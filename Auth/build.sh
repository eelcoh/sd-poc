#!/bin/sh
#!/bin/bash


SRCPATH="$GOPATH/src/$1"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


cd $SRCPATH

if [[ $? -eq 0 ]]; then
	echo "compiling ... "
	CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' .

	if [[ $? -eq 0 ]]; then
		mv $1 "$DIR/bin"
		echo "moved file"

		if [[ $? -eq 0 ]]; then
			echo "changing working dir"
			cd $DIR

			if [[ $? -eq 0 ]]; then
				echo "build docker file"
				docker build . -t $1

				if [[ $? -eq 0 ]]; then
					echo "done"
				fi

			fi
		fi
	fi


fi
