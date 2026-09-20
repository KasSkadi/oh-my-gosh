# ─────────────────────────────────────────────
#  tags.zsh — 标签与别名
#  经文格式："正文|出处|#tag #tag"
#  标签统一用英文规范名，别名表负责多语言输入
# ─────────────────────────────────────────────

# 规范标签（英文小写），gosh tags 只统计实际用到的标签
typeset -ga GOSH_TAG_CANON=(
  blessing comfort courage creation discipleship eternal-life faith
  fear-of-god forgiveness friendship generosity gospel grace guidance
  healing holiness hope humility identity joy justice kingdom law light
  love mercy obedience patience peace praise prayer promise protection
  provision psalm repentance rest salvation shepherd strength thanksgiving
  tongue trust truth victory wait wisdom work
)

# 别名 → 规范标签（支持中英文、单复数、常见写法）
typeset -gA GOSH_TAG_ALIASES=(
  psalms psalm        psalm psalm         詩篇 psalm        诗篇 psalm
  詩 psalm            诗 psalm           psalm-of-david psalm
  comfort comfort     comforting comfort  consolation comfort
  安慰 comfort        安慰类 comfort      安慰類 comfort
  prayer prayer       祷告 prayer         禱告 prayer       祈祷 prayer
  praise praise       赞美 praise         讚美 praise       worship praise
  grace grace         恩典 grace          恩惠 grace
  faith faith         信心 faith          信 faith
  love love           爱 love             愛 love           charity love
  hope hope           盼望 hope           希望 hope
  peace peace         平安 peace          和睦 peace
  joy joy             喜乐 joy            喜樂 joy          rejoice joy
  strength strength   力量 strength       刚强 strength     剛強 strength
  courage courage     勇气 courage        勇氣 courage      胆量 courage
  protection protection 保护 protection   保護 protection   保守 protection
  provision provision 供应 provision      供應 provision    provide provision
  wisdom wisdom       智慧 wisdom
  guidance guidance   引导 guidance       引導 guidance     带领 guidance
  salvation salvation 救恩 salvation      拯救 salvation
  gospel gospel       福音 gospel
  creation creation   创造 creation       創造 creation
  promise promise     应许 promise        應許 promise      约定 promise
  mercy mercy         怜悯 mercy          憐憫 mercy
  forgiveness forgiveness 赦免 forgiveness 宽恕 forgiveness  寬恕 forgiveness
  obedience obedience 顺服 obedience      順服 obedience
  holiness holiness   圣洁 holiness       聖潔 holiness
  repentance repentance 悔改 repentance
  thanksgiving thanksgiving 感恩 thanksgiving 感谢 thanksgiving 感謝 thanksgiving
  identity identity   身份 identity       价值 identity
  work work           工作 work           职场 work
  rest rest           安息 rest           安静 rest
  wait wait           等候 wait
  trust trust         信靠 trust          交托 trust
  truth truth         真理 truth
  light light         光 light           光照 light
  healing healing     医治 healing        醫治 healing      安慰医治 healing
  blessing blessing   祝福 blessing       赐福 blessing
  kingdom kingdom     国度 kingdom        國度 kingdom
  discipleship discipleship 门徒 discipleship 門徒 discipleship
  eternal-life eternal-life 永生 eternal-life 永恒 eternal-life
  victory victory     得胜 victory        得勝 victory       胜利 victory
  patience patience   忍耐 patience       耐心 patience
  humility humility   谦卑 humility       謙卑 humility
  justice justice     公义 justice        公義 justice
  law law             律法 law
  friendship friendship 朋友 friendship   友谊 friendship
  fear-of-god fear-of-god 敬畏 fear-of-god 敬畏神 fear-of-god
  tongue tongue       言语 tongue         言語 tongue       舌头 tongue
  generosity generosity 施舍 generosity   慷慨 generosity    给予 generosity
)

# 把用户输入解析成规范标签
_gosh_resolve_tag() {
  emulate -L zsh
  local raw=${1:l}
  raw=${raw#\#}
  raw=${raw// /}
  [[ -z $raw ]] && return 0
  print -r -- ${GOSH_TAG_ALIASES[$raw]:-$raw}
}

_gosh_tag_exists() {
  emulate -L zsh
  (( ${_GOSH_TAG_COUNT[$1]:-0} > 0 ))
}

# 抽不到时说明原因：标签不认识，还是这个版本里没有
_gosh_report_bad_tag() {
  emulate -L zsh
  local raw=$1 canon=$2
  if (( ${GOSH_TAG_CANON[(Ie)$canon]} )); then
    _gosh_t empty_tag_pool "$canon" "$GOSH_BIBLE_VERSION"
  else
    _gosh_t unknown_tag "$raw"
  fi
  return 1
}
