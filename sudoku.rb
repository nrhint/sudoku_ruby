# Nathan Hinton
# This is the main file for the sudoku class


### Class Sudoku
# Holds the Sudoku data and has methods to manipulate it
###
class Sudoku

  attr_accessor :print

  ### function initialize
  # Initialize the object
  ###
  def initialize
    @grid = []
    9.times do
      @grid.append([])
    end
  end

  ### function print
  # print the grid out
  ###
  def print
    puts '+---+---+---+---+---+---+---+---+---+'
    9.times do |row|
      string = '| '
      9.times do |col|
        if @grid[row][col].nil?
          string += '  | '
        else
          string += @grid[row][col].to_s + ' | '
        end
      end
      puts string
      puts '+---+---+---+---+---+---+---+---+---+'
    end
  end

  ### function solve
  # Solve (or generate if empty) a puzzle
  ###
  def solve(pos = 0, grid = @grid)#[[], [], [], [], [], [], [], [], []])
    if pos == 81
      if is_valid?(grid)
        #require 'byebug';debugger
        @grid = grid
        return grid
      end
    end
    values = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffle!
    values.each do |value|
      #puts "trying #{value} at #{pos}"
      new_grid = try_move(pos/9, pos%9, value, grid)
      if new_grid != false
        solve(pos + 1, new_grid)
      end
    end
    # Rather then implimenting a full recursion just retry...
    if pos == 0
      num_count = 0
      @grid.each do |row|
        num_count += row.compact.length
      end
      if num_count != 81
        puts('failed to find solution for this:')
        print
        @grid = [[], [], [], [], [], [], [], [], []]
        return solve(0)
      end
    end
  end

  ###function is_valid?
  # Checks if the value to be changed will be valid
  ###
  def is_valid?(grid)
    # Check rows:
    grid.each do |row|
      if row.compact.uniq != row.compact
        # require 'byebug';debugger
        return false # Failed to have unique row values
      end
    end
    # Check cols:
    9.times do |col|
      tmp = []
      9.times do |row|
        tmp.append(grid[row][col])
      end
      if tmp.compact.uniq != tmp.compact
        # require 'byebug';debugger
        return false # Failed to have cols unique
      end
    end
    # Check boxes:
    9.times do |box_idx|
      tmp = []
      3.times do |col|
        3.times do |row|
          tmp.append(grid[3*(box_idx/3)+row][3*(box_idx%3)+col])
        end
      end
      # puts "Box idx: #{box_idx}"
      # print
      # puts tmp
      # require 'byebug';debugger
      if tmp.compact.uniq != tmp.compact
        # require 'byebug';debugger
        return false # Failed to have cols unique
      end
    end
    return true
  end

  ### function try_move
  # col: Integer (The col to place the number in)
  # row: Integer (The row to place the number in)
  # val: Integer (The value to place into the grid)
  # returns true if the number was allowed, otherwise false.
  ###
  def try_move(col, row, val, grid)
    orig_val = grid[row][col]
    grid[row][col] = val
    if is_valid?(grid)
      return grid
    else
      grid[row][col] = orig_val
    end
    # require 'byebug';debugger
    return false
  end # function try_move
end


require 'benchmark'
total_time = 0
runs = 10
runs.times do 
  total_time += Benchmark.realtime {
    sudoku = Sudoku.new()
    sudoku.solve
    sudoku.print
  }
end
puts "Over #{runs} runs the average time was #{total_time/runs}"
puts 'finished'
