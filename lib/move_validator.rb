# frozen_string_literal: true

require_relative 'board'

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

  # Checks if there is the given player is in check in current board
  def check?(board, color)
    # We flatten the board since it's an array for array
    board.each_piece.any? do |piece|
      piece.calculate_next_moves(board).any? do |move|
        piece_at_move = board.piece_at(*move)
        piece_at_move.is_a?(King) && piece_at_move.color == color
      end
    end
  end

  def enemy_color(color)
    color == Board::PLAYER_ONE ? Board::PLAYER_TWO : Board::PLAYER_ONE
  end

  def simulate_move(board, initial_pos, final_pos)
    copy_board = deep_copy(board)
    copy_board.piece_move(initial_pos, final_pos)
    copy_board
  end

  # O-O
  def short_castle_blocked?(board, color)
    rank = color == Board::PLAYER_ONE ? 0 : 7
    enemy = color == Board::PLAYER_ONE ? Board::PLAYER_TWO : Board::PLAYER_ONE
    is_hallway_free = board.piece_at(rank, 5).nil? && board.piece_at(rank, 6).nil?
    rook = board.piece_at(rank, 7)
    board.each_piece(enemy).any? do |piece|
      piece_moves = piece.next_moves(board)
      piece_moves.include?([rank, 5]) || piece_moves.include?([rank, 6])
    end || !is_hallway_free || rook.moved?
  end

  # O-O-O
  def long_castle_blocked?(board, color)
    rank = color == Board::PLAYER_ONE ? 0 : 7
    enemy = color == Board::PLAYER_ONE ? Board::PLAYER_TWO : Board::PLAYER_ONE
    rook = board.piece_at(rank, 0)
    is_hallway_free = board.piece_at(rank, 1).nil? && board.piece_at(rank, 2).nil? && board.piece_at(rank, 3).nil?
    board.each_piece(enemy).any? do |piece|
      piece_moves = piece.next_moves(board)
      piece_moves.include?([rank, 5]) || piece_moves.include?([rank, 6])
    end || !is_hallway_free || rook.moved?
  end

  def capture_en_passant?(board, piece, piece_position)
    offset = (piece.color == Board::PLAYER_ONE ? -1 : 1)
    copy_board = simulate_move(board, to_index(piece.coordinates), piece_position)
    piece_at_pos = copy_board.piece_at(piece_position.first + offset, piece_position.last)
    piece_at_pos.is_a?(Pawn)
  end

  def pawn_capture?(board, piece, piece_position)
    !board.piece_at(*piece_position).nil? || capture_en_passant?(board, piece,
                                                                 piece_position)
  end
end
