
stow(8)                                                 User Contributed Perl Documentation                                                stow(8)

NAME
       stow - manage farms of symbolic links

SYNOPSIS
       stow [ options ] package ...

TERMINOLOGY
       A "package" is a related collection of files and directories that you wish to administer as a unit -- e.g., Perl or Emacs -- and that needs
       to be installed in a particular directory structure -- e.g., with bin, lib, and man subdirectories.

       A "target directory" is the root of a tree in which one or more packages wish to appear to be installed. A common, but by no means the only
       such location is /usr/local.  The examples in this manual page will use /usr/local as the target directory.

       A "stow directory" is the root of a tree containing separate packages in private subtrees. When Stow runs, it uses the current directory as
       the default stow directory. The examples in this manual page will use /usr/local/stow as the stow directory, so that individual packages
       will be, for example, /usr/local/stow/perl and /usr/local/stow/emacs.

       An "installation image" is the layout of files and directories required by a package, relative to the target directory. Thus, the
       installation image for Perl includes: a bin directory containing perl and a2p (among others); an info directory containing Texinfo
       documentation; a lib/perl directory containing Perl libraries; and a man/man1 directory containing man pages.

       A "package directory" is the root of a tree containing the installation image for a particular package. Each package directory must reside
       in a stow directory -- e.g., the package directory /usr/local/stow/perl must reside in the stow directory /usr/local/stow.  The "name" of a
       package is the name of its directory within the stow directory -- e.g., perl.

       Thus, the Perl executable might reside in /usr/local/stow/perl/bin/perl, where /usr/local is the target directory, /usr/local/stow is the
       stow directory, /usr/local/stow/perl is the package directory, and bin/perl within is part of the installation image.

       A "symlink" is a symbolic link. A symlink can be "relative" or "absolute". An absolute symlink names a full path; that is, one starting
       from /.  A relative symlink names a relative path; that is, one not starting from /.  The target of a relative symlink is computed starting
       from the symlink's own directory.  Stow only creates relative symlinks.

OPTIONS
       The stow directory is assumed to be the value of the "STOW_DIR" environment variable or if unset the current directory, and the target
       directory is assumed to be the parent of the current directory (so it is typical to execute stow from the directory /usr/local/stow).  Each
       package given on the command line is the name of a package in the stow directory (e.g., perl).  By default, they are installed into the
       target directory (but they can be deleted instead using "-D").

       -n
       --no
           Do not perform any operations that modify the filesystem; merely show what would happen.

       -d DIR
       --dir=DIR
           Set  the  stow directory to "DIR" instead of the current directory.  This also has the effect of making the default target directory be
           the parent of "DIR".

       -t DIR
       --target=DIR
           Set the target directory to "DIR" instead of the parent of the stow directory.

       -v
       --verbose[=N]
           Send verbose output to standard error describing what Stow is doing. Verbosity levels are from 0 to 5; 0 is the default.  Using "-v" or
           "--verbose" increases the verbosity by one; using ‘--verbose=N' sets it to N.

       -S
       --stow
           Stow the packages that follow this option into the target directory.  This is the default action and so can be omitted if you are  only
           stowing packages rather than performing a mixture of stow/delete/restow actions.

       -D
       --delete
           Unstow the packages that follow this option from the target directory rather than installing them.

       -R
       --restow
           Restow  packages  (first unstow, then stow again). This is useful for pruning obsolete symlinks from the target tree after updating the
           software in a package.

       --adopt
           Warning!  This behaviour is specifically intended to alter the contents of your stow directory.  If you do not want that,  this  option
           is not for you.

           When  stowing,  if a target is encountered which already exists but is a plain file (and hence not owned by any existing stow package),
           then normally Stow will register this as a conflict and refuse to proceed.  This option changes that behaviour  so  that  the  file  is
           moved  to  the  same  relative  place  within  the package's installation image within the stow directory, and then stowing proceeds as
           before.  So effectively, the file becomes adopted by the stow package, without its contents changing.

       --no-folding
           Disable folding of newly stowed directories when stowing, and refolding of newly foldable directories when unstowing.

       --ignore=REGEX
           Ignore files ending in this Perl regex.

       --defer=REGEX
           Don't stow files beginning with this Perl regex if the file is already stowed to another package.

       --override=REGEX
           Force stowing files beginning with this Perl regex if the file is already stowed to another package.

       --dotfiles
           Enable special handling for "dotfiles" (files or folders whose name begins with a period) in the package directory. If this  option  is
           enabled, Stow will add a preprocessing step for each file or folder whose name begins with "dot-", and replace the "dot-" prefix in the
           name  by  a period (.). This is useful when Stow is used to manage collections of dotfiles, to avoid having a package directory full of
           hidden files.

           For example, suppose we have a package containing two files, stow/dot-bashrc and stow/dot-emacs.d/init.el. With this option, Stow  will
           create symlinks from .bashrc to stow/dot-bashrc and from .emacs.d/init.el to stow/dot-emacs.d/init.el. Any other files, whose name does
           not begin with "dot-", will be processed as usual.

       -V
       --version
           Show Stow version number, and exit.

       -h
       --help
           Show Stow command syntax, and exit.

