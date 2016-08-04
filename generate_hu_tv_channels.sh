 #!/bin/bash

greeting="Hungarian TV channel generator"
echo $greeting
#settings
#set filename
fileName="mtva"

#variables
channels=("mtv1live" "mtv2live" "mtv4live" "dunalive" "dunaworldlive")
channelsName=("M1" "M2" "M4" "Duna" "Duna World")
#resolution is 5 -> {0..4}
resolutionName=("720p" "480p" "360p" "270p" "180p")
baseUrl="http://player.mediaklikk.hu/player/player-inside-full3.php?userid=mtva&streamid="
urlEnd="&flashmajor=22&flashminor=0"
urls=()
links=()
content="#EXTM3U\n"
file="$fileName.m3u"

#generate  urls
for channel in ${channels[@]};
do
  urls+=($baseUrl$channel$urlEnd)
done
#fetch response
for url in ${urls[@]};
do
  response=$(curl -s $url)
  begin=$((`expr "$response" : '.*http:\/\/c'` - 8))
  end=`expr "$response" : '.*index\.m3u8'`
  length=$(($end - $begin - 10))
  links+=(${response:$begin:$length}0)
done
#write out to file
var=0
for link in ${links[@]};
do
  for i in {0..4};
  do
    content="$content#EXTINF:0,${channelsName[$var]} ${resolutionName[$i]}\n$link$(($i + 1)).m3u8\n"
  done
  var=$((var+1))
done

echo -e $content > $file

echo "done"
