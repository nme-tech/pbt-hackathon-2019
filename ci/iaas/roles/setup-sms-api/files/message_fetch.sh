#!/bin/bash
MESSAGE_ID=$1
BASE_URL='https://api.twilio.com'

source .env

wget -q --user ${TWILIO_ACCOUNT_SID} --password ${TWILIO_AUTH_TOKEN} \
  ${BASE_URL}/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json -O Messages.json

json2yaml ./Messages.json > Messages.yml
rm -f Messages.json

i=0
TOTAL_RECORDS=`cat Messages.yml | shyaml get-length messages`

while [ $i -lt $TOTAL_RECORDS ]; do
  CREATED=`env TZ=America/New_York date`
  MSID=`cat Messages.yml | shyaml get-value messages.${i}.sid`
  MTYPE=`cat Messages.yml | shyaml get-value messages.${i}.direction`

  echo "" >> messages.log
  echo "Processing $MSID" >> messages.log

  if [[ "$MTYPE" == "outbound-api" ]] || [[ "$MTYPE" == "outbound-reply" ]]; then
    echo "Found message for deletion: $MSID Reason: $MTYPE" >> messages.log
  elif [[ "$MTYPE" == "inbound" ]]; then
    MSOURCE=`cat Messages.yml | shyaml get-value messages.${i}.from`
    NUM_MEDIA=`cat Messages.yml | shyaml get-value messages.${i}.num_media`
    echo "Message received from: $MSOURCE" >> messages.log

    if [[ "$NUM_MEDIA" == "0" ]]; then
      MBODY=`cat Messages.yml | shyaml get-value messages.${i}.body`
      echo "Text: $MBODY" >> messages.log

      curl -X POST ${BASE_URL}/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json \
        --data-urlencode "Body=Please submit a picture of the incident to start a work order request" \
        --data-urlencode "From=+15203415609" \
        --data-urlencode "To=${MSOURCE}" \
        -u ${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}

        curl -X DELETE ${BASE_URL}/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages/${MSID} \
         -u ${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}

    else
      MEDIA_JSON="${BASE_URL}/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages/${MSID}/Media.json"

      wget -q --user ${TWILIO_ACCOUNT_SID} --password ${TWILIO_AUTH_TOKEN} \
        ${MEDIA_JSON} -O media.json

      MEDIA_URL=`cat media.json | shyaml get-value media_list.0.uri | sed 's/.json//'`
      echo "Media URL found: ${BASE_URL}$MEDIA_URL" >> messages.log
      rm -f media.json

      curl -X POST ${BASE_URL}/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json \
        --data-urlencode "Body=Thank you for submitting a work order request to PBC311. Please tell me a little more about the project. https://pbc311.hackathon2019.nmetech.com/" \
        --data-urlencode "From=+15203415609" \
        --data-urlencode "To=${MSOURCE}" \
        -u ${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN} >> messages.log

      # TODO: fix postgres command
      # echo "INSERT INTO pbc311 (task, photo_id) VALUES ('${MEDIA_URL}');" | \
      #   psql -h pbc311-db.hackathon2019.nmetech.com -U pgadmin -u pbc311
    fi
    echo "Message $i processed." >> messages.log
    #curl -X DELETE ${BASE_URL}/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages/${MSID} \
    #  -u ${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}

  fi
  ((i++))
done

rm -f Messages.yml
