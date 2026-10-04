//
//  TaskType.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import Foundation

enum TaskType: String, Identifiable, CaseIterable, Hashable {
    case oilChange = "troca_oleo"
    case oilCheck = "verificar_oleo"
    case waterCheck = "verificar_agua"
    case brakeCheck = "verificar_freios"
    case tireCalibration = "calibrar_pneus"
    case batteryCheck = "verificar_bateria"
    
    var id: String {
        rawValue
    }
    
    var displayTitle: String {
        switch self {
        case .oilChange:
            return "Troca de Óleo"
        case .oilCheck:
            return "Verificação de Óleo"
        case .waterCheck:
            return "Ver e Trocar Água"
        case .brakeCheck:
            return "Checagem dos Freios"
        case .tireCalibration:
            return "Calibragem dos Pneus"
        case .batteryCheck:
            return "Checagem da Bateria"
        }
    }
    
    var duration: String {
        switch self {
        case .oilChange:
            return "8 min"
        case .oilCheck:
            return "3 min"
        case .waterCheck:
            return "2 min"
        case .brakeCheck:
            return "5 min"
        case .tireCalibration:
            return "3 min"
        case .batteryCheck:
            return "5 min"
        }
    }
    
    var level: String {
        switch self {
        case .oilChange:
            return "Intermediário"
        default:
            return "Iniciante"
        }
    }
    
    var tutorialData: TutorialModel {
        switch self {
        case .oilChange:
            return oilChangeTutorial
        case .oilCheck:
            return oilCheckTutorial
        case .waterCheck:
            return waterCheckTutorial
        case .brakeCheck:
            return brakeCheckTutorial
        case .tireCalibration:
            return tireCalibrationTutorial
        case .batteryCheck:
            return batteryCheckTutorial
        }
    }
}

private extension TaskType {
    var oilChangeTutorial: TutorialModel {
        TutorialModel(
            title: "Troca de Óleo",
            introImage: .asset(
                name: "troca_oleo",
                fallback: "drop.fill"
            ),
            introDescription: "Entenda como funciona a troca de óleo do motor e o que é feito nesse processo.",
            introNote: "Aviso: Antes de realizar a troca do óleo, verifique o tutorial e o nível do óleo.",
            materials: [
                TutorialMaterial(
                    name: "Óleo de motor",
                    description: "Consulte o manual do veículo para confirmar o tipo do óleo: sintético, semissintético ou mineral."
                ),
                TutorialMaterial(
                    name: "Filtro de óleo",
                    description: "Use o modelo específico para o motor do seu carro."
                ),
                TutorialMaterial(
                    name: "Arruela de vedação",
                    description: "A arruela fica no parafuso do cárter e ajuda a evitar vazamentos."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Esvaziamento do óleo antigo",
                    description: """
                    Você terá que ter acesso à parte de baixo do carro. Use um macaco automotivo acompanhado de cavaletes de segurança.
                    
                    Deite-se embaixo do motor e procure pelo filtro de óleo e pelo parafuso do cárter.
                    
                    Posicione uma bacia embaixo do parafuso, solte-o com uma chave e deixe o óleo antigo escorrer até o fim.
                    """,
                    image: .asset(
                        name: "passo1_oleo",
                        fallback: "wrench.and.screwdriver.fill"
                    ),
                    warningMessage: "Aviso: Nunca fique embaixo do carro apoiado apenas pelo macaco hidráulico."
                ),
                TutorialStep(
                    title: "Passo 2: Substituição do filtro e abastecimento",
                    description: """
                    Assim que o óleo antigo terminar de escorrer, desenrosque o filtro antigo e troque-o por um novo.
                    
                    Substitua também a arruela de vedação, recoloque o plugue no cárter e aperte-o.
                    
                    Depois, coloque o óleo novo na quantidade indicada pelo manual e use a vareta para conferir o nível.
                    """,
                    image: .asset(
                        name: "troca_oleo",
                        fallback: "drop.fill"
                    ),
                    warningMessage: "Aviso: Lubrifique a borracha do filtro novo com um pouco de óleo e aperte-o apenas com a força das mãos."
                )
            ]
        )
    }
    
