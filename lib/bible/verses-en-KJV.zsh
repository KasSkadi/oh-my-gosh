# ─────────────────────────────────────────────
#  verses-en-KJV.zsh — King James Version (1611)
#  Public domain in most jurisdictions.
#  Format: "verse|reference|#tag #tag"
# ─────────────────────────────────────────────

typeset -ga GOSH_VERSES=(
  # ── Genesis ──
  "In the beginning God created the heaven and the earth.|Genesis 1:1|#creation #truth"
  "And God said, Let there be light: and there was light.|Genesis 1:3|#creation #light"
  "So God created man in his own image, in the image of God created he him.|Genesis 1:27|#creation #identity"
  "I will bless thee, and thou shalt be a blessing.|Genesis 12:2|#blessing #promise"

  # ── Exodus ──
  "I am the LORD thy God, which have brought thee out of the land of Egypt, out of the house of bondage.|Exodus 20:2|#law #salvation"
  "The LORD is a man of war: the LORD is his name.|Exodus 15:3|#victory #strength"

  # ── Numbers ──
  "The LORD bless thee, and keep thee.|Numbers 6:24|#blessing #protection"
  "The LORD make his face shine upon thee, and be gracious unto thee.|Numbers 6:25|#blessing #grace #light"
  "The LORD lift up his countenance upon thee, and give thee peace.|Numbers 6:26|#blessing #peace"

  # ── Deuteronomy ──
  "And thou shalt love the LORD thy God with all thine heart, and with all thy soul, and with all thy might.|Deuteronomy 6:5|#love #obedience"
  "Man doth not live by bread only, but by every word that proceedeth out of the mouth of the LORD doth man live.|Deuteronomy 8:3|#provision #truth"

  # ── Joshua ──
  "Be strong and of a good courage; be not afraid, neither be thou dismayed: for the LORD thy God is with thee whithersoever thou goest.|Joshua 1:9|#courage #comfort #promise"

  # ── 1 Samuel ──
  "The LORD seeth not as man seeth; for man looketh on the outward appearance, but the LORD looketh on the heart.|1 Samuel 16:7|#identity #truth"

  # ── Psalms ──
  "Blessed is the man that walketh not in the counsel of the ungodly.|Psalms 1:1|#psalm #holiness"
  "The LORD is my shepherd; I shall not want.|Psalms 23:1|#psalm #shepherd #provision #trust"
  "He maketh me to lie down in green pastures: he leadeth me beside the still waters.|Psalms 23:2|#psalm #rest #provision"
  "Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me.|Psalms 23:4|#psalm #comfort #courage #protection"
  "The LORD is my light and my salvation; whom shall I fear?|Psalms 27:1|#psalm #light #salvation #courage"
  "But thou, O LORD, art a shield for me; my glory, and the lifter up of mine head.|Psalms 3:3|#psalm #comfort #protection"
  "The LORD is nigh unto them that are of a broken heart; and saveth such as be of a contrite spirit.|Psalms 34:18|#psalm #comfort #mercy"
  "Cast thy burden upon the LORD, and he shall sustain thee.|Psalms 55:22|#psalm #comfort #trust"
  "Commit thy way unto the LORD; trust also in him; and he shall bring it to pass.|Psalms 37:5|#psalm #trust #guidance"
  "God is our refuge and strength, a very present help in trouble.|Psalms 46:1|#psalm #comfort #strength #protection"
  "Be still, and know that I am God.|Psalms 46:10|#psalm #rest #peace #trust"
  "Thy word is a lamp unto my feet, and a light unto my path.|Psalms 119:105|#psalm #light #guidance #truth"
  "I will lift up mine eyes unto the hills, from whence cometh my help. My help cometh from the LORD, which made heaven and earth.|Psalms 121:1-2|#psalm #comfort #protection"
  "He healeth the broken in heart, and bindeth up their wounds.|Psalms 147:3|#psalm #comfort #healing"
  "Let every thing that hath breath praise the LORD. Praise ye the LORD.|Psalms 150:6|#psalm #praise #joy"

  # ── Proverbs ──
  "The fear of the LORD is the beginning of knowledge.|Proverbs 1:7|#wisdom #fear-of-god"
  "Trust in the LORD with all thine heart; and lean not unto thine own understanding.|Proverbs 3:5|#wisdom #trust"
  "In all thy ways acknowledge him, and he shall direct thy paths.|Proverbs 3:6|#wisdom #guidance"
  "But the path of the just is as the shining light, that shineth more and more unto the perfect day.|Proverbs 4:18|#light #holiness #hope"
  "A soft answer turneth away wrath: but grievous words stir up anger.|Proverbs 15:1|#tongue #patience #peace"
  "A man's heart deviseth his way: but the LORD directeth his steps.|Proverbs 16:9|#guidance #trust"
  "A friend loveth at all times, and a brother is born for adversity.|Proverbs 17:17|#friendship #love"
  "It is his glory to pass over a transgression.|Proverbs 19:11|#patience #mercy #forgiveness"

  # ── Ecclesiastes ──
  "To every thing there is a season, and a time to every purpose under the heaven.|Ecclesiastes 3:1|#wisdom #patience"
  "Vanity of vanities, saith the Preacher, vanity of vanities; all is vanity.|Ecclesiastes 1:2|#wisdom #truth"

  # ── Isaiah ──
  "In quietness and in confidence shall be your strength.|Isaiah 30:15|#rest #strength #trust"
  "He giveth power to the faint; and to them that have no might he increaseth strength.|Isaiah 40:29|#strength #comfort"
  "But they that wait upon the LORD shall renew their strength.|Isaiah 40:31|#strength #hope #wait"
  "They shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint.|Isaiah 40:31|#strength #hope #wait"
  "Fear thou not; for I am with thee: be not dismayed; for I am thy God.|Isaiah 41:10|#comfort #courage #promise"
  "When thou passest through the waters, I will be with thee; and through the rivers, they shall not overflow thee.|Isaiah 43:2|#comfort #protection #promise"

  # ── Jeremiah ──
  "For I know the thoughts that I think toward you, saith the LORD, thoughts of peace, and not of evil, to give you an expected end.|Jeremiah 29:11|#hope #peace #promise"
  "Thy word was unto me the joy and rejoicing of mine heart.|Jeremiah 15:16|#joy #truth #identity"

  # ── Lamentations ──
  "It is of the LORD's mercies that we are not consumed, because his compassions fail not. They are new every morning: great is thy faithfulness.|Lamentations 3:22-23|#comfort #mercy #hope"

  # ── Micah ──
  "What doth the LORD require of thee, but to do justly, and to love mercy, and to walk humbly with thy God?|Micah 6:8|#justice #mercy #humility"

  # ── Nahum ──
  "The LORD is good, a strong hold in the day of trouble; and he knoweth them that trust in him.|Nahum 1:7|#comfort #protection"

  # ── Zephaniah ──
  "The LORD thy God in the midst of thee is mighty; he will save, he will rejoice over thee with joy; he will rest in his love, he will joy over thee with singing.|Zephaniah 3:17|#comfort #love #joy #salvation"

  # ── Matthew ──
  "Blessed are the poor in spirit: for theirs is the kingdom of heaven.|Matthew 5:3|#kingdom #humility"
  "Blessed are they that mourn: for they shall be comforted.|Matthew 5:4|#comfort #kingdom"
  "Ye are the salt of the earth.|Matthew 5:13|#discipleship #identity"
  "Ye are the light of the world. A city that is set on an hill cannot be hid.|Matthew 5:14|#light #discipleship #identity"
  "But seek ye first the kingdom of God, and his righteousness; and all these things shall be added unto you.|Matthew 6:33|#kingdom #provision #faith"
  "Take therefore no thought for the morrow: for the morrow shall take thought for the things of itself.|Matthew 6:34|#comfort #trust #peace"
  "Come unto me, all ye that labour and are heavy laden, and I will give you rest.|Matthew 11:28|#comfort #rest"
  "With men this is impossible; but with God all things are possible.|Matthew 19:26|#faith #strength"
  "Go ye therefore, and teach all nations, baptizing them in the name of the Father, and of the Son, and of the Holy Ghost.|Matthew 28:19|#gospel #discipleship"
  "Lo, I am with you alway, even unto the end of the world.|Matthew 28:20|#comfort #promise #discipleship"

  # ── Mark ──
  "Jesus said unto him, If thou canst believe, all things are possible to him that believeth.|Mark 9:23|#faith"

  # ── Luke ──
  "For with God nothing shall be impossible.|Luke 1:37|#faith #promise"
  "Give, and it shall be given unto you; good measure, pressed down, and shaken together, and running over.|Luke 6:38|#generosity #blessing"

  # ── John ──
  "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.|John 3:16|#gospel #love #salvation #eternal-life #faith"
  "I am the bread of life: he that cometh to me shall never hunger.|John 6:35|#gospel #provision"
  "I am the light of the world: he that followeth me shall not walk in darkness, but shall have the light of life.|John 8:12|#gospel #light"
  "I am come that they might have life, and that they might have it more abundantly.|John 10:10|#gospel #eternal-life"
  "Jesus saith unto him, I am the way, the truth, and the life.|John 14:6|#gospel #truth #salvation"
  "Let not your heart be troubled: ye believe in God, believe also in me.|John 14:1|#comfort #faith #trust"
  "Peace I leave with you, my peace I give unto you: let not your heart be troubled, neither let it be afraid.|John 14:27|#peace #comfort"
  "I am the vine, ye are the branches.|John 15:5|#discipleship #identity"
  "These things I have spoken unto you, that in me ye might have peace. In the world ye shall have tribulation: but be of good cheer; I have overcome the world.|John 16:33|#peace #comfort #victory"

  # ── Acts ──
  "It is more blessed to give than to receive.|Acts 20:35|#generosity #blessing"

  # ── Romans ──
  "And we know that all things work together for good to them that love God, to them who are the called according to his purpose.|Romans 8:28|#promise #love #hope"
  "Neither height, nor depth, nor any other creature, shall be able to separate us from the love of God, which is in Christ Jesus our Lord.|Romans 8:38-39|#comfort #love #promise"
  "Be not conformed to this world: but be ye transformed by the renewing of your mind.|Romans 12:2|#holiness #obedience"
  "Rejoicing in hope; patient in tribulation; continuing instant in prayer.|Romans 12:12|#hope #patience #prayer"

  # ── 1 Corinthians ──
  "Charity suffereth long, and is kind; charity envieth not; charity vaunteth not itself, is not puffed up.|1 Corinthians 13:4|#love #patience"
  "And now abideth faith, hope, charity, these three; but the greatest of these is charity.|1 Corinthians 13:13|#love #faith #hope"

  # ── 2 Corinthians ──
  "Blessed be God, the Father of mercies, and the God of all comfort; who comforteth us in all our tribulation.|2 Corinthians 1:3-4|#comfort #mercy"
  "My grace is sufficient for thee: for my strength is made perfect in weakness.|2 Corinthians 12:9|#grace #strength #comfort"

  # ── Galatians ──
  "The fruit of the Spirit is love, joy, peace, longsuffering, gentleness, goodness, faith, meekness, temperance.|Galatians 5:22-23|#joy #love #peace #holiness"

  # ── Ephesians ──
  "For by grace are ye saved through faith; and that not of yourselves: it is the gift of God.|Ephesians 2:8|#grace #salvation #faith"
  "For we are his workmanship, created in Christ Jesus unto good works.|Ephesians 2:10|#identity #work"

  # ── Philippians ──
  "Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God.|Philippians 4:6|#prayer #thanksgiving #peace"
  "And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.|Philippians 4:7|#peace #comfort #protection"
  "I can do all things through Christ which strengtheneth me.|Philippians 4:13|#strength #faith"

  # ── Colossians ──
  "And whatsoever ye do, do it heartily, as to the Lord, and not unto men.|Colossians 3:23|#work #obedience"

  # ── 1 Thessalonians ──
  "Rejoice evermore. Pray without ceasing. In every thing give thanks: for this is the will of God in Christ Jesus concerning you.|1 Thessalonians 5:16-18|#joy #prayer #thanksgiving"

  # ── 2 Timothy ──
  "For God hath not given us the spirit of fear; but of power, and of love, and of a sound mind.|2 Timothy 1:7|#courage #love #strength"

  # ── Hebrews ──
  "Now faith is the substance of things hoped for, the evidence of things not seen.|Hebrews 11:1|#faith #hope"
  "So that we may boldly say, The Lord is my helper, and I will not fear what man shall do unto me.|Hebrews 13:6|#courage #trust #comfort"
  "Jesus Christ the same yesterday, and to day, and for ever.|Hebrews 13:8|#promise #trust"

  # ── James ──
  "Draw nigh to God, and he will draw nigh to you.|James 4:8|#prayer #holiness"
  "Humble yourselves in the sight of the Lord, and he shall lift you up.|James 4:10|#humility #promise"

  # ── 1 Peter ──
  "Casting all your care upon him; for he careth for you.|1 Peter 5:7|#comfort #trust"

  # ── 1 John ──
  "God is love; and he that dwelleth in love dwelleth in God, and God in him.|1 John 4:16|#love #identity"
  "There is no fear in love; but perfect love casteth out fear.|1 John 4:18|#love #comfort #courage"
  "If we confess our sins, he is faithful and just to forgive us our sins, and to cleanse us from all unrighteousness.|1 John 1:9|#forgiveness #repentance #grace"

  # ── Revelation ──
  "And God shall wipe away all tears from their eyes; and there shall be no more death, neither sorrow, nor crying, neither shall there be any more pain.|Revelation 21:4|#comfort #eternal-life #hope"
  "And, behold, I come quickly; and my reward is with me.|Revelation 22:12|#promise #kingdom"
  "I am Alpha and Omega, the beginning and the end, the first and the last.|Revelation 22:13|#eternal-life #kingdom #truth"
)
