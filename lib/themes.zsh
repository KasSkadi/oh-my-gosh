# ─────────────────────────────────────────────
#  themes.zsh — 主题加载器
#  主题文件：$GOSH_HOME/themes/theme-<name>.zsh
#  GOSH_THEME=revelation 即启用；GOSH_THEME=none 只输出经文、不动提示符
# ─────────────────────────────────────────────

# name → "中文说明|English description"
typeset -gA GOSH_THEMES=(
  [default]="经典风格：两行提示符 + 📖 经文|Classic: two-line prompt with 📖 verses"
  [minimal]="极简风格：纯文本经文，不打扰提示符|Minimal: plain-text verses, quiet prompt"
  [revelation]="启示录风格：烈焰配色 + 经文边框|Revelation: flame palette and framed verses"
  [heaven]="天堂风格：云白与柔蓝|Heaven: cloud white and soft blue"
  [none]="只输出经文，完全不改动提示符|Verses only, your prompt stays untouched"
)

typeset -g GOSH_THEME_NAME=""
typeset -ga GOSH_CROSS_ART=()

# 启动时把「用户自己配的样式」存下来，切换主题时用它复位，
# 这样 GOSH_THEME=none 不会把你在 zshrc 里设的前缀/颜色吃掉。
typeset -gi _GOSH_STYLE_SNAPSHOT=0
typeset -g _GOSH_BASE_VERSE_PREFIX="" _GOSH_BASE_VERSE_COLOR="" _GOSH_BASE_VERSE_REF_COLOR=""
typeset -g _GOSH_BASE_VERSE_SEP="" _GOSH_BASE_CROSS_COLOR=""

_gosh_style_snapshot() {
  emulate -L zsh
  _GOSH_BASE_VERSE_PREFIX=$GOSH_VERSE_PREFIX
  _GOSH_BASE_VERSE_COLOR=$GOSH_VERSE_COLOR
  _GOSH_BASE_VERSE_REF_COLOR=$GOSH_VERSE_REF_COLOR
  _GOSH_BASE_VERSE_SEP=$GOSH_VERSE_SEP
  _GOSH_BASE_CROSS_COLOR=$GOSH_CROSS_COLOR
  _GOSH_STYLE_SNAPSHOT=1
}

_gosh_theme_dir() { print -r -- "${GOSH_HOME:-$HOME/.gosh}/themes" }

# 目录里多出来的 theme-*.zsh 也登记（显示名用文件名）
_gosh_theme_scan() {
  emulate -L zsh
  local f name
  for f in "$(_gosh_theme_dir)"/theme-*.zsh(N); do
    name=${${f:t}#theme-}
    name=${name%.zsh}
    [[ -n ${GOSH_THEMES[$name]} ]] && continue
    GOSH_THEMES[$name]="$name|$name"
  done
}

_gosh_theme_ids() { print -l -- ${(ok)GOSH_THEMES} }

_gosh_theme_desc() {
  emulate -L zsh
  local d=${GOSH_THEMES[$1]:-"$1|$1"}
  if [[ ${GOSH_UI_LANG:-zh} == en ]]; then
    print -r -- ${d#*\|}
  else
    print -r -- ${d%%\|*}
  fi
}

# 把主题可覆盖的变量/函数恢复成默认值，避免切换主题时残留上个主题的样式
_gosh_theme_reset() {
  emulate -L zsh
  unset -f _gosh_theme_render_verse _gosh_theme_render_cross _gosh_theme_banner 2>/dev/null
  GOSH_THEME_NAME=""
  GOSH_CROSS_ART=()
  if (( _GOSH_STYLE_SNAPSHOT )); then
    GOSH_VERSE_PREFIX=$_GOSH_BASE_VERSE_PREFIX
    GOSH_VERSE_COLOR=$_GOSH_BASE_VERSE_COLOR
    GOSH_VERSE_REF_COLOR=$_GOSH_BASE_VERSE_REF_COLOR
    GOSH_VERSE_SEP=$_GOSH_BASE_VERSE_SEP
    GOSH_CROSS_COLOR=$_GOSH_BASE_CROSS_COLOR
  else
    GOSH_VERSE_PREFIX="📖  "
    GOSH_VERSE_COLOR=245
    GOSH_VERSE_REF_COLOR=240
    GOSH_VERSE_SEP="  — "
    GOSH_CROSS_COLOR=245
  fi
}

_gosh_theme_load() {
  emulate -L zsh
  local name=${1:-$GOSH_THEME}

  if [[ $name == (none|off) ]]; then
    _gosh_theme_reset
    GOSH_THEME=none
    return 0
  fi

  local file="$(_gosh_theme_dir)/theme-$name.zsh"
  if [[ ! -r $file ]]; then
    if [[ $name != default ]]; then
      _gosh_t unknown_theme "$name" >&2
      name=default
      file="$(_gosh_theme_dir)/theme-$name.zsh"
    fi
    if [[ ! -r $file ]]; then
      print -u2 -- "⚠️  oh-my-gosh: 找不到主题文件 $file"
      return 1
    fi
  fi

  _gosh_theme_reset
  source "$file"
  GOSH_THEME=$name
  [[ -n $GOSH_THEME_NAME ]] || GOSH_THEME_NAME=$name
  return 0
}