INSTALLING PACKAGES
       The default action of Stow is to install a package. This means creating symlinks in the target tree that point into the package tree.  Stow
       attempts  to do this with as few symlinks as possible; in other words, if Stow can create a single symlink that points to an entire subtree
       within the package tree, it will choose to do that rather than create a directory in the target tree and populate it with symlinks.

       For example, suppose that no packages have yet been installed in /usr/local; it's completely empty (except for the  stow  subdirectory,  of
       course).  Now  suppose  the  Perl  package is installed.  Recall that it includes the following directories in its installation image: bin;
       info; lib/perl; man/man1.  Rather than creating the directory /usr/local/bin and populating it with symlinks to  ../stow/perl/bin/perl  and
       ../stow/perl/bin/a2p  (and so on), Stow will create a single symlink, /usr/local/bin, which points to stow/perl/bin.  In this way, it still
       works to refer to /usr/local/bin/perl and /usr/local/bin/a2p, and fewer symlinks have been created. This is called "tree folding", since an
       entire subtree is "folded" into a single symlink.

       To complete this example, Stow will also create the symlink /usr/local/info pointing to stow/perl/info; the symlink /usr/local/lib pointing
       to stow/perl/lib; and the symlink /usr/local/man pointing to stow/perl/man.

       Now suppose that instead of installing the Perl package into an empty target tree, the target tree is not empty to begin with. Instead,  it
       contains  several files and directories installed under a different system-administration philosophy. In particular, /usr/local/bin already
       exists and is a directory, as are /usr/local/lib and /usr/local/man/man1.  In this case, Stow will descend into /usr/local/bin  and  create
       symlinks  to  ../stow/perl/bin/perl  and  ../stow/perl/bin/a2p  (etc.), and it will descend into /usr/local/lib and create the tree-folding
       symlink perl pointing to ../stow/perl/lib/perl, and so on. As a rule, Stow only descends as far as necessary into the target tree  when  it
       can create a tree-folding symlink.

       The  time often comes when a tree-folding symlink has to be undone because another package uses one or more of the folded subdirectories in
       its installation image. This operation is called "splitting open" a folded tree. It involves removing the original symlink from the  target
       tree, creating a true directory in its place, and then populating the new directory with symlinks to the newly-installed package and to the
       old  package that used the old symlink. For example, suppose that after installing Perl into an empty /usr/local, we wish to install Emacs.
       Emacs's installation image includes a bin directory containing the emacs and etags executables, among others. Stow must  make  these  files
       appear  to  be installed in /usr/local/bin, but presently /usr/local/bin is a symlink to stow/perl/bin.  Stow therefore takes the following
       steps: the  symlink  /usr/local/bin  is  deleted;  the  directory  /usr/local/bin  is  created;  links  are  made  from  /usr/local/bin  to
       ../stow/emacs/bin/emacs   and   ../stow/emacs/bin/etags;   and   links   are   made   from   /usr/local/bin  to  ../stow/perl/bin/perl  and
       ../stow/perl/bin/a2p.

       When splitting open a folded tree, Stow makes sure that the symlink it is about to remove points inside a valid package in the current stow
       directory.

   Stow will never delete anything that it doesn't own.
       Stow "owns" everything living in the target tree that points into a package in the stow directory. Anything Stow owns, it can recompute  if
       lost. Note that by this definition, Stow doesn't "own" anything in the stow directory or in any of the packages.

       If  Stow  needs to create a directory or a symlink in the target tree and it cannot because that name is already in use and is not owned by
       Stow, then a conflict has arisen. See the "Conflicts" section in the info manual.

