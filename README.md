# hutvPlaylistGenerators
This scripts generate m3u file whitch contains hu tv channels. It can be use in Kodi media player.

### Windows

Text editor: set path where to save the *.m3u:
> $path = "C:\";

Text editor: set filename
> $fileName = "mtva";

Powershell run in administrator mode set this if security policy not allow execution:
> Set-ExecutionPolicy RemoteSigned

Powershell run in administrator mode:
> ./generate_hu_tv_channels.ps1

Play in Kodi.

### Linux

Text editor: set filename
> $fileName = "mtva"

Run in terminal if bash not default:
> bash ./generate_hu_tv_channels.sh

Play in Kodi.
