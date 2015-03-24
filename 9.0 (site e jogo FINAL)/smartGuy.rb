#encoding: utf-8
require 'gosu'
require 'jogador'
require 'inimigo'
require 'mapa'
require 'efeito'
require 'xmlcompilar'
class SmartGuy < Gosu::Window
  @@formato = [3, 1.0, 1.0, 0xffffffff]
  attr_reader :map, :placar

  def initialize
    super(640, 480, false)
    self.caption = "Smart Guy"
    #plano de fundo do jogo
    @sky = Gosu::Image.new(self, "imagens/fundo1.png", true)
    #plano de fundo da tela inicial e pause
    @fundoMenus = Gosu::Image.new(self, "imagens/Space.png", true)
    @pos_x_background = 0
    #carregando o mapa da primeira fase
    @map = Mapa.new(self, "Mapa.txt")
    #carregar o efeito das fases 
    @efeito = Efeito.new(self)
    @faseStatus = "fase1"
    @fase = 1
    #texto Tempo
    @tmp = Gosu::Font.new(self, "Arial", 20)
    @seg = 0.0
    @min = 0.0
    #carregando a trilha sonora do jogo
    @trilha = Gosu::Song.new(self, "audios/trilhaAntiga.ogg")
    #carregando audio da morte
    @dead = Gosu::Sample.new(self, "audios/dead.wav") 
    #carregando o jogador
    @jogador = Jogador.new(self, 100, 1650) 
    #carregando o inimigos do fase 1
    @inimigo1 = []
    @inimigo1[0] = Inimigo.new(self, 1924, 1749)
    @inimigo1[1] = Inimigo.new(self, 1219, 1299)
    @inimigo1[2] = Inimigo.new(self, 1084, 849)
    @inimigo1[3] = Inimigo.new(self, 1834, 399)
    #carregando o inimigos do fase 2
    @inimigo2 = []
    @inimigo2[0] = Inimigo.new(self, 1344, 1749)
    @inimigo2[1] = Inimigo.new(self, 280, 1299)
    @inimigo2[2] = Inimigo.new(self, 1434, 849)
    @inimigo2[3] = Inimigo.new(self, 1790, 399)

    #carregando a chave
    @keyPlacar = Gosu::Image.new(self, "imagens/key.png", true)
    #texto da porcentagem
    @fonteIndidicador = Gosu::Font.new(self, Gosu::default_font_name, 40)
    #texto condição
    @fonteCondicao = Gosu::Font.new(self, Gosu::default_font_name, 20)
    #texto dos menus
    @fonte = Gosu::Font.new(self, "Arial", 20)
    #mensagem dos menus
    @msgInicio = Gosu::Image.from_text(self, "SMART GUY", "Broadway", 80)
    @msgPause = Gosu::Image.from_text(self, "PAUSE", "Broadway", 80)
    @msgFim = Gosu::Image.from_text(self, "FIM DE JOGO!", "Broadway", 80)
    #estado do jogo
    @estado = "INICIO"
    #criando o placar do jogo
    @placar = 0    
    # Posicao da "camera" é no topo esquerdo do mapa
    @camera_x = @camera_y = 0
    @moveJogador_x = 0
    @moveInimigo_x = 0
    #fonte none do Usuario
    @fonteUsuario = Gosu::Font.new(self, "Arial", 50)
    #Entrada do teclado
    self.text_input = Gosu::TextInput.new
    @nomeUsuario = ""
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
    self.caption = "Smart Guy: #{@nomeUsuario}"
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
    @pos_x_background = @pos_x_background - 5
    if(@pos_x_background<(-3070))then @pos_x_background = 0 end

    @estado = "JOGANDO" if button_down?(Gosu::KbSpace)
    if button_down?(Gosu::KbEscape) then close end
  end

