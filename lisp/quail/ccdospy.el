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
;;	Original table is from cxterm/dict/tit/CCDOSPY.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	GB
;; MULTICHOICE:	YES
;; PROMPT:	汉字输入∷缩写拼音∷ 
;; #
;; COMMENT 缩写拼音方案 (源于 CCDOS)
;; COMMENT
;; COMMENT 小写英文字母代表「拼音」符号，但如下「拼音」则用一键表示:
;; COMMENT   拼音:  zh  en  eng ang ch  an  ao  ai  ong sh  ing "u(yu)
;; COMMENT     键:   a   f   g   h   i   j   k   l   s   u   y   v
;; COMMENT 例∶  汉字∶ 【啊】【果】【中】【文】【光】【玉】【全】
;; COMMENT       拼音∶   a    guo   zhong  wen  guang  yu   quan
;; COMMENT       键入∶   a1   guo4   as1   wf4  guh1  yu..6 qvj6
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
;; # the following line must not be removed
;; BEGINDICTIONARY
;; #

(require 'quail)

(quail-define-package
 "ccdospy" "缩写拼音"
 '((?a . "zh") (?f . "en") (?g ."eng") (?h . "ang") (?i . "ch") (?j . "an")
   (?k . "ao") (?l . "ai") (?s . "ong") (?u . "sh") (?y . "ing") (?v . "yu"))
 "缩写拼音方案 (源于 CCDOS)

小写英文字母代表「拼音」符号，但如下「拼音」则用一键表示:
   拼音:  zh  en  eng ang ch  an  ao  ai  ong sh  ing \"u(yu)
     键:   a   f   g   h   i   j   k   l   s   u   y   v
 例∶  汉字∶ 【啊】【果】【中】【文】【光】【玉】【全】
       拼音∶   a    guo   zhong  wen  guang  yu   quan
       键入∶   a    guo03 as     wf03 guh    yu25 qvj05"
 *quail-mode-rich-map* nil nil nil nil t)

(defmacro qdl (key str)
  (list 'quail-defrule key (list 'string-to-char-list str)))

