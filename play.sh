#!/bin/bash

set -e

# tune="USER INPUT"
echo "🎼 Tunes available: baby_sneeze, retro_game, cartoon_sneeze, birds_chirping, dwarf_laugh, angelical_choir, medieval_orchestra"
read -p "Enter tune🎶: " tune

if [ "$tune" = "baby_sneeze" ]; then
	file=2214
elif [ "$tune" = "retro_game" ]; then
	file=213
elif [ "$tune" = "cartoon_sneeze" ]; then
	file=747
elif [ "$tune" = "birds_chirping" ]; then
	file=2472
elif [ "$tune" = "dwarf_laugh" ]; then
	file=2885
elif [ "$tune" = "angelical_choir" ]; then
	file=654
elif [ "$tune" = "medieval_orchestra" ]; then
	file=226
else
	echo "Please try again with one of the options available!🪗"
	exit 1
fi


# Create directory for tune files
if [ ! -d ../tunes ]; then 
	mkdir ../tunes
fi


# Get tune desired
wget https://assets.mixkit.co/active_storage/sfx/$file/$file.wav
mv $file.wav ../tunes/

echo "#!/bin/bash

file=$file

play_tune() {
file_path=\$(wslpath -w ../tunes/\$file.wav)
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c \"(New-Object Media.SoundPlayer '\$file_path').PlaySync()\" 2> error.log
}

play_tune
exit_code=\$?

# check for format errors
if [ \$exit_code -ne 0 ]; then
        echo \"An error occurred.\"

        error=\$(cat error.log)
        if [[ \$error =~ \"only supports playing PCM wave files\" ]]; then
                echo \"It's there!\"
                ffmpeg -i ../tunes/\$file.wav -acodec pcm_s16le -ar 44100 -ac 2 ../tunes/converted_\$file.wav -y

                # try running again
                old_file=\$file
                file=converted_\$old_file
                play_tune
		rm ../tunes/\$file.wav
        fi
fi
" > game_over.sh

chmod +x game_over.sh

# clean environment
./game_over.sh
rm game_over.sh
rm ../tunes/$file.wav
rm error.log

rm -r ../tunes
