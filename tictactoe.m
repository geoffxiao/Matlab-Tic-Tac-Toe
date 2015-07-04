%-------------------------------------------------------------------------%
% ENGR 122 Final Project
% Geoffrey Xiao, Josh Murphy, Carter Henderson
% 
% Tic-Tac-Toe playing application. Two human players can compete. 
% Prints the history of Tic-Tac-Toe games in a text file
%-------------------------------------------------------------------------%

function [] = tictactoe()

    clc; close all; clear all; % Clear and close everything

    board = cell(3,3); % Create board
    vecFree = 1:9; % Free spaces
    vecPlayer1PosMoved = []; % positions player 1 moved
    vecPlayer2PosMoved = []; % positions player 2 moved
    cellplot(board); % Plot the board
    title('Tic Tac Toe--Click to start');
    ginput(1); % Wait for click
    
    % Set up the game variables
    player = 1; % The player whose turn it is
    x = 0; % Click position x-axis
    y = 0; % Click position y-axis
    gameOver = false; % Game over boolean
    counter = 1; % The move counter

    % Creating the history file
    c = clock; % Get the time
    fid = fopen('history.txt', 'at'); % Open/Create the history file
    date = ['Game History--', sprintf('%d/%d/%d/ %d:%d', c(2),...
        c(3), c(1), c(4), c(5))]; % Create the date string
    % Append the date string to the history file
    fprintf(fid, char(10)); 
    fprintf(fid, date);
    fprintf(fid, char(10));

    while(~gameOver)
        % Keep playing until no moves left or someone wins
    
        %---------Player 1's turn----------%
        % Player 1 is X
        if(player == 1)
            
            % Title for the game GUI
            title(sprintf('Player %d (X)', player)); 
            [x, y] = ginput(1); % Get the mouse click
            
            % Keep prompting for mouse click while the mouse click is
            %   invalid
            while(~isValidMove(vecFree, mouseClick(x, y)))
                % Change the GUI title
                title(sprintf('INVALID MOVE Player %d', player)); 
                [x, y] = ginput(1); % Get a new mouse click
            end % End while
            
            % isValidMove also returns the new vector of valid moves
            [~, vecFree] = isValidMove(vecFree, mouseClick(x, y));
            
            % Convert the mouse click to a board position (1-9)
            movedPos = mouseClick(x, y);
            
            % Convert the board position to a point in the cell array
            [x, y] = convert(mouseClick(x, y));
            
            % Append the move Player 1 just made to the array that tracks
            %   Player 1's moves
            vecPlayer1PosMoved = [vecPlayer1PosMoved movedPos];
            % Change the board to reflect Player 1's move
            board{x, y} = 'X'; 
            cellplot(board); % Plot the new board
            
            % Output the move to the text file
            fprintf(fid, sprintf('Move %d:', counter)); % Print move number
            fprintf(fid, char(10)); % New line
            boardToString(board, fid); % Print the actual board
            
            player = player + 1; % Change to player 2
            counter = counter + 1; % Increment counter
            
            
        %---------Player 2's turn----------%
        % Player 2 is O
        else
            title(sprintf('Player %d (O)', player)); % Change GUI title
            [x, y] = ginput(1); % Get Player 2's move
            
            % Keep asking for a move while the move is invalid
            while(~isValidMove(vecFree, mouseClick(x, y)))
                % Change GUI title
                title(sprintf('INVALID MOVE Player %d', player));
                [x, y] = ginput(1); % Get a move
            end % End while
            
            % Change the vector of available moves
            [~, vecFree] = isValidMove(vecFree, mouseClick(x, y));
            
            % Convert the mouse click to a board position
            movedPos = mouseClick(x, y); 
           
            % Convert the board position to a cell array position
            [x, y] = convert(mouseClick(x, y)); 
            % Update Player 2's moves
            vecPlayer2PosMoved = [vecPlayer2PosMoved movedPos]; 
            
            board{x, y} = 'O'; % Update the board
            cellplot(board); % Plot the board
            
            % Output the move to the text file
            fprintf(fid, sprintf('Move %d:', counter));
            fprintf(fid, char(10)); % new line
            boardToString(board, fid); % Output the entire board
            
            player = player - 1; % Change to Player 1
            counter = counter + 1; % Increment counter
            
        end % End if, else
        
        % Check if the game is over
        gameOver = win(vecPlayer1PosMoved) || win(vecPlayer2PosMoved) ||...
            (length(vecPlayer1PosMoved) + length(vecPlayer2PosMoved) == 9);
        
    end % End while
    
    % Now the game is over
    
    % Player 1 has won  
    if(win(vecPlayer1PosMoved))
        
        % Change the title to player 1 has won
        title(sprintf(...
            'Player %d (X) Wins! Click to see how Player %d won.', 1, 1));
        % Print the winning combination
        [~, winningStrokesIndex] = win(vecPlayer1PosMoved);
        plotWinningStrokes(winningStrokesIndex, 'X', 1);
        
        % Output the winner to the text file
        fprintf(fid, char(10)); % New line
        fprintf(fid, 'Player 1 (X) wins!');
        fprintf(fid, char(10)); % New line
        
    % Player 2 has won
    elseif(win(vecPlayer2PosMoved))
        
        % Change the title to player 2 has won
        title(sprintf(...
            'Player %d (O) Wins! Click to see how Player %d won.', 2, 2));
        % Print the winning combination
        [~, winningStrokesIndex] = win(vecPlayer2PosMoved);
        plotWinningStrokes(winningStrokesIndex, 'O', 2);
        
        % Output the winner to the text file
        fprintf(fid, char(10)); % new line
        fprintf(fid, 'Player 2 (O) wins!');
        fprintf(fid, char(10)); % new line
    
    % Tie game
    else
        
        title('Tie game'); % Change GUI title
        
        % Output the winner to the text file
        fprintf(fid, char(10)); 
        fprintf(fid, 'Tie Game');
        fprintf(fid, char(10));
        
    end % End if, elseif, else
    
