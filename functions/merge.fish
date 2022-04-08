function merge --description "merge directories with rsync"
  set --function dryrun "--dry-run"
  if not isatty stdin
    read --local answer
    if test "$anwser" = "y"
      set --erase dryrun
    end
  end
  if test (count $argv) -lt 2
    echo no src/dest dirs. you moron
    return
  end
  for arg in argv
    if not string match --quiet '*/' $src
      set arg "$arg/"
    end
    set --append --function dirs $arg
  end
  rsync --archive --verbose --progress $dryrun $dirs
end
