INCLUDE Irvine32.inc
INCLUDELIB winmm.lib

mciSendStringA PROTO, lpstrCommand:PTR BYTE, lpstrReturnString:PTR BYTE, uReturnLength:DWORD, hwndCallback:DWORD

.data
    menuTitle1 BYTE "  ____                         __   __            _          ",0
    menuTitle2 BYTE " / ___| _   _ _ __   ___ _ __  |  \/  | __ _ _ __(_) ___  ",0
    menuTitle3 BYTE " \___ \| | | | '_ \ / _ \ '__| | |\/| |/ _` | '__| |/ _ \ ",0
    menuTitle4 BYTE "  ___) | |_| | |_) |  __/ |    | |  | | (_| | |  | | (_) |",0
    menuTitle5 BYTE " |____/ \__,_| .__/ \___|_|    |_|  |_|\__,_|_|  |_|\___/ ",0
    menuTitle6 BYTE "              |_|                                         ",0
    
    rollNumber BYTE "                     Roll Number: 24I-0544",0
    divider    BYTE "==============================================================",0
    
    menuOption1 BYTE "                        Start Game",0
    menuOption2 BYTE "                        High Scores",0
    menuOption3 BYTE "                        Instructions",0
    menuOption4 BYTE "                        Exit",0
    
    levelTitle   BYTE "                     === SELECT LEVEL ===",0
    levelOption1 BYTE "                        Level 1: Grassland Adventure",0
    levelOption2 BYTE "                        Level 2: Underground Challenge",0
    levelOption3 BYTE "                        Level 3: Sky High Platforms",0
    levelOption4 BYTE "                        Level 4: Castle Fortress",0
    levelOption5 BYTE "                        Back to Main Menu",0
    
    instructionTitle BYTE "                     === INSTRUCTIONS ===",0
    instruction1 BYTE "    W / UP Arrow    - Jump",0
    instruction2 BYTE "    A / LEFT Arrow  - Move Left",0
    instruction3 BYTE "    S / DOWN Arrow  - Move Down",0
    instruction4 BYTE "    D / RIGHT Arrow - Move Right",0
    instruction5 BYTE "    P               - PAUSE GAME",0
    instruction6 BYTE "    X               - Quit Immediately",0
    instruction7 BYTE "    Press ESC to return to menu...",0
    
    highScoreTitle BYTE "                     === HIGH SCORES ===",0
    highScoreMsg   BYTE "                     No scores yet!",0
    returnMsg      BYTE "    Press ESC to return to menu...",0
    navPrompt      BYTE "    Use UP/DOWN or W/S to navigate, ENTER to select",0

    ; --- PAUSE MENU VARIABLES ---
    pauseTitle     BYTE "                     === GAME PAUSED ===",0
    pauseOpt1      BYTE "                        Resume Game",0
    pauseOpt2      BYTE "                        Restart Level",0
    pauseOpt3      BYTE "                        Exit to Main Menu",0
    pauseChoice    BYTE 1
    gameAction     BYTE 0 ; 0=Continue, 1=Restart, 2=Exit
    pauseOpt4      BYTE "                        Shop",0
    ; ----------------------------
    
    ; --- SHOP MENU VARIABLES ---
    shopTokens       DWORD 0
    shopTitle        BYTE "                     === SHOP ===",0
    shopTokensStr    BYTE "                     Shop Tokens: ",0
    shopOpt1         BYTE "                     [1] Buy 1 Life - 8 Tokens",0
    shopOpt2         BYTE "                     [2] Buy 2 Red Shots - 13 Tokens",0
    shopOptBack      BYTE "                     [ESC] Back to Pause Menu",0
    shopMsgBought    BYTE "                     Purchase Successful!     ",0
    shopMsgNoFunds   BYTE "                     Not Enough Tokens!       ",0
    shopChoice       BYTE 0
    ; ----------------------------
    
    ground      BYTE "================================================================================",0
    platform1   BYTE "============",0
    platform2   BYTE "============",0
    strScore    BYTE "SCORE: ",0
    strLives    BYTE " LIVES: ",0
    strLevel    BYTE " LEVEL: 1-1",0
    
    strTime          BYTE " TIME: ",0
    gameTimer        DWORD 120
    timerTick        DWORD 0
    flagPole         BYTE  "|",0
    flagTop          BYTE  "|>",0
    flagX            BYTE  74
    flagY            BYTE  19
    levelComplete    BYTE  0
    enemiesDefeated  BYTE  0
    
    winTitleStr      BYTE "                 === LEVEL COMPLETED! ===",0
    winBaseScore     BYTE "                 Base Score:       ",0
    winEnemiesStr    BYTE "                 Enemies Defeated: ",0
    winTimeBonus     BYTE "                 Time Bonus (x50): ",0
    winFinalScore    BYTE "                 FINAL SCORE:      ",0
    winExitMsg       BYTE "                 Press any key to continue...",0

    score DWORD 0
    lives BYTE 3
    
    xPos BYTE 5
    yPos BYTE 23
    prevXPos BYTE 5
    prevYPos BYTE 23
    velocityY SBYTE 0
    isOnGround BYTE 1
    isJumping BYTE 0
    jumpPower SBYTE -5
    gravity SBYTE 1
    maxFallSpeed SBYTE 8
    
    groundLevel BYTE 23
    minX BYTE 0
    maxX BYTE 79
    minY BYTE 2
    
    plat1Y BYTE 19
    plat1XStart BYTE 13
    plat1XEnd BYTE 24
    
    plat2Y BYTE 15
    plat2XStart BYTE 35
    plat2XEnd BYTE 46

    pipe1 BYTE "||",0
    pipe2 BYTE "||",0
    pipe3 BYTE "||",0

    pipe1X BYTE 30
    pipe1Y BYTE 22
    pipe1Height BYTE 2

    pipe2X BYTE 50
    pipe2Y BYTE 21
    pipe2Height BYTE 3

    pipe3X BYTE 65
    pipe3Y BYTE 22
    pipe3Height BYTE 2

    coinSymbol BYTE "O",0
    totalCoins dd 13
    
    coinXPos BYTE 15, 17, 19, 21, 23
             BYTE 37, 39, 41, 43, 45
             BYTE 56, 58, 60

    coinYPos BYTE 18, 18, 18, 18, 18
             BYTE 14, 14, 14, 14, 14
             BYTE 19, 19, 19

    coinCollected BYTE 13 DUP(0)
    coinValue DWORD 200
    coinsCollected BYTE 0

    doubleJumpAvailable BYTE 1
    normalJumpPower SBYTE -5
    enhancedJumpPower SBYTE -8
    hasSpringMushroom BYTE 0
    springMushroomTimer BYTE 0

    springMushroomX BYTE 40
    springMushroomY BYTE 23
    springMushroomCollected BYTE 0

    totalEnemies BYTE 5
    enemyScreen BYTE 1, 1, 1, 2, 2
    enemyXPos BYTE 25, 44, 70, 30, 55
    enemyYPos BYTE 23, 23, 23, 23, 23
    enemyPrevXPos BYTE 25, 50, 68, 30, 55
    enemyDirection SBYTE 1, -1, 1, 1, -1
    enemyAlive BYTE 1, 1, 1, 1, 1

    enemy1Left BYTE 20
    enemy1Right BYTE 28
    enemy2Left BYTE 40
    enemy2Right BYTE 48
    enemy3Left BYTE 66
    enemy3Right BYTE 74
    enemy4Left BYTE 25
    enemy4Right BYTE 40
    enemy5Left BYTE 50
    enemy5Right BYTE 65

    cP  EQU 0C5h
    cB  EQU 0DBh
    cT  EQU 0DFh
    cD  EQU 0DCh
    cU  EQU 0C4h

    art01 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art02 LABEL BYTE
        BYTE cB,cB,cB,cT,cT,cT,cB,cB,cP,cB,cB,cB
        BYTE cT,cT,cT,cB,cB,cB,cP,cB,cB,cB,cT,cB
        BYTE cD,cB,cT,cB,cB,cB,cP,cB,cB,cT,cT,cT,13,10,0
    art03 LABEL BYTE
        BYTE cB,cB,cP,cP,cP,cP,cB,cB,cP,cB,cB,cP
        BYTE cP,cP,cP,cP,cB,cB,cP,cB,cB,cP,cP,cP
        BYTE cB,cP,cP,cP,cB,cB,cP,cB,cB,cP,cP,cP,13,10,0
    art04 LABEL BYTE
        BYTE cB,cB,cP,cP,cP,cD,cD,cD,cP,cB,cB,cD
        BYTE cD,cD,cD,cD,cB,cB,cP,cB,cB,cP,cP,cP
        BYTE cT,cP,cP,cP,cB,cB,cP,cB,cB,cT,cT,cT,13,10,0
    art05 LABEL BYTE
        BYTE cB,cB,cP,cP,cP,cP,cB,cB,cP,cB,cB,cP
        BYTE cP,cP,cP,cP,cB,cB,cP,cB,cB,cP,cP,cP
        BYTE cP,cP,cP,cP,cB,cB,cP,cB,cB,cP,cP,cP,13,10,0
    art06 LABEL BYTE
        BYTE cB,cB,cB,cD,cD,cD,cB,cB,cP,cB,cB,cP
        BYTE cP,cP,cP,cP,cB,cB,cP,cB,cB,cP,cP,cP
        BYTE cP,cP,cP,cP,cB,cB,cP,cB,cB,cD,cD,cD,13,10,0
    art07 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art08 LABEL BYTE
        BYTE cB,cB,cB,cT,cT,cT,cB,cB,cB,cP,cT,cB
        BYTE cB,cB,cP,cP,cB,cB,cT,cP,cB,cB,cT,cT
        BYTE cT,cP,cB,cB,cT,cT,cT,cT,cB,cB,cD,cP,13,10,0
    art09 LABEL BYTE
        BYTE cB,cB,cP,cP,cP,cP,cP,cB,cB,cP,cP,cP
        BYTE cB,cB,cP,cP,cB,cB,cP,cP,cB,cB,cP,cP
        BYTE cP,cP,cB,cB,cP,cP,cP,cP,cP,cB,cB,cP,13,10,0
    art10 LABEL BYTE
        BYTE cB,cB,cP,cP,cP,cP,cP,cB,cB,cP,cP,cP
        BYTE cB,cB,cP,cP,cB,cB,cP,cP,cB,cB,cT,cT
        BYTE cT,cP,cB,cB,cD,cD,cD,cD,cD,cT,cT,cP,13,10,0
    art11 LABEL BYTE
        BYTE cB,cB,cP,cP,cP,cP,cP,cB,cB,cP,cP,cP
        BYTE cB,cB,cP,cP,cB,cT,cP,cP,cB,cB,cP,cP
        BYTE cP,cP,cB,cB,cP,cP,cP,cP,cP,cB,cB,cP,13,10,0
    art12 LABEL BYTE
        BYTE cB,cB,cB,cD,cD,cD,cB,cB,cB,cP,cP,cP
        BYTE cU,cT,cB,cT,cP,cP,cU,cP,cB,cB,cD,cD
        BYTE cD,cP,cB,cB,cP,cP,cP,cP,cP,cB,cB,cD,13,10,0
    art13 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art14 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cB,cB,cP,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cP,cB,cB,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art15 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cB,cB,cB,cB,cD,cP
        BYTE cP,cP,cD,cD,cD,cD,cD,cD,cD,cP,cP,cP
        BYTE cD,cB,cB,cB,cB,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art16 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cT,cT,cB
        BYTE cD,cB,cB,cB,cB,cB,cB,cB,cB,cB,cD,cB
        BYTE cT,cT,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art17 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cB
        BYTE cB,cB,cB,cB,cB,cB,cB,cB,cB,cB,cB,cB
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art18 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cB
        BYTE cB,cT,cT,cT,cB,cB,cB,cT,cT,cT,cB,cB
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art19 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cB
        BYTE cB,cP,cP,cP,cB,cB,cB,cP,cP,cP,cB,cB
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art20 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cB
        BYTE cB,cB,cB,cB,cT,cD,cT,cB,cB,cB,cB,cB
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art21 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP
        BYTE cB,cB,cB,cB,cB,cB,cB,cB,cB,cB,cB,cP
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art22 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cD,cD,cD,cB
        BYTE cB,cP,cP,cB,cT,cB,cT,cB,cP,cP,cB,cB
        BYTE cD,cD,cD,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art23 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cT,cT,cB,cB
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cB
        BYTE cB,cT,cT,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0
    art24 LABEL BYTE
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cT,cT
        BYTE cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cT
        BYTE cT,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,cP,13,10,0

    finalScoreMsg BYTE "              FINAL SCORE: ",0
    restartMsg    BYTE "         Press any key to exit...",0

    bytesWritten  DWORD ?
    hOut DWORD ?
    invincibleTimer BYTE 0

    mciRetString      BYTE 128 DUP(?)
    ; Background Music
    cmdOpenMenu       BYTE "open Sounds\menu_bg.wav type mpegvideo alias themeMenu",0
    cmdOpenLvl1       BYTE "open Sounds\level-1_bg.wav type mpegvideo alias theme1",0
    cmdOpenLvl2       BYTE "open Sounds\level-2_bg.wav type mpegvideo alias theme2",0
    cmdOpenLvl3       BYTE "open Sounds\level-3_bg.wav type mpegvideo alias theme3",0
    cmdOpenLvl4       BYTE "open Sounds\level-4_bg.wav type mpegvideo alias theme4",0
    
    ; Sound Effects (SFX)
    cmdOpenNav        BYTE "open Sounds\menu_up-down.wav type mpegvideo alias sfxNav",0
    cmdOpenSel        BYTE "open Sounds\select_option.wav type mpegvideo alias sfxSel",0
    cmdOpenJump       BYTE "open Sounds\jump.wav type mpegvideo alias sfxJump",0
    cmdOpenCoin       BYTE "open Sounds\Coin.wav type mpegvideo alias sfxCoin",0
    cmdOpenWin        BYTE "open Sounds\winner.wav type mpegvideo alias sfxWin",0
    cmdOpenLose       BYTE "open Sounds\Losing.wav type mpegvideo alias sfxLose",0
    cmdOpenShopBuy    BYTE "open Sounds\shop_purchase.wav type mpegvideo alias sfxShopBuy",0

    ; 2. PLAY COMMANDS
    ; Music (Looping)
    cmdPlayMenu       BYTE "play themeMenu from 0 repeat",0
    cmdPlayLvl1       BYTE "play theme1 from 0 repeat",0
    cmdPlayLvl2       BYTE "play theme2 from 0 repeat",0
    cmdPlayLvl3       BYTE "play theme3 from 0 repeat",0
    cmdPlayLvl4       BYTE "play theme4 from 0 repeat",0

    ; SFX (One-shot, 'from 0' allows rapid spamming)
    cmdPlayNav        BYTE "play sfxNav from 0",0
    cmdPlaySel        BYTE "play sfxSel from 0",0
    cmdPlayJump       BYTE "play sfxJump from 0",0
    cmdPlayCoin       BYTE "play sfxCoin from 0",0
    cmdPlayWin        BYTE "play sfxWin from 0",0
    cmdPlayLose       BYTE "play sfxLose from 0",0
    cmdPlayShopBuy    BYTE "play sfxShopBuy from 0",0
    
    ; Menu music state flag
    menuMusicPlaying  BYTE 0

    ; 3. STOP/PAUSE COMMANDS
    cmdStopMenu       BYTE "pause themeMenu",0
    cmdStopLvl1       BYTE "pause theme1",0
    cmdStopLvl2       BYTE "pause theme2",0
    cmdStopLvl3       BYTE "pause theme3",0
    cmdStopLvl4       BYTE "pause theme4",0
    cmdCloseAll       BYTE "close all",0

    inputChar BYTE ?
    menuChoice BYTE 1
    levelChoice BYTE 1
    currentLevel BYTE 1
    levelScreen BYTE 1 

    highScoreFile     BYTE "highscores.txt",0
    fileHandle        DWORD ?
    namePrompt        BYTE "ENTER YOUR NAME: ",0
    currentPlayerName BYTE 20 DUP(0)
    NAME_STRIDE       EQU 20

    highScoreNames BYTE "Kira", 0, 15 DUP(0)
                   BYTE "Goku", 0, 15 DUP(0)
                   BYTE "Monkey D. Luffy", 0, 4 DUP(0)
                   BYTE "Roronoa Zoro", 0, 7 DUP(0)
                   BYTE "Nami", 0, 15 DUP(0)
    spacerStr db " ",0
    highScoreValues   DWORD 5000, 4000, 3000, 2000, 100

    hsTitleStr        BYTE "=== TOP 5 HIGH SCORES ===",0
    hsRankStr         BYTE ". ",0
    hsScoreStr        BYTE "    PTS",0
    hsHeaderStr       BYTE "RANK   NAME                  SCORE",0
    hsDividerStr      BYTE "==========================================",0
    hsPtsLabel        BYTE " PTS",0   

    scoreTextBuffer   BYTE 12 DUP(0)
    newLine           BYTE 13, 10
    spaceChar         BYTE " ", 0
    bytesRead         DWORD ?

    cheatStrMatch   BYTE "cheat",0
    cheatNameTrigger BYTE "CHEAT",0 ; Added Trigger for Name
    cheatIndex      DWORD 0
    cheatActive     BYTE 0          ; 0 = Off, 1 = On
    
    msgCheatActive  BYTE "CHEAT ACTIVATED!",0

    fireballAmmo    BYTE 0
    blueballAmmo    BYTE 0
    
    ; Projectile Object Arrays
    MAX_PROJ        EQU 10
    projX           BYTE MAX_PROJ DUP(0)
    projY           BYTE MAX_PROJ DUP(0)
    projType        BYTE MAX_PROJ DUP(0) ; 0=None, 1=Fire(R), 2=Blue(B)
    projDir         SBYTE MAX_PROJ DUP(1); 1=Right, -1=Left
    projDist        BYTE MAX_PROJ DUP(0) ; Distance traveled
    
    ; ASCII Characters
    charFire        BYTE 15         
    charBlue        BYTE 233       
    
    ; HUD strings for ammo
    strFireAmmo     BYTE " FIRE: ",0
    strBlueAmmo     BYTE " BLUE: ",0
    marioFacing SBYTE 1

    ;temporary msg
    buildingMsg BYTE "          BUILDING IN PROGRESS...",0


