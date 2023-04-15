#-------------------------------------------------------------------------------
# This script is used to setup an environment for the C1C0 project. It requires
# a linux environment with apt-get and git installed. It will install all the
# repositories for the C1C0 modules, set up their virtual environments, and
# download requirements. Credit for this script goes to Christopher De Jesus,
# and Mohammad Khan.
#
# Script Usage:
# chmod +x setup_jetson.sh
# ./setup_jetson.sh [-v (verbose mode)]
#-------------------------------------------------------------------------------

#!/bin/bash

# Parse command line arguments
if [ "$1" = "-v" ]; then verbose=true;
else verbose=false; fi

# Changes terminal text color
ruby() { printf "\e[1;31m"; }
aqua() { printf "\e[1;32m"; }
none() { printf "\e[0m"; }

# Prints a message in color
info() { aqua && printf "$1" && none; }
perr() { ruby && printf "$1" && none; }
bord() { aqua && echo "----------------------------------------" && none; }

# Attempts to install the given linux package. Returns 0 if successful, 1 if not.
try_install() { # $1 = package name
    info "\tInstalling $1...\n"

    dpkg -s "$1" &> /dev/null
    if [ ! $? -eq 0 ]; then
        if [ "$verbose" = true ]; then sudo apt-get install "$1" || perr "Failed to install $1\n";
        else sudo apt-get install "$1" &> /dev/null || perr "Failed to install $1\n"; fi
    fi

    dpkg -s "$1" &> /dev/null
    if [ ! $? -eq 0 ]; then return 1;
    else return 0; fi
}

# Attempts to clone the given git repository to the given repo path. Returns 0
# if successful, 1 if not.
try_clone() { # $1 = repo link, $2 = repo path
    info "\tCloning $1...\n"

    if [ ! -d "$2/.git" ]; then
        if [ "$verbose" = true ]; then git clone "$1" "$2" || perr "Failed to clone $1\n";
        else git clone "$1" "$2" &> /dev/null || perr "Failed to clone $1\n"; fi
    fi

    if  [ ! -d "$2/.git" ]; then return 1;
    else return 0; fi
}

# Attempts to checkout to the given branch of the given git repository. Returns
# 0 if successful, 1 if not.
try_checkout() { # $1 = repo path, $2 = branch name
    info "\tChecking $1:$2...\n"

    if [ $(git -C $1 rev-parse --abbrev-ref HEAD) != $2 ]; then
        if [ "$verbose" = true ]; then git -C $1 checkout $2 || perr "Failed to checkout $1:$2\n";
        else git -C $1 checkout $2 &> /dev/null || perr "Failed to checkout $1:$2\n"; fi
    fi

    if [ $(git -C $1 rev-parse --abbrev-ref HEAD) != "$2" ]; then return 1;
    else return 0; fi
}

# Attempts to create a python virtual environment in the given venv path. Returns
# 0 if successful, 1 if not.
try_venv() { # $1 = venv path
    info "\tCreating $1...\n"

    if [ ! -d "$1" ]; then
        if [ "$verbose" = true ]; then python3 -m venv "$1" || perr "Failed to create $1\n";
        else python3 -m venv "$1" &> /dev/null || perr "Failed to create $1\n"; fi
    fi

    if [ ! -d "$1" ]; then return 1;
    else return 0; fi
}

# Attempts to install the given pip package using the given pip path. Returns 0
# if successful, 1 if not.
try_pip() { # $1 = pip path, $2 = package name
    info "\tInstalling $1...\n"

    $1 show $2 &> /dev/null
    if [ ! $? -eq 0 ]; then
        if [ "$verbose" = true ]; then $1 install $2 || perr "Failed to install $1\n";
        else $1 install $2 &> /dev/null || perr "Failed to install $1\n"; fi
    fi

    $1 show $2 &> /dev/null
    if [ $? -eq 0 ]; then return 1;
    else return 0; fi
}

# Attempts to read the given requirements file and install all packages that don't
# need to be built from source. Returns 0 if successful, 1 if not.
try_requirements() { # $1 = pip path, $2 = requirements file
    info "\tReading $2...\n"

    skip_list = "Pillow"
    status=0

    while read -r line; do
        for word in $skip_list; do
            if [[ "$line" == "$word" ]]; then continue 2; fi
        done

        try_pip $1 $line || status=1
    done < $2

    return $status
}

