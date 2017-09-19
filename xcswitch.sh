#!/bin/sh
set -e

readonly PROGNAME="$(basename "$0")"
readonly ARGS="$@"

# some colors
fg_red="$(tput setaf 1)"
fg_green="$(tput setaf 2)"
fg_cyan="$(tput setaf 6)"
fg_reset="$(tput sgr0)"

# initialize
XCODE_VS=(`ls -1d /Applications/Xcode* | sed '1d;s/\/Applications\/Xcode//' | sed 's/\.app//'`)
CURR_XCODE=`xcodebuild -version | head -n1`
CURR_XCODE_V=${CURR_XCODE:6}

echo "${fg_green}Xcode switcher -- Currently: ${fg_reset}${fg_cyan}[${CURR_XCODE_V}]${fg_reset}"
echo ""

# ---------------------------------------------------------
usage() {
    cat <<- EO_USAGE
Switch Xcode environment and keep it under /Applications/Xcode.app
usage:
    $PROGNAME {version}
where:
    {version} Xcode version: 8.3.3, 9.0, etc.

    Available versions are:
    - ${CURR_XCODE_V}   <= Current version
EO_USAGE
    local x=""
    for item in "${XCODE_VS[@]}"; do
        echo "    - ${item}"
    done
}

# ---------------------------------------------------------
pick_one() {
    PS3="Select Xcode version to use: (CTRL+C to quit) "
    select answer in "${XCODE_VS[@]}"; do
        for item in "${XCODE_VS[@]}"; do
            if [[ $item == $answer ]]; then
                break 2
            fi
        done
    done
    if [[ "X$answer" = "X" ]]; then
        echo ""
        exit 1
    fi
    do_switch $answer
}

# ---------------------------------------------------------
do_switch() {
    echo "Switching from: [${CURR_XCODE_V}] - to: ${fg_cyan}[${1}]${fg_reset}"
    echo "..."

    sudo mv /Applications/Xcode.app /Applications/Xcode${CURR_XCODE_V}.app
    sudo mv /Applications/Xcode${1}.app /Applications/Xcode.app

    echo "Double check versions below:"
    xcodebuild -version
    swift -version
    echo ""
}

# ---------------------------------------------------------
main() {
    #make sure only digits
    local dev=
    local regex="^[0-9]+\.[0-9]+(\.[0-9]+)?$"
    if [[ $ARGS =~ $regex ]]; then
        for item in "${XCODE_VS[@]}"; do
            if [[ $item == $ARGS ]]; then
                dev=$item
                break 2
            fi
        done
    fi
    if [[ "X$dev" == "X" ]]; then
        if [[ "$ARGS" == "${CURR_XCODE_V}" ]]; then
            echo "Already running version: ${CURR_XCODE_V}..."
        else
            echo "${fg_red}Invalid version: [$ARGS]${fg_reset}"
            usage
        fi
        echo ""
        exit 1
    fi
    do_switch $dev
}

# ---------------------------------------------------------
# no args? select one
if (($# != 1)); then
    pick_one
    exit 1
fi
main

# EOF