.code
main PROC
    call LoadHighScores
    call InitAudioSystem
    call InputPlayerNameScreen
    call DisplayMenu
    
    menuLoop:
        call GetMenuSelection
        
        cmp menuChoice, 1
        je showLevelMenu
        
        cmp menuChoice, 2
        je showHighScores
        
        cmp menuChoice, 3
        je showInstructions
        
        cmp menuChoice, 4
        je exitProgram
        
        jmp menuLoop
    
    showLevelMenu:
        call DisplayLevelMenu
        call GetLevelSelection
        
        cmp levelChoice, 5
        je returnToMain
        
        mov al, levelChoice
        mov currentLevel, al
        call StartGameplay
        
        call UpdateHighScores
        call SaveHighScores
        
    returnToMain:
        call DisplayMenu
        jmp menuLoop
    
    showHighScores:
        call DisplayHighScoresActual
        call DisplayMenu
        jmp menuLoop
    
    showInstructions:
        call DisplayInstructions
        call DisplayMenu
        jmp menuLoop
    
    exitProgram:
        call closeAudioSystem
        exit
main ENDP

DisplayMenu PROC
    call PlayMenuMusic
    call Clrscr
    mov eax, red + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET menuTitle1
    call WriteString
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET menuTitle2
    call WriteString
    mov eax, red + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET menuTitle3
    call WriteString
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET menuTitle4
    call WriteString
    mov eax, red + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET menuTitle5
    call WriteString
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 10
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET menuTitle6
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET rollNumber
    call WriteString
    mov dl, 0
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET divider
    call WriteString
    
    call DrawMenuOptions
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET divider
    call WriteString
    mov dl, 0
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET navPrompt
    call WriteString
    ret
DisplayMenu ENDP

DrawMenuOptions PROC
    cmp menuChoice, 1
    jne option1Normal
    mov eax, green + (black * 16)
    jmp option1Draw
    option1Normal:
    mov eax, yellow + (black * 16)
    option1Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET menuOption1
    call WriteString
    
    cmp menuChoice, 2
    jne option2Normal
    mov eax, green + (black * 16)
    jmp option2Draw
    option2Normal:
    mov eax, yellow + (black * 16)
    option2Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET menuOption2
    call WriteString
    
    cmp menuChoice, 3
    jne option3Normal
    mov eax, green + (black * 16)
    jmp option3Draw
    option3Normal:
    mov eax, yellow + (black * 16)
    option3Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET menuOption3
    call WriteString
    
    cmp menuChoice, 4
    jne option4Normal
    mov eax, green + (black * 16)
    jmp option4Draw
    option4Normal:
    mov eax, yellow + (black * 16)
    option4Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET menuOption4
    call WriteString
    ret
DrawMenuOptions ENDP

GetMenuSelection PROC
    menuInputLoop:
        call ReadKey
        jz menuInputLoop
        cmp al, 0
        je checkExtendedKey
        cmp al, 'w'
        je moveMenuUp
        cmp al, 'W'
        je moveMenuUp
        cmp al, 's'
        je moveMenuDown
        cmp al, 'S'
        je moveMenuDown
        cmp al, 13
        je menuSelected
        jmp menuInputLoop
    checkExtendedKey:
        cmp ah, 48h
        je moveMenuUp
        cmp ah, 50h
        je moveMenuDown
        jmp menuInputLoop
    moveMenuUp:
        dec menuChoice
        cmp menuChoice, 0
        jne updateMenu
        mov menuChoice, 4
        jmp updateMenu
    moveMenuDown:
        inc menuChoice
        cmp menuChoice, 5
        jne updateMenu
        mov menuChoice, 1
        jmp updateMenu
    updateMenu:
        call PlayMenuMoveSound
        call DrawMenuOptions
        jmp menuInputLoop
    menuSelected:
        call PlayMenuSelectSound
        ret
