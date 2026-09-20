# ─────────────────────────────────────────────
#  theme-default.zsh — 经典风格
# ─────────────────────────────────────────────

GOSH_THEME_NAME="default"
GOSH_VERSE_PREFIX="📖  "
GOSH_VERSE_COLOR=245
GOSH_VERSE_REF_COLOR=240
GOSH_VERSE_SEP="  — "
GOSH_CROSS_COLOR=245

if [[ -o interactive ]] && [[ $GOSH_SET_PROMPT == 1 ]]; then
  PROMPT='%F{242}✝%f %F{cyan}%n%f%F{242}@%f%F{blue}%m%f %F{242}·%f %F{yellow}%~%f
%F{242}❯%f '
  RPROMPT='%F{242}%D{%H:%M}%f'
fi
