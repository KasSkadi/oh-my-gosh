#!/usr/bin/env zsh
# ─────────────────────────────────────────────
#  tests/run.zsh — oh-my-gosh 自测
#  运行：zsh tests/run.zsh
#  如果 zsh 的模块目录不在编译时的位置（比如手动解包），
#  用 GOSH_TEST_MODULE_PATH=/path/to/zsh/modules 指路
# ─────────────────────────────────────────────
emulate -L zsh

[[ -n ${GOSH_TEST_MODULE_PATH:-} ]] && module_path=($GOSH_TEST_MODULE_PATH $module_path)

REPO=${0:A:h:h}
ZSH_BIN=${GOSH_TEST_ZSH:-${commands[zsh]:-zsh}}
export GOSH_HOME=$REPO

typeset -gi GOSH_TEST_PASS=0 GOSH_TEST_FAIL=0

_ok() { GOSH_TEST_PASS=$(( GOSH_TEST_PASS + 1 )); print -r -- "  ✅ $1" }
_no() {
  GOSH_TEST_FAIL=$(( GOSH_TEST_FAIL + 1 ))
  print -r -- "  ❌ $1"
  [[ -n ${2:-} ]] && print -r -- "     ↳ $2"
}
_is() {
  if [[ $2 == $3 ]]; then _ok "$1"; else _no "$1" "expected [$2], got [$3]"; fi
}
_has() {
  if [[ $3 == *"$2"* ]]; then _ok "$1"; else _no "$1" "[$2] not found in: $3"; fi
}
_not_has() {
  if [[ $3 != *"$2"* ]]; then _ok "$1"; else _no "$1" "[$2] unexpectedly present in: $3"; fi
}
_status_is() { # _status_is desc expected_status command...
  local desc=$1 want=$2; shift 2
  "$@" >/dev/null 2>&1
  local got=$?
  if [[ $got == $want ]]; then _ok "$desc"; else _no "$desc" "exit $got, want $want"; fi
}
_section() { print -r -- ""; print -r -- "── $1 ──" }

# ═══════════════ 1. 载入与数据完整性 ═══════════════
_section "载入 / Loading"

local out
out=$("$ZSH_BIN" -f -c "module_path=(${(j: :)module_path}); source $REPO/lib/oh-my-gosh.zsh; print READY" 2>&1)
_has "source lib/oh-my-gosh.zsh 干净载入" "READY" "$out"
_not_has "载入过程中没有多余输出" "error" "$out"

source "$REPO/lib/oh-my-gosh.zsh"
_gosh_has_function _gosh_precmd && _ok "_gosh_precmd 已定义" || _no "_gosh_precmd 已定义"
_gosh_has_function gosh         && _ok "gosh 函数已定义"     || _no "gosh 函数已定义"
_gosh_has_function _gosh_pray   && _ok "祈祷模式已定义"       || _no "祈祷模式已定义"

_section "经文数据 / Data"

