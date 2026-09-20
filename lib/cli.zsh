# ─────────────────────────────────────────────
#  cli.zsh — gosh 命令
# ─────────────────────────────────────────────

_gosh_cmd_bless() {
  emulate -L zsh
  local tag="" count=1
  while (( $# )); do
    case $1 in
      -n|--count)
        [[ -n $2 ]] || { print -u2 -- "gosh bless: -n 需要一个数字"; return 2 }
        count=$2; shift 2 ;;
      -h|--help)
        print -r -- "用法：gosh bless [标签] [-n 节数]"
        return 0 ;;
      -*) print -u2 -- "gosh bless: 未知选项 $1"; return 2 ;;
      *)  tag=$1; shift ;;
    esac
  done
  [[ $count == <-> ]] || count=1
  (( count > 0 )) || count=1
  (( count > 99 )) && count=99
  [[ -n $tag ]] || tag=$GOSH_VERSE_TAG

  local i
  for (( i = 1; i <= count; i++ )); do
    _gosh_print_verse "$tag" || return 1
  done
  return 0
}

_gosh_cmd_tag() {
  emulate -L zsh
  local arg=$1
  if [[ -z $arg ]]; then
    if [[ -z $GOSH_VERSE_TAG ]]; then
      _gosh_l2 '✝️  当前没有标签过滤：从全部经文里抽取|✝️  No tag filter: drawing from all verses'
    else
      _gosh_t tag_now "#$GOSH_VERSE_TAG"
    fi
    return 0
  fi
  if [[ $arg == (all|clear|none|off) ]]; then
    GOSH_VERSE_TAG=""
    _gosh_t tag_cleared
    return 0
  fi
  local canon=$(_gosh_resolve_tag "$arg")
  if ! _gosh_tag_exists "$canon"; then
    _gosh_report_bad_tag "$arg" "$canon"
    return 1
  fi
  GOSH_VERSE_TAG=$canon
  _gosh_t tag_set "$canon"
  return 0
}

_gosh_list_tags() {
  emulate -L zsh
  _gosh_t available_tags
  local -a tags=(${(ok)_GOSH_TAG_COUNT})
  local t out="" col=0
  for t in "${tags[@]}"; do
    out+=$(printf '%-22s' "#$t(${_GOSH_TAG_COUNT[$t]})")
    if (( ++col % 3 == 0 )); then
      print -r -- "  $out"
      out=""
    fi
  done
  [[ -n $out ]] && print -r -- "  $out"
  print -r -- "  $(_gosh_l2 '用法：gosh bless psalm ｜ gosh tag psalm' 'Usage: gosh bless psalm | gosh tag psalm')"
}

_gosh_cmd_theme() {
  emulate -L zsh
  local name=$1
  if [[ -z $name || $name == (show|status) ]]; then
    _gosh_t theme_now "$GOSH_THEME" "$(_gosh_theme_desc "$GOSH_THEME")"
    return 0
  fi
  if [[ $name == (list|ls|themes) ]]; then
    _gosh_list_themes
    return 0
  fi
  if [[ $name == (none|off) ]]; then
    GOSH_THEME=none
    _gosh_theme_reset
    _gosh_t theme_none
    return 0
  fi
  if [[ ! -r "$GOSH_HOME/themes/theme-$name.zsh" ]]; then
    _gosh_t unknown_theme "$name"
    return 1
  fi
  _gosh_theme_load "$name" || return 1
  _gosh_t theme_set "$GOSH_THEME" "$(_gosh_theme_desc "$GOSH_THEME")"
  return 0
}

_gosh_list_themes() {
  emulate -L zsh
  _gosh_t available_themes
  local name mark
  for name in $(_gosh_theme_ids); do
    if [[ $name == $GOSH_THEME ]]; then mark='●'; else mark='○'; fi
    printf '  %s %-12s %s\n' "$mark" "$name" "$(_gosh_theme_desc "$name")"
  done
  print -r -- "  $(_gosh_l2 '用法：GOSH_THEME=revelation ｜ gosh theme revelation' 'Usage: GOSH_THEME=revelation | gosh theme revelation')"
}

