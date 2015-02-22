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
;;	Original table is from cxterm/dict/tit/PY.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	GB
;; MULTICHOICE:	YES
;; PROMPT:	汉字输入∷拼音∷ 
;; #
;; COMMENT	拼音方案
;; COMMENT
;; COMMENT 小写英文字母代表「拼音」符号， "u(yu) 则用 u: 表示∶
;; # define keys
;; VALIDINPUTKEY:	:abcdefghijklmnopqrstuvwxyz
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
 "py" "拼音" nil 
 "小写英文字母代表「拼音」符号， \"u(yu) 则用 u: 表示"
 *quail-mode-rich-map* nil nil nil nil t)

(defmacro qdl (key str)
  (list 'quail-defrule key (list 'string-to-char-list str)))

(qdl "a" "\
啊阿呵吖腌锕嗄")
(qdl "ai" "\
埃挨哎唉哀捱锿皑癌呆\
蔼矮嗳霭艾碍爱隘嗌嫒\
瑷暧砹")
(qdl "an" "\
鞍氨安厂广谙庵桉鹌俺\
埯揞铵按暗岸胺案犴黯")
(qdl "ang" "\
肮昂盎")
(qdl "ao" "\
凹熬敖翱嚣嗷廒遨獒聱\
螯鳌鏖袄拗媪傲奥懊澳\
坳岙骜鏊")
(qdl "ba" "\
芭捌扒叭吧笆八疤巴岜\
粑拔跋茇菝魃靶把钯耙\
坝霸罢爸灞鲅")
(qdl "bai" "\
掰白柏百摆佰伯捭败拜\
稗呗")
(qdl "ban" "\
斑班搬扳般颁瘢癍板版\
阪坂钣舨扮拌伴瓣半办\
绊")
(qdl "bang" "\
邦帮梆浜榜膀绑棒磅蚌\
镑傍谤蒡")
(qdl "bao" "\
苞胞包褒剥炮孢煲龅薄\
雹保堡饱宝葆鸨褓抱报\
暴豹鲍爆刨曝瀑趵")
(qdl "bei" "\
杯碑悲卑背陂埤萆鹎北\
辈贝钡倍狈备惫焙被孛\
邶蓓悖碚褙鐾鞴臂呗")
(qdl "ben" "\
奔贲锛苯本畚笨夯坌")
(qdl "beng" "\
崩绷嘣甭蚌泵蹦迸甏")
(qdl "bi" "\
逼鼻荸比鄙笔彼匕俾吡\
妣秕舭碧蓖蔽毕毙毖币\
庇痹闭敝弊必辟壁臂避\
陛拂秘泌埤芘荜萆薜哔\
狴庳愎滗濞弼婢嬖璧贲\
畀铋裨筚箅篦襞跸髀")
(qdl "bian" "\
鞭边编煸砭蝙笾鳊贬扁\
匾碥窆褊便变卞辨辩辫\
遍弁苄忭汴缏")
(qdl "biao" "\
标彪膘勺骠杓飑飙飚镖\
镳瘭髟表婊裱鳔")
(qdl "bie" "\
鳖憋瘪别蹩")
(qdl "bin" "\
彬斌濒滨宾傧豳缤玢槟\
镔摈殡膑髌鬓")
(qdl "bing" "\
兵冰并槟柄丙秉饼炳屏\
禀邴病摒")
(qdl "bo" "\
般剥玻菠播拨钵波饽趵\
柏百薄博勃搏铂箔伯帛\
舶脖膊渤泊驳魄孛亳礴\
钹鹁踣簸跛檗掰擘卜啵")
(qdl "bu" "\
逋晡钸不醭堡捕卜哺补\
卟埠布步簿部怖埔瓿钚")
(qdl "ca" "\
擦拆嚓礤")
(qdl "cai" "\
猜裁材才财睬踩采彩菜\
蔡")
(qdl "can" "\
餐参骖蚕残惭惨黪灿掺\
孱璨粲")
(qdl "cang" "\
苍舱仓沧伧藏")
(qdl "cao" "\
操糙槽曹嘈漕螬艚草")
(qdl "ce" "\
厕策侧册测恻")
(qdl "cen" "\
参岑涔")
(qdl "ceng" "\
噌层曾蹭")
(qdl "cha" "\
插叉碴差喳嚓馇杈锸茬\
茶查搽察猹楂槎檫镲衩\
岔诧刹汊姹")
(qdl "chai" "\
差拆钗柴豺侪瘥虿")
(qdl "chan" "\
搀掺觇蝉馋谗缠单廛潺\
澶孱婵禅镡蟾躔铲产阐\
冁谄蒇骣颤忏羼")
(qdl "chang" "\
昌猖伥菖阊娼鲳场尝常\
长偿肠裳倘苌徜嫦厂敞\
惝昶氅畅唱倡鬯怅")
(qdl "chao" "\
超抄钞吵绰剿怊焯朝嘲\
潮巢晁炒耖")
(qdl "che" "\
车砗扯尺撤掣彻澈坼")
(qdl "chen" "\
郴抻嗔琛臣辰尘晨忱沉\
陈橙沈谌宸碜趁衬称秤\
谶榇龀伧")
(qdl "cheng" "\
撑称秤噌柽瞠铛蛏城橙\
成呈乘程惩澄诚承盛丞\
埕枨塍铖裎酲逞骋")
(qdl "chi" "\
吃痴哧嗤媸眵鸱蚩螭笞\
魑持匙池迟弛驰坻墀茌\
篪踟耻齿侈尺褫豉赤翅\
斥炽傺叱啻彳饬敕瘛")
(qdl "chong" "\
充冲涌茺忡憧舂艟虫崇\
种重宠铳")
(qdl "chou" "\
抽瘳酬畴踌稠愁筹仇绸\
俦帱惆雠瞅丑臭")
(qdl "chu" "\
初出樗橱厨躇锄雏滁除\
刍蜍蹰楚础储处杵楮褚\
矗搐触畜亍怵憷绌黜")
(qdl "chuai" "\
揣搋啜嘬膪踹")
(qdl "chuan" "\
川穿巛氚椽传船遄舡喘\
舛串钏")
(qdl "chuang" "\
疮窗创幢床闯怆")
(qdl "chui" "\
吹炊捶锤垂椎陲棰槌")
(qdl "chun" "\
春椿蝽醇唇淳纯莼鹑蠢")
(qdl "chuo" "\
戳踔绰啜辍龊")
(qdl "ci" "\
差疵刺呲茨磁雌辞慈瓷\
词兹茈祠鹚糍此赐次伺")
(qdl "cong" "\
聪葱囱匆从苁骢璁枞丛\
淙琮")
(qdl "cou" "\
凑楱辏腠")
(qdl "cu" "\
粗徂殂醋簇促卒蔟猝酢\
蹙蹴")
(qdl "cuan" "\
蹿汆撺镩攒篡窜爨")
(qdl "cui" "\
摧崔催衰榱隹璀脆瘁粹\
淬翠萃啐悴毳")
(qdl "cun" "\
村皴存蹲忖寸")
(qdl "cuo" "\
磋撮搓蹉嵯矬痤瘥鹾脞\
措挫错厝锉")
(qdl "da" "\
搭答耷哒嗒褡达瘩打怛\
妲沓笪靼鞑大塔疸")
(qdl "dai" "\
呆待呔歹傣逮大戴带殆\
代贷袋怠埭甙岱迨骀绐\
玳黛")
(qdl "dan" "\
耽担丹单郸儋殚眈瘅聃\
箪掸胆赕疸旦氮但惮淡\
诞弹蛋石萏啖澹")
(qdl "dang" "\
当铛裆挡党谠荡档凼菪\
宕砀")
(qdl "dao" "\
刀叨忉氘捣蹈倒岛祷导\
到稻悼道盗帱焘纛")
(qdl "de" "\
德得锝的底地")
(qdl "dei" "\
得")
(qdl "deng" "\
蹬灯登噔簦等戥澄瞪凳\
邓嶝磴镫")
(qdl "di" "\
堤低滴提氐嘀镝羝的迪\
敌笛狄涤翟嫡籴荻觌抵\
底诋邸坻柢砥骶地蒂第\
帝弟递缔谛娣绨棣碲睇")
(qdl "dia" "\
嗲")
(qdl "dian" "\
颠掂滇巅癫碘点典丶踮\
靛垫电佃甸店惦奠淀殿\
阽坫玷钿癜簟")
(qdl "diao" "\
碉叼雕凋刁貂鲷鸟掉吊\
钓调铞铫")
(qdl "die" "\
跌爹踮碟蝶迭谍叠佚垤\
堞揲喋牒瓞耋蹀鲽")
(qdl "ding" "\
丁盯叮钉仃玎町疔耵酊\
顶鼎锭定订啶腚碇铤")
(qdl "diu" "\
丢铥")
(qdl "dong" "\
东冬咚岽氡鸫董懂硐动\
栋侗恫冻洞垌峒胨胴")
(qdl "dou" "\
兜都蔸篼抖斗陡蚪豆逗\
痘读窦")
(qdl "du" "\
都督嘟毒犊独读顿渎椟\
牍髑黩堵睹赌肚笃杜镀\
度渡妒芏蠹")
(qdl "duan" "\
端短锻段断缎椴煅簖")
(qdl "dui" "\
堆兑队对敦怼憝碓镦")
(qdl "dun" "\
墩吨蹲敦礅镦盹趸顿囤\
钝盾遁沌炖砘")
(qdl "duo" "\
掇哆多咄裰度夺铎踱垛\
躲朵哚缍跺舵剁惰堕驮\
沲柁")
(qdl "e" "\
阿屙婀蛾峨鹅俄额讹娥\
哦莪锇恶厄扼遏鄂饿噩\
谔垩苊萼呃愕阏轭腭锷\
鹗颚鳄")
(qdl "ei" "\
诶")
(qdl "en" "\
恩蒽摁")
(qdl "er" "\
而儿鸸鲕耳尔饵洱迩珥\
铒二贰佴")
(qdl "fa" "\
发罚筏伐乏阀垡法砝珐")
(qdl "fan" "\
藩帆番翻蕃幡樊矾钒繁\
凡烦泛蘩燔蹯反返范贩\
犯饭梵畈")
(qdl "fang" "\
坊芳方妨邡枋钫肪房防\
鲂仿访纺彷舫放")
(qdl "fei" "\
菲非啡飞妃绯扉蜚霏鲱\
肥淝腓匪诽悱榧斐篚翡\
吠肺废沸费芾狒镄痱")
(qdl "fen" "\
芬酚吩氛分纷玢坟焚汾\
棼鼢粉奋份忿愤粪偾瀵\
鲼")
(qdl "feng" "\
丰封枫蜂峰锋风疯烽酆\
葑沣砜逢冯缝讽唪奉凤\
俸")
(qdl "fo" "\
佛")
(qdl "fou" "\
否缶")
(qdl "fu" "\
夫敷肤孵呋稃麸趺跗佛\
扶拂辐幅氟符伏俘服浮\
涪福袱弗匐凫郛芙芾苻\
茯莩菔幞怫艴孚绂绋桴\
祓砩黻罘蚨蜉蝠甫抚辅\
俯釜斧脯腑府腐父拊滏\
黼赴副覆赋复傅付阜腹\
负富讣附妇缚咐驸赙馥\
蝮鲋鳆")
(qdl "ga" "\
嘎胳夹咖伽旮噶轧尜钆\
尕尬")
(qdl "gai" "\
该陔垓赅改概钙盖溉芥\
丐戤")
(qdl "gan" "\
干甘杆柑竿肝乾坩苷尴\
泔矸疳酐赶感秆敢擀澉\
橄赣淦绀旰")
(qdl "gang" "\
冈刚钢缸肛纲杠扛罡岗\
港戆筻")
(qdl "gao" "\
篙皋高膏羔糕睾槔搞镐\
稿藁缟槁杲告诰郜锆")
(qdl "ge" "\
哥歌搁戈鸽胳疙割格咯\
屹仡圪纥袼革葛蛤阁隔\
鬲塥嗝搿膈镉颌骼盖个\
各合哿舸铬硌虼")
(qdl "gei" "\
给")
(qdl "gen" "\
根跟哏艮亘茛")
(qdl "geng" "\
耕更庚羹赓埂耿梗颈哽\
绠鲠")
(qdl "gong" "\
工攻功恭龚供躬公宫弓\
共红肱蚣觥巩汞拱珙贡")
(qdl "gou" "\
钩勾沟句佝缑枸篝鞲苟\
狗岣笱垢构购够诟遘媾\
觏彀")
(qdl "gu" "\
辜菇咕箍估沽孤姑骨菰\
呱轱毂鸪蛄酤觚鼓古蛊\
谷股贾嘏诂汩牯臌瞽罟\
钴鹄鹘故顾固雇崮梏牿\
锢痼鲴")
(qdl "gua" "\
刮瓜括呱栝胍鸹剐寡挂\
褂卦诖")
(qdl "guai" "\
乖掴拐怪")
(qdl "guan" "\
棺关官冠观纶倌莞矜鳏\
管馆罐惯灌贯掼涫盥鹳")
(qdl "guang" "\
光咣桄胱广犷逛")
(qdl "gui" "\
瑰规圭硅归龟闺傀妫皈\
鲑轨鬼诡癸匦庋宄晷簋\
桂柜跪贵刽炔刿桧炅鳜")
(qdl "gun" "\
辊滚衮绲磙鲧棍")
(qdl "guo" "\
锅郭过涡埚呙崞聒蝈国\
馘掴帼虢果裹猓椁蜾")
(qdl "ha" "\
哈铪蛤虾")
(qdl "hai" "\
嘿咳嗨骸孩还海胲醢氦\
亥害骇")
(qdl "han" "\
酣憨顸蚶鼾邯韩含涵寒\
函汗邗晗焓喊罕阚翰撼\
捍旱憾悍焊汉菡撖瀚颔")
(qdl "hang" "\
夯杭航吭行绗珩颃巷沆")
(qdl "hao" "\
蒿薅嚆壕嚎豪毫号貉嗥\
濠蚝郝好镐耗浩灏昊皓\
颢")
(qdl "he" "\
呵喝诃嗬荷菏核禾和何\
合盒貉阂河涸劾阖纥曷\
盍颌蚵翮赫褐鹤贺吓壑")
(qdl "hei" "\
嘿黑嗨")
(qdl "hen" "\
痕很狠恨")
(qdl "heng" "\
哼亨横衡恒行蘅珩桁")
(qdl "hng" "\
哼")
(qdl "hong" "\
轰哄烘訇薨虹鸿洪宏弘\
红黉荭蕻闳泓讧")
(qdl "hou" "\
喉侯猴瘊篌糇骺吼厚候\
后堠後逅鲎")
(qdl "hu" "\
呼乎忽糊戏唿惚滹轷烀\
核和瑚壶葫胡蝴狐湖弧\
囫猢槲觳煳鹄鹕醐斛鹘\
虎唬浒琥护互沪户冱岵\
怙戽扈祜瓠鹱笏")
(qdl "hua" "\
花哗华化砉猾滑划豁骅\
铧画话桦")
(qdl "huai" "\
槐徊怀淮踝坏划")
(qdl "huan" "\
欢獾环桓还郇萑圜洹寰\
缳锾鬟缓换患唤痪豢焕\
涣宦幻奂擐浣漶逭鲩")
(qdl "huang" "\
荒慌肓黄磺蝗簧皇凰惶\
煌隍徨湟潢遑璜癀蟥篁\
鳇晃幌恍谎")
(qdl "hui" "\
堕灰挥辉徽恢诙咴隳珲\
晖虺麾徊蛔回茴洄毁悔\
慧卉惠晦贿秽会烩汇讳\
诲绘溃荟蕙哕喙浍彗缋\
桧恚蟪")
(qdl "hun" "\
荤昏婚阍魂浑混馄珲诨\
溷")
(qdl "huo" "\
豁劐攉锪耠和活伙火夥\
钬获或惑霍货祸藿嚯镬\
蠖")
(qdl "ji" "\
击圾基机畸稽积箕肌饥\
迹激讥鸡姬绩缉几期其\
奇丌乩剞墼芨叽咭唧屐\
畿玑赍犄齑矶羁嵇笄跻\
革吉极棘辑籍集及急疾\
汲即嫉级脊藉亟佶诘蒺\
蕺岌嵴楫殛戢瘠笈给挤\
己济纪掎戟虮麂蓟技冀\
季伎祭剂悸寄寂计记既\
忌际妓继齐系偈芰荠哜\
洎骥觊稷暨跽霁鲚鲫髻")
(qdl "jia" "\
嘉枷夹佳家加茄挟伽葭\
浃迦珈镓痂笳袈跏荚颊\
郏戛恝铗袷蛱贾甲钾假\
搅铰矫侥脚狡角饺缴绞\
剿嘏佼挢岬徼湫敫胛皎\
瘕稼价架驾嫁")
(qdl "jian" "\
歼监坚尖笺间煎兼肩艰\
奸缄渐溅浅菅蒹搛湔缣\
戋犍鹣鲣鞯茧检柬碱硷\
拣捡简俭剪减谫囝蹇謇\
枧戬睑锏裥笕翦趼荐槛\
鉴践贱见键箭件健舰剑\
饯涧建僭谏楗牮毽腱踺")
(qdl "jiang" "\
僵姜将浆江疆茳缰礓豇\
蒋桨奖讲耩虹匠酱降强\
洚绛犟糨")
(qdl "jiao" "\
蕉椒礁焦胶交郊浇骄娇\
教僬艽茭姣鹪蛟跤鲛嚼\
矫峤搅铰侥脚狡角饺缴\
绞剿佼挢徼湫敫皎酵轿\
较叫窖觉校噍醮")
(qdl "jie" "\
揭接皆秸街阶节结楷喈\
嗟疖截劫桔杰捷睫竭洁\
偈讦诘拮婕孑桀碣颉羯\
鲒解姐价戒藉芥界借介\
疥诫届蚧骱家")
(qdl "jin" "\
巾筋斤金今津襟禁衿矜\
紧锦仅谨尽卺堇馑廑瑾\
槿进靳晋近烬浸劲荩噤\
妗缙赆觐")
(qdl "jing" "\
荆兢茎睛晶鲸京惊精粳\
经菁泾腈旌井警景颈刭\
儆阱憬肼劲静境敬镜径\
痉靖竟竞净獍迳弪婧胫\
靓")
(qdl "jiong" "\
扃炯窘迥炅")
(qdl "jiu" "\
揪究纠啾阄鸠赳鬏玖韭\
久灸九酒厩救旧臼舅咎\
就疚僦柩桕鹫")
(qdl "ju" "\
车鞠拘狙疽居驹据锯俱\
且苴掬琚椐锔裾趄雎鞫\
桔菊局橘柜咀矩举沮莒\
枸榉踽龃聚拒巨具距踞\
句惧炬剧倨讵苣遽屦榘\
犋飓钜窭醵瞿")
(qdl "juan" "\
捐鹃娟圈涓蠲镌卷锩倦\
眷绢俊鄄狷桊隽")
(qdl "jue" "\
撅嗟噘嚼脚角攫抉掘倔\
爵觉决诀绝厥劂谲矍蕨\
噱崛獗孓珏桷橛爝镢蹶\
觖")
(qdl "jun" "\
龟均菌钧军君皲筠麇峻\
俊竣浚郡骏捃")
(qdl "ka" "\
喀咖咔卡咯佧胩")
(qdl "kai" "\
开揩锎楷凯慨剀垲蒈恺\
铠锴忾")
(qdl "kan" "\
刊堪勘看戡龛槛坎砍侃\
莰阚嵌瞰")
(qdl "kang" "\
康慷糠闶扛抗亢炕伉钪")
(qdl "kao" "\
尻考拷烤栲靠犒铐")
(qdl "ke" "\
呵坷苛柯棵磕颗科嗑珂\
轲瞌钶稞疴窠颏蝌髁壳\
咳可渴岢克刻客课恪溘\
骒缂氪锞蚵")
(qdl "ken" "\
肯啃垦恳龈裉")
(qdl "keng" "\
坑吭铿")
(qdl "kong" "\
空倥崆箜恐孔控")
(qdl "kou" "\
抠芤眍口扣寇蔻叩筘")
(qdl "ku" "\
枯哭窟刳堀骷苦酷库裤\
喾绔")
(qdl "kua" "\
夸垮侉挎跨胯")
(qdl "kuai" "\
蒯会块筷侩快郐哙狯浍\
脍")
(qdl "kuan" "\
宽髋款")
(qdl "kuang" "\
匡筐框诓哐狂诳夼矿眶\
旷况邝圹纩贶")
(qdl "kui" "\
亏盔岿窥悝葵奎魁馗夔\
隗揆喹逵暌睽蝰傀跬馈\
愧溃匮蒉喟愦聩篑")
(qdl "kun" "\
坤昆琨锟醌鲲髡捆悃阃\
困")
(qdl "kuo" "\
括扩廓阔适栝蛞")
(qdl "la" "\
垃拉喇啦邋旯砬蜡腊辣\
落剌瘌蓝")
(qdl "lai" "\
莱来崃徕涞铼赖濑赉睐\
癞籁")
(qdl "lan" "\
蓝婪栏拦篮阑兰澜谰岚\
斓镧褴揽览懒缆漤榄罱\
烂滥")
(qdl "lang" "\
啷琅榔狼廊郎阆锒稂螂\
朗浪莨蒗")
(qdl "lao" "\
捞劳牢唠崂铹痨醪老佬\
姥潦栳铑酪烙涝落络耢")
(qdl "le" "\
肋勒乐仂叻泐鳓了")
(qdl "lei" "\
勒擂雷镭累羸嫘缧檑蕾\
磊儡垒诔耒肋类泪酹嘞")
(qdl "leng" "\
棱楞塄冷愣")
(qdl "li" "\
哩厘梨犁黎篱狸离漓丽\
璃蓠藜喱嫠骊缡罹鹂蜊\
蠡鲡黧理李里鲤礼俚悝\
澧逦娌锂醴鳢莉荔吏栗\
厉励砾历利傈例俐痢立\
粒沥隶力鬲俪郦坜苈莅\
藓呖唳猁溧枥栎轹戾砺\
詈疠疬蛎笠篥粝跞雳")
(qdl "lia" "\
俩")
(qdl "lian" "\
联莲连镰廉怜涟帘奁濂\
臁裢蠊鲢敛脸蔹琏裣链\
恋炼练潋楝殓")
(qdl "liang" "\
粮凉梁粱良量墚莨椋踉\
俩两魉辆晾亮谅靓")
(qdl "liao" "\
撩撂聊僚疗燎寥辽嘹獠\
寮缭鹩潦了蓼钌镣廖料\
尥")
(qdl "lie" "\
咧裂列烈劣猎冽埒捩洌\
趔躐鬣")
(qdl "lin" "\
琳林磷霖临邻鳞淋秘啉\
嶙遴辚瞵粼麟凛廪懔檩\
赁吝蔺膦躏")
(qdl "ling" "\
拎棱玲菱零龄铃伶羚凌\
灵陵令酃苓囹泠绫柃棂\
瓴聆蛉翎鲮岭领另呤")
(qdl "liu" "\
溜熘琉榴硫馏留刘瘤流\
浏遛骝旒镏鎏柳绺锍六\
碌陆鹨")
(qdl "lo" "\
咯")
(qdl "long" "\
隆龙聋咙笼窿茏泷珑栊\
胧砻癃垄拢陇垅弄")
(qdl "lou" "\
搂楼娄偻蒌喽耧蝼髅篓\
嵝漏陋露镂瘘")
(qdl "lu" "\
撸噜芦卢颅庐炉垆泸栌\
轳胪鸬舻鲈掳卤虏鲁橹\
镥六麓碌露路赂鹿潞禄\
录陆戮绿蓼渌漉逯璐辂\
辘鹭簏氇")
(qdl "lu:" "\
吕铝侣旅履屡缕偻捋膂\
稆褛虑氯律率滤绿驴闾\
榈")
(qdl "luan" "\
峦挛孪滦脔娈栾鸾銮卵\
乱")
(qdl "lue" "\
掠略锊")
(qdl "lun" "\
抡轮伦仑沦纶论囵")
(qdl "luo" "\
罗落捋萝螺逻锣箩骡猡\
椤脶镙裸倮蠃瘰咯烙洛\
骆络荦摞泺漯珞硌雒")
(qdl "m" "\
呒")
(qdl "ma" "\
妈麻蚂摩抹嬷吗蟆玛码\
马犸骂唛杩嘛么")
(qdl "mai" "\
埋霾买荬麦卖迈脉劢")
(qdl "man" "\
颟埋瞒馒蛮蔓谩鳗鞔满\
螨曼慢漫墁幔缦熳镘")
(qdl "mang" "\
芒茫盲氓忙邙硭莽漭蟒")
(qdl "mao" "\
猫茅锚毛矛茆牦旄蝥蟊\
髦铆卯峁泖昴茂冒帽貌\
贸袤瑁耄懋瞀")
(qdl "me" "\
么麽")
(qdl "mei" "\
玫枚梅酶霉煤没眉媒糜\
莓嵋猸湄楣镅鹛镁每美\
浼昧寐妹媚谜袂魅")
(qdl "men" "\
闷门扪钔焖懑们")
(qdl "meng" "\
蒙氓萌檬盟甍瞢朦礞虻\
艨锰猛勐懵蜢蠓艋梦孟")
(qdl "mi" "\
眯咪醚靡糜迷谜弥蘼猕\
祢縻麋米芈弭脒敉秘觅\
泌蜜密幂谧嘧汨宓糸")
(qdl "mian" "\
棉眠绵冕免勉娩缅沔渑\
湎腼眄黾面")
(qdl "miao" "\
喵苗描瞄鹋藐秒渺邈缈\
杪淼眇庙妙缪")
(qdl "mie" "\
乜咩蔑灭蠛篾")
(qdl "min" "\
民苠岷缗玟珉抿皿敏悯\
闽闵泯愍黾鳘")
(qdl "ming" "\
盟明螟鸣铭名冥茗溟暝\
瞑酩命")
(qdl "miu" "\
谬缪")
(qdl "mo" "\
摸摹蘑模膜磨摩魔无谟\
馍嫫麽抹貉嘿脉冒没末\
莫墨默沫漠寞陌万茉蓦\
殁镆秣瘼耱貊貘")
(qdl "mou" "\
哞谋牟侔缪眸蛑鍪某")
(qdl "mu" "\
模毪姥拇牡亩姆母牟墓\
暮幕募慕木目睦牧穆仫\
坶苜沐钼")
(qdl "n" "\
唔嗯")
(qdl "na" "\
那南拿镎哪呐钠娜纳呢\
捺肭衲")
(qdl "nai" "\
哪氖乃奶艿耐奈鼐佴萘\
柰")
(qdl "nan" "\
囝囡南男难喃楠腩蝻赧")
(qdl "nang" "\
囊囔馕攮曩")
(qdl "nao" "\
孬挠努呶猱硇铙蛲脑恼\
垴瑙闹淖")
(qdl "ne" "\
哪呐呢讷")
(qdl "nei" "\
哪馁那内")
(qdl "nen" "\
嫩恁")
(qdl "neng" "\
能")
(qdl "ng" "\
唔嗯")
(qdl "ni" "\
妮呢霓倪泥尼坭猊怩铌\
鲵拟你旎祢匿腻逆溺尿\
伲昵慝睨")
(qdl "nian" "\
蔫拈年粘黏鲇鲶碾撵捻\
辇念酿廿埝")
(qdl "niang" "\
娘酿")
(qdl "niao" "\
鸟茑嬲袅溺尿脲")
(qdl "nie" "\
捏聂孽啮镊镍涅乜陧蘖\
嗫颞臬蹑")
(qdl "nin" "\
您恁")
(qdl "ning" "\
柠狞凝宁拧苎咛甯聍泞\
佞")
(qdl "niu" "\
妞牛扭钮纽狃忸拗")
(qdl "nong" "\
脓浓农侬哝弄")
(qdl "nou" "\
耨")
(qdl "nu" "\
奴孥驽努弩胬怒")
(qdl "nu:" "\
女钕恧衄")
(qdl "nuan" "\
暖")
(qdl "nue" "\
虐疟")
(qdl "nuo" "\
娜挪傩懦糯诺搦喏锘")
(qdl "o" "\
喔噢哦")
(qdl "ou" "\
欧鸥殴沤区讴瓯藕呕偶\
耦怄")
(qdl "pa" "\
扒啪趴派葩耙爬杷钯筢\
帕怕琶")
(qdl "pai" "\
拍排牌徘俳迫湃派蒎哌")
(qdl "pan" "\
扳番攀潘般盘磐胖爿蟠\
蹒盼畔判叛拚泮袢襻")
(qdl "pang" "\
膀乓滂磅庞旁彷逄螃耪\
胖")
(qdl "pao" "\
抛炮泡脬咆刨袍跑匏狍\
庖疱")
(qdl "pei" "\
呸胚醅培裴赔陪锫配佩\
沛辔帔旆霈")
(qdl "pen" "\
喷盆湓")
(qdl "peng" "\
砰抨烹澎嘭怦彭蓬棚硼\
篷膨朋鹏堋蟛捧碰")
(qdl "pi" "\
辟坏坯砒霹批披劈丕邳\
噼纰铍琵毗啤脾疲皮陂\
陴郫埤鼙芘枇罴裨蚍蜱\
貔否匹痞仳圮擗吡庀癖\
疋僻屁譬淠媲甓睥")
(qdl "pian" "\
扁篇偏片犏翩便骈缏胼\
蹁谝骗")
(qdl "piao" "\
飘漂剽缥螵瓢朴嫖莩殍\
瞟票嘌骠")
(qdl "pie" "\
撇瞥氕丿苤")
(qdl "pin" "\
拼拚姘频贫苹嫔颦品榀\
聘牝")
(qdl "ping" "\
乒俜娉冯坪苹萍平凭瓶\
评屏枰鲆")
(qdl "po" "\
泊坡泼颇朴陂泺攴钋繁\
婆鄱皤叵钷笸破魄迫粕\
珀")
(qdl "pou" "\
剖裒掊")
(qdl "pu" "\
扑铺仆噗脯莆葡菩蒲匍\
濮璞镤堡埔朴圃普浦谱\
溥氆镨蹼暴曝瀑")
(qdl "qi" "\
缉期欺栖戚妻七凄漆柒\
沏萋嘁桤槭欹蹊其棋奇\
歧畦崎脐齐旗祈祁骑亓\
俟圻芪荠萁蕲岐淇骐琪\
琦耆祺颀蛴蜞綦鳍麒稽\
起岂乞企启芑屺绮杞綮\
契砌器气迄弃汽泣讫亟\
葺汔憩碛")
(qdl "qia" "\
掐伽葜袷卡恰洽髂")
(qdl "qian" "\
牵扦钎铅千迁签仟谦佥\
阡芊岍悭骞搴褰愆乾黔\
钱钳前潜荨掮犍钤虔箝\
鬈遣浅谴缱肷堑嵌欠歉\
纤倩芡茜慊椠")
(qdl "qiang" "\
将枪呛腔羌抢戕戗锖锵\
镪蜣跄墙蔷强嫱樯襁羟\
炝")
(qdl "qiao" "\
橇锹敲悄雀劁缲硗跷蕉\
桥瞧乔侨翘谯荞峤憔樵\
鞒巧愀壳鞘撬峭俏窍诮")
(qdl "qie" "\
切茄伽且砌怯窃郄惬慊\
妾挈锲箧趄")
(qdl "qin" "\
钦侵亲衾秦琴勤芹擒禽\
芩嗪噙廑溱檎锓矜覃螓\
寝沁揿吣")
(qdl "qing" "\
青轻氢倾卿清圊蜻鲭擎\
晴氰情檠黥顷请苘謦亲\
庆磬罄箐綮")
(qdl "qiong" "\
琼穷邛茕穹蛩筇跫銎")
(qdl "qiu" "\
龟秋丘邱湫楸蚯鳅仇球\
求囚酋泅俅巯犰逑遒赇\
虬蝤裘鼽糗")
(qdl "qu" "\
趋区蛆曲躯屈驱诎岖觑\
祛蛐麴黢渠劬蕖蘧衢璩\
氍朐磲鸲癯蠼瞿取娶龋\
苣趣去阒戌")
(qdl "quan" "\
圈悛颧权醛泉全痊拳诠\
荃辁铨蜷筌鬈犬绻畎券\
劝")
(qdl "que" "\
缺炔阙瘸却鹊榷确雀阕\
悫")
(qdl "qun" "\
逡裙群麇")
(qdl "ran" "\
然燃蚺髯冉染苒")
(qdl "rang" "\
嚷瓤禳穰壤攘让")
(qdl "rao" "\
饶荛娆桡扰绕")
(qdl "re" "\
惹若喏热")
(qdl "ren" "\
壬仁人任忍荏稔韧认刃\
妊纫仞葚饪轫衽")
(qdl "reng" "\
扔仍")
(qdl "ri" "\
日")
(qdl "rong" "\
戎茸蓉荣融熔溶容绒嵘\
狨榕肜蝾冗")
(qdl "rou" "\
揉柔糅蹂鞣肉")
(qdl "ru" "\
茹蠕儒孺如薷嚅濡铷襦\
颥辱乳汝入褥蓐洳溽缛")
(qdl "ruan" "\
软阮朊")
(qdl "rui" "\
蕤蕊瑞锐芮枘睿蚋")
(qdl "run" "\
闰润")
(qdl "ruo" "\
若弱偌箬")
(qdl "sa" "\
撒仨挲洒萨卅脎飒")
(qdl "sai" "\
腮鳃塞思噻赛")
(qdl "san" "\
三叁毵伞散馓糁霰")
(qdl "sang" "\
桑丧嗓搡磉颡")
(qdl "sao" "\
搔骚缫缲臊鳋扫嫂梢埽\
瘙")
(qdl "se" "\
塞瑟色涩啬铯穑")
(qdl "sen" "\
森")
(qdl "seng" "\
僧")
(qdl "sha" "\
莎砂杀刹沙纱煞杉挲铩\
痧裟鲨傻啥厦唼嗄歃霎")
(qdl "shai" "\
筛酾色晒")
(qdl "shan" "\
珊苫杉山删煽衫扇栅埏\
芟潸姗膻钐舢跚髟掺掸\
闪陕单擅赡膳善汕缮剡\
讪鄯嬗骟禅疝蟮鳝")
(qdl "shang" "\
墒伤商汤殇熵觞赏晌上\
垧尚绱裳")
(qdl "shao" "\
鞘梢捎稍烧蛸筲艄芍勺\
韶苕杓少哨邵绍召劭潲")
(qdl "she" "\
奢赊猞畲蛇舌折佘舍赦\
摄射慑涉社设厍滠歙麝")
(qdl "shei" "\
谁")
(qdl "shen" "\
参砷申呻伸身深娠绅诜\
莘糁神甚什沈审婶谂哂\
渖矧肾慎渗葚椹胂蜃")
(qdl "sheng" "\
声生甥牲升胜笙绳渑省\
眚乘盛剩圣嵊晟")
(qdl "shi" "\
师失狮施湿诗尸虱嘘蓍\
酾鲺十石拾时什食蚀实\
识埘莳炻鲥史矢使屎驶\
始豕式示士世柿事拭誓\
逝势是嗜噬适仕侍释饰\
氏市恃室视试似峙谥弑\
轼贳铈螫舐筮匙殖")
(qdl "shou" "\
收熟手首守艏寿授售受\
瘦兽狩绶")
(qdl "shu" "\
蔬枢梳殊抒输叔舒淑疏\
书倏菽摅姝纾毹殳疋赎\
孰熟塾秫薯暑曙署蜀黍\
鼠属数术述树束戍竖墅\
庶漱恕俞丨沭澍腧")
(qdl "shua" "\
刷唰耍")
(qdl "shuai" "\
摔衰甩率帅蟀")
(qdl "shuan" "\
栓拴闩涮")
(qdl "shuang" "\
霜双泷孀爽")
(qdl "shui" "\
谁水睡税说")
(qdl "shun" "\
吮瞬顺舜")
(qdl "shuo" "\
说数硕朔烁蒴搠妁槊铄")
(qdl "si" "\
斯撕嘶思私司丝厮厶咝\
澌缌锶鸶蛳死食肆寺嗣\
四伺似饲巳俟兕汜泗姒\
驷祀耜笥厕")
(qdl "song" "\
松凇菘崧嵩忪淞耸怂悚\
竦颂送宋讼诵")
(qdl "sou" "\
搜艘嗖馊溲飕锼螋擞叟\
薮嗾瞍嗽")
(qdl "su" "\
苏酥稣俗素速粟僳塑溯\
宿诉肃缩夙谡蔌嗉愫涑\
簌觫")
(qdl "suan" "\
酸狻蒜算")
(qdl "sui" "\
尿虽荽濉眭睢隋随绥遂\
髓碎岁穗隧祟谇邃燧")
(qdl "sun" "\
孙荪狲飧损笋榫隼")
(qdl "suo" "\
莎蓑梭唆缩嗦嗍娑桫挲\
睃羧琐索锁所唢")
(qdl "ta" "\
塌他它她踏溻遢铊趿塔\
獭鳎挞蹋拓嗒闼漯榻沓")
(qdl "tai" "\
胎苔台抬邰薹骀炱跆鲐\
呔泰酞太态汰肽钛")
(qdl "tan" "\
坍摊贪瘫滩弹坛檀痰潭\
谭谈郯澹昙锬镡覃坦毯\
袒忐钽碳探叹炭")
(qdl "tang" "\
汤趟铴镗耥羰塘搪堂棠\
膛唐糖饧溏瑭樘螗螳醣\
倘躺淌傥帑烫")
(qdl "tao" "\
掏涛滔绦叨韬焘饕萄桃\
逃淘陶鼗啕洮讨套")
(qdl "te" "\
特忒忑慝铽")
(qdl "tei" "\
忒")
(qdl "teng" "\
藤腾疼誊滕")
(qdl "ti" "\
梯剔踢锑体提题蹄啼荑\
绨缇鹈醍替嚏惕涕剃屉\
倜悌逖裼")
(qdl "tian" "\
天添佃填田甜恬阗畋钿\
舔腆忝殄掭")
(qdl "tiao" "\
挑佻祧调条迢苕蜩笤龆\
鲦髫窕眺跳粜")
(qdl "tie" "\
贴帖萜铁餮")
(qdl "ting" "\
厅听烃汀廷停亭庭莛葶\
婷蜓霆挺艇梃町铤")
(qdl "tong" "\
恫通嗵侗桐酮瞳同铜彤\
童佟仝垌茼峒潼砼桶捅\
筒统痛恸")
(qdl "tou" "\
偷投头骰钭透")
(qdl "tu" "\
凸秃突图徒途涂屠荼菟\
酴土吐钍兔堍")
(qdl "tuan" "\
湍团抟疃彖")
(qdl "tui" "\
推忒颓腿蜕褪退煺")
(qdl "tun" "\
吞暾囤屯臀饨豚氽褪")
(qdl "tuo" "\
拖托脱乇舵鸵陀驮驼佗\
坨沱柁橐砣铊酡跎鼍椭\
妥庹魄拓唾柝箨")
(qdl "wa" "\
凹挖哇蛙洼娲娃瓦佤袜\
腽")
(qdl "wai" "\
歪崴外")
(qdl "wan" "\
豌弯湾剜蜿玩顽丸烷完\
芄纨娩碗挽晚皖惋宛婉\
莞菀绾琬脘畹蔓万腕")
(qdl "wang" "\
汪尢芒王亡忘枉网往罔\
惘辋魍旺望妄")
(qdl "wei" "\
威巍微危萎委偎隈葳薇\
崴逶煨韦违桅围唯惟为\
潍维圩囗帏帷嵬闱沩涠\
苇伟伪尾纬诿隗猥洧娓\
玮韪炜痿艉鲔未蔚味畏\
胃喂魏位渭谓尉慰卫遗\
猬軎")
(qdl "wen" "\
瘟温蚊文闻纹阌璺雯吻\
稳紊刎问汶")
(qdl "weng" "\
嗡翁蓊瓮蕹")
(qdl "wo" "\
挝蜗涡窝倭莴喔我斡卧\
握沃幄渥肟硪龌")
(qdl "wu" "\
恶巫呜钨乌污诬屋兀邬\
圬於亡无芜梧吾吴毋捂\
唔浯蜈鼯武五午舞伍侮\
仵庑怃忤迕妩牾鹉坞戊\
雾晤物勿务悟误阢芴寤\
婺骛杌焐鹜痦鋈")
(qdl "xi" "\
腊栖昔熙析西硒矽晰嘻\
吸锡牺稀息希悉膝夕惜\
熄烯溪汐犀僖兮郗茜菥\
奚唏浠淅嬉樨曦欷歙熹\
皙穸蜥螅蟋舾羲粞翕醯\
蹊鼷檄袭席习媳隰觋喜\
铣洗葸蓰徙屣玺禧系隙\
戏细饩阋禊舄")
(qdl "xia" "\
瞎虾呷匣霞辖暇峡侠狭\
狎遐瑕柙硖瘕黠唬下厦\
夏吓罅")
(qdl "xian" "\
掀锨先仙鲜纤莶暹氙祆\
籼酰跹咸贤衔舷闲涎弦\
嫌娴鹇痫铣洗显险冼藓\
猃燹蚬筅跣见现献县腺\
馅羡宪陷限线苋岘霰")
(qdl "xiang" "\
相厢镶香箱襄湘乡芗葙\
骧缃降翔祥详庠想响享\
饷鲞飨项巷橡像向象蟓")
(qdl "xiao" "\
萧硝霄削哮嚣销消宵肖\
哓潇逍骁绡枭枵蛸箫魈\
淆崤晓小筱孝校啸笑效")
(qdl "xie" "\
楔些歇蝎鞋协挟携邪斜\
胁谐叶偕勰撷缬颉写血\
解契械卸蟹懈泄泻谢屑\
亵燮薤獬廨渫瀣邂绁榭\
榍躞")
(qdl "xin" "\
薪芯锌欣辛新忻心馨昕\
歆鑫寻镡信衅囟")
(qdl "xing" "\
星腥猩惺兴刑型形邢行\
陉荥饧硎省醒擤幸杏性\
姓荇悻")
(qdl "xiong" "\
兄凶胸匈汹芎雄熊")
(qdl "xiu" "\
休修羞咻馐庥鸺貅髹宿\
朽臭嗅锈秀袖绣岫溴")
(qdl "xu" "\
墟戌需虚嘘须吁圩顼砉\
盱胥徐许诩浒栩糈醑蓄\
酗叙旭序畜恤絮婿绪续\
勖洫溆煦蓿")
(qdl "xuan" "\
轩喧宣儇谖萱揎暄煊悬\
旋玄漩璇痃选癣券眩绚\
泫渲楦炫碹铉镟")
(qdl "xue" "\
削靴薛学穴噱泶踅雪鳕\
血谑")
(qdl "xun" "\
荤勋熏埙薰獯曛窨醺循\
旬询寻驯巡郇荀峋恂洵\
浔鲟浚殉汛训讯逊迅巽\
蕈徇")
(qdl "ya" "\
压押鸦鸭呀丫雅哑垭桠\
芽牙蚜崖衙涯伢岈琊睚\
匹瞧痖疋亚讶轧揠迓娅\
氩砑")
(qdl "yan" "\
焉咽阉烟淹燕殷鄢菸崦\
恹阏湮嫣胭腌铅盐严研\
蜒岩延言颜阎炎沿阽芫\
闫妍檐筵奄掩眼衍演厣\
剡俨偃兖郾琰罨魇鼹鼽\
艳堰厌砚雁唁彦焰宴谚\
验赝谳滟晏焱酽餍")
(qdl "yang" "\
殃央鸯秧泱鞅杨扬佯疡\
羊洋阳徉炀烊蛘氧仰痒\
养样漾怏恙")
(qdl "yao" "\
邀腰妖要约夭吆幺侥陶\
瑶摇尧遥窑谣姚爻徭珧\
轺肴铫繇鳐咬舀崾杳窈\
疟药耀钥曜鹞")
(qdl "ye" "\
椰噎耶掖邪爷揶铘野冶\
也哗咽页业叶曳腋夜液\
拽靥谒邺晔烨")
(qdl "yi" "\
一壹医揖铱依伊衣椅咿\
噫猗漪欹黟蛇颐夷遗移\
仪胰疑沂宜姨彝诒圯荑\
咦嶷饴怡迤贻眙痍蛾尾\
蚁倚已乙矣以苡旖钇舣\
酏艾艺抑易邑屹亿役臆\
逸肄疫亦裔意毅忆义益\
溢诣议谊译异翼翌绎刈\
劓仡佚佾埸懿薏弈奕挹\
弋呓嗌峄怿悒驿缢殪轶\
熠镒镱瘗癔翊蜴羿翳")
(qdl "yin" "\
烟茵荫因殷音阴姻堙喑\
洇湮氤铟吟银淫寅鄞圻\
垠狺夤霪龈饮尹引隐吲\
瘾蚓印胤茚窨")
(qdl "ying" "\
英樱婴鹰应缨莺撄嘤膺\
瑛璎鹦罂莹萤营荧蝇迎\
赢盈嬴茔荥萦蓥滢潆瀛\
楹影颖郢瘿颍硬映媵")
(qdl "yo" "\
哟育唷")
(qdl "yong" "\
拥佣臃痈庸雍壅墉慵邕\
镛鳙饔喁踊蛹咏泳涌永\
恿勇俑甬用")
(qdl "you" "\
幽优悠忧攸呦尤由邮铀\
犹油游莜莸尢柚猷疣蚰\
蝣蝤繇鱿酉有友卣莠牖\
铕黝右佑釉诱又幼侑囿\
宥蚴鼬")
(qdl "yu" "\
迂淤吁纡於瘀于盂榆虞\
愚舆余俞逾鱼愉渝渔隅\
予娱与禺谀萸揄嵛狳馀\
妤瑜觎腴欤窬蝓竽臾舁\
雩雨屿禹宇语羽伛俣圄\
圉庾瘐窳龉谷蔚尉玉域\
芋郁遇喻峪御愈欲狱育\
誉浴寓裕预豫驭粥毓谕\
菀蓣饫阈鬻妪昱煜熨燠\
聿钰鹆鹬蜮")
(qdl "yuan" "\
鸳渊冤眢鸢箢元垣袁原\
援辕园员圆猿源缘塬芫\
圜沅媛橼爰螈鼋远苑愿\
怨院垸掾瑗")
(qdl "yue" "\
曰约乐说越跃钥岳粤月\
悦阅龠瀹栎樾刖钺")
(qdl "yun" "\
晕氲员耘云郧匀芸纭昀\
筠陨允狁殒均运蕴酝韵\
孕郓恽愠韫熨")
(qdl "za" "\
匝扎拶咂砸杂咱咋")
(qdl "zai" "\
栽哉灾甾宰载仔崽再在")
(qdl "zan" "\
簪糌咱攒拶昝趱暂赞瓒\
錾")
(qdl "zang" "\
赃锗臧驵藏脏葬奘")
(qdl "zao" "\
遭糟凿藻枣早澡蚤缲躁\
噪造皂灶燥唣")
(qdl "ze" "\
责择则泽咋赜啧帻迮笮\
箦舴侧仄昃")
(qdl "zei" "\
贼")
(qdl "zen" "\
怎谮")
(qdl "zeng" "\
增憎曾缯罾赠综甑锃")
(qdl "zha" "\
查扎喳渣咋揸吒哳楂齄\
札轧铡闸炸喋眨砟蜡栅\
榨乍诈柞咤痄蚱")
(qdl "zhai" "\
侧摘斋翟择宅窄祭债寨\
砦瘵")
(qdl "zhan" "\
瞻毡詹粘沾占谵旃盏斩\
辗崭展搌颤蘸栈战站湛\
绽")
(qdl "zhang" "\
樟章彰漳张鄣獐嫜璋蟑\
长掌涨仉杖丈帐账仗胀\
瘴障幛嶂")
(qdl "zhao" "\
朝嘲招昭着啁钊找沼爪\
赵照罩兆肇召诏棹笊")
(qdl "zhe" "\
遮折蜇哲蛰辙谪摺辄磔\
者锗褶赭蔗这浙柘鹧着")
(qdl "zhei" "\
这")
(qdl "zhen" "\
珍斟真甄砧臻贞针侦蓁\
浈溱桢椹榛胗祯箴枕疹\
诊缜轸畛稹震振镇阵圳\
赈朕鸩")
(qdl "zheng" "\
丁蒸挣睁征狰争怔正症\
峥徵钲铮筝鲭整拯政帧\
郑证诤")
(qdl "zhi" "\
氏芝枝支吱蜘知肢脂汁\
之织指只掷卮栀胝祗职\
直植殖执值侄埴摭絷跖\
踯址止趾旨纸芷徵咫枳\
轵祉黹酯识志挚至致置\
帜峙制智秩稚质炙痔滞\
治窒陟郅帙忮彘骘栉桎\
轾贽膣雉鸷痣蛭踬豸觯")
(qdl "zhong" "\
中盅忠钟衷终忪锺螽舯\
种肿冢踵重仲众")
(qdl "zhou" "\
舟周州洲诌粥啁轴妯碡\
肘帚咒皱宙昼骤荮纣绉\
胄籀繇酎")
(qdl "zhu" "\
珠株蛛朱猪诸诛侏邾茱\
洙潴槠橥铢术逐竹烛筑\
瘃竺舳躅属煮拄瞩嘱主\
渚褚麈著柱助蛀贮铸住\
注祝驻伫苎杼炷疰箸翥")
(qdl "zhua" "\
挝抓爪")
(qdl "zhuai" "\
拽转曳嘬")
(qdl "zhuan" "\
专砖颛转传撰赚篆啭馔\
沌")
(qdl "zhuang" "\
桩庄装妆奘幢撞壮状僮\
戆")
(qdl "zhui" "\
椎锥追骓隹赘坠缀惴缒")
(qdl "zhun" "\
屯谆肫窀准")
(qdl "zhuo" "\
捉拙卓桌倬涿焯缴著琢\
茁酌啄着灼浊诼擢浞濯\
禚斫镯")
(qdl "zi" "\
吱兹咨资姿滋淄孜仔谘\
呲嵫孳缁辎赀锱粢趑觜\
訾龇鲻髭紫籽滓子茈姊\
梓秭耔笫自渍字恣眦")
(qdl "zong" "\
鬃棕踪宗综枞腙总偬纵\
粽")
(qdl "zou" "\
邹诹陬鄹驺鲰走奏揍")
(qdl "zu" "\
租菹足卒族镞祖诅阻组\
俎")
(qdl "zuan" "\
钻躜纂缵赚攥")
(qdl "zui" "\
堆咀嘴觜醉最罪蕞")
(qdl "zun" "\
尊遵樽鳟撙")
(qdl "zuo" "\
作嘬琢昨笮撮左佐凿柞\
做坐座阼唑怍胙祚酢")