local -a all_versions=($(_gosh_bible_ids))
_is "版本数量" 3 ${#all_versions[@]}

local id entry
for id in "${all_versions[@]}"; do
  _gosh_load_bible "$id" >/dev/null 2>&1
  (( ${#GOSH_VERSES[@]} > 0 )) && _ok "$id: ${#GOSH_VERSES[@]} 节经文" || _no "$id: 经文为空"

  local bad=0 notag=0
  for entry in "${GOSH_VERSES[@]}"; do
    [[ $entry == *'|'* && -n $(_gosh_verse_text "$entry") && -n $(_gosh_verse_ref "$entry") ]] || (( bad++ ))
    [[ -n $(_gosh_verse_tags "$entry") ]] || (( notag++ ))
  done
  _is "$id: 每条都有正文与出处" 0 $bad
  _is "$id: 每条都带 #tag" 0 $notag

  local -a unregistered=() t
  for t in ${(k)_GOSH_TAG_COUNT}; do
    (( ${GOSH_TAG_CANON[(Ie)$t]} )) || unregistered+=("$t")
  done
  _is "$id: 没有未登记标签" 0 ${#unregistered[@]}

  (( ${_GOSH_TAG_COUNT[psalm]:-0} > 0 ))   && _ok "$id: 有 #psalm 经文"   || _no "$id: 有 #psalm 经文"
  (( ${_GOSH_TAG_COUNT[comfort]:-0} > 0 )) && _ok "$id: 有 #comfort 经文" || _no "$id: 有 #comfort 经文"
done

local -a missing=()
for t in $GOSH_TAG_CANON; do
  _gosh_load_bible zh-Hans >/dev/null 2>&1
  (( ${_GOSH_TAG_COUNT[$t]:-0} > 0 )) || missing+=("$t")
done
_is "规范标签都有对应经文" 0 ${#missing[@]}

# ═══════════════ 2. 抽取与标签 ═══════════════
_section "抽取 / Selection"

_gosh_load_bible zh-Hans >/dev/null 2>&1

local -i hits=0 i
for i in {1..40}; do
  _gosh_pick_entry psalm && _gosh_entry_has_tag "$REPLY" psalm && (( hits++ ))
done
_is "gosh bless psalm 只抽诗篇" 40 $hits

_is "别名 诗篇 → psalm"       psalm   "$(_gosh_resolve_tag 诗篇)"
_is "别名 Psalms → psalm"     psalm   "$(_gosh_resolve_tag Psalms)"
_is "别名 #安慰 → comfort"    comfort "$(_gosh_resolve_tag '#安慰')"
_is "别名 信心 → faith"       faith   "$(_gosh_resolve_tag 信心)"
_is "未知标签原样返回"        nosuch  "$(_gosh_resolve_tag nosuch)"

out=$(gosh bless psalm -n 3 2>&1)
local -i psalm_lines=0
local l
for l in ${(f)out}; do
  [[ $l == *(诗篇|詩篇|Psalms)* ]] && (( psalm_lines++ ))
done
_is "gosh bless psalm -n 3 输出三节" 3 $psalm_lines

_status_is "未知标签返回错误" 1 gosh bless nosuchtag
out=$(gosh bless nosuchtag 2>&1)
_has "未知标签有提示" "未知标签" "$out"

out=$(gosh tags 2>&1)
_has "gosh tags 列出标签" "#psalm" "$out"

gosh tag psalm >/dev/null 2>&1
_is "gosh tag psalm 设置过滤器" psalm "$GOSH_VERSE_TAG"
gosh tag all >/dev/null 2>&1
_is "gosh tag all 清除过滤器" "" "$GOSH_VERSE_TAG"

# ═══════════════ 3. 频率 / 概率 / 失败彩蛋 ═══════════════
_section "触发节奏与失败彩蛋 / Cadence & comfort"

GOSH_ENABLE_VERSE=1
GOSH_VERSE_TAG=""
GOSH_VERSE_PROBABILITY=100
GOSH_VERSE_FREQUENCY=2
_GOSH_READY=1
_GOSH_SKIP_NEXT=0

_GOSH_CMD_COUNT=0; true; out=$(_gosh_precmd 2>&1)
_is "频率 2：第 1 条命令不出经文" "" "$out"
_GOSH_CMD_COUNT=1; true; out=$(_gosh_precmd 2>&1)
(( ${#out} > 0 )) && _ok "频率 2：第 2 条命令出经文" || _no "频率 2：第 2 条命令出经文"

GOSH_VERSE_PROBABILITY=0
GOSH_VERSE_FREQUENCY=1
_GOSH_CMD_COUNT=0; true; out=$(_gosh_precmd 2>&1)
_is "概率 0：不出经文" "" "$out"

GOSH_VERSE_FREQUENCY=0
GOSH_VERSE_PROBABILITY=100
_GOSH_CMD_COUNT=0; true; out=$(_gosh_precmd 2>&1)
_is "频率 0：不自动输出" "" "$out"

# 失败彩蛋：需要在 comfort 池里找到打印出来的那节
local -a comfort_texts=()
for entry in "${GOSH_VERSES[@]}"; do
  _gosh_entry_has_tag "$entry" comfort && comfort_texts+=("$(_gosh_verse_text "$entry")")
done

GOSH_COMFORT_ON_ERROR=1
GOSH_VERSE_FREQUENCY=0
_GOSH_SKIP_NEXT=0
false; out=$(_gosh_precmd 2>&1)
local hit=0
for l in "${comfort_texts[@]}"; do
  [[ $out == *"$l"* ]] && hit=1
done
_is "命令失败必出一节安慰经文" 1 $hit

GOSH_ENABLE_VERSE=0
false; out=$(_gosh_precmd 2>&1)
_is "总开关关闭时失败也不输出" "" "$out"
GOSH_ENABLE_VERSE=1

GOSH_COMFORT_ON_ERROR=0
false; out=$(_gosh_precmd 2>&1)
_is "gosh comfort off 后失败不输出" "" "$out"
GOSH_COMFORT_ON_ERROR=1

_GOSH_SKIP_NEXT=1
false; out=$(_gosh_precmd 2>&1)
_is "gosh 自身触发时跳过下一节" "" "$out"

_GOSH_HISTORY=()
GOSH_VERSE_NO_REPEAT=8
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
(( ${#_GOSH_HISTORY[@]} <= 8 )) && _ok "历史长度不超过 GOSH_VERSE_NO_REPEAT" || _no "历史长度不超过 GOSH_VERSE_NO_REPEAT" "${#_GOSH_HISTORY[@]}"
(( ${#_GOSH_HISTORY[@]} == 8 )) && _ok "历史长度裁剪到 8（切片没被拼成一个元素）" || _no "历史长度裁剪到 8" "${#_GOSH_HISTORY[@]}"
_gosh_in_history "${picks[-1]}" && _ok "最新一次抽取在历史里" || _no "最新一次抽取在历史里"
_GOSH_HISTORY=()

# ═══════════════ 4. 主题 ═══════════════
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

# 环境变量方式切换（新起一个 shell）
out=$("$ZSH_BIN" -f -c "module_path=(${(j: :)module_path}); export GOSH_HOME=$REPO GOSH_THEME=revelation; source $REPO/lib/oh-my-gosh.zsh; print -r -- \$GOSH_THEME" 2>&1)
_is "GOSH_THEME=revelation 环境变量生效" revelation "$out"

out=$("$ZSH_BIN" -f -c "module_path=(${(j: :)module_path}); export GOSH_HOME=$REPO GOSH_THEME=none GOSH_VERSE_PREFIX='>> '; source $REPO/lib/oh-my-gosh.zsh; print -r -- \"[\$GOSH_VERSE_PREFIX]\"" 2>&1)
_is "GOSH_THEME=none 保留自定义前缀" "[>> ]" "$out"

gosh theme default >/dev/null 2>&1

# ═══════════════ 5. 多语言版本 ═══════════════
_section "圣经版本与语言 / Versions & languages"

gosh version en-KJV >/dev/null 2>&1
_is "切换到 en-KJV" en-KJV "$GOSH_BIBLE_VERSION"
_gosh_pick_entry psalm
_has "en-KJV 的诗篇是英文" "Psalms" "$REPLY"

gosh version zh-Hant >/dev/null 2>&1
_gosh_pick_entry psalm
_has "zh-Hant 的诗篇是繁体" "詩篇" "$REPLY"

gosh version zh-Hans >/dev/null 2>&1
_gosh_pick_entry psalm
_has "zh-Hans 的诗篇是简体" "诗篇" "$REPLY"

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

# 每种语言都能用中文/英文标签抽取
local -i ok_tags=0
for id in "${all_versions[@]}"; do
  _gosh_load_bible "$id" >/dev/null 2>&1
  _gosh_pick_entry "诗篇"      && _gosh_entry_has_tag "$REPLY" psalm   && (( ok_tags++ ))
done
_is "跨语言用别名「诗篇」都能抽到诗篇" 3 $ok_tags

_gosh_load_bible zh-Hans >/dev/null 2>&1

# ═══════════════ 6. 祈祷模式 ═══════════════
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

# ═══════════════ 7. 保存设置 ═══════════════
_section "保存设置 / Persistence"

local tmp=$(mktemp -d "${TMPDIR:-/tmp}/oh-my-gosh-test.XXXXXX")
ln -s "$REPO/lib" "$tmp/lib"
ln -s "$REPO/themes" "$tmp/themes"

local real_home=$GOSH_HOME
GOSH_HOME=$tmp
gosh theme heaven  >/dev/null 2>&1
gosh version en-KJV >/dev/null 2>&1
gosh tag psalm     >/dev/null 2>&1
gosh save          >/dev/null 2>&1
[[ -r "$tmp/goshrc" ]] && _ok "gosh save 写出 goshrc" || _no "gosh save 写出 goshrc"

out=$("$ZSH_BIN" -f -c "module_path=(${(j: :)module_path}); export GOSH_HOME=$tmp; source $REPO/lib/oh-my-gosh.zsh; print -r -- \"\$GOSH_THEME|\$GOSH_BIBLE_VERSION|\$GOSH_VERSE_TAG\"" 2>&1)
_is "goshrc 在下次启动时生效" "heaven|en-KJV|psalm" "$out"

GOSH_HOME=$real_home
[[ $tmp == ${TMPDIR:-/tmp}/oh-my-gosh-test.* ]] && rm -rf "$tmp"

# ═══════════════ 汇总 ═══════════════
print -r -- ""
print -r -- "════════════════════════════════════"
if (( GOSH_TEST_FAIL == 0 )); then
  print -r -- "✅ 全部通过：$GOSH_TEST_PASS 项"
else
  print -r -- "❌ 失败 $GOSH_TEST_FAIL 项 / 通过 $GOSH_TEST_PASS 项"
fi
print -r -- "════════════════════════════════════"
(( GOSH_TEST_FAIL == 0 ))
