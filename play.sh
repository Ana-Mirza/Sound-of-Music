#!/bin/bash

set -e

###### Constants ######
schedule_pattern="^((((\d+,)+\d+|(\d+(\/|-|#)\d+)|\d+L?|\*(\/\d+)?|L(-\d+)?|\?|[A-Z]{3}(-[A-Z]{3})?) ?){5,7})$"
schedule_file="/var/spool/cron/crontabs/$USER"
ID=$RANDOM

#######################


# Get tune
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

# Rehearse options
read -s -p "Do you want to rehearse the tune? (y/n)" rehearse
echo ""

if [ "$rehearse" = "y" ]; then
	echo "UNIX crontab format: * * * * *" 
	read -p "Enter schedule: " schedule
fi

# Check rehearse option
if [[ "$schedule" =~ $schedule_pattern ]]; then
	echo $schedule
else
	echo "Invalid schedule, see README.md for examples!"
	rehearse="n"
fi

# Create directory for tune files
if [ ! -d ../tunes ]; then 
	mkdir ../tunes
fi

if [ ! -d ./rehearsals ]; then
	mkdir rehearsals
fi


# Get tune desired
wget https://assets.mixkit.co/active_storage/sfx/$file/$file.wav
mv $file.wav ../tunes/

file_path=$(realpath ../tunes/\$file.wav)

# Create rehearsing script
echo "#!/bin/bash

file=$file

play_tune() {
file_path=$file_path
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c \"(New-Object Media.SoundPlayer '\$file_path').PlaySync()\"
}

play_tune 2> error.log
exit_code=\$?

# check for format errors
if [ \$exit_code -ne 0 ]; then
        echo \"An error occurred.\"

        error=\$(cat error.log)
        if [[ \$error =~ \"only supports playing PCM wave files\" ]]; then
                echo \"It's there!\"
                ffmpeg -i ../tunes/\$file.wav -acodec pcm_s16le -ar 44100 -ac 2 ../tunes/converted_\$file.wav -y

                # try running again
                new_file=converted_\$file
		mv ../tunes/\$new_file.wav ../tunes/\$file.wav
                play_tune 2> error.log
        fi
fi
" > ./rehearsals/rehearse_tune_$ID.sh
chmod +x rehearsals/rehearse_tune_$ID.sh

# Play tune
./rehearsals/rehearse_tune_$ID.sh

# Set up schedule
if [ "$rehearse" = "y" ]; then
	(crontab -l 2>/dev/null; echo "$schedule $(pwd)/rehearsals/rehearse_tune_$ID.sh") | crontab -
	echo ""; echo "Your tune ID is: $ID"
else
	rm rehearsals/rehearse_tune_$ID.sh
	rm ../tunes/$file.wav
fi

