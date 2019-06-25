export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/
export SPARK_MASTER_HOST=localhost
export SPARK_HOME=/usr/local/installs/spark/
export GOPATH=$HOME/dev/go
export GO_HOME=$HOME/dev/go

export EDITOR=vim
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

export ANT_HOME=/usr/local/installs/apache-ant
export GRADLE_HOME=/usr/local/installs/gradle
export PYTHON=/usr/local/bin/python
export SCALA_HOME=/usr/local/opt/scala@2.12
export PUPPET_ROOT=/usr/bin
export PROD_MFA_DEVICE=arn:aws:iam::249536929440:mfa/jim.baugh-prd

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h (\[\033[33;1m\]\$(date '+%m/%d %H:%M %S')):\n\w\[\033[m\]\[\033[33m\]\$(parse_git_branch)\n\[\033[0m\]\$ "

PATH=/usr/local/opt/bison/bin:$JAVA_HOME/bin:$ANT_HOME/bin:$GRADLE_HOME/bin:$SCALA_HOME/bin:/usr/local/installs/spark/bin:/usr/local/installs:$GOPATH/bin:$PATH

set -o vi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Cassandra
if [ -d "/usr/local/installs/cassandra" ]; then
  export PATH="$PATH:/usr/local/installs/cassandra/bin"
fi

awsenv() {
    export PROD_ACCESS_KEY=$(aws configure get aws_access_key_id)
    export PROD_SECRET_KEY=$(aws configure get aws_secret_access_key)
}
awsunset(){
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
}

restartLoad() {
    id=$1
    echo "restarting load with id: $id"
    curl -XGET -H "Content-Type: application/json" "http://internal-fulfillment-segment-shoppe-prod-1750656076.us-east-1.elb.amazonaws.com:18080/api/v1/segment/load/$id/restart"
}

# security add-generic-password -s oracle_vpn -a astockto_us -p yourSweetPassword
oracle(){
    USER=`keychain -u -s oracle_vpn`
    PASS=`keychain -p -s oracle_vpn`
    state=$1
    if [[ $state == "on" ]]; then
      export VPN="oracle"
      res=`printf "$USER\n$PASS\n\n" | /opt/cisco/anyconnect/bin/vpn -s connect myaccess.oraclevpn.com`
      if [[ $! == 0 ]]; then
          echo "connected to oracle vpn"
      fi
    elif [[ $state == "off" ]]; then
        unset VPN
        /opt/cisco/anyconnect/bin/vpn disconnect
    fi
}

odc(){
    USER=`keychain -u -s dlx`
    PASS=`keychain -p -s dlx`
    state=$1
    if [[ $state == "on" ]]; then
      export VPN="odc"
      res=`printf "odc-user\n$USER\n$PASS\n\n" | /opt/cisco/anyconnect/bin/vpn -s connect vpn1.datalogix.com`
      if [[ $! == 0 ]]; then
          echo "connected to odc vpn"
      fi
    elif [[ $state == "off" ]]; then
        unset VPN
        /opt/cisco/anyconnect/bin/vpn disconnect
    else
        /opt/cisco/anyconnect/bin/vpn $state
    fi
}

switch(){
    if [[ $VPN == "oracle" ]]; then
        oracle off && odc on
    elif [[ $VPN == "odc" ]]; then
        odc off && oracle on
    else
        odc on
    fi
}

restartLoad() {
    id=$1
    echo "restarting load with id: $id"
    curl -XGET -H "Content-Type: application/json" "http://internal-fulfillment-segment-shoppe-prod-1750656076.us-east-1.elb.amazonaws.com:18080/api/v1/segment/load/$id/restart"
}

dynoInfo() {
    ip=$1
    count=10
    if [[ -n $2 ]]; then
      count=$2
    fi
    curl -s $ip:8080/REST/v1/admin/cluster_describe | jq -r '.[].hostname' | head -n $count | while read a; 
     do 
       b=`ssh -n -q -i ~/.ssh/idt_production_aws_2.pem ec2-user@${a} "redis-cli -p 22122 info memory | grep used_memory_human"`; 
       c=`ssh -n -q -i ~/.ssh/idt_production_aws_2.pem ec2-user@${a} "lsof | grep dynomite | wc -l"`;
       echo $a $b $c; 
     done
}

# added by Anaconda2 4.4.0 installer
export PATH="/anaconda2/bin:$PATH"

complete -C /usr/local/installs/vault vault
# added by Anaconda2 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/anaconda2/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/anaconda2/etc/profile.d/conda.sh" ]; then
        . "/anaconda2/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/anaconda2/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
