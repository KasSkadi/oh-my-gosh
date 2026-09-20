# ─────────────────────────────────────────────
#  verses-zh-Hans.zsh — 和合本（简体）· 公有领域
#  格式： "经文|出处|#tag #tag"
#  标签一律用英文规范名（见 lib/tags.zsh），方便跨语言过滤
# ─────────────────────────────────────────────

typeset -ga GOSH_VERSES=(
  # ── 创世记 ──
  "起初，神创造天地。|创世记 1:1|#creation #truth"
  "神说：要有光，就有了光。|创世记 1:3|#creation #light"
  "我们要照着我们的形像、按着我们的样式造人。|创世记 1:26|#creation #identity"
  "耶和华对亚伯兰说：你要离开本地、本族、父家，往我所要指示你的地去。|创世记 12:1|#promise #guidance #obedience"

  # ── 出埃及记 ──
  "我是耶和华你的神，曾将你从埃及地为奴之家领出来。|出埃及记 20:2|#law #salvation"
  "耶和华是战士，他的名是耶和华。|出埃及记 15:3|#victory #strength"

  # ── 民数记 ──
  "愿耶和华赐福给你，保护你。|民数记 6:24|#blessing #protection"
  "愿耶和华使他的脸光照你，赐恩给你。|民数记 6:25|#blessing #grace #light"
  "愿耶和华向你仰脸，赐你平安。|民数记 6:26|#blessing #peace"

  # ── 申命记 ──
  "你要尽心、尽性、尽力爱耶和华你的神。|申命记 6:5|#love #obedience"
  "人活着不是单靠食物，乃是靠耶和华口里所出的一切话。|申命记 8:3|#provision #truth"

  # ── 约书亚记 ──
  "你当刚强壮胆！不要惧怕，也不要惊惶。|约书亚记 1:9|#courage #comfort #promise"

  # ── 撒母耳记上 ──
  "耶和华不像人看人：人是看外貌；耶和华是看内心。|撒母耳记上 16:7|#identity #truth"

  # ── 诗篇 ──
  "不从恶人的计谋，不站罪人的道路，不坐亵慢人的座位。|诗篇 1:1|#psalm #holiness"
  "耶和华是我的牧者，我必不至缺乏。|诗篇 23:1|#psalm #shepherd #provision #trust"
  "他使我躺卧在青草地上，领我在可安歇的水边。|诗篇 23:2|#psalm #rest #provision"
  "我虽然行过死荫的幽谷，也不怕遭害，因为你与我同在。|诗篇 23:4|#psalm #comfort #courage #protection"
  "耶和华是我的亮光，是我的拯救，我还怕谁呢？|诗篇 27:1|#psalm #light #salvation #courage"
  "但你耶和华是我四围的盾牌，是我的荣耀，又是叫我抬起头来的。|诗篇 3:3|#psalm #comfort #protection"
  "耶和华靠近伤心的人，拯救灵性痛悔的人。|诗篇 34:18|#psalm #comfort #mercy"
  "你要把你的重担卸给耶和华，他必抚养你；他永不叫义人动摇。|诗篇 55:22|#psalm #comfort #trust"
  "当将你的事交托耶和华，并倚靠他，他就必成全。|诗篇 37:5|#psalm #trust #guidance"
  "神是我们的避难所，是我们的力量，是我们在患难中随时的帮助。|诗篇 46:1|#psalm #comfort #strength #protection"
  "你们要休息，要知道我是神。|诗篇 46:10|#psalm #rest #peace #trust"
  "你的话是我脚前的灯，是我路上的光。|诗篇 119:105|#psalm #light #guidance #truth"
  "我要向山举目；我的帮助从何而来？我的帮助从造天地的耶和华而来。|诗篇 121:1-2|#psalm #comfort #protection"
  "他医好伤心的人，裹好他们的伤处。|诗篇 147:3|#psalm #comfort #healing"
  "凡有气息的都要赞美耶和华！|诗篇 150:6|#psalm #praise #joy"

  # ── 箴言 ──
  "敬畏耶和华是知识的开端。|箴言 1:7|#wisdom #fear-of-god"
  "你要专心仰赖耶和华，不可倚靠自己的聪明。|箴言 3:5|#wisdom #trust"
  "在你一切所行的事上都要认定他，他必指引你的路。|箴言 3:6|#wisdom #guidance"
  "义人的路好像黎明的光，越照越明，直到日午。|箴言 4:18|#light #holiness #hope"
  "回答柔和，使怒消退；言语暴戾，触动怒气。|箴言 15:1|#tongue #patience #peace"
  "人心筹算自己的道路；惟耶和华指引他的脚步。|箴言 16:9|#guidance #trust"
  "朋友乃时常亲爱，弟兄为患难而生。|箴言 17:17|#friendship #love"
  "人有见识就不轻易发怒；宽恕人的过失便是自己的荣耀。|箴言 19:11|#patience #mercy #forgiveness"

  # ── 传道书 ──
  "凡事都有定期，天下万务都有定时。|传道书 3:1|#wisdom #patience"
  "虚空的虚空，虚空的虚空，凡事都是虚空。|传道书 1:2|#wisdom #truth"

  # ── 以赛亚书 ──
  "你们得救在乎归回安息；你们得力在乎平静安稳。|以赛亚书 30:15|#rest #strength #trust"
  "疲乏的，他赐能力；软弱的，他加力量。|以赛亚书 40:29|#strength #comfort"
  "但那等候耶和华的必从新得力。|以赛亚书 40:31|#strength #hope #wait"
  "他们必如鹰展翅上腾；他们奔跑却不困倦，行走却不疲乏。|以赛亚书 40:31|#strength #hope #wait"
  "你不要害怕，因为我与你同在；不要惊惶，因为我是你的神。|以赛亚书 41:10|#comfort #courage #promise"
  "你从水中经过，我必与你同在；你趟过江河，水必不漫过你。|以赛亚书 43:2|#comfort #protection #promise"

  # ── 耶利米书 ──
  "我知道我向你们所怀的意念是赐平安的意念，不是降灾祸的意念，要叫你们末后有指望。|耶利米书 29:11|#hope #peace #promise"
  "你的话是我心中的欢喜快乐，因我是称为你名下的人。|耶利米书 15:16|#joy #truth #identity"

  # ── 耶利米哀歌 ──
  "我们不至消灭，是出于耶和华诸般的慈爱；是因他的怜悯不致断绝。每早晨这都是新的；你的诚实极其广大！|耶利米哀歌 3:22-23|#comfort #mercy #hope"

  # ── 弥迦书 ──
  "行公义，好怜悯，存谦卑的心，与你的神同行。|弥迦书 6:8|#justice #mercy #humility"

  # ── 那鸿书 ──
  "耶和华本为善，在患难的日子为人的保障，并且认得那些投靠他的人。|那鸿书 1:7|#comfort #protection"

  # ── 西番雅书 ──
  "耶和华你的神是施行拯救、大有能力的主。他在你中间必因你欢欣喜乐，默然爱你，且因你喜乐而欢呼。|西番雅书 3:17|#comfort #love #joy #salvation"

  # ── 马太福音 ──
  "虚心的人有福了！因为天国是他们的。|马太福音 5:3|#kingdom #humility"
  "哀恸的人有福了！因为他们必得安慰。|马太福音 5:4|#comfort #kingdom"
  "你们是世上的盐。|马太福音 5:13|#discipleship #identity"
  "你们是世上的光。|马太福音 5:14|#light #discipleship #identity"
  "你们要先求他的国和他的义，这些东西都要加给你们了。|马太福音 6:33|#kingdom #provision #faith"
  "不要为明天忧虑，因为明天自有明天的忧虑。|马太福音 6:34|#comfort #trust #peace"
  "凡劳苦担重担的人可以到我这里来，我就使你们得安息。|马太福音 11:28|#comfort #rest"
  "在人这是不能的，在神凡事都能。|马太福音 19:26|#faith #strength"
  "你们要去，使万民作我的门徒。|马太福音 28:19|#gospel #discipleship"
  "我就常与你们同在，直到世界的末了。|马太福音 28:20|#comfort #promise #discipleship"

  # ── 马可福音 ──
  "在信的人，凡事都能。|马可福音 9:23|#faith"

  # ── 路加福音 ──
  "在神凡事都能。|路加福音 1:37|#faith #promise"
  "你们要给人，就必有给你们的。|路加福音 6:38|#generosity #blessing"

  # ── 约翰福音 ──
  "神爱世人，甚至将他的独生子赐给他们。|约翰福音 3:16|#gospel #love #salvation"
  "叫一切信他的，不至灭亡，反得永生。|约翰福音 3:16|#gospel #faith #eternal-life"
  "我就是生命的粮。|约翰福音 6:35|#gospel #provision"
  "我是世界的光。跟从我的，就不在黑暗里走。|约翰福音 8:12|#gospel #light"
  "我来了，是要叫羊得生命，并且得的更丰盛。|约翰福音 10:10|#gospel #eternal-life"
  "我就是道路、真理、生命。|约翰福音 14:6|#gospel #truth #salvation"
  "你们心里不要忧愁；你们信神，也当信我。|约翰福音 14:1|#comfort #faith #trust"
  "我留下平安给你们；我将我的平安赐给你们。|约翰福音 14:27|#peace #comfort"
  "我是葡萄树，你们是枝子。|约翰福音 15:5|#discipleship #identity"
  "我将这些事告诉你们，是要叫你们在我里面有平安。在世上你们有苦难；但你们可以放心，我已经胜了世界。|约翰福音 16:33|#peace #comfort #victory"

  # ── 使徒行传 ──
  "施比受更为有福。|使徒行传 20:35|#generosity #blessing"

  # ── 罗马书 ──
  "我们晓得万事都互相效力，叫爱神的人得益处。|罗马书 8:28|#promise #love #hope"
  "是高处的，是低处的，是别的受造之物，都不能叫我们与神的爱隔绝；这爱是在我们的主基督耶稣里的。|罗马书 8:38-39|#comfort #love #promise"
  "不要效法这个世界，只要心意更新而变化。|罗马书 12:2|#holiness #obedience"
  "在指望中要喜乐，在患难中要忍耐，祷告要恒切。|罗马书 12:12|#hope #patience #prayer"

  # ── 哥林多前书 ──
  "爱是恒久忍耐，又有恩慈；爱是不嫉妒。|哥林多前书 13:4|#love #patience"
  "如今常存的有信，有望，有爱；这三样，其中最大的是爱。|哥林多前书 13:13|#love #faith #hope"

  # ── 哥林多后书 ──
  "愿颂赞归与我们的主耶稣基督的父神，就是发慈悲的父，赐各样安慰的神。我们在一切患难中，他就安慰我们。|哥林多后书 1:3-4|#comfort #mercy"
  "我的恩典够你用的，因为我的能力是在人的软弱上显得完全。|哥林多后书 12:9|#grace #strength #comfort"

  # ── 加拉太书 ──
  "圣灵所结的果子，就是仁爱、喜乐、和平、忍耐、恩慈、良善、信实、温柔、节制。|加拉太书 5:22-23|#joy #love #peace #holiness"

  # ── 以弗所书 ──
  "你们得救是本乎恩，也因着信。|以弗所书 2:8|#grace #salvation #faith"
  "我们原是他的工作，在基督耶稣里造成的。|以弗所书 2:10|#identity #work"

  # ── 腓立比书 ──
  "应当一无挂虑，只要凡事藉着祷告、祈求和感谢，将你们所要的告诉神。|腓立比书 4:6|#prayer #thanksgiving #peace"
  "神所赐、出人意外的平安，必在基督耶稣里保守你们的心怀意念。|腓立比书 4:7|#peace #comfort #protection"
  "我靠着那加给我力量的，凡事都能做。|腓立比书 4:13|#strength #faith"

  # ── 歌罗西书 ──
  "无论做什么，都要从心里做，像是给主做的，不是给人做的。|歌罗西书 3:23|#work #obedience"

  # ── 帖撒罗尼迦前书 ──
  "要常常喜乐，不住地祷告，凡事谢恩。|帖撒罗尼迦前书 5:16-18|#joy #prayer #thanksgiving"

  # ── 提摩太后书 ──
  "神赐给我们，不是胆怯的心，乃是刚强、仁爱、谨守的心。|提摩太后书 1:7|#courage #love #strength"

  # ── 希伯来书 ──
  "信就是所望之事的实底，是未见之事的确据。|希伯来书 11:1|#faith #hope"
  "主是帮助我的，我必不惧怕。|希伯来书 13:6|#courage #trust #comfort"
  "耶稣基督昨日、今日、一直到永远，是一样的。|希伯来书 13:8|#promise #trust"

  # ── 雅各书 ──
  "你们要亲近神，神就必亲近你们。|雅各书 4:8|#prayer #holiness"
  "务要在主面前自卑，主就必叫你们升高。|雅各书 4:10|#humility #promise"

  # ── 彼得前书 ──
  "你们要将一切的忧虑卸给神，因为他顾念你们。|彼得前书 5:7|#comfort #trust"

  # ── 约翰一书 ──
  "神就是爱；住在爱里面的，就是住在神里面，神也住在他里面。|约翰一书 4:16|#love #identity"
  "爱里没有惧怕；爱既完全，就把惧怕除去。|约翰一书 4:18|#love #comfort #courage"
  "我们若认自己的罪，神是信实的，是公义的，必要赦免我们的罪。|约翰一书 1:9|#forgiveness #repentance #grace"

  # ── 启示录 ──
  "神要擦去他们一切的眼泪；不再有死亡，也不再有悲哀、哭号、疼痛。|启示录 21:4|#comfort #eternal-life #hope"
  "看哪，我必快来！|启示录 22:12|#promise #kingdom"
  "我是阿拉法，我是俄梅戛；我是首先的，我是末后的。|启示录 22:13|#eternal-life #kingdom #truth"
)
