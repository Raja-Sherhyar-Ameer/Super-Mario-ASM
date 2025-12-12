GetKeyState PROTO, nVirtKey:DWORD

.data
    l4_strLevel     BYTE " LEVEL: 4-1 (CASTLE)",0
    l4_winMsg       BYTE "    COURSE CLEAR! PRINCESS SAVED!    ",0
    l4_strTime      BYTE "TIME: ",0
    
    l4_lavaTimer    BYTE 0
    l4_lavaState    BYTE 0 
    l4_doubleJumpUsed BYTE 0
    l4_safeXPos     BYTE 5
    l4_safeYPos     BYTE 23
    l4_justDied     BYTE 0
    
    l4_platX        BYTE 10, 28, 45, 65
    l4_platY        BYTE 19, 15, 12, 17
    l4_platLen      BYTE 8, 10, 12, 9
    l4_platPrevX    BYTE 28
    l4_platDir      SBYTE 1
    l4_platMinX     BYTE 20
    l4_platMaxX     BYTE 36
    l4_platTimer    BYTE 0

    l4_pipeX        BYTE 20, 38, 58
    l4_pipeY        BYTE 21, 19, 20
    l4_pipeHeight   BYTE 3, 5, 4
    
    l4_coinX        BYTE 11, 13, 15, 17, 46, 49, 52, 55
    l4_coinY        BYTE 18, 18, 18, 18, 11, 11, 11, 11
    l4_coinCollected BYTE 8 DUP(0)
    l4_totalCoins   BYTE 8
    l4_coinValue    DWORD 250
    
    l4_powerX       BYTE 33, 50, 69
    l4_powerY       BYTE 14, 11, 16
    l4_powerCollected BYTE 3 DUP(0)
    
    strBossHP db "BOSS HP: ",0
    l4_bossX        BYTE 50
    l4_bossY        BYTE 3
    l4_bossPrevX    BYTE 50
    l4_bossPrevY    BYTE 3
    l4_bossDir      SBYTE 1
    l4_bossPatrolMinX BYTE 10
    l4_bossPatrolMaxX BYTE 70
    l4_bossPatrolY  BYTE 3
    l4_bossTimer    BYTE 0
    l4_bossActive   BYTE 1
    l4_bossState    BYTE 0
    l4_bossHealth   BYTE 6
    l4_bossHitCooldown BYTE 0
    l4_bossAttackCooldown WORD 0
    l4_bossActivateX BYTE 40
    l4_bossDefeated BYTE 0
    l4_bossPhase1Fired BYTE 0
    l4_bossPhase2Fired BYTE 0
    
    l4_bossProj      BYTE 5 DUP(0)
    l4_bossProjX     BYTE 5 DUP(0)
    l4_bossProjY     BYTE 5 DUP(0)
    l4_bossProjPrevX BYTE 5 DUP(0)
    l4_bossProjPrevY BYTE 5 DUP(0)
    l4_bossProjDirX SBYTE 5 DUP(0)
    l4_bossProjDirY SBYTE 5 DUP(0)

    l4_flagX        BYTE 73
    l4_flagY        BYTE 20
    l4_flagActive   BYTE 0
    strPressAnyKey  BYTE "Press any key to continue...",0

    l4_strBaseScore  BYTE " BASE SCORE:        ",0
    l4_strBossBonus  BYTE " BOSS BONUS:        2000",0
    l4_strTimeBonus  BYTE " TIME BONUS (x50):  ",0
    l4_strFinalScore BYTE " FINAL SCORE:       ",0

.code

L4_SpawnPlayerProjectile PROC
    pushad
    mov esi, 0
    L4_findSlot:
        cmp esi, MAX_PROJ
        jge L4_spawnDone
        cmp projType[esi], 0
        je L4_slotFound
        inc esi
        jmp L4_findSlot
    L4_slotFound:
        mov al, xPos
        mov projX[esi], al
        mov al, yPos
        mov projY[esi], al
        mov projType[esi], cl 
        mov projDist[esi], 0
        
        cmp cl, 1       
        je L4_setupRed
        
        mov al, marioFacing ; blue moves horizontally
        mov projDir[esi], al
        jmp L4_spawnDone

    L4_setupRed:
        mov projDir[esi], -1 ; red moves upwards
        jmp L4_spawnDone

    L4_spawnDone:
    popad
    ret
L4_SpawnPlayerProjectile ENDP

L4_UpdatePlayerProjectiles PROC
    pushad
    mov esi, 0
    L4_updProjLoop:
        cmp esi, MAX_PROJ
        jge L4_doneUpdProj
        
        cmp projType[esi], 0
        je L4_nextProj
        
        cmp projType[esi], 1
        je L4_moveVertical
        jmp L4_moveHorizontal
        
    L4_moveVertical:
        mov al, projY[esi]
        add al, projDir[esi]   ; move up
        cmp al, 2
        jl L4_killProj
        mov projY[esi], al
        jmp L4_checkCollision
        
    L4_moveHorizontal:
        mov al, projX[esi]
        mov bl, byte ptr projDir[esi]
        add al, bl             ; move left/right
        cmp al, 0
        jle L4_killProj
        cmp al, 79
        jge L4_killProj
        mov projX[esi], al
        
        inc projDist[esi]
        cmp projDist[esi], 40
        jg L4_killProj

    L4_checkCollision:
        cmp projType[esi], 1
        je L4_handleFireball
        cmp projType[esi], 2
        je L4_handleBlueball
        jmp L4_nextProj
        
    L4_handleFireball:         ; red hits boss
        cmp l4_bossDefeated, 1
        je L4_nextProj
        
        movzx edx, l4_bossX
        movzx eax, l4_bossY
        mov bl, projX[esi]
        mov bh, projY[esi]
        
        movzx ecx, bl
        sub ecx, edx
        cmp ecx, 0
        jge L4_absX
        neg ecx
    L4_absX:
        cmp ecx, 2         ; check alignment
        jg L4_nextProj
        
        cmp bh, al         ; check height
        jg L4_nextProj
        cmp bh, 2
        jl L4_nextProj
        
        cmp l4_bossHealth, 0
        jle L4_killProj
        dec l4_bossHealth
        
        mov dl, l4_bossX
        mov dh, l4_bossY
        call Gotoxy
        mov eax, white + (red * 16)
        call SetTextColor
        mov al, 'X'
        call WriteChar
        mov eax, 30
        call Delay
        
        add score, 100
        call PlayCoinSound
        
        movzx eax, l4_bossHealth
        cmp eax, 4
        jne L4_chkPhase2_Proj
        cmp l4_bossPhase1Fired, 0
        jne L4_chkPhase2_Proj
        call L4_EraseBoss
        mov l4_bossPhase1Fired, 1
        call L4_FireBossProjectiles
        
    L4_chkPhase2_Proj:
        movzx eax, l4_bossHealth
        cmp eax, 2
        jne L4_chkDefeat_Proj
        cmp l4_bossPhase2Fired, 0
        jne L4_chkDefeat_Proj
        call L4_EraseBoss
        mov l4_bossPhase2Fired, 1
        call L4_FireBossProjectiles
        
    L4_chkDefeat_Proj:
        movzx eax, l4_bossHealth
        cmp eax, 0
        jg L4_killProj
        
        mov l4_bossDefeated, 1
        mov l4_bossActive, 0
        mov l4_bossHealth, 0
        
        push edx
        mov dl, l4_bossPrevX
        mov dh, l4_bossPrevY
        call L4_RepairTile
        mov dl, l4_bossX
        mov dh, l4_bossY
        call L4_RepairTile
        pop edx
        
        add score, 5000
        mov l4_flagActive, 1
        jmp L4_killProj
        
    L4_handleBlueball:      ; blue hits coin
        mov edi, 0
    L4_chkCoinBlue:
        cmp edi, 8 
        jge L4_nextProj
        
        lea ebx, l4_coinCollected
        cmp byte ptr [ebx + edi], 1
        je L4_nextCoinBlue
        
        lea ebx, l4_coinX
        mov dl, byte ptr [ebx + edi]
        cmp projX[esi], dl
        jne L4_nextCoinBlue
        
        lea ebx, l4_coinY
        mov dh, byte ptr [ebx + edi]
        cmp projY[esi], dh
        jne L4_nextCoinBlue
        
        lea ebx, l4_coinCollected
        mov byte ptr [ebx + edi], 1
        add score, 200
        inc coinsCollected
        call PlayCoinSound
        jmp L4_killProj
        
    L4_nextCoinBlue:
        inc edi
        jmp L4_chkCoinBlue

    L4_killProj:
        mov dl, projX[esi]
        mov dh, projY[esi]
        call L4_RepairTile
        mov projType[esi], 0
        
    L4_nextProj:
        inc esi
        jmp L4_updProjLoop
        
    L4_doneUpdProj:
    popad
    ret
