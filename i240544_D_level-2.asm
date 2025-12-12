
.data
    l2_strLevel BYTE " LEVEL: 2-1",0
    l2_currentScreen BYTE 1
    l2_secretRoomActive BYTE 0
    l2_returnX BYTE 0
    l2_returnY BYTE 0

    l2_moveSpeed BYTE 0
    l2_maxMoveSpeed BYTE 3

    l2_totalEnemies BYTE 3
    l2_enemyType BYTE 2, 1, 2          ; 2=Koopa, 1=Goomba, 2=Koopa
    l2_enemyScreen BYTE 1, 2, 2        ; Screen 1: Koopa, Screen 2: Goomba + Koopa
    
    ; Positions
    l2_enemyStartX BYTE 40, 25, 60
    l2_enemyXPos BYTE 40, 25, 60
    l2_enemyYPos BYTE 23, 23, 23       ; Ground Level
    l2_enemyPrevXPos BYTE 40, 25, 60
    
    l2_enemyDirection SBYTE 1, -1, 1
    l2_enemyAlive BYTE 1, 1, 1
    l2_enemyLeft BYTE 30, 15, 50       ; Patrol Left Bound
    l2_enemyRight BYTE 50, 40, 70      ; Patrol Right Bound
    
    ; Shell Data (Size 3 - only Koopas can become shells)
    l2_shellActive BYTE 0, 0, 0
    l2_shellX BYTE 0, 0, 0
    l2_shellY BYTE 0, 0, 0
    l2_shellDir SBYTE 0, 0, 0
    l2_shellTimer BYTE 0, 0, 0
    l2_shellMoving BYTE 0, 0, 0
    l2_shellPrevX BYTE 0, 0, 0

    l2_stairPlats BYTE 3
    l2_stairX BYTE 14, 22, 30
    l2_stairY BYTE 20, 17, 15
    l2_stairLen BYTE 7, 7, 7
    
    l2_floatPlatX BYTE 50
    l2_floatPlatY BYTE 16
    l2_floatPlatLen BYTE 10
    l2_floatDir SBYTE 1
    l2_floatTimer BYTE 0
    l2_floatMinY BYTE 12
    l2_floatMaxY BYTE 19
    
    l2_spikes BYTE 3
    l2_spikeX BYTE 35, 55, 68
    l2_spikeLen BYTE 4, 5, 3
    
    l2_screen2FloatX BYTE 35
    l2_screen2FloatY BYTE 15
    l2_screen2FloatLen BYTE 10
    
    l2_powerUpActive BYTE 1
    l2_powerUpX BYTE 38
    l2_powerUpY BYTE 14
    
    ; Main Level Coins (10 total)
    l2_mainCoins BYTE 10
    l2_mainCoinX BYTE 8, 12, 42, 46, 16, 24, 32, 52, 56, 38
    l2_mainCoinY BYTE 23, 23, 23, 23, 19, 16, 14, 15, 15, 14
    l2_mainCoinCollected BYTE 10 DUP(0)
    l2_mainCoinScreen BYTE 1, 1, 1, 1, 1, 1, 1, 1, 1, 2
    
    ; Secret Room Coins (12 total)
    l2_secretCoins BYTE 12
    l2_secretCoinX BYTE 15, 17, 23, 25, 31, 33, 39, 41, 47, 49, 55, 57
    l2_secretCoinY BYTE 19, 19, 16, 16, 14, 14, 16, 16, 19, 19, 21, 21
    l2_secretCoinCollected BYTE 12 DUP(0)
    
    l2_secretPlats BYTE 6
    l2_secretPlatX BYTE 14, 22, 30, 38, 46, 54
    l2_secretPlatY BYTE 20, 17, 15, 17, 20, 22
    l2_secretPlatLen BYTE 6, 6, 6, 6, 6, 6
    
    l2_exitPowerX BYTE 56
    l2_exitPowerY BYTE 21
    l2_flagX BYTE 75
    l2_flagY BYTE 19

.code

Level2Gameplay PROC
    resetGameL2:
    call Clrscr
    mov gameAction, 0
    mov lives, 5
    mov l2_currentScreen, 1
    mov l2_secretRoomActive, 0
    mov l2_powerUpActive, 1
    mov xPos, 5
    mov yPos, 23
    mov prevXPos, 5
    mov prevYPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    mov hasSpringMushroom, 0
    mov score,0
    mov isJumping, 0
    mov gameTimer, 300
    mov timerTick, 0
    mov cheatIndex, 0
    ; Preserve cheat ammo if cheat was activated via player name
    cmp cheatActive, 1
    jne l2_resetAmmoToZero
    mov al, 5
    mov fireballAmmo, al
    mov blueballAmmo, al
    jmp l2_doneAmmoReset
    l2_resetAmmoToZero:
    mov fireballAmmo, 0
    mov blueballAmmo, 0
    l2_doneAmmoReset:
    mov levelComplete, 0
    mov enemiesDefeated, 0
    mov marioFacing, 1
    mov l2_moveSpeed, 0
    
    mov ecx, MAX_PROJ
    mov esi, 0
    resetProjLoopL2:
        mov projType[esi], 0
        inc esi
    loop resetProjLoopL2
    
    mov esi, 0
    resetEnemyLoopL2:
        cmp esi, 3  ; <--- CHANGED TO 3
        jge doneEnemyResetL2
        mov l2_enemyAlive[esi], 1
        mov l2_shellActive[esi], 0
        mov l2_shellTimer[esi], 0
        mov l2_shellMoving[esi], 0
        mov al, l2_enemyStartX[esi]
        mov l2_enemyXPos[esi], al
        mov l2_enemyPrevXPos[esi], al
        inc esi
        jmp resetEnemyLoopL2
    doneEnemyResetL2:
    
    mov esi, 0
    resetMainCoinLoop:
        cmp esi, 10
        jge doneMainCoinReset
        mov l2_mainCoinCollected[esi], 0
        inc esi
        jmp resetMainCoinLoop
    doneMainCoinReset:
    
    mov esi, 0
    resetSecretCoinLoop:
        cmp esi, 12
        jge doneSecretCoinReset
        mov l2_secretCoinCollected[esi], 0
        inc esi
        jmp resetSecretCoinLoop
    doneSecretCoinReset:
    
    mov score, 0
    mov invincibleTimer, 0
    mov coinsCollected, 0
    call Randomize
    call PlayLevel2Music
    call L2_DrawHUD
    call L2_DrawCurrentScreen
    call L2_DrawEnemies
    call DrawMario

    gameLoopL2:
    mov al, xPos
    mov prevXPos, al
    mov al, yPos
    mov prevYPos, al
    
    call L2_HandleInput
    call L2_ApplyDeceleration
    
    cmp gameAction, 1
    je resetGameL2
    cmp gameAction, 2
    je exitGameL2
    
    call L2_UpdateFloatingPlatform
    call ApplyPhysics
    call L2_UpdateMario
    
    call EraseProjectiles
    call L2_UpdateProjectiles
    call L2_CheckProjectileEnemyCollision
    call L2_CheckProjectileCoinCollision
    
    cmp invincibleTimer, 0
    jle skipInvincibleDecL2
    dec invincibleTimer
    
skipInvincibleDecL2:
    call L2_UpdateEnemies
    call L2_UpdateShells
    call L2_CheckEnemyCollision
    call L2_CheckSpikeCollision
    call L2_CheckScreenTransition
    call L2_CheckPowerUpCollection
    call L2_CheckCoinCollection
    call L2_CheckFlagCollision
    
    cmp levelComplete, 1
    je levelWinL2
    cmp lives, 0
    je triggerGameOverL2
    
    call EraseMario
    call L2_EraseEnemies
    call L2_RedrawStatic
    call L2_DrawCoins
    call L2_DrawPowerUp
    call L2_DrawFlag
    call L2_DrawEnemies
    call DrawMario
    call DrawProjectiles
    call L2_DrawHUD
    
    mov eax, 30
    call Delay
    
    inc timerTick
    cmp timerTick, 33
    jl skipTimeUpdateL2
    
    mov timerTick, 0
    dec gameTimer
    cmp gameTimer, 0
    je triggerGameOverL2
    
skipTimeUpdateL2:
    jmp gameLoopL2

    levelWinL2:
        call DisplayLevelComplete
        ret
    triggerGameOverL2:
        call DisplayGameOver
        ret
    exitGameL2:
        ret
Level2Gameplay ENDP

