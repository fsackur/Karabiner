# $Rule = Get-KarabinerRule -Description 'PC-Style Undo'

# https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/to/

# Valid values in PS-land
enum ToEvent
{
    KeyCode           = 0
    ConsumerKeyCode   = 1
    PointingButton    = 2
    ShellCommand      = 3
    SelectInputSource = 4
    SetVariable       = 5
    MouseKey          = 6
    StickyModifier    = 7
    SoftwareFunction  = 8
}

# Canonical keys in k config
enum ToEventK
{
    key_code            = 0
    consumer_key_code   = 1
    pointing_button     = 2
    shell_command       = 3
    select_input_source = 4
    set_variable        = 5
    mouse_key           = 6
    sticky_modifier     = 7
    software_function   = 8
}

class To
{
    # [ValidateSet(
    #     'KeyCode',
    #     'ConsumerKeyCode',
    #     'PointingButton',
    #     'ShellCommand',
    #     'SelectInputSource',
    #     'SetVariable',
    #     'MouseKey',
    #     'StickyModifier',
    #     'SoftwareFunction'
    # )]
    # [string]$Event
    [ToEvent]$Event

    [string]$Value

    [string[]]$Modifiers

    [bool]$Lazy = $false
    [bool]$Repeat = $true
    [bool]$Halt = $false
    [int]$HoldDownMilliseconds = 0
}

function ConvertTo-To
{
    [OutputType([To])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]$InputObject
    )

    process
    {
        $To = [To]::new()
        $InputObject.PSObject.Properties | ForEach-Object {
            $Event = $_.Name -as [ToEventK]
            if ($null -ne $Event)
            {
                $To.Event = $Event
                $To.Value = $_.Value
            }
            else
            {
                $To.$($_.Name) = $_.Value
            }
        }
        $To
    }
}

function ConvertFrom-To
{
    [OutputType([object])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [To]$InputObject
    )

    process
    {
        $Event = [string][ToEventK]$InputObject.Event
        [pscustomobject]@{
            $Event                 = $InputObject.Value
            modifiers              = [string[]]$InputObject.Modifiers
            lazy                   = $InputObject.Lazy
            repeat                 = $InputObject.Repeat
            halt                   = $InputObject.Halt
            hold_down_milliseconds = $InputObject.HoldDownMilliseconds
        }
    }
}
