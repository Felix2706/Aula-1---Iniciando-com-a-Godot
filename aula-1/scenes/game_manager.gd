# Arquivo game_manager.gd

extends Node

const VIDAS_INICIAIS := 3

var vidas: int = VIDAS_INICIAIS
var moedas: int = 0
var speed_boost_ativo: bool = false

signal moeda_coletada(total: int)
signal speed_boost_mudou(ativo: bool)

func resetar_jogo() -> void:
	vidas = VIDAS_INICIAIS
	moedas = 0
	speed_boost_ativo = false
	speed_boost_mudou.emit(false)

func adicionar_moeda() -> void:
	moedas += 1
	moeda_coletada.emit(moedas)
