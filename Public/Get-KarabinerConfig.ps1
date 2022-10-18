function Get-KarabinerConfig
{
    $Config = Get-KarabinerConfigPath | Resolve-Path | Get-Content | ConvertFrom-Json
    $Config.PSTypeNames.Insert(0, 'KarabinerConfig')
    $Config
}
