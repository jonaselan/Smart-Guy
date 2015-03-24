require 'gosu'
require 'key'
require 'door'

class Mapa
  attr_reader :width, :height, :keys, :doors

  def initialize(window, filename)
    # Load 60x60 tiles, 5px overlap in all four directions.
    # carrega imagens de 60x60, com 5 pixel de sobreposição 
    # nas quatro direções
    @tileset = Gosu::Image.load_tiles(window, "imagens/sprite.png", 60, 60, true)
    # 0 chao
    # 1 bolsa
    # 2 lampada
    # 3 direita chao
    # 4 esquerda chao
    # 5 parede esquerda
    # 6 direita parede
    # 7 solo
    # 8 escada esquerda
    # 9 escada direta
    # 10 porta
    # 11 quinas esquerda
    # 12 quinas direita
    key_img = Gosu::Image.new(window, "imagens/key.png", false)
    @keys = []

    door_img = Gosu::Image.new(window, "imagens/door.png", false)
    @doors = []

    lines = File.readlines(filename).map do |line| 
      line.chomp 
    end
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y| #Caracteres para cada array da imagem
        case lines[y][x, 1]
        when '#'
          0
        when 'b'
          1
        when 'l'
          2
        when 'q'
          3
        when 't'
          4
        when 'e'
          5
        when 'd'
          6  
        when 'c'
          7  
        when '/'
          8  
        when ';'
          9  
        when 'p'
          10  
        when 'n' #esquerda
          11
        when 'm' #direita
          12
        when 'y'
          @doors.push(Door.new(door_img, x * 50 + 25, y * 50 + 25))
            nil
        when 'x'
          @keys.push(Key.new(key_img, x * 50 + 25, y * 50 + 25))
            nil
        else
          nil
        end
      end
    end
  end

  def draw
    # Função de desenho simplificada:
    #  - Desenha TODOS os quadros. uns na tela outros fora da tela
    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        if tile
          @tileset[tile].draw(x * 50 - 5, y * 50 - 5, 0)
        end
      end
    end
    @keys.each do |c| c.draw end
    @doors.each do |c| c.draw end
  end

  # Método que retorna verdadeiro se o pixel das 
  # cordenadas (x,y) passadas é sólido
  def solid?(x, y)
    y < 0 || @tiles[x / 50][y / 50]
  end
end
