/*      Jserver Interface for Mule
        Coded by Yutaka Ishikawa at ETL (yisikawa@etl.go.jp)
                 Satoru Tomura   at ETL (tomura@etl.go.jp)
	Modified for Wnn4 library by
		 Toshiaki Shingu (shingu@cpr.canon.co.jp)
		 Hiroshi Kuribayashi (kuri@nff.ncl.omron.co.jp)

   This file is part of Egg on Nemacs (Japanese environment)

   Egg is distributed in the forms of patches to GNU
   Emacs under the terms of the GNU EMACS GENERAL PUBLIC
   LICENSE which is distributed along with GNU Emacs by the
   Free Software Foundation.

   Egg is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied
   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
   PURPOSE.  See the GNU EMACS GENERAL PUBLIC LICENSE for
   more details.

   You should have received a copy of the GNU EMACS GENERAL
   PUBLIC LICENSE along with Nemacs; see the file COPYING.
   If not, write to the Free Software Foundation, 675 Mass
   Ave, Cambridge, MA 02139, USA. */

/*
 *      CHANGE LOG
 *
 *	1994.2.24  check_wnn_server_type() should not be static.
 *	1994.2.3   kWnn support by H.Kuribayashi.
 *	1993.6.29  wnn-server-set-rev updated.
 *	1993.4.23  serious bug in wnn-server-open fixed.
 *	1993.4.2   wnn-server-fuzokugo-set,
 *		wnn-server-dict-add, wnn-server-dict-delete,
 *		wnn-server-dict-comment, wnn-server-dict-save,
 *		wnn-server-word-search, wnn-server-word-hindo-set,
 *		wnn-server-word-info, wnn-server-word-use,
 *		wnn-server-word-delete, wnn-server-word-add
 *		changed to support fixed type dictionary.
 *	1993.3.3   w2y: bug fixed.
 *	1992.12.7  wnn-server-set-param was modified to set parameters on
 *		normal/reverse environment individually.
 *	1992.11.27 wnn-server-get-msg fixed by kuri.
 *	1992.10.29 m2w() and w2m() handle PY_EOF for cserver.
 *	1992.10.19 Slight change in Fwnn_word_info() by T.Atsushiba
 *	1992.09.29 completely modified for chinese translation.
 *	1992.09.03 code related to wnn_error changed.
 *	1992.08.20 yes_or_no
 *	1992.07.02 wnn-server-dict-list modified
 *	1992.07.02 wnn-server-word-info
 *	1992.05.18 modified for mule
 *	1992.05.15 wnn-server-dict-add/query
 *	1992.05.09 SERIOUS BUG FIX with jl_close
 *	1992.05.09 wnn-server-open with lang
 *	1992.05.09 wnn-server-inspect inproved
 *	1992.05.09 zenkouho with dai/sho bunsetu
 *	1992.04.23 rewrite for jl library by T.Shingu(shingu@cpr.canon.co.jp)
 *	-----------------------------------------------------------------------
 *
 *	Functions defined in this file are
 *	   (wnn-server-open wnn-host-name login-name)
 *		wnn-host-name: STRING or NIL
 *		login-name: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		jserver と接続し、サーバー内部に正変換／逆変換２つの環境を
 *		作る。エラーの時は nil を返す。
 *
 *	   (wnn-server-close)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		jserver との接続を切る。辞書、頻度はセーブされない。
 *
 *	   (wnn-server-dict-add dict-file-name hindo-file-name priority
 *		dict-file-mode hindo-file-mode pw1 pw2)
 *		dict-file-name: STRING
 *		hindo-file-name: STRING or NULL-STRING
 *		priority: INTEGER
 *		dict-file-mode: BOOLEAN
 *		hindo-file-mode: BOOLEAN
 *		pw1: STRING or NIL
 *		pw2: STRING or NIL
 *		DESCRIPTION:
 *		辞書ファイル名、頻度ファイル名、優先度、辞書ファイルモード
 *		頻度ファイルモードで指定した辞書をバッファに追加する。
 *		pw1, pw2 は辞書ファイル、頻度ファイルのパスワード。
 *
 *	   (wnn-server-dict-delete dic-no)
 *		dic-no: INTEGER
 *		RETURNS: エラーの時 nil
 *		DESCRIPTION: dic-no の辞書番号の辞書を、バッファから
 *		削除する。
 *
 *	   (wnn-server-dict-list)
 *		RETURNS: ((dic-no1 file-name1 comment1 word-no1 nice1)
 *			  (dic-no2 file-name2 comment2 word-no2 nice2)...)
 *		DESCRIPTION: バッファ上の辞書のリストを得る。
 *
 *	   (wnn-server-dict-comment dic-no comment)
 *		RETURNS: エラーの時 nil
 *		DESCRIPTION: dic-no の辞書にコメントをつける。
 *
 *	   (wnn-server-set-rev rev)
 *		rev: BOOLEAN
 *		rev が nil の時は正変換、それ以外の時は逆変換
 *
 *	   (wnn-server-henkan-begin henkan-string)
 *		henkan-string: STRING
 *		RETURNS: bunsetu-suu
 *		DESCRIPTION:
 *		仮名漢字変換をし、第一候補の文節数を返す。
 *
 *	   (wnn-server-zenkouho bunsetu-no dai)
 *		bunsetu-no: INTEGER
 *		dai: BOOLEAN
 *		RETURNS: offset
 *		DESCRIPTION:
 *		文節番号で指定された文節の全候補をとりだし
 *		、現在のオフセットを返す。
 *
 *	   (wnn-server-get-zenkouho offset)
 *		bunsetu-no: INTEGER
 *		dai: BOOLEAN
 *		RETURNS: list of zenkouho
 *		DESCRIPTION:
 *		オフセットで指定された候補を得る。
 *
 *	   (wnn-server-zenkouho-bun)
 *		RETURNS: INTEGER
 *		DESCRIPTION:
 *		全候補を表示している文節番号を得る。
 *
 *	   (wnn-server-zenkouho-suu)
 *		RETURNS: INTEGER
 *		DESCRIPTION:
 *		全候補を表示している文節の全候補数を得る。
 *
 *	   (wnn-server-dai-top bun-no)
 *		bun-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		文節が大文節の先頭なら t
 *
 *	   (wnn-server-dai-end bun-no)
 *		bun-no: INTEGER
 *		RETURNS: INTEGER
 *		DESCRIPTION:
 *		次の大文節の文節番号を得る。
 *
 *	   (wnn-server-henkan-kakutei kouho-no dai)
 *		kouho-no: INTEGER
 *		dai: BOOLEAN
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		候補番号で示された候補を選択する。
 *		(wnn-server-zenkouho) を呼んてからでないといけない。
 *
 *	   (wnn-server-bunsetu-henkou bunsetu-no bunsetu-length dai)
 *		bunsetu-no: INTEGER
 *		bunsetu-length: INTEGER
 *		dai: BOOLEAN
 *		RETURNS:
 *		DESCRIPTION:
 *		文節の長さを変更する。
 *
 *         (wnn-bunsetu-kouho-inspect bunsetu-no)
 *              bunsetu-no: INTEGER
 *              RETURNS: (kanji yomi jisho-no serial-no hinsi hindo
 *		ima hyoka daihyoka kangovect)
 *		DESCRIPTION:
 *		文節の色々な情報を変換バッファからとり出す。
 *
 *	   (wnn-server-henkan-quit)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		何もしない。
 *
 *	   (wnn-server-bunsetu-kanji bun-no)
 *		RETURNS: (bunsetu-kanji length)
 *		DESCRIPTION:
 *
 *	   (wnn-server-bunsetu-yomi bun-no)
 *		RETURNS: (bunsetu-yomi length)
 *		DESCRIPTION:
 *
 *	   (wnn-server-bunsetu-suu)
 *		RETURNS: bunsetu-suu
 *		DESCRIPTION:
 *
 *	   (wnn-server-hindo-update &optional bunsetu-no)
 *              bunsetu-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		頻度情報を更新する。
 *
 *	   (wnn-server-word-add dic-no tango yomi comment hinsi)
 *		dic-no: INTEGER
 *		tango: STRING
 *		yoni: STRING
 *		comment: STRING
 *		hinsi: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		辞書に単語を登録する。
 *
 *	   (wnn-server-word-delete dic-no entry)
 *		dic-no: INTEGER
 *		entry: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		辞書からエントリ番号で示される単語を削除する。
 *
 *	   (wnn-server-word-use dic-no entry)
 *		dic-no: INTEGER
 *		entry: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		辞書からエントリ番号で示される単語の有効／無効をトグルする。
 *
 *	   (wnn-server-word-info dic-no entry)
 *		dic-no: INTEGER
 *		entry: INTEGER
 *		RETURNS: (yomi kanji comment hindo hinsi)
 *		DESCRIPTION:
 *		辞書からエントリ番号で示される単語の情報を得る。
 *
 *	   (wnn-server-word-hindo-set dic-no entry hindo)
 *		dic-no: INTEGER
 *		entry: INTEGER
 *		hindo: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		辞書からエントリ番号で示される単語の頻度を設定する。
 *
 *	   (wnn-server-word-search yomi)
 *		yomi: STRING
 *		RETURNS: a LIST of dict-joho
 *		DESCRIPTION:
 *		全ての辞書から単語検索を行なう。
 *
 *         (wnn-server-dict-save)
 *              RETURNS: BOOLEAN
 *              DESCRIPTION:
 *		全ての辞書と頻度ファイルをセーブする。
 *
 *	   (wnn-server-get-param)
 *		RETURNS: (n nsho p1 p2 p3 ... p15)
 *		DESCRIPTION: 変換パラメータを得る。
 *
 *	   (wnn-server-set-param n sho p1 ... p15)
 *		RETURNS: エラーの時 nil
 *		DESCRIPTION: 変換パラメータを設定する。
 *
 *	   (wnn-server-get-msg error-no)
 *		RETURNS: エラーメッセージ
 *		DESCRIPTION: エラー番号からメッセージを得る。
 *
 *	   (wnn-server-fuzokugo-set fname)
 *		RETURNS: エラーの時 nil
 *		DESCRIPTION: バッファに附属語ファイルを読み込む。
 *
 *	   (wnn-server-fuzokugo-get)
 *		RETURNS: ファイル名
 *		DESCRIPTION: バッファの附属語ファイル名を得る。
 *
 *	   (wnn-server-isconnect)
 *		RETURNS: コネクトしてれば t, してなければ nil
 *		DESCRIPTION: サーバと継っているか調べる。
 *
 *	   (wnn-server-hinsi-dicts hinsi-no)
 *		RETURNS: (dic-no1 dic-no2 ...)
 *		DESCRIPTION: hinsi-no の品詞が登録できる辞書のリストを得る。
 *		hinsi-no = -1 のときには、登録可能な全辞書を得る。
 *
 *	   (wnn-server-hinsi-list dic-no name)
 *		RETURNS: (name1 name2 ... )
 *		DESCRIPTION: dic-no の辞書で、品詞ノードに属する
 *		品詞ノード（名）のリストを得る。
 *		品詞名を与えた時は、０を返す。
 *
 *	   (wnn-server-hinsi-name hinsi-no)
 *		RETURNS: hinsi-name
 *		DESCRIPTION: 品詞番号から名前を取る。
 *
 *	   (wnn-server-hinsi-number hinsi-name)
 *		RETURNS: hinsi-no
 *		DESCRIPTION: 品詞名を品詞番号に変換する。
 */

