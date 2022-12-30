#!/bin/bash
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ "$1" =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
else
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE (symbol = '$1' OR name = '$1')")
fi

if [[ -z $ELEMENT ]]
then
  echo I could not find that element in the database.
else
  echo $ELEMENT | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELT BAR BOIL BAR TYPE_ID
  do
  echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
fi
