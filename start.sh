#!/bin/bash

# JenkinsNetwork Master Startup Script
# Usage: ./start.sh [stack_name] [--all]
# Example: ./start.sh media --all

STACKS=(
    "network"
    "storage"
    "media"
    "monitoring"
    "Arr Stack"
)

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to display usage
usage() {
    echo "Usage: $0 [stack_name] [--all]"
    echo ""
    echo "Available stacks:"
    for stack in "${STACKS[@]}"; do
        echo "  - $stack"
    done
    echo ""
    echo "Examples:"
    echo "  $0 all              # Start all stacks"
    echo "  $0 media            # Start only media stack"
    echo "  $0 stop all         # Stop all stacks"
    echo "  $0 stop media       # Stop only media stack"
    exit 1
}

# Function to start a stack
start_stack() {
    local stack=$1

    # Check if stack directory exists
    if [ ! -d "$CURRENT_DIR/$stack" ]; then
        echo "❌ Stack '$stack' not found!"
        exit 1
    fi

    echo "🚀 Starting stack: $stack"
    cd "$CURRENT_DIR/$stack"

    # Try docker-compose first, then docker compose (v2)
    if docker-compose version >/dev/null 2>&1; then
        docker-compose up -d
    elif docker compose version >/dev/null 2>&1; then
        docker compose up -d
    else
        echo "❌ Neither docker-compose nor docker compose is available!"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Stack '$stack' started successfully"
    else
        echo "❌ Failed to start stack '$stack'"
        exit 1
    fi
}

# Function to stop a stack
stop_stack() {
    local stack=$1

    # Check if stack directory exists
    if [ ! -d "$CURRENT_DIR/$stack" ]; then
        echo "❌ Stack '$stack' not found!"
        exit 1
    fi

    echo "🛑 Stopping stack: $stack"
    cd "$CURRENT_DIR/$stack"

    # Try docker-compose first, then docker compose (v2)
    if docker-compose version >/dev/null 2>&1; then
        docker-compose down
    elif docker compose version >/dev/null 2>&1; then
        docker compose down
    else
        echo "❌ Neither docker-compose nor docker compose is available!"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Stack '$stack' stopped successfully"
    else
        echo "❌ Failed to stop stack '$stack'"
        exit 1
    fi
}

# Function to restart a stack
restart_stack() {
    local stack=$1

    stop_stack "$stack"
    sleep 2
    start_stack "$stack"
}

# Function to check stack status
check_status() {
    local stack=$1

    echo "📊 Checking status for: $stack"
    cd "$CURRENT_DIR/$stack"

    if docker-compose ps >/dev/null 2>&1; then
        docker-compose ps
    elif docker compose ps >/dev/null 2>&1; then
        docker compose ps
    fi
}

# Main logic
case "${1:-}" in
    all)
        case "${2:-}" in
            start|up)
                for stack in "${STACKS[@]}"; do
                    start_stack "$stack"
                done
                echo ""
                echo "🎉 All stacks started!"
                ;;
            stop|down)
                for stack in "${STACKS[@]}"; do
                    stop_stack "$stack"
                done
                echo ""
                echo "🎉 All stacks stopped!"
                ;;
            restart|reload)
                for stack in "${STACKS[@]}"; do
                    restart_stack "$stack"
                done
                echo ""
                echo "🎉 All stacks restarted!"
                ;;
            status)
                for stack in "${STACKS[@]}"; do
                    check_status "$stack"
                    echo ""
                done
                ;;
            *)
                usage
                ;;
        esac
        ;;

    start|up|stop|down|restart|reload|status)
        if [ "$1" = "status" ]; then
            check_status "$2"
        else
            case "${2:-}" in
                all)
                    restart_stack "$2" # reuse restart logic for all
                    ;;
                "")
                    usage
                    ;;
                *)
                    case "$1" in
                        start|up) start_stack "$2" ;;
                        stop|down) stop_stack "$2" ;;
                        restart|reload) restart_stack "$2" ;;
                    esac
                    ;;
            esac
        fi
        ;;

    *)
        usage
        ;;
esac