#include <ctype.h>

#include "config.h"

#include "commonhd.h"
#include "jllib.h"
#include "cplib.h"

#define EGG_TIMEOUT 5
#define NSERVER 4
#define WNNSERVER_J 0
#define WNNSERVER_C 1
#define WNNSERVER_T 2
#define WNNSERVER_K 3

#ifdef NULL
#undef NULL
#endif
#include "lisp.h"
#include "buffer.h"
#include "window.h"
#include "mule.h"

static struct wnn_buf *wnnfns_buf[NSERVER];
static struct wnn_env *wnnfns_env_norm[NSERVER];
static struct wnn_env *wnnfns_env_rev[NSERVER];
static int wnnfns_norm;
static unsigned char lc_wnn_server_type[NSERVER] = {LCJP, LCCN, LCINV, LCKR};

static int yes_or_no();
static void puts2();

/* Lisp Variables and Constants Definition */
Lisp_Object	Qjserver;
Lisp_Object	Qcserver;
/*Lisp_Object	Qtserver;*/
Lisp_Object	Qkserver;
Lisp_Object	Qwnn_no_uniq;
Lisp_Object	Qwnn_uniq;
Lisp_Object	Qwnn_uniq_kanji;
Lisp_Object	Vwnn_server_type;
Lisp_Object	Vcwnn_zhuyin;
Lisp_Object	Vwnnenv_sticky;
Lisp_Object	Vwnn_uniq_level;
int		lc_sisheng;

/* Lisp functions definition */
Lisp_Object Fwnn_set_param (int, Lisp_Object *);


