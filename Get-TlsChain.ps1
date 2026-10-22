param(
    [Parameter(Mandatory)]
    [string]$HostName
)

$tcp=[Net.Sockets.TcpClient]::new($HostName,443)
$ssl=[Net.Security.SslStream]::new($tcp.GetStream(),$false,({$true}))
$ssl.AuthenticateAsClient($HostName)

$cert=[Security.Cryptography.X509Certificates.X509Certificate2]::new($ssl.RemoteCertificate)
$chain=[Security.Cryptography.X509Certificates.X509Chain]::new()
$chain.Build($cert) | Out-Null

$chain.ChainElements.Certificate |
    Select Subject,Issuer,NotAfter
