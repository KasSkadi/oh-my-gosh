# ─────────────────────────────────────────────
#  theme-heaven.zsh — 天堂：云白与柔蓝
# ─────────────────────────────────────────────

GOSH_THEME_NAME="heaven"
GOSH_VERSE_PREFIX="☁  "
GOSH_VERSE_COLOR=153
GOSH_VERSE_REF_COLOR=110
GOSH_VERSE_SEP="  ✧ "
GOSH_CROSS_COLOR=117
typeset -ga GOSH_CROSS_ART=(
  '  ☁          ☁  '
  '        │       '
  '        │       '
  '  ──────┼────── '
  '        │       '
  '        │       '
  '  ☁          ☁  '
)

# 经文用柔和的上下点缀包裹
_gosh_theme_render_verse() {
  emulate -L zsh
  local text=${1//\%/%%} ref=$2
  print -P "%F{110}✦ ⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯⋯ %f"
  print -P "%F{${GOSH_VERSE_COLOR}}${GOSH_VERSE_PREFIX}${text}%f"
  if [[ $GOSH_VERSE_SHOW_REF == 1 && -n $ref ]]; then
    print -P "%F{${GOSH_VERSE_REF_COLOR}}                          ✧ ${ref}%f"
  fi
}

if [[ -o interactive ]] && [[ $GOSH_SET_PROMPT == 1 ]]; then
  PROMPT='%F{110}☁%f %F{153}%n%f%F{240}@%f%F{117}%m%f %F{240}·%f %F{189}%~%f
%F{117}❯%f '
  RPROMPT='%F{110}☁ %F{240}%D{%H:%M}%f'
fi
