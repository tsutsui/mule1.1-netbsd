/*      Jserver Interface for Nemacs
        Coded by Yutaka Ishikawa at ETL (yisikawa@etl.go.jp)
                 Satoru Tomura   at ETL (tomura@etl.go.jp)


   This file is part of Egg on Mule (Multilingual environment)

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
 *	1992.03.25 Make wchar_t to be defined surely by K.Handa
 *	1992.02.15 w2c, c2w ... are modified for Mule Ver.0.9.0
 *      1989.12.12 in makeBunsetsu and makeKouho, call wcstrlen2 by K.Handa
 *      1989.12.12 bitPos modified and renamed to bunpoCode
 *      1989.12.06 a bug fixed by S.T.
 *      1989.11.25 wnn-server-*evf added by S.T.
 *      1989.11.21 jserver-* are renamed to wnn-* by S.T.
 *      1988.11.17 jserver-inspect-henkan is added by S.T.
 *      1988.11.17 jserver-make-directory is added by S.T.
 *      1988.11.08 jserver-dict-save is added: save current dictionary and
 *                 frequency information of system dictionaries by S.T. 
 *      1988.11.08 jserver-open: when jserver-host-name is nil, 
 *                 it means local host by S.T.
 *	1988.07.14 Enable to add alphabetical "yomi" into a dictionary by Y.I.
 *	1988.07.14 Bug for vax is fixed by atarashi@cslv4.nec.junet.
 *	-----------------------------------------------------------------------
 *	1988.06.09
 *	1988.01.26
 *	1988.01.12
 *	-----------------------------------------------------------------------
 *
 *	Functions defined in this file are
 *	   (wnn-server-open wnn-host-name login-name)
 *		wnn-host-name: STRING or NIL
 *		login-name: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		You must call this function before using jserver.
 *	   (wnn-server-close)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		You should call this function when you stop using jserver.
 *		If you have not called it and are going to exit emacs,
 *		wnn-server-close is automatically invoked.
 *	   (wnn-server-use-dict dict-file-name hindo-file-name priority file-mode)
 *		dict-file-name: STRING
 *		hindo-file-name: STRING or NULL-STRING
 *		priority: INTEGER
 *		readonly-flag: BOOLEAN
 *		DESCRIPTION:
 *		After calling the wnn-server-open, you must assert dictionaries
 *		which you use in jserver.
 *		Dictionary files are devided into two categories:
 *		system and user. System dictionary files are read-only while
 *		user dictionary files are writable.
 *		If the dict-file-name denotes a system dictionary,
 *		hindo-file-name must be filled. If the dict-file-name denotes
 *		a user dictionary, hindo-file-name is omitted.
 *	   (wnn-server-henkan-begin henkan-string)
 *		henkan-string: STRING
 *		RETURNS: a LIST of pairs of bunsetu-kanji and bunsetu-yomi.
 *		DESCRIPTION:
 *		This function is called if you want to change Kana-string to
 *		Kanji-string. The Kana-string must be filled in henkan-string.
 *	   (wnn-server-henkan-next bunsetu-no )
 *		bunsetu-no: INTEGER
 *		RETURNS: a LIST of pairs of bunsetu-kanji and bunsetu-yomi.
 *		DESCRIPTION:
 *		return candidates for bunsetsu pointed by bunsetsu-no.
 *	   (wnn-server-henkan-kakutei bunsetsu-no kouho-no)
 *		bunsetsu-no: INTEGER
 *		kouho-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		word pointed by kouho-no is chosen for bunsetsu pointed by
 *		bunsetsu-no.
 *	   (wnn-server-bunsetu-henkou bunsetu-no bunsetu-length)
 *		bunsetu-no: INTEGER
 *		bunsetu-length: INTEGER
 *		RETURNS:
 *		DESCRIPTION:
 *		bunsetsu is changed.
 *         (wnn-bunsetu-kouho-inspect bunsetu-no kouho-no)
 *              bunsetu-no: INTEGER
 *              kouho-no: INTEGER
 *              RETURNS: a LIST of jiritugo, fuzokugo, yomi, jisho-no, serial-no.
 *	   (wnn-server-henkan-quit)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *	
 *	   (wnn-server-henkan-end &optional bunsetu-no)
 *              bunsetu-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (wnn-server-set-current-dict dict-no)
 *		dict-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (wnn-server-dict-add tango yomi bunpo-type)
 *		tamgo: STRING
 *		yoni: STRING
 *		bunpo-type: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (wnn-server-dict-delete no yomi)
 *		no: INTEGER
 *		yomi: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (wnn-server-dict-info yomi)
 *		yomi: STRING
 *		RETURNS: a LIST of dict-joho
 *		DESCRIPTION:
 *
 *	   (wnn-server-file-access file-name file-mode)
 *		file-name: STRING
 *		file-mode: INTEGER
 *		RETURNS: INTEGER
 *		DESCRIPTION:
 *
 *         (wnn-server-make-directory pathname)
 *              pathname: STRING
 *              RETURNS: BOOLEAN
 *              DESCRIPTION:
 *
 *	   (wnn-dict-satus file-name)
 *		file-name: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *         (wnn-server-dict-save)
 *              RETURNS: BOOLEAN
 *              DESCRIPTION:
 *
 */

#include "config.h"

#ifdef WNN4V3
#include "commonhd.h"
/* 92.3.25 by K.Handa */
#ifndef WCHAR_T
typedef  unsigned short wchar_t;
#define WCHAR_T
#endif
/* end of patch */
#include "jlib.h"
#else
#ifdef WNN3
#include "commonheader.h"
#endif WNN3
#endif WNN4V3

