.data
    l3_strLevel BYTE " LEVEL: 3-1 (SKY PLATFORMS)",0
    l3_winMsg   BYTE "  SKY MASTERED! LEVEL COMPLETE!  ",0
    l3_totalPlatforms BYTE 6
    l3_platX     BYTE 10, 25, 40, 55, 15, 45
    l3_platY     BYTE 20, 16, 18, 14, 12, 10
    l3_platLen   BYTE 8, 10, 9, 12, 7, 10
    l3_totalPipes BYTE 4
    l3_pipeX      BYTE 18, 37, 52, 68
    l3_pipeY      BYTE 21, 19, 15, 23
    l3_pipeHeight BYTE 3, 5, 9, 1
    l3_totalCoins BYTE 12
    l3_coinX      BYTE 12, 14, 16, 27, 29, 31, 42, 44, 57, 59, 17, 47
    l3_coinY      BYTE 19, 19, 19, 15, 15, 15, 17, 17, 13, 13, 11, 9
    l3_coinCollected BYTE 12 DUP(0)
    l3_coinValue  DWORD 300
    l3_powerupActive BYTE 1
    l3_powerupX   BYTE 60
    l3_powerupY   BYTE 13
    l3_groundEnemies BYTE 3
    l3_groundEnemyX    BYTE 30, 50, 25
    l3_groundEnemyY    BYTE 23, 23, 15
    l3_groundEnemyPrevX BYTE 30, 50, 25
    l3_groundEnemyDir   SBYTE 1, -1, 1
    l3_groundEnemyAlive BYTE 1, 1, 1
    l3_groundEnemyMinX  BYTE 22, 42, 15
    l3_groundEnemyMaxX  BYTE 38, 62, 33
    l3_flyingEnemies BYTE 2
    l3_flyingEnemyX    BYTE 45, 20
    l3_flyingEnemyY    BYTE 17, 11
    l3_flyingEnemyPrevX BYTE 45, 20
    l3_flyingEnemyPrevY BYTE 17, 11
    l3_flyingEnemyDirX  SBYTE -1, 1
    l3_flyingEnemyDirY  SBYTE -1, -1
    l3_flyingEnemyAlive BYTE 1, 1
    l3_flyingEnemyMinX  BYTE 40, 15
    l3_flyingEnemyMaxX  BYTE 55, 24
    l3_flyingEnemyMinY  BYTE 10, 5
    l3_flyingEnemyMaxY  BYTE 18, 12
    l3_flyingEnemyTimer BYTE 0, 0
    l3_flagX      BYTE 72
    l3_flagY      BYTE 17

.code

Level3Gameplay PROC
    l3_resetGame:
        call Clrscr
        mov gameAction, 0
        mov lives, 5
        mov xPos, 5
        mov yPos, 23
        mov prevXPos, 5
        mov prevYPos, 23
        mov velocityY, 0
        mov isOnGround, 1
        mov isJumping, 0
        mov gameTimer, 180
        mov timerTick, 0
        mov score, 0
        mov hasSpringMushroom, 0
        mov levelComplete, 0
        mov enemiesDefeated, 0
        mov cheatIndex, 0
        ; Preserve cheat ammo if cheat was activated via player name
        cmp cheatActive, 1
        jne l3_resetAmmoToZero
        mov al, 5
        mov fireballAmmo, al
        mov blueballAmmo, al
        jmp l3_doneAmmoReset
        l3_resetAmmoToZero:
        mov fireballAmmo, 0
        mov blueballAmmo, 0
        l3_doneAmmoReset:
        mov marioFacing, 1
        mov currentLevel, 3
        mov doubleJumpAvailable, 1
        mov ecx, 5
        mov esi, 0
        l3_resetProjLoop:
            mov projType[esi], 0
            inc esi
        loop l3_resetProjLoop
        mov esi, 0
        l3_resetCoinLoop:
            cmp esi, 12
            jge l3_resetGroundEnemies
            mov l3_coinCollected[esi], 0
            inc esi
            jmp l3_resetCoinLoop
        l3_resetGroundEnemies:
        mov l3_groundEnemyX[0], 30
        mov l3_groundEnemyX[1], 50
        mov l3_groundEnemyX[2], 25
        mov l3_groundEnemyAlive[0], 1
        mov l3_groundEnemyAlive[1], 1
        mov l3_groundEnemyAlive[2], 1
        mov l3_flyingEnemyX[0], 45
        mov l3_flyingEnemyY[0], 17
        mov l3_flyingEnemyX[1], 20
        mov l3_flyingEnemyY[1], 11
        mov l3_flyingEnemyAlive[0], 1
        mov l3_flyingEnemyAlive[1], 1
        mov l3_flyingEnemyTimer[0], 0
        mov l3_flyingEnemyTimer[1], 0
        mov l3_powerupActive, 1
        mov score, 0
        mov invincibleTimer, 0
        mov coinsCollected, 0
        call PlayLevel3Music
        call Randomize
        call L3_DrawHUD
        call L3_DrawLevel
        call L3_DrawCoins
        call L3_DrawPowerup
        call L3_DrawGroundEnemies
        call L3_DrawFlyingEnemies
        call L3_DrawFlag
        call DrawMario
    l3_gameLoop:
        mov al, xPos
        mov prevXPos, al
        mov al, yPos
        mov prevYPos, al
        call L3_HandleInput
        cmp gameAction, 1
        je l3_resetGame
        cmp gameAction, 2
        je l3_exitGame
        call ApplyPhysics
        call L3_UpdateMario
        call L3_EraseProjectiles
        call L3_UpdateProjectiles
        call L3_UpdateGroundEnemies
        call L3_UpdateFlyingEnemies
        cmp invincibleTimer, 0
        jle l3_skipInvDec
        dec invincibleTimer
        l3_skipInvDec:
        call L3_CheckGroundEnemyCollision
        call L3_CheckFlyingEnemyCollision
        call L3_CheckCoinCollection
        call L3_CheckPowerupCollection
        call L3_CheckFlagCollision
        cmp levelComplete, 1
        je l3_levelWin
        cmp lives, 0
        je l3_gameOver
        call EraseMario
        call L3_EraseGroundEnemies
        call L3_EraseFlyingEnemies
        call L3_RedrawStatic
        call L3_DrawCoins
        call L3_DrawPowerup
        call L3_DrawGroundEnemies
        call L3_DrawFlyingEnemies
        call L3_DrawFlag
        call DrawMario
        call DrawProjectiles
        call L3_DrawHUD
        mov eax, 30
        call Delay
        inc timerTick
        cmp timerTick, 33
        jl l3_skipTimeUpdate
        mov timerTick, 0
        dec gameTimer
        cmp gameTimer, 0
        je l3_gameOver
        l3_skipTimeUpdate:
        jmp l3_gameLoop
    l3_levelWin:
        call DisplayLevelComplete
        ret
    l3_gameOver:
        call DisplayGameOver
        ret
    l3_exitGame:
        ret