DEFUN ("wnn-server-open", Fwnn_open, Swnn_open,
  2, 2, 0,
  "Connect to jserver of host HNAME, make an environment with\n\
login name LNAME in the server.\n\
Return nil if error occurs")
     (hname, lname)
     register Lisp_Object hname, lname;
{
  char	envname[32];
  char	langname[32];
  char	hostname[32];
  int	snum;
  CHECK_STRING (lname, 0);

  snum = check_wnn_server_type();
  switch (snum) {
  case WNNSERVER_J:
    strcpy(langname, "ja_JP");
    break;
  case WNNSERVER_C:
    strcpy(langname, "zh_CN");
    break;
/*  
  case WNNSERVER_T:
    strcpy(langname, "zh_TW");
    break;
*/
  case WNNSERVER_K:
    strcpy(langname, "ko_KR");
    break;
  }
  strncpy(envname, XSTRING(lname)->data, 32);
  if (hname == Qnil) strcpy(hostname, "");
  else {
    CHECK_STRING (hname, 1);
    strncpy(hostname, XSTRING(hname)->data, 32);
  }
  CHECK_STRING (lname, 1);
  if(!(wnnfns_buf[snum] = jl_open_lang(envname, hostname, langname,
				       0, 0, 0, EGG_TIMEOUT))) {
    return Qnil;
  }
  if (!jl_isconnect(wnnfns_buf[snum])) return Qnil;
  wnnfns_env_norm[snum] = jl_env_get(wnnfns_buf[snum]);
/*  if (Vwnnenv_sticky == Qt) jl_env_sticky_e(wnnfns_env_norm[snum]);
  else jl_env_un_sticky_e(wnnfns_env_norm[snum]);*/
  strcat(envname, "R");
  if(!(wnnfns_env_rev[snum] = jl_connect_lang(envname, hostname, langname,
					      0, 0, 0, EGG_TIMEOUT))) {
    return Qnil;
  }
/*  if (Vwnnenv_sticky == Qt) jl_env_sticky_e(wnnfns_env_rev[snum]);
  else jl_env_un_sticky_e(wnnfns_env_rev[snum]);*/
  return Qt;
}


DEFUN ("wnn-server-close", Fwnn_close, Swnn_close, 0, 0, 0,
       "Close the connection to jserver, Dictionary and friquency files\n\
are not saved.")
     ()
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(wnnfns_env_norm[snum]) {
    if (Vwnnenv_sticky == Qnil) jl_env_un_sticky_e(wnnfns_env_norm[snum]);
    else jl_env_sticky_e(wnnfns_env_norm[snum]);
    jl_disconnect(wnnfns_env_norm[snum]);
  }
  if(wnnfns_env_rev[snum]) {
    if (Vwnnenv_sticky == Qnil) jl_env_un_sticky_e(wnnfns_env_rev[snum]);
    else jl_env_sticky_e(wnnfns_env_rev[snum]);
    jl_disconnect(wnnfns_env_rev[snum]);
  }
  jl_env_set(wnnfns_buf[snum], 0);
  jl_close(wnnfns_buf[snum]);
  wnnfns_buf[snum] = (struct wnn_buf *)0;
  wnnfns_env_norm[snum] = wnnfns_env_rev[snum] = (struct wnn_env *)0;
  return Qt;
}

DEFUN ("wnn-server-dict-add", Fwnn_dict_add, Swnn_dict_add, 5, MANY, 0,
       "Add dictionary specified by DIICT-FILE-NAME, FREQ-FILE-NAME,\n\
PRIORITY, DICT-FILE-MODE, FREQ-FILE-MODE.\n\
Specify password files of dictionary and frequency, PW1 and PW2, if needed.")
     (nargs, args)
     int			nargs;
     register Lisp_Object	*args;
{
  struct gcpro gcpro1;
  int	snum;
  CHECK_STRING (args[0], 0);
  CHECK_STRING (args[1], 1);
  CHECK_NUMBER (args[2], 2);
  if (args[5] != Qnil) CHECK_STRING (args[5], 5);
  if (args[6] != Qnil) CHECK_STRING (args[6], 6);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  GCPRO1 (*args);
  gcpro1.nvars = nargs;
  if(jl_dic_add(wnnfns_buf[snum],
		XSTRING(args[0])->data,
		XSTRING(args[1])->data,
		wnnfns_norm ? WNN_DIC_ADD_NOR : WNN_DIC_ADD_REV,
		XINT(args[2]),
		(args[3] == Qnil) ? WNN_DIC_RDONLY : WNN_DIC_RW,
		(args[4] == Qnil) ? WNN_DIC_RDONLY : WNN_DIC_RW,
		(args[5] == Qnil) ? 0 : XSTRING(args[5])->data,
		(args[6] == Qnil) ? 0 : XSTRING(args[6])->data,
		yes_or_no,
		puts2 ) < 0) {
    UNGCPRO;
    return Qnil;
  }
  UNGCPRO;
  return Qt;
}

DEFUN ("wnn-server-dict-delete", Fwnn_dict_delete, Swnn_dict_delete, 
       1, 1, 0,
       "Remove dictionary specified by DIC-NUMBER from buffer.")
     (dicno)
     register Lisp_Object dicno;
{
  int	no;
  int	snum;
  CHECK_NUMBER(dicno, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  no = XINT(dicno);
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_dic_delete(wnnfns_buf[snum], no) < 0) return Qnil;
  return Qt;
}

DEFUN ("wnn-server-dict-list", Fwnn_dict_list, Swnn_dict_list, 
       0, 0, 0,
       "Return information of dictionaries.")
     ()
{
  WNN_DIC_INFO	*dicinfo;
  int		cnt, i;
  unsigned char	comment[1024];
  Lisp_Object	val;
  int	snum;  
  unsigned char lc;

  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  if((cnt = jl_dic_list(wnnfns_buf[snum], &dicinfo)) < 0) return Qnil;
  val = Qnil;
  for(i = 0, dicinfo += cnt; i < cnt; i++) {
    dicinfo--;
    w2m(dicinfo->comment, comment, lc);
    val = Fcons(Fcons(make_number(dicinfo->dic_no),
		Fcons(make_string(dicinfo->fname, strlen(dicinfo->fname)),
		Fcons(make_string(comment, strlen(comment)),
		Fcons(make_number(dicinfo->gosuu),
		Fcons(make_number(dicinfo->nice), Qnil))))), val);
	}
  return val;
}