_gosh_cmd_version() {
  emulate -L zsh
  local id=$1
  if [[ -z $id || $id == (show|status) ]]; then
    _gosh_t version_now "$GOSH_BIBLE_VERSION" "$GOSH_BIBLE_NAME"
    return 0
  fi
  if [[ $id == (list|ls|versions) ]]; then
    _gosh_list_versions
    return 0
  fi
  if [[ ! -r "$GOSH_HOME/lib/bible/verses-$id.zsh" ]]; then
    _gosh_t unknown_version "$id"
    return 1
  fi
  _gosh_load_bible "$id" || return 1
  _gosh_t version_set "$GOSH_BIBLE_VERSION" "$GOSH_BIBLE_NAME"
  return 0
}

_gosh_list_versions() {
  emulate -L zsh
  _gosh_t available_versions
  local id mark
  for id in $(_gosh_bible_ids); do
    if [[ $id == $GOSH_BIBLE_VERSION ]]; then mark='●'; else mark='○'; fi
    printf '  %s %-10s %-28s %s\n' "$mark" "$id" "$(_gosh_bible_name "$id")" "$(_gosh_bible_lang "$id")"
  done
  print -r -- "  $(_gosh_l2 '用法：GOSH_BIBLE_VERSION=en-KJV ｜ gosh version en-KJV' 'Usage: GOSH_BIBLE_VERSION=en-KJV | gosh version en-KJV')"
}

_gosh_cmd_lang() {
  emulate -L zsh
  local arg=${1:l}
  if [[ -z $arg ]]; then
    _gosh_t lang_now "$GOSH_UI_LANG"
    return 0
  fi
  case $arg in
    zh|zh-cn|zh-hans|zh-hant|chinese|中文|简体|繁體) GOSH_LANG=zh ;;
    en|english|en-us|英文) GOSH_LANG=en ;;
    auto) GOSH_LANG="" ;;
    *) _gosh_l2 "⚠️  语言只能是 zh / en / auto" "⚠️  Language must be zh, en or auto"; return 1 ;;
  esac
  _gosh_sync_lang
  if [[ -z $GOSH_LANG ]]; then
    _gosh_l2 "🌐 界面语言：跟随圣经版本（$GOSH_UI_LANG）" "🌐 UI language: following the Bible version ($GOSH_UI_LANG)"
  else
    _gosh_t lang_set "$GOSH_UI_LANG"
  fi
  return 0
}

_gosh_status() {
  emulate -L zsh
  _gosh_t status_title "$GOSH_VERSION"
  printf '  %-10s %s\n' "$(_gosh_l2 '版本' 'Version')" "$GOSH_BIBLE_VERSION  ·  $GOSH_BIBLE_NAME"
  printf '  %-10s %s\n' "$(_gosh_l2 '语言' 'Language')" "ui=$GOSH_UI_LANG  ·  bible=$GOSH_BIBLE_LANG"
  printf '  %-10s %s\n' "$(_gosh_l2 '主题' 'Theme')" "$GOSH_THEME  ·  $(_gosh_theme_desc "$GOSH_THEME")"
  printf '  %-10s %s\n' "$(_gosh_l2 '标签' 'Tag')" "${GOSH_VERSE_TAG:-(*)}"
  printf '  %-10s %s\n' "$(_gosh_l2 '开关' 'Switch')" "on=$GOSH_ENABLE_VERSE  ·  freq=$GOSH_VERSE_FREQUENCY  ·  prob=$GOSH_VERSE_PROBABILITY%"
  printf '  %-10s %s\n' "$(_gosh_l2 '失败彩蛋' 'On error')" "comfort=$GOSH_COMFORT_ON_ERROR  ·  #$GOSH_COMFORT_TAG"
  printf '  %-10s %s\n' "$(_gosh_l2 '祈祷' 'Prayer')" "count=$GOSH_PRAY_COUNT  ·  delay=${GOSH_PRAY_DELAY}s"
  _gosh_t count_now "${#GOSH_VERSES[@]}" "${#_GOSH_TAG_COUNT[@]}"
  return 0
}

