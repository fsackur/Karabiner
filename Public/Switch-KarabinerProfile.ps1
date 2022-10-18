function Switch-KarabinerProfile
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({
            $Current = Invoke-Karabiner show-current-profile-name
            $All = Invoke-Karabiner list-profile-names
            $Names = (@($All) -ne $Current), $Current | Write-Output
            $Names -replace '.*\s.*', "'`$0'"
        })]
        $Profile
    )

    Invoke-Karabiner select-profile $Profile
}
