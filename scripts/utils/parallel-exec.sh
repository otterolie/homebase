#!/bin/bash
# ============================================================
# parallel-exec.sh - Run commands in parallel
# ============================================================

parallel_run() {
  local pids=()
  local failed=0

  # Start all commands in background
  for cmd in "$@"; do
    eval "$cmd" &
    pids+=($!)
  done

  # Wait for all jobs and track failures
  for pid in "${pids[@]}"; do
    if ! wait "$pid"; then
      ((failed++))
    fi
  done

  return $failed
}

# Run commands in parallel with a limit
parallel_run_limit() {
  local limit=$1
  shift
  local pids=()
  local failed=0

  for cmd in "$@"; do
    # Wait if we've hit the limit
    while [ ${#pids[@]} -ge $limit ]; do
      for i in "${!pids[@]}"; do
        if ! kill -0 "${pids[$i]}" 2>/dev/null; then
          wait "${pids[$i]}" || ((failed++))
          unset 'pids[$i]'
        fi
      done
      pids=("${pids[@]}")  # Re-index array
      sleep 0.1
    done

    # Start new command
    eval "$cmd" &
    pids+=($!)
  done

  # Wait for remaining jobs
  for pid in "${pids[@]}"; do
    wait "$pid" || ((failed++))
  done

  return $failed
}
