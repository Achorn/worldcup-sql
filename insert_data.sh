#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# delete entire database TRUNCATE
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then

    # check if winner is not in table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams where name = '$WINNER'")
    #if team id doesnt exist
    if [[ -z $WINNER_ID ]]
      then 
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then 
          echo inserted $WINNER into table
        fi
        WINNER_ID=$($PSQL "SELECT team_id FROM teams where name = '$WINNER'")

    fi

    # ADD OPPONENT
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name = '$OPPONENT'")
    #if team id doesnt exist
    if [[ -z $OPPONENT_ID ]]
      then 
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name = '$OPPONENT'")

        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then 
          echo inserted $WINNER into table
        fi
    fi

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values( $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )")
    if [[ ISNERT_GAME_RESULT='INSERT 0 1' ]]
    then 
    echo Inserted game: $WINNER VS $OPPONENT
    fi

  fi
done