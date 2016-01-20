    #!/bin/bash
    # Modified from http://linuxcommand.org/lc3_adv_dialog.php
    # while-menu-dialog: a menu driven system information program
    # Adjust tcdialog to dialog or similar in Fedora
     
    DIALOG_CANCEL=1
    DIALOG_ESC=255
    HEIGHT=0
    WIDTH=0
  
    display_result() {
      dialog --title "$1" \
        --no-collapse \
        --msgbox "$result" 0 0
        
    }
     
    input_box() {
     dialog --title "$1" \
        --no-collapse \
        --inputbox "Enter file directory"
    }
     
    while true; do
      exec 3>&1
      selection=$(dialog \
        --backtitle "Directory Explorer" \
        --title "Menu" \
        --clear \
        --cancel-label "Exit" \
        --menu "Please Choose:" $HEIGHT $WIDTH 4 \
        "1" "Print Current Directory"  \
        "2" "Current Directory Files" \
        "3" "Total Disk Space Utilised" \
        "4" "Display Home Space Utilisation" \
        2>&1 1>&3)
      exit_status=$?
      exec 3>&-
      case $exit_status in
        $DIALOG_CANCEL)
          clear
          echo "Program Terminated."
          exit
          ;;
        $DIALOG_ESC)
          clear
          echo "Program aborted." >&2
          exit 1
          ;;
      esac


      case $selection in
        0 )
          clear
          echo "Program terminated."
          ;;
        1 )
          result=$(echo "Print Current Directory: $PWD"  )
          display_result "Print Current Directory"
          ;;
        2 )
          result=$(echo "Current Directory Files:" $(ls) )
          display_result "Current Directory Files"
          ;;
        3 )
          result=$(df -h)
          display_result "Disk Space Information"
          ;;
        4 )
          if [[ $(id -u) -eq 0 ]]; then
            result=$(du -sh /home/* 2> /dev/null)
            display_result "Home Space Utilisation (All Users)"
          else
            result=$(du -sh $HOME 2> /dev/null)
            display_result "Home Space Utilisation ($USER)"
          fi
          ;;
      esac
    done
