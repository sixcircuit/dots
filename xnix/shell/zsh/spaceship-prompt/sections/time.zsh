#
# Time
#
# Current time

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_TIME_SHOW="${SPACESHIP_TIME_SHOW=false}"
SPACESHIP_TIME_PREFIX="${SPACESHIP_TIME_PREFIX="at "}"
SPACESHIP_TIME_SUFFIX="${SPACESHIP_TIME_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_TIME_FORMAT="${SPACESHIP_TIME_FORMAT=false}"
SPACESHIP_TIME_12HR="${SPACESHIP_TIME_12HR=false}"
SPACESHIP_TIME_COLOR="${SPACESHIP_TIME_COLOR="yellow"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_time() {
  [[ $SPACESHIP_TIME_SHOW == false ]] && return

  local 'time_str'

  if [[ $SPACESHIP_TIME_FORMAT != false ]]; then
    time_str="${SPACESHIP_TIME_FORMAT}"
  elif [[ $SPACESHIP_TIME_12HR == true ]]; then
    time_str="%D{%r}"
  else
    time_str="%D{%T}"
  fi

  local 'hour'

  hour=`date +"%H"`
  hour=$(($hour+0))

  local 'color'
  
  color=$SPACESHIP_TIME_COLOR

  # TODO: I THINK THIS LOGIC IS STRAIGHT UP GARBAGE? IT MAY ONLY WORK FOR THE 
  # NUMBERS I HAVE. IT MIGHT NOT EVEN WORK FOR THAT. FIX IT UP. IT'S A GOOD IDEA.

  if [[ ($hour -lt $SPACESHIP_TIME_TOO_LATE_DAY_START_HOUR) ]]; then
     color=$SPACESHIP_TIME_TOO_LATE_RED_COLOR
  elif [[ ($hour -ge $SPACESHIP_TIME_TOO_LATE_RED_HOUR) ]]; then
     color=$SPACESHIP_TIME_TOO_LATE_RED_COLOR
  elif [[ ($hour -ge $SPACESHIP_TIME_TOO_LATE_YELLOW_HOUR) ]]; then
     color=$SPACESHIP_TIME_TOO_LATE_YELLOW_COLOR
  fi 

  spaceship::section \
    "$color" \
    "$SPACESHIP_TIME_PREFIX" \
    "$time_str" \
    "$SPACESHIP_TIME_SUFFIX"
}
