Describe "Module pre-requisites" {

    # Testing the build pipeline
    It "Finds Karabiner CLI" {
        InModuleScope Karabiner {
            {Get-KarabinerCommand -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