Level3Gameplay ENDP

L3_HandleInput PROC
    push eax
    push ebx
    call ReadKey
    jz l3_noInput
    cmp al, 0
    je l3_checkArrowKeys
    push eax
    or al, 20h
    mov esi, cheatIndex
    lea ebx, cheatStrMatch
    mov cl, [ebx + esi]
    cmp al, cl
    jne l3_resetCheatIndex
    inc cheatIndex
    cmp cheatIndex, 5
    jne l3_continueInput
    mov cheatActive, 1
    mov cheatIndex, 0
    mov al, 5
    mov fireballAmmo, al
    mov blueballAmmo, al
    jmp l3_continueInput
    l3_resetCheatIndex:
    cmp al, 'c'
    je l3_setIndexOne
    mov cheatIndex, 0
    jmp l3_continueInput
    l3_setIndexOne:
    mov cheatIndex, 1
    l3_continueInput:
    pop eax
    cmp al, 'p'
    je l3_triggerPause
    cmp al, 'P'
    je l3_triggerPause
    ; Check if player can fire red projectiles (from shop or cheat)
    cmp fireballAmmo, 0
    jg l3_canFireRed
    cmp cheatActive, 1
    jne l3_standardControls
    l3_canFireRed:
    cmp al, 'r'
    je l3_attemptFireShot
    cmp al, 'R'
    je l3_attemptFireShot
    ; Blue shots only available with cheat active
    cmp cheatActive, 1
    jne l3_standardControls
    cmp al, 'b'
    je l3_attemptBlueShot
    cmp al, 'B'
    je l3_attemptBlueShot
    l3_standardControls:
    cmp al, 'a'
    je l3_moveLeft
    cmp al, 'A'
    je l3_moveLeft
    cmp al, 'd'
    je l3_moveRight
    cmp al, 'D'
    je l3_moveRight
    cmp al, 'w'
    je l3_tryJump
    cmp al, 'W'
    je l3_tryJump
    cmp al, 'x'
    je l3_exitToMenu
    cmp al, 'X'
    je l3_exitToMenu
    cmp al, 27
    je l3_exitToMenu
    jmp l3_noInput
    l3_checkArrowKeys:
    cmp ah, 4Bh
    je l3_moveLeft
    cmp ah, 4Dh
    je l3_moveRight
    cmp ah, 48h
    je l3_tryJump
    jmp l3_noInput
    l3_triggerPause:
    call PauseMenu
    call Clrscr
    call L3_DrawHUD
    call L3_DrawLevel
    call L3_DrawCoins
    call L3_DrawPowerup
    call L3_DrawGroundEnemies
    call L3_DrawFlyingEnemies
    call L3_DrawFlag
    call DrawMario
    jmp l3_noInput
    l3_attemptFireShot:
    cmp fireballAmmo, 0
    jle l3_standardControls
    dec fireballAmmo
    mov cl, 1
    call SpawnProjectile
    jmp l3_noInput
    l3_attemptBlueShot:
    cmp blueballAmmo, 0
    jle l3_standardControls
    dec blueballAmmo
    mov cl, 2
    call SpawnProjectile
    jmp l3_noInput
    l3_moveLeft:
    mov marioFacing, -1
    mov bl, xPos
    mov al, xPos
    cmp al, minX
    jle l3_noInput
    dec xPos
    call L3_CheckPipeCollisionHorizontal
    cmp al, 1
    je l3_restoreXLeft
    jmp l3_noInput
    l3_restoreXLeft:
    mov xPos, bl
    jmp l3_noInput
    l3_moveRight:
    mov marioFacing, 1
    mov bl, xPos
    mov al, xPos
    cmp al, maxX
    jge l3_noInput
    inc xPos
    call L3_CheckPipeCollisionHorizontal
    cmp al, 1
    je l3_restoreXRight
    jmp l3_noInput
    l3_restoreXRight:
    mov xPos, bl
    jmp l3_noInput
    l3_tryJump:
    cmp isOnGround, 1
    je l3_doNormalJump
    cmp doubleJumpAvailable, 1
    je l3_doDoubleJump
    jmp l3_noInput
    l3_doNormalJump:
    mov doubleJumpAvailable, 1
    jmp l3_performJump
    l3_doDoubleJump:
    mov doubleJumpAvailable, 0
    l3_performJump:
    movzx eax, yPos
    cmp al, 23
    je l3_jumpFromGround
    jmp l3_jumpFromPlatform
    l3_jumpFromGround:
    cmp hasSpringMushroom, 1
    je l3_springJumpGround
    movsx eax, normalJumpPower
    mov velocityY, al
    jmp l3_finishJump
    l3_springJumpGround:
    movsx eax, enhancedJumpPower
    mov velocityY, al
    jmp l3_finishJump
    l3_jumpFromPlatform:
    cmp hasSpringMushroom, 1
    je l3_springJumpPlatform
    mov al, -3
    mov velocityY, al
    jmp l3_finishJump
    l3_springJumpPlatform:
    mov al, -5
    mov velocityY, al
    l3_finishJump:
    mov isOnGround, 0
    mov isJumping, 1
    call PlayJumpSound
    jmp l3_noInput
    l3_exitToMenu:
    mov gameAction, 2
    pop ebx
    pop eax
    ret
    l3_noInput:
    pop ebx
    pop eax
    ret
