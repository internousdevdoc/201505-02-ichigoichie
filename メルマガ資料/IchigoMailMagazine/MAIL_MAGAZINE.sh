#!/bin/sh

## 使用するディレクトリの設定
CURRENT_DIR="/home/centos/IchigoMailMagazine/"
SQL_DIR="/home/centos/IchigoMailMagazine/SQLFile/"
MAIL_DIR="/home/centos/IchigoMailMagazine/mailFile/"

## Load setting files
## (各種設定ファイルを読み込む)
DB_CONFIG="${CURRENT_DIR}dblist.conf"

#####################################################################
## 接続するawsのインスタンスが変わるときに変更する必要あり
## 接続先のpemfileを設定
pem_file="${CURRENT_DIR}pemFile/internousdev-com-centos-stage-a.pem"
## 接続先のaws(Manager Consoleで確認)
aws_address="centos@52.68.25.72"
## ~/.ssh/configファイルにホストアドレスを書いておく
##  そうすると初めてアクセスするときに言われなくなる
#####################################################################


## SQLファイルの定義
select_subject_sql="${SQL_DIR}select_subject.sql"
select_contents_sql="${SQL_DIR}select_contents.sql"
select_address_sql="${SQL_DIR}select_address.sql"

## 実行する各SQLファイルとデータベースコンフィグ情報があるかどうかチェック
if [[ ! -f ${DB_CONFIG} ]]; then
    echo "[ERROR] Not found file ${DB_CONFIG}"
    exit 1
fi

if [[ ! -f ${select_subject_sql} ]]; then
    echo "[ERROR] Not found file ${select_subject_sql}"
fi

if [[ ! -f ${select_contents_sql} ]]; then
    echo "[ERROR] Not found file ${select_contents_sql}"
fi

if [[ ! -f ${select_address_sql} ]]; then
    echo "[ERROR] Not found file ${select_address_sql}"
fi

. ${DB_CONFIG}
. ${select_subject_sql}
. ${select_contents_sql}
. ${select_address_sql}

echo "[INFO] === START === (`date`)"

## データベースから取得した情報を出力するファイルの設定
subject="subject.txt"
contents="contents.txt"
address="address.txt"

## 外部ファイルからデータベース情報とSQL文インポート
db_con_info=${DB_CONNECT_INFO}
subject_sql=${SUBJECT_SQL}
contents_sql=${CONTENTS_SQL}
address_sql=${ADDRESS_SQL}

echo "dbconnect: $db_con_info"
echo "[INFO]　ssh接続によるデータベースアクセスします"
echo "${subject_sql}を実行"
echo "${subject_sql}" | ssh -i ${pem_file} ${aws_address} mysql -N -B ${db_con_info} > ${MAIL_DIR}${subject}
echo "${subject}ファイルに件名取得終了"
echo "${contents_sql}を実行"
echo "${contents_sql}" | ssh -i ${pem_file} ${aws_address} mysql -N -B ${db_con_info} > ${MAIL_DIR}${contents}
echo "${contents}ファイルに内容取得終了"
echo "${address_sql}を実行"
echo "${address_sql}" | ssh -i ${pem_file} ${aws_address} mysql -N -B ${db_con_info} > ${MAIL_DIR}${address}
echo "${address}アドレス取得終了"
echo "[INFO] ssh接続によるデータベースアクセスが完了しました"

# メール送信テスト
read line < $MAIL_DIR$contents
echo $line
contentsStr=$line

read line < $MAIL_DIR$subject
echo $line
subjectStr=$line

while read line;do
    echo $line
    echo -e "${contentsStr}" | mail -s "${subjectStr}" "${line}"
done < $MAIL_DIR$address

echo "send mail success"

exit 0