private
  def draw_pause
    @fundoMenus.draw(@pos_x_background,0,0)
    @fundoMenus.draw(@pos_x_background+3070, 0, 0)

    msg = "PRESSIONE [ ESPACE ] PARA CONTINUAR" 
    msg2 = "PRESSIONE [ ESC ] PARA SAIR"
    @msgPause.draw((self.width/2 - @msgPause.width/2),(self.height/2-70 - @msgPause.height/2),0)
    @fonte.draw(msg, (self.width/2 - @fonte.text_width(msg,1)/2),(self.height/2 - @fonte.height/2),*@@formato)
    @fonte.draw(msg2, (self.width/2 - @fonte.text_width(msg2,1)/2),(self.height/2+30 - @fonte.height/2),*@@formato)
  end

private 
  def update_inicio
    @pos_x_background = @pos_x_background - 5
    if(@pos_x_background<(-3070))then @pos_x_background = 0 end
    
    @estado = "JOGANDO" if button_down?(Gosu::KbSpace)
    if button_down?(Gosu::KbEscape) then close end
    @nomeUsuario = self.text_input.text.upcase
  end

private
  def draw_inicio
    @fundoMenus.draw(@pos_x_background,0,0)
    @fundoMenus.draw(@pos_x_background+3070, 0, 0)

    msg = "PRESSIONE [ ESPACE ] PARA COMECAR"
    msg2 = "PRESSIONE [ ESC ] PARA SAIR"
    msg3 = "INFORME SEU NOME: "
    @msgInicio.draw((self.width/2 - @msgInicio.width/2),(self.height/2-70 - @msgInicio.height/2),0)
    @fonte.draw(msg, (self.width/2 - @fonte.text_width(msg,1)/2),(self.height/2 - @fonte.height/2),*@@formato)
    @fonte.draw(msg2, (self.width/2 - @fonte.text_width(msg2,1)/2),(self.height/2+30 - @fonte.height/2),*@@formato)
    @fonte.draw(msg3, (self.width/2 - @fonte.text_width(msg3,1)/2),(self.height/2+60 - @fonte.height/2),*@@formato)
    @fonteUsuario.draw(@nomeUsuario, self.width/2-@fonteUsuario.text_width(@nomeUsuario,1)/2, (self.height/2+80 - @fonte.height/2),*@@formato)
  end

  def update_jogando  
        @trilha.play 
         if (@faseStatus == "fase1") then
          for i in 0..3 do          
            if ((@jogador.x - @inimigo1[i].x).abs < 10 && (@jogador.y - @inimigo1[i].y).abs < 10) then        
              # jogador morreu e volta para inicio da fase
              @jogador = Jogador.new(self, 100, 1650) 
              @dead.play
            end
          end
        elsif (@faseStatus == "fase2") then
         for i in 0..3 do          
            if ((@jogador.x - @inimigo2[i].x).abs < 10 && (@jogador.y - @inimigo2[i].y).abs < 10) then        
              # jogador morreu e volta para inicio da fase
              @jogador = Jogador.new(self, 100, 1650) 
              @dead.play
            end
          end
        end

    if button_down? Gosu::KbEscape then close end

    #movimentação do jogador
      @moveJogador_x = 0
    if button_down? Gosu::KbLeft or button_down?(Gosu::GpLeft) then
      @moveJogador_x -= 5
    end
  
    if button_down? Gosu::KbRight or button_down?(Gosu::GpRight) then
      @moveJogador_x += 5
    end
    
    if button_down? Gosu::KbUp or button_down?(Gosu::GpUp) then 
      @jogador.try_to_jump 
    end

    #cronometro
    @seg += 1.0/60.0
    if (@seg.to_i == 60) then
        @seg = 0.0
        @min += 1
    end

      #movimentação inimigo
    if (@seg.to_i%2==0) then
      @moveInimigo_x = 3
    else
      @moveInimigo_x = -3
    end
    

    @jogador.update(@moveJogador_x, @placar)      
     # adc +5 ao placar
    @placar += @jogador.collect_keys(@map.keys)
          
      if (@faseStatus == "fase1") then
        @efeito.update("1")
            for i in 0..3 do          
              @inimigo1[i].update(@moveInimigo_x) 
            end
      elsif (@faseStatus == "fase2") then
            for i in 0..3 do          
              @inimigo2[i].update(@moveInimigo_x) 
            end
        @efeito.update("2")
      end  

      if ((@jogador.enter_door(@map.doors) == 2) && (@fase == 1)) then
          #segunda fase
          @faseStatus = "fase2"
          @sky = Gosu::Image.new(self, "imagens/fundo2.png", true)
          @map = Mapa.new(self,"Mapa2.txt")
          @jogador = Jogador.new(self, 100, 1650)          
          @fase = 2 
          @placar = 0
        elsif ((@jogador.enter_door(@map.doors) == 2) && (@fase == 2)) then
          @estado = "FIM"
        elsif ((@jogador.enter_door(@map.doors) == 1)) then
          @draw_negacao = true
        else 
          @draw_negacao = false 
      end

    # camera segue o jogador
    @camera_x = [[@jogador.x - 320, 0].max, @map.width * 50 - 640].min
    @camera_y = [[@jogador.y - 240, 0].max, @map.height * 50 - 480].min
  end

  def draw_jogando
      # sem isso da um bug do caramba
      self.text_input = nil

      @sky.draw -@camera_x, -@camera_y, 0        
      @keyPlacar.draw 25,10,1
            
        if (@faseStatus == "fase1") then
          @efeito.draw("1")
          elsif (@faseStatus == "fase2") then
          @efeito.draw("2")          
        end

      #desenhar placar
      @fonteIndidicador.draw("#{@placar}%", 80, 10, *@@formato)  
      # Faz com que tudo dentro do bloco seja desenhado deslocado
      translate(-@camera_x, -@camera_y) do      
              
      @map.draw
      @jogador.draw
        # verificar se o inimigo é da primeira fazer ou segunda para puxar o array
      if (@faseStatus == "fase1") then
        for i in 0..3 do  
          @inimigo1[i].draw
        end
      elsif (@faseStatus == "fase2") then
        for i in 0..3 do  
          @inimigo2[i].draw
        end
      end
      end
  end

  def draw_negacao 
    @fonteCondicao.draw("Colete mais chaves", 45, 50, 50, 1.0, 1.0, 0xffffffff) 
  end

  def update_fim 
    @trilha.pause
    @pos_x_background = @pos_x_background - 5
    if(@pos_x_background<(-3070))then @pos_x_background = 0 end

    if button_down?(Gosu::KbEscape) then close end
       GerarXML.new(("%.2d"% @min.to_i+":"+"%.2d"% @seg.to_i).to_s, @nomeUsuario)
  end

  def draw_fim
    @fundoMenus.draw(@pos_x_background,0,0)
    @fundoMenus.draw(@pos_x_background+3070, 0, 0)

    msg = ("Tempo total: " + "%.2d"% @min.to_i+":"+"%.2d"% @seg.to_i)    
    msg2 = "PRESSIONE [ ESC ] PARA SAIR"
    msg3 = "PARABÉNS, #{@nomeUsuario}"
    @fonte.draw(msg3, (self.width/2 - @fonte.text_width(msg3,1)/2),(self.height/2+60 - @fonte.height/2),*@@formato)
    #@fonteUsuario.draw((self.width/2 - @msg3.width/2),(self.height/2-70 - @msg3.height/2),0)
    @msgFim.draw((self.width/2 - @msgFim.width/2),(self.height/2-70 - @msgFim.height/2),0)
    @tmp.draw(msg, (self.width/2 - @fonte.text_width(msg,1)/2),(self.height/2 - @fonte.height/2),*@@formato)
    @fonte.draw(msg2, (self.width/2 - @fonte.text_width(msg2,1)/2),(self.height/2+30 - @fonte.height/2),*@@formato)
  end 
end