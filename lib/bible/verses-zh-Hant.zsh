# ─────────────────────────────────────────────
#  verses-zh-Hant.zsh — 和合本（繁體）· 公有領域
#  格式： "經文|出處|#tag #tag"
# ─────────────────────────────────────────────

typeset -ga GOSH_VERSES=(
  # ── 創世記 ──
  "起初，神創造天地。|創世記 1:1|#creation #truth"
  "神說：要有光，就有了光。|創世記 1:3|#creation #light"
  "我們要照著我們的形像、按著我們的樣式造人。|創世記 1:26|#creation #identity"
  "耶和華對亞伯蘭說：你要離開本地、本族、父家，往我所要指示你的地去。|創世記 12:1|#promise #guidance #obedience"

  # ── 出埃及記 ──
  "我是耶和華你的神，曾將你從埃及地為奴之家領出來。|出埃及記 20:2|#law #salvation"
  "耶和華是戰士，他的名是耶和華。|出埃及記 15:3|#victory #strength"

  # ── 民數記 ──
  "願耶和華賜福給你，保護你。|民數記 6:24|#blessing #protection"
  "願耶和華使他的臉光照你，賜恩給你。|民數記 6:25|#blessing #grace #light"
  "願耶和華向你仰臉，賜你平安。|民數記 6:26|#blessing #peace"

  # ── 申命記 ──
  "你要盡心、盡性、盡力愛耶和華你的神。|申命記 6:5|#love #obedience"
  "人活著不是單靠食物，乃是靠耶和華口裡所出的一切話。|申命記 8:3|#provision #truth"

  # ── 約書亞記 ──
  "你當剛強壯膽！不要懼怕，也不要驚惶。|約書亞記 1:9|#courage #comfort #promise"

  # ── 撒母耳記上 ──
  "耶和華不像人看人：人是看外貌；耶和華是看內心。|撒母耳記上 16:7|#identity #truth"

  # ── 詩篇 ──
  "不從惡人的計謀，不站罪人的道路，不坐褻慢人的座位。|詩篇 1:1|#psalm #holiness"
  "耶和華是我的牧者，我必不至缺乏。|詩篇 23:1|#psalm #shepherd #provision #trust"
  "他使我躺臥在青草地上，領我在可安歇的水邊。|詩篇 23:2|#psalm #rest #provision"
  "我雖然行過死蔭的幽谷，也不怕遭害，因為你與我同在。|詩篇 23:4|#psalm #comfort #courage #protection"
  "耶和華是我的亮光，是我的拯救，我還怕誰呢？|詩篇 27:1|#psalm #light #salvation #courage"
  "但你耶和華是我四圍的盾牌，是我的榮耀，又是叫我抬起頭來的。|詩篇 3:3|#psalm #comfort #protection"
  "耶和華靠近傷心的人，拯救靈性痛悔的人。|詩篇 34:18|#psalm #comfort #mercy"
  "你要把你的重擔卸給耶和華，他必撫養你；他永不叫義人動搖。|詩篇 55:22|#psalm #comfort #trust"
  "當將你的事交託耶和華，並倚靠他，他就必成全。|詩篇 37:5|#psalm #trust #guidance"
  "神是我們的避難所，是我們的力量，是我們在患難中隨時的幫助。|詩篇 46:1|#psalm #comfort #strength #protection"
  "你們要休息，要知道我是神。|詩篇 46:10|#psalm #rest #peace #trust"
  "你的話是我腳前的燈，是我路上的光。|詩篇 119:105|#psalm #light #guidance #truth"
  "我要向山舉目；我的幫助從何而來？我的幫助從造天地的耶和華而來。|詩篇 121:1-2|#psalm #comfort #protection"
  "他醫好傷心的人，裹好他們的傷處。|詩篇 147:3|#psalm #comfort #healing"
  "凡有氣息的都要讚美耶和華！|詩篇 150:6|#psalm #praise #joy"

  # ── 箴言 ──
  "敬畏耶和華是知識的開端。|箴言 1:7|#wisdom #fear-of-god"
  "你要專心仰賴耶和華，不可倚靠自己的聰明。|箴言 3:5|#wisdom #trust"
  "在你一切所行的事上都要認定他，他必指引你的路。|箴言 3:6|#wisdom #guidance"
  "義人的路好像黎明的光，越照越明，直到日午。|箴言 4:18|#light #holiness #hope"
  "回答柔和，使怒消退；言語暴戾，觸動怒氣。|箴言 15:1|#tongue #patience #peace"
  "人心籌算自己的道路；惟耶和華指引他的腳步。|箴言 16:9|#guidance #trust"
  "朋友乃時常親愛，弟兄為患難而生。|箴言 17:17|#friendship #love"
  "人有見識就不輕易發怒；寬恕人的過失便是自己的榮耀。|箴言 19:11|#patience #mercy #forgiveness"

  # ── 傳道書 ──
  "凡事都有定期，天下萬務都有定時。|傳道書 3:1|#wisdom #patience"
  "虛空的虛空，虛空的虛空，凡事都是虛空。|傳道書 1:2|#wisdom #truth"

  # ── 以賽亞書 ──
  "你們得救在乎歸回安息；你們得力在乎平靜安穩。|以賽亞書 30:15|#rest #strength #trust"
  "疲乏的，他賜能力；軟弱的，他加力量。|以賽亞書 40:29|#strength #comfort"
  "但那等候耶和華的必從新得力。|以賽亞書 40:31|#strength #hope #wait"
  "他們必如鷹展翅上騰；他們奔跑卻不困倦，行走卻不疲乏。|以賽亞書 40:31|#strength #hope #wait"
  "你不要害怕，因為我與你同在；不要驚惶，因為我是你的神。|以賽亞書 41:10|#comfort #courage #promise"
  "你從水中經過，我必與你同在；你趟過江河，水必不漫過你。|以賽亞書 43:2|#comfort #protection #promise"

  # ── 耶利米書 ──
  "我知道我向你們所懷的意念是賜平安的意念，不是降災禍的意念，要叫你們末後有指望。|耶利米書 29:11|#hope #peace #promise"
  "你的話是我心中的歡喜快樂，因我是稱為你名下的人。|耶利米書 15:16|#joy #truth #identity"

  # ── 耶利米哀歌 ──
  "我們不至消滅，是出於耶和華諸般的慈愛；是因他的憐憫不致斷絕。每早晨這都是新的；你的誠實極其廣大！|耶利米哀歌 3:22-23|#comfort #mercy #hope"

  # ── 彌迦書 ──
  "行公義，好憐憫，存謙卑的心，與你的神同行。|彌迦書 6:8|#justice #mercy #humility"

  # ── 那鴻書 ──
  "耶和華本為善，在患難的日子為人的保障，並且認得那些投靠他的人。|那鴻書 1:7|#comfort #protection"

  # ── 西番雅書 ──
  "耶和華你的神是施行拯救、大有能力的主。他在你中間必因你歡欣喜樂，默然愛你，且因你喜樂而歡呼。|西番雅書 3:17|#comfort #love #joy #salvation"

  # ── 馬太福音 ──
  "虛心的人有福了！因為天國是他們的。|馬太福音 5:3|#kingdom #humility"
  "哀慟的人有福了！因為他們必得安慰。|馬太福音 5:4|#comfort #kingdom"
  "你們是世上的鹽。|馬太福音 5:13|#discipleship #identity"
  "你們是世上的光。|馬太福音 5:14|#light #discipleship #identity"
  "你們要先求他的國和他的義，這些東西都要加給你們了。|馬太福音 6:33|#kingdom #provision #faith"
  "不要為明天憂慮，因為明天自有明天的憂慮。|馬太福音 6:34|#comfort #trust #peace"
  "凡勞苦擔重擔的人可以到我這裡來，我就使你們得安息。|馬太福音 11:28|#comfort #rest"
  "在人這是不能的，在神凡事都能。|馬太福音 19:26|#faith #strength"
  "你們要去，使萬民作我的門徒。|馬太福音 28:19|#gospel #discipleship"
  "我就常與你們同在，直到世界的末了。|馬太福音 28:20|#comfort #promise #discipleship"

  # ── 馬可福音 ──
  "在信的人，凡事都能。|馬可福音 9:23|#faith"

  # ── 路加福音 ──
  "在神凡事都能。|路加福音 1:37|#faith #promise"
  "你們要給人，就必有給你們的。|路加福音 6:38|#generosity #blessing"

  # ── 約翰福音 ──
  "神愛世人，甚至將他的獨生子賜給他們。|約翰福音 3:16|#gospel #love #salvation"
  "叫一切信他的，不至滅亡，反得永生。|約翰福音 3:16|#gospel #faith #eternal-life"
  "我就是生命的糧。|約翰福音 6:35|#gospel #provision"
  "我是世界的光。跟從我的，就不在黑暗裡走。|約翰福音 8:12|#gospel #light"
  "我來了，是要叫羊得生命，並且得的更豐盛。|約翰福音 10:10|#gospel #eternal-life"
  "我就是道路、真理、生命。|約翰福音 14:6|#gospel #truth #salvation"
  "你們心裡不要憂愁；你們信神，也當信我。|約翰福音 14:1|#comfort #faith #trust"
  "我留下平安給你們；我將我的平安賜給你們。|約翰福音 14:27|#peace #comfort"
  "我是葡萄樹，你們是枝子。|約翰福音 15:5|#discipleship #identity"
  "我將這些事告訴你們，是要叫你們在我裡面有平安。在世上你們有苦難；但你們可以放心，我已經勝了世界。|約翰福音 16:33|#peace #comfort #victory"

  # ── 使徒行傳 ──
  "施比受更為有福。|使徒行傳 20:35|#generosity #blessing"

  # ── 羅馬書 ──
  "我們曉得萬事都互相效力，叫愛神的人得益處。|羅馬書 8:28|#promise #love #hope"
  "是高處的，是低處的，是別的受造之物，都不能叫我們與神的愛隔絕；這愛是在我們的主基督耶穌裡的。|羅馬書 8:38-39|#comfort #love #promise"
  "不要效法這個世界，只要心意更新而變化。|羅馬書 12:2|#holiness #obedience"
  "在指望中要喜樂，在患難中要忍耐，禱告要恆切。|羅馬書 12:12|#hope #patience #prayer"

  # ── 哥林多前書 ──
  "愛是恆久忍耐，又有恩慈；愛是不嫉妒。|哥林多前書 13:4|#love #patience"
  "如今常存的有信，有望，有愛；這三樣，其中最大的是愛。|哥林多前書 13:13|#love #faith #hope"

  # ── 哥林多後書 ──
  "願頌讚歸與我們的主耶穌基督的父神，就是發慈悲的父，賜各樣安慰的神。我們在一切患難中，他就安慰我們。|哥林多後書 1:3-4|#comfort #mercy"
  "我的恩典夠你用的，因為我的能力是在人的軟弱上顯得完全。|哥林多後書 12:9|#grace #strength #comfort"

  # ── 加拉太書 ──
  "聖靈所結的果子，就是仁愛、喜樂、和平、忍耐、恩慈、良善、信實、溫柔、節制。|加拉太書 5:22-23|#joy #love #peace #holiness"

  # ── 以弗所書 ──
  "你們得救是本乎恩，也因著信。|以弗所書 2:8|#grace #salvation #faith"
  "我們原是他的工作，在基督耶穌裡造成的。|以弗所書 2:10|#identity #work"

  # ── 腓立比書 ──
  "應當一無掛慮，只要凡事藉著禱告、祈求和感謝，將你們所要的告訴神。|腓立比書 4:6|#prayer #thanksgiving #peace"
  "神所賜、出人意外的平安，必在基督耶穌裡保守你們的心懷意念。|腓立比書 4:7|#peace #comfort #protection"
  "我靠著那加給我力量的，凡事都能做。|腓立比書 4:13|#strength #faith"

  # ── 歌羅西書 ──
  "無論做什麼，都要從心裡做，像是給主做的，不是給人做的。|歌羅西書 3:23|#work #obedience"

  # ── 帖撒羅尼迦前書 ──
  "要常常喜樂，不住地禱告，凡事謝恩。|帖撒羅尼迦前書 5:16-18|#joy #prayer #thanksgiving"

  # ── 提摩太後書 ──
  "神賜給我們，不是膽怯的心，乃是剛強、仁愛、謹守的心。|提摩太後書 1:7|#courage #love #strength"

  # ── 希伯來書 ──
  "信就是所望之事的實底，是未見之事的確據。|希伯來書 11:1|#faith #hope"
  "主是幫助我的，我必不懼怕。|希伯來書 13:6|#courage #trust #comfort"
  "耶穌基督昨日、今日、一直到永遠，是一樣的。|希伯來書 13:8|#promise #trust"

  # ── 雅各書 ──
  "你們要親近神，神就必親近你們。|雅各書 4:8|#prayer #holiness"
  "務要在主面前自卑，主就必叫你們升高。|雅各書 4:10|#humility #promise"

  # ── 彼得前書 ──
  "你們要將一切的憂慮卸給神，因為他顧念你們。|彼得前書 5:7|#comfort #trust"

  # ── 約翰一書 ──
  "神就是愛；住在愛裡面的，就是住在神裡面，神也住在他裡面。|約翰一書 4:16|#love #identity"
  "愛裡沒有懼怕；愛既完全，就把懼怕除去。|約翰一書 4:18|#love #comfort #courage"
  "我們若認自己的罪，神是信實的，是公義的，必要赦免我們的罪。|約翰一書 1:9|#forgiveness #repentance #grace"

  # ── 啟示錄 ──
  "神要擦去他們一切的眼淚；不再有死亡，也不再有悲哀、哭號、疼痛。|啟示錄 21:4|#comfort #eternal-life #hope"
  "看哪，我必快來！|啟示錄 22:12|#promise #kingdom"
  "我是阿拉法，我是俄梅戛；我是首先的，我是末後的。|啟示錄 22:13|#eternal-life #kingdom #truth"
)
