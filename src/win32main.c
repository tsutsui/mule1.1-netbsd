/* Startup routines for Win32 API (MS Windows NT and Windows 3.1)

   This file describes the parameters that s- files should define or not.
   Copyright (C) 1985, 1986 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY.  No author or distributor
accepts responsibility to anyone for the consequences of using it
or for whether it serves any particular purpose or works at all,
unless he says so in writing.  Refer to the GNU Emacs General Public
License for full details.

Everyone is granted permission to copy, modify and redistribute
GNU Emacs, but only under the conditions described in the
GNU Emacs General Public License.   A copy of this license is
supposed to have been given to you along with GNU Emacs so you
can know your rights and responsibilities.  It should be in a
file named COPYING.  Among other things, the copyright notice
and this notice must be preserved on all copies.  */

/* 93.6.1  written by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */

#include "config.h"

#include <windows.h>
#include <assert.h>
#ifdef USE_IME
#include <winnls32.h>
#include <ime.h>
#endif
#include <dde.h>

#ifdef WIN32S
#include <errno.h>
int errno;
#endif

HWND hwndMain;
DWORD main_thread;
HANDLE hStdin, hStdout, hStderr;

#ifdef HAVE_THREAD
EmacsMain (lpszCmdLine)
  LPSTR lpszCmdLine;
{
  int argc = 1;
  char *argv[1] = { "mule", };
  char *envp[1] = { "", };

  return main (argc, argv, envp);
}  
#endif /* HAVE_THREAD */

int APIENTRY
WinMain (hInstance, hPrevInstance, lpszCmdLine, nCmdShow)
    HINSTANCE hInstance;
    HINSTANCE hPrevInstance;
    LPSTR lpszCmdLine;
    int nCmdShow;
{
  if (!hPrevInstance) {
      if (!InitApplication (hInstance))
          return FALSE;
  }

  if (!InitInstance (hInstance, nCmdShow)) {
      return FALSE;
  }

#ifdef HAVE_THREAD
  /* Create main thread.  */
  {
    HANDLE hthreadMain;
    MSG msg;

    {
      SECURITY_ATTRIBUTES sa;
      
      sa.nLength = sizeof (SECURITY_ATTRIBUTES);
      sa.bInheritHandle = TRUE;
      sa.lpSecurityDescriptor = 0;
    
      hthreadMain
        = CreateThread (&sa, (DWORD) 0,
                       (LPTHREAD_START_ROUTINE) EmacsMain,
                       (LPVOID) lpszCmdLine,
                       (DWORD) 0,
                       &main_thread);
#if 0
#ifdef USE_IME
      SetPriorityClass (GetCurrentProcess (), LOW_PRIORITY_CLASS);
      SetThreadPriority (hthreadMain, THREAD_PRIORITY_ABOVE_NORMAL);
#endif
#endif
    }
		     
    {
      SECURITY_ATTRIBUTES sa;
      
      sa.nLength = sizeof (SECURITY_ATTRIBUTES);
      sa.bInheritHandle = TRUE;
      sa.lpSecurityDescriptor = 0;
    }

    while (GetMessage (&msg, (HWND) hwndMain, 0, 0)) {
      TranslateMessage (&msg);
      DispatchMessage (&msg);
    }
  }
  
  return 0;
#else /* not HAVE_THREAD */
  {
    int argc = 1;
    char *argv[1] = { "mule", };
    char *envp[1] = { "", };

    return main (argc, argv, envp);
  }
#endif /* not HAVE_THREAD */
}

#ifdef USE_IME
unsigned char win32_ime_buf[1024];
unsigned char win32_keyboard_buf[1024];
unsigned char *win32_keyboard_bufsp;
unsigned char *win32_keyboard_bufp;
CRITICAL_SECTION KeyboardBufferCriticalSection;

extern HANDLE hIME;
extern DWORD wIMEOpen;
#endif /* USE_IME */

