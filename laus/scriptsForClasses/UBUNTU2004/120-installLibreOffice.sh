#!/bin/bash

#apt-get -y update

# quiet installation
export DEBIAN_FRONTEND=noninteractive

## LibreOffice full Package
## LibreOffice German Languagepackage
## LibreOffice Englisch-GB, German-AT, France, Italian, Spain Dictionarys
## Hyphenation & Thesaurus
apt-get -y install libreoffice libreoffice-l10n-de hunspell hunspell-de-at hunspell-en-gb hunspell-fr hunspell-it hunspell-es hyphen-de mythes-de

