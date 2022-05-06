#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

SERVICES_MENU() {
  # If an argument is passed to the function print it
  if [[ $1 ]]
  then
    echo -e $1
  fi

  # Query the database for the services.  Get the id and name of the service
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  
  # If there are services
  if [[ $AVAILABLE_SERVICES ]]
  then
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
      # Print the services out
      echo "$SERVICE_ID) $NAME"
    done
  fi

  # Ask for a service id
  echo -e "\nWhich service would you like?"
  read SERVICE_ID_SELECTED

  # If the service input is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # Return to the service menu
    SERVICES_MENU "I could not find that service. What would you like today?"
  else
    # Check the service input exists in the database of services
    SERVICE_ID_SEARCH=$($PSQL "SELECT service_id, name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    
    # If the service input does not exist in the database of service
    if [[ -z $SERVICE_ID_SEARCH ]]
    then
      # Return to the service menu
      SERVICES_MENU "I could not find that service. What would you like today?"
    else
      # Query for the selected services name 
      SERVICE_NAME=$(echo $SERVICE_ID_SEARCH | sed -E 's/[0-9]+ \| //')
      # Go to customer info 
      CUSTOMER_INFO $SERVICE_NAME $SERVICE_ID_SELECTED
    fi
  fi
}

CUSTOMER_INFO() {
  # Ask for a customer's phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # Query for the customer's name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # If customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # Ask for the customer's name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # Insert a new customer into the database
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi
  # Query for a customer's id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # Ask for the service time
  echo -e "\nWhat time would you like your $1, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # Insert a new appointment into the database
  INSERT_APP_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $2, '$SERVICE_TIME')") 
  echo -e "\nI have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICES_MENU "\nWelcome to My Salon, how can I help you?\n"