_gosh_save() {
  emulate -L zsh
  local file="$GOSH_HOME/goshrc"
  local -a lines=(
    "GOSH_THEME=$GOSH_THEME"
    "GOSH_BIBLE_VERSION=$GOSH_BIBLE_VERSION"
    "GOSH_ENABLE_VERSE=$GOSH_ENABLE_VERSE"
    "GOSH_VERSE_FREQUENCY=$GOSH_VERSE_FREQUENCY"
    "GOSH_VERSE_PROBABILITY=$GOSH_VERSE_PROBABILITY"
    "GOSH_COMFORT_ON_ERROR=$GOSH_COMFORT_ON_ERROR"
    "GOSH_VERSE_SHOW_REF=$GOSH_VERSE_SHOW_REF"
    "GOSH_PRAY_COUNT=$GOSH_PRAY_COUNT"
  )
  [[ -n $GOSH_LANG ]] && lines+=("GOSH_LANG=$GOSH_LANG")
  [[ -n $GOSH_VERSE_TAG ]] && lines+=("GOSH_VERSE_TAG=$GOSH_VERSE_TAG")

  {
    print -r -- "# ── oh-my-gosh 持久化设置（由 gosh save 生成，可手改） ──"
    local l
    for l in "${lines[@]}"; do
      printf '%q=%q\n' "${l%%=*}" "${l#*=}"
    done
  } >| "$file" || return 1
  _gosh_t save_ok "$file"
  return 0
}

_gosh_shell() {
  emulate -L zsh
  local launcher="$GOSH_HOME/bin/gosh"
  if [[ ! -x $launcher ]]; then
    _gosh_t cant_launch "$launcher" >&2
    return 1
  fi
  exec "$launcher" "$@"
}

_gosh_usage() {
  if [[ ${GOSH_UI_LANG:-zh} == en ]]; then
    cat <<EOF

  gosh — oh-my-gosh ${GOSH_VERSION}  (Bible: $GOSH_BIBLE_VERSION · Theme: $GOSH_THEME)

  gosh bless [tag] [-n N]   print random verse(s), optionally filtered by #tag
  gosh pray [tag] [-n N]    prayer mode: verses + ASCII cross (--slow to pace out)
  gosh tag [tag|all]        show / set / clear the global tag filter
  gosh tags                 list every tag available in the current version
  gosh theme [name]         show / switch theme (gosh themes to list them)
  gosh version [id]         show / switch Bible version (gosh versions to list)
  gosh lang [zh|en|auto]    UI language
  gosh on | off             toggle the random verse output
  gosh freq N               print a verse every N commands (0 = never)
  gosh prob P               trigger probability in percent
  gosh comfort on|off       comfort verse when a command fails
  gosh status               show the current configuration
  gosh save                 persist the current settings to \$GOSH_HOME/goshrc
  gosh shell                open a nested gosh shell

  Config lives in \$GOSH_HOME/goshrc (or your zshrc), e.g.
    GOSH_THEME=revelation
    GOSH_BIBLE_VERSION=en-KJV
    GOSH_VERSE_TAG=psalm

EOF
  else
    cat <<EOF

  gosh — oh-my-gosh ${GOSH_VERSION}  （圣经：$GOSH_BIBLE_VERSION · 主题：$GOSH_THEME）

  gosh bless [标签] [-n 节数]   立即抽经文，可按 #tag 过滤（如 gosh bless psalm）
  gosh pray [标签] [-n 节数]    祈祷模式：一串经文 + ASCII 十字架（--slow 逐节停顿）
  gosh tag [标签|all]          查看 / 设置 / 清除全局标签过滤
  gosh tags                    列出当前版本的全部标签
  gosh theme [名字]            查看 / 切换主题（gosh themes 列出全部）
  gosh version [id]            查看 / 切换圣经版本（gosh versions 列出全部）
  gosh lang [zh|en|auto]       界面语言
  gosh on | off                开关随机经文输出
  gosh freq N                  每 N 条命令输出一次（0 = 不自动输出）
  gosh prob P                  触发概率（百分比）
  gosh comfort on|off          命令失败时是否必出“安慰”经文
  gosh status                  查看当前配置
  gosh save                    把当前设置写入 \$GOSH_HOME/goshrc
  gosh shell                   打开一个嵌套的 gosh shell

  配置写在 \$GOSH_HOME/goshrc（或你的 zshrc）里，例如：
    GOSH_THEME=revelation
    GOSH_BIBLE_VERSION=en-KJV
    GOSH_VERSE_TAG=psalm

EOF
  fi
}

