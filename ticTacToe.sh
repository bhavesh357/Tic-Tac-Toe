#!/bin/bash -x

#Variables
declare -a board[0]=0
declare -a players
isWinner=0

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

function showBoard() {
	for((i=1;i<10;i+=3))
	do
		echo ${board[$i]} ${board[$(($i+1))]} ${board[$(($i+2))]}  $i $(($i+1)) $(($i+2))
	done
}

function checkIfWinner() {
	winningPlayer=$1
	checkRows $winningPlayer
	if [ isWinner -eq 0 ]
	then 
		checkColumns $winningPlayer
	fi
	if [ isWinner -eq 0 ]
	then 
		checkDiag $winningPlayer
	fi
}

function check() {
	playerToCheck=$1
	checkIfWinner $playerToCheck
}

function getInput() {
	player=$1
	rightInput=0
	while [ $rightInput -eq 0 ]
	do
		echo enter the number between 1-9 and empty position
		read input 
		if [ ${board[$input]}="_" ]
		then
			rightInput=1
		fi
	done
	board[$input]=$1
	check $player
}

echo "Welcome to Tic Tac Toe"
resetBoard
echo Your Letter is X
toss
for((j=0;j<2;j++))
do
	showBoard
	p=${players[j]}
	getInput $p
	showBoard
done