L3_HandleInput ENDP

L3_CheckPipeCollisionHorizontal PROC
    push ebx
    push ecx
    push esi
    push edx
    mov esi, 0
    l3_pipeHorizLoop:
        cmp esi, 4
        jge l3_noPipeCollH
        mov al, yPos
        mov cl, l3_pipeY[esi]
        cmp al, cl
        jl l3_nextPipeH
        movzx ebx, l3_pipeHeight[esi]
        add cl, bl
        dec cl
        cmp al, cl
        jg l3_nextPipeH
        mov al, xPos
        mov bl, l3_pipeX[esi]
        cmp al, bl
        je l3_pipeHit
        inc bl
        cmp al, bl
        je l3_pipeHit
        jmp l3_nextPipeH
        l3_pipeHit:
        mov al, 1
        jmp l3_pipeHorizDone
        l3_nextPipeH:
        inc esi
        jmp l3_pipeHorizLoop
    l3_noPipeCollH:
    mov al, 0
    l3_pipeHorizDone:
    pop edx
    pop esi
    pop ecx
    pop ebx
    ret
L3_CheckPipeCollisionHorizontal ENDP

L3_DrawLevel PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov ecx, 80
    l3_drawGroundLoop:
        mov al, 177
        call WriteChar
    loop l3_drawGroundLoop
    call L3_DrawPlatforms
    call L3_DrawPipes
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L3_DrawLevel ENDP

L3_DrawPlatforms PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, white + (cyan * 16)
    call SetTextColor
    mov esi, 0
    l3_platformLoop:
        movzx ecx, l3_totalPlatforms
        cmp esi, ecx
        jge l3_platformsDone
        movzx ecx, l3_platLen[esi]
        mov dl, l3_platX[esi]
        mov dh, l3_platY[esi]
        call Gotoxy
        l3_drawPlatSeg:
            mov al, 205
            call WriteChar
        loop l3_drawPlatSeg
        inc esi
        jmp l3_platformLoop
    l3_platformsDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L3_DrawPlatforms ENDP

L3_DrawPipes PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov esi, 0
    l3_pipeLoop:
        movzx eax, l3_totalPipes
        cmp esi, eax
        jge l3_pipesDone
        movzx ecx, l3_pipeHeight[esi]
        mov bl, l3_pipeY[esi]
        l3_pipeSegLoop:
            mov dl, l3_pipeX[esi]
            mov dh, bl
            call Gotoxy
            mov al, 186
            call WriteChar
            inc dl
            call Gotoxy
            call WriteChar
            inc bl
        loop l3_pipeSegLoop
        inc esi
        jmp l3_pipeLoop
    l3_pipesDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L3_DrawPipes ENDP

L3_DrawCoins PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov esi, 0
    l3_coinDrawLoop:
        movzx ecx, l3_totalCoins
        cmp esi, ecx
        jge l3_coinDrawDone
        cmp l3_coinCollected[esi], 1
        je l3_skipCoinDraw
        mov dl, l3_coinX[esi]
        mov dh, l3_coinY[esi]
        call Gotoxy
        mov al, 'O'
        call WriteChar
        l3_skipCoinDraw:
        inc esi
        jmp l3_coinDrawLoop
    l3_coinDrawDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
L3_DrawCoins ENDP

L3_DrawPowerup PROC
    push eax
    push edx
    cmp l3_powerupActive, 0
    je l3_noPowerupDraw
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    mov dl, l3_powerupX
    mov dh, l3_powerupY
    call Gotoxy
    mov al, '+'
    call WriteChar
    l3_noPowerupDraw:
    pop edx
    pop eax
    ret
L3_DrawPowerup ENDP