#include "lisp.h"
#include "buffer.h"
#include "window.h"
#include "mule.h"		/* 92.1.15 by K.Handa */

/*
#define	KANA_LEN		500
#define	KLIST_LEN		50
#define	KANJI_LEN		500
#define	JI_KANJI_LEN		200
#define	JI_KOUHO_ENT_LEN	100
#define	JISHO_BUF_SIZE		200
*/
#define	KANA_LEN		1000
#define	KLIST_LEN		100
#define	KANJI_LEN		1000
#define	JI_KANJI_LEN		1000
#define	JI_KOUHO_ENT_LEN	150
#define	JISHO_BUF_SIZE		400
#define	MAX_BUNSETSU_SUU	50

typedef struct J_JOHO {
        int             ent;
	wchar		j_kbuf[JI_KANJI_LEN];
 	JIKOUHO_ENT	j_ent[JI_KOUHO_ENT_LEN];
} J_JOHO;

struct bunjoho	*jd_open();
struct bunjoho	*jd_open_in();

Lisp_Object	makeBunsetsu();
Lisp_Object	makeKouho();
Lisp_Object     makeInspect();
Lisp_Object     makeInspectKp();
Lisp_Object	makeJishoJoho();

static struct bunjoho	*bjp;
static int		bunsetsuNo;
static int		wnnExist;
static J_JOHO		jj[MAX_BUNSETSU_SUU];
static wchar		kanjibuf[MAX_BUNSETSU_SUU][30];
static JIKOUHOJOHO	whereToGo;

/* Lisp Variables and Constants Definition */
Lisp_Object	Vwnn_error_code;
Lisp_Object	Qwnn_dead;
Lisp_Object	Qwnn_already_exist;
Lisp_Object	Qwnn_no_connection;
Lisp_Object	Qwnn_arguments_missmatch;
Lisp_Object	Qwnn_alloc_fail;
Lisp_Object	Qwnn_open_fail;
Lisp_Object	Qwnn_save_fail;
Lisp_Object	Qwnn_close_fail;
Lisp_Object	Qwnn_too_many_bunsetsu;
Lisp_Object	Qwnn_no_exist;
Lisp_Object	Qwnn_not_a_dict;
Lisp_Object	Qwnn_user_dict;
Lisp_Object	Qwnn_system_dict;

Lisp_Object	Qwnn_no_exist_file;

#ifdef WNN3
Lisp_Object	Qwnn_not_valid_user_dict;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_not_system_dict;
#endif WNN3

/* Lisp_Object	Qwnn_not_a_dict; */
#ifdef WNN3
Lisp_Object	Qwnn_no_spec_file;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_no_spec_hindo_file;
#endif WNN3

Lisp_Object	Qwnn_full_jisho_table;
Lisp_Object	Qwnn_bad_hindo_file;

#ifdef WNN3
Lisp_Object	Qwnn_cannot_read_file;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_overflow_global_hindo_table;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_overflow_global_jisho_table;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_cannot_write_file;
#endif WNN3

Lisp_Object	Qwnn_cannot_open_file;
Lisp_Object	Qwnn_not_use_dict_no;

#ifdef WNN3
Lisp_Object	Qwnn_not_userdict;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_cannot_change_current_dict;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_overflow_jisho_table;
#endif WNN3

Lisp_Object	Qwnn_too_many_moji;
Lisp_Object	Qwnn_overflow_wk_area;

#ifdef WNN3
Lisp_Object	Qwnn_overflow_k_area;
#endif WNN3

Lisp_Object	Qwnn_too_long_yomi;
Lisp_Object	Qwnn_too_long_kanji;

#ifdef WNN3
Lisp_Object	Qwnn_bad_yomi;
#endif WNN3

Lisp_Object	Qwnn_dict_no_yomi;

#ifdef WNN3
Lisp_Object	Qwnn_not_specified_dict;
#endif WNN3

Lisp_Object	Qwnn_cannot_registered_in_the_dict;
Lisp_Object	Qwnn_not_exist_word;

#ifdef WNN3
Lisp_Object	Qwnn_too_many_jikouho;
#endif WNN3

Lisp_Object	Qwnn_some_error;
Lisp_Object	Qwnn_have_some_bugs;

#ifdef WNN3
Lisp_Object	Qwnn_no_more_buf_area;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_minus_mojiretsu;
#endif WNN3

Lisp_Object	Qwnn_cannot_mkdir;

#ifdef WNN3
Lisp_Object	Qwnn_not_a_username;
#endif WNN3

#ifdef WNN3
Lisp_Object	Qwnn_not_a_hostname;
#endif WNN3

Lisp_Object	Qwnn_unknown_fail;

#define IS_WNN_DEAD						\
{								\
     jd_server_dead_env_flg = 1;				\
     if(setjmp(jd_server_dead_env) == 666) {/* Wnn dead */	\
	 wnnExist = 0;					\
	 Vwnn_error_code = Qwnn_dead;			\
	 return Qnil;						\
     }								\
}


/* Lisp functions definition */
DEFUN ("wnn-server-open", Fwnn_open, Swnn_open, 2, 2, 0,
	"For Wnn.")
	(register Lisp_Object hname, register Lisp_Object lname)
{
	if ( 
	    (hname != Qnil  &&  XTYPE (hname) != Lisp_String)
	    ||
	     XTYPE(lname) != Lisp_String
	    ){
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	      }
	if(wnnExist) {
		Vwnn_error_code = Qwnn_already_exist;
		return Qnil;
	}
        if (hname == Qnil) {
           if(!(bjp = jd_open_in(KANA_LEN, KLIST_LEN, KANJI_LEN,
                              "",
			      XSTRING(lname)->data, 0))) {
		errorSet();
		return Qnil;
	      }
	 } else 
	if(!(bjp = jd_open_in(KANA_LEN, KLIST_LEN, KANJI_LEN,
			      XSTRING(hname)->data, 
			      XSTRING(lname)->data, 0))) {
		errorSet();
		return Qnil;
	}
	Vwnn_error_code = Qnil;
	wnnExist = 1;
	return Qt;
}


