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
;;	Original table is from cxterm/dict/tit/TONEPY.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	GB
;; MULTICHOICE:	YES
;; PROMPT:	汉字输入∷带调拼音∷ 
;; #
;; COMMENT	带调拼音方案
;; COMMENT
;; COMMENT 小写英文字母代表「拼音」符号， "u(yu) 则用 u: 表示∶
;; COMMENT 音调用数字表示， 12345 分别代表阴平、阳平、上声、下声及轻声
;; # define keys
;; VALIDINPUTKEY:	12345:abcdefghijklmnopqrstuvwxyz
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
 "tonepy" "调" nil
 "汉字输入∷带调拼音∷ 

	带调拼音方案

 小写英文字母代表「拼音」符号， \"u(yu) 则用 u: 表示∶
 音调用数字表示， 12345 分别代表阴平、阳平、上声、下声及轻声"
 *quail-mode-rich-map* nil nil nil nil t)

(defmacro qdl (key str)
  (list 'quail-defrule key (list 'string-to-char-list str)))

(qdl "a1" "\
啊阿呵吖腌锕")
(qdl "a2" "\
啊呵嗄")
(qdl "a3" "\
啊呵")
(qdl "a4" "\
啊呵")
(qdl "a5" "\
啊阿呵")
(qdl "ai1" "\
埃挨哎唉哀捱锿")
(qdl "ai2" "\
挨皑癌呆捱")
(qdl "ai3" "\
哎蔼矮嗳霭")
(qdl "ai4" "\
哎唉艾碍爱隘嗳嗌嫒瑷\
暧砹")
(qdl "an1" "\
鞍氨安厂广谙庵桉鹌")
(qdl "an3" "\
俺埯揞铵")
(qdl "an4" "\
按暗岸胺案犴黯")
(qdl "ang1" "\
肮")
(qdl "ang2" "\
昂")
(qdl "ang4" "\
盎")
(qdl "ao1" "\
凹熬")
(qdl "ao2" "\
敖熬翱嚣嗷廒遨獒聱螯\
鳌鏖")
(qdl "ao3" "\
袄拗媪")
(qdl "ao4" "\
傲奥懊澳坳拗岙骜鏊")
(qdl "ba1" "\
芭捌扒叭吧笆八疤巴岜\
粑")
(qdl "ba2" "\
八拔跋茇菝魃")
(qdl "ba3" "\
靶把钯")
(qdl "ba4" "\
把耙坝霸罢爸灞鲅")
(qdl "ba5" "\
吧罢")
(qdl "bai1" "\
掰")
(qdl "bai2" "\
白")
(qdl "bai3" "\
柏百摆佰伯捭")
(qdl "bai4" "\
败拜稗呗")
(qdl "ban1" "\
斑班搬扳般颁瘢癍")
(qdl "ban3" "\
板版阪坂钣舨")
(qdl "ban4" "\
扮拌伴瓣半办绊")
(qdl "bang1" "\
邦帮梆浜")
(qdl "bang3" "\
榜膀绑")
(qdl "bang4" "\
膀棒磅蚌镑傍谤蒡")
(qdl "bao1" "\
苞胞包褒剥炮孢煲龅")
(qdl "bao2" "\
薄雹")
(qdl "bao3" "\
保堡饱宝葆鸨褓")
(qdl "bao4" "\
抱报暴豹鲍爆刨曝瀑趵")
(qdl "bei1" "\
杯碑悲卑背陂埤萆鹎")
(qdl "bei3" "\
北")
(qdl "bei4" "\
辈背贝钡倍狈备惫焙被\
孛邶蓓悖碚褙鐾鞴")
(qdl "bei5" "\
臂呗")
(qdl "ben1" "\
奔贲锛")
(qdl "ben3" "\
苯本畚")
(qdl "ben4" "\
奔笨夯坌")
(qdl "beng1" "\
崩绷嘣")
(qdl "beng2" "\
甭")
(qdl "beng3" "\
绷")
(qdl "beng4" "\
蚌绷泵蹦迸甏")
(qdl "bi1" "\
逼")
(qdl "bi2" "\
鼻荸")
(qdl "bi3" "\
比鄙笔彼匕俾吡妣秕舭")
(qdl "bi4" "\
碧蓖蔽毕毙毖币庇痹闭\
敝弊必辟壁臂避陛拂秘\
泌埤芘荜萆薜哔狴庳愎\
滗濞弼婢嬖璧贲畀铋裨\
筚箅篦襞跸髀")
(qdl "bian1" "\
鞭边编煸砭蝙笾鳊")
(qdl "bian3" "\
贬扁匾碥窆褊")
(qdl "bian4" "\
便变卞辨辩辫遍弁苄忭\
汴缏")
(qdl "bian5" "\
边")
(qdl "biao1" "\
标彪膘勺骠杓飑飙飚镖\
镳瘭髟")
(qdl "biao3" "\
表婊裱")
(qdl "biao4" "\
鳔")
(qdl "bie1" "\
鳖憋瘪")
(qdl "bie2" "\
别蹩")
(qdl "bie3" "\
瘪")
(qdl "bie4" "\
别")
(qdl "bin1" "\
彬斌濒滨宾傧豳缤玢槟\
镔")
(qdl "bin4" "\
摈殡膑髌鬓")
(qdl "bing1" "\
兵冰并槟")
(qdl "bing3" "\
柄丙秉饼炳屏禀邴")
(qdl "bing4" "\
病并摒")
(qdl "bo1" "\
般剥玻菠播拨钵波饽趵")
(qdl "bo2" "\
柏百薄博勃搏铂箔伯帛\
舶脖膊渤泊驳魄孛亳礴\
钹鹁踣")
(qdl "bo3" "\
簸跛")
(qdl "bo4" "\
柏薄檗掰擘簸")
(qdl "bo5" "\
卜啵")
(qdl "bu1" "\
逋晡钸")
(qdl "bu2" "\
不醭")
(qdl "bu3" "\
堡捕卜哺补卟")
(qdl "bu4" "\
埠不布步簿部怖埔瓿钚")
(qdl "ca1" "\
擦拆嚓")
(qdl "ca3" "\
礤")
(qdl "cai1" "\
猜")
(qdl "cai2" "\
裁材才财")
(qdl "cai3" "\
睬踩采彩")
(qdl "cai4" "\
采菜蔡")
(qdl "can1" "\
餐参骖")
(qdl "can2" "\
蚕残惭")
(qdl "can3" "\
惨黪")
(qdl "can4" "\
惨灿掺孱璨粲")
(qdl "cang1" "\
苍舱仓沧伧")
(qdl "cang2" "\
藏")
(qdl "cao1" "\
操糙")
(qdl "cao2" "\
槽曹嘈漕螬艚")
(qdl "cao3" "\
草")
(qdl "ce4" "\
厕策侧册测恻")
(qdl "cen1" "\
参")
(qdl "cen2" "\
岑涔")
(qdl "ceng1" "\
噌")
(qdl "ceng2" "\
层曾")
(qdl "ceng4" "\
蹭")
(qdl "cha1" "\
插叉碴差喳嚓馇杈锸")
(qdl "cha2" "\
叉茬茶查碴搽察猹楂槎\
檫")
(qdl "cha3" "\
叉镲衩")
(qdl "cha4" "\
叉岔差诧刹汊姹杈衩")
(qdl "chai1" "\
差拆钗")
(qdl "chai2" "\
柴豺侪")
(qdl "chai4" "\
瘥虿")
(qdl "chan1" "\
搀掺觇")
(qdl "chan2" "\
蝉馋谗缠单廛潺澶孱婵\
禅镡蟾躔")
(qdl "chan3" "\
铲产阐冁谄蒇骣")
(qdl "chan4" "\
颤忏羼")
(qdl "chang1" "\
昌猖伥菖阊娼鲳")
(qdl "chang2" "\
场尝常长偿肠裳倘苌徜\
嫦")
(qdl "chang3" "\
场厂敞惝昶氅")
(qdl "chang4" "\
畅唱倡鬯怅")
(qdl "chao1" "\
超抄钞吵绰剿怊焯")
(qdl "chao2" "\
朝嘲潮巢晁")
(qdl "chao3" "\
吵炒")
(qdl "chao4" "\
耖")
(qdl "che1" "\
车砗")
(qdl "che3" "\
扯尺")
(qdl "che4" "\
撤掣彻澈坼")
(qdl "chen1" "\
郴抻嗔琛")
(qdl "chen2" "\
臣辰尘晨忱沉陈橙沈谌\
宸")
(qdl "chen3" "\
碜")
(qdl "chen4" "\
趁衬称秤谶榇龀")
(qdl "chen5" "\
伧")
(qdl "cheng1" "\
撑称秤噌柽瞠铛蛏")
(qdl "cheng2" "\
城橙成呈乘程惩澄诚承\
盛丞埕枨塍铖裎酲")
(qdl "cheng3" "\
逞骋裎")
(qdl "cheng4" "\
称秤")
(qdl "chi1" "\
吃痴哧嗤媸眵鸱蚩螭笞\
魑")
(qdl "chi2" "\
持匙池迟弛驰坻墀茌篪\
踟")
(qdl "chi3" "\
耻齿侈尺褫豉")
(qdl "chi4" "\
赤翅斥炽傺叱啻彳饬敕\
瘛")
(qdl "chong1" "\
充冲涌茺忡憧舂艟")
(qdl "chong2" "\
虫崇种重")
(qdl "chong3" "\
宠")
(qdl "chong4" "\
冲铳")
(qdl "chou1" "\
抽瘳")
(qdl "chou2" "\
酬畴踌稠愁筹仇绸俦帱\
惆雠")
(qdl "chou3" "\
瞅丑")
(qdl "chou4" "\
臭")
(qdl "chu1" "\
初出樗")
(qdl "chu2" "\
橱厨躇锄雏滁除刍蜍蹰")
(qdl "chu3" "\
楚础储处杵楮褚")
(qdl "chu4" "\
矗搐触处畜亍怵憷绌黜")
(qdl "chuai1" "\
揣搋")
(qdl "chuai3" "\
揣")
(qdl "chuai4" "\
揣啜嘬膪踹")
(qdl "chuan1" "\
川穿巛氚")
(qdl "chuan2" "\
椽传船遄舡")
(qdl "chuan3" "\
喘舛")
(qdl "chuan4" "\
串钏")
(qdl "chuang1" "\
疮窗创")
(qdl "chuang2" "\
幢床")
(qdl "chuang3" "\
闯")
(qdl "chuang4" "\
创怆")
(qdl "chui1" "\
吹炊")
(qdl "chui2" "\
捶锤垂椎陲棰槌")
(qdl "chun1" "\
春椿蝽")
(qdl "chun2" "\
醇唇淳纯莼鹑")
(qdl "chun3" "\
蠢")
(qdl "chuo1" "\
戳踔")
(qdl "chuo4" "\
绰啜辍龊")
(qdl "ci1" "\
差疵刺呲")
(qdl "ci2" "\
茨磁雌辞慈瓷词兹茈祠\
鹚糍")
(qdl "ci3" "\
此")
(qdl "ci4" "\
刺赐次伺")
(qdl "cong1" "\
聪葱囱匆从苁骢璁枞")
(qdl "cong2" "\
从丛淙琮")
(qdl "cou4" "\
凑楱辏腠")
(qdl "cu1" "\
粗")
(qdl "cu2" "\
徂殂")
(qdl "cu4" "\
醋簇促卒蔟猝酢蹙蹴")
(qdl "cuan1" "\
蹿汆撺镩")
(qdl "cuan2" "\
攒")
(qdl "cuan4" "\
篡窜爨")
(qdl "cui1" "\
摧崔催衰榱隹")
(qdl "cui3" "\
璀")
(qdl "cui4" "\
脆瘁粹淬翠萃啐悴毳")
(qdl "cun1" "\
村皴")
(qdl "cun2" "\
存蹲")
(qdl "cun3" "\
忖")
(qdl "cun4" "\
寸")
(qdl "cuo1" "\
磋撮搓蹉")
(qdl "cuo2" "\
嵯矬痤瘥鹾")
(qdl "cuo3" "\
撮脞")
(qdl "cuo4" "\
措挫错厝锉")
(qdl "da1" "\
搭答耷哒嗒褡")
(qdl "da2" "\
达答瘩打怛妲沓笪靼鞑")
(qdl "da3" "\
打")
(qdl "da4" "\
大")
(qdl "da5" "\
塔疸")
(qdl "dai1" "\
呆待呔")
(qdl "dai3" "\
歹傣逮")
(qdl "dai4" "\
大戴带殆代贷袋待逮怠\
埭甙岱迨骀绐玳黛")
(qdl "dan1" "\
耽担丹单郸儋殚眈瘅聃\
箪")
(qdl "dan3" "\
担掸胆赕疸瘅")
(qdl "dan4" "\
担旦氮但惮淡诞弹蛋石\
萏啖澹瘅")
(qdl "dang1" "\
当铛裆")
(qdl "dang3" "\
挡党谠")
(qdl "dang4" "\
当挡荡档凼菪宕砀")
(qdl "dao1" "\
刀叨忉氘")
(qdl "dao2" "\
叨")
(qdl "dao3" "\
捣蹈倒岛祷导")
(qdl "dao4" "\
倒到稻悼道盗帱焘纛")
(qdl "de2" "\
德得锝")
(qdl "de5" "\
得的底地")
(qdl "dei3" "\
得")
(qdl "deng1" "\
蹬灯登噔簦")
(qdl "deng3" "\
等戥")
(qdl "deng4" "\
澄蹬瞪凳邓嶝磴镫")
(qdl "di1" "\
堤低滴提氐嘀镝羝")
(qdl "di2" "\
的迪敌笛狄涤翟嫡籴荻\
嘀觌镝")
(qdl "di3" "\
抵底氐诋邸坻柢砥骶")
(qdl "di4" "\
的地蒂第帝弟递缔谛娣\
绨棣碲睇")
(qdl "dia3" "\
嗲")
(qdl "dian1" "\
颠掂滇巅癫")
(qdl "dian3" "\
碘点典丶踮")
(qdl "dian4" "\
靛垫电佃甸店惦奠淀殿\
阽坫玷钿癜簟")
(qdl "diao1" "\
碉叼雕凋刁貂鲷")
(qdl "diao3" "\
鸟")
(qdl "diao4" "\
掉吊钓调铞铫")
(qdl "die1" "\
跌爹踮")
(qdl "die2" "\
碟蝶迭谍叠佚垤堞揲喋\
牒瓞耋蹀鲽")
(qdl "ding1" "\
丁盯叮钉仃玎町疔耵酊")
(qdl "ding3" "\
顶鼎酊")
(qdl "ding4" "\
钉锭定订啶腚碇铤")
(qdl "diu1" "\
丢铥")
(qdl "dong1" "\
东冬咚岽氡鸫")
(qdl "dong3" "\
董懂硐")
(qdl "dong4" "\
动栋侗恫冻洞垌峒胨胴\
硐")
(qdl "dou1" "\
兜都蔸篼")
(qdl "dou3" "\
抖斗陡蚪")
(qdl "dou4" "\
斗豆逗痘读窦")
(qdl "du1" "\
都督嘟")
(qdl "du2" "\
毒犊独读顿渎椟牍髑黩")
(qdl "du3" "\
堵睹赌肚笃")
(qdl "du4" "\
杜镀肚度渡妒芏蠹")
(qdl "duan1" "\
端")
(qdl "duan3" "\
短")
(qdl "duan4" "\
锻段断缎椴煅簖")
(qdl "dui1" "\
堆")
(qdl "dui4" "\
兑队对敦怼憝碓镦")
(qdl "dun1" "\
墩吨蹲敦礅镦")
(qdl "dun3" "\
盹趸")
(qdl "dun4" "\
顿囤钝盾遁沌炖砘")
(qdl "duo1" "\
掇哆多咄裰")
(qdl "duo2" "\
度夺铎踱")
(qdl "duo3" "\
垛躲朵哚缍")
(qdl "duo4" "\
垛跺舵剁惰堕驮沲柁")
(qdl "e1" "\
阿屙婀")
(qdl "e2" "\
蛾峨鹅俄额讹娥哦莪锇")
(qdl "e3" "\
恶")
(qdl "e4" "\
恶厄扼遏鄂饿噩谔垩苊\
萼呃愕阏轭腭锷鹗颚鳄")
(qdl "e5" "\
呃")
(qdl "ei2" "\
诶")
(qdl "ei3" "\
诶")
(qdl "ei4" "\
诶")
(qdl "en1" "\
恩蒽")
(qdl "en4" "\
摁")
(qdl "er2" "\
而儿鸸鲕")
(qdl "er3" "\
耳尔饵洱迩珥铒")
(qdl "er4" "\
二贰佴")
(qdl "fa1" "\
发")
(qdl "fa2" "\
罚筏伐乏阀垡")
(qdl "fa3" "\
法砝")
(qdl "fa4" "\
发珐")
(qdl "fan1" "\
藩帆番翻蕃幡")
(qdl "fan2" "\
樊矾钒繁凡烦泛蕃蘩燔\
蹯")
(qdl "fan3" "\
反返")
(qdl "fan4" "\
范贩犯饭泛梵畈")
(qdl "fang1" "\
坊芳方妨邡枋钫")
(qdl "fang2" "\
坊肪房防妨鲂")
(qdl "fang3" "\
仿访纺彷舫")
(qdl "fang4" "\
放")
(qdl "fei1" "\
菲非啡飞妃绯扉蜚霏鲱")
(qdl "fei2" "\
肥淝腓")
(qdl "fei3" "\
菲匪诽悱榧斐蜚篚翡")
(qdl "fei4" "\
吠肺废沸费芾狒镄痱")
(qdl "fen1" "\
芬酚吩氛分纷玢")
(qdl "fen2" "\
坟焚汾棼鼢")
(qdl "fen3" "\
粉")
(qdl "fen4" "\
分奋份忿愤粪偾瀵鲼")
(qdl "feng1" "\
丰封枫蜂峰锋风疯烽酆\
葑沣砜")
(qdl "feng2" "\
逢冯缝")
(qdl "feng3" "\
讽唪")
(qdl "feng4" "\
缝奉凤俸葑")
(qdl "fo2" "\
佛")
(qdl "fou3" "\
否缶")
(qdl "fu1" "\
夫敷肤孵呋稃麸趺跗")
(qdl "fu2" "\
佛夫扶拂辐幅氟符伏俘\
服浮涪福袱弗匐凫郛芙\
芾苻茯莩菔幞怫艴孚绂\
绋桴祓砩黻罘稃蚨蜉蝠")
(qdl "fu3" "\
甫抚辅俯釜斧脯腑府腐\
父拊滏黼")
(qdl "fu4" "\
服赴副覆赋复傅付阜父\
腹负富讣附妇缚咐驸赙\
馥蝮鲋鳆")
(qdl "fu5" "\
咐")
(qdl "ga1" "\
嘎胳夹咖伽旮")
(qdl "ga2" "\
噶嘎轧尜钆")
(qdl "ga3" "\
嘎尕")
(qdl "ga4" "\
尬")
(qdl "gai1" "\
该陔垓赅")
(qdl "gai3" "\
改")
(qdl "gai4" "\
概钙盖溉芥丐戤")
(qdl "gan1" "\
干甘杆柑竿肝乾坩苷尴\
泔矸疳酐")
(qdl "gan3" "\
杆赶感秆敢擀澉橄")
(qdl "gan4" "\
干赣淦绀旰")
(qdl "gang1" "\
冈刚钢缸肛纲杠扛罡")
(qdl "gang3" "\
岗港")
(qdl "gang4" "\
钢杠戆筻")
(qdl "gao1" "\
篙皋高膏羔糕睾槔")
(qdl "gao3" "\
搞镐稿藁缟槁杲")
(qdl "gao4" "\
膏告诰郜锆")
(qdl "ge1" "\
哥歌搁戈鸽胳疙割格咯\
屹仡圪纥袼")
(qdl "ge2" "\
搁胳革葛格蛤阁隔鬲塥\
嗝搿膈镉颌骼")
(qdl "ge3" "\
盖葛个各合哿舸")
(qdl "ge4" "\
铬个各硌虼")
(qdl "gei3" "\
给")
(qdl "gen1" "\
根跟")
(qdl "gen2" "\
哏")
(qdl "gen3" "\
艮")
(qdl "gen4" "\
亘茛艮")
(qdl "geng1" "\
耕更庚羹赓")
(qdl "geng3" "\
埂耿梗颈哽绠鲠")
(qdl "geng4" "\
更")
(qdl "gong1" "\
工攻功恭龚供躬公宫弓\
共红肱蚣觥")
(qdl "gong3" "\
巩汞拱珙")
(qdl "gong4" "\
供贡共")
(qdl "gou1" "\
钩勾沟句佝缑枸篝鞲")
(qdl "gou3" "\
苟狗岣枸笱")
(qdl "gou4" "\
勾垢构购够诟遘媾觏彀")
(qdl "gu1" "\
辜菇咕箍估沽孤姑骨菰\
呱轱毂鸪蛄酤觚")
(qdl "gu2" "\
骨")
(qdl "gu3" "\
鼓古蛊骨谷股贾嘏诂汩\
牯臌毂瞽罟钴鹄蛄鹘")
(qdl "gu4" "\
估故顾固雇崮梏牿锢痼\
鲴")
(qdl "gua1" "\
刮瓜括呱栝胍鸹")
(qdl "gua3" "\
剐寡呱")
(qdl "gua4" "\
挂褂卦诖")
(qdl "guai1" "\
乖掴")
(qdl "guai3" "\
拐")
(qdl "guai4" "\
怪")
(qdl "guan1" "\
棺关官冠观纶倌莞矜鳏")
(qdl "guan3" "\
管馆莞")
(qdl "guan4" "\
冠观罐惯灌贯掼涫盥鹳")
(qdl "guang1" "\
光咣桄胱")
(qdl "guang3" "\
广犷")
(qdl "guang4" "\
逛桄")
(qdl "gui1" "\
瑰规圭硅归龟闺傀妫皈\
鲑")
(qdl "gui3" "\
轨鬼诡癸匦庋宄晷簋")
(qdl "gui4" "\
桂柜跪贵刽炔刿桧炅鳜")
(qdl "gun3" "\
辊滚衮绲磙鲧")
(qdl "gun4" "\
棍")
(qdl "guo1" "\
锅郭过涡埚呙崞聒蝈")
(qdl "guo2" "\
国馘掴帼虢")
(qdl "guo3" "\
果裹猓椁蜾")
(qdl "guo4" "\
过")
(qdl "ha1" "\
哈铪")
(qdl "ha2" "\
蛤虾")
(qdl "ha3" "\
哈")
(qdl "ha4" "\
哈")
(qdl "hai1" "\
嘿咳嗨")
(qdl "hai2" "\
骸孩还")
(qdl "hai3" "\
海胲醢")
(qdl "hai4" "\
氦亥害骇")
(qdl "han1" "\
酣憨顸蚶鼾")
(qdl "han2" "\
邯韩含涵寒函汗邗晗焓")
(qdl "han3" "\
喊罕阚")
(qdl "han4" "\
翰撼捍旱憾悍焊汗汉菡\
撖瀚颔")
(qdl "hang1" "\
夯")
(qdl "hang2" "\
杭航吭行绗珩颃")
(qdl "hang4" "\
巷行沆")
(qdl "hao1" "\
蒿薅嚆")
(qdl "hao2" "\
壕嚎豪毫号貉嗥濠蚝")
(qdl "hao3" "\
郝好")
(qdl "hao4" "\
镐好耗号浩灏昊皓颢")
(qdl "he1" "\
呵喝诃嗬")
(qdl "he2" "\
荷菏核禾和何合盒貉阂\
河涸劾阖纥曷盍颌蚵翮")
(qdl "he4" "\
喝荷和何赫褐鹤贺吓壑")
(qdl "hei1" "\
嘿黑嗨")
(qdl "hen2" "\
痕")
(qdl "hen3" "\
很狠")
(qdl "hen4" "\
恨")
(qdl "heng1" "\
哼亨")
(qdl "heng2" "\
横衡恒行蘅珩桁")
(qdl "heng4" "\
横")
(qdl "hng5" "\
哼")
(qdl "hong1" "\
轰哄烘訇薨")
(qdl "hong2" "\
虹鸿洪宏弘红黉荭蕻闳\
泓")
(qdl "hong3" "\
哄")
(qdl "hong4" "\
哄讧蕻")
(qdl "hou2" "\
喉侯猴瘊篌糇骺")
(qdl "hou3" "\
吼")
(qdl "hou4" "\
侯厚候后堠後逅鲎")
(qdl "hu1" "\
呼乎忽糊戏唿惚滹轷烀")
(qdl "hu2" "\
核和瑚壶葫胡蝴狐糊湖\
弧囫猢槲觳煳鹄鹕醐斛\
鹘")
(qdl "hu3" "\
虎唬浒琥")
(qdl "hu4" "\
糊虎护互沪户冱岵怙戽\
扈祜瓠鹱笏")
(qdl "hua1" "\
花哗华化砉")
(qdl "hua2" "\
哗华猾滑划豁骅铧")
(qdl "hua4" "\
华画划化话桦")
(qdl "huai2" "\
槐徊怀淮踝")
(qdl "huai4" "\
坏")
(qdl "huai5" "\
划")
(qdl "huan1" "\
欢獾")
(qdl "huan2" "\
环桓还郇萑圜洹寰缳锾\
鬟")
(qdl "huan3" "\
缓")
(qdl "huan4" "\
换患唤痪豢焕涣宦幻奂\
擐浣漶逭鲩")
(qdl "huang1" "\
荒慌肓")
(qdl "huang2" "\
黄磺蝗簧皇凰惶煌隍徨\
湟潢遑璜癀蟥篁鳇")
(qdl "huang3" "\
晃幌恍谎")
(qdl "huang4" "\
晃")
(qdl "hui1" "\
堕灰挥辉徽恢诙咴隳珲\
晖虺麾")
(qdl "hui2" "\
徊蛔回茴洄")
(qdl "hui3" "\
毁悔虺")
(qdl "hui4" "\
慧卉惠晦贿秽会烩汇讳\
诲绘溃荟蕙哕喙浍彗缋\
桧恚蟪")
(qdl "hun1" "\
荤昏婚阍")
(qdl "hun2" "\
魂浑混馄珲")
(qdl "hun4" "\
混诨溷")
(qdl "huo1" "\
豁劐攉锪耠")
(qdl "huo2" "\
和活")
(qdl "huo3" "\
伙火夥钬")
(qdl "huo4" "\
和豁获或惑霍货祸藿嚯\
镬蠖")
(qdl "ji1" "\
击圾基机畸稽积箕肌饥\
迹激讥鸡姬绩缉几期其\
奇丌乩剞墼芨叽咭唧屐\
畿玑赍犄齑矶羁嵇笄跻")
(qdl "ji2" "\
革吉极棘辑籍集及急疾\
汲即嫉级脊藉亟佶诘蒺\
蕺岌嵴楫殛戢瘠笈")
(qdl "ji3" "\
革给挤几脊己济纪掎戟\
虮麂")
(qdl "ji4" "\
蓟技冀季伎祭剂悸济寄\
寂计记既忌际妓继纪齐\
系偈芰荠哜洎骥觊稷暨\
跽霁鲚鲫髻")
(qdl "jia1" "\
嘉枷夹佳家加茄挟伽葭\
浃迦珈镓痂笳袈跏")
(qdl "jia2" "\
夹荚颊郏戛恝铗袷蛱")
(qdl "jia3" "\
贾甲钾假搅铰矫侥脚狡\
角饺缴绞剿嘏佼挢岬徼\
湫敫胛皎瘕")
(qdl "jia4" "\
假稼价架驾嫁")
(qdl "jia5" "\
家")
(qdl "jian1" "\
歼监坚尖笺间煎兼肩艰\
奸缄渐溅浅菅蒹搛湔缣\
戋犍鹣鲣鞯")
(qdl "jian3" "\
茧检柬碱硷拣捡简俭剪\
减谫囝蹇謇枧戬睑锏裥\
笕翦趼")
(qdl "jian4" "\
监间荐槛鉴践贱见键箭\
件健舰剑饯渐溅涧建僭\
谏楗牮毽腱锏踺")
(qdl "jiang1" "\
僵姜将浆江疆茳缰礓豇")
(qdl "jiang3" "\
蒋桨奖讲耩")
(qdl "jiang4" "\
虹将浆匠酱降强洚绛犟\
糨")
(qdl "jiao1" "\
蕉椒礁焦胶交郊浇骄娇\
教僬艽茭姣鹪蛟跤鲛")
(qdl "jiao2" "\
嚼矫峤")
(qdl "jiao3" "\
搅铰矫侥脚狡角饺缴绞\
剿佼挢徼湫敫皎")
(qdl "jiao4" "\
嚼教酵轿较叫窖觉校噍\
峤徼醮")
(qdl "jie1" "\
揭接皆秸街阶节结楷喈\
嗟疖")
(qdl "jie2" "\
截劫节桔杰捷睫竭洁结\
偈讦诘拮婕孑桀碣颉羯\
鲒")
(qdl "jie3" "\
解姐")
(qdl "jie4" "\
价解戒藉芥界借介疥诫\
届蚧骱")
(qdl "jie5" "\
家价")
(qdl "jin1" "\
巾筋斤金今津襟禁衿矜")
(qdl "jin3" "\
紧锦仅谨尽卺堇馑廑瑾\
槿")
(qdl "jin4" "\
仅进靳晋禁近烬浸尽劲\
荩噤妗缙赆觐")
(qdl "jing1" "\
荆兢茎睛晶鲸京惊精粳\
经菁泾腈旌")
(qdl "jing3" "\
井警景颈刭儆阱憬肼")
(qdl "jing4" "\
劲经静境敬镜径痉靖竟\
竞净獍迳弪婧胫靓")
(qdl "jiong1" "\
扃")
(qdl "jiong3" "\
炯窘迥炅")
(qdl "jiu1" "\
揪究纠啾阄鸠赳鬏")
(qdl "jiu3" "\
玖韭久灸九酒")
(qdl "jiu4" "\
厩救旧臼舅咎就疚僦柩\
桕鹫")
(qdl "ju1" "\
车鞠拘狙疽居驹据锯俱\
且苴掬琚椐锔裾趄雎鞫")
(qdl "ju2" "\
桔菊局橘锔")
(qdl "ju3" "\
柜咀矩举沮莒枸榉踽龃")
(qdl "ju4" "\
沮聚拒据巨具距踞锯俱\
句惧炬剧倨讵苣遽屦榘\
犋飓钜窭趄醵瞿")
(qdl "juan1" "\
捐鹃娟圈涓蠲镌")
(qdl "juan3" "\
卷锩")
(qdl "juan4" "\
倦眷卷绢俊圈鄄狷桊隽")
(qdl "jue1" "\
撅嗟噘")
(qdl "jue2" "\
嚼脚角攫抉掘倔爵觉决\
诀绝厥劂谲矍蕨噱崛獗\
孓珏桷橛爝镢蹶觖")
(qdl "jue3" "\
蹶")
(qdl "jue4" "\
倔")
(qdl "jun1" "\
龟均菌钧军君皲筠麇")
(qdl "jun4" "\
菌峻俊竣浚郡骏捃隽")
(qdl "ka1" "\
喀咖咔")
(qdl "ka3" "\
卡咯佧咔胩")
(qdl "kai1" "\
开揩锎")
(qdl "kai3" "\
楷凯慨剀垲蒈恺铠锴")
(qdl "kai4" "\
忾")
(qdl "kan1" "\
刊堪勘看戡龛")
(qdl "kan3" "\
槛坎砍侃莰阚")
(qdl "kan4" "\
看嵌阚瞰")
(qdl "kang1" "\
康慷糠闶")
(qdl "kang2" "\
扛")
(qdl "kang4" "\
抗亢炕伉闶钪")
(qdl "kao1" "\
尻")
(qdl "kao3" "\
考拷烤栲")
(qdl "kao4" "\
靠犒铐")
(qdl "ke1" "\
呵坷苛柯棵磕颗科嗑珂\
轲瞌钶稞疴窠颏蝌髁")
(qdl "ke2" "\
壳咳颏")
(qdl "ke3" "\
坷可渴岢轲")
(qdl "ke4" "\
可克刻客课嗑恪溘骒缂\
氪锞蚵")
(qdl "ken3" "\
肯啃垦恳龈")
(qdl "ken4" "\
裉")
(qdl "keng1" "\
坑吭铿")
(qdl "kong1" "\
空倥崆箜")
(qdl "kong3" "\
恐孔倥")
(qdl "kong4" "\
空控")
(qdl "kou1" "\
抠芤眍")
(qdl "kou3" "\
口")
(qdl "kou4" "\
扣寇蔻叩筘")
(qdl "ku1" "\
枯哭窟刳堀骷")
(qdl "ku3" "\
苦")
(qdl "ku4" "\
酷库裤喾绔")
(qdl "kua1" "\
夸")
(qdl "kua3" "\
垮侉")
(qdl "kua4" "\
挎跨胯")
(qdl "kuai3" "\
蒯")
(qdl "kuai4" "\
会块筷侩快郐哙狯浍脍")
(qdl "kuan1" "\
宽髋")
(qdl "kuan3" "\
款")
(qdl "kuang1" "\
匡筐框诓哐")
(qdl "kuang2" "\
狂诳")
(qdl "kuang3" "\
夼")
(qdl "kuang4" "\
框矿眶旷况邝圹纩贶")
(qdl "kui1" "\
亏盔岿窥悝")
(qdl "kui2" "\
葵奎魁馗夔隗揆喹逵暌\
睽蝰")
(qdl "kui3" "\
傀跬")
(qdl "kui4" "\
馈愧溃匮蒉喟愦聩篑")
(qdl "kun1" "\
坤昆琨锟醌鲲髡")
(qdl "kun3" "\
捆悃阃")
(qdl "kun4" "\
困")
(qdl "kuo4" "\
括扩廓阔适栝蛞")
(qdl "la1" "\
垃拉喇啦邋")
(qdl "la2" "\
拉喇旯砬")
(qdl "la3" "\
拉喇")
(qdl "la4" "\
拉蜡腊辣落剌瘌")
(qdl "la5" "\
啦蓝")
(qdl "lai2" "\
莱来崃徕涞铼")
(qdl "lai4" "\
赖濑赉睐癞籁")
(qdl "lan2" "\
蓝婪栏拦篮阑兰澜谰岚\
斓镧褴")
(qdl "lan3" "\
揽览懒缆漤榄罱")
(qdl "lan4" "\
烂滥")
(qdl "lang1" "\
啷")
(qdl "lang2" "\
琅榔狼廊郎阆锒稂螂")
(qdl "lang3" "\
朗")
(qdl "lang4" "\
郎浪莨蒗阆")
(qdl "lao1" "\
捞")
(qdl "lao2" "\
劳牢唠崂铹痨醪")
(qdl "lao3" "\
老佬姥潦栳铑")
(qdl "lao4" "\
酪烙涝落络唠耢")
(qdl "le1" "\
肋")
(qdl "le4" "\
勒乐仂叻泐鳓")
(qdl "le5" "\
了")
(qdl "lei1" "\
勒擂")
(qdl "lei2" "\
雷镭累擂羸嫘缧檑")
(qdl "lei3" "\
蕾磊累儡垒诔耒")
(qdl "lei4" "\
累擂肋类泪酹")
(qdl "lei5" "\
嘞")
(qdl "leng1" "\
棱")
(qdl "leng2" "\
棱楞塄")
(qdl "leng3" "\
冷")
(qdl "leng4" "\
愣")
(qdl "li1" "\
哩")
(qdl "li2" "\
厘梨犁黎篱狸离漓丽璃\
蓠藜喱嫠骊缡罹鹂蜊蠡\
鲡黧")
(qdl "li3" "\
理李里鲤礼哩俚悝澧逦\
娌锂蠡醴鳢")
(qdl "li4" "\
莉荔吏栗丽厉励砾历利\
傈例俐痢立粒沥隶力鬲\
俪郦坜苈莅藓呖唳猁溧\
枥栎轹戾砺詈疠疬蛎笠\
篥粝跞雳")
(qdl "li5" "\
璃哩")
(qdl "lia3" "\
俩")
(qdl "lian2" "\
联莲连镰廉怜涟帘奁濂\
臁裢蠊鲢")
(qdl "lian3" "\
敛脸蔹琏裣")
(qdl "lian4" "\
链恋炼练潋楝殓")
(qdl "liang2" "\
粮凉梁粱良量墚莨椋踉")
(qdl "liang3" "\
俩两魉")
(qdl "liang4" "\
凉辆量晾亮谅踉靓")
(qdl "liao1" "\
撩撂")
(qdl "liao2" "\
撩聊僚疗燎寥辽撂嘹獠\
寮缭鹩")
(qdl "liao3" "\
燎潦了蓼钌")
(qdl "liao4" "\
撩了撂镣廖料尥钌")
(qdl "lie1" "\
咧")
(qdl "lie3" "\
裂咧")
(qdl "lie4" "\
列裂烈劣猎冽埒捩洌趔\
躐鬣")
(qdl "lie5" "\
咧")
(qdl "lin2" "\
琳林磷霖临邻鳞淋秘啉\
嶙遴辚瞵粼麟")
(qdl "lin3" "\
凛廪懔檩")
(qdl "lin4" "\
淋赁吝蔺膦躏")
(qdl "ling1" "\
拎")
(qdl "ling2" "\
棱玲菱零龄铃伶羚凌灵\
陵令酃苓囹泠绫柃棂瓴\
聆蛉翎鲮")
(qdl "ling3" "\
岭领令")
(qdl "ling4" "\
另令呤")
(qdl "liu1" "\
溜熘")
(qdl "liu2" "\
琉榴硫馏留刘瘤流浏遛\
骝旒镏鎏")
(qdl "liu3" "\
柳绺锍")
(qdl "liu4" "\
溜馏六碌陆遛镏鹨")
(qdl "lo5" "\
咯")
(qdl "long1" "\
隆")
(qdl "long2" "\
龙聋咙笼窿隆茏泷珑栊\
胧砻癃")
(qdl "long3" "\
笼垄拢陇垅")
(qdl "long4" "\
弄")
(qdl "lou1" "\
搂")
(qdl "lou2" "\
楼娄偻蒌喽耧蝼髅")
(qdl "lou3" "\
搂篓嵝")
(qdl "lou4" "\
漏陋露镂瘘")
(qdl "lou5" "\
喽")
(qdl "lu1" "\
撸噜")
(qdl "lu2" "\
芦卢颅庐炉垆泸栌轳胪\
鸬舻鲈")
(qdl "lu3" "\
芦掳卤虏鲁橹镥")
(qdl "lu4" "\
六麓碌露路赂鹿潞禄录\
陆戮绿蓼渌漉逯璐辂辘\
鹭簏")
(qdl "lu5" "\
轳氇")
(qdl "lu:3" "\
吕铝侣旅履屡缕偻捋膂\
稆褛")
(qdl "lu:4" "\
虑氯律率滤绿")
(qdl "lu:5" "\
驴闾榈")
(qdl "luan2" "\
峦挛孪滦脔娈栾鸾銮")
(qdl "luan3" "\
卵")
(qdl "luan4" "\
乱")
(qdl "lue:3" "\
掠")
(qdl "lue:4" "\
掠略锊")
(qdl "lun1" "\
抡")
(qdl "lun2" "\
抡轮伦仑沦纶论囵")
(qdl "lun4" "\
论")
(qdl "luo1" "\
罗落捋")
(qdl "luo2" "\
萝螺罗逻锣箩骡猡椤脶\
镙")
(qdl "luo3" "\
裸倮蠃瘰")
(qdl "luo4" "\
咯烙落洛骆络荦摞泺漯\
珞硌雒")
(qdl "luo5" "\
罗")
(qdl "m2" "\
呒")
(qdl "ma1" "\
妈麻蚂摩抹嬷")
(qdl "ma2" "\
麻吗蟆")
(qdl "ma3" "\
玛码蚂马吗犸")
(qdl "ma4" "\
蚂骂唛杩")
(qdl "ma5" "\
嘛吗么")
(qdl "mai2" "\
埋霾")
(qdl "mai3" "\
买荬")
(qdl "mai4" "\
麦卖迈脉劢")
(qdl "man1" "\
颟")
(qdl "man2" "\
埋瞒馒蛮蔓谩鳗鞔")
(qdl "man3" "\
满螨")
(qdl "man4" "\
蔓曼慢漫谩墁幔缦熳镘")
(qdl "mang2" "\
芒茫盲氓忙邙硭")
(qdl "mang3" "\
莽漭蟒")
(qdl "mao1" "\
猫")
(qdl "mao2" "\
猫茅锚毛矛茆牦旄蝥蟊\
髦")
(qdl "mao3" "\
铆卯峁泖昴")
(qdl "mao4" "\
茂冒帽貌贸袤瑁耄懋瞀")
(qdl "me5" "\
么麽")
(qdl "mei2" "\
玫枚梅酶霉煤没眉媒糜\
莓嵋猸湄楣镅鹛")
(qdl "mei3" "\
镁每美浼")
(qdl "mei4" "\
昧寐妹媚谜袂魅")
(qdl "men1" "\
闷")
(qdl "men2" "\
门扪钔")
(qdl "men4" "\
闷焖懑")
(qdl "men5" "\
们")
(qdl "meng1" "\
蒙")
(qdl "meng2" "\
氓萌蒙檬盟甍瞢朦礞虻\
艨")
(qdl "meng3" "\
蒙锰猛勐懵蜢蠓艋")
(qdl "meng4" "\
梦孟")
(qdl "mi1" "\
眯咪")
(qdl "mi2" "\
醚靡糜迷谜弥蘼猕祢縻\
麋")
(qdl "mi3" "\
眯靡米芈弭脒敉")
(qdl "mi4" "\
秘觅泌蜜密幂谧嘧汨宓\
糸")
(qdl "mian2" "\
棉眠绵")
(qdl "mian3" "\
冕免勉娩缅沔渑湎腼眄\
黾")
(qdl "mian4" "\
面")
(qdl "miao1" "\
喵")
(qdl "miao2" "\
苗描瞄鹋")
(qdl "miao3" "\
藐秒渺邈缈杪淼眇")
(qdl "miao4" "\
庙妙缪")
(qdl "mie1" "\
乜咩")
(qdl "mie4" "\
蔑灭蠛篾")
(qdl "min2" "\
民苠岷缗玟珉")
(qdl "min3" "\
抿皿敏悯闽闵泯愍黾鳘")
(qdl "ming2" "\
盟明螟鸣铭名冥茗溟暝\
瞑")
(qdl "ming3" "\
酩")
(qdl "ming4" "\
命")
(qdl "miu4" "\
谬缪")
(qdl "mo1" "\
摸")
(qdl "mo2" "\
摸摹蘑模膜磨摩魔无谟\
馍嫫麽")
(qdl "mo3" "\
抹")
(qdl "mo4" "\
貉嘿脉冒没磨抹末莫墨\
默沫漠寞陌万茉蓦殁镆\
秣瘼耱貊貘")
(qdl "mou1" "\
哞")
(qdl "mou2" "\
谋牟侔缪眸蛑鍪")
(qdl "mou3" "\
某")
(qdl "mu2" "\
模毪")
(qdl "mu3" "\
姥拇牡亩姆母")
(qdl "mu4" "\
牟墓暮幕募慕木目睦牧\
穆仫坶苜沐钼")
(qdl "n2" "\
唔嗯")
(qdl "n3" "\
唔嗯")
(qdl "n4" "\
嗯")
(qdl "na1" "\
那南")
(qdl "na2" "\
拿镎")
(qdl "na3" "\
哪那")
(qdl "na4" "\
呐钠那娜纳呢捺肭衲")
(qdl "na5" "\
哪呐")
(qdl "nai3" "\
哪氖乃奶艿")
(qdl "nai4" "\
耐奈鼐佴萘柰")
(qdl "nan1" "\
囝囡")
(qdl "nan2" "\
南男难喃楠")
(qdl "nan3" "\
腩蝻赧")
(qdl "nan4" "\
难")
(qdl "nang1" "\
囊囔")
(qdl "nang2" "\
囊馕")
(qdl "nang3" "\
攮馕曩")
(qdl "nao1" "\
孬")
(qdl "nao2" "\
挠努呶猱硇铙蛲")
(qdl "nao3" "\
脑恼垴瑙")
(qdl "nao4" "\
闹淖")
(qdl "ne2" "\
哪")
(qdl "ne4" "\
呐呢讷")
(qdl "ne5" "\
呐呢")
(qdl "nei3" "\
哪馁")
(qdl "nei4" "\
那内")
(qdl "nen4" "\
嫩恁")
(qdl "neng2" "\
能")
(qdl "ng2" "\
唔嗯")
(qdl "ng3" "\
唔嗯")
(qdl "ng4" "\
嗯")
(qdl "ni1" "\
妮")
(qdl "ni2" "\
呢霓倪泥尼坭猊怩铌鲵")
(qdl "ni3" "\
拟你旎祢")
(qdl "ni4" "\
泥匿腻逆溺尿伲昵慝睨")
(qdl "nian1" "\
蔫拈")
(qdl "nian2" "\
年粘黏鲇鲶")
(qdl "nian3" "\
碾撵捻辇")
(qdl "nian4" "\
念酿廿埝")
(qdl "niang2" "\
娘酿")
(qdl "niang4" "\
酿")
(qdl "niao3" "\
鸟茑嬲袅")
(qdl "niao4" "\
溺尿脲")
(qdl "nie1" "\
捏")
(qdl "nie4" "\
聂孽啮镊镍涅乜陧蘖嗫\
颞臬蹑")
(qdl "nin2" "\
您恁")
(qdl "ning2" "\
柠狞凝宁拧苎咛甯聍")
(qdl "ning3" "\
拧")
(qdl "ning4" "\
宁拧泞佞")
(qdl "niu1" "\
妞")
(qdl "niu2" "\
牛")
(qdl "niu3" "\
扭钮纽狃忸")
(qdl "niu4" "\
拗")
(qdl "nong2" "\
脓浓农侬哝")
(qdl "nong4" "\
弄")
(qdl "nou4" "\
耨")
(qdl "nu2" "\
奴孥驽")
(qdl "nu3" "\
努弩胬")
(qdl "nu4" "\
怒")
(qdl "nu:3" "\
女钕")
(qdl "nu:4" "\
恧衄")
(qdl "nuan3" "\
暖")
(qdl "nue:4" "\
虐疟")
(qdl "nuo2" "\
娜挪傩")
(qdl "nuo4" "\
懦糯诺搦喏锘")
(qdl "o1" "\
喔噢")
(qdl "o2" "\
哦")
(qdl "o4" "\
哦")
(qdl "ou1" "\
欧鸥殴沤区讴瓯")
(qdl "ou3" "\
藕呕偶耦")
(qdl "ou4" "\
呕沤怄")
(qdl "pa1" "\
扒啪趴派葩")
(qdl "pa2" "\
扒耙爬杷钯筢")
(qdl "pa4" "\
帕怕")
(qdl "pa5" "\
琶")
(qdl "pai1" "\
拍")
(qdl "pai2" "\
排牌徘俳")
(qdl "pai3" "\
排迫")
(qdl "pai4" "\
湃派蒎哌")
(qdl "pan1" "\
扳番攀潘")
(qdl "pan2" "\
般盘磐胖爿蟠蹒")
(qdl "pan4" "\
盼畔判叛拚泮袢襻")
(qdl "pang1" "\
膀乓滂")
(qdl "pang2" "\
膀磅庞旁彷逄螃")
(qdl "pang3" "\
耪")
(qdl "pang4" "\
胖")
(qdl "pao1" "\
抛炮泡脬")
(qdl "pao2" "\
咆刨炮袍跑匏狍庖")
(qdl "pao3" "\
跑")
(qdl "pao4" "\
炮泡疱")
(qdl "pei1" "\
呸胚醅")
(qdl "pei2" "\
培裴赔陪锫")
(qdl "pei4" "\
配佩沛辔帔旆霈")
(qdl "pen1" "\
喷")
(qdl "pen2" "\
盆湓")
(qdl "pen4" "\
喷")
(qdl "peng1" "\
砰抨烹澎嘭怦")
(qdl "peng2" "\
澎彭蓬棚硼篷膨朋鹏堋\
蟛")
(qdl "peng3" "\
捧")
(qdl "peng4" "\
碰")
(qdl "pi1" "\
辟坏坯砒霹批披劈丕邳\
噼纰铍")
(qdl "pi2" "\
琵毗啤脾疲皮陂陴郫埤\
鼙芘枇罴铍裨蚍蜱貔")
(qdl "pi3" "\
否劈匹痞仳圮擗吡庀癖\
疋")
(qdl "pi4" "\
辟僻屁譬淠媲甓睥")
(qdl "pian1" "\
扁篇偏片犏翩")
(qdl "pian2" "\
便骈缏胼蹁")
(qdl "pian3" "\
谝")
(qdl "pian4" "\
片骗")
(qdl "piao1" "\
飘漂剽缥螵")
(qdl "piao2" "\
瓢朴嫖")
(qdl "piao3" "\
漂莩缥殍瞟")
(qdl "piao4" "\
漂票嘌骠")
(qdl "pie1" "\
撇瞥氕")
(qdl "pie3" "\
撇丿苤")
(qdl "pin1" "\
拼拚姘")
(qdl "pin2" "\
频贫苹嫔颦")
(qdl "pin3" "\
品榀")
(qdl "pin4" "\
聘牝")
(qdl "ping1" "\
乒俜娉")
(qdl "ping2" "\
冯坪苹萍平凭瓶评屏枰\
鲆")
(qdl "po1" "\
泊坡泼颇朴陂泺攴钋")
(qdl "po2" "\
繁婆鄱皤")
(qdl "po3" "\
叵钷笸")
(qdl "po4" "\
破魄迫粕朴珀")
(qdl "pou1" "\
剖")
(qdl "pou2" "\
裒掊")
(qdl "pou3" "\
掊")
(qdl "pu1" "\
扑铺仆噗")
(qdl "pu2" "\
脯仆莆葡菩蒲匍濮璞镤")
(qdl "pu3" "\
堡埔朴圃普浦谱溥氆镨\
蹼")
(qdl "pu4" "\
堡暴铺曝瀑")
(qdl "qi1" "\
缉期欺栖戚妻七凄漆柒\
沏萋嘁桤槭欹蹊")
(qdl "qi2" "\
其棋奇歧畦畦崎脐齐旗\
祈祁骑亓俟圻芪荠萁蕲\
岐淇骐琪琦耆祺颀蛴蜞\
綦鳍麒")
(qdl "qi3" "\
稽起岂乞企启芑屺绮杞\
綮")
(qdl "qi4" "\
妻齐契砌器气迄弃汽泣\
讫亟葺汔憩碛")
(qdl "qia1" "\
掐伽葜袷")
(qdl "qia3" "\
卡")
(qdl "qia4" "\
恰洽髂")
(qdl "qian1" "\
牵扦钎铅千迁签仟谦佥\
阡芊岍悭骞搴褰愆")
(qdl "qian2" "\
乾黔钱钳前潜荨掮犍钤\
虔箝鬈")
(qdl "qian3" "\
遣浅谴缱肷")
(qdl "qian4" "\
堑嵌欠歉纤倩芡茜慊椠")
(qdl "qiang1" "\
将枪呛腔羌抢戕戗锖锵\
镪蜣跄")
(qdl "qiang2" "\
墙蔷强嫱樯")
(qdl "qiang3" "\
强抢镪襁羟")
(qdl "qiang4" "\
呛戗炝跄")
(qdl "qiao1" "\
橇锹敲悄雀劁缲硗跷")
(qdl "qiao2" "\
蕉桥瞧乔侨翘谯荞峤憔\
樵鞒")
(qdl "qiao3" "\
悄巧雀愀")
(qdl "qiao4" "\
壳鞘撬翘峭俏窍诮谯")
(qdl "qie1" "\
切")
(qdl "qie2" "\
茄伽")
(qdl "qie3" "\
且")
(qdl "qie4" "\
砌切怯窃郄惬慊妾挈锲\
箧趄")
(qdl "qin1" "\
钦侵亲衾")
(qdl "qin2" "\
秦琴勤芹擒禽芩嗪噙廑\
溱檎锓矜覃螓")
(qdl "qin3" "\
寝")
(qdl "qin4" "\
沁揿吣")
(qdl "qing1" "\
青轻氢倾卿清圊蜻鲭")
(qdl "qing2" "\
擎晴氰情檠黥")
(qdl "qing3" "\
顷请苘謦")
(qdl "qing4" "\
亲庆磬罄箐綮")
(qdl "qiong2" "\
琼穷邛茕穹蛩筇跫銎")
(qdl "qiu1" "\
龟秋丘邱湫楸蚯鳅")
(qdl "qiu2" "\
仇球求囚酋泅俅巯犰逑\
遒赇虬蝤裘鼽")
(qdl "qiu3" "\
糗")
(qdl "qu1" "\
趋区蛆曲躯屈驱诎岖觑\
祛蛐麴黢")
(qdl "qu2" "\
渠劬蕖蘧衢璩氍朐磲鸲\
癯蠼瞿")
(qdl "qu3" "\
曲取娶龋苣")
(qdl "qu4" "\
趣去阒觑")
(qdl "qu5" "\
戌")
(qdl "quan1" "\
圈悛")
(qdl "quan2" "\
颧权醛泉全痊拳诠荃辁\
铨蜷筌鬈")
(qdl "quan3" "\
犬绻畎")
(qdl "quan4" "\
券劝")
(qdl "que1" "\
缺炔阙")
(qdl "que2" "\
瘸")
(qdl "que4" "\
却鹊榷确雀阕阙悫")
(qdl "qun1" "\
逡")
(qdl "qun2" "\
裙群麇")
(qdl "ran2" "\
然燃蚺髯")
(qdl "ran3" "\
冉染苒")
(qdl "rang1" "\
嚷")
(qdl "rang2" "\
瓤禳穰")
(qdl "rang3" "\
壤攘嚷禳")
(qdl "rang4" "\
让")
(qdl "rao2" "\
饶荛娆桡")
(qdl "rao3" "\
扰绕娆")
(qdl "rao4" "\
绕")
(qdl "re3" "\
惹若喏")
(qdl "re4" "\
热")
(qdl "ren2" "\
壬仁人任")
(qdl "ren3" "\
忍荏稔")
(qdl "ren4" "\
韧任认刃妊纫仞葚饪轫\
衽")
(qdl "reng1" "\
扔")
(qdl "reng2" "\
仍")
(qdl "ri4" "\
日")
(qdl "rong2" "\
戎茸蓉荣融熔溶容绒嵘\
狨榕肜蝾")
(qdl "rong3" "\
冗")
(qdl "rou2" "\
揉柔糅蹂鞣")
(qdl "rou4" "\
肉")
(qdl "ru2" "\
茹蠕儒孺如薷嚅濡铷襦\
颥")
(qdl "ru3" "\
辱乳汝")
(qdl "ru4" "\
入褥蓐洳溽缛")
(qdl "ruan3" "\
软阮朊")
(qdl "rui2" "\
蕤")
(qdl "rui3" "\
蕊")
(qdl "rui4" "\
瑞锐芮枘睿蚋")
(qdl "run4" "\
闰润")
(qdl "ruo4" "\
若弱偌箬")
(qdl "sa1" "\
撒仨挲")
(qdl "sa3" "\
撒洒")
(qdl "sa4" "\
萨卅脎飒")
(qdl "sai1" "\
腮鳃塞思噻")
(qdl "sai4" "\
塞赛")
(qdl "san1" "\
三叁毵")
(qdl "san3" "\
伞散馓糁霰")
(qdl "san4" "\
散")
(qdl "sang1" "\
桑丧")
(qdl "sang3" "\
嗓搡磉颡")
(qdl "sang4" "\
丧")
(qdl "sao1" "\
搔骚缫缲臊鳋")
(qdl "sao3" "\
扫嫂")
(qdl "sao4" "\
扫梢埽臊瘙")
(qdl "se4" "\
塞瑟色涩啬铯穑")
(qdl "sen1" "\
森")
(qdl "seng1" "\
僧")
(qdl "sha1" "\
莎砂杀刹沙纱煞杉挲铩\
痧裟鲨")
(qdl "sha3" "\
傻")
(qdl "sha4" "\
沙啥煞厦唼嗄歃霎")
(qdl "shai1" "\
筛酾")
(qdl "shai3" "\
色")
(qdl "shai4" "\
晒")
(qdl "shan1" "\
珊苫杉山删煽衫扇栅埏\
芟潸姗膻钐舢跚髟")
(qdl "shan3" "\
掺掸闪陕")
(qdl "shan4" "\
单掸苫擅赡膳善汕扇缮\
剡讪鄯嬗骟禅钐疝蟮鳝")
(qdl "shang1" "\
墒伤商汤殇熵觞")
(qdl "shang3" "\
赏晌上垧")
(qdl "shang4" "\
上尚绱")
(qdl "shang5" "\
裳")
(qdl "shao1" "\
鞘梢捎稍烧蛸筲艄")
(qdl "shao2" "\
芍勺韶苕杓")
(qdl "shao3" "\
少")
(qdl "shao4" "\
捎稍少哨邵绍召劭潲")
(qdl "she1" "\
奢赊猞畲")
(qdl "she2" "\
蛇舌折佘")
(qdl "she3" "\
舍")
(qdl "she4" "\
舍赦摄射慑涉社设厍滠\
歙麝")
(qdl "shei2" "\
谁")
(qdl "shen1" "\
参砷申呻伸身深娠绅诜\
莘糁")
(qdl "shen2" "\
神甚什")
(qdl "shen3" "\
沈审婶谂哂渖矧")
(qdl "shen4" "\
甚肾慎渗葚椹胂蜃")
(qdl "sheng1" "\
声生甥牲升胜笙")
(qdl "sheng2" "\
绳渑")
(qdl "sheng3" "\
省眚")
(qdl "sheng4" "\
乘盛剩胜圣嵊晟")
(qdl "shi1" "\
师失狮施湿诗尸虱嘘蓍\
酾鲺")
(qdl "shi2" "\
十石拾时什食蚀实识埘\
莳炻鲥")
(qdl "shi3" "\
史矢使屎驶始豕")
(qdl "shi4" "\
式示士世柿事拭誓逝势\
是嗜噬适仕侍释饰氏市\
恃室视试似峙谥莳弑轼\
贳铈螫舐筮")
(qdl "shi5" "\
匙殖")
(qdl "shou1" "\
收")
(qdl "shou2" "\
熟")
(qdl "shou3" "\
手首守艏")
(qdl "shou4" "\
寿授售受瘦兽狩绶")
(qdl "shu1" "\
蔬枢梳殊抒输叔舒淑疏\
书倏菽摅姝纾毹殳疋")
(qdl "shu2" "\
赎孰熟塾秫")
(qdl "shu3" "\
薯暑曙署蜀黍鼠属数")
(qdl "shu4" "\
术述树束戍竖墅庶数漱\
恕俞丨沭澍腧")
(qdl "shua1" "\
刷唰")
(qdl "shua3" "\
耍")
(qdl "shua4" "\
刷")
(qdl "shuai1" "\
摔衰")
(qdl "shuai3" "\
甩")
(qdl "shuai4" "\
率帅蟀")
(qdl "shuan1" "\
栓拴闩")
(qdl "shuan4" "\
涮")
(qdl "shuang1" "\
霜双泷孀")
(qdl "shuang3" "\
爽")
(qdl "shui2" "\
谁")
(qdl "shui3" "\
水")
(qdl "shui4" "\
睡税说")
(qdl "shun3" "\
吮")
(qdl "shun4" "\
瞬顺舜")
(qdl "shuo1" "\
说")
(qdl "shuo4" "\
数硕朔烁蒴搠妁槊铄")
(qdl "si1" "\
斯撕嘶思私司丝厮厶咝\
澌缌锶鸶蛳")
(qdl "si3" "\
死")
(qdl "si4" "\
食肆寺嗣四伺似饲巳俟\
兕汜泗姒驷祀耜笥")
(qdl "si5" "\
厕")
(qdl "song1" "\
松凇菘崧嵩忪淞")
(qdl "song3" "\
耸怂悚竦")
(qdl "song4" "\
颂送宋讼诵")
(qdl "sou1" "\
搜艘嗖馊溲飕锼螋")
(qdl "sou3" "\
擞叟薮嗾瞍")
(qdl "sou4" "\
擞嗽")
(qdl "su1" "\
苏酥稣")
(qdl "su2" "\
俗")
(qdl "su4" "\
素速粟僳塑溯宿诉肃缩\
夙谡蔌嗉愫涑簌觫")
(qdl "suan1" "\
酸狻")
(qdl "suan4" "\
蒜算")
(qdl "sui1" "\
尿虽荽濉眭睢")
(qdl "sui2" "\
隋随绥遂")
(qdl "sui3" "\
髓")
(qdl "sui4" "\
碎岁穗遂隧祟谇邃燧")
(qdl "sun1" "\
孙荪狲飧")
(qdl "sun3" "\
损笋榫隼")
(qdl "suo1" "\
莎蓑梭唆缩嗦嗍娑桫挲\
睃羧")
(qdl "suo3" "\
琐索锁所唢")
(qdl "ta1" "\
塌他它她踏溻遢铊趿")
(qdl "ta3" "\
塔獭鳎")
(qdl "ta4" "\
挞蹋踏拓嗒闼漯榻沓")
(qdl "tai1" "\
胎苔台")
(qdl "tai2" "\
苔抬台邰薹骀炱跆鲐")
(qdl "tai3" "\
呔")
(qdl "tai4" "\
泰酞太态汰肽钛")
(qdl "tan1" "\
坍摊贪瘫滩")
(qdl "tan2" "\
弹坛檀痰潭谭谈郯澹昙\
锬镡覃")
(qdl "tan3" "\
坦毯袒忐钽")
(qdl "tan4" "\
碳探叹炭")
(qdl "tang1" "\
汤趟铴镗耥羰")
(qdl "tang2" "\
塘搪堂棠膛唐糖饧溏瑭\
樘镗螗螳醣")
(qdl "tang3" "\
倘躺淌傥帑")
(qdl "tang4" "\
趟烫")
(qdl "tao1" "\
掏涛滔绦叨韬焘饕")
(qdl "tao2" "\
萄桃逃淘陶鼗啕洮")
(qdl "tao3" "\
讨")
(qdl "tao4" "\
套")
(qdl "te4" "\
特忒忑慝铽")
(qdl "tei1" "\
忒")
(qdl "teng2" "\
藤腾疼誊滕")
(qdl "ti1" "\
梯剔踢锑体")
(qdl "ti2" "\
提题蹄啼荑绨缇鹈醍")
(qdl "ti3" "\
体")
(qdl "ti4" "\
替嚏惕涕剃屉倜悌逖绨\
裼")
(qdl "tian1" "\
天添")
(qdl "tian2" "\
佃填田甜恬阗畋钿")
(qdl "tian3" "\
舔腆忝殄")
(qdl "tian4" "\
掭")
(qdl "tiao1" "\
挑佻祧")
(qdl "tiao2" "\
调条迢苕蜩笤龆鲦髫")
(qdl "tiao3" "\
挑窕")
(qdl "tiao4" "\
眺跳粜")
(qdl "tie1" "\
贴帖萜")
(qdl "tie3" "\
铁帖")
(qdl "tie4" "\
帖餮")
(qdl "ting1" "\
厅听烃汀")
(qdl "ting2" "\
廷停亭庭莛葶婷蜓霆")
(qdl "ting3" "\
挺艇梃町铤")
(qdl "ting4" "\
梃")
(qdl "tong1" "\
恫通嗵")
(qdl "tong2" "\
侗桐酮瞳同铜彤童佟仝\
垌茼峒潼砼")
(qdl "tong3" "\
侗桶捅筒统")
(qdl "tong4" "\
通同痛恸")
(qdl "tou1" "\
偷")
(qdl "tou2" "\
投头骰")
(qdl "tou3" "\
钭")
(qdl "tou4" "\
透")
(qdl "tu1" "\
凸秃突")
(qdl "tu2" "\
图徒途涂屠荼菟酴")
(qdl "tu3" "\
土吐钍")
(qdl "tu4" "\
吐兔堍菟")
(qdl "tuan1" "\
湍")
(qdl "tuan2" "\
团抟")
(qdl "tuan3" "\
疃")
(qdl "tuan4" "\
彖")
(qdl "tui1" "\
推忒")
(qdl "tui2" "\
颓")
(qdl "tui3" "\
腿")
(qdl "tui4" "\
蜕褪退煺")
(qdl "tun1" "\
吞暾")
(qdl "tun2" "\
囤屯臀饨豚")
(qdl "tun3" "\
氽")
(qdl "tun4" "\
褪")
(qdl "tuo1" "\
拖托脱乇")
(qdl "tuo2" "\
舵鸵陀驮驼佗坨沱柁橐\
砣铊酡跎鼍")
(qdl "tuo3" "\
椭妥庹")
(qdl "tuo4" "\
魄拓唾柝箨")
(qdl "wa1" "\
凹挖哇蛙洼娲")
(qdl "wa2" "\
娃")
(qdl "wa3" "\
瓦佤")
(qdl "wa4" "\
瓦袜腽")
(qdl "wa5" "\
哇")
(qdl "wai1" "\
歪")
(qdl "wai3" "\
崴")
(qdl "wai4" "\
外")
(qdl "wan1" "\
豌弯湾剜蜿")
(qdl "wan2" "\
玩顽丸烷完芄纨")
(qdl "wan3" "\
娩碗挽晚皖惋宛婉莞菀\
绾琬脘畹")
(qdl "wan4" "\
蔓万腕")
(qdl "wang1" "\
汪尢")
(qdl "wang2" "\
芒王亡忘")
(qdl "wang3" "\
枉网往罔惘辋魍")
(qdl "wang4" "\
王往旺望忘妄")
(qdl "wei1" "\
威巍微危萎委偎隈葳薇\
崴逶煨")
(qdl "wei2" "\
韦违桅围唯惟为潍维圩\
囗帏帷嵬闱沩涠")
(qdl "wei3" "\
唯苇萎委伟伪尾纬诿隗\
猥洧娓玮韪炜痿艉鲔")
(qdl "wei4" "\
为未蔚味畏胃喂魏位渭\
谓尉慰卫遗猬軎")
(qdl "wen1" "\
瘟温")
(qdl "wen2" "\
蚊文闻纹阌璺雯")
(qdl "wen3" "\
吻稳紊刎")
(qdl "wen4" "\
纹问汶璺")
(qdl "weng1" "\
嗡翁")
(qdl "weng3" "\
蓊")
(qdl "weng4" "\
瓮蕹")
(qdl "wo1" "\
挝蜗涡窝倭莴喔")
(qdl "wo2" "\
哦")
(qdl "wo3" "\
我")
(qdl "wo4" "\
哦斡卧握沃幄渥肟硪龌")
(qdl "wu1" "\
恶巫呜钨乌污诬屋兀邬\
圬於")
(qdl "wu2" "\
亡无芜梧吾吴毋捂唔浯\
蜈鼯")
(qdl "wu3" "\
武五捂午舞伍侮仵庑怃\
忤迕妩牾鹉")
(qdl "wu4" "\
恶乌坞戊雾晤物勿务悟\
误兀阢芴寤婺骛杌焐鹜\
痦鋈")
(qdl "xi1" "\
腊栖昔熙析西硒矽晰嘻\
吸锡牺稀息希悉膝夕惜\
熄烯溪汐犀僖兮郗茜菥\
奚唏浠淅嬉樨曦欷歙熹\
皙穸蜥螅蟋舾羲粞翕醯\
蹊鼷")
(qdl "xi2" "\
檄袭席习媳隰觋")
(qdl "xi3" "\
喜铣洗葸蓰徙屣玺禧")
(qdl "xi4" "\
系隙戏细饩阋禊舄")
(qdl "xia1" "\
瞎虾呷")
(qdl "xia2" "\
匣霞辖暇峡侠狭狎遐瑕\
柙硖瘕黠")
(qdl "xia4" "\
唬下厦夏吓罅")
(qdl "xian1" "\
掀锨先仙鲜纤莶暹氙祆\
籼酰跹")
(qdl "xian2" "\
咸贤衔舷闲涎弦嫌娴鹇\
痫")
(qdl "xian3" "\
铣洗鲜显险冼藓猃燹蚬\
筅跣")
(qdl "xian4" "\
见现献县腺馅羡宪陷限\
线苋岘霰")
(qdl "xiang1" "\
相厢镶香箱襄湘乡芗葙\
骧缃")
(qdl "xiang2" "\
降翔祥详庠")
(qdl "xiang3" "\
想响享饷鲞飨")
(qdl "xiang4" "\
相项巷橡像向象蟓")
(qdl "xiao1" "\
萧硝霄削哮嚣销消宵肖\
哓潇逍骁绡枭枵蛸箫魈")
(qdl "xiao2" "\
淆崤")
(qdl "xiao3" "\
晓小筱")
(qdl "xiao4" "\
孝校肖啸笑效")
(qdl "xie1" "\
楔些歇蝎")
(qdl "xie2" "\
鞋协挟携邪斜胁谐叶偕\
勰撷缬颉")
(qdl "xie3" "\
写血")
(qdl "xie4" "\
解契写械卸蟹懈泄泻谢\
屑亵燮薤獬廨渫瀣邂绁\
榭榍躞")
(qdl "xin1" "\
薪芯锌欣辛新忻心馨昕\
歆鑫")
(qdl "xin2" "\
寻镡")
(qdl "xin4" "\
芯信衅囟")
(qdl "xing1" "\
星腥猩惺兴")
(qdl "xing2" "\
刑型形邢行陉荥饧硎")
(qdl "xing3" "\
省醒擤")
(qdl "xing4" "\
兴幸杏性姓荇悻")
(qdl "xiong1" "\
兄凶胸匈汹芎")
(qdl "xiong2" "\
雄熊")
(qdl "xiu1" "\
休修羞咻馐庥鸺貅髹")
(qdl "xiu3" "\
宿朽")
(qdl "xiu4" "\
臭宿嗅锈秀袖绣岫溴")
(qdl "xu1" "\
墟戌需虚嘘须吁圩顼砉\
盱胥")
(qdl "xu2" "\
徐")
(qdl "xu3" "\
许诩浒栩糈醑")
(qdl "xu4" "\
蓄酗叙旭序畜恤絮婿绪\
续勖洫溆煦")
(qdl "xu5" "\
蓿")
(qdl "xuan1" "\
轩喧宣儇谖萱揎暄煊")
(qdl "xuan2" "\
悬旋玄漩璇痃")
(qdl "xuan3" "\
选癣")
(qdl "xuan4" "\
券旋眩绚泫渲楦炫碹铉\
镟")
(qdl "xue1" "\
削靴薛")
(qdl "xue2" "\
学穴噱泶踅")
(qdl "xue3" "\
雪鳕")
(qdl "xue4" "\
血谑")
(qdl "xun1" "\
荤勋熏埙薰獯曛窨醺")
(qdl "xun2" "\
循旬询寻驯巡郇荀峋恂\
洵浔鲟")
(qdl "xun4" "\
浚熏殉汛训讯逊迅巽蕈\
徇")
(qdl "ya1" "\
压押鸦鸭呀丫雅哑垭桠")
(qdl "ya2" "\
芽牙蚜崖衙涯伢岈琊睚")
(qdl "ya3" "\
匹瞧雅痖疋")
(qdl "ya4" "\
压亚讶轧揠迓娅氩砑")
(qdl "ya5" "\
呀")
(qdl "yan1" "\
焉咽阉烟淹燕殷鄢菸崦\
恹阏湮嫣胭腌")
(qdl "yan2" "\
铅盐严研蜒岩延言颜阎\
炎沿阽芫闫妍檐筵")
(qdl "yan3" "\
奄掩眼衍演厣剡俨偃兖\
郾琰罨魇鼹鼽")
(qdl "yan4" "\
咽研沿艳堰燕厌砚雁唁\
彦焰宴谚验赝谳滟晏焱\
酽餍")
(qdl "yang1" "\
殃央鸯秧泱鞅")
(qdl "yang2" "\
杨扬佯疡羊洋阳徉炀烊\
蛘")
(qdl "yang3" "\
氧仰痒养")
(qdl "yang4" "\
样漾怏烊恙鞅")
(qdl "yao1" "\
邀腰妖要约夭吆幺")
(qdl "yao2" "\
侥陶瑶摇尧遥窑谣姚爻\
徭珧轺肴铫繇鳐")
(qdl "yao3" "\
咬舀崾杳窈")
(qdl "yao4" "\
疟药要耀钥曜鹞")
(qdl "ye1" "\
椰噎耶掖")
(qdl "ye2" "\
邪耶爷揶铘")
(qdl "ye3" "\
野冶也")
(qdl "ye4" "\
哗咽页掖业叶曳腋夜液\
拽靥谒邺晔烨")
(qdl "yi1" "\
一壹医揖铱依伊衣椅咿\
噫猗漪欹黟")
(qdl "yi2" "\
蛇颐夷遗移仪胰疑沂宜\
姨彝诒圯荑咦嶷饴怡迤\
贻眙痍")
(qdl "yi3" "\
蛾尾衣椅蚁倚已乙矣以\
苡迤旖钇舣酏")
(qdl "yi4" "\
艾衣艺抑易邑屹亿役臆\
逸肄疫亦裔意毅忆义益\
溢诣议谊译异翼翌绎刈\
劓仡佚佾埸懿薏弈奕挹\
弋呓嗌噫峄怿悒驿缢殪\
轶熠镒镱瘗癔翊蜴羿翳")
(qdl "yin1" "\
烟茵荫因殷音阴姻堙喑\
洇湮氤铟")
(qdl "yin2" "\
吟银淫寅鄞圻垠狺夤霪\
龈")
(qdl "yin3" "\
殷饮尹引隐吲瘾蚓")
(qdl "yin4" "\
荫饮印胤茚窨")
(qdl "ying1" "\
英樱婴鹰应缨莺撄嘤膺\
瑛璎鹦罂")
(qdl "ying2" "\
莹萤营荧蝇迎赢盈嬴茔\
荥萦蓥滢潆瀛楹")
(qdl "ying3" "\
影颖郢瘿颍")
(qdl "ying4" "\
应硬映媵")
(qdl "yo1" "\
哟育唷")
(qdl "yo5" "\
哟")
(qdl "yong1" "\
拥佣臃痈庸雍壅墉慵邕\
镛鳙饔")
(qdl "yong2" "\
喁")
(qdl "yong3" "\
踊蛹咏泳涌永恿勇俑甬")
(qdl "yong4" "\
佣用")
(qdl "you1" "\
幽优悠忧攸呦")
(qdl "you2" "\
尤由邮铀犹油游莜莸尢\
柚猷疣蚰蝣蝤繇鱿")
(qdl "you3" "\
酉有友卣莠牖铕黝")
(qdl "you4" "\
有右佑釉诱又幼侑囿宥\
柚蚴鼬")
(qdl "yu1" "\
迂淤吁纡於瘀")
(qdl "yu2" "\
于盂榆虞愚舆余俞逾鱼\
愉渝渔隅予娱与禺谀萸\
揄嵛狳馀妤瑜觎腴欤窬\
蝓竽臾舁雩")
(qdl "yu3" "\
予雨与屿禹宇语羽伛俣\
圄圉庾瘐窳龉")
(qdl "yu4" "\
谷蔚尉雨与语玉域芋郁\
吁遇喻峪御愈欲狱育誉\
浴寓裕预豫驭粥毓谕菀\
蓣饫阈鬻妪昱煜熨燠聿\
钰鹆鹬蜮")
(qdl "yuan1" "\
鸳渊冤眢鸢箢")
(qdl "yuan2" "\
元垣袁原援辕园员圆猿\
源缘塬芫圜沅媛橼爰螈\
鼋")
(qdl "yuan3" "\
远")
(qdl "yuan4" "\
苑愿怨院垸掾媛瑗")
(qdl "yue1" "\
曰约")
(qdl "yue4" "\
乐说越跃钥岳粤月悦阅\
龠瀹栎樾刖钺")
(qdl "yun1" "\
晕氲")
(qdl "yun2" "\
员耘云郧匀芸纭昀筠")
(qdl "yun3" "\
陨允狁殒")
(qdl "yun4" "\
均员运蕴酝晕韵孕郓恽\
愠韫熨")
(qdl "za1" "\
匝扎拶咂")
(qdl "za2" "\
砸杂咱")
(qdl "za3" "\
咋")
(qdl "zai1" "\
栽哉灾甾")
(qdl "zai3" "\
宰载仔崽")
(qdl "zai4" "\
载再在")
(qdl "zan1" "\
簪糌")
(qdl "zan2" "\
咱")
(qdl "zan3" "\
攒拶昝趱")
(qdl "zan4" "\
暂赞瓒錾")
(qdl "zan5" "\
咱")
(qdl "zang1" "\
赃锗臧")
(qdl "zang3" "\
驵")
(qdl "zang4" "\
藏脏葬奘")
(qdl "zao1" "\
遭糟")
(qdl "zao2" "\
凿")
(qdl "zao3" "\
藻枣早澡蚤缲")
(qdl "zao4" "\
躁噪造皂灶燥唣")
(qdl "ze2" "\
责择则泽咋赜啧帻迮笮\
箦舴")
(qdl "ze4" "\
侧仄昃")
(qdl "zei2" "\
贼")
(qdl "zen3" "\
怎")
(qdl "zen4" "\
谮")
(qdl "zeng1" "\
增憎曾缯罾")
(qdl "zeng4" "\
赠综缯甑锃")
(qdl "zha1" "\
查扎喳渣咋揸吒哳楂齄")
(qdl "zha2" "\
扎札轧铡闸炸喋")
(qdl "zha3" "\
眨砟")
(qdl "zha4" "\
蜡栅榨咋乍炸诈柞吒咤\
痄蚱")
(qdl "zhai1" "\
侧摘斋")
(qdl "zhai2" "\
翟择宅")
(qdl "zhai3" "\
窄")
(qdl "zhai4" "\
祭债寨砦瘵")
(qdl "zhan1" "\
瞻毡詹粘沾占谵旃")
(qdl "zhan3" "\
盏斩辗崭展搌")
(qdl "zhan4" "\
颤蘸栈占战站湛绽")
(qdl "zhang1" "\
樟章彰漳张鄣獐嫜璋蟑")
(qdl "zhang3" "\
长掌涨仉")
(qdl "zhang4" "\
涨杖丈帐账仗胀瘴障幛\
嶂")
(qdl "zhao1" "\
朝嘲招昭着啁钊")
(qdl "zhao2" "\
着")
(qdl "zhao3" "\
找沼爪")
(qdl "zhao4" "\
赵照罩兆肇召诏棹笊")
(qdl "zhe1" "\
遮折蜇")
(qdl "zhe2" "\
折哲蛰辙谪摺辄磔蜇")
(qdl "zhe3" "\
者锗褶赭")
(qdl "zhe4" "\
蔗这浙柘鹧")
(qdl "zhe5" "\
着")
(qdl "zhei4" "\
这")
(qdl "zhen1" "\
珍斟真甄砧臻贞针侦蓁\
浈溱桢椹榛胗祯箴")
(qdl "zhen3" "\
枕疹诊缜轸畛稹")
(qdl "zhen4" "\
震振镇阵圳赈朕鸩")
(qdl "zheng1" "\
丁蒸挣睁征狰争怔正症\
峥徵钲铮筝鲭")
(qdl "zheng3" "\
整拯")
(qdl "zheng4" "\
挣怔正政帧症郑证诤铮")
(qdl "zhi1" "\
氏芝枝支吱蜘知肢脂汁\
之织指只掷卮栀胝祗")
(qdl "zhi2" "\
职直植殖执值侄指埴摭\
絷跖踯")
(qdl "zhi3" "\
址指止趾只旨纸芷徵咫\
枳轵祉黹酯")
(qdl "zhi4" "\
识知志挚掷至致置帜峙\
制智秩稚质炙痔滞治窒\
陟郅帙忮彘骘栉桎轾贽\
膣雉鸷痣蛭踬豸觯")
(qdl "zhong1" "\
中盅忠钟衷终忪锺螽舯")
(qdl "zhong3" "\
种肿冢踵")
(qdl "zhong4" "\
中种重仲众")
(qdl "zhou1" "\
舟周州洲诌粥啁")
(qdl "zhou2" "\
轴妯碡")
(qdl "zhou3" "\
肘帚")
(qdl "zhou4" "\
轴咒皱宙昼骤荮纣绉胄\
籀繇酎")
(qdl "zhu1" "\
珠株蛛朱猪诸诛侏邾茱\
洙潴槠橥铢")
(qdl "zhu2" "\
术逐竹烛筑瘃竺舳躅")
(qdl "zhu3" "\
属煮拄瞩嘱主渚褚麈")
(qdl "zhu4" "\
著柱助蛀贮铸筑住注祝\
驻伫苎杼炷疰箸翥")
(qdl "zhua1" "\
挝抓")
(qdl "zhua3" "\
爪")
(qdl "zhuai1" "\
拽")
(qdl "zhuai3" "\
转")
(qdl "zhuai4" "\
曳拽嘬")
(qdl "zhuan1" "\
专砖颛")
(qdl "zhuan3" "\
转")
(qdl "zhuan4" "\
传转撰赚篆啭馔沌")
(qdl "zhuang1" "\
桩庄装妆")
(qdl "zhuang3" "\
奘")
(qdl "zhuang4" "\
幢撞壮状僮戆")
(qdl "zhui1" "\
椎锥追骓隹")
(qdl "zhui4" "\
赘坠缀惴缒")
(qdl "zhun1" "\
屯谆肫窀")
(qdl "zhun3" "\
准")
(qdl "zhuo1" "\
捉拙卓桌倬涿焯")
(qdl "zhuo2" "\
缴著琢茁酌啄着灼浊诼\
擢浞濯禚斫镯")
(qdl "zi1" "\
吱兹咨资姿滋淄孜仔谘\
呲嵫孳缁辎赀锱粢趑觜\
訾龇鲻髭")
(qdl "zi3" "\
紫仔籽滓子茈姊梓秭耔\
笫訾")
(qdl "zi4" "\
自渍字恣眦")
(qdl "zong1" "\
鬃棕踪宗综枞腙")
(qdl "zong3" "\
总偬")
(qdl "zong4" "\
纵粽")
(qdl "zou1" "\
邹诹陬鄹驺鲰")
(qdl "zou3" "\
走")
(qdl "zou4" "\
奏揍")
(qdl "zu1" "\
租菹")
(qdl "zu2" "\
足卒族镞")
(qdl "zu3" "\
祖诅阻组俎")
(qdl "zuan1" "\
钻躜")
(qdl "zuan3" "\
纂缵")
(qdl "zuan4" "\
赚钻攥")
(qdl "zui1" "\
堆")
(qdl "zui3" "\
咀嘴觜")
(qdl "zui4" "\
醉最罪蕞")
(qdl "zun1" "\
尊遵樽鳟")
(qdl "zun3" "\
撙")
(qdl "zuo1" "\
作嘬")
(qdl "zuo2" "\
琢昨作笮")
(qdl "zuo3" "\
撮左佐")
(qdl "zuo4" "\
凿柞做作坐座阼唑怍胙\
祚酢")
