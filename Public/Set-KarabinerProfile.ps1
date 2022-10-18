function Set-KarabinerProfile
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        $Profile
    )

    begin
    {
        $Config = Get-KarabinerConfig
    }

    process
    {
        $Names = @($Config.profiles.name)
        $Index = $Names.IndexOf($Profile.Name)
        if ($Index -eq -1)
        {
            $Config.profiles += $Profile
        }
        else
        {
            $Config.profiles[$Index] = $Profile
        }
    }

    end
    {
        $Config | Set-KarabinerConfig
    }
}