L4_UpdatePlayerProjectiles ENDP

L4_DrawPlayerProjectiles PROC
    pushad
    mov esi, 0
    L4_drawPPLoop:
        cmp esi, MAX_PROJ
        jge L4_doneDrawPP
        cmp projType[esi], 0
        je L4_skipDrawPP
        
        mov dl, projX[esi]
        mov dh, projY[esi]
        call Gotoxy
        
        cmp projType[esi], 1
        je L4_drawFire
        
        ; Draw Blue
        mov eax, lightBlue + (black * 16)
        call SetTextColor
        mov al, charBlue
        call WriteChar
        jmp L4_skipDrawPP
        
    L4_drawFire:
        mov eax, lightRed + (black * 16)
        call SetTextColor
        mov al, charFire
        call WriteChar
        
    L4_skipDrawPP:
        inc esi
        jmp L4_drawPPLoop
    L4_doneDrawPP:
    popad
    ret
L4_DrawPlayerProjectiles ENDP

L4_ErasePlayerProjectiles PROC
    pushad
    mov esi, 0
    L4_erasePPLoop:
        cmp esi, MAX_PROJ
        jge L4_doneErasePP
        cmp projType[esi], 0
        je L4_skipErasePP
        
        mov dl, projX[esi]
        mov dh, projY[esi]
        call L4_RepairTile ; Use RepairTile to restore background
        
    L4_skipErasePP:
        inc esi
        jmp L4_erasePPLoop
    L4_doneErasePP:
    popad
    ret
L4_ErasePlayerProjectiles ENDP

; ---------------------------------------------------------
;  L4_EraseMario - Erase Mario using L4_RepairTile
; ---------------------------------------------------------
L4_EraseMario PROC
    push edx
    mov dl, prevXPos
    mov dh, prevYPos
    call L4_RepairTile
    pop edx
    ret
L4_EraseMario ENDP

; ---------------------------------------------------------
;  EXISTING LEVEL 4 PROCEDURES
; ---------------------------------------------------------

L4_DrawRepeatedChar PROC
    push ecx
    push eax
    L4_repeatLoop:
        call WriteChar
    loop L4_repeatLoop
    pop eax
    pop ecx
    ret
L4_DrawRepeatedChar ENDP

L4_DrawPipeSegment PROC
    push eax
    push edx
    call Gotoxy
    mov eax, yellow + (red * 16)
    call SetTextColor
    mov al, 186
    call WriteChar
    call WriteChar
    pop edx
    pop eax
    ret
L4_DrawPipeSegment ENDP

L4_DrawPlatformSegment PROC
    push eax
    push ecx
    push edx
    call Gotoxy
    mov eax, lightGray + (magenta * 16)
    call SetTextColor
    movzx ecx, cl
    mov al, 205 
    call L4_DrawRepeatedChar
    pop edx
    pop ecx
    pop eax
    ret
L4_DrawPlatformSegment ENDP

L4_IsInRange PROC
    cmp al, bl
    jl L4_outOfRange
    cmp al, bh
    jg L4_outOfRange
    mov al, 1
    ret
    L4_outOfRange:
    mov al, 0
    ret
L4_IsInRange ENDP

L4_FireBossProjectiles PROC
    pushad
    mov esi, 0
    L4_clearOldProj:
        cmp esi, 5
        jl L4_continueClearing
        jmp L4_startFiring
        L4_continueClearing:
        cmp l4_bossProj[esi], 0
        je L4_skipClear
        push edx
        mov dl, l4_bossProjPrevX[esi]
        mov dh, l4_bossProjPrevY[esi]
        call L4_RepairTile
        pop edx
        mov l4_bossProj[esi], 0
        L4_skipClear:
        inc esi
        jmp L4_clearOldProj
    L4_startFiring:
    mov ecx, 5
    mov esi, 0
    L4_fireLoop:
        mov al, l4_bossX
        mov l4_bossProjX[esi], al
        mov l4_bossProjPrevX[esi], al
        mov al, l4_bossY
        mov l4_bossProjY[esi], al
        mov l4_bossProjPrevY[esi], al
        mov l4_bossProj[esi], 1
        cmp esi, 0
        je L4_proj0
        cmp esi, 1
        je L4_proj1
        cmp esi, 2
        je L4_proj2
        cmp esi, 3
        je L4_proj3
        cmp esi, 4
        je L4_proj4
        L4_proj0:
            mov l4_bossProjDirX[esi], -1
            mov l4_bossProjDirY[esi], 1
            jmp L4_nextFire
        L4_proj1:
            mov l4_bossProjDirX[esi], 1
            mov l4_bossProjDirY[esi], 1
            jmp L4_nextFire
        L4_proj2:
            mov l4_bossProjDirX[esi], 0
            mov l4_bossProjDirY[esi], 1
            jmp L4_nextFire
        L4_proj3:
            mov l4_bossProjDirX[esi], -1
            mov l4_bossProjDirY[esi], 0
            jmp L4_nextFire
        L4_proj4:
            mov l4_bossProjDirX[esi], 1
            mov l4_bossProjDirY[esi], 0
        L4_nextFire:
        inc esi
        sub ecx, 1
        jz L4_fireDoneLabel
        jmp L4_fireLoop
    L4_fireDoneLabel:
    popad
    ret
L4_FireBossProjectiles ENDP

L4_UpdateBossProjectiles PROC
    pushad
    mov esi, 0
    L4_updateProjLoop:
        cmp esi, 5
        jl L4_continueUpdateProj
        jmp L4_updateProjDone
        L4_continueUpdateProj:
        cmp l4_bossProj[esi], 0
        jne L4_projActive
        jmp L4_skipProjUpdate
        L4_projActive:
        mov al, l4_bossProjX[esi]
        mov l4_bossProjPrevX[esi], al
        mov al, l4_bossProjY[esi]
        mov l4_bossProjPrevY[esi], al
        movsx eax, l4_bossProjDirX[esi]
        movzx ebx, l4_bossProjX[esi]
        add ebx, eax
        cmp ebx, 0
        jge L4_checkRightBound
        jmp L4_deactivateProj
        L4_checkRightBound:
        cmp ebx, 79
        jle L4_xBoundOK
        jmp L4_deactivateProj
        L4_xBoundOK:
        mov l4_bossProjX[esi], bl
        movsx eax, l4_bossProjDirY[esi]
        movzx ebx, l4_bossProjY[esi]
        add ebx, eax
        cmp ebx, 2
        jge L4_checkBottomBound
        jmp L4_deactivateProj
        L4_checkBottomBound:
        cmp ebx, 24
        jle L4_yBoundOK
        jmp L4_deactivateProj
        L4_yBoundOK:
        mov l4_bossProjY[esi], bl
        call L4_CheckProjMapCollision
        cmp al, 1
        je L4_deactivateProj
        jmp L4_skipProjUpdate
        L4_deactivateProj:
            mov l4_bossProj[esi], 0
            push edx
            mov dl, l4_bossProjPrevX[esi]
            mov dh, l4_bossProjPrevY[esi]
            call L4_RepairTile
            pop edx
        L4_skipProjUpdate:
        inc esi
        jmp L4_updateProjLoop
    L4_updateProjDone:
    popad
    ret
L4_UpdateBossProjectiles ENDP