gosh() {
  emulate -L zsh
  _GOSH_SKIP_NEXT=1
  local cmd=$1
  case $cmd in
    ''|-h|--help|help)  _gosh_usage ;;
    -v|--version)       print -r -- "oh-my-gosh $GOSH_VERSION" ;;
    bless|verse)        shift; _gosh_cmd_bless "$@" ;;
    pray)               shift; _gosh_pray "$@" ;;
    tag)                shift; _gosh_cmd_tag "$@" ;;
    tags|tags-list)     _gosh_list_tags ;;
    theme)              shift; _gosh_cmd_theme "$@" ;;
    themes)             _gosh_list_themes ;;
    version|bible)      shift; _gosh_cmd_version "$@" ;;
    versions)           _gosh_list_versions ;;
    lang)               shift; _gosh_cmd_lang "$@" ;;
    on)                 GOSH_ENABLE_VERSE=1; _gosh_t on_msg ;;
    off)                GOSH_ENABLE_VERSE=0; _gosh_t off_msg ;;
    freq)
      if [[ -n $2 ]]; then
        if [[ $2 != <-> ]]; then
          _gosh_l2 "⚠️  频率需要是数字（0 = 不自动输出）" "⚠️  Frequency must be a number (0 = never)"
          return 2
        fi
        GOSH_VERSE_FREQUENCY=$2
        _gosh_t freq_set "$GOSH_VERSE_FREQUENCY"
      else
        _gosh_t freq_now "$GOSH_VERSE_FREQUENCY"
      fi ;;
    prob)
      if [[ -n $2 ]]; then
        if [[ $2 != <-> ]]; then
          _gosh_l2 "⚠️  概率需要是 0-100 的数字" "⚠️  Probability must be a number between 0 and 100"
          return 2
        fi
        GOSH_VERSE_PROBABILITY=$(( $2 > 100 ? 100 : $2 ))
        _gosh_t prob_set "$GOSH_VERSE_PROBABILITY"
      else
        _gosh_t prob_now "$GOSH_VERSE_PROBABILITY"
      fi ;;
    comfort)
      case $2 in
        on|1)  GOSH_COMFORT_ON_ERROR=1 ;;
        off|0) GOSH_COMFORT_ON_ERROR=0 ;;
        '')    ;;
        *)     _gosh_l2 "用法：gosh comfort on|off" "Usage: gosh comfort on|off"; return 2 ;;
      esac
      _gosh_t comfort_now "$GOSH_COMFORT_ON_ERROR (#$GOSH_COMFORT_TAG)" ;;
    status|info)        _gosh_status ;;
    save)               _gosh_save ;;
    shell|zsh)          shift; _gosh_shell "$@" ;;
    *)
      _gosh_l2 "⚠️  未知命令：$cmd" "⚠️  Unknown command: $cmd"
      _gosh_usage
      return 1 ;;
  esac
}

# 补全（需要在 compinit 之后注册）
_gosh_complete() {
  local -a subcmds
  subcmds=(
    'bless:抽一节随机经文|print random verses'
    'pray:祈祷模式（经文 + 十字架）|prayer mode'
    'tag:设置标签过滤|set the tag filter'
    'tags:列出标签|list tags'
    'theme:切换主题|switch theme'
    'themes:列出主题|list themes'
    'version:切换圣经版本|switch Bible version'
    'versions:列出版本|list versions'
    'lang:界面语言|UI language'
    'on:开启经文输出|enable verses'
    'off:关闭经文输出|disable verses'
    'freq:设置频率|set cadence'
    'prob:设置概率|set probability'
    'comfort:失败彩蛋开关|comfort on error'
    'status:查看配置|show config'
    'save:保存设置|save settings'
    'shell:打开嵌套 gosh shell|open a nested gosh shell'
    'help:帮助|help'
  )
  if (( CURRENT == 2 )); then
    _describe 'gosh command' subcmds
    return
  fi
  local cmd=${words[2]}
  case $cmd in
    bless|pray|tag)
      local -a taglist
      taglist=(${(ok)_GOSH_TAG_COUNT})
      _describe 'tag' taglist
      ;;
    theme)
      local -a themes
      themes=($(_gosh_theme_ids))
      _describe 'theme' themes
      ;;
    version|bible)
      local -a versions
      versions=($(_gosh_bible_ids))
      _describe 'version' versions
      ;;
    lang)
      _values 'language' zh en auto
      ;;
    on|off|comfort)
      _values 'toggle' on off
      ;;
  esac
}