L2_UpdateEnemies PROC
    push eax
    push ebx
    push ecx
    push esi
    mov esi, 0
    
    updateEnemyLoopL2:
        cmp esi, 3      ; <--- CHANGED TO 3
        jge doneUpdateEnemiesL2
        cmp l2_enemyAlive[esi], 0
        je skipUpdateEnemyL2
        cmp l2_shellActive[esi], 1
        je skipUpdateEnemyL2
        
        movzx eax, l2_enemyScreen[esi]
        movzx ecx, l2_currentScreen
        cmp al, cl
        jne skipUpdateEnemyL2
        
        mov al, l2_enemyXPos[esi]
        mov l2_enemyPrevXPos[esi], al
        mov cl, l2_enemyDirection[esi]
        add al, cl
        mov bl, l2_enemyLeft[esi]
        cmp al, bl
        jle reverseL2
        mov bl, l2_enemyRight[esi]
        cmp al, bl
        jge reverseL2
        mov l2_enemyXPos[esi], al
        jmp skipUpdateEnemyL2
        
    reverseL2:
        mov cl, l2_enemyDirection[esi]
        neg cl
        mov l2_enemyDirection[esi], cl
        mov al, l2_enemyPrevXPos[esi]
        mov l2_enemyXPos[esi], al
        
    skipUpdateEnemyL2:
        inc esi
        jmp updateEnemyLoopL2
        
    doneUpdateEnemiesL2:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
L2_UpdateEnemies ENDP

L2_CheckEnemyCollision PROC
    push eax
    push ebx
    push edx
    push esi
    
    cmp l2_secretRoomActive, 1
    je noEnemyColL2
    
    call L2_CheckMovingShellCollision
    
    mov esi, 0
    checkColLoopL2:
        cmp esi, 3
        jge noEnemyColL2
        
        cmp l2_enemyAlive[esi], 0
        je nextColEnemyL2
        
        movzx eax, l2_enemyScreen[esi]
        movzx ebx, l2_currentScreen
        cmp al, bl
        jne nextColEnemyL2
        
        mov dl, l2_enemyXPos[esi]
        mov al, xPos
        sub al, dl
        cmp al, 0
        jge absXL2
        neg al
    absXL2:
        cmp al, 2
        jg nextColEnemyL2
        
        mov dh, l2_enemyYPos[esi]
        mov al, yPos
        cmp al, dh
        jne nextColEnemyL2
        
        mov al, prevYPos
        cmp al, dh
        jl isStompL2
        
        cmp invincibleTimer, 0
        jg nextColEnemyL2
        
        dec lives
        call L2_DrawHUD
        mov invincibleTimer, 60
        jmp nextColEnemyL2
        
    isStompL2:
        mov l2_enemyAlive[esi], 0
        inc enemiesDefeated
        
        cmp l2_enemyType[esi], 2
        je createShellL2
        
        mov dl, l2_enemyXPos[esi]
        mov dh, l2_enemyYPos[esi]
        call Gotoxy
        mov al, ' '
        call WriteChar
        add score, 100
        jmp finishStompL2
        
    createShellL2:
        mov l2_shellActive[esi], 1
        mov al, l2_enemyXPos[esi]
        mov l2_shellX[esi], al
        mov al, l2_enemyYPos[esi]
        mov l2_shellY[esi], al
        mov l2_shellDir[esi], 0
        mov l2_shellTimer[esi], 0
        mov l2_shellMoving[esi], 0
        add score, 150
        
    finishStompL2:
        call L2_DrawHUD
        mov velocityY, -2
        dec yPos
        mov isOnGround, 0
        
    nextColEnemyL2:
        inc esi
        jmp checkColLoopL2
        
    noEnemyColL2:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L2_CheckEnemyCollision ENDP

L2_UpdateShells PROC
    push eax
    push ebx
    push esi
    push edx
    mov esi, 0
    
    updateShellLoopL2:
        cmp esi, 3
        jge doneUpdateShellsL2
        
        cmp l2_shellActive[esi], 0
        je skipShellL2
        
        inc l2_shellTimer[esi]
        
        push eax
        movzx eax, l2_shellTimer[esi]
        cmp eax, 150        ; Changed from 270 (BYTE max is 255) - ~5 seconds at 30ms
        pop eax
        jl checkShellMovement
        
        mov l2_shellActive[esi], 0
        mov l2_shellMoving[esi], 0
        mov l2_enemyAlive[esi], 1
        mov al, l2_shellX[esi]
        mov l2_enemyXPos[esi], al
        mov l2_enemyPrevXPos[esi], al
        
        mov dl, l2_shellX[esi]
        mov dh, l2_shellY[esi]
        call Gotoxy
        mov al, ' '
        call WriteChar
        jmp skipShellL2
        
    checkShellMovement:
        cmp l2_shellMoving[esi], 0
        je skipShellL2
        
        mov al, l2_shellX[esi]
        mov l2_shellPrevX[esi], al
        
        mov bl, l2_shellDir[esi]
        add al, bl
        
        cmp al, minX
        jle killShellL2
        cmp al, maxX
        jge killShellL2
        
        mov l2_shellX[esi], al
        
        push esi
        call L2_CheckShellHitEnemy
        pop esi
        jmp skipShellL2
        
    killShellL2:
        mov dl, l2_shellX[esi]
        mov dh, l2_shellY[esi]
        call Gotoxy
        mov al, ' '
        call WriteChar
        mov l2_shellActive[esi], 0
        mov l2_shellMoving[esi], 0
        
    skipShellL2:
        inc esi
        jmp updateShellLoopL2
        
    doneUpdateShellsL2:
    pop edx
    pop esi
    pop ebx
    pop eax
    ret
L2_UpdateShells ENDP

L2_DrawEnemies PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    cmp l2_secretRoomActive, 1
    je doneDrawEnemiesL2
    
    mov esi, 0
    drawEnemyLoopL2:
        cmp esi, 3
        jge doneDrawEnemiesL2
        
        cmp l2_shellActive[esi], 1
        jne checkAliveDraw
        
        mov dl, l2_shellX[esi]
        mov dh, l2_shellY[esi]
        call Gotoxy
        mov eax, lightGreen + (black * 16)
        call SetTextColor
        
        cmp l2_shellMoving[esi], 0
        je drawStunnedShell
        
        mov al, 219
        call WriteChar
        jmp skipDrawEnemyL2
        
    drawStunnedShell:
        mov al, 254
        call WriteChar
        jmp skipDrawEnemyL2

    checkAliveDraw:
        cmp l2_enemyAlive[esi], 0
        je skipDrawEnemyL2
        
        movzx eax, l2_enemyScreen[esi]
        movzx ecx, l2_currentScreen
        cmp al, cl
        jne skipDrawEnemyL2
        
        mov dl, l2_enemyXPos[esi]
        mov dh, l2_enemyYPos[esi]
        call Gotoxy
        
        cmp l2_enemyType[esi], 1
        je drawGoombaL2
        
        mov eax, lightGreen + (black * 16)
        call SetTextColor
        mov al, 178
        call WriteChar
        jmp skipDrawEnemyL2
        
    drawGoombaL2:
        mov eax, lightRed + (black * 16)
        call SetTextColor
        mov al, 219
        call WriteChar
        
    skipDrawEnemyL2:
        inc esi
        jmp drawEnemyLoopL2
        
    doneDrawEnemiesL2:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_DrawEnemies ENDP

L2_EraseEnemies PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    mov eax, black + (black * 16)
    call SetTextColor
    mov esi, 0
    
    eraseEnemyLoopL2:
        cmp esi, 3
        jge doneEraseEnemiesL2
        
        ; Check screen first (applies to both alive and dead enemies)
        movzx eax, l2_enemyScreen[esi]
        movzx ecx, l2_currentScreen
        cmp al, cl
        jne eraseShellCheckL2
        
        ; Always erase at previous position to fix ghosting
        mov dl, l2_enemyPrevXPos[esi]
        mov dh, l2_enemyYPos[esi]
        call Gotoxy
        mov al, ' '
        call WriteChar
        
    eraseShellCheckL2:
        cmp l2_shellActive[esi], 0
        je skipEraseEnemyL2
        
        cmp l2_shellMoving[esi], 0
        je skipEraseEnemyL2
        
        mov dl, l2_shellPrevX[esi]
        mov dh, l2_shellY[esi]
        call Gotoxy
        mov al, ' '
        call WriteChar
        
    skipEraseEnemyL2:
        inc esi
        jmp eraseEnemyLoopL2
        
    doneEraseEnemiesL2:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_EraseEnemies ENDP

