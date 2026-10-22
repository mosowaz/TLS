get_tls_chain() {
    local host="$1"
    local port="${2:-443}"

    echo "TLS Certificate Chain for $host:$port"
    echo

    openssl s_client \
        -connect "${host}:${port}" \
        -servername "$host" \
        -showcerts \
        </dev/null 2>/dev/null |
    awk '
        /s:/ {
            level++
            printf "\nLevel %d\n", level
            print
        }
        /i:/ { print }
    '
}
