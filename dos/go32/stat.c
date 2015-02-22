/* DJGCC's stat () can't get the status of root directory. */
/* We can't redefine stat () to sys_stat () because structure named stat
   is declared in <sys/stat.h>. So we must rewite stat () to sys_stat ()
   in all file it appears. */

#include <sys/stat.h>

int
stat (name, buf)
     const char *name;
     struct stat *buf;
{
  if (strcmp (name, "/") && strcmp (name + 1, ":/"))
    {
      int len = strlen (name);
      char *tmp = (char *) alloca (len + 1);

      strcpy (tmp, name);
      if (tmp[len - 1] == '/') tmp[len - 1] = 0;
      return _stat (tmp, buf);
    }
  else
    {
      buf->st_rdev = buf->st_ino = 0;
      buf->st_dev = 0;
      buf->st_nlink = 1;
      buf->st_uid = buf->st_gid = 0;
      buf->st_size = 0;
      buf->st_atime = buf->st_mtime = buf->st_ctime = 0;
      buf->st_mode = S_IREAD | S_IWRITE | S_IFDIR;
      return 0;
    }
}

/*
 * int _stat (cont char *, struct stat *);
 */
asm ("	.text");
asm ("	.globl __stat");
asm ("__stat:");
asm ("	movb	$6,%al");
asm ("	jmp	turbo_assist");
