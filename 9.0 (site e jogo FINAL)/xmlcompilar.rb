#Agradeço a DEUS pelo dom do conhecimento
# encoding: utf-8
require 'rexml/document'
require 'yaml'

class GerarXML

	$jogadores = []

	def initialize (tempo, nome)
		@tempo = tempo
		@nome = nome

		$jogadores << [@tempo, @nome]
		
		carregar_arquivo
		atualizar_dados
		ordernar_jogador
		criar_ranking
		criar_xml
	end

	def carregar_arquivo
		#$jogadores = []
		$jogadores += YAML::load(File.open("arquivos/ranking.yml"))

		/
		puts "----Antigo----"
		print $jogadores
		puts "--------------"
		/
	end

	def atualizar_dados
		for linha in 0..$jogadores.size-1 do
			for coluna in 0..linha.size-1 do
				if $jogadores[linha][coluna]==@nome then
					$jogadores[linha][0]=@tempo
				end
			end
		end
		$jogadores.uniq!

		/
		puts "----Novo------"
		puts""
		print $jogadores
		puts""
		puts "--------------"
		/
		
	end

	def ordernar_jogador
		$jogadores.sort!
	end

	def criar_ranking
		arquivo = File.new("arquivos/ranking.yml", "w")
		arquivo.write $jogadores.to_yaml
		arquivo.close
	end

	def criar_xml
		documento = REXML::Document.new
		declaracao = REXML::XMLDecl.new("1.0","UTF-8")
		documento.add declaracao

		elementoRoot = REXML::Element.new("smartguy")
		documento.add_element elementoRoot

		$jogadores.each do |dados|
		win = REXML::Element.new("jogador")
		time = REXML::Element.new("tempo")
		name = REXML::Element.new("nome")

		time.text = dados[0]
		name.text = dados[1]

		win.add_element time
		win.add_element name

		elementoRoot.add win
		end

		#documento.write(File.open("smartGuy Site_v09/xml/informacao.xml","w"))
		documento.write(File.open("smartguy site_v09/paginas/informacao.xml","w"))
		documento.write(File.open("smartguy site_v09/paginas_US/informacao.xml","w"))
	end

end

/
# arquivo teste
GerarXML.new("00:02", "nos")
GerarXML.new("00:10", "eu")
GerarXML.new("05:01", "tu")
GerarXML.new("01:00", "nos")
GerarXML.new("00:11", "Testando")
/