L2_KickShell PROC
    push eax
    push ebx
    push edx
    push esi
    
    movzx edx, xPos
    movzx ebx, yPos
    mov esi, 0
    
    checkShellKickLoop:
        cmp esi, 3
        jge noShellKick
        
        cmp l2_enemyType[esi], 2
        jne nextShellKick
        
        cmp l2_shellActive[esi], 0
        je nextShellKick
        
        movzx eax, l2_shellX[esi]
        mov cl, al
        sub cl, 2
        cmp dl, cl
        jl nextShellKick
        add cl, 4
        cmp dl, cl
        jg nextShellKick
        
        movzx eax, l2_shellY[esi]
        cmp eax, ebx
        jne nextShellKick
        
        cmp l2_shellMoving[esi], 1
        je stopShell
        
        mov al, marioFacing
        mov l2_shellDir[esi], al
        mov l2_shellMoving[esi], 1
        mov al, l2_shellX[esi]
        mov l2_shellPrevX[esi], al
        call PlayKickSound
        jmp noShellKick
        
    stopShell:
        mov l2_shellMoving[esi], 0
        mov l2_shellDir[esi], 0
        jmp noShellKick
        
    nextShellKick:
        inc esi
        jmp checkShellKickLoop
        
    noShellKick:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L2_KickShell ENDP

L2_CheckShellHitEnemy PROC
    push eax
    push ebx
    push ecx
    push edx
    push edi
    push esi
    
    cmp l2_shellMoving[esi], 0
    je noShellHit
    
    movzx edx, l2_shellX[esi]
    movzx eax, l2_shellY[esi]
    movzx ebx, l2_enemyScreen[esi]
    
    mov edi, 0
    checkHitLoop:
        cmp edi, 3
        jge noShellHit
        
        cmp edi, esi
        je nextHitCheck
        
        cmp l2_enemyAlive[edi], 0
        je nextHitCheck
        
        movzx ecx, l2_enemyScreen[edi]
        cmp ebx, ecx
        jne nextHitCheck
        
        movzx ecx, l2_enemyXPos[edi]
        push eax
        mov al, cl
        sub al, dl
        cmp al, 0
        jge absHitX
        neg al
    absHitX:
        cmp al, 2
        pop eax
        jg nextHitCheck
        
        movzx ecx, l2_enemyYPos[edi]
        cmp eax, ecx
        jne nextHitCheck
        
        mov l2_enemyAlive[edi], 0
        add score, 200
        inc enemiesDefeated
        
        cmp l2_enemyType[edi], 2
        jne eraseHitEnemy
        mov l2_shellActive[edi], 0
        
    eraseHitEnemy:
        push edx
        push eax
        mov dl, l2_enemyXPos[edi]
        mov dh, l2_enemyYPos[edi]
        call Gotoxy
        mov al, ' '
        call WriteChar
        pop eax
        pop edx
        
    nextHitCheck:
        inc edi
        jmp checkHitLoop
        
    noShellHit:
    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_CheckShellHitEnemy ENDP

L2_CheckMovingShellCollision PROC
    push eax
    push ebx
    push edx
    push esi
    
    movzx edx, xPos
    movzx ebx, yPos
    
    mov esi, 0
    checkMovingShellLoop:
        cmp esi, 3
        jge noMovingShellCol
        
        cmp l2_shellActive[esi], 0
        je nextMovingShell
        
        cmp l2_shellMoving[esi], 0
        je nextMovingShell
        
        movzx eax, l2_enemyScreen[esi]
        cmp al, l2_currentScreen
        jne nextMovingShell
        
        movzx eax, l2_shellX[esi]
        push ebx
        mov bl, al
        sub bl, dl
        cmp bl, 0
        jge absShellX
        neg bl
    absShellX:
        cmp bl, 2
        pop ebx
        jg nextMovingShell
        
        movzx eax, l2_shellY[esi]
        cmp eax, ebx
        jne nextMovingShell
        
        cmp invincibleTimer, 0
        jg nextMovingShell
        
        dec lives
        call L2_DrawHUD
        mov invincibleTimer, 60
        jmp noMovingShellCol
        
    nextMovingShell:
        inc esi
        jmp checkMovingShellLoop
        
    noMovingShellCol:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L2_CheckMovingShellCollision ENDP

; ============================================================================
; PLAY KICK SOUND (New Procedure - Placeholder)
; ============================================================================
PlayKickSound PROC
    ; Implement sound effect here if desired
    ; For now, just a placeholder
    ret
PlayKickSound ENDP

L2_HandleInput PROC
    push eax
    push ebx
    push ecx
    
    call ReadKey
    jz noInputL2
    
    cmp al, 'k'
    je doKickL2
    cmp al, 'K'
    je doKickL2
    
    cmp al, 0
    je checkArrowKeysL2
    
    push eax
    or al, 20h
    mov esi, cheatIndex
    lea ebx, cheatStrMatch
    mov cl, [ebx + esi]
    cmp al, cl
    jne resetCheatIndexL2
    inc cheatIndex
    cmp cheatIndex, 5
    jne continueInputL2
    mov cheatActive, 1
    mov cheatIndex, 0
    mov al, 5
    mov fireballAmmo, al
    mov blueballAmmo, al
    jmp continueInputL2
    
    resetCheatIndexL2:
    cmp al, 'c'
    je setIndexOneL2
    mov cheatIndex, 0
    jmp continueInputL2
    
    setIndexOneL2:
    mov cheatIndex, 1
    
    continueInputL2:
    pop eax
    
    cmp al, 'p'
    je triggerPauseL2
    cmp al, 'P'
    je triggerPauseL2
    
    ; Check if player can fire red projectiles (from shop or cheat)
    cmp fireballAmmo, 0
    jg canFireRedL2
    cmp cheatActive, 1
    jne standardControlsL2
    canFireRedL2:
    cmp al, 'r'
    je attemptFireShotL2
    cmp al, 'R'
    je attemptFireShotL2
    ; Blue shots only available with cheat active
    cmp cheatActive, 1
    jne standardControlsL2
    cmp al, 'b'
    je attemptBlueShotL2
    cmp al, 'B'
    je attemptBlueShotL2
    
    standardControlsL2:
    cmp al, 'a'
    je moveLeftL2
    cmp al, 'A'
    je moveLeftL2
    cmp al, 'd'
    je moveRightL2
    cmp al, 'D'
    je moveRightL2
    cmp al, 'w'
    je tryJumpL2
    cmp al, 'W'
    je tryJumpL2
    cmp al, 'x'
    je exitToMenuL2
    cmp al, 'X'
    je exitToMenuL2
    cmp al, 27
    je exitToMenuL2
    jmp noInputL2
    
    doKickL2:
    call L2_KickShell
    jmp noInputL2

    checkArrowKeysL2:
    cmp ah, 4Bh
    je moveLeftL2
    cmp ah, 4Dh
    je moveRightL2
    cmp ah, 48h
    je tryJumpL2
    jmp noInputL2
    
    triggerPauseL2:
    call PauseMenu
    call Clrscr
    call L2_DrawHUD
    call L2_DrawCurrentScreen
    call L2_DrawCoins
    call L2_DrawPowerUp
    call L2_DrawFlag
    call L2_DrawEnemies
    call DrawMario
    jmp noInputL2
    
    attemptFireShotL2:
    cmp fireballAmmo, 0
    jle standardControlsL2
    dec fireballAmmo
    mov cl, 1
    call SpawnProjectile
    jmp noInputL2
    
    attemptBlueShotL2:
    cmp blueballAmmo, 0
    jle standardControlsL2
    dec blueballAmmo
    mov cl, 2
    call SpawnProjectile
    jmp noInputL2
    
    moveLeftL2:
    mov marioFacing, -1
    cmp l2_moveSpeed, 0
    jl continueLeftGlide
    mov l2_moveSpeed, 0
    
    continueLeftGlide:
    mov al, l2_moveSpeed
    dec al
    mov bl, l2_maxMoveSpeed
    neg bl
    cmp al, bl
    jl capLeftSpeed
    mov l2_moveSpeed, al
    jmp applyLeftMove
    
    capLeftSpeed:
    mov l2_moveSpeed, bl
    
    applyLeftMove:
    movsx ecx, l2_moveSpeed
    neg ecx
    mov esi, 0
    
    leftMoveLoop:
        cmp esi, ecx
        jge noInputL2
        mov al, xPos
        cmp al, minX
        jle noInputL2
        dec xPos
        inc esi
        jmp leftMoveLoop
    
    moveRightL2:
    mov marioFacing, 1
    cmp l2_moveSpeed, 0
    jg continueRightGlide
    mov l2_moveSpeed, 0
    
    continueRightGlide:
    mov al, l2_moveSpeed
    inc al
    mov bl, l2_maxMoveSpeed
    cmp al, bl
    jg capRightSpeed
    mov l2_moveSpeed, al
    jmp applyRightMove
    
    capRightSpeed:
    mov l2_moveSpeed, bl
    
    applyRightMove:
    movzx ecx, l2_moveSpeed
    mov esi, 0
    
    rightMoveLoop:
        cmp esi, ecx
        jge noInputL2
        mov al, xPos
        cmp al, maxX
        jge noInputL2
        inc xPos
        inc esi
        jmp rightMoveLoop
    
    tryJumpL2:
    cmp isOnGround, 1
    je doNormalJumpL2
    cmp doubleJumpAvailable, 1
    je doDoubleJumpL2
    jmp noInputL2
    
    doNormalJumpL2:
    mov doubleJumpAvailable, 1
    jmp performJumpL2
    
    doDoubleJumpL2:
    mov doubleJumpAvailable, 0
    
    performJumpL2:
    movzx eax, yPos
    cmp al, 23
    je jumpFromGroundL2
    jmp jumpFromPlatformL2
    
    jumpFromGroundL2:
    cmp hasSpringMushroom, 1
    je springJumpGroundL2
    movsx eax, normalJumpPower
    mov velocityY, al
    jmp finishJumpL2
    
    springJumpGroundL2:
    movsx eax, enhancedJumpPower
    mov velocityY, al
    jmp finishJumpL2
    
    jumpFromPlatformL2:
    cmp hasSpringMushroom, 1
    je springJumpPlatformL2
    mov al, -3
    mov velocityY, al
    jmp finishJumpL2
    
    springJumpPlatformL2:
    mov al, -5
    mov velocityY, al
    
    finishJumpL2:
    mov isOnGround, 0
    mov isJumping, 1
    call PlayJumpSound
    jmp noInputL2
    
    exitToMenuL2:
    mov gameAction, 2
    pop ecx
    pop ebx
    pop eax
    ret
    
    noInputL2:
    pop ecx
    pop ebx
    pop eax
    ret
