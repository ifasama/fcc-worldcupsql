#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPO WINGO OPGO
do
 if [[ $WINNER != "winner" ]]
 then
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name=('$WINNER')")
  
  if [[ -z $TEAM_ID ]]
  then
   INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
   
   if [[ $INSERT_TEAM == "INSERT 0 1" ]]
   then
    echo Inserted, $WINNER
   fi
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name=('$WINNER')")
  fi
 fi
 
 if [[ $OPPO != "opponent" ]]
 then
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name=('$OPPO')")
  
  if [[ -z $TEAM_ID ]]
  then
   INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPO')")
   
   if [[ $INSERT_TEAM == "INSERT 0 1" ]]
   then
    echo Inserted, $OPPO
   fi
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name=('$OPPO')")
  fi
 fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPO WINGO OPGO
do
if [[ $YEAR != "year" ]]
 then
   WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPO'")

  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OP_ID, $WINGO, $OPGO)")
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then
  echo Inserted, $YEAR $ROUND $WIN_ID $OP_ID
  fi
fi
done
