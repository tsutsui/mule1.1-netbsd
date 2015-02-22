;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).
;; This file contains Chinese characters.

;; Mule is free software distributed in the form of patches to GNU Emacs.
;; You can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.

;; Mule is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;; 92.3.6   Written for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;	Original table is from cxterm/dict/tit/SW.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	GB
;; MULTICHOICE:	YES
;; PROMPT:	汉字输入∷首尾∷ 
;; #
;; COMMENT	(源于 CCDOS)
;; COMMENT	书写该汉字时的「首笔」及「尾笔」。例如，【吕】首尾笔皆为「口」，故在
;; COMMENT 「首尾」模式中用 ff0 三键输入。（ f 键在「首尾」模式中表示「口」）
;; # define keys
;; VALIDINPUTKEY:	abcdefghijklmnopqrstuvwxyz
;; SELECTKEY:	1\040
;; SELECTKEY:	2
;; SELECTKEY:	3
;; SELECTKEY:	4
;; SELECTKEY:	5
;; SELECTKEY:	6
;; SELECTKEY:	7
;; SELECTKEY:	8
;; SELECTKEY:	9
;; SELECTKEY:	0
;; BACKSPACE:	\010\177
;; DELETEALL:	\015\025
;; MOVERIGHT:	.>
;; MOVELEFT:	,<
;; REPEATKEY:	\020\022
;; KEYPROMPT(a):	心又
;; KEYPROMPT(b):	冖山
;; KEYPROMPT(c):	尸土
;; KEYPROMPT(d):	丶刀
;; KEYPROMPT(e):	火阝
;; KEYPROMPT(f):	口口
;; KEYPROMPT(g):	扌衣
;; KEYPROMPT(h):	氵疋
;; KEYPROMPT(i):	讠大
;; KEYPROMPT(j):	艹丁
;; KEYPROMPT(k):	亻厶
;; KEYPROMPT(l):	木灬
;; KEYPROMPT(m):	礻十
;; KEYPROMPT(n):	饣歹
;; KEYPROMPT(o):	月冂
;; KEYPROMPT(p):	纟门
;; KEYPROMPT(q):	石今
;; KEYPROMPT(r):	王丨
;; KEYPROMPT(s):	八女
;; KEYPROMPT(t):	丿乙
;; KEYPROMPT(u):	日囗
;; KEYPROMPT(v):	辶小
;; KEYPROMPT(w):	犭厂
;; KEYPROMPT(x):	竹虫
;; KEYPROMPT(y):	一弋
;; KEYPROMPT(z):	人卜
;; # the following line must not be removed
;; BEGINDICTIONARY
;; #

(require 'quail)

(quail-define-package
 "sw" "首尾"
 '((?a . "心") (?b . "冖") (?c . "尸") (?d . "丶") (?e . "火") (?f . "口")
   (?g . "扌") (?h . "氵") (?i . "讠") (?j . "艹") (?k . "亻") (?l . "木") 
   (?m . "礻") (?n . "饣") (?o . "月") (?p . "纟") (?q . "石") (?r . "王")
   (?s . "八") (?t . "丿") (?u . "日") (?v . "辶") (?w . "犭") (?x . "竹")
   (?y . "一") (?z . "人"))
 "汉字输入∷首尾∷ 

	(源于 CCDOS)
	书写该汉字时的「首笔」及「尾笔」。例如，【吕】首尾笔皆为「口」，故在
 「首尾」模式中用 ff0 三键输入。（ f 键在「首尾」模式中表示「口」）"
 *quail-mode-rich-map* nil nil nil nil t)

(defmacro qdl (key str)
  (list 'quail-defrule key (list 'string-to-char-list str)))