L2_HandleInput ENDP

L2_ApplyDeceleration PROC
    push eax
    
    cmp l2_moveSpeed, 0
    je noDecel
    jl decelLeft
    
    decelRight:
    dec l2_moveSpeed
    jmp noDecel
    
    decelLeft:
    inc l2_moveSpeed
    
    noDecel:
    pop eax
    ret
L2_ApplyDeceleration ENDP


L2_DrawFlag PROC
    push eax
    push edx
    push ecx
    cmp l2_secretRoomActive, 1
    je skipFlagDrawL2
    cmp l2_currentScreen, 2
    jne skipFlagDrawL2
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, l2_flagX
    mov dh, l2_flagY
    call Gotoxy
    mov edx, OFFSET flagTop
    call WriteString
    mov ecx, 4
    mov dh, l2_flagY
    inc dh
drawPoleLoopL2:
    push dx
    mov dl, l2_flagX
    call Gotoxy
    mov edx, OFFSET flagPole
    call WriteString
    pop dx
    inc dh
    loop drawPoleLoopL2
skipFlagDrawL2:
    pop ecx
    pop edx
    pop eax
    ret
L2_DrawFlag ENDP

L2_CheckFlagCollision PROC
    push eax
    cmp l2_secretRoomActive, 1
    je noFlagCollisionL2
    cmp l2_currentScreen, 2
    jne noFlagCollisionL2
    movzx eax, xPos
    cmp al, l2_flagX
    jl noFlagCollisionL2
    movzx eax, yPos
    cmp al, l2_flagY
    jl noFlagCollisionL2
    mov levelComplete, 1
noFlagCollisionL2:
    pop eax
    ret
L2_CheckFlagCollision ENDP

L2_UpdateFloatingPlatform PROC
    push eax
    push ebx
    push ecx
    push edx
    cmp l2_currentScreen, 1
    jne doneFloatUpdate
    cmp l2_secretRoomActive, 1
    je doneFloatUpdate
    inc l2_floatTimer
    cmp l2_floatTimer, 4
    jl doneFloatUpdate
    mov l2_floatTimer, 0
    mov eax, black + (black * 16)
    call SetTextColor
    movzx ecx, l2_floatPlatLen
    mov dl, l2_floatPlatX
    mov dh, l2_floatPlatY
    call Gotoxy
    eraseFloatLoop:
        mov al, ' '
        call WriteChar
        loop eraseFloatLoop
    mov al, l2_floatPlatY
    add al, l2_floatDir
    mov l2_floatPlatY, al
    mov bl, l2_floatMinY
    cmp al, bl
    jle reverseDown
    mov bl, l2_floatMaxY
    cmp al, bl
    jge reverseUp
    jmp redrawFloat
    reverseDown:
        mov l2_floatDir, 1
        jmp redrawFloat
    reverseUp:
        mov l2_floatDir, -1
    redrawFloat:
        mov eax, cyan + (black * 16)
        call SetTextColor
        movzx ecx, l2_floatPlatLen
        mov dl, l2_floatPlatX
        mov dh, l2_floatPlatY
        call Gotoxy
        drawFloatLoop:
            mov al, 196
            call WriteChar
            loop drawFloatLoop
    doneFloatUpdate:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_UpdateFloatingPlatform ENDP

L2_UpdateMario PROC
    push eax
    push ebx
    mov al, yPos
    movsx ebx, velocityY
    add al, bl
    cmp al, minY
    jge topBoundaryOKL2
    mov al, minY
    mov velocityY, 0
    topBoundaryOKL2:
    mov yPos, al
    movsx eax, velocityY
    cmp eax, 0
    jle checkGroundOnlyL2
    cmp l2_secretRoomActive, 1
    je checkSecretFloor
    cmp l2_currentScreen, 1
    je checkScreen1Floor
    call L2_CheckScreen2FloatColl
    cmp al, 1
    je doneUpdateL2
    jmp checkGroundOnlyL2
    checkScreen1Floor:
    call L2_CheckStairsColl
    cmp al, 1
    je doneUpdateL2
    call L2_CheckFloatColl
    cmp al, 1
    je doneUpdateL2
    jmp checkGroundOnlyL2
    checkSecretFloor:
    call L2_CheckSecretPlatsColl
    cmp al, 1
    je doneUpdateL2
    checkGroundOnlyL2:
    mov al, yPos
    cmp al, 23
    jl inAirL2
    mov yPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    mov doubleJumpAvailable, 1
    jmp doneUpdateL2
    inAirL2:
    mov isOnGround, 0
    doneUpdateL2:
    pop ebx
    pop eax
    ret
L2_UpdateMario ENDP

L2_CheckSpikeCollision PROC
    push eax
    push ebx
    push esi
    cmp l2_currentScreen, 1
    jne noSpikes
    movzx eax, xPos
    movzx ebx, yPos
    cmp bl, 23
    jne noSpikes
    mov esi, 0
    checkSpikeLoop:
        cmp esi, 3
        jge noSpikes
        
        movzx ebx, l2_spikeX[esi]
        inc ebx                  ; Start Check at X + 1
        cmp eax, ebx
        jl nextSpike
        
        movzx ebx, l2_spikeX[esi]
        add bl, l2_spikeLen[esi]
        dec bl                   ; End Check at X + Len - 1
        cmp eax, ebx
        jge nextSpike
        ; --------------------------------
        
        cmp invincibleTimer, 0
        jg nextSpike
        dec lives
        call L2_DrawHUD
        mov invincibleTimer, 60
        mov velocityY, -2
        mov isOnGround, 0
        mov isJumping, 1
        jmp noSpikes
        nextSpike:
        inc esi
        jmp checkSpikeLoop
    noSpikes:
    pop esi
    pop ebx
    pop eax
    ret
L2_CheckSpikeCollision ENDP

L2_CheckStairsColl PROC
    push ebx
    push esi
    mov esi, 0
    checkStairLoop:
        cmp esi, 3
        jge noStairColl
        mov al, xPos
        mov bl, l2_stairX[esi]
        cmp al, bl
        jl nextStair
        add bl, l2_stairLen[esi]
        cmp al, bl
        jge nextStair
        mov al, yPos
        mov bl, l2_stairY[esi]
        dec bl
        cmp al, bl
        jl nextStair
        mov al, l2_stairY[esi]
        dec al
        mov yPos, al
        mov velocityY, 0
        mov isOnGround, 1
        mov doubleJumpAvailable, 1
        mov al, 1
        jmp stairCollDone
        nextStair:
        inc esi
        jmp checkStairLoop
    noStairColl:
        mov al, 0
    stairCollDone:
    pop esi
    pop ebx
    ret
L2_CheckStairsColl ENDP

L2_CheckFloatColl PROC
    push ebx
    mov al, xPos
    mov bl, l2_floatPlatX
    cmp al, bl
    jl noFloatColl
    add bl, l2_floatPlatLen
    cmp al, bl
    jge noFloatColl
    mov al, yPos
    mov bl, l2_floatPlatY
    dec bl
    cmp al, bl
    jl noFloatColl
    mov al, l2_floatPlatY
    dec al
    mov yPos, al
    mov velocityY, 0
    mov isOnGround, 1
    mov doubleJumpAvailable, 1
    mov al, 1
    jmp floatCollDone
    noFloatColl:
        mov al, 0
    floatCollDone:
    pop ebx
    ret
