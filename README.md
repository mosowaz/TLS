### Powershell Usage

```powershell
iex (irm "https://raw.githubusercontent.com/mosowaz/TLS/main/Get-TlsChain.ps1"); Get-TlsChain -HostName "www.microsoft.com"
```

### Bash Usage
```bash
source <(curl -fsSL https://raw.githubusercontent.com/mosowaz/TLS/main/Get-TlsChain.sh)
get_tls_chain www.microsoft.com
```

Oneliner
```bash
openssl s_client -connect "$HOST:443" -servername www.microsoft.com -showcerts </dev/null
```
