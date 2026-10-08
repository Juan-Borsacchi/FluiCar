//
//  TaskType.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import Foundation

enum TaskType: String, Identifiable, CaseIterable, Hashable, Codable {
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
            return "Ver e Trocar Água do Radiador"
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
            return "2 - 8 min"
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
                name: "change_oil",
                fallback: "drop.fill"
            ),
            introDescription: "Entenda como funciona a troca de óleo do motor e o que é feito nesse processo.",
            introNote: "Aviso: Antes de realizar a troca do óleo, verifique o tutorial e o nível do óleo.",
            materials: [
                TutorialMaterial(
                    name: "Óleo de motor",
                    description: "Consulte o manual do automóvel para confirmar o tipo do óleo: sintético, semissintético ou mineral."
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
                        name: "step1_oil",
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
                        name: "change_oil",
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
                name: "check_oil",
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
                        name: "step1_coil",
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
                    image:  .asset(
                        name: "step2_coil",
                        fallback: "magnifyingglass"
                    ),
                    warningMessage: "Aviso: O óleo não deve ficar abaixo da marca mínima nem acima da marca máxima."
                )
            ]
        )
    }
    
    var waterCheckTutorial: TutorialModel {
        TutorialModel(
            title: "Ver e Trocar Água do Radiador",
            introImage: .asset(
                name: "check_water",
                fallback: "drop.fill"
            ),
            introDescription: "Aprenda a verificar e completar o fluido de arrefecimento do radiador.",
            introNote: "Aviso: Faça o procedimento somente com o motor totalmente frio.",
            materials: [
                TutorialMaterial(
                    name: "Fluido de arrefecimento",
                    description: "Consulte o manual para saber qual fluido é recomendado para o seu automóvel."
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
                        name: "step1_cwater",
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
                    image: .asset(
                        name: "step2_cwater",
                        fallback: "drop.fill"
                    ),
                    warningMessage: "Aviso: Se for necessário completar o reservatório toda semana ou todo mês, pode existir um vazamento."
                )
            ]
        )
    }
    
    var brakeCheckTutorial: TutorialModel {
        TutorialModel(
            title: "Checagem dos Freios",
            introImage: .asset(
                name: "check_brake",
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
                    Aponte uma lanterna pelos espaços da roda para iluminar o sistema.
                        
                    Procure pelo disco de freio (comum nas rodas dianteiras) e observe se há riscos profundos, rachaduras ou sinais de desgaste excessivo.
                     
                    Nota: Se o automóvel possui calotas fechadas ou freios a tambor (comuns nas rodas traseiras), não é possível fazer essa inspeção visual sem remover a roda.
                    """,
                    image: .asset(
                        name: "step1_cbrake",
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
                    image: .asset(
                        name: "step2_cbrake",
                        fallback: "exclamationmark.triangle.fill"
                    ),
                    warningMessage: "Aviso: Se houver vibração forte ou ruídos durante a frenagem, procure uma oficina."
                )
            ]
        )
    }
    
    var tireCalibrationTutorial: TutorialModel {
        TutorialModel(
            title: "Calibragem dos Pneus",
            introImage: .asset(
                name: "tire_calibrate",
                fallback: "gauge.with.dots.needle.67percent"
            ),
            introDescription: "Aprenda a ajustar a pressão a cada 15 dias. A calibragem correta evita desgaste nas bordas (pressão baixa) ou no centro (pressão alta) do pneu.",
            introNote: "Aviso: Faça a calibragem preferencialmente com os pneus frios.",
            materials: [
                TutorialMaterial(
                    name: "Calibrador de pneus",
                    description: "Pode ser um compressor com medidor de pressão ou o equipamento de um posto."
                ),
                TutorialMaterial(
                    name: "Manual do automóvel",
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
                    Vá a um posto próximo (rode menos de 3 km) ou deixe o carro parado para que os pneus estejam frios.
                    
                    Consulte a etiqueta na porta do motorista, na tampa do tanque de combustível, no pneu ou no manual do automóvel.
                    
                    Confira a pressão dos quatro pneus e também do estepe, se houver.
                    """,
                    image: .asset(
                        name: "step1_tcalibrate",
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
                    image: .asset(
                        name: "step2_tcalibrate",
                        fallback: "gauge.with.dots.needle.67percent"
                    ),
                    warningMessage: "Aviso: Andar com o pneu murcho gasta as laterais e consome mais combustível. Pneu muito cheio gasta o centro e reduz a estabilidade."
                )
            ]
        )
    }
    var batteryCheckTutorial: TutorialModel {
        TutorialModel(
            title: "Checagem da Bateria",
            introImage: .asset(
                name: "check_batery",
                fallback: "battery.100percent"
            ),
            introDescription: "Aprenda a identificar sinais de desgaste ou problemas na bateria do seu automóvel.",
            introNote: "Aviso: Faça a inspeção com o carro desligado, em local ventilado e sem chamas ou faíscas.",
            materials: [
                TutorialMaterial(
                    name: "Lanterna",
                    description: "Use a lanterna para visualizar melhor a carcaça e os terminais da bateria."
                ),
                TutorialMaterial(
                    name: "Multímetro",
                    description: "Pode ser usado para medir a tensão e a saúde elétrica da bateria."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Inspeção visual e de sintomas",
                    description: """
                        Antes de abrir o capô, note se a partida anda "pesada", luzes ou painel oscilam ou a multimídia reinicia ao dar a partida.
                        
                        Com o carro desligado, abra o capô e localize a bateria.
                        
                        Use uma lanterna para verificar se a carcaça tem estufamentos, rachaduras ou vazamentos, e se os terminais (+) e (-) estão firmes e livres daquele pó esverdeado/branco (zinabre).
                        """,
                    image: .asset(
                        name: "step1_cbatery",
                        fallback: "battery.100percent"
                    ),
                    warningMessage: "Aviso: Se houver cheiro de 'ovo podre' ou se a carcaça estiver estufada, a bateria pode estar sobrecarregada ou fervendo. Nunca toque no zinabre sem proteção."
                ),
                TutorialStep(
                    title: "Passo 2: Teste com multímetro",
                    description: """
                        Com o automóvel desligado há mais de 30 minutos, ajuste o multímetro em tensão contínua (DCV ou escala de 20V).
                        
                        Encoste a ponta vermelha no terminal positivo (+) e a preta no negativo (-). A leitura deve ficar entre 12.4V e 12.6V.
                        
                        Depois, ligue o motor: a tensão deve subir para algo entre 13.5V e 14.7V. Se ficar abaixo de 13V com o carro ligado, o alternador pode estar falhando.
                        """,
                    image: .asset(
                        name: "step2_cbatery",
                        fallback: "battery.100percent"
                    ),
                    warningMessage: "Aviso: Se a tensão cair para menos de 9.6V no exato instante da partida, a bateria provavelmente já não segura mais carga."
                )
            ]
        )
    }
}
