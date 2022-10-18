function Set-KarabinerRule
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
    param
    (
        [ArgumentCompleter({(Invoke-Karabiner list-profile-names) -replace '.*\s.*', "'`$0'"})]
        $Profile,

        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        $Rule
    )

    begin
    {
        $ProfileParams = if ($Profile) {@{Name = $Profile}} else {@{}}
        $_Profile = Get-KarabinerProfile @ProfileParams
        $Rules = $_Profile.complex_modifications.rules
    }

    process
    {
        $Descriptions = @($Rules.description)
        $Index = $Descriptions.IndexOf($Rule.description)
        if ($Index -eq -1)
        {
            $Rules += $Rule
            $Rules = $_Profile.complex_modifications.rules
        }
        else
        {
            $Rules[$Index] = $Rule
        }
    }

    end
    {
        $_Profile | Set-KarabinerProfile
    }
}
