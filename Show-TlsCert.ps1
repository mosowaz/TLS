function Get-TlsChain {
    param(
        [Parameter(Mandatory)]
        [string]$HostName,

        [int]$Port = 443
    )

    $tcp = [System.Net.Sockets.TcpClient]::new($HostName,$Port)
    $ssl = [System.Net.Security.SslStream]::new($tcp.GetStream(),$false,({$true}))
    $ssl.AuthenticateAsClient($HostName)

    $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($ssl.RemoteCertificate)
    $chain = [System.Security.Cryptography.X509Certificates.X509Chain]::new()
    $chain.Build($cert) | Out-Null

    $level = 0

    foreach ($element in $chain.ChainElements) {
        $level++

        Write-Host "`n===== Certificate $level =====" -ForegroundColor Cyan
        Write-Host "Subject: $($element.Certificate.Subject)"
        Write-Host "Issuer : $($element.Certificate.Issuer)"
        Write-Host "Expires: $($element.Certificate.NotAfter)"
        Write-Host ""

        $base64 = [Convert]::ToBase64String($element.Certificate.RawData)

        Write-Output "-----BEGIN CERTIFICATE-----"
        ($base64 -split "(.{64})" | Where-Object { $_ })
        Write-Output "-----END CERTIFICATE-----"
    }

    $ssl.Dispose()
    $tcp.Dispose()
}