L2_CheckFloatColl ENDP

L2_CheckScreen2FloatColl PROC
    push ebx
    mov al, xPos
    mov bl, l2_screen2FloatX
    cmp al, bl
    jl noScreen2Coll
    add bl, l2_screen2FloatLen
    cmp al, bl
    jge noScreen2Coll
    mov al, yPos
    mov bl, l2_screen2FloatY
    dec bl
    cmp al, bl
    jl noScreen2Coll
    mov al, l2_screen2FloatY
    dec al
    mov yPos, al
    mov velocityY, 0
    mov isOnGround, 1
    mov doubleJumpAvailable, 1
    mov al, 1
    jmp screen2CollDone
    noScreen2Coll:
        mov al, 0
    screen2CollDone:
    pop ebx
    ret
L2_CheckScreen2FloatColl ENDP

L2_CheckSecretPlatsColl PROC
    push ebx
    push esi
    mov esi, 0
    checkSecretLoop:
        cmp esi, 6
        jge noSecretColl
        mov al, xPos
        mov bl, l2_secretPlatX[esi]
        cmp al, bl
        jl nextSecret
        add bl, l2_secretPlatLen[esi]
        cmp al, bl
        jge nextSecret
        mov al, yPos
        mov bl, l2_secretPlatY[esi]
        dec bl
        cmp al, bl
        jl nextSecret
        mov al, l2_secretPlatY[esi]
        dec al
        mov yPos, al
        mov velocityY, 0
        mov isOnGround, 1
        mov doubleJumpAvailable, 1
        mov al, 1
        jmp secretCollDone
        nextSecret:
        inc esi
        jmp checkSecretLoop
    noSecretColl:
        mov al, 0
    secretCollDone:
    pop esi
    pop ebx
    ret
L2_CheckSecretPlatsColl ENDP

L2_DrawHUD PROC
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
    jg showFireAmmoL2
    cmp cheatActive, 1
    jne skipCheatHudL2
    showFireAmmoL2:
    mov dl, 30
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strFireAmmo
    call WriteString
    movzx eax, fireballAmmo
    call WriteDec
    ; Show blue ammo only if cheat is active
    cmp cheatActive, 1
    jne skipCheatHudL2
    mov edx, OFFSET strBlueAmmo
    call WriteString
    movzx eax, blueballAmmo
    call WriteDec
    jmp drawTimerL2
    skipCheatHudL2:
    mov dl, 35
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET l2_strLevel
    call WriteString
    drawTimerL2:
    mov dl, 60
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strTime
    call WriteString
    mov eax, gameTimer
    call WriteDec
    mov al, ' '
    call WriteChar
    pop edx
    pop eax
    ret
L2_DrawHUD ENDP

L2_DrawCurrentScreen PROC
    push eax
    cmp l2_secretRoomActive, 1
    je drawSecretRoom
    cmp l2_currentScreen, 1
    je drawScreen1
    call L2_DrawScreen2
    jmp doneDrawScreen
    drawScreen1:
    call L2_DrawScreen1
    jmp doneDrawScreen
    drawSecretRoom:
    call L2_DrawSecretRoom
    doneDrawScreen:
    pop eax
    ret
L2_DrawCurrentScreen ENDP

L2_DrawScreen1 PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov ecx, 80
    drawGround1:
        mov al, 178
        call WriteChar
        loop drawGround1
    call L2_DrawStairPlatforms
    call L2_DrawFloatingPlatform
    call L2_DrawSpikes
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_DrawScreen1 ENDP

L2_DrawStairPlatforms PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, brown + (black * 16)
    call SetTextColor
    mov esi, 0
    drawStairLoop:
        cmp esi, 3
        jge doneStairs
        movzx ecx, l2_stairLen[esi]
        mov dl, l2_stairX[esi]
        mov dh, l2_stairY[esi]
        call Gotoxy
        drawStairSingle:
            mov al, 220
            call WriteChar
            loop drawStairSingle
        inc esi
        jmp drawStairLoop
    doneStairs:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_DrawStairPlatforms ENDP

L2_DrawFloatingPlatform PROC
    push eax
    push ebx
    push ecx
    push edx
    mov eax, cyan + (black * 16)
    call SetTextColor
    movzx ecx, l2_floatPlatLen
    mov dl, l2_floatPlatX
    mov dh, l2_floatPlatY
    call Gotoxy
    drawFloatSingle:
        mov al, 196
        call WriteChar
        loop drawFloatSingle
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_DrawFloatingPlatform ENDP

L2_DrawSpikes PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov esi, 0
    drawSpikeLoop:
        cmp esi, 3
        jge doneSpikes
        movzx ecx, l2_spikeLen[esi]
        mov dl, l2_spikeX[esi]
        mov dh, 24
        call Gotoxy
        drawSpikeSingle:
            mov al, 94
            call WriteChar
            loop drawSpikeSingle
        inc esi
        jmp drawSpikeLoop
    doneSpikes:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_DrawSpikes ENDP

L2_DrawScreen2 PROC
    push eax
    push ebx
    push ecx
    push edx
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    movzx ecx, l2_screen2FloatLen
    mov dl, l2_screen2FloatX
    mov dh, l2_screen2FloatY
    call Gotoxy
    drawScreen2Float:
        mov al, 205
        call WriteChar
        loop drawScreen2Float
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov ecx, 80
    drawGround2:
        mov al, 178
        call WriteChar
        loop drawGround2
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_DrawScreen2 ENDP

L2_DrawPowerUp PROC
    push eax
    push edx
    cmp l2_secretRoomActive, 1
    je checkExitPower
    cmp l2_powerUpActive, 0
    je noPowerDraw
    cmp l2_currentScreen, 2
    jne noPowerDraw
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, l2_powerUpX
    mov dh, l2_powerUpY
    call Gotoxy
    mov al, 236
    call WriteChar
    jmp noPowerDraw
    checkExitPower:
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, l2_exitPowerX
    mov dh, l2_exitPowerY
    call Gotoxy
    mov al, 236
    call WriteChar
    noPowerDraw:
    pop edx
    pop eax
    ret
L2_DrawPowerUp ENDP

L2_DrawSecretRoom PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov ecx, 80
    drawSecretGround:
        mov al, 178
        call WriteChar
        loop drawSecretGround
    mov eax, magenta + (black * 16)
    call SetTextColor
    mov esi, 0
    drawSecretPlatLoop:
        cmp esi, 6
        jge doneSecretPlat
        movzx ecx, l2_secretPlatLen[esi]
        mov dl, l2_secretPlatX[esi]
        mov dh, l2_secretPlatY[esi]
        call Gotoxy
        drawSecretSingle:
            mov al, 205
            call WriteChar
            loop drawSecretSingle
        inc esi
        jmp drawSecretPlatLoop
    doneSecretPlat:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L2_DrawSecretRoom ENDP

L2_DrawCoins PROC
    push eax
    push ebx
    push edx
    push esi
    mov eax, yellow + (black * 16)
    call SetTextColor
    cmp l2_secretRoomActive, 1
    je drawSecretCoins
    mov esi, 0
    drawMainCoinLoop:
        cmp esi, 10
        jge doneDrawCoins
        cmp l2_mainCoinCollected[esi], 1
        je skipMainCoin
        movzx eax, l2_mainCoinScreen[esi]
        cmp al, l2_currentScreen
        jne skipMainCoin
        mov dl, l2_mainCoinX[esi]
        mov dh, l2_mainCoinY[esi]
        call Gotoxy
        mov al, 'O'
        call WriteChar
        skipMainCoin:
        inc esi
        jmp drawMainCoinLoop
    drawSecretCoins:
    mov esi, 0
    drawSecretCoinLoop:
        cmp esi, 12
        jge doneDrawCoins
        cmp l2_secretCoinCollected[esi], 1
        je skipSecretCoin
        mov dl, l2_secretCoinX[esi]
        mov dh, l2_secretCoinY[esi]
        call Gotoxy
        mov al, 'O'
        call WriteChar
        skipSecretCoin:
        inc esi
        jmp drawSecretCoinLoop
    doneDrawCoins:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L2_DrawCoins ENDP

