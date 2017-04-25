#!/bin/sh

#  Copy.command
#  TotalCommander
#
#  Created by Marcin Karmelita on 24/04/17.
#  Copyright © 2017 Marcin Karmelita. All rights reserved.

echo "*********************************"
echo "Copy file to pastboard"
echo "From: " "${1}"
echo "To: Pasteboard"
echo "*********************************"

pbcopy < "${1}"

echo "*********************************"
echo "Copy finished"
echo "*********************************"
