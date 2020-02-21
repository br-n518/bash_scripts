#!/bin/bash

FILE_PERMS=755

### line_query() - With $subject set, ask the user for $response
function line_query() {
    echo -n "$subject = "
    read response
}

### line_write() - Write a single key-value line to desktop file.
function line_write() {
    echo "$subject=$response">>$DESKTOP_PATH
}

### Get filename for .desktop file
echo "Desktop Entry File (*.desktop):"
subject=Filename
line_query
DESKTOP_PATH=$response
if [ ! "${response: -8}" == ".desktop" ]; then
DESKTOP_PATH="$DESKTOP_PATH".desktop
fi

### Initialize desktop file
echo "[Desktop Entry]">$DESKTOP_PATH
if [ ! -f "$DESKTOP_PATH" ]; then exit 1; fi
chmod $FILE_PERMS $DESKTOP_PATH

### User Input
echo
echo "Enter executable command/path:"
subject=Exec
line_query
line_write

echo
echo "Display name (as seen in menus):"
subject=Name
line_query
line_write
subject=GenericName
line_write

echo
echo "Optional descriptive comment:"
subject=Comment
line_query
line_write

echo
echo "Path to icon file (PNG or SVG):"
subject=Icon
line_query
line_write

### Auto-write
subject=Terminal
response=False
line_write
subject=Type
response=Application
line_write

### Categories
echo -e "\n\n"
echo "CATEGORIES (basic list, choose one or separate with semi-colon):"
echo
echo "*  Accessories, Development, Education,"
echo "*  Game, Graphics, Internet,"
echo "*  Multimedia, Office, System."
echo
subject=Categories
line_query
line_write

echo
echo "Done."