    var oilCheckTutorial: TutorialModel {
        TutorialModel(
            title: "Verificação de Óleo",
            introImage: .asset(
                name: "verificacao_oleo",
                fallback: "magnifyingglass"
            ),
            introDescription: "Entenda como verificar o nível de óleo do motor corretamente.",
            introNote: "Aviso: Faça a checagem com o motor desligado há pelo menos 10 minutos e o carro estacionado em uma superfície plana.",
            materials: [
                TutorialMaterial(
                    name: "Pano limpo ou papel toalha",
                    description: "Use para limpar a vareta e garantir uma leitura correta do nível."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Localização e limpeza da vareta",
                    description: """
                    Com o motor frio, abra o capô e localize a vareta de nível.
                    
                    Puxe a vareta completamente para fora e limpe toda a ponta com um pano limpo.
                    
                    Depois, coloque a vareta novamente até o final.
                    """,
                    image: .asset(
                        name: "verificacao_oleo",
                        fallback: "magnifyingglass"
                    ),
                    warningMessage: "Aviso: Se o motor estiver funcionando ou recém-desligado, a leitura poderá ficar incorreta."
                ),
                TutorialStep(
                    title: "Passo 2: Medição do nível",
                    description: """
                    Aguarde alguns segundos e retire a vareta novamente.
                    
                    Observe as marcações de mínimo e máximo. O óleo deve estar entre as duas marcações.
                    
                    Se estiver próximo do mínimo, complete usando o mesmo tipo de óleo recomendado pelo manual.
                    """,
                    image: .system("gauge.with.dots.needle.67percent"),
                    warningMessage: "Aviso: O óleo não deve ficar abaixo da marca mínima nem acima da marca máxima."
                )
            ]
        )
    }
    
    var waterCheckTutorial: TutorialModel {
        TutorialModel(
            title: "Ver e Trocar Água",
            introImage: .asset(
                name: "verificar_agua",
                fallback: "drop.fill"
            ),
            introDescription: "Aprenda a verificar e completar o fluido de arrefecimento do radiador.",
            introNote: "Aviso: Faça o procedimento somente com o motor totalmente frio.",
            materials: [
                TutorialMaterial(
                    name: "Fluido de arrefecimento",
                    description: "Consulte o manual para saber qual fluido é recomendado para o seu veículo."
                ),
                TutorialMaterial(
                    name: "Água desmineralizada",
                    description: "Use água desmineralizada quando o fluido concentrado precisar ser diluído."
                ),
                TutorialMaterial(
                    name: "Pano grosso",
                    description: "Use para proteger a mão ao abrir a tampa do reservatório."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Localização e inspeção visual",
                    description: """
                    Abra o capô e localize o reservatório de expansão.
                    
                    Observe as marcações de mínimo e máximo na lateral do reservatório.
                    
                    O fluido deve estar entre essas duas marcações.
                    """,
                    image: .asset(
                        name: "verificar_agua",
                        fallback: "drop.fill"
                    ),
                    warningMessage: "Aviso: Nunca abra a tampa do radiador ou do reservatório com o motor quente."
                ),
                TutorialStep(
                    title: "Passo 2: Adicionando o fluido",
                    description: """
                    Se o nível estiver próximo ou abaixo da marca mínima, adicione o fluido recomendado.
                    
                    Complete até próximo da marca máxima, sem ultrapassá-la.
                    
                    Se o nível baixar frequentemente, procure uma oficina para verificar possíveis vazamentos.
                    """,
                    image: .system("drop.fill"),
                    warningMessage: "Aviso: Se for necessário completar o reservatório toda semana ou todo mês, pode existir um vazamento."
                )
            ]
        )
    }
    
    var brakeCheckTutorial: TutorialModel {
        TutorialModel(
            title: "Checagem dos Freios",
            introImage: .asset(
                name: "verificar_freios",
                fallback: "exclamationmark.triangle.fill"
            ),
            introDescription: "Aprenda a identificar sinais de desgaste nas pastilhas e nos discos de freio.",
            introNote: "Aviso: A inspeção deve ser feita com o carro frio e em local seguro.",
            materials: [
                TutorialMaterial(
                    name: "Lanterna",
                    description: "A lanterna do celular pode ajudar a iluminar a parte interna da roda."
                ),
                TutorialMaterial(
                    name: "Histórico de revisões",
                    description: "Consulte quando as pastilhas e os discos foram substituídos pela última vez."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Inspeção visual",
                    description: """
                    Aponte uma lanterna pelos espaços da roda.
                    
                    Procure pelo disco de freio e observe se há riscos profundos, rachaduras ou sinais de desgaste excessivo.
                    
                    Em algumas rodas traseiras, o veículo pode utilizar tambores em vez de discos.
                    """,
                    image: .asset(
                        name: "verificar_freios",
                        fallback: "exclamationmark.triangle.fill"
                    ),
                    warningMessage: "Aviso: Nunca toque nos discos logo após dirigir. Eles podem estar extremamente quentes."
                ),
                TutorialStep(
                    title: "Passo 2: Avaliação do desgaste",
                    description: """
                    Observe se existe um degrau muito profundo na borda do disco.
                    
                    Vibrações no pedal ou no volante durante a frenagem podem indicar problemas no disco.
                    
                    A medição correta da espessura deve ser feita por um profissional.
                    """,
                    image: .system("exclamationmark.triangle.fill"),
                    warningMessage: "Aviso: Se houver vibração forte ou ruídos durante a frenagem, procure uma oficina."
                )
            ]
        )
    }
    
