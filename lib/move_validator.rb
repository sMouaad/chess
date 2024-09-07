# frozen_string_literal: true

module MoveValidator
  def deep_copy(data)
    Marshal.load(Marshal.dump(data))
  end

  def empty_square?(board, position)
    piece_board = board.piece_at(*position)
    piece_board.nil?
  end

  def enemy_square?(board, position)
    piece_board = board.piece_at(*position)
    !piece_board.nil? && enemy?(piece_board)
  end

  # Checks if there is a check in current board
  def check?(board)
    board.data.flatten.compact.any? do |piece|
      piece.next_moves(board).any? do |move|
        board.piece_at(*move).is_a? King
      end
    end
  end

  def simulate_move(board, initial_pos, final_pos)
    copy_board = deep_copy(board)
    copy_board.piece_move(initial_pos, final_pos)
    copy_board
  end
end
