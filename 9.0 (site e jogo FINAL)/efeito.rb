require 'gosu'

class Efeito
	def initialize (janela)
		@janela = janela
		@cont1 = 140
		@cont2 = 140
		@f1 = Gosu::Image.new(@janela, 'imagens/fase1.png', true)
		@f2 = Gosu::Image.new(@janela, 'imagens/fase2.png', true)
	end
	def update(fase)
		@fase = fase
		if @cont1 != 0 && @fase == "1" then
			@cont1 -=1
		end

		if @cont2 != 0 && @fase == "2" then
			@cont2 -=1
		end
	end

	def draw(fase)
		@fase = fase
		if @cont1 != 0 && @fase == "1" then
			@f1.draw_rot(@janela.width/2,@janela.height/3.5,3,0)
		elsif @cont2 != 0 && @fase == "2" then
			@f2.draw_rot(@janela.width/2,@janela.height/3.5,3,0)	
		end
	end
end