DEFUN ("wnn-server-dict-comment", Fwnn_dict_comment, Swnn_dict_comment, 
       2, 2, 0,
       "Set comment to dictionary specified by DIC-NUMBER.\n\
Comment string COMMENT")
     (dicno, comment)
     register Lisp_Object dicno, comment;
{
  w_char		wbuf[512];
  int	snum;
  CHECK_NUMBER(dicno, 0);
  CHECK_STRING(comment, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  m2w(XSTRING(comment)->data, wbuf);
  if(jl_dic_comment_set(wnnfns_buf[snum], XINT(dicno), wbuf) < 0) 
    return Qnil;
  return Qt;
}


DEFUN ("wnn-server-set-rev", Fwnn_set_rev, Swnn_set_rev, 
       1, 1, 0,
       "Switch the translation mode to normal if T, or reverse if NIL.")
     (rev)
     register Lisp_Object rev;
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(rev == Qnil){
    if((!wnnfns_buf[snum]) || (!wnnfns_env_norm[snum])) return;
    jl_env_set(wnnfns_buf[snum], wnnfns_env_norm[snum]);
    wnnfns_norm = 1;
  }
  else{
    if((!wnnfns_buf[snum]) || (!wnnfns_env_rev[snum])) return;
    jl_env_set(wnnfns_buf[snum], wnnfns_env_rev[snum]);
    wnnfns_norm = 0;
  }
}

DEFUN ("wnn-server-henkan-begin", Fwnn_begin_henkan, Swnn_begin_henkan, 
       1, 1, 0,
       "Translate YOMI string to kanji. Retuen the number of bunsetsu.")
     (hstring)
     register Lisp_Object hstring;
{
  int			cnt;
  w_char		wbuf[5000];
  int	snum;
  CHECK_STRING(hstring, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  m2w(XSTRING(hstring)->data, wbuf);
  if (snum == WNNSERVER_C)	/* 92.10.30 by T.Saneto */
      w2y(wbuf);

  if((cnt = jl_ren_conv(wnnfns_buf[snum], wbuf,	0, -1, WNN_USE_MAE)) < 0) 
    return Qnil;
  return make_number(cnt);
}

DEFUN ("wnn-server-zenkouho", Fwnn_zenkouho, Swnn_zenkouho, 2, 2, 0,
       "Get zenkouho at BUNSETSU-NUMBER. Second argument DAI is T\n\
if dai-bunsetsu, NIL if sho-bunsetsu. Return the current offset of zenkouho.")
     (bunNo, dai)
     register Lisp_Object bunNo, dai;
{
  int		no, offset;
  int	snum;
  int	uniq_level;
  CHECK_NUMBER(bunNo, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  no = XINT(bunNo);
  if (Vwnn_uniq_level == Qwnn_no_uniq) uniq_level = WNN_NO_UNIQ;
  else if (Vwnn_uniq_level == Qwnn_uniq) uniq_level = WNN_UNIQ;
  else uniq_level = WNN_UNIQ_KNJ;
  if(dai == Qnil) {
    if (offset = jl_zenkouho(wnnfns_buf[snum],no,WNN_USE_MAE, uniq_level) < 0)
      return Qnil;
  }
  else {
    if (offset = jl_zenkouho_dai(wnnfns_buf[snum], no, dai_end(no, snum),
				 WNN_USE_MAE, uniq_level) < 0)
      return Qnil;
  }
  return make_number(offset);
}


DEFUN ("wnn-server-get-zenkouho", Fwnn_get_zenkouho, Swnn_get_zenkouho,
       1, 1, 0, "Get kanji string of KOUHO-NUMBER")
     (kouhoNo)
     register Lisp_Object kouhoNo;
{
  unsigned char	kanji_buf[256];
  w_char	wbuf[256];
  int	snum;
  unsigned char lc;
  CHECK_NUMBER(kouhoNo, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  jl_get_zenkouho_kanji(wnnfns_buf[snum], XINT(kouhoNo), wbuf);
  w2m(wbuf, kanji_buf, lc);
  return make_string(kanji_buf, strlen(kanji_buf));
}

DEFUN ("wnn-server-zenkouho-bun", Fwnn_zenkouho_bun, Swnn_zenkouho_bun,
       0, 0, 0,
       "For Wnn.")
     ()
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  return make_number(jl_zenkouho_bun(wnnfns_buf[snum]));
}

DEFUN ("wnn-server-zenkouho-suu", Fwnn_zenkouho_suu, Swnn_zenkouho_suu,
       0, 0, 0,
       "Return the number of zen kouho")
     ()
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  return make_number(jl_zenkouho_suu(wnnfns_buf[snum]));
}

DEFUN ("wnn-server-dai-top", Fwnn_dai_top, Swnn_dai_top, 1, 1, 0,
       "Return T if bunsetsu BUN-NUMBER is dai-bunsetsu.")
     (bunNo)
     register Lisp_Object bunNo;
{
  int	snum;
  CHECK_NUMBER(bunNo, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if (jl_dai_top(wnnfns_buf[snum], XINT(bunNo)) == 1) return Qt;
  else return Qnil;
}

DEFUN ("wnn-server-dai-end", Fwnn_dai_end, Swnn_dai_end, 1, 1, 0,
       "Return the bunsetu number of the next dai-bunsetsu after BUN-NUMBER.")
     (bunNo)
     register Lisp_Object bunNo;
{
  int	snum;
  CHECK_NUMBER(bunNo, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  return make_number(dai_end(XINT(bunNo), snum));
}

DEFUN ("wnn-server-henkan-kakutei", Fwnn_kakutei, Swnn_kakutei, 2, 2, 0,
       "Set candidate with OFFSET, DAI. DAI is T if dai-bunsetsu.")
     (offset, dai)
     register Lisp_Object offset, dai;
{
  int	snum;
  CHECK_NUMBER(offset, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(dai == Qnil) {
    if(jl_set_jikouho(wnnfns_buf[snum], XINT(offset)) < 0) return Qnil;
  }
  else {
    if(jl_set_jikouho_dai(wnnfns_buf[snum], XINT(offset)) < 0) return Qnil;
  }
  return Qt;
}

DEFUN ("wnn-server-bunsetu-henkou", Fwnn_bunsetu_henkou, Swnn_bunsetu_henkou,
       3, 3, 0,
       "Change length of BUN-NUMBER bunsetu to LEN. DAI is T if dai-bunsetsu.")
     (bunNo, len, dai)
     register Lisp_Object bunNo, len, dai;
{
  Lisp_Object	val;
  int		cnt, no;
  int	snum;
  CHECK_NUMBER(bunNo, 0);
  CHECK_NUMBER(len, 1);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  no = XINT(bunNo);
  if((cnt = jl_nobi_conv(wnnfns_buf[snum], no, XINT(len), -1, WNN_USE_MAE,
			 (dai == Qnil) ? WNN_SHO : WNN_DAI)) < 0)
    return Qnil;
  return make_number(cnt);
}

DEFUN ("wnn-server-inspect", Fwnn_inspect, Swnn_inspect, 1, 1, 0,
       "Get bunsetsu information specified by BUN-NUMBER.")
     (bunNo)
     Lisp_Object  bunNo;
{
  Lisp_Object		val;
  struct wnn_jdata	*info_buf;
  unsigned char		cbuf[512];
  w_char		wbuf[256];
  int			bun_no, yomilen, jirilen, i;
  int	snum;
  unsigned char		lc;
  CHECK_NUMBER(bunNo, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  bun_no = XINT(bunNo);
  val = Qnil;
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->kangovect), val);
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->daihyoka), val);
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->hyoka), val);
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->ima), val);
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->hindo), val);
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->hinsi), val);
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->entry), val);
  val = Fcons(make_number(wnnfns_buf[snum]->bun[bun_no]->dic_no), val);
  yomilen = jl_get_yomi(wnnfns_buf[snum], bun_no, bun_no + 1, wbuf);
  jirilen = wnnfns_buf[snum]->bun[bun_no]->jirilen;
  for(i = yomilen; i >= jirilen; i--) wbuf[i+1] = wbuf[i];
  wbuf[jirilen] = '+';
  w2m(wbuf, cbuf, lc);
  val = Fcons(make_string(cbuf, strlen(cbuf)), val);
  jl_get_kanji(wnnfns_buf[snum], bun_no, bun_no + 1, wbuf);
  w2m(wbuf, cbuf, lc);
  val = Fcons(make_string(cbuf, strlen(cbuf)), val);
  return val;
}


