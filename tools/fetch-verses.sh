#!/usr/bin/env bash
# ═════════════════════════════════════════════
#  fetch-verses.sh — 生成 oh-my-gosh 的经文数据
#
#  仓库里不含任何圣经原文：数据由你自己获取或提供。
#
#    tools/fetch-verses.sh list                 看可用来源 / 已装数据
#    tools/fetch-verses.sh cuv                  新标点和合本（简体）· 公有领域
#    tools/fetch-verses.sh cuvt                 新標點和合本（繁體）· 公有領域
#    tools/fetch-verses.sh kjv                  King James Version · 公有领域
#    tools/fetch-verses.sh web                  World English Bible · 公有领域
#    tools/fetch-verses.sh from-file 我的经文.txt --id my-ver --lang zh --name "我的译本"
#    tools/fetch-verses.sh clean --yes          删除本工具生成的数据
#
#  结果写入 $GOSH_HOME/lib/bible/（verses-<id>.txt + verses-<id>.meta，已被 .gitignore 忽略）
#  版权、出处与免责说明见仓库根目录 NOTICE.md
# ═════════════════════════════════════════════
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GOSH_HOME="${GOSH_HOME:-$(cd "$HERE/.." && pwd)}"
OUT_DIR="${GOSH_HOME}/lib/bible"
BOOKS="${HERE}/books.tsv"
TAGS="${HERE}/curated-tags.txt"
EBIBLE="https://ebible.org/Scriptures"

VER_ID=""; VER_LANG=""; VER_NAME=""; VER_NOTE=""
NO_TAGS=0; YES=0; FMT="vpl"; FILE=""; ACTION=""

usage() {
  sed -n '3,20p' "${BASH_SOURCE[0]}" | sed 's/^#\{1,\} \{0,1\}//'
  cat <<'EOF'

选项：
  --out DIR      输出目录（默认 $GOSH_HOME/lib/bible）
  --id ID        版本 id（默认按来源：zh-Hans / zh-Hant / en-KJV / en-WEB）
  --lang LANG    书卷名语言：zh-Hans / zh-Hant / en（默认按来源）
  --name NAME    显示名（默认按来源）
  --format FMT   from-file 的格式：vpl（"GEN 1:1 经文"）或 tsv（"出处<TAB>经文"）
  --no-tags      不套用精选标签，只保留书卷标签
  --yes          clean 时确认删除
EOF
}

die() { echo "❌ $*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# ── 来源表（全部为公有领域文本）──
source_meta() {
  case "$1" in
    cuv)  SRC_ZIP="cmn-cu89s_vpl.zip"; VER_ID="zh-Hans"; VER_LANG="3"; VER_NAME="新标点和合本（简体）"; VER_NOTE="eBible.org (cmn-cu89s) · Public Domain" ;;
    cuvt) SRC_ZIP="cmn-cu89t_vpl.zip"; VER_ID="zh-Hant"; VER_LANG="4"; VER_NAME="新標點和合本（繁體）"; VER_NOTE="eBible.org (cmn-cu89t) · Public Domain" ;;
    kjv)  SRC_ZIP="eng-kjv_vpl.zip";   VER_ID="en-KJV";  VER_LANG="2"; VER_NAME="King James Version (1611)"; VER_NOTE="eBible.org (eng-kjv) · Public Domain（英国为永久 Crown copyright，见 NOTICE.md）" ;;
    web)  SRC_ZIP="eng-web_vpl.zip";   VER_ID="en-WEB";  VER_LANG="2"; VER_NAME="World English Bible"; VER_NOTE="eBible.org (eng-web) · Public Domain（“World English Bible”是 eBible.org 的商标）" ;;
    *) return 1 ;;
  esac
}

lang_to_col() {
  case "$1" in
    3|zh-Hans|zh|hans) print_col=3 ;;
    4|zh-Hant|hant)    print_col=4 ;;
    2|en|english)      print_col=2 ;;
    *) die "--lang 只能是 zh-Hans / zh-Hant / en" ;;
  esac
}

download() {
  local url=$1 dest=$2
  if have curl; then curl -fsSL --retry 3 -o "$dest" "$url"
  elif have wget; then wget -q -O "$dest" "$url"
  else die "下载需要 curl 或 wget"; fi
}

