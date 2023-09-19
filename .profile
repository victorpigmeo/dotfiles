# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export XDG_DATA_DIRS=/usr/local/share/:/usr/share/
# if [ -n ${XDG_SESSION_ID} ];then
#     xdgpath=$(echo $XDG_DATA_DIRS|sed -e 's#/usr/local/share:##' -e 's#/usr/share:##')
#     XDG_DATA_DIRS=/usr/local/share:/usr/share
#     if [ -d ~/.nix-profile ];then
#         for x in $(find ~/.nix-profile/share/applications/*.desktop);do
#             XDG_DATA_DIRS=$(dirname $(dirname $(readlink -f $x))):${XDG_DATA_DIRS}
#         done
#     fi
#     XDG_DATA_DIRS=${HOME}/.local/share:${xdgpath}:${XDG_DATA_DIRS}
#     export XDG_DATA_DIRS
# fi

export PATH=$PATH

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

if [ -e /home/victor/.nix-profile/etc/profile.d/nix.sh ]; then . /home/victor/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
