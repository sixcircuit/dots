
# START SSH AGENT WHEN ZSH STARTS
SSH_ENV="$HOME/.ssh/environment"

# start the ssh-agent
function start_agent {
    echo "starting new ssh agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    if [ -f ~/term/local/bin/load_keys ]; then
        ~/term/local/bin/load_keys
    fi
}

# test for identities
function test_identities {
    # test whether standard identities have been added to the agent already
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        ssh-add
        # $SSH_AUTH_SOCK broken so we start a new proper agent
        if [ $? -eq 2 ];then
            start_agent
        fi
    fi
}

# check if any keys are loaded, if so don't do anything

ssh-add -l >/dev/null 2>&1

if [ $? -ne 0 ]; then
   # check for running ssh-agent with proper $SSH_AGENT_PID
   if [ -n "$SSH_AGENT_PID" ]; then
       ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
       if [ $? -eq 0 ]; then
       test_identities
       fi
   # if $SSH_AGENT_PID is not properly set, we might be able to load one from
   # $SSH_ENV
   else
       if [ -f "$SSH_ENV" ]; then
       . "$SSH_ENV" > /dev/null
       fi
       ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep ssh-agent > /dev/null
       if [ $? -eq 0 ]; then
           test_identities
       else
           start_agent
       fi
   fi
fi

