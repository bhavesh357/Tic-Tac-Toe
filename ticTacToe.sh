#!/bin/bash -x

#Variables
declare -a board[0]=0
declare -a players

function resetBoard() {
	for((i=1;i<10;i++))
	do
		board[i]="_"
	done
}

echo "Welcome to Tic Tac Toe"
resetBoard
echo Your Letter is X