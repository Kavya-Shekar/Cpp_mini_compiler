D=dict()
f = open("final_symbol.txt", "a")
f.write('-----------------------------SymbolTable--------------------------------')
f.write('\n')
f.write('SNo.	Token	LineNo.  Category   DataType	Value	Scope')
f.write('\n')	
with open('value.txt', 'r') as file_out:
    for line in file_out:
        line=line.split()
        if(len(line)==2):
        	D[line[0]]=line[1]
        	
with open('symbol.txt', 'r+') as file_out:
    for line in file_out:
        line=line.split()
        if(len(line)==7):
        	if line[1] in D.keys():
        		f.write(line[0])
        		f.write('\t\t')
        		f.write(line[1])
        		f.write('\t\t')
        		f.write(line[2])
        		f.write('\t\t')
        		f.write(line[3])
        		f.write('\t\t')
        		f.write(line[4])
        		f.write('\t\t')
        		f.write(D[line[1]])
        		f.write('\t\t')
        		f.write(line[6])
        		f.write('\n')
f.close()
