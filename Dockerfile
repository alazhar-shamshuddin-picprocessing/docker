################################################################################
# This Dockerfile builds a Docker container with the required modules to run
# all the picprocessing applications.  See README.md for details.
################################################################################

FROM perl:5.32
LABEL maintainer="Alazhar Shamshuddin"
RUN cpanm DateTime && \
    cpanm DBI && \
    cpanm JSON && \
    cpanm File::Slurp && \
    cpanm Image::ExifTool && \
    cpanm Log::Log4perl

# Required only for extractpicasainfo.pl if running in Windows Subsystem for 
# Linux (WSL)
ARG USERPROFILE=/mnt/c/Users/Alazhar
ENV USERPROFILE=$USERPROFILE

COPY ./extractpicasainfo/extractpicasainfo.pl \
    ./gpspics/gpspics.pl \
    ./renamepics/renamepics.pl \
    ./updatedigikaminfo/updatedigikaminfo.pl \
    /apps/
WORKDIR /apps
CMD [ "/bin/bash" ]
