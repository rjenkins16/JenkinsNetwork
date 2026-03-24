#!/bin/bash

# Stack Status Script
# Displays the status of all your stacks

STACKS=(
    "network"
    "storage"
    "media"
    "monitoring"
    "Arr Stack"
)

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "         JenkinsNetwork Stack Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for stack in "${STACKS[@]}"; do
    echo "📦 $stack"

    if [ -d "$CURRENT_DIR/$stack" ]; then
        cd "$CURRENT_DIR/$stack"

        if docker-compose ps >/dev/null 2>&1; then
            containers=$(docker-compose ps -q 2>/dev/null | wc -l)
            running=$(docker-compose ps -q 2>/dev/null | xargs -r docker inspect --format='{{.State.Status}}' 2>/dev/null | grep -c "running" || echo 0)
            stopped=$(docker-compose ps -q 2>/dev/null | xargs -r docker inspect --format='{{.State.Status}}' 2>/dev/null | grep -c "exited" || echo 0)

            if [ "$containers" -gt 0 ]; then
                echo "   Containers: $running running, $stopped stopped, $containers total"
                docker-compose ps --services --format "table {{.Name}}\t{{.Status}}" 2>/dev/null | tail -n +2
            else
                echo "   No containers found"
            fi
        elif docker compose ps >/dev/null 2>&1; then
            containers=$(docker compose ps -q 2>/dev/null | wc -l)
            running=$(docker compose ps -q 2>/dev/null | xargs -r docker inspect --format='{{.State.Status}}' 2>/dev/null | grep -c "running" || echo 0)
            stopped=$(docker compose ps -q 2>/dev/null | xargs -r docker inspect --format='{{.State.Status}}' 2>/dev/null | grep -c "exited" || echo 0)

            if [ "$containers" -gt 0 ]; then
                echo "   Containers: $running running, $stopped stopped, $containers total"
                docker compose ps --services --format "table {{.Name}}\t{{.Status}}" 2>/dev/null | tail -n +2
            else
                echo "   No containers found"
            fi
        else
            echo "   Error: Could not determine status"
        fi
    else
        echo "   ❌ Stack directory not found"
    fi

    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "To manage stacks, use: ./start.sh [stack] [action]"
echo "Actions: start, stop, restart, status"
echo "Examples:"
echo "  ./start.sh all start"
echo "  ./start.sh media status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"