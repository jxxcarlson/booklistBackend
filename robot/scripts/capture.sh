color=`tput setaf 48`
reset=`tput setaf 7`

echo
echo "${color}Removing latest dump and capturing database at Heroku${reset}"
rm latest.dump
heroku pg:backups:capture

echo
echo "${color}Downloading backup${reset}"
heroku pg:backups:download

echo
echo "${color}Loading backup into local database${reset}"
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d book_list_dev latest.dump

echo
echo "${color}Done${reset}"
