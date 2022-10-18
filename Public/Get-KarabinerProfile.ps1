function Get-KarabinerProfile
{
    [CmdletBinding(DefaultParameterSetName = 'Current')]
    param
    (
        [Parameter(ParameterSetName = 'ByName', Mandatory, Position = 0)]
        [ArgumentCompleter({(Invoke-Karabiner list-profile-names) -replace '.*\s.*', "'`$0'"})]
        [SupportsWildcards()]
        $Name,

        [Parameter(ParameterSetName = 'All')]
        [switch]$All
    )

    if ($PSCmdlet.ParameterSetName -eq 'Current')
    {
        $Name = Invoke-Karabiner show-current-profile-name
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'All')
    {
        $Name = '*'
    }

    $Config = Get-KarabinerConfig
    $Profiles = $Config.profiles | Where-Object Name -like $Name
    $Profiles | ForEach-Object {$_.PSTypeNames.Insert(0, 'KarabinerProfile')}
    $Profiles
}
