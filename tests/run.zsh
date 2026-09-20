#!/usr/bin/env zsh
# ─────────────────────────────────────────────
#  tests/run.zsh — oh-my-gosh 自测
#
#  运行：zsh tests/run.zsh
#
#  仓库不含经文原文，所以测试会先在临时目录里搭一个 GOSH_HOME，
#  用 tools/fetch-verses.sh 导入一份「假经文」fixture（正文是占位文字，
#  只有出处、标签、书卷是真的），再验证全部功能。
#
#  如果 zsh 的模块目录不在编译时的位置（比如手动解包），
#  用 GOSH_TEST_MODULE_PATH=/path/to/zsh/modules 指路。
# ─────────────────────────────────────────────
emulate -L zsh

[[ -n ${GOSH_TEST_MODULE_PATH:-} ]] && module_path=($GOSH_TEST_MODULE_PATH $module_path)

REPO=${0:A:h:h}
ZSH_BIN=${GOSH_TEST_ZSH:-${commands[zsh]:-zsh}}
TEST_HOME=$(mktemp -d "${TMPDIR:-/tmp}/oh-my-gosh-test.XXXXXX")
typeset -g GOSH_HOME=$TEST_HOME
export GOSH_HOME

typeset -gi GOSH_TEST_PASS=0 GOSH_TEST_FAIL=0

_ok() { GOSH_TEST_PASS=$(( GOSH_TEST_PASS + 1 )); print -r -- "  ✅ $1" }
_no() {
  GOSH_TEST_FAIL=$(( GOSH_TEST_FAIL + 1 ))
  print -r -- "  ❌ $1"
  [[ -n ${2:-} ]] && print -r -- "     ↳ $2"
}
_is() { if [[ $2 == $3 ]]; then _ok "$1"; else _no "$1" "expected [$2], got [$3]"; fi }
_has() { if [[ $3 == *"$2"* ]]; then _ok "$1"; else _no "$1" "[$2] not found in: $3"; fi }
_not_has() { if [[ $3 != *"$2"* ]]; then _ok "$1"; else _no "$1" "[$2] unexpectedly present"; fi }
_status_is() {
  local desc=$1 want=$2; shift 2
  "$@" >/dev/null 2>&1
  local got=$?
  if [[ $got == $want ]]; then _ok "$desc"; else _no "$desc" "exit $got, want $want"; fi
}
_section() { print -r -- ""; print -r -- "── $1 ──" }
_zsh() { "$ZSH_BIN" -f -c "module_path=(${(j: :)module_path}); export GOSH_HOME=$TEST_HOME; source $TEST_HOME/lib/oh-my-gosh.zsh; $1" 2>&1 }

# ── 搭测试环境：复制 lib/themes/tools，并生成 fixture 数据 ──
cp -R "$REPO/lib" "$REPO/themes" "$REPO/tools" "$TEST_HOME/" 2>/dev/null
mkdir -p "$TEST_HOME/lib/bible"

cat > "$TEST_HOME/fixture-zh.vpl" <<'EOF'
GEN 1:1 测试占位经文甲
GEN 1:3 测试占位经文乙
PSA 23:1 测试占位经文丙
PSA 23:4 测试占位经文丁
PSA 34:18 测试占位经文戊
PSA 46:1 测试占位经文己
PSA 121:1 测试占位经文庚
JHN 3:16 测试占位经文辛
MAT 11:28 测试占位经文壬
2CO 12:9 测试占位经文癸
REV 22:12 测试占位经文子
EOF
cat > "$TEST_HOME/fixture-en.vpl" <<'EOF'
GEN 1:1 FIXTURE TEXT ONE
PSA 23:1 FIXTURE TEXT TWO
PSA 23:4 FIXTURE TEXT THREE
PSA 34:18 FIXTURE TEXT FOUR
JHN 3:16 FIXTURE TEXT FIVE
MAT 11:28 FIXTURE TEXT SIX
EOF

tool() { GOSH_HOME=$TEST_HOME command bash "$TEST_HOME/tools/fetch-verses.sh" "$@"; }

# ═══════════════ 1. 无数据时的行为 ═══════════════
_section "没有数据时 / Without data"

local out
out=$(_zsh 'gosh --version')
_has "没有经文数据也能载入" "oh-my-gosh" "$out"

out=$(_zsh 'gosh status')
_has "gosh status 提示未安装" "未安装" "$out"

