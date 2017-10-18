
spam = ['apples', 'bananas', 'tofu', 'cats']
eggs = [1, 2, 3, 4, 5, 6, 7, 8]

def andand(test):
	for i in range(len(test) - 1):
		print(str(test[i]) + ', ', end='')
	print('and ' + str(test[-1]))

andand(spam)
andand(eggs)
