#!/bin/bash
echo "Programa de Backup Diferencial"
#Autor: sysga.com
#Programa de criação de backup diferencial
#DATA: 04/02/2008
echo " "

dadosdif() {

SRCDIR="/home/servidor/*" #diretórios que serão feito backup
DSTDIR=/home/backup_arquivos  #diretório de destino do backup
DATA="`date +\%d-\%m-\%y_\%H_%m`" #pega data atual
TIME_FIND=-30 #+xx busca arquivos criados existentes a xx minutos (arquivos que tenham mais de xx minutos)
#-xx arquivos que tenham sido criados nos últimos xx minutos
#12 horas = 720 minutos 8horas 480 minutos
TIME_DEL=+7   # dias em que permanecera o backup diferencial armazenado

#criar o arquivo dif-data.tar no diretório de destino
ARQ="$DSTDIR/dif-$DATA.tar"
#data de inicio backup
DATAIN=`date +%c`
echo " Data de inicio: $DATAIN"

}

backupdif(){
sync

find $SRCDIR -type f -cmin $TIME_FIND -exec tar  --absolute-names  -rvf $ARQ {} ";"

if [ $? -eq 0 ] ; then
   echo "--------------------------------------"
        echo "Backup Diferencial concluído com sucesso"
   DATAFIN=`date +%c`
   echo "Data de termino: $DATAFIN"
   echo "Backup realizado com sucesso" >> /var/log/backup_diferencial.log
   echo "Criado pelo usuário: $USER" >> /var/log/backup_diferencial.log
   echo "INICIO: $DATAIN" >> /var/log/backup_diferencial.log
   echo "FIM: $DATAFIN" >> /var/log/backup_diferencial.log
   echo "------------------------------------------------" >> /var/log/backup_diferencial.log
   echo " "
   echo "Log gerado em /var/log/backup_diferencial.log"

else
   echo "ERRO! Backup Diferencial $DATAIN" >> /var/log/backup_diferencial.log
fi  
}

procuraedestroidif(){

#apagando arquivos mais antigos (a 7 dias que existe (-cmin +2)
find $DSTDIR -name "dif*" -ctime $TIME_DEL -exec rm -f {} ";"
   if [ $? -eq 0 ] ; then
      echo "Arquivo de backup mais antigo eliminado com sucesso!"
   else
      echo "Erro durante a busca e destruição do backup antigo!"
   fi
}

dadosdif
backupdif
procuraedestroidif

#. ./compactar.backup #chama e roda o script de compactação de backup


exit 0
