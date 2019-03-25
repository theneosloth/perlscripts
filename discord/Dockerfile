FROM perl:5.26

RUN cpanm Modern::Perl

RUN cpanm JSON

RUN cpanm IO::Socket::SSL

RUN cpanm Net::SSLeay

WORKDIR /scraper

COPY scraper.pl ./scraper.pl

ENTRYPOINT ["perl", "./scraper.pl"]
