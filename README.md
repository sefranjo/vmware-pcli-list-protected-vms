# List VMs protected By SRM and their Protecction Groups

This simple scripts are for list all vms protected by SRM. It has only one `parameter` and is the vcenter server.
There are two files, one to list them (`List-SRM-protected-Vms.ps1`) and another to generate a csv (`CSV-SRM-protected-Vms.ps1`)

### Example of usage:

```PowerShell
List-SRM-protected-Vms.ps1 your-vcenter.domain.local
```

Example of output:
```
VM Name                             Protection group name IP
-------                             --------------------- --
vm-DNS1                             GROUP-Services           10.0.0.5
vm-DC1                              GROUP-Services           10.0.0.7
vm-DFS1                             GROUP-Services           10.0.0.8
vm-webserver1                       GROUP-APPS               10.0.1.25
```

