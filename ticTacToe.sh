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

function toss() {
	t=$(($RANDOM%2))
	if [ $t -eq 0 ]
	then 
		echo "You will play first"
		players[0]="X"
		players[1]="O"
	else
		echo "You will play second"
		players[0]="O"
		players[1]="X"
	fi
}

echo "Welcome to Tic Tac Toe"
resetBoard
echo Your Letter is X
toss