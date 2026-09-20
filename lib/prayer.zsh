# ─────────────────────────────────────────────
#  prayer.zsh — 祈祷模式：一串随机经文 + ASCII 十字架
# ─────────────────────────────────────────────

typeset -ga _GOSH_CROSS_DEFAULT=(
  '        ##       '
  '        ##       '
  '        ##       '
  '  ############## '
  '        ##       '
  '        ##       '
  '        ##       '
  '        ##       '
)

_gosh_render_cross() {
  emulate -L zsh
  if _gosh_has_function _gosh_theme_render_cross; then
    _gosh_theme_render_cross
    return 0
  fi
  local -a art
  if (( ${#GOSH_CROSS_ART[@]} )); then
    art=("${GOSH_CROSS_ART[@]}")
  else
    art=("${_GOSH_CROSS_DEFAULT[@]}")
  fi
  local line
  for line in "${art[@]}"; do
    print -P "%F{${GOSH_CROSS_COLOR}}${line}%f"
  done
}

_gosh_banner() {
  emulate -L zsh
  if _gosh_has_function _gosh_theme_banner; then
    _gosh_theme_banner "$1"
    return 0
  fi
  local title
  case $1 in
    pray) title=$(_gosh_t prayer_title) ;;
    *)    title=$(_gosh_t holy_word) ;;
  esac
  print -P "%F{${GOSH_VERSE_REF_COLOR}}─────────  %F{${GOSH_VERSE_COLOR}}${title}%F{${GOSH_VERSE_REF_COLOR}}  ─────────%f"
}

# gosh pray [tag] [-n N] [--slow|--fast]
_gosh_pray() {
  emulate -L zsh
  local tag="" count=${GOSH_PRAY_COUNT:-5} delay=${GOSH_PRAY_DELAY:-0}

  while (( $# )); do
    case $1 in
      -n|--count)
        [[ -n $2 ]] || { print -u2 -- "gosh pray: -n 需要一个数字"; return 2 }
        count=$2; shift 2 ;;
      --slow) delay=0.6; shift ;;
      --fast) delay=0; shift ;;
      -h|--help)
        print -r -- "用法：gosh pray [标签] [-n 节数] [--slow]"
        return 0 ;;
      -*) print -u2 -- "gosh pray: 未知选项 $1"; return 2 ;;
      *)  tag=$1; shift ;;
    esac
  done

  [[ $count == <-> ]] || count=${GOSH_PRAY_COUNT:-5}
  (( count > 0 )) || count=1
  (( count > 99 )) && count=99

  print ''
  _gosh_banner pray
  _gosh_render_cross
  print ''

  local i
  for (( i = 1; i <= count; i++ )); do
    _gosh_print_verse "$tag" || return 1
    if (( i < count )) && (( delay > 0 )); then
      sleep "$delay"
    fi
  done

  print ''
  print -P "%F{${GOSH_VERSE_REF_COLOR}}          $(_gosh_t amen)%f"
  print ''
  return 0
}
