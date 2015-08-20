$infile  = $args[0]
$outfile = $args[1]

$out = (Get-Content $infile -encoding Default)
if ($env:PKGSERVER) {
    $out = $out.replace("#PKGSERVER:", "").replace("___PKGSERVER___", $Env:PKGSERVER)
}

$out | Out-File $outfile -encoding Default

Write-Host $outfile
