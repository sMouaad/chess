require './lib/notation'
describe Notation do
  include Notation
  describe '#to_parse_notation' do
    describe 'simple pawn moves' do
      it 'validates e4' do
        expect(parse_notation('e4')).to_not eql nil
      end
      it 'validates d5' do
        expect(parse_notation('d5')).to_not eql nil
      end
      it 'validates a3' do
        expect(parse_notation('a3')).to_not eql nil
      end
      it 'validates h6' do
        expect(parse_notation('h6')).to_not eql nil
      end
    end

    describe 'simple piece moves' do
      it 'validates Nf3' do
        expect(parse_notation('Nf3')).to_not eql nil
      end
      it 'validates Bg5' do
        expect(parse_notation('Bg5')).to_not eql nil
      end
      it 'validates Qd4' do
        expect(parse_notation('Qd4')).to_not eql nil
      end
      it 'validates Ke2' do
        expect(parse_notation('Ke2')).to_not eql nil
      end
      it 'validates Ra4' do
        expect(parse_notation('Ra4')).to_not eql nil
      end
    end

    describe 'captures' do
      it 'validates exd5' do
        expect(parse_notation('exd5')).to_not eql nil
      end
      it 'validates Bxf7' do
        expect(parse_notation('Bxf7')).to_not eql nil
      end
      it 'validates Qxd8' do
        expect(parse_notation('Qxd8')).to_not eql nil
      end
      it 'validates Nxe5' do
        expect(parse_notation('Nxe5')).to_not eql nil
      end
    end

    describe 'specific piece disambiguation' do
      it 'validates Nge2' do
        expect(parse_notation('Nge2')).to_not eql nil
      end
      it 'validates R1a3' do
        expect(parse_notation('R1a3')).to_not eql nil
      end
      it 'validates Qh4e1' do
        expect(parse_notation('Qh4e1')).to_not eql nil
      end
    end

    describe 'promotions' do
      it 'validates e8=Q' do
        expect(parse_notation('e8=Q')).to_not eql nil
      end
      it 'validates a1=N' do
        expect(parse_notation('a1=N')).to_not eql nil
      end
      it 'validates h8=R' do
        expect(parse_notation('h8=R')).to_not eql nil
      end
    end

    describe 'captures with promotions' do
      it 'validates exf8=Q' do
        expect(parse_notation('exf8=Q')).to_not eql nil
      end
      it 'validates hxg1=B' do
        expect(parse_notation('hxg1=B')).to_not eql nil
      end
    end

    describe 'invalid moves' do
      it 'invalidates e9' do
        expect(parse_notation('e9')).to eql nil
      end
      it 'invalidates Px' do
        expect(parse_notation('Px')).to eql nil
      end
      it 'invalidates H4' do
        expect(parse_notation('H4')).to eql nil
      end
      it 'invalidates e8=P' do
        expect(parse_notation('e8=P')).to eql nil
      end
      it 'invalidates Ae4' do
        expect(parse_notation('Ae4')).to eql nil
      end
    end
  end
  describe '#to_coordinates' do
    it 'converts row 0, column 0 to "a1"' do
      expect(to_coordinates(0, 0)).to eq('a1')
    end

    it 'converts row 0, column 7 to "h1"' do
      expect(to_coordinates(0, 7)).to eq('h1')
    end

    it 'converts row 7, column 0 to "a8"' do
      expect(to_coordinates(7, 0)).to eq('a8')
    end

    it 'converts row 7, column 7 to "h8"' do
      expect(to_coordinates(7, 7)).to eq('h8')
    end
    it 'converts row 3, column 5 to "f4"' do
      expect(to_coordinates(3, 5)).to eq('f4')
    end
    it 'converts row 1, column 3 to "d2"' do
      expect(to_coordinates(1, 3)).to eq('d2')
    end
  end
end
