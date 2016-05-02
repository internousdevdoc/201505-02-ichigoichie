#!/bin/sh
csv_outputdir="/home/centos/IchigoMailMagazine/mailFile"

# メール送信テスト
contentsFile="${csv_outputdir}/contents.txt"
subjectFile="${csv_outputdir}/subject.txt"
read line < $contentsFile
echo "contetnsFile"
echo $line
contents=$line
read line < $subjectFile
echo $line
subject=$line

address="${csv_outputdir}/address.txt"

while read line;do
    echo $line
    echo "${contents}" | mail -s "${subject}" "${line}"
done < $address
echo "send mail success"








