                                                   jmp start
    
    
    ;stringForShow:   
    startmsg db 10,13,'game started...',10,13,
             db 'player 1 turn. input location...(EX: 2,3 ) :  ',10,13,'$'
    
    p1win db 'player (1) WIN...',10,13,'$'
    p2win db 'player (2) WIN...',10,13,'$'
          
    p1turn db 'player 1 turn. input location...(EX: 2,3 )',10,13,'$'      
    p2turn db 'player 2 turn. input location...(EX: 2,3 )',10,13,'$'                                                          
    
    tAgain db 'do you want play again?(y/n)',10,13,'$' 
    
    gg db 10,13,'Good game...:)   (press any key)$'
    
    ;variables:
    mainBoard db '111111111'
    win db 0       

    RepresentationBoard db 10,13,'1,1   1,2   1,3',10,13,
                              db '2,1   2,2   2,3',10,13,
                              db '3,1   3,2   3,3',10,13,'$'
      
    input db 3 dup(?)
    locationCheck db 3 dup(',')
    
    turnMark db 42
    
    locationInvolved db 0 
    
    keyPressed db 0
    
    
    ;macros:
    initialize macro
    
    call resetMainBoard
    call resetRepresentationBoard 
    call resetLocationInvolved 
    call resetTurnMark
    call resetWin
    call showRepresentationBoard 
    call showStartmsg
    
    initialize endm  
    
    
    
    
        
     
    
    
    mainProcess macro
    
        mov ax,11
        call process 
        
        mov ax,12
        call process
        
        mov ax,13
        call process
        
        mov ax,21
        call process
        
        mov ax,22
        call process
                             
        mov ax,23
        call process
        
        mov ax,31
        call process
        
        mov ax,32
        call process
        
        mov ax,33
        call process
        
        
    mainProcess endm
    
    
    
    inputLocation macro
        
        lea bx,input
        mov ah,1
        int 21h
        mov [bx],al
        inc bx
        
        mov ah,1
        int 21h
        mov [bx],al
        inc bx
        
        mov ah,1
        int 21h
        mov [bx],al
        inc bx
        
    inputLocation endm
        
    
    
    
    fillLocationCheck macro l
                   
        mov dx,0           
        mov ax,l
        mov cl,10
        lea bp,locationCheck 
        div cl
        add ah,48
        add al,48
        mov [bp],al
        inc bp
        
        mov [bp],','
        inc bp
        
        mov [bp],ah
        
    fillLocationCheck endm
    
    
    
    updateBoard macro
        
        mov cx,0
        mov dx,0
        
        cmp locationInvolved,11
        je updateMBL11
        
        cmp locationInvolved,12
        je updateMBL12   
        
        cmp locationInvolved,13
        je updateMBL13
        
        cmp locationInvolved,21
        je updateMBL21
        
        cmp locationInvolved,22
        je updateMBL22
        
        cmp locationInvolved,23
        je updateMBL23
        
        cmp locationInvolved,31
        je updateMBL31
        
        cmp locationInvolved,32
        je updateMBL32
        
        cmp locationInvolved,33
        je updateMBL33
        
        updateMBL11:
            mov dx,0
            mov cx,2
            jmp UBEnd
        
        updateMBL12:
            mov dx,1
            mov cx,8
            jmp UBEnd
        
        updateMBL13:   
            mov dx,2
            mov cx,14
            jmp UBEnd
        
        updateMBL21:     
            mov dx,3
            mov cx,19
            jmp UBEnd
        
        updateMBL22:     
            mov dx,4
            mov cx,25
            jmp UBEnd
        
        updateMBL23:     
            mov dx,5
            mov cx,31
            jmp UBEnd
        
        updateMBL31:
            mov dx,6
            mov cx,36
            jmp UBEnd
        
        updateMBL32: 
            mov dx,7
            mov cx,42
            jmp UBEnd
        
        updateMBL33:    
            mov dx,8
            mov cx,48
        
        UBEnd:
            call update   
       
    updateBoard endm
    
    
         
         
         
         
         
    checkWin macro
        
        call checkColumnes
        call checkRows
        call checkKaj
        call isFill
        
    checkWin endm
    
    
    
    
        
    changeTurn macro
        
        cmp turnMark,38
        je l
        sub turnMark,4
        jmp CTEnd
        l:
        add turnMark,4
        CTEnd:
            
    changeTurn endm 
    
    
    print macro m
        
        lea dx,m
        mov ah,9
        int 21h    
        
    print endm
         
         
    
    
