# This script is used to solve the problem that perf output <not counted>
# in a while loop, if we find a <not counted>, delete this line and -1 line if odd line; delete this line and +1 line if even line

echo "This script is used to solve the problem that perf output <not counted>"

filename="redis_curve.reporter.perf_counters"
echo filename = $filename

while true;
do
    numlines=`grep -rIn "<not counted>" $filename | wc | awk '{print $1}'`;
    if (( numlines > 0)) 
    then
        firstline=`grep -rIn "<not counted>" $filename | head -n 1 | awk -F":" '{print $1}'`;
        if (( firstline % 2 == 1)) 
        then
            # odd line, delete firstline and firstline-1
            otherline=$(( $firstline-1 ))
            echo "odd line, "$firstline", "$otherline
            sed -i "${otherline},${firstline}d" $filename
        else
            # even line, delete firstline and firstline+1
            #echo "even line, "$firstline
            otherline=$(( $firstline+1 ))
            echo "even line, "$firstline", "$otherline
            sed -i "${firstline},${otherline}d" $filename
        fi
    else
        break
    fi
    #break
done

