A. Choix de l'algorithme de chiffrement
🌞 Déterminer quel algorithme de chiffrement utiliser pour vos clés

***https://ikarus.sg/rsa-is-not-dead/?utm_source=chatgpt.com***

B. Génération de votre paire de clés
🌞 Générer une paire de clés pour ce TP

la clé privée doit s'appeler cloud_tp1

elle doit se situer dans le dossier standard pour votre utilisateur
elle doit utiliser l'algorithme que vous avez choisi à l'étape précédente (donc, pas de RSA)
elle est protégée par un mot de passe de votre choix

***PS C:\Windows\system32> ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\cloud_tp1" -C "TP1 Cloud"***
>>
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Passphrases do not match.  Try again.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in C:\Users\Fadhil\.ssh\cloud_tp1
Your public key has been saved in C:\Users\Fadhil\.ssh\cloud_tp1.pub
The key fingerprint is:
SHA256:1QVNFvRxAflO4fKqy1v6Uc75nLbxhK3u2QjN0UUetRU TP1 Cloud
The key's randomart image is:
+--[ED25519 256]--+
|            .*OEO|
|           . +.=*|
|          . . o.=|
|         .   . =.|
|        S     *..|
|             o+*.|
|            .o==o|
|          . oo.O=|
|           *=+Bo*|
+----[SHA256]-----+

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0hOBkvbSiLmeoHEoX9r/zo0C9pNd45QCq0PQh2kBYH TP1 Cloud

