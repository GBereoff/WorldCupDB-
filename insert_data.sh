#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#TRUNCATE tables 
echo $($PSQL "TRUNCATE TABLE games, teams")

#INSERT data into tables
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #check if its a header
  if [[ $YEAR != 'year' ]]
  then
    #get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    #insert winner if not in table
    if [[ -z $WINNER_ID ]]
    then
      WINNER_ID=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER') ")
      echo "Inserted $WINNER"

      #get new winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi

    #get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_ID=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT') ")
      echo "Inserted $OPPONENT"

      #get new opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi

    #insert game
    GAME_INSERTION_ID=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS) ")

    echo "Inserted game between $WINNER and $OPPONENT"

  fi

done