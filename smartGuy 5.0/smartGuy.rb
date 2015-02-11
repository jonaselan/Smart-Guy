require 'gosu'
require 'jogador'
require 'mapa'

class SmartGuy < Gosu::Window
  @@formato = [3, 1.0, 1.0, 0xffffffff]
  attr_reader :map, :placar

  def initialize
    super(640, 480, false)
    self.caption = "Smart Guy"
    #plano de fundo do jogo
    @sky = Gosu::Image.new(self, "fundo.png", true)
    #plano de fundo da tela inicial e pause
    @fundoMenus = Gosu::Image.new(self, "Space.png", true)
    #carregando o mapa
    @map = Mapa.new(self, "Mapa.txt")
    #carregando a trilha sonora do jogo
    @trilha = Gosu::Song.new(self, "trilha.ogg")
    #carregando o jogo
    @jogador = Jogador.new(self, 100, 1650) 
    #carregando a chave
    @keyPlacar = Gosu::Image.new(self, "key.png", true)
    #texto da porcentagem
    @fonteIndidicador = Gosu::Font.new(self, Gosu::default_font_name, 40)
  
    #texto condição
    @fonteCondicao = Gosu::Font.new(self, Gosu::default_font_name, 20)

    #texto dos menus
    @fonte = Gosu::Font.new(self, "happy hell", 20)
    #mensagem dos menus
    @msgInicio = Gosu::Image.from_text(self, "SMART GUY", "Broadway", 80)
    @msgPause = Gosu::Image.from_text(self, "PAUSE", "Broadway", 60)
    @msgFim = Gosu::Image.from_text(self, "FIM DE JOGO!", "Broadway", 80)
    #estado do jogo
    @estado = "INICIO"
    #criando o placar do jogo
    @placar = 0    
    # Posicao da "camera" é no topo esquerdo do mapa
    @camera_x = @camera_y = 0
  end

public
  def update
    if button_down?(Gosu::KbP) then @estado = "PAUSE" end
    if    @estado == "INICIO" then 
      update_inicio      
    elsif @estado == "JOGANDO" then 
      update_jogando
    elsif @estado == "PAUSE" then 
      update_pause
    elsif (@estado == "FIM") then
      update_fim
    end 
  end

  def draw
    #@sky.draw(0,0,0)

      if (@draw_negacao == true) then
        draw_negacao
      end

      if    @estado == "INICIO"  then draw_inicio
      elsif @estado == "JOGANDO" then draw_jogando
      elsif @estado == "PAUSE" then draw_pause
      elsif @estado == "FIM" then draw_fim    
    end 
  end  

private 
  def update_pause
    @trilha.pause
    @estado = "JOGANDO" if button_down?(Gosu::KbI)
    if button_down?(Gosu::KbEscape) then close end
  end

private
  def draw_pause
    @fundoMenus.draw 0,0,0
    msg = "PRESSIONE [ I ] PARA CONTINUAR" 
    msg2 = "PRESSIONE [ ESC ] PARA SAIR"
    @msgPause.draw(230,180,0)
    x = self.width / 2 - @fonte.text_width(msg,1) / 2
    @fonte.draw(msg, x, self.height/2, *@@formato)
    @fonte.draw(msg2, x+17, self.height/1.8, *@@formato)
  end


private 
  def update_inicio
    @estado = "JOGANDO" if button_down?(Gosu::KbI)
    if button_down?(Gosu::KbEscape) then close end
  end

private
  def draw_inicio
    @fundoMenus.draw 0,0,0
    msg = "PRESSIONE [I] PARA COMECAR"
    msg2 = "PRESSIONE [ ESC ] PARA SAIR"
    @msgInicio.draw(110,150,0)
    x = self.width / 2 - @fonte.text_width(msg,1) / 2
    @fonte.draw(msg, x, self.height/2, *@@formato)
    @fonte.draw(msg2, x+5, self.height/1.8, *@@formato)
  end

  def update_jogando  
    @trilha.play 
    if button_down? Gosu::KbEscape then close end
      move_x = 0

    if button_down? Gosu::KbLeft or button_down?(Gosu::GpLeft) then
      move_x -= 5
    end
  
    if button_down? Gosu::KbRight or button_down?(Gosu::GpRight) then
      move_x += 5
    end
    
    if button_down? Gosu::KbUp  or button_down?(Gosu::GpUp) then 
      @jogador.try_to_jump 
    end

      @jogador.update(move_x, @placar)
      # adc +5 ao placar
      @placar += @jogador.collect_keys(@map.keys)
    
      if (@jogador.enter_door(@map.doors) == 2) then
          @estado = "FIM"
        elsif (@jogador.enter_door(@map.doors) == 1) then
          @draw_negacao = true 
        else 
          @draw_negacao = false 
      end

    # camera segue o jogador
    @camera_x = [[@jogador.x - 320, 0].max, @map.width * 50 - 640].min
    @camera_y = [[@jogador.y - 240, 0].max, @map.height * 50 - 480].min
  end

  def draw_negacao 
    @fonteCondicao.draw("Pegue mais chaves", 45, 50, 50, 1.0, 1.0, 0xffffffff) 
  end

  def draw_jogando
      @sky.draw -@camera_x, -@camera_y, 0        
      @keyPlacar.draw 25,10,1
      #desenhar placar
      @fonteIndidicador.draw("#{@placar}%", 80, 10, *@@formato)  

    # Faz com que tudo dentro do bloco seja desenhado deslocado
    translate(-@camera_x, -@camera_y) do
      @map.draw
      @jogador.draw
    end
  end

  def update_fim 
    #colocar outra música
    @trilha.pause
    if button_down?(Gosu::KbEscape) then close end
  end

  def draw_fim
    @fundoMenus.draw 0,0,0
    @msgFim.draw(110,150,0)
    msg = "PRESSIONE [ ESC ] PARA SAIR"
    x = self.width / 2 - @fonte.text_width(msg,1) / 2
    @fonte.draw(msg, x+5, self.height/1.8, *@@formato)
  end
end