L4_CheckProjMapCollision PROC
    push ebx
    push ecx
    push edx
    push edi
    movzx edx, l4_bossProjX[esi]
    movzx eax, l4_bossProjY[esi]
    mov edi, 0
    L4_checkProjPlat:
        cmp edi, 4
        jl L4_continueCheckPlat
        jmp L4_checkProjPipes
        L4_continueCheckPlat:
        movzx ebx, l4_platY[edi]    
        cmp eax, ebx                
        jne L4_nextProjPlat
        movzx ebx, l4_platX[edi]
        cmp edx, ebx
        jl L4_nextProjPlat
        add bl, l4_platLen[edi]
        dec bl
        cmp edx, ebx
        jg L4_nextProjPlat
        mov al, 1
        jmp L4_projMapDone
        L4_nextProjPlat:
        inc edi
        jmp L4_checkProjPlat
    L4_checkProjPipes:
        mov edi, 0
        L4_projPipeLoop:
            cmp edi, 3
            jl L4_continuePipeCheck
            jmp L4_checkProjFloor
            L4_continuePipeCheck:
            movzx ebx, l4_pipeX[edi]
            cmp edx, ebx
            je L4_isProjPipe
            inc ebx
            cmp edx, ebx
            jne L4_nextProjPipe
            L4_isProjPipe:
            movzx ecx, l4_pipeY[edi]
            cmp eax, ecx
            jl L4_nextProjPipe
            movzx ebx, l4_pipeHeight[edi]
            add ebx, ecx
            cmp eax, ebx
            jge L4_nextProjPipe
            mov al, 1
            jmp L4_projMapDone
            L4_nextProjPipe:
            inc edi
            jmp L4_projPipeLoop
    L4_checkProjFloor:
        cmp eax, 24
        jl L4_projNoHit
        mov al, 1
        jmp L4_projMapDone
    L4_projNoHit:
        mov al, 0
    L4_projMapDone:
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
L4_CheckProjMapCollision ENDP

L4_EraseBossProjectiles PROC
    pushad
    mov esi, 0
    L4_eraseProjLoop:
        cmp esi, 5
        jl L4_continueEraseProj
        jmp L4_eraseProjDone
        L4_continueEraseProj:
        cmp l4_bossProj[esi], 0
        je L4_skipProjErase
        push edx
        mov dl, l4_bossProjPrevX[esi]
        mov dh, l4_bossProjPrevY[esi]
        call L4_RepairTile
        pop edx
        L4_skipProjErase:
        inc esi
        jmp L4_eraseProjLoop
    L4_eraseProjDone:
    popad
    ret
L4_EraseBossProjectiles ENDP

L4_DrawBossProjectiles PROC
    pushad
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov esi, 0
    L4_drawProjLoop:
        cmp esi, 5
        jl L4_continueDrawProj
        jmp L4_drawProjDone
        L4_continueDrawProj:
        cmp l4_bossProj[esi], 0
        je L4_skipProjDraw
        mov dl, l4_bossProjX[esi]
        mov dh, l4_bossProjY[esi]
        call Gotoxy
        mov al, '*'
        call WriteChar
        L4_skipProjDraw:
        inc esi
        jmp L4_drawProjLoop
    L4_drawProjDone:
    popad
    ret
L4_DrawBossProjectiles ENDP

L4_CheckBossProjHit PROC
    pushad
    cmp invincibleTimer, 0
    jle L4_checkProjHitStart
    jmp L4_noProjHit
    L4_checkProjHitStart:
    movzx edx, xPos
    movzx eax, yPos
    mov esi, 0
    L4_checkProjHitLoop:
        cmp esi, 5
        jl L4_continueProjHitCheck
        jmp L4_noProjHit
        L4_continueProjHitCheck:
        cmp l4_bossProj[esi], 0
        je L4_nextProjHit
        movzx ebx, l4_bossProjX[esi]
        cmp edx, ebx
        jne L4_nextProjHit
        movzx ebx, l4_bossProjY[esi]
        cmp eax, ebx
        jne L4_nextProjHit
        push edx
        mov dl, l4_bossProjPrevX[esi]
        mov dh, l4_bossProjPrevY[esi]
        call L4_RepairTile
        pop edx
        mov l4_bossProj[esi], 0
        call L4_ResetMarioAfterDeath
        jmp L4_noProjHit
        L4_nextProjHit:
        inc esi
        jmp L4_checkProjHitLoop
    L4_noProjHit:
    popad
    ret
L4_CheckBossProjHit ENDP

L4_UpdateBoss PROC
    push eax
    push ebx
    push edx
    cmp l4_bossDefeated, 1
    je L4_skipBossMove
    cmp l4_bossHitCooldown, 0
    je L4_noCooldown
    dec l4_bossHitCooldown
    L4_noCooldown:
    cmp l4_bossAttackCooldown, 0
    je L4_canMove
    dec l4_bossAttackCooldown
    L4_canMove:
    inc l4_bossTimer
    cmp l4_bossTimer, 5
    jl L4_skipBossMove
    mov l4_bossTimer, 0
    mov al, l4_bossX
    mov l4_bossPrevX, al
    mov al, l4_bossY
    mov l4_bossPrevY, al
    cmp l4_bossState, 0
    je L4_patrolMode
    cmp l4_bossState, 1
    je L4_trackingMode
    cmp l4_bossState, 2
    je L4_returningMode
    jmp L4_skipBossMove
    L4_patrolMode:
    mov al, xPos
    cmp al, l4_bossActivateX
    jge L4_activateTracking
    mov al, l4_bossY
    cmp al, l4_bossPatrolY
    jne L4_fixPatrolHeight
    mov al, l4_bossX
    movsx ebx, l4_bossDir
    add al, bl
    cmp al, l4_bossPatrolMinX
    jle L4_reversePatrol
    cmp al, l4_bossPatrolMaxX
    jge L4_reversePatrol
    mov l4_bossX, al
    jmp L4_skipBossMove
    L4_fixPatrolHeight:
    mov al, l4_bossY
    cmp al, l4_bossPatrolY
    jl L4_patrolMoveDown
    dec l4_bossY
    jmp L4_skipBossMove
    L4_patrolMoveDown:
    inc l4_bossY
    jmp L4_skipBossMove
    L4_reversePatrol:
    neg l4_bossDir
    jmp L4_skipBossMove
    L4_activateTracking:
    mov l4_bossState, 1
    jmp L4_skipBossMove
    L4_trackingMode:
    cmp l4_bossAttackCooldown, 0
    jg L4_skipBossMove
    mov al, xPos
    mov bl, l4_bossX
    cmp al, bl
    jl L4_trackMoveLeft
    cmp al, bl
    jg L4_trackMoveRight
    jmp L4_trackVertical
    L4_trackMoveLeft:
    mov al, l4_bossX
    cmp al, 3
    jle L4_trackVertical
    dec l4_bossX
    jmp L4_skipBossMove
    L4_trackMoveRight:
    mov al, l4_bossX
    cmp al, 77
    jge L4_trackVertical
    inc l4_bossX
    jmp L4_skipBossMove
    L4_trackVertical:
    mov al, yPos
    mov bl, l4_bossY
    cmp al, bl
    jl L4_trackMoveUp
    cmp al, bl
    jg L4_trackMoveDown
    mov l4_bossState, 2
    mov l4_bossAttackCooldown, 100
    jmp L4_skipBossMove
    L4_trackMoveUp:
    mov al, l4_bossY
    cmp al, 3
    jle L4_skipBossMove
    dec l4_bossY
    jmp L4_skipBossMove
    L4_trackMoveDown:
    mov al, l4_bossY
    cmp al, 22
    jge L4_checkRetreat
    inc l4_bossY
    jmp L4_skipBossMove
    L4_checkRetreat:
    mov al, l4_bossY
    mov bl, yPos
    sub al, bl
    cmp al, -2
    jl L4_skipBossMove
    cmp al, 2
    jg L4_skipBossMove
    mov l4_bossState, 2
    mov l4_bossAttackCooldown, 100
    jmp L4_skipBossMove
    L4_returningMode:
    mov al, l4_bossY
    cmp al, l4_bossPatrolY
    je L4_backToPatrol
    jg L4_returnMoveUp
    inc l4_bossY
    jmp L4_skipBossMove
    L4_returnMoveUp:
    dec l4_bossY
    jmp L4_skipBossMove
    L4_backToPatrol:
    cmp l4_bossAttackCooldown, 0
    jg L4_skipBossMove
    mov l4_bossState, 1
    L4_skipBossMove:
    pop edx
    pop ebx
    pop eax
    ret
L4_UpdateBoss ENDP

L4_EraseBoss PROC
    push eax
    push edx
    cmp l4_bossDefeated, 1
    je L4_skipBossErase
    mov dl, l4_bossPrevX
    mov dh, l4_bossPrevY
    call L4_RepairTile
    L4_skipBossErase:
    pop edx
    pop eax
    ret