#ifdef HAVE_THREAD
LONG APIENTRY
MainWndProc(hWnd, message, wParam, lParam)
    HWND hWnd;
    UINT message;
    UINT wParam;
    LONG lParam;
{
  extern HANDLE hWaitObject[64];

  switch (message) {
#ifdef USE_IME
  case WM_CREATE:
    ImeCreate (hwndMain);
    break;
#endif

#ifdef USE_IME
  case WM_IME_REPORT:
    switch (wParam) {
    case IR_STRING:
      {
	LPTSTR lpStr;
	HANDLE hStr = (HANDLE) lParam;
	
	if (!hStr) break;
	lpStr = GlobalLock (hStr);
	if (!lpStr) break;
	
	SetEvent (hWaitObject[0]);
	EnterCriticalSection (&KeyboardBufferCriticalSection);
	{
	  unsigned char *p = lpStr;
	  while (*p) {
	    *win32_keyboard_bufp++ = *p++;
	  }
	}
	LeaveCriticalSection (&KeyboardBufferCriticalSection);
	
	GlobalUnlock (hStr);
	return TRUE;
      }
    default:
      break;
    }
    break;
#endif /* USE_IME */

  case WM_KEYDOWN:
    switch (wParam) {
    case VK_DELETE:
      PostThreadMessage (main_thread, WM_CHAR, 0177, 0);
      SetEvent (hWaitObject[0]);
      break;
    }
    break;

  case WM_CHAR:
  case WM_SYSCHAR: /* 93.5.6 by H.Igarashi */
#if 1
    if (0x8000 & GetKeyState(VK_CONTROL)) /* 93.5.6 by H.Igarashi */
      wParam &= 0x1f; /* CONTROL key */
    PostThreadMessage (main_thread, message, wParam, lParam);
    SetEvent (hWaitObject[0]);
#else
    SetEvent (hWaitObject[0]);
    EnterCriticalSection (&KeyboardBufferCriticalSection);
    *win32_keyboard_bufp++ = (unsigned char) wParam;
    LeaveCriticalSection (&KeyboardBufferCriticalSection);
#endif
    break;

  case WM_ACTIVATE:
    if (LOWORD (wParam) == WA_INACTIVE)
      UnregisterHotKey (hwndMain, GetCurrentProcessId ());
    else
      RegisterHotKey (hwndMain, GetCurrentProcessId (), MOD_CONTROL,
		      0x47 /* VK_G should be defined in winuser.h */);
    break;

  case WM_HOTKEY:
    interrupt_signal ();
  case WM_SIZE:
  case WM_PAINT:
    PostThreadMessage (main_thread, message, wParam, lParam);
    SetEvent (hWaitObject[0]);
    break;

  default:
    return DefWindowProc (hWnd, message, wParam, lParam);
  }
  return NULL;
}
#endif /* HAVE_THREAD */

BOOL
InitApplication (hInstance)
    HINSTANCE hInstance;
{
    WNDCLASS wc;

    wc.style = 0;
#ifdef HAVE_THREAD
    wc.lpfnWndProc = (WNDPROC) MainWndProc;
#else
    wc.lpfnWndProc = (WNDPROC) DefWindowProc;
#endif
    wc.cbClsExtra = 0;
    wc.cbWndExtra = 0;
    wc.hInstance = hInstance;
    wc.hIcon = LoadIcon ((HINSTANCE) NULL, IDI_APPLICATION);
    wc.hCursor = LoadCursor ((HINSTANCE) NULL, IDC_ARROW);
    wc.hbrBackground = GetStockObject (WHITE_BRUSH);
    wc.lpszMenuName = "MainMenu";
    wc.lpszClassName = "MainWndClass";

    return RegisterClass (&wc);
}
     

BOOL
InitInstance (hInstance, nCmdShow)
    HINSTANCE hInstance;
    int nCmdShow;
{
    hwndMain = CreateWindow ("MainWndClass", "GNU Emacs",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, 0,
        640, 480,
        (HWND) NULL, (HMENU) NULL, hInstance, (LPVOID) NULL);

    if (!hwndMain) return FALSE;

#ifndef WIN32S
    FreeConsole();	    
    AllocConsole ();
    ShowWindow (GetForegroundWindow (), SW_HIDE);
    {
      hStdin = GetStdHandle (STD_INPUT_HANDLE);
      hStdout = GetStdHandle (STD_OUTPUT_HANDLE);
      hStderr = GetStdHandle (STD_ERROR_HANDLE);
    }
#endif

    ShowWindow(hwndMain, nCmdShow);
    UpdateWindow(hwndMain);

    {
      extern HBRUSH hWhiteBrush, hBlackBrush;
      hWhiteBrush = CreateSolidBrush (RGB(255, 255, 255));
      hBlackBrush = CreateSolidBrush (RGB(  0,   0,   0));
    }

#ifndef WIN32S
    assert (GetCurrentProcessId () < 0xC000);
    RegisterHotKey (hwndMain, GetCurrentProcessId (), MOD_CONTROL,
                    0x47 /* VK_G should be defined in winuser.h */);
#endif

#ifdef USE_IME
    InitializeCriticalSection (&KeyboardBufferCriticalSection);
    EnterCriticalSection (&KeyboardBufferCriticalSection);
    win32_keyboard_bufp = win32_keyboard_bufsp = win32_keyboard_buf;
    LeaveCriticalSection (&KeyboardBufferCriticalSection);
#endif
    return TRUE;
}


#ifdef USE_IME
ImeCreate(hWnd)
     HWND hWnd;
{
  HDC        hDC;
  TEXTMETRIC tm;
  LPIMEPRO   lpImepro;
  
  hIME = GlobalAlloc(GHND | GMEM_SHARE, (DWORD) sizeof (IMESTRUCT));
  wIMEOpen = 0;
}

ImeMoveConvertWin (hWnd, x, y)
     HWND hWnd;
     int x, y;
{
  LPIMESTRUCT lpIme = (LPIMESTRUCT) GlobalLock (hIME);
  lpIme->fnc = IME_SETCONVERSIONWINDOW;
#if 1
  lpIme->wParam = MCW_WINDOW;
  lpIme->lParam1 = MAKELONG (x, y);
  lpIme->lParam2 = MAKELONG (x, y);
#else
  lpIme->wParam = MCW_DEFAULT;
#endif
  GlobalUnlock (hIME);
  SendIMEMessageEx (hwndMain, (LPARAM) hIME);
}
#endif /* USE_IME */
