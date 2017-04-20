# settings
# set the path where to save the *.m3u
$path = "C:\";
# set filename
$fileName = "mtva";

# variables (do not modify it)
$baseUrl = "http://player.mediaklikk.hu/player/player-inside-full3.php?userid=mtva&streamid=";
$baseUrlEnd = "&noflash=yes";
$channel = "mtv1live", "mtv2live", "mtv4live", "mtv5live", "dunalive", "dunaworldlive";
$channelName = "M1", "M2", "M4", "M5", "Duna", "Duna World";
$urls = New-Object System.Collections.Generic.List[System.Object];
$type = "1", "2", "3", "4", "5";
$typeName = "720p","480p","360p","270p","180p";
# $typeM3u = "VID_1280x720_HUN","VID_854x480_HUN","VID_640x360_HUN","VID_480x270_HUN","VID_320x180_HUN";
$typeM3u = "01","02","03","04","05";

echo "Hungarian TV channel generator";

foreach($c in $channel) {
   $url = "$($baseUrl)$($c)$($baseUrlEnd)";
   $R = Invoke-WebRequest "$($baseUrl)$($c)$($baseUrlEnd)" -UseBasicParsing;
   while($R.Content.IndexOf('http://c') -lt 0) {
           $R = Invoke-WebRequest "$($baseUrl)$($c)$($baseUrlEnd)";
   }
   $start = $R.Content.IndexOf('http:\/\/c');
   $length = $R.Content.IndexOf('index.m3u8') - $start;
   $result = $R.Content.Substring($start, $length).replace('\/','/');
   $urls.Add($result);
}

$fileContent = New-Object System.Collections.Generic.List[System.Object];

for($i = 0; $i -lt $urls.Count; $i++) {

    for($j = 0; $j -lt $type.length; $j++) {
        $fileContent.Add("#EXTINF:0,$($channelName[$i]) $($typeName[$j])");
        $fileContent.Add("$($urls[$i])$($typeM3u[$j]).m3u8");
    }

}

$stream = [System.IO.StreamWriter] "$($path)$($fileName).m3u";

$stream.WriteLine("#EXTM3U");

foreach($content in $fileContent) {
    $stream.WriteLine($content);
}

$stream.close();

echo "Done";
