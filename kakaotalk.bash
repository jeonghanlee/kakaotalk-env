#!/usr/bin/env bash
#
#  Copyright (c) 2019           Jeong Han Lee
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
#
#   author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    : Wednesday, December 11 23:04:08 CET 2019
#   version : 0.0.1

declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="${SC_SCRIPT%/*}"
declare -gr SC_LOGDATE="$(date +%y%m%d%H%M)"


declare -gr ProgramFiles="${HOME}/.wine/drive_c/Program Files"
declare -gr KakaoTalk="${ProgramFiles}/Kakao/KakaoTalk"

EXIST=1
NON_EXIST=0

SUDO="sudo"

function pushd { builtin pushd "$@" > /dev/null; }
function popd  { builtin popd  "$@" > /dev/null; }


function die
{
    error=${1:-1}
    ## exits with 1 if error number not given
    shift
    [ -n "$*" ] &&
	printf "%s%s: %s\n" "$scriptname" ${version:+" ($version)"} "$*" >&2
    exit "$error"
}


## if [[ $(checkIfFile "${release_file}") -eq "$NON_EXIST" ]]; then
#   NON_EXIT
## fi

function checkIfFile
{
    local file=$1
    local result=""
    if [ ! -e "$file" ]; then
	result=$NON_EXIST
	# doesn't exist
    else
	result=$EXIST
	# exist
    fi
    echo "${result}"	 
};


function checkIfVar()
{

    local var=$1
    local result=""
    if [ -z "$var" ]; then
	result=$NON_EXIST
	# doesn't exist
    else
	result=$EXIST
	# exist
    fi
    echo "${result}"
}

function get_ip
{
    local realip=$(ip -4 route get 8.8.8.8 | awk {'print $7'} | tr -d '\n')

    printf "Real IP address %s\n" "$realip"
}


function start_kakaotalk
{
    pushd "${KakaoTalk}"
    wine KakaoTalk.exe &
    popd
}





function stop_kakaotalk
{
    local pid=NON_EXIST;
    pid=$(ps ax |grep KakaoTalk.exe | grep -v "grep" | awk '{print $1}')
    if [[ $(checkIfVar "${pid}") -eq "$NON_EXIST" ]]; then
	printf ">> KakaoTalk is not running\n";
    else
	printf ">> KakaoTalk is running with %s\n" "${pid}"
	printf "   Killing the running KakaoTalk ....\n"
	kill -9 ${pid}
    fi
}


case "$1" in
    start)
	start_kakaotalk
	;;
    stop)
	stop_kakaotalk
	;;
    restart)
	stop_kakaotalk
	start_kakaotalk
	;;
    ip)
	get_ip;
	;;
     *)
	echo "Usage: $0 {start|stop|restart|ip}"
	exit 2
esac

exit