(qdl "a" "\
啊阿吖嗄腌锕")
(qdl "aa" "\
扎喳渣札轧铡闸眨栅榨\
咋乍炸诈揸吒咤哳楂砟\
痄蚱齄")
(qdl "ae" "\
遮折哲蛰辙者锗蔗这浙\
谪摺柘辄磔鹧褶蜇赭")
(qdl "af" "\
珍斟真甄砧臻贞针侦枕\
疹诊震振镇阵圳蓁浈缜\
桢榛轸赈胗朕祯畛稹鸩\
箴")
(qdl "ag" "\
蒸挣睁征狰争怔整拯正\
政帧症郑证诤峥徵钲铮\
筝")
(qdl "ah" "\
樟章彰漳张掌涨杖丈帐\
账仗胀瘴障仉鄣幛嶂獐\
嫜璋蟑")
(qdl "ai" "\
芝枝支吱蜘知肢脂汁之\
织职直植殖执值侄址指\
止趾只旨纸志挚掷至致\
置帜峙制智秩稚质炙痔\
滞治窒卮陟郅埴芷摭帙\
忮彘咫骘栉枳栀桎轵轾\
贽胝膣祉祗黹雉鸷痣蛭\
絷酯跖踬踯豸觯")
(qdl "aj" "\
瞻毡詹粘沾盏斩辗崭展\
蘸栈占战站湛绽谵搌旃")
(qdl "ak" "\
招昭找沼赵照罩兆肇召\
诏棹钊笊")
(qdl "al" "\
摘斋宅窄债寨砦瘵")
(qdl "aou" "\
舟周州洲诌粥轴肘帚咒\
皱宙昼骤荮啁妯纣绉胄\
碡籀酎")
(qdl "as" "\
中盅忠钟衷终种肿重仲\
众冢锺螽舯踵")
(qdl "au" "\
珠株蛛朱猪诸诛逐竹烛\
煮拄瞩嘱主著柱助蛀贮\
铸筑住注祝驻伫侏倬邾\
茱洙渚潴杼槠橥炷铢疰\
瘃竺箸舳翥躅麈")
(qdl "aua" "\
抓爪")
(qdl "auh" "\
桩庄装妆撞壮状椎僮")
(qdl "aui" "\
锥追赘坠缀惴骓缒")
(qdl "auj" "\
专砖转撰赚篆啭馔颛")
(qdl "aul" "\
拽")
(qdl "aun" "\
谆准肫窀")
(qdl "auo" "\
捉拙卓桌琢茁酌啄着灼\
浊诼擢浞涿濯焯禚斫镯")
(qdl "aux" "\
奘")
(qdl "ba" "\
芭捌扒叭吧笆八疤巴拔\
跋靶把耙坝霸罢爸茇菝\
岜灞钯粑鲅魃")
(qdl "bei" "\
杯碑悲卑北辈背贝钡倍\
狈备惫焙被孛陂邶蓓悖\
碚鹎褙鐾鞴")
(qdl "bey" "\
呗庳")
(qdl "bf" "\
奔苯本笨畚坌贲锛")
(qdl "bg" "\
崩绷甭泵蹦迸嘣甏")
(qdl "bh" "\
邦帮梆榜膀绑棒磅蚌镑\
傍谤蒡浜")
(qdl "bi" "\
逼鼻比鄙笔彼碧蓖蔽毕\
毙毖币庇痹闭敝弊必辟\
壁臂避陛匕俾荜荸萆薜\
吡哔狴愎滗濞弼妣婢嬖\
璧畀铋秕裨筚箅篦舭襞\
跸髀")
(qdl "bie" "\
鳖憋别瘪蹩")
(qdl "bij" "\
边编贬扁便变卞辨辩辫\
遍匾弁苄忭汴缏煸砭碥\
窆褊蝙笾鳊")
(qdl "bik" "\
标彪膘表婊骠飑飙飚镖\
镳瘭裱鳔髟")
(qdl "bin" "\
彬斌濒滨宾摈傧豳缤玢\
槟殡膑镔髌鬓")
(qdl "biz" "\
鞭")
(qdl "bj" "\
斑班搬扳般颁板版扮拌\
伴瓣半办绊阪坂钣瘢癍\
舨")
(qdl "bk" "\
苞胞包褒剥薄雹保堡饱\
宝抱报暴豹鲍爆葆孢煲\
鸨褓趵龅")
(qdl "bl" "\
白柏百摆佰败拜稗捭掰")
(qdl "bo" "\
玻菠播拨钵波博勃搏铂\
箔伯帛舶脖膊渤泊驳亳\
啵饽檗擘礴钹鹁簸跛踣")
(qdl "bu" "\
捕卜哺补埠不布步簿部\
怖卟逋瓿晡钚钸醭")
(qdl "by" "\
兵冰柄丙秉饼炳病并禀\
邴摒")
(qdl "ca" "\
擦嚓礤")
(qdl "ce" "\
厕策侧册测恻")
(qdl "cf" "\
岑涔")
(qdl "cg" "\
层蹭噌")
(qdl "ch" "\
苍舱仓沧藏伧")
(qdl "ci" "\
疵茨磁雌辞慈瓷词此刺\
赐次茈祠鹚糍")
(qdl "cj" "\
餐参蚕残惭惨灿孱骖璨\
粲黪")
(qdl "ck" "\
操糙槽曹草嘈漕螬艚")
(qdl "cl" "\
猜裁材才财睬踩采彩菜\
蔡")
(qdl "co" "\
辏")
(qdl "cou" "\
凑楱腠")
(qdl "cs" "\
聪葱囱匆从丛苁淙骢琮\
璁枞")
(qdl "cu" "\
粗醋簇促蔟徂猝殂酢蹙\
蹴")
(qdl "cui" "\
摧崔催脆瘁粹淬翠萃啐\
悴璀榱毳隹")
(qdl "cuj" "\
蹿篡窜汆撺爨镩")
(qdl "cun" "\
村存寸忖皴")
(qdl "cuo" "\
磋撮搓措挫错厝嵯脞锉\
矬痤鹾蹉")
(qdl "da" "\
搭达答瘩打大耷哒嗒怛\
妲沓褡笪靼鞑")
(qdl "de" "\
德得的锝")
(qdl "dg" "\
蹬灯登等瞪凳邓腾噔嶝\
戥磴镫簦")
(qdl "dh" "\
当挡党荡档谠凼菪宕砀\
铛裆")
(qdl "di" "\
堤低滴迪敌笛狄涤翟嫡\
抵底地蒂第帝弟递缔氐\
籴诋谛邸坻荻嘀娣绨柢\
棣觌砥碲睇镝羝骶")
(qdl "dia" "\
嗲")
(qdl "die" "\
跌爹碟蝶迭谍叠垤堞揲\
喋牒瓞耋蹀鲽")
(qdl "dij" "\
颠掂滇碘点典靛垫电佃\
甸店惦奠淀殿丶阽坫巅\
玷钿癜癫簟踮")
(qdl "dik" "\
碉叼雕凋刁掉吊钓调铞\
铫貂鲷")
(qdl "diu" "\
丢铥")
(qdl "dj" "\
耽担丹单郸掸胆旦氮但\
惮淡诞弹蛋儋萏啖殚赕\
眈疸瘅聃箪")
(qdl "dk" "\
刀捣蹈倒岛祷导到稻悼\
道盗叨忉氘纛")
(qdl "dl" "\
呆歹傣戴带殆代贷袋待\
逮怠埭甙呔岱迨骀绐玳\
黛")
(qdl "dou" "\
兜抖斗陡豆逗痘蔸窦蚪\
篼")
(qdl "ds" "\
东冬董懂动栋侗恫冻洞\
垌咚岽峒氡胨胴硐鸫")
(qdl "du" "\
都督毒犊独读堵睹赌杜\
镀肚度渡妒芏嘟渎椟牍\
蠹笃髑黩")
(qdl "dui" "\
堆兑队对怼憝碓镦")
(qdl "duj" "\
端短锻段断缎椴煅簖")
(qdl "dun" "\
墩吨蹲敦顿囤钝盾遁沌\
炖砘礅盹趸")
(qdl "duo" "\
掇哆多夺垛躲朵跺舵剁\
惰堕咄哚沲缍柁铎裰踱")
(qdl "dy" "\
丁盯叮钉顶鼎锭定订仃\
啶玎腚碇町疔耵酊")
(qdl "e" "\
蛾峨鹅俄额讹娥恶厄扼\
遏鄂饿噩谔垩苊莪萼呃\
愕屙婀轭腭锇锷鹗颚鳄")
(qdl "ei" "\
诶")
(qdl "er" "\
而儿耳尔饵洱二贰佴迩\
珥铒鸸鲕")
(qdl "f" "\
恩蒽摁")
(qdl "fa" "\
发罚筏伐乏阀法珐垡砝")
(qdl "fei" "\
菲非啡飞肥匪诽吠肺废\
沸费芾狒悱淝妃绯榧腓\
斐扉镄痱蜚篚翡霏鲱")
(qdl "ff" "\
芬酚吩氛分纷坟焚汾粉\
奋份忿愤粪偾瀵棼鲼鼢")
(qdl "fg" "\
丰封枫蜂峰锋风疯烽逢\
冯缝讽奉凤俸酆葑唪沣\
砜")
(qdl "fh" "\
坊芳方肪房防妨仿访纺\
放邡枋钫舫鲂")
(qdl "fj" "\
藩帆番翻樊矾钒繁凡烦\
反返范贩犯饭泛蕃蘩幡\
梵燔畈蹯")
(qdl "fo" "\
佛")
(qdl "fou" "\
否缶")
(qdl "fu" "\
夫敷肤孵扶拂辐幅氟符\
伏俘服浮涪福袱弗甫抚\
辅俯釜斧脯腑府腐赴副\
覆赋复傅付阜父腹负富\
讣附妇缚咐匐凫郛芙苻\
茯莩菔拊呋幞怫滏艴孚\
驸绂绋桴赙祓砩黻黼罘\
稃馥蚨蜉蝠蝮麸趺跗鲋\
鳆")
(qdl "ga" "\
噶嘎尬尕尜旮钆")
(qdl "ge" "\
哥歌搁戈鸽胳疙割革葛\
格蛤阁隔铬个各鬲仡哿\
圪塥嗝纥搿膈硌镉袼颌\
虼舸骼")
(qdl "gei" "\
给")
(qdl "gf" "\
根跟亘茛哏艮")
(qdl "gg" "\
耕更庚羹埂耿梗哽赓绠\
鲠")
(qdl "gh" "\
冈刚钢缸肛纲岗港杠戆\
罡筻")
(qdl "gj" "\
干甘杆柑竿肝赶感秆敢\
赣坩苷尴擀泔淦澉绀橄\
旰矸疳酐")
(qdl "gk" "\
篙皋高膏羔糕搞镐稿告\
睾诰郜藁缟槔槁杲锆")
(qdl "gl" "\
该改概钙盖溉丐陔垓戤\
赅")
(qdl "gou" "\
钩勾沟苟狗垢构购够佝\
诟岣遘媾缑枸觏彀笱篝\
鞲")
(qdl "gs" "\
工攻功恭龚供躬公宫弓\
巩汞拱贡共珙肱蚣觥")
(qdl "gu" "\
辜菇咕箍估沽孤姑鼓古\
蛊骨谷股故顾固雇嘏衮\
诂菰呱崮汩梏轱牯牿臌\
毂瞽罟钴锢鸪鹄痼蛄酤\
觚鲴鹘")
(qdl "gua" "\
刮瓜剐寡挂褂卦诖栝胍\
鸹")
(qdl "guh" "\
光广逛咣犷桄胱")
(qdl "gui" "\
瑰规圭硅归龟闺轨鬼诡\
癸桂柜跪贵刽匦匮刿庋\
宄妫桧炅晷皈簋鲑鳜")
(qdl "guj" "\
棺关官冠观管馆罐惯灌\
贯倌掼涫盥鹳矜鳏")
(qdl "gul" "\
乖拐怪")
(qdl "gun" "\
辊滚棍绲磙鲧")
(qdl "guo" "\
锅郭国果裹过馘埚掴呙\
帼崞猓椁虢聒蜾蝈")
(qdl "h" "\
肮昂盎")
(qdl "ha" "\
哈铪")
(qdl "he" "\
呵喝荷菏核禾和何合盒\
貉阂河涸赫褐鹤贺诃劾\
壑嗬阖曷盍蚵翮")
(qdl "hei" "\
嘿黑")
(qdl "hf" "\
痕很狠恨")
(qdl "hg" "\
哼亨横衡恒蘅珩桁")
(qdl "hh" "\
夯杭航沆绗颃")
(qdl "hj" "\
酣憨邯韩含涵寒函喊罕\
翰撼捍旱憾悍焊汗汉邗\
菡撖瀚晗焓顸颔蚶鼾")
(qdl "hk" "\
壕嚎豪毫郝好耗号浩蒿\
薅嗥嚆濠灏昊皓颢蚝")
(qdl "hl" "\
骸孩海氦亥害骇嗨胲醢")
(qdl "hou" "\
喉侯猴吼厚候后堠嚯後\
夥逅钬瘊蠖篌糇鲎骺")
(qdl "hs" "\
轰哄烘虹鸿洪宏弘红黉\
訇讧荭蕻薨闳泓")
(qdl "hu" "\
呼乎忽瑚壶葫胡蝴狐糊\
湖弧虎唬护互沪户冱藿\
唿囫岵猢怙惚浒滹琥槲\
轷觳烀煳戽扈祜镬瓠鹕\
鹱笏醐斛")
(qdl "hua" "\
花哗华猾滑画划化话骅\
桦砉铧")
(qdl "huh" "\
荒慌黄磺蝗簧皇凰惶煌\
晃幌恍谎隍徨湟潢遑璜\
肓癀蟥篁鳇")
(qdl "hui" "\
灰挥辉徽恢蛔回毁悔慧\
卉惠晦贿秽会烩汇讳诲\
绘诙茴荟蕙咴哕喙隳浍\
彗缋珲晖恚虺蟪麾")
(qdl "huj" "\
欢环桓还缓换患唤痪豢\
焕涣宦幻郇奂萑擐圜獾\
洹浣漶寰逭缳锾鲩鬟")
(qdl "hul" "\
槐徊怀淮坏踝")
(qdl "hun" "\
荤昏婚魂浑混诨馄阍溷")
(qdl "huo" "\
豁活伙火获或惑霍货祸\
劐攉锪耠")
(qdl "huy" "\
洄")
(qdl "ia" "\
插叉茬茶查碴搽察岔差\
诧馇汊姹杈槎檫锸镲衩")
(qdl "ie" "\
车扯撤掣彻澈坼砗")
(qdl "if" "\
郴臣辰尘晨忱沉陈趁衬\
谌谶抻嗔宸琛榇碜龀")
(qdl "ig" "\
撑称城橙成呈乘程惩澄\
诚承逞骋秤丞埕枨柽塍\
瞠铖铳裎蛏酲")
(qdl "ih" "\
昌猖场尝常长偿肠厂敞\
畅唱倡伥鬯苌菖徜怅惝\
阊娼嫦昶氅鲳")
(qdl "ii" "\
吃痴持匙池迟弛驰耻齿\
侈尺赤翅斥炽傺墀茌叱\
哧啻嗤彳饬媸敕眵鸱瘛\
褫蚩螭笞篪豉踟魑")
(qdl "ij" "\
搀掺蝉馋谗缠铲产阐颤\
冁谄蒇廛忏潺澶羼婵骣\
觇禅镡蟾躔")
(qdl "ik" "\
超抄钞朝嘲潮巢吵炒怊\
晁耖")
(qdl "il" "\
拆柴豺侪钗瘥虿")
(qdl "iou" "\
抽酬畴踌稠愁筹仇绸瞅\
丑臭俦帱惆瘳雠")
(qdl "is" "\
充冲虫崇宠茺忡憧舂艟")
(qdl "iu" "\
初出橱厨躇锄雏滁除楚\
础储矗搐触处亍刍怵憷\
绌杵楮樗褚蜍蹰黜")
(qdl "iuh" "\
疮窗幢床闯创怆")
(qdl "iui" "\
吹炊捶锤垂陲棰槌")
(qdl "iuj" "\
川穿椽传船喘串舛遄巛\
氚钏舡")
(qdl "iul" "\
揣搋膪踹")
(qdl "iun" "\
春椿醇唇淳纯蠢莼鹑蝽")
(qdl "iuo" "\
戳绰啜辍踔龊")
(qdl "j" "\
鞍氨安俺按暗岸胺案谙\
埯揞犴庵桉铵鹌黯")
(qdl "ji" "\
击圾基机畸稽积箕肌饥\
迹激讥鸡姬绩缉吉极棘\
辑籍集及急疾汲即嫉级\
挤几脊己蓟技冀季伎祭\
剂悸济寄寂计记既忌际\
妓继纪丌亟乩剞佶诘墼\
芨芰荠蒺蕺掎咭哜唧岌\
嵴洎屐骥畿玑楫殛戟戢\
赍觊犄齑矶羁嵇稷瘠虮\
笈笄暨跻跽霁鲚鲫髻麂")
(qdl "jia" "\
嘉枷夹佳家加荚颊贾甲\
钾假稼价架驾嫁郏葭岬\
浃迦珈戛胛恝铗镓痂瘕\
袷蛱笳袈跏")
(qdl "jie" "\
揭接皆秸街阶截劫节桔\
杰捷睫竭洁结解姐戒藉\
芥界借介疥诫届讦拮喈\
嗟婕孑桀碣疖颉蚧羯鲒\
骱")
(qdl "jih" "\
僵姜将浆江疆蒋桨奖讲\
匠酱降茳洚绛缰犟礓耩\
糨豇")
(qdl "jij" "\
歼监坚尖笺间煎兼肩艰\
奸缄茧检柬碱硷拣捡简\
俭剪减荐槛鉴践贱见键\
箭件健舰剑饯渐溅涧建\
僭谏谫菅蒹搛囝湔蹇謇\
缣枧楗戋戬牮犍毽腱睑\
锏鹣裥笕翦趼踺鲣鞯")
(qdl "jik" "\
蕉椒礁焦胶交郊浇骄娇\
嚼搅铰矫侥脚狡角饺缴\
绞剿教酵轿较叫窖佼僬\
艽茭挢噍峤徼湫姣敫皎\
鹪蛟醮跤鲛")
(qdl "jin" "\
巾筋斤金今津襟紧锦仅\
谨进靳晋禁近烬浸尽劲\
卺荩堇噤馑廑妗缙瑾槿\
赆觐衿")
(qdl "jiq" "\
伽")
(qdl "jis" "\
炯窘迥扃")
(qdl "jiu" "\
揪究纠玖韭久灸九酒厩\
救旧臼舅咎就疚偈僦啾\
阄柩桕鸠鹫赳鬏")
(qdl "jv" "\
鞠拘狙疽居驹菊局咀矩\
举沮聚拒据巨具距踞锯\
俱句惧炬剧倨讵苣苴莒\
掬遽屦琚椐榘榉橘犋飓\
钜锔窭裾趄醵踽龃雎鞫")
(qdl "jve" "\
撅攫抉掘倔爵觉决诀绝\
厥劂谲矍蕨噘噱崛獗孓\
珏桷橛爝镢蹶觖")
(qdl "jvj" "\
捐鹃娟倦眷卷绢鄄狷涓\
桊蠲锩镌隽")
(qdl "jvn" "\
均菌钧军君峻俊竣浚郡\
骏捃皲筠麇")
(qdl "jy" "\
荆兢茎睛晶鲸京惊精粳\
经井警景颈静境敬镜径\
痉靖竟竞净刭儆阱菁獍\
憬泾迳弪婧肼胫腈旌靓")
(qdl "k" "\
凹敖熬翱袄傲奥懊澳坳\
拗嗷岙廒遨媪骜獒聱螯\
鏊鳌鏖")
(qdl "ka" "\
喀咖卡咯佧咔胩")
(qdl "ke" "\
坷苛柯棵磕颗科壳咳可\
渴克刻客课嗑岢恪溘骒\
缂珂轲氪瞌钶锞稞疴窠\
颏蝌髁")
(qdl "kf" "\
肯啃垦恳裉龈")
(qdl "kg" "\
坑吭铿")
(qdl "kh" "\
康慷糠扛抗亢炕伉闶钪")
(qdl "kj" "\
刊堪勘坎砍看侃莰阚戡\
龛瞰")
(qdl "kk" "\
考拷烤靠尻栲犒铐")
(qdl "kl" "\
开揩楷凯慨剀垲蒈忾恺\
铠锎锴")
(qdl "kou" "\
抠口扣寇芤蔻叩眍筘")
(qdl "ks" "\
空恐孔控倥崆箜")
(qdl "ku" "\
枯哭窟苦酷库裤刳堀喾\
绔骷")
(qdl "kua" "\
夸垮挎跨胯侉")
(qdl "kuh" "\
匡筐狂框矿眶旷况诓诳\
邝圹夼哐纩贶")
(qdl "kui" "\
亏盔岿窥葵奎魁傀馈愧\
溃馗夔隗蒉揆喹喟悝愦\
逵暌睽聩蝰篑跬")
(qdl "kuj" "\
宽款髋")
(qdl "kul" "\
块筷侩快蒯郐哙狯脍")
(qdl "kun" "\
坤昆捆困悃阃琨锟醌鲲\
髡")
(qdl "kuo" "\
括扩廓阔蛞")
(qdl "l" "\
埃挨哎唉哀皑癌蔼矮艾\
碍爱隘捱嗳嗌嫒瑷暧砹\
锿霭")
(qdl "la" "\
垃拉喇蜡腊辣啦剌邋旯\
砬瘌")
(qdl "le" "\
勒乐仂叻泐鳓")
(qdl "lei" "\
雷镭蕾磊累儡垒擂肋类\
泪羸诔嘞嫘缧檑耒酹")
(qdl "lg" "\
棱楞冷塄愣")
(qdl "lh" "\
琅榔狼廊郎朗浪莨蒗啷\
阆锒稂螂")
(qdl "li" "\
厘梨犁黎篱狸离漓理李\
里鲤礼莉荔吏栗丽厉励\
砾历利傈例俐痢立粒沥\
隶力璃哩俪俚郦坜苈莅\
蓠藜呖唳喱猁溧澧逦娌\
嫠骊缡枥栎轹戾砺詈罹\
锂鹂疠疬蛎蜊蠡笠篥粝\
醴跞雳鲡鳢黧")
(qdl "lia" "\
俩")
(qdl "lie" "\
列裂烈劣猎冽埒捩咧洌\
趔躐鬣")
(qdl "lih" "\
粮凉梁粱良两辆量晾亮\
谅墚椋踉魉")
(qdl "lij" "\
联莲连镰廉怜涟帘敛脸\
链恋炼练蔹奁潋濂琏楝\
殓臁裢裣蠊鲢")
(qdl "lik" "\
撩聊僚疗燎寥辽潦了撂\
镣廖料蓼尥嘹獠寮缭钌\
鹩")
(qdl "lin" "\
琳林磷霖临邻鳞淋凛赁\
吝蔺啉嶙廪懔遴檩辚膦\
瞵粼躏麟")
(qdl "liu" "\
溜琉榴硫馏留刘瘤流柳\
六浏遛骝绺旒熘锍镏鹨\
鎏")
(qdl "lj" "\
蓝婪栏拦篮阑兰澜谰揽\
览懒缆烂滥岚漤榄斓罱\
镧褴")
(qdl "lk" "\
捞劳牢老佬姥酪烙涝唠\
崂栳铑铹痨耢醪")
(qdl "ll" "\
莱来赖崃徕涞濑赉睐铼\
癞籁")
(qdl "lou" "\
楼娄搂篓漏陋偻蒌喽嵝\
镂瘘耧蝼髅")
(qdl "ls" "\
龙聋咙笼窿隆垄拢陇垅\
茏泷珑栊胧砻癃")
(qdl "lu" "\
芦卢颅庐炉掳卤虏鲁麓\
碌露路赂鹿潞禄录陆戮\
倮垆撸噜泸渌漉逯璐栌\
橹轳辂辘氇胪镥鸬鹭簏\
舻鲈")
(qdl "luj" "\
峦挛孪滦卵乱娈栾鸾銮")
(qdl "lun" "\
抡轮伦仑沦纶论囵")
(qdl "luo" "\
萝螺罗逻锣箩骡裸落洛\
骆络蠃荦摞猡泺漯珞椤\
脶镙瘰雒")
(qdl "luz" "\
脔")
(qdl "lv" "\
驴吕铝侣旅履屡缕虑氯\
律率滤绿捋闾榈膂稆褛")
(qdl "lve" "\
掠略锊")
(qdl "ly" "\
拎玲菱零龄铃伶羚凌灵\
陵岭领另令酃苓呤囹泠\
绫柃棂瓴聆蛉翎鲮")
(qdl "m" "\
呒")
(qdl "ma" "\
妈麻玛码蚂马骂嘛吗唛\
犸嬷杩蟆")
(qdl "me" "\
么麽")
(qdl "mei" "\
玫枚梅酶霉煤没眉媒镁\
每美昧寐妹媚莓嵋猸浼\
湄楣镅鹛袂魅")
(qdl "mf" "\
门闷们扪焖懑钔")
(qdl "mg" "\
萌蒙檬盟锰猛梦孟勐甍\
瞢懵朦礞虻蜢蠓艋艨")
(qdl "mh" "\
芒茫盲氓忙莽邙漭硭蟒")
(qdl "mi" "\
眯醚靡糜迷谜弥米秘觅\
泌蜜密幂芈谧蘼咪嘧猕\
汨宓弭脒祢敉糸縻麋")
(qdl "mie" "\
蔑灭乜咩蠛篾")
(qdl "mij" "\
棉眠绵冕免勉娩缅面沔\
湎腼眄")
(qdl "mik" "\
苗描瞄藐秒渺庙妙喵邈\
缈缪杪淼眇鹋")
(qdl "min" "\
民抿皿敏悯闽苠岷闵泯\
缗玟珉愍黾鳘")
(qdl "miu" "\
谬")
(qdl "mj" "\
瞒馒蛮满蔓曼慢漫谩墁\
幔缦熳镘颟螨鳗鞔")
(qdl "mk" "\
猫茅锚毛矛铆卯茂冒帽\
貌贸袤茆峁泖瑁昴牦耄\
旄懋瞀蝥蟊髦")
(qdl "ml" "\
埋买麦卖迈脉劢荬霾")
(qdl "mo" "\
摸摹蘑模膜磨摩魔抹末\
莫墨默沫漠寞陌谟茉蓦\
馍嫫殁镆秣瘼耱貊貘")
(qdl "mou" "\
谋牟某侔哞眸蛑鍪")
(qdl "mu" "\
拇牡亩姆母墓暮幕募慕\
木目睦牧穆仫坶苜沐毪\
钼")
(qdl "my" "\
明螟鸣铭名命冥茗溟暝\
瞑酩")
(qdl "n" "\
唔嗯")
(qdl "na" "\
拿哪呐钠那娜纳捺肭镎\
衲")
(qdl "ne" "\
呢讷")
(qdl "nei" "\
馁内")
(qdl "nf" "\
嫩恁")
(qdl "ng" "\
能")
(qdl "nh" "\
囊攮囔馕曩")
(qdl "ni" "\
妮霓倪泥尼拟你匿腻逆\
溺伲坭猊怩昵旎慝睨铌\
鲵")
(qdl "nie" "\
捏聂孽啮镊镍涅陧蘖嗫\
颞臬蹑")
(qdl "nih" "\
娘酿")
(qdl "nij" "\
蔫拈年碾撵捻念廿埝辇\
黏鲇鲶")
(qdl "nik" "\
鸟尿茑嬲脲袅")
(qdl "nin" "\
您")
(qdl "niu" "\
牛扭钮纽狃忸妞")
(qdl "nj" "\
南男难喃囡楠腩蝻赧")
(qdl "nk" "\
挠脑恼闹淖孬垴呶猱瑙\
硇铙蛲")
(qdl "nl" "\
氖乃奶耐奈鼐艿萘柰")
(qdl "nou" "\
耨")
(qdl "ns" "\
脓浓农弄侬哝")
(qdl "nu" "\
奴努怒挪懦糯诺弩胬孥\
驽")
(qdl "nuj" "\
暖")
(qdl "nuo" "\
傩搦喏锘")
(qdl "nv" "\
女恧钕衄")
(qdl "nve" "\
虐疟")
(qdl "ny" "\
柠狞凝宁拧泞佞苎咛甯\
聍")
(qdl "o" "\
哦喔噢")
(qdl "ou" "\
欧鸥殴藕呕偶沤讴怄瓯\
耦")
(qdl "pa" "\
啪趴爬帕怕琶葩杷筢")
(qdl "pei" "\
呸胚培裴赔陪配佩沛辔\
帔旆锫醅霈")
(qdl "pf" "\
喷盆湓")
(qdl "pg" "\
砰抨烹澎彭蓬棚硼篷膨\
朋鹏捧碰堋嘭怦蟛")
(qdl "ph" "\
乓庞旁耪胖彷滂逄螃")
(qdl "pi" "\
坯砒霹批披劈琵毗啤脾\
疲皮匹痞僻屁譬丕仳陴\
邳郫圮埤鼙芘拚擗噼庀\
淠媲纰枇甓睥罴铍癖疋\
蚍蜱貔")
(qdl "pie" "\
撇瞥丿苤氕")
(qdl "pij" "\
篇偏片骗谝骈犏胼翩蹁")
(qdl "pik" "\
飘漂瓢票剽嘌嫖缥殍瞟\
螵")
(qdl "pin" "\
拼频贫品聘姘嫔榀牝颦")
(qdl "pj" "\
攀潘盘磐盼畔判叛爿泮\
袢襻蟠蹒")
(qdl "pk" "\
抛咆刨炮袍跑泡匏狍庖\
脬疱")
(qdl "pl" "\
拍排牌徘湃派俳蒎哌")
(qdl "po" "\
坡泼颇婆破魄迫粕叵鄱\
珀攴钋钷皤笸")
(qdl "pou" "\
剖裒掊")
(qdl "pu" "\
扑铺仆莆葡菩蒲埔朴圃\
普浦谱曝瀑匍噗溥濮璞\
氆镤镨蹼")
(qdl "py" "\
乒坪苹萍平凭瓶评屏俜\
娉枰鲆")
(qdl "qi" "\
期欺栖戚妻七凄漆柒沏\
其棋奇歧畦崎脐齐旗祈\
祁骑起岂乞企启契砌器\
气迄弃汽泣讫亓俟圻芑\
芪萁萋葺蕲嘁屺岐汔淇\
骐绮琪琦杞桤槭耆欹祺\
憩碛颀蛴蜞綦蹊鳍麒")
(qdl "qia" "\
掐恰洽葜髂")
(qdl "qie" "\
切茄且怯窃郄惬妾挈锲\
箧")
(qdl "qih" "\
枪呛腔羌墙蔷强抢戕嫱\
樯戗炝锖锵镪襁蜣羟跄")
(qdl "qij" "\
牵扦钎铅千迁签仟谦乾\
黔钱钳前潜遣浅谴堑嵌\
欠歉倩佥阡芊芡茜荨掮\
岍悭慊骞搴褰缱椠肷愆\
钤虔箝")
(qdl "qik" "\
橇锹敲悄桥瞧乔侨巧鞘\
撬翘峭俏窍劁诮谯荞愀\
憔缲樵硗跷鞒")
(qdl "qin" "\
钦侵亲秦琴勤芹擒禽寝\
沁芩揿吣嗪噙溱檎锓覃\
螓衾")
(qdl "qis" "\
琼穷邛茕穹蛩筇跫銎")
(qdl "qiu" "\
秋丘邱球求囚酋泅俅巯\
犰逑遒楸赇虬蚯蝤裘糗\
鳅鼽")
(qdl "qv" "\
趋区蛆曲躯屈驱渠取娶\
龋趣去诎劬蕖蘧岖衢阒\
璩觑氍朐祛磲鸲癯蛐蠼\
麴瞿黢")
(qdl "qve" "\
缺炔瘸却鹊榷确雀阕阙\
悫")
(qdl "qvj" "\
圈颧权醛泉全痊拳犬券\
劝诠荃悛绻辁畎铨蜷筌\
鬈")
(qdl "qvn" "\
裙群逡")
(qdl "qy" "\
青轻氢倾卿清擎晴氰情\
顷请庆苘圊檠磬蜻罄箐\
綮謦鲭黥")
(qdl "re" "\
惹热")
(qdl "rf" "\
壬仁人忍韧任认刃妊纫\
仞荏葚饪轫稔衽")
(qdl "rg" "\
扔仍")
(qdl "rh" "\
瓤壤攘嚷让禳穰")
(qdl "ri" "\
日")
(qdl "rj" "\
然燃冉染苒蚺髯")
(qdl "rk" "\
饶扰绕荛娆桡")
(qdl "rou" "\
揉柔肉糅蹂鞣")
(qdl "rs" "\
戎茸蓉荣融熔溶容绒冗\
嵘狨榕肜蝾")
(qdl "ru" "\
茹蠕儒孺如辱乳汝入褥\
偌蓐薷嚅洳溽濡缛铷襦\
颥")
(qdl "rui" "\
蕊瑞锐芮蕤枘睿蚋")
(qdl "ruj" "\
软阮")
(qdl "run" "\
闰润")
(qdl "ruo" "\
若弱箬")
(qdl "ruz" "\
朊")
(qdl "sa" "\
撒洒萨卅仨挲脎飒")
(qdl "se" "\
瑟色涩啬铯穑")
(qdl "sf" "\
森")
(qdl "sg" "\
僧")
(qdl "sh" "\
桑嗓丧搡磉颡")
(qdl "si" "\
斯撕嘶思私司丝死肆寺\
嗣四伺似饲巳厮兕厶咝\
汜泗澌姒驷缌祀锶鸶耜\
蛳笥")
(qdl "sj" "\
三叁伞散馓毵糁霰")
(qdl "sk" "\
搔骚扫嫂埽缫臊瘙鳋")
(qdl "sl" "\
腮鳃塞赛噻")
(qdl "sou" "\
搜艘擞嗽叟薮嗖嗾馊溲\
飕瞍锼螋")
(qdl "ss" "\
松耸怂颂送宋讼诵凇菘\
崧嵩忪悚淞竦")
(qdl "su" "\
苏酥俗素速粟僳塑溯宿\
诉肃夙谡蔌嗉愫涑簌觫\
稣")
(qdl "sui" "\
虽隋随绥髓碎岁穗遂隧\
祟谇濉邃燧眭睢")
(qdl "suj" "\
酸蒜算狻")
(qdl "sun" "\
孙损笋荪狲飧榫隼")
(qdl "suo" "\
蓑梭唆缩琐索锁所唢嗦\
嗍娑桫睃羧")
(qdl "suy" "\
荽")
(qdl "ta" "\
塌他它她塔獭挞蹋踏闼\
溻遢榻铊趿鳎")
(qdl "te" "\
特忒忑铽")
(qdl "tg" "\
藤疼誊滕")
(qdl "th" "\
汤塘搪堂棠膛唐糖倘躺\
淌趟烫傥帑溏瑭樘铴镗\
耥螗螳羰醣")
(qdl "ti" "\
梯剔踢锑提题蹄啼体替\
嚏惕涕剃屉倜悌逖缇鹈\
裼醍")
(qdl "tie" "\
贴铁帖萜餮")
(qdl "tij" "\
天添填田甜恬舔腆掭忝\
阗殄畋")
(qdl "tik" "\
挑条迢眺跳佻祧窕蜩笤\
粜龆鲦髫")
(qdl "tj" "\
坍摊贪瘫滩坛檀痰潭谭\
谈坦毯袒碳探叹炭郯澹\
昙忐钽锬")
(qdl "tk" "\
掏涛滔绦萄桃逃淘陶讨\
套鼗啕洮韬焘饕")
(qdl "tl" "\
胎苔抬台泰酞太态汰邰\
薹肽炱钛跆鲐")
(qdl "tou" "\
偷投头透钭骰")
(qdl "ts" "\
通桐酮瞳同铜彤童桶捅\
筒统痛佟仝茼嗵恸潼砼")
(qdl "tu" "\
凸秃突图徒途涂屠土吐\
兔堍荼菟钍酴")
(qdl "tui" "\
推颓腿蜕褪退煺")
(qdl "tuj" "\
湍团抟彖疃")
(qdl "tun" "\
吞屯臀氽饨暾豚")
(qdl "tuo" "\
拖托脱鸵陀驮驼椭妥拓\
唾乇佗坨庹沱柝橐砣箨\
酡跎鼍")
(qdl "ty" "\
厅听烃汀廷停亭庭挺艇\
莛葶婷梃铤蜓霆")
(qdl "ua" "\
莎砂杀刹沙纱傻啥煞唼\
猹歃铩痧裟霎鲨")
(qdl "ue" "\
奢赊蛇舌舍赦摄射慑涉\
社设厍佘猞滠歙畲麝")
(qdl "uf" "\
砷申呻伸身深娠绅神沈\
审婶甚肾慎渗诜谂莘哂\
渖椹胂矧蜃")
(qdl "ug" "\
声生甥牲升绳省盛剩胜\
圣嵊渑晟眚笙")
(qdl "uh" "\
墒伤商赏晌上尚裳垧绱\
殇熵觞")
(qdl "ui" "\
师失狮施湿诗尸虱十石\
拾时什食蚀实识史矢使\
屎驶始式示士世柿事拭\
誓逝势是嗜噬适仕侍释\
饰氏市恃室视试谥埘莳\
蓍弑轼贳炻铈螫舐筮豕\
鲥鲺")
(qdl "uj" "\
珊苫杉山删煽衫闪陕擅\
赡膳善汕扇缮讪鄯芟潸\
姗嬗骟膻钐疝蟮舢跚鳝")
(qdl "uk" "\
梢捎稍烧芍勺韶少哨邵\
绍劭苕潲杓蛸筲艄")
(qdl "ul" "\
筛晒酾")
(qdl "uou" "\
收手首守寿授售受瘦兽\
狩绶艏")
(qdl "uu" "\
蔬枢梳殊抒输叔舒淑疏\
书赎孰熟薯暑曙署蜀黍\
鼠属术述树束戍竖墅庶\
数漱恕丨倏塾菽摅沭澍\
姝纾毹腧殳秫蟀")
(qdl "uua" "\
刷耍唰")
(qdl "uuh" "\
霜双爽孀")
(qdl "uui" "\
谁水睡税")
(qdl "uuj" "\
栓拴闩涮")
(qdl "uul" "\
摔衰甩帅")
(qdl "uun" "\
吮瞬顺舜")
(qdl "uuo" "\
说硕朔烁蒴搠妁槊铄")
(qdl "wa" "\
挖哇蛙洼娃瓦袜佤娲腽")
(qdl "wei" "\
威巍微危韦违桅围唯惟\
为潍维苇萎委伟伪尾纬\
未蔚味畏胃喂魏位渭谓\
尉慰卫偎诿隈圩葳薇囗\
帏帷崴嵬猥猬闱沩洧涠\
逶娓玮韪軎炜煨痿艉鲔")
(qdl "wf" "\
瘟温蚊文闻纹吻稳紊问\
刎阌汶璺雯")
(qdl "wg" "\
嗡翁瓮蓊蕹")
(qdl "wh" "\
汪王亡枉网往旺望忘妄\
罔尢惘辋魍")
(qdl "wj" "\
豌弯湾玩顽丸烷完碗挽\
晚皖惋宛婉万腕剜芄莞\
菀纨绾琬脘畹蜿")
(qdl "wl" "\
歪外")
(qdl "wo" "\
挝蜗涡窝我斡卧握沃倭\
莴幄渥肟硪龌")
(qdl "wu" "\
巫呜钨乌污诬屋无芜梧\
吾吴毋武五捂午舞伍侮\
坞戊雾晤物勿务悟误兀\
仵阢邬圬芴庑怃忤浯寤\
迕妩婺骛杌牾焐鹉鹜痦\
蜈鋈鼯")
(qdl "xi" "\
昔熙析西硒矽晰嘻吸锡\
牺稀息希悉膝夕惜熄烯\
溪汐犀檄袭席习媳喜铣\
洗系隙戏细僖兮隰郗菥\
葸蓰奚唏徙饩阋浠淅屣\
嬉玺枵樨曦觋欷熹禊禧\
皙穸蜥螅蟋舄舾羲粞翕\
醯鼷")
(qdl "xia" "\
瞎虾匣霞辖暇峡侠狭下\
厦夏吓呷狎遐瑕柙硖罅\
黠")
(qdl "xie" "\
些歇蝎鞋协挟携邪斜胁\
谐写械卸蟹懈泄泻谢屑\
偕亵勰燮薤撷獬廨渫瀣\
邂绁缬榭榍躞")
(qdl "xih" "\
相厢镶香箱襄湘乡翔祥\
详想响享项巷橡像向象\
芗葙饷庠骧")
(qdl "xij" "\
掀锨先仙鲜纤咸贤衔闲\
涎弦嫌显险现献县腺馅\
羡宪陷限线冼苋莶藓岘\
猃暹娴氙燹祆鹇痫蚬筅\
籼酰跣跹")
(qdl "xik" "\
萧硝霄削哮嚣销消宵淆\
晓小孝校肖啸笑效哓崤\
潇逍骁绡枭筱箫魈")
(qdl "xin" "\
薪芯锌欣辛新忻心信衅\
囟馨昕歆鑫")
(qdl "xis" "\
兄凶胸匈汹雄熊芎")
(qdl "xiu" "\
楔休修羞朽嗅锈秀袖绣\
咻岫馐庥溴鸺貅髹")
(qdl "xix" "\
缃蟓鲞飨")
(qdl "xji" "\
舷")
(qdl "xv" "\
墟戌需虚嘘须徐许蓄酗\
叙旭序畜恤絮婿绪续诩\
勖蓿洫溆顼栩煦盱胥糈\
醑")
(qdl "xve" "\
靴薛学穴雪血谑泶踅鳕")
(qdl "xvj" "\
喧宣悬旋玄选癣眩绚儇\
谖萱揎泫渲漩璇楦暄炫\
煊碹铉镟痃")
(qdl "xvn" "\
勋熏循旬询寻驯巡殉汛\
训讯逊迅巽埙荀蕈薰峋\
徇獯恂洵浔曛醺鲟")
(qdl "xvz" "\
轩")
(qdl "xy" "\
星腥猩惺兴刑型形邢行\
醒幸杏性姓陉荇荥擤饧\
悻硎")
(qdl "ya" "\
压押鸦鸭呀丫芽牙蚜崖\
衙涯雅哑亚讶伢垭揠岈\
迓娅琊桠氩砑睚痖")
(qdl "ye" "\
椰噎耶爷野冶也页掖业\
叶曳腋夜液靥谒邺揶晔\
烨铘")
(qdl "yh" "\
殃央鸯秧杨扬佯疡羊洋\
阳氧仰痒养样漾徉怏泱\
炀烊恙蛘鞅")
(qdl "yi" "\
一壹医揖铱依伊衣颐夷\
遗移仪胰疑沂宜姨彝椅\
蚁倚已乙矣以艺抑易邑\
屹亿役臆逸肄疫亦裔意\
毅忆义益溢诣议谊译异\
翼翌绎刈劓佚佾诒圯埸\
懿苡荑薏弈奕挹弋叽呓\
咦咿噫峄嶷猗饴怿怡悒\
漪迤驿缢殪轶贻旖熠眙\
钇镒镱痍瘗癔翊蜴舣羿\
翳酏黟")
(qdl "yin" "\
茵荫因殷音阴姻吟银淫\
寅饮尹引隐印胤鄞垠堙\
茚吲喑狺夤洇氤铟瘾窨\
蚓霪")
(qdl "yj" "\
焉咽阉烟淹盐严研蜒岩\
延言颜阎炎沿奄掩眼衍\
演艳堰燕厌砚雁唁彦焰\
宴谚验厣赝剡俨偃兖谳\
郾鄢埏芫菸崦恹闫阏湮\
滟妍嫣琰檐晏胭焱罨筵\
酽魇餍鼹")
(qdl "yk" "\
邀腰妖瑶摇尧遥窑谣姚\
咬舀药要耀夭爻吆崾徭\
幺珧杳轺曜肴鹞窈繇鳐")
(qdl "yo" "\
哟唷")
(qdl "you" "\
幽优悠忧尤由邮铀犹油\
游酉有友右佑釉诱又幼\
卣攸侑莠莜莸呦囿宥柚\
猷牖铕疣蚰蚴蝣鱿黝鼬")
(qdl "ys" "\
拥佣臃痈庸雍踊蛹咏泳\
涌永恿勇用俑壅墉喁慵\
邕镛甬鳙饔")
(qdl "yu" "\
迂淤于盂榆虞愚舆余俞\
逾鱼愉渝渔隅予娱雨与\
屿禹宇语羽玉域芋郁吁\
遇喻峪御愈欲狱育誉浴\
寓裕预豫驭禺毓伛俣谀\
谕萸蓣揄圄圉嵛狳饫馀\
庾阈鬻妪妤纡瑜昱觎腴\
欤於煜熨燠聿钰鹆鹬瘐\
瘀窬窳蜮蝓竽臾舁雩龉")
(qdl "yue" "\
曰约越跃钥岳粤月悦阅\
龠瀹樾刖钺")
(qdl "yuj" "\
鸳渊冤元垣袁原援辕园\
员圆猿源缘远苑愿怨院\
垸塬掾沅媛瑗橼爰眢鸢\
螈箢鼋")
(qdl "yun" "\
耘云郧匀陨允运蕴酝晕\
韵孕郓芸狁恽愠纭韫殒\
昀氲")
(qdl "yy" "\
英樱婴鹰应缨莹萤营荧\
蝇迎赢盈影颖硬映嬴郢\
茔莺萦蓥撄嘤膺滢潆瀛\
瑛璎楹媵鹦瘿颍罂")
(qdl "za" "\
匝砸杂咂")
(qdl "ze" "\
责择则泽仄赜啧帻迮昃\
笮箦舴")
(qdl "zei" "\
贼")
(qdl "zf" "\
怎谮")
(qdl "zg" "\
增憎曾赠缯甑罾锃")
(qdl "zh" "\
赃脏葬驵臧")
(qdl "zi" "\
兹咨资姿滋淄孜紫仔籽\
滓子自渍字谘呲嵫姊孳\
缁梓辎赀恣眦锱秭耔笫\
粢趑觜訾龇鲻髭")
(qdl "zj" "\
咱攒暂赞拶瓒昝簪糌趱\
錾")
(qdl "zk" "\
遭糟凿藻枣早澡蚤躁噪\
造皂灶燥唣")
(qdl "zl" "\
栽哉灾宰载再在崽甾")
(qdl "zou" "\
邹走奏揍诹陬鄹驺鲰")
(qdl "zs" "\
鬃棕踪宗综总纵偬腙粽")
(qdl "zu" "\
租足卒族祖诅阻组俎阼\
菹镞")
(qdl "zui" "\
嘴醉最罪蕞")
(qdl "zuj" "\
钻纂攥缵躜")
(qdl "zun" "\
尊遵撙樽鳟")
(qdl "zuo" "\
昨左佐柞做作坐座唑嘬\
怍胙祚")
