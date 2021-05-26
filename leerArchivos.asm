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

.CODE
    .STARTUP 
    PutStr in_fn_prompt
    GetStr in_file_name,30

    ;open the input file
    mov EAX,5
    mov EBX,in_file_name
    mov ECX,110110110b
    mov EDX,0
    int 0x80
    mov [fd_in],EAX

    cmp EAX,0
    jge repeat_read
    PutStr in_file_err_msg
    nwln
    jmp done

repeat_read:
    ;read input file
    mov EAX,3
    mov EBX,[fd_in]
    mov ECX,in_buf
    mov EDX,BUF_SIZE
    int 0x80
    PutLInt EAX
    PutStr in_buf

close_exit:
    mov EAX,6
    mov EBX,[fd_in] 
done: 
    nwln
    .EXIT