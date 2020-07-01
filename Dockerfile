FROM ubuntu:18.04

# Maintainer 
MAINTAINER "Praveen Edulakanti" 

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y git

RUN apt-get install -y apache2

RUN apt-get install -y software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update

RUN apt-get install -y php7.2 \
    php7.2-mysql \
    php7.2-cli \
    php7.2-common \
    libapache2-mod-php7.2 \
    php7.2 php7.2-curl \
    php7.2-mbstring

RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Configure apache for TYPO3
RUN a2enmod rewrite expires
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
RUN a2enconf servername

#run apache
CMD ["apachectl", "-D", "FOREGROUND"]

RUN cd /var/www/html/

RUN mkdir -p /var/www/html/user

RUN git clone https://github.com/praveen-edulakanti/user.git /var/www/html/user

RUN rm -rf /var/www/html/user/config.php

COPY config.php /var/www/html/user/config.php

#Set working directory
WORKDIR /var/www/html/

EXPOSE 80