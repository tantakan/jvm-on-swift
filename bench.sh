#/bin/bash

echo "Prepare for benchmark..."
swift build
echo "Done"
echo "---"

echo "### JVM on Swift"
echo "time .build/debug/jvm-on-swift Sample/Hello.class"
time .build/debug/jvm-on-swift Sample/Hello.class
echo "---"

echo "### JVM"
echo "(cd examples && time java Hello.class)"
(cd Sample && time java Hello)
echo "---"
