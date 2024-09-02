module Notation
  NOTATION = /^(?<piece>(?<_>[KBNQR][a-h]?[1-8]?)|[a-h])?(?:(?<=[a-h])x|x?)(?<final_position>[a-h][1-8])(?<promotion>=?[KBNQR])?$/.freeze
  CASTLE_NOTATION = /^O-O(?:-O)?$/.freeze
  def notation_to_index(algebraic)
  end

  def correct_notation?(algebraic)
    return false unless algebraic.is_a? String

    algebraic.match?(NOTATION) || algebraic.match?(CASTLE_NOTATION)
  end

  def file_to_index
  end

  def rank_to_index
  end
end