L3_DrawGroundEnemies PROC
    push eax
    push ebx
    push edx
    push esi
    mov eax, red + (black * 16)
    call SetTextColor
    mov esi, 0
    l3_groundEnemyDrawLoop:
        movzx eax, l3_groundEnemies
        cmp esi, eax
        jge l3_groundEnemyDrawDone
        cmp l3_groundEnemyAlive[esi], 0
        je l3_skipGroundDraw
        mov dl, l3_groundEnemyX[esi]
        mov dh, l3_groundEnemyY[esi]
        call Gotoxy
        mov al, 178
        call WriteChar
        l3_skipGroundDraw:
        inc esi
        jmp l3_groundEnemyDrawLoop
    l3_groundEnemyDrawDone:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L3_DrawGroundEnemies ENDP

L3_DrawFlyingEnemies PROC
    push eax
    push ebx
    push edx
    push esi
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov esi, 0
    l3_flyingEnemyDrawLoop:
        movzx eax, l3_flyingEnemies
        cmp esi, eax
        jge l3_flyingEnemyDrawDone
        cmp l3_flyingEnemyAlive[esi], 0
        je l3_skipFlyingDraw
        mov dl, l3_flyingEnemyX[esi]
        mov dh, l3_flyingEnemyY[esi]
        call Gotoxy
        mov al, 219
        call WriteChar
        l3_skipFlyingDraw:
        inc esi
        jmp l3_flyingEnemyDrawLoop
    l3_flyingEnemyDrawDone:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L3_DrawFlyingEnemies ENDP

L3_DrawFlag PROC
    push eax
    push ecx
    push edx
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, l3_flagX
    mov dh, l3_flagY
    call Gotoxy
    mov al, 16
    call WriteChar
    mov ecx, 6
    mov dh, l3_flagY
    inc dh
    l3_flagPoleLoop:
        push ecx
        mov dl, l3_flagX
        call Gotoxy
        mov al, 179
        call WriteChar
        inc dh
        pop ecx
    loop l3_flagPoleLoop
    pop edx
    pop ecx
    pop eax
    ret
L3_DrawFlag ENDP

L3_DrawHUD PROC
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
    jg l3_showFireAmmo
    cmp cheatActive, 1
    jne l3_skipCheatHud
    l3_showFireAmmo:
    mov dl, 30
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strFireAmmo
    call WriteString
    movzx eax, fireballAmmo
    call WriteDec
    ; Show blue ammo only if cheat is active
    cmp cheatActive, 1
    jne l3_skipCheatHud
    mov edx, OFFSET strBlueAmmo
    call WriteString
    movzx eax, blueballAmmo
    call WriteDec
    jmp l3_drawTimer
    l3_skipCheatHud:
    mov dl, 35
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET l3_strLevel
    call WriteString
    l3_drawTimer:
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
L3_DrawHUD ENDP

L3_UpdateMario PROC
    push eax
    push ebx
    mov al, yPos
    movsx ebx, velocityY
    add al, bl
    cmp al, minY
    jge l3_topOK
    mov al, minY
    mov velocityY, 0
    l3_topOK:
    mov yPos, al
    movsx eax, velocityY
    cmp eax, 0
    jle l3_checkGroundOnly
    call L3_CheckPlatformCollision
    cmp al, 1
    je l3_marioUpdateDone
    call L3_CheckPipeTopCollision
    cmp al, 1
    je l3_marioUpdateDone
    l3_checkGroundOnly:
    mov al, yPos
    cmp al, 23
    jl l3_marioInAir
    mov yPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    mov doubleJumpAvailable, 1
    jmp l3_marioUpdateDone
    l3_marioInAir:
    mov isOnGround, 0
    l3_marioUpdateDone:
    pop ebx
    pop eax
    ret
L3_UpdateMario ENDP

L3_CheckPipeTopCollision PROC
    push ebx
    push ecx
    push esi
    push edx
    cmp velocityY, 0
    jle l3_noPipeTop
    mov esi, 0
    l3_pipeTopLoop:
        cmp esi, 4
        jge l3_noPipeTop
        mov al, xPos
        mov bl, l3_pipeX[esi]
        cmp al, bl
        je l3_checkPipeTopHeight
        inc bl
        cmp al, bl
        jne l3_nextPipeTop
        l3_checkPipeTopHeight:
        mov al, yPos
        mov bl, l3_pipeY[esi]
        dec bl
        mov cl, prevYPos
        cmp cl, bl
        jg l3_nextPipeTop
        cmp al, bl
        jl l3_nextPipeTop
        mov yPos, bl
        mov velocityY, 0
        mov isOnGround, 1
        mov doubleJumpAvailable, 1
        mov al, 1
        jmp l3_pipeTopDone
        l3_nextPipeTop:
        inc esi
        jmp l3_pipeTopLoop
    l3_noPipeTop:
    mov al, 0
    l3_pipeTopDone:
    pop edx
    pop esi
    pop ecx
    pop ebx
    ret
L3_CheckPipeTopCollision ENDP

