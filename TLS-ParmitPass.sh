#!/bin/bash
set -vx
#========================================================================================
# スクリプト名：TLS-ParmitPass.sh
# 概 要 　　　：秘密鍵を使用したopensslコマンドにて、パスワードの暗号及び復号を行う。また
#　　　 　　　：秘密鍵の作成も行う
# -hオプション：usage
# -gオプション：実行したユーザーホームディレクトリ以下の.sshに秘密鍵を作成する
# -eオプション：ファイルの暗号化を実施する
# -dオプション：ファイルの復号化を実施する
# 第2引数　　：-gオプション：秘密鍵の名前(未入力の場合はデフォルトのid-rsaになる)
#　　　　　　 ：-eオプション：暗号化するパスワードファイル
# 　　　　　　：-dオプション：復号化するファイル
# 第3引数　　：-eオプション：使用する公開鍵のパス
# 　　　　　　：-dオプション：使用する秘密鍵のパス
# 備考　　　　：暗号化する際は、暗号化後の文字列を出力するのでファイルにリダイレクトして
#  　　　　　 ：記録してください
#========================================================================================

#========================================================================================
# 変数/定数等
#========================================================================================
# 第1引数
fst_arg="$1"
# 第2引数
snd_arg="$2"
# 第3引数
thd_arg="$3"
#========================================================================================
# 各オプションの処理記述項目
#========================================================================================

function key_generate() {
   # 秘密鍵の名前を格納
   sec_key_name=$(echo $1)
   
   # 秘密鍵の名前指定が無い場合、「id_rsa」で問題無いか確認
   if [ "$sec_key_name" = "" ] ; then
   
      echo '鍵の名前指定がありませんでした。その場合デフォルトのid_rsaとなりますが問題ありませんか。(yes/no)'
      
      while true ; do

         read answer

         case $answer in

            yes)
        
		    echo 'id_rsa'で鍵を作成致します
        
            sec_key_name=$(echo 'id_rsa')
            ### ループから抜ける
		    break

            ;;

            no)

            echo '一旦処理を終了します。次回鍵ファイルの名前指定を実施して下さい。'
           
            exit 1
            ;;

            *)
            
			echo 'yesかnoで回答して下さい'
            ;;
      
         esac

	  done

   fi
 
   # 既に同名の秘密鍵ファイルが存在していないかチェック
   ls ~/.ssh/"$sec_key_name" >& /dev/null

   # 上記の存在確認
   if [ $? -eq 0 ] ; then

      echo '指定された秘密鍵名は既に~/.ssh/に存在するようです。別名を指定してください。'
      exit 1

   fi

   echo '秘密鍵'"$sec_key_name"'及び公開鍵'"$sec_key_name"'.pemを作成します'
   # 秘密鍵を作成
   ssh-keygen -t rsa -f ~/.ssh/"$sec_key_name" -N ''

   if [ $? -eq 0 ] ; then

      echo '秘密鍵の作成が完了しました。秘密鍵及び公開鍵は以下のパスに存在します'
      find ~/.ssh -maxdepth 1 -mindepth 1  | grep "$sec_key_name"
   
   else

      echo '秘密鍵の作成処理が失敗しています。'
      exit 1

   fi   

}

function file_encryption() {
   # 暗号化するパスワードファイルのパスを格納
   encryption_file=$(echo $1)

   # 指定された公開鍵のパスを格納
   publickey_file=$(echo $2)
   
   # 公開鍵を利用したファイルの暗号化処理
   openssl rsautl -pubin -inkey "$publickey_file" -in "$encryption_file" -encrypt -out ./encriptionfile.txt

   # 暗号化処理が成功しているかの確認処理
   if [ $? -eq 0 ] ; then

      echo '指定したファイルをencriptionfile.txtという名前でカレントディレクトリに作成しました。'

   else

      echo 'ファイル暗号化処理が失敗しています'
      exit 1

   fi

}


