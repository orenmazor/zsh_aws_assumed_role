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
    account_id=$(aws sts get-caller-identity | jq -r .Account)
    account_name=$(aws organizations describe-account --account-id $account_id | jq -r .Account.Name)
    aws_assumed_role=$account_name
  else
      unset aws_assumed_role
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
