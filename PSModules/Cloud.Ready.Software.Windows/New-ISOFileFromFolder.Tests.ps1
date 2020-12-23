Describe 'New-ISOFileFromFolder' {
    BeforeAll {
        . "$PSScriptRoot\New-ISOFileFromFolder.ps1"
        . "$PSScriptRoot\Write-IStreamToFile.ps1"
    }

    It "does not complain about more than 1 million blocks" {
        $filepath = "$TestDrive\example.txt"
        $resultfullfilepath = "$TestDrive\result.iso"
        $proverb = "All work and no play makes Jack a dull boy`r`n"
        $repeat1 = 1MB
        $data = $proverb * $repeat1
        $repeat2 = 45 # 44 fits under 1 million blocks?
        $expectedinputlength = $repeat1 * $repeat2 * $proverb.Length
        $expectedoutputlength = $expectedinputlength + 1MB + 128KB
        for ($i = 0; $i -lt $repeat2; $i++) {
            Add-Content -Value $data -Encoding ascii -LiteralPath $filepath -NoNewline
        }
        (Get-ChildItem -LiteralPath $filepath).Length | Should Be $expectedinputlength
        {
            New-ISOFileFromFolder -FilePath $filepath -Name 'megablock' -ResultFullFileName $resultfullfilepath
        } | Should Not Throw
        (Get-ChildItem -LiteralPath $resultfullfilepath).Length | Should Be $expectedoutputlength
    }
}