extract_zip() {
  local zip=$1 dir=$2
  if have unzip; then unzip -q -o "$zip" -d "$dir"
  elif have python3; then python3 -c 'import sys,zipfile; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])' "$zip" "$dir"
  else die "解压需要 unzip 或 python3；也可以自己解压后用 from-file 导入"; fi
}

# ── 核心转换 ──
# $1 输入  $2 输出(txt)  $3 书卷名列(2/3/4)  $4 输入格式  $5 显示名  $6 来源说明
# 输出每行： 出处 <TAB> #tags <TAB> 经文
convert() {
  local in=$1 out=$2 col=$3 fmt=$4 name=$5 note=$6
  local use_tags=1
  [[ $NO_TAGS == 1 ]] && use_tags=0

  : > "$out"

  local stats
  stats=$(awk -v col="$col" -v fmt="$fmt" -v books="$BOOKS" -v tags="$TAGS" \
              -v use_tags="$use_tags" -v out="$out" '
    BEGIN {
      FS = "|"
      while ((getline line < books) > 0) {
        if (line == "" || substr(line, 1, 1) == "#") continue
        n = split(line, f, "|")
        code = f[1]
        book_name[code] = f[col]
        book_tag[code] = f[5]
        for (i = 2; i <= 4; i++) name_to_code[f[i]] = code
        if (n >= 6) {                     # 历史 USFM 代码别名（JOH → JHN 等）
          nal = split(f[6], al, ",")
          for (i = 1; i <= nal; i++) if (al[i] != "") code_alias[al[i]] = code
        }
      }
      close(books)
      if (use_tags) {
        while ((getline line < tags) > 0) {
          if (line == "" || substr(line, 1, 1) == "#") continue
          split(line, f, "|")
          curated[f[1]] = f[2]
          ncurated++
        }
        close(tags)
      }
    }

    function clean(t,   s) {
      s = t
      gsub(/\r/, "", s)
      gsub(/[\[\]{}]/, "", s)      # KJV 的补充字标记等
      gsub(/¶/, "", s)             # 段落记号
      gsub(/\t/, " ", s)           # 制表符是字段分隔符
      sub(/^[ ]+/, "", s); sub(/[ ]+$/, "", s)
      gsub(/[ ]{2,}/, " ", s)
      return s
    }

    function emit(code, chap, verse, text,   key, list, n, i, ntag, tt, tag) {
      text = clean(text)
      if (text == "") { skipped++; return }
      key = code " " chap ":" verse
      split("", seen)          # 每节都要清空，否则重复出现的标签会被当成本节已用
      n = 0; list = ""
      if (book_tag[code] != "") { tag = "#" book_tag[code]; seen[tag] = 1; list = tag; n = 1 }
      if (use_tags && curated[key] != "") {
        ntag = split(curated[key], tt, " ")
        for (i = 1; i <= ntag; i++) {
          if (tt[i] == "" || (tt[i] in seen)) continue
          seen[tt[i]] = 1
          list = list (n ? " " : "") tt[i]
          n++
        }
        matched[key] = 1
      }
      printf "%s %s:%s\t%s\t%s\n", book_name[code], chap, verse, (n > 0 ? list : ""), text >> out
      count++
    }

    function handle(code, cv, text,   a, r, v1, v2, v) {
      if (!(code in book_name) && (code in code_alias)) code = code_alias[code]
      if (!(code in book_name)) { unknown++; return }
      split(cv, a, ":")
      if (a[2] ~ /-/) {
        split(a[2], r, "-")
        v1 = r[1] + 0; v2 = r[2] + 0
        for (v = v1; v <= v2; v++) emit(code, a[1] + 0, v, text)
      } else {
        emit(code, a[1] + 0, a[2] + 0, text)
      }
    }

    fmt == "vpl" {
      line = $0
      i = index(line, " "); if (i == 0) next
      code = substr(line, 1, i - 1)
      rest = substr(line, i + 1)
      j = index(rest, " "); if (j == 0) next
      handle(code, substr(rest, 1, j - 1), substr(rest, j + 1))
      next
    }

    fmt == "tsv" {
      nf = split($0, f2, "\t")
      if (nf >= 3)      { ref = f2[1] " " f2[2]; text = f2[3] }   # 书卷 <TAB> 章:节 <TAB> 经文
      else if (nf == 2) { ref = f2[1];           text = f2[2] }   # 出处 <TAB> 经文
      else next
      k = index(ref, " ")
      head = k ? substr(ref, 1, k - 1) : ref
      cv = k ? substr(ref, k + 1) : ""
      if (head in book_name) code = head
      else if (head in name_to_code) code = name_to_code[head]
      else {
        code = ""
        for (c in book_name) {
          if (index(ref, book_name[c] " ") == 1) { code = c; cv = substr(ref, length(book_name[c]) + 2); break }
        }
      }
      if (code != "") handle(code, cv, text)
      next
    }

    END {
      close(out)
      for (k in matched) nmatched++
      printf "%d %d %d %d\n", count + 0, nmatched + 0, ncurated + 0, unknown + 0
    }
  ' "$in")

  COUNT=${stats%% *}; stats=${stats#* }
  MATCHED=${stats%% *}; stats=${stats#* }
  CURATED=${stats%% *}; UNKNOWN=${stats##* }
  return 0
}

# 写 meta 边车文件（版本名 / 语言 / 来源 / 节数），让 zsh 侧不用加载全文就知道基本信息
write_meta() {
  local lang=$1
  {
    printf 'name=%s\n'   "$VER_NAME"
    printf 'lang=%s\n'   "$lang"
    printf 'id=%s\n'     "$VER_ID"
    printf 'count=%s\n'  "$COUNT"
    printf 'source=%s\n' "$VER_NOTE"
    printf 'date=%s\n'   "$(date '+%Y-%m-%d')"
  } > "$OUT_DIR/verses-$VER_ID.meta"
}

report() {
  local out=$1
  local tagcount
  tagcount=$(grep -o '#[a-z-]*' "$out" | sort -u | wc -l | tr -d ' ')
  echo ""
  echo "✅ 已生成 $out"
  echo "   id       : $VER_ID（$VER_NAME）"
  echo "   经文     : $COUNT 节（$OUT_DIR/verses-$VER_ID.txt）"
  echo "   元数据   : $OUT_DIR/verses-$VER_ID.meta"
  echo "   标签     : $tagcount 个"
  echo "   精选标签 : 命中 $MATCHED / $CURATED 条引用"
  if [[ ${UNKNOWN:-0} != 0 ]]; then
    echo "   跳过     : $UNKNOWN 行（不在 66 卷正典内）"
  fi
  echo ""
  echo "   在 zsh 里执行：  gosh version $VER_ID"
}

installed() {
  local meta="$OUT_DIR/verses-$1.meta"
  if [[ -r $meta ]]; then
    printf '● 已安装（%s 节）' "$(sed -n 's/^count=//p' "$meta")"
  elif [[ -r "$OUT_DIR/verses-$1.txt" || -r "$OUT_DIR/verses-$1.zsh" ]]; then
    printf '● 已安装'
  else
    printf '○ 未安装'
  fi
}

cmd_list() {
  echo "可用来源（均为公有领域文本，从 eBible.org 下载）："
  echo ""
  printf '  %-6s %-9s %-28s %s\n' "cuv"  "zh-Hans" "新标点和合本（简体）"     "$(installed zh-Hans)"
  printf '  %-6s %-9s %-28s %s\n' "cuvt" "zh-Hant" "新標點和合本（繁體）"     "$(installed zh-Hant)"
  printf '  %-6s %-9s %-28s %s\n' "kjv"  "en-KJV"  "King James Version (1611)" "$(installed en-KJV)"
  printf '  %-6s %-9s %-28s %s\n' "web"  "en-WEB"  "World English Bible"       "$(installed en-WEB)"
  echo ""
  echo "  用法：tools/fetch-verses.sh <来源>"
  echo "        tools/fetch-verses.sh from-file <文件> --id <id> --lang zh|en [--format vpl|tsv]"
  echo ""
  echo "  输出目录：$OUT_DIR"
  echo "  仓库不含经文原文；使用时请遵守当地法律与各译本的授权条款（见 NOTICE.md）。"
}

cmd_clean() {
  local f found=0
  shopt -s nullglob
  for f in "$OUT_DIR"/verses-*.txt "$OUT_DIR"/verses-*.meta "$OUT_DIR"/verses-*.zsh; do
    found=1
    if [[ $YES == 1 ]]; then
      rm -f "$f"
      echo "已删除 $f"
    else
      echo "将删除 $f（加 --yes 才会真的删）"
    fi
  done
  shopt -u nullglob
  [[ $found == 0 ]] && echo "没有找到已生成的经文数据（$OUT_DIR）"
  return 0
}

# ── 参数解析 ──
[[ $# -gt 0 ]] || { usage; exit 1; }
CMD=$1; shift

case $CMD in
  -h|--help|help) usage; exit 0 ;;
  list)           cmd_list; exit 0 ;;
  clean)          ACTION=clean ;;
  from-file)
    ACTION=convert
    [[ $# -gt 0 ]] || die "from-file 需要文件名"
    FILE=$1; shift ;;
  cuv|cuvt|kjv|web)
    ACTION=fetch
    SRC=$CMD
    source_meta "$SRC" || die "未知来源：$SRC" ;;
  *) die "未知来源：$CMD（试试 list）" ;;
esac

while [[ $# -gt 0 ]]; do
  case $1 in
    --out)     OUT_DIR=$2; shift 2 ;;
    --id)      VER_ID=$2; shift 2 ;;
    --lang)    VER_LANG=$2; shift 2 ;;
    --name)    VER_NAME=$2; shift 2 ;;
    --format)  FMT=$2; shift 2 ;;
    --no-tags) NO_TAGS=1; shift ;;
    --yes)     YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "未知参数：$1" ;;
  esac
