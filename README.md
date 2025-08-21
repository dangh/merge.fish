# merge.fish
Merge directories with rsync

### Installation

```sh
fisher install dangh/merge.fish
```

### Usage

```sh
merge src_dir_1 src_dir_2 ... dest_dir

# exclude more files
merge src_dir_1 src_dir_2 ... dest_dir -e '.*'
```

### Troubleshooting

The default rsync shipped with macOS might not recognize unicode.

If it's hanged when listing directories, install rsync with homebrew.

```sh
brew install rsync
```
