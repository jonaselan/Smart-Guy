require 'gosu'

class Inimigo
  attr_reader :x, :y
  def initialize(window, x, y)
    @x, @y = x, y
    @dir = :left
    @vy = 0 #  Velocidade vertical
    @map = window.map
    # Carrega todas as imagens para animação
    @standing, @walk1, @walk2, @jump =
      *Gosu::Image.load_tiles(window, "imagens/Inimigo.png", 50, 50, false)
    #a imagem a ser desenhada.
    @cur_image = @standing
  end

  def draw
    if @dir == :left then
      offs_x = -25
      factor = 1.0
    else
      offs_x = 25
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 49, 0, factor, 1.0)
  end

  def would_fit(offs_x, offs_y)
    not @map.solid?(@x + offs_x, @y + offs_y) and
      not @map.solid?(@x + offs_x, @y + offs_y - 45)
  end

  def update(move_x)
    if (move_x == 0)
      @cur_image = @standing
    else
      @cur_image = (Gosu::milliseconds / 175 % 2 == 0) ? @walk1 : @walk2
    end

    if move_x > 0 then
      @dir = :right
      move_x.times do 
        if would_fit(1, 0) then @x += 1 end 
      end
    end
    if move_x < 0 then
      @dir = :left
      (-move_x).times do
         if would_fit(-1, 0) then 
           @x -= 1 end 
         end
    end

    @vy += 1
    if @vy > 0 then
      @vy.times do
        if would_fit(0, 1) then 
          @y += 1 
        else 
          @vy = 0 
        end 
      end
    end
    if @vy < 0 then
      (-@vy).times do
        if would_fit(0, -1) then 
          @y -= 1 
        else 
          @vy = 0 
        end 
      end
    end
  end

  
end