done

case $FMT in
  vpl|tsv) ;;
  *) die "--format 只能是 vpl 或 tsv" ;;
esac
mkdir -p "$OUT_DIR"

if [[ $ACTION == clean ]]; then
  cmd_clean
  exit 0
fi

case $VER_LANG in
  2|3|4) print_col=$VER_LANG ;;
  *)     lang_to_col "${VER_LANG:-3}" ;;
esac

TMPDIR_RUN="$(mktemp -d "${TMPDIR:-/tmp}/oh-my-gosh-verses.XXXXXX")"
trap 'rm -rf "$TMPDIR_RUN"' EXIT

if [[ $ACTION == fetch ]]; then
  [[ -n $VER_ID ]] || die "内部错误：缺少版本 id"
  echo "⬇️  下载 ${VER_NAME}（$SRC_ZIP）..."
  download "$EBIBLE/$SRC_ZIP" "$TMPDIR_RUN/$SRC_ZIP"
  echo "📦 解压..."
  extract_zip "$TMPDIR_RUN/$SRC_ZIP" "$TMPDIR_RUN/x"
  INPUT=$(ls "$TMPDIR_RUN"/x/*_vpl.txt 2>/dev/null | head -1 || true)
  [[ -n $INPUT && -r $INPUT ]] || die "压缩包里没找到 *_vpl.txt"
  FMT="vpl"
else
  [[ -r $FILE ]] || die "读不到文件：$FILE"
  INPUT=$FILE
  [[ -n $VER_ID ]]   || die "from-file 需要 --id（版本 id，例如 my-ver）"
  [[ -n $VER_NAME ]] || VER_NAME="自定义版本（$VER_ID）"
  [[ -n $VER_NOTE ]] || VER_NOTE="用户自行提供（$FILE）"
fi

OUT_FILE="$OUT_DIR/verses-$VER_ID.txt"
echo "✍️  生成 $OUT_FILE ..."
convert "$INPUT" "$OUT_FILE" "$print_col" "$FMT" "$VER_NAME" "$VER_NOTE"

case $VER_ID in
  zh-*) META_LANG=zh ;;
  en-*) META_LANG=en ;;
  *)    META_LANG=${VER_LANG:-zh} ;;
esac
write_meta "$META_LANG"
report "$OUT_FILE"
