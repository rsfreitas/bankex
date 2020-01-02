#!/bin/bash

#
# Description: The script to test the bankex API features from the client side.
# Author: Rodrigo Freitas
# Created at: Wed Dec 18 14:06:30 -03 2019
#

username=""
password=""
key=""
action=""
host="localhost"
port=4000
destination=""
amount=0
method_type="POST"
headers="-H \"Content-Type: application/json\""
auth=""
args=""
day=0
month=0
year=0
range=""

usage()
{
    echo "Usage: ./client.sh [OPTIONS]"
    echo "Client script to test/access server features."
    echo
    echo "Options:"
    echo -e " -a [amount]\t\tSets the value to transfer from one user to another or to withdraw from."
    echo -e " -d [destination]\tSets the destination user of a transfer."
    echo -e " -h, --help\t\tShows this help screen."
    echo -e " -H [host]\t\tSets the hostname/IP of the service."
    echo -e " -K [key]\t\tSets the authorization key."
    echo -e " -p [port]\t\tSets the service port on the server."
    echo -e " -P [password]\t\tSets the user password."
    echo -e " -U [username]\t\tSets the username."
    echo -e " -D [day]\t\tDay value for --statement option."
    echo -e " -M [month]\t\tMonth value for --statement option."
    echo -e " -Y [year]\t\tYear value for --statement option."
    echo -e " -R [range]\t\tRange value for --statement option."
    echo -e " --signup\t\tCreates a new account into the server."
    echo -e " --signin\t\tMakes login into an account."
    echo -e " --transfer\t\tTransfers values from an user to another."
    echo -e " --withdraw\t\tWithdraws values from an account."
    echo -e " --statement\t\tCreates a statement according to some predefined values."
    echo -e " --fullstatement\t\tCreates a complete database statement from all registered users."
    echo
    echo "Details:"
    echo
    echo "1 - The range option (-R) must receive its argument in the following format:"
    echo "    <start>-<end>"
    echo
    echo "    Example:"
    echo "    2-13"
    echo
}

while getopts a:d:hH:p:U:P:K:-:D:M:Y:R: opt; do
    case $opt in
        # Handle long options
        -)
            case "$OPTARG" in
                signup)
                    action="signup"
                    ;;

                signin)
                    action="signin"
                    ;;

                transfer)
                    action="transfer"
                    ;;

                withdraw)
                    action="withdraw"
                    ;;

                statement)
                    action="statement"
                    ;;

                fullstatement)
                    action="full-statement"
                    ;;

                help)
                    usage
                    exit 1
                    ;;

                *)
                    echo "unknown option --$OPTARG"
                    exit -1
                    ;;
            esac
            ;;

        a)
            amount=$OPTARG
            ;;

        d)
            destination=$OPTARG
            ;;

        H)
            host=$OPTARG
            ;;

        p)
            port=$OPTARG
            ;;

        h)
            usage
            exit 1
            ;;

        U)
            username=$OPTARG
            ;;

        P)
            password=$OPTARG
            ;;

        K)
            key=$OPTARG
            ;;

        D)
            day=$OPTARG
            ;;

        M)
            month=$OPTARG
            ;;

        Y)
            year=$OPTARG
            ;;

        R)
            range=$OPTARG
            ;;

        ?)
            echo "unsupported option"
            exit -1
            ;;
    esac
done

command -v curl --version >/dev/null 2>&1 || {
    echo "The curl tool is required to execute this script. Install it first."
    exit 1
}

if [ -z "$action" ]; then
    echo "no action was selected, aborting"
    exit -1
fi

case "$action" in
    "signup")
        if [ -z "$username" -o -z "$password" ]; then
            echo "both username and password must be used to signup a new account"
            exit 1
        fi

        curl -v -X $method_type "http://$host:$port/api/$action"    \
            -H "Content-Type: application/json"                     \
            --data '{"user":{"email":"'$username'","password":"'$password'"}}'
        ;;

    "signin")
        if [ -z "$username" -o -z "$password" ]; then
            echo "both username and password must be used to sign in into your account"
            exit 1
        fi

        curl -v -X $method_type "http://$host:$port/api/$action"    \
            -H "Content-Type: application/json"                     \
            --data '{"email":"'$username'","password":"'$password'"}'
        ;;

    "transfer")
        if [ -z "$destination" ]; then
            echo "a destination must be informed to transfer value to"
            exit 1
        fi

        if [ -z "$key" ]; then
            echo "no access key was provided for the transfer"
            exit 2
        fi

        curl -v -X $method_type "http://$host:$port/api/$action"    \
            -H "Content-Type: application/json"                     \
            -H "Authorization: Bearer $key"                         \
            --data '{"dest":"'$destination'","amount":'$amount'}'
        ;;

    "withdraw")
        if [ -z "$key" ]; then
            echo "no access key was provided for the withdraw"
            exit 1
        fi

        curl -v -X $method_type "http://$host:$port/api/$action"    \
            -H "Content-Type: application/json"                     \
            -H "Authorization: Bearer $key"                         \
            --data '{"amount":'$amount'}'
        ;;

    "statement")
        if [ -z "$key" ]; then
            echo "no access key was provided for the statement"
            exit 1
        fi

        if ! [ -z "$range" ]; then
            if [ $day -eq 0 -a $month -eq 0 ]; then
                if [ $year -eq 0 ]; then
                    echo "month range statements must have a valid year"
                    exit 2
                fi

                args=(--data-urlencode \"month_range=$range\" --data-urlencode \"year=$year\")
            else
                if [ $month -eq 0 -o $year -eq 0 ]; then
                    echo "day range statements must have month and year"
                    exit 2
                fi

                args=(--data-urlencode \"day_range=$range\" --data-urlencode \"month=$month\" --data-urlencode \"year=$year\")
            fi
        else
            if [ $day -eq 0 ]; then
                if [ $month -eq 0 -o $year -eq 0 ]; then
                    echo "monthly statements must have month and year"
                    exit 2
                fi

                args=(--data-urlencode \"month=$month\" --data-urlencode \"year=$year\")
            else
                if [ $day -eq 0 -o $month -eq 0 -o $year -eq 0 ]; then
                    echo "daily statements must have valid day, month and year"
                    exit 2
                fi

                args=(--data-urlencode \"day=$day\" --data-urlencode \"month=$month\" --data-urlencode \"year=$year\")
            fi
        fi

        method_type="GET"
        curl -v -X $method_type "http://$host:$port/api/$action"    \
            -H "Authorization: Bearer $key"                         \
            ${args[@]}
        ;;

    "full-statement")
        if [ -z "$key" ]; then
            echo "no access key was provided for the statement"
            exit 1
        fi

        method_type="GET"
        curl -v -X $method_type "http://$host:$port/api/$action"    \
            -H "Authorization: Bearer $key"
        ;;
esac

exit 0

