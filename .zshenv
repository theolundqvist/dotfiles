# create / setup spaces
function yabai_setup_space {
  local idx="$1"
  local name="$2"
  local space=
  echo "setup space $idx : $name"

  space=$(yabai -m query --spaces --space "$idx")
  if [ -z "$space" ]; then
    yabai -m space --create
  fi

  yabai -m space "$idx" --label "$name"
}

function yabai_remove_extra_spaces {
  for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 6)'); do
    yabai -m space --destroy 7      # <-- max number spaces
  done
}


function start_apps {

  open -a 'Alacritty';
  open -a 'Arc';
  open -a 'Discord';
  open -a 'Messenger';
  open -a 'Messages'
  open -a 'Spotify'
}



function yabai_setup_laptop_env {
  yabai_remove_extra_spaces

  yabai_setup_space 1 term
  yabai_setup_space 2 web
  yabai_setup_space 3 coms
  yabai_setup_space 4 music
  yabai_setup_space 5 x
  yabai_setup_space 6 y

   
  start_apps 

  yabai -m rule --remove "X.1"
  yabai -m rule --remove "X.2"
  yabai -m rule --remove "X.3"
  yabai -m rule --remove "X.4"
  yabai -m rule --remove "X.5"
  yabai -m rule --remove "X.6"
  yabai -m rule --add label="X.1" app="^Alacritty$" space=^1
  yabai -m rule --add label="X.2" app="^Arc$" space=2
  yabai -m rule --add label="X.3" app="^Messenger$" space=3
  yabai -m rule --add label="X.4" app="^Discord$" space=3
  yabai -m rule --add label="X.5" app="^Messages$" space=3
  yabai -m rule --add label="X.6" app="^Spotify$" space=4 

  # yabai -m rule --add app="^Music$" space=5
}


function yabai_setup_desktop_env {

  yabai_remove_extra_spaces

  yabai_setup_space 1 term
  yabai_setup_space 2 web
  yabai_setup_space 3 coms
  yabai_setup_space 4 music
  yabai_setup_space 5 x
  yabai_setup_space 6 y


  start_apps 

  yabai -m rule --remove "X.1"
  yabai -m rule --remove "X.2"
  yabai -m rule --remove "X.3"
  yabai -m rule --remove "X.4"
  yabai -m rule --remove "X.5"
  yabai -m rule --remove "X.6"
  yabai -m rule --add label="X.1" app="^Alacritty$" space=^1 display=2
  yabai -m rule --add label="X.2" app="^Arc$" space=1 display=2
  yabai -m rule --add label="X.3" app="^Messenger$" space=3 display=2
  yabai -m rule --add label="X.4" app="^Discord$" space=3 display=2
  yabai -m rule --add label="X.5" app="^Messages$" space=3 display=2
  yabai -m rule --add label="X.6" app="^Spotify$" space=4 display=2
  # yabai -m rule --add app="^Music$" space=5
}


