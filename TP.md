#**TP1 : Azure first steps**
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
PS C:\Windows\system32> Get-WindowsCapability -Online | Where{ $_.Name -like 'OpenSSH-Client*' }
PS C:\Windows\system32> Get-WindowsCapability -Online -Name OpenSSH-Client


Name         :
State        : NotPresent
DisplayName  :
Description  :
DownloadSize : 0
InstallSize  : 0

PS C:\Windows\system32> Add-WindowsCapability -Online -Name OpenSSH-Client


Path          :
Online        : True
RestartNeeded : False

PS C:\Windows\system32> Get-Service ssh-agent
>>

Status   Name               DisplayName
------   ----               -----------
Stopped  ssh-agent          OpenSSH Authentication Agent


PS C:\Windows\system32> Set-Service -Name ssh-agent -StartupType Manual
>> Start-Service ssh-agent
>>
PS C:\Windows\system32> Start-Service ssh-agent
>>
PS C:\Windows\system32> Set-Service -Name ssh-agent -StartupType Automatic
>>
PS C:\Windows\system32> ssh-add "$env:USERPROFILE\.ssh\cloud_tp1"
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

#**TP2 : Aller plus loing aveceuh Azure**
 🌞Ajouter un NSG à votre déploiement Terraform

🌞le trafic qui arrive sur l'interface réseau de la VM qui porte l'IP publique doit être filtré :
        n'autorise les connexions que sur le port 22 (pour SSH)
        n'autorise les connexions que depuis votre IP publique

🌞je vous recommande de créer un nouveau fichier network.tf à côté de votre main.tf et y mettre cette conf

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

🌞 une commande ssh fonctionnelle
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

🌞 changement de port :
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


1. Adapter le plan Terraform¶

🌞 Donner un nom DNS à votre VM

    avec Terraform, suffit d'ajouter une propriété domain_name_label sur la ressource azurerm_public_ip
    go terraform apply après !

```PS C:\Users\Fadhil\terraform> terraform apply
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_network_security_group.vm_nsg: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.nsg_association: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_public_ip.main will be updated in-place
  ~ resource "azurerm_public_ip" "main" {
      + domain_name_label       = "monvm-ssh-demo"
        id                      = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip"
        name                    = "vm-ip"
        tags                    = {}
        # (12 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_public_ip.main: Modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_public_ip.main: Still modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-...rosoft.Network/publicIPAddresses/vm-ip, 00m10s elapsed]
azurerm_public_ip.main: Modifications complete after 10s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

2. Ajouter un output custom à terraform apply¶

🌞 Un ptit output nan ?
    créez un fichier outputs.tf à côté de votre main.tf
    doit afficher l'IP publique et le nom DNS de la VM

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

Changes to Outputs:
  + public_dns = "monvm-ssh-demo.francecentral.cloudapp.azure.com"
  + public_ip  = "4.211.175.88"

You can apply this plan to save these new output values to the Terraform state, without changing any real infrastructure.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

public_dns = "monvm-ssh-demo.francecentral.cloudapp.azure.com"
public_ip = "4.211.175.88"
```

3. Proooofs !¶

