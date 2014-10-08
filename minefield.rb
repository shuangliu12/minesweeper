require 'pry'

class Minefield
  attr_reader :row_count, :column_count

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mines = init_mines(row_count, column_count, mine_count)
    @cleared = []
    row_count.times do
      @cleared << Array(false)*column_count
    end
  end

# put mines in random places
  def init_mines(row_count, column_count, mine_count)
    field = []
    until field.length == row_count*column_count
      field << false
    end

    rand_num = (0...row_count*column_count).to_a.shuffle.first(mine_count)
    rand_num.each do |num|
      field[num] = true
    end

    minefield=[]
    field.each_slice(column_count) do |sub|
      minefield << sub
    end
    minefield
    #double array to represent row, column of the minefield
    # mine is true [[false, true, true], [false, false, true], [false, false, true]]
  end



  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @cleared[row][col]
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    if @cleared[row][col] == false
      @cleared[row][col]=true
      if adjacent_mines(row,col) == 0 && @mines[row][col] == false
        #check up
        if row > 0
          clear(row-1,col)
        end
        #check down
        if row < row_count - 1
          clear(row+1,col)
        end
        #check left
        if col > 0
          clear(row,col-1)
        end
        #check right
        if col < column_count - 1
          clear(row,col+1)
        end
      end
    end
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    (0...row_count).to_a.each do |row|
      (0...column_count).to_a.each do |col|
        if @cleared[row][col] == true && @mines[row][col] == true
          return true
        end
      end
    end
    return false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    (0...row_count).to_a.each do |row|
      (0...column_count).to_a.each do |col|
        if @cleared[row][col] == false && @mines[row][col] == false
          return false
        end
      end
    end
    return true
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    mine_count = 0
    #check the 3 squares above if we're not in the top row
    if row > 0
      if col > 0
        if @mines[row-1][col-1] == true
          mine_count += 1
        end
      end
      if @mines[row-1][col] == true
          mine_count += 1
      end
      if col < column_count-1
        if @mines[row-1][col+1] == true
          mine_count += 1
        end
      end
    end

    #check the 3 squares below if we're not in the bottom row
    if row < row_count - 1
      if col > 0
        if @mines[row+1][col-1] == true
          mine_count += 1
        end
      end
      if @mines[row+1][col] == true
          mine_count += 1
      end
      if col < column_count-1
        if @mines[row+1][col+1] == true
          mine_count += 1
        end
      end
    end

    #check the square to the left
    if col > 0
      if @mines[row][col-1] == true
          mine_count += 1
      end
    end

    #check the square to the right
    if col < column_count-1
      if @mines[row][col+1] == true
        mine_count += 1
      end
    end
    mine_count
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    @mines[row][col]
  end
end
