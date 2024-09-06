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

  def check?(board, initial_pos, final_pos)
    copy_board = deep_copy(board)
    copy_board.piece_move(initial_pos, final_pos) # mimicks move
    copy_board.piece_at(*final_pos).next_moves(board).any? do |move|
      copy_board.piece_at(*move).is_a? King
    end
  end
end
