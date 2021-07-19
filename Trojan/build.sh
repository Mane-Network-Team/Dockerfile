#! /bin/sh

function write_dockerfile()
{
cat <<EOF >>Dockerfile
FROM alpine
ADD ./trojan-go-linux-amd64.zip /opt/
WORKDIR /opt/
RUN unzip trojan-go-linux-amd64.zip && chmod 'u+x' *
COPY ./config.json /opt/
EXPOSE 10808
CMD /opt/trojan-go -config config.json
EOF
}

configfile="config.json"
if [ ! -f "$configfile" ]; then
	echo "NO FOUND config.json FILE!"
	echo "  - Make sure your local_port should be 10808 !!"
	exit
fi

trojancore="trojan-go-linux-amd64.zip"
if [ ! -f "$trojancore" ]; then
	proxychains wget https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip
fi

dockerfile="Dockerfile"
if [ ! -f "$dockerfile" ]; then
	write_dockerfile
fi

docker build -t trojan .
docker run -itd -p 10808:10808 trojan
