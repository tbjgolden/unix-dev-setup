# ask for username
# ask for access token

mkdir -p ~/Documents

function set_github_credentials
    if test -z $GITHUB_USERNAME
        set -U GITHUB_USERNAME (string trim (read -P 'github username'\n'» '))
    end

    if test -z $GITHUB_TOKEN
        set -U GITHUB_TOKEN (string trim (read -s -P 'github access token'\n'» '))
    end

    set ISAUTHED (curl -s -u $GITHUB_USERNAME':'$GITHUB_TOKEN "https://api.github.com/user" | jq '.total_private_repos')
end

set ISAUTHED (curl -s -u $GITHUB_USERNAME':'$GITHUB_TOKEN "https://api.github.com/user" | jq '.total_private_repos')
set_github_credentials
while test $ISAUTHED = "null"
    set_github_credentials
end

# Sets git email to github primary
if test -z $GITHUB_EMAIL
    set -U GITHUB_EMAIL (curl -s -u $GITHUB_USERNAME':'$GITHUB_TOKEN "https://api.github.com/user/emails" | jq -r ".[] | select(.primary == true) | .email")
end

# Sets git name to github name
if test -z $GITHUB_NAME
    set -U GITHUB_NAME (curl -u $GITHUB_USERNAME':'$GITHUB_TOKEN "https://api.github.com/user" | jq ".name")
end

# Updates git credentials to include access token
rm -f ~/.git-credentials
echo -n "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com" > ~/.git-credentials

# Updates configs with updated data
git config --global user.name $GITHUB_NAME
git config --global user.email $GITHUB_EMAIL
git config --global credential.helper store
git config --global pull.rebase false
git config --global init.defaultBranch main

# sync all repositories from the last 2 calendar years
rm -f ~/Documents/.repos.json
curl -s -u $GITHUB_USERNAME':'$GITHUB_TOKEN "https://api.github.com/user/repos?per_page=100&since="(echo (math (date +"%Y") - 2)'-01-01T00:00:01Z') | jq 'map({name,clone_url,private,fork})' >~/Documents/.repos.json

# filter out forks and split them into open and closed source
eval set PUBLIC_REPOS (echo (cat ~/Documents/.repos.json | jq -r 'map(select(.fork == false) | select(.private == false) | .clone_url) | @sh'))
eval set PRIVATE_REPOS (echo (cat ~/Documents/.repos.json | jq -r 'map(select(.fork == false) | select(.private == true) | .clone_url) | @sh'))

# clones any uncloned repos
mkdir -p ~/Documents/open
for PUBLIC_REPO in $PUBLIC_REPOS
  set -l frags (string split / $PUBLIC_REPO)
  if test (count $frags) -eq 5
    set -l username $frags[4]
    set -l repo_name (string sub -s 1 -l (math (string length $frags[5]) - 4) $frags[5])
    set full_path ~/Documents/open/$username/$repo_name
    mkdir -p ~/Documents/open/$username
    if not test -d $full_path
      git clone $PUBLIC_REPO $full_path
    end
  end
end
mkdir -p ~/Documents/closed
for PRIVATE_REPO in $PRIVATE_REPOS
  set -l frags (string split / $PRIVATE_REPO)
  if test (count $frags) -eq 5
    set -l username $frags[4]
    set -l repo_name (string sub -s 1 -l (math (string length $frags[5]) - 4) $frags[5])
    set full_path ~/Documents/closed/$username/$repo_name
    mkdir -p ~/Documents/closed/$username
    if not test -d $full_path
      git clone $PRIVATE_REPO $full_path
    end
  end
end
