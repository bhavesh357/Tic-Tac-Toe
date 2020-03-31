#!/bin/bash -x

#Constants
declare -a corner
declare -a sides

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
		if [[ "${board[$i]}" = "$currentPlayer" && "${board[$(($i+1))]}" = "$currentPlayer" && "${board[$(($i+2))]}" = "$currentPlayer" ]]
		then
			isWinner=1
		else
			if [[ "${board[$i]}" = "$currentPlayer" && "${board[$(($i+1))]}" = "$currentPlayer" ]]
			then
				nextMove=$(($i+2))
			fi
			if [[ "${board[$i]}" = "$currentPlayer" && "${board[$(($i+2))]}" = "$currentPlayer" ]]
			then
				nextMove=$(($i+1))
			fi
			if [[ "${board[$(($i+2))]}" = "$currentPlayer" && "${board[$(($i+1))]}" = "$currentPlayer" ]]
			then
				nextMove=$i
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
		else
			if [[ "${board[$i]}" = "$currentPlayer" && "${board[$(($i+3))]}" = "$currentPlayer" ]]
			then
				nextMove=$(($i+6))
			fi
			if [[ "${board[$i]}" = "$currentPlayer" && "${board[$(($i+6))]}" = "$currentPlayer" ]]
			then
				nextMove=$(($i+3))
			fi
			if [[ "${board[$(($i+3))]}" = "$currentPlayer" && "${board[$(($i+6))]}" = "$currentPlayer" ]]
			then
				nextMove=$i
			fi
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
	if [ $isWinner -eq 0 ]
	then
		if [[ "${board[1]}" = "$currentPlayer" && "${board[5]}" = "$currentPlayer" ]]
		then
			nextMove=9
		fi
		if [[ "${board[1]}" = "$currentPlayer" && "${board[9]}" = "$currentPlayer" ]]
		then
			nextMove=5
		fi
		if [[ "${board[5]}" = "$currentPlayer" && "${board[9]}" = "$currentPlayer" ]]
		then
			nextMove=1
		fi
		if [[ "${board[3]}" = "$currentPlayer" && "${board[5]}" = "$currentPlayer" ]]
		then
			nextMove=7
		fi
		if [[ "${board[3]}" = "$currentPlayer" && "${board[7]}" = "$currentPlayer" ]]
		then
			nextMove=5
		fi
		if [[ "${board[5]}" = "$currentPlayer" && "${board[7]}" = "$currentPlayer" ]]
		then
			nextMove=3
		fi
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
	nextMove=0
	checkRows "O"
	if [ $nextMove -eq 0 ]
	then
		checkColumns "O"
	fi
	if [ $nextMove -eq 0 ]
	then
		checkDiag "O"
	fi
	if [ $nextMove -eq 0 ]
	then
		checkRows "X"
	fi
	if [ $nextMove -eq 0 ]
	then
		checkColumns "X"
	fi
	if [ $nextMove -eq 0 ]
	then
		checkDiag "X"
	fi
	if [ $nextMove -eq 0 ]
	then
		for((l=0;l<4;l++))
		do
			if [ "${board[${corner[$l]}]}" = "_" ]
			then
				nextMove=${corner[$l]}
			fi
		done
	fi
	if [ $nextMove -eq 0 ]
	then
		if [ "${board[5]}" = "_" ]
		then
			nextMove=5
		fi
	fi
	if [ $nextMove -eq 0 ]
	then
		for((m=0;m<4;m++))
		do
			if [ "${board[${sides[$m]}]}" = "_" ]
			then
				nextMove=${sides[$m]}
			fi
		done
	fi
	board[$nextMove]="O"
}

echo "Welcome to Tic Tac Toe"
resetBoard
corner[0]=1
corner[1]=3
corner[2]=7
corner[3]=9
sides[0]=2
sides[1]=4
sides[2]=6
sides[3]=8
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
		check $p
	fi
done