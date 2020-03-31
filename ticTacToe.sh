#!/bin/bash 

#Variables
declare -a board[0]=0
declare -a players
isWinner=0
isTie=0
nextMove=0

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

function checkRows() {
	currentPlayer=$1
	for((i=1;i<10;i+=3))
	do
		if [ "${board[$i]}" = "$currentPlayer" ]
		then
			if [ "${board[$(($i+1))]}" = "$currentPlayer" ]
			then
				if [ "${board[$(($i+2))]}" = "$currentPlayer" ]
				then
					isWinner=1
				fi
			fi
		fi
	done
}

function checkColumns() {
	currentPlayer=$1
	for((i=1;i<10;i+=3))
	do
		if [[ "${board[$i]}" = "$currentPlayer" && "${board[$(($i+3))]}" = "$currentPlayer" && "${board[$(($i+6))]}" = "$currentPlayer" ]]
		then
			isWinner=1
		fi
	done
}

function checkDiag() {
	currentPlayer=$1
	if [[ "${board[1]}" = "$currentPlayer" && "${board[$((5))]}" = "$currentPlayer" && "${board[$((9))]}" = "$currentPlayer" ]]
	then
		isWinner=1
	fi
	if [[ "${board[3]}" = "$currentPlayer" && "${board[$((5))]}" = "$currentPlayer" && "${board[$((7))]}" = "$currentPlayer" ]]
	then
		isWinner=1
	fi
	
}

function checkIfWinner() {
	winningPlayer=$1
	checkRows $winningPlayer
	if [ $isWinner -eq 0 ]
	then 
		checkColumns $winningPlayer
	fi
	if [ $isWinner -eq 0 ]
	then 
		checkDiag $winningPlayer
	fi
}

function checkIfTie() {
	isTie=1
	for((k=1;k<10;k++))
	do
		if [ "${board[k]}" = "_" ]
		then
			isTie=0
		fi
	done
}

function check() {
	playerToCheck=$1
	if [ $isWinner -ne 1 ]
	then 
		checkIfWinner $playerToCheck
	fi
	if [ $isWinner -ne 1 ]
	then 
		checkIfTie
	else
		echo player $currentPlayer has won
	fi
}

function getInput() {
	rightInput=0
	while [ $rightInput -eq 0 ]
	do
		echo enter the number between 1-9 and empty position
		read input 
		if [ "${board[$input]}" = "_" ]
		then
			rightInput=1
		fi
	done
	board[$input]="X"
}

function getNextInput() {
	board[nextMove]="O"
}

echo "Welcome to Tic Tac Toe"
resetBoard
echo Your Letter is X
toss
for((j=0;j<12;j++))
do
	if [[ $isWinner -ne 1 && $isTie -ne 1 ]]
	then 
		showBoard
		p=${players[$(($j%2))]}
		echo $p turn
		if [ "X" = "$p" ]
		then
			getInput
		else
			getNextInput
		fi
		showBoard
		check $player
	fi
done