L3_CheckPlatformCollision PROC
    push ebx
    push ecx
    push esi
    push edx
    mov esi, 0
    l3_checkPlatLoop:
        movzx ecx, l3_totalPlatforms
        cmp esi, ecx
        jge l3_noPlatformCollision
        mov al, xPos
        mov bl, l3_platX[esi]
        cmp al, bl
        jl l3_nextPlatform
        add bl, l3_platLen[esi]
        dec bl
        cmp al, bl
        jg l3_nextPlatform
        mov cl, l3_platY[esi]
        dec cl
        mov al, prevYPos
        cmp al, cl
        jg l3_nextPlatform
        mov al, yPos
        cmp al, cl
        jl l3_nextPlatform
        mov yPos, cl
        mov velocityY, 0
        mov isOnGround, 1
        mov doubleJumpAvailable, 1
        mov al, 1
        jmp l3_platformCollisionDone
        l3_nextPlatform:
        inc esi
        jmp l3_checkPlatLoop
    l3_noPlatformCollision:
    mov al, 0
    l3_platformCollisionDone:
    pop edx
    pop esi
    pop ecx
    pop ebx
    ret
L3_CheckPlatformCollision ENDP

L3_UpdateGroundEnemies PROC
    push eax
    push ebx
    push esi
    mov esi, 0
    l3_updateGroundLoop:
        movzx eax, l3_groundEnemies
        cmp esi, eax
        jge l3_updateGroundDone
        cmp l3_groundEnemyAlive[esi], 0
        je l3_skipGroundUpdate
        mov al, l3_groundEnemyX[esi]
        mov l3_groundEnemyPrevX[esi], al
        movsx ebx, l3_groundEnemyDir[esi]
        add al, bl
        cmp al, l3_groundEnemyMinX[esi]
        jle l3_reverseGroundDir
        cmp al, l3_groundEnemyMaxX[esi]
        jge l3_reverseGroundDir
        mov l3_groundEnemyX[esi], al
        jmp l3_skipGroundUpdate
        l3_reverseGroundDir:
        neg l3_groundEnemyDir[esi]
        l3_skipGroundUpdate:
        inc esi
        jmp l3_updateGroundLoop
    l3_updateGroundDone:
    pop esi
    pop ebx
    pop eax
    ret
L3_UpdateGroundEnemies ENDP

L3_UpdateFlyingEnemies PROC
    push eax
    push ebx
    push esi
    mov esi, 0
    l3_updateFlyingLoop:
        movzx eax, l3_flyingEnemies
        cmp esi, eax
        jge l3_updateFlyingDone
        cmp l3_flyingEnemyAlive[esi], 0
        je l3_skipFlyingUpdate
        inc l3_flyingEnemyTimer[esi]
        cmp l3_flyingEnemyTimer[esi], 2
        jl l3_skipFlyingUpdate
        mov l3_flyingEnemyTimer[esi], 0
        mov al, l3_flyingEnemyX[esi]
        mov l3_flyingEnemyPrevX[esi], al
        mov al, l3_flyingEnemyY[esi]
        mov l3_flyingEnemyPrevY[esi], al
        mov al, l3_flyingEnemyX[esi]
        movsx ebx, l3_flyingEnemyDirX[esi]
        add al, bl
        cmp al, l3_flyingEnemyMinX[esi]
        jle l3_reverseFlyingX
        cmp al, l3_flyingEnemyMaxX[esi]
        jge l3_reverseFlyingX
        mov l3_flyingEnemyX[esi], al
        jmp l3_updateFlyingY
        l3_reverseFlyingX:
        neg l3_flyingEnemyDirX[esi]
        jmp l3_updateFlyingY
        l3_updateFlyingY:
        mov al, l3_flyingEnemyY[esi]
        movsx ebx, l3_flyingEnemyDirY[esi]
        add al, bl
        cmp al, l3_flyingEnemyMinY[esi]
        jle l3_reverseFlyingY
        cmp al, l3_flyingEnemyMaxY[esi]
        jge l3_reverseFlyingY
        mov l3_flyingEnemyY[esi], al
        jmp l3_skipFlyingUpdate
        l3_reverseFlyingY:
        neg l3_flyingEnemyDirY[esi]
        l3_skipFlyingUpdate:
        inc esi
        jmp l3_updateFlyingLoop
    l3_updateFlyingDone:
    pop esi
    pop ebx
    pop eax
    ret
L3_UpdateFlyingEnemies ENDP

L3_EraseGroundEnemies PROC
    push eax
    push edx
    push esi
    mov esi, 0
    l3_eraseGroundLoop:
        movzx eax, l3_groundEnemies
        cmp esi, eax
        jge l3_eraseGroundDone
        ; Always erase at previous position to fix ghosting (removed alive check)
        mov dl, l3_groundEnemyPrevX[esi]
        mov dh, l3_groundEnemyY[esi]
        call L3_RepairTile
        inc esi
        jmp l3_eraseGroundLoop
    l3_eraseGroundDone:
    pop esi
    pop edx
    pop eax
    ret
L3_EraseGroundEnemies ENDP

L3_EraseFlyingEnemies PROC
    push eax
    push edx
    push esi
    mov esi, 0
    l3_eraseFlyingLoop:
        movzx eax, l3_flyingEnemies
        cmp esi, eax
        jge l3_eraseFlyingDone
        ; Always erase at previous position to fix ghosting (removed alive check)
        mov dl, l3_flyingEnemyPrevX[esi]
        mov dh, l3_flyingEnemyPrevY[esi]
        call L3_RepairTile
        inc esi
        jmp l3_eraseFlyingLoop
    l3_eraseFlyingDone:
    pop esi
    pop edx
    pop eax
    ret
L3_EraseFlyingEnemies ENDP

L3_RedrawStatic PROC
    push eax
    push ebx
    push edx
    push esi
    mov dl, prevXPos
    mov dh, prevYPos
    call L3_RepairTile
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L3_RedrawStatic ENDP