start:
    tryAgian:
        initialize   
           
        nextPlayer:        
           changeTurn
          
           inputLocation
          
           mainProcess 
      
           updateBoard
        
           print RepresentationBoard 
           
           checkWin
           cmp win,0
           jne t
           cmp turnMark,38
           je player1turn
               print p2turn
               jmp nextPlayer
           player1turn:
               print p1turn
               jmp nextPlayer  
           
           
           t:
           cmp win,1
           je doTryAgain
           
           cmp turnMark,38
           je player2win  
               print p1win 
               jmp doTryAgain
           
           player2win:
               print p2win
           
           doTryAgain:
               print tAgain
               call getKey  
               cmp keyPressed,'y'
               je tryAgian
                
               print gg
               call getKey
               call endProgram

    
     


    
            
              
              
 




 
 
 
endProgram proc
    
    mov ah,4ch
    int 21h
    
    ret
endProgram endp 

 
getKey proc
    
    mov ah,1
    int 21h
    mov keyPressed,al
    
    ret
getKey endp






 
stop proc
    
    push ax
    mov ah,8
    int 21h 
    pop ax
    
    ret
stop endp



 resetRepresentationBoard proc
            
        lea bx,RepresentationBoard    
        mov cx,0
        RRBLoop:
          
            mov [bx],10
            inc bx
            mov [bx],13
            inc bx
            
            mov [bx],'1'
            inc bx 
            mov [bx],','
            inc bx
            mov [bx],'1' 
            inc bx            
              
            mov [bx],' ' 
            inc bx 
            mov [bx],' ' 
            inc bx
            mov [bx],' ' 
            inc bx
            
            mov [bx],'1'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'2'
            inc bx            
              
            mov [bx],' ' 
            inc bx 
            mov [bx],' ' 
            inc bx
            mov [bx],' ' 
            inc bx
            
            mov [bx],'1'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'3'
            inc bx
            
            mov [bx],10
            inc bx
            mov [bx],13
            inc bx
            
            mov [bx],'2'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'1'
            inc bx            
              
            mov [bx],' ' 
            inc bx 
            mov [bx],' ' 
            inc bx
            mov [bx],' ' 
            inc bx
            
            mov [bx],'2'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'2'
            inc bx            
              
            mov [bx],' ' 
            inc bx 
            mov [bx],' ' 
            inc bx
            mov [bx],' ' 
            inc bx 
            
            mov [bx],'2'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'3' 
            inc bx
            
            mov [bx],10
            inc bx
            mov [bx],13
            inc bx
            
            mov [bx],'3'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'1'
            inc bx            
              
            mov [bx],' ' 
            inc bx 
            mov [bx],' ' 
            inc bx
            mov [bx],' ' 
            inc bx 
            
            mov [bx],'3'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'2'
            inc bx            
              
            mov [bx],' ' 
            inc bx 
            mov [bx],' ' 
            inc bx
            mov [bx],' ' 
            inc bx 
            
            mov [bx],'3'
            inc bx
            mov [bx],','
            inc bx
            mov [bx],'3'
            inc bx
                       
            mov [bx],10
            inc bx
            mov [bx],13
            inc bx
            
            mov [bx],'$'
            

             
        ret
    resetRepresentationBoard endp
    
    
    
    
    
    
    
    resetMainBoard proc
        
        lea bx,mainBoard      
        mov cx,0      
        RMBFor:
            mov [bx],'0'
            inc bx  
            inc cx
            cmp cx,9
            jne RMBFor
         
        ret
    resetMainBoard endp   
    
    
    
    
     resetTurnMark proc
        
        mov turnMark,38
        
        ret
    resetTurnMark endp
    
    
    
    
    
    resetLocationInvolved proc
        
        lea bx,locationInvolved
        mov [bx],0
        inc bx
        mov [bx],0
        inc bx
        mov [bx],0
        inc bx
        
        
        ret
    resetLocationInvolved endp  
    
    
    
    process proc    
        
       fillLocationCheck ax
       lea bp,locationCheck
       lea bx,input
       mov cx,0
       
       PLoop:
           mov al,[bx]
           cmp al,[bp]
           jne PEndFalse
           add bx,2
           add bp,2
           inc cx
           cmp cx,2
           jne Ploop
           
       PEndeTrue: 
           call updateLocationInvolved   
           
           
           
       PEndFalse:
       ret
               
    process endp 
    
    updateLocationInvolved proc  
        
        lea bx,locationinvolved
        lea bp,input
        mov cl,10
        
        mov al,[bp]
        mov ah,0 
        sub al,48
        mul cl
        mov locationinvolved,al
       
        inc bx
        add bp,2
        
        mov al,[bp]
        sub al,48
        add locationinvolved,al
                
        ret
    updateLocationInvolved endp 
    
    update proc
        
        lea bx,mainBoard 
        add bx,dx
        mov al,turnMark
        mov [bx],al
        
        
        lea bx,RepresentationBoard 
        add bx,cx
        mov [bx],' '
        inc bx
        
        mov [bx],al
        inc bx
        
        mov [bx],' '
        inc bx
                      
        ret
    update endp 
    
    
    
    
    resetWin proc
        
        mov win,0
        
        ret
    resetWin endp
    
    checkColumnes proc
        
        mov dx,0
        mov cx,3  
        
        iLoop:
            lea bx,mainBoard
            add bx,dx
            lea bp,mainBoard
            add bp,dx
            
            mov al,[bx]
            call lop
            inc dx
            loop iLoop      
          
        ret
    checkColumnes endp   
    
    
    lop proc
        
        push cx
        mov cx,3
        jLoop:
            cmp [bp],al
            jne LEnd
            cmp al,'0'
            je LEnd
            add bp,3
            loop jLoop
        
        mov win,al 
        
        
        
        LEnd:  
        pop cx
        ret
    lop endp
    
    checkRows proc
        
        mov dx,0
        mov cx,3  
        
        iRLoop:
            lea bx,mainBoard
            add bx,dx
            lea bp,mainBoard
            add bp,dx
            
            mov al,[bx]
            call lopR
            add dx,3
            loop iRLoop      
          
        ret
    checkRows endp   
    
    
    lopR proc
        
        push cx
        mov cx,3
        jRLoop:
            cmp [bp],al
            jne LREnd
            cmp al,'0'
            je LREnd
            inc bp
            loop jRLoop
        
        mov win,al 
        
        
        
        LREnd:  
        pop cx
        ret
    lopR endp
    
    
    isFill proc
        
        mov cx,9
        lea bx,mainBoard
        
        IFLoop:
            cmp [bx],'0'
            je IFEnd
            inc bx
            loop IFLoop
            
        mov win,1    
            
        IFEnd:
        ret
    isFill endp
    
    
    
    
    
    checkKaj proc
        
        lea bx,mainBoard
        lea bp,mainBoard
        add bp,4
        
        mov al,[bp]
        cmp al,[bx]
        jne next
        cmp al,'0'
        je next
        
        add bp,4 
        mov al,[bp]
        cmp al,[bx]
        jne next
        cmp al,'0'
        je next
        
        mov win,al
        jmp KEnd
        
        
        next:
        lea bx,mainBoard
        lea bp,mainBoard
        add bp,4
        add bx,2
        
        mov al,[bp]
        cmp al,[bx]
        jne KEnd
        cmp al,'0'
        je KEnd
        
        add bp,2 
        mov al,[bp]
        cmp al,[bx]
        jne KEnd
        cmp al,'0'
        je KEnd
        
        mov win,al
        jmp KEnd
            
        KEnd:
        ret
    checkKaj endp
     
    showStartmsg proc
        
        print startmsg
        
        ret
    showStartmsg endp
    
     showRepresentationBoard proc
        
        print RepresentationBoard
        
        ret
     showRepresentationBoard endp
              
