#! /usr/bin/zsh
# vim:smartindent

# This file is public domain. No rights reserved.

#Linkuje index.html na .welcome (nebo opacne) podle toho, ktery je
#novejsi

echo "Index.html <-> .welcome linker"

if [ $# -eq 0 ]; then 
	echo "Usage: $0 <Directory> "
	exit 1
fi
	
if [ ! -d $1 ]; then
	echo "$1 is not directory"
	exit 1
fi

if [  ${1[-1,-1]} != "/" ]; then 
 	typeset 1="$1/"
fi

setopt NULL_GLOB
setopt GLOB_DOTS

function dirlinker ()
{
 local WELCOME=".welcome"
 local INDEX="index.html"
#	echo "INDEX=$INDEX."
        if [[ $INDEX -ef $WELCOME ]]; then
		return
	fi
	if [ ! -r .cacheinfo ]; then
		return
	fi
	if [[ ( -s $INDEX ) || ( -s $WELCOME ) ]]; then
		if [[ ( $INDEX -nt $WELCOME ) || ( ! -s $WELCOME ) ]]; then
			echo "Linking... $INDEX -> $WELCOME"
			ln -f $INDEX $WELCOME
		else
			echo "Linking... $WELCOME -> $INDEX"
			ln -f $WELCOME $INDEX
			
		fi
	fi	
}

function dirwalker ()
{
 echo "Directory $1"
 cd $1
 if [ $? -gt 0 ]; then; return;fi
 dirlinker	 
# echo "Looping.."
 for i in (*)/ ; do
#	 echo $i
	 dirwalker $1$i
 done
 cd ..
}


dirwalker $1
