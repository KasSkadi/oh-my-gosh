# ─────────────────────────────────────────────
#  theme-revelation.zsh — 启示录：烈焰与金
# ─────────────────────────────────────────────

GOSH_THEME_NAME="revelation"
GOSH_VERSE_PREFIX="🔥  "
GOSH_VERSE_COLOR=224
GOSH_VERSE_REF_COLOR=214
GOSH_VERSE_SEP="  ✦ "
GOSH_CROSS_COLOR=214
typeset -ga GOSH_CROSS_ART=(
  '        ██        '
  '        ██        '
  '        ██        '
  ' ████████████████ '
  '        ██        '
  '        ██        '
  '        ██        '
  '        ██        '
  '        ██        '
)

# 经文带边框，右上角用 ✦ 引出出处
_gosh_theme_render_verse() {
  emulate -L zsh
  local text=${1//\%/%%} ref=$2
  local label=$(_gosh_t holy_word)
  print -P "%F{196}╭─ %F{220}🔥 %F{196}┤ %F{214}${label}%F{196} ├─╮%f"
  print -P "%F{196}│%f %F{${GOSH_VERSE_COLOR}}${text}%f"
  if [[ $GOSH_VERSE_SHOW_REF == 1 && -n $ref ]]; then
    print -P "%F{196}╰─%F{214}✦ %F{220}${ref}%f"
  else
    print -P "%F{196}╰────────%f"
  fi
}

# 祈祷标题：加一圈火焰
_gosh_theme_banner() {
  emulate -L zsh
  local title=$(_gosh_t prayer_title)
  print -P "%F{196}🔥 ─────── %F{220}${title}%F{196} ─────── 🔥%f"
}

if [[ -o interactive ]] && [[ $GOSH_SET_PROMPT == 1 ]]; then
  PROMPT='%F{196}✞%f %F{203}%n%f%F{240}@%f%F{214}%m%f %F{240}·%f %F{220}%~%f
%F{196}❯%f '
  RPROMPT='%F{214}ΑΩ%f %F{240}%D{%H:%M}%f'
fi
