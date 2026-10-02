//
//  TaskType.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import Foundation

enum TaskType: String, Identifiable, CaseIterable {
    case trocaOleo = "troca_oleo"
    case verificarAgua = "verificar_agua"
    
    var id: String { self.rawValue }
    
    var tutorialData: TutorialModel {
            switch self {
            case .trocaOleo:
                return TutorialModel(
                    title: "Troca de Óleo",
                    introImageName: "troca_oleo",
                    introDescription: "Entenda como funciona a troca de óleo do motor e o que é feito nesse processo.",
                    introNote: "Aviso: Antes de realizar a troca do óleo verifique o tutorial para saber o nivel do óleo.",
                    materials: [
                        TutorialMaterial(name: "Óleo de motor", description: "Consulte o manual do veículo para confirmar o tipo do óleo (Sintético, Semissintético ou Mineral)."),
                        TutorialMaterial(name: "Filtro de óleo", description: "Precisa ser o modelo específico para o motor do seu carro (consulte o manual do veículo para confirmar)."),
                        TutorialMaterial(name: "Arruela de vedação", description: "É uma junta de metal que vai no parafuso do cárter (onde o óleo fica armazenado) para evitar vazamentos.")
                    ],
                    steps: [
                        TutorialStep(
                            title: "Passo 2: Substituição do filtro e abastecimento",
                            description: "Você terá que ter acesso a parte de baixo do carro. Você pode usar um macaco automotivo acompanhado de cavaletes de segurança. \n Deite-se embaixo do motor e procure por uma peça redonda (o filtro de óleo) e um parafuso solitário na base do motor (o plugue do cárter). \n Posicione uma bacia embaixo desse parafuso, solte-o com uma chave e deixe o óleo velho escorrer até o fim.",
                            imageName: "passo1_oleo",
                            warningMessage: "Aviso: Nunca fique embaixo do carro segurado apenas pelo macaco hidráulico."
                        ),
                        TutorialStep(
                            title: "Passo 2: Adicionando o fluido",
                            description: "Assim que óleo antigo terminar de escorrer, desenrosque o filtro de óleo antigo e troque-o por um novo. /n Antes de fechar a parte de baixo, substitua a arruela de vedação antiga por uma nova, recoloque o plugue no cárter e aperte. /n Para finalizar, vá para a parte de cima do carro e abra a tampa do motor. Com a ajuda de um funil, coloque o óleo novo na quantidade exata indicada pelo manual e use a vareta para checar se atingiu o nível ideal.",
                            imageName: "troca_oleo",
                            warningMessage: "Aviso: Lubrifique a borracha do filtro novo com um pouco de óleo antes de rosquear e aperte-o apenas com a força das mãos."
                        )
                    ]
                )
                
            case .verificarAgua:
                return TutorialModel(
                    title: "Ver e Trocar Água",
                    introImageName: "troca_oleo",
                    introDescription: "Entenda como funciona para checar e colocar o fluido de arrefecimento...",
                    introNote: "Aviso: Cheque com o motor totalmente frio...",
                    materials: [
                        TutorialMaterial(name: "Fluido de arrefecimento", description: "Consulte o manual do veículo..."),
                        TutorialMaterial(name: "Água desmineralizada", description: "Se o seu fluido for do tipo concentrado..."),
                        TutorialMaterial(name: "Pano Grosso", description: "Para proteger sua mão ao abrir a tampa...")
                    ],
                    steps: [
                        TutorialStep(
                            title: "Passo 1: Localização e inspeção visual",
                            description: "Abra o capô do carro e trave-o...",
                            imageName: "drop.triangle",
                            warningMessage: "Aviso: Nunca abra a tampa do radiador ou do reservatório com o motor quente..."
                        ),
                        TutorialStep(
                            title: "Passo 2: Adicionando o fluido",
                            description: "Se o nível do líquido estiver perto ou abaixo...",
                            imageName: "engine.combustion",
                            warningMessage: "Aviso: É normal o nível baixar ao longo de muitos meses..."
                        )
                    ]
                )
            }
        }
}
