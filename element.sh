#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$1

# Check if ELEMENT is an integer (atomic_number)
if [[ $ELEMENT =~ ^[0-9]+$ ]]
then
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements e 
  JOIN properties p ON e.atomic_number = p.atomic_number 
  JOIN types t ON p.type_id = t.type_id
  WHERE e.atomic_number=$ELEMENT;")
else
  # Otherwise, check symbol or name
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
  FROM elements e 
  JOIN properties p ON e.atomic_number = p.atomic_number 
  JOIN types t ON p.type_id = t.type_id
  WHERE e.symbol='$ELEMENT' OR e.name='$ELEMENT';")
fi

# If not found
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Format output
echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