L4_EraseBoss ENDP

L4_DrawBoss PROC
    push eax
    push edx
    cmp l4_bossDefeated, 1
    je L4_skipBossDraw
    cmp l4_bossHitCooldown, 0
    je L4_normalColor
    mov eax, white + (black * 16)
    jmp L4_drawBossChar
    L4_normalColor:
    mov eax, red + (black * 16)
    L4_drawBossChar:
    call SetTextColor
    mov dl, l4_bossX
    mov dh, l4_bossY
    call Gotoxy
    mov al, 219
    call WriteChar
    L4_skipBossDraw:
    pop edx
    pop eax
    ret
L4_DrawBoss ENDP

L4_CheckBossCollision PROC
    push eax
    push ebx
    push edx
    cmp l4_bossDefeated, 1
    je L4_noBossCollision
    movzx eax, xPos
    movzx ebx, l4_bossX
    sub eax, ebx
    cmp eax, 1
    jg L4_noBossCollision
    cmp eax, -1
    jl L4_noBossCollision
    movzx eax, yPos
    movzx ebx, l4_bossY
    sub eax, ebx
    cmp eax, 1
    jg L4_noBossCollision
    cmp eax, -1
    jl L4_noBossCollision
    movzx eax, prevYPos
    movzx ebx, l4_bossY
    cmp eax, ebx
    jge L4_sideHit
    L4_jumpedOnBoss:
    cmp l4_bossHitCooldown, 0
    jg L4_noBossCollision
    movzx eax, l4_bossHealth
    cmp eax, 0
    jle L4_noBossCollision
    dec l4_bossHealth
    mov l4_bossHitCooldown, 30
    mov velocityY, -4
    mov isJumping, 1
    push eax
    push edx
    mov eax, 1000
    add score, eax
    call PlayCoinSound
    pop edx
    pop eax
    movzx eax, l4_bossHealth
    cmp eax, 4
    jne L4_checkPhase2
    cmp l4_bossPhase1Fired, 0
    jne L4_checkPhase2
    call L4_EraseBoss
    mov l4_bossPhase1Fired, 1
    call L4_FireBossProjectiles
    L4_checkPhase2:
    movzx eax, l4_bossHealth
    cmp eax, 2
    jne L4_checkDefeat
    cmp l4_bossPhase2Fired, 0
    jne L4_checkDefeat
    call L4_EraseBoss
    mov l4_bossPhase2Fired, 1
    call L4_FireBossProjectiles
    L4_checkDefeat:
    movzx eax, l4_bossHealth
    cmp eax, 0
    jne L4_noBossCollision
    mov l4_bossDefeated, 1
    mov l4_bossActive, 0
    mov l4_bossHealth, 0
    push edx
    mov dl, l4_bossPrevX
    mov dh, l4_bossPrevY
    call L4_RepairTile
    mov dl, l4_bossX
    mov dh, l4_bossY
    call L4_RepairTile
    pop edx
    push eax
    mov eax, 5000
    add score, eax
    pop eax
    mov l4_flagActive, 1
    jmp L4_noBossCollision
    L4_sideHit:
    cmp invincibleTimer, 0
    jg L4_noBossCollision
    call L4_ResetMarioAfterDeath
    L4_noBossCollision:
    pop edx
    pop ebx
    pop eax
    ret
L4_CheckBossCollision ENDP

L4_UpdateMovingPlatform PROC
    push eax
    push ebx
    push ecx
    push edx
    inc l4_platTimer
    cmp l4_platTimer, 10
    jl L4_skipMove
    mov l4_platTimer, 0
    mov al, l4_platX[1]
    mov l4_platPrevX, al
    movsx ebx, l4_platDir
    add al, bl
    add al, bl
    cmp al, l4_platMinX
    jl L4_reverseDir
    cmp al, l4_platMaxX
    jg L4_reverseDir
    mov l4_platX[1], al
    mov bl, xPos
    mov bh, yPos
    cmp bh, 14
    jne L4_skipMove
    mov cl, l4_platPrevX
    cmp bl, cl
    jl L4_skipMove
    add cl, l4_platLen[1]
    dec cl
    cmp bl, cl
    jg L4_skipMove
    mov cl, l4_platX[1]
    cmp bl, cl
    jl L4_checkLeftBoundary
    add cl, l4_platLen[1]
    dec cl
    cmp bl, cl
    jg L4_checkRightBoundary
    movsx ecx, l4_platDir
    add bl, cl
    add bl, cl
    mov xPos, bl
    jmp L4_skipMove
    L4_checkLeftBoundary:
    mov bl, l4_platX[1]
    mov xPos, bl
    jmp L4_skipMove
    L4_checkRightBoundary:
    mov bl, l4_platX[1]
    add bl, l4_platLen[1]
    dec bl
    mov xPos, bl
    jmp L4_skipMove
    L4_reverseDir:
    neg l4_platDir
    mov al, l4_platPrevX
    mov l4_platX[1], al
    L4_skipMove:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L4_UpdateMovingPlatform ENDP

L4_ErasePlatform PROC
    push eax
    push ecx
    push edx
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, l4_platPrevX
    mov dh, l4_platY[1]
    call Gotoxy
    movzx ecx, l4_platLen[1]
    mov al, ' '
    call L4_DrawRepeatedChar
    pop edx
    pop ecx
    pop eax
    ret
L4_ErasePlatform ENDP

L4_DrawMovingPlatform PROC
    push eax
    push ecx
    push edx
    mov dl, l4_platX[1]
    mov dh, l4_platY[1]
    mov cl, l4_platLen[1]
    call L4_DrawPlatformSegment
    pop edx
    pop ecx
    pop eax
    ret
L4_DrawMovingPlatform ENDP

L4_IsOnElevatedSurface PROC
    push ebx
    push ecx
    push esi
    mov al, yPos
    cmp al, 23
    je L4_notElevated
    mov esi, 0
    L4_checkElevPlat:
        cmp esi, 4
        jge L4_checkElevPipe
        mov al, xPos
        mov bl, l4_platX[esi]
        cmp al, bl
        jl L4_nextElevPlat
        add bl, l4_platLen[esi]
        dec bl
        cmp al, bl
        jg L4_nextElevPlat
        mov al, yPos
        mov bl, l4_platY[esi]
        dec bl
        cmp al, bl
        jne L4_nextElevPlat
        mov al, 1
        jmp L4_elevDone
        L4_nextElevPlat:
        inc esi
        jmp L4_checkElevPlat
    L4_checkElevPipe:
    mov esi, 0
    L4_elevPipeLoop:
        cmp esi, 3
        jge L4_notElevated
        mov al, xPos
        mov bl, l4_pipeX[esi]
        cmp al, bl
        je L4_checkElevPipeY
        inc bl
        cmp al, bl
        jne L4_nextElevPipe
        L4_checkElevPipeY:
        mov al, yPos
        mov bl, l4_pipeY[esi]
        dec bl
        cmp al, bl
        jne L4_nextElevPipe
        mov al, 1
        jmp L4_elevDone
        L4_nextElevPipe:
        inc esi
        jmp L4_elevPipeLoop
    L4_notElevated:
    mov al, 0
    L4_elevDone:
    pop esi
    pop ecx
    pop ebx
    ret
L4_IsOnElevatedSurface ENDP

L4_IsOverPit PROC
    push ebx
    mov al, xPos
    mov bl, 25
    mov bh, 34
    call L4_IsInRange
    cmp al, 1
    je L4_overPitTrue
    mov al, xPos
    mov bl, 49
    mov bh, 56
    call L4_IsInRange
    cmp al, 1
    je L4_overPitTrue
    mov al, 0
    jmp L4_pitCheckDone
    L4_overPitTrue:
    mov al, 1
    L4_pitCheckDone:
    pop ebx
    ret
L4_IsOverPit ENDP

L4_ResetDoubleJump PROC
    mov l4_doubleJumpUsed, 0
    ret
L4_ResetDoubleJump ENDP

L4_SaveSafePosition PROC
    push eax
    call L4_IsOverPit
    cmp al, 1
    je L4_skipSave
    mov al, xPos
    mov l4_safeXPos, al
    mov al, yPos
    mov l4_safeYPos, al
    L4_skipSave:
    pop eax
    ret
