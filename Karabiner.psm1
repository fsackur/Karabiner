
'Private', 'Public' |
    ForEach-Object {Join-Path $PSScriptRoot $_} |
    Get-ChildItem -Filter *.ps1 |
    ForEach-Object {. $_.FullName}


$KarabinerProfileCompleter = {
    param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    if (-not $Script:KarabinerProfiles)
    {
        $Script:KarabinerProfiles = (Get-KarabinerConfig).profiles.Name
    }
    $Completions = (@($Script:KarabinerProfiles) -like "$wordToComplete*"), (@($Script:KarabinerProfiles) -like "*.$wordToComplete*") | Write-Output
    $Completions -replace '.*\s.*', "'`$0'"
}

Register-ArgumentCompleter -ScriptBlock $KarabinerProfileCompleter -CommandName Get-KarabinerProfile, Set-KarabinerProfile -ParameterName Name
Register-ArgumentCompleter -ScriptBlock $KarabinerProfileCompleter -CommandName Get-KarabinerRule, Set-KarabinerRule -ParameterName Profile
