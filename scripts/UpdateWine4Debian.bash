#!/usr/bin/env bash
#
#  Copyright (c) 2021           Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#   author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   version : 0.0.2

declare -g SC_SCRIPT;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

function pushdd { builtin pushd "$@" > /dev/null || exit; }
function popdd  { builtin popd  > /dev/null || exit; }


function which_os
{
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    echo "$VERSION_CODENAME"
  fi
}


DEB=$(which_os)


sudo apt install -y make wget fonts-nanum fonts-nanum-eco fonts-nanum-extra

sudo dpkg --add-architecture i386

pushdd "${SC_TOP}"
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
if [[ -f "/etc/apt/sources.list.d/winehq.list" ]]; then
    sudo rm -f /etc/apt/sources.list.d/winehq.list
fi
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/${DEB}/winehq-${DEB}.sources
popdd

sudo apt update -y
sudo apt install --install-recommends winehq-stable

printf ">>> Please check the following Wine version\n"
wine --version
