#!/bin/sh
apk add --no-cache bash
sed 1,4d /obj/ent.sh > /tmp/ent.sh
exec bash /tmp/ent.sh "$@"
#!/bin/bash

set -e

# Parse args
dargs=false
up_args=()
d_args=()
if [ "$AUTH_KEY" != "" ]; then
    up_args=("--authkey" "$AUTH_KEY")
fi
for arg in "$@"; do
    if [ "$arg" = "--" ]; then
        dargs=true
    elif [ "$dargs" = "true" ]; then
        d_args+=("$arg")
    else
        up_args+=("$arg")
    fi
done

{
    if [ "${up_args[0]}" != "" ]; then
        echo "Waiting for a moment before running 'up'..."
        sleep 3
        tailscale up "${up_args[@]}"
    fi
} &

exec tailscaled "${d_args[@]}"
