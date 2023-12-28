FROM ubuntu:23.04
MAINTAINER  tanzhenlong@qq.com

ENV KIBANA_VERSION 6.5.4
ENV KIBANA_BASE_URL https://www.elastic.co/cn/downloads/past-releases#kibana
ENV TIME_ZONE Asia/Shanghai
ENV PATH=/usr/share/kibana/bin:$PATH


WORKDIR /usr/share/kibana


COPY kibana-6.5.4-linux-x86_64.tar.gz /tmp
COPY kibana-docker /usr/local/bin

RUN apt-get update && apt-get upgrade -y \
                   && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
		   && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone \
		   && dpkg-reconfigure -f noninteractive tzdata \
                   && apt-get install fontconfig -y \
                   && tar -zxf /tmp/kibana-6.5.4-linux-x86_64.tar.gz -C /tmp \
                   && mv /tmp/kibana-6.5.4-linux-x86_64/*  /usr/share/kibana\
                   && ln -s /usr/share/kibana /opt/kibana \
                   && userdel -r ubuntu \
                   && groupadd --gid 1000 kibana  \
                   && useradd --uid 1000 --gid 1000       --home-dir /usr/share/kibana --no-create-home       kibana \
                   && chown -R 1000:0 /usr/share/kibana \
                   && chmod -R g=u /usr/share/kibana \ 
                   && find /usr/share/kibana -type d -exec chmod g+s {} \; \
                   && find /usr/share/kibana -gid 0 -and -not -perm /g+w -exec chmod g+w {} \; \
		   && chmod +x /usr/local/bin/kibana-docker \
	           && apt-get clean \
		   && rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*  \

USER 1000
CMD ["/usr/local/bin/kibana-docker"]
