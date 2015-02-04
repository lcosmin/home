
echo -n "[+] Setting GO variables..."

case "$(uname)" in
    Darwin)
        export GOROOT=/usr/local/Cellar/go/1.4.1/libexec
        ;;
    Linux)
        export GOROOT=/usr/local/go
        ;;
esac

export GOPATH=$HOME/Work/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

echo "done"