# Install python related packages
bord && info "Installing libraries...\n"
try_install python3
try_install python3-dev
try_install python3-pip
try_install python3-venv

# Path planning information
path_continue=true
path_remote="git@github.com:cornell-cup/C1C0_path_planning.git"
path_local="../c1c0-path-planning"
path_branch="integration"
path_venv="$path_local/venv"
path_pip="$path_venv/bin/pip"
path_req="$path_local/requirements.txt"

# Set up path planning
bord && info "Building path planning...\n"
if [ $path_continue = true ]; then try_clone $path_remote $path_local || path_continue=false; fi
if [ $path_continue = true ]; then try_checkout $path_local $path_branch || path_continue=false; fi
if [ $path_continue = true ]; then try_venv $path_venv || path_continue=false; fi
if [ $path_continue = true ]; then try_requirements $path_pip $path_req || path_continue=false; fi
if [ $path_continue = false ]; then perr "Failed to build path planning\n"; fi

# Facial recognition information
facial_continue=true
facial_remote="git@github.com:cornell-cup/r2-facial_recognition_client.git"
facial_local="../r2-facial_recognition_client"
facial_branch="updating"
facial_venv="$facial_local/venv"
facial_pip="$facial_venv/bin/pip"
facial_req="$facial_local/requirements.txt"

# Set up facial recognition
bord && info "Building facial recognition...\n"
if [ $facial_continue = true ]; then try_clone $facial_remote $facial_local || facial_continue=false; fi
if [ $facial_continue = true ]; then try_checkout $facial_local $facial_branch || facial_continue=false; fi
if [ $facial_continue = true ]; then try_venv $facial_venv || facial_continue=false; fi
if [ $facial_continue = true ]; then try_requirements $facial_pip $facial_req || facial_continue=false; fi
if [ $facial_continue = false ]; then perr "Failed to build facial recognition\n"; fi

# Chatbot information
chat_continue=true
chat_remote="git@github.com:cornell-cup/r2-chatbot.git"
chat_local="../r2-chatbot"
chat_branch="master"
chat_venv="$chat_local/r2_chatterbot/venv"
chat_pip="$chat_venv/bin/pip"
chat_req="$chat_local/r2_chatterbot/requirements.txt"

# Set up chatbot
bord && info "Building chatbot...\n"
if [ $chat_continue = true ]; then try_clone $chat_remote $chat_local || chat_continue=false; fi
if [ $chat_continue = true ]; then try_checkout $chat_local $chat_branch || chat_continue=false; fi
if [ $chat_continue = true ]; then try_venv $chat_venv || chat_continue=false; fi
if [ $chat_continue = true ]; then try_requirements $chat_pip $chat_req || chat_continue=false; fi
if [ $chat_continue = false ]; then perr "Failed to build chatbot\n"; fi

# Object detection information
object_continue=true
object_remote="git@github.com:cornell-cup/r2-object_detection.git"
object_local="../r2-object_detection"
object_branch="blue-arm"
object_venv="$object_local/venv"
object_pip="$object_venv/bin/pip"
object_req="$object_local/requirements.txt"

# Set up object detection
bord && info "Building object detection...\n"
if [ $object_continue = true ]; then try_clone $object_remote $object_local || object_continue=false; fi
if [ $object_continue = true ]; then try_checkout $object_local $object_branch || object_continue=false; fi
if [ $object_continue = true ]; then try_venv $object_venv || object_continue=false; fi
if [ $object_continue = true ]; then try_requirements $object_pip $object_req || object_continue=false; fi
if [ $object_continue = false ]; then perr "Failed to build objection detection\n"; fi

# Movement information
move_continue=true
move_remote="git@github.com:cornell-cup/c1c0-movement.git"
move_local="../c1c0-movement"
move_branch="main"

# Set up movement
bord && info "Building movement...\n"
if [ $move_continue = true ]; then try_clone $move_remote $move_local || move_continue=false; fi
if [ $move_continue = true ]; then try_checkout $move_local $move_branch || move_continue=false; fi
if [ $move_continue = false ]; then perr "Failed to build movement\n"; fi

# Ending script
bord && exit 0
