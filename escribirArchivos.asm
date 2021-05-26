%include "io.mac"

%define BUF_SIZE 256

.DATA
    out_fn_prompt db 'Enter the output file name: ',0 
    out_file_err_msg db 'Cannot create output file.',0
    in_buf db 'Hola mundo',0

.UDATA
    out_file_name resb 30
    fd_out resb 1
    bytesQty resb 2

.CODE
    .STARTUP 
    PutStr out_fn_prompt
    GetStr out_file_name,30
;create output file
    mov EAX,8
    mov EBX,out_file_name
    mov ECX,110110110b
    int 0x80
    mov [fd_out],EAX

    cmp EAX,0
    jge repeat_read
    PutStr out_file_err_msg
    nwln 
    jmp copy_done

repeat_read:
    
    ;write to ouput file
    mov EDX,10
    mov EAX,4
    mov EBX,[fd_out]
    mov ECX,in_buf
    int 0x80

    cmp EDX,BUF_SIZE
    jl copy_done

    jmp repeat_read
copy_done:
    mov EAX,6
    mov EBX,[fd_out]


done: 
    .EXIT