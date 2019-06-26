echo -n Password:
read -s password

echo 

tmp=$(echo $password | shasum | cut -c1-30)
printf "C$tmp!" | pbcopy


