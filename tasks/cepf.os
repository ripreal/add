#Использовать logos
#Использовать fs
#Использовать cmdline
#Использовать "."

Перем ВозможныеКоманды;
Перем Лог;

Процедура ИнициализацияОкружения()

	Лог = Исходники.ПолучитьЛог();
	
	ПарсерАргументовКоманднойСтроки = Новый ПарсерАргументовКоманднойСтроки();

	Исходники.УстановитьПараметрыСборкиРазборкиДляКоманднойСтроки(ПарсерАргументовКоманднойСтроки);

	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметр("--key", "Ключ массива файлов из json-файла настроек", Истина);

	ПарсерАргументовКоманднойСтроки.ДобавитьПараметр("Каталог", 
		"Каталог, где находятся исходники для сборки бинарных файлов (epf,erf)");
	
	Аргументы = ПарсерАргументовКоманднойСтроки.Разобрать(АргументыКоманднойСтроки);
	
	ОдинКаталог = Аргументы["Каталог"];
	Лог.Отладка("Получили каталог для сборки <%1>", "" + ОдинКаталог);
	КлючМассиваФайловВФайлеНастроек = Аргументы["--key"];
	Лог.Отладка("Получили ключ массива файлов в json-файле настроек для сборки <%1>", "" + КлючМассиваФайловВФайлеНастроек);

	ОписаниеСборкиРазборки = Исходники.ОписаниеСборкиРазборки(Аргументы, Лог);
	ПутьКаталогаСборки = ОписаниеСборкиРазборки.ПутьКаталогаСборки;
	
	Если Не ПустаяСтрока(ОдинКаталог) Тогда
		
		МассивПутей = Новый Массив();
		МассивПутей.Добавить(ОдинКаталог);
		
	Иначе
		
		МассивПутей = Исходники.ПапкиВнешнихФайлов(КлючМассиваФайловВФайлеНастроек);
		
	КонецЕсли;

	КаталогПроекта = Исходники.КаталогПроекта();
	Для каждого Элемент из МассивПутей Цикл
		ЗапуститьОбработку(Элемент, КаталогПроекта, ПутьКаталогаСборки);
	КонецЦикла;

КонецПроцедуры

Процедура ЗапуститьОбработку(Знач Путь, Знач КаталогПроекта, Знач ПодкаталогСборки)
	// ПодкаталогСборки = ?(Бинарники1СХранятсяРядомСИсходниками, "", ПутьКаталогаСборки + "/");

	КаталогСоответствующийКорню = Исходники.КаталогСоответствующийКорню();

	Файл = Новый Файл(Путь);
	Если Файл.ИмяБезРасширения = КаталогСоответствующийКорню И Файл.ЭтоКаталог() Тогда 
		ЧтоИКуда = СтрШаблон("./%2 ./%1", ПодкаталогСборки, КаталогСоответствующийКорню);
	Иначе
		ОтносительныйПутьРодителя = ФС.ОтносительныйПуть(КаталогПроекта, Файл.Путь);

		Если ОтносительныйПутьРодителя = КаталогСоответствующийКорню Тогда
			ЧтоИКуда = СтрШаблон("%3/%1 ./%2", Файл.ИмяБезРасширения, ПодкаталогСборки, КаталогСоответствующийКорню);
		Иначе
			ЧтоИКуда = СтрШаблон("%1 ./%2%1", Путь, ПодкаталогСборки);
		КонецЕсли;
	КонецЕсли;

	ШаблонЗапуска = СтрШаблон("oscript ./tools/runner.os compileepf %1 --ibname /F./build/ibservice", ЧтоИКуда);
	Исходники.ИсполнитьКоманду(ШаблонЗапуска);
	
КонецПроцедуры

ИнициализацияОкружения();
