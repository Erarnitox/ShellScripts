#!/bin/sh

UA="Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"

while :
do
USERNAME='login:user'$((RANDOM%100000000+1))
PASSWORD='passwod:'$((RANDOM%10000000+1))
echo "Username: "$USERNAME" Password: "$PASSWORD
torsocks curl -d $USERNAME -d $PASSWORD -X POST https://dlscordnitro.ru.com/db/checkIsNew.php
done
