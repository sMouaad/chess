# frozen_string_literal: true

require_relative 'board'

# Module containing methods related to piece moves validation, checking, and disambiguating
module MoveValidator
  def deep_copy(data)
    Marshal.load(Marshal.dump(data))
  end

  def empty_square?(board, position)
    board.piece_at(*position).nil?
  end

  def enemy_square?(board, position)
    piece_board = board.piece_at(*position)
    !piece_board.nil? && enemy?(piece_board)
  end

  # Checks if there is the given player is in check in current board
  def check?(board, color)
    board.each_piece.any? do |piece|
      piece.calculate_next_moves(board).any? do |move|
        piece_at_move = board.piece_at(*move)
        piece_at_move.is_a?(King) && piece_at_move.color == color
      end
    end
  end

  # Checks if there is the given player is checkmated in current board
  def checkmate?(board, color)
    board.each_piece(color).all? do |piece|
      piece.next_moves(board).empty?
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
    is_hallway_free = board.piece_at(rank, 5).nil? && board.piece_at(rank, 6).nil?
    rook = board.piece_at(rank, 7)
    board.each_piece(enemy_color(color)).any? do |piece|
      piece_moves = piece.next_moves(board)
      piece_moves.include?([rank, 5]) || piece_moves.include?([rank, 6])
    end || !is_hallway_free || rook.nil? || rook.moved?
  end

  # O-O-O
  def long_castle_blocked?(board, color)
    rank = color == Board::PLAYER_ONE ? 0 : 7
    rook = board.piece_at(rank, 0)
    is_hallway_free = board.piece_at(rank, 1).nil? && board.piece_at(rank, 2).nil? && board.piece_at(rank, 3).nil?
    board.each_piece(enemy_color(color)).any? do |piece|
      piece_moves = piece.next_moves(board)
      piece_moves.include?([rank, 1]) || piece_moves.include?([rank, 2]) || piece_moves.include?([rank, 3])
    end || !is_hallway_free || rook.nil? || rook.moved?
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

  # Iterate through all moves and get all pieces in common for a given move, then disambiguate
  def remove_ambiguity(hash)
    all_moves(hash).each do |move|
      conflicted_pieces = conflicts(hash, move)
      disambiguate_pieces(hash, conflicted_pieces, move) unless conflicted_pieces.length == 1
    end
  end

  # For a given move give all the pieces that are in conflict
  def conflicts(hash, piece_move)
    conflicted_pieces = []
    hash.each do |piece_position, piece_moves|
      piece_moves.each do |move|
        conflicted_pieces << piece_position if piece_move == move
      end
    end
    conflicted_pieces
  end

  # Disambiguate pieces
  def disambiguate_pieces(hash, pieces, move)
    pieces.each do |piece|
      str = move[0] + if ambiguity_file?(piece, pieces) && ambiguity_rank?(piece, pieces)
                        piece
                      elsif !ambiguity_file?(piece, pieces)
                        coordinates_file(piece)
                      else
                        coordinates_rank(piece)
                      end
      hash[piece].push("#{str}#{move[1..]}").delete(move)
    end
  end
end
