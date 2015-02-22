static int prev_get_char = -1;

kbhit ()
{
  if (prev_get_char != -1)
    return 1;
  else if ((prev_get_char = _read_kbd (0,0,0)) != -1)
    return 1;
  else
    return 0;
}

getkey ()
{
  int c;

  if (prev_get_char != -1) {
    c = prev_get_char;
    prev_get_char = -1;
  } else {
    c = _read_kbd (0,0,0);
  }
  return c;
}