L4_SaveSafePosition ENDP

L4_DrawCoins PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov esi, 0
    L4_coinDrawLoop:
        movzx ecx, l4_totalCoins
        cmp esi, ecx
        jge L4_coinDrawDone
        lea ebx, l4_coinCollected
        cmp BYTE PTR [ebx + esi], 1
        je L4_skipCoinDraw
        lea ebx, l4_coinX
        mov dl, [ebx + esi]
        lea ebx, l4_coinY
        mov dh, [ebx + esi]
        call Gotoxy
        mov al, 'O'
        call WriteChar
        L4_skipCoinDraw:
        inc esi
        jmp L4_coinDrawLoop
    L4_coinDrawDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L4_DrawCoins ENDP

L4_CheckCoinCollection PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    movzx edx, xPos
    movzx eax, yPos
    mov esi, 0
    L4_coinCheckLoop:
        movzx ecx, l4_totalCoins
        cmp esi, ecx
        jge L4_coinCheckDone
        lea ebx, l4_coinCollected
        cmp BYTE PTR [ebx + esi], 1
        je L4_skipCoinCheck
        lea ebx, l4_coinX
        movzx ebx, BYTE PTR [ebx + esi]
        cmp edx, ebx
        jne L4_skipCoinCheck
        lea ebx, l4_coinY
        movzx ebx, BYTE PTR [ebx + esi]
        cmp eax, ebx
        jne L4_skipCoinCheck
        lea ebx, l4_coinCollected
        mov BYTE PTR [ebx + esi], 1
        push eax
        push edx
        mov eax, l4_coinValue
        add score, eax
        call PlayCoinSound
        pop edx
        pop eax
        L4_skipCoinCheck:
        inc esi
        jmp L4_coinCheckLoop
    L4_coinCheckDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L4_CheckCoinCollection ENDP

L4_DrawPowerups PROC
    push eax
    push ebx
    push edx
    push esi
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov esi, 0
    L4_powerDrawLoop:
        cmp esi, 3
        jge L4_powerDrawDone
        lea ebx, l4_powerCollected
        cmp BYTE PTR [ebx + esi], 1
        je L4_skipPowerDraw
        lea ebx, l4_powerX
        mov dl, [ebx + esi]
        lea ebx, l4_powerY
        mov dh, [ebx + esi]
        call Gotoxy
        mov al, '+'
        call WriteChar
        L4_skipPowerDraw:
        inc esi
        jmp L4_powerDrawLoop
    L4_powerDrawDone:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L4_DrawPowerups ENDP

L4_CheckPowerupCollection PROC
    push eax
    push ebx
    push edx
    push esi
    movzx edx, xPos
    movzx eax, yPos
    mov esi, 0
    L4_powerCheckLoop:
        cmp esi, 3
        jge L4_powerCheckDone
        lea ebx, l4_powerCollected
        cmp BYTE PTR [ebx + esi], 1
        je L4_skipPowerCheck
        lea ebx, l4_powerX
        movzx ebx, BYTE PTR [ebx + esi]
        cmp edx, ebx
        jne L4_skipPowerCheck
        lea ebx, l4_powerY
        movzx ebx, BYTE PTR [ebx + esi]
        cmp eax, ebx
        jne L4_skipPowerCheck
        lea ebx, l4_powerCollected
        mov BYTE PTR [ebx + esi], 1
        inc lives
        push eax
        mov eax, 500
        add score, eax
        call PlayCoinSound
        pop eax
        L4_skipPowerCheck:
        inc esi
        jmp L4_powerCheckLoop
    L4_powerCheckDone:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L4_CheckPowerupCollection ENDP

Level4Gameplay PROC
    call Clrscr
    mov lives, 5
    mov score, 0
    mov hasSpringMushroom, 0
    mov xPos, 5
    mov yPos, 23
    mov prevXPos, 5
    mov prevYPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    mov isJumping, 0
    mov marioFacing, 1
    mov currentLevel, 4
    mov l4_lavaTimer, 0
    mov l4_lavaState, 0 
    mov l4_doubleJumpUsed, 0
    mov l4_safeXPos, 5
    mov l4_safeYPos, 23
    mov l4_justDied, 0
    mov gameAction, 0
    mov levelComplete, 0
    mov invincibleTimer, 0
    mov gameTimer, 120
    mov timerTick, 0
    mov l4_platX[1], 28
    mov l4_platPrevX, 28
    mov l4_platDir, 1
    mov l4_platTimer, 0
    mov l4_bossX, 50
    mov l4_bossY, 3
    mov l4_bossPrevX, 50
    mov l4_bossPrevY, 3
    mov l4_bossDir, 1
    mov l4_bossTimer, 0
    mov l4_bossActive, 1
    mov l4_bossState, 0
    mov l4_bossHealth, 6
    mov l4_bossHitCooldown, 0
    mov l4_bossAttackCooldown, 0
    mov l4_bossDefeated, 0
    mov l4_bossPhase1Fired, 0
    mov l4_bossPhase2Fired, 0
    mov l4_flagActive, 0
    mov ecx, MAX_PROJ
    mov esi, 0
    L4_resetProjLoop:
        mov projType[esi], 0
        inc esi
    loop L4_resetProjLoop
    mov ecx, 5
    mov esi, 0
    L4_resetBossProjLoop:
        mov l4_bossProj[esi], 0
        inc esi
    loop L4_resetBossProjLoop
    mov esi, 0
    L4_resetCoinsLoop:
        movzx ecx, l4_totalCoins
        cmp esi, ecx
        jge L4_resetPowerLoop
        lea ebx, l4_coinCollected
        mov BYTE PTR [ebx + esi], 0
        inc esi
        jmp L4_resetCoinsLoop
    L4_resetPowerLoop:
    mov esi, 0
    L4_resetPowerLoopInner:
        cmp esi, 3
        jge L4_initDone
        lea ebx, l4_powerCollected
        mov BYTE PTR [ebx + esi], 0
        inc esi
        jmp L4_resetPowerLoopInner
    L4_initDone:
    call PlayLevel4Music
    call L4_DrawHUD
    call L4_DrawStaticLevel
    call L4_DrawCoins
    call L4_DrawPowerups
    call L4_DrawBoss
    call DrawMario
    L4_gameLoop:
        cmp l4_justDied, 1
        jne L4_normalFrame
        mov l4_justDied, 0
        call L4_DrawStaticLevel
        call L4_DrawCoins
        call L4_DrawPowerups
        call L4_DrawBoss
        call DrawMario
        call L4_DrawHUD
        jmp L4_gameLoop
        L4_normalFrame:
        mov al, xPos
        mov prevXPos, al
        mov al, yPos
        mov prevYPos, al
        call L4_HandleInput
        cmp gameAction, 1
        je L4_restart
        cmp gameAction, 2
        je L4_exit
        
        call L4_UpdateMovingPlatform
        call L4_UpdateBoss
        call L4_UpdateBossProjectiles
        
        call L4_ErasePlayerProjectiles ; ERASE BEFORE UPDATE
        call L4_UpdatePlayerProjectiles ; UPDATE & CHECK COLLISION
        
        call L4_CheckCoinCollection
        call L4_CheckPowerupCollection
        call ApplyPhysics
        call L4_UpdateMario
        call L4_UpdateLava
        call EraseProjectiles
        cmp invincibleTimer, 0
        jle L4_skipInvCheck
        dec invincibleTimer
        L4_skipInvCheck:
        call L4_CheckHazards
        call L4_CheckBossCollision
        call L4_CheckBossProjHit
        call L4_CheckFlagCollision
        cmp levelComplete, 1
        je L4_levelWin
        cmp l4_justDied, 1
        je L4_skipRender
        call L4_CheckCoinCollection
        call L4_CheckPowerupCollection
        cmp lives, 0
        je L4_gameOver
        call L4_EraseMario
        call L4_ErasePlatform
        call L4_EraseBoss
        call L4_EraseBossProjectiles
        call L4_RedrawStatic
        call L4_DrawMovingPlatform
        call L4_DrawBoss
        call L4_DrawBossProjectiles
        call L4_DrawCoins
        call L4_DrawPowerups
        call DrawProjectiles
        
        call L4_DrawPlayerProjectiles ; DRAW CHEAT PROJ
        
        call L4_DrawFlag
        call DrawMario
        call L4_DrawHUD
        L4_skipRender:
        mov eax, 30
        call Delay
        inc timerTick
        cmp timerTick, 33
        jl L4_skipTime
        mov timerTick, 0
        dec gameTimer
        cmp gameTimer, 0
        je L4_gameOver
    L4_skipTime:
        jmp L4_gameLoop
    L4_levelWin:
        call L4_ShowWinScreen
        ret
    L4_restart:
        jmp Level4Gameplay
    L4_exit:
        ret
    L4_gameOver:
        call DisplayGameOver
        ret