end % End function


function [] = boardToString(board, fid)
% This function outputs the entire board to the text file
% 
% @param board  the current board
% @param fid    the output file

    % Loop through all the rows
    for i = 1:3        
        % Loop through all the columns
        for c = 1:3         
            temp = board{i, c}; % Get the board value 
            
            % If there is an 'X' or 'O' inside get that 
            if(strcmp(temp, 'X') || strcmp(temp, 'O'))
                temp = ['[', temp,']'];
                
            % Else set temp to be empty brackets
            else temp = '[ ]';
                
            end % End if, else
            
            fprintf(fid, [temp, ' ']); % Output to text file
            
        end % End for
        
       fprintf(fid, char(10)); % Output new line character to text file          
    
    end % End for
    
end % End function


% Plot the combination that won the game
function [] = plotWinningStrokes(index, winnerPiece, winnerNum)
% This function plots the combination that one the game
% 
% @param index        the index (in the vector winningPos) that won 
%                         the game
% @param winnerPiece  X/O, whichever won the game
% @param winnerNum    1/2, whichever player won the game

    % Pause, wait for the user to click
    ginput(1);
    
    % The winning combinations
    winningPos = {[1 2 3], [1 5 9], [1 4 7], [2 5 8], [3 6 9], [3 5 7],...
        [4 5 6], [7 8 9]};
    
    % Variable index passed gives which winning combination won the game
    % The three (x, y) coordinates refer to positions in the cell board
    %   array
    % The values in winningPos are board positions
    % Have to convert the board position to a cell board array coordinate
    [firstX, firstY] = convert(winningPos{index}(1));
    [secondX, secondY] = convert(winningPos{index}(2));
    [thirdX, thirdY] = convert(winningPos{index}(3));
    
    % Create a new board
    board = cell(3);
    
    % Put the winner's piece into the winning positions
    board{firstX, firstY} = winnerPiece;
    board{secondX, secondY} = winnerPiece;
    board{thirdX, thirdY} = winnerPiece;
    
    % New figure
    figure;
    
    % Plot the winning combination
    cellplot(board);
    
    % Set the graph title
    title(sprintf('Player %d won with this combination', winnerNum));
    
end % End function


