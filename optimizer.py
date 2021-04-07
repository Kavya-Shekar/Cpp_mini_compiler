import re
import time

isid = lambda s : bool(re.match(r"^[A-Za-z][A-Za-z0-9_]*$", s)) 


def printicg(list_of_lines, message = "") :
	print(message.upper())
	for line in list_of_lines :
		print(line.strip())
def LiveVariableAnalysis(lines):
    k = 1
    Live_Variables = []
    Var_D = dict()
    for i in lines:
        i = i.strip("\n")
        if(len(i.split()) == 5 or len(i.split()) == 3):
            lhs = i.split()[0]
            out = exists_rhs(lines, lhs, k-1)
            if(out != -1):
                if(lhs not in Live_Variables):
                    Live_Variables.append(lhs)
                    Var_D[out] = lhs
            if((k-1) in Var_D.keys()):
                Live_Variables.remove(Var_D[k-1])
           
        print("Live Variables at Line {0} are : {1}" .format(k,Live_Variables))
        time.sleep(0.02)
        k = k + 1
    time.sleep(0.05)
    print('\n')
  
def exists_rhs(lines, lhs, start):
    for i in range(len(lines)-1, start-1, -1):
        if(len(lines[i].split()) == 5):
            rhs1 = lines[i].split()[2]
            rhs2 = lines[i].split()[4]
            if(rhs1 == lhs or rhs2 == lhs):              
                return i
        elif(len(lines[i].split()) == 3):
            rhs = lines[i].split()[2]
            if(rhs == lhs):
                return i
        elif(len(lines[i].split()) == 4):
            rhs = lines[i].split()[1]
            l1 = ""
            l2 = ""
            fl = 0
            for x in rhs:
                if x in [">", "<", "=", "!"]:
                    fl = 1
                    continue
                if (x == "="):
                    continue
                if(fl == 0):
                    l1 = l1 + x
                if(fl == 1):
                    l2 = l2 + x
            if(l1 == lhs or l2 == lhs):
                return i
    return -1   
    
def Label_exists(lines, i):
    if(i == 0):
        return 0
    while(i>=0):
        if(len(lines[i].split()) == 2):
            return 1
        i=i-1
    return 0
        
    
def DeadCodeElimination(lines):
    new_lines = []
    for i in range(len(lines)):
        lines[i] = lines[i].strip("\n")
        outflag = 0
        if(Label_exists(lines, i) == 1):
            new_lines.append(lines[i])
            continue
        if(len(lines[i].split()) == 5 or len(lines[i].split()) == 3):
            lhs = lines[i].split()[0]
            out = exists_rhs(lines,lhs,i+1)
            if(out!=-1):
              outflag=1
            else:
	      continue
            if(outflag == 1):
               new_lines.append(lines[i])
        else:
           new_lines.append(lines[i])
           continue
          
    
    return new_lines
    
def printc(list1):
    for i in list1:
        print(i)
        

def printl(list1,filepointer):
    for i in list1:
        filepointer.write("%s\n"%(i))

def make_subexpression_dict(lines) :
	expressions = {}
	variables = {}
	for line in lines :
		tokens = line.split()
		if len(tokens) == 5 :
			if tokens[0] in variables and variables[tokens[0]] in expressions :
				del expressions[variables[tokens[0]]]
			rhs = tokens[2] + " " + tokens[3] + " " + tokens[4]
			if rhs not in expressions :
				expressions[rhs] = tokens[0]
				if isid(tokens[2]) :
					variables[tokens[2]] = rhs
				if isid(tokens[4]) :
					variables[tokens[4]] = rhs
	return expressions

def eliminate_common_subexpressions(lines) :
	expressions = make_subexpression_dict(lines)
	llines = len(lines)
	new_list_of_lines = lines[:]
	for i in range(llines) :
		tokens = lines[i].split()
		if len(tokens) == 5 :
			rhs = tokens[2] + " " + tokens[3] + " " + tokens[4]
			if rhs in expressions and expressions[rhs] != tokens[0]:
				new_list_of_lines[i] = tokens[0] + " " + tokens[1] + " " + expressions[rhs]
	return new_list_of_lines
				          

fin = open("icg.txt", "r")
lines = fin.readlines()
fout = open("Optim_ICG.txt", "w")
print("----------------------------------------------------")
print("Live Variable Analysis")
print("-----------------------------------------------------")

LiveVariableAnalysis(lines)

print("-------------------------------------------------------")
print("Dead Code Elimination")
print("-------------------------------------------------------")

lines = DeadCodeElimination(lines)
printc(lines)

print("--------------------------------------")
print("Common Sub EXpression Elimination")
print("-------------------------------------")

lines = eliminate_common_subexpressions(lines)
printc(lines)

printl(lines,fout)

fin.close()
fout.close()
