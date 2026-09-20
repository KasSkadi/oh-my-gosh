# ─────────────────────────────────────────────
#  verse.zsh — 解析 / 抽取 / 渲染 / precmd 钩子
#  条目格式："正文|出处|#tag #tag"（第三段可选）
# ─────────────────────────────────────────────

typeset -gA _GOSH_TAG_COUNT=()

# ── 解析 ──
_gosh_verse_text() { print -r -- ${1%%|*} }

_gosh_verse_ref() {
  emulate -L zsh
  local rest=${1#*|}
  if [[ $rest == *'|'* ]]; then
    print -r -- ${rest%%|*}
  else
    print -r -- ${rest}
  fi
}

_gosh_verse_tags() {
  emulate -L zsh
  local rest=${1#*|}
  [[ $rest == *'|'* ]] && print -r -- ${rest#*|}
}

# 条目是否符合某个规范标签
_gosh_entry_has_tag() {
  emulate -L zsh
  local field=$(_gosh_verse_tags "$1")
  [[ -n $field ]] || return 1
  local -a toks=( ${(s: :)${field//\#/}} )
  (( ${toks[(Ie)$2]} ))
}

# 统计当前版本用到的标签，供 gosh tags 使用
_gosh_tag_reindex() {
  emulate -L zsh
  _GOSH_TAG_COUNT=()
  local entry field t
  for entry in "${GOSH_VERSES[@]}"; do
    field=$(_gosh_verse_tags "$entry")
    [[ -n $field ]] || continue
    for t in ${(s: :)${field//\#/}}; do
      [[ -n $t ]] && _GOSH_TAG_COUNT[$t]=$(( ${_GOSH_TAG_COUNT[$t]:-0} + 1 ))
    done
  done
}

# ── 抽取 ──
_gosh_in_history() {
  emulate -L zsh
  (( ${_GOSH_HISTORY[(Ie)$1]} ))
}

_gosh_history_push() {
  emulate -L zsh
  _GOSH_HISTORY+=("$1")
  local cap=${GOSH_VERSE_NO_REPEAT:-8}
  (( cap > 0 )) || cap=1
  while (( ${#_GOSH_HISTORY[@]} > cap )); do
    # 注意：切片必须用 (@)，否则带空格的经文会被拼成一个元素
    _GOSH_HISTORY=("${(@)_GOSH_HISTORY[2,-1]}")
  done
}

# _gosh_pick_entry [tag|别名] → 结果放进 $REPLY
_gosh_pick_entry() {
  emulate -L zsh
  local tag=""
  [[ -n $1 ]] && tag=$(_gosh_resolve_tag "$1")
  local -a pool=()
  local entry
  for entry in "${GOSH_VERSES[@]}"; do
    if [[ -z $tag ]] || _gosh_entry_has_tag "$entry" "$tag"; then
      pool+=("$entry")
    fi
  done
  (( ${#pool[@]} )) || return 1

  local idx cand tries=0
  while (( tries++ < 20 )); do
    idx=$(( RANDOM % ${#pool[@]} + 1 ))
    cand=${pool[$idx]}
    _gosh_in_history "$cand" || break
  done
  REPLY=${cand:-${pool[1]}}
  return 0
}

# ── 渲染 ──
_gosh_render_verse_default() {
  emulate -L zsh
  local text=${1//\%/%%} ref=$2
  if [[ $GOSH_VERSE_SHOW_REF == 1 && -n $ref ]]; then
    print -P "%F{${GOSH_VERSE_COLOR}}${GOSH_VERSE_PREFIX}${text}%f%F{${GOSH_VERSE_REF_COLOR}}${GOSH_VERSE_SEP}${ref}%f"
  else
    print -P "%F{${GOSH_VERSE_COLOR}}${GOSH_VERSE_PREFIX}${text}%f"
  fi
}

_gosh_render_verse() {
  emulate -L zsh
  if _gosh_has_function _gosh_theme_render_verse; then
    _gosh_theme_render_verse "$@"
  else
    _gosh_render_verse_default "$@"
  fi
  if [[ $GOSH_VERSE_SHOW_TAGS == 1 && -n $3 ]]; then
    print -P "%F{${GOSH_VERSE_REF_COLOR}}   ${3}%f"
  fi
}

# ── 对外：打印一节经文 ──
_gosh_print_verse() {
  emulate -L zsh
  local raw=$1
  local tag=""
  [[ -n $raw ]] && tag=$(_gosh_resolve_tag "$raw")

  if ! _gosh_pick_entry "$tag"; then
    if [[ -n $tag ]]; then
      _gosh_report_bad_tag "$raw" "$tag" >&2
    else
      print -u2 -- "⚠️  oh-my-gosh: 经文数据为空（$GOSH_BIBLE_VERSION）"
    fi
    return 1
  fi

  local entry=$REPLY
  _gosh_history_push "$entry"
  _gosh_render_verse "$(_gosh_verse_text "$entry")" "$(_gosh_verse_ref "$entry")" "$(_gosh_verse_tags "$entry")"
  return 0
}

# ── precmd：每条命令结束、提示符出现前运行 ──
_gosh_precmd() {
  # 必须最先取 $?：下面的 emulate 会把状态码重置掉
  local last_status=$?
  emulate -L zsh

  if (( _GOSH_SKIP_NEXT )); then
    _GOSH_SKIP_NEXT=0
    return 0
  fi
  [[ $GOSH_ENABLE_VERSE == 1 ]] || return 0

  # 第一个提示符不输出（shell 刚起来，还没执行过命令）
  if (( ! _GOSH_READY )); then
    _GOSH_READY=1
    return 0
  fi

  _GOSH_CMD_COUNT=$(( _GOSH_CMD_COUNT + 1 ))

  # 彩蛋：命令失败必出一节「安慰」经文，绕过频率与概率
  if (( last_status != 0 )) && [[ $GOSH_COMFORT_ON_ERROR == 1 ]]; then
    _gosh_print_verse "$GOSH_COMFORT_TAG"
    return 0
  fi

  (( GOSH_VERSE_FREQUENCY > 0 )) || return 0
  (( _GOSH_CMD_COUNT % GOSH_VERSE_FREQUENCY == 0 )) || return 0
  (( RANDOM % 100 < GOSH_VERSE_PROBABILITY )) || return 0

  _gosh_print_verse "$GOSH_VERSE_TAG"
  return 0
}