L2_CheckScreenTransition PROC
    push eax
    cmp l2_secretRoomActive, 1
    je noTransition
    cmp l2_currentScreen, 2
    je noTransition
    movzx eax, xPos
    cmp al, 75
    jl noTransition
    mov l2_currentScreen, 2
    mov xPos, 5
    mov yPos, 23
    mov velocityY, 0
    mov isOnGround, 0
    mov doubleJumpAvailable, 1
    call Clrscr
    call L2_DrawHUD
    call L2_DrawCurrentScreen
    call L2_DrawEnemies
    call DrawMario
    noTransition:
    pop eax
    ret
L2_CheckScreenTransition ENDP

L2_CheckPowerUpCollection PROC
    push eax
    push ebx
    cmp l2_secretRoomActive, 1
    je checkExitPowerCol
    cmp l2_powerUpActive, 0
    je noPowerCol
    cmp l2_currentScreen, 2
    jne noPowerCol
    movzx eax, xPos
    movzx ebx, l2_powerUpX
    cmp eax, ebx
    jne noPowerCol
    movzx eax, yPos
    movzx ebx, l2_powerUpY
    cmp eax, ebx
    jne noPowerCol
    mov l2_powerUpActive, 0
    mov al, xPos
    mov l2_returnX, al
    mov al, yPos
    mov l2_returnY, al
    mov l2_secretRoomActive, 1
    mov xPos, 10
    mov yPos, 23
    mov velocityY, 0
    mov isOnGround, 0
    mov doubleJumpAvailable, 1
    call Clrscr
    call L2_DrawHUD
    call L2_DrawCurrentScreen
    call DrawMario
    jmp noPowerCol
    checkExitPowerCol:
    movzx eax, xPos
    movzx ebx, l2_exitPowerX
    cmp eax, ebx
    jne noPowerCol
    movzx eax, yPos
    movzx ebx, l2_exitPowerY
    cmp eax, ebx
    jne noPowerCol
    mov l2_secretRoomActive, 0
    mov al, l2_returnX
    mov xPos, al
    mov al, l2_returnY
    mov yPos, al
    mov velocityY, 0
    mov isOnGround, 0
    mov doubleJumpAvailable, 1
    call Clrscr
    call L2_DrawHUD
    call L2_DrawCurrentScreen
    call L2_DrawEnemies
    call DrawMario
    noPowerCol:
    pop ebx
    pop eax
    ret
L2_CheckPowerUpCollection ENDP

L2_CheckCoinCollection PROC
    push eax
    push ebx
    push edx
    push esi
    push edi
    movzx edx, xPos
    movzx eax, yPos
    cmp l2_secretRoomActive, 1
    je checkSecretCoins
    mov esi, 0
    checkMainCoinLoop:
        cmp esi, 10
        jge noCoinCol
        cmp l2_mainCoinCollected[esi], 1
        je skipMainCoin2
        movzx ebx, l2_mainCoinScreen[esi]
        cmp bl, l2_currentScreen
        jne skipMainCoin2
        movzx ebx, l2_mainCoinX[esi]
        cmp edx, ebx
        jne skipMainCoin2
        movzx ebx, l2_mainCoinY[esi]
        mov edi, ebx
        dec edi
        cmp eax, edi
        jl skipMainCoin2
        mov edi, ebx
        inc edi
        cmp eax, edi
        jg skipMainCoin2
        mov l2_mainCoinCollected[esi], 1
        call PlayCoinSound
        push eax
        push edx
        mov eax, coinValue
        add score, eax
        pop edx
        pop eax
        inc coinsCollected
    skipMainCoin2:
        inc esi
        jmp checkMainCoinLoop
    checkSecretCoins:
    mov esi, 0
    checkSecretCoinLoop:
        cmp esi, 12
        jge noCoinCol
        cmp l2_secretCoinCollected[esi], 1
        je skipSecretCoin2
        movzx ebx, l2_secretCoinX[esi]
        mov edi, ebx
        dec edi
        cmp edx, edi
        jl skipSecretCoin2
        mov edi, ebx
        inc edi
        cmp edx, edi
        jg skipSecretCoin2
        movzx ebx, l2_secretCoinY[esi]
        mov edi, ebx
        dec edi
        cmp eax, edi
        jl skipSecretCoin2
        mov edi, ebx
        inc edi
        cmp eax, edi
        jg skipSecretCoin2
        mov l2_secretCoinCollected[esi], 1
        call PlayCoinSound
        push eax
        push edx
        mov eax, coinValue
        add score, eax
        pop edx
        pop eax
        inc coinsCollected
    skipSecretCoin2:
        inc esi
        jmp checkSecretCoinLoop
    noCoinCol:
    pop edi
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L2_CheckCoinCollection ENDP

L2_RedrawStatic PROC
    push eax
    push edx
    push ebx
    push esi
    cmp l2_secretRoomActive, 1
    je redrawSecretStatic
    cmp l2_currentScreen, 1
    je redrawScreen1Static
    mov al, prevYPos
    mov bl, l2_screen2FloatY
    cmp al, bl
    jne checkScreen2Ground
    mov al, prevXPos
    mov bl, l2_screen2FloatX
    cmp al, bl
    jl checkScreen2Ground
    add bl, l2_screen2FloatLen
    cmp al, bl
    jge checkScreen2Ground
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, prevYPos
    call Gotoxy
    mov al, 205
    call WriteChar
    checkScreen2Ground:
    mov al, prevYPos
    cmp al, 24
    jne doneRedraw
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, 24
    call Gotoxy
    mov al, 178
    call WriteChar
    jmp doneRedraw
    redrawScreen1Static:
    mov esi, 0
    redrawStairLoop:
        cmp esi, 3
        jge checkFloatRedraw
        mov al, prevYPos
        mov bl, l2_stairY[esi]
        cmp al, bl
        jne nextStairRedraw
        mov al, prevXPos
        mov bl, l2_stairX[esi]
        cmp al, bl
        jl nextStairRedraw
        add bl, l2_stairLen[esi]
        cmp al, bl
        jge nextStairRedraw
        mov eax, brown + (black * 16)
        call SetTextColor
        mov dl, prevXPos
        mov dh, prevYPos
        call Gotoxy
        mov al, 220
        call WriteChar
        nextStairRedraw:
        inc esi
        jmp redrawStairLoop
    checkFloatRedraw:
    mov al, prevYPos
    mov bl, l2_floatPlatY
    cmp al, bl
    jne checkGroundRedraw
    mov al, prevXPos
    mov bl, l2_floatPlatX
    cmp al, bl
    jl checkGroundRedraw
    add bl, l2_floatPlatLen
    cmp al, bl
    jge checkGroundRedraw
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, prevYPos
    call Gotoxy
    mov al, 196
    call WriteChar
    checkGroundRedraw:
    mov al, prevYPos
    cmp al, 24
    jne doneRedraw
    movzx eax, prevXPos
    mov esi, 0
    checkSpikeRedraw:
        cmp esi, 3
        jge drawGroundRedraw
        movzx ebx, l2_spikeX[esi]
        cmp eax, ebx
        jl nextSpikeRedraw
        add bl, l2_spikeLen[esi]
        cmp eax, ebx
        jge nextSpikeRedraw
        mov eax, lightRed + (black * 16)
        call SetTextColor
        mov dl, prevXPos
        mov dh, 24
        call Gotoxy
        mov al, 94
        call WriteChar
        jmp doneRedraw
        nextSpikeRedraw:
        inc esi
        jmp checkSpikeRedraw
    drawGroundRedraw:
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, 24
    call Gotoxy
    mov al, 178
    call WriteChar
    jmp doneRedraw
    redrawSecretStatic:
    mov esi, 0
    redrawSecretLoop:
        cmp esi, 6
        jge checkSecretGround
        mov al, prevYPos
        mov bl, l2_secretPlatY[esi]
        cmp al, bl
        jne nextSecretRedraw
        mov al, prevXPos
        mov bl, l2_secretPlatX[esi]
        cmp al, bl
        jl nextSecretRedraw
        add bl, l2_secretPlatLen[esi]
        cmp al, bl
        jge nextSecretRedraw
        mov eax, magenta + (black * 16)
        call SetTextColor
        mov dl, prevXPos
        mov dh, prevYPos
        call Gotoxy
        mov al, 205
        call WriteChar
        jmp doneRedraw
        nextSecretRedraw:
        inc esi
        jmp redrawSecretLoop
    checkSecretGround:
    mov al, prevYPos
    cmp al, 24
    jne doneRedraw
    mov eax, gray + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, 24
    call Gotoxy
    mov al, 178
    call WriteChar
    doneRedraw:
    pop esi
    pop ebx
    pop edx
    pop eax
    ret
L2_RedrawStatic ENDP

L2_CheckProjectileEnemyCollision PROC
    pushad
    
    cmp l2_secretRoomActive, 1
    je noProjEnemyCol
    
    mov esi, 0
    
