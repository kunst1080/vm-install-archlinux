function onetimeServer($port, $script) {
	$endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Any, $port)
	$listener = New-Object System.Net.Sockets.TcpListener $endpoint
	$listener.Start()
	
	Write-Host "Listenning... :" $port
	Write-Host "    response-script:" $script
	$client = $listener.AcceptTcpClient()
	$stream = $client.GetStream()
	$content = [string]::Join("`n",(Get-Content $script))
	$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
	$stream.Write($buffer, 0 , $buffer.Length)
	$stream.Close()
	$client.Close()
	$listener.Stop()
}

onetimeServer 8080 $args[0]