Level4Gameplay ENDP

L4_HandleInput PROC
    push eax
    push ebx
    call ReadKey
    jz L4_noInput
    cmp al, 0
    je L4_checkArrowKeys
    cmp al, 'p'
    je L4_triggerPause
    cmp al, 'P'
    je L4_triggerPause
    ; Check if player can fire red projectiles (from shop or cheat)
    cmp fireballAmmo, 0
    jg L4_canFireRed
    cmp cheatActive, 1
    jne L4_standardControls
    L4_canFireRed:
    cmp al, 'r'
    je L4_cheatFire
    cmp al, 'R'
    je L4_cheatFire
    ; Blue shots only available with cheat active
    cmp cheatActive, 1
    jne L4_standardControls
    cmp al, 'b'
    je L4_cheatBlue
    cmp al, 'B'
    je L4_cheatBlue
    jmp L4_standardControls
    L4_triggerPause:
    call PauseMenu
    call Clrscr
    call L4_DrawHUD
    call L4_DrawStaticLevel
    call L4_DrawMovingPlatform
    call L4_DrawCoins
    call L4_DrawPowerups
    call L4_DrawBoss
    call L4_DrawBossProjectiles
    call L4_DrawPlayerProjectiles
    call L4_DrawFlag
    call DrawMario
    jmp L4_noInput
    L4_cheatFire:
    cmp fireballAmmo, 0
    jle L4_standardControls
    dec fireballAmmo
    mov cl, 1
    call L4_SpawnPlayerProjectile
    jmp L4_noInput
    L4_cheatBlue:
    cmp blueballAmmo, 0
    jle L4_standardControls
    dec blueballAmmo
    mov cl, 2
    call L4_SpawnPlayerProjectile
    jmp L4_noInput
    L4_standardControls:
    cmp al, 'a'
    je L4_moveLeft
    cmp al, 'A'
    je L4_moveLeft
    cmp al, 'd'
    je L4_moveRight
    cmp al, 'D'
    je L4_moveRight
    cmp al, 'w'
    je L4_inputUp
    cmp al, 'W'
    je L4_inputUp
    cmp al, 'x'
    je L4_exitInput
    cmp al, 'X'
    je L4_exitInput
    cmp al, 27
    je L4_exitInput
    jmp L4_noInput
    L4_checkArrowKeys:
    cmp ah, 4Bh
    je L4_moveLeft
    cmp ah, 4Dh
    je L4_moveRight
    cmp ah, 48h
    je L4_inputUp
    jmp L4_noInput
    L4_moveLeft:
    mov marioFacing, -1
    mov bl, xPos
    mov al, xPos
    cmp al, minX
    jle L4_noInput
    dec xPos
    call L4_CheckPipeCollisionHorizontal
    cmp al, 1
    je L4_restoreLeft
    jmp L4_noInput
    L4_restoreLeft:
    mov xPos, bl
    jmp L4_noInput
    L4_moveRight:
    mov marioFacing, 1
    mov bl, xPos
    mov al, xPos
    cmp al, maxX
    jge L4_noInput
    inc xPos
    call L4_CheckPipeCollisionHorizontal
    cmp al, 1
    je L4_restoreRight
    jmp L4_noInput
    L4_restoreRight:
    mov xPos, bl
    jmp L4_noInput
    L4_inputUp:
    cmp isOnGround, 1
    je L4_doNormalJump
    cmp l4_doubleJumpUsed, 1
    je L4_noInput
    mov l4_doubleJumpUsed, 1
    mov velocityY, -3
    mov isJumping, 1
    call PlayJumpSound
    jmp L4_noInput
    L4_doNormalJump:
    mov l4_doubleJumpUsed, 0
    call L4_PerformJump
    jmp L4_noInput
    L4_exitInput:
    mov gameAction, 2
    jmp L4_noInput
    L4_noInput:
    pop ebx
    pop eax
    ret
L4_HandleInput ENDP

L4_PerformJump PROC
    push eax
    call L4_IsOnElevatedSurface
    cmp al, 1
    je L4_reducedJump
    mov velocityY, -5
    jmp L4_applyJump
    L4_reducedJump:
    mov velocityY, -3
    L4_applyJump:
    mov isOnGround, 0
    mov isJumping, 1
    call PlayJumpSound
    pop eax
    ret
L4_PerformJump ENDP

L4_CheckPipeCollisionHorizontal PROC
    push ebx
    push ecx
    push esi
    push edx
    mov esi, 0
    L4_pipeHorizLoop:
        cmp esi, 3
        jge L4_noPipeCollH
        mov al, yPos
        mov cl, l4_pipeY[esi]
        cmp al, cl
        jl L4_nextPipeH
        mov al, xPos
        mov bl, l4_pipeX[esi]
        cmp al, bl
        je L4_pipeHit
        inc bl
        cmp al, bl
        je L4_pipeHit
        jmp L4_nextPipeH
    L4_pipeHit:
        mov al, 1
        jmp L4_pipeHorizDone
    L4_nextPipeH:
        inc esi
        jmp L4_pipeHorizLoop
    L4_noPipeCollH:
    mov al, 0
    L4_pipeHorizDone:
    pop edx
    pop esi
    pop ecx
    pop ebx
    ret
L4_CheckPipeCollisionHorizontal ENDP

L4_UpdateMario PROC
    push eax
    push ebx
    mov al, yPos
    movsx ebx, velocityY
    add al, bl
    cmp al, minY
    jge L4_topBoundaryOK
    mov al, minY
    mov velocityY, 0
    L4_topBoundaryOK:
    mov yPos, al
    movsx eax, velocityY
    cmp eax, 0
    jle L4_checkGroundOnly
    call L4_CheckPipeTops
    cmp al, 1
    je L4_landedSuccessfully
    call L4_CheckPlatforms
    cmp al, 1
    je L4_landedSuccessfully
    jmp L4_checkGroundOnly
    L4_landedSuccessfully:
    call L4_ResetDoubleJump
    call L4_SaveSafePosition
    jmp L4_doneUpdate
    L4_checkGroundOnly:
    mov al, xPos
    mov bl, 25
    mov bh, 34
    call L4_IsInRange
    cmp al, 1
    je L4_inAir
    mov al, xPos
    mov bl, 49
    mov bh, 56
    call L4_IsInRange
    cmp al, 1
    je L4_inAir
    mov al, yPos
    cmp al, 23
    jl L4_inAir
    mov yPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    call L4_ResetDoubleJump
    call L4_SaveSafePosition
    jmp L4_doneUpdate
    L4_inAir:
    mov isOnGround, 0
    L4_doneUpdate:
    pop ebx
    pop eax
    ret
L4_UpdateMario ENDP

L4_CheckPlatforms PROC
    push ebx
    push ecx
    push esi
    push edx
    mov esi, 0
    L4_checkPlat:
        cmp esi, 4
        jge L4_noPlatform
        mov al, xPos
        mov bl, l4_platX[esi]
        cmp al, bl
        jl L4_nextPlat
        add bl, l4_platLen[esi]
        dec bl
        cmp al, bl
        jg L4_nextPlat
        mov cl, l4_platY[esi]
        dec cl
        mov al, prevYPos
        cmp al, cl
        jg L4_nextPlat
        mov al, yPos
        cmp al, cl
        jl L4_nextPlat
        mov yPos, cl
        mov velocityY, 0
        mov isOnGround, 1
        mov al, 1
        jmp L4_donePlat
        L4_nextPlat:
        inc esi
        jmp L4_checkPlat
    L4_noPlatform:
    mov al, 0
    L4_donePlat:
    pop edx
    pop esi
    pop ecx
    pop ebx
    ret
L4_CheckPlatforms ENDP

