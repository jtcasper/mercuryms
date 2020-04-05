#!/bin/bash
# DATA indices are defined by the mercuryms-send program, and are from mercuryms-sqlite
# 0: MEDIA.ID
# 1: MEDIA.PHONE_NUMBER
# 2: MEDIA.URI
while IFS='|' read -a DATA DATA_STR; do
    # Check if the phone number has an existing folder.
    # WebDAV responds to a PROPFIND with a 207 if a resource exists.
    # It responds 404 otherwise, but we will attempt to create on any other code.
    # AWK exits with inverted exit codes to use the && bash short circuit.
    curl --silent \
         --include \
         --user $USER:$($PW_COMMAND) \
         "$HOST/remote.php/dav/files/$USER/${DATA[1]}" \
         -X PROPFIND \
         --data '<?xml version="1.0" encoding="UTF-8"?>
 <d:propfind xmlns:d="DAV:">
   <d:prop>
     <d:resourcetype/>
   </d:prop>
 </d:propfind>' \
    | awk '/HTTP\// {if ($2 == "207") { exit 1; } else { exit 0; }}' \
    && curl --silent \
            --user $USER:$($PW_COMMAND) \
            -X MKCOL "$HOST/remote.php/dav/files/$USER/${DATA[1]}"
    # Download the media we were sent from the URI.
    # Upload it to Nextcloud and respond with the ID in the database
    # so that we can record success.
    IDENTIFIER=$(echo ${DATA[2]} | awk -F/ '{print $NF}')
    curl --silent \
         --location ${DATA[2]} \
    | curl --silent \
           --user $USER:$($PW_COMMAND) \
           --upload-file - \
           "$HOST/remote.php/dav/files/$USER/${DATA[1]}/$IDENTIFIER.jpg" && echo ${DATA[0]} received.
done

exit 0
