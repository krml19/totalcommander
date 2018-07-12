#!/bin/sh

#  Copy.command
#  TotalCommander
#
#  Created by Marcin Karmelita on 24/04/17.
#  Copyright © 2017 Marcin Karmelita. All rights reserved.

echo "*********************************"
echo "Copy file"
echo "From: " "${1}"
echo "To: " "${2}"
echo "*********************************"

cp -r "${1}" "${2}"

echo "*********************************"
echo "Copy finished"
echo "*********************************"
