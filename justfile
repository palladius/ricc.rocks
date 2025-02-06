# uno dei miei primi just files...

meta-list:
    echodo just -l

status:
	git submodule status



#[group zzo]
zzo-status:
    echo sobenme


#[group git-submodule]
git-submodule-status:
	git submodule status

gsm-status: git-submodule-status