DEFUN ("wnn-server-close", Fwnn_close, Swnn_close, 0, 0, 0,
	"For Wnn.")
	(void)
{
	int	val;

	/* Vwnn_error_code will be assigned in wnn_exit */
	if((val = wnn_exit()) < 0)
		return Qnil;
	else
		return Qt;
}

DEFUN ("wnn-server-use-dict", Fwnn_use_dict, Swnn_use_dict, 4, 4, 0,
	"For Wnn.")
	(register Lisp_Object dfname, register Lisp_Object hfname, register Lisp_Object prio, register Lisp_Object readonly)
{
	Lisp_Object	val;
	int	v, rflag;

	if (XTYPE (dfname) != Lisp_String
	    || XTYPE(hfname) != Lisp_String
	    || XTYPE(prio) != Lisp_Int) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	rflag = (readonly == Qnil)?0:1;
	if((v = jd_dicadd(XSTRING(dfname)->data,
	             XSTRING(hfname)->data, XINT(prio), rflag)) < 0) {
		errorSet();
		return Qnil;
	}
	XSETTYPE (val, Lisp_Int);
	XFASTINT (val) = v;
	Vwnn_error_code = Qnil;
	return val;
}

DEFUN ("wnn-server-henkan-begin", Fwnn_begin_henkan, Swnn_begin_henkan, 
       1, 1, 0,
	"For Wnn.")
	(register Lisp_Object hstring)
{
	register int		i;
	register KOUHO_ENT	*kp;
	register Lisp_Object val;

	if (XTYPE (hstring) != Lisp_String) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	c2w(XSTRING(hstring)->data, bjp->kana_buf);
	if((bunsetsuNo = jd_reconv(0, kanjibuf[0], KANJI_LEN)) < 0) {
		errorSet();
		return Qnil;
	}
	if(bunsetsuNo > MAX_BUNSETSU_SUU) {/* Too many bunsetsu */
		Vwnn_error_code = Qwnn_too_many_bunsetsu;
		return Qnil;
	}
	
        for(i=0; i < bunsetsuNo ; i++) jj[i].ent = -1;
	
	val = Qnil;
	for(i = bunsetsuNo, kp = &bjp->klist[bunsetsuNo - 1]; i > 0; --i, --kp) {
		val = Fcons(makeBunsetsu(kp), val);
	}
	Vwnn_error_code = Qnil;
	return val;
}

DEFUN ("wnn-server-henkan-next", Fwnn_jikouho, Swnn_jikouho, 1, 1, 0,
	"For Wnn.")
	(register Lisp_Object bunNo)
{
	Lisp_Object	val;
	JIKOUHO_ENT	*jp;
	int		no;
	int		ent;

	if( XTYPE(bunNo) != Lisp_Int  ||
	    XINT(bunNo) < 0 || bunsetsuNo <= XINT(bunNo) ) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	no = XINT(bunNo);

	if ( jj[no].ent == -1 ) {
	  whereToGo.jlist = jj[no].j_ent;
	  whereToGo.jlist_size = JI_KOUHO_ENT_LEN;
	  whereToGo.kanji_buf = jj[no].j_kbuf;
	  whereToGo.kanji_buf_size = JI_KANJI_LEN;
	  if((ent = jd_next(no, &whereToGo)) < 0) {
	    errorSet();
	    return Qnil;
	  }
	  jj[no].ent = ent; 
	} else {
	  ent = jj[no].ent ;
	}
	jp = &jj[no].j_ent[ent];
	val = Qnil;
	while(ent--) {
		val = Fcons(makeKouho(--jp, no), val);
	}
	Vwnn_error_code = Qnil;
	return val;
}

