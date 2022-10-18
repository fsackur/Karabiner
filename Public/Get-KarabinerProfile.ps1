function Get-KarabinerProfile
{
    param
    (
        [SupportsWildcards()]
        $Name = '*'
    )

    $Config = Get-KarabinerConfig
    $Profiles = $Config.profiles | Where-Object Name -like $Name
    $Profiles | ForEach-Object {$_.PSTypeNames.Insert(0, 'KarabinerProfile')}
    $Profiles
}
