# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

$vcenter = $args[0]

$credential = Get-Credential
Connect-ViServer -Server $vcenter -Credential $credential

$srm = Connect-SrmServer -Credential $credential -RemoteCredential $credential

$srmApi = $srm.ExtensionData
$protectionGroups = $srmApi.Protection.ListProtectionGroups()

$protectionGroups | % {
    $protectionGroup = $_
    $protectionGroupInfo = $protectionGroup.GetInfo()
    # The following command lists the virtual machines associated with a protection group
    $protectedVms = $protectionGroup.ListProtectedVms()
    # The result of the above call is an array of references to the virtual machines at the vSphere API
    # To populate the data from the vSphere connection, call the UpdateViewData method on each virtual machine view object
    $protectedVms | % { $_.Vm.UpdateViewData() }
    # After the data is populated, use it to generate a report
    $protectedVms | %{
            $output = "" | select VmName, PgName, VmIP
            $output.VmName = $_.Vm.Name
            $output.VmIP = $_.Vm.Guest.IPAddress
            $output.PgName = $protectionGroupInfo.Name
            $output
    }
} | Format-Table -AutoSize @{Label="VM Name"; Expression={$_.VmName} }, @{Label="Protection group name"; Expression={$_.PgName} },  @{Label="IP"; Expression={$_.VmIP} }

disconnect-viserver -Server $vcenter -confirm:$false
Disconnect-SrmServer -confirm:$false
