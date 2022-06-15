# merge.fish
Merge directories with rsync

### Installation

```sh
fisher install dangh/merge.fish
```

### Usage

```sh
# dryrun
merge src_dir_1 src_dir_2 ... dest_dir

# confirm merge
yes | merge src_dir_1 src_dir_2 ... dest_dir

# additional args can be appended to the command with --name=value format
# exclude dot files for example
merge src_dir_1 src_dir_2 ... dest_dir --exclude='.*'
```

### Troubleshooting

The default rsync shipped with macOS might not recognize unicode.

If it's hanged when listing directories, install rsync with homebrew.

```sh
brew install rsync
```
