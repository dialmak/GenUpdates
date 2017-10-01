[![ru-board.com](http://i.piccy.info/i9/cc66ead96da77910881990ceb35dcaac/1477414632/13196/1081034/ru_board.png)](http://forum.ru-board.com/topic.cgi?forum=62&bm=1&topic=30273&start=560#lt)       
 
# GenUpdates  

Внимание! Скачивать ТОЛЬКО по этой ссылке https://github.com/dialmak/GenUpdates/archive/master.zip

###  Описание

Скрипт "GenUpdates.cmd" предназначен для генерирования скриптов установки обновлений Windows с возможностью проконтролировать коды ошибок при установке обновлений.
Расположите "GenUpdates.cmd" вместе с "Settings.ini" перед папками с скачанными обновлениями. 
В "Settings.ini" укажите параметр update_folder - относительный путь к папке с обновлениями, остальные параметры опциональны.
Затем запустите скрипт "GenUpdates.cmd" и следуйте подсказкам. Сгенерированный скрипт для установки обновлений Windows будет записан в ту же папку, что и скрипт "GenUpdates.cmd".

**Внимание!** Если у вас после открытия списка обновлений - "крякозябры", тогда инсталлируйте [notepad++](https://notepad-plus-plus.org/download/).
<hr>

###  Быстрый старт

Пример создания скриптов установки обновлений Windows для списка [Рекомендации по обновлению ОС Windows 7 SP1 + KB3125574 от ***TAILORD***](http://forum.ru-board.com/topic.cgi?forum=62&topic=30273&start=18&limit=1&m=1#1)

- [x] Сделать папочку "Updates 7" и в ней папки 
      * "Updates 01" (для Списка 1 пункты 1-39)  
      * "Updates 02" (для Списка 1 пункт 40)  
      * "Updates 03" (для Списка 1 пункт 42-43)
      * и т.д.
      * "Addons" (для списка Дополнительно) 
       
- [x] Скачать файлы из списков в соответствующие папки.
- [x] Положить в папку "Updates 7" скрипт "GenUpdates.cmd" с файлом настроек "Settings.ini".
- [x] Указать в "Settings.ini" папку "Updates 01" и запустив "GenUpdates.cmd" - сгенерировать скрипт установки обновлений следуя подсказкам.
- [x] Затем проделать тоже самое для остальных папок.
- [x] Пользоваться  :smiley:

<hr>

###  Полный список кодов ошибок Центра обновления

<https://msdn.microsoft.com/en-us/library/windows/desktop/hh968413(v=vs.85).aspx>   
<https://support.microsoft.com/en-us/kb/938205>   
<https://social.technet.microsoft.com/wiki/contents/articles/15260.windows-update-agent-error-codes.aspx>   
