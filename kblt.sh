#! /bin/bash

locked=false

array[0]=F1
array[1]=F2
array[2]=F3
array[3]=F4
array[4]=F5
array[5]=F6
array[6]=F7
array[7]=F8
array[8]=F9
array[9]=F10
array[10]=F11
array[11]=F12
array[12]=num_indicator
array[13]=logo
array[14]=num_indicator
array[15]=caps_indicator
array[16]=scroll_indicator
array[17]=game_mode
array[18]=back_light
array[19]=shift_left
array[20]=ctrl_left
array[21]=win_left
array[22]=alt_left
array[23]=alt_right
array[24]=win_right
array[25]=menu
array[26]=ctrl_right
array[27]=shift_right
array[28]=mute
array[29]=play_pause
array[30]=stop
array[31]=previous
array[32]=next
array[33]=arrow_top
array[34]=arrow_left
array[35]=arrow_bottom
array[36]=arrow_right
array[37]=num_lock
array[38]=num_slash
array[39]=num_asterisk
array[40]=num_minus
array[41]=num_plus
array[42]=numenter
array[43]=num0
array[44]=num1
array[45]=num2
array[46]=num3
array[47]=num4
array[48]=num5
array[49]=num6
array[50]=num7
array[51]=num8
array[52]=num9
array[53]=num_dot
array[54]=escape
array[55]=print_screen
array[56]=scroll_lock
array[57]=pause_break
array[58]=insert
array[59]=home
array[60]=page_up
array[61]=delete
array[62]=end
array[63]=page_down
array[64]=0
array[65]=1
array[66]=2
array[67]=3
array[68]=4
array[69]=5
array[70]=6
array[71]=7
array[72]=8
array[73]=9
array[74]=a
array[75]=b
array[76]=c
array[77]=d
array[78]=e
array[79]=f
array[80]=g
array[81]=h
array[82]=i
array[83]=j
array[84]=k
array[85]=l
array[86]=m
array[87]=n
array[88]=o
array[89]=p
array[90]=q
array[91]=r
array[92]=s
array[93]=t
array[94]=u
array[95]=v
array[96]=w
array[97]=x
array[98]=y
array[99]=z
array[100]=tab
array[101]=caps_lock
array[102]=space
array[103]=backspace
array[104]=enter
array[105]=tilde
array[106]=minus
array[107]=equal
array[108]=open_bracket
array[109]=close_bracket
array[110]=backslash
array[111]=semicolon
array[112]=dollar
array[113]=quote
array[114]=intl_backslash
array[115]=comma
array[116]=period
array[117]=slash

size=${#array[@]}

speed=0.01

animationPID=false

animate(){
  local cmd
  for i in {0..25}
  do
    index=$(($RANDOM % $size))

    color=$(openssl rand -hex 3)

    cmd=$cmd"k ${array[$index]} ${color}\n"
  done
  cmd=$cmd"c"
  echo -e $cmd | g810-led -pp
}

watchAnimation(){
  while [ true ]
  do
    animate
    sleep $speed
  done
}

set(){
  if [ $1 != $locked ]
  then
    locked=$1
    if [ $animationPID != false ]
    then
    kill $animationPID
    animationPID=false
    fi
    if [ $1 = false ]
    then
      g512-led -fx cwave keys 3
      sleep .5
      g512-led -pp < /etc/g810-led/profile
    elif [ $1 = "login" ]
    then
      watchAnimation &
      animationPID=$!
    else
      g512-led -a 000000
    fi
  fi
}

dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" "type='signal',interface='org.gnome.SessionManager.Presence',member='StatusChanged'" |
  while read x; do
    case "$x" in 
      *"boolean true"*) set true;;
      *"boolean false"*) set false;;  
      *"member=WakeUpScreen"*) set false;;
      *"uint32 3"*) set true;;
      *"uint32 0"*) set "login";;
    esac
  done

