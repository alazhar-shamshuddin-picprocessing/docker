################################################################################
# This Dockerfile builds a Docker container with the required modules to run
# all the picprocessing applications.
#
# Build the docker image as follows.  Keep the build context and Dockerfile
# paths in mind.
#
#    - If your current working directory is picprocessing (with the
#      various applications in child folders), run the following command.
#      The remaining instructions assume this is your working directory.
#
#         > docker build -f ./docker/Dockerfile -t picprocessing:latest .
#
#    - If your current working directory is picprocessing/docker, however,
#      notice how the Dockerfile path and current context (..) change:
#
#         > docker build -f ./Dockerfile -t picprocessing:latest ..
#
# Run the container using the following commands.  Adjust test_data to point
# to your actual photos directory.  The second volume mount is only required
# if you're running extractpicasainfo.pl.
#
#    - This will launch the bash shell within the container.
#
#         > docker run -it -v "$PWD/test_data":/data \
#                          -v ${USERPROFILE}/AppData/Local/Google/Picasa2/contacts:${USERPROFILE}/AppData/Local/Google/Picasa2/contacts \
#           picprocessing
#
#    - This will allow you to run the necessary script without entering the
#      container (but remember to mount the volumes containing the files you
#      want to process).
#
#          > docker run -it picprocessing perl <app> -h
#
# Within the container, enter the following commands to run the desired scripts:
#
#    > perl gpspics.pl -h
#    > perl extractpicasainfo.pl -h
#
# Note that some commands, like the following example, will modify your actual
# files.
#
#    > perl gpspics.pl -c /data/<folder_name>
#
# Note:
#    - Not all Perl modules (i.e., DateTime and DBI) can be installed using
#      cpanm on the perl:5.32-slim image.  That's why we are using the larger,
#      common image (perl:5.32).
#
#      If you need to install DateTime and DBI on other base images, try
#      the following commands if cpanm doesn't work:
#         > apt update
#         > apt install -y librose-datetime-perl
#         > apt install -y libdbi-perl
#
#      In some instances, you may also need:
#         > apt install perl-doc
#
#    - The cpanm command can be used to install specific module versions using
#      the following command: cpan <module>@<version>.  The script below
#      installs the latest modules but the following version numbers should
#      work if necessary:
#         DateTime           Version 1.54
#         DBI                Version 1.643
#         JSON               Version 4.03
#         File::Slurp        Version 9999.32
#         Image::ExifTool    Version 12.16
#         Log::Log4perl      Version 1.54
################################################################################

FROM perl:5.32
LABEL maintainer="Alazhar Shamshuddin"
RUN cpanm DateTime && \
    cpanm DBI && \
    cpanm JSON && \
    cpanm File::Slurp && \
    cpanm Image::ExifTool && \
    cpanm Log::Log4perl

# Required only for extractpicasainfo.pl
ARG USERPROFILE=/mnt/c/Users/Alazhar
ENV USERPROFILE=$USERPROFILE

COPY ./extractpicasainfo/extractpicasainfo.pl \
    ./gpspics/gpspics.pl \
    ./renamepics/renamepics.pl \
    ./updatedigikaminfo/updatedigikaminfo.pl \
    /apps/
WORKDIR /apps
CMD [ "/bin/bash" ]