GetMenuSelection ENDP

DisplayLevelMenu PROC
    call Clrscr
    mov levelChoice, 1
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET levelTitle
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET divider
    call WriteString
    call DrawLevelOptions
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET divider
    call WriteString
    mov dl, 0
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET navPrompt
    call WriteString
    ret
DisplayLevelMenu ENDP

DrawLevelOptions PROC
    cmp levelChoice, 1
    jne level1Normal
    mov eax, green + (black * 16)
    jmp level1Draw
    level1Normal:
    mov eax, yellow + (black * 16)
    level1Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET levelOption1
    call WriteString
    cmp levelChoice, 2
    jne level2Normal
    mov eax, green + (black * 16)
    jmp level2Draw
    level2Normal:
    mov eax, yellow + (black * 16)
    level2Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET levelOption2
    call WriteString
    cmp levelChoice, 3
    jne level3Normal
    mov eax, green + (black * 16)
    jmp level3Draw
    level3Normal:
    mov eax, yellow + (black * 16)
    level3Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET levelOption3
    call WriteString
    cmp levelChoice, 4
    jne level4Normal
    mov eax, green + (black * 16)
    jmp level4Draw
    level4Normal:
    mov eax, yellow + (black * 16)
    level4Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET levelOption4
    call WriteString
    cmp levelChoice, 5
    jne level5Normal
    mov eax, green + (black * 16)
    jmp level5Draw
    level5Normal:
    mov eax, yellow + (black * 16)
    level5Draw:
    call SetTextColor
    mov dl, 0
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET levelOption5
    call WriteString
    ret
DrawLevelOptions ENDP

GetLevelSelection PROC
    levelInputLoop:
        call ReadKey
        jz levelInputLoop
        cmp al, 0
        je checkLevelExtendedKey
        cmp al, 'w'
        je moveLevelUp
        cmp al, 'W'
        je moveLevelUp
        cmp al, 's'
        je moveLevelDown
        cmp al, 'S'
        je moveLevelDown
        cmp al, 13
        je levelSelected
        cmp al, 27
        je backToMain
        jmp levelInputLoop
    checkLevelExtendedKey:
        cmp ah, 48h
        je moveLevelUp
        cmp ah, 50h
        je moveLevelDown
        jmp levelInputLoop
    moveLevelUp:
        dec levelChoice
        cmp levelChoice, 0
        jne updateLevel
        mov levelChoice, 5
        jmp updateLevel
    moveLevelDown:
        inc levelChoice
        cmp levelChoice, 6
        jne updateLevel
        mov levelChoice, 1
        jmp updateLevel
    updateLevel:
        call PlayMenuMoveSound
        call DrawLevelOptions
        jmp levelInputLoop
    backToMain:
        mov levelChoice, 5
    levelSelected:
        call PlayMenuSelectSound
        ret
GetLevelSelection ENDP

DisplayInstructions PROC
    call Clrscr
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET instructionTitle
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET instruction1
    call WriteString
    mov dl, 0
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET instruction2
    call WriteString
    mov dl, 0
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET instruction3
    call WriteString
    mov dl, 0
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET instruction4
    call WriteString
    mov dl, 0
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET instruction5
    call WriteString
    mov dl, 0
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET instruction6
    call WriteString
    mov dl, 0
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET instruction7
    call WriteString
    waitForEscape:
        call ReadKey
        jz waitForEscape
        cmp al, 27
        jne waitForEscape
    ret
DisplayInstructions ENDP

DisplayHighScores PROC
    call Clrscr
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET highScoreTitle
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET highScoreMsg
    call WriteString
    mov dl, 0
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET returnMsg
    call WriteString
    waitForEscape2:
        call ReadKey
        jz waitForEscape2
        cmp al, 27
        jne waitForEscape2
    ret
DisplayHighScores ENDP

StartGameplay PROC
    mov al, currentLevel
    cmp al, 1
    je runLevel1
    cmp al, 2
    je runLevel2
    cmp al, 3
    je runLevel3
    cmp al, 4
    je runLevel4
    ret
    
runLevel1:
    call Level1Gameplay
    ret
runLevel2:
    call Level2Gameplay
    ret
runLevel3:
    call Level3Gameplay
    ret
runLevel4:
    call Level4Gameplay
    ret
StartGameplay ENDP

Level1Gameplay PROC
    resetGame:
    call Clrscr
    mov gameAction, 0
    mov lives, 3
    mov score, 0
    mov levelScreen, 1
    mov xPos, 5
    mov yPos, 23
    mov prevXPos, 5
    mov prevYPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    mov isJumping, 0
    
    mov gameTimer, 120
    mov timerTick, 0
    mov levelComplete, 0
    mov enemiesDefeated, 0

    mov hasSpringMushroom, 0       
    mov springMushroomCollected, 0
    mov springMushroomTimer, 0
    
    mov cheatIndex, 0
    ; Preserve cheat ammo if cheat was activated via player name
    cmp cheatActive, 1
    jne resetAmmoToZero
    mov al, 5
    mov fireballAmmo, al
    mov blueballAmmo, al
    jmp doneAmmoReset
    resetAmmoToZero:
    mov fireballAmmo, 0
    mov blueballAmmo, 0
    doneAmmoReset:
    
    mov ecx, MAX_PROJ
    mov esi, 0
    resetProjLoop:
        mov projType[esi], 0
        inc esi
    loop resetProjLoop

    mov ecx, totalCoins
    mov esi, 0
    resetCoinLoop:
        lea ebx, coinCollected
        add ebx, esi
        mov byte ptr [ebx], 0
        inc esi
        loop resetCoinLoop
        
    mov esi, 0
    resetEnemyLoop:
        cmp esi, 5
        jge doneEnemyReset
        lea ebx, enemyAlive
        mov byte ptr [ebx + esi], 1
        inc esi
        jmp resetEnemyLoop
    doneEnemyReset:
    
    mov coinsCollected, 0
    mov score, 0
    mov invincibleTimer, 0
    call Randomize
    call PlayLevel1Music
    call DrawHUD
    call DrawLevel
    call DrawMario
    call DrawEnemies

    gameLoop:
    mov al, xPos
    mov prevXPos, al
    mov al, yPos
    mov prevYPos, al
    
    call HandleInput

    cmp gameAction, 1   
    je resetGame
    cmp gameAction, 2   
    je exitGame

    call ApplyPhysics
    call UpdateMario
    
    call EraseProjectiles
    call UpdateProjectiles

    cmp invincibleTimer, 0
    jle skipTimerDec
    dec invincibleTimer
    skipTimerDec:
    
    call UpdateEnemies
    call CheckEnemyCollision
    cmp lives, 0
    je triggerGameOver

    call CheckScreenTransition
    call CheckCoinCollection
    call CheckSpringMushroomCollection

    call CheckFlagCollision
    cmp levelComplete, 1
    je levelWin

    call EraseMario
    call EraseEnemies
    
    call RedrawStaticElements
    call DrawCoins
    call DrawSpringMushroom
    
    call DrawFlag

    call DrawEnemies
    call DrawMario
    call DrawProjectiles
    
    call DrawHUD

    mov eax, 30
    call Delay
    
    inc timerTick
    cmp timerTick, 33
    jl skipTimeUpdate
    mov timerTick, 0
    dec gameTimer

    cmp springMushroomTimer, 0
    jle checkGameTimerEnd
    dec springMushroomTimer
    cmp springMushroomTimer, 0
    jg checkGameTimerEnd
    mov hasSpringMushroom, 0

    checkGameTimerEnd:
    cmp gameTimer, 0
    je triggerGameOver
    skipTimeUpdate:

    jmp gameLoop

    levelWin:
        call DisplayLevelComplete
        ret

    triggerGameOver:
        call DisplayGameOver
        ret
    exitGame:
        ret
Level1Gameplay ENDP

PauseMenu PROC
    call Clrscr
    mov pauseChoice, 1
    
    drawPauseLoop:
        ; Draw Title
        mov eax, red + (black * 16)
        call SetTextColor
        mov dl, 0
        mov dh, 8
        call Gotoxy
        mov edx, OFFSET pauseTitle
        call WriteString
        
        ; Draw Option 1 - Resume
        cmp pauseChoice, 1
        jne pOpt1Normal
        mov eax, green + (black * 16)
        jmp pOpt1Draw
        pOpt1Normal:
        mov eax, white + (black * 16)
        pOpt1Draw:
        call SetTextColor
        mov dl, 0
        mov dh, 10
        call Gotoxy
        mov edx, OFFSET pauseOpt1
        call WriteString

        ; Draw Option 2 - Shop
        cmp pauseChoice, 2
        jne pOpt2Normal
        mov eax, green + (black * 16)
        jmp pOpt2Draw
        pOpt2Normal:
        mov eax, white + (black * 16)
        pOpt2Draw:
        call SetTextColor
        mov dl, 0
        mov dh, 11
        call Gotoxy
        mov edx, OFFSET pauseOpt4
        call WriteString

        ; Draw Option 3 - Restart
        cmp pauseChoice, 3
        jne pOpt3Normal
        mov eax, green + (black * 16)
        jmp pOpt3Draw
        pOpt3Normal:
        mov eax, white + (black * 16)
        pOpt3Draw:
        call SetTextColor
        mov dl, 0
        mov dh, 12
        call Gotoxy
        mov edx, OFFSET pauseOpt2
        call WriteString

        ; Draw Option 4 - Exit to Main
        cmp pauseChoice, 4
        jne pOpt4Normal
        mov eax, green + (black * 16)
        jmp pOpt4Draw
        pOpt4Normal:
        mov eax, white + (black * 16)
        pOpt4Draw:
        call SetTextColor
        mov dl, 0
        mov dh, 13
        call Gotoxy
        mov edx, OFFSET pauseOpt3
        call WriteString

        ; Input Handling
        call ReadChar
        cmp al, 'w'
        je pUp
        cmp al, 'W'
        je pUp
        cmp al, 's'
        je pDown
        cmp al, 'S'
        je pDown
        cmp al, 13 
        je pSelect
        jmp drawPauseLoop

    pUp:
        dec pauseChoice
        cmp pauseChoice, 0
        jne pUpSound
        mov pauseChoice, 4
    pUpSound:
        call PlayMenuMoveSound
        jmp drawPauseLoop

    pDown:
        inc pauseChoice
        cmp pauseChoice, 5
        jne pDownSound
        mov pauseChoice, 1
    pDownSound:
        call PlayMenuMoveSound
        jmp drawPauseLoop

    pSelect:
        call PlayMenuSelectSound
        
        cmp pauseChoice, 1
        je resumeGame
        cmp pauseChoice, 2
        je openShop
        cmp pauseChoice, 3
        je restartGame
        cmp pauseChoice, 4
        je exitToMain

    openShop:
        call ShopMenu
        jmp drawPauseLoop

    resumeGame:
        call Clrscr
        call DrawHUD
        call DrawLevel
        call DrawCoins
        call DrawSpringMushroom
        call DrawFlag
        call DrawEnemies
        call DrawMario
        mov gameAction, 0
        ret

    restartGame:
        mov gameAction, 1
        ret

    exitToMain:
        mov gameAction, 2
        ret
