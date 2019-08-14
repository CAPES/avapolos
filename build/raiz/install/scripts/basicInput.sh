basicInput(){ # $1 = message; $2 = option 1 (padrão); $3 = option 2; $4 = useDefault (1 or 0); $5 = errorMessage #the user input is available in the variable $option
   option1=$(tr '[:upper:]' '[:lower:]' <<< "$2" )
   option2=$(tr '[:upper:]' '[:lower:]' <<< "$3" )
   if [ -z $4 ]; then
      useDefault="1";
   else
      useDefault=$4;
   fi
   if [ "$useDefault" = "1" ]; then
      labelDefault=$(tr '[:lower:]' '[:upper:]' <<< "$2" )
   else
      labelDefault=$(tr '[:upper:]' '[:lower:]' <<< "$2" )
   fi
   option="§"
   while ! [[ "$useDefault" = "1" && -z $option ]] && [ ! "$option"  = "$option1" ] && [ ! "$option"  = "$option2" ]; do
      if [ ! -z "$5" ]; then
         if [ ! "$option" = "§" ]; then
            echo $5
         fi
      fi
      echo -e "$1 ($labelDefault/$3)"
      read option
      option=$(tr '[:upper:]' '[:lower:]' <<< "$option" )

   done
}
