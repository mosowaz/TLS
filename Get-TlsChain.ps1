function Get-TlsChain {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$HostName,

        [int]$Port = 443
    )

    try {
        $tcp = [System.Net.Sockets.TcpClient]::new($HostName, $Port)

        $ssl = [System.Net.Security.SslStream]::new(
            $tcp.GetStream(),
            $false,
            { $true }
        )

        $ssl.AuthenticateAsClient($HostName)

        $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new(
            $ssl.RemoteCertificate
        )

        $chain = [System.Security.Cryptography.X509Certificates.X509Chain]::new()
        $null = $chain.Build($cert)

        $level = 0

        $chain.ChainElements | ForEach-Object {

            $level++

            $role = switch ($level) {
                1 { "Leaf" }
                { $_ -eq $chain.ChainElements.Count } { "Root" }
                default { "Intermediate" }
            }

            [PSCustomObject]@{
                Level      = $level
                Role       = $role
                Subject    = $_.Certificate.Subject
                Issuer     = $_.Certificate.Issuer
                NotBefore  = $_.Certificate.NotBefore
                NotAfter   = $_.Certificate.NotAfter
                Thumbprint = $_.Certificate.Thumbprint
                Protocol   = $ssl.SslProtocol
            }
        }
    }
    finally {
        if ($ssl) { $ssl.Dispose() }
        if ($tcp) { $tcp.Dispose() }
    }
}
