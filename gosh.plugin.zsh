# oh-my-gosh — 把随机经文带进你的 zsh
# 用法（任选其一）：
#   1) source /path/to/oh-my-gosh/gosh.plugin.zsh
#   2) 作为 oh-my-zsh / zinit / antigen 插件加载（插件名 gosh 或 oh-my-gosh）
#   3) 用 install-gosh.sh 安装后运行 gosh shell

export GOSH_HOME="${GOSH_HOME:-${0:A:h}}"
source "$GOSH_HOME/lib/oh-my-gosh.zsh"
