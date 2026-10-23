#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p Work
cd Work
mkdir -p 'Лабораторная работа №1!' 'ФИО' 'Контрольная работа №1!'
chmod 772 'Контрольная работа №1!'
chmod 200 'ФИО'
stat -c '%a %n' 'Контрольная работа №1!' 'ФИО'
touch 'Text @1' 'Text $2' 'Text  #3'
printf '%s\n' 'Птица говорун отличается умом и сообразительностью!' \
    'Отличается умом, отличается сообразительностью...' > 'Text @1'
cat 'Text @1' > 'Text $2'
mv -f 'Text $2' 'Лабораторная работа №1!/'
# Для работы внутри каталога необходимы права x; в конце возвращаем 200.
chmod 700 'ФИО'
cp 'Text @1' 'ФИО/'
gzip -kf 'Text @1' 'Text  #3'
tar -cf MyAchiv 'Text @1.gz' 'Text  #3.gz'
head -n 1 'Text @1' > 'Text  #3'
printf '%s\n' 'Будь осторожен! Преступник вооружен!' >> 'Text  #3'
tac 'Text @1' > 'ФИО/Result_one'
mv -f 'ФИО/Result_one' 'ФИО/Result_two'
find 'ФИО' -mindepth 1 -maxdepth 1 -name 'T*' -printf '%f\n' \
    > 'Лабораторная работа №1!/Result_3'
uname -a >> 'Лабораторная работа №1!/Result_3'
date >> 'Лабораторная работа №1!/Result_3'
printf '\nText  #3:\n'
cat 'Text  #3'
printf '\nResult_two:\n'
cat 'ФИО/Result_two'
printf '\nMyAchiv:\n'
tar -tf MyAchiv
cmp 'Text @1' 'ФИО/Text @1'
cmp 'Text @1' 'Лабораторная работа №1!/Text $2'
tac 'Text @1' | cmp - 'ФИО/Result_two'
gzip -t 'Text @1.gz' 'Text  #3.gz'
chmod 200 'ФИО'
stat -c '%a %n' 'Контрольная работа №1!' 'ФИО'
echo 'Проверки файлов: OK'
