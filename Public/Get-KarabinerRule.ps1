function Get-KarabinerRule
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
    param
    (
        [Parameter(Position = 0)]
        [ArgumentCompleter({(Invoke-Karabiner list-profile-names) -replace '.*\s.*', "'`$0'"})]
        $Profile,

        [Parameter(Position = 1)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            $fakeBoundParameters.Remove($parameterName)
            $Rules = Get-KarabinerRule @fakeBoundParameters
            $Completions = (@($Rules.description) -ilike "$wordToComplete*"), (@($Rules.description) -ilike "*?$wordToComplete*") | Write-Output
            $Completions -replace '.*\s.*', "'`$0'"
        })]
        [SupportsWildcards()]
        $Description = '*'
    )

    $ProfileParams = if ($Profile) {@{Name = $Profile}} else {@{}}
    $_Profile = Get-KarabinerProfile @ProfileParams
    $Rules = $_Profile.complex_modifications.rules | Where-Object Description -like $Description
    $Rules | ForEach-Object {$_.PSTypeNames.Insert(0, 'KarabinerRule')}
    $Rules
}
