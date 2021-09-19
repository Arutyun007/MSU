include console.inc

.data
	POPULATION STRUC ; популяция
		X1 DD ? ; X1
		X2 DD ? ; X2
		X3 DD ? ; X3
	POPULATION ENDS

; Вводятся пользователем
	A1 DD 1 ; Значение коэффициента A1
	A2 DD 1 ; Значение коэффициента A2
	A3 DD 1 ; Значение коэффициента A3
	D  dd 81 ; Значение коэффициента D
	SizeInitialPopulation equ 4 ; Размер начальной популяции в диапазоне от 4 до 10 включительно
	IterationLimit dd 1000000000 ; Критерий останова - количество итераций
	Residual dd 0 ; Критерий останова - невязка уравнения
	MutationProbability dd 20; Вероятность мутации в процентах %
	ProgramMode dd 0; Режим работы программы (0 - тестовый, 1 - основной)
	
; Вспомогательные переменные
	CurrentIteration dd 1 ; Счетчик итераций
	BitNumber db 0 ; Номер бита для изменения при мутации
	temp dd 4 ; Переменная буфера для тестирования генерации случайного числа
	MaxValueRange dd 255 ; Верхний диапазон при генераии чисел для начальной популяции
	NumberOfParentGen dd 3; Количество генов у каждого родителя (хромосомы)
	Limit dd 255 ; При расчете целевой функции
	ObjectiveFunctionSum dd 0 ; Среднее значение целевой функции
	AverageObjectiveFunction dd 0 ; Среднее значение целевой функции
	RelationFiAndFaveDivSum dd 0 ; Сумма целой части от деления Fi/Fср
	RelationFiAndFaveModSum dd 0; Сумма остатка от деления Fi/Fср
	RelationFiAndFaveDivPercentSum dd 0; Сумма целой части вероятностей Fi/Fср
	NumberOfGens dd 0; Суммарное количество генов
	SizeArrangeRuler dd 2 ; Размер массива из линейки
	MaxValueRangeRuler dd 0 ;  Максимальное число диапазона линейки
	ZeroOneRange dd 1 ;  Для генерации чисел 0 и 1
	BitNumberRange dd 7 ; Для генерации номера бита от  0-7	
	ProbabilityForOneGene dd 0; Вероятность на 1 ген
	
; Вспомогательные переменные - массивы	
	ObjectiveFunction dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений целевой функции
	ObjectiveFunctionLocal dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений вспомогательной функции
	RelationFiAndFaveArrDiv dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений div части отношения Fi/Fср
	RelationFiAndFaveArrMod dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений mod части отношения Fi/Fср
	RelationFiAndFaveArrDivPercent dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений целой части вероятности по Fi/Fср в процентах каждой популяции
	RelationFiAndFaveArrModPercent dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений остатка вероятности по Fi/Fср в процентах каждой популяции
	ExchangeNumberFromEveryParentArrDiv dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений для количества обменов от каждого родителя (хромосомы)
	ExchangeNumberFromEveryGenArrDiv dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Массив для значений для количества обменов от каждого гена родителя (хромосомы)
	DifferenceResultAndDArr dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Мазница между результатом Диафантова уравнения и D
	ArrangeRulerArr dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Линейка с диапазоном попадания
	ParentFirstArr dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Линейка с диапазоном попадания первого родителя
	ParentSecondArr dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Линейка с диапазоном попадания второго родителя
		
; Вспомогательные переменные - массивы структур
	P POPULATION <> , (SizeInitialPopulation - 1) DUP ( <> ); Инициализация массив структур из популяций
	P1 POPULATION <> , (SizeInitialPopulation - 1) DUP ( <> ); Родитель 1
	P2 POPULATION <> , (SizeInitialPopulation - 1) DUP ( <> ); Родитель 2
	
	

	
.code
	
; Генерация случайного числа
	RandomGenerator proc
		push ebp ;соглашение о связях (вызов регистра в стек)
		mov ebp, esp ;esp-адрес в памяти стеке. esp всегда указывает на вершину стека
		;push eax
		push ebx
		push edx
		push ecx
		
		mov eax, [ebp + 8] ; записал в eax значение eax
		mov ebx, [ebp + 12] ; записал в ebx значение MaxValueRange

		mov eax, ebx
		add eax, 1
		invoke nrandom, eax ; генерирует в eax случайное значение из диапазона от 0 до MaxValueRange

	;	; pop в обратном порядке по сравнения с верхом, где push
		pop ecx
		pop edx
		pop ebx
		;pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	RandomGenerator endp
	

; Генерация случайного числа в основной программе	
	RandomGeneratorMainProgram proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push edx
		push ecx
		push edi
		
		mov edi, [ebp + 8] ; Переменная для записи
		mov ebx, [ebp + 12] ; Значение MaxValueRange

		mov eax, ebx
		add eax, 1
		invoke nrandom, eax ; Генерирует в eax случайное значение из диапазона от 0 до MaxValueRange
		
		mov dword ptr [edi], eax

		pop edi
		pop ecx
		pop edx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp	
		ret 2*4
	RandomGeneratorMainProgram endp

	
; Заполнение одной популяции	
	GeneratorInitialPopulation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push edx
		
		assume edx: ptr POPULATION

		mov edx, [ebp + 8] ; записал в edx структуру популяции
		mov ebx, [ebp + 12] ; записал в ebx значение MaxValueRange
		
		push ebx
		push eax
		call RandomGenerator
		mov [edx].X1, eax
		
		push ebx
		push eax
		call RandomGenerator
		mov [edx].X2, eax
		
		push ebx
		push eax
		call RandomGenerator
		mov [edx].X3, eax

		pop edx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	GeneratorInitialPopulation endp
	
; Заполнение всей начальной популяции
	GeneratorInitialAllPopulation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		
		mov ecx, SizeInitialPopulation
		mov ebx, offset P
		
	CycleInitial:
		push MaxValueRange
		push ebx
		call GeneratorInitialPopulation
		add ebx, sizeof POPULATION
	loop CycleInitial
	
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		
		ret
	GeneratorInitialAllPopulation  endp
	
; Генерация начальной популяции по заданным значениям		
	GivenInitialAllPopulation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		assume edi: ptr POPULATION
		
		mov edi, [ebp+8] ; Массив структур
		
		mov [edi].X1, 87
		mov [edi].X2, 223
		mov [edi].X3, 154	
		
		add edi, sizeof POPULATION
		mov [edi].X1, 41
		mov [edi].X2, 164
		mov [edi].X3, 212
		
		add edi, sizeof POPULATION
		mov [edi].X1, 98
		mov [edi].X2, 255
		mov [edi].X3, 65
		
		add edi, sizeof POPULATION
		mov [edi].X1, 176
		mov [edi].X2, 34
		mov [edi].X3, 3
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret
	GivenInitialAllPopulation  endp
	
	
