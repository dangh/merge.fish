function merge -d 'merge directories with rsync'
    argparse 'e/exclude=' -- $argv
    or return 1

    if test (count $argv) -lt 2
        echo "Usage: merge [-e pattern ...] <src_dir> <src_dir> ... <dst_dir>"
        return 1
    end

    set dst $argv[-1]
    set srcs $argv[1..-2]

    # build exclude list
    set rsync_excludes "--exclude=.DS_Store"
    for pattern in $_flag_exclude
        set rsync_excludes $rsync_excludes "--exclude=$pattern"
    end

    for src in $srcs
        echo $src

        set -l new_files
        set -l changed_files
        set -l identical_files

        # 1. dry-run with rsync to get changed files
        rsync -rcvn --itemize-changes $rsync_excludes $src/ $dst/ | while read -d ' ' -l code file
            switch $code
                case ">f+++++++++"
                    set -a new_files $src/$file
                case ">f*"
                    set -a changed_files $src/$file
            end
        end

        # 2. find all files and exclude the changed files to get identical files
        find $src -type f | sort | while read -l file
            set base (string sub -s (math 2+(string length $src)) $file)
            if contains $file $new_files
                echo "  $base" (set_color green)"(new)"(set_color normal)
            else if contains $file $changed_files
                echo "  $base" (set_color red)"(changed)"(set_color normal)
            else
                echo "  $base"
                set -a identical_files $file
            end
        end

        # 3. confirm
        read -l -P "Proceed with move? (y/N) " answer
        switch $answer
            case y Y
                # copy new/overwrite files
                rsync -rcv --remove-source-files --progress $rsync_excludes $src/ $dst/

                # remove identical files
                for f in $identical_files
                    if test -f $f
                        rm $f
                    end
                end

                # remove empty dirs
                find $src -type d -empty -delete
            case '*'
                echo "Aborted."
        end
    end
end
