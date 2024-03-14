function merge -d 'merge directories with rsync'
    argparse f/force -- $argv

    set -f dryrun
    if not isatty stdin
        read -l answer
        if test "$answer" = y
            set -e dryrun
        end
    end
    set -f rsync_argv
    set -f rsync_dirs
    for arg in $argv
        if string match -q -- '-*' $arg
            set -a rsync_argv $arg
        else
            if not string match -q '*/' -- $arg
                set arg "$arg/"
            end
            set -a rsync_dirs $arg
        end
    end
    if test (count $rsync_dirs) -lt 2
        echo no src/dest dirs. you moron
        return
    end
    set -a rsync_argv --archive --verbose --remove-source-files --progress
    set -q _flag_force || set -a rsync_argv --ignore-existing
    set -f rsync_dest $rsync_dirs[-1]
    set -e rsync_dirs[-1]
    for src in $rsync_dirs
        set_color green
        printf rsync
        for arg in $rsync_argv $src $rsync_dest
            printf ' %s' (string escape -- \\$arg | string sub -s 3)
        end
        printf \n
        set_color normal
        if set -q dryrun
            rsync $rsync_argv --dry-run $src $rsync_dest
        else
            rsync $rsync_argv $src $rsync_dest
            find $src -type d -empty -delete
        end
    end
end
