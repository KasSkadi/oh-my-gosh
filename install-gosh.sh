#!/usr/bin/env bash
# ═════════════════════════════════════════════
#  oh-my-gosh 安装脚本
#  把「随机经文 + 主题 + 祈祷模式」装进你的 zsh
#
#  用法：
#    ./install-gosh.sh                 # 装到 ~/.gosh
#    GOSH_HOME=/other/path ./install-gosh.sh
#    ./install-gosh.sh --dir /other/path
#    ./install-gosh.sh --no-rc         # 不修改 ~/.zshrc
# ═════════════════════════════════════════════
set -euo pipefail

VERSION="0.2.0"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GOSH_HOME="${GOSH_HOME:-$HOME/.gosh}"
WRITE_RC=1
[[ -n "${GOSH_NO_RC:-}" ]] && WRITE_RC=0

usage() {
  cat <<'EOF'
oh-my-gosh 安装脚本

  ./install-gosh.sh [选项]

  --dir <路径>   安装目录（默认 ~/.gosh）
  --no-rc        不修改 ~/.zshrc，只打印手动配置方法
  -h, --help     显示本帮助

环境变量：
  GOSH_HOME      安装目录（等价于 --dir）
  GOSH_NO_RC=1   等价于 --no-rc
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      [[ -n ${2:-} ]] || { echo "❌ --dir 需要一个路径" >&2; exit 1; }
      GOSH_HOME="$2"; shift 2 ;;
    --no-rc) WRITE_RC=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "❌ 未知参数：$1" >&2; usage; exit 1 ;;
  esac
done

# ── 安全检查：不要装到根目录或家目录本身 ──
case "$GOSH_HOME" in
  ""|"/"|"$HOME"|".")
    echo "❌ 拒绝安装到：$GOSH_HOME（请用一个子目录，例如 ~/.gosh）" >&2
    exit 1 ;;
esac

# ── 依赖检查 ──
if ! command -v zsh >/dev/null 2>&1; then
  cat >&2 <<'MSG'
❌ 未检测到 zsh，请先安装：
   macOS:   brew install zsh
   Ubuntu:  sudo apt install zsh
   Arch:    sudo pacman -S zsh
   Fedora:  sudo dnf install zsh
MSG
  exit 1
fi

if [[ ! -r "$SRC_DIR/lib/oh-my-gosh.zsh" ]]; then
  cat >&2 <<EOF
❌ 找不到 $SRC_DIR/lib/oh-my-gosh.zsh
   请先把仓库克隆下来，再在仓库目录里运行安装脚本：

     git clone <repo-url> oh-my-gosh
     cd oh-my-gosh
     ./install-gosh.sh

EOF
  exit 1
fi

echo "🐋 正在安装 oh-my-gosh $VERSION 到 $GOSH_HOME ..."
mkdir -p "$GOSH_HOME"

install_dir() {
  local name="$1"
  [[ -d "$SRC_DIR/$name" ]] || return 0
  mkdir -p "$GOSH_HOME/$name"
  cp -R "$SRC_DIR/$name/." "$GOSH_HOME/$name/"
}
install_file() {
  local name="$1"
  [[ -f "$SRC_DIR/$name" ]] || return 0
  cp "$SRC_DIR/$name" "$GOSH_HOME/$name"
}

install_dir lib
install_dir themes
install_dir bin
install_dir zdotdir
install_dir tools
install_file gosh.plugin.zsh
install_file oh-my-gosh.plugin.zsh
install_file README.md
install_file NOTICE.md
install_file LICENSE

chmod +x "$GOSH_HOME/bin/gosh"
[[ -f "$GOSH_HOME/tools/fetch-verses.sh" ]] && chmod +x "$GOSH_HOME/tools/fetch-verses.sh"

# ── 仓库不含经文原文：检查本地是否已经有数据 ──
shopt -s nullglob
HAS_DATA=0
for f in "$GOSH_HOME"/lib/bible/verses-*.txt "$GOSH_HOME"/lib/bible/verses-*.zsh; do
  [[ -r $f ]] && HAS_DATA=1
done
shopt -u nullglob

# ── 把 $HOME 前缀缩写成 $HOME，方便写进 rc 文件 ──
as_rc_path() {
  local p="$1"
  case "$p" in
    "$HOME"/*) printf '$HOME%s' "${p#"$HOME"}" ;;
    *)         printf '%s' "$p" ;;
  esac
}

PLUGIN_RC_PATH="$(as_rc_path "$GOSH_HOME/gosh.plugin.zsh")"
BIN_RC_PATH="$(as_rc_path "$GOSH_HOME/bin")"
RC_FILE="${ZDOTDIR:-$HOME}/.zshrc"
BLOCK_START="# >>> oh-my-gosh >>>"
BLOCK_END="# <<< oh-my-gosh <<<"

if [[ $WRITE_RC == 1 ]]; then
  touch "$RC_FILE"
  if grep -qF "$BLOCK_START" "$RC_FILE" 2>/dev/null; then
    echo "ℹ️  $RC_FILE 里已经有 oh-my-gosh 配置，跳过"
  else
    BACKUP="$RC_FILE.oh-my-gosh.$(date +%Y%m%d%H%M%S).bak"
    cp "$RC_FILE" "$BACKUP"
    {
      printf '\n%s\n' "$BLOCK_START"
      echo "# 在你已有的 zsh 里直接启用（推荐）："
      echo "[[ -r \"$PLUGIN_RC_PATH\" ]] && source \"$PLUGIN_RC_PATH\""
      echo "# 或者只想要独立的 gosh shell，取消下一行注释并去掉上面这行："
      echo "# export PATH=\"$BIN_RC_PATH:\$PATH\""
      printf '%s\n' "$BLOCK_END"
    } >> "$RC_FILE"
    echo "📝 已写入 $RC_FILE（备份：$BACKUP）"
  fi
else
  echo "ℹ️  跳过修改 rc 文件，请手动加上："
  echo ""
  echo "    source \"$PLUGIN_RC_PATH\""
  echo ""
fi

# ── 自检 ──
echo ""
if SELFCHECK=$(GOSH_HOME="$GOSH_HOME" zsh -f -c "source \"$GOSH_HOME/lib/oh-my-gosh.zsh\"; gosh --version" 2>&1); then
  echo "🔎 自检通过："
  echo "$SELFCHECK" | sed 's/^/    /'
else
  echo "⚠️  自检失败，请把下面的输出发给开发者："
  echo "$SELFCHECK" | sed 's/^/    /'
fi

if [[ $HAS_DATA == 1 ]]; then
  echo "📖 经文数据：已安装（$GOSH_HOME/lib/bible）"
else
  echo "📖 经文数据：尚未安装（仓库不含经文原文）"
fi

cat <<EOF

✅ 安装完成！oh-my-gosh $VERSION

下一步（任选其一）：
  1) 在你已有的 zsh 里启用：  source ~/.zshrc   （然后随便跑条命令）
  2) 或者用独立 shell：       $GOSH_HOME/bin/gosh

常用命令：
  gosh setup cuv kjv    获取公有领域经文数据（首次使用必须先做）
  gosh bless psalm     抽一节诗篇
  gosh pray            祈祷模式：一串经文 + 十字架
  gosh theme revelation 换成启示录风格
  gosh version en-KJV  换成英文圣经
  gosh tags            看当前版本的所有标签
  gosh help            全部命令

版权与数据来源：见 $GOSH_HOME/NOTICE.md
卸载：删掉 $GOSH_HOME，再删掉 ${RC_FILE} 里 $BLOCK_START 到 $BLOCK_END 的几行。

EOF