L3_RepairTile PROC
    pushad
    mov esi, 0
    l3_repairPlatCheck:
        movzx ecx, l3_totalPlatforms
        cmp esi, ecx
        jge l3_repairPipes
        mov al, dh
        cmp al, l3_platY[esi]
        jne l3_repairNextPlat
        mov al, dl
        cmp al, l3_platX[esi]
        jl l3_repairNextPlat
        mov bl, l3_platX[esi]
        add bl, l3_platLen[esi]
        dec bl
        cmp al, bl
        jg l3_repairNextPlat
        mov eax, white + (cyan * 16)
        call SetTextColor
        call Gotoxy
        mov al, 205
        call WriteChar
        jmp l3_repairDone
        l3_repairNextPlat:
        inc esi
        jmp l3_repairPlatCheck
    l3_repairPipes:
    mov esi, 0
    l3_repairPipeCheck:
        movzx eax, l3_totalPipes
        cmp esi, eax
        jge l3_repairGround
        mov al, dl
        mov bl, l3_pipeX[esi]
        cmp al, bl
        je l3_isPipe
        inc bl
        cmp al, bl
        jne l3_repairNextPipe
        l3_isPipe:
        movzx ebx, l3_pipeY[esi]
        cmp dh, bl
        jl l3_repairNextPipe
        movzx ecx, l3_pipeHeight[esi]
        add ebx, ecx
        cmp dh, bl
        jge l3_repairNextPipe
        mov eax, lightGreen + (black * 16)
        call SetTextColor
        call Gotoxy
        mov al, 186
        call WriteChar
        jmp l3_repairDone
        l3_repairNextPipe:
        inc esi
        jmp l3_repairPipeCheck
    l3_repairGround:
    cmp dh, 24
    jne l3_repairAir
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    call Gotoxy
    mov al, 177
    call WriteChar
    jmp l3_repairDone
    l3_repairAir:
    mov eax, black + (black * 16)
    call SetTextColor
    call Gotoxy
    mov al, ' '
    call WriteChar
    l3_repairDone:
    popad
    ret
L3_RepairTile ENDP

L3_CheckGroundEnemyCollision PROC
    push eax
    push ebx
    push edx
    push esi
    movzx edx, xPos
    movzx eax, yPos
    mov esi, 0
    l3_groundCollisionLoop:
        movzx ebx, l3_groundEnemies
        cmp esi, ebx
        jge l3_noGroundCollision
        cmp l3_groundEnemyAlive[esi], 0
        je l3_nextGroundCollision
        movzx ebx, l3_groundEnemyX[esi]
        push eax
        mov al, bl
        sub al, dl
        cmp al, 0
        jge l3_absGroundX
        neg al
        l3_absGroundX:
        cmp al, 2
        pop eax
        jg l3_nextGroundCollision
        movzx ebx, l3_groundEnemyY[esi]
        cmp eax, ebx
        jne l3_nextGroundCollision
        movzx ebx, prevYPos
        cmp ebx, eax
        jl l3_stompedGroundEnemy
        cmp invincibleTimer, 0
        jg l3_nextGroundCollision
        dec lives
        call L3_DrawHUD
        mov invincibleTimer, 60
        jmp l3_nextGroundCollision
        l3_stompedGroundEnemy:
        mov l3_groundEnemyAlive[esi], 0
        push edx
        mov dl, l3_groundEnemyX[esi]
        mov dh, l3_groundEnemyY[esi]
        call L3_RepairTile
        pop edx
        inc enemiesDefeated
        add score, 100
        call L3_DrawHUD
        mov velocityY, -2
        dec yPos
        mov isOnGround, 0
        call PlayCoinSound
        l3_nextGroundCollision:
        inc esi
        jmp l3_groundCollisionLoop
    l3_noGroundCollision:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L3_CheckGroundEnemyCollision ENDP

L3_CheckFlyingEnemyCollision PROC
    push eax
    push ebx
    push edx
    push esi
    movzx edx, xPos
    movzx eax, yPos
    mov esi, 0
    l3_flyingCollisionLoop:
        movzx ebx, l3_flyingEnemies
        cmp esi, ebx
        jge l3_noFlyingCollision
        cmp l3_flyingEnemyAlive[esi], 0
        je l3_nextFlyingCollision
        movzx ebx, l3_flyingEnemyX[esi]
        push eax
        mov al, bl
        sub al, dl
        cmp al, 0
        jge l3_absFlyingX
        neg al
        l3_absFlyingX:
        cmp al, 2
        pop eax
        jg l3_nextFlyingCollision
        movzx ebx, l3_flyingEnemyY[esi]
        cmp eax, ebx
        jne l3_nextFlyingCollision
        movzx ebx, prevYPos
        cmp ebx, eax
        jl l3_stompedFlyingEnemy
        cmp invincibleTimer, 0
        jg l3_nextFlyingCollision
        dec lives
        call L3_DrawHUD
        mov invincibleTimer, 60
        jmp l3_nextFlyingCollision
        l3_stompedFlyingEnemy:
        mov l3_flyingEnemyAlive[esi], 0
        push edx
        mov dl, l3_flyingEnemyX[esi]
        mov dh, l3_flyingEnemyY[esi]
        call L3_RepairTile
        pop edx
        inc enemiesDefeated
        add score, 150
        call L3_DrawHUD
        mov velocityY, -3
        dec yPos
        mov isOnGround, 0
        call PlayCoinSound
        l3_nextFlyingCollision:
        inc esi
        jmp l3_flyingCollisionLoop
    l3_noFlyingCollision:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L3_CheckFlyingEnemyCollision ENDP

