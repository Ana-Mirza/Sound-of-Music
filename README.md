# Sound-of-Music🪇

This project contains a Script that teaches WSL-2 how to play different tunes.
If you want to give it a try, make sure you are running it in a wsl environment and you installed the dependencies.

## Dependencies🎭
```console
$ sudo ./staff.sh
```

## Run🥁
```console
$ ./play.sh
```

## Scheduling rehearsals ↳ ↰
If you want to set a schedule for WSL to rehearse a tune, check examples at this link: https://crontab.guru/examples.html

The rehearsals are set in the backstage using the UNIX cron job scheduler. Our job will run periodically a script that plays a tune. All rehearsal scripts are located in the *rehearsal/* folder.

## End schedule📌
To end a schedule setup, use the ID returned at the end by *play.sh*.The following command will display all the schedules.

```console
$ crontab -l
```

### Option 1
Simply use the script provided with the tune ID you want to end.

```console
$ ./end_schedule.sh <id>
```

### Option 2
Delete manually by editing the crontab file and deleting the line with the tune ID, then, delete the rehearsal script.

```console
$ crontab -e # enters the crontab file in edit mode and delete job
$ rm rehearsals/rehearse_tune_<id>
```
