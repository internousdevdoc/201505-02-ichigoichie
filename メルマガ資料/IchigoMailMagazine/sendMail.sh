#!/bin/sh
## ローカルデータベースへアクセスしてデータを取得し、取得したアドレス宛にメールを送るスクリプト
DBHOST="localhost"
DBUSER="root"
DBPASS="mysql"
DBNAME="ichigoichie"

MYSQL="/usr/local/bin/mysql"

txt_outputdir="./"
select_subject_sql="./selectSubject.sql"
select_contents_sql="./selectContents.sql"
select_address_sql="./selectAddress.sql"

if [ ! -f "$select_subject_sql" ];then
    echo "SQLファイル(subject)が存在しません。: $select_subject_sql" >&2
    exit 1
fi

if [ ! -f "$select_contents_sql" ];then
    echo "SQL(contents)ファイルが存在しません。: $select_contents_sql" >&2
    exit 1
fi

if [ ! -f "$select_address_sql" ];then
    echo "SQL(address)ファイルが存在しません。: $select_address_sql" >&2
    exit 1
fi

if [ ! -d "$txt_outputdir" ];then    echo "txt出力先のディレクトリが存在しません: $txt_outputdir" >&2
    exit 1
fi

$MYSQL -h "${DBHOST}" -u "${DBUSER}" -p"${DBPASS}" -D "${DBNAME}" -N < "$select_subject_sql" | tr "\t" "," > "${csv_outputdir}/subject.txt"
$MYSQL -h "${DBHOST}" -u "${DBUSER}" -p"${DBPASS}" -D "${DBNAME}" -N < "$select_contents_sql" | tr "\t" "," > "${csv_outputdir}/contents.txt"
$MYSQL -h "${DBHOST}" -u "${DBUSER}" -p"${DBPASS}" -D "${DBNAME}" -N < "$select_address_sql" | tr "\t" "," > "${csv_outputdir}/address.txt"

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
done < $address.txt
echo "send mail success"








