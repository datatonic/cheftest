#!/bin/bash
#!/bin/bash
if [[ "${UID}" -ne 0 ]]; then
    echo " You need to run this script as root"
    exit 1
fi

#To directly modify sshd_config.

#sed -i 's/#\?\(Port\s*\).*$/\1 2231/' /etc/ssh/sshd_config

sed -i 's/#\?\(AuthenticationMethods\s*\).*$/\1 publickey/' /etc/ssh/sshd_config
sed -i 's/#\?\(ChallengeResponseAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(UsePAM\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(UseDNS\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(PerminRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(PubkeyAuthentication\s*\).*$/\1 yes/' /etc/ssh/sshd_config
sed -i 's/#\?\(PermitEmptyPasswords\s*\).*$/\1 no/' /etc/ssh/sshd_config
sed -i 's/#\?\(PasswordAuthentication\s*\).*$/\1 no/' /etc/ssh/sshd_config

#Check the exit status of the last command

if [[ "${?}" -ne 0 ]]; then
   echo "The sshd_config file was not modified successfully"
   exit 1
fi

systemctl restart sshd

