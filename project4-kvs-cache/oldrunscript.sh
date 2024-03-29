#!/bin/bash

# buggy but mimics human input
# runscript cuz I don't want to type commands every time I want to test ./client

client_commands=(
  "SET file1.txt hey"
  "SET file2.txt hello"
  "SET file3.txt hi"
  "SET file4.txt bye"
  "GET file1.txt"
  "GET file2.txt"
  "GET file3.txt"
  "GET file4.txt"
)

commands=(
  "make clean"
  "make"
)

client_start_command="./client data CLOCK 3"

runCommand() {
  echo "💦 runscript.sh: Running $1"
  bash -c "$1"
  echo ""
}

for cmd in "${commands[@]}"; do
  runCommand "$cmd"
done

echo "$client_start_command"

coproc CLIENT_PROCESS { stdbuf -o0 $client_start_command; }

for client_cmd in "${client_commands[@]}"; do
  echo "$client_cmd"
  echo "$client_cmd" >&"${CLIENT_PROCESS[1]}"
  read -r output <&"${CLIENT_PROCESS[0]}"
  echo "$output"
done

exec {CLIENT_PROCESS[1]}>&-

while read -r output <&"${CLIENT_PROCESS[0]}"; do
  echo "$output"
done

wait "${CLIENT_PROCESS_PID}"
