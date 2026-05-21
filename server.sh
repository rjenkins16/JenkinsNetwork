#!/bin/bash

# Docker Stack Manager
# Usage: ./server.sh <command> [stack]
# Commands: start, stop, status
# Stacks: arr, media, network, storage, all

STACKS=("arr" "media" "network" "storage")
COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect docker compose command (space version or dash version)
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose version &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "Error: Neither 'docker compose' nor 'docker-compose' found. Please install Docker Compose."
    exit 1
fi

usage() {
    echo "Docker Stack Manager"
    echo "Usage: $0 <command> [stack]"
    echo ""
    echo "Commands:"
    echo "  start    - Start one or all stacks"
    echo "  stop     - Stop one or all stacks"
    echo "  status   - Check status of one or all stacks"
    echo "  update   - Update one or all stacks"
    echo ""
    echo "Stacks:"
    echo "  arr      - Start/stop/status/update arr stack"
    echo "  media    - Start/stop/status/update media stack"
    echo "  network  - Start/stop/status/update network stack"
    echo "  storage  - Start/stop/status/update storage stack"
    echo "  all      - Start/stop/status/update all stacks"
    echo ""
    echo "Examples:"
    echo "  $0 start arr"
    echo "  $0 stop all"
    echo "  $0 status media"
    exit 1
}

check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: '$cmd' not found. Please install it and try again."
        exit 1
    fi
}

start_stack() {
    local stack="$1"
    echo "Starting $stack stack..."
    cd "$COMPOSE_DIR/$stack" && $DOCKER_COMPOSE up -d
}

stop_stack() {
    local stack="$1"
    echo "Stopping $stack stack..."
    cd "$COMPOSE_DIR/$stack" && $DOCKER_COMPOSE down
}

update_stack() {
    local stack="$1"
    echo "Updating $stack stack..."
    cd "$COMPOSE_DIR/$stack" 
    $DOCKER_COMPOSE pull && $DOCKER_COMPOSE up -d
}


status_stack() {
    local stack="$1"
    echo "=== Status of $stack stack ==="
    cd "$COMPOSE_DIR/$stack" && $DOCKER_COMPOSE ps
    echo ""
}

start_all() {
    echo "Starting all stacks..."
    for stack in "${STACKS[@]}"; do
        start_stack "$stack"
    done
}

stop_all() {
    echo "Stopping all stacks..."
    for stack in "${STACKS[@]}"; do
        stop_stack "$stack"
    done
}

update_all() {
    echo "Updating all stacks..."
    for stack in "${STACKS[@]}"; do
        update_stack "$stack"
    done
}


status_all() {
    echo "=== Status of all stacks ==="
    for stack in "${STACKS[@]}"; do
        status_stack "$stack"
    done
}

# Check arguments
if [ $# -eq 0 ]; then
    usage
fi

COMMAND="$1"
STACK="${2:-all}"

# Validate command
if [[ ! "$COMMAND" =~ ^(start|stop|status|update)$ ]]; then
    echo "Error: Invalid command '$COMMAND'. Use 'start', 'stop', 'status', or 'update'."
    usage
fi

# Validate stack
if [ "$STACK" != "all" ]; then
    if ! [[ " ${STACKS[*]} " =~ " $STACK " ]]; then
        echo "Error: Invalid stack '$STACK'. Available stacks: ${STACKS[*]} or 'all'"
        usage
    fi
fi

# Execute command
case "$COMMAND" in
    start)
        if [ "$STACK" == "all" ]; then
            start_all
        else
            start_stack "$STACK"
        fi
        ;;
    stop)
        if [ "$STACK" == "all" ]; then
            stop_all
        else
            stop_stack "$STACK"
        fi
        ;;
    status)
        if [ "$STACK" == "all" ]; then
            status_all
        else
            status_stack "$STACK"
        fi
        ;;
    update)
        if [ "$STACK" == "all" ]; then
            update_all
        else
            update_stack "$STACK"
        fi
        ;;

    *)
        echo "Error: Invalid command '$COMMAND'"
        usage
        ;;
esac
