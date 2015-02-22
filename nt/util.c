#include <windows.h>
#include <sys/param.h>

#define FILE_SYSTEM_STRING_SIZE 10 /* Should be greater than 8. */

/*
 * Convert long format filename to 8.3, if the file on FAT-FS.
 * Caution: this function operates destructive!
 */

char *
dos_truncate_filename (filename)
    char *filename;
{
  LPSTR lpszRootPathName = "?:\\";
  LPSTR lpszFileSystem[FILE_SYSTEM_STRING_SIZE];

  if (strlen (filename) < 2 ||
      (strlen (filename) >= 2 && filename[1] != ':'))
    {
      char cur_dir[MAXPATHLEN+1];
      GetCurrentDirectory (MAXPATHLEN+1, (LPTSTR) cur_dir);
      *lpszRootPathName = *cur_dir;
    }
  else
    {
      *lpszRootPathName = *filename;
    }

  if (GetVolumeInformation (lpszRootPathName, 0, 0, 0, 0, 0,
	                    lpszFileSystem, FILE_SYSTEM_STRING_SIZE)
      && !strcmp ((char *) lpszFileSystem, "FAT"))
    {
      char drive[_MAX_DRIVE], dir[_MAX_DIR];
      char fname[_MAX_FNAME], ext[_MAX_EXT];

      _splitpath (filename, drive, dir, fname, ext);
      *(fname + (strlen (fname) > 8 ? 8 : strlen (fname))) = '\0';
#if 0
      *(ext + (strlen (ext) > 3 ? 3 : strlen (ext))) = '\0';
#endif
      _makepath (filename, drive, dir, fname, ext);
    }
  
  return filename;
}
