# ─────────────────────────────────────────────
#  theme-minimal.zsh — 极简：无图标、无边框
# ─────────────────────────────────────────────

GOSH_THEME_NAME="minimal"
GOSH_VERSE_PREFIX=""
GOSH_VERSE_COLOR=250
GOSH_VERSE_REF_COLOR=242
GOSH_VERSE_SEP="  · "
GOSH_CROSS_COLOR=242
typeset -ga GOSH_CROSS_ART=(
  '    +'
  '    +'
  '    +'
  '----+----'
  '    +'
  '    +'
  '    +'
)

# 极简经文：只有正文与浅灰出处
_gosh_theme_render_verse() {
  emulate -L zsh
  local text=${1//\%/%%} ref=$2
  if [[ $GOSH_VERSE_SHOW_REF == 1 && -n $ref ]]; then
    print -P "%F{${GOSH_VERSE_COLOR}}${text}%f%F{${GOSH_VERSE_REF_COLOR}}${GOSH_VERSE_SEP}${ref}%f"
  else
    print -P "%F{${GOSH_VERSE_COLOR}}${text}%f"
  fi
}

if [[ -o interactive ]] && [[ $GOSH_SET_PROMPT == 1 ]]; then
  PROMPT='%F{240}%~%f %F{244}❯%f '
  RPROMPT=''
fi