PauseMenu ENDP

ShopMenu PROC
    pushad
    
    shopLoop:
    call Clrscr
    
    ; Calculate shop tokens = score / 200
    mov eax, score
    mov ebx, 200
    xor edx, edx
    div ebx
    mov shopTokens, eax
    
    ; Draw Shop Title
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET shopTitle
    call WriteString
    
    ; Draw current tokens
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET shopTokensStr
    call WriteString
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov eax, shopTokens
    call WriteDec
    
    ; Draw Option 1 - Buy Life
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET shopOpt1
    call WriteString
    
    ; Draw Option 2 - Buy Red Shots
    mov dl, 0
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET shopOpt2
    call WriteString
    
    ; Draw Back Option
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET shopOptBack
    call WriteString
    
    ; Wait for input
    call ReadChar
    
    cmp al, '1'
    je buyLife
    cmp al, '2'
    je buyRedShots
    cmp al, 27
    je exitShop
    jmp shopLoop
    
    buyLife:
        ; Check if enough tokens (8 required)
        cmp shopTokens, 8
        jl notEnoughTokens
        ; Deduct 1600 points (8 tokens * 200)
        mov eax, 1600
        sub score, eax
        ; Add 1 life
        inc lives
        ; Play purchase sound
        call PlayShopBuySound
        ; Show success message
        mov eax, lightGreen + (black * 16)
        call SetTextColor
        mov dl, 0
        mov dh, 14
        call Gotoxy
        mov edx, OFFSET shopMsgBought
        call WriteString
        mov eax, 1000
        call Delay
        jmp shopLoop
    
    buyRedShots:
        ; Check if enough tokens (13 required)
        cmp shopTokens, 13
        jl notEnoughTokens
        ; Deduct 2600 points (13 tokens * 200)
        mov eax, 2600
        sub score, eax
        ; Add 2 red projectiles to fireballAmmo
        add fireballAmmo, 2
        ; Play purchase sound
        call PlayShopBuySound
        ; Show success message
        mov eax, lightGreen + (black * 16)
        call SetTextColor
        mov dl, 0
        mov dh, 14
        call Gotoxy
        mov edx, OFFSET shopMsgBought
        call WriteString
        mov eax, 1000
        call Delay
        jmp shopLoop
    
    notEnoughTokens:
        mov eax, lightRed + (black * 16)
        call SetTextColor
        mov dl, 0
        mov dh, 14
        call Gotoxy
        mov edx, OFFSET shopMsgNoFunds
        call WriteString
        mov eax, 1000
        call Delay
        jmp shopLoop
    
    exitShop:
    call Clrscr
    popad
    ret
ShopMenu ENDP

DrawHUD PROC
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
    jg showFireAmmo
    cmp cheatActive, 1
    jne skipCheatHud
    
    showFireAmmo:
    mov dl, 30
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strFireAmmo
    call WriteString
    movzx eax, fireballAmmo
    call WriteDec
    
    ; Show blue ammo only if cheat is active
    cmp cheatActive, 1
    jne skipCheatHud
    
    mov edx, OFFSET strBlueAmmo
    call WriteString
    movzx eax, blueballAmmo
    call WriteDec
    jmp drawTimer
    
    skipCheatHud:
    mov dl, 35
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strLevel
    call WriteString
    
    drawTimer:
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
DrawHUD ENDP

DrawLevel PROC
    push eax
    push edx
    push ecx
    call DrawGround
    call DrawPlatforms
    call DrawPipes
    call DrawCoins
    pop ecx
    pop edx
    pop eax
    ret
DrawLevel ENDP

DrawPipes PROC
    push eax
    push ebx
    push ecx
    push edx
    cmp levelScreen, 2
    je skipAllPipes
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    movzx ecx, pipe1Height
    mov bl, pipe1Y
    drawPipe1Loop:
        mov dl, pipe1X
        mov dh, bl
        call Gotoxy
        mov edx, OFFSET pipe1
        call WriteString
        inc bl
        loop drawPipe1Loop
    movzx ecx, pipe2Height
    mov bl, pipe2Y
    drawPipe2Loop:
        mov dl, pipe2X
        mov dh, bl
        call Gotoxy
        mov edx, OFFSET pipe2
        call WriteString
        inc bl
        loop drawPipe2Loop
    movzx ecx, pipe3Height
    mov bl, pipe3Y
    drawPipe3Loop:
        mov dl, pipe3X
        mov dh, bl
        call Gotoxy
        mov edx, OFFSET pipe3
        call WriteString
        inc bl
        loop drawPipe3Loop
    skipAllPipes:
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret
DrawPipes ENDP

RedrawStaticElements PROC
    push eax
    push edx
    push ebx
    mov al, prevYPos
    cmp al, 24
    jne checkPlat1Redraw
    mov eax, green + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, 24
    call Gotoxy
    mov al, '='
    call WriteChar
    checkPlat1Redraw:
    mov al, prevYPos
    mov bl, plat1Y
    cmp al, bl
    jne checkPlat2Redraw
    mov al, prevXPos
    cmp al, plat1XStart
    jl checkPlat2Redraw
    cmp al, plat1XEnd
    jg checkPlat2Redraw
    mov eax, green + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, plat1Y
    call Gotoxy
    mov al, '='
    call WriteChar
    checkPlat2Redraw:
    mov al, prevYPos
    mov bl, plat2Y
    cmp al, bl
    jne checkPipesRedraw
    mov al, prevXPos
    cmp al, plat2XStart
    jl checkPipesRedraw
    cmp al, plat2XEnd
    jg checkPipesRedraw
    mov eax, green + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, plat2Y
    call Gotoxy
    mov al, '='
    call WriteChar    
    checkPipesRedraw:
    call RedrawPipes
    doneRedraw:
    pop ebx
    pop edx
    pop eax
    ret
RedrawStaticElements ENDP

RedrawPipes PROC
    push eax
    push ebx
    push edx
    cmp levelScreen, 2
    je donePipeRedraw
    mov al, prevXPos
    cmp al, pipe1X
    je checkPipe1Y
    inc al
    cmp al, pipe1X
    jne checkPipe2
    checkPipe1Y:
    mov al, prevYPos
    cmp al, 22
    jl checkPipe2
    cmp al, 23
    jg checkPipe2
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, pipe1X
    mov dh, prevYPos
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dl
    call Gotoxy
    call WriteChar
    checkPipe2:
    mov al, prevXPos
    cmp al, pipe2X
    je checkPipe2Y
    inc al
    cmp al, pipe2X
    jne checkPipe3
    checkPipe2Y:
    mov al, prevYPos
    cmp al, 21
    jl checkPipe3
    cmp al, 23
    jg checkPipe3
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, pipe2X
    mov dh, prevYPos
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dl
    call Gotoxy
    call WriteChar
    checkPipe3:
    mov al, prevXPos
    cmp al, pipe3X
    je checkPipe3Y
    inc al
    cmp al, pipe3X
    jne donePipeRedraw
    checkPipe3Y:
    mov al, prevYPos
    cmp al, 22
    jl donePipeRedraw
    cmp al, 23
    jg donePipeRedraw
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov dl, pipe3X
    mov dh, prevYPos
    call Gotoxy
    mov al, '|'
    call WriteChar
    inc dl
    call Gotoxy
    call WriteChar
    donePipeRedraw:
    pop edx
    pop ebx
    pop eax
    ret
RedrawPipes ENDP

EraseMario PROC
    push eax
    push edx
    mov eax, black + (black * 16)
    call SetTextColor
    mov dl, prevXPos
    mov dh, prevYPos
    call Gotoxy
    mov al, ' '
    call WriteChar
    pop edx
    pop eax
    ret
EraseMario ENDP

ApplyPhysics PROC
    push eax
    cmp isOnGround, 1
    je skipGravity
    mov al, velocityY
    add al, gravity
    cmp al, maxFallSpeed
    jle velocityOK
    mov al, maxFallSpeed
    velocityOK:
    mov velocityY, al
    skipGravity:
    pop eax
    ret
ApplyPhysics ENDP

CheckPipeCollisionHorizontal PROC
    push ebx
    push ecx
    cmp levelScreen, 2
    je noPipeCollisionH
    mov al, yPos
    cmp al, 22
    jl noPipeCollisionH
    cmp al, 23
    jg noPipeCollisionH
    mov al, xPos
    cmp al, pipe1X
    jl checkPipe2CollH
    mov bl, pipe1X
    inc bl
    cmp al, bl
    jg checkPipe2CollH
    mov al, 1
    jmp pipeCollisionDoneH
    checkPipe2CollH:
    mov al, xPos
    cmp al, pipe2X
    jl checkPipe3CollH
    mov bl, pipe2X
    inc bl
    cmp al, bl
    jg checkPipe3CollH
    mov al, 1
    jmp pipeCollisionDoneH
    checkPipe3CollH:
    mov al, xPos
    cmp al, pipe3X
    jl noPipeCollisionH
    mov bl, pipe3X
    inc bl
    cmp al, bl
    jg noPipeCollisionH
    mov al, 1
    jmp pipeCollisionDoneH
    noPipeCollisionH:
    mov al, 0
    pipeCollisionDoneH:
    pop ecx
    pop ebx
    ret
CheckPipeCollisionHorizontal ENDP

CheckMarioPlatformCollision PROC
    push ebx
    mov al, xPos
    cmp al, plat2XStart
    jl checkP1_Mario
    cmp al, plat2XEnd
    jg checkP1_Mario
    mov al, yPos
    mov bl, plat2Y
    dec bl
    cmp al, bl
    jl checkP1_Mario
    mov al, plat2Y
    dec al
    mov yPos, al
    mov velocityY, 0
    mov isOnGround, 1
    mov al, 1
    jmp donePlatColl_Mario
checkP1_Mario:
    mov al, xPos
    cmp al, plat1XStart
    jl noPlatColl_Mario
    cmp al, plat1XEnd
    jg noPlatColl_Mario
    mov al, yPos
    mov bl, plat1Y
    dec bl
    cmp al, bl
    jl noPlatColl_Mario
    mov al, plat1Y
    dec al
    mov yPos, al
    mov velocityY, 0
    mov isOnGround, 1
    mov al, 1
    jmp donePlatColl_Mario
noPlatColl_Mario:
    mov al, 0
donePlatColl_Mario:
    pop ebx
    ret