🌞 Proofs ! Donnez moi :

   🌞 la sortie du terraform apply (ce qu'affiche votre outputs.tf)

    🌞une commande ssh fonctionnelle vers le nom de domaine (pas l'IP)
       🌞 vers le nom de domaine de la publique
        toujours sans mot de passe avec votre Agent SSH

```
PS C:\Users\Fadhil\terraform> ssh azureuser@4.211.175.88 -i C:\Users\Fadhil\.ssh\id_ed25519
ssh: connect to host 4.211.175.88 port 22: Connection refused
PS C:\Users\Fadhil\terraform>
>> ssh-add C:\Users\Fadhil\.ssh\id_ed25519
>> Start-Service ssh-agent
Identity added: C:\Users\Fadhil\.ssh\id_ed25519 (fadhil@DESKTOP-GQR9FCC)
PS C:\Users\Fadhil\terraform> ssh -p 2222 azureuser@monvm-ssh-demo.francecentral.cloudapp.azure.com
The authenticity of host '[monvm-ssh-demo.francecentral.cloudapp.azure.com]:2222 ([4.211.175.88]:2222)' can't be established.
ED25519 key fingerprint is SHA256:89UPd323P9TWcxh7TWAw0XxhLq9uJuCE554YHDQOlQQ.
This host key is known by the following other names/addresses:
    C:\Users\Fadhil/.ssh/known_hosts:7: 4.211.175.88
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[monvm-ssh-demo.francecentral.cloudapp.azure.com]:2222' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep 15 12:33:01 UTC 2025

  System load:  0.0               Processes:             110
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


Last login: Mon Sep 15 11:11:59 2025 from 77.136.67.139
azureuser@super-vm:~$
```
III. Blob storage¶
1. Intro¶

➜ Azure propose du Blob Storage.

Dans cette section, vous allez créer un Azure Storage Container pour profiter du Blob Storage Azure depuis votre VM.

La logique Azure est la suivante :

    il faut créer un Storage Account
    avec ce Storage Account vous pourrez créer des Storage Container
    on peut accéder à ce Storage Container depuis nos VMs autorisées

➜ Une fois qu'une VM a accès à un Storage Container, elle peut écrire/lire des fichiers arbitrairement dedans.

Vous verrez qu'on peut appliquer une politique d'accès et d'authentification qui permet de définir qui peut accéder à notre Storage Container.
Note

C'est idéal pour y déposer les backups par exemple ! Ou partager des données avec d'autres VMs.
2. Let's go¶

🌞 Compléter votre plan Terraform pour déployer du Blob Storage pour votre VM

    je vous recommande de créer un nouveau fichier storage.tf à côté de votre main.tf

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
PS C:\Users\Fadhil\terraform> terraform apply
PS C:\Users\Fadhil\terraform> terraform apply
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_network_security_group.vm_nsg: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.nsg_association: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_network_security_group.vm_nsg will be updated in-place
  ~ resource "azurerm_network_security_group" "vm_nsg" {
        id                  = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg"
        name                = "mon-projet-nsg"
      ~ security_rule       = [
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "2222"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "Allow-SSH-From-My-IP"
              - priority                                   = 1001
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
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
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
        tags                = {}
        # (2 unchanged attributes hidden)
    }

  # azurerm_storage_account.main will be created
  + resource "azurerm_storage_account" "main" {
      + access_tier                        = (known after apply)
      + account_kind                       = "StorageV2"
      + account_replication_type           = "LRS"
      + account_tier                       = "Standard"
      + allow_nested_items_to_be_public    = true
      + cross_tenant_replication_enabled   = false
      + default_to_oauth_authentication    = false
      + dns_endpoint_type                  = "Standard"
      + https_traffic_only_enabled         = true
      + id                                 = (known after apply)
      + infrastructure_encryption_enabled  = false
      + is_hns_enabled                     = false
      + large_file_share_enabled           = (known after apply)
      + local_user_enabled                 = true
      + location                           = "francecentral"
      + min_tls_version                    = "TLS1_2"
      + name                               = "monvmstorageacct"
      + nfsv3_enabled                      = false
      + primary_access_key                 = (sensitive value)
      + primary_blob_connection_string     = (sensitive value)
      + primary_blob_endpoint              = (known after apply)
      + primary_blob_host                  = (known after apply)
      + primary_blob_internet_endpoint     = (known after apply)
      + primary_blob_internet_host         = (known after apply)
      + primary_blob_microsoft_endpoint    = (known after apply)
      + primary_blob_microsoft_host        = (known after apply)
      + primary_connection_string          = (sensitive value)
      + primary_dfs_endpoint               = (known after apply)
      + primary_dfs_host                   = (known after apply)
      + primary_dfs_internet_endpoint      = (known after apply)
      + primary_dfs_internet_host          = (known after apply)
      + primary_dfs_microsoft_endpoint     = (known after apply)
      + primary_dfs_microsoft_host         = (known after apply)
      + primary_file_endpoint              = (known after apply)
      + primary_file_host                  = (known after apply)
      + primary_file_internet_endpoint     = (known after apply)
      + primary_file_internet_host         = (known after apply)
      + primary_file_microsoft_endpoint    = (known after apply)
      + primary_file_microsoft_host        = (known after apply)
      + primary_location                   = (known after apply)
      + primary_queue_endpoint             = (known after apply)
      + primary_queue_host                 = (known after apply)
      + primary_queue_microsoft_endpoint   = (known after apply)
      + primary_queue_microsoft_host       = (known after apply)
      + primary_table_endpoint             = (known after apply)
      + primary_table_host                 = (known after apply)
      + primary_table_microsoft_endpoint   = (known after apply)
      + primary_table_microsoft_host       = (known after apply)
      + primary_web_endpoint               = (known after apply)
      + primary_web_host                   = (known after apply)
      + primary_web_internet_endpoint      = (known after apply)
      + primary_web_internet_host          = (known after apply)
      + primary_web_microsoft_endpoint     = (known after apply)
      + primary_web_microsoft_host         = (known after apply)
      + public_network_access_enabled      = true
      + queue_encryption_key_type          = "Service"
      + resource_group_name                = "mon-projet"
      + secondary_access_key               = (sensitive value)
      + secondary_blob_connection_string   = (sensitive value)
      + secondary_blob_endpoint            = (known after apply)
      + secondary_blob_host                = (known after apply)
      + secondary_blob_internet_endpoint   = (known after apply)
      + secondary_blob_internet_host       = (known after apply)
      + secondary_blob_microsoft_endpoint  = (known after apply)
      + secondary_blob_microsoft_host      = (known after apply)
      + secondary_connection_string        = (sensitive value)
      + secondary_dfs_endpoint             = (known after apply)
      + secondary_dfs_host                 = (known after apply)
      + secondary_dfs_internet_endpoint    = (known after apply)
      + secondary_dfs_internet_host        = (known after apply)
      + secondary_dfs_microsoft_endpoint   = (known after apply)
      + secondary_dfs_microsoft_host       = (known after apply)
      + secondary_file_endpoint            = (known after apply)
      + secondary_file_host                = (known after apply)
      + secondary_file_internet_endpoint   = (known after apply)
      + secondary_file_internet_host       = (known after apply)
      + secondary_file_microsoft_endpoint  = (known after apply)
      + secondary_file_microsoft_host      = (known after apply)
      + secondary_location                 = (known after apply)
      + secondary_queue_endpoint           = (known after apply)
      + secondary_queue_host               = (known after apply)
      + secondary_queue_microsoft_endpoint = (known after apply)
      + secondary_queue_microsoft_host     = (known after apply)
      + secondary_table_endpoint           = (known after apply)
      + secondary_table_host               = (known after apply)
      + secondary_table_microsoft_endpoint = (known after apply)
      + secondary_table_microsoft_host     = (known after apply)
      + secondary_web_endpoint             = (known after apply)
      + secondary_web_host                 = (known after apply)
      + secondary_web_internet_endpoint    = (known after apply)
      + secondary_web_internet_host        = (known after apply)
      + secondary_web_microsoft_endpoint   = (known after apply)
      + secondary_web_microsoft_host       = (known after apply)
      + sftp_enabled                       = false
      + shared_access_key_enabled          = true
      + table_encryption_key_type          = "Service"

      + blob_properties {
          + change_feed_enabled      = false
          + default_service_version  = (known after apply)
          + last_access_time_enabled = false
          + versioning_enabled       = false

          + delete_retention_policy {
              + days                     = 7
              + permanent_delete_enabled = false
            }
        }

      + network_rules {
          + bypass                     = (known after apply)
          + default_action             = "Allow"
          + ip_rules                   = (known after apply)
          + virtual_network_subnet_ids = (known after apply)
        }

      + queue_properties (known after apply)

      + routing (known after apply)

      + share_properties (known after apply)

      + static_website (known after apply)
    }

  # azurerm_storage_container.main will be created
  + resource "azurerm_storage_container" "main" {
      + container_access_type             = "private"
      + default_encryption_scope          = (known after apply)
      + encryption_scope_override_enabled = true
      + has_immutability_policy           = (known after apply)
      + has_legal_hold                    = (known after apply)
      + id                                = (known after apply)
      + metadata                          = (known after apply)
      + name                              = "moncontainer"
      + resource_manager_id               = (known after apply)
      + storage_account_name              = "monvmstorageacct"
    }

Plan: 2 to add, 1 to change, 0 to destroy.

Changes to Outputs:
  + storage_account_name   = "monvmstorageacct"
  + storage_container_name = "moncontainer"
╷
│ Warning: Argument is deprecated
│
│   with azurerm_storage_container.main,
│   on storage.tf line 24, in resource "azurerm_storage_container" "main":
│   24:   storage_account_name  = azurerm_storage_account.main.name
│
│ the `storage_account_name` property has been deprecated in favour of `storage_account_id` and will be removed in version 5.0 of the Provider.
╵

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_network_security_group.vm_nsg: Modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_storage_account.main: Creating...
azurerm_network_security_group.vm_nsg: Modifications complete after 2s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_storage_account.main: Still creating... [00m10s elapsed]
azurerm_storage_account.main: Still creating... [00m20s elapsed]
azurerm_storage_account.main: Still creating... [00m30s elapsed]
azurerm_storage_account.main: Still creating... [00m40s elapsed]
azurerm_storage_account.main: Still creating... [00m50s elapsed]
azurerm_storage_account.main: Still creating... [01m00s elapsed]
azurerm_storage_account.main: Creation complete after 1m8s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_storage_container.main: Creating...
azurerm_storage_container.main: Creation complete after 1s [id=https://monvmstorageacct.blob.core.windows.net/moncontainer]
╷
│ Warning: Argument is deprecated
│
│   with azurerm_storage_container.main,
│   on storage.tf line 24, in resource "azurerm_storage_container" "main":
│   24:   storage_account_name  = azurerm_storage_account.main.name
│
│ the `storage_account_name` property has been deprecated in favour of `storage_account_id` and will be removed in version 5.0 of the Provider.
╵

Apply complete! Resources: 2 added, 1 changed, 0 destroyed.

Outputs:

public_dns = "monvm-ssh-demo.francecentral.cloudapp.azure.com"
public_ip = "4.211.175.88"
storage_account_name = "monvmstorageacct"
storage_container_name = "moncontainer"
```
##IV. Monitoring¶##
1. Introw¶

➜ Alors le monitoring avec Azure... euh c'est le bordel ! Ca a beaucoup évolué et le modèle est assez complexe.

-On va aller sur quelque chose de simpliste : monitoring CPU et RAM déjà, avec des alertes par mail si ça dépasse un certain seuil.

-Azure fournit toutes ces features, et on peut tout déployer avec Terraform, let's go :)

-Vous pouvez utiliser un Logs Analytics Workspace, ou rester simple avec l'onglet Monitoring de la VM et les Platform Metrics. Je vous laisse faire vos recherches !

🌞 Compléter votre plan Terraform et mettez en place une alerte CPU

    je vous recommande de créer un nouveau fichier monitoring.tf à côté de votre main.tf
    si le % d'utilisation CPU monte au dessus de 70% une alerte doit être levée
    vous devez recevoir un mail
```
PS C:\Users\Fadhil\terraform> terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed hashicorp/azurerm v4.44.0

Terraform has been successfully initialized!

PS C:\Users\Fadhil\terraform> terraform plan
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_network_security_group.vm_nsg: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_storage_account.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.nsg_association: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]
azurerm_storage_container.main: Refreshing state... [id=https://monvmstorageacct.blob.core.windows.net/moncontainer]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_monitor_action_group.main will be created
  + resource "azurerm_monitor_action_group" "main" {
      + enabled             = true
      + id                  = (known after apply)
      + location            = "global"
      + name                = "ag-mon-projet-alerts"
      + resource_group_name = "mon-projet"
      + short_name          = "vm-alerts"

      + email_receiver {
          + email_address           = "remyfadhil@gmail.com"
          + name                    = "admin"
          + use_common_alert_schema = true
        }
    }

  # azurerm_monitor_metric_alert.cpu_alert will be created
  + resource "azurerm_monitor_metric_alert" "cpu_alert" {
      + auto_mitigate            = true
      + description              = "Alert when CPU usage exceeds 70%"
      + enabled                  = true
      + frequency                = "PT1M"
      + id                       = (known after apply)
      + name                     = "cpu-alert-super-vm"
      + resource_group_name      = "mon-projet"
      + scopes                   = [
          + "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm",
        ]
      + severity                 = 2
      + target_resource_location = (known after apply)
      + target_resource_type     = (known after apply)
      + window_size              = "PT5M"

      + action {
          + action_group_id = (known after apply)
        }

      + criteria {
          + aggregation            = "Average"
          + metric_name            = "Percentage CPU"
          + metric_namespace       = "Microsoft.Compute/virtualMachines"
          + operator               = "GreaterThan"
          + skip_metric_validation = false
          + threshold              = 70
        }
    }

  # azurerm_network_security_group.vm_nsg will be updated in-place
  ~ resource "azurerm_network_security_group" "vm_nsg" {
        id                  = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg"
        name                = "mon-projet-nsg"
      ~ security_rule       = [
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "2222"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "Allow-SSH-From-My-IP"
              - priority                                   = 1001
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
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
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
        tags                = {}
        # (2 unchanged attributes hidden)
    }

  # azurerm_storage_account.main will be updated in-place
  ~ resource "azurerm_storage_account" "main" {
        id                                 = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct"
        name                               = "monvmstorageacct"
        tags                               = {}
        # (97 unchanged attributes hidden)

      + network_rules {
          + bypass                     = (known after apply)
          + default_action             = "Allow"
          + ip_rules                   = (known after apply)
          + virtual_network_subnet_ids = (known after apply)
        }

        # (3 unchanged blocks hidden)
    }

Plan: 2 to add, 2 to change, 0 to destroy.
╷
│ Warning: Argument is deprecated
│
│   with azurerm_storage_container.main,
│   on storage.tf line 24, in resource "azurerm_storage_container" "main":
│   24:   storage_account_name  = azurerm_storage_account.main.name
│
│ the `storage_account_name` property has been deprecated in favour of `storage_account_id` and will be removed in version 5.0 of the Provider.
╵

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
PS C:\Users\Fadhil\terraform> terraform apply
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_network_security_group.vm_nsg: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_storage_account.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.nsg_association: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]
azurerm_storage_container.main: Refreshing state... [id=https://monvmstorageacct.blob.core.windows.net/moncontainer]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_monitor_action_group.main will be created
  + resource "azurerm_monitor_action_group" "main" {
      + enabled             = true
      + id                  = (known after apply)
      + location            = "global"
      + name                = "ag-mon-projet-alerts"
      + resource_group_name = "mon-projet"
      + short_name          = "vm-alerts"

      + email_receiver {
          + email_address           = "remyfadhil@gmail.com"
          + name                    = "admin"
          + use_common_alert_schema = true
        }
    }

  # azurerm_monitor_metric_alert.cpu_alert will be created
  + resource "azurerm_monitor_metric_alert" "cpu_alert" {
      + auto_mitigate            = true
      + description              = "Alert when CPU usage exceeds 70%"
      + enabled                  = true
      + frequency                = "PT1M"
      + id                       = (known after apply)
      + name                     = "cpu-alert-super-vm"
      + resource_group_name      = "mon-projet"
      + scopes                   = [
          + "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm",
        ]
      + severity                 = 2
      + target_resource_location = (known after apply)
      + target_resource_type     = (known after apply)
      + window_size              = "PT5M"

      + action {
          + action_group_id = (known after apply)
        }

      + criteria {
          + aggregation            = "Average"
          + metric_name            = "Percentage CPU"
          + metric_namespace       = "Microsoft.Compute/virtualMachines"
          + operator               = "GreaterThan"
          + skip_metric_validation = false
          + threshold              = 70
        }
    }

  # azurerm_network_security_group.vm_nsg will be updated in-place
  ~ resource "azurerm_network_security_group" "vm_nsg" {
        id                  = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg"
        name                = "mon-projet-nsg"
      ~ security_rule       = [
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "2222"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "Allow-SSH-From-My-IP"
              - priority                                   = 1001
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
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
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
        tags                = {}
        # (2 unchanged attributes hidden)
    }

  # azurerm_storage_account.main will be updated in-place
  ~ resource "azurerm_storage_account" "main" {
        id                                 = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct"
        name                               = "monvmstorageacct"
        tags                               = {}
        # (97 unchanged attributes hidden)

      + network_rules {
          + bypass                     = (known after apply)
          + default_action             = "Allow"
          + ip_rules                   = (known after apply)
          + virtual_network_subnet_ids = (known after apply)
        }

        # (3 unchanged blocks hidden)
    }

Plan: 2 to add, 2 to change, 0 to destroy.
╷
│ Warning: Argument is deprecated
│
│   with azurerm_storage_container.main,
│   on storage.tf line 24, in resource "azurerm_storage_container" "main":
│   24:   storage_account_name  = azurerm_storage_account.main.name
│
│ the `storage_account_name` property has been deprecated in favour of `storage_account_id` and will be removed in version 5.0 of the Provider.
╵

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_monitor_action_group.main: Creating...
azurerm_network_security_group.vm_nsg: Modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_storage_account.main: Modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_monitor_action_group.main: Creation complete after 3s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/actionGroups/ag-mon-projet-alerts]
azurerm_monitor_metric_alert.cpu_alert: Creating...
azurerm_network_security_group.vm_nsg: Modifications complete after 4s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_storage_account.main: Still modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-...orage/storageAccounts/monvmstorageacct, 00m10s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [00m10s elapsed]
azurerm_storage_account.main: Modifications complete after 15s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [00m20s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [00m30s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [00m40s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [00m50s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [01m00s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [01m10s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [01m20s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [01m30s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [01m40s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [01m50s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Still creating... [02m00s elapsed]
azurerm_monitor_metric_alert.cpu_alert: Creation complete after 2m6s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/cpu-alert-super-vm]

Apply complete! Resources: 2 added, 2 changed, 0 destroyed.

Outputs:

public_dns = "monvm-ssh-demo.francecentral.cloudapp.azure.com"
public_ip = "4.211.175.88"
storage_account_name = "monvmstorageacct"
storage_container_name = "moncontainer"
```

3. Alerte mémoire¶

🌞 Compléter votre plan Terraform et mettez en place une alerte mémoire

    la "mémoire" ou "memory", c'est la RAM hein, pas le stockage (je précise au cas où, te sens pas insulté)
    s'il y a moins de 512M de RAM dispo, une alerte doit être levée
    vous devez recevoir un mail
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
azurerm_network_security_group.vm_nsg: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_monitor_action_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/actionGroups/ag-mon-projet-alerts]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_storage_account.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.nsg_association: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]
azurerm_monitor_metric_alert.cpu_alert: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/cpu-alert-super-vm]
azurerm_storage_container.main: Refreshing state... [id=https://monvmstorageacct.blob.core.windows.net/moncontainer]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_monitor_metric_alert.memory will be created
  + resource "azurerm_monitor_metric_alert" "memory" {
      + auto_mitigate            = true
      + description              = "Alerte si la RAM dispo < 512Mo"
      + enabled                  = true
      + frequency                = "PT1M"
      + id                       = (known after apply)
      + name                     = "vm-memory-alert"
      + resource_group_name      = "mon-projet"
      + scopes                   = [
          + "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm",
        ]
      + severity                 = 3
      + target_resource_location = (known after apply)
      + target_resource_type     = (known after apply)
      + window_size              = "PT5M"

      + action {
          + action_group_id = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/actionGroups/ag-mon-projet-alerts"

      + criteria {
          + aggregation            = "Average"
          + metric_name            = "Available Memory Bytes"
          + metric_namespace       = "Microsoft.Insights/virtualMachines"
          + operator               = "LessThan"
          + skip_metric_validation = false
          + threshold              = 536870912
        }
    }

  # azurerm_storage_account.main will be updated in-place
  ~ resource "azurerm_storage_account" "main" {
        id                                 = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct"
        name                               = "monvmstorageacct"
        tags                               = {}
        # (97 unchanged attributes hidden)

      + network_rules {
          + bypass                     = (known after apply)
          + default_action             = "Allow"
          + ip_rules                   = (known after apply)
          + virtual_network_subnet_ids = (known after apply)
        }

        # (3 unchanged blocks hidden)
    }

Plan: 1 to add, 1 to change, 0 to destroy.
╷
│ Warning: Argument is deprecated
│
│   with azurerm_storage_container.main,
│   on storage.tf line 24, in resource "azurerm_storage_container" "main":
│   24:   storage_account_name  = azurerm_storage_account.main.name
│
│ the `storage_account_name` property has been deprecated in favour of `storage_account_id` and will be removed in version 5.0 of the Provider.
╵

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
PS C:\Users\Fadhil\terraform> terraform apply
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet]
azurerm_network_security_group.vm_nsg: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/publicIPAddresses/vm-ip]
azurerm_monitor_action_group.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/actionGroups/ag-mon-projet-alerts]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet]
azurerm_storage_account.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/virtualNetworks/vm-vnet/subnets/vm-subnet]
azurerm_network_interface.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic]
azurerm_network_interface_security_group_association.nsg_association: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkInterfaces/vm-nic|/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg]
azurerm_linux_virtual_machine.main: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm]
azurerm_monitor_metric_alert.cpu_alert: Refreshing state... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/cpu-alert-super-vm]
azurerm_storage_container.main: Refreshing state... [id=https://monvmstorageacct.blob.core.windows.net/moncontainer]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_monitor_metric_alert.memory will be created
  + resource "azurerm_monitor_metric_alert" "memory" {
      + auto_mitigate            = true
      + description              = "Alerte si la RAM dispo < 512Mo"
      + enabled                  = true
      + frequency                = "PT1M"
      + id                       = (known after apply)
      + name                     = "vm-memory-alert"
      + resource_group_name      = "mon-projet"
      + scopes                   = [
          + "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Compute/virtualMachines/super-vm",
        ]
      + severity                 = 3
      + target_resource_location = (known after apply)
      + target_resource_type     = (known after apply)
      + window_size              = "PT5M"

      + action {
          + action_group_id = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/actionGroups/ag-mon-projet-alerts"
        }

      + criteria {
          + aggregation            = "Average"
          + metric_name            = "Available Memory Bytes"
          + metric_namespace       = "Microsoft.Compute/virtualMachines"
          + operator               = "LessThan"
          + skip_metric_validation = false
          + threshold              = 536870912
        }
    }

  # azurerm_storage_account.main will be updated in-place
  ~ resource "azurerm_storage_account" "main" {
        id                                 = "/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct"
        name                               = "monvmstorageacct"
        tags                               = {}
        # (97 unchanged attributes hidden)

      + network_rules {
          + bypass                     = (known after apply)
          + default_action             = "Allow"
          + ip_rules                   = (known after apply)
          + virtual_network_subnet_ids = (known after apply)
        }

        # (3 unchanged blocks hidden)
    }

Plan: 1 to add, 1 to change, 0 to destroy.
╷
│ Warning: Argument is deprecated
│
│   with azurerm_storage_container.main,
│   on storage.tf line 24, in resource "azurerm_storage_container" "main":
│   24:   storage_account_name  = azurerm_storage_account.main.name
│
│ the `storage_account_name` property has been deprecated in favour of `storage_account_id` and will be removed in version 5.0 of the Provider.
╵

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_monitor_metric_alert.memory: Creating...
azurerm_storage_account.main: Modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_monitor_metric_alert.memory: Still creating... [00m10s elapsed]
azurerm_storage_account.main: Still modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-...orage/storageAccounts/monvmstorageacct, 00m10s elapsed]
azurerm_storage_account.main: Modifications complete after 15s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_monitor_metric_alert.memory: Still creating... [00m20s elapsed]
azurerm_storage_account.main: Still modifying... [id=/subscriptions/11a3389f-d095-47e7-b620-...orage/storageAccounts/monvmstorageacct, 00m10s elapsed]
azurerm_storage_account.main: Modifications complete after 15s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct]
azurerm_monitor_metric_alert.memory: Still creating... [00m20s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [00m30s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [00m45s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [00m55s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [01m05s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [01m15s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [01m25s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [01m35s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [01m45s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [01m55s elapsed]
azurerm_monitor_metric_alert.memory: Still creating... [02m05s elapsed]
azurerm_monitor_metric_alert.memory: Creation complete after 2m7s [id=/subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/vm-memory-alert]

Apply complete! Resources: 1 added, 1 changed, 0 destroyed.

Outputs:

public_dns = "monvm-ssh-demo.francecentral.cloudapp.azure.com"
public_ip = "4.211.175.88"
storage_account_name = "monvmstorageacct"
storage_container_name = "moncontainer"
```


4. Proofs¶
A. Voir les alertes avec az¶

🌞 Une commande az qui permet de lister les alertes actuellement configurées
    on doit voir l'alerte RAM
    on doit voir l'alerte CPU

```
PS C:\Users\Fadhil\terraform>
>> az monitor metrics alert list --resource-group mon-projet --output table
AutoMitigate    Description                       Enabled    EvaluationFrequency    Location    Name                ResourceGroup    Severity    TargetResourceRegion    TargetResourceType    WindowSize
--------------  --------------------------------  ---------  ---------------------  ----------  ------------------  ---------------  ----------  ----------------------  --------------------  ------------
True            Alert when CPU usage exceeds 70%  True       PT1M                   global      cpu-alert-super-vm  mon-projet       2                                                         PT5M
True            Alerte si la RAM dispo < 512Mo    True       PT1M                   global      vm-memory-alert     mon-projet       3   

```


B. Stress pour fire les alertes¶

🌞 Stress de la machine
    🌞installez le paquet stress-ng dans la VM
    🌞utilisez la commande stress-ng pour :
        🌞stress le CPU (donner la commande)
        🌞stress la RAM (donner la commande)

        
```
PS C:\Users\Fadhil\terraform> ssh -p 2222 azureuser@monvm-ssh-demo.francecentral.cloudapp.azure.com
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1089-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep 15 15:44:33 UTC 2025

  System load:  0.0               Processes:             112
  Usage of /:   9.5% of 28.89GB   Users logged in:       0
  Memory usage: 35%               IPv4 address for eth0: 10.0.1.4
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Infrastructure is not enabled.

30 updates can be applied immediately.
20 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

44 additional security updates can be applied with ESM Infra.
Learn more about enabling ESM Infra service for Ubuntu 20.04 at
https://ubuntu.com/20-04

New release '22.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Mon Sep 15 13:06:04 2025 from 92.92.128.251
azureuser@super-vm:~$ sudo apt update
Hit:1 http://azure.archive.ubuntu.com/ubuntu focal InRelease
Get:2 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease [128 kB]
Hit:3 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease
Hit:4 http://azure.archive.ubuntu.com/ubuntu focal-security InRelease
Hit:5 https://packages.microsoft.com/repos/azure-cli focal InRelease
Fetched 128 kB in 1s (124 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
30 packages can be upgraded. Run 'apt list --upgradable' to see them.
azureuser@super-vm:~$ sudo apt install -y stress-ng
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  libipsec-mb0 libjudydebian1 libsctp1
Suggested packages:
  lksctp-tools
The following NEW packages will be installed:
  libipsec-mb0 libjudydebian1 libsctp1 stress-ng
0 upgraded, 4 newly installed, 0 to remove and 30 not upgraded.
Need to get 2292 kB of archives.
After this operation, 19.8 MB of additional disk space will be used.
Get:1 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 libipsec-mb0 amd64 0.53-1 [491 kB]
Get:2 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 libjudydebian1 amd64 1.0.5-5 [94.6 kB]
Get:3 http://azure.archive.ubuntu.com/ubuntu focal/main amd64 libsctp1 amd64 1.0.18+dfsg-1 [7876 B]
Get:4 http://azure.archive.ubuntu.com/ubuntu focal-updates/universe amd64 stress-ng amd64 0.11.07-1ubuntu2 [1698 kB]
Fetched 2292 kB in 0s (20.8 MB/s)
Selecting previously unselected package libipsec-mb0.
(Reading database ... 94565 files and directories currently installed.)
Preparing to unpack .../libipsec-mb0_0.53-1_amd64.deb ...
Unpacking libipsec-mb0 (0.53-1) ...
Selecting previously unselected package libjudydebian1.
Preparing to unpack .../libjudydebian1_1.0.5-5_amd64.deb ...
Unpacking libjudydebian1 (1.0.5-5) ...
Selecting previously unselected package libsctp1:amd64.
Preparing to unpack .../libsctp1_1.0.18+dfsg-1_amd64.deb ...
Unpacking libsctp1:amd64 (1.0.18+dfsg-1) ...
Selecting previously unselected package stress-ng.
Preparing to unpack .../stress-ng_0.11.07-1ubuntu2_amd64.deb ...
Unpacking stress-ng (0.11.07-1ubuntu2) ...
Setting up libjudydebian1 (1.0.5-5) ...
Setting up libipsec-mb0 (0.53-1) ...
Setting up libsctp1:amd64 (1.0.18+dfsg-1) ...
Setting up stress-ng (0.11.07-1ubuntu2) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.17) ...
azureuser@super-vm:~$ stress-ng --cpu 0 --timeout 60s
stress-ng: info:  [17943] dispatching hogs: 1 cpu
stress-ng: info:  [17943] successful run completed in 60.07s (1 min, 0.07 secs)
azureuser@super-vm:~$ stress-ng --vm 1 --vm-bytes 600M --timeout 60s
stress-ng: info:  [17950] dispatching hogs: 1 vm
stress-ng: info:  [17950] successful run completed in 60.00s (1 min, 0.00 secs)
azureuser@super-vm:~$ stress-ng --vm 1 --vm-bytes 1G --timeout 60s
stress-ng: info:  [18008] dispatching hogs: 1 vm
stress-ng: error: [18010] stress-ng-vm: gave up trying to mmap, no available memory
stress-ng: info:  [18008] successful run completed in 10.02s
azureuser@super-vm:~$ stress-ng --vm 1 --vm-bytes 600M --timeout 60s
stress-ng: info:  [18011] dispatching hogs: 1 vm
stress-ng: info:  [18011] successful run completed in 60.29s (1 min, 0.29 secs)
```


🌞 Vérifier que des alertes ont été fired

    🌞normalement t'as un mail
    🌞tu le vois dans la WebUI Azure
    🌞dans le compte-rendu, je veux une commande az qui montre que les alertes ont été levées
```
    azureuser@super-vm:~$ az monitor metrics alert list --resource-group mon-projet --output table
AutoMitigate    Description                       Enabled    EvaluationFrequency    Location    Name                ResourceGroup    Severity    TargetResourceRegion    TargetResourceType    WindowSize
--------------  --------------------------------  ---------  ---------------------  ----------  ------------------  ---------------  ----------  ----------------------  --------------------  ------------
True            Alert when CPU usage exceeds 70%  True       PT1M                   global      cpu-alert-super-vm  mon-projet       2                                                         PT5M
True            Alerte si la RAM dispo < 512Mo    True       PT1M                   global      vm-memory-alert     mon-projet       3  

azureuser@super-vm:~$ az monitor activity-log list --resource-group mon-projet --output table
Caller                  CorrelationId                         Description    EventDataId                           EventTimestamp                Level          OperationId                           ResourceGroup    ResourceGroupName    ResourceId                                                                                                                                                                         SubmissionTimestamp    SubscriptionId                        TenantId
----------------------  ------------------------------------  -------------  ------------------------------------  ----------------------------  -------------  ------------------------------------  ---------------  -------------------  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  ---------------------  ------------------------------------  ------------------------------------
remy.bouelet@efrei.net  59aa7461-650d-4eef-b17c-6ed43cfd9b98                 ae74c2fc-5f0d-41e1-822d-b89f3769c224  2025-09-15T15:43:07.4433164Z  Informational  1979695b-d8b0-48d1-aa7b-730bfd5c48fd  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg/securityRules/Allow-SSH-From-My-IP  2025-09-15T15:45:30Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  59aa7461-650d-4eef-b17c-6ed43cfd9b98                 25668a53-0d75-4d09-857f-1604c7b59a30  2025-09-15T15:43:05.6211839Z  Informational  59aa7461-650d-4eef-b17c-6ed43cfd9b98  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg/securityRules/Allow-SSH-From-My-IP  2025-09-15T15:44:37Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  59aa7461-650d-4eef-b17c-6ed43cfd9b98                 2a4ed786-e169-41e9-b705-092d2f17e608  2025-09-15T15:43:05.4024308Z  Informational  59aa7461-650d-4eef-b17c-6ed43cfd9b98  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Network/networkSecurityGroups/mon-projet-nsg/securityRules/Allow-SSH-From-My-IP  2025-09-15T15:44:37Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 26c274a4-8a89-4a10-8098-f87dc954328d  2025-09-15T15:23:58.3203056Z  Informational  fc570395-6361-483c-86d3-7ff2d0439813  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:24:51Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 e901bd16-103b-4142-ad2c-71ab01dfcaf3  2025-09-15T15:23:58.2421766Z  Warning        fc570395-6361-483c-86d3-7ff2d0439813  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:24:51Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 af51762f-77a7-4baa-a6c7-da7474f0402d  2025-09-15T15:23:58.2421766Z  Informational  ee362a2b-28de-4832-9238-3b364dc4d096  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:24:51Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 fe7107a0-481a-4cc4-b919-981a034db336  2025-09-15T15:23:58.2265526Z  Warning        ee362a2b-28de-4832-9238-3b364dc4d096  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:24:51Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  5852db8d-84e2-7a90-20b7-2679313d4d66                 c978bc57-7c49-4c7b-8f3f-5f8abe2d58c0  2025-09-15T15:23:56.6482881Z  Informational  286b7758-56bd-408f-9e9b-4e52a8c93c21  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourcegroups/mon-projet/providers/Microsoft.Insights/metricalerts/vm-memory-alert                                            2025-09-15T15:24:51Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 36d05e53-5863-4d8c-b809-7d37b21b65b9  2025-09-15T15:23:56.4748355Z  Informational  26f14a66-6fbf-4f30-a577-5553e3856f68  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourcegroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:25:10Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  975a22dc-f09a-4b6b-a8c7-d45217d75f85                 de19e773-4c84-4bd2-af74-c4b2e7bf9fd5  2025-09-15T15:14:08.8881658Z  Informational  975a22dc-f09a-4b6b-a8c7-d45217d75f85  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:16:46Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  975a22dc-f09a-4b6b-a8c7-d45217d75f85                 35e7365d-1371-4083-b0ea-7664da77d612  2025-09-15T15:14:08.8413026Z  Informational  975a22dc-f09a-4b6b-a8c7-d45217d75f85  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:16:46Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b4710ce6-3e25-4003-b460-43e0daa05c61                 6299583a-9636-4d13-97ba-b7f18f55a20b  2025-09-15T15:14:08.3415554Z  Informational  b4710ce6-3e25-4003-b460-43e0daa05c61  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:16:03Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b4710ce6-3e25-4003-b460-43e0daa05c61                 72480d06-daa1-4fa3-a5d9-1d7df592fb52  2025-09-15T15:14:08.2790415Z  Informational  b4710ce6-3e25-4003-b460-43e0daa05c61  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:16:03Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  71c7ee66-1888-4962-bac9-68acb81fc52a                 987dc6c9-3260-4552-b060-a4501737fa99  2025-09-15T15:14:07.2253768Z  Informational  71c7ee66-1888-4962-bac9-68acb81fc52a  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:52Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  71c7ee66-1888-4962-bac9-68acb81fc52a                 f4d678d2-3b3a-43bc-9255-7437015ed2be  2025-09-15T15:14:07.1628345Z  Informational  71c7ee66-1888-4962-bac9-68acb81fc52a  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:52Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  5852db8d-84e2-7a90-20b7-2679313d4d66                 a3a51e7d-32b9-4aa3-acbf-d4737d7374d0  2025-09-15T15:13:58.460285Z   Informational  95c91259-25b9-459f-afa8-4a2eb97a04d9  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/vm-memory-alert                                            2025-09-15T15:15:20Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  5852db8d-84e2-7a90-20b7-2679313d4d66                 f174ec6e-779c-421f-bc76-7da43ee3fea4  2025-09-15T15:13:55.569484Z   Informational  95c91259-25b9-459f-afa8-4a2eb97a04d9  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/vm-memory-alert                                            2025-09-15T15:15:20Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 f6f221bc-d16a-419f-a30d-b62372ada02f  2025-09-15T15:13:55.4838661Z  Informational  b88847e4-b3eb-43c7-9bd9-480f453b844f  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:02Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 31b7bddf-a334-4e52-b98d-b606c4227bff  2025-09-15T15:13:55.4682541Z  Informational  b88847e4-b3eb-43c7-9bd9-480f453b844f  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:02Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 96124fc7-a58b-47ed-b03e-9cb5b8745794  2025-09-15T15:13:55.2651218Z  Warning        b88847e4-b3eb-43c7-9bd9-480f453b844f  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:02Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b88847e4-b3eb-43c7-9bd9-480f453b844f                 c16fc7d1-b01e-4439-902f-d7e9f68c79f6  2025-09-15T15:13:55.2182369Z  Informational  b88847e4-b3eb-43c7-9bd9-480f453b844f  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:02Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  34872e15-3134-4c39-946f-1c6673346b59                 ca06165e-5fd6-4a51-9155-565118c9ab21  2025-09-15T15:13:15.8401655Z  Informational  34872e15-3134-4c39-946f-1c6673346b59  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:14:58Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  34872e15-3134-4c39-946f-1c6673346b59                 9b14a96b-d189-47d8-b419-a59f951cf22e  2025-09-15T15:13:15.3089141Z  Informational  34872e15-3134-4c39-946f-1c6673346b59  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:14:58Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  a27db643-8e17-41ef-b183-12638cfce78c                 f15e0e87-fea1-4633-8b71-40978bfa816e  2025-09-15T15:13:14.181609Z   Informational  a27db643-8e17-41ef-b183-12638cfce78c  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:11Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  a27db643-8e17-41ef-b183-12638cfce78c                 0ba99cc2-9053-4c2a-804d-a290e02389ea  2025-09-15T15:13:14.0878576Z  Informational  a27db643-8e17-41ef-b183-12638cfce78c  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:11Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  d6dc08eb-3e78-41db-bd57-8621f440c92c                 06de5eb7-436a-43ce-bc6a-7c75dfa04a07  2025-09-15T15:13:13.0330578Z  Informational  d6dc08eb-3e78-41db-bd57-8621f440c92c  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:16Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  d6dc08eb-3e78-41db-bd57-8621f440c92c                 64330032-0b68-4ec7-8f1c-7add1f0fb8cc  2025-09-15T15:13:12.9236844Z  Informational  d6dc08eb-3e78-41db-bd57-8621f440c92c  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:15:16Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  367a35b6-2881-46b2-a386-667265d03c2e                 3b1eb33d-92d0-4686-83e9-4c410eb7e3c7  2025-09-15T15:11:55.1867755Z  Informational  367a35b6-2881-46b2-a386-667265d03c2e  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:42Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  367a35b6-2881-46b2-a386-667265d03c2e                 29eac82e-6968-4a29-a063-6357aa463a5a  2025-09-15T15:11:55.1086242Z  Informational  367a35b6-2881-46b2-a386-667265d03c2e  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:42Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b92f1796-7e31-4433-a1af-52da07eabbb2                 b40a4aef-a4bb-410b-816c-c80a3a59affd  2025-09-15T15:11:54.3583315Z  Informational  b92f1796-7e31-4433-a1af-52da07eabbb2  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:06Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  b92f1796-7e31-4433-a1af-52da07eabbb2                 018fc2ce-aba8-45bc-a390-c1533c813f62  2025-09-15T15:11:54.3114564Z  Informational  b92f1796-7e31-4433-a1af-52da07eabbb2  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:06Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  d7aa291d-0a24-4535-9d60-e30459af79aa                 fc591242-9a1b-4e39-be4f-b131095f1b56  2025-09-15T15:11:53.4471968Z  Informational  d7aa291d-0a24-4535-9d60-e30459af79aa  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:20Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  d7aa291d-0a24-4535-9d60-e30459af79aa                 ac8a02ee-773e-4cde-b905-7e5c1fd3eb62  2025-09-15T15:11:53.3846751Z  Informational  d7aa291d-0a24-4535-9d60-e30459af79aa  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:20Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  a15c4a6e-189c-8853-946f-8735ac6c5e63                 81434b47-ee34-455b-9fda-e6ab8e053d08  2025-09-15T15:11:42.5821383Z  Error          504caf3c-08c8-46c6-bb55-d14d62134dca  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/vm-memory-alert                                            2025-09-15T15:13:15Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  fdddf838-7d70-498b-8d0b-c76a5e040124                 af647353-8e77-4c61-9afa-f748d095bef1  2025-09-15T15:11:41.7484841Z  Informational  fdddf838-7d70-498b-8d0b-c76a5e040124  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:15Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  fdddf838-7d70-498b-8d0b-c76a5e040124                 26fb5144-26fa-47a3-894f-48d54126e7af  2025-09-15T15:11:41.7170531Z  Informational  fdddf838-7d70-498b-8d0b-c76a5e040124  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:15Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  fdddf838-7d70-498b-8d0b-c76a5e040124                 fc46b011-ff2c-461a-acb2-5f87e0ba63a4  2025-09-15T15:11:41.529565Z   Warning        fdddf838-7d70-498b-8d0b-c76a5e040124  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:15Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  fdddf838-7d70-498b-8d0b-c76a5e040124                 fe26dbb4-195a-4b57-9966-2cb1d7ba8cd3  2025-09-15T15:11:41.4670518Z  Informational  fdddf838-7d70-498b-8d0b-c76a5e040124  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:15Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  a15c4a6e-189c-8853-946f-8735ac6c5e63                 7d42bacc-018f-4970-8e37-081571c6ce94  2025-09-15T15:11:41.4102314Z  Informational  504caf3c-08c8-46c6-bb55-d14d62134dca  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Insights/metricAlerts/vm-memory-alert                                            2025-09-15T15:13:15Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  c7b8caf2-e113-447b-9927-14f76e71f559                 15a9255f-ba08-4a4e-bfbc-5d62581f8d3e  2025-09-15T15:11:09.6534892Z  Informational  c7b8caf2-e113-447b-9927-14f76e71f559  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:06Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  c7b8caf2-e113-447b-9927-14f76e71f559                 d835d172-9bae-4dd5-830b-f5342d7dadcc  2025-09-15T15:11:09.5909926Z  Informational  c7b8caf2-e113-447b-9927-14f76e71f559  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:06Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  15a15666-4b2d-4753-afda-a7c90b6a0675                 755b77cd-c134-42d1-8dde-3efbb1864c80  2025-09-15T15:11:09.0066564Z  Informational  15a15666-4b2d-4753-afda-a7c90b6a0675  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:45Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  15a15666-4b2d-4753-afda-a7c90b6a0675                 c0192d92-4162-460a-ad67-bece73753091  2025-09-15T15:11:08.944159Z   Informational  15a15666-4b2d-4753-afda-a7c90b6a0675  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:45Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  fde2c82d-e186-437b-9cc9-a60420fb9326                 2afae0e8-5e84-415c-bafb-e6fe51598c4a  2025-09-15T15:11:07.7637048Z  Informational  fde2c82d-e186-437b-9cc9-a60420fb9326  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:30Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  fde2c82d-e186-437b-9cc9-a60420fb9326                 ca97d67d-0aef-4e50-97d5-77fd463692d3  2025-09-15T15:11:07.6699633Z  Informational  fde2c82d-e186-437b-9cc9-a60420fb9326  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:13:30Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  3795f27c-470a-42fa-ae3e-f63a8dcdf2eb                 d9af36b7-847f-43e5-9736-108adcd389cb  2025-09-15T15:10:35.6369627Z  Informational  3795f27c-470a-42fa-ae3e-f63a8dcdf2eb  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:18Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  3795f27c-470a-42fa-ae3e-f63a8dcdf2eb                 ffed2100-5a72-4442-b6e0-7f945261a3ac  2025-09-15T15:10:35.57445Z    Informational  3795f27c-470a-42fa-ae3e-f63a8dcdf2eb  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:18Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  1951e03a-b1d0-472e-a6f3-d53bd13edf58                 821ca972-3e80-4af5-a059-db7888977674  2025-09-15T15:10:35.0569026Z  Informational  1951e03a-b1d0-472e-a6f3-d53bd13edf58  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:18Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  1951e03a-b1d0-472e-a6f3-d53bd13edf58                 fe61a409-1471-4484-8f86-6da5db7f4c79  2025-09-15T15:10:34.9945664Z  Informational  1951e03a-b1d0-472e-a6f3-d53bd13edf58  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:18Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
remy.bouelet@efrei.net  96b9c5d0-24d3-4f90-becb-ab78813cf039                 591ff97e-04c4-45cd-9ada-c6a0ca1017d7  2025-09-15T15:10:33.9025788Z  Informational  96b9c5d0-24d3-4f90-becb-ab78813cf039  mon-projet       mon-projet           /subscriptions/11a3389f-d095-47e7-b620-80db81a05f5c/resourceGroups/mon-projet/providers/Microsoft.Storage/storageAccounts/monvmstorageacct                                         2025-09-15T15:12:18Z   11a3389f-d095-47e7-b620-80db81a05f5c  413600cf-bd4e-4c7c-8a61-69e73cddf731
```



