DEFUN ("wnn-server-henkan-quit", Fwnn_quit_henkan, Swnn_quit_henkan, 0, 0, 0,
       "do nothing")
     ()
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  return Qt;
}

DEFUN ("wnn-server-bunsetu-kanji", Fwnn_bunsetu_kanji, Swnn_bunsetu_kanji,
       1, 1, 0,
       "Get the pair of kanji and length of bunsetsu specified by BUN-NUMBER.")
     (bunNo)
     register Lisp_Object bunNo;
{
  register int		no;
  unsigned char		kanji_buf[256];
  w_char		wbuf[256];
  int			kanji_len;
  int			snum;
  unsigned char		lc;
  CHECK_NUMBER(bunNo, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  no = XINT(bunNo);
  kanji_len = jl_get_kanji(wnnfns_buf[snum], no, no + 1, wbuf);
  w2m(wbuf, kanji_buf, lc);
  return Fcons(make_string(kanji_buf, strlen(kanji_buf)),
	       make_number(kanji_len));
}

DEFUN ("wnn-server-bunsetu-yomi", Fwnn_bunsetu_yomi, Swnn_bunsetu_yomi,
       1, 1, 0,
       "Get the pair of yomi and length of bunsetsu specified by BUN-NUMBER.")
     (bunNo)
     register Lisp_Object bunNo;
{
  register int		no;
  unsigned char		yomi_buf[256];
  w_char		wbuf[256];
  int			yomi_len;
  int			snum;
  unsigned char		lc;
  CHECK_NUMBER(bunNo, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  no = XINT(bunNo);
  yomi_len = jl_get_yomi(wnnfns_buf[snum], no, no + 1, wbuf);
  w2m(wbuf, yomi_buf, lc);
  return Fcons(make_string(yomi_buf, strlen(yomi_buf)),
	       make_number(yomi_len));
}

DEFUN ("wnn-server-bunsetu-suu", Fwnn_bunsetu_suu, Swnn_bunsetu_suu,
       0, 0, 0,
       "Get the number of bunsetsu.")
     ()
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  return make_number(jl_bun_suu(wnnfns_buf[snum]));
}

DEFUN ("wnn-server-hindo-update", Fwnn_hindo_update, Swnn_hindo_update,
       0, 1, 0,
       "Update frequency of bunsetsu specified by NUM-NUMBER.")
     (bunNo)
     Lisp_Object  bunNo;
{
  int		no;
  Lisp_Object	val;
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if (bunNo == Qnil) no = -1;
  else {
    CHECK_NUMBER(bunNo, 0);
    no = XINT(bunNo);
  }
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_update_hindo(wnnfns_buf[snum], 0, no) < 0) return Qnil;
  return Qt;
}


DEFUN ("wnn-server-word-add", Fwnn_word_toroku, Swnn_word_toroku, 5, 5, 0,
       "Add a word to dictionary. Arguments are\n\
DIC-NUMBER, KANJI, YOMI, COMMENT, HINSI-NUMBER")
     (dicno, kanji, yomi, comment, hinsi)
     register Lisp_Object dicno, kanji, yomi, comment, hinsi;
{
  w_char		yomi_buf[256], kanji_buf[256], comment_buf[256];
  int	snum;
  CHECK_NUMBER(dicno, 0);
  CHECK_STRING(kanji, 1);
  CHECK_STRING(yomi, 2);
  CHECK_STRING(comment, 3);
  CHECK_NUMBER(hinsi, 4);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  m2w(XSTRING(yomi)->data, yomi_buf);
  if (snum == WNNSERVER_C)
      w2y(yomi_buf);
  m2w(XSTRING(kanji)->data, kanji_buf);
  m2w(XSTRING(comment)->data, comment_buf);
  if(jl_word_add(wnnfns_buf[snum], XINT(dicno), yomi_buf, kanji_buf,
		 comment_buf, XINT(hinsi), 0) < 0) 
    return Qnil;
  else return Qt;
}


DEFUN ("wnn-server-word-delete", Fwnn_word_sakujo, Swnn_word_sakujo, 2, 2, 0,
       "Delete a word from dictionary, specified by DIC-NUMBER, SERIAL-NUMBER")
     (no, serial)
     register Lisp_Object no, serial;
{
  int	snum;
  CHECK_NUMBER(no, 0);
  CHECK_NUMBER(serial, 1);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_word_delete(wnnfns_buf[snum], XINT(no), XINT(serial)) < 0)
    return Qnil;
  else return Qt;
}


DEFUN ("wnn-server-word-use", Fwnn_word_use, Swnn_word_use, 2, 2, 0,
       "Toggle on/off word, specified by DIC-NUMBER and SERIAL-NUMBER")
     (no, serial)
     register Lisp_Object no, serial;
{
  int	snum;
  CHECK_NUMBER(no, 0);
  CHECK_NUMBER(serial, 1);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_word_use(wnnfns_buf[snum], XINT(no), XINT(serial)) < 0)
    return Qnil;
  else return Qt;
}

