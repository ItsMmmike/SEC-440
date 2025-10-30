# Baseline Script for SEC-440 Wk_03
# Run w/ Admin PS

# 1 List Current Auth User
whoami > "$(hostname)_list-current-user.txt"
makecab.exe "$(hostname)_list-current-user.txt" "$(hostname)_list-current-user.cab"

# 2 Enumerate Priv of Current User
whoami /Groups /Priv > "$(hostname)_enumerate-current-user-priv.txt"
makecab.exe "$(hostname)_enumerate-current-user-priv.txt" "$(hostname)_enumerate-current-user-priv.cab"

# 3 Enumerate Hostname
hostname > "$(hostname)_enumerate-hostname.txt"
makecab.exe "$(hostname)_enumerate-hostname.txt" "$(hostname)_enumerate-hostname.cab"

# 4 List all open network sockets
netstat -anbo > "$(hostname)_list-open-net-sockets.txt"
makecab.exe "$(hostname)_list-open-net-sockets.txt" "$(hostname)_list-open-net-sockets.cab"

# 5 List network stats for protocols used
netstat -s > "$(hostname)_list-netstat-and-protocols.txt"
makecab.exe "$(hostname)_list-netstat-and-protocols.txt" "$(hostname)_list-netstat-and-protocols.cab"

# 6 ^List full path to executables listening on each net socket
Get-NetTcpConnection | ? State -eq Listen | % { $p = Get-Process -Id $_.OwningProcess -EA SilentlyContinue; "$($_.LocalAddress):$($_.LocalPort) - $($p.ProcessName) ($($p.Path))" } > "$(hostname)_list-netsocket-full-listening-path.txt"
makecab.exe "$(hostname)_list-netsocket-full-listening-path.txt" "$(hostname)_list-netsocket-full-listening-path.cab"

# 7 ^List all running processes
Get-Process > "$(hostname)_list-running-process.txt"
makecab.exe "$(hostname)_list-running-process.txt" "$(hostname)_list-running-process.cab"

# 8 ^List all running processes + full path of run location
Get-Process | Select ProcessName,ID,Path > "$(hostname)_list-running-process-runpaths.txt"
makecab.exe "$(hostname)_list-running-process-runpaths.txt" "$(hostname)_list-running-process-runpaths.cab"

# 9 ^Enumerate user who owns processes
Get-Process -IncludeUserName | Select ProcessName,ID,UserName > "$(hostname)_enumerate-process-owner.txt"
makecab.exe "$(hostname)_enumerate-process-owner.txt" "$(hostname)_enumerate-process-owner.cab"

# 10 List all loaded modules with running processes
Get-Process | Select -ExpandProperty Modules -EA SilentlyContinue | Select ModuleName > "$(hostname)_list-process-modules.txt"
makecab.exe "$(hostname)_list-process-modules.txt" "$(hostname)_list-process-modules.cab"

# 11 List all associated services w/ process
tasklist /svc > "$(hostname)_list-process-service.txt"
makecab.exe "$(hostname)_list-process-service.txt" "$(hostname)_list-process-service.cab"

# 12 Enumerate Password Policy
net accounts > "$(hostname)_enumerate-password-policy.txt"
makecab.exe "$(hostname)_enumerate-password-policy.txt" "$(hostname)_enumerate-password-policy.cab"

# 13 Enumerate all users
Get-Localuser | Select Name,Enabled > "$(hostname)_enumerate-users.txt"
makecab.exe "$(hostname)_enumerate-users.txt" "$(hostname)_enumerate-users.cab"

# 14 Enumerate all groups
Get-LocalGroup | Select Name > "$(hostname)_enumerate-groups.txt"
makecab.exe "$(hostname)_enumerate-groups.txt" "$(hostname)_enumerate-groups.cab"

