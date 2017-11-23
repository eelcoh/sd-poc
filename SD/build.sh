#!/bin/sh
cd /Users/eelco/Source/go/src/github.com/eelcoh/sdpoc &&

if [[ $? -eq 0 ]]; then
	echo "compiling ... "
	CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' .

	if [[ $? -eq 0 ]]; then
    		mv sdpoc ~/Source/kubernetes/sd-poc/SD/bin
		echo "moved file"

		if [[ $? -eq 0 ]]; then
			echo "changing working dir"
			cd ~/Source/kubernetes/sd-poc/SD

			if [[ $? -eq 0 ]]; then
				echo "build docker file"
				docker build . -t sd

				if [[ $? -eq 0 ]]; then
					echo "done"
				fi

			fi
		fi
	fi


fi
