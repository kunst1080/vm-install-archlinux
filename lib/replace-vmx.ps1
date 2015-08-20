$infile  = $args[0]
$outfile = $args[1]

$in = (Get-Content $infile -encoding Default)
$out = $in.replace("___VM_NAME___", $Env:VM_NAME).replace("___ISO___", $Env:ISO)

$out | Out-File $outfile -encoding Default

Write-Host $outfile
