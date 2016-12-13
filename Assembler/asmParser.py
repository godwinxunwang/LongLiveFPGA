from asmError import *
# from asmSymbols import *
import re

NO_COMMAND = 0
R_COMMAND = 1
I_COMMAND = 2
J_COMMAND = 3
L_COMMAND = 4

rCommand = ["add", "sub", "and", "or", "nor"]
iCommand = ["addi", "subi", "andi","ori","shl","shr","lw","sw","blt", "beq", "bne"]
jCommand = ["jmp", "hal"]
branchCommand = ["blt", "beq", "bne"]

iDict = {
    "addi": "000001", 
    "subi": "000010", 
    "andi": "000011", 
    "ori" : "000100", 
    "shl" : "000101", 
    "shr" : "000110", 
    "lw"  : "000111", 
    "sw"  : "001000", 
    "blt" : "001001", 
    "beq" : "001010", 
    "bne" : "001011"
}

rDictFunc = {
    "add": "010000",  
    "sub": "010001", 
    "and": "010010", 
    "or" : "010011", 
    "nor": "010100"
}

jDict = {} 

def ifIType(string): 
    for i in iCommand: 
        if i in string: 
            return True 
    return False 

class Parser(object):
    

    def __init__(self, source):
        """
        Costructor Parser(source)
        Open 'source' and get ready to parse it.
        'source' may be a file name or a string list
        """
        try:
            self._file = open(source, 'r');
        except:
            FatalError('Could not open source file "'+source+'"')

        self._line_number = 0
        self._validline_num = 0
        self._rawline = None
        self._command_type = NO_COMMAND
        self._opcode = '000000'
        self._rs = ''
        self._rt = ''
        self._rd = ''
        self._shamt = '00000'
        self._funct = ''
        self._imm = ''
        self._jAddr = '' 
        
    def has_more_commands(self):
        """
        Returns True if there are more commands, False at end of file.
        """
        if self._rawline == '': 
            return 0
        else: 
            return 1
    
    def advance(self):
        """
        Reads the next command from the input and makes it the current
        command.  Should be called only if HasMoreCommands() is True.
        Initially there is no current command.
        Returns True if parsing is successful and False otherwise.
        """
        self._rawline = self._file.readline()
        self._line_number += 1
        if (self._command_type != (NO_COMMAND or L_COMMAND)): 
            self._validline_num += 1
        newline = self._rawline.strip() #remove whitespace
        newline = newline.replace(" ", "")
        newline = newline.split("#", 1)[0] #remove everything after "#"
        print(newline)
        
        splitted = newline.split("$")
        
        if(newline == '' and self.has_more_commands()): 
            self._command_type = NO_COMMAND
            return True
        
        if(newline != ''):
            print("hello head")
            if("jmp" in newline or "hal" in newline): 
                print("hello j")
                self._command_type = J_COMMAND
                if "hal" in newline: 
                    self._opcode = "111111"
                    self._jAddr = "00000000000000000000000000"
                else: 
                    self._opcode = "001100"
                    jmpLabel = newline[3:]

                    self._jAddr = "{0:026b}".format(int(jDict.get(jmpLabel)))
                return True
                
            elif(splitted[0] in iCommand):
                print("hello i")
                self._command_type = I_COMMAND 
                splittedString = newline.split("$")
                #print(splittedString)
                self._opcode = iDict.get(splittedString[0])
                self._rt = "{0:05b}".format(int(splittedString[1].replace(",","")))
                
                secondSplit = splittedString[2].split(",")
                #print(secondSplit)
                self._rs = "{0:05b}".format(int(secondSplit[0]))
                
                if(splittedString[0] in branchCommand): 
                    self._imm = "{0:016b}".format(int(jDict.get(secondSplit[1])))
                else: 
                    self._imm = "{0:016b}".format(int(secondSplit[1]))
                
                return True
                
            elif(":" in newline): # if is label 
                print("hello label")
                self._command_type = L_COMMAND
                jDict.update({newline[:-1]:(self._validline_num-1)})
                return True
                
            elif(splitted[0] in rCommand):  
                print("hello r")
                self._command_type = R_COMMAND
                splittedString = newline.split("$")
                
                self._opcode = "000000"
                self._funct = rDictFunc.get(splittedString[0])
                
                self._rd = "{0:05b}".format(int(splittedString[1].replace(",", "")))
                self._rs = "{0:05b}".format(int(splittedString[2].replace(",", "")))
                self._rt = "{0:05b}".format(int(splittedString[3].replace(",", "")))
                
                return True 
        
        return False


    def command_type(self):
        return self._command_type

    def opcode(self): 
        return self._opcode
        
    def rs(self):
        return self._rs

    def rt(self):
        return self._rt

    def rd(self):
        return self._rd
    
    def shamt(self):
        return self._shamt
        
    def funct(self):
        return self._funct
        
    def imm(self):
        return self._imm


    def jAddr(self):
        return self._jAddr
        
    def line_no(self):
        return self._line_number

if __name__ == '__main__':
    parser = Parser("test.asm")
    parsed = parser.advance()
    while (parser.has_more_commands()):
        if not parsed:
            FatalError("Parse error", parser.line_no())
        elif parser._command_type == R_COMMAND:
            output_file.write("{}{}{}{}{}{}\n".format(parser.opcode(), parser.rs(), parser.rt(), parser.rd(), parser.shamt(), parser.funct()))
        elif parser._command_type == I_COMMAND:
            output_file.write("{}{}{}{}\n".format(parser.opcode(), parser.rs(), parser.rt(), parser.imm()))
        elif parser._command_type == J_COMMAND: 
            output_file.write("{}{}\n".format(parser.opcode(), parser.jAddr()))
        parsed = parser.advance() 
