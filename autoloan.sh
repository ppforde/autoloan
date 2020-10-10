# open a file for the data
exec 1>"loans.csv"

NUMBER_PERIODS=(24 36 48 60 72)

INTEREST_RATE=4.7

PRESENT_VALUE=25000

{
    echo "LOAN,TERM,RATE,DATE"

    IFS=,
    while [ $PRESENT_VALUE -lt 30000 ]; do

        for N in ${NUMBER_PERIODS[@]}; do

            echo "$PRESENT_VALUE,$N,$INTEREST_RATE,$(date +%Y-%m-%d) $(date +%H:%M:%S)"            

        done    

        PRESENT_VALUE=$((PRESENT_VALUE+1000))

    done
}
