
#!/bin/sh

dwm_alsa () {
  VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
  printf "%s" "$SEP1"
  if [ "$VOL" -eq 0 ]; then
    printf ""
  elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
    printf " %s%%" "$VOL"
  elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
    printf " %s%%" "$VOL"
  else
    printf "󰕾 %s%%" "$VOL"
  fi
  printf "%s\n" "$SEP2"
}

dwm_alsa

