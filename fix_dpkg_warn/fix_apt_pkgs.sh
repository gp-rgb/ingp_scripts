for package in $(apt-get upgrade 2>&1 |\
                 grep "warning: files list file for package '" |\
                 grep -Po "[^'\n ]+'" | grep -Po "[^']+"); do
    apt-get -y install --reinstall "$package";
done
