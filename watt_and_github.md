# ssh
after add sshkey, if using watt to connect github, there are problems with port.
use 
```bash
ssh -T -p 443 git@ssh.github.com
```
to verify. should return
```bash
... You've successfully authenicated, but GitHub does not provide shell acess.
```

`nvim ~/.ssh/config' add following to 
```
Host github.com
Hostname ssh.github.com
Port 443
User git
```
