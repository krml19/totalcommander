#!/bin/sh

#  Delete.command
#  TotalCommander
#
#  Created by Marcin Karmelita on 24/04/17.
#  Copyright © 2017 Marcin Karmelita. All rights reserved.

echo "*********************************"
echo "Delete file"
echo "file: " "${1}"
echo "*********************************"

rm "${1}"

echo "*********************************"
echo "Delete finished"
echo "*********************************"
