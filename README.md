# CUCU Compiler

CUCU Compiler is a compiler for CUCU language. The allowed instructions are given in [Instructions.pdf](./Instructions.pdf).

## How to run
- Terminal commands to compile:
```bash
bison -d cucu.y
```
```bash
flex cucu.l
```
```bash
g++ cucu.tab.c lex.yy.c -ll -o cucu
```
- Terminal command to run:
```bash
  ./cucu  <filename>
```
## Results
- The LEXER.txt will contain the tokens.
- PARSER.txt will contain the more information, like where the function starts and ends, the arguments it takes, variable declarations inside and outside the functions,etc.
## Assumptions:

- The program must contain atleast one declaration( variable or function) and a definition of a function.

- A variable outside a function must only be declared not initialized.

- IF statements and else statements must be in parenthesis.
functions cannot have expressions as parameters.
