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
#   version : 0.0.1

declare -g SC_SCRIPT;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }


sudo apt install -y make wget fonts-nanum fonts-nanum-coding fonts-nanum-eco fonts-nanum-extra

sudo dpkg --add-architecture i386

pushd "${SC_TOP}"
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" > winehq.list
sudo mv "${SC_TOP}/winehq.list" /etc/apt/sources.list.d/
popd

sudo apt update -y
sudo apt install --install-recommends winehq-devel

printf ">>> Please check the following Wine version\n"
wine --version