***PS C:\Windows\system32> Get-Content "$env:USERPROFILE\.ssh\cloud_tp1.pub"***
>>
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0hOBkvbSiLmeoHEoX9r/zo0C9pNd45QCq0PQh2kBYH TP1 Cloud
***PS C:\Windows\system32> dir $env:USERPROFILE\.ssh\cloud_tp1****
>>


    Répertoire : C:\Users\Fadhil\.ssh


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/09/2025     14:09            444 cloud_tp1
-a----        05/09/2025     14:09             92 cloud_tp1.pub '''


C) Configurer un agent SSH sur votre poste
***PS C:\Windows\system32> Get-WindowsCapability -Online | Where{ $_.Name -like 'OpenSSH-Client*' } ***
***PS C:\Windows\system32> Get-WindowsCapability -Online -Name OpenSSH-Client***


Name         :
State        : NotPresent
DisplayName  :
Description  :
DownloadSize : 0
InstallSize  : 0



***PS C:\Windows\system32> Add-WindowsCapability -Online -Name OpenSSH-Client***


Path          :
Online        : True
RestartNeeded : False

***PS C:\Windows\system32> Get-Service ssh-agent***
>>

Status   Name               DisplayName
------   ----               -----------
Stopped  ssh-agent          OpenSSH Authentication Agent


***PS C:\Windows\system32> Set-Service -Name ssh-agent -StartupType Manual***
>> ***Start-Service ssh-agent***
>>
***PS C:\Windows\system32> Start-Service ssh-agent***
>>
***PS C:\Windows\system32> Set-Service -Name ssh-agent -StartupType Automatic***
>>
***PS C:\Windows\system32> ssh-add "$env:USERPROFILE\.ssh\cloud_tp1"
>>
Enter passphrase for C:\Users\Fadhil\.ssh\cloud_tp1:
Identity added: C:\Users\Fadhil\.ssh\cloud_tp1 (TP1 Cloud) 

🌞 Connectez-vous en SSH à la VM pour preuve

cette connexion ne doit demander aucun password : votre clé a été ajoutée à votre Agent SSH

***PS C:\Windows\system32> ssh azureuser@20.19.89.209***
>>
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.11.0-1018-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Sep  5 13:07:20 UTC 2025

  System load:  0.0               Processes:             133
  Usage of /:   5.6% of 28.02GB   Users logged in:       0
  Memory usage: 35%               IPv4 address for eth0: 172.16.0.4
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

2. az : a programmatic approach
🌞 Créez une VM depuis le Azure CLI


en utilisant uniquement la commande az donc


je vous laisse faire vos recherches pour créer une VM avec la commande az


vous devrez préciser :

quel utilisateur doit être créé à la création de la VM
le fichier de clé utilisé pour se connecter à cet utilisateur
comme ça, dès que la VM pop, on peut se co en SSH !



**PS C:\Windows\system32> az group create --name fadhil --location francecentral**
{
  "id": "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/fadhil",
  "location": "francecentral",
  "managedBy": null,
  "name": "fadhil",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
**PS C:\Windows\system32>  az vm create --size "Standard_B1s" -g fadhil -n super_vm --image Ubuntu2204 --admin-username fatp1fadhil --ssh-key-values ~/.ssh/id_ed25519.pub**
The default value of '--size' will be changed to 'Standard_D2s_v5' from 'Standard_DS1_v2' in a future release.
Selecting "northeurope" may reduce your costs. The region you've selected may cost more for the same services. You can disable this message in the future with the command "az config set core.display_region_identified=false". Learn more at https://go.microsoft.com/fwlink/?linkid=222571

{
  "fqdns": "",
  "id": "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/fadhil/providers/Microsoft.Compute/virtualMachines/super_vm",
  "location": "francecentral",
  "macAddress": "00-22-48-39-A8-64",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "4.211.131.12",
  "resourceGroup": "fadhil"


🌞 Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique

une commande SSH fonctionnelle vers la VM sans password toujouuurs because Agent SSH

**PS C:\Windows\system32> ssh fatp1fadhil@4.211.131.12 -i C:\Users\Fadhil\.ssh\id_ed25519**
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Sep  5 14:08:49 UTC 2025

  System load:  0.08              Processes:             104
  Usage of /:   5.4% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

fatp1fadhil@supervm:~$
logout
Connection to 4.211.131.12 closed.
**PS C:\Windows\system32> ssh fatp1fadhil@4.211.131.12 -i C:\Users\Fadhil\.ssh\id_ed25519**
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Sep  5 14:08:49 UTC 2025

  System load:  0.08              Processes:             104
  Usage of /:   5.4% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Fri Sep  5 14:08:54 2025 from 85.255.30.124
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

fatp1fadhil@supervm:~$



🌞 Une fois connecté, prouvez la présence...

...du service walinuxagent.service


**fatp1fadhil@supervm:~$ systemctl status walinuxagent.service**
Warning: The unit file, source configuration file or drop-ins of walinuxagent.service changed on disk. Run 'systemctl daemon-reload' to reload units.
● walinuxagent.service - Azure Linux Agent
     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset: enabled)
    Drop-In: /run/systemd/system.control/walinuxagent.service.d
             └─50-CPUAccounting.conf, 50-MemoryAccounting.conf
     Active: active (running) since Fri 2025-09-05 13:20:29 UTC; 58min ago
   Main PID: 754 (python3)
      Tasks: 7 (limit: 1009)
     Memory: 45.3M
        CPU: 4.435s
     CGroup: /system.slice/walinuxagent.service
             ├─ 754 /usr/bin/python3 -u /usr/sbin/waagent -daemon
             └─1060 python3 -u bin/WALinuxAgent-2.14.0.1-py3.12.egg -run-exthandlers

Sep 05 13:20:39 supervm python3[1060]:        0        0 DROP       tcp  --  *      *       0.0.0.0/0            168.63.129.16        ctstate INVALID,NEW
Sep 05 13:20:39 supervm python3[1060]: 2025-09-05T13:20:39.020577Z INFO ExtHandler ExtHandler Looking for existing remote access users.
Sep 05 13:20:39 supervm python3[1060]: 2025-09-05T13:20:39.025148Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>
Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.976815Z INFO CollectLogsHandler ExtHandler WireServer endpoint 168.63.129.16 read from file
Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.976999Z INFO CollectLogsHandler ExtHandler Wire server endpoint:168.63.129.16
Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.977108Z INFO CollectLogsHandler ExtHandler Starting log collection...
Sep 05 13:25:51 supervm python3[1060]: 2025-09-05T13:25:51.654842Z INFO CollectLogsHandler ExtHandler Successfully collected logs. Archive size: 76980 b, elapsed time>
Sep 05 13:25:51 supervm python3[1060]: 2025-09-05T13:25:51.674265Z INFO CollectLogsHandler ExtHandler Successfully uploaded logs.
Sep 05 13:35:36 supervm python3[754]: 2025-09-05T13:35:36.537331Z INFO Daemon Agent WALinuxAgent-2.14.0.1 launched with command 'python3 -u bin/WALinuxAgent-2.14.0.1->
Sep 05 13:50:40 supervm python3[1060]: 2025-09-05T13:50:40.236109Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>
lines 1-24/24 (END)

...du service cloud-init.service


**fatp1fadhil@supervm:~$ systemctl status cloud-init.service**
● cloud-init.service - Cloud-init: Network Stage
     Loaded: loaded (/lib/systemd/system/cloud-init.service; enabled; vendor preset: enabled)
     Active: active (exited) since Fri 2025-09-05 13:20:29 UTC; 1h 8min ago
   Main PID: 506 (code=exited, status=0/SUCCESS)
        CPU: 1.516s

Sep 05 13:20:29 supervm cloud-init[510]: |.o+..            |
Sep 05 13:20:29 supervm cloud-init[510]: | o.= .           |
Sep 05 13:20:29 supervm cloud-init[510]: |. + =            |
Sep 05 13:20:29 supervm cloud-init[510]: | . = .  S        |
Sep 05 13:20:29 supervm cloud-init[510]: |  . B +  .       |
Sep 05 13:20:29 supervm cloud-init[510]: |   + @ =  E      |
Sep 05 13:20:29 supervm cloud-init[510]: |    * @+=+.. .   |
Sep 05 13:20:29 supervm cloud-init[510]: |     =+B=*=oo    |
Sep 05 13:20:29 supervm cloud-init[510]: +----[SHA256]-----+
Sep 05 13:20:29 supervm systemd[1]: Finished Cloud-init: Network Stage.
fatp1fadhil@supervm:~$


Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Sep  5 14:08:49 UTC 2025

  System load:  0.08              Processes:             104
  Usage of /:   5.4% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

fatp1fadhil@supervm:~$
logout
Connection to 4.211.131.12 closed.
**PS C:\Windows\system32> ssh fatp1fadhil@4.211.131.12 -i C:\Users\Fadhil\.ssh\id_ed25519**
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Sep  5 14:08:49 UTC 2025

  System load:  0.08              Processes:             104
  Usage of /:   5.4% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Fri Sep  5 14:08:54 2025 from 85.255.30.124
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

fatp1fadhil@supervm:~$
**fatp1fadhil@supervm:~$ systemctl status walinuxagent.service**
Warning: The unit file, source configuration file or drop-ins of walinuxagent.service changed on disk. Run 'systemctl daemon-reload' to reload units.
● walinuxagent.service - Azure Linux Agent
     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset: enabled)
    Drop-In: /run/systemd/system.control/walinuxagent.service.d
             └─50-CPUAccounting.conf, 50-MemoryAccounting.conf
     Active: active (running) since Fri 2025-09-05 13:20:29 UTC; 58min ago
   Main PID: 754 (python3)
      Tasks: 7 (limit: 1009)
     Memory: 45.3M
        CPU: 4.435s
     CGroup: /system.slice/walinuxagent.service
             ├─ 754 /usr/bin/python3 -u /usr/sbin/waagent -daemon
             └─1060 python3 -u bin/WALinuxAgent-2.14.0.1-py3.12.egg -run-exthandlers

Sep 05 13:20:39 supervm python3[1060]:        0        0 DROP       tcp  --  *      *       0.0.0.0/0            168.63.129.16        ctstate INVALID,NEW
Sep 05 13:20:39 supervm python3[1060]: 2025-09-05T13:20:39.020577Z INFO ExtHandler ExtHandler Looking for existing remote access users.
Sep 05 13:20:39 supervm python3[1060]: 2025-09-05T13:20:39.025148Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.976815Z INFO CollectLogsHandler ExtHandler WireServer endpoint 168.63.129.16 read from file
Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.976999Z INFO CollectLogsHandler ExtHandler Wire server endpoint:168.63.129.16
Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.977108Z INFO CollectLogsHandler ExtHandler Starting log collection...
Sep 05 13:25:51 supervm python3[1060]: 2025-09-05T13:25:51.654842Z INFO CollectLogsHandler ExtHandler Successfully collected logs. Archive size: 76980 b, elapsed time>Sep 05 13:25:51 supervm python3[1060]: 2025-09-05T13:25:51.674265Z INFO CollectLogsHandler ExtHandler Successfully uploaded logs.
Sep 05 13:35:36 supervm python3[754]: 2025-09-05T13:35:36.537331Z INFO Daemon Agent WALinuxAgent-2.14.0.1 launched with command 'python3 -u bin/WALinuxAgent-2.14.0.1->Sep 05 13:50:40 supervm python3[1060]: 2025-09-05T13:50:40.236109Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>...skipping...
Warning: The unit file, source configuration file or drop-ins of walinuxagent.service changed on disk. Run 'systemctl daemon-reload' to reload units.
● walinuxagent.service - Azure Linux Agent
     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset: enabled)
    Drop-In: /run/systemd/system.control/walinuxagent.service.d
             └─50-CPUAccounting.conf, 50-MemoryAccounting.conf
     Active: active (running) since Fri 2025-09-05 13:20:29 UTC; 58min ago
   Main PID: 754 (python3)
      Tasks: 7 (limit: 1009)
     Memory: 45.3M
        CPU: 4.435s
     CGroup: /system.slice/walinuxagent.service
             ├─ 754 /usr/bin/python3 -u /usr/sbin/waagent -daemon
             └─1060 python3 -u bin/WALinuxAgent-2.14.0.1-py3.12.egg -run-exthandlers

Sep 05 13:20:39 supervm python3[1060]:        0        0 DROP       tcp  --  *      *       0.0.0.0/0            168.63.129.16        ctstate INVALID,NEW
Sep 05 13:20:39 supervm python3[1060]: 2025-09-05T13:20:39.020577Z INFO ExtHandler ExtHandler Looking for existing remote access users.
Sep 05 13:20:39 supervm python3[1060]: 2025-09-05T13:20:39.025148Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.976815Z INFO CollectLogsHandler ExtHandler WireServer endpoint 168.63.129.16 read from file
Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.976999Z INFO CollectLogsHandler ExtHandler Wire server endpoint:168.63.129.16
Sep 05 13:25:38 supervm python3[1060]: 2025-09-05T13:25:38.977108Z INFO CollectLogsHandler ExtHandler Starting log collection...
Sep 05 13:25:51 supervm python3[1060]: 2025-09-05T13:25:51.654842Z INFO CollectLogsHandler ExtHandler Successfully collected logs. Archive size: 76980 b, elapsed time>Sep 05 13:25:51 supervm python3[1060]: 2025-09-05T13:25:51.674265Z INFO CollectLogsHandler ExtHandler Successfully uploaded logs.
Sep 05 13:35:36 supervm python3[754]: 2025-09-05T13:35:36.537331Z INFO Daemon Agent WALinuxAgent-2.14.0.1 launched with command 'python3 -u bin/WALinuxAgent-2.14.0.1->Sep 05 13:50:40 supervm python3[1060]: 2025-09-05T13:50:40.236109Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>~