checkProjLoop:
    cmp esi, MAX_PROJ
    jge noProjEnemyCol
    
    ; Only check red fireballs (type 1)
    cmp projType[esi], 1
    jne nextProj
    
    movzx edx, projX[esi]
    movzx ebx, projY[esi]
    
    mov edi, 0
    
checkEnemyHitLoop:
    cmp edi, 3
    jge nextProj
    
    cmp l2_enemyAlive[edi], 0
    je nextEnemyHit
    
    movzx eax, l2_enemyScreen[edi]
    cmp al, l2_currentScreen
    jne nextEnemyHit
    
    ; Check X distance
    movzx eax, l2_enemyXPos[edi]
    push ebx
    mov bl, al
    sub bl, dl
    cmp bl, 0
    jge absProjX
    neg bl
absProjX:
    cmp bl, 2
    pop ebx
    jg nextEnemyHit
    
    ; Check Y distance
    movzx eax, l2_enemyYPos[edi]
    cmp eax, ebx
    jne nextEnemyHit
    
    ; Enemy hit!
    mov l2_enemyAlive[edi], 0
    inc enemiesDefeated
    add score, 100
    
    ; Check if Koopa (type 2) - create shell
    cmp l2_enemyType[edi], 2
    jne eraseFireHitEnemy
    
    ; Create shell
    mov l2_shellActive[edi], 1
    mov al, l2_enemyXPos[edi]
    mov l2_shellX[edi], al
    mov al, l2_enemyYPos[edi]
    mov l2_shellY[edi], al
    mov l2_shellDir[edi], 0
    mov l2_shellTimer[edi], 0
    mov l2_shellMoving[edi], 0
    add score, 50
    
eraseFireHitEnemy:
    ; Erase enemy
    push edx
    mov dl, l2_enemyXPos[edi]
    mov dh, l2_enemyYPos[edi]
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop edx
    
    ; Kill projectile and redraw background
    mov dl, projX[esi]
    mov dh, projY[esi]
    call Gotoxy
    
    call L2_CheckPlatformCollision
    cmp al, 1
    je restorePlatFire
    
    mov al, projY[esi]
    cmp al, 24
    je restoreGroundFire
    
    mov eax, black + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    jmp killFireProj
    
restorePlatFire:
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov al, 196
    call WriteChar
    jmp killFireProj
    
restoreGroundFire:
    mov eax, gray + (black * 16)
    call SetTextColor
    mov al, 178
    call WriteChar
    
killFireProj:
    mov projType[esi], 0
    call L2_DrawHUD
    jmp nextProj
    
nextEnemyHit:
    inc edi
    jmp checkEnemyHitLoop
    
nextProj:
    inc esi
    jmp checkProjLoop
    
noProjEnemyCol:
    popad
    ret
L2_CheckProjectileEnemyCollision ENDP

L2_CheckProjectileCoinCollision PROC
    pushad
    
    mov esi, 0
    
checkBlueProjLoop:
    cmp esi, MAX_PROJ
    jge noBlueProjCol
    
    ; Only check blue projectiles (type 2)
    cmp projType[esi], 2
    jne nextBlueProj
    
    movzx edx, projX[esi]
    movzx ebx, projY[esi]
    
    cmp l2_secretRoomActive, 1
    je checkSecretCoinsBlue
    
    ; Check main coins
    mov edi, 0
checkMainCoinBlue:
    cmp edi, 10
    jge nextBlueProj
    
    cmp l2_mainCoinCollected[edi], 1
    je nextMainCoinBlue
    
    movzx eax, l2_mainCoinScreen[edi]
    cmp al, l2_currentScreen
    jne nextMainCoinBlue
    
    ; Check X distance
    movzx eax, l2_mainCoinX[edi]
    push ebx
    mov bl, al
    sub bl, dl
    cmp bl, 0
    jge absBlueMainX
    neg bl
absBlueMainX:
    cmp bl, 1
    pop ebx
    jg nextMainCoinBlue
    
    ; Check Y distance
    movzx eax, l2_mainCoinY[edi]
    push edx
    mov dl, al
    sub dl, bl
    cmp dl, 0
    jge absBlueMainY
    neg dl
absBlueMainY:
    cmp dl, 1
    pop edx
    jg nextMainCoinBlue
    
    ; Coin collected!
    mov l2_mainCoinCollected[edi], 1
    call PlayCoinSound
    
    push eax
    push edx
    mov eax, coinValue
    add score, eax
    pop edx
    pop eax
    
    inc coinsCollected
    
    ; Kill projectile and redraw
    mov dl, projX[esi]
    mov dh, projY[esi]
    call Gotoxy
    
    mov eax, black + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
    mov projType[esi], 0
    call L2_DrawHUD
    jmp nextBlueProj
    
nextMainCoinBlue:
    inc edi
    jmp checkMainCoinBlue
    
checkSecretCoinsBlue:
    mov edi, 0
checkSecretCoinBlue:
    cmp edi, 12
    jge nextBlueProj
    
    cmp l2_secretCoinCollected[edi], 1
    je nextSecretCoinBlue
    
    ; Check X distance
    movzx eax, l2_secretCoinX[edi]
    push ebx
    mov bl, al
    sub bl, dl
    cmp bl, 0
    jge absBlueSecretX
    neg bl
absBlueSecretX:
    cmp bl, 1
    pop ebx
    jg nextSecretCoinBlue
    
    ; Check Y distance
    movzx eax, l2_secretCoinY[edi]
    push edx
    mov dl, al
    sub dl, bl
    cmp dl, 0
    jge absBlueSecretY
    neg dl
absBlueSecretY:
    cmp dl, 1
    pop edx
    jg nextSecretCoinBlue
    
    ; Coin collected!
    mov l2_secretCoinCollected[edi], 1
    call PlayCoinSound
    
    push eax
    push edx
    mov eax, coinValue
    add score, eax
    pop edx
    pop eax
    
    inc coinsCollected
    
    ; Kill projectile and redraw
    mov dl, projX[esi]
    mov dh, projY[esi]
    call Gotoxy
    
    mov eax, black + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    
    mov projType[esi], 0
    call L2_DrawHUD
    jmp nextBlueProj
    
nextSecretCoinBlue:
    inc edi
    jmp checkSecretCoinBlue
    
nextBlueProj:
    inc esi
    jmp checkBlueProjLoop
    
noBlueProjCol:
    popad
    ret
L2_CheckProjectileCoinCollision ENDP

L2_RedrawProjectilePosition PROC
    push eax
    push ebx
    push edx
    push esi
    
    movzx edx, projX[esi]
    movzx ebx, projY[esi]
    
    mov dl, projX[esi]
    mov dh, projY[esi]
    call Gotoxy
    
    cmp l2_secretRoomActive, 1
    je redrawSecretBg
    
    cmp l2_currentScreen, 1
    je redrawScreen1Bg
    
    movzx eax, projY[esi]
    cmp al, l2_screen2FloatY
    jne checkScreen2Ground
    movzx eax, projX[esi]
    mov bl, l2_screen2FloatX
    cmp al, bl
    jl checkScreen2Ground
    add bl, l2_screen2FloatLen
    cmp al, bl
    jge checkScreen2Ground
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov al, 205
    call WriteChar
    jmp doneProjRedraw
    
    checkScreen2Ground:
    movzx eax, projY[esi]
    cmp al, 24
    jne doneProjRedraw
    mov eax, gray + (black * 16)
    call SetTextColor
    mov al, 178
    call WriteChar
    jmp doneProjRedraw
    
    redrawScreen1Bg:
    push esi
    mov esi, 0
    checkStairRedrawProj:
        cmp esi, 3
        jge checkFloatRedrawProj
        movzx eax, projY[esi]
        mov bl, l2_stairY[esi]
        cmp al, bl
        jne nextStairProj
        movzx eax, projX[esi]
        mov bl, l2_stairX[esi]
        cmp al, bl
        jl nextStairProj
        add bl, l2_stairLen[esi]
        cmp al, bl
        jge nextStairProj
        mov eax, brown + (black * 16)
        call SetTextColor
        mov al, 220
        call WriteChar
        pop esi
        jmp doneProjRedraw
    nextStairProj:
        inc esi
        jmp checkStairRedrawProj
    
    checkFloatRedrawProj:
    pop esi
    movzx eax, projY[esi]
    mov bl, l2_floatPlatY
    cmp al, bl
    jne checkGroundRedrawProj
    movzx eax, projX[esi]
    mov bl, l2_floatPlatX
    cmp al, bl
    jl checkGroundRedrawProj
    add bl, l2_floatPlatLen
    cmp al, bl
    jge checkGroundRedrawProj
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov al, 196
    call WriteChar
    jmp doneProjRedraw
    
    checkGroundRedrawProj:
    movzx eax, projY[esi]
    cmp al, 24
    jne doneProjRedraw
    
    movzx eax, projX[esi]
    push esi
    mov esi, 0
    checkSpikeRedrawProj:
        cmp esi, 3
        jge drawGroundRedrawProj
        movzx ebx, l2_spikeX[esi]
        cmp eax, ebx
        jl nextSpikeProj
        add bl, l2_spikeLen[esi]
        cmp eax, ebx
        jge nextSpikeProj
        mov eax, lightRed + (black * 16)
        call SetTextColor
        mov al, 94
        call WriteChar
        pop esi
        jmp doneProjRedraw
    nextSpikeProj:
        inc esi
        jmp checkSpikeRedrawProj
    
    drawGroundRedrawProj:
    pop esi
    mov eax, gray + (black * 16)
    call SetTextColor
    mov al, 178
    call WriteChar
    jmp doneProjRedraw
    
    redrawSecretBg:
    push esi
    mov esi, 0
    checkSecretPlatRedraw:
        cmp esi, 6
        jge checkSecretGroundRedraw
        movzx eax, projY[esi]
        mov bl, l2_secretPlatY[esi]
        cmp al, bl
        jne nextSecretPlatProj
        movzx eax, projX[esi]
        mov bl, l2_secretPlatX[esi]
        cmp al, bl
        jl nextSecretPlatProj
        add bl, l2_secretPlatLen[esi]
        cmp al, bl
        jge nextSecretPlatProj
        mov eax, magenta + (black * 16)
        call SetTextColor
        mov al, 205
        call WriteChar
        pop esi
        jmp doneProjRedraw
    nextSecretPlatProj:
        inc esi
        jmp checkSecretPlatRedraw
    
    checkSecretGroundRedraw:
    pop esi
    movzx eax, projY[esi]
    cmp al, 24
    jne doneProjRedraw
    mov eax, gray + (black * 16)
    call SetTextColor
    mov al, 178
    call WriteChar
    
    doneProjRedraw:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L2_RedrawProjectilePosition ENDP