function file_decrypton() {
   # 復号化するパスワードファイルのパスを格納
   decripton_file=$(echo $1)
   
   #　指定された秘密鍵のパスを格納
   parmitkey_file=$(echo $2)
   
   # 指定されたフイルをcatコマンドで出力、出力結果を複合する
   decript_word=$(cat "$decripton_file" | openssl rsautl -decrypt -inkey "$parmitley_file")
   
   # 上記の復号処理の結果(catした処理と復号した処理)を一時ファイルに書き出す
   echo "{$pipestatus[@]}" > /var/tmp/decript_status
   
   # catした処理のステータスコードを格納 
   cat_status=$(cat /var/tmp/decript_status | awk '{print $1}')
   
   # opensslの処理のステータスコードを格納
   openssl_status=$(cat /var/tmp/decript_status | awk '{print $2}')
   
   # 一時ファイルである/var/tmp/decript_statusを削除
   rm /var/tmp/decript_status

   if [ $cat_status -ne 0 ] ; then
	   
      echo '暗号化ファイルがうまく出力出来なかったようです。処理を中断します。'
      exit 1

   elif [ $openssl_status -ne 0 ] ; then

      echo '暗号化ファイルの復号がうまく行かなかったようです。'
      exit 1

   else

      echo "$decript_word"
   
   fi
      		  
}


function usage_display() {
   echo '本シェルスクリプトは、暗号化ファイル作成及び暗号化ファイルの復号を行うファイルです。'
   echo 'また、秘密鍵及び公開鍵の作成も実施します。'
   echo ''
   echo '以下オプション説明(※オプションは第一引数に設定してください)'
   echo '-hオプション：usageを表示する'
   echo ''
   echo '-gオプション：実行したユーザーホームディレクトリ以下の.sshに秘密鍵を作成する'
   echo '※第2引数に秘密鍵の名前を指定してください'
   echo ''
   echo '-eオプション：ファイルの暗号化を実施する'
   echo '※第2引数にパスワードファイルのパスを指定して下さい'
   echo '※第3引数に公開鍵のパスを指定して下さい'
   echo '※暗号化する際は、暗号化後の文字列を出力するのでファイルにリダイレクトして下さい。'
   echo ''
   echo '-dオプション：ファイルの復号化を実施する'
   echo '※このオプションは復号した内容を標準出力する機能です'
   echo '※第2引数に復号するファイルのパスを指定してください'
   echo '※第3引数に復号する際に利用する秘密鍵のパスを指定してください'
}

#========================================================================================
# 事前処理
#========================================================================================

# 第1引数チェック処理

if [[ "$fst_arg" =~ (-h|-g|-e|-d) ]]; then
   
   :

else

   echo '第1引数に指定する値が間違っています'
   echo '以下を参照してください'
   
   # 第1引数の指定が間違っている場合は、USAGEを表示
   usage_display

   exit 1

fi

# 第2引数チェック処理

case "$fst_arg" in
   # USAGE表示及び鍵作成の際は、特に何も実施しない
   -[hg] ) : ;;

   # その他の処理は、指定されたファイルの存在チェックを行う。
   * ) 
      if [ -f "$snd_arg" ] ; then

         :
     
      else
         
         echo '第2引数に指定されたファイルが存在しない様です。処理を中断します。'
         exit 1
      fi
   ;;

esac

# 第3引数チェック処理        

case "$fst_arg" in
   # 秘密鍵作成及びUSAGE表示の際は、特に何も実施しない
   -[gh] ) : ;;

   # その他の処理は、指定されたファイルの存在チェックを行う。
   * ) 
      if [ -f "$thd_arg" ] ; then

         :

      else
         
         echo '第3引数に指定されたファイルが存在しない様です。処理を中断します。'
         exit 1

      fi
   ;;

esac

#========================================================================================
# 本処理
#========================================================================================

for OPT in "$@" ; do

   case $OPT in
      # 第1引数にgオプションが指定された場合は、秘密鍵及び公開鍵の作成処理
      -g ) key_generate "$snd_arg" ;;

      # 第1引数にeオプションが指定された場合は、パスワードファイルの暗号化
      -e ) file_encryption "$snd_arg" "$thd_arg" ;;

      # 第1引数にdオプションが指定された場合は、暗号化されたパスワードファイルを復号
      -d ) file_decrypton "$snd_arg" "$thd_arg" ;;

      # 第1引数にhオプションが指定された場合は、USAGE表示
      -h ) usage_display ;;
 
   esac 

done

#========================================================================================
# 事後処理
#========================================================================================

exit 0
