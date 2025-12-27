#!/bin/bash
# Element lookup script for periodic table project

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if no argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Query the element by atomic_number, symbol, or name
ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p ON e.atomic_number=p.atomic_number
JOIN types t ON p.type_id=t.type_id
WHERE e.atomic_number='$1' OR e.symbol='$1' OR e.name='$1'")

# If element not found
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Parse the data
IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT"

# Output the information
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