# 15 Enumerate all users in each group
Get-LocalGroup | ForEach {
    $group = $_.Name
    Write-Output "ParentGroup: $group"
    Get-LocalGroupMember -Group $group | ForEach {
        Write-Output "User: $($_.Name)"
    }
Write-Output "==="
} | Out-File -FilePath "$PSScriptRoot\$(hostname)_enumerate-group-users.txt" -Encoding UTF8
makecab.exe "$(hostname)_enumerate-group-users.txt" "$(hostname)_enumerate-group-users.cab"

# 16 Enumerate all registered services
Get-Service > "$(hostname)_enumerate-registered-services.txt"
makecab.exe "$(hostname)_enumerate-registered-services.txt" "$(hostname)_enumerate-registered-services.cab"

# 17 Enumerate all running services
Get-Service | Where {$_.Status -eq "Running"} > "$(hostname)_enumerate-running-services.txt"
makecab.exe "$(hostname)_enumerate-running-services.txt" "$(hostname)_enumerate-running-services.cab"

# 18 Enumerate all stopped services
Get-Service | Where {$_.Status -eq "Stopped"} > "$(hostname)_enumerate-stopped-services.txt"
makecab.exe "$(hostname)_enumerate-stopped-services.txt" "$(hostname)_enumerate-stopped-services.cab"

# 19 Enumerate full path of executable for all registered services (running/stopped)
(Get-CimInstance -ClassName Win32_Service).PathName > "$(hostname)_enumerate-exe-path.txt"
makecab.exe "$(hostname)_enumerate-exe-path.txt" "$(hostname)_enumerate-exe-path.cab"

# 20 Enumerate perms for each folder under Program Files
Get-ChildItem "C:\Program Files" -Directory | ForEach {Get-Acl $_.FullName -EA SilentlyContinue} | ForEach { $_.Access} | Select IdentityReference, FileSystemRights | Sort-Object IdentityReference -Unique > "$(hostname)_enumerate-program-files-perms.txt"
makecab.exe "$(hostname)_enumerate-program-files-perms.txt" "$(hostname)_enumerate-program-files-perms.cab"

# 21 Enumerate permissions for the "C:\Users\Public" folder
(Get-ACL (Get-ChildItem "C:\Users\Public").FullName -EA SilentlyContinue).Access | Select IdentityReference, FileSystemRights | Sort-Object IdentityReference -Unique > "$(hostname)_enumerate-public-folder-perms.txt"
makecab.exe "$(hostname)_enumerate-public-folder-perms.txt" "$(hostname)_enumerate-public-folder-perms.cab"

# 22 Enumerate permissions for the "C:\ProgramData" folder
(Get-ACL (Get-ChildItem "C:\ProgramData").FullName -EA SilentlyContinue).Access | Select IdentityReference, FileSystemRights | Sort-Object IdentityReference -Unique > "$(hostname)_enumerate-programdata-folder-perms.txt"
makecab.exe "$(hostname)_enumerate-programdata-folder-perms.txt" "$(hostname)_enumerate-programdata-folder-perms.cab"

# 23 Enumerate all scheduled tasks
Get-ScheduledTask | Select TaskName,State > "$(hostname)_enumerate-scheduled-tasks.txt"
makecab.exe "$(hostname)_enumerate-scheduled-tasks.txt" "$(hostname)_enumerate-scheduled-tasks.cab"

# 24 Enumerate System info about the Windows Host (List details about host)
Get-ComputerInfo > "$(hostname)_enumerate-system-info.txt"
makecab.exe "$(hostname)_enumerate-system-info.txt" "$(hostname)_enumerate-system-info.cab"

# 25 Generate tree outline of the C:\drive
tree C:\ > "$(hostname)_enumerate-c-drive-tree.txt"
makecab.exe "$(hostname)_enumerate-c-drive-tree.txt" "$(hostname)_enumerate-c-drive-tree.cab"

# 26 Compress + Decompress w/ makecab command
# --> Can be done manually via expand cmd --> "expand <cab-file-here.cab> <file-output-location-here>"
