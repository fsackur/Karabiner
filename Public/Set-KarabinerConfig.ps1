function Set-KarabinerConfig
{
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        $Config
    )

    $ConfigPath = Get-KarabinerConfigPath
    $Config | ConvertTo-Json -Depth 20 | Set-Content $ConfigPath
}