    var tireCalibrationTutorial: TutorialModel {
        TutorialModel(
            title: "Calibragem dos Pneus",
            introImage: .asset(
                name: "calibrar_pneus",
                fallback: "gauge.with.dots.needle.67percent"
            ),
            introDescription: "Aprenda a conferir e ajustar corretamente a pressão dos pneus.",
            introNote: "Aviso: Faça a calibragem preferencialmente com os pneus frios.",
            materials: [
                TutorialMaterial(
                    name: "Calibrador de pneus",
                    description: "Pode ser um compressor com medidor de pressão ou o equipamento de um posto."
                ),
                TutorialMaterial(
                    name: "Manual do veículo",
                    description: "Consulte a pressão recomendada para os pneus dianteiros, traseiros e estepe."
                ),
                TutorialMaterial(
                    name: "Medidor de pressão",
                    description: "Use um manômetro caso o equipamento não tenha um medidor confiável."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Conferência da pressão",
                    description: """
                    Deixe o carro parado tempo suficiente para que os pneus estejam frios.
                    
                    Consulte a etiqueta na porta do motorista ou o manual do veículo.
                    
                    Confira a pressão dos quatro pneus e também do estepe, se houver.
                    """,
                    image: .asset(
                        name: "calibrar_pneus",
                        fallback: "gauge.with.dots.needle.67percent"
                    ),
                    warningMessage: "Aviso: Não esvazie um pneu quente para tentar atingir a pressão recomendada."
                ),
                TutorialStep(
                    title: "Passo 2: Ajuste da pressão",
                    description: """
                    Se a pressão estiver abaixo da recomendada, adicione ar aos poucos.
                    
                    Se estiver acima, libere pequenas quantidades e confira novamente.
                    
                    Recoloque as tampas das válvulas ao finalizar.
                    """,
                    image: .system("gauge.with.dots.needle.67percent"),
                    warningMessage: "Aviso: A pressão pode ser diferente entre os eixos e quando o veículo estiver carregado."
                )
            ]
        )
    }
    
    var batteryCheckTutorial: TutorialModel {
        TutorialModel(
            title: "Checagem da Bateria",
            introImage: .asset(
                name: "verificar_bateria",
                fallback: "battery.100percent"
            ),
            introDescription: "Aprenda a identificar sinais de desgaste ou problemas na bateria do veículo.",
            introNote: "Aviso: Faça a inspeção com o carro desligado, em local ventilado e sem chamas ou faíscas.",
            materials: [
                TutorialMaterial(
                    name: "Lanterna",
                    description: "Use a lanterna do celular para visualizar os terminais e o compartimento."
                ),
                TutorialMaterial(
                    name: "Multímetro",
                    description: "Pode ser usado para medir a tensão da bateria."
                ),
                TutorialMaterial(
                    name: "Manual do veículo",
                    description: "Consulte as orientações específicas do sistema elétrico do seu carro."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Inspeção visual dos terminais",
                    description: """
                    Com o carro desligado, abra o capô e localize a bateria.
                    
                    Observe se existem trincas, vazamentos, deformações ou corrosão excessiva.
                    
                    Os terminais positivo e negativo devem estar firmes e limpos.
                    """,
                    image: .asset(
                        name: "verificar_bateria",
                        fallback: "battery.100percent"
                    ),
                    warningMessage: "Aviso: Nunca coloque objetos metálicos entre os dois terminais da bateria."
                ),
                TutorialStep(
                    title: "Passo 2: Teste da tensão",
                    description: """
                    Se possuir um multímetro, selecione a função de tensão contínua.
                    
                    Encoste a ponta positiva no terminal positivo e a ponta negativa no terminal negativo.
                    
                    Compare a leitura com a especificação do veículo. Se houver dificuldade para dar partida, procure uma oficina.
                    """,
                    image: .system("bolt.fill"),
                    warningMessage: "Aviso: Uma leitura baixa pode indicar bateria descarregada, mas também pode haver problema no alternador ou no sistema de carga."
                )
            ]
        )
    }
}
