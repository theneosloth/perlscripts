FROM perl:5.26

RUN cpanm Modern::Perl

RUN cpanm JSON

RUN cpanm IO::Socket::SSL

WORKDIR /scraper

COPY scraper.pl ./scraper.pl

VOLUME /scraper

ENTRYPOINT ["perl", "./scraper.pl"]
