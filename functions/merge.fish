function merge --description 'merge directories with rsync'
  set --function dryrun
  if not isatty stdin
    read --local answer
    if test "$answer" = y
      set --erase dryrun
    end
  end
  set --function rsync_argv
  set --function rsync_dirs
  for arg in $argv
    if string match --quiet -- '-*' $arg
      set --append rsync_argv $arg
    else
      if not string match --quiet '*/' -- $arg
        set arg "$arg/"
      end
      set --append rsync_dirs $arg
    end
  end
  if test (count $rsync_dirs) -lt 2
    echo no src/dest dirs. you moron
    return
  end
  set --append rsync_argv --archive --verbose --remove-source-files --ignore-existing --progress
  set --query dryrun
  set --function rsync_dest $rsync_dirs[-1]
  set --erase rsync_dirs[-1]
  for src in $rsync_dirs
    set_color green
    printf rsync
    for arg in $rsync_argv $src $rsync_dest
      printf ' %s' (string escape -- \\$arg | string sub --start 3)
    end
    printf \n
    set_color normal
    if set --query dryrun
      rsync $rsync_argv --dry-run $src $rsync_dest
    else
      rsync $rsync_argv $src $rsync_dest
      find $src -type d -empty -delete
    end
  end
end
