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

  local 'time_format'

  if [[ $SPACESHIP_TIME_FORMAT != false ]]; then
    time_format="${SPACESHIP_TIME_FORMAT}"
  else
    time_format="%T"
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

  local local_time=$(date +"$time_format")
  local utc_time=$(TZ="UTC" date +"$time_format")
  local local_hour=$(date +"%H")
  local local_hour=$(date +"%-I")
  local local_am_pm=$(date +"%p")
  local utc_hour=$(TZ="UTC" date +"%H")
  local utc_hour=$(TZ="UTC" date +"%-I")
  local utc_am_pm=$(TZ="UTC" date +"%p")
  local any_minute=$(TZ="UTC" date +"%M")
  local any_second=$(TZ="UTC" date +"%S")

    # "([$utc_hour]$local_time)" \
    # "($local_time)[$utc_time]" \
    # "[$utc_hour,$local_hour]:$any_minute" \
    # "loc[$local_time] utc[$utc_hour]" \
    # "($local_hour:$any_minute$local_am_pm | $utc_hour:$any_minute$utc_am_pm)" \
    # "($local_time | $utc_time)" \

  spaceship::section \
    "$color" \
    "$SPACESHIP_TIME_PREFIX" \
    "($local_time)" \
    "$SPACESHIP_TIME_SUFFIX"
}