; Передача на вывод популяции
	OutputPopulation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		
		mov ecx, SizeInitialPopulation
		mov ebx, offset P
		
	OutputCycle:
		push ebx
		call printStruc
		add ebx, sizeof POPULATION
	loop OutputCycle
		
		push edx
		push ecx
		pop edx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp	
		ret
	OutputPopulation  endp

	
; Передача на вывод популяции
	OutputPopulationMainProgram proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		
		assume edx: ptr POPULATION
		
		mov edx, [ebp + 8] ; Массив структуры 
		mov ecx, SizeInitialPopulation ; Размер популяции
		
	OutputPopulationMainProgramCycle:
		push edx
		call printStruc
		add edx, sizeof POPULATION
	loop OutputPopulationMainProgramCycle
		
		push edx
		push ecx
		pop edx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp	
		ret 4
	OutputPopulationMainProgram  endp	

	
; Вывод по одной популяции
	printStruc proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		assume edi: ptr POPULATION
		
		mov edi, [ebp+8] ; Структура
		
		mov edx, [edi].X1
		outintln edx,, "P.X1 =  "
		mov edx, [edi].X2
		outintln edx,, "P.X2 =  "
		mov edx, [edi].X3
		outintln edx,, "P.X3 =  "
		outstrln
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp	
		ret 4
	printStruc endp		

; Печать массива	
	printArray proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		
		mov eax, [ebp+8] ; Массив
		mov ecx, [ebp+12] ; Размер массива

	PrintCycle:
		push [eax]
		call printArrayElement
		add eax, 4
	loop PrintCycle

		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		
		ret 2*4
	printArray endp
	
	printArrayElement proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		
		mov eax, dword ptr[ebp+8]
		outintln eax
		
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		
		ret 4
	printArrayElement endp
	
	