L2_UpdateProjectiles PROC
    pushad
    
    mov esi, 0
    
updateProjLoop:
    cmp esi, MAX_PROJ
    jge doneUpdateProj
    
    cmp projType[esi], 0
    je nextProj
    
    ; Update position
    mov al, projX[esi]
    mov bl, byte ptr projDir[esi]
    add al, bl
    
    ; Check boundaries
    cmp al, minX
    jle killProj
    cmp al, maxX
    jge killProj
    
    mov projX[esi], al
    
    ; Increment distance
    inc projDist[esi]
    cmp projDist[esi], 40
    jg killProj
    
    ; Check platform collision
    call L2_CheckPlatformCollision
    cmp al, 1
    je killProj
    
    ; Check spike collision
    call L2_CheckSpikeCollisionProj
    cmp al, 1
    je killProj
    
    ; Check ground collision
    mov al, projY[esi]
    cmp al, 24
    je killProj
    
    jmp nextProj
    
killProj:
    ; Erase projectile at current position
    mov dl, projX[esi]
    mov dh, projY[esi]
    call Gotoxy
    
    ; Redraw background
    call L2_CheckPlatformCollision
    cmp al, 1
    je restorePlatChar
    
    call L2_CheckSpikeCollisionProj
    cmp al, 1
    je restoreSpikeChar
    
    ; Default: black or ground
    mov al, projY[esi]
    cmp al, 24
    je restoreGroundChar
    
    ; Empty space
    mov eax, black + (black * 16)
    call SetTextColor
    mov al, ' '
    call WriteChar
    jmp setDead
    
restorePlatChar:
    cmp l2_currentScreen, 1
    je checkStairOrFloat
    
    ; Screen 2 float platform
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov al, 205
    call WriteChar
    jmp setDead
    
checkStairOrFloat:
    ; Check if stair
    push esi
    mov esi, 0
testStair:
    cmp esi, 3
    jge testFloat
    
    mov al, projY[esi]
    mov bl, l2_stairY[esi]
    cmp al, bl
    jne nextTestStair
    
    mov al, projX[esi]
    mov bl, l2_stairX[esi]
    cmp al, bl
    jl nextTestStair
    add bl, l2_stairLen[esi]
    cmp al, bl
    jg nextTestStair
    
    ; It's a stair
    pop esi
    mov eax, brown + (black * 16)
    call SetTextColor
    mov al, 220
    call WriteChar
    jmp setDead
    
nextTestStair:
    inc esi
    jmp testStair
    
testFloat:
    pop esi
    ; It's floating platform
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov al, 196
    call WriteChar
    jmp setDead
    
restoreSpikeChar:
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov al, '^'
    call WriteChar
    jmp setDead
    
restoreGroundChar:
    mov eax, gray + (black * 16)
    call SetTextColor
    mov al, 178
    call WriteChar
    
setDead:
    mov projType[esi], 0
    
nextProj:
    inc esi
    jmp updateProjLoop
    
doneUpdateProj:
    popad
    ret
L2_UpdateProjectiles ENDP

L2_CheckPlatformCollision PROC
    push ebx
    
    ; Check stairs
    push esi
    mov esi, 0
checkStairCollProj:
    cmp esi, 3
    jge checkFloatPlat
    
    mov al, projY[esi]
    mov bl, l2_stairY[esi]
    cmp al, bl
    jne nextStairColl
    
    mov al, projX[esi]
    mov bl, l2_stairX[esi]
    cmp al, bl
    jl nextStairColl
    add bl, l2_stairLen[esi]
    cmp al, bl
    jg nextStairColl
    
    pop esi
    mov al, 1
    jmp donePlatColl
    
nextStairColl:
    inc esi
    jmp checkStairCollProj
    
checkFloatPlat:
    pop esi
    
    cmp l2_currentScreen, 1
    jne checkScreen2Float
    
    mov al, projY[esi]
    mov bl, l2_floatPlatY
    cmp al, bl
    jne checkScreen2Float
    
    mov al, projX[esi]
    mov bl, l2_floatPlatX
    cmp al, bl
    jl checkScreen2Float
    add bl, l2_floatPlatLen
    cmp al, bl
    jg checkScreen2Float
    
    mov al, 1
    jmp donePlatColl
    
checkScreen2Float:
    cmp l2_currentScreen, 2
    jne checkSecretPlats
    
    mov al, projY[esi]
    mov bl, l2_screen2FloatY
    cmp al, bl
    jne checkSecretPlats
    
    mov al, projX[esi]
    mov bl, l2_screen2FloatX
    cmp al, bl
    jl checkSecretPlats
    add bl, l2_screen2FloatLen
    cmp al, bl
    jg checkSecretPlats
    
    mov al, 1
    jmp donePlatColl
    
checkSecretPlats:
    cmp l2_secretRoomActive, 1
    jne noPlat
    
    push esi
    mov esi, 0
checkSecretPlatLoop:
    cmp esi, 6
    jge noSecretPlat
    
    mov al, projY[esi]
    mov bl, l2_secretPlatY[esi]
    cmp al, bl
    jne nextSecretPlatColl
    
    mov al, projX[esi]
    mov bl, l2_secretPlatX[esi]
    cmp al, bl
    jl nextSecretPlatColl
    add bl, l2_secretPlatLen[esi]
    cmp al, bl
    jg nextSecretPlatColl
    
    pop esi
    mov al, 1
    jmp donePlatColl
    
nextSecretPlatColl:
    inc esi
    jmp checkSecretPlatLoop
    
noSecretPlat:
    pop esi
    
noPlat:
    mov al, 0
    
donePlatColl:
    pop ebx
    ret
L2_CheckPlatformCollision ENDP

L2_CheckSpikeCollisionProj PROC
    push ebx
    
    cmp l2_currentScreen, 1
    jne noSpikeProj
    
    mov al, projY[esi]
    cmp al, 24
    jne noSpikeProj
    
    push esi
    mov esi, 0
checkSpikeProjLoop:
    cmp esi, 3
    jge noSpikeFound
    
    movzx ebx, l2_spikeX[esi]
    movzx eax, projX[esi]
    cmp eax, ebx
    jl nextSpikeCheck
    
    add bl, l2_spikeLen[esi]
    cmp eax, ebx
    jge nextSpikeCheck
    
    pop esi
    mov al, 1
    jmp doneSpikeProj
    
nextSpikeCheck:
    inc esi
    jmp checkSpikeProjLoop
    
noSpikeFound:
    pop esi
    
noSpikeProj:
    mov al, 0
    
doneSpikeProj:
    pop ebx
    ret
L2_CheckSpikeCollisionProj ENDP