DEFUN ("wnn-server-henkan-kakutei", Fwnn_kakutei, Swnn_kakutei, 2, 2, 0,
	"For Wnn.")
	(register Lisp_Object bunNo, register Lisp_Object kouhoNo)
{
	int		bno, kno;
	Lisp_Object	val;
	JIKOUHO_ENT	*jp;
	KOUHO_ENT	*kp;

	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	bno = XINT(bunNo);
	kno = XINT(kouhoNo);
	
	if( bno < 0 || bunsetsuNo <= bno ||
	    kno < 0 || 
           ( 0 < kno && ( jj[bno].ent == -1 ||
			  jj[bno].ent <= kno ))){
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if ( jj[bno].ent != -1 ) {
	  kp = &bjp->klist[bno];
	  jp = &jj[bno].j_ent[kno];
	  kp->fl = kp->fl + kp->jl - jp->jl;
	  kp->jl = jp->jl;
	  kp->jishono = jp->jishono;
	  kp->serial = jp->serial;
	  kp->k_data = jp->k_data;
	}
	Vwnn_error_code = Qnil;
	return Qt;
}

DEFUN ("wnn-bunsetu-kouho-inspect", Fwnn_inspect_henkan, Swnn_inspect_henkan,
       2, 2, 0,
	"For Wnn.")
	(register Lisp_Object bunNo, register Lisp_Object kouhoNo)
{
        Lisp_Object     val;
	int		bno, kno;
	int             ent;
	JIKOUHO_ENT	*jp;
	KOUHO_ENT	*kp;

	if(XTYPE(bunNo) != Lisp_Int || XTYPE(kouhoNo) != Lisp_Int) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	bno = XINT(bunNo);
	kno = XINT(kouhoNo);

	if ( bno < 0 || bunsetsuNo <= bno ||
	    kno < 0 || 
           ( 0 < kno && ( jj[bno].ent == -1 ||
			  jj[bno].ent <= kno ))){
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if ( jj[bno].ent == -1 ) {
	  val = makeInspectKp(bno);
	} else {
	  jp = &jj[bno].j_ent[kno];
	  val = makeInspect(jp, bno);
	}
	Vwnn_error_code = Qnil;
	return val;
}


DEFUN ("wnn-server-bunsetu-henkou", Fwnn_bunsetu_henkou, Swnn_bunsetu_henkou,
       2, 2, 0,
	"For Wnn.")
	(register Lisp_Object bunNo, register Lisp_Object len)
{
	Lisp_Object	val;
	KOUHO_ENT	*kp;
	int		no, l, i;

	if(XTYPE(bunNo) != Lisp_Int || XTYPE(len) != Lisp_Int) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	no = XINT(bunNo);
	l = XINT(len);
	if((bunsetsuNo = jd_tanconv(no, l, kanjibuf[no], KANJI_LEN)) < 0) {
		errorSet();
		return Qnil;
	}
	bunsetsuNo += no;

	for (i = no ; i < bunsetsuNo ; i++) jj[i].ent = -1 ;

	val = Qnil;
	for(i = bunsetsuNo, kp = &bjp->klist[bunsetsuNo - 1]; i > 0; --i, --kp) {
		val = Fcons(makeBunsetsu(kp), val);
	}
	Vwnn_error_code = Qnil;
	return val;
}

DEFUN ("wnn-server-henkan-quit", Fwnn_quit_henkan, Swnn_quit_henkan, 0, 0, 0,
	"For Wnn.")
	(void)
{
	Vwnn_error_code = Qnil;
	return Qt;
}

DEFUN ("wnn-server-henkan-end", Fwnn_end_henkan, Swnn_end_henkan, 0, 1, 0,
	"For Wnn.")
	(Lisp_Object bunNo)
{
	if(XTYPE(bunNo) != Lisp_Int && bunNo != Qnil){
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}

	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

        if (bunNo != Qnil) {
	  int      bno;
	  bno = XINT (bunNo);
	  if ( 0 <= bno && bno < bunsetsuNo) {
            bjp->kana_buf[ bjp->klist[bno].s_ichi ] = 0;
	    if((jd_reconv(bno, kanjibuf[bno], KANJI_LEN)) < 0) {
	      errorSet();
	      return Qnil;
	    }
	  }
	}

	if(jd_end() < 0) {
		errorSet();
		return Qnil;
	} else {
		Vwnn_error_code = Qnil;
		return Qt;
	}
}

DEFUN ("wnn-server-set-current-dict", Fwnn_set_current_dict, Swnn_set_current_dict, 1, 1, 0,
	"For Wnn.")
	(register Lisp_Object dno)
{
	if(XTYPE(dno) != Lisp_Int) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	if(jd_udchg(XINT(dno)) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vwnn_error_code = Qnil;
		return Qt;
	}
}

DEFUN ("wnn-server-dict-add", Fwnn_dict_toroku, Swnn_dict_toroku, 3, 3, 0,
	"For Wnn.")
	(register Lisp_Object kanji, register Lisp_Object yomi, register Lisp_Object bunpo)
{
	char	*yp, *kp;
	int	ret, ysize, ksize, btype;

	if(XTYPE(kanji) != Lisp_String
	  || XTYPE(yomi) != Lisp_String
	  || XTYPE(bunpo) != Lisp_Int) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	ksize = XSTRING(kanji)->size << 1; /* multipied by 2 */
	kp = (char *) alloca(ksize + 2);
	c2w(XSTRING(kanji)->data, kp);

	ysize = XSTRING(yomi)->size << 1; /* multipied by 2 */
	yp = (char *) alloca(ysize + 2);
	c2w(XSTRING(yomi)->data, yp);

	btype = 1 << XINT(bunpo);
	if((ret = jd_wreg(kp, yp, btype)) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vwnn_error_code = Qnil;
		return Qt;
	}
}


DEFUN ("wnn-server-dict-delete", Fwnn_dict_sakujo, Swnn_dict_sakujo, 2, 2, 0,
	"For Wnn.")
	(register Lisp_Object no, register Lisp_Object yomi)
{
	int	ysize, ret;
	char	*yp;

	if(XTYPE(no) != Lisp_Int
	  || XTYPE(yomi) != Lisp_String) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	ysize = XSTRING(yomi)->size << 1; /* multipied by 2 */
	yp = (char *) alloca(ysize + 2);
	c2w(XSTRING(yomi)->data, yp);

	if((ret = jd_wdel(XINT(no), yp)) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vwnn_error_code = Qnil;
		return Qt;
	}
}


DEFUN ("wnn-server-dict-info", Fwnn_dict_joho, Swnn_dict_joho, 1, 1, 0,
	"For Wnn.")
	(register Lisp_Object yomi)
{
	JISHOJOHO	jbuf[JISHO_BUF_SIZE];
	wchar		kbuf[KANJI_LEN];
	JISHOJOHO	*jp;
	int		count, ysize;
	char		*yp;
	Lisp_Object	val;

	if(XTYPE(yomi) != Lisp_String) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	ysize = XSTRING(yomi)->size << 1; /* multipied by 2 */
	yp = (char *) alloca(ysize + 2);
	c2w(XSTRING(yomi)->data, yp);
	count = jd_wsch(yp, jbuf, JISHO_BUF_SIZE, kbuf, KANJI_LEN);
	if(count < 0) {
		errorSet();
		return Qnil;
	}
	val = Qnil;
	for(count, jp = jbuf; count > 0; --count, jp++) {
		val = Fcons(makeJishoJoho(jp), val);
	}
	Vwnn_error_code = Qnil;
	return val;
}

DEFUN ("wnn-server-getevf", Fwnn_getevf, Swnn_getevf, 0, 0, 0,	"For Wnn.")
	(void)
{
        int             p0, p1, p2, p3, p4, p5;
        int             rc;
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	rc = jd_getevf(&p0, &p1, &p2, &p3, &p4, &p5);
	if(rc < 0) {
		errorSet();
		return Qnil;
	}
	return Fcons(make_number(p0),
	       Fcons(make_number(p1),
               Fcons(make_number(p2),
	       Fcons(make_number(p3),
	       Fcons(make_number(p4),
               Fcons(make_number(p5),Qnil))))));
}

DEFUN ("wnn-server-setevf", Fwnn_setevf, Swnn_setevf, 6, MANY, 0, "For Wnn.")
      (int nargs, register Lisp_Object *args)
{
        int             rc;

	if(nargs != 6 ||
	   XTYPE(args[0]) != Lisp_Int ||
	   XTYPE(args[1]) != Lisp_Int ||
	   XTYPE(args[2]) != Lisp_Int ||
	   XTYPE(args[3]) != Lisp_Int ||
	   XTYPE(args[4]) != Lisp_Int ||
	   XTYPE(args[5]) != Lisp_Int ) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	      }

	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	rc = jd_setevf(XINT(args[0]), XINT(args[1]), XINT(args[2]),
		       XINT(args[3]), XINT(args[4]), XINT(args[5]));

	if(rc < 0) {
		errorSet();
		return Qnil;
	}
	return Qt;
}


DEFUN ("wnn-server-file-access", Fwnn_file_access, Swnn_file_access, 2, 2, 0,
	"For Wnn.")
	(register Lisp_Object fname, register Lisp_Object fmode)
{

	if(XTYPE(fname) != Lisp_String
	   || XTYPE(fmode) != Lisp_Int) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

/*
	if(jd_access(XSTRING(fname)->data, XINT(fmode)) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vwnn_error_code = Qnil;
		return Qt;
	}
*/
	Vwnn_error_code = Qnil;
	return make_number(jd_access(XSTRING(fname)->data, XINT(fmode)));

}


DEFUN ("wnn-server-make-directory", Fwnn_make_directory,
         Swnn_make_directory, 1, 1, 0,
	"For Wnn.")
	(register Lisp_Object pathname)
{

	if(XTYPE(pathname) != Lisp_String) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	if(jd_mkdir(XSTRING(pathname)->data) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vwnn_error_code = Qnil;
		return Qt;
	}
}



DEFUN ("wnn-dict-status", Fwnn_dict_satus, Swnn_dict_satus, 1, 1, 0,
	"For Wnn.")
	(register Lisp_Object fname)
{
	int	ret;

	if(XTYPE(fname) != Lisp_String) {
		Vwnn_error_code = Qwnn_arguments_missmatch;
		return Qnil;
	}
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	ret = jd_dicstatus(XSTRING(fname)->data);
	wnn_errorno = ret;
	errorSet();
	return Qt;
}

DEFUN ("wnn-server-dict-save", Fwnn_dict_save, Swnn_dict_save, 0, 0, 0,
	"For Wnn.")
	(void)
{
	if(!wnnExist) {
		Vwnn_error_code = Qwnn_no_connection;
		return Qnil;
	}

	IS_WNN_DEAD;

	if(jd_freqsv() < 0) {
		errorSet();
		return Qnil;
	} else {
		Vwnn_error_code = Qnil;
		return Qt;
	}
}

Lisp_Object
makeBunsetsu(KOUHO_ENT *kp)
{
	Lisp_Object	val1, val2;
	int		kanalen;
	wchar		*kanjip, *kanap;
	wchar		*bunp;

	/* make kanji with kana */
	kanap = bjp->kana_buf + kp->s_ichi + kp->jl;
	val1 = make_string(bjp->kana_buf,
			   wcstrlen(kp->k_data) + wcstrlen2(kanap, kp->fl));
	bunp = (wchar *) XSTRING(val1)->data;
	*bunp = 0;
	w2c(kp->k_data, bunp, 0);
	if(kp->fl) {
		w2c(kanap, bunp, kp->fl);
	}

	/* make kana */
	kanalen = wcstrlen2(bjp->kana_buf + kp->s_ichi, kp->jl + kp->fl);
	val2 = make_string(bjp->kana_buf, kanalen);
	bunp = (wchar *) XSTRING(val2)->data;
	*bunp = 0;
	w2c(bjp->kana_buf + kp->s_ichi, bunp, kp->jl + kp->fl);
	return Fcons(val1, val2);
}

Lisp_Object
makeKouho(JIKOUHO_ENT *jp, int no)
{
	Lisp_Object	val;
	int		fl;
	KOUHO_ENT	*kp;
	wchar		*kanap, *bunp;

	kp = &bjp->klist[no];
	fl = kp->fl + kp->jl - jp->jl;
	kanap = bjp->kana_buf + kp->s_ichi + jp->jl;
	val = make_string(bjp->kana_buf,
			  wcstrlen(jp->k_data) + wcstrlen2(kanap, fl));
	bunp = (wchar *) XSTRING(val)->data;
	*bunp = 0;
	w2c(jp->k_data, bunp, 0);
	if(fl) {
		w2c(kanap, bunp, fl);
	};
	return val;
}      


Lisp_Object
makeInspect(JIKOUHO_ENT *jp, int no)
{
	int		fl;
	KOUHO_ENT	*kp;
	wchar		*kanap, *bunp;
        Lisp_Object     jishono, serial;
        Lisp_Object     kanji,kana,fuzoku;
	int             kanalen;
	kp = &bjp->klist[no];
	fl = kp->fl + kp->jl - jp->jl;
	kanji = make_string(jp->k_data, wcstrlen(jp->k_data));
	bunp = (wchar *) XSTRING(kanji)->data;
	*bunp = 0;
	w2c(jp->k_data, bunp, 0);

	kanalen = wcstrlen2(bjp->kana_buf + kp->s_ichi, jp->jl);
	kana = make_string(bjp->kana_buf, kanalen);
	bunp = (wchar *) XSTRING(kana)->data;
	*bunp = 0;
	if(jp->jl){
		kanap = bjp->kana_buf + kp->s_ichi;
		w2c(kanap, bunp, jp->jl);
	      }

	kanalen = wcstrlen2(bjp->kana_buf + kp->s_ichi + jp->jl, fl);
	fuzoku = make_string(bjp->kana_buf, kanalen);
	bunp = (wchar *) XSTRING(fuzoku)->data;
	*bunp = 0;
	if(fl){
	        kanap = bjp->kana_buf + kp->s_ichi + jp->jl;
		w2c(kanap, bunp, fl);
	      }

	XSET (jishono, Lisp_Int, jp->jishono);
	XSET (serial,  Lisp_Int, jp->serial);
	return Fcons (kanji, Fcons (fuzoku , Fcons (kana, 
		       Fcons (jishono, Fcons ( serial, Qnil)))));
}

Lisp_Object
makeInspectKp (int bno)
{
        KOUHO_ENT	*kp;
	int		kanalen;
	wchar		*kanjip, *kanap;
	wchar		*bunp;
	Lisp_Object     kanji, kana, fuzoku;
	Lisp_Object     jishono, serial;

	kp = &bjp->klist[bno];
	kanji = make_string(kp->k_data, wcstrlen(kp->k_data));
	bunp = (wchar *) XSTRING(kanji)->data;
	*bunp = 0;
	w2c(kp->k_data, bunp, 0);

	kanalen = wcstrlen2(bjp->kana_buf + kp->s_ichi, kp->jl );
	kana = make_string(bjp->kana_buf, kanalen);
	bunp = (wchar *) XSTRING(kana)->data;
	*bunp = 0;
	if(kp->jl){
		kanap = bjp->kana_buf + kp->s_ichi;
		w2c(kanap, bunp, kp->jl);
	      }

	kanalen = wcstrlen2(bjp->kana_buf + kp->s_ichi + kp->jl, kp->fl);
	fuzoku = make_string(bjp->kana_buf, kanalen);
	bunp = (wchar *) XSTRING(fuzoku)->data;
	*bunp = 0;
	if(kp->fl){
	        kanap = bjp->kana_buf + kp->s_ichi + kp->jl;
		w2c(kanap, bunp, kp->fl);
	      }

	  XSET (jishono, Lisp_Int, kp->jishono);
	  XSET (serial,  Lisp_Int, kp->serial);
	  return Fcons (kanji,Fcons (fuzoku, Fcons (kana, 
		       Fcons (jishono, Fcons (serial, Qnil)))));
}


Lisp_Object
makeJishoJoho(JISHOJOHO *jp)
{
	char		*cp;
	Lisp_Object	str, bumpo, hindo, jisho, serial, val;

	cp = (char *) alloca(wcstrlen(jp->k_data) + 1);
	*cp = 0;
	w2c(jp->k_data, cp, 0);
	str = make_string(cp, strlen(cp));
	XFASTINT(bumpo) = bunpoCode(jp->bumpo);
	XFASTINT(hindo) = jp->hindo;
	XFASTINT(jisho) = jp->jisho;
	XFASTINT(serial) = jp->serial;
	val = Fcons(serial, Qnil);
	val = Fcons(jisho, val);
	val = Fcons(hindo, val);
	val = Fcons(bumpo, val);
	val = Fcons(str, val);
	return val;
}

int
wnn_exit (void)
{
	int	ret1, ret2;

	IS_WNN_DEAD;

	if(wnnExist) {
		Vwnn_error_code = Qnil;
		if((ret1 = jd_freqsv()) < 0)
			errorSet();
		if((ret2 = jd_close()) < 0)
			errorSet();
		wnnExist = 0;
		return ret1|ret2;
	} else {
		Vwnn_error_code = Qwnn_no_connection;
	}
	return -2;
}

void
syms_of_wnn (void)
{
	defsubr(&Swnn_open);
	defsubr(&Swnn_close);
	defsubr(&Swnn_use_dict);
	defsubr(&Swnn_begin_henkan);
	defsubr(&Swnn_jikouho);
	defsubr(&Swnn_kakutei);
	defsubr(&Swnn_inspect_henkan);
	defsubr(&Swnn_bunsetu_henkou);
	defsubr(&Swnn_quit_henkan);
	defsubr(&Swnn_end_henkan);
	defsubr(&Swnn_set_current_dict);
	defsubr(&Swnn_dict_toroku);
	defsubr(&Swnn_dict_sakujo);
	defsubr(&Swnn_dict_joho);
	defsubr(&Swnn_file_access);
        defsubr(&Swnn_getevf);
	defsubr(&Swnn_setevf);
        defsubr(&Swnn_make_directory);
	defsubr(&Swnn_dict_satus);
        defsubr(&Swnn_dict_save);

	DEFVAR_LISP ("wnn-error-code", &Vwnn_error_code, "For wnn");
	Vwnn_error_code = Qnil;

	Qwnn_dead = intern (":wnn-dead");
	Qwnn_already_exist = intern (":already-exist");
	Qwnn_no_connection = intern (":wnn-no-connection");
	Qwnn_arguments_missmatch = intern(":arguments-missmatch");
	Qwnn_alloc_fail = intern(":alloc-fail");
	Qwnn_open_fail = intern(":open-fail");
	Qwnn_save_fail = intern(":save-fail");
	Qwnn_close_fail = intern(":close-fail");
	Qwnn_too_many_bunsetsu = intern(":too-many-bunsetsu");
	Qwnn_no_exist = intern(":no-exist");
	Qwnn_not_a_dict = intern(":not-a-dict");
	Qwnn_user_dict = intern(":user-dict");
	Qwnn_system_dict = intern(":system-dict");

	Qwnn_no_exist_file = intern(":no-exist-file");

#ifdef WNN3
	Qwnn_not_valid_user_dict = intern(":not-valid-user-dict");
#endif WNN3

#ifdef WNN3
	Qwnn_not_system_dict = intern(":not-system-dict");
#endif WNN3

/*	Qwnn_not_a_dict = intern(":not-a-dict"); */
#ifdef WNN3
	Qwnn_no_spec_file = intern(":no-spec-file");
#endif WNN3

#ifdef WNN3
	Qwnn_no_spec_hindo_file = intern(":no-spec-hindo-file");
#endif WNN3

	Qwnn_full_jisho_table = intern(":full-jisho-table");
	Qwnn_bad_hindo_file = intern(":bad-hindo-file");
#ifdef WNN3
	Qwnn_cannot_read_file = intern(":cannot-read-file");
#endif WNN3

#ifdef WNN3
	Qwnn_overflow_global_hindo_table = intern(":overflow-global-hindo-table");
#endif WNN3

#ifdef WNN3
	Qwnn_overflow_global_jisho_table = intern(":overflow-global-jisho-table");
#endif WNN3

#ifdef WNN3
	Qwnn_cannot_write_file = intern(":cannot-write-file");
#endif WNN3

	Qwnn_cannot_open_file = intern(":cannot-open-file");
	Qwnn_not_use_dict_no = intern(":not-use-dict-no");

#ifdef WNN3
	Qwnn_not_userdict = intern(":not-userdict");
#endif WNN3

#ifdef WNN3
	Qwnn_cannot_change_current_dict = intern(":cannot-change-current-dict");
#endif WNN3

#ifdef WNN3
	Qwnn_overflow_jisho_table = intern(":overflow-jisho-table");
#endif WNN3

	Qwnn_too_many_moji = intern(":too-many-moji");
	Qwnn_overflow_wk_area = intern(":overflow-wk-area");

#ifdef WNN3
	Qwnn_overflow_k_area = intern(":overflow-k-area");
#endif WNN3

	Qwnn_too_long_yomi = intern(":too-long-yomi");
	Qwnn_too_long_kanji = intern(":too-long-kanji");

#ifdef WNN3
	Qwnn_bad_yomi = intern(":bad-yomi");
#endif WNN3

	Qwnn_dict_no_yomi = intern(":dict-no-yomi");

#ifdef WNN3
	Qwnn_not_specified_dict = intern(":not-specified-dict");
#endif WNN3

	Qwnn_cannot_registered_in_the_dict = intern(":cannot-registered-in-the-dict");
	Qwnn_not_exist_word = intern(":not-exist-word");

#ifdef WNN3
	Qwnn_too_many_jikouho = intern(":too-many-jikouho");
#endif WNN3

	Qwnn_some_error = intern(":some-error");
	Qwnn_have_some_bugs = intern(":have-some-bugs");

#ifdef WNN3
	Qwnn_no_more_buf_area = intern(":no-more-buf-area");
#endif WNN3

#ifdef WNN3
	Qwnn_minus_mojiretsu = intern(":minus-mojiretsu");
#endif WNN3

	Qwnn_cannot_mkdir = intern(":cannot-mkdir");

#ifdef WNN3
	Qwnn_not_a_username = intern(":not-a-username");
#endif WNN3

#ifdef WNN3
	Qwnn_not_a_hostname = intern(":not-a-hostname");
#endif WNN3

	Qwnn_unknown_fail = intern(":unknown-fail");
}

void
w2c (wchar *wp, char *cp, int len /* length of go */)
{
	wchar	wc;

	while(*cp) cp++;
	while(wc = *wp++) {
		if(wc & 0x8000) { /* 92.1.15 by K.Handa */
			*cp++ = LCJP;
			*cp++ = (wc & 0xff00) >> 8;
		}
		*cp++ = wc & 0x00ff;
		if(len && --len == 0)
			break;
	}
	*cp = 0;
}

int
wcstrlen(wchar *wp)
{
	wchar	wc;
	int	len = 0;

	while(wc = *wp++) {
		if(wc & 0x8000)
			len += 3; /* 92.1.15 by K.Handa */
		else
			len++;
	}
	return len;
}

int
wcstrlen2(wchar *wp, int wsize /* wchar size */)
{
	wchar	wc;
	int	len = 0;

	if(!wsize) return 0;
	while(wsize--) {
		if(*wp++ & 0x8000)
			len += 3; /* 92.1.15 by K.Handa */
		else
			len++;
	}
	return len;
}

void
c2w(unsigned char *cp, wchar *wp)
{
	unsigned char	ch;

	while(ch = *cp++) {
		if(ch & 0x80) {
			ch = *cp++; /* 92.1.15 by K.Handa */
			*wp++ = (((wchar) ch) << 8) | *cp++;
		} else {
/*
			*wp++ = (((wchar) ch) << 8) | ch;
*/
			*wp++ = (wchar) ch;
		}
	}
	*wp = 0;
}

/* Return bit position as bunpo code index:
for unknown value, return 1000; 89-Dec-12 */
int
bunpoCode (int val)
{
	int	ret = 0;

	if(val <= 0) return 1000; 
	while((val & 1)==0) {
		ret++;
		val >>= 1;
	}
	if ((val>>1)==0) return ret;
	else return 1000;
}

int
errorSet (void)
{
	switch(wnn_errorno) {
	case WNN_NO_EXIST:
		Vwnn_error_code = Qwnn_no_exist_file;
		break;

#ifdef WNN3
	case WNN_NOT_USERDICT:
		Vwnn_error_code = Qwnn_not_valid_user_dict;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_NOT_SYSTEM:
		Vwnn_error_code = Qwnn_not_system_dict;
		break;
#endif WNN3

	case WNN_NOT_A_DICT:
		Vwnn_error_code = Qwnn_not_a_dict;
		break;

#ifdef WNN3
	case WNN_FILE_NO_SPECIFIED:
		Vwnn_error_code = Qwnn_no_spec_file;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_HINDO_FILE_NOT_SPECIFIED:
		Vwnn_error_code = Qwnn_no_spec_hindo_file;
		break;
#endif WNN3

	case WNN_JISHOTABLE_FULL:
		Vwnn_error_code = Qwnn_full_jisho_table;
		break;
	case WNN_HINDO_NO_MATCH:
		Vwnn_error_code = Qwnn_bad_hindo_file;
		break;

#ifdef WNN3
	case WNN_PARAMR:
		Vwnn_error_code = Qwnn_cannot_read_file;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_HJT_FULL:
		Vwnn_error_code = Qwnn_overflow_global_hindo_table;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_JT_FULL:
		Vwnn_error_code = Qwnn_overflow_global_jisho_table;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_PARAMW:
		Vwnn_error_code = Qwnn_cannot_write_file;
		break;
#endif WNN3

	case WNN_OPENF_ERR:
		Vwnn_error_code = Qwnn_cannot_open_file;
		break;
	case WNN_DICT_NOT_USED:
		Vwnn_error_code = Qwnn_not_use_dict_no;
		break;

#ifdef WNN3
	case WNN_NOT_A_USERDICT:
		Vwnn_error_code = Qwnn_not_userdict;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_READONLY:
		Vwnn_error_code = Qwnn_cannot_change_current_dict;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_JMT_FULL:
		Vwnn_error_code = Qwnn_overflow_jisho_table;
		break;
#endif WNN3

	case WNN_LONG_MOJIRETSU:
		Vwnn_error_code = Qwnn_too_many_moji;
		break;
	case WNN_WKAREA_FULL:
		Vwnn_error_code = Qwnn_overflow_wk_area;
		break;

#ifdef WNN3
	case WNN_KAREA_FULL:
		Vwnn_error_code = Qwnn_overflow_k_area;
		break;
#endif WNN3

	case WNN_YOMI_LONG:
		Vwnn_error_code = Qwnn_too_long_yomi;
		break;
	case WNN_KANJI_LONG:
		Vwnn_error_code = Qwnn_too_long_kanji;
		break;

#ifdef WNN3
	case WNN_BAD_YOMI:
		Vwnn_error_code = Qwnn_bad_yomi;
		break;
#endif WNN3

	case WNN_NO_YOMI:
		Vwnn_error_code = Qwnn_dict_no_yomi;
		break;

#ifdef WNN3
	case WNN_NO_CURRENT:
		Vwnn_error_code = Qwnn_not_specified_dict;
		break;
#endif WNN3

	case WNN_RDONLY:
		Vwnn_error_code = Qwnn_cannot_registered_in_the_dict;
		break;
	case WNN_WORD_NO_EXIST:
		Vwnn_error_code = Qwnn_not_exist_word;
		break;

#ifdef WNN3
	case WNN_JIKOUHO_TOO_MANY:
		Vwnn_error_code = Qwnn_too_many_jikouho;
		break;
#endif WNN3

	case WNN_SOME_ERROR:
		Vwnn_error_code = Qwnn_some_error;
		break;
	case WNN_SONOTA:
		Vwnn_error_code = Qwnn_have_some_bugs;
		break;

#ifdef WNN3
	case WNN_JSERVER_DEAD:
		Vwnn_error_code = Qwnn_dead;
		break;
#endif WNN3

	case WNN_ALLOC_FAIL:
	case WNN_MALLOC_INITIALIZE:
	case WNN_MALLOC_ERR:
		Vwnn_error_code = Qwnn_alloc_fail;
		break;
	case WNN_SOCK_OPEN_FAIL:
		Vwnn_error_code = Qwnn_open_fail;
		break;

#ifdef WNN3
	case WNN_RCV_SPACE_OVER:
		Vwnn_error_code = Qwnn_no_more_buf_area;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_MINUS_MOJIRETSU:
		Vwnn_error_code = Qwnn_minus_mojiretsu;
		break;
#endif WNN3

	case WNN_MKDIR_FAIL:
		Vwnn_error_code = Qwnn_cannot_mkdir;
		break;

#ifdef WNN3
	case WNN_BAD_USER:
		Vwnn_error_code = Qwnn_not_a_username;
		break;
#endif WNN3

#ifdef WNN3
	case WNN_BAD_HOST:
		Vwnn_error_code = Qwnn_not_a_hostname;
		break;
#endif WNN3

	default:
/*		Vwnn_error_code = Qwnn_unknown_fail; */
		Vwnn_error_code = make_number( wnn_errorno);
	}
}
