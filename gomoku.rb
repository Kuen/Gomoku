# CSCI3180 Principles of Programming Languages
# --- Declaration ---
# I declare that the assignment here submitted is original except for source material explicitly 
# acknowledged. I also acknowledge that I am aware of University policy and regulations on 
# honesty in academic work, and of the disciplinary guidelines and procedures applicable to
# breaches of such policy and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
# Assignment 2 
# Name		: Yu Yuk Kuen
# Student ID 	: 1155051348
# Email Addr 	: tgp146871@gmail.com

class Gomoku
	def initialize()
		@board = Array.new(15){Array.new(15){'.'}};
		@player1;
		@player2;
		@turn;
	end
	def startGame
		print("First player is (1) Computer or (2) Human? ");
		keyStr = gets();
		keyInt = keyStr.to_i;
		case (keyInt)
		when 1
			puts("Player O is Computer");
			@player1 = Computer.new('O', @board);
		when 2
			puts("Player O is Human");
			@player1 = Human.new('O', @board);
		else
			puts("error")
		end

		print("Second player is (1) Computer or (2) Human? ");
		keyStr = gets();
		keyInt = keyStr.to_i;
		case (keyInt)
		when 1
			puts("Player X is Computer");
			@player2 = Computer.new('X', @board);
		when 2
			puts("Player X is Human");
			@player2 = Human.new('X', @board);
		else
			puts("error")
		end
		
		win = 0;
		draw = 0;
		printBoard();
		@turn = @player1;
		while win == 0 && draw == 0
			position = @turn.nextMove;
			@board[position[0].to_i][position[1].to_i] = @turn.symbol;
			printf("Player %c places to row %d, col %d\n", @turn.symbol, position[0], position[1]);	
			win += Checker.checkHorizontal(@board, @turn.symbol, position);
			win += Checker.checkVertical(@board, @turn.symbol, position);
			win += Checker.checkNegativeDiagonal(@board, @turn.symbol, position);
			win += Checker.checkPositiveDiagonal(@board, @turn.symbol, position);
			draw += Checker.checkDraw(@board);
			printBoard();
			if win >= 1
				printf("Player %c wins!\n", @turn.symbol);
			elsif draw >= 1
				printf("Draw game!\n");
			end
			@turn = switchTurn(@turn);
		end

		
	end
	def printBoard
		row = 0;
		puts("                       1 1 1 1 1");
		puts("   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4");
		@board.each {|a,b,c,d,e,f,g,h,i,j,k,l,m,n,o| 
   			printf("%2d", row)
   			row += 1
   			puts( " #{a} #{b} #{c} #{d} #{e} #{f} #{g} #{h} #{i} #{j} #{k} #{l} #{m} #{n} #{o}" ) 
		}
	end

	def switchTurn(player)
		if player == @player1
			return @player2;
		elsif player == @player2
			return @player1;
		end
	end

end

class Player
	def initialize(symbol, board)
		@symbol = symbol;
		@board = board;
	end
	def nextMove
	end
	def symbol
		return @symbol;
	end
end

class Human < Player
	def nextMove
		vaild = false;
		while vaild == false
			printf("Player %c, make a move (row col): ", @symbol);
			input = gets.split(' ');
			x = input[0].to_i;
			y = input[1].to_i;
			vaild = Checker.checkVaildMove(x, y, @board);
			if vaild == false
				puts("Invalid input. Try again!");
			elsif vaild == true
				return input;
			end
		end
	end
end

class Computer < Player
	def nextMove
		input = Array.new(2);
		win = 0;
		for i in 0..14
			for j in 0..14
				if @board[i][j] == '.'
					@board[i][j] = @symbol;
					input[0] = i;
					input[1] = j;
					win += Checker.checkHorizontal(@board, @symbol, input);
					win += Checker.checkVertical(@board, @symbol, input);
					win += Checker.checkNegativeDiagonal(@board, @symbol, input);
					win += Checker.checkPositiveDiagonal(@board, @symbol, input);
					if win == 0
						@board[i][j] = '.';
					elsif win >= 1
						@board[i][j] = '.';
						return input;
					end
				end
			end
		end
		vaild = false;
		while vaild == false
			x = rand(15);
			y = rand(15);
			vaild = Checker.checkVaildMove(x, y, @board);
			if vaild == true;
				input[0] = x;
				input[1] = y;
				return input;
			end
		end
	end
end

class Checker
	def self.checkVaildMove(x, y, board)
		if (x < 0 || x > 14)
			return false;
		end
		if (y < 0 || y > 14)
			return false;
		end
		if (board[x][y] != '.')
			return false;
		end
		return true;
	end

	def self.checkHorizontal(board, symbol, position)
		string = "";
		row = position[0].to_i;
		col_min = position[1].to_i - 4;
		col_max = position[1].to_i + 4;
		if col_min < 0
			col_min = 0;
		end
		if col_max > 14;
			col_max = 14;
		end
		for col in col_min..col_max
			string += board[row][col];
		end
		symbol = symbol;
		return checkFiveSymobl(string, symbol);
	end

	def self.checkVertical(board, symbol, position)
		string = "";
		col = position[1].to_i;
		row_min = position[0].to_i - 4;
		row_max = position[0].to_i + 4;
		if row_min < 0
			row_min = 0;
		end
		if row_max > 14;
			row_max = 14;
		end
		for row in row_min..row_max
			string += board[row][col];
		end
		symbol = symbol;
		return checkFiveSymobl(string, symbol);
	end

	def self.checkNegativeDiagonal(board, symbol, position)
		string = "";
		row_min = position[0].to_i;
		row_max = position[0].to_i;
		col_min = position[1].to_i;
		col_max = position[1].to_i;
		count = 0;

		while (row_min!=0 && col_min!=0 && count!=4)
			row_min -= 1;
			col_min -= 1;
			count += 1;
		end

		count = 0;
		while (row_max!=14 && col_max!=14 && count!=4)
			row_max += 1;
			col_max += 1;
			count += 1;
		end

		for row in row_min..row_max
			string += board[row][col_min];
			col_min += 1;
		end
		symbol = symbol;
		return checkFiveSymobl(string, symbol);
	end

	def self.checkPositiveDiagonal(board, symbol, position)
		string = "";
		row_min = position[0].to_i;
		row_max = position[0].to_i;
		col_min = position[1].to_i;
		col_max = position[1].to_i;
		count = 0;

		while (row_min!=0 && col_max!=14 && count!=4)
			row_min -= 1;
			col_max += 1;
			count += 1;
		end

		count = 0;
		while (row_max!=14 && col_min!=0 && count!=4)
			row_max += 1;
			col_min -= 1;
			count += 1;
		end

		for col in col_min..col_max
			string += board[row_max][col];
			row_max -= 1;
		end
		symbol = symbol;
		return checkFiveSymobl(string, symbol);
	end

	def self.checkDraw(board)
		board.each {|i|
			i.each {|j|
				if j == '.'
					return 0;
				end
			}
		}
		return 1;
	end

	def self.checkFiveSymobl(string, symbol)
		# puts string;
		case symbol
		when 'O'
			if string.include? "OOOOO"
				return 1;
			end
		when 'X'
			if string.include? "XXXXX"
				return 1;
			end		
		end
		return 0;
	end


end

Gomoku.new.startGame;
