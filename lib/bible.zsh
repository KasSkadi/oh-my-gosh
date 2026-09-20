# ─────────────────────────────────────────────
#  bible.zsh — 圣经版本管理（多语言）
#
#  仓库不含经文原文，数据由用户自己生成，放在
#    $GOSH_HOME/lib/bible/verses-<id>.txt    正文（TAB 分隔：出处、#tags、经文）
#    $GOSH_HOME/lib/bible/verses-<id>.meta   元数据（name/lang/count/source）
#  也兼容手写的 verses-<id>.zsh（typeset -ga GOSH_VERSES=( "正文|出处|#tags" )）
#  生成数据：tools/fetch-verses.sh（见 NOTICE.md）
# ─────────────────────────────────────────────

typeset -ga GOSH_VERSES=()
typeset -g  GOSH_BIBLE_NAME=""
typeset -g  GOSH_BIBLE_LANG=""
typeset -g  GOSH_BIBLE_SOURCE=""
typeset -gi GOSH_BIBLE_COUNT=0

# 数据格式： "" 未装 | "txt" 惰性加载 | "zsh" 已载入内存
typeset -g  _GOSH_DATA_FORMAT=""
typeset -g  _GOSH_DATA_FILE=""
typeset -gi _GOSH_DATA_LOADED=0
typeset -gi _GOSH_TAG_INDEXED=0
typeset -gi _GOSH_NO_DATA_WARNED=0

_gosh_bible_dir() { print -r -- "${GOSH_HOME:-$HOME/.gosh}/lib/bible" }

# 已安装的版本 id（有 .txt 或 .zsh 数据文件即算）
_gosh_bible_ids() {
  emulate -L zsh
  local -A ids=()
  local f id
  for f in "$(_gosh_bible_dir)"/verses-*.txt(N) "$(_gosh_bible_dir)"/verses-*.zsh(N); do
    id=${${f:t}#verses-}
    id=${id%.*}
    ids[$id]=1
  done
  print -l -- ${(ok)ids}
}

_gosh_bible_available() {
  emulate -L zsh
  local -a ids=($(_gosh_bible_ids))
  (( ${#ids[@]} > 0 ))
}

# 读取 .meta 边车文件里的某个字段
_gosh_bible_meta_field() {
  emulate -L zsh
  local id=$1 field=$2
  local file="$(_gosh_bible_dir)/verses-$id.meta"
  [[ -r $file ]] || return 1
  local line
  while IFS= read -r line; do
    [[ $line == "$field="* ]] && { print -r -- ${line#*=}; return 0 }
  done < "$file"
  return 1
}

# 版本显示名 / 语言：优先 meta，其次按 id 推断
_gosh_bible_name() {
  emulate -L zsh
  local id=${1:-$GOSH_BIBLE_VERSION}
  local n
  n=$(_gosh_bible_meta_field "$id" name) && [[ -n $n ]] && { print -r -- $n; return 0 }
  print -r -- "$id"
}

_gosh_bible_lang_of() {
  emulate -L zsh
  local id=${1:-$GOSH_BIBLE_VERSION}
  local l
  l=$(_gosh_bible_meta_field "$id" lang)
  [[ -n $l ]] && { print -r -- $l; return 0 }
  case ${id%%-*} in
    en) print -r -- en ;;
    *)  print -r -- zh ;;
  esac
}

# 数据文件路径（.txt 优先，其次 .zsh）
_gosh_bible_data_file() {
  emulate -L zsh
  local id=$1 dir=$(_gosh_bible_dir)
  if [[ -r "$dir/verses-$id.txt" ]]; then
    print -r -- "$dir/verses-$id.txt"
  elif [[ -r "$dir/verses-$id.zsh" ]]; then
    print -r -- "$dir/verses-$id.zsh"
  else
    return 1
  fi
}

# 惰性加载：把 txt 读进内存（每个 shell 只做一次，且在第一次用经文时才做）
_gosh_bible_ensure_loaded() {
  emulate -L zsh
  [[ $_GOSH_DATA_FORMAT == txt ]] || return 0
  (( _GOSH_DATA_LOADED )) && return 0

  local data=""
  zmodload zsh/mapfile 2>/dev/null
  if (( ${+mapfile} )) && [[ -r $_GOSH_DATA_FILE ]]; then
    data=${mapfile[$_GOSH_DATA_FILE]}
  else
    data=$(<"$_GOSH_DATA_FILE")
  fi

  # 去掉结尾换行（否则 (f) 会多切出一个空元素）与 CRLF 的 \r
  data=${data%$'\n'}
  [[ $data == *$'\r'* ]] && data=${data//$'\r'/}

  GOSH_VERSES=("${(f)data}")
  _GOSH_DATA_LOADED=1
  _GOSH_TAG_INDEXED=0
  GOSH_BIBLE_COUNT=${#GOSH_VERSES[@]}
  return 0
}

# 载入某个版本；没有数据时给出获取提示
_gosh_load_bible() {
  emulate -L zsh
  local id=${1:-$GOSH_BIBLE_VERSION}
  local file=""

  file=$(_gosh_bible_data_file "$id") || file=""

  if [[ -z $file ]]; then
    if [[ $id != zh-Hans ]]; then
      local bad=$id
      id=zh-Hans
      file=$(_gosh_bible_data_file "$id") || file=""
      [[ -z $file ]] && _gosh_t unknown_version "$bad" >&2
    fi
  fi

  if [[ -z $file ]]; then
    GOSH_VERSES=()
    GOSH_BIBLE_NAME=""
    GOSH_BIBLE_LANG=""
    GOSH_BIBLE_COUNT=0
    _GOSH_DATA_FORMAT=""
    _GOSH_DATA_FILE=""
    _GOSH_DATA_LOADED=0
    _GOSH_TAG_INDEXED=0
    GOSH_BIBLE_VERSION=$id
    _gosh_sync_lang
    _gosh_bible_hint
    return 1
  fi

  GOSH_VERSES=()
  _GOSH_DATA_LOADED=0
  _GOSH_TAG_INDEXED=0

  case $file in
    *.zsh)
      _GOSH_DATA_FORMAT=zsh
      _GOSH_DATA_FILE=$file
      source "$file"
      _GOSH_DATA_LOADED=1
      GOSH_BIBLE_COUNT=${#GOSH_VERSES[@]}
      ;;
    *)
      _GOSH_DATA_FORMAT=txt
      _GOSH_DATA_FILE=$file
      GOSH_BIBLE_COUNT=$(_gosh_bible_meta_field "$id" count)
      [[ $GOSH_BIBLE_COUNT == <-> ]] || GOSH_BIBLE_COUNT=0
      ;;
  esac

  GOSH_BIBLE_VERSION=$id
  GOSH_BIBLE_NAME=$(_gosh_bible_name "$id")
  GOSH_BIBLE_LANG=$(_gosh_bible_lang_of "$id")
  GOSH_BIBLE_SOURCE=$(_gosh_bible_meta_field "$id" source)
  _gosh_sync_lang
  return 0
}

# 没数据时的提示：自动触发时每个 shell 只说一次，用户显式命令则总是说
_gosh_bible_hint() {
  emulate -L zsh
  local force=${1:-0}
  if (( ! force )); then
    (( _GOSH_NO_DATA_WARNED )) && return 0
    _GOSH_NO_DATA_WARNED=1
  fi
  _gosh_t no_data >&2
  return 1
}
