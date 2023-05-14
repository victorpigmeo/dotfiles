#!/bin/sh

NIX_APPLICATIONS_SYMLINK="${HOME}/.local/share/applications/nix-applications"
DEFAULT_ICONS_DIR="${HOME}/.local/share/icons"
NIX_ICONS_SYMLINK="${DEFAULT_ICONS_DIR}/hicolor"

echo "Checking if applications symlink exists"
if [ -d $NIX_APPLICATIONS_SYMLINK ]; then
   echo "Symlink ${NIX_APPLICATIONS_SYMLINK} exists."
else
   echo "Creating applications symlink"
   ln -sf ${HOME}/.nix-profile/share/applications/ ${NIX_APPLICATIONS_SYMLINK}
fi

echo "Checking if default icons directory exists"
if [ -d $DEFAULT_ICONS_DIR ]; then
   echo "Directory ${DEFAULT_ICONS_DIR} exists."
else
   echo "Creating icons directory"
   mkdir $DEFAULT_ICONS_DIR
fi

echo "Checking if icons symlink exists"
if [ -d $NIX_ICONS_SYMLINK ]; then
   echo "Symlink ${NIX_ICONS_SYMLINK} exists."
else
   echo "Creating icons symlink"
   ln -sf ${HOME}/.nix-profile/share/icons/hicolor/ ${NIX_ICONS_SYMLINK}
fi