DEFUN ("wnn-server-word-info", Fwnn_word_info, Swnn_word_info, 2, 2, 0,
       "Return list of yomi, kanji, comment, hindo, hinshi.")
     (no, serial)
     register Lisp_Object no, serial;
{
  Lisp_Object		val;
  struct wnn_jdata	*info_buf;
  unsigned char		cbuf[512];
  int			snum;
  unsigned char		lc;
  CHECK_NUMBER(no, 0);
  CHECK_NUMBER(serial, 1);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  /* 92.10.19 patch by T.Atsushiba <atsushiba@ailove.ENET.dec.com>
     -- coerced to (int) */
  if((int)(info_buf =  jl_word_info(wnnfns_buf[snum],
				 XINT(no), XINT(serial))) <= 0) {
    return Qnil;
  } else {
    val = Qnil;
    val = Fcons(make_number(info_buf->hinshi), val);
    val = Fcons(make_number(info_buf->hindo), val);
    w2m(info_buf->com, cbuf, lc);
    val = Fcons(make_string(cbuf, strlen(cbuf)), val);
    w2m(info_buf->kanji, cbuf, lc);
    val = Fcons(make_string(cbuf, strlen(cbuf)), val);
    w2m(info_buf->yomi, cbuf, lc);
    val = Fcons(make_string(cbuf, strlen(cbuf)), val);
    return val;
  }
}

DEFUN ("wnn-server-word-hindo-set", Fwnn_hindo_set, Swnn_hindo_set, 3, 3, 0,
       "Set frequency to arbitrary value. Specified by DIC-NUMBER,\n\
SERIAL-NUMBER, FREQUENCY")
     (no, serial, hindo)
     register Lisp_Object no, serial, hindo;
{
  int	snum;
  CHECK_NUMBER(no, 0);
  CHECK_NUMBER(serial, 1);
  CHECK_NUMBER(hindo, 2);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(js_hindo_set(jl_env_get(wnnfns_buf[snum]),
		  XINT(no),
		  XINT(serial),
		  WNN_HINDO_NOP,
		  XINT(hindo)) < 0)
    return Qnil;
  else return Qt;
}


DEFUN ("wnn-server-word-search", Fwnn_dict_search, Swnn_dict_search, 1, 1, 0,
       "Search a word YOMI from buffer.\n\
Return list of (kanji hinshi freq dic_no serial).")
     (yomi)
     register Lisp_Object yomi;
{
  Lisp_Object		val;
  struct wnn_jdata	*wordinfo;
  int			i, count;
  w_char			wbuf[256];
  unsigned char		kanji_buf[256];
  int			kanji_len;
  int			snum;
  unsigned char		lc;
  CHECK_STRING(yomi, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  m2w(XSTRING(yomi)->data, wbuf);
  if (snum == WNNSERVER_C)
      w2y(wbuf);
  if((count = jl_word_search_by_env(wnnfns_buf[snum],
				    wbuf, &wordinfo)) < 0)
    return Qnil;
  val = Qnil;
  for(i = 0, wordinfo += count; i < count; i++) {
    wordinfo--;
    w2m(wordinfo->kanji, kanji_buf, lc);
    val = Fcons(Fcons(make_string(kanji_buf, strlen(kanji_buf)),
		Fcons(make_number(wordinfo->hinshi),
		Fcons(make_number(wordinfo->hindo),
		Fcons(make_number(wordinfo->dic_no),
		Fcons(make_number(wordinfo->serial), Qnil))))),
		val);
  }
  return val;
}

DEFUN ("wnn-server-dict-save", Fwnn_dict_save, Swnn_dict_save, 0, 0, 0,
       "Save all dictianaries and grequency files.")
     ()
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_dic_save_all(wnnfns_buf[snum]) < 0) return Qnil;
  else return Qt;
}

DEFUN ("wnn-server-get-param", Fwnn_get_param, Swnn_get_param,
       0, 0, 0,
       "Returns (n nsho hindo len jiri flag jisho sbn dbn_len sbn_cnt\n\
suuji kana eisuu kigou toji_kakko fuzokogo kaikakko)")
     ()
{
  struct wnn_param	param;
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_param_get(wnnfns_buf[snum], &param) < 0) return Qnil;
  return Fcons(make_number(param.n),
	 Fcons(make_number(param.nsho),
	 Fcons(make_number(param.p1),
	 Fcons(make_number(param.p2),
	 Fcons(make_number(param.p3),
	 Fcons(make_number(param.p4),
	 Fcons(make_number(param.p5),
	 Fcons(make_number(param.p6),
	 Fcons(make_number(param.p7),
	 Fcons(make_number(param.p8),
	 Fcons(make_number(param.p9),
	 Fcons(make_number(param.p10),
	 Fcons(make_number(param.p11),
	 Fcons(make_number(param.p12),
	 Fcons(make_number(param.p13),
	 Fcons(make_number(param.p14),
	 Fcons(make_number(param.p15),Qnil)))))))))))))))));
}

DEFUN ("wnn-server-set-param", Fwnn_set_param, Swnn_set_param,
       17, MANY, 0,
       "Set parameters, n nsho hindo len jiri flag jisho sbn dbn_len sbn_cnt\n\
suuji kana eisuu kigou toji_kakko fuzokogo kaikakko")
     (nargs, args)
     int nargs;
     register Lisp_Object *args;
{
  int             rc;
  struct wnn_param	param;
  int	snum;
  for (rc = 0; rc < 17; rc++) CHECK_NUMBER(args[rc], rc);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  param.n = XINT(args[0]);
  param.nsho = XINT(args[1]);
  param.p1 = XINT(args[2]);
  param.p2 = XINT(args[3]);
  param.p3 = XINT(args[4]);
  param.p4 = XINT(args[5]);
  param.p5 = XINT(args[6]);
  param.p6 = XINT(args[7]);
  param.p7 = XINT(args[8]);
  param.p8 = XINT(args[9]);
  param.p9 = XINT(args[10]);
  param.p10 = XINT(args[11]);
  param.p11 = XINT(args[12]);
  param.p12 = XINT(args[13]);
  param.p13 = XINT(args[14]);
  param.p14 = XINT(args[15]);
  param.p15 = XINT(args[16]);
  
  rc = jl_param_set(wnnfns_buf[snum], &param);
  if(rc < 0) return Qnil;
  return Qt;
}

DEFUN ("wnn-server-get-msg", Fwnn_get_msg, Swnn_get_msg, 0, 0, 0,
       "Get message string from wnn_perror.")
     ()
{
  char mbuf[256];
  char 			*msgp;
  int			snum;
  unsigned char		lc;
  char  langname[32];
/*  CHECK_NUMBER(errno, 0);*/
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  switch (snum) {
  case WNNSERVER_J:
    strcpy(langname, "ja_JP");
    break;
  case WNNSERVER_C:
    strcpy(langname, "zh_CN");
    break;
/*
  case WNNSERVER_T:
    strcpy(langname, "zh_TW");
    break;
*/
  case WNNSERVER_K:
    strcpy(langname, "ko_KR");
    break;
  }
  if(!wnnfns_buf[snum]) return Qnil;
/*  msgp = msg_get(wnn_msg_cat, XINT(errno), 0, 0);*/
  msgp = wnn_perror_lang(langname);
  c2m(msgp, mbuf, lc);
  return make_string(mbuf, strlen(mbuf));
}


