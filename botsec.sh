#!/bin/bash
TOKEN='1322235264:AAE7QI-f1GtAF_huVz8E5IBdb5JbWIIiGKI'
MSG_URL='https://api.telegram.org/bot'$TOKEN'/sendMessage'
ID_MSG='1121093080'

send_message ()
{
  res=$(curl -s -X POST $MSG_URL -d chat_id=$ID_MSG -d text=$2 &)
}

who > /tmp/.ccw #сохраняем во временный файл результат
while true; do {
    gg=$(who) #получаем список сессий
    master=$(cat /tmp/.ccw | wc -l) #считаем количество строк у временного файла
    slave=$(echo "${gg}" | wc -l) #считаем количество строк текущих сессий
    if [[ "$master" != "$slave" ]] #если количество строк не равно, то отправляем сообщение
    then
        for id in $ID_MSG
    do
      send_message $id "$(hostname) $(hostname -I) ${gg}"
    done
        #> /tmp/.ccw
        echo "${gg}" > /tmp/.ccw #сохраняем во временный файл, для последущего сравнения
    fi
    sleep 5
}; done
