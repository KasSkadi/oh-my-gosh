# ─────────────────────────────────────────────
#  config.zsh — 默认配置 / Defaults
#  所有变量都可以在 zshrc 或 goshrc 里覆盖
# ─────────────────────────────────────────────

: ${GOSH_VERSION:=0.2.0}

# ── 总开关与触发节奏 / Master switch & cadence ──
: ${GOSH_ENABLE_VERSE:=1}         # 1 开启随机经文 / 0 关闭
: ${GOSH_VERSE_FREQUENCY:=1}      # 每 N 条命令输出一次（0 = 只在 bless/失败时输出）
: ${GOSH_VERSE_PROBABILITY:=100}  # 触发概率 %（0-100）

# ── 失败彩蛋 / Comfort easter egg ──
: ${GOSH_COMFORT_ON_ERROR:=1}     # 命令失败（$? != 0）时必出一节“安慰”经文
: ${GOSH_COMFORT_TAG:=comfort}    # 失败时抽取的标签

# ── 抽取 / Selection ──
: ${GOSH_VERSE_TAG:=}             # 全局标签过滤，如 psalm / 诗篇；空 = 全部
: ${GOSH_VERSE_NO_REPEAT:=8}      # 记住最近 N 节，避免连续重复

# ── 圣经版本与语言 / Bible version & UI language ──
: ${GOSH_BIBLE_VERSION:=zh-Hans}  # zh-Hans / zh-Hant / en-KJV / 自定义
: ${GOSH_LANG:=}                  # zh / en；空 = 跟随圣经版本自动推断

# ── 主题 / Theme ──
: ${GOSH_THEME:=default}          # default / minimal / revelation / heaven / none
: ${GOSH_SET_PROMPT:=1}           # 0 = 只输出经文，不改动你的提示符

# ── 祈祷模式 / Prayer mode ──
: ${GOSH_PRAY_COUNT:=5}           # gosh pray 输出的经文节数
: ${GOSH_PRAY_DELAY:=0}           # 每节之间的停顿（秒），gosh pray --slow 会用 0.6

# ── 显示样式（主题会覆盖） / Rendering (themes override) ──
: ${GOSH_VERSE_SHOW_REF:=1}       # 1 显示出处 / 0 不显示
: ${GOSH_VERSE_SHOW_TAGS:=0}      # 1 额外显示 #tags
: ${GOSH_VERSE_PREFIX:="📖  "}
: ${GOSH_VERSE_COLOR:=245}        # 256 色号
: ${GOSH_VERSE_REF_COLOR:=240}
: ${GOSH_VERSE_SEP:="  — "}
: ${GOSH_CROSS_COLOR:=245}

# ── 内部状态 / Internal state（不要改这些） ──
typeset -gi _GOSH_CMD_COUNT=0
typeset -gi _GOSH_SKIP_NEXT=0
typeset -gi _GOSH_READY=0
typeset -ga _GOSH_HISTORY=()

# 容错：颜色/概率必须是数字
[[ $GOSH_VERSE_COLOR == <-> ]] || GOSH_VERSE_COLOR=245
[[ $GOSH_VERSE_REF_COLOR == <-> ]] || GOSH_VERSE_REF_COLOR=240
[[ $GOSH_CROSS_COLOR == <-> ]] || GOSH_CROSS_COLOR=245
[[ $GOSH_VERSE_PROBABILITY == <-> ]] || GOSH_VERSE_PROBABILITY=100
[[ $GOSH_VERSE_FREQUENCY == <-> ]] || GOSH_VERSE_FREQUENCY=1
[[ $GOSH_VERSE_NO_REPEAT == <-> ]] || GOSH_VERSE_NO_REPEAT=8

# 界面语言：显式 GOSH_LANG 优先，否则跟随圣经版本的语言
typeset -g GOSH_UI_LANG=zh

# 不使用 $+functions（那需要 zsh/parameter 模块），用 whence 判断更皮实
_gosh_has_function() {
  emulate -L zsh
  local w
  w=$(whence -w -- "$1" 2>/dev/null) || return 1
  [[ ${w##*: } == function ]]
}

_gosh_sync_lang() {
  emulate -L zsh
  local want=${GOSH_LANG:-${GOSH_BIBLE_LANG:-}}
  if [[ -z $want ]]; then
    case ${GOSH_BIBLE_VERSION%%-*} in
      en) want=en ;;
      *)  want=zh ;;
    esac
  fi
  GOSH_UI_LANG=$want
  typeset -g GOSH_UI_LANG
}
_gosh_sync_lang