; Вычисление целевой функции 255*D/((F(X1, X2, X3)-D), F(X1, X2, X3)- вспомогательная функция
	ObjectiveFunctionCalculation1 proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov edi, [ebp + 8] ;записал в eax первый элемент массива целевой функции
		mov ebx, [ebp + 12] ;записал в ebx первый элемент массива вспомогательной функции
		mov ecx, SizeInitialPopulation
		mov edx, D
		
	ObjectiveFunctionCalculationCycle:	
		mov edx, D
		cmp dword ptr [ebx], edx
		jg FXnGreaterD
		jl FXnLessD
		ObjectiveFunctionCalculationProc:	
		add edi, 4
		add ebx, 4
	loop ObjectiveFunctionCalculationCycle
	
	jmp ObjectiveFunctionCalculationProc1
	
	FXnGreaterD:
		mov edx, D
		mov dword ptr[edi], edx
		mov eax, dword ptr[edi]
		mul Limit	
		mov dword ptr[edi], eax
		mov edx, 0
		mov edx, D
		sub dword ptr [ebx],edx
		mov edx, 0
		mov eax, dword ptr[edi]
		div dword ptr [ebx]
		mov dword ptr[edi], eax
		jmp ObjectiveFunctionCalculationProc
	exit
	
	FXnLessD:
		mov edx, D
		mov dword ptr[edi], edx
		mov eax, dword ptr[edi]
		mul Limit		
		mov dword ptr[edi], eax
		mov edx, 0
		mov edx, D
		sub edx, dword ptr [ebx]
		mov dword ptr [ebx], edx ;!!!!!!!!!!!!!!!!ЗДЕСЬ ИДЁТ ПЕРЕЗАПИСЬ F(X1, X2, X3)
		mov edx, 0
		mov eax, dword ptr[edi]
		div dword ptr [ebx]
		mov dword ptr[edi], eax
		jmp ObjectiveFunctionCalculationProc
	exit
	
	ObjectiveFunctionCalculationProc1:
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		
		ret 2*4
	ObjectiveFunctionCalculation1 endp


; Вычисление целевой функции 255/((F(X1, X2, X3)-D), F(X1, X2, X3)- вспомогательная функция
	ObjectiveFunctionCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
	
		mov edi, [ebp + 8] ;записал в eax первый элемент массива целевой функции. В этот момент (F(x1, x2, x3) - D)
		mov ecx, SizeInitialPopulation

	ObjectiveFunctionCalculationCycle:	
		mov ebx, dword ptr [edi]
		mov eax, Limit
		mov edx, 10000
		mul edx
		mov edx, 0
		div ebx
		mov dword ptr [edi], eax
		add edi, 4
	loop ObjectiveFunctionCalculationCycle	

		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp		
		ret 4
	ObjectiveFunctionCalculation endp
		

; Вычисление вспомогательной функции для целевой функции
	LocalObjectiveFunctionCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi

		assume edx: ptr POPULATION		
		
		mov edx, [ebp+8] ; Коэффициенты популяции
		mov ebx, [ebp+12] ; Массив значений вспомогательной функции
		mov ecx, SizeInitialPopulation
		
	LocalObjectiveFunctionCalculationCycle:
		push A1
		push [edx].X1
		call PartLocalObjectiveFunctionCalculation
		mov [ebx], eax
		push A2
		push [edx].X2
		call PartLocalObjectiveFunctionCalculation
		add [ebx], eax
		push A3
		push [edx].X3
		call PartLocalObjectiveFunctionCalculation
		add [ebx], eax
		add ebx, 4
		add edx, sizeof POPULATION
	loop LocalObjectiveFunctionCalculationCycle
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp	
		ret 2*4
	LocalObjectiveFunctionCalculation endp	

	
; Вычисление части вспомогательной функции (произведение An*Xn)
	PartLocalObjectiveFunctionCalculation proc
		push ebp
		mov ebp, esp
;		push eax
		push ebx
		push ecx
		push edx
		
		mov eax, [ebp+8] ; Коэффициент популяции
		mov ebx, [ebp+12] ; Коэффициент популяции
		
		mul ebx		
		
		pop edx
		pop ecx
		pop ebx
	;	pop eax
		mov esp, ebp
		pop ebp		
		ret 2*4
	PartLocalObjectiveFunctionCalculation endp


; Вычисление среднего значения целевой функции
	AverageObjectiveFunctionCalculation proc
		push ebp
		mov ebp, esp
	;	sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov edi, [ebp+8] ; Среднее значение
		mov ebx, [ebp+12] ; Первый элемент массива целевой функции
		mov ecx, SizeInitialPopulation
		
		mov edx, 0
		mov dword ptr [edi], edx
	
	AverageObjectiveFunctionCalculationCycle:
		mov edx, dword ptr[ebx]
		add dword ptr[edi], edx
		add ebx, 4
	loop AverageObjectiveFunctionCalculationCycle
	
		mov eax, dword ptr[edi]
		mov edx, 0
		mov ecx, SizeInitialPopulation
		div ecx
		mov dword ptr [edi], eax
	
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	AverageObjectiveFunctionCalculation endp
	
	
; Обмен между массивами
	ExchangeBetweenArrays proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov eax, [ebp+8] ; Первый элемент массива приемника
		mov ebx, [ebp+12] ; Первый элемент массива источника
		mov ecx, SizeInitialPopulation
			
	ExchangeBetweenArraysCycle:
		mov edx, dword ptr[ebx]
		mov dword ptr [eax], edx
		mov edx, 0
		add eax, 4
		add ebx, 4
	loop ExchangeBetweenArraysCycle	
	
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	ExchangeBetweenArrays endp
	

; Обмен между структурами (популяциями)
	ExchangeBetweenStructures proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov ebx, [ebp+8] ; Первый элемент массива структуры приемника
		mov edx, [ebp+12] ; Первый элемент массива структура источника
		mov ecx, SizeInitialPopulation	
		
	ExchangeBetweenStructuresCycle:
		mov eax, dword ptr [edx].X1
		mov dword ptr [ebx].X1, eax
		mov eax, dword ptr [edx].X2
		mov dword ptr [ebx].X2, eax
		mov eax, dword ptr [edx].X3
		mov dword ptr [ebx].X3, eax
		add ebx, sizeof POPULATION
		add edx, sizeof POPULATION
	loop ExchangeBetweenStructuresCycle	

		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	ExchangeBetweenStructures endp

	
; Обмен между регистрами
	ExchangeBetweenRegisters proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov eax, [ebp+8] ; Регистр приемник
		mov ebx, [ebp+12] ; Регистр источник
		
		mov edx, dword ptr[ebx]
		mov dword ptr [eax], edx

		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	ExchangeBetweenRegisters endp		
	
	
; Вычисление целой части отношения Fi/Fср
	RelationFiAndFaveDivCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov edi, [ebp+8] ; Первый элемент массива целевой функции
		mov ebx, [ebp+12] ; Сумма элементов
		mov ecx, SizeInitialPopulation	
		
	RelationFiAndFaveDivCalculationCycle:
		mov eax, dword ptr[edi]
		push 10000
		push eax
		call MultiplicationTwoNumbersCalculation	
		mov edx, 0
		div ebx
		mov dword ptr [edi], eax
		add edi, 4
	loop RelationFiAndFaveDivCalculationCycle	
	
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	RelationFiAndFaveDivCalculation endp
	
; Произведние двух чисел, вызов из функции 
	MultiplicationTwoNumbersCalculation proc
		push ebp
		mov ebp, esp
	;	push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov eax, [ebp+8] ; Первое число (результат)
		mov edx, [ebp+12] ; Второе число
		
		mul edx
		
		pop edi
		pop edx
		pop ecx
		pop ebx
	;	pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	MultiplicationTwoNumbersCalculation endp	
	

; Произведние двух чисел, вызов из основной программы
	MultiplicationTwoNumbersMainProgramCalculation proc
		push ebp
		mov ebp, esp
	;	sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov ebx, [ebp+8] ;первое число (результат)
		mov edx, [ebp+12] ;второе число
		
		mov eax, dword ptr [ebx]
		mul edx
		mov dword ptr [ebx], eax
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	MultiplicationTwoNumbersMainProgramCalculation endp	
	
	
; Деление двух чисел
	DivisionTwoNumbersCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov edi, [ebp+8] ; Первое число (результат)
		mov ebx, [ebp+12] ; Второе число
		
		mov eax, dword ptr [edi]
		mov edx, 0
			
		div ebx

		mov dword ptr [edi], eax
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	DivisionTwoNumbersCalculation endp	
	

; Деление массива на число	
	DivisionArrayByNumberCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov edi, [ebp+8] ; Массив (результат)
		mov ebx, [ebp+12] ; Делитель
		mov ecx, SizeInitialPopulation
		
	DivisionArrayByNumberCalculationCycle:
		mov eax, dword ptr [edi]
		mov edx, 0
		div ebx
		mov dword ptr [edi], eax
		add edi, 4
	loop DivisionArrayByNumberCalculationCycle
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	DivisionArrayByNumberCalculation endp	

	
; Вычисление разности между массивом и D
	SubtractionArrayAndNumberCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov edi, [ebp+8] ; Массив (результат)
		mov ecx, SizeInitialPopulation
		
	SubtractionArrayAndNumberCalculationCycle:	
		mov eax, dword ptr [edi]
		mov ebx, D
		cmp eax, ebx
		jge FXnGreaterD
		jl FXnLessD
		SubtractionArrayAndNumberCalculationCycleProc:	
		add edi, 4
	loop SubtractionArrayAndNumberCalculationCycle	
	
	jmp SubtractionArrayAndNumberCalculationCycleProc1
		
	FXnGreaterD:
		sub eax, ebx
		mov dword ptr[edi], eax
		jmp SubtractionArrayAndNumberCalculationCycleProc
	exit
	
	FXnLessD:
		sub ebx, eax
		mov dword ptr[edi], ebx
		jmp SubtractionArrayAndNumberCalculationCycleProc
	exit
	
	SubtractionArrayAndNumberCalculationCycleProc1:
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 4
	SubtractionArrayAndNumberCalculation endp	


; Вычисление остатка отношения Fi/Fср
	RelationFiAndFaveModCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		mov edi, [ebp+8] ; Cреднее значение Fср
		mov ebx, [ebp+12] ; Первый элемент массива целевой функции
		mov ecx, SizeInitialPopulation	
		
	RelationFiAndFaveModCalculationCycle:
		mov eax, dword ptr[ebx]
		mov edx, 0
		div edi
		mov dword ptr [ebx], edx
		add ebx, 4
	loop RelationFiAndFaveModCalculationCycle	
	
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	RelationFiAndFaveModCalculation endp


; Вычисление суммы элементов массива
	ArrayElementsSumCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		
		mov edi, [ebp+8] ; Переменная для записи
		mov ebx, [ebp+12] ; Первый элемент массива
		mov ecx, SizeInitialPopulation

		mov eax, 0
		mov dword ptr [edi], eax

	ArrayElementsSumCalculationCycle:
		add eax, dword ptr [ebx]
		add ebx, 4
	loop ArrayElementsSumCalculationCycle
		
		mov dword ptr [edi], eax
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	ArrayElementsSumCalculation endp	

	
; Вычисление отношения суммы элементов от остатка отношения	Fi/Fср и Fср	
	RelationFiAndFaveDivSumCalculation proc	
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi
		
		
		mov edi, [ebp+8] ; Целая часть
		mov ebx, [ebp+12] ; Остаток
		mov ecx, [ebp+16] ;Fср
		
		mov eax, dword ptr [ebx]
		mov edx, 0
		div ecx
		
		add eax, dword ptr [edi]
		mov dword ptr [edi], eax
		mov dword ptr [ebx], edx
			
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 3*4
	RelationFiAndFaveDivSumCalculation endp


; Вычисление вероятности от доли процента каждого родителя по целой части
	RelationFiAndFaveArrDivPercentCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi		
		
		mov edi, [ebp+8] ; Массив вероятностей целой части отношения Fi/Fср
		mov ebx, [ebp+12] ; Сумма целых частей Fср
		mov ecx, SizeInitialPopulation
		
		mov eax, 0
		cmp ebx, eax
		je zero
		
	RelationFiAndFaveArrDivPercentCalculationCycle:
		mov eax, dword ptr [edi]
		mov edx, 100
		mul edx
		mov edx, 0
		div ebx
		mov dword ptr [edi], eax
		add edi, 4
	loop RelationFiAndFaveArrDivPercentCalculationCycle

	zero:	
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	RelationFiAndFaveArrDivPercentCalculation endp
	
	
; Вычисление вероятности от доли процента каждого родителя по остатку
	RelationFiAndFaveArrModPercentCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi		
		
		mov edi, [ebp+8] ; Массив вероятностей остатка отношения Fi/Fср
		mov ebx, [ebp+12] ; Сумма остатков отношения Fi/Fср
		mov ecx, SizeInitialPopulation; 
		
		mov eax, 0
		cmp ebx, eax
		je zero
		
	RelationFiAndFaveArrModPercentCalculationCycle:
		mov eax, dword ptr [edi]
		mov edx, 100
		mul edx
		mov edx, 0
		div ebx
		mov dword ptr [edi], eax
		add edi, 4
	loop RelationFiAndFaveArrModPercentCalculationCycle
		
	zero:
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	RelationFiAndFaveArrModPercentCalculation endp	

	
; Заполнение линейки с диапазонами - СТАРЫЙ ВАРИАНТ
	ArrangeRulerCalculationOLD proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi		
		
		mov edi, [ebp+8] ; Массив диапазонов
		mov ebx, [ebp+12] ; Массив вероятностей для добавления в линейку
		mov ecx, SizeInitialPopulation;
		
		mov edx, 1
		mov eax, 0
		mov dword ptr [edi], eax

	ArrangeRulerCalculationOLDCycle:
		add edi, 4
		add eax, dword ptr [ebx]
		sub eax, 1
		mov dword ptr [edi], eax
		add ebx, 4
		add edi, 4
		add eax, edx
		mov dword ptr [edi], eax
	loop ArrangeRulerCalculationOLDCycle
		
	
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	ArrangeRulerCalculationOLD endp	


; Заполнение линейки с диапазонами
	ArrangeRulerCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi		
		
		mov edi, [ebp+8] ;массив диапазонов
		mov ebx, [ebp+12] ;массив вероятностей для добавления в линейку
		mov ecx, SizeInitialPopulation;
		
		mov eax, 0
		mov dword ptr [edi], eax

	ArrangeRulerCalculationCycle:
		add eax, dword ptr [ebx]
		mov dword ptr [edi], eax
		add ebx, 4
		add edi, 4
	loop ArrangeRulerCalculationCycle	
	
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	ArrangeRulerCalculation endp	


; Запись последнего элемента массива в переменную - СТАРЫЙ ВАРИАНТ
	LastElementCalculationOLD proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi		
		
		mov eax, [ebp+8] ; Значение последнего элемента
		mov ebx, [ebp+12] ; Массив диапазонов линейки
		mov ecx, SizeArrangeRuler ; Размер массива диапазонов линейки
		mov edx, 0
		
	LastElementCalculationOLDCycle:
		mov dword ptr [eax], edx
		add ebx, 4
		mov edx, dword ptr [ebx]
	loop LastElementCalculationOLDCycle
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	LastElementCalculationOLD endp


; Запись последнего элемента массива в переменную
	LastElementCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi		
		
		mov eax, [ebp+8] ; Значение последнего элемента
		mov ebx, [ebp+12] ; Массив диапазонов линейки
		mov ecx, SizeInitialPopulation ; Размер массива диапазонов линейки
		mov edx, 0
		
	LastElementCalculationCycle:
		mov dword ptr [eax], edx
		add ebx, 4
		mov edx, dword ptr [ebx]
	loop LastElementCalculationCycle
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	LastElementCalculation endp


; Заполнение случайными числами массива первого родителя
	RandomParentCalculation proc
		push ebp
		mov ebp, esp
		push eax
		push ebx
		push ecx
		push edx
		push edi		
		
		mov edi, [ebp+8] ; массив чисел (результат)
		mov ebx, [ebp+12] ; верхний диапазон
		mov ecx, SizeInitialPopulation ; размер массива диапазонов линейки
		
	RandomParentCalculationCycle:
		mov eax, dword ptr [edi]
		push ebx
		push eax
		call RandomGenerator 
		mov dword ptr [edi], eax
		add edi, 4
	loop RandomParentCalculationCycle
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	RandomParentCalculation endp


; Селекция
	SelectionFormation proc
		push ebp
		mov ebp, esp
		sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi	
		
		Loc1 equ dword ptr [ebp-4] ; Хранение счетчика

		mov Loc1, SizeInitialPopulation
		
		assume edi: ptr POPULATION
		assume ebx: ptr POPULATION
		
		mov edi, [ebp+8] ; Массив новой особи
		mov ebx, [ebp+12] ; Массив текущей популяции
		mov edx, [ebp+16] ; Массив диапазонов
		mov ecx, SizeInitialPopulation ; размер массива диапазонов линейки Счётчик внешнего цикла
		
		
		label_1:								; команда внешнего цикла
			push MaxValueRangeRuler
			push offset temp
			call RandomGeneratorMainProgram

			mov eax, temp
			mov Loc1, ecx ; сохраняем счетчик в Loc1
			mov ecx, SizeInitialPopulation		; счетчик внутреннего цикла
		label_2:
			cmp eax, dword ptr [edx]
			jle RandomLessArrange
			add edx, 4
			add ebx, sizeof POPULATION
		loop label_2
		
		RandomLessArrange:
			mov eax, dword ptr [ebx].X1
			mov dword ptr [edi].X1, eax
			mov eax, dword ptr [ebx].X2
			mov dword ptr [edi].X2, eax
			mov eax, dword ptr [ebx].X3
			mov dword ptr [edi].X3, eax
			
			add edi, sizeof POPULATION
			mov ebx, [ebp+12]
			mov edx, [ebp+16]
			mov ecx, Loc1			
		loop label_1	
		
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 3*4
	SelectionFormation endp


; Скрещивание
	Crossing proc
		push ebp
		mov ebp, esp
		sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi
		push esi
		
		Loc1 equ dword ptr [ebp-4] ; хранение счетчика
		
		mov Loc1, 1	
		
		assume ebx: ptr POPULATION
		assume edx: ptr POPULATION
		assume edi: ptr POPULATION
		
		mov ebx, [ebp+8] ; Массив новой популяции
		mov edx, [ebp+12] ; Массив первого родителя
		mov edi, [ebp+16] ; Массив второго родителя
		mov ecx, SizeInitialPopulation ; Размер массива диапазонов линейки Счётчик внешнего цикла		
		
		CrossingLabel:							; команда внешнего цикла
			push ZeroOneRange
			push offset temp
			call RandomGeneratorMainProgram
			mov eax, temp
			mov esi, 0
			cmp eax, esi
			je CrossingLabel1
			jne CrossingLabel2
			CrossingLabelSource:
			add ebx, sizeof POPULATION
			add edx, sizeof POPULATION
			add edi, sizeof POPULATION
		loop CrossingLabel
		
		jmp CrossingProcExit
		
		CrossingLabel1:
			push ZeroOneRange
			push offset temp
			call RandomGeneratorMainProgram
			mov eax, temp
			mov esi, 0
			je CrossingLabel_1_1
			jne CrossingLabel_1_2
		
		CrossingLabel_1_1:						; 00
			mov eax, dword ptr [edx].X1
			mov dword ptr [ebx].X1, eax
			mov eax, dword ptr [edi].X2
			mov dword ptr [ebx].X2, eax
			mov eax, dword ptr [edi].X3
			mov dword ptr [ebx].X3, eax
		jmp CrossingLabelSource	
		
		CrossingLabel_1_2:						; 01
			mov eax, dword ptr [edx].X1
			mov dword ptr [ebx].X1, eax
			mov eax, dword ptr [edx].X2
			mov dword ptr [ebx].X2, eax
			mov eax, dword ptr [edi].X3
			mov dword ptr [ebx].X3, eax
		jmp CrossingLabelSource	
			
		CrossingLabel2:
			push ZeroOneRange
			push offset temp
			call RandomGeneratorMainProgram
			mov eax, temp
			mov esi, 0
			je CrossingLabel_2_1
			jne CrossingLabel_2_2
		
		CrossingLabel_2_1:						; 10
			mov eax, dword ptr [edi].X1
			mov dword ptr [ebx].X1, eax
			mov eax, dword ptr [edx].X2
			mov dword ptr [ebx].X2, eax
			mov eax, dword ptr [edx].X3
			mov dword ptr [ebx].X3, eax
		jmp CrossingLabelSource
		
		CrossingLabel_2_2:						; 11
			mov eax, dword ptr [edi].X1
			mov dword ptr [ebx].X1, eax
			mov eax, dword ptr [edi].X2
			mov dword ptr [ebx].X2, eax
			mov eax, dword ptr [edx].X3
			mov dword ptr [ebx].X3, eax
		jmp CrossingLabelSource
		
	CrossingProcExit:
		
		pop esi
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 3*4
	Crossing endp
	

; Скрещивание - обмен битами
	CrossingBites proc
		push ebp
		mov ebp, esp
		sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi
		push esi
		
		Loc1 equ dword ptr [ebp-4] ; Хранение счетчика
		
		mov Loc1, 1
			
		assume edi: ptr POPULATION
		assume esi: ptr POPULATION
		
		mov edi, [ebp+8] ; Массив новой популяции
		mov esi, [ebp+12] ; Массив второго родителя
		mov ecx, SizeInitialPopulation ; Размер массива диапазонов линейки Счётчик внешнего цикла
		
		CrossingBitesX1Cycle:
			mov Loc1, ecx
			push BitNumberRange
			push offset BitNumber
			call RandomGeneratorMainProgram
			jmp CrossingBitesLabelX1
			CrossingBitesX1LoopBody:
			add edi, sizeof POPULATION
			add esi, sizeof POPULATION
			mov ecx, Loc1
		loop CrossingBitesX1Cycle
			
		jmp CrossingBitesX2
			
			CrossingBitesLabelX1:
			mov cl, BitNumber
;			outintln cl,, "BitNumber Crossing X1 = " 
			mov eax, dword ptr [edi]. X1
			mov ebx, dword ptr [esi]. X1
			mov edx, 1
			shl edx, cl
			xor eax, ebx 
			and edx, eax 
			cmp edx, 0
			je CrossingBitesLabel1
			CrossingBitesLabel1_1:
				xor eax, ebx
				mov edx, 1
				shl edx, cl
				xor eax, edx
				xor ebx, edx
				mov dword ptr [edi]. X1, eax
				mov dword ptr [esi]. X1, ebx 
			jmp CrossingBitesX1LoopBody
			CrossingBitesLabel1:
				xor eax, ebx
				jmp CrossingBitesLabel1_1
			
		CrossingBitesX2:
		mov edi, [ebp+8] ; Массив новой популяции
		mov esi, [ebp+12] ; Массив второго родителя
		mov ecx, SizeInitialPopulation

		CrossingBitesX2Cycle:
			mov Loc1, ecx
			push BitNumberRange
			push offset BitNumber
			call RandomGeneratorMainProgram
			jmp CrossingBitesLabelX2
			CrossingBitesX2LoopBody:
			add edi, sizeof POPULATION
			add esi, sizeof POPULATION
			mov ecx, Loc1
		loop CrossingBitesX2Cycle
			
		jmp CrossingBitesX3
			
			CrossingBitesLabelX2:
			mov cl, BitNumber
;			outintln cl,, "BitNumber Crossing X2 = " 
			mov eax, dword ptr [edi]. X2
			mov ebx, dword ptr [esi]. X2
			mov edx, 1
			shl edx, cl
			xor eax, ebx 
			and edx, eax 
			cmp edx, 0
			je CrossingBitesLabel2
			CrossingBitesLabel2_2:
				xor eax, ebx
				mov edx, 1
				shl edx, cl
				xor eax, edx
				xor ebx, edx
				mov dword ptr [edi]. X2, eax
				mov dword ptr [esi]. X2, ebx 
			jmp CrossingBitesX2LoopBody
			CrossingBitesLabel2:
				xor eax, ebx
				jmp CrossingBitesLabel2_2
		
		CrossingBitesX3:
		mov edi, [ebp+8] ; Массив новой популяции
		mov esi, [ebp+12] ; Массив второго родителя
		mov ecx, SizeInitialPopulation

		CrossingBitesX3Cycle:
			mov Loc1, ecx
			push BitNumberRange
			push offset BitNumber
			call RandomGeneratorMainProgram
			jmp CrossingBitesLabelX3
			CrossingBitesX3LoopBody:
			add edi, sizeof POPULATION
			add esi, sizeof POPULATION
			mov ecx, Loc1
		loop CrossingBitesX3Cycle
			
		jmp CrossingBitesExit
			
			CrossingBitesLabelX3:
			mov cl, BitNumber
;			outintln cl,, "BitNumber Crossing X3 = " 
			mov eax, dword ptr [edi]. X3
			mov ebx, dword ptr [esi]. X3
			mov edx, 1
			shl edx, cl
			xor eax, ebx 
			and edx, eax 
			cmp edx, 0
			je CrossingBitesLabel3
			CrossingBitesLabel3_3:
				xor eax, ebx
				mov edx, 1
				shl edx, cl
				xor eax, edx
				xor ebx, edx
				mov dword ptr [edi]. X3, eax
				mov dword ptr [esi]. X3, ebx 
			jmp CrossingBitesX3LoopBody
			CrossingBitesLabel3:
				xor eax, ebx
				jmp CrossingBitesLabel3_3

	CrossingBitesExit:
		
		pop esi
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	CrossingBites endp

   
; Мутация
	Mutation Proc
		push ebp
		mov ebp, esp
		sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi
		push esi
		
		Loc1 equ dword ptr [ebp-4] ; Хранение счетчика
		Loc2 equ dword ptr [ebp-8] ; Хранение счетчика
		
		mov Loc1, 1
		
		assume ebx: ptr POPULATION	
		
		mov ebx, [ebp+8] ; массив популяции
		mov esi, [ebp+12] ; массив вероятностей
		mov edi, [ebp+16] ; вероятность мутации
		mov ecx, SizeInitialPopulation ; размер популяции - счетчик		
		
		mov edx, 100
		mov eax, edi
		mul edx
		mov edi, eax
		
		mov eax, 0
		mov dl, BitNumber

		MutationLabel:
			mov Loc1, ecx
			cmp dword ptr [esi], edi
			jle MutationProc
			MutationLabelProc:
			add ebx, sizeof POPULATION
			add esi, 4
		loop MutationLabel
		
		jmp MutationExit
		
		MutationProc:
			push ZeroOneRange
			push offset temp
			call RandomGeneratorMainProgram
			mov eax, temp
			mov edx, 1
			cmp eax, edx ; 0 - ген не мутирует, 1 - ген мутирует
			je MutationX1Proc
			MutationProcLabel_1:
			push ZeroOneRange
			push offset temp
			call RandomGeneratorMainProgram
			mov eax, temp
			mov edx, 1
			cmp eax, edx ; 0 - ген не мутирует, 1 - ген мутирует
			je MutationX2Proc
			MutationProcLabel_2:
			push ZeroOneRange
			push offset temp
			call RandomGeneratorMainProgram
			mov eax, temp
			mov edx, 1
			cmp eax, edx ; 0 - ген не мутирует, 1 - ген мутирует
			je MutationX3Proc
			MutationProcLabel_3:
		jmp MutationLabelProc	
		
				MutationX1Proc:
					push BitNumberRange
					push offset BitNumber
					call RandomGeneratorMainProgram
					mov cl, BitNumber
					mov edx, 1
					shl edx, cl
					mov eax, dword ptr [ebx].X1
					xor eax, edx
					mov dword ptr [ebx].X1, eax
					mov ecx, Loc1
					jmp MutationProcLabel_1
				
				MutationX2Proc:
					push BitNumberRange
					push offset BitNumber
					call RandomGeneratorMainProgram
					mov cl, BitNumber
					mov edx, 1
					shl edx, cl
					mov eax, dword ptr [ebx].X2
					xor eax, edx
					mov dword ptr [ebx].X2, eax
					mov ecx, Loc1
					jmp MutationProcLabel_2
				
				MutationX3Proc:
					push BitNumberRange
					push offset BitNumber
					call RandomGeneratorMainProgram
					mov cl, BitNumber
					mov edx, 1
					shl edx, cl
					mov eax, dword ptr [ebx].X3
					xor eax, edx
					mov dword ptr [ebx].X3, eax
					mov ecx, Loc1
					jmp MutationProcLabel_3
		exit

	MutationExit:
		
		pop esi
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 3*4
	Mutation endp

	
; Проверка решения в тестовом режиме на невязки
	CheckSolutionTestingMode Proc
		push ebp
		mov ebp, esp
		sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi
		push esi
		
		Loc1 equ dword ptr [ebp-4] ; Хранение счетчика
		
		mov Loc1, 0
		mov esi, 1
		
		assume ebx: ptr POPULATION
		
		mov ebx, [ebp+8] ; Массив популяции
		mov edi, [ebp+12] ; Массив разности F(X1, X2, X3) - D
		mov ecx, SizeInitialPopulation ; Размер популяции - счетчик	
		
		CheckSolutionTestingModeCycle:
			mov eax, Residual
			cmp dword ptr [edi], eax
			je SolutionTestingModeYes
			CheckSolutionTestingModeCycleProc:
			add ebx, sizeof POPULATION
			add edi, 4			
		loop CheckSolutionTestingModeCycle
		
		jmp CheckSolutionTestingModeCycleExit
		
		SolutionTestingModeYes:
			mov eax, Loc1
			add eax, esi
			mov Loc1, eax
			outintln CurrentIteration,, "CurrentIteration =  "
			outstrln
			outstrln "Solution = "
			push ebx
			call printStruc
			jmp CheckSolutionTestingModeCycleProc
		
		ProgramTestingModeExit1:
		
			exit
		
		CheckSolutionTestingModeCycleExit:
			mov eax, Loc1
			mov esi, 0
			cmp eax, esi
			jg ProgramTestingModeExit1	
		
		pop esi
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	CheckSolutionTestingMode endp	


; Проверка решения в основном режиме на невязки
	CheckSolutionBasicMode Proc
		push ebp
		mov ebp, esp
		sub esp, 4
		push eax
		push ebx
		push ecx
		push edx
		push edi
		push esi
		
		Loc4 equ dword ptr [ebp-4] ; Хранение счетчика
		
		mov Loc4, 0
		mov esi, 1
		
		assume ebx: ptr POPULATION
		
		mov ebx, [ebp+8] ; Массив популяции
		mov edi, [ebp+12] ; Массив разности F(X1, X2, X3) - D
		mov ecx, SizeInitialPopulation ; Размер популяции - счетчик		
		
		CheckSolutionBasicModeCycle:
			mov eax, Residual
			cmp dword ptr [edi], eax
			je SolutionBasicModeYes
			CheckSolutionBasicModeCycleProc:
			add ebx, sizeof POPULATION
			add edi, 4			
		loop CheckSolutionBasicModeCycle
		
		jmp CheckSolutionBasicModeCycleExit
		
		SolutionBasicModeYes:
			mov eax, Loc4
			add eax, esi
			mov Loc4, eax
			outintln CurrentIteration,, "Number of Iterations =  "
			outstrln
			outintln Residual,, "Residual (F(x1,x2,x3) - D) = "
			outstrln "Solution = "
			push ebx
			call printStruc
			jmp CheckSolutionBasicModeCycleProc
		
		ProgramBasicModeExit1:
		
			exit
		
		CheckSolutionBasicModeCycleExit:
			mov eax, Loc4
			mov esi, 0
			cmp eax, esi
			jg ProgramBasicModeExit1
		
		pop esi
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		mov esp, ebp
		pop ebp
		ret 2*4
	CheckSolutionBasicMode endp	
	
	
 start:
	
	; Инициализация системной функции генерации случайного числа
	; GetTickCount возвращаеn количество миллисекунд, прошедших с момента запуска системы, а затем инициализируем переменную seed полученным значением
	invoke GetTickCount
	invoke nseed, eax

; Генерация начальной популяции
	call GeneratorInitialAllPopulation

; Генерация начальной популяции по заданным значениям	
;	push offset P
;	call GivenInitialAllPopulation

	outstrln "---------------------------------------------------"
	outintln ProgramMode,, "Program Operation Mode (0 - Testing, 1- Basic) = "
	outstrln "---------------------------------------------------"
	outstrln
	mov ebx, ProgramMode
	mov ecx, 0
	cmp ebx, ecx
	je TestingMode
	jne BasicMode

; Работа программы в тестовом режиме	
TestingMode:
; генерация начальной популяции
;	call GeneratorInitialAllPopulation
	
	outintln CurrentIteration,, "Current Iteration =  "
	outstrln
	outstrln "Population =  "
; вывод популяции
	push offset P
	call OutputPopulationMainProgram

	
; вычисление массива вспомогательной функции
	push offset ObjectiveFunction ;второй фактический параметр
	push offset P ;первый фактический параметр
	call LocalObjectiveFunctionCalculation
	
	
; вычисление разности между массивом F(x1,x2,x3) и D
	push offset ObjectiveFunction
	call SubtractionArrayAndNumberCalculation
	
	outstrln "Residual before Mutation (F(x1,x2,x3) - D) = "
	push SizeInitialPopulation
	push offset ObjectiveFunction
	call printArray	
	outstrln
	
	
; проверка решения на невязки
	push offset ObjectiveFunction
	push offset P
	call CheckSolutionTestingMode

; вычисление целевой функции
	push offset ObjectiveFunction ;первый фактический параметр
	call ObjectiveFunctionCalculation

;	outstrln "ObjectiveFunction"

;	push SizeInitialPopulation
;	push offset ObjectiveFunction
;	call printArray

; Сумма элементов массива целевой функции
	push offset ObjectiveFunction
	push offset ObjectiveFunctionSum
	call ArrayElementsSumCalculation

; вычисление вероятностей от отношения Fi/Fср
	push ObjectiveFunctionSum
	push offset ObjectiveFunction
	call RelationFiAndFaveDivCalculation
	
;	outstrln "RelationFiAndFaveArrDiv"
;	push SizeInitialPopulation
;	push offset ObjectiveFunction
;	call printArray
	
	
; Мутация
	push MutationProbability
	push offset ObjectiveFunction
	push offset P
	call Mutation

; Вывод новой популяции после мутации
	outstrln "New Population after mutation="
	push offset P
	call OutputPopulationMainProgram


; вычисление массива вспомогательной функции
	push offset ObjectiveFunction ;второй фактический параметр
	push offset P ;первый фактический параметр
	call LocalObjectiveFunctionCalculation

; вычисление разности между массивом F(x1,x2,x3) и D
	push offset ObjectiveFunction
	call SubtractionArrayAndNumberCalculation
	
	outstrln "Residual after Mutation (F(x1,x2,x3) - D) = "
	push SizeInitialPopulation
	push offset ObjectiveFunction
	call printArray
	outstrln
	
; проверка решения на невязки
	push offset ObjectiveFunction
	push offset P
	call CheckSolutionTestingMode

; вычисление целевой функции
	push offset ObjectiveFunction ;первый фактический параметр
	call ObjectiveFunctionCalculation
	
; Сумма элементов массива целевой функции
	push offset ObjectiveFunction
	push offset ObjectiveFunctionSum
	call ArrayElementsSumCalculation
	
; вычисление вероятностей от отношения Fi/Fср
	push ObjectiveFunctionSum
	push offset ObjectiveFunction
	call RelationFiAndFaveDivCalculation

; Заполнение линейки с диапазонами
	push offset ObjectiveFunction
	push offset ArrangeRulerArr
	call ArrangeRulerCalculation

;	outstrln "Lineika = "
;	push SizeInitialPopulation
;	push offset ArrangeRulerArr
;	call printArray
;	outstrln


; Запись последнего элемента массива линейки с диапазонами в переменную для дальнейшей генерации;
	push offset ArrangeRulerArr
	push offset MaxValueRangeRuler
	call LastElementCalculation

; Селекция - выбор первого родителя		
	push offset ArrangeRulerArr
	push offset P
	push offset P1
	call SelectionFormation

;	outstrln "First parent = "
;	push offset P1
;	call OutputPopulationMainProgram
	
; Селекция - выбор второго родителя	
	push offset ArrangeRulerArr
	push offset P
	push offset P2
	call SelectionFormation
	
;	outstrln "Second parent = "
;	push offset P2
;	call OutputPopulationMainProgram
	
; Обмен популяциями
	push offset P1
	push offset P
	call ExchangeBetweenStructures

;	outstrln "ExchangeBetweenStructures = "
;	push offset P
;	call OutputPopulationMainProgram
; Скрещивание
	push offset P2
	push offset P
	call CrossingBites

;	outstrln "First Parent after crossing = "
;	push offset P
;	call OutputPopulationMainProgram
	
;	outstrln "Second Parent after crossing = "
;	push offset P2
;	call OutputPopulationMainProgram


; Переход к следующей итерации
	mov eax, CurrentIteration
	mov ebx, 1
	add eax, ebx
	mov CurrentIteration, eax
	mov eax, CurrentIteration
	mov ebx, IterationLimit
	cmp eax, ebx
	jg ProgramExit2
	
	
	
	outstrln "----------------------------------------------"
	
	jmp TestingMode


; Работа программы в основном режиме
BasicMode:

; вычисление массива вспомогательной функции
	push offset ObjectiveFunction ;второй фактический параметр
	push offset P ;первый фактический параметр
	call LocalObjectiveFunctionCalculation
	
;	outintln CurrentIteration,, "Current Iteration =  "
; вычисление разности между массивом F(x1,x2,x3) и D
	push offset ObjectiveFunction
	call SubtractionArrayAndNumberCalculation
	
;	outstrln "Residual before Mutation (F(x1,x2,x3) - D) = "
;	push SizeInitialPopulation
;	push offset ObjectiveFunction
;	call printArray	
;	outstrln
	
;	outintln CurrentIteration,, "Current Iteration =  "
; проверка решения на невязки
	push offset ObjectiveFunction
	push offset P
	call CheckSolutionBasicMode
;	outintln CurrentIteration,, "Current Iteration =  "
; вычисление целевой функции
	push offset ObjectiveFunction ;первый фактический параметр
	call ObjectiveFunctionCalculation
;	outintln CurrentIteration,, "Current Iteration =  "
;	outstrln "ObjectiveFunction"
;	outintln CurrentIteration,, "Current Iteration =  "
;	push SizeInitialPopulation
;	push offset ObjectiveFunction
;	call printArray

; Сумма элементов массива целевой функции
	push offset ObjectiveFunction
	push offset ObjectiveFunctionSum
	call ArrayElementsSumCalculation

; вычисление вероятностей от отношения Fi/Fср
	push ObjectiveFunctionSum
	push offset ObjectiveFunction
	call RelationFiAndFaveDivCalculation
	
;	outstrln "RelationFiAndFaveArrDiv"
;	push SizeInitialPopulation
;	push offset ObjectiveFunction
;	call printArray
	
	
; Мутация
	push MutationProbability
	push offset ObjectiveFunction
	push offset P
	call Mutation

; Вывод новой популяции после мутации
;	outstrln "New Population after mutation="
;	push offset P
;	call OutputPopulationMainProgram


; вычисление массива вспомогательной функции
	push offset ObjectiveFunction ;второй фактический параметр
	push offset P ;первый фактический параметр
	call LocalObjectiveFunctionCalculation

; вычисление разности между массивом F(x1,x2,x3) и D
	push offset ObjectiveFunction
	call SubtractionArrayAndNumberCalculation
	
;	outstrln "Residual after Mutation (F(x1,x2,x3) - D) = "
;	push SizeInitialPopulation
;	push offset ObjectiveFunction
;	call printArray
;	outstrln
	
; проверка решения на невязки
	push offset ObjectiveFunction
	push offset P
	call CheckSolutionBasicMode

; вычисление целевой функции
	push offset ObjectiveFunction ;первый фактический параметр
	call ObjectiveFunctionCalculation
	
; Сумма элементов массива целевой функции
	push offset ObjectiveFunction
	push offset ObjectiveFunctionSum
	call ArrayElementsSumCalculation
	
; вычисление вероятностей от отношения Fi/Fср
	push ObjectiveFunctionSum
	push offset ObjectiveFunction
	call RelationFiAndFaveDivCalculation

; Заполнение линейки с диапазонами
	push offset ObjectiveFunction
	push offset ArrangeRulerArr
	call ArrangeRulerCalculation

;	outstrln "Lineika = "
;	push SizeInitialPopulation
;	push offset ArrangeRulerArr
;	call printArray
;	outstrln


; Запись последнего элемента массива линейки с диапазонами в переменную для дальнейшей генерации;
	push offset ArrangeRulerArr
	push offset MaxValueRangeRuler
	call LastElementCalculation

; Селекция - выбор первого родителя		
	push offset ArrangeRulerArr
	push offset P
	push offset P1
	call SelectionFormation

;	outstrln "First parent = "
;	push offset P1
;	call OutputPopulationMainProgram
	
; Селекция - выбор второго родителя	
	push offset ArrangeRulerArr
	push offset P
	push offset P2
	call SelectionFormation
	
;	outstrln "Second parent = "
;	push offset P2
;	call OutputPopulationMainProgram
	
; Обмен популяциями
	push offset P1
	push offset P
	call ExchangeBetweenStructures

;	outstrln "ExchangeBetweenStructures = "
;	push offset P
;	call OutputPopulationMainProgram
; Скрещивание
	push offset P2
	push offset P
	call CrossingBites

;	outstrln "First Parent after crossing = "
;	push offset P
;	call OutputPopulationMainProgram
	
;	outstrln "Second Parent after crossing = "
;	push offset P2
;	call OutputPopulationMainProgram

; Переход к следующей итерации
	mov eax, CurrentIteration
	mov ebx, 1
	add eax, ebx
	mov CurrentIteration, eax
	mov eax, CurrentIteration
	mov ebx, IterationLimit
	cmp eax, ebx
	jg ProgramExit2
	
	
	
;	outstrln "----------------------------------------------"
	
	jmp BasicMode





	

ProgramExit2:
	outstrln "Iteration limit"
	outstrln
exit

end start	