L4_CheckPipeTops PROC
    push ebx
    push ecx
    push esi
    cmp velocityY, 0
    jle L4_noPipeTop
    mov esi, 0
    L4_pipeLoop:
        cmp esi, 3
        jge L4_noPipeTop
        mov al, xPos
        mov bl, l4_pipeX[esi]
        cmp al, bl
        je L4_checkPipeHeight
        inc bl
        cmp al, bl
        jne L4_nextPipe
    L4_checkPipeHeight:
        mov al, yPos
        mov bl, l4_pipeY[esi]
        dec bl
        mov cl, prevYPos
        cmp cl, bl
        jg L4_nextPipe
        cmp al, bl
        jl L4_nextPipe
        mov yPos, bl
        mov velocityY, 0
        mov isOnGround, 1
        mov al, 1
        jmp L4_pipeDone
        L4_nextPipe:
        inc esi
        jmp L4_pipeLoop
    L4_noPipeTop:
    mov al, 0
    L4_pipeDone:
    pop esi
    pop ecx
    pop ebx
    ret
L4_CheckPipeTops ENDP

L4_UpdateLava PROC
    push eax
    push ecx
    push edx
    inc l4_lavaTimer
    cmp l4_lavaTimer, 50
    jl L4_doneLava
    mov l4_lavaTimer, 0
    xor l4_lavaState, 1
    cmp l4_lavaState, 0
    jne L4_doneLava
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, 25
    mov dh, 23
    call Gotoxy
    mov ecx, 10
    mov al, ' '
    call L4_DrawRepeatedChar
    mov dl, 49
    mov dh, 23
    call Gotoxy
    mov ecx, 8
    mov al, ' '
    call L4_DrawRepeatedChar
    L4_doneLava:
    pop edx
    pop ecx
    pop eax
    ret
L4_UpdateLava ENDP

L4_CheckHazards PROC
    push eax
    push ebx
    push edx
    cmp invincibleTimer, 0
    jg L4_doneHaz
    mov al, xPos
    mov bl, 25
    mov bh, 34
    call L4_IsInRange
    cmp al, 1
    jne L4_checkSecondPit
    mov al, yPos
    cmp al, 22
    jle L4_checkPitBase
    mov lives, 0
    jmp L4_doneHaz
    L4_checkSecondPit:
    mov al, xPos
    mov bl, 49
    mov bh, 56
    call L4_IsInRange
    cmp al, 1
    jne L4_checkPitBase
    mov al, yPos
    cmp al, 22
    jle L4_checkPitBase
    mov lives, 0
    jmp L4_doneHaz
    L4_checkPitBase:
    mov al, yPos
    cmp al, 24
    jne L4_doneHaz
    call L4_ResetMarioAfterDeath
    L4_doneHaz:
    pop edx
    pop ebx
    pop eax
    ret
L4_CheckHazards ENDP

L4_ResetMarioAfterDeath PROC
    push eax
    cmp l4_justDied, 1
    je L4_skipDeath
    mov l4_justDied, 1
    dec lives
    mov al, l4_safeXPos
    mov xPos, al
    mov prevXPos, al
    mov al, l4_safeYPos
    mov yPos, al
    mov prevYPos, al
    mov velocityY, 0
    mov isOnGround, 1
    mov isJumping, 0
    call L4_ResetDoubleJump
    mov invincibleTimer, 90
    L4_skipDeath:
    pop eax
    ret
L4_ResetMarioAfterDeath ENDP

L4_DrawStaticLevel PROC
    push eax
    push edx
    push ecx
    push esi
    push ebx
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov ecx, 25
    mov al, 178
    call L4_DrawRepeatedChar
    mov dl, 35
    mov dh, 24
    call Gotoxy
    mov ecx, 14
    mov al, 178
    call L4_DrawRepeatedChar
    mov dl, 57
    mov dh, 24
    call Gotoxy
    mov ecx, 23
    mov al, 178
    call L4_DrawRepeatedChar
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 25
    mov dh, 24
    call Gotoxy
    mov ecx, 10
    mov al, 178
    call L4_DrawRepeatedChar
    mov dl, 49
    mov dh, 24
    call Gotoxy
    mov ecx, 8
    mov al, 178
    call L4_DrawRepeatedChar
    mov esi, 0
    L4_drawPlat:
        cmp esi, 4
        jge L4_drawPipes
        cmp esi, 1
        je L4_skipMovingPlat
        mov dl, l4_platX[esi]
        mov dh, l4_platY[esi]
        mov cl, l4_platLen[esi]
        call L4_DrawPlatformSegment
        L4_skipMovingPlat:
        inc esi
        jmp L4_drawPlat
    L4_drawPipes:
    mov esi, 0
    L4_pipeDrawLoop:
        cmp esi, 3
        jge L4_doneDraw
        movzx ecx, l4_pipeHeight[esi]
        mov bl, l4_pipeY[esi]
        L4_pipeSegLoop:
            mov dl, l4_pipeX[esi]
            mov dh, bl
            call L4_DrawPipeSegment
            inc bl
        loop L4_pipeSegLoop
        inc esi
        jmp L4_pipeDrawLoop
    L4_doneDraw:
    pop ebx
    pop esi
    pop ecx
    pop edx
    pop eax
    ret
L4_DrawStaticLevel ENDP

L4_RedrawStatic PROC
    push eax
    push edx
    push ecx
    mov dl, prevXPos
    mov dh, prevYPos
    call L4_RepairTile
    cmp l4_lavaState, 1
    jne L4_doneRepair
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, 25
    mov dh, 23
    call Gotoxy
    mov ecx, 10
    mov al, 178
    call L4_DrawRepeatedChar
    mov dl, 49
    mov dh, 23
    call Gotoxy
    mov ecx, 8
    mov al, 178
    call L4_DrawRepeatedChar
    L4_doneRepair:
    pop ecx
    pop edx
    pop eax
    ret
L4_RedrawStatic ENDP

L4_RepairTile PROC
    pushad
    mov esi, 0
    L4_chkPlat:
        cmp esi, 4
        jge L4_chkPipes
        cmp esi, 1
        je L4_nextPlat2
        mov al, dh
        cmp al, l4_platY[esi]
        jne L4_nextPlat2
        mov al, dl
        cmp al, l4_platX[esi]
        jl L4_nextPlat2
        mov bl, l4_platX[esi]
        add bl, l4_platLen[esi]
        dec bl
        cmp al, bl
        jg L4_nextPlat2
        mov eax, lightGray + (magenta * 16)
        call SetTextColor
        call Gotoxy
        mov al, 205
        call WriteChar
        jmp L4_tileDone
        L4_nextPlat2:
        inc esi
        jmp L4_chkPlat
    L4_chkPipes:
    mov esi, 0
    L4_chkPipeLoop:
        cmp esi, 3
        jge L4_chkFloor
        mov al, dl
        mov bl, l4_pipeX[esi]
        cmp al, bl
        je L4_isPipePos
        inc bl
        cmp al, bl
        jne L4_nextPipe2
        L4_isPipePos:
        mov cl, l4_pipeY[esi]
        movzx ebx, l4_pipeHeight[esi]
        add bl, cl
        cmp dh, cl
        jl L4_nextPipe2
        cmp dh, bl
        jge L4_nextPipe2
        mov eax, yellow + (red * 16)
        call SetTextColor
        call Gotoxy
        mov al, 186
        call WriteChar
        jmp L4_tileDone
        L4_nextPipe2:
        inc esi
        jmp L4_chkPipeLoop
    L4_chkFloor:
    cmp dh, 24
    jne L4_chkLava
    mov al, dl
    mov bl, 25
    mov bh, 34
    call L4_IsInRange
    cmp al, 1
    je L4_repPit
    mov al, dl
    mov bl, 49
    mov bh, 56
    call L4_IsInRange
    cmp al, 1
    je L4_repPit
    L4_repSafe:
    mov eax, gray + (black * 16)
    call SetTextColor
    call Gotoxy
    mov al, 178
    call WriteChar
    jmp L4_tileDone
    L4_repPit:
    mov eax, lightRed + (black * 16)
    call SetTextColor
    call Gotoxy
    mov al, 178
    call WriteChar
    jmp L4_tileDone
    L4_chkLava:
    cmp dh, 23
    jne L4_drawAir
    cmp l4_lavaState, 1
    jne L4_drawAir
    mov al, dl
    mov bl, 25
    mov bh, 34
    call L4_IsInRange
    cmp al, 1
    je L4_drLava
    mov al, dl
    mov bl, 49
    mov bh, 56
    call L4_IsInRange
    cmp al, 1
    je L4_drLava
    jmp L4_drawAir
    L4_drLava:
    mov eax, lightRed + (black * 16)
    call SetTextColor
    call Gotoxy
    mov al, 178
    call WriteChar
    jmp L4_tileDone
    L4_drawAir:
    mov eax, black + (black * 16)
    call SetTextColor
    call Gotoxy
    mov al, ' '
    call WriteChar
    L4_tileDone:
    popad
    ret