CheckMarioPlatformCollision ENDP

UpdateMario PROC
    push eax
    push ebx
    mov al, yPos
    movsx ebx, velocityY
    add al, bl
    cmp al, minY
    jge topBoundaryOK
    mov al, minY
    mov velocityY, 0
topBoundaryOK:
    mov yPos, al
    movsx eax, velocityY
    cmp eax, 0
    jle checkGroundOnly
    call CheckPipeTopCollision
    cmp al, 1
    je doneUpdate
    call CheckMarioPlatformCollision
    cmp al, 1
    je doneUpdate
checkGroundOnly:
    mov al, yPos
    cmp al, 23
    jl inAir
    mov yPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    jmp doneUpdate
inAir:
    mov isOnGround, 0
doneUpdate:
    pop ebx
    pop eax
    ret
UpdateMario ENDP

CheckPipeTopCollision PROC
    push ebx
    push ecx
    cmp levelScreen, 2
    je noPipeTopColl
    cmp velocityY, 0
    jle noPipeTopColl
    mov al, xPos
    cmp al, pipe1X
    jl checkPipe2Top
    mov bl, pipe1X
    inc bl
    cmp al, bl
    jg checkPipe2Top
    mov al, yPos
    mov bl, pipe1Y
    dec bl
    cmp al, bl
    jl checkPipe2Top
    mov yPos, bl
    mov velocityY, 0
    mov isOnGround, 1
    mov al, 1
    jmp pipeTopDone
    checkPipe2Top:
    mov al, xPos
    cmp al, pipe2X
    jl checkPipe3Top
    mov bl, pipe2X
    inc bl
    cmp al, bl
    jg checkPipe3Top
    mov al, yPos
    mov bl, pipe2Y
    dec bl
    cmp al, bl
    jl checkPipe3Top
    mov yPos, bl
    mov velocityY, 0
    mov isOnGround, 1
    mov al, 1
    jmp pipeTopDone
    checkPipe3Top:
    mov al, xPos
    cmp al, pipe3X
    jl noPipeTopColl
    mov bl, pipe3X
    inc bl
    cmp al, bl
    jg noPipeTopColl
    mov al, yPos
    mov bl, pipe3Y
    dec bl
    cmp al, bl
    jl noPipeTopColl
    mov yPos, bl
    mov velocityY, 0
    mov isOnGround, 1
    mov al, 1
    jmp pipeTopDone
    noPipeTopColl:
    mov al, 0
    pipeTopDone:
    pop ecx
    pop ebx
    ret
CheckPipeTopCollision ENDP

DrawCoins PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov esi, 0
    mov ecx, totalCoins
    drawLoop:
        lea ebx, coinCollected
        cmp byte ptr [ebx + esi], 1
        je skipDraw
        lea ebx, coinXPos
        mov dl, byte ptr [ebx + esi]
        lea ebx, coinYPos
        mov dh, byte ptr [ebx + esi]
        push ecx
        call Gotoxy
        mov al, 'O'
        call WriteChar
        pop ecx
    skipDraw:
        inc esi
        loop drawLoop
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawCoins ENDP

CheckCoinCollection PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    movzx edx, xPos
    movzx eax, yPos
    mov esi, 0
    
    checkLoop:
        cmp esi, 13
        jge doneCoinCheck
        
        lea ebx, coinCollected
        cmp byte ptr [ebx + esi], 1
        je skipCoin
        
        ; Exact X position match
        lea ebx, coinXPos
        movzx ebx, byte ptr [ebx + esi]
        cmp edx, ebx
        jne skipCoin
        
        ; Exact Y position match
        lea ebx, coinYPos
        movzx ebx, byte ptr [ebx + esi]
        cmp eax, ebx
        jne skipCoin
        
        lea ebx, coinCollected
        mov byte ptr [ebx + esi], 1

        call PlayCoinSound        
        push eax
        push edx
        mov eax, coinValue
        add score, eax
        pop edx
        pop eax
        inc coinsCollected
        
    skipCoin:
        inc esi
        jmp checkLoop
    
    doneCoinCheck:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CheckCoinCollection ENDP

HandleInput PROC
    push eax
    push ebx
    call ReadKey
    jz noInput
    cmp al, 0
    je checkArrowKeys
    push eax
    or al, 20h
    mov esi, cheatIndex
    lea ebx, cheatStrMatch
    mov cl, [ebx + esi]
    cmp al, cl
    jne resetCheatIndex
    inc cheatIndex
    cmp cheatIndex, 5
    jne continueInput
    mov cheatActive, 1
    mov cheatIndex, 0
    mov al, 5
    mov fireballAmmo, al
    mov blueballAmmo, al
    jmp continueInput
    resetCheatIndex:
    cmp al, 'c'
    je setIndexOne
    mov cheatIndex, 0
    jmp continueInput
    setIndexOne:
    mov cheatIndex, 1
    continueInput:
    pop eax
    cmp al, 'p'
    je triggerPause
    cmp al, 'P'
    je triggerPause
    ; Check if player can fire red projectiles (from shop or cheat)
    cmp fireballAmmo, 0
    jg canFireRed
    cmp cheatActive, 1
    jne standardControls
    canFireRed:
    cmp al, 'r'
    je attemptFireShot
    cmp al, 'R'
    je attemptFireShot
    ; Blue shots only available with cheat active
    cmp cheatActive, 1
    jne standardControls
    cmp al, 'b'
    je attemptBlueShot
    cmp al, 'B'
    je attemptBlueShot
    jmp standardControls
    attemptFireShot:
        cmp fireballAmmo, 0
        jle standardControls
        dec fireballAmmo
        mov cl, 1
        call SpawnProjectile
        jmp noInput
    attemptBlueShot:
        cmp blueballAmmo, 0
        jle standardControls
        dec blueballAmmo
        mov cl, 2
        call SpawnProjectile
        jmp noInput
    standardControls:
    cmp al, 'a'
    je moveLeft
    cmp al, 'A'
    je moveLeft
    cmp al, 'd'
    je moveRight
    cmp al, 'D'
    je moveRight
    cmp al, 'w'
    je tryJump
    cmp al, 'W'
    je tryJump
    cmp al, 'x'
    je exitToMenu
    cmp al, 'X'
    je exitToMenu
    cmp al, 27
    je exitToMenu
    jmp noInput
    checkArrowKeys:
        cmp ah, 4Bh
        je moveLeft
        cmp ah, 4Dh
        je moveRight
        cmp ah, 48h
        je tryJump
        jmp noInput
    triggerPause:
        call PauseMenu
        jmp noInput
    moveLeft:
        mov marioFacing, -1
        mov bl, xPos
        mov al, xPos
        cmp al, minX
        jle noInput
        dec xPos
        call CheckPipeCollisionHorizontal
        cmp al, 1
        je restoreLeft
        jmp noInput
    restoreLeft:
        mov xPos, bl
        jmp noInput
    moveRight:
        mov marioFacing, 1
        mov bl, xPos
        mov al, xPos
        cmp al, maxX
        jge noInput
        inc xPos
        call CheckPipeCollisionHorizontal
        cmp al, 1
        je restoreRight
        jmp noInput
    restoreRight:
        mov xPos, bl
        jmp noInput
    tryJump:
    cmp isOnGround, 1
    je doNormalJump
    cmp doubleJumpAvailable, 1
    je doDoubleJump
    jmp noInput
doNormalJump:
    mov doubleJumpAvailable, 1
    jmp performJump
doDoubleJump:
    mov doubleJumpAvailable, 0
    jmp performJump
performJump:
    movzx eax, yPos
    cmp al, 23
    je jumpFromGround
    jmp jumpFromPlatform
jumpFromGround:
    cmp hasSpringMushroom, 1
    je springJumpGround
    movsx eax, normalJumpPower
    mov velocityY, al
    jmp finishJump
springJumpGround:
    movsx eax, enhancedJumpPower
    mov velocityY, al
    jmp finishJump
jumpFromPlatform:
    cmp hasSpringMushroom, 1
    je springJumpPlatform
    mov al, -3
    mov velocityY, al
    jmp finishJump
springJumpPlatform:
    mov al, -5
    mov velocityY, al
    jmp finishJump
finishJump:
    mov isOnGround, 0
    mov isJumping, 1
    call PlayJumpSound
    jmp noInput
    exitToMenu:
        mov gameAction, 2
        pop ebx
        pop eax
        ret
    noInput:
    pop ebx
    pop eax
    ret
HandleInput ENDP

DrawPlatforms PROC
    push eax
    push edx
    mov eax, green + (black * 16)
    call SetTextColor
    mov dl, plat1XStart
    mov dh, plat1Y
    call Gotoxy
    mov edx, OFFSET platform1
    call WriteString
    mov dl, plat2XStart
    mov dh, plat2Y
    call Gotoxy
    mov edx, OFFSET platform2
    call WriteString
    pop edx
    pop eax
    ret
DrawPlatforms ENDP

DrawGround PROC
    push eax
    push edx
    mov eax, green + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov edx, OFFSET ground
    call WriteString
    pop edx
    pop eax
    ret
DrawGround ENDP

CheckScreenTransition PROC
    push eax
    push ebx
    push ecx
    push esi
    cmp levelScreen, 2
    je noTransition
    movzx eax, xPos
    cmp al, 75
    jl noTransition
    mov levelScreen, 2
    mov xPos, 5
    mov yPos, 23
    mov velocityY, 0
    mov isOnGround, 1
    mov doubleJumpAvailable, 1
    mov springMushroomCollected, 0
    mov hasSpringMushroom, 0
    mov springMushroomTimer, 0
    mov ecx, 10
    mov esi, 0
    resetCoinsLoop:
        lea ebx, coinCollected
        mov byte ptr [ebx + esi], 0
        inc esi
        loop resetCoinsLoop
        mov byte ptr [ebx+10], 1
        mov byte ptr [ebx+11], 1
        mov byte ptr [ebx+12], 1

    call Clrscr
    call DrawHUD
    call DrawGround
    call DrawPlatforms
    call DrawCoins
    call DrawSpringMushroom
    call DrawEnemies
    call DrawMario
noTransition:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
CheckScreenTransition ENDP

