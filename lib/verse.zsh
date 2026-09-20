# ─────────────────────────────────────────────
#  verse.zsh — 解析 / 抽取 / 渲染 / precmd 钩子
#
#  条目格式（两种都支持，靠 _GOSH_DATA_FORMAT 区分）：
#    txt : "出处<TAB>#tags<TAB>正文"     ← tools/fetch-verses.sh 生成，惰性加载
#    zsh : "正文|出处|#tags"             ← 手写的小数据集
#
#  注意：解析路径上不要用命令替换（$()），否则每节经文都会 fork 一个子进程；
#  31k 节的数据集下那会是灾难。结果放在 _GOSH_P_TEXT/_GOSH_P_REF/_GOSH_P_TAGS。
# ─────────────────────────────────────────────

typeset -g _GOSH_P_TEXT="" _GOSH_P_REF="" _GOSH_P_TAGS=""
typeset -gA _GOSH_TAG_COUNT=()

# ── 解析 ──
_gosh_parse_entry() {
  emulate -L zsh
  local entry=$1 rest
  if [[ $_GOSH_DATA_FORMAT == txt ]]; then
    _GOSH_P_REF=${entry%%$'\t'*}
    rest=${entry#*$'\t'}
    _GOSH_P_TAGS=${rest%%$'\t'*}
    _GOSH_P_TEXT=${rest#*$'\t'}
  else
    _GOSH_P_TEXT=${entry%%|*}
    rest=${entry#*|}
    _GOSH_P_REF=${rest%%|*}
    if [[ $rest == *'|'* ]]; then
      _GOSH_P_TAGS=${rest#*|}
    else
      _GOSH_P_TAGS=""
    fi
  fi
}

# 便利包装（会 fork，别放在循环里）
_gosh_verse_text() { _gosh_parse_entry "$1"; print -r -- "$_GOSH_P_TEXT" }
_gosh_verse_ref()  { _gosh_parse_entry "$1"; print -r -- "$_GOSH_P_REF" }
_gosh_verse_tags() { _gosh_parse_entry "$1"; print -r -- "$_GOSH_P_TAGS" }

# 条目是否符合某个规范标签（无命令替换）
_gosh_entry_has_tag() {
  emulate -L zsh
  local entry=$1 tag=$2 field rest
  if [[ $_GOSH_DATA_FORMAT == txt ]]; then
    field=${${entry#*$'\t'}%%$'\t'*}
  else
    rest=${entry#*|}
    field=""
    [[ $rest == *'|'* ]] && field=${rest#*|}
  fi
  [[ -n $field ]] || return 1
  [[ " ${field//\#/} " == *" $tag "* ]]
}

# ── 标签索引（按需构建，`gosh tags` / 校验标签时才用）──
_gosh_tag_reindex() {
  emulate -L zsh
  _gosh_bible_ensure_loaded
  _GOSH_TAG_COUNT=()
  local entry field t
  for entry in "${GOSH_VERSES[@]}"; do
    if [[ $_GOSH_DATA_FORMAT == txt ]]; then
      field=${${entry#*$'\t'}%%$'\t'*}
    else
      field=""
      [[ ${entry#*|} == *'|'* ]] && field=${${entry#*|}#*|}
    fi
    [[ -n $field ]] || continue
    for t in ${(s: :)${field//\#/}}; do
      [[ -n $t ]] && _GOSH_TAG_COUNT[$t]=$(( ${_GOSH_TAG_COUNT[$t]:-0} + 1 ))
    done
  done
  _GOSH_TAG_INDEXED=1
}

_gosh_ensure_tag_index() {
  emulate -L zsh
  (( _GOSH_TAG_INDEXED )) || _gosh_tag_reindex
  return 0
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
    # 切片必须用 (@)，否则含空格的经文会被拼成一个元素
    _GOSH_HISTORY=("${(@)_GOSH_HISTORY[2,-1]}")
  done
}

# _gosh_pick_entry [tag|别名] → 结果放进 $REPLY
_gosh_pick_entry() {
  emulate -L zsh
  _gosh_bible_ensure_loaded
  local total=${#GOSH_VERSES[@]}
  (( total > 0 )) || return 1

  local tag=""
  [[ -n $1 ]] && tag=$(_gosh_resolve_tag "$1")

  local -a pool=()
  local entry field i
  if [[ -n $tag ]]; then
    # 只有带过滤时才扫描；无过滤直接在全集里随机
    for (( i = 1; i <= total; i++ )); do
      entry=${GOSH_VERSES[$i]}
      if [[ $_GOSH_DATA_FORMAT == txt ]]; then
        field=${${entry#*$'\t'}%%$'\t'*}
      else
        field=""
        [[ ${entry#*|} == *'|'* ]] && field=${${entry#*|}#*|}
      fi
      [[ -n $field ]] || continue
      [[ " ${field//\#/} " == *" $tag "* ]] && pool+=("$i")
    done
    total=${#pool[@]}
    (( total > 0 )) || return 1
  fi

  local tries=0 cand idx n
  while (( tries++ < 20 )); do
    n=$(( RANDOM % total + 1 ))
    cand=${GOSH_VERSES[${pool[$n]:-$n}]}
    # 空行（理论上不会有）也当作命中，继续抽
    [[ -n $cand ]] && { _gosh_in_history "$cand" || break }
  done
  [[ -n $cand ]] || cand=${GOSH_VERSES[1]}
  REPLY=$cand
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
  local raw=$1 tag=""
  [[ -n $raw ]] && tag=$(_gosh_resolve_tag "$raw")

  if ! _gosh_pick_entry "$tag"; then
    if [[ -n $tag && ${#GOSH_VERSES[@]} -gt 0 ]]; then
      _gosh_report_bad_tag "$raw" "$tag" >&2
    else
      _gosh_bible_hint
    fi
    return 1
  fi

  local entry=$REPLY
  _gosh_history_push "$entry"
  _gosh_parse_entry "$entry"
  _gosh_render_verse "$_GOSH_P_TEXT" "$_GOSH_P_REF" "$_GOSH_P_TAGS"
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