out=$(_zsh 'gosh bless 2>&1')
_has "gosh bless 提示去获取数据" "gosh setup" "$out"

out=$(_zsh 'gosh versions')
_has "gosh versions 列出获取方式" "gosh setup" "$out"

out=$(_zsh 'true')
_has "没有数据时启动会提示一次 gosh setup" "gosh setup" "$out"

out=$(_zsh '_GOSH_READY=1; true; _gosh_precmd')
local -a hint_lines=("${(f)out}")
_is "没有数据时只提示一次，不随命令刷屏" 1 ${#hint_lines[@]}

# ═══════════════ 2. 导入数据 ═══════════════
_section "导入经文数据 / Import"

out=$(tool from-file "$TEST_HOME/fixture-zh.vpl" --id zh-Hans --lang zh-Hans --name "测试译本（简）" 2>&1)
_has "工具能生成简体数据" "已生成" "$out"
_has "工具报告命中精选标签" "精选标签" "$out"

out=$(tool from-file "$TEST_HOME/fixture-en.vpl" --id en-KJV --lang en --name "Test Version (EN)" 2>&1)
_has "工具能生成英文数据" "已生成" "$out"

[[ -r "$TEST_HOME/lib/bible/verses-zh-Hans.txt" ]] && _ok "生成 .txt 数据文件" || _no "生成 .txt 数据文件"
[[ -r "$TEST_HOME/lib/bible/verses-zh-Hans.meta" ]] && _ok "生成 .meta 元数据" || _no "生成 .meta 元数据"

out=$(tool list)
_has "工具 list 显示已安装" "已安装" "$out"

# 精选标签必须逐节完整套用（曾经因为 awk 里 seen 没清空而丢标签）
local jline
jline=$(grep $'^约翰福音 3:16\t' "$TEST_HOME/lib/bible/verses-zh-Hans.txt")
_has "精选标签逐节套用（#love）" "#love" "$jline"
_has "精选标签逐节套用（#faith）" "#faith" "$jline"

# 手写的 .zsh 格式也要能用
cat > "$TEST_HOME/lib/bible/verses-hand.zsh" <<'EOF'
typeset -ga GOSH_VERSES=(
  "手写占位甲|诗篇 23:1|#psalm #provision"
  "手写占位乙|诗篇 23:4|#psalm #comfort"
  "手写占位丙|约翰福音 3:16"
)
EOF

# ═══════════════ 3. 载入与数据完整性 ═══════════════
_section "载入与数据 / Loading"

source "$TEST_HOME/lib/oh-my-gosh.zsh"
_gosh_has_function _gosh_precmd && _ok "_gosh_precmd 已定义" || _no "_gosh_precmd 已定义"
_gosh_has_function gosh         && _ok "gosh 函数已定义"     || _no "gosh 函数已定义"
_gosh_has_function _gosh_pray   && _ok "祈祷模式已定义"       || _no "祈祷模式已定义"

local -a ids=($(_gosh_bible_ids))
_is "识别到三个版本" 3 ${#ids[@]}

_gosh_load_bible zh-Hans >/dev/null
_is "版本名来自 meta" "测试译本（简）" "$GOSH_BIBLE_NAME"
_is "版本语言来自 meta" "zh" "$GOSH_BIBLE_LANG"
_is "节数来自 meta（无需读全文）" 11 "$GOSH_BIBLE_COUNT"
_is "txt 数据是惰性加载" 0 ${#GOSH_VERSES[@]}

_gosh_bible_ensure_loaded
_is "第一次使用时才读进内存" 11 ${#GOSH_VERSES[@]}

local bad=0 notag=0 entry field
for entry in "${GOSH_VERSES[@]}"; do
  field=${${entry#*$'\t'}%%$'\t'*}
  [[ $entry == *$'\t'* && -n ${entry##*$'\t'} ]] || (( bad++ ))
  [[ -n $field ]] || (( notag++ ))
done
_is "每行都是 出处<TAB>标签<TAB>正文" 0 $bad
_is "每条都带 #tag" 0 $notag

_gosh_tag_reindex
(( ${_GOSH_TAG_COUNT[psalm]:-0} > 0 ))   && _ok "有 #psalm 标签"   || _no "有 #psalm 标签"
(( ${_GOSH_TAG_COUNT[comfort]:-0} > 0 )) && _ok "有 #comfort 标签" || _no "有 #comfort 标签"

local -a unregistered=() t
for t in ${(k)_GOSH_TAG_COUNT}; do
  (( ${GOSH_TAG_CANON[(Ie)$t]} )) || unregistered+=("$t")
done
_is "所有标签都在规范表里" 0 ${#unregistered[@]}

# 仓库里不能有经文原文
if command -v git >/dev/null 2>&1 && [[ -d $REPO/.git ]]; then
  local tracked grepout
  (cd "$REPO" && git check-ignore -q lib/bible/verses-zh-Hans.txt) \
    && _ok ".gitignore 挡住了经文数据" || _no ".gitignore 挡住了经文数据"
  tracked=$(cd "$REPO" && git ls-files 'lib/bible/*' 2>/dev/null | grep 'verses-' || true)
  _is "仓库没有跟踪任何经文数据" "" "$tracked"
fi

# 随仓库分发的标签表只能有「引用 + 标签」，不能有经文正文
local badlines
badlines=$(grep -cvE '^#|^$|^[1-3]?[A-Z]{2,3} [0-9]+:[0-9]+\|#' "$REPO/tools/curated-tags.txt" || true)
_is "精选标签表只有引用与标签" 0 "$badlines"

# ═══════════════ 4. 抽取与标签 ═══════════════
_section "抽取 / Selection"

local -i hits=0 i
for i in {1..20}; do
  _gosh_pick_entry psalm && _gosh_entry_has_tag "$REPLY" psalm && (( hits++ ))
done
_is "gosh bless psalm 只抽诗篇" 20 $hits

_is "别名 诗篇 → psalm"    psalm   "$(_gosh_resolve_tag 诗篇)"
_is "别名 Psalms → psalm"  psalm   "$(_gosh_resolve_tag Psalms)"
_is "别名 #安慰 → comfort" comfort "$(_gosh_resolve_tag '#安慰')"
_is "未知标签原样返回"     nosuch  "$(_gosh_resolve_tag nosuch)"

out=$(gosh bless psalm -n 3 2>&1)
local -i psalm_lines=0
local l
for l in ${(f)out}; do
  [[ $l == *(诗篇|詩篇|Psalms)* ]] && (( psalm_lines++ ))
done
_is "gosh bless psalm -n 3 输出三节" 3 $psalm_lines

_status_is "未知标签返回错误" 1 gosh bless nosuchtag
out=$(gosh bless nosuchtag 2>&1)
_has "未知标签给出提示" "未知标签" "$out"

out=$(gosh tags 2>&1)
_has "gosh tags 列出标签" "#psalm" "$out"

gosh tag psalm >/dev/null 2>&1
_is "gosh tag psalm 设置过滤器" psalm "$GOSH_VERSE_TAG"
gosh tag all >/dev/null 2>&1
_is "gosh tag all 清除过滤器" "" "$GOSH_VERSE_TAG"

# ═══════════════ 5. 频率 / 概率 / 失败彩蛋 ═══════════════
_section "触发节奏与失败彩蛋 / Cadence & comfort"

GOSH_ENABLE_VERSE=1; GOSH_VERSE_TAG=""; GOSH_VERSE_PROBABILITY=100; GOSH_VERSE_FREQUENCY=2
_GOSH_READY=1; _GOSH_SKIP_NEXT=0

_GOSH_CMD_COUNT=0; true; out=$(_gosh_precmd 2>&1)
_is "频率 2：第 1 条命令不出经文" "" "$out"
_GOSH_CMD_COUNT=1; true; out=$(_gosh_precmd 2>&1)
(( ${#out} > 0 )) && _ok "频率 2：第 2 条命令出经文" || _no "频率 2：第 2 条命令出经文"

GOSH_VERSE_PROBABILITY=0; GOSH_VERSE_FREQUENCY=1
_GOSH_CMD_COUNT=0; true; out=$(_gosh_precmd 2>&1)
_is "概率 0：不出经文" "" "$out"

GOSH_VERSE_FREQUENCY=0; GOSH_VERSE_PROBABILITY=100
_GOSH_CMD_COUNT=0; true; out=$(_gosh_precmd 2>&1)
_is "频率 0：不自动输出" "" "$out"

local -a comfort_texts=()
for entry in "${GOSH_VERSES[@]}"; do
  _gosh_entry_has_tag "$entry" comfort && comfort_texts+=("${entry##*$'\t'}")
done

GOSH_COMFORT_ON_ERROR=1; GOSH_VERSE_FREQUENCY=0; _GOSH_SKIP_NEXT=0
false; out=$(_gosh_precmd 2>&1)
local hit=0
for l in "${comfort_texts[@]}"; do
  [[ $out == *"$l"* ]] && hit=1
done
_is "命令失败必出一节安慰经文" 1 $hit

GOSH_ENABLE_VERSE=0; false; out=$(_gosh_precmd 2>&1)
_is "总开关关闭时失败也不输出" "" "$out"
GOSH_ENABLE_VERSE=1

GOSH_COMFORT_ON_ERROR=0; false; out=$(_gosh_precmd 2>&1)
_is "comfort off 后失败不输出" "" "$out"
GOSH_COMFORT_ON_ERROR=1

_GOSH_SKIP_NEXT=1; false; out=$(_gosh_precmd 2>&1)
_is "gosh 自身触发时跳过下一节" "" "$out"

# fixture 里诗篇只有 5 节，所以把历史窗口调小（窗口 ≥ 池子大小时本来就无法避免重复）
_GOSH_HISTORY=(); GOSH_VERSE_NO_REPEAT=2
local -a picks=()
for i in {1..30}; do
  _gosh_pick_entry psalm
  picks+=("$REPLY")
  _gosh_history_push "$REPLY"
done
local -i repeats=0
for i in {2..30}; do
  [[ ${picks[$i]} == ${picks[$((i-1))]} ]] && (( repeats++ ))
done
_is "不会连续抽到同一节" 0 $repeats
_is "历史裁剪到 GOSH_VERSE_NO_REPEAT" 2 ${#_GOSH_HISTORY[@]}
GOSH_VERSE_NO_REPEAT=5
_GOSH_HISTORY=()
_gosh_history_push "d"; _gosh_history_push "e"; _gosh_history_push "f"; _gosh_history_push "g"
_gosh_history_push "a b c"                     # 含空格的条目
_is "含空格的条目没被拆开" 5 ${#_GOSH_HISTORY[@]}
_is "含空格条目的内容完整" "a b c" "${_GOSH_HISTORY[-1]}"
_gosh_history_push "h"                         # 触发裁剪
_is "历史裁剪到 5" 5 ${#_GOSH_HISTORY[@]}
_is "裁剪后顺序正确" "h" "${_GOSH_HISTORY[-1]}"
_GOSH_HISTORY=(); GOSH_VERSE_NO_REPEAT=8

# ═══════════════ 6. 主题 ═══════════════
_section "主题 / Themes"

local theme
for theme in $(_gosh_theme_ids); do
  _status_is "主题 $theme 可载入" 0 _gosh_theme_load "$theme"
done

gosh theme revelation >/dev/null 2>&1
_is "GOSH_THEME=revelation" revelation "$GOSH_THEME"
out=$(_gosh_render_verse "测试" "Test 1:1" "")
_has "启示录主题带边框" "╭" "$out"

gosh theme heaven >/dev/null 2>&1
out=$(_gosh_render_verse "测试" "Test 1:1" "")
_has "天堂主题带云朵" "☁" "$out"

gosh theme minimal >/dev/null 2>&1
out=$(_gosh_render_verse "测试" "Test 1:1" "")
_not_has "极简主题没有边框" "╭" "$out"

gosh theme none >/dev/null 2>&1
_is "GOSH_THEME=none" none "$GOSH_THEME"
out=$(_gosh_render_verse "测试" "Test 1:1" "")
_has "none 主题仍能输出经文" "测试" "$out"

_status_is "未知主题返回错误" 1 gosh theme bogus

out=$("$ZSH_BIN" -f -c "module_path=(${(j: :)module_path}); export GOSH_HOME=$TEST_HOME GOSH_THEME=revelation; source $TEST_HOME/lib/oh-my-gosh.zsh; print -r -- \$GOSH_THEME" 2>&1)
_is "GOSH_THEME 环境变量生效" revelation "$out"

out=$("$ZSH_BIN" -f -c "module_path=(${(j: :)module_path}); export GOSH_HOME=$TEST_HOME GOSH_THEME=none GOSH_VERSE_PREFIX='>> '; source $TEST_HOME/lib/oh-my-gosh.zsh; print -r -- \"[\$GOSH_VERSE_PREFIX]\"" 2>&1)
_is "GOSH_THEME=none 保留自定义前缀" "[>> ]" "$out"

gosh theme default >/dev/null 2>&1

# ═══════════════ 7. 版本与语言 ═══════════════
_section "圣经版本与语言 / Versions & languages"

gosh version en-KJV >/dev/null 2>&1
_is "切换到 en-KJV" en-KJV "$GOSH_BIBLE_VERSION"
_gosh_pick_entry psalm
_has "en-KJV 的诗篇是英文出处" "Psalms" "$REPLY"

gosh version hand >/dev/null 2>&1
_is "能切到手写的 .zsh 数据" hand "$GOSH_BIBLE_VERSION"
_gosh_pick_entry psalm
_has "手写数据也能按标签抽取" "手写占位" "$REPLY"

gosh version zh-Hans >/dev/null 2>&1
_gosh_pick_entry psalm
_has "zh-Hans 的诗篇是中文出处" "诗篇" "$REPLY"

_status_is "未知版本返回错误" 1 gosh version bogus

gosh version en-KJV >/dev/null 2>&1
_is "切到英文版本后界面语言跟随" en "$GOSH_UI_LANG"
out=$(gosh on 2>&1)
_has "英文界面提示为英文" "Verse output" "$out"

gosh lang zh >/dev/null 2>&1
_is "gosh lang zh 强制中文界面" zh "$GOSH_UI_LANG"
_is "界面语言不影响圣经版本" en-KJV "$GOSH_BIBLE_VERSION"

gosh lang auto >/dev/null 2>&1
_is "GOSH_LANG=auto 跟随版本语言" en "$GOSH_UI_LANG"

gosh lang zh >/dev/null 2>&1
gosh version zh-Hans >/dev/null 2>&1

local -i ok_tags=0
for id in zh-Hans en-KJV hand; do
  _gosh_load_bible "$id" >/dev/null 2>&1
  _gosh_pick_entry "诗篇" && _gosh_entry_has_tag "$REPLY" psalm && (( ok_tags++ ))
done
_is "跨语言/跨格式用别名「诗篇」都能抽到诗篇" 3 $ok_tags

_gosh_load_bible zh-Hans >/dev/null 2>&1

# ═══════════════ 8. 祈祷模式 ═══════════════
_section "祈祷模式 / Prayer"

out=$(gosh pray -n 3 2>&1)
_has "祈祷模式有十字架" "##" "$out"
_has "祈祷模式有阿们" "阿們" "$out"

local -i verse_lines=0
for l in ${(f)out}; do
  [[ $l == *"📖"* ]] && (( verse_lines++ ))
done
_is "gosh pray -n 3 输出三节经文" 3 $verse_lines

out=$(gosh pray psalm -n 2 2>&1)
local -i p=0
for l in ${(f)out}; do
  [[ $l == *(诗篇|詩篇|Psalms)* ]] && (( p++ ))
done
_is "gosh pray psalm 只出诗篇" 2 $p

out=$(gosh pray faith -n 1 --slow 2>&1)
_has "--slow 也能正常输出" "阿們" "$out"

# ═══════════════ 9. 保存设置 ═══════════════
_section "保存设置 / Persistence"

gosh theme heaven  >/dev/null 2>&1
gosh version en-KJV >/dev/null 2>&1
gosh tag psalm     >/dev/null 2>&1
gosh save          >/dev/null 2>&1
[[ -r "$TEST_HOME/goshrc" ]] && _ok "gosh save 写出 goshrc" || _no "gosh save 写出 goshrc"

out=$(_zsh 'print -r -- "$GOSH_THEME|$GOSH_BIBLE_VERSION|$GOSH_VERSE_TAG"')
_is "goshrc 在下次启动时生效" "heaven|en-KJV|psalm" "$out"

# ═══════════════ 汇总 ═══════════════
print -r -- ""
print -r -- "════════════════════════════════════"
if (( GOSH_TEST_FAIL == 0 )); then
  print -r -- "✅ 全部通过：$GOSH_TEST_PASS 项"
else
  print -r -- "❌ 失败 $GOSH_TEST_FAIL 项 / 通过 $GOSH_TEST_PASS 项"
fi
print -r -- "════════════════════════════════════"

[[ $TEST_HOME == ${TMPDIR:-/tmp}/oh-my-gosh-test.* ]] && rm -rf "$TEST_HOME"
(( GOSH_TEST_FAIL == 0 ))
