TITLE   8086 Code Template (for EXE file)

;       AUTHOR          ZY
;       DATE            2025.1.5
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'
; TODO: add your data here!!!!
HOUR  db  0
MIN   db  0
SEC   db  0

COUNT db  0
VAR   dw  0
INNER_COUNT db 0
VAR_INDEX   dw    0

string_fun  db 'Xidian University 2024$'

string_fun_length  dw $-string_fun 
interupt    db  '$'        
string_origin  db 'The original data is: $' 


string_main  db 'please input the function number(1~5)$' 
string_error db 'Wrong number, please input again:  $' 
string_broken db 'The pro is broken, Ple. run again $'
  

string_fun1_result  db 100 dup(0) 
             db '$'                       
string_fun1_disresult   db  'The Upper Case is:  $'       
             
fun2_string      db 'Xidian University 2024'      
fun2_string_length    db $-fun2_string                
fun2_hex         db 0F1h, 25h, 0Dh                
fun2_hex_length       db $-fun2_hex                    
fun2_empty_msg   db 'Empty string$'


string_fun2_result  db 'The maximum is:  $'


string_fun3_intro   db  'The original data is:$'
string_fun3_disp_result     db 'The sorted data is: $' 
string_fun3_hex      dw 0005H
                     dw 0081H
                     dw 0032H
                     dw 0044H
                    
string_fun3_number   dw $-string_fun3_hex
string_fun3_temp     dw  100 DUP(0)
                     db '$'
string_fun3_result   dW  100 dup(0)
                     db  '$'
                     
                                 
string_fun4_info     db 'please press anykey to display the time $'            
string_fun4  db  'Now the time is:$'
string_time       db ':$'
                   db '$'            

   
;string_input_character db 'please input character $'
;string_input_error     db 'error please input 0~9 a~z A~Z $'
;string_fun3_info     db 'please input the decimal number $'
;string_fun3_error    db 'input error,please input 0~255 $'
;string_fun3_hex      db 100 dup(?)
;                     db '$'
;string_fun3_temp     dw  ?
;                     db '$'
;string_fun3_result   db  100 dup(?)
;                     db  '$'
;string_hexcopy       db  100 dup(?)
;                     db  '$'
;string_fun4_info     db 'please press anykey to display the time $'

DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
        DW      100h    DUP(?)
TOP     LABEL WORD
SSEG    ENDS



CSEG    SEGMENT 'CODE'
        ASSUME  CS:CSEG, DS:DSEG, ES:DSEG, SS:SSEG
;*******************************************

START:

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX
    MOV     AX, SSEG
    MOV     SS, AX
    LEA     SP, TOP
    

