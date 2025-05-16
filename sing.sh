#!/bin/bash

set -e

# sound="USER INPUT"
echo "Sound available: baby_sneeze, retro_game, cartoon_sneeze"
read -p "Enter sound: " sound

if [ "$sound" = "baby_sneeze" ]; then
	file=2214
elif [ "$sound" = "retro_game" ]; then
	file=213
elif [ "$sound" = "cartoon_sneeze" ]; then
	file=747
else
	echo "Unknown sound effect"
	exit 1
fi



# Create directory for sound files
if [ ! -d ../sounds ]; then 
	mkdir ../sounds
fi


# Get sound desired
wget https://assets.mixkit.co/active_storage/sfx/$file/$file.wav
mv $file.wav ../sounds/


#echo "#!/bin/bash

#file_path=\$(wslpath -w ../sounds/$file.wav)
#/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c \"(New-Object Media.SoundPlayer '\$file_path').PlaySync()\"" > game_over.sh

echo "#!/bin/bash

file=$file

play_sound() {
file_path=\$(wslpath -w ../sounds/\$file.wav)
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c \"(New-Object Media.SoundPlayer '\$file_path').PlaySync()\" 2> error.log
}

play_sound
exit_code=\$?

# check for format errors
if [ \$exit_code -ne 0 ]; then
        echo \"An error occurred.\"

        error=\$(cat error.log)
        if [[ \$error =~ \"only supports playing PCM wave files\" ]]; then
                echo \"It's there!\"
                ffmpeg -i ../sounds/\$file.wav -acodec pcm_s16le -ar 44100 -ac 2 ../sounds/converted_\$file.wav -y

                # try running again
                old_file=\$file
                file=converted_\$old_file
                play_sound
        fi
        rm error.log
fi
" > game_over.sh

chmod +x game_over.sh

./game_over.sh
rm game_over.sh
