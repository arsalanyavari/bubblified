#!/bin/bash

blue_color="\033[1;34m"
yellow_color="\033[1;33m"
reset_color="\033[0m"

calculate_terminal_dimensions() {
    term_width=$(tput cols)
    term_height=$(tput lines)
}

center_text() {
    local text="$1"
    local length=${#text}
    local padding=$(( (term_width - length) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

handle_input() {
    selected_option=0
    while true; do
        if [ $2 = 1 ]; then
            requirement_menu $1
        elif [ $2 = 2 ]; then
            select_style_menu $1
        fi

        read -rsn3 key                  # Read one character without echo
        
        case $key in
            $'\e[A')                    # Up arrow key
                ((selected_option = (selected_option - 1 + ${#options[@]}) % ${#options[@]}))
                ;;
            $'\e[B')                    # Down arrow key
                ((selected_option = (selected_option + 1) % ${#options[@]}))
                ;;
            "")                         # Enter key
            # handle_choice
            
            selected_option=$((selected_option + 1))
            if [ $selected_option = ${#options[@]} ]; then
                echo 
                echo -e "$yellow_color""Have a nice time\t bye bye :D $reset_color"
                exit 0
            else
                return $selected_option
            fi
        esac
        
    done
}

requirement_menu() {
    clear                               # Clear the screen
    
    calculate_terminal_dimensions

    local prefix="This is "
    local colored_text="Bubbilified configuration wizard"
    local suffix=". It will ask you a few questions and configure your prompt."
    echo -e "$prefix$blue_color$colored_text$reset_color$suffix"
    echo 
    local prefix="Does this look like a "
    
    if [ "$1" = "prompt" ]; then
        colored_text="Circle"
        icon_element="⬤"
    elif [ "$1" = "icons" ]; then
        colored_text="Icons"
        icon_element="        "     # I have no energy to find their unicode; so I copy paste them. It will work :)
    fi
    
    echo -e "$(center_text "\t      $prefix$yellow_color$colored_text$reset_color")"
    center_text "reference: https://graphemica.com/%E2%AC%A4"
    echo
    center_text " --->  $icon_element   <---"
    echo


    for i in "${!options[@]}"; do
        local text_length=${#options[$i]}
        local padding=$(( (term_width - text_length) / 2 ))
        
        if [[ $i -eq $selected_option ]]; then
            printf "%*s" $padding ""    # Move cursor to padding
            tput rev                    # Start reverse (highlighting) mode
            printf "%s" "${options[$i]}"
            tput sgr0                   # End reverse mode
            echo
        else
            center_text "${options[$i]}"
        fi
    done
}


select_style_menu() {
    clear                               # Clear the screen
    
    calculate_terminal_dimensions

    center_text "Prompt Style"
    echo 
    local prefix="Does this look like a "
    
    if [ "$1" = "prompt" ]; then
        colored_text="Circle"
        icon_element="⬤"
    elif [ "$1" = "icons" ]; then
        colored_text="Icons"
        icon_element="        "     # I have no energy to find their unicode; so I copy paste them. It will work :)
    fi
    
    echo -e "$(center_text "\t      $prefix$yellow_color$colored_text$reset_color")"
    center_text "reference: https://graphemica.com/%E2%AC%A4"
    echo
    center_text " --->  $icon_element   <---"
    echo


    for i in "${!options[@]}"; do
        local text_length=${#options[$i]}
        local padding=$(( (term_width - text_length) / 2 ))
        
        if [[ $i -eq $selected_option ]]; then
            printf "%*s" $padding ""    # Move cursor to padding
            tput rev                    # Start reverse (highlighting) mode
            printf "%s" "${options[$i]}"
            tput sgr0                   # End reverse mode
            echo
        else
            center_text "${options[$i]}"
        fi
    done 

}


options=("Yes" "No!" "Quit and do nothing :)")

selected_option=0
handle_input "prompt" 1
is_circle=$?

handle_input "icons" 1
is_icon=$?


if [ "$is_circle" -ne 1 ]; then
    options=("Pure" "Restart from the beginning" "Quit and do nothing :)")
else
    options=("Classic" "Rainbow" "Pure" "Restart from the beginning" "Quit and do nothing :)")
fi

if [ "$is_icon" -ne 1 ]; then
    options=("Pure" "Restart from the beginning" "Quit and do nothing :)")
else
    options=("Classic" "Rainbow" "Pure" "Restart from the beginning" "Quit and do nothing :)")
fi