DrawMario PROC
    push eax
    push edx
    mov eax, blue + (black * 16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, 'M'
    call WriteChar
    pop edx
    pop eax
    ret
DrawMario ENDP

DrawSpringMushroom PROC
    push eax
    push edx
    cmp levelScreen, 2
    jne skipMushroom
    cmp springMushroomCollected, 1
    je skipMushroom
    mov eax, green + (black * 16)
    call SetTextColor
    mov dl, springMushroomX
    mov dh, springMushroomY
    call Gotoxy
    mov al, 'S'
    call WriteChar
skipMushroom:
    pop edx
    pop eax
    ret
DrawSpringMushroom ENDP

CheckSpringMushroomCollection PROC
    push eax
    push ebx
    push edx
    
    cmp levelScreen, 2
    jne noMushroomCollect
    cmp springMushroomCollected, 1
    je noMushroomCollect
    
    movzx eax, xPos
    movzx ebx, yPos
    cmp al, springMushroomX
    jne noMushroomCollect
    cmp bl, springMushroomY
    jne noMushroomCollect
    
    mov springMushroomCollected, 1
    mov hasSpringMushroom, 1
    mov springMushroomTimer, 7
    
    push eax
    mov eax, 300
    add score, eax
    pop eax
    
noMushroomCollect:
    pop edx
    pop ebx
    pop eax
    ret
CheckSpringMushroomCollection ENDP

UpdateEnemies PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov esi, 0
    updateEnemyLoop:
        cmp esi, 5
        jge doneUpdateEnemies
        lea ebx, enemyAlive
        cmp byte ptr [ebx + esi], 0
        je skipUpdateEnemy
        lea ebx, enemyScreen
        movzx eax, byte ptr [ebx + esi]
        movzx ecx, levelScreen
        cmp al, cl
        jne skipUpdateEnemy
        lea ebx, enemyXPos
        mov al, byte ptr [ebx + esi]
        lea ebx, enemyPrevXPos
        mov byte ptr [ebx + esi], al
        lea ebx, enemyDirection
        mov cl, byte ptr [ebx + esi]
        add al, cl
        push eax
        mov eax, esi
        cmp al, 0
        je bound1
        cmp al, 1
        je bound2
        cmp al, 2
        je bound3
        cmp al, 3
        je bound4
        cmp al, 4
        je bound5
    bound1:
        pop eax
        cmp al, enemy1Left
        jle reverse
        cmp al, enemy1Right
        jge reverse
        jmp savePos
    bound2:
        pop eax
        cmp al, enemy2Left
        jle reverse
        cmp al, enemy2Right
        jge reverse
        jmp savePos
    bound3:
        pop eax
        cmp al, enemy3Left
        jle reverse
        cmp al, enemy3Right
        jge reverse
        jmp savePos
    bound4:
        pop eax
        cmp al, enemy4Left
        jle reverse
        cmp al, enemy4Right
        jge reverse
        jmp savePos
    bound5:
        pop eax
        cmp al, enemy5Left
        jle reverse
        cmp al, enemy5Right
        jge reverse
        jmp savePos
    reverse:
        lea ebx, enemyDirection
        mov cl, byte ptr [ebx + esi]
        neg cl
        mov byte ptr [ebx + esi], cl
        lea ebx, enemyPrevXPos
        mov al, byte ptr [ebx + esi]
        jmp savePosFinal
    savePos:
        lea ebx, enemyXPos
        mov byte ptr [ebx + esi], al
        jmp skipUpdateEnemy
    savePosFinal:
        lea ebx, enemyXPos
        mov byte ptr [ebx + esi], al
    skipUpdateEnemy:
        inc esi
        jmp updateEnemyLoop
    doneUpdateEnemies:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
UpdateEnemies ENDP

EraseEnemies PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov esi, 0
    eraseEnemyLoop:
        cmp esi, 5
        jge doneEraseEnemies
        ; Check screen first (applies to both alive and dead enemies)
        lea ebx, enemyScreen
        movzx eax, byte ptr [ebx + esi]
        movzx ecx, levelScreen
        cmp al, cl
        jne skipEraseEnemy
        ; Always erase at previous position to fix ghosting
        lea ebx, enemyPrevXPos
        mov dl, byte ptr [ebx + esi]
        lea ebx, enemyYPos
        mov dh, byte ptr [ebx + esi]
        call Gotoxy
        mov al, ' '
        call WriteChar
    skipEraseEnemy:
        inc esi
        jmp eraseEnemyLoop
    doneEraseEnemies:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
EraseEnemies ENDP

DrawEnemies PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov eax, red + (black * 16)
    call SetTextColor
    mov esi, 0
    drawEnemyLoop:
        cmp esi, 5
        jge doneDrawEnemies
        lea ebx, enemyAlive
        cmp byte ptr [ebx + esi], 0
        je skipDrawEnemy
        lea ebx, enemyScreen
        movzx eax, byte ptr [ebx + esi]
        movzx ecx, levelScreen
        cmp al, cl
        jne skipDrawEnemy
        lea ebx, enemyXPos
        mov dl, byte ptr [ebx + esi]
        lea ebx, enemyYPos
        mov dh, byte ptr [ebx + esi]
        call Gotoxy
        mov al, 178
        call WriteChar
    skipDrawEnemy:
        inc esi
        jmp drawEnemyLoop
    doneDrawEnemies:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawEnemies ENDP

CheckEnemyCollision PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov esi, 0
    checkColLoop:
        cmp esi, 5
        jge doneColCheck
        lea ebx, enemyAlive
        cmp byte ptr [ebx + esi], 0
        je nextColEnemy
        lea ebx, enemyScreen
        movzx eax, byte ptr [ebx + esi]
        movzx ecx, levelScreen
        cmp al, cl
        jne nextColEnemy
        lea ebx, enemyXPos
        mov dl, byte ptr [ebx + esi]
        mov al, xPos
        sub al, dl
        cmp al, 0
        jge absX
        neg al
    absX:
        cmp al, 2
        jg nextColEnemy
        lea ebx, enemyYPos
        mov dh, byte ptr [ebx + esi]
        mov al, yPos
        cmp al, dh
        jne nextColEnemy
        mov al, prevYPos
        cmp al, dh
        jl isStompCollision
        cmp invincibleTimer, 0
        jg nextColEnemy
        dec lives
        call DrawHUD
        cmp lives, 0
        je doneColCheck
        mov invincibleTimer, 60
        jmp nextColEnemy
    isStompCollision:
        lea ebx, enemyAlive
        mov byte ptr [ebx + esi], 0
        ; --- Increment Defeated Counter ---
        inc enemiesDefeated
        ; ----------------------------------
        mov dl, enemyXPos[esi]
        mov dh, enemyYPos[esi]
        call Gotoxy
        mov al, ' '
        call WriteChar
        mov eax, score
        add eax, 100
        mov score, eax
        call DrawHUD
        mov velocityY, -2
        dec yPos
        mov isOnGround, 0
        jmp nextColEnemy
    nextColEnemy:
        inc esi
        jmp checkColLoop
    doneColCheck:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CheckEnemyCollision ENDP

DrawFlag PROC
    push eax
    push edx
    push ecx
    cmp levelScreen, 2
    jne skipFlagDraw
    mov eax, lightRed + (black * 16)
    call SetTextColor
    mov dl, flagX
    mov dh, flagY
    call Gotoxy
    mov edx, OFFSET flagTop
    call WriteString
    mov ecx, 4
    mov dh, flagY
    inc dh
drawPoleLoop:
    push dx
    mov dl, flagX
    call Gotoxy
    mov edx, OFFSET flagPole
    call WriteString
    pop dx
    inc dh
    loop drawPoleLoop
skipFlagDraw:
    pop ecx
    pop edx
    pop eax
    ret
DrawFlag ENDP

CheckFlagCollision PROC
    push eax
    cmp levelScreen, 2
    jne noFlagCollision
    movzx eax, xPos
    cmp al, flagX
    jl noFlagCollision
    movzx eax, yPos
    cmp al, flagY
    jl noFlagCollision
    mov levelComplete, 1
noFlagCollision:
    pop eax
    ret
CheckFlagCollision ENDP

DisplayLevelComplete PROC
    call Clrscr
    call PlayWinSound
    mov eax, green + (black * 16)
    call SetTextColor
    
    ; Title
    mov dl, 0
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET winTitleStr
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Base Score
    mov dl, 0
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET winBaseScore
    call WriteString
    mov eax, score
    call WriteDec
    
    ; Enemies Defeated
    mov dl, 0
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET winEnemiesStr
    call WriteString
    movzx eax, enemiesDefeated
    call WriteDec
    
    ; Time Bonus Calculation (Time Remaining * 50)
    mov dl, 0
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET winTimeBonus
    call WriteString
    mov eax, gameTimer
    mov ebx, 50
    mul ebx
    push eax  ; Save calculated bonus
    call WriteDec
    
    ; Add Bonus to Score
    pop eax
    add score, eax
    
    ; Final Score
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET winFinalScore
    call WriteString
    mov eax, score
    call WriteDec
    
    ; Exit Message
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET winExitMsg
    call WriteString
    
    call ReadChar
    ret
DisplayLevelComplete ENDP

DisplayGameOver PROC
    call Clrscr

    call PlayGameOverSound
    mov bl, 22
    mov bh, 2
    mov edx, OFFSET art01
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 3
    mov edx, OFFSET art02
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 4
    mov edx, OFFSET art03
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 5
    mov edx, OFFSET art04
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 6
    mov edx, OFFSET art05
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 7
    mov edx, OFFSET art06
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 8
    mov edx, OFFSET art07
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 9
    mov edx, OFFSET art08
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 10
    mov edx, OFFSET art09
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 11
    mov edx, OFFSET art10
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 12
    mov edx, OFFSET art11
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 13
    mov edx, OFFSET art12
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 14
    mov edx, OFFSET art13
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 15
    mov edx, OFFSET art14
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 16
    mov edx, OFFSET art15
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 17
    mov edx, OFFSET art16
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 18
    mov edx, OFFSET art17
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 19
    mov edx, OFFSET art18
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 20
    mov edx, OFFSET art19
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 21
    mov edx, OFFSET art20
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 22
    mov edx, OFFSET art21
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 23
    mov edx, OFFSET art22
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 24
    mov edx, OFFSET art23
    call DrawArtLine
    call Crlf
    mov bl, 22
    mov bh, 25
    mov edx, OFFSET art24
    call DrawArtLine
    call Crlf
    mov eax, white + (black * 16)
    call SetTextColor
    mov dh, 27
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET finalScoreMsg
    call WriteString
    mov eax, score
    call WriteDec
    mov dh, 29
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET restartMsg
    call WriteString
    call ReadChar
    ret
DisplayGameOver ENDP

DrawArtLine PROC
    ; Input: EDX = string offset, BL = start column, BH = row
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov esi, edx
    mov dh, bh      ; Row from BH
    mov bl, bl      ; Column stays in BL
drawCharLoop:
    mov al, [esi]
    cmp al, 0
    je doneDraw
    cmp al, 13
    je skipChar
    cmp al, 10
    je skipChar
    cmp al, 0DBh
    je makeWhite
    cmp al, 0DFh
    je makeWhite
    cmp al, 0DCh
    je makeWhite
    cmp al, 0C5h
    je makeGreen
    cmp al, 0C4h
    je makeGreen
    push eax
    mov eax, white + (black * 16)
    call SetTextColor
    pop eax
    jmp printIt
makeWhite:
    push eax
    mov eax, white + (black * 16)
    call SetTextColor
    pop eax
    mov al, [esi]
    jmp printIt
makeGreen:
    push eax
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    pop eax
    mov al, [esi]
    jmp printIt
printIt:
    push eax
    mov dl, bl
    call Gotoxy
    pop eax
    call WriteChar
    inc bl
skipChar:
    inc esi
    jmp drawCharLoop
doneDraw:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawArtLine ENDP

InputPlayerNameScreen PROC
    call Clrscr
    mov eax, yellow + (black * 16)
    call SetTextColor
GetValidName:
    mov dl, 20
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET namePrompt
    call WriteString
    mov eax, white + (black * 16)
    call SetTextColor
    
    mov edx, OFFSET currentPlayerName
    mov ecx, 20
    call ReadString
    
    cmp eax, 0
    je GetValidName
    cmp byte ptr [currentPlayerName], ' '
    je GetValidName

    
    mov ecx, eax                
    lea esi, currentPlayerName
convertLoop:
    mov al, [esi]
    cmp al, 'a'
    jb nextChar
    cmp al, 'z'
    ja nextChar
    sub byte ptr [esi], 32    
nextChar:
    inc esi
    loop convertLoop

    INVOKE Str_compare, ADDR currentPlayerName, ADDR cheatNameTrigger
    jne notCheatName
    mov cheatActive, 1
    mov al, 5
    mov fireballAmmo, al
    mov blueballAmmo, al
    notCheatName:
    ; ---------------------------------

    ret
InputPlayerNameScreen ENDP

TrimName PROC USES eax ecx esi
    mov ecx, NAME_STRIDE
    add esi, NAME_STRIDE
    dec esi
trimLoop:
    mov al, [esi]
    cmp al, ' '
    jne doneTrim
    mov byte ptr [esi], 0
    dec esi
    loop trimLoop
doneTrim:
    ret
TrimName ENDP

IntToString PROC USES eax ebx ecx edx edi
    mov ecx, 10
    xor bx, bx
    cmp eax, 0
    jne convertLoop
    mov byte ptr [edi], '0'
    inc edi
    mov byte ptr [edi], 0
    ret
convertLoop:
    xor edx, edx
    div ecx
    add dl, '0'
    push dx
    inc bx
    test eax, eax
    jz popLoop
    jmp convertLoop
popLoop:
    pop dx
    mov [edi], dl
    inc edi
    dec bx
    jnz popLoop
    mov byte ptr [edi], 0
    ret
IntToString ENDP

StrToInt PROC USES ebx ecx edx esi
    xor eax, eax
    mov esi, edx
    mov ecx, 10
parseLoop:
    movzx ebx, byte ptr [esi]
    cmp bl, '0'
    jb doneParse
    cmp bl, '9'
    ja doneParse
    sub bl, '0'
    imul eax, ecx
    add eax, ebx
    inc esi
    jmp parseLoop
doneParse:
    ret
StrToInt ENDP

SaveHighScores PROC
    mov edx, OFFSET highScoreFile
    call CreateOutputFile
    mov fileHandle, eax
    
    mov ecx, 5              
    mov edi, 0              
    mov esi, 0              
    
saveLoop:
    push ecx
    push edi
    push esi
    
    ; Write the Name
    lea edx, highScoreNames[edi]
    mov eax, fileHandle
    invoke Str_length, edx  
    mov ecx, eax            
    cmp ecx, 0
    je writePadding        
    
    mov eax, fileHandle
    call WriteToFile        ; Write the actual name

    ; 2. Write Padding Spaces (Total 20 - NameLength)
    lea edx, highScoreNames[edi]
    invoke Str_length, edx
    mov ebx, 20
    sub ebx, eax            ; Calculate remaining spaces
    cmp ebx, 0
    jle writeScore          ; If name is 20+ chars (unlikely), skip padding

    mov ecx, ebx            
writePadding:
    mov eax, fileHandle
    lea edx, spacerStr      
    push ecx
    mov ecx, 1
    call WriteToFile
    pop ecx
    loop writePadding

writeScore:
    ; Convert Score to String and Write
    pop esi
    mov eax, highScoreValues[esi]
    push esi
    
    lea edi, scoreTextBuffer
    call IntToString        ; Convert number to string
    
    lea edx, scoreTextBuffer
    invoke Str_length, edx
    mov ecx, eax
    mov eax, fileHandle
    call WriteToFile        ; Write score string
    
    ; Write Newline
    mov eax, fileHandle
    lea edx, newLine
    mov ecx, 2
    call WriteToFile
    
    pop esi
    pop edi
    pop ecx
    
    add edi, NAME_STRIDE
    add esi, 4
    dec ecx
    jz SaveHighScoresDone
    jmp saveLoop
    
    SaveHighScoresDone: 
    mov eax, fileHandle
    call CloseFile
    ret
SaveHighScores ENDP

LoadHighScores PROC
    mov edx, OFFSET highScoreFile
    call OpenInputFile
    cmp eax, INVALID_HANDLE_VALUE
    je loadFailed
    mov fileHandle, eax
    mov ecx, 5
    xor ebx, ebx
    xor esi, esi
readLoop:
    push ecx
    push ebx
    push esi
    mov eax, fileHandle
    lea edx, highScoreNames
    add edx, ebx
    mov ecx, NAME_STRIDE
    call ReadFromFile
    push esi
    lea esi, highScoreNames
    add esi, ebx
    call TrimName
    pop esi
    push edi
    lea edi, scoreTextBuffer
readScoreLoop:
    mov eax, fileHandle
    mov edx, edi
    mov ecx, 1
    call ReadFromFile
    cmp eax, 0
    je doneReadScore
    mov al, [edi]
    cmp al, 13
    je skipCR
    cmp al, 10
    je doneReadScore
    inc edi
    jmp readScoreLoop
skipCR:
    jmp readScoreLoop
doneReadScore:
    mov byte ptr [edi], 0
    pop edi
    lea edx, scoreTextBuffer
    call StrToInt
    pop esi
    mov highScoreValues[esi], eax
    pop ebx
    pop ecx
    add ebx, NAME_STRIDE
    add esi, 4
    loop readLoop
    mov eax, fileHandle
    call CloseFile
loadFailed:
    ret
LoadHighScores ENDP

UpdateHighScores PROC
    pushad
    mov ecx, 5
    mov edi, 0
    mov esi, 0
CheckNameLoop:
    INVOKE Str_compare, ADDR currentPlayerName, ADDR highScoreNames[edi]
    je NameFound
    add edi, NAME_STRIDE
    add esi, 4
    loop CheckNameLoop
    mov eax, score
    cmp eax, highScoreValues[16]
    jle DoneUpdate
    mov highScoreValues[16], eax
    lea esi, currentPlayerName
    lea edi, highScoreNames[80]
    mov ecx, NAME_STRIDE
    cld
    rep movsb
    jmp SortAndSave
NameFound:
    mov eax, score
    cmp eax, highScoreValues[esi]
    jle DoneUpdate
    mov highScoreValues[esi], eax
SortAndSave:
    call SortHighScores
DoneUpdate:
    popad
    ret
UpdateHighScores ENDP

SortHighScores PROC
    pushad
    mov ecx, 4
OuterLoop:
    push ecx
    mov esi, 0
    mov edi, 0
    mov ecx, 4
InnerLoop:
    mov eax, highScoreValues[esi]
    mov ebx, highScoreValues[esi + 4]
    cmp eax, ebx
    jge NoSwap
    mov highScoreValues[esi], ebx
    mov highScoreValues[esi + 4], eax
    push ecx
    push esi
    push edi
    lea esi, highScoreNames[edi]
    lea edi, highScoreNames[edi + 20]
    call SwapNamesHelper
    pop edi
    pop esi
    pop ecx
NoSwap:
    add esi, 4
    add edi, NAME_STRIDE
    loop InnerLoop
    pop ecx
    loop OuterLoop
    popad
    ret
SortHighScores ENDP

SwapNamesHelper PROC USES eax ecx esi edi
    mov ecx, 20
SwapByteLoop:
    mov al, [esi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi
    inc edi
    loop SwapByteLoop
    ret
SwapNamesHelper ENDP

DisplayHighScoresActual PROC
    LOCAL hsLoopCnt:DWORD, hsScoreOff:DWORD, hsNameOff:DWORD, hsRank:DWORD, hsRow:BYTE
    pushad
    
    call Clrscr
    mov eax, yellow + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET hsTitleStr
    call WriteString
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET hsHeaderStr
    call WriteString
    mov dl, 20
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET hsDividerStr
    call WriteString
    
    ; Initialize loop variables in LOCAL memory (survives all calls)
    mov hsLoopCnt, 5
    mov hsScoreOff, 0
    mov hsNameOff, 0
    mov hsRank, 1
    
hsDisplayLoop:
    ; Calculate row: dh = rank * 2 + 6
    mov eax, hsRank
    shl eax, 1
    add eax, 6
    mov hsRow, al                       ; Save row to local variable
    
    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, hsRow                       ; Restore row
    call Gotoxy
    
    ; Print rank number
    mov eax, hsRank
    call WriteDec
    mov edx, OFFSET hsRankStr
    call WriteString
    
    ; Print name - need to restore row since edx was used
    mov dl, 27
    mov dh, hsRow                       ; Restore row again
    call Gotoxy
    mov edi, hsNameOff
    lea edx, highScoreNames[edi]
    call WriteString
    
    ; Calculate spacing
    mov edi, hsNameOff
    lea edx, highScoreNames[edi]
    INVOKE Str_length, edx
    mov ecx, 25
    sub ecx, eax
    cmp ecx, 1
    jge hsSpaceLoop
    mov ecx, 1
hsSpaceLoop:
    mov al, ' '
    call WriteChar
    loop hsSpaceLoop
    
    ; Print score
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    mov esi, hsScoreOff
    mov eax, highScoreValues[esi]
    call WriteDec
    mov edx, OFFSET hsPtsLabel
    call WriteString
    
    ; Increment for next iteration
    add hsScoreOff, 4
    add hsNameOff, NAME_STRIDE
    inc hsRank
    dec hsLoopCnt
    jnz hsDisplayLoop
    
    ; Footer
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov dl, 20
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET returnMsg
    call WriteString
    
hsWaitEsc:
    call ReadKey
    cmp al, 27
    jne hsWaitEsc
    
    popad
    ret
DisplayHighScoresActual ENDP


SpawnProjectile PROC
    pushad
    mov esi, 0
    findSlot:
        cmp esi, MAX_PROJ
        jge spawnDone
        cmp projType[esi], 0
        je slotFound
        inc esi
        jmp findSlot
    slotFound:
        mov al, xPos
        mov projX[esi], al
        mov al, yPos
        mov projY[esi], al
        mov projType[esi], cl
        mov projDist[esi], 0
        
        mov al, marioFacing
        mov projDir[esi], al
        
    spawnDone:
    popad
    ret
SpawnProjectile ENDP

CheckPlatformCollision PROC
    push ebx
    mov al, projY[esi]
    cmp al, plat1Y
    jne checkPlat2
    mov al, projX[esi]
    cmp al, plat1XStart
    jl checkPlat2
    cmp al, plat1XEnd
    jg checkPlat2
    mov al, 1
    jmp donePlat
checkPlat2:
    mov al, projY[esi]
    cmp al, plat2Y
    jne noPlat
    mov al, projX[esi]
    cmp al, plat2XStart
    jl noPlat
    cmp al, plat2XEnd
    jg noPlat
    mov al, 1
    jmp donePlat
noPlat:
    mov al, 0
donePlat:
    pop ebx
    ret
CheckPlatformCollision ENDP

CheckPipeCollisionStatic PROC
    push ebx
    cmp levelScreen, 1
    jne noPipe
    mov al, projX[esi]
    cmp al, pipe1X
    jl chkPipe2
    mov bl, pipe1X
    inc bl
    cmp al, bl
    jg chkPipe2
    mov al, projY[esi]
    cmp al, pipe1Y
    jl chkPipe2
    mov al, 1
    jmp donePipe
chkPipe2:
    mov al, projX[esi]
    cmp al, pipe2X
    jl chkPipe3
    mov bl, pipe2X
    inc bl
    cmp al, bl
    jg chkPipe3
    mov al, projY[esi]
    cmp al, pipe2Y
    jl chkPipe3
    mov al, 1
    jmp donePipe
chkPipe3:
    mov al, projX[esi]
    cmp al, pipe3X
    jl noPipe
    mov bl, pipe3X
    inc bl
    cmp al, bl
    jg noPipe
    mov al, projY[esi]
    cmp al, pipe3Y
    jl noPipe
    mov al, 1
    jmp donePipe
noPipe:
    mov al, 0
donePipe:
    pop ebx
    ret
CheckPipeCollisionStatic ENDP

UpdateProjectiles PROC
    pushad
    mov esi, 0
    updateProjLoop:
        cmp esi, MAX_PROJ
        jge doneUpdateProj
        cmp projType[esi], 0
        je nextProj
        
        mov al, projX[esi]
        mov bl, byte ptr projDir[esi]
        add al, bl
        cmp al, minX
        jle killProj
        cmp al, maxX
        jge killProj
        mov projX[esi], al
        
        inc projDist[esi]
        cmp projDist[esi], 40
        jg killProj

        call CheckPlatformCollision
        cmp al, 1
        je killProj
        
        call CheckPipeCollisionStatic
        cmp al, 1
        je killProj

        cmp projType[esi], 1
        je handleFireballLogic
        cmp projType[esi], 2
        je handleBlueballLogic
        jmp nextProj
        
    handleFireballLogic:
        mov edi, 0 
        chkEnFire:
            cmp edi, 5
            jge nextProj
            lea ebx, enemyAlive
            cmp byte ptr [ebx + edi], 0
            je nextEnFire
            lea ebx, enemyScreen
            mov al, byte ptr [ebx + edi]
            cmp al, levelScreen
            jne nextEnFire
            lea ebx, enemyXPos
            mov dl, byte ptr [ebx + edi]
            mov al, projX[esi]
            sub al, dl
            cmp al, 0
            jge absFire
            neg al
            absFire:
            cmp al, 2
            jg nextEnFire
            lea ebx, enemyYPos
            mov dh, byte ptr [ebx + edi]
            mov al, projY[esi]
            cmp al, dh
            jne nextEnFire
            
            lea ebx, enemyXPos
            mov dl, byte ptr [ebx + edi]
            lea ebx, enemyYPos
            mov dh, byte ptr [ebx + edi]
            call Gotoxy
            mov al, ' '
            call WriteChar
            
            lea ebx, enemyAlive
            mov byte ptr [ebx + edi], 0
            inc enemiesDefeated
            add score, 100
            jmp killProj
            
            nextEnFire:
            inc edi
            jmp chkEnFire
            
    handleBlueballLogic:
        mov edi, 0
        chkCoinBlue:
            cmp edi, totalCoins
            jge checkSpringBlue
            lea ebx, coinCollected
            cmp byte ptr [ebx + edi], 1
            je nextCoinBlue
            lea ebx, coinXPos
            mov dl, byte ptr [ebx + edi]
            mov al, projX[esi]
            cmp al, dl
            jne nextCoinBlue
            lea ebx, coinYPos
            mov dh, byte ptr [ebx + edi]
            mov al, projY[esi]
            cmp al, dh
            jne nextCoinBlue
            lea ebx, coinCollected
            mov byte ptr [ebx + edi], 1
            add score, 200
            inc coinsCollected
            call PlayCoinSound
            jmp killProj
            nextCoinBlue:
            inc edi
            jmp chkCoinBlue
        checkSpringBlue:
            jmp nextProj

    killProj:
        mov dl, projX[esi]
        mov dh, projY[esi]
        call Gotoxy

        call CheckPlatformCollision
        cmp al, 1
        je restorePlatChar
        
        call CheckPipeCollisionStatic
        cmp al, 1
        je restorePipeChar
        
        mov eax, black + (black * 16)
        call SetTextColor
        mov al, ' '
        call WriteChar
        jmp setDead

    restorePlatChar:
        mov eax, green + (black * 16)
        call SetTextColor
        mov al, '='
        call WriteChar
        jmp setDead

    restorePipeChar:
        mov eax, lightGreen + (black * 16)
        call SetTextColor
        mov al, '|'
        call WriteChar

    setDead:
        mov projType[esi], 0
        
    nextProj:
        inc esi
        jmp updateProjLoop
        
    doneUpdateProj:
    popad
    ret
UpdateProjectiles ENDP

DrawProjectiles PROC
    pushad
    mov esi, 0
    drawProjLoop:
        cmp esi, MAX_PROJ
        jge doneDrawProj
        cmp projType[esi], 0
        je skipDrawProj
        mov dl, projX[esi]
        mov dh, projY[esi]
        call Gotoxy
        cmp projType[esi], 1
        je drawFire
        mov eax, lightBlue + (black * 16)
        call SetTextColor
        mov al, charBlue
        call WriteChar
        jmp skipDrawProj
        drawFire:
        mov eax, lightRed + (black * 16)
        call SetTextColor
        mov al, charFire
        call WriteChar
        skipDrawProj:
        inc esi
        jmp drawProjLoop
    doneDrawProj:
    popad
    ret
DrawProjectiles ENDP

EraseProjectiles PROC
    pushad
    mov esi, 0
    eraseProjLoop:
        cmp esi, MAX_PROJ
        jge doneEraseProj
        cmp projType[esi], 0
        je skipEraseP
        mov dl, projX[esi]
        mov dh, projY[esi]
        call Gotoxy
        mov eax, black + (black * 16)
        call SetTextColor
        mov al, ' '
        call WriteChar
        skipEraseP:
        inc esi
        jmp eraseProjLoop
    doneEraseProj:
    popad
    ret
EraseProjectiles ENDP

; --- AUDIO INIT ---
InitAudioSystem PROC
    push eax
    ; Load Backgrounds
    invoke mciSendStringA, ADDR cmdOpenMenu, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenLvl1, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenLvl2, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenLvl3, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenLvl4, ADDR mciRetString, 0, 0
    ; Load SFX
    invoke mciSendStringA, ADDR cmdOpenNav, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenSel, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenJump, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenCoin, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenWin, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenLose, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdOpenShopBuy, ADDR mciRetString, 0, 0
    pop eax
    ret
InitAudioSystem ENDP

; --- MUSIC PROCEDURES ---
PlayMenuMusic PROC
    push eax
    ; Check if menu music is already playing
    cmp menuMusicPlaying, 1
    je menuMusicAlreadyPlaying
    ; Ensure ALL level music is stopped
    invoke mciSendStringA, ADDR cmdStopLvl1, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdStopLvl2, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdStopLvl3, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdStopLvl4, ADDR mciRetString, 0, 0
    
    ; Start Menu music
    invoke mciSendStringA, ADDR cmdPlayMenu, ADDR mciRetString, 0, 0
    mov menuMusicPlaying, 1
    menuMusicAlreadyPlaying:
    pop eax
    ret
PlayMenuMusic ENDP

PlayLevel1Music PROC
    push eax
    mov menuMusicPlaying, 0
    invoke mciSendStringA, ADDR cmdStopMenu, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdPlayLvl1, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayLevel1Music ENDP

PlayLevel2Music PROC
    push eax
    mov menuMusicPlaying, 0
    invoke mciSendStringA, ADDR cmdStopMenu, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdPlayLvl2, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayLevel2Music ENDP

PlayLevel3Music PROC
    push eax
    mov menuMusicPlaying, 0
    ; Stop Menu music before starting Level 3
    invoke mciSendStringA, ADDR cmdStopMenu, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdPlayLvl3, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayLevel3Music ENDP

PlayLevel4Music PROC
    push eax
    mov menuMusicPlaying, 0
    ; Stop Menu music before starting Level 4
    invoke mciSendStringA, ADDR cmdStopMenu, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdPlayLvl4, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayLevel4Music ENDP

; --- SFX PROCEDURES ---
PlayMenuMoveSound PROC
    push eax
    invoke mciSendStringA, ADDR cmdPlayNav, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayMenuMoveSound ENDP

PlayMenuSelectSound PROC
    push eax
    invoke mciSendStringA, ADDR cmdPlaySel, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayMenuSelectSound ENDP

PlayJumpSound PROC
    push eax
    invoke mciSendStringA, ADDR cmdPlayJump, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayJumpSound ENDP

PlayCoinSound PROC
    push eax
    invoke mciSendStringA, ADDR cmdPlayCoin, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayCoinSound ENDP

PlayShopBuySound PROC
    push eax
    invoke mciSendStringA, ADDR cmdPlayShopBuy, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayShopBuySound ENDP

PlayWinSound PROC
    push eax
    ; Stop ALL level music for win
    invoke mciSendStringA, ADDR cmdStopLvl1, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdStopLvl2, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdStopLvl3, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdStopLvl4, ADDR mciRetString, 0, 0
    invoke mciSendStringA, ADDR cmdPlayWin, ADDR mciRetString, 0, 0
    pop eax
    ret
PlayWinSound ENDP

PlayGameOverSound PROC
    push eax
    ; Stop all music by closing all devices
    invoke mciSendStringA, ADDR cmdCloseAll, ADDR mciRetString, 0, 0
    ; Re-open lose sound specifically because close all kills it
    invoke mciSendStringA, ADDR cmdOpenLose, ADDR mciRetString, 0, 0 
    invoke mciSendStringA, ADDR cmdPlayLose, ADDR mciRetString, 0, 0
    pop eax
    
    ; Re-initialize all audio devices so sounds work for next game
    call InitAudioSystem
    ret
PlayGameOverSound ENDP


CloseAudioSystem PROC
    push eax
    invoke mciSendStringA, ADDR cmdCloseAll, ADDR mciRetString, 0, 0
    pop eax
    ret
CloseAudioSystem ENDP

INCLUDE i240544_D_level-2.asm
INCLUDE i240544_D_level-4.asm
INCLUDE i240544_D_level-3.asm

END main