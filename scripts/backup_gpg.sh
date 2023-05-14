#!/bin/sh

echo "Creating gpgbkp directory"
mkdir gpgbkp
cd gpgbkp

#list keys
gpg --list-secret-keys --keyid-format LONG

#export public keys
gpg --export --export-options backup --output public.gpg

#export private keys
gpg --export-secret-keys --export-options backup --output private.gpg

#export ownertrust
gpg --export-ownertrust > trust.gpg

echo "Now copy the gpgbkp directory to the new computer and run 'gpg --import <file>' for all those files"
