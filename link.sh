# Usage: ln [OPTION]... [-T] TARGET LINK_NAME
#   or:  ln [OPTION]... TARGET
#   or:  ln [OPTION]... TARGET... DIRECTORY
#   or:  ln [OPTION]... -t DIRECTORY TARGET...
# In the 1st form, create a link to TARGET with the name LINK_NAME.
# In the 2nd form, create a link to TARGET in the current directory.
# In the 3rd and 4th forms, create links to each TARGET in DIRECTORY.
# Create hard links by default, symbolic links with --symbolic.
#
# Mandatory arguments to long options are mandatory for short options too.
#       --backup[=CONTROL]      make a backup of each existing destination file
#   -b                          like --backup but does not accept an argument
#   -d, -F, --directory         allow the superuser to attempt to hard link
#                                 directories (note: will probably fail due to
#                                 system restrictions, even for the superuser)
#   -f, --force                 remove existing destination files
#   -i, --interactive           prompt whether to remove destinations
#   -L, --logical               dereference TARGETs that are symbolic links
#   -n, --no-dereference        treat LINK_NAME as a normal file if
#                                 it is a symbolic link to a directory
#   -P, --physical              make hard links directly to symbolic links
#   -r, --relative              with -s, create links relative to link location
#   -s, --symbolic              make symbolic links instead of hard links

# ln -s TARGET LINK_NAME

ln -s ./dotfiles/.ssh ~/.ssh 
ln -s ./scripts/ ~/scripts/