; TODO: add your code here!!!!
  MAIN_FUNCTION:
       
       MOV     AH, 02H
       MOV     DL, 0DH    ; 0d:回车  0a：换行换到下面位置
       INT     21H
       MOV     AH, 02H
       MOV     DL, 0AH
       INT     21H
       
       LEA     DX, string_main  ;   显示一段字符串  地址：  DS：DX
       MOV     AH, 09H
       INT     21H
       
       MOV     AH,  01H    ;      输入一个数字（其ascii码会输入到AL），选择子程序
       INT     21H
       
       CMP     AL, 31H    ;    分析是不是1-5，如果不是，报错；如果是，调用响应子函数
       JB      DISP_INPUT_ERR
       CMP     AL, 35H
       JA      DISP_INPUT_ERR
       JMP     FUNC_SEL
       
  DISP_INPUT_ERR:
       MOV     AH,  02H    ;   回车
       MOV     DL,  0DH
       INT     21H
       MOV     AH, 02H
       MOV     DL, 0AH
       INT     21H
       LEA     DX,  string_error 
       MOV     AH,  09H
       INT     21H
       JMP      MAIN_FUNCTION
       
 FUNC_SEL:
       CMP  AL,  32H
       JB   FUNC_1
       JE   FUNC_2   
       JMP  FUNC_345
       
 FUNC_345:
       CMP  AL,  34H
       JB   FUNC_3
       JE   FUNC_4
       JMP  FUNC_5
       
   
 FUNC_1:
        CALL  FUNCTION_1  
        JMP   MAIN_FUNCTION
  
 FUNC_2:
        CALL  FUNCTION_2
        JMP   MAIN_FUNCTION
 
 FUNC_3:
        CALL  FUNCTION_3
        JMP   MAIN_FUNCTION
        
 FUNC_4:
        CALL  FUNCTION_4
        JMP   MAIN_FUNCTION
  
  FUNC_5:
        CALL  FUNCTION_5
        JMP   MAIN_FUNCTION     
       
  ;   INPUT YOUR FUNCTION 1  HERE     
    FUNCTION_1 PROC NEAR     
          
       MOV  BX, 01H
       MOV     AH,  02H   
       MOV     DL,  0DH
       INT     21H
       MOV     AH, 02H
       MOV     DL, 0AH
       INT     21H
       
       MOV  AH,09H
       LEA  DX,string_fun3_intro
       INT  21H
       
       MOV  AH,09H
       LEA  DX,string_fun
       INT  21H
       
       MOV  CX, string_fun_length
       LEA  BP, string_fun
    F1_LABEL:
       MOV  AL,DS:[BP]
       CMP  AL,61H
       JB   F1_DEC
       CMP  AL,7AH
       JA   F1_DEC
       SUB  AL,20H
       MOV  DS:[BP],AL
    F1_DEC:
       DEC  CX
       INC  BP
       CMP  CX,0
       JA  F1_LABEL

       MOV     AH, 02H
       MOV     DL, 0DH   
       INT     21H
       MOV     AH, 02H
       MOV     DL, 0AH
       INT     21H
       
       LEA  BP,string_fun
       MOV  CX,string_fun_length
       
       MOV  AH,09H
       LEA  DX,string_fun1_disresult
       INT  21H
       
       MOV  AH,09H
       LEA  DX,string_fun
       INT  21H
    
       RET       
          
    FUNCTION_1     ENDP   
    
    
       
       
 ;   INPUT YOUR FUNCTION 2 HERE 
    FUNCTION_2 PROC NEAR          
                            
            MOV AH, 02H
            MOV DL, 0DH
            INT 21H
            MOV DL, 0AH
            INT 21H
        
            
            LEA DX, string_origin
            MOV AH, 09H
            INT 21H
        
            
            MOV AH, 02H
            MOV DL, 27H
            INT 21H
        
            
            MOV AL, fun2_string_length
            OR AL, AL
            JZ F2_ISEMPTY_STRING
            
            
            MOV CL, fun2_string_length   
            XOR CH, CH               
            LEA SI, fun2_string      
        F2_DISPLAY_STRING:
            MOV AL, [SI]
            MOV DL, AL
            MOV AH, 02H
            INT 21H
            INC SI
            LOOP F2_DISPLAY_STRING
            JMP F2_CONTINUE_DISPLAY
        
        F2_ISEMPTY_STRING:
            
            LEA DX, fun2_empty_msg
            MOV AH, 09H
            INT 21H
        
        F2_CONTINUE_DISPLAY:
            
            MOV DL, 27H
            MOV AH, 02H
            INT 21H
            MOV DL, 2CH
            INT 21H
            MOV DL, " "
            INT 21H
        
            
            XOR BX, BX                
            LEA SI, fun2_hex          
        F2_DISPLAY_HEX:
            MOV AL, fun2_hex_length
            CMP BL, AL                
            JAE F2_START_MAX_SEARCH     
            
            MOV AL, [SI]              
        
            
            PUSH AX                   
            MOV CL, 4
            SHR AL, CL               
            CMP AL, 0AH
            POP AX                  
            JB F2_NO_LEADING     
        
            ; 显示前导0
            PUSH AX
            MOV DL, 30H
            MOV AH, 02H
            INT 21H
            POP AX
        
        F2_NO_LEADING:    
            ; 显示高位
            MOV AH, AL
            MOV CL, 4
            SHR AH, CL
            CMP AH, 0AH
            JB F2_HIGH_DIG
            ADD AH, 07H
        F2_HIGH_DIG:
            ADD AH, 30H
            PUSH AX                   ; 保存AX
            MOV DL, AH
            MOV AH, 02H
            INT 21H
            POP AX                    ; 恢复AX
        
            
            AND AL, 0FH
            CMP AL, 0AH
            JB F2_LOW_DIG
            ADD AL, 07H
        F2_LOW_DIG:
            ADD AL, 30H
            MOV DL, AL
            MOV AH, 02H
            INT 21H
        
            
            MOV DL, 48H
            MOV AH, 02H
            INT 21H
        
            
            INC BL
            MOV AL, fun2_hex_length
            CMP BL, AL
            JAE F2_START_MAX_SEARCH     
        
           
            MOV DL, 2CH
            MOV AH, 02H
            INT 21H
            MOV DL, ' '
            INT 21H
        
            INC SI
            JMP F2_DISPLAY_HEX
        
        
        
        
        
        F2_CHECK_HEX_ONLY:
            
            LEA SI, fun2_hex
            XOR BX, BX               
        
        F2_CHECK_HEX_MAX:
            MOV AL, fun2_string_length
            ADD AL, fun2_hex_length    
            CMP BL, AL
            JAE F2_SHOW_MAX_RESULT
            MOV AL, [SI]
            CMP AL, CL
            JBE F2_NEXT_HEX_NUM
            MOV CL, AL
            MOV DI, BX
        F2_NEXT_HEX_NUM:
            INC SI
            INC BX
            JMP F2_CHECK_HEX_MAX
        
        F2_CHECK_HEX_START:
            
            LEA SI, fun2_hex
            MOV BL, fun2_string_length
            XOR BH, BH
            JMP F2_CHECK_HEX_MAX
        F2_START_MAX_SEARCH:
            
            MOV CL, 0                 
            MOV DI, 0                 
            
            
            MOV AL, fun2_string_length
            OR AL, AL
            JZ F2_CHECK_HEX_ONLY       
            
            
            LEA SI, fun2_string
            XOR BX, BX
        F2_CHECK_STRING_MAX:
            CMP BL, fun2_string_length
            JAE F2_CHECK_HEX_START
            MOV AL, [SI]
            CMP AL, CL
            JBE F2_NEXT_STRING_CHAR
            MOV CL, AL
            MOV DI, BX
        F2_NEXT_STRING_CHAR:
            INC SI
            INC BX
            JMP F2_CHECK_STRING_MAX
        
        F2_SHOW_MAX_RESULT:
            
            MOV AH, 02H
            MOV DL, 0DH
            INT 21H
            MOV DL, 0AH
            INT 21H
            
           
            LEA DX, string_fun2_result
            MOV AH, 09H
            INT 21H
        
            
            MOV AL, fun2_string_length
            OR AL, AL
            JZ F2_SHOW_HEX_VALUE         
        
           
            XOR AH, AH               
            CMP DI, AX               
            JB F2_SHOW_CHAR              
            JMP F2_SHOW_HEX_VALUE       
        
        F2_SHOW_CHAR:
            
            MOV DL, CL
            MOV AH, 02H
            INT 21H
            JMP F2_FUNCTION_END
        
        F2_SHOW_HEX_VALUE:
            
            MOV AL, CL         
            MOV BL, AL          
            MOV CL, 4           
            SHR AL, CL          
            CMP AL, 0AH         
            JB F2_DISPLAY_HIGH     
            
            
            PUSH AX             ; 保存AX
            MOV DL, 30H
            MOV AH, 02H
            INT 21H
            POP AX              ; 恢复AX
        
        F2_DISPLAY_HIGH:
            ; 显示高4位
            CMP AL, 0AH         
            JB F2_DIGIT1
            ADD AL, 07H         
        F2_DIGIT1:
            ADD AL, 30H        
            MOV DL, AL
            MOV AH, 02H
            INT 21H
            
            ; 显示低4位
            MOV AL, BL          
            AND AL, 0FH         
            CMP AL, 0AH         
            JB F2_DIGIT2
            ADD AL, 07H         
        F2_DIGIT2:
            ADD AL, 30H         
            MOV DL, AL
            MOV AH, 02H
            INT 21H
            
            MOV DL, 48H
            INT 21H
        
        F2_FUNCTION_END:
            

          RET
    FUNCTION_2     ENDP   
        
        
        
        
        
