function Get-KarabinerRule
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        $Profile,

        [Parameter(Position = 1)]
        [SupportsWildcards()]
        $Description = '*'
    )

    $_Profile = Get-KarabinerProfile $Profile
    $Rules = $_Profile.complex_modifications.rules | Where-Object Description -like $Description
    $Rules | ForEach-Object {$_.PSTypeNames.Insert(0, 'KarabinerRule')}
    $Rules
}