DELETING PACKAGES
       When the "-D" option is given, the action of Stow is to delete a package from the target tree. Note that Stow will not delete  anything  it
       doesn't "own". Deleting a package does not mean removing it from the stow directory or discarding the package tree.

       To  delete a package, Stow recursively scans the target tree, skipping over the stow directory (since that is usually a subdirectory of the
       target tree) and any other stow directories it encounters (see "Multiple stow directories" in the info manual). Any symlink it  finds  that
       points  into  the package being deleted is removed. Any directory that contained only symlinks to the package being deleted is removed. Any
       directory that, after removing symlinks and empty subdirectories, contains only symlinks to a single other package, is considered to  be  a
       previously "folded" tree that was "split open."  Stow will re-fold the tree by removing the symlinks to the surviving package, removing the
       directory, then linking the directory back to the surviving package.

RESOURCE FILES
       Stow  searches  for  default  command  line  options  at  .stowrc (current directory) and ~/.stowrc (home directory) in that order. If both
       locations are present, the files are effectively appended together.

       The effect of options in the resource file is similar to simply prepending the options to the command line.  For  options  that  provide  a
       single  value,  such as --target or --dir, the command line option will overwrite any options in the resource file. For options that can be
       given more than once, --ignore for example, command line options and resource options are appended together.

       Environment variables and the tilde character (~) will be expanded for options that take a file path.

       The options -D, -R, -S, and any packages listed in the resource file are ignored.

       See the info manual for more information on how stow handles resource file.

SEE ALSO
       The full documentation for stow is maintained as a Texinfo manual.  If the info and stow programs are properly installed at your site,  the
       command

           info stow

       should give you access to the complete manual.

BUGS
       Please report bugs in Stow using the Debian bug tracking system.

       Currently known bugs include:

       •   The empty-directory problem.

           If  package  foo includes an empty directory -- say, foo/bar -- then if no other package has a bar subdirectory, everything's fine.  If
           another stowed package quux, has a bar subdirectory, then when stowing, targetdir/bar will be "split open" and the contents of quux/bar
           will be individually stowed.  So far, so good. But when unstowing quux, targetdir/bar will be removed, even though foo/bar needs it  to
           remain.   A workaround for this problem is to create a file in foo/bar as a placeholder. If you name that file .placeholder, it will be
           easy to find and remove such files when this bug is fixed.

       •   When using multiple stow directories (see "Multiple stow directories" in the info manual), Stow  fails  to  "split  open"  tree-folding
           symlinks  (see  "Installing  packages"  in the info manual) that point into a stow directory which is not the one in use by the current
           Stow command. Before failing, it should search the target of the link to see whether any element of the path contains a .stow file.  If
           it finds one, it can "learn" about the cooperating stow directory to short-circuit the .stow search the next time it encounters a tree-
           folding symlink.

AUTHOR
       This  man  page  was  originally constructed by Charles Briscoe-Smith from parts of Stow's info manual, and then converted to POD format by
       Adam Spiers.  The info manual contains the following notice, which, as it says, applies to this manual page, too.  The text of the  section
       entitled "GNU General Public License" can be found in the file /usr/share/common-licenses/GPL on any Debian GNU/Linux system.  If you don't
       have  access  to a Debian system, or the GPL is not there, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
       MA, 02111-1307, USA.

COPYRIGHT
       Copyright (C) 1993, 1994, 1995, 1996 by Bob Glickstein <bobg+stow@zanshin.com>; 2000, 2001 by Guillaume Morin; 2007 by Kahlil Hodgson; 2011
       by Adam Spiers; and others.

       Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this  permission  notice  are
       preserved on all copies.

       Permission is granted to copy and distribute modified versions of this manual under the conditions for verbatim copying, provided also that
       the section entitled "GNU General Public License" is included with the modified manual, and provided that the entire resulting derived work
       is distributed under the terms of a permission notice identical to this one.

       Permission  is  granted  to  copy and distribute translations of this manual into another language, under the above conditions for modified
       versions, except that this permission notice may be stated in a translation approved by the Free Software Foundation.

perl v5.26.1                                                        2019-07-28                                                             stow(8)