L3_CheckCoinCollection PROC
    push eax
    push ebx
    push edx
    push esi
    movzx edx, xPos
    movzx eax, yPos
    mov esi, 0
    l3_coinCollectionLoop:
        movzx ebx, l3_totalCoins
        cmp esi, ebx
        jge l3_coinCollectionDone
        cmp l3_coinCollected[esi], 1
        je l3_nextCoinCheck
        movzx ebx, l3_coinX[esi]
        cmp edx, ebx
        jne l3_nextCoinCheck
        movzx ebx, l3_coinY[esi]
        cmp eax, ebx
        jne l3_nextCoinCheck
        mov l3_coinCollected[esi], 1
        push eax
        push edx
        mov eax, l3_coinValue
        add score, eax
        call PlayCoinSound
        pop edx
        pop eax
        inc coinsCollected
        l3_nextCoinCheck:
        inc esi
        jmp l3_coinCollectionLoop
    l3_coinCollectionDone:
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
L3_CheckCoinCollection ENDP

L3_CheckPowerupCollection PROC
    push eax
    push ebx
    cmp l3_powerupActive, 0
    je l3_noPowerup
    movzx eax, xPos
    movzx ebx, l3_powerupX
    cmp eax, ebx
    jne l3_noPowerup
    movzx eax, yPos
    movzx ebx, l3_powerupY
    cmp eax, ebx
    jne l3_noPowerup
    mov l3_powerupActive, 0
    inc lives
    add score, 500
    call PlayCoinSound
    call L3_DrawHUD
    l3_noPowerup:
    pop ebx
    pop eax
    ret
L3_CheckPowerupCollection ENDP

L3_CheckFlagCollision PROC
    push eax
    push ebx
    movzx eax, xPos
    movzx ebx, l3_flagX
    sub ebx, 1
    cmp eax, ebx
    jl l3_noFlagCollision
    movzx ebx, l3_flagX
    add ebx, 2
    cmp eax, ebx
    jg l3_noFlagCollision
    movzx eax, yPos
    movzx ebx, l3_flagY
    cmp eax, ebx
    jl l3_noFlagCollision
    mov levelComplete, 1
    l3_noFlagCollision:
    pop ebx
    pop eax
    ret
L3_CheckFlagCollision ENDP

; ================================================
; L3_EraseProjectiles - Erase projectiles using L3_RepairTile
; ================================================
L3_EraseProjectiles PROC
    pushad
    mov esi, 0
    l3_eraseProjLoop:
        cmp esi, MAX_PROJ
        jge l3_doneEraseProj
        cmp projType[esi], 0
        je l3_skipEraseP
        mov dl, projX[esi]
        mov dh, projY[esi]
        call L3_RepairTile
        l3_skipEraseP:
        inc esi
        jmp l3_eraseProjLoop
    l3_doneEraseProj:
    popad
    ret
L3_EraseProjectiles ENDP

