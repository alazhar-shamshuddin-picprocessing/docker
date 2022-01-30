# picprocessing (Docker)
This Dockerfile builds a Docker container with the required modules to run
the following picprocessing applications:
1. extractpicasainfo  
1. gpspics  
1. renamepics
1. updatedigikaminfo

## Quick Start
1. Build the docker image.  Keep the build context and Dockerfile paths in mind.

    - If your current working directory is `picprocessing` (with the
     various applications in child folders), run the following command.
     The remaining instructions assume this is your working directory.

        > `docker build -f ./docker/Dockerfile -t picprocessing:latest .`

   - If your current working directory is picprocessing/docker, however,
     notice how the Dockerfile path and current context (..) change:

        > `docker build -f ./Dockerfile -t picprocessing:latest ..`

1. Run the container using one of the options below.  Adjust test_data to point
to your photos directory.  The second (Picasa) volume mount is only required
if you're running `extractpicasainfo.pl`; it depends on where the Picasa
contacts folder lives on the host machine.

   - Launch a bash shell within the container:

        - This is the most basic way to enter the container.  The second command
        is redundant because the Dockerfile already specifies `bash` as the
        default CMD.  Note that no volumes are mounted; files on the host 
        machine are not available to the Docker container.
        
            > `docker run -it picprocessing`

            > `docker run -it picprocessing bash`

        - This command is tailored for Window Subsystem for Linux (WSL) and
        assumes you have Picasa installed.  It mounts the "test_data" folder
        on the host system to the /data folder inside the container.  It
        also mounts Picasa's contacts folder using the same path inside the 
        container as the host system.

            ```
            docker run -it \
                -v "$PWD/test_data":/data \
                -v ${USERPROFILE}/AppData/Local/Google/Picasa2/contacts:${USERPROFILE}/AppData/Local/Google/Picasa2/contacts \
                picprocessing
            ```
    
        - This command is tailored for Linux and assumes you have Picasa 
        installed under Wine.  

            ```
            docker run -it \
                -v "$PWD/test_data":/data \
                -v "$HOME/.wine/drive_c/users/alazhar/Local Settings/Application Data/Google/Picasa2/contacts":/data/AppData/Local/Google/Picasa2/contacts \
                picprocessing
            ```

      Within the container, you may run the Perl apps as per the following
      examples:

        > `perl <app> -h`
        
        > `perl gpspics.pl -h`

        > `perl extractpicasainfo.pl -h`

    - You may run the necessary apps without entering the container as per the 
    following examples.  Note that you must modify the the commands below to
    mount the volumes containing the files you want to process (as per 
    the examples above).

        > `docker run -it picprocessing perl <app> -h`

        > `docker run -it picprocessing perl renamepics -h`

## Notes
- Modifying files in mounted volumes inside the container will modify them
on the host system.

- Some commands, like the following example, will modify your actual
files on the host system.

    > `perl gpspics.pl -c /data/<folder_name>`

- Not all Perl modules (i.e., DateTime and DBI) can be installed using cpanm on
the perl:5.32-slim image.  That's why we are using the larger, common image 
(perl:5.32).

- If you need to install DateTime and DBI on other base images, try the 
following commands if cpanm doesn't work:

    > `sudo apt update`

    > `sudo apt install -y librose-datetime-perl`
        
    > `sudo apt install -y libdbi-perl`

    In some instances, you may also need:

    > `sudo apt install perl-doc`

- The cpanm command can be used to install specific module versions using the
following command: 

    > `cpanm <module>@<version>`  

- The Dockerfile installs the latest modules but the following version numbers
should work if necessary:

    | Module          | Version |
    | --------------- | ------- |
    | DateTime        | 1.54    |
    | DBI             | 1.643   |
    | JSON            | 4.03    |
    | File::Slurp     | 9999.32 |
    | Image::ExifTool | 12.16   |
    | Log::Log4perl   | 1.54    |
