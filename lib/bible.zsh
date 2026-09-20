# ─────────────────────────────────────────────
#  bible.zsh — 圣经版本管理（多语言）
#  数据文件：$GOSH_HOME/lib/bible/verses-<id>.zsh
# ─────────────────────────────────────────────

# 已知版本：id → "语言|显示名"
typeset -gA GOSH_BIBLES=(
  [zh-Hans]="zh|和合本 · 简体中文"
  [zh-Hant]="zh|和合本 · 繁體中文"
  [en-KJV]="en|King James Version (1611)"
)

typeset -ga GOSH_VERSES=()
typeset -g GOSH_BIBLE_NAME=""
typeset -g GOSH_BIBLE_LANG=""

_gosh_bible_dir() { print -r -- "${GOSH_HOME:-$HOME/.gosh}/lib/bible" }

# 把目录里额外的 verses-*.zsh 也登记进来
_gosh_bible_scan() {
  emulate -L zsh
  local f id
  for f in "$(_gosh_bible_dir)"/verses-*.zsh(N); do
    id=${${f:t}#verses-}
    id=${id%.zsh}
    [[ -n ${GOSH_BIBLES[$id]} ]] && continue
    case ${id%%-*} in
      zh) GOSH_BIBLES[$id]="zh|$id" ;;
      en) GOSH_BIBLES[$id]="en|$id" ;;
      *)  GOSH_BIBLES[$id]="zh|$id" ;;
    esac
  done
}

_gosh_bible_ids() { print -l -- ${(ok)GOSH_BIBLES} }

_gosh_bible_meta() {
  emulate -L zsh
  local id=${1:-$GOSH_BIBLE_VERSION}
  print -r -- ${GOSH_BIBLES[$id]:-"zh|$id"}
}

_gosh_bible_name() { local m=$(_gosh_bible_meta "$1"); print -r -- ${m#*\|} }
_gosh_bible_lang() { local m=$(_gosh_bible_meta "$1"); print -r -- ${m%%\|*} }

# 载入某个版本；失败时回落到 zh-Hans
_gosh_load_bible() {
  emulate -L zsh
  local id=${1:-$GOSH_BIBLE_VERSION}
  local file="$(_gosh_bible_dir)/verses-$id.zsh"

  if [[ ! -r $file ]]; then
    if [[ $id != zh-Hans ]]; then
      local bad=$id
      id=zh-Hans
      file="$(_gosh_bible_dir)/verses-$id.zsh"
      _gosh_t unknown_version "$bad" >&2
    fi
    if [[ ! -r $file ]]; then
      print -u2 -- "⚠️  oh-my-gosh: 找不到经文数据 $file"
      return 1
    fi
  fi

  GOSH_VERSES=()
  source "$file"
  GOSH_BIBLE_VERSION=$id
  GOSH_BIBLE_NAME="$(_gosh_bible_name $id)"
  GOSH_BIBLE_LANG="$(_gosh_bible_lang $id)"
  _gosh_sync_lang
  _gosh_tag_reindex
  return 0
}
