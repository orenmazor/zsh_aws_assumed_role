#
# Assumed Role
#
# This script is a small convenience to show the assumed role currently

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_AWS_ASSUMED_ROLE_SHOW="${SPACESHIP_AWS_ASSUMED_ROLE_SHOW=true}"
SPACESHIP_AWS_ASSUMED_ROLE_PREFIX="${SPACESHIP_AWS_ASSUMED_ROLE_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_AWS_ASSUMED_ROLE_SUFFIX="${SPACESHIP_AWS_ASSUMED_ROLE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_AWS_ASSUMED_ROLE_SYMBOL="📡 "
SPACESHIP_AWS_ASSUMED_ROLE_COLOR="green"


# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show assumed role status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_aws_assumed_role() {
  # If SPACESHIP_FOOBAR_SHOW is false, don't show foobar section
  [[ $SPACESHIP_AWS_ASSUMED_ROLE_SHOW == false ]] && return

  # Use quotes around unassigned local variables to prevent
  # getting replaced by global aliases
  # http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing
  local 'aws_assumed_role'

  if [[ -n "$AWS_SESSION_TOKEN" && -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" ]]; then

      # if the session token changed, then we're on a new account
      if [ "$AWS_SESSION_TOKEN" != "$CACHED_AWS_SESSION_TOKEN" ]; then

        # THIS GOES ON THE WIRE AVOID THIS CALL AVOID AVOID AVOID
        account_id=$(aws sts get-caller-identity | jq -r .Account)
        aws_assumed_role="$account_id"

        # how do we cache these?
        set CACHED_AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN"
        set CACHED_AWS_ROLE_NAME="aws_assumed_role"
        set CACHED_EXPIRATION_TIME="$EXPIRATION"
      else
          echo "using cache!"
        aws_assumed_role=$CACHED_AWS_ROLE_NAME
      fi
  else
      unset aws_assumed_role
      unset CACHED_AWS_SESSION_TOKEN
      unset CACHED_AWS_ROLE_NAME
      unset CACHED_EXPIRATION_TIME
  fi

  # Exit section if variable is empty
  [[ -z $aws_assumed_role ]] && return

  # Display foobar section
  spaceship::section \
    "$SPACESHIP_AWS_ASSUMED_ROLE_COLOR" \
    "$SPACESHIP_AWS_ASSUMED_ROLE_PREFIX" \
    "$SPACESHIP_AWS_ASSUMED_ROLE_SYMBOL$aws_assumed_role" \
    "$SPACESHIP_AWS_ASSUMED_ROLE_SUFFIX"
}
