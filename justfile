# uno dei miei primi just files...

meta-list:
    echodo just -l

status: git-submodule-status


#[group zzo]
zzo-status:
    cd zzo.ricc.rocks && make test


#[group git-submodule]
git-submodule-status:
	git submodule status

gsm-status: git-submodule-status

gsm-update-all:
    git submodule foreach git pull origin master

gsm-update-funge:
    verde "Riccardo read: https://stackoverflow.com/questions/5828324/update-git-submodule-to-latest-commit-on-origin"
    git submodule update --remote --merge

test:
    cd zzo.ricc.rocks && make test

curl-localhost:
    curl http://localhost:1313/en/
