#!/bin/sh

#  Move.command
#  TotalCommander
#
#  Created by Marcin Karmelita on 24/04/17.
#  Copyright © 2017 Marcin Karmelita. All rights reserved.

echo "*********************************"
echo "Move started"
echo "From: " "${1}"
echo "To: " "${2}"
echo "*********************************"

mv "${1}" "${2}"

echo "*********************************"
echo "Move finished"
echo "*********************************"
