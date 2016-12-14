#!/usr/bin/python3
from asmParser import *
#from asmCode import *
from asmError import *
from sys import argv
#from numpy import binary_repr
import re

def Main():
    input_filename = argv[1]
    match = re.match('^(.*)\.asm$', input_filename)
    if not match:
        FatalError(filename + " is not an asm file")

    output_filename = match.groups()[0] + ".out"
    output_file = open(output_filename, "w");
    if not output_file:
        FatalError("Cannot open output file " + output_filename)
        
    #code = Code()
    '''
    while parser.has_more_commands():
        if not parsed:
            FatalError("Parse error", parser.line_no(), parser.line())
        parsed = parser.advance()
        #print("rawline:", parser._rawline)
    '''
    
    '''
    parser._line_number = 0
    parser._file = open(input_filename, 'r')
    parsed = parser.advance()
    '''
    #parser._command_type = NO_COMMAND
    #print("rawline:", parser._rawline)
    labelParser = Parser(input_filename)
    labelParsed = labelParser.getLabel()
    
    while labelParser.has_more_commands():
        #print("-------begin-------")
        #print(labelParser._validline_num)
        if not labelParsed:
            FatalError("Parse error", labelParser.line_no())

        labelParsed = labelParser.getLabel()   
       
    
    parser = Parser(input_filename)
    parsed = parser.advance()
    
    while parser.has_more_commands():
        #print("-------begin-------")
        #print(parser._line_number)
        print("Line No: ", parser._line_number, ". ")
        if not parsed:
            FatalError("Parse error", parser.line_no())
        elif parser._command_type == R_COMMAND:
            output_file.write("{}{}{}{}{}{}{}{}\n".format("\"", parser._opcode, parser._rs, parser._rt, parser._rd, parser._shamt, parser._funct, "\", "))
        elif parser._command_type == I_COMMAND:
            output_file.write("{}{}{}{}{}{}\n".format("\"", parser._opcode, parser._rs, parser._rt, parser._imm, "\", "))
        elif parser._command_type == J_COMMAND: 
            output_file.write("{}{}{}{}\n".format("\"", parser._opcode, parser._jAddr, "\", "))
        parsed = parser.advance()   
    print(jDict) 
        
        #print("Current command type ->", parser._command_type)
        #print("Line number: ", parser._line_number)
        #print("valid line number: ", parser._validline_num)
        #print("-------end-------")


if __name__ == '__main__':
    Main()