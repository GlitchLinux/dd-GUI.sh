# DD GUI Utility

This script gives the user a quick and simple GUI for performing `dd` tasks using Zenity. It allows users to copy data from a file to a disk or from one disk to another with a series of dialogs for file and disk selection, followed by a confirmation prompt before executing the `dd` command.

![Screenshot_2024-08-04_00-11-54](https://github.com/user-attachments/assets/ebcfab24-43cf-4641-941c-105d335730e3) ![Screenshot_2024-08-04_00-13-07](https://github.com/user-attachments/assets/9299c5f0-caf7-4480-a119-ad68cfb05d01)

## Features

- **File to Disk**: Select a file to write to a disk.
- **Disk to Disk**: Select a source disk to read from and a destination disk to write to.
- **Confirmation Prompt**: Confirm the operation before it proceeds.
- **Progress Display**: Shows progress of the `dd` operation in the terminal.
- **Completion Notification**: Notifies the user upon completion or cancellation of the operation.

Script enables a user-friendly interface for `dd`  operations, Script aims to simplify the process of copying data between files and disks.

## Requirements

- Bash
- Zenity
- `dd` command-line utility
- `lsblk` command-line utility
- Root permissions (for `dd` operation)

## Usage

1. **Clone the repository or download the script**:

    ```sh
    git clone https://github.com/yourusername/dd-utility-script.git
    cd dd-utility-script
    ```

2. **Make the script executable**:

    ```sh
    chmod +x dd-utility.sh
    ```

3. **Run the script**:

    ```sh
    ./dd-utility.sh
    ```

## Script Details

```bash
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
```

## Notes

- Ensure you have the necessary permissions to perform disk write operations.
- Use with caution as `dd` can overwrite important data.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing

Feel free to submit issues or pull requests if you find any bugs or have suggestions for improvements.

## Author

- **gLiTcH LINUX** (https://github.com/GlitchLinux)

---

Happy cloning!
