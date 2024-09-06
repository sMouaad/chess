module MoveValidator
  def empty_square?(board, position)
    piece_board = board.piece_at(*position)
    piece_board.nil?
  end

  def enemy_square?(board, position)
    piece_board = board.piece_at(*position)
    !piece_board.nil? && self.enemy?(piece_board) # rubocop:disable Style/RedundantSelf
  end
end