;   INPUT YOUR FUNCTION 3 HERE 
    FUNCTION_3 PROC NEAR
          MOV     AH, 02H
          MOV     DL, 0DH    
          INT     21H
          MOV     AH, 02H
          MOV     DL, 0AH
          INT     21H
          
          LEA   DX,string_fun3_intro
          MOV   AH,09H
          INT   21H
          
          MOV     AH, 02H
          MOV     DL, 0DH   
          INT     21H
          MOV     AH, 02H
          MOV     DL, 0AH
          INT     21H
          
          MOV   CX,string_fun3_number
          MOV   AX,CX
          MOV   DL,2
          DIV   DL
          MOV   CX,AX
          MOV   CH,0
          LEA   SI,string_fun3_hex
          MOV   BX,0
          
     F3_INPUT_LOOP:
          
          
          MOV   BP,BX
          MOV   AX,DS:[SI][BP]
          ;高位
          MOV   DL,AH
          MOV   DH,AH
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          MOV   AX,DS:[SI][BP]
          MOV   DL,DH
          SHL   DL,4
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          ;低位
          MOV   AX,DS:[SI][BP]
          MOV   DL,AL
          MOV   DH,AL
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          MOV   AX,DS:[SI][BP]
          MOV   DL,DH
          SHL   DL,4
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          
          MOV   DL,48H
          INT   21H
          
          CMP   CL,1
          JBE   F3_PRE_PROCESS
          MOV   DL,2CH
          INT   21H
          ADD   BX,2
          MOV   BP,BX
          LOOP  F3_INPUT_LOOP
          
          
          
          
    F3_PRE_PROCESS:
          MOV     AH, 02H
          MOV     DL, 0DH    
          INT     21H
          MOV     AH, 02H
          MOV     DL, 0AH
          INT     21H
    
          LEA   DX,string_fun3_disp_result
          MOV   AH,09H
          INT   21H
                    
          MOV   BX, 03H          
          MOV   CX, string_fun3_number
          LEA   BP, string_fun3_hex
          
          
          MOV   AX,CX
          MOV   AH,0h
          MOV   DL,2
          DIV   DL
          MOV   CL,AL
          MOV   COUNT,CL
          
    F3_OUTER_LOOP:
          MOV   CL,COUNT
          CMP   CL,0
          JBE   F3_END
          LEA   SI,string_fun3_hex
          MOV   VAR_INDEX,SI
          MOV   AX,DS:[SI]
          MOV   VAR,AX
          MOV   AL,COUNT
          MOV   INNER_COUNT,AL
    F3_INNER_LOOP:
          MOV   CL,INNER_COUNT
          CMP   CL,0
          JBE   F3_INNER_NEXT
    F3_MAIN_CONTAIN:
          LEA   BP,string_fun3_hex
          MOV   AL,COUNT
          MOV   AH,0
          SUB   AL,INNER_COUNT
          MOV   DL,2
          MUL   DL
          MOV   SI,AX
          MOV   AX,DS:[BP+SI]
          CMP   AX,VAR
          JA    CHANGE      
          JMP   F3_MAIN_CONTAIN_END
          
    CHANGE:
          MOV   VAR,AX
          MOV   AX,BP
          ADD   AX,SI
          MOV   VAR_INDEX,AX
      
          
    F3_MAIN_CONTAIN_END:
          MOV   CL,INNER_COUNT
          DEC   CL
          MOV   INNER_COUNT,CL
          CMP   CL,0
          JA    F3_INNER_LOOP
    F3_INNER_NEXT:
          LEA   BP,string_fun3_hex
          MOV   AL,COUNT
          SUB   AL,1
          MOV   DL,2
          MOV   AH,0
          MUL   DL
          MOV   SI,AX
          MOV   AX,DS:[BP+SI]
          MOV   DI,VAR_INDEX
          XCHG  AX,DS:[DI]
          XCHG  AX,DS:[BP+SI]
          
          MOV   CL,COUNT
          DEC   CL
          MOV   COUNT,CL
          CMP   CL,0
          JA   F3_OUTER_LOOP
          
                
          
    F3_END:
          MOV   CX,string_fun3_number
          MOV   AX,CX
          MOV   DL,2
          DIV   DL
          MOV   CX,AX
          MOV   CH,0
          LEA   SI,string_fun3_hex
          MOV   AX,CX
          MOV   DL,2
          MUL   DL
          SUB   AX,2
          MOV   BX,AX
          
          MOV   AH, 02H
          MOV   DL, 0DH    
          INT   21H
          MOV   AH, 02H
          MOV   DL, 0AH
          INT   21H
    F3_OUTPUT_LOOP:
          
          
          MOV   BP,BX
          MOV   AX,DS:[SI][BP]
          ;高位
          MOV   DL,AH
          MOV   DH,AH
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          MOV   AX,DS:[SI][BP]
          MOV   DL,DH
          SHL   DL,4
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          ;低位
          MOV   AX,DS:[SI][BP]
          MOV   DL,AL
          MOV   DH,AL
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          MOV   AX,DS:[SI][BP]
          MOV   DL,DH
          SHL   DL,4
          SHR   DL,4
          ADD   DL,30H
          MOV   AH,02H
          INT   21H
          
          
          MOV   DL,48H
          INT   21H
          
          CMP   CL,1
          JBE    F3_LAST
          MOV   DL,2CH
          INT   21H
          SUB   BX,2
          MOV   BP,BX
          LOOP  F3_OUTPUT_LOOP
    F3_LAST:
          RET
    FUNCTION_3     ENDP      
        
        
        
        
