#!/bin/sh
# Подмена asound.conf для визуализатора на часах. Идемпотентно, запускать до quasar.
BIN=/data/opt/clockviz
[ -x "$BIN" ] || exit 0
grep -q ' /etc/asound.conf ' /proc/mounts && exit 0
grep -q '^pcm.dmix_spk {' /etc/asound.conf || exit 0
sed 's|^pcm.dmix_spk {|pcm.dmix_spk_real {|' /etc/asound.conf > /tmp/asound.viz || exit 0
cat >> /tmp/asound.viz <<EOT

pcm.dmix_spk {
  type file
  slave.pcm "dmix_spk_real"
  file "|$BIN -c 2 -r 48000"
  format raw
}
EOT
mount -t none --bind /tmp/asound.viz /etc/asound.conf
EOF
chmod +x /data/opt/clockviz-setup.sh
