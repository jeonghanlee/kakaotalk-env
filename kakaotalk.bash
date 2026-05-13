#!/usr/bin/env bash
#
#  Copyright (c) 2019 - 2023  Jeong Han Lee
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
#   version : 0.0.6

set -euo pipefail

declare -g SC_SCRIPT

SC_SCRIPT="$(realpath "$0")"

declare -gr version="0.0.6"

declare -gr ProgramFiles1="${HOME}/.wine/drive_c/Program Files"
declare -gr ProgramFiles2="${HOME}/.wine/drive_c/Program Files (x86)"

declare -gr KakaoTalk="/Kakao/KakaoTalk"
declare -gr KakaoTalkPath1="${ProgramFiles1}${KakaoTalk}"
declare -gr KakaoTalkPath2="${ProgramFiles2}${KakaoTalk}"

function pushdd { builtin pushd "$@" > /dev/null || exit 1; }
function popdd  { builtin popd > /dev/null || exit 1; }

function die {
    local message="$1"

    printf "%s%s: %s\n" "$SC_SCRIPT" "${version:+ (${version})}" "$message" >&2
    exit 1
}

function get_kakaotalk_path {
    if [[ -d "${KakaoTalkPath1}" ]]; then
        printf "%s\n" "${KakaoTalkPath1}"
        return 0
    fi

    if [[ -d "${KakaoTalkPath2}" ]]; then
        printf "%s\n" "${KakaoTalkPath2}"
        return 0
    fi

    return 1
}

function get_ip
{
    local realip

    realip="$(ip -4 route get 8.8.8.8 | awk '{print $7; exit}')"
    printf "Real IP address %s\n" "$realip"
}


function start_kakaotalk
{
    local target

    if ! target="$(get_kakaotalk_path)"; then
        die "There is no path for KakaoTalk"
    fi

    pushdd "${target}"
        wine KakaoTalk.exe &
    popdd
}


function uninstall_kakaotalk
{
    local target

    if ! target="$(get_kakaotalk_path)"; then
        die "There is no path for KakaoTalk"
    fi

    pushdd "${target}"
        wine uninstall.exe &
    popdd
}


function stop_kakaotalk
{
    local name="KakaoTalk.exe"
    local pid

    # If we can use an expect script, we can kill KakaoTalk process without sudo
    # $ winedbg 
    # $ info proc
    # Wine-dbg>info proc
    #  pid      threads  executable (all id:s are in hex)
    # 00000061 1        'winedbg.exe'
    # 00000023 4        'explorer.exe'
    # 0000000e 5        'services.exe'
    # 0000001e 4        \_ 'winedevice.exe'
    # 00000019 3        \_ 'plugplay.exe'
    # 00000011 4        \_ 'winedevice.exe'
    # 00000008 55       'KakaoTalk.exe'
    # Wine-dbg>attach 00000008
    # 0x00000000f7f22067: int $0x80
    # Wine-dbg>kill
    # Wine-dbg>quit
    # $
    #
    # It turns out, we don't need to be sudo. ;)
    #
    if ! pid="$(pgrep -x "$name")"; then
        printf ">> Wine %s application is not running\n" "$name"
    else
        printf ">> Wine %s application was found with PID %s\n" "$name" "${pid}"
        printf "%s\n" "   Killing the running application ...."
        pkill -9 -x "$name"
    fi
}


## Interesting..
function winedbg_stop_kakaotalk
{
    local name="KakaoTalk.exe"
    local hex_wid
  
    hex_wid="$(winedbg --command "info proc" | awk -v name="$name" '$0 ~ name {print $1}')"
    printf "%s\n" "$hex_wid"
}

case "${1:-}" in
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
    uninstall)
        uninstall_kakaotalk
        ;;
    ip)
        get_ip
        ;;
    dbg)
        winedbg_stop_kakaotalk
        ;;
     *)
        printf "Usage: %s {start|stop|restart|uninstall|ip|dbg}\n" "$0"
        exit 2
esac

exit 0
