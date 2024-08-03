#!/bin/bash

# Function to display file selection dialog
choose_file() {
    FILE=$(zenity --file-selection --title="Select File" --width=600 --height=400)
}

# Function to display disk selection dialog
choose_disk() {
    DISK_DETAILS=$(lsblk -dpno NAME,SIZE,MODEL | grep -E '^/dev/sd.')
    DISK=$(zenity --list --title="Select Disk" --text="$1\n\n$DISK_DETAILS" --column="Drive" --width=600 --height=400 $(lsblk -dpno NAME | grep -E '^/dev/sd.'))
}

# Function to display confirmation dialog
confirm_dd() {
    zenity --question --title="Confirm DD" --text="Perform DD task:\n\nSource: $SOURCE\nDestination: $DESTINATION\n\nCancel or Execute?" --width=400
}

# Main menu
DD_TASK=$(zenity --list --title="DD Utility" --text="Choose DD task" --column="Task" "File to Disk" "Disk to Disk")

case $DD_TASK in
    "File to Disk")
        choose_file
        choose_disk "Choose disk to write to:"
        SOURCE=$FILE
        DESTINATION=$DISK
        ;;
    "Disk to Disk")
        choose_disk "Choose disk to read from (source):"
        SOURCE=$DISK
        choose_disk "Choose disk to write to (destination):"
        DESTINATION=$DISK
        ;;
    *)
        zenity --error --text="Invalid selection. Exiting."
        exit 1
        ;;
esac

confirm_dd

if [ $? -eq 0 ]; then
    # Execute DD with progress directly in the default terminal
    sudo dd if="$SOURCE" of="$DESTINATION" bs=4M status=progress

    zenity --info --title="DD Completed" --text="DD operation completed successfully." --width=300
else
    zenity --info --title="DD Canceled" --text="DD operation canceled by user." --width=300
fi