DEFUN ("wnn-server-fuzokugo-set", Fwnn_fuzokugo_set, Swnn_fuzokugo_set,
       1, 1, 0, "For Wnn.")
     (file)
     register Lisp_Object file;
{
  int	snum;
  CHECK_STRING(file, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_fuzokugo_set(wnnfns_buf[snum], XSTRING(file)->data) < 0)
    return Qnil;
  return Qt;
}

DEFUN ("wnn-server-fuzokugo-get", Fwnn_fuzokugo_get, Swnn_fuzokugo_get,
       0, 0, 0, "For Wnn.")
     ()
{
  char	fname[256];
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_fuzokugo_get(wnnfns_buf[snum], fname) < 0) return Qnil;
  return make_string(fname, strlen(fname));
}


DEFUN ("wnn-server-isconnect", Fwnn_isconnect, Swnn_isconnect, 0, 0, 0,
       "For Wnn.")
     ()
{
  int	snum;
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if(jl_isconnect(wnnfns_buf[snum])) return Qt;
  else return Qnil;
}

DEFUN ("wnn-server-hinsi-dicts", Fwnn_hinsi_dicts, Swnn_hinsi_dicts, 1, 1, 0,
       "For Wnn.")
     (hinsi)
     register Lisp_Object hinsi;
{
  int		*area;
  int		cnt;
  Lisp_Object	val;
  int	snum;
  CHECK_NUMBER(hinsi, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  if((cnt = jl_hinsi_dicts(wnnfns_buf[snum], XINT(hinsi), &area)) < 0)
    return Qnil;
  val = Qnil;
  for (area += cnt; cnt > 0; cnt--) {
    area--;
    val = Fcons(make_number(*area), val);
  }
  return val;
}

DEFUN ("wnn-server-hinsi-list", Fwnn_hinsi_list, Swnn_hinsi_list, 2, 2, 0,
       "For Wnn.")
     (dicno, name)
     register Lisp_Object dicno, name;
{
  int		cnt;
  Lisp_Object	val;
  w_char		wbuf[256];
  w_char		**area;
  unsigned char	cbuf[512];
  int		snum;
  unsigned char lc;
  CHECK_NUMBER(dicno, 0);
  CHECK_STRING(name, 1);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  m2w(XSTRING(name)->data, wbuf);
  if((cnt = jl_hinsi_list(wnnfns_buf[snum], XINT(dicno), wbuf, &area)) < 0)
    return Qnil;
  if (cnt == 0) return make_number(0);
  val = Qnil;
  for (area += cnt; cnt > 0; cnt--) {
    area--;
    w2m(*area, cbuf, lc);
    val = Fcons(make_string(cbuf, strlen(cbuf)), val);
  }
  return val;
}

DEFUN ("wnn-server-hinsi-name", Fwnn_hinsi_name, Swnn_hinsi_name, 1, 1, 0,
       "For Wnn.")
     (no)
     register Lisp_Object no;
{
  unsigned char	name[256];
  w_char		*wname;
  int			snum;
  unsigned char		lc;
  CHECK_NUMBER(no, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  lc = lc_wnn_server_type[snum];
  if(!wnnfns_buf[snum]) return Qnil;
  if((wname = jl_hinsi_name(wnnfns_buf[snum], XINT(no))) == 0) return Qnil;
  w2m(wname, name, lc);
  return make_string(name, strlen(name));
}

DEFUN ("wnn-server-hinsi-number", Fwnn_hinsi_number, Swnn_hinsi_number,
       1, 1, 0,
       "For Wnn.")
     (name)
     register Lisp_Object name;
{
  w_char		w_buf[256];
  int		no;
  int	snum;
  CHECK_STRING(name, 0);
  if ((snum = check_wnn_server_type()) == -1) return Qnil;
  if(!wnnfns_buf[snum]) return Qnil;
  m2w(XSTRING(name)->data, w_buf);
  if((no = jl_hinsi_number(wnnfns_buf[snum], w_buf)) < 0) return Qnil;
  return make_number(no);
}

syms_of_wnn()
{
  int i;

  defsubr(&Swnn_open);
  defsubr(&Swnn_close);
  defsubr(&Swnn_dict_add);
  defsubr(&Swnn_dict_delete);
  defsubr(&Swnn_dict_list);
  defsubr(&Swnn_dict_comment);
  defsubr(&Swnn_set_rev);
  defsubr(&Swnn_begin_henkan);
  defsubr(&Swnn_zenkouho);
  defsubr(&Swnn_get_zenkouho);
  defsubr(&Swnn_zenkouho_bun);
  defsubr(&Swnn_zenkouho_suu);
  defsubr(&Swnn_dai_top);
  defsubr(&Swnn_dai_end);
  defsubr(&Swnn_kakutei);
  defsubr(&Swnn_bunsetu_henkou);
  defsubr(&Swnn_inspect);
  defsubr(&Swnn_quit_henkan);
  defsubr(&Swnn_bunsetu_kanji);
  defsubr(&Swnn_bunsetu_yomi);
  defsubr(&Swnn_bunsetu_suu);
  defsubr(&Swnn_hindo_update);
  defsubr(&Swnn_word_toroku);
  defsubr(&Swnn_word_sakujo);
  defsubr(&Swnn_word_use);
  defsubr(&Swnn_word_info);
  defsubr(&Swnn_hindo_set);
  defsubr(&Swnn_dict_search);
  defsubr(&Swnn_dict_save);
  defsubr(&Swnn_get_param);
  defsubr(&Swnn_set_param);
  defsubr(&Swnn_get_msg);
  defsubr(&Swnn_fuzokugo_set);
  defsubr(&Swnn_fuzokugo_get);
  defsubr(&Swnn_isconnect);
  defsubr(&Swnn_hinsi_dicts);
  defsubr(&Swnn_hinsi_list);
  defsubr(&Swnn_hinsi_name);
  defsubr(&Swnn_hinsi_number);

  DEFVAR_INT ("lc-sisheng", &lc_sisheng, "Leading character for Sisheng.");
  DEFVAR_LISP ("wnn-server-type", &Vwnn_server_type, "*jserver, cserver ..");
  DEFVAR_LISP ("cwnn-zhuyin", &Vcwnn_zhuyin, "*pinyin or zhuyin");
  DEFVAR_LISP ("wnnenv-sticky", &Vwnnenv_sticky,
	       "*If non-nil, make environment sticky");
  DEFVAR_LISP ("wnn-uniq-level", &Vwnn_uniq_level, "*Uniq level");

  Qjserver = intern("jserver");
  Qcserver = intern("cserver");
  /* Qtserver = intern("tserver"); */
  Qkserver = intern("kserver");

  Qwnn_no_uniq = intern("wnn-no-uniq");
  Qwnn_uniq = intern("wnn-uniq");
  Qwnn_uniq_kanji = intern("wnn-uniq-kanji");

  Vwnn_server_type = Qjserver;
  Vcwnn_zhuyin = Qnil;
  Vwnnenv_sticky = Qnil;

  Vwnn_uniq_level = Qwnn_uniq;

  for (i = 0; i < NSERVER; i++) {
    wnnfns_buf[i] = (struct wnn_buf *)0;
    wnnfns_env_norm[i] = (struct wnn_env *)0;
    wnnfns_env_rev[i] = (struct wnn_env *)0;
  }
}

w2m(wp, mp, lc)
     w_char		*wp;
     unsigned char	*mp;
     unsigned char	lc;
{
  w_char	wc;
  w_char	pzy[10];
  int		i, len;

  while(wc = *wp++) {
    switch (wc & 0x8080) {
    case 0x80:
      if (Vwnn_server_type == Qcserver) {
	len = cwnn_yincod_pzy(pzy, wc,
			      (Vcwnn_zhuyin == Qnil)
			      ? CWNN_PINYIN
			      : CWNN_ZHUYIN);
	for(i = 0; i < len; i++) {
	  if (pzy[i] & 0x80) {
	    *mp++ = LCPRV11;
	    *mp++ = lc_sisheng;
	  }
	  *mp++ = pzy[i];
	}
      }
      else {
	*mp++ = LCKANA;
	*mp++ = (wc & 0xff);
      }
      break;
    case 0x8080:
      *mp++ = lc;
      *mp++ = (wc & 0xff00) >> 8;
      *mp++ = wc & 0x00ff;
      break;
    case 0x8000:
      if (lc == LCJP)
	*mp++ = LCJP2;
      else if (lc == LCBIG5_1)
	*mp++ = LCBIG5_2;
      else
	*mp++ = lc;
      *mp++ = (wc & 0xff00) >> 8;
      *mp++ = wc & 0x00ff | 0x80;
      break;
    default:
      *mp++ = wc & 0x00ff;
      break;
    }
  }
  *mp = 0;
}

m2w(mp, wp)
     unsigned char	*mp;
     w_char		*wp;
{
  unsigned int ch;
  
  while (ch = *mp++) {
    if (ASCII_P (ch)) {
      *wp++ = ch;
    } else if (LC_P (ch)) {
      switch (ch) {
      case LCKANA: *wp++ = *mp++; break;
      case LCROMAN: *wp++ = *mp++ & 0x7F; break;
      case LCJPOLD: case LCCN: case LCJP: case LCKR:
      /* case LCTW: */
	ch = *mp++;
	*wp++ = (ch << 8) | *mp++;
	break;
      case LCJP2:
	ch = *mp++;
	*wp++ = (ch << 8) | (*mp++ & 0x7f);
	break;
      case LCPRV11:
	ch = *mp++;
	if (ch == lc_sisheng)
	  *wp++ = 0x8e80 | *mp++;
	else
	  mp++;
	break;
      default:			/* ignore this character */
	mp += char_bytes[ch] - 1;
      }
    }
  }
  *wp = 0;
}

_xp(x)
int x;
{
    printf("%x\n", x); fflush(stdout);
}

/* static void */
w2y(w)
w_char *w;
{
  unsigned long		pbuf[5000], ybuf[5000];
  unsigned long		*pin;
  w_char *y;
  int len;

  pin = pbuf;
  y = w;
  while (1) {
	if (*w == 0) {*pin =0; break;}
	else	       *pin = *w;
	w++; pin++;
  }
  len = cwnn_pzy_yincod(ybuf, pbuf,
			(Vcwnn_zhuyin == Qnil) ? CWNN_PINYIN : CWNN_ZHUYIN);
  if (len <= 0)
	return;

  pin = ybuf;
  while (1) {
      if (*pin == 0 || len == 0) {*y = 0;break;}
      *y = *pin;
      y++; pin++; len--;
  }
}

c2m(cp, mp, lc)
     unsigned char	*cp;
     unsigned char	*mp;
     unsigned char	lc;
{
  unsigned char		ch;
  while(ch = *cp) {
    if(ch & 0x80) {
      *mp++ = lc;
      *mp++ = *cp++;
    }
    *mp++ = *cp++;
  }
  *mp = 0;
}

int
dai_end(no, server)
     int	no;
     int	server;
{
  for(no++; no < jl_bun_suu(wnnfns_buf[server])
      && !jl_dai_top(wnnfns_buf[server], no); no++);
  return (no);
}

static int
yes_or_no(s)
unsigned char *s;
{
  extern Lisp_Object	Fy_or_n_p();
  unsigned char		mbuf[512];
  unsigned char		lc;
  int			len;
  int			snum;
  if ((snum  = check_wnn_server_type()) == -1) return 0;
  lc = lc_wnn_server_type[snum];
  /* if no message found, create file without query */
/*  if (wnn_msg_cat->msg_bd == 0) return 1;*/
  if (*s == 0) return 1;
  c2m(s, mbuf, lc);
  /* truncate "(Y/N)" */
  for (len = 0; (mbuf[len]) && (len < 512); len++);
  for (; (mbuf[len] != '(') && (len > 0); len--);
  if (Fy_or_n_p(make_string(mbuf, len)) == Qnil) return 0;
  else return (1);
}

static void
puts2(s)
char *s;
{
  Lisp_Object		args[1];
  char			mbuf[512];
  unsigned char		lc;
  int			snum;
  if ((snum = check_wnn_server_type()) == -1) return;
  lc = lc_wnn_server_type[snum];
  c2m(s, mbuf, lc);
  args[0] = make_string(mbuf, strlen(mbuf));
  Fmessage(1, args);
}

int
check_wnn_server_type()
{
  if (Vwnn_server_type == Qjserver) {
    return WNNSERVER_J;
  }
  else if (Vwnn_server_type == Qcserver) {
    return WNNSERVER_C;
  }
  /* else if (Vwnn_server_type == Qtserver) {
    return WNNSERVER_T;
  } */
  else if (Vwnn_server_type == Qkserver) {
    return WNNSERVER_K;
  }
  else return -1;
}
