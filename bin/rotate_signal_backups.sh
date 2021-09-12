#!/bin/bash

# 0 0 3 * * /Users/kendrick/bin/rotate_signal_backups.sh >/tmp/rotate_signal_backups.cron.stdout.log 2>/tmp/rotate_signal_backups.cron.stderr.log

backup_root="/Volumes/Finity/Dropbox/Backup/Signal Backups"

current_month_prefix="signal-$(date "+%Y-%m")"
previous_month_prefix="signal-$(date -v-1m "+%Y-%m")"

ls "$backup_root"/

# "~/Dropbox/Backup/Signal Backups/monthlies/signal-2019-10-01-23-27-09.backup"

# copy this month's file
echo "copy this month's file: " cp \"${backup_root}\"/${current_month_prefix}-01-* \"${backup_root}\"/monthlies/
cp "${backup_root}"/${current_month_prefix}-01-* "${backup_root}"/monthlies/

# all hidden files, ignoring . and ..
echo "remove all hidden files: " rm -rf \"${backup_root}\"/.*
rm -rf "${backup_root}"/..?* "${backup_root}"/.[!.]*

# all previous month files
echo "remove all previous month's files: " rm -rf \"${backup_root}\"/${previous_month_prefix}-*
rm -rf "${backup_root}"/${previous_month_prefix}-*


