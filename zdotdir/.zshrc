# ─────────────────────────────────────────────
#  gosh shell 的 zshrc（由 oh-my-gosh 提供）
# ─────────────────────────────────────────────

export GOSH_HOME="${GOSH_HOME:-$HOME/.gosh}"

source "$GOSH_HOME/lib/oh-my-gosh.zsh"

# 想同时继承你原来的 ~/.zshrc？设置 GOSH_INHERIT_ZDOTDIR=1
if [[ -n ${GOSH_INHERIT_ZDOTDIR:-} && -r "${GOSH_ORIGINAL_ZDOTDIR:-$HOME}/.zshrc" ]]; then
  source "${GOSH_ORIGINAL_ZDOTDIR:-$HOME}/.zshrc"
fi
