#!/bin/bash

#Constants
BOARD_SIZE=9
NUMBER_OF_PLAYERS=2
SIZE_OF_SIDES_AND_CORNERS=4

#Variables
declare -a corner
declare -a sides
declare -a board[0]=0
declare -a players
isWinner=0
isTie=0
nextMove=0
declare computerSign
declare playerSign


function resetBoard() {
	for((i=1;i<=$BOARD_SIZE;i++))
	do
		board[i]="_"
	done
}

function getRandom() {
	echo $(($RANDOM%2))
}

function toss() {
	tossResult=$( getRandom )
	if [ $tossResult -eq 0 ]
	then
		echo "You will play first"
		players[0]=$playerSign
		players[1]=$computerSign
	else
		echo "You will play second"
		players[0]=$computerSign
		players[1]=$playerSign
	fi
}

function showBoard() {
	for((i=1;i<=$BOARD_SIZE;i+=3))
	do
		echo ${board[$i]} ${board[$(($i+1))]} ${board[$(($i+2))]}
	done
}

function checkRowsAndColumns() {
	currentPlayer=$1
	incrementBy=$2
	nextBoard=$3
	nextToNextBoard=$(($nextBoard*2))
	c=1
	while [ $c -le $BOARD_SIZE ]
	do
		if [[ "${board[$c]}" = "$currentPlayer" && "${board[$(($c+$nextBoard))]}" = "$currentPlayer" && "${board[$(($c+$nextToNextBoard))]}" = "$currentPlayer" ]]
		then
			isWinner=1
		else
			if [[ "${board[$c]}" = "$currentPlayer" && "${board[$(($c+$nextBoard))]}" = "$currentPlayer" && "${board[$(($c+$nextToNextBoard))]}" = "_" ]]
			then
				nextMove=$(($c+$nextToNextBoard))
			fi
			if [[ "${board[$c]}" = "$currentPlayer" && "${board[$(($c+$nextToNextBoard))]}" = "$currentPlayer" && "${board[$(($c+$nextBoard))]}" = "_" ]]
			then
				nextMove=$(($c+$nextBoard))
			fi
			if [[ "${board[$(($c+$nextBoard))]}" = "$currentPlayer" && "${board[$(($c+$nextToNextBoard))]}" = "$currentPlayer" && "${board[$c]}" = "_" ]]
			then
				nextMove=$c
			fi
		fi
		c=$(($c+$incrementBy))
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
		if [[ "${board[1]}" = "$currentPlayer" && "${board[5]}" = "$currentPlayer" && "${board[9]}" = "_" ]]
		then
			nextMove=9
		fi
		if [[ "${board[1]}" = "$currentPlayer" && "${board[9]}" = "$currentPlayer" && "${board[5]}" = "_" ]]
		then
			nextMove=5
		fi
		if [[ "${board[5]}" = "$currentPlayer" && "${board[9]}" = "$currentPlayer" && "${board[1]}" = "_" ]]
		then
			nextMove=1
		fi
		if [[ "${board[3]}" = "$currentPlayer" && "${board[5]}" = "$currentPlayer" && "${board[7]}" = "_" ]]
		then
			nextMove=7
		fi
		if [[ "${board[3]}" = "$currentPlayer" && "${board[7]}" = "$currentPlayer" && "${board[5]}" = "_" ]]
		then
			nextMove=5
		fi
		if [[ "${board[5]}" = "$currentPlayer" && "${board[7]}" = "$currentPlayer" && "${board[3]}" = "_" ]]
		then
			nextMove=3
		fi
	fi
}

function checkIfWinner() {
	winningPlayer=$1
	checkRowsAndColumns $winningPlayer 3 1
	if [ $isWinner -eq 0 ]
	then
		checkRowsAndColumns $winningPlayer 1 3
	fi
	if [ $isWinner -eq 0 ]
	then
		checkDiag $winningPlayer
	fi
}

function checkIfTie() {
	isTie=1
	for((k=1;k<=$BOARD_SIZE;k++))
	do
		if [ "${board[k]}" = "_" ]
		then
			isTie=0
		fi
	done
	if [ $isTie -eq 1 ]
	then
		showBoard
		echo it was a tie
	fi
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
		showBoard
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
		else
			if [[ "${board[$input]}" = "X" || "${board[$input]}" = "O" ]]
			then
				echo "that place is already taken. Try other place"
			else
				echo "Enter valid input"
			fi
		fi
	done
	board[$input]=$playerSign
}

function checkForPlayer() {
	playerToCheckFor=$1
	if [ $nextMove -eq 0 ]
	then
		checkRowsAndColumns $playerToCheckFor 3 1
	fi
	if [ $nextMove -eq 0 ]
	then
		checkRowsAndColumns $playerToCheckFor 1 3
	fi
	if [ $nextMove -eq 0 ]
	then
		checkDiag $playerToCheckFor
	fi
}

function checkCornersAndSides() {
	isCorner=$1
	if [ $nextMove -eq 0 ]
	then
		for((l=0;l<$SIZE_OF_SIDES_AND_CORNERS;l++))
		do
			if [ $isCorner -eq 1 ]
			then
				if [ "${board[${corner[$l]}]}" = "_" ]
				then
					nextMove=${corner[$l]}
				fi
			else
				if [ "${board[${sides[$l]}]}" = "_" ]
				then
					nextMove=${sides[$l]}
				fi
			fi
		done
	fi
}

function checkCenter() {
	if [ $nextMove -eq 0 ]
	then
		if [ "${board[5]}" = "_" ]
		then
			nextMove=5
		fi
	fi
}

function getNextInput() {
	nextMove=0
	checkForPlayer $computerSign
	checkForPlayer $playerSign
	checkCornersAndSides 1
	checkCenter
	checkCornersAndSides 0
	board[$nextMove]=$computerSign
}

function assignSign() {
	if [ $( getRandom ) -eq 0 ]
	then
		computerSign="X"
		playerSign="O"
	else
		computerSign="O"
		playerSign="X"
	fi
	echo player your sign is $playerSign
	echo computer sign is $computerSign
}

function setCornersAndSides() {
	corner[0]=1
	corner[1]=3
	corner[2]=7
	corner[3]=9
	sides[0]=2
	sides[1]=4
	sides[2]=6
	sides[3]=8
}

function startPlaying() {
	j=0
	while [[ $isWinner -ne 1 && $isTie -ne 1 ]]
	do
		showBoard
		p=${players[$(($j%2))]}
		echo $p turn
		if [ $playerSign = "$p" ]
		then
			getInput
		else
			getNextInput
		fi
		check $p
		((j++))
	done
}
function main() {
	echo "Welcome to Tic Tac Toe"
	resetBoard
	setCornersAndSides
	assignSign
	toss
	startPlaying
}

main
