find . -name "config" | grep ".git/config" | xargs -t -P 1 -I {} sh -c "sed -i '.bak' 's/gitlab.valkyrie.net/gitlab.oracledatacloud.com/' {}"
