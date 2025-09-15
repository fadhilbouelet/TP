A. Choix de l'algorithme de chiffrement
🌞 Déterminer quel algorithme de chiffrement utiliser pour vos clés
```
https://ikarus.sg/rsa-is-not-dead/?utm_source=chatgpt.com

```

B. Génération de votre paire de clés
🌞 Générer une paire de clés pour ce TP

la clé privée doit s'appeler cloud_tp1

elle doit se situer dans le dossier standard pour votre utilisateur
elle doit utiliser l'algorithme que vous avez choisi à l'étape précédente (donc, pas de RSA)
elle est protégée par un mot de passe de votre choix
```
PS C:\Windows\system32> ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\cloud_tp1" -C "TP1 Cloud"
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

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0hOBkvbSiLmeoHEoX9r/zo0C9pNd45QCq0PQh2kBYH TP1 Cloud ```

PS C:\Windows\system32> Get-Content "$env:USERPROFILE\.ssh\cloud_tp1.pub"
>>
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0hOBkvbSiLmeoHEoX9r/zo0C9pNd45QCq0PQh2kBYH TP1 Cloud

PS C:\Windows\system32> dir $env:USERPROFILE\.ssh\cloud_tp1
>>


    Répertoire : C:\Users\Fadhil\.ssh


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        05/09/2025     14:09            444 cloud_tp1
-a----        05/09/2025     14:09             92 cloud_tp1.pub '''

```

C) Configurer un agent SSH sur votre poste
```
PS C:\Windows\system32> Get-WindowsCapability -Online | Where{ $_.Name -like 'OpenSSH-Client*' }```

PS C:\Windows\system32> Get-WindowsCapability -Online -Name OpenSSH-Client


Name         :
State        : NotPresent
DisplayName  :
Description  :
DownloadSize : 0
InstallSize  : 0

```

```
PS C:\Windows\system32> Add-WindowsCapability -Online -Name OpenSSH-Client


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
```

🌞 Connectez-vous en SSH à la VM pour preuve

cette connexion ne doit demander aucun password : votre clé a été ajoutée à votre Agent SSH

```
PS C:\Windows\system32> ssh azureuser@20.19.89.209
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
```

2. az : a programmatic approach
🌞 Créez une VM depuis le Azure CLI


en utilisant uniquement la commande az donc


je vous laisse faire vos recherches pour créer une VM avec la commande az


vous devrez préciser :

quel utilisateur doit être créé à la création de la VM
le fichier de clé utilisé pour se connecter à cet utilisateur
comme ça, dès que la VM pop, on peut se co en SSH !



```
PS C:\Windows\system32> az group create --name fadhil --location francecentral**
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
PS C:\Windows\system32>  az vm create --size "Standard_B1s" -g fadhil -n super_vm --image Ubuntu2204 --admin-username fatp1fadhil --ssh-key-values ~/.ssh/id_ed25519.pub**
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
```

🌞 Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique

une commande SSH fonctionnelle vers la VM sans password toujouuurs because Agent SSH

```
PS C:\Windows\system32> ssh fatp1fadhil@4.211.131.12 -i C:\Users\Fadhil\.ssh\id_ed25519**
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
PS C:\Windows\system32> ssh fatp1fadhil@4.211.131.12 -i C:\Users\Fadhil\.ssh\id_ed25519**
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

```



🌞 Une fois connecté, prouvez la présence...

...du service walinuxagent.service


```
fatp1fadhil@supervm:~$ systemctl status walinuxagent.service**
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


fatp1fadhil@supervm:~$ systemctl status cloud-init.service
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

PS C:\Windows\system32> ssh fatp1fadhil@4.211.131.12 -i C:\Users\Fadhil\.ssh\id_ed25519**
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

```

4. Exemple d'utilisation Azure + Terraform¶

Parce que jui pas trop un animal, j'vous file un bon pattern de fichiers Terraform qui fait le job.

Créez un dossier dédié et déposez ces 3 fichiers :
A. Création de fichiers

B. Commandes Terraform¶

Une fois les 3 fichiers en place (main.tf, variables.tf, terraform.tfvars), déplacez-vous dans le dossier, et utilisez des commandes terraform :

# On se déplace dans le dossier qui contient le main.tf et les autres fichiers
cd terraform/

# Initialisation de Terraform, utile une seule fois
# Ici, Terraform va récupérer le nécessaire pour déployer sur Azure spécifiquement
terraform init

# Si vous voulez voir ce qui serait fait avant de déployer, vous pouvez :
terraform plan

# Pour déployer votre "plan Terraform" (ce qui est défini dans le main.tf)
terraform apply

# Pour détruire tout ce qui a été déployé (recommandé de le faire régulièrement pour déployer depuis zéro)
terraform destroy

```
PS C:\Users\Fadhil> cd terraform/
PS C:\Users\Fadhil\terraform> terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/azurerm...
- Installing hashicorp/azurerm v4.44.0...
- Installed hashicorp/azurerm v4.44.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

PS C:\Users\Fadhil\terraform> terraform apply
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.main will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_username                                         = "azureuser"
      + allow_extension_operations                             = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = (known after apply)
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "francecentral"
      + max_bid_price                                          = -1
      + name                                                   = "super-vm"
      + network_interface_ids                                  = (known after apply)
      + os_managed_disk_id                                     = (known after apply)
      + patch_assessment_mode                                  = (known after apply)
      + patch_mode                                             = (known after apply)
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = (known after apply)
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "mon-projet"
      + size                                                   = "Standard_B1s"
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = (known after apply)

      + admin_ssh_key {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + id                        = (known after apply)
          + name                      = "vm-os-disk"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "0001-com-ubuntu-server-focal"
          + publisher = "Canonical"
          + sku       = "20_04-lts"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }

  # azurerm_network_interface.main will be created
  + resource "azurerm_network_interface" "main" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "francecentral"
      + mac_address                    = (known after apply)
      + name                           = "vm-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mon-projet"
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet"
        }
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "francecentral"
      + name                    = "vm-ip"
      + resource_group_name     = "mon-projet"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_public_ip.main: Creating...
azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_network_interface.main: Creating...
azurerm_network_interface.main: Still creating... [00m10s elapsed]
azurerm_network_interface.main: Creation complete after 13s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_linux_virtual_machine.main: Creating...
azurerm_linux_virtual_machine.main: Still creating... [00m10s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m20s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m30s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m40s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [00m50s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 50s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```


 🌞Ajouter un NSG à votre déploiement Terraform

    le trafic qui arrive sur l'interface réseau de la VM qui porte l'IP publique doit être filtré :
        n'autorise les connexions que sur le port 22 (pour SSH)
        n'autorise les connexions que depuis votre IP publique

    je vous recommande de créer un nouveau fichier network.tf à côté de votre main.tf et y mettre cette conf

```
PS C:\Users\Fadhil\terraform> terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed hashicorp/azurerm v4.44.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
PS C:\Users\Fadhil\terraform> terraform plan
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_network_interface_security_group_association.nsg_association will be created
  + resource "azurerm_network_interface_security_group_association" "nsg_association" {
      + id                        = (known after apply)
      + network_interface_id      = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic"
      + network_security_group_id = (known after apply)
    }

  # azurerm_network_security_group.vm_nsg will be created
  + resource "azurerm_network_security_group" "vm_nsg" {
      + id                  = (known after apply)
      + location            = "francecentral"
      + name                = "mon-projet-nsg"
      + resource_group_name = "mon-projet"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Allow-SSH-From-My-IP"
              + priority                                   = 1001
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "4.211.175.88"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
    }

Plan: 2 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```

3. Proofs !¶

🌞 Prouver que ça fonctionne, rendu attendu :

    la sortie du terraform apply


```
PS C:\Users\Fadhil\terraform> terraform apply
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_network_security_group.vm_nsg: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.nsg_association: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

```

  une commande az pour obtenir toutes les infos liées à la VM
        on doit y voir le NSG

        ```
        PS C:\Users\Fadhil\terraform> az vm show --resource-group mon-projet --name super-vm --show-details
>>
{
  "diagnosticsProfile": {
    "bootDiagnostics": {
      "enabled": false
    }
  },
  "etag": "\"1\"",
  "extensionsTimeBudget": "PT1H30M",
  "fqdns": "",
  "hardwareProfile": {
    "vmSize": "Standard_B1s"
  },
  "id": "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm",
  "location": "francecentral",
  "macAddresses": "00-22-48-39-EC-62",
  "name": "super-vm",
  "networkProfile": {
    "networkInterfaces": [
      {
        "id": "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic",
        "primary": true,
        "resourceGroup": "mon-projet"
      }
    ]
  },
  "osProfile": {
    "adminUsername": "azureuser",
    "allowExtensionOperations": true,
    "computerName": "super-vm",
    "linuxConfiguration": {
      "disablePasswordAuthentication": true,
      "patchSettings": {
        "assessmentMode": "ImageDefault",
        "patchMode": "ImageDefault"
      },
      "provisionVMAgent": true,
      "ssh": {
        "publicKeys": [
          {
            "keyData": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0hOBkvbSiLmeoHEoX9r/zo0C9pNd45QCq0PQh2kBYH TP1 Cloud",
            "path": "/home/azureuser/.ssh/authorized_keys"
          }
        ]
      }
    },
    "requireGuestProvisionSignal": true,
    "secrets": []
  },
  "powerState": "VM running",
  "priority": "Regular",
  "privateIps": "10.0.1.4",
  "provisioningState": "Succeeded",
  "publicIps": "4.211.175.88",
  "resourceGroup": "mon-projet",
  "storageProfile": {
    "dataDisks": [],
    "imageReference": {
      "exactVersion": "20.04.202505200",
      "offer": "0001-com-ubuntu-server-focal",
      "publisher": "Canonical",
      "sku": "20_04-lts",
      "version": "latest"
    },
    "osDisk": {
      "caching": "ReadWrite",
      "createOption": "FromImage",
      "deleteOption": "Detach",
      "diskSizeGB": 30,
      "managedDisk": {
        "id": "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/disks/vm-os-disk",
        "resourceGroup": "mon-projet",
        "storageAccountType": "Standard_LRS"
      },
      "name": "vm-os-disk",
      "osType": "Linux",
      "writeAcceleratorEnabled": false
    }
  },
  "tags": {},
  "timeCreated": "2025-09-15T08:48:31.6484898+00:00",
  "type": "Microsoft.Compute/virtualMachines",
  "vmId": "413956df-c562-41a1-b0e0-3fe53837da40"
}
 
 ```

    une commande ssh fonctionnelle
        vers l'IP publique de la VM
        toujours sans mot de passe avec votre Agent SSH

  ```
  PS C:\Users\Fadhil\terraform> ssh azureuser@4.211.175.88 -i C:\Users\Fadhil\.ssh\id_ed25519
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep 15 11:09:35 UTC 2025

  System load:  0.0               Processes:             111
  Usage of /:   5.5% of 28.89GB   Users logged in:       0
  Memory usage: 30%               IPv4 address for eth0: 10.0.1.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '22.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Mon Sep 15 10:31:50 2025 from 77.136.67.139
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@super-vm:~$
```

    changement de port :
        modifiez le port d'écoute du serveur OpenSSH sur la VM pour le port 2222/tcp
        prouvez que le serveur OpenSSH écoute sur ce nouveau port (avec une commande ss sur la VM)

        ```
        PS C:\Users\Fadhil\terraform> ssh azureuser@4.211.175.88
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep 15 11:11:58 UTC 2025

  System load:  0.08              Processes:             112
  Usage of /:   5.5% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.1.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '22.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Mon Sep 15 11:09:36 2025 from 77.136.67.139
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@super-vm:~$ sudo nano /etc/ssh/sshd_config
azureuser@super-vm:~$ sudo systemctl restart ssh
azureuser@super-vm:~$ sudo ss -tlnp | grep ssh
LISTEN    0         128                0.0.0.0:2222             0.0.0.0:*        users:(("sshd",pid=2095,fd=3))
LISTEN    0         128                   [::]:2222                [::]:*        users:(("sshd",pid=2095,fd=4))

```

 prouvez qu'une nouvelle connexion sur ce port 2222/tcp ne fonctionne pas à cause du NSG
 ```
 PS C:\Users\Fadhil\terraform> ssh -p 2222 azureuser@4.211.175.88
ssh: connect to host 4.211.175.88 port 2222: Connection timed out
```










