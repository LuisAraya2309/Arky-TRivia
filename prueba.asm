;
;
;
;
;
;

%include "io.mac"

%define BUF_SIZE 256

.DATA
    in_fn_prompt db 'Enter the input file name: ',0 
    out_fn_prompt db 'Enter the output file name: ',0 
    in_file_err_msg db 'Input file open error.',0 
    out_file_err_msg db 'Cannot create output file.',0

.UDATA
    in_file_name resb 30
    out_file_name resb 30
    fd_in resb 1   
    fd_out resb 1
    in_buf resb BUF_SIZE
    bytesQty resb 2

.CODE
    .STARTUP 
    PutStr in_fn_prompt
    GetStr in_file_name,30

    PutStr out_fn_prompt
    GetStr out_file_name,30

    ;open the input file
    mov EAX,5
    mov EBX,in_file_name
    mov ECX,110110110b
    mov EDX,0
    int 0x80
    mov [fd_in],EAX

    cmp EAX,0
    jge read_file
    PutStr in_file_err_msg
    nwln
    jmp done

read_file:

    ;read input file
    mov EAX,3
    mov EBX,[fd_in]
    mov ECX,in_buf
    mov EDX,BUF_SIZE
    int 0x80
    PutLInt EAX
    mov [bytesQty],EAX

    ;PutStr in_buf

    ;create output file
    mov EAX,8
    mov EBX,out_file_name
    mov ECX,110110110b
    int 0x80
    mov [fd_out],EAX

    cmp EAX,0
    jge write_file
    PutStr out_file_err_msg
    nwln 
    jmp close_exit

write_file:
    
    ;write to ouput file
    mov EAX,4
    mov EBX,[fd_out]
    mov ECX,in_buf
    mov EDX,[bytesQty]
    int 0x80

    cmp EDX,BUF_SIZE
    jl copy_done

    jmp write_file

copy_done:
    mov EAX,6
    mov EBX,[fd_out]

close_exit:
    mov EAX,6
    mov EBX,[fd_in]


done:
    nwln 
    .EXIT