L4_RepairTile ENDP

L4_DrawHUD PROC
    push eax
    push edx
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strScore
    call WriteString
    mov eax, score
    call WriteDec
    mov dl, 20
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strLives
    call WriteString
    movzx eax, lives
    call WriteDec
    ; Show red projectile ammo if player has any (from shop or cheat)
    cmp fireballAmmo, 0
    jg L4_showFireAmmo
    jmp L4_skipFireAmmo
    L4_showFireAmmo:
    mov dl, 30
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strFireAmmo
    call WriteString
    movzx eax, fireballAmmo
    call WriteDec
    L4_skipFireAmmo:
    mov dl, 55
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET l4_strTime
    call WriteString
    mov eax, gameTimer
    call WriteDec
    mov al, ' '
    call WriteChar
    call WriteChar
    call WriteChar
    mov dl, 40
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET l4_strLevel
    call WriteString
    mov dl, 70
    mov dh, 0
    call Gotoxy
    mov eax, white + (black * 16)
    call SetTextColor
    mov edx, OFFSET strBossHP
    call WriteString
    movzx eax, l4_bossHealth
    call WriteDec
    pop edx
    pop eax
    ret
L4_DrawHUD ENDP

L4_DrawFlag PROC
    push eax
    push edx
    push ecx
    cmp l4_flagActive, 1
    jne L4_skipFlagDraw
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, l4_flagX
    mov dh, l4_flagY
    call Gotoxy
    mov al, '>'
    call WriteChar
    mov ecx, 4
    mov dh, l4_flagY
    inc dh
    L4_drawPoleLoop:
        push edx
        mov dl, l4_flagX
        call Gotoxy
        mov al, '|'
        call WriteChar
        pop edx
        inc dh
    loop L4_drawPoleLoop
    L4_skipFlagDraw:
    pop ecx
    pop edx
    pop eax
    ret
L4_DrawFlag ENDP

L4_CheckFlagCollision PROC
    push eax
    push ebx
    cmp l4_flagActive, 1
    jne L4_FlagColl_Done
    movzx eax, xPos
    movzx ebx, l4_flagX
    sub ebx, 1
    cmp eax, ebx
    jl L4_FlagColl_Done
    movzx ebx, l4_flagX
    add ebx, 2
    cmp eax, ebx
    jg L4_FlagColl_Done
    movzx eax, yPos
    movzx ebx, l4_flagY
    sub ebx, 1
    cmp eax, ebx
    jl L4_FlagColl_Done
    movzx ebx, l4_flagY
    add ebx, 5
    cmp eax, ebx
    jg L4_FlagColl_Done
    mov levelComplete, 1
    L4_FlagColl_Done:
    pop ebx
    pop eax
    ret
L4_CheckFlagCollision ENDP

L4_ShowWinScreen PROC
    push eax
    push ecx
    push edx
    push ebx
    call PlayWinSound
    mov eax, 100
    call Delay
    
    call Clrscr
    
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET l4_winMsg
    call WriteString
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 28
    mov dh, 6
    call Gotoxy
    mov al, '.'
    call WriteChar
    mov al, '-'
    call WriteChar
    mov al, '='
    mov ecx, 9
    call L4_DrawRepeatedChar
    mov al, '-'
    call WriteChar
    mov al, '.'
    call WriteChar
    
    mov dl, 28
    mov dh, 7
    call Gotoxy
    mov al, '\'
    call WriteChar
    mov al, 39
    call WriteChar
    mov al, '-'
    call WriteChar
    mov al, '='
    mov ecx, 7
    call L4_DrawRepeatedChar
    mov al, '-'
    call WriteChar
    mov al, 39
    call WriteChar
    mov al, '/'
    call WriteChar
    
    mov dl, 28
    mov dh, 8
    call Gotoxy
    mov al, '_'
    call WriteChar
    mov al, '|'
    call WriteChar
    mov al, ' '
    mov ecx, 3
    call L4_DrawRepeatedChar
    mov al, '.'
    call WriteChar
    mov al, '='
    call WriteChar
    mov al, '.'
    call WriteChar
    mov al, ' '
    mov ecx, 3
    call L4_DrawRepeatedChar
    mov al, '|'
    call WriteChar
    mov al, '_'
    call WriteChar
    
    mov dl, 28
    mov dh, 9
    call Gotoxy
    mov al, '('
    call WriteChar
    call WriteChar
    mov al, '|'
    call WriteChar
    mov al, ' '
    mov ecx, 2
    call L4_DrawRepeatedChar
    mov al, '{'
    call WriteChar
    call WriteChar
    mov al, '4'
    call WriteChar
    mov al, '}'
    call WriteChar
    call WriteChar
    mov al, ' '
    mov ecx, 2
    call L4_DrawRepeatedChar
    mov al, '|'
    call WriteChar
    mov al, ')'
    call WriteChar
    call WriteChar
    
    mov dl, 28
    mov dh, 10
    call Gotoxy
    mov al, '\'
    call WriteChar
    mov al, '|'
    call WriteChar
    mov al, ' '
    mov ecx, 3
    call L4_DrawRepeatedChar
    mov al, '/'
    call WriteChar
    mov al, '|'
    call WriteChar
    mov al, '\'
    call WriteChar
    mov al, ' '
    mov ecx, 3
    call L4_DrawRepeatedChar
    mov al, '|'
    call WriteChar
    mov al, '/'
    call WriteChar
    
    mov dl, 28
    mov dh, 11
    call Gotoxy
    mov al, '\'
    call WriteChar
    mov al, '_'
    call WriteChar
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, 39
    call WriteChar
    mov al, '`'
    call WriteChar
    mov al, 39
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '_'
    call WriteChar
    call WriteChar
    mov al, '/'
    call WriteChar
    
    mov dl, 28
    mov dh, 12
    call Gotoxy
    mov al, ' '
    mov ecx, 2
    call L4_DrawRepeatedChar
    mov al, '_'
    call WriteChar
    mov al, '`'
    call WriteChar
    mov al, ')'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, '('
    call WriteChar
    mov al, '`'
    call WriteChar
    mov al, '_'
    call WriteChar
    
    mov dl, 28
    mov dh, 13
    call Gotoxy
    mov al, ' '
    call WriteChar
    mov al, '_'
    call WriteChar
    mov al, '/'
    call WriteChar
    mov al, '_'
    mov ecx, 7
    call L4_DrawRepeatedChar
    mov al, '\'
    call WriteChar
    mov al, '_'
    call WriteChar
    
    mov dl, 27
    mov dh, 14
    call Gotoxy
    mov al, '/'
    call WriteChar
    mov al, '_'
    mov ecx, 11
    call L4_DrawRepeatedChar
    mov al, '\'
    call WriteChar
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov dl, 20
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET l4_strBaseScore
    call WriteString
    mov eax, score
    call WriteDec
    
    mov dl, 20
    mov dh, 17
    call Gotoxy
    mov edx, OFFSET l4_strBossBonus
    call WriteString
    
    mov eax, 2000
    add score, eax
    
    mov dl, 20
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET l4_strTimeBonus
    call WriteString
    
    mov eax, gameTimer
    mov ebx, 50
    mul ebx
    
    push eax
    call WriteDec
    pop eax
    
    add score, eax
    
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    mov dl, 20
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET l4_strFinalScore
    call WriteString
    mov eax, score
    call WriteDec
    
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, 22
    call Gotoxy
    mov edx, OFFSET strPressAnyKey
    call WriteString
    
    L4_waitForEnter:
        call ReadKey
        jz L4_waitForEnter
        cmp al, 13
        jne L4_waitForEnter
    
    pop ebx
    pop edx
    pop ecx
    pop eax
    ret
L4_ShowWinScreen ENDP