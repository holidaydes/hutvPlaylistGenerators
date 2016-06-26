# settings
$baseUrl = "http://player.mediaklikk.hu/player/player-inside-full3.php?userid=mtva&streamid=";
$baseUrlEnd = "&flashmajor=22&flashminor=0";
$channel = "mtv1live", "mtv2live", "mtv4live", "dunalive", "dunaworldlive";
$channelName = "M1", "M2", "M4", "Duna", "Duna World";
$urls = New-Object System.Collections.Generic.List[System.Object];
$type = "1", "2", "3", "4", "5";
$typeName = "720p","480p","360p","270p","180p";

$path = "C:\";

foreach($c in $channel) {
   $R = Invoke-WebRequest "$($baseUrl)$($c)";
   while($R.Content.IndexOf('c40') -lt 0) {
           $R = Invoke-WebRequest "$($baseUrl)$($c)$($baseUrlEnd)";
   }
   $start = $R.Content.IndexOf('http://c');
   $length = $R.Content.IndexOf('index.m3u8') - $start;
   $result = $R.Content.Substring($start, $length);
   $urls.Add($result);
}

$fileContent = New-Object System.Collections.Generic.List[System.Object];

for($i = 0; $i -lt $urls.Count; $i++) {

    for($j = 0; $j -lt $type.length; $j++) {
        $fileContent.Add("#EXTINF:0,$($channelName[$i]) $($typeName[$j])");
        $fileContent.Add("$($urls[$i])0$($type[$j]).m3u8");
    }

}

$stream = [System.IO.StreamWriter] "$($path)mtv.m3u";

$stream.WriteLine("#EXTM3U");

foreach($content in $fileContent) {
    $stream.WriteLine($content);
}

$stream.close();

echo "Done";