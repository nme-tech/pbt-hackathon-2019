#!/bin/bash

cat >/tmp/email.txt <<EOL
Subject: [PBC-311] Dispatch Report - ${REPORT_TEXT}

A new work order has been dispatched.

The location is ${REPORT_LOC}
Reported by ${REPORT_POC}

Thank you!
EOL


sendmail ${PBC_WORKER}  < /tmp/email.txt
