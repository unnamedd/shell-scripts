#!/bin/bash

organization="zewo"
repository="zewo"

read -p "Username: " githubusername
read -s -p "Password: " githubpassword

userpassword="${githubusername}:${githubpassword}"

printf "\n################################################\n"

create_issue () {
	printf "\nCreating issue..."
	if http --json \
			--ignore-stdin \
			--auth $userpassword \
			--auth-type basic \
			--check-status \
			POST \
			https://api.github.com/repos/$organization/$repository/issues \
			title="$title" \
			labels:='["help wanted","task"]' \
			&> /dev/null; then
				
		printf " - Created issue: $title" 
	else
		case $? in
			2) printf '\nRequest timed out!' ;;
			3) printf '\nUnexpected HTTP 3xx Redirection!' ;;
			4) printf '\nHTTP 4xx Client Error!' ;;
			5) printf '\nHTTP 5xx Server Error!' ;;
			*) printf '\nOther Error!' ;;
		    esac
	fi
}

check_command() {
	type $1 >/dev/null 2>&1 || {
		return 1
	}
	return 0
}

for i in $(ls -d */); do 
	cd ${i%%/};
	
	if [ ! -f "README.md" ]; then
		
		folder=$i
		replace=""
		name=${folder/\//$replace}
		title="Create README for repo $name"
		
		if [[ ! $name = "zewo.github.io" && ! $name = "Zewo" ]]; then
			create_issue $title
		fi
	fi
	
	cd ..
done
	
