function Set-KarabinerRule
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        $Profile,

        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        $Rule
    )

    begin
    {
        $_Profile = Get-KarabinerProfile $Profile
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