;   INPUT YOUR FUNCTION 4 HERE 
    FUNCTION_4 PROC NEAR
        ;引导词            
          MOV   AH, 02H
          MOV   DL, 0DH    
          INT   21H
          MOV   AH, 02H
          MOV   DL, 0AH
          INT   21H
          
          MOV   AH,09H
          LEA   DX,string_fun4_info
          INT   21H
          
          MOV   AH,01H
          INT   21H
          
          MOV   AH, 02H
          MOV   DL, 0DH    
          INT   21H
          MOV   AH, 02H
          MOV   DL, 0AH
          INT   21H
          
          MOV   AH,09H
          LEA   DX,string_fun4
          INT   21H
          
          MOV   AH,2CH
          INT   21H
          
          MOV   HOUR,CH
          MOV   MIN,CL
          MOV   SEC,DH
          
          
          ;HOUR
          MOV   AH,2CH
          INT   21H
          MOV   HOUR,CH
          MOV   AL,HOUR
          SHR   CH,4
          MOV   CL,AL
          SHL   AL,4
          SHR   AL,4
          CMP   AL,10
          JB    F4_HOUR_LOOP
          INC   CH
          
          
F4_HOUR_LOOP: CMP   CH,0
          JBE   F4_HOUR_NEXT
          ADD   CL,6
          DEC   CH
          MOV   AL,CL
          DAA
          MOV   CL,AL
          JMP   F4_HOUR_LOOP
          
