if status is-interactive
# Commands to run in interactive sessions can go here

set -U fish_greeting ""

# Set up fish to use starship
starship init fish | source

# Set input text color
set -U fish_color_normal '#e4cbb3'
set -U fish_color_error '#b666e6'
set -U fish_color_valid_path '#fabc2c'

fastfetch

end 
