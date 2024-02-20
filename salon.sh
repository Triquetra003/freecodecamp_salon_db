#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"
CHOOSE_SERVICE() {
if [[ $1 ]]
then
  echo -e "\n$1"
fi
  
  SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")
  
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
do
   echo "$SERVICE_ID) $NAME"
done

  read SERVICE_ID_SELECTED
  
 READ_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
 if [[ -z $READ_SERVICE_ID ]]
 then
  CHOOSE_SERVICE "I could not find that service. What would you like today?"
 else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  READ_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your hair$READ_SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_TIME=$($PSQL "INSERT INTO appointments(customer_id,time,service_id) VALUES($CUSTOMER_ID,'$SERVICE_TIME',$SERVICE_ID_SELECTED)")
  echo -e "\nI have put you down for a$READ_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

 fi

}
CHOOSE_SERVICE