F4_HOUR_NEXT:
          MOV   AL,CL
          DAA
          MOV   HOUR,AL
          SHR   AL,4
          ADD   AL,30H
          MOV   DL,AL
          MOV   AH,02H
          INT   21H
          
          MOV   AL,HOUR
          DAA
          MOV   CL,AL
          SHL   CL,4
          SHR   CL,4
          MOV   AL,CL
          ADD   AL,30H
          MOV   DL,AL
          MOV   AH,02H
          INT   21H
          ;冒号
          MOV   AH,02H
          MOV   DL,3AH
          INT   21H
          ;MIN
          MOV   AH,2CH
          INT   21H
          MOV   MIN,CL
          MOV   AL,MIN
          SHR   AL,4
          MOV   CH,AL
          MOV   AL,MIN
          SHL   AL,4
          SHR   AL,4
          CMP   AL,10
          JB    F4_MIN_LOOP
          INC   CH
          
          
F4_MIN_LOOP: CMP   CH,0
          JBE   F4_MIN_NEXT
          ADD   CL,6
          DEC   CH
          MOV   AL,CL
          DAA
          MOV   CL,AL
          JMP   F4_MIN_LOOP
          
F4_MIN_NEXT:
          MOV   AL,CL
          DAA
          MOV   MIN,AL
          SHR   AL,4
          ADD   AL,30H
          MOV   DL,AL
          MOV   AH,02H
          INT   21H
          
          MOV   AL,MIN
          DAA
          MOV   CL,AL
          SHL   CL,4
          SHR   CL,4
          MOV   AL,CL
          ADD   AL,30H
          MOV   DL,AL
          MOV   AH,02H
          INT   21H
          
          
          ;冒号
          MOV   AH,02H
          MOV   DL,3AH
          INT   21H
          ;SEC
          MOV   AH,2CH
          INT   21H
          MOV   SEC,DH
          MOV   AL,SEC
          SHR   AL,4
          MOV   CH,AL
          MOV   AL,SEC
          SHL   AL,4
          SHR   AL,4
          CMP   AL,10
          MOV   CL,SEC
          JB    F4_SEC_LOOP
          INC   CH
          
          
F4_SEC_LOOP: CMP   CH,0
          JBE   F4_SEC_NEXT
          ADD   CL,6
          DEC   CH
          MOV   AL,CL
          DAA
          MOV   CL,AL
          JMP   F4_SEC_LOOP
          
F4_SEC_NEXT:
          MOV   AL,CL
          DAA
          MOV   SEC,AL
          SHR   AL,4
          ADD   AL,30H
          MOV   DL,AL
          MOV   AH,02H
          INT   21H
          
          MOV   AL,SEC
          DAA
          MOV   CL,AL
          SHL   CL,4
          SHR   CL,4
          MOV   AL,CL
          ADD   AL,30H
          MOV   DL,AL
          MOV   AH,02H
          INT   21H
          
          
          RET
    FUNCTION_4     ENDP     
        
        
        
        
        
;   INPUT YOUR FUNCTION 5HERE 
    FUNCTION_5 PROC NEAR          
         
          JMP  MAIN_FUNCTION:
          
          
          
          RET
    FUNCTION_5     ENDP
        
        
        
 
        HLT
        CSEG    ENDS 

        END    START    ; set entry point.