function [valid, vecFreeOut] = isValidMove(vecFreeIn, desiredMove)
% This decides if the move is valid or not. And once the move is valid, the
%   function returns the vector that contains the free moves.
% 
% @param vecFreeIn     the original vector of free moves
% @param desiredMove   the move the player wants
% @return valid        true if the move is valid (the move is valid
%                           if it is in a box and a new move)
% @return vecFreeOut   the new vector of free moves

    % Initialize the output vector vecFreeOut
    % Will store the free positions after a correct move has been made
    vecFreeOut = vecFreeIn;

    % If desired position is valid
    if(any(desiredMove == vecFreeIn) && desiredMove ~= -1)
        valid = true; % Sets output variable valid to true
        % remove desired position from free vector
        vecFreeOut(vecFreeIn == desiredMove) = []; 
        
    % Else the position is invalid
    else 
        valid = false; % Set output variable valid to false
        % Keep the output vector the same as the input vector
        vecFreeOut = vecFreeIn; 
    
    end % End if, else

end % End function


function [out, maxPos] = win(positionsMoved)
% This decides if player has won. Returns true if player has won
% 
% @param positionsMoved  The positions the player has moved
% @return out            Returns true if the player has won
% @return maxPos         The index of the winning combination

    % All the winning combinations
    winningPos = {[1 2 3], [1 5 9], [1 4 7], [2 5 8], [3 6 9],...
        [3 5 7], [4 5 6], [7 8 9]};
    
    % Find max winning combination elements in the moved positions
    xWin = 0;
    maxPos = 0;
    
    % Cycle through all possible the winning positions
    for i = 1:length(winningPos)
        % Temp = how many of these winning positions are in the player's
        %   moved positions
        temp = sum(ismember(positionsMoved,winningPos{i}));
        % Get the maximum temp
        if(temp > xWin) 
            xWin = temp;
            maxPos = i;
        end
    end % End for
    
    % If you have 3 winning combos, you win!
    % If three winning positions are in the player's moved positions
    if(xWin == 3) 
        out = true;
    else
        out = false;
    end

end


function [boardPos] = mouseClick(x, y)
% Convert mouse click to board position (1-9)
%
% @param x          the x-axis coordinate of the mouse click
% @param y          the y-axis coordinate of the mouse click
% @return boardPos  the board position (1-9) the mouse clock refers to

    if( 0 < x && x < 1 && 0 < y && y < 1)
        boardPos = 1;
    elseif ( 1 < x && x < 2 && 0 < y && y < 1)
        boardPos = 2;
    elseif ( 2 < x && x < 3 && 0 < y && y < 1)
        boardPos = 3;
    elseif ( 0 < x && x < 1 && 1 < y && y < 2)
        boardPos = 4;
    elseif ( 1 < x && x < 2 && 1 < y && y < 2)
        boardPos = 5;
    elseif ( 2 < x && x < 3 && 1 < y && y < 2)
        boardPos = 6;
    elseif ( 0 < x && x < 1 && 2 < y && y < 3)
        boardPos = 7;
    elseif ( 1 < x && x < 2 && 2 < y && y < 3)
        boardPos = 8;
    elseif ( 2 < x && x < 3 && 2 < y && y < 3)
        boardPos = 9;
    else boardPos = -1; % Invalid move outside the box
    end % End if, elseif, else
        
end % End function


function [posX, posY] = convert(num)
% Convert the numeral position (1-9) to an (x,y) position in the cell array
% The board:
%      1 2 3
%      4 5 6
%      7 8 9
% 
% @param num    the board position (1-9)
% @return posX  the row in the cell array
% @return posY  the column in the cell array

    switch(num)
        case 1
            posX = 1; posY = 1;
        case 2
            posX = 1; posY = 2; 
        case 3
            posX = 1; posY = 3; 
        case 4
            posX = 2; posY = 1; 
        case 5
            posX = 2; posY = 2; 
        case 6
            posX = 2; posY = 3; 
        case 7
            posX = 3; posY = 1; 
        case 8
            posX = 3; posY = 2; 
        case 9
            posX = 3; posY = 3;
    end % End switch
    
end % End function