(qdl "aa" "\
叉憾慢慑双心又忄忮悛\
惚愎怼")
(qdl "ac" "\
懂怪难圣惟惺性悭悝憧")
(qdl "ad" "\
怖鸡怜劝惕忉怫恸恂悌\
愕愣")
(qdl "ae" "\
邓恢愀")
(qdl "af" "\
惦恰恬悟怙怊怡恪")
(qdl "ag" "\
恨艰怅")
(qdl "ah" "\
憷")
(qdl "ai" "\
懊快怏恹")
(qdl "aj" "\
对悸恃愉忖恻悖")
(qdl "ak" "\
怯忪")
(qdl "al" "\
桑怵憔")
(qdl "am" "\
惮悼悍懈忏忤怦怿恽悻\
悴")
(qdl "ao" "\
恫惰恼懦悄情怄惬惝惘\
惆惴慵")
(qdl "ap" "\
悯")
(qdl "ar" "\
惭惶忻忡")
(qdl "as" "\
惧慎")
(qdl "at" "\
必惨忱观慌恍慨愧惋忆\
忧悦怃怆怩恺悒")
(qdl "au" "\
悔怕惜憎悃慊懵")
(qdl "av" "\
怀惊慷悚愫憬懔")
(qdl "ax" "\
蚤")
(qdl "ay" "\
叠恒忙戏恤怔忾忸怛愠")
(qdl "az" "\
愤惯欢懒忭怍悱愦颡")
(qdl "ba" "\
寂峻寝岐崽宓皲")
(qdl "bb" "\
出窟密山窑冖崛")
(qdl "bc" "\
崔窿塞室堂崖窒")
(qdl "bd" "\
常寡寒鹤帘岭幂窍窃穷\
写屿岣峋崂骞鸩穹窈")
(qdl "be" "\
炭灾郓峁")
(qdl "bf" "\
宫官害豁家窖窘客容峪\
冢喾岵寤謇")
(qdl "bg" "\
农裳宸褰寰")
(qdl "bh" "\
定嶷蹇")
(qdl "bi" "\
寞实突峡窦")
(qdl "bj" "\
穿割寄宁崎守学宇掌峙\
字刿剀剜岈岢峥崞嵛搴\
窬")
(qdl "bk" "\
尝宏崧嵫")
(qdl "bl" "\
案寐宋棠寨崃嵘窠粜")
(qdl "bm" "\
岸峰罕军牢宰岍峄嶂嶙")
(qdl "bn" "\
岁穸")
(qdl "bo" "\
崩岗宦岿峭窝宵寓岌岖\
岚峒崤嵩嵴宥甯")
(qdl "bq" "\
岩岑宕")
(qdl "br" "\
宝窜审崭岬峤屮")
(qdl "bs" "\
安宾穴宴寅黉冥崾嵝窭")
(qdl "bt" "\
宠党冠究觉凯寇宽窥寥\
岂冗它完宛巍宪屹冤宅\
屺岘岜崦嵬宄觊窀窕")
(qdl "bu" "\
窗富宿宙岫崮嵋窆窨窳")
(qdl "bv" "\
察崇祟宗岽嵊寮泶")
(qdl "bx" "\
蜜蚩")
(qdl "by" "\
峨空宣宜岷崆崴嵯嶝鲎")
(qdl "bz" "\
额嵌赛赏窄巅颛")
(qdl "ca" "\
殿鼓慧履麦坡慰志坂埝\
墁懿屐彀毂觳恝恚悫赧")
(qdl "cb" "\
击屈堀罄")
(qdl "cc" "\
壁堆雇圭埋声尸士土屋\
垆垤堙耋")
(qdl "cd" "\
场赤坊房赫劫尽局均考\
垮耪劈韧扇塌韦坞圬坜\
坳埸埽塄骜鹛耢翥翩麴")
(qdl "ce" "\
都郝却熨")
(qdl "cf" "\
垢壕吉嘉居培譬启塔塘\
喜坫耜耠謦")
(qdl "cg" "\
表壤袁展垠襞")
(qdl "ch" "\
超趁堤靛赴赶起趋趣趟\
越赵走屣赳趄趔趑趱")
(qdl "ci" "\
埃块契堠獒戾麸")
(qdl "cj" "\
封静剧坷刷寺尉孝圩埘\
埒屙孱挈擘耔耨")
(qdl "ck" "\
层去坛耘")
(qdl "cl" "\
熬垛末屎未煮堞墚檗熹\
耒")
(qdl "cm" "\
辟埠丰耕坪屏犀幸肇埤\
墀鼙羼戽聱")
(qdl "cn" "\
鏊鐾")
(qdl "co" "\
敖臂扁墩坟埂圾肩教埔\
青墒赦属坍臀屑堰垌垧\
垴埚堋塥墉彗扃耥耦耩")
(qdl "cq" "\
砉磬耱")
(qdl "cr" "\
坤圳圻埕璧")
(qdl "cs" "\
屡填屦嫠嬖耧")
(qdl "ct" "\
耙地耗境壳坑老尼彭屁\
尾艳圪圮圯垅坨坭垲垸\
埯堍尻甏甓觌耄扈耖靓")
(qdl "cu" "\
尺毒堵届眉墙屠增者坩\
坶馨咫韬耆瞽赭")
(qdl "cv" "\
坏尿素埏埭塬綮纛")
(qdl "cw" "\
圹")
(qdl "cx" "\
螯螫")
(qdl "cy" "\
城壶堪垃坯坦屉墟盐壹\
域垣址昼坻垭埴韫盍鳌")
(qdl "cz" "\
坝坎款责赘卦坼垓埙扉\
颉")
(qdl "da" "\
变憋竣恋凌叛敲忍忘意\
毅恣憝戆")
(qdl "db" "\
峦宀籼")
(qdl "dc" "\
翟户童耀雍壮准塾壅旌")
(qdl "dd" "\
帝方粉冯冷旁券刃市弯\
为亦羽韵丶冫劭劾於旆\
鸾鹑鹨鹫翊粝粼")
(qdl "de" "\
部郭郊郎那邵邙邡鄣")
(qdl "df" "\
豪豢吝韶司糖誊言冶誉\
粘站召咨啻")
(qdl "dg" "\
哀褒裹粮良旅衰襄衣衷\
装衮袤亵裒饔")
(qdl "dh" "\
凝旋蹩")
(qdl "di" "\
凑奖决类头状族奕糇糗")
(qdl "dj" "\
亨剂将净刻刘挛孪判剖\
拳亭享削籽冽旖")
(qdl "dk" "\
玄凇糍")
(qdl "dl" "\
糕桨米烹亲熟栾桊粢糅")
(qdl "dm" "\
瓣半弊辨辩辫粹翠斗辉\
举料率弃辛章卒弈羿")
(qdl "dn" "\
銮")
(qdl "do" "\
敝敞当凋端敦放高膏糊\
交精粳靖朗离糯商尚数\
文肖效夜裔义育斋脔肓\
膂飒旃敉糈")
(qdl "dp" "\
斓")
(qdl "dr" "\
冲齐望新丫州主丬齑")
(qdl "ds" "\
粪六娄凄旗妄兴翼妆姿\
妾娈")
(qdl "dt" "\
充瓷刀刁光毫竟竞就卷\
亢况亮施习彦赢彰兖亳\
嬴蠃羸冼瓿氅旄旎旒粑\
糁")
(qdl "du" "\
酱竭眷盲亩瞥粕瓤畜音\
糟之昶粞糌")
(qdl "dv" "\
冰糙冻浆京糠辣凉凛紊\
永禀竦粽")
(qdl "dw" "\
产广疒")
(qdl "dx" "\
蛮糨")
(qdl "dy" "\
鳖斌戳粗盗减立粒戮氓\
孰亡卫翌亠冱鲞")
(qdl "dz" "\
卞颤次赣亥颜资歆颃颏")
(qdl "ea" "\
陵熄隐阪陂陬燮煅熳")
(qdl "eb" "\
灿陆")
(qdl "ec" "\
陛堕隆炉灶坠陧陲")
(qdl "ed" "\
防烬烤煽陶烯灼骘炀炜")
(qdl "ee" "\
火炎卩阝郯焱")
(qdl "ef" "\
焙烙陪熔阽焐焓")
(qdl "eg" "\
限隈煨")
(qdl "eh" "\
陡")
(qdl "ei" "\
焕炔陕燠")
(qdl "ej" "\
阿灯附剡烀爝")
(qdl "ek" "\
烩炫")
(qdl "el" "\
除煤燃燥隰")
(qdl "em" "\
烽焊降障阵阡阱陴烨烊\
焯")
(qdl "eo" "\
炳隔炯炬隋阴隅煳煸熵")
(qdl "ep" "\
焖")
(qdl "eq" "\
炻")
(qdl "er" "\
煌阶隍炷")
(qdl "es" "\
炽烘")
(qdl "et" "\
炒炕陇炮阮烧陀烷院阢\
陟隗炖炝")
(qdl "eu" "\
陌陷烟焰阳熘熠燔")
(qdl "ev" "\
爆陈际炼燎烁随隧隙隳\
煺燧")
(qdl "ex" "\
烛")
(qdl "ey" "\
隘烂陋烃险阻陉煜煊")
(qdl "ez" "\
炊队烦陨炸阼陔")
(qdl "fa" "\
跋唆叹吱吣呶唛唿啵啜\
嗖嗫嗄嗯嗳嘬噫跛跽踱\
蹑躞")
(qdl "fb" "\
咄嘧")
(qdl "fc" "\
哩吐唾哇唯唑喱喹喔噻\
嚯跬踵躔")
(qdl "fd" "\
叼吊吩号鹃跨另骂吗鸣\
嗣蹋踢蹄啼吻嗡呜勋哟\
叨叻呖呤咚呦哧唠唏啭\
啕嘞鹗鹭趵躅")
(qdl "fe" "\
鄙鄂哪郧郢叩咴唧啖啷\
啾嘟燹踯")
(qdl "ff" "\
咕哈嚎踞喀咖咯口路吕\
品器啥嘻嚣唁啄咭唔喏\
嗒喙噱囗豕跏跆踟踮踣")
(qdl "fg" "\
跟嚷喂哌哝哏囔踉饕")
(qdl "fh" "\
嚏足啶")
(qdl "fi" "\
唉跌吠喉唤哭吴嗅跃呋\
呔唳嗾噗噢趺蹊蹼")
(qdl "fj" "\
啊别踌叮蹲咐剐呵哼呼\
嚼喇哮呀吁喻咛咧唰嗬\
跗蹰")
(qdl "fk" "\
吆哙")
(qdl "fl" "\
踩呆跺嘿嘛嗓味躁噪咻\
哚咪啉喋嗪噍踝蹀蹂")
(qdl "fm" "\
哗啤叶哔咩哞唪啐嗥噼\
趼跸踔")
(qdl "fn" "\
哆哕嗲")
(qdl "fo" "\
哎蹦哺嘲喘距啃呐啮呕\
哨吸响咬踊嘱嘴呙咂哐\
哽啁唷喃喁喟嗷嗝嗍嘣\
嘀噙嚆嚅趿跚跤踹踽蹁\
蹒")
(qdl "fp" "\
躏")
(qdl "fq" "\
吟跖")
(qdl "fr" "\
呈蹿叫呻嘶听啸吖吲呷\
哜哳跻")
(qdl "fs" "\
叭哄趴只唼喽嗔嘤")
(qdl "ft" "\
吧吵吃吨跪吼唬吭咙呢\
咆跑呛吮跳兄邑咒叱叽\
吒呒呓呃吡哓呲咣咿咤\
唣嘭跄跎跷跣蹴黾鼍")
(qdl "fu" "\
蹭唱躇蹈噶喝啪嗜踏咽\
咱呱哂喵喈喑嗨嘈噜噌\
蹯")
(qdl "fv" "\
咏踪哒嗉嗦嗵嘌嘹噤嚓\
跞跹踺")
(qdl "fx" "\
虽嗤")
(qdl "fy" "\
蹬嘎喊践咀啦哦呸噬嘘\
喧哑噎喳趾咝嗟嗑嗌嘁\
噔戢蹉躐")
(qdl "fz" "\
吹啡咳喷嗽吓员咋卟呗\
咔咦唢啧噘颚踬蹶躜")
(qdl "ga" "\
拔搬扳报拨撮掇撼技攫\
捻披摄授搜投援摅摁")
(qdl "gb" "\
掘摇拙")
(qdl "gc" "\
捶摧挫垫挂护捏摊推握\
撞捱擢攉")
(qdl "gd" "\
扮搀捣拂拐拘拷挎捞拎\
掳扔势掏携扬抟拗掬搦\
鸷")
(qdl "ge" "\
揪挪抑掷揶")
(qdl "gf" "\
搭掂据扣括撂拈拾誓抬\
搪捂招哲拮捃掊掾")
(qdl "gg" "\
攘振扌搌擐攮")
(qdl "gh" "\
捷提捉踅")
(qdl "gi" "\
挨扶换抉摸挟揍捩揆")
(qdl "gj" "\
捌搏撑持打拧抒挣挚拊\
捋掎揄撙")
(qdl "gk" "\
摆")
(qdl "gl" "\
操搽抹热揉探揲搡摭")
(qdl "gm" "\
拌掸掉抖捍挥撵抨捧拼\
扦摔揖择拚捭摒擀擗")
(qdl "gn" "\
拶")
(qdl "go" "\
捕撤揣挡搞拒捐抠撇擒\
撒扫捎擞捅掖拥摘掮揠\
搠撖")
(qdl "gp" "\
搁扪")
(qdl "gq" "\
拓")
(qdl "gr" "\
挤拴撕押折拄抻挢撺擤")
(qdl "gs" "\
按扒摈拱接搂撰撄")
(qdl "gt" "\
把抱掺抄扼抚搅抗揽拢\
抡挠抛批抢撬扰挑拖托\
挖挽掩扎执挹搋")
(qdl "gu" "\
播插抽搐措揭揩捆擂描\
拇拍掐指抓掴揞搛摺撸")
(qdl "gv" "\
擦拣撩掠挞挺挝掭捺摞\
攥絷")
(qdl "gw" "\
扩")
(qdl "gx" "\
搔蛰蜇")
(qdl "gy" "\
扯搓担抵捡扛控拉拦抿\
扭擅拭找拯拽揸揎")
(qdl "gz" "\
拆撅拟排扑损掀攒掼揿\
撷贽")
(qdl "ha" "\
波渡汉浸浚滤漫没泌泼\
沁淑汊溲溆滠漶懑")
(qdl "hb" "\
汕")
(qdl "hc" "\
灌沪淮涅滩洼潍涯淫泸\
湮渥潼濉濯")
(qdl "hd" "\
渤沸汾沟鸿涝沥溺沛沏\
汤淘涕湾污泻淤滞沔沩\
泐泠洵浠溻滂瀚")
(qdl "he" "\
淡烫泖湫")
(qdl "hf" "\
涪沽浩活洁潞洛洽溶沿\
浴沾沼治洳浯涿涫溏澹\
濠")
(qdl "hg" "\
滚浪浓派涨裟")
(qdl "hh" "\
淀氵浞漩")
(qdl "hi" "\
澳涣漠汰沃溪泱浃渎溴\
濮")
(qdl "hj" "\
测淳浮河泞涛汀游渝洌\
浏浔涮湔溥溽滹漪澍潺\
挲")
(qdl "hk" "\
法滋泫泓浍淞")
(qdl "hl" "\
滁涤梁粱淋滦沫柒渠染\
深涂澡沐沭洙涞渫溱溧")
(qdl "hm" "\
淬洱汗浑津淖湃潭洋泽\
漳汁滓沣泮洚浒漭")
(qdl "hn" "\
汐淦滏鋈鎏")
(qdl "ho" "\
潮澈滴洞涵湖滑激汲漓\
漏满沤浦清溯淌湍渭涡\
消淆汹液涌汶洧涓潋澉\
潸潲濡瀹灞")
(qdl "hp" "\
涧澜润")
(qdl "hq" "\
涔")
(qdl "hr" "\
济渐汪沂渊浙洲注淅淠\
渖湟滢潇澌濞")
(qdl "hs" "\
滨滇洪婆汝演浜淇溟潢\
漤瀵娑")
(qdl "ht" "\
沧沉池溉港混浇流沦渺\
泥泡澎沙涉沈渗洗淹汔\
汜沅沌沆泷沲沱洮浼浣\
渑淝滟滗漉瀛")
(qdl "hu" "\
泊泛海涸酒渴泪溜潘潜\
泅洒滔湘油淄汨汩泔泗\
洇洄洎涠渚湎湄溷漕潴\
濂")
(qdl "hv" "\
涟潦漂瀑漆添涎漾泳源\
泺涑淙渌潆漯")
(qdl "hx" "\
浊")
(qdl "hy" "\
澄汇溅江沮滥汽泣浅涩\
湿温泄汛溢渔渣湛泯泾\
洹洫湓渲溘澧澶瀣鲨")
(qdl "hz" "\
濒溃漱渍汴浈濑灏")
(qdl "ia" "\
谩设态诹谂谖谡")
(qdl "ib" "\
谣讪诎")
(qdl "ic" "\
谨奎谁诖")
(qdl "id" "\
谤谗词访夯讳夸太询诱\
诩谔谛谫鹌鹩")
(qdl "ie" "\
谈诙")
(qdl "if" "\
话诺语诂诏诒诘诟诰诼\
谘谵")
(qdl "ii" "\
大读诀犬误讠诶谟谳")
(qdl "ij" "\
订夺奇诗讨谢讶谆刳剞\
诃诤谕")
(qdl "ik" "\
讼套")
(qdl "il" "\
谍课谋诛诔谯")
(qdl "im" "\
奔计讲评牵谭详许译讦\
诨谇耷")
(qdl "io" "\
调讽请诵谓议诌讴讵讷\
诓诮谑谝谪谲奁飙")
(qdl "ip" "\
谰")
(qdl "ir" "\
训诠诳夼")
(qdl "is" "\
识诿")
(qdl "it" "\
诧讹诡谎讥记论谬讫说\
奄谚诊诜谠匏")
(qdl "iu" "\
奋诲谱谦奢谐诣诸谄谒\
谙谮瓠")
(qdl "iv" "\
诞谅谜奈谴谏")
(qdl "iy" "\
诚诫让试诬讯谊证诅讧\
诋谌谥谧谶")
(qdl "iz" "\
诽讣该认诉诈谀欹")
(qdl "ja" "\
菠葱菱蔓惹蕊芯夔芰芟\
茇菝菽菔葸葭蒽蕙蕞薏")
(qdl "jb" "\
茁")
(qdl "jc" "\
茬董芦墓鞋芏茌茔荏堇\
萑蕹薹藿")
(qdl "jd" "\
荡蒂芳芬苟节鞠菊劳勒\
荔幕募蔫葡勤鹊芍苏萄\
苇药艿芎芾苈芴苓茑荀\
荩莠莺菸萼蓦蓊蒡鹋鹳\
鞫")
(qdl "je" "\
荧鄞茚茆荻")
(qdl "jf" "\
菇警苦落蒙菩茄蓉茹若\
苫苔营苕莒茗萜菅蓓")
(qdl "jg" "\
蓑苌茛莨蒎蒗")
(qdl "jh" "\
蓰")
(qdl "ji" "\
获荚葵莫英芙茯荬葜蒺\
蔟鞅")
(qdl "jj" "\
薄荷菏蓟荐蒋荆苛莉茅\
摹孽擎蔚芽芋蒯劐艹苻\
荇荨荮荸莳莩葑葶蓐薅\
蘅鞯")
(qdl "jk" "\
芸荟菘")
(qdl "jl" "\
苯菜茶蕉莱荣燕藻蘸蔗\
蒸茉茱荼葆蓁蕖薰藁蘖\
檠鞣")
(qdl "jm" "\
草革荤井莽苹萍茸薛葬\
芊荜荦莘萆萃葺蕈薜藓")
(qdl "jn" "\
萝蓥")
(qdl "jo" "\
艾蔽鞭葫敬萌藕莆蒲鞘\
散荫芨苣芮苒苘茼茭莴\
莜菁菡葚蒿蓠蒴蔹薇薮\
薷鞲鞴")
(qdl "jp" "\
蔺")
(qdl "jq" "\
蘑芩菪")
(qdl "jr" "\
芥靳芹萧薪莹荞荃荠菥\
蕲鞒")
(qdl "js" "\
鞍共黄萎荽萁萋蒌蕻")
(qdl "jt" "\
芭靶苞蓖苍范花荒藐莎\
蔬芜巷靴艺苑艽芄芑芗\
芫苊芘苋芤茏荛茈茺莸\
莞莼菟菀葩甍蔸蔻蓼薨\
觏觐鞔")
(qdl "ju" "\
蔼曹藩葛藉菌蕾苗暮蔷\
薯昔蓄茵芝著苷苜茜茴\
莓菖萏菰葙蒈蓍蒹蓿蕤\
瞢蕃沓")
(qdl "jv" "\
蔡恭莲慕蓬水蒜藤莛荥\
荪萘萦藜蘧蘩淼綦鞑")
(qdl "jw" "\
萨")
(qdl "jx" "\
茧萤")
(qdl "jy" "\
藏茎蓝芒茫茂蔑蕴廿芷\
芪苎苤苴茕苠茳荭莪莅\
莶菹葳蒇萱蕺薤靼")
(qdl "jz" "\
茨菲颧苁芡苄苡荑莰萸\
蒉蓣蔌蕨蘼颟")
(qdl "ka" "\
彼惩怠德伎假仅俊您侵\
傻役悠偬後恁愆皴")
(qdl "kb" "\
倔仙岱徭")
(qdl "kc" "\
堡催佳垒任仕侄俚傩僮\
垡隹雠")
(qdl "kd" "\
傍彻传仿份佛伶仍伤伺\
伟伪仂仞佝佟侉俜彷徇\
鸺鹪隽")
(qdl "ke" "\
伙仰御邰炱煲")
(qdl "kf" "\
倍估侣售俗台像信佑伽\
佶偌倌倨僖儋")
(qdl "kg" "\
袋很依伥侬偎儇")
(qdl "kh" "\
促徒徙")
(qdl "ki" "\
伏侯候侠矣佚俣俟倏")
(qdl "kj" "\
侧待倒得俘俯傅付何衡\
街例俐侍停偷衔行衙衍\
倚仔劁仃伢俦衢")
(qdl "kk" "\
偿侩亻仫厶彳")
(qdl "kl" "\
保集焦傈僳体熊休徐侏\
倮僬徕黛")
(qdl "km" "\
伴华件律牟僻仟什佯仵\
佴侔俸倬俾弁徉牮隼")
(qdl "kn" "\
侈")
(qdl "ko" "\
傲便侗徽俩偶佩偏俏儒\
使倘微仪佣仗做伛攸侑\
佾佼俪俑倩倜偃儆徜徵\
徼")
(qdl "kp" "\
们")
(qdl "kr" "\
价侨伸往仲住侪徨")
(qdl "ks" "\
供俱佞倭偻傧")
(qdl "kt" "\
俺参仇化侥倦傀佬伦能\
倪凭他修伊亿优允仉仡\
仳佤伧伉佗伲侃佻傥僦\
毵")
(qdl "ku" "\
佰伯倡储佃徊借儡僧侮\
循偕偈僭畚")
(qdl "kv" "\
傣健僚你俅傺")
(qdl "kw" "\
俨")
(qdl "ky" "\
代但低俄伐俭僵径仁叁\
位伍征值佐仨伫倥徂")
(qdl "kz" "\
贷货赁徘仆倾似债侦作\
佧俳偾")
(qdl "la" "\
板愁椒棱秘权穗梭稳想\
枝杈椴懋稔稷馥")
(qdl "lb" "\
嵇")
(qdl "lc" "\
杜桂榷稚桩椎栌柽桎棰\
槿樘")
(qdl "ld" "\
榜构楞棉柿梯稀朽秀杨\
杓杩枥枋栉枵柃枸栲栩\
棼榻樗秭")
(qdl "le" "\
梆郴焚榔柳秋椰棂楸")
(qdl "lf" "\
椽格棺和枷稼秸桔枯檬\
梧橡杏栝梏椐榀榕橼檐\
稆黏")
(qdl "lg" "\
根枨榱稂穰")
(qdl "lh" "\
楚樾")
(qdl "li" "\
樊模楔秧秩椟楱")
(qdl "lj" "\
材橱村季柯李利柠攀树\
椅榆杼桁桴椁榭樽稃")
(qdl "lk" "\
私松桧")
(qdl "ll" "\
本杰棵梨林木森术株榇\
榛樵灬秣秫稞黧")
(qdl "lm" "\
稗棒秤杆秆科犁样樟杵\
枰桦梓棹楫榉榫槔槲樨")
(qdl "ln" "\
秽梦移椤")
(qdl "lo" "\
柄稠档枫稿梗柜极框枚\
棚梢稍枢桐桶椭檄校栅\
杖枘柩桷楠榧槁榍橄檎\
橘")
(qdl "lp" "\
榈")
(qdl "lq" "\
柘")
(qdl "lr" "\
程桥栓枉析种柱柙")
(qdl "ls" "\
横积婪楼棋委樱枳桉槟\
稹")
(qdl "lt" "\
彬概棍杭槐机麓秒穆枪\
橇杉梳税桃秃桅魏札枕\
杌杞枇杪枧杷栊栀柁栳\
桡桄桤梵桫榄秕")
(qdl "lu" "\
柏槽椿稻柑稽楷榴梅栖\
相香杳柚桕楮楣槠樯橹\
檑穑皙")
(qdl "lv" "\
杯标称栋禁黎黍棕柰栎\
梃椋楗棣楝槌檩檫")
(qdl "ly" "\
查橙杠桓检槛栏檀械栈\
植租柢桠椹楂槎楦楹槭")
(qdl "lz" "\
核朴颓榨柞枞柝桢橛")
(qdl "ma" "\
被翅轰惠友支嘏勰辍祓\
衩裰")
(qdl "mc" "\
基垄堑社雄在墼轳轾衽")
(qdl "md" "\
办帮勃布初带韩翰驾勘\
力切协枣专转轫祠鸠鸪\
鸫鹁鹕裼")
(qdl "me" "\
邦邯灰祁郁郏")
(qdl "mf" "\
古加裙辖右裕轱轺辂軎\
祜禧袷袼裾褡")
(qdl "mg" "\
囊丧袭辕辗禳裉裱袈裘")
(qdl "mi" "\
袄夫袱夹卖献奏轶辏祆\
禊袂")
(qdl "mj" "\
博才衬刺存祷褥事寿输\
孛剌哿轲轷襻")
(qdl "mk" "\
祛")
(qdl "ml" "\
架来裸某秦袜杂椠橐焘\
禚褓")
(qdl "mm" "\
车奉辜卉辑裤聋十斡祥\
轩斟卅辇辚礻禅衤袢裨")
(qdl "mn" "\
錾")
(qdl "mo" "\
朝敷甫辅故胡祸较救吏\
辆南期有丈辙辋敕衲裆\
褙褊襦")
(qdl "mp" "\
裥")
(qdl "mq" "\
砻衿")
(qdl "mr" "\
轿祈神斯斩辁裎")
(qdl "ms" "\
龚妻其真轵祺褛")
(qdl "mt" "\
规轨辊兢九克礼龙轮袍\
七乾衫视屯丸旭也尤轧\
祝馗尢尥尬尴轭轸辄辘\
祀祧褫")
(qdl "mu" "\
春辐福甘褐替袖暂轴啬\
辎旮褚褶舂")
(qdl "mv" "\
东棘柬襟禄求束索泰褪\
轹祢裢")
(qdl "mx" "\
蠢襁蠹")
(qdl "my" "\
裁矗戴截盔轻甚袒栽哉\
载整直祖左轼戟戡祉祗\
裣褴")
(qdl "mz" "\
补颠顿褂贺颊赖欺软爽\
夷贲赉赍祚祯")
(qdl "na" "\
惫镀锻饭急馒镊鳃怨皱\
馊钗钣钹铋铍锓锪锶锼\
锾镘镬镱鲅鲮鲰鲶鳆鳗")
(qdl "nb" "\
鳐")
(qdl "nc" "\
雏锤鲤锥饪馑钍铿锂锉\
镗锺雒鲈鲑鲣")
(qdl "nd" "\
镑馋锄钓冬钙钩锦钧铃\
饰饲锑钨务锡夕锈鸳饧\
饬钫钸铈铐铞铴铹锔锷\
镌镯觞鲂鳄鳎鳓")
(qdl "ne" "\
灸铆锹炙邹钬铘锬鲫鳅")
(qdl "nf" "\
铬各馆咎锯铝铭名铅象\
詹钻饴彖钴铪铷锆锘锫\
镓鲇鲐鲒鳝")
(qdl "ng" "\
镶铱银飧馕锒锿")
(qdl "nh" "\
锭镟")
(qdl "ni" "\
镁铁奂饫馍钛铗锲镆镞\
镤觖")
(qdl "nj" "\
钉铡争铸饽钊钌钶铮锊\
锕锝锵镎鲋鲟鲥鳟")
(qdl "nk" "\
铉铥")
(qdl "nl" "\
钵镍然煞条馀桀铢铩铼\
锞镳稣鲦鲽")
(qdl "nm" "\
饼饵锋解鳞钎鲜锌彝针\
舛钭铎铒铧锛镡斛觯鲆")
(qdl "nn" "\
多金锣饣钅鑫")
(qdl "no" "\
钢镐锅铰角饺钠铺铜销\
钥刍饷馓钜钷铕铛锖镉\
镛镝镦鲔鲕鲛鲠鲡鲭鲷\
鳊鳕鳙")
(qdl "np" "\
钔锎锏镧")
(qdl "nq" "\
钤")
(qdl "nr" "\
钾钟钏钰铨锃镩鲚鳇")
(qdl "ns" "\
馁镇夤馔钕铵镂镔")
(qdl "nt" "\
饱鲍钞钝钒龟饥镜免勉\
饶锐色兔危铣饨馄彘钆\
钇钐钪钯铊铌铑铙铠铫\
铯铳锍锟锩觥鱿鲩鲲鲵")
(qdl "nu" "\
备铂处错久镭镰馏鲁锚\
钳馅铀锗夂昝眢钼钿铟\
锢锱锴锸镅镏镥镨觚鲳\
鲴鲻鳍")
(qdl "nv" "\
祭键鲸链镣钚铄铤镖镙\
镲觫鲢鲧鳏鳔")
(qdl "nw" "\
铲")
(qdl "nx" "\
触蚀蟹镪螽蠡鳋")
(qdl "ny" "\
饿饯锰钮钱鱼饩馇馐钲\
钺钽铖铽锇镒镫鲺鳢")
(qdl "nz" "\
钡负馈欠钦锁外锨饮钋\
镄镢鲱鲼鳜")
(qdl "oa" "\
贩凤服腹股殴腮悬臆肢\
臌慝骰")
(qdl "ob" "\
罂")
(qdl "oc" "\
雕肚胜膛腥臃赃脏胪脞\
塍膣")
(qdl "od" "\
膀肠赐肪肺购胯肋鸥鹏\
腾希胁胸匝帚助赅肟朐\
腭鹦翳鹘髑")
(qdl "oe" "\
脚灵郄郗郾酆赕")
(qdl "of" "\
胳赂匿赔赡膳胎贴同周\
叵豳贻豚膪朦骷骺骼髂")
(qdl "og" "\
脓账胀赈")
(qdl "oh" "\
腚")
(qdl "oi" "\
肤膜赎医肽朕腠")
(qdl "oj" "\
脖膊财腑刚刹删则肘刈\
赙刖脬腧")
(qdl "ok" "\
县幽肱脍")
(qdl "ol" "\
杀熙脎脒臊髁")
(qdl "om" "\
肝胖脾用肼胼膦髀")
(qdl "on" "\
夙")
(qdl "oo" "\
败册风脯冈骨贿胶脑朋\
区网凶腋爻匾肭肴胴脶\
腈腩膈")
(qdl "or" "\
臣凰匠匡脐匣肿胛胂骱")
(qdl "os" "\
胺具腆腰婴媵膑髅髌")
(qdl "ot" "\
肮胞脆肥肌见膨匹甩彤\
脱腕匦鬯瓯贶肜朊肫胧\
胗胱脘腌飑飓飕飚髋")
(qdl "ou" "\
贬赌腊赠脂赚胍胭腼臁")
(qdl "ov" "\
膘脉赊髓腿膝腺凼赇胨\
脲腙腱滕")
(qdl "oy" "\
丹胆赋肛贱巨脸皿腻胚\
腔且月贼贮罔弑彐胝胫\
腽膻骶")
(qdl "oz" "\
贝匪骸内欧肉卧颐胰匮\
赜赆肷胩胙胲腓腴欷")
(qdl "pa" "\
缎缓闷缀阌绂绫绶缌缦")
(qdl "pb" "\
绌")
(qdl "pc" "\
缠闺维缍")
(qdl "pd" "\
闯缔纺纷幻绵闹纫纬绣\
绚幼约终闱阏绋绔绨鸶\
鹇")
(qdl "pe" "\
绑")
(qdl "pf" "\
阁给结阔络缮绍问缘辔\
闾绐绺绾")
(qdl "pg" "\
阆缳飨")
(qdl "ph" "\
绽缇")
(qdl "pi" "\
续阕缑")
(qdl "pj" "\
闭缚纡纣纾绗绮缛")
(qdl "pk" "\
绘闳纭幺")
(qdl "pl" "\
绦闲缫缲")
(qdl "pm" "\
绊阐绰缉闻纤绎绛缂")
(qdl "po" "\
绷编绸纲级缴绞绢纳纹\
闵阚绉绠绡绱缏缟缡")
(qdl "pp" "\
门纟")
(qdl "pr" "\
纠闰绅闸")
(qdl "ps" "\
缕绥缨织阒阗缜缤")
(qdl "pt" "\
纯纪绝缆纶绕纱绳统乡\
阉阅闶阄阋纥纨纰绲绻\
缈缪")
(qdl "pu" "\
间缅缩细绪阎阃阊阍绀\
缁缃缗缙缣缯")
(qdl "pv" "\
缝阑练绿综闼缒缥缧缭\
缱糸")
(qdl "pw" "\
纩")
(qdl "px" "\
闽")
(qdl "py" "\
阀红继缄经纽绒丝线纸\
组闩闫阈阖绁缢缰畿")
(qdl "pz" "\
阂绩闪纵绯缋缬缵")
(qdl "qa" "\
忌骏皮破恿驭骢愍")
(qdl "qb" "\
础")
(qdl "qc" "\
硅驴骓碓")
(qdl "qd" "\
磅骋弗弓劲驹码马乃砌\
弱书勇粥砖勐弼驽骛骟\
砀砺砩碲鹜鹬")
(qdl "qe" "\
郡碳")
(qdl "qf" "\
君骆豫砧骤骀硌碚礞")
(qdl "qg" "\
碾张骧磙")
(qdl "qh" "\
碇疋")
(qdl "qi" "\
癸买驮硖")
(qdl "qj" "\
碍剥导了矛骑寻予孕子\
刭孑孓驸骣砑硎礴")
(qdl "qk" "\
磁弘弦砝")
(qdl "ql" "\
碟礁柔骒磔磉磲")
(qdl "qm" "\
碑弹磷砰群碎研异弭驿\
骅骈犟聿矸砗")
(qdl "qn" "\
矽鍪")
(qdl "qo" "\
驳碉改函及硼骗驱确孺\
驶硝硬砸孜鬻驺骊砜砹\
硐碥礅甬胥")
(qdl "qq" "\
磊石矜")
(qdl "qr" "\
骄砷肃驯引驻鼐肀斫")
(qdl "qs" "\
碘磺巽婺骐骥")
(qdl "qt" "\
弛驰凳矾己孔硫砒砂疏\
巳驼碗砚已尹卺巯艴孢\
骁骖矶砘砣硗碜")
(qdl "qu" "\
承孤弧硒驷骝砭硇碡碣\
瞀")
(qdl "qv" "\
泵砾隶碌录骡弥孙尕骠\
礤")
(qdl "qw" "\
矿")
(qdl "qx" "\
蛋强骚蝥蟊")
(qdl "qy" "\
碴丑磋登碱硷疆磕孟民\
碰验盈丞亟弪驵戤砼砥\
砬硭硪碹磴礓")
(qdl "qz" "\
费孩骇颈砍颇硕预阙砟\
碛")
(qdl "ra" "\
悲毖玻患瑟忠帔幔瑗瑕\
瑷璁")
(qdl "rb" "\
瑶")
(qdl "rc" "\
幢坚理帷幄瑾璀")
(qdl "rd" "\
卜畅巾玲玛师帅鸯与玉\
冂帏玮玢翡")
(qdl "re" "\
邮邶邺琊琰鬏")
(qdl "rf" "\
帖琢玷珈珞琚瑭璩璐髫\
髻")
(qdl "rg" "\
长琅裴帐鬟")
(qdl "rh" "\
璇")
(qdl "ri" "\
央奘帙幞瑛璞")
(qdl "rj" "\
刂帱玎珂珩琦瑜")
(qdl "rk" "\
珐")
(qdl "rl" "\
琳珠琛璨髹")
(qdl "rm" "\
辈毕弄肆芈幛珥珲璋")
(qdl "rn" "\
鉴")
(qdl "ro" "\
背归瑚璃玫冉瑞珊肾史\
收凿玟斐黹黻黼髯")
(qdl "rq" "\
碧琴")
(qdl "rr" "\
斑班串断申王中丨凵爿\
珏")
(qdl "rs" "\
典冀帜珙琪璜璎鬓")
(qdl "rt" "\
北比毙电帆瑰幌览琉琶\
琵玩现珍玑珑珧琥琨琬\
髟髡髦髭鬈")
(qdl "ru" "\
幅皆旧临帽帕曲由帼幡\
珀瑁瑙")
(qdl "rv" "\
环紧琼球鬃琏琮")
(qdl "rx" "\
蜚")
(qdl "ry" "\
盎监韭世竖业曳盅戕玳\
珉鬣")
(qdl "rz" "\
非贵玖琐贤以帧帻顼瓒\
贳")
(qdl "sa" "\
慈忿妓奴怒嫂恕媳总媛\
嫒恙羧")
(qdl "sb" "\
岔")
(qdl "sc" "\
妒妊塑娃姓坌娌")
(qdl "sd" "\
弟妨分剪羚妈奶努翁翔\
爷兮帑弩妁姊妫娉娣嫣\
嫦蠲鹆鹈鹚鹣翦")
(qdl "se" "\
郸娜郑鄯羰")
(qdl "sf" "\
姑谷嫁如善始兽嬉")
(qdl "sg" "\
娘娠冁婊")
(qdl "sh" "\
婕")
(qdl "si" "\
奠羹关嫉美妖娱嫫猷")
(qdl "sj" "\
好前剃尊妤婀婷孥孳")
(qdl "sk" "\
公兹嬷")
(qdl "sl" "\
羔煎媒妹姝槊")
(qdl "sm" "\
并单奸羊妍姘婢婵嫜")
(qdl "sn" "\
爹釜")
(qdl "so" "\
嫡父妇姬娟嫩朔婿妪姗\
姣娲婧胬媾")
(qdl "sp" "\
娴")
(qdl "sq" "\
妗")
(qdl "sr" "\
斧娇婶养")
(qdl "ss" "\
八姜女嫔")
(qdl "st" "\
爸兑姥娩妙妮瓶羌她婉\
瓮姚妃妩妣娆姹娓媲甑")
(qdl "su" "\
婚兼媚姆普酋首嫌姻曾\
着妯娼嫱孀羯")
(qdl "sv" "\
絮嫖嫘")
(qdl "sx" "\
媸")
(qdl "sy" "\
差娥盖姐兰盆羞益馘妞\
妲娅媪嬗羝羟羲")
(qdl "sz" "\
颁贫歉颂羡姨欲姒")
(qdl "ta" "\
爱般版段发反忽毁受艘\
息悉殷鼗叟爰殳憩皈鹱\
舨")
(qdl "tb" "\
岳岙舢")
(qdl "tc" "\
垂牡壬生牲重舻艟")
(qdl "td" "\
翱豹币帛匆岛的甸鹅翻\
躬勾舅句卵鸟乓勺甥乌\
物勿匈旬粤匀乜勹匍訇\
匐劬巛鸨鸲鸱鸹鹄鹎鹞\
舄舫鼢")
(qdl "te" "\
卯卿邱印邬邸邾郇郜郛\
郫鄱爨")
(qdl "tf" "\
船告貉后舌吞牯牾牿皓\
艨貂鼯")
(qdl "tg" "\
袅")
(qdl "th" "\
疑")
(qdl "ti" "\
奥臭犊失夭奚牍貘鼷")
(qdl "tj" "\
豺掣剁孵刮乎剿爵刨射\
身剩手特制刎劓孚犄掰\
搿舸")
(qdl "tk" "\
丢么舷")
(qdl "tl" "\
采巢躲朵皋禾熏朱枭牒\
臬貅")
(qdl "tm" "\
拜卑辞阜牛牌千升释舜\
衅肄睾廾舁鼾")
(qdl "tn" "\
够")
(qdl "to" "\
敌牧躯躺向禹舟犏犒敫\
牖皎舣艄")
(qdl "tq" "\
磐")
(qdl "tr" "\
鼻川乖皇斤片乔所玺璺\
舯")
(qdl "ts" "\
兵妥舆犋鼹")
(qdl "tt" "\
皑包彩舱兜舵儿凡鬼航\
几舰魁乱毛貌觅乒魄乳\
毯鸵皖先皂毡兆丿匕乇\
卮胤凫彡邕牝牦毪毳毽\
氇氆虢舭艉貔魅魃魉魈\
魍魑鼽")
(qdl "tu" "\
白舶囱盾乏番瓜昏臼看\
留爬甜牺舀釉旨爪自囟\
甾眚皤瓞舳舾艏艚貊鼬")
(qdl "tv" "\
秉乘尔乐泉舔艇系犍繇")
(qdl "tw" "\
豸")
(qdl "ty" "\
盘丘氏鼠我血氐盥舐衄\
舡艋齄")
(qdl "tz" "\
斥靠贸顺欣须颖赞质歃\
颀颍臾舴")
(qdl "ua" "\
恩恳曼暖思暇愚最矍暧\
睃瞍畈黢")
(qdl "ub" "\
黜")
(qdl "uc" "\
垦里量墨睦畦墅睡瞳星\
曜眭睚睢瞠疃罹雎瞿")
(qdl "ud" "\
母男盼蜀图围鸭易勖囫\
囹嬲昀眄睇羁黝")
(qdl "ue" "\
昂瞅即炅昴")
(qdl "uf" "\
固回略晤瞎瞻昭圄晗晷\
眙罟詈黠")
(qdl "ug" "\
晨匙畏眼圜曩艮")
(qdl "uh" "\
睫是题韪")
(qdl "ui" "\
默因映昊暌睽畎黩")
(qdl "uj" "\
畴盯罚畸时剔团野睁囝\
盱町")
(qdl "uk" "\
罢眩昙")
(qdl "ul" "\
睬果黑困昧眯瞧照杲曛\
煦睐罴")
(qdl "um" "\
旱畔瞬田晕早罩圉旰晔\
晖眸睥瞵")
(qdl "un" "\
罗夥眵黟")
(qdl "uo" "\
睛眶瞒明圃晴晌胃瞩禺\
囿圊晡暾胄眍瞰畋罱")
(qdl "uq" "\
黔")
(qdl "ur" "\
鼎国甲界旺晰昕畀")
(qdl "us" "\
囡晏暝瞑")
(qdl "ut" "\
巴囤晃既昆冕毗圈入四\
眺晚毋晓影园兕囵旯昵\
晁氍盹眇眈眦睨畛畹罨\
黪")
(qdl "uu" "\
暗凹昌睹晦晶冒瞄晒暑\
曙署凸眨曷罾黯")
(qdl "uv" "\
暴景累晾曝瞟罘黥")
(qdl "uw" "\
旷")
(qdl "uy" "\
旦瞪盟眠目日显曰置戥\
昱晟暄曦睑瞌罡暨")
(qdl "uz" "\
贯颗囚歇圆罪昨颢")
(qdl "va" "\
返逡遐")
(qdl "vb" "\
遥")
(qdl "vc" "\
尘雀廷逵暹")
(qdl "vd" "\
边递迹劣迈透违巡遢")
(qdl "ve" "\
迎逖")
(qdl "vf" "\
遣适遂迢造逐追迦迨逅\
逭遽邃")
(qdl "vg" "\
退")
(qdl "vi" "\
达迭尖送")
(qdl "vj" "\
过辽迂逾遵迓")
(qdl "vk" "\
运")
(qdl "vl" "\
迷述途遮")
(qdl "vm" "\
迸避逢建进连迁迕逄遴\
邂")
(qdl "vn" "\
逻")
(qdl "vo" "\
遍通邀遇这迥逋逦逍遄\
遨遘")
(qdl "vr" "\
逞逛近逝遑")
(qdl "vs" "\
逶")
(qdl "vt" "\
逆迄少逃选逸远迤邈")
(qdl "vu" "\
逼迟道迪遁遏迫省遭遒\
遛")
(qdl "vv" "\
逮还速小逊廴辶迩逑逯\
尜")
(qdl "vy" "\
逗迅延迳邋")
(qdl "vz" "\
遗迮")
(qdl "wa" "\
度废感疲瘦厦疫愿狻庋\
痣瘕瘛瘢瘾癔癜")
(qdl "wb" "\
癌疝")
(qdl "wc" "\
厘狸庐瘫猩压雁庄座狴\
獾廑廛痤瘗癃癯")
(qdl "wd" "\
狗厉励历狮疼席疡鹰犸\
狒鹧疖疠疬痨瘀")
(qdl "we" "\
狄廓廊痰邝")
(qdl "wf" "\
痴唇瘩店痞唐狺猞痂痦\
瘃")
(qdl "wg" "\
辰痕狠狼猿猥餍")
(qdl "wh" "\
蹙")
(qdl "wi" "\
猴痪疾庆狭厌狱瘊瘼")
(qdl "wj" "\
厕厨府厚痢疗摩狞辱厅\
序狰痔劂狩猁猗疔疴瘌\
麝")
(qdl "wk" "\
狯痃麽")
(qdl "wl" "\
床麻糜庶狳猓猱獯庥橥\
麇麋")
(qdl "wm" "\
瘁库癣痒瘴厍犴猝獐獬\
庠庳廨瘅癖麟")
(qdl "wn" "\
猡鏖")
(qdl "wo" "\
病猜疯腐猾狡疟瘸痛痈\
庸狷猢猬廒膺瘠")
(qdl "wp" "\
痫")
(qdl "wq" "\
磨")
(qdl "wr" "\
痹疥狂痊厣厮狎疰癍麈")
(qdl "ws" "\
痿瘘癀瘿麒")
(qdl "wt" "\
疤庇瘪疮疵厄犯疙厩廖\
鹿魔庞犹疹犰狁狍猊獍\
庀庑庖庵疣疱痧瘳魇麾\
麂")
(qdl "wu" "\
猖狐疚廉猎瘤猫庙厢猪\
厝靥猸庹疳痼")
(qdl "wv" "\
康庭原狲猕獠廪瘭瘰瘵\
縻")
(qdl "ww" "\
厂犭犷")
(qdl "wx" "\
独瘙蜃")
(qdl "wy" "\
成底痘痉狙疽猛戚盛戍\
威瘟戊咸戌应症狃狨猃\
猹臧疸痖瘥")
(qdl "wz" "\
狈庚顾靡獭仄厥赝獗庾\
赓痄痍痱瘐癞癫")
(qdl "xa" "\
蝮螋螅蟋蟪蠖蠼簸")
(qdl "xc" "\
蛙蛏蛭蝰螳笙")
(qdl "xd" "\
第筋蚂筛蛎蛉蚴蛳蜴螃\
笃笫笏笱笥筠")
(qdl "xe" "\
螂筇")
(qdl "xf" "\
答蛤管蜘篆蛄蛞螗蟓蟮\
蠓蟾笤笳笞筘箬")
(qdl "xi" "\
簇筷笑蚨蛱蜈蟆篌")
(qdl "xj" "\
簿筹等符箭蚜蚵蜊蜉蝓\
蝣竽筝")
(qdl "xk" "\
篡蚣")
(qdl "xl" "\
笨蝶蛛蜍蜾蝾螓篥")
(qdl "xm" "\
蚌蝉蜂竿算蚪蛘蛑蜱蝌\
蟒蟑蟀笄筚箨箪簟")
(qdl "xn" "\
箩")
(qdl "xo" "\
篙箍蝴筐篱篇蠕筒蚊蜗\
蚁蛹蚋蚺蛟蛸蜻蜩蝻蝙\
螨螭笈笸筻筲筱箐箧篝\
篚")
(qdl "xp" "\
简")
(qdl "xr" "\
蝗蛀蚧蚓蛴蜥筌箅箫篁\
簖")
(qdl "xs" "\
簧箕篓螟蜞蝼蟥")
(qdl "xt" "\
笆笔笼蛇笋蜕蝇筑虬虮\
虼蚍蚬蚝蛲蜣蜷蜿蟛笕\
筅筢箢篦篪篼簏")
(qdl "xu" "\
箔笛蛔籍蜡箱蝎蚶蚰蛐\
蝈蝽蝠蝤螬蟠蠊笊箸箝\
簪籀")
(qdl "xv" "\
策螺篷蜒纂蜓螈螵笾筵")
(qdl "xx" "\
虫")
(qdl "xy" "\
蛾筏蛊虹笺篮签蛆虻蚯\
蜮蜢蠛竺笪笠筮箜箴篾\
簋簦")
(qdl "xz" "\
虾蚱笮箦篑簌籁")
(qdl "ya" "\
聪恶覆憨惑恐聂取酸霞\
夏殁忑恧豉")
(qdl "yc" "\
霍型醒雅至垩霪霾")
(qdl "yd" "\
动酚功亏零聘巧万雾殉\
鸦焉酌丐劢殇鸢鸸鹂鹉\
聆翮雩雳霈")
(qdl "ye" "\
耿聊灭邪邢耶邗邛邴邳\
郅郦鄄鄢鄹酃")
(qdl "yf" "\
殆否聚酷酪露吾聒酤酩\
醅醣醵")
(qdl "yg" "\
裂酿震餮")
(qdl "yh" "\
醍趸跫")
(qdl "yi" "\
联酞天殃醭")
(qdl "yj" "\
醇寸到丁副哥划酵刊可\
列耐刑牙于亍孬剽殍耵\
聍酊酎酹")
(qdl "yk" "\
云酝")
(qdl "yl" "\
栗烈霖殊酥粟臻酴醮醺")
(qdl "ym" "\
耳干歼开霹平醉殚覃酐")
(qdl "yn" "\
歹銎")
(qdl "yo" "\
霸甭丙而敢更攻丽两飘\
酮霄需酗雪雨再政致鬲\
聃酾醐醑雯霰")
(qdl "yr" "\
酬画醛丌亓酲霁")
(qdl "ys" "\
娶耍要职殡霎")
(qdl "yt" "\
雹耽巩魂霓配翘死瓦豌\
无形尧乙元甄兀殄觋虺\
酏酡酰醌醪鼋")
(qdl "yu" "\
百醋酣晋雷酶霉面瓢霜\
西酉酯霭")
(qdl "yv" "\
不汞醚票示忝霆")
(qdl "yw" "\
严酽")
(qdl "yx" "\
蚕融虿蛩")
(qdl "yy" "\
残耻豆二贰飞戈工互或\
戒戎三虱式歪巫武五亚\
一盂盏正殖丕亘噩匚弋\
忒甙殂殓殛殪戋戛戬豇\
醢醯醴")
(qdl "yz" "\
顶歌贡贾顽下项页殒昃\
聩顸颞颥酢霏")
(qdl "za" "\
复虑念歧叔怂叙愈怎攴\
忐")
(qdl "zb" "\
缶")
(qdl "zc" "\
雌罐卢坐壑矬雉龌")
(qdl "zd" "\
鸽龄令虏鸬翎翕")
(qdl "ze" "\
邻命卸郐")
(qdl "zf" "\
含合舍占知訾龆龉")
(qdl "zg" "\
餐食衾龈")
(qdl "zh" "\
龊")
(qdl "zi" "\
缺矢虞")
(qdl "zj" "\
创刽剑拿舒俞竹罅")
(qdl "zk" "\
会")
(qdl "zl" "\
柴点余桌籴榘粲")
(qdl "zm" "\
年伞耸午舞斜卓颦")
(qdl "zo" "\
齿脊矩肯敛敏虐禽龋龠\
攵虔觜")
(qdl "zq" "\
今砦")
(qdl "zr" "\
个矫介全矧")
(qdl "zs" "\
矮")
(qdl "zt" "\
彪步仓此虎仑乞毓乩瓴\
觇觎觑毹龛虍龀龅龇")
(qdl "zu" "\
督卤每智卣睿畲")
(qdl "zv" "\
繁紫氽佘汆")
(qdl "zy" "\
氨丛氮短氛氟缸氦盒氯\
氖企气氢氰上些虚氧战\
止仝佥俎戗氕氘氙氚氡\
氩氤氪氲鹾龃鳘")
(qdl "zz" "\
从卡领颅频顷人贪乍贞\
众赀欤歙颌颔")
