# ─────────────────────────────────────────────
#  oh-my-gosh.zsh — 核心：加载一切
# ─────────────────────────────────────────────

# GOSH_HOME：优先环境变量，否则按本文件位置推断（lib/ 的上一级）
if [[ -z ${GOSH_HOME:-} ]]; then
  GOSH_HOME=${${(%):-%x}:A:h:h}
fi
export GOSH_HOME

_GOSH_LIB="$GOSH_HOME/lib"

source "$_GOSH_LIB/config.zsh"

# 用户持久化设置（gosh save 生成）
if [[ -r "$GOSH_HOME/goshrc" ]]; then
  source "$GOSH_HOME/goshrc"
fi
_gosh_sync_lang

source "$_GOSH_LIB/locale.zsh"
source "$_GOSH_LIB/tags.zsh"
source "$_GOSH_LIB/bible.zsh"
source "$_GOSH_LIB/themes.zsh"
source "$_GOSH_LIB/verse.zsh"
source "$_GOSH_LIB/prayer.zsh"
source "$_GOSH_LIB/cli.zsh"

# ── 启动 ──
_gosh_theme_scan
# 没有数据时会打印一次「怎么获取数据」的提示（不会每条命令都刷屏）
_gosh_load_bible "$GOSH_BIBLE_VERSION" || true
_gosh_style_snapshot
_gosh_theme_load "$GOSH_THEME"

# precmd 钩子：每条命令结束后输出经文
# 直接用 precmd_functions（core 自带），不依赖 fpath 里的 add-zsh-hook
if [[ -o interactive ]]; then
  if (( ! ${precmd_functions[(Ie)_gosh_precmd]:-0} )); then
    precmd_functions+=(_gosh_precmd)
  fi
fi

# 补全
if _gosh_has_function compdef; then
  compdef _gosh_complete gosh 2>/dev/null
fi