; ================================================
; L3_UpdateProjectiles - Full projectile update for Level 3
; Handles movement, collision with enemies/coins, and redrawing
; ================================================
L3_UpdateProjectiles PROC
    pushad
    mov esi, 0
    l3_updateProjLoop:
        cmp esi, MAX_PROJ
        jge l3_doneUpdateProj
        cmp projType[esi], 0
        je l3_nextProj
        
        ; Move projectile
        mov al, projX[esi]
        mov bl, byte ptr projDir[esi]
        add al, bl
        cmp al, minX
        jle l3_killProj
        cmp al, maxX
        jge l3_killProj
        mov projX[esi], al
        
        ; Check distance limit
        inc projDist[esi]
        cmp projDist[esi], 40
        jg l3_killProj
        
        ; Check platform collision
        push edx
        mov dl, projX[esi]
        mov dh, projY[esi]
        call L3_CheckPlatformCollisionProj
        pop edx
        cmp al, 1
        je l3_killProj
        
        ; Check pipe collision
        push edx
        mov dl, projX[esi]
        mov dh, projY[esi]
        call L3_CheckPipeCollisionProj
        pop edx
        cmp al, 1
        je l3_killProj
        
        ; Handle by projectile type
        cmp projType[esi], 1
        je l3_handleFireball
        cmp projType[esi], 2
        je l3_handleBlueball
        jmp l3_nextProj
        
    l3_handleFireball:
        ; Check ground enemies
        mov edi, 0
        l3_chkGroundEnFire:
            cmp edi, 3
            jge l3_chkFlyingEnFire
            cmp l3_groundEnemyAlive[edi], 0
            je l3_nextGroundEnFire
            mov al, projX[esi]
            mov dl, l3_groundEnemyX[edi]
            sub al, dl
            cmp al, 0
            jge l3_absGroundFire
            neg al
            l3_absGroundFire:
            cmp al, 2
            jg l3_nextGroundEnFire
            mov al, projY[esi]
            cmp al, l3_groundEnemyY[edi]
            jne l3_nextGroundEnFire
            ; Kill ground enemy
            mov l3_groundEnemyAlive[edi], 0
            push edx
            mov dl, l3_groundEnemyX[edi]
            mov dh, l3_groundEnemyY[edi]
            call L3_RepairTile
            pop edx
            inc enemiesDefeated
            add score, 100
            call L3_DrawHUD
            jmp l3_killProj
            l3_nextGroundEnFire:
            inc edi
            jmp l3_chkGroundEnFire
        
        l3_chkFlyingEnFire:
        mov edi, 0
        l3_flyingFireLoop:
            cmp edi, 2
            jge l3_nextProj
            cmp l3_flyingEnemyAlive[edi], 0
            je l3_nextFlyingEnFire
            mov al, projX[esi]
            mov dl, l3_flyingEnemyX[edi]
            sub al, dl
            cmp al, 0
            jge l3_absFlyingFire
            neg al
            l3_absFlyingFire:
            cmp al, 2
            jg l3_nextFlyingEnFire
            mov al, projY[esi]
            cmp al, l3_flyingEnemyY[edi]
            jne l3_nextFlyingEnFire
            ; Kill flying enemy
            mov l3_flyingEnemyAlive[edi], 0
            push edx
            mov dl, l3_flyingEnemyX[edi]
            mov dh, l3_flyingEnemyY[edi]
            call L3_RepairTile
            pop edx
            inc enemiesDefeated
            add score, 150
            call L3_DrawHUD
            jmp l3_killProj
            l3_nextFlyingEnFire:
            inc edi
            jmp l3_flyingFireLoop
        
    l3_handleBlueball:
        ; Check coins
        mov edi, 0
        l3_chkCoinBlue:
            movzx eax, l3_totalCoins
            cmp edi, eax
            jge l3_chkPowerupBlue
            cmp l3_coinCollected[edi], 1
            je l3_nextCoinBlue
            mov al, projX[esi]
            cmp al, l3_coinX[edi]
            jne l3_nextCoinBlue
            mov al, projY[esi]
            cmp al, l3_coinY[edi]
            jne l3_nextCoinBlue
            ; Collect coin
            mov l3_coinCollected[edi], 1
            add score, 200
            inc coinsCollected
            call PlayCoinSound
            call L3_DrawHUD
            jmp l3_killProj
            l3_nextCoinBlue:
            inc edi
            jmp l3_chkCoinBlue
        
        l3_chkPowerupBlue:
        cmp l3_powerupActive, 0
        je l3_nextProj
        mov al, projX[esi]
        cmp al, l3_powerupX
        jne l3_nextProj
        mov al, projY[esi]
        cmp al, l3_powerupY
        jne l3_nextProj
        ; Collect powerup
        mov l3_powerupActive, 0
        inc lives
        add score, 500
        call PlayCoinSound
        call L3_DrawHUD
        jmp l3_killProj
        
    l3_killProj:
        ; Use L3_RepairTile to restore whatever was at projectile position
        mov dl, projX[esi]
        mov dh, projY[esi]
        call L3_RepairTile
        mov projType[esi], 0
        
    l3_nextProj:
        inc esi
        jmp l3_updateProjLoop
        
    l3_doneUpdateProj:
    popad
    ret
L3_UpdateProjectiles ENDP

; ================================================
; L3_CheckPlatformCollisionProj - Check if projectile hit platform
; Input: DL=X, DH=Y  Output: AL=1 if collision
; ================================================
L3_CheckPlatformCollisionProj PROC
    push ebx
    push ecx
    push esi
    mov esi, 0
    l3_platProjLoop:
        movzx ecx, l3_totalPlatforms
        cmp esi, ecx
        jge l3_noPlatProj
        mov al, dh
        cmp al, l3_platY[esi]
        jne l3_nextPlatProj
        mov al, dl
        cmp al, l3_platX[esi]
        jl l3_nextPlatProj
        mov bl, l3_platX[esi]
        add bl, l3_platLen[esi]
        dec bl
        cmp al, bl
        jg l3_nextPlatProj
        mov al, 1
        jmp l3_platProjDone
        l3_nextPlatProj:
        inc esi
        jmp l3_platProjLoop
    l3_noPlatProj:
    mov al, 0
    l3_platProjDone:
    pop esi
    pop ecx
    pop ebx
    ret
L3_CheckPlatformCollisionProj ENDP

; ================================================
; L3_CheckPipeCollisionProj - Check if projectile hit pipe
; Input: DL=X, DH=Y  Output: AL=1 if collision
; ================================================
L3_CheckPipeCollisionProj PROC
    push ebx
    push ecx
    push esi
    mov esi, 0
    l3_pipeProjLoop:
        cmp esi, 4
        jge l3_noPipeProj
        mov al, dl
        mov bl, l3_pipeX[esi]
        cmp al, bl
        je l3_checkPipeHeight
        inc bl
        cmp al, bl
        jne l3_nextPipeProj
        l3_checkPipeHeight:
        mov al, dh
        mov cl, l3_pipeY[esi]
        cmp al, cl
        jl l3_nextPipeProj
        movzx ebx, l3_pipeHeight[esi]
        add cl, bl
        dec cl
        cmp al, cl
        jg l3_nextPipeProj
        mov al, 1
        jmp l3_pipeProjDone
        l3_nextPipeProj:
        inc esi
        jmp l3_pipeProjLoop
    l3_noPipeProj:
    mov al, 0
    l3_pipeProjDone:
    pop esi
    pop ecx
    pop ebx
    ret
L3_CheckPipeCollisionProj ENDP