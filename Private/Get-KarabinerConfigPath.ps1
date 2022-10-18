function Get-KarabinerConfigPath
{
    "~/.config/karabiner/karabiner.json" | Resolve-Path | Select-Object -ExpandProperty Path
}
