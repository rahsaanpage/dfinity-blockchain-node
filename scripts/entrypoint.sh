#!/bin/bash

[ -z "$NODE_ENTRYPOINT" ] && {
    echo "environment variable NODE_ENTRYPOINT must be set" >&2
    exit 1
}

while true; do
    [ -f /app/assets/ready ] && break
    echo "waiting for agent to be ready"
    [ -f /app/assets/failed ] && echo "Agent bootstrap failed, crashing now!" && exit 1
    sleep 10
done

echo "Version: $(ic-rosetta-api --version)"

echo "Executing: $NODE_ENTRYPOINT $NODE_ARGS"
exec ${NODE_ENTRYPOINT} $(echo "$NODE_ARGS" | xargs)
