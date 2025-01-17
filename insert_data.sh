#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != year ]]
  then
    CHECK_TEAM=$($PSQL "select name from teams where name = '$winner'")
    if [[ -z $CHECK_TEAM ]]
    then
      INSERT_TEAM=$($PSQL "insert into teams(name) values('$winner')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then 
        echo Inserted Team $winner
      fi
    fi
    CHECK_TEAM=$($PSQL "select name from teams where name = '$opponent'")
    if [[ -z $CHECK_TEAM ]]
    then
      INSERT_TEAM=$($PSQL "insert into teams(name) values('$opponent')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then 
        echo Inserted Team $opponent
      fi
    fi
    winner_id=$($PSQL "select team_id from teams where name = '$winner';")
    opponent_id=$($PSQL "select team_id from teams where name = '$opponent';")
    Insert_Game=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);")
    echo "Inserted Game of $year - Round '$round' held between '$winner' ($winner_goals) and '$opponent' ($opponent_goals)"
  fi
done
