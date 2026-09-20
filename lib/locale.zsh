# ─────────────────────────────────────────────
#  locale.zsh — 界面文案（zh / en）
# ─────────────────────────────────────────────

typeset -gA _GOSH_I18N_ZH=(
  on_msg          "✝️  经文输出：已开启"
  off_msg         "✝️  经文输出：已关闭"
  freq_now        "✝️  当前频率：每 %s 条命令输出一次（0 = 不自动输出）"
  freq_set        "✝️  频率已设为：每 %s 条命令"
  prob_now        "✝️  当前触发概率：%s%%"
  prob_set        "✝️  触发概率已设为：%s%%"
  tag_now         "✝️  当前标签过滤：%s"
  tag_cleared     "✝️  已清除标签过滤，恢复全部经文"
  tag_set         "✝️  标签过滤已设为：#%s"
  comfort_now     "✝️  失败安慰经文：%s"
  theme_now       "🎨 当前主题：%s（%s）"
  theme_set       "🎨 主题已切换：%s（%s）"
  theme_none      "🎨 主题已设为 none：只输出经文，不改动提示符"
  version_now     "📚 当前圣经版本：%s（%s）"
  version_set     "📚 圣经版本已切换：%s（%s）"
  lang_now        "🌐 当前界面语言：%s"
  lang_set        "🌐 界面语言已设为：%s"
  available_tags  "可用标签（#tag）："
  available_themes "可用主题："
  available_versions "可用圣经版本："
  unknown_tag     "⚠️  未知标签「%s」，试试 gosh tags 查看全部标签"
  unknown_theme   "⚠️  未知主题「%s」，可用主题见 gosh themes"
  unknown_version "⚠️  未知圣经版本「%s」，可用版本见 gosh versions"
  empty_tag_pool  "⚠️  标签 #%s 在当前版本（%s）里没有经文"
  verse_off       "✝️  经文输出当前是关闭的，用 gosh on 打开"
  save_ok         "💾 已保存到 %s"
  amen            "阿們 · Amen"
  prayer_title    "祈禱 · PRAYER"
  holy_word       "聖 言"
  count_now       "📖 当前版本共 %s 节经文，%s 个标签"
  status_title    "── oh-my-gosh %s ──"
  cant_launch     "⚠️  找不到启动器 %s"
  help_hint       "用 gosh help 查看全部命令"
)

typeset -gA _GOSH_I18N_EN=(
  on_msg          "✝️  Verse output: on"
  off_msg         "✝️  Verse output: off"
  freq_now        "✝️  Frequency: once every %s command(s) (0 = never automatically)"
  freq_set        "✝️  Frequency set to: every %s command(s)"
  prob_now        "✝️  Trigger probability: %s%%"
  prob_set        "✝️  Trigger probability set to: %s%%"
  tag_now         "✝️  Active tag filter: %s"
  tag_cleared     "✝️  Tag filter cleared — drawing from all verses"
  tag_set         "✝️  Tag filter set to: #%s"
  comfort_now     "✝️  Comfort-on-error: %s"
  theme_now       "🎨 Theme: %s (%s)"
  theme_set       "🎨 Theme switched: %s (%s)"
  theme_none      "🎨 Theme set to none: verses only, your prompt is untouched"
  version_now     "📚 Bible version: %s (%s)"
  version_set     "📚 Bible version switched: %s (%s)"
  lang_now        "🌐 UI language: %s"
  lang_set        "🌐 UI language set to: %s"
  available_tags  "Available tags (#tag):"
  available_themes "Available themes:"
  available_versions "Available Bible versions:"
  unknown_tag     "⚠️  Unknown tag “%s” — run gosh tags to list them all"
  unknown_theme   "⚠️  Unknown theme “%s” — see gosh themes"
  unknown_version "⚠️  Unknown Bible version “%s” — see gosh versions"
  empty_tag_pool  "⚠️  No verses tagged #%s in %s"
  verse_off       "✝️  Verse output is off — run gosh on"
  save_ok         "💾 Saved to %s"
  amen            "Amen · 阿們"
  prayer_title    "PRAYER · 祈禱"
  holy_word       "THE  WORD"
  count_now       "📖 %s verses, %s tags in the current version"
  status_title    "── oh-my-gosh %s ──"
  cant_launch     "⚠️  Launcher not found: %s"
  help_hint       "Run gosh help for the full command list"
)

# _gosh_t <key> [args...]
_gosh_t() {
  emulate -L zsh
  local key=$1; shift
  local fmt
  if [[ ${GOSH_UI_LANG:-zh} == en ]]; then
    fmt=${_GOSH_I18N_EN[$key]:-$key}
  else
    fmt=${_GOSH_I18N_ZH[$key]:-$key}
  fi
  if (( $# )); then
    printf "$fmt\n" "$@"
  else
    printf '%s\n' "$fmt"
  fi
}

# _gosh_l2 "中文|English" —— 内联双语字符串
_gosh_l2() {
  emulate -L zsh
  if [[ ${GOSH_UI_LANG:-zh} == en ]]; then
    print -r -- ${1#*\|}
  else
    print -r -- ${1%%\|*}
  fi
}
