# This Works is placed under the terms of the Copyright Less License,
# see file COPYRIGHT.CLL.  USE AT OWN RISK, ABSOLUTELY NO WARRANTY.

cd "`dirname "$0"`" || exit

sh0()
{
while read line; do echo "[TEST] $line"; done
}

sh1()
{
while read -r line; do echo "[TEST] $line"; done
}

sh2()
{
while read -r line; do echo "[TEST]" $line; done
}

sh3()
{
while read -r line; do echo "[TEST]" "$line"; done
}

sed1()
{
sed 's/^/[TEST] /'
}

awk1()
{
awk '{ print "[TEST] " $0 }'
}

awk2a()
{
awk -vT="[TEST] " '{ print T $0 }'
}

awk2b()
{
awk -vT="[TEST]" '{ print T " " $0 }'
}

awk2c()
{
awk -vT="[TEST]" 'BEGIN { T=T " "; } { print T $0 }'
}

awk3a()
{
T="[TEST] " awk '{ print ENVIRON["T"] $0 }'
}

awk3b()
{
T="[TEST]" awk '{ print ENVIRON["T"] " " $0 }'
}

awk3c()
{
T="[TEST]" awk 'BEGIN { T=ENVIRON["T"] " " } { print T $0 }'
}

perl1()
{
perl -ne 'print "[TEST] $_"'
}

# This is buffered and possibly not what you want
python1()
{
python -uSc 'import sys
for line in sys.stdin: print "[TEST]",line,'
}
 
python2()
{
python -uSc 'import sys
while 1:
 line = sys.stdin.readline()
 if not line: break
 print "[TEST]",line,'
}

# Example for a dynamic binary
# See https://github.com/hilbix/unbuffered/
bin1()
{
./unbuffered.dynamic -cp'[TEST] ' -q''
}

# Example for a static binary
bin2()
{
./unbuffered.static -cp'[TEST] ' -q''
}

loop()
{
for a in `seq "$1"`
do
	"$2" < "$INPUT"
done >/dev/null
}

run()
{
# Put sh last so it can be aborted, in case it is too slow
for r in bin1 bin2 perl1 python1 python2 awk1 awk2a awk2b awk2c awk3a awk3b awk3c sed1 sh0 sh1 sh2 sh3
do
	echo "run $r"
	time loop "$1" "$r"
done 2>&1
}

gen1()
{
seq "$1"
}

gen2()
{
seq "$1" | awk '{ print "the quick brown fox jumps over the lazy dog #" $0 }'
}

timing()
{
echo -n .
"gen$1" "$3" > "$INPUT"
echo -n o
sync
echo -n x
cat "$INPUT" >/dev/null
cat "$INPUT" >/dev/null
cat "$INPUT" >/dev/null
#run 1 >/dev/null
echo
run "$2" | awk -v L="$2*$1" '$1=="run" { script=$2 } $1=="user" { print $2 " " L " " script }'
}

check()
{
timing 1 "$@"
timing 2 "$@"
}

INPUT=/tmp/timing.input.tmp.$$
trap 'rm -f "$INPUT"' 0

check 10000 100
check 1000 1000
check 100 10000
check 10 100000

