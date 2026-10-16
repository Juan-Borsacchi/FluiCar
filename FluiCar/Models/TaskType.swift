//
//  TaskType.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import Foundation

enum TaskType: String, Identifiable, CaseIterable, Hashable, Codable {
    case oilCheck = "verificar_oleo"
    case waterCheck = "verificar_agua"
    case brakeCheck = "verificar_freios"
    case tireCalibration = "calibrar_pneus"
    case batteryCheck = "verificar_bateria"
    case oilChange = "troca_oleo"
    
    var id: String {
        rawValue
    }
    
    var displayTitle: String {
        switch self {
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
        case .oilChange:
            return "Troca de Óleo"
        }
    }
    
    var duration: String {
        switch self {
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
        case .oilChange:
            return "8 min"
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
        case .oilChange:
            return oilChangeTutorial
        }
    }
}

private extension TaskType {
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
                    warningMessage: "Aviso: Se o motor estiver funcionando ou recém-desligado, a leitura poderá ficar incorreta.",
                    warningTitle: "Possível erro de leitura"
                ),
                TutorialStep(
                    title: "Passo 2: Medição do nível",
                    description: """
                    Aguarde alguns segundos e retire a vareta novamente.
                    
                    Observe as marcações de mínimo e máximo. O óleo deve estar entre as duas marcações.
                    
                    Se estiver próximo do mínimo, complete usando o mesmo tipo de óleo recomendado pelo manual.
                    """,
                    image: .asset(
                        name: "step2_coil",
                        fallback: "magnifyingglass"
                    ),
                    warningMessage: "Aviso: O óleo não deve ficar abaixo da marca mínima nem acima da marca máxima.",
                    warningTitle: "Risco de danos ao automóvel"
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
                    Abra o capô e procure pelo reservatório de expansão, procure por um pote plástico translúcido com linhas de MÍN/MÁX e um líquido colorido no interior.
                    
                    Observe as marcações de mínimo e máximo na lateral do reservatório.
                    
                    O fluido deve estar entre essas duas marcações.
                    """,
                    image: .asset(
                        name: "step1_cwater",
                        fallback: "drop.fill"
                    ),
                    warningMessage: "Aviso: Nunca abra a tampa do reservatório com o motor quente. O sistema trabalha sob alta pressão e o líquido fervente pode espirrar, causando queimaduras graves.",
                    warningTitle: "Risco de acidente grave"
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
                    warningMessage: "Aviso: Se for necessário completar o reservatório toda semana ou todo mês, pode existir um vazamento.",
                    warningTitle: "Risco de danos ao automóvel"
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
                    warningMessage: "Aviso: Nunca toque nos discos logo após dirigir. Eles podem estar extremamente quentes.",
                    warningTitle: "Risco de acidente"
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
                    warningMessage: "Aviso: Se houver vibração forte ou ruídos durante a frenagem, procure uma oficina.",
                    warningTitle: "Risco de danos ao automóvel"
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
                    warningMessage: "Aviso: Não esvazie um pneu quente para tentar atingir a pressão recomendada.",
                    warningTitle: "Possível erro de leitura"
                ),
                TutorialStep(
                    title: "Passo 2: Ajuste da pressão e calibrando no posto",
                    description: """
                    Digite o valor recomendado no visor do calibrador e retire a tampa da válvula do pneu.
                    
                    Encaixe a mangueira com firmeza na válvula: o aparelho faz o ajuste sozinho. Se a pressão estiver abaixo da recomendada, ele adiciona ar aos poucos, porém se estiver acima, ele libera o excesso automaticamente.
                    
                    Mantenha o bico pressionado até o sinal sonoro (bip) confirmar que a pressão foi atingida.
                    
                    Ao terminar, não esqueça de colocar as tampas das válvulas no lugar.
                    """,
                    image: .asset(
                        name: "step2_tcalibrate",
                        fallback: "gauge.with.dots.needle.67percent"
                    ),
                    warningMessage: "Aviso: Andar com o pneu murcho gasta as laterais e consome mais combustível. Pneu muito cheio gasta o centro e reduz a estabilidade.",
                    warningTitle: "Risco de danos ao automóvel"
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
            introDescription: "Aprenda a identificar sinais de desgaste na bateria e a testar se ela e o alternador estão funcionando corretamente.",
            introNote: "Aviso: Faça a inspeção com o carro desligado, em local ventilado e sem chamas ou faíscas.",
            materials: [
                TutorialMaterial(
                    name: "Lanterna",
                    description: "Para iluminar a carcaça, polos e verificar a presença de corrosão ou vazamentos."
                ),
                TutorialMaterial(
                    name: "Multímetro ou voltímetro",
                    description: "Aparelho para medir a tensão elétrica da bateria em repouso e com o motor funcionando."
                )
            ],
            steps: [
                TutorialStep(
                    title: "Passo 1: Inspeção visual e física",
                    description: """
                    Antes de abrir o capô, repare nos sintomas: partida pesada, relógio zerando ou painel oscilando são indícios de bateria no fim da vida útil.
                    
                    Com o motor desligado, abra o capô e localize a bateria. Use a lanterna para examinar a carcaça.
                    
                    Se houver pó branco/azulado nos polos (zinabre), limpe com cuidado usando água morna e bicarbonato. Verifique também se os cabos estão bem presos e sem folga.
                    """,
                    image: .asset(
                        name: "step1_cbatery",
                        fallback: "battery.100percent"
                    ),
                    warningMessage: "Aviso: Carcaça estufada, trincada ou com cheiro de 'ovo podre' indica falha grave e risco de vazamento de ácido. Se notar isso, troque a bateria de imediato e não faça os testes elétricos.",
                    warningTitle: "Risco de acidente grave"
                ),
                TutorialStep(
                    title: "Passo 2: Medição e diagnóstico final",
                    description: """
                    Ajuste o multímetro para 20V DC (tensão contínua). Conecte a ponteira vermelha no polo (+) e a preta no polo (-):
                    
                    1. Com o motor desligado (há pelo menos 30 min) e as ponteiras conectadas, verifique:
                    Se no painel do multímetro aparecer 12.4V a 12.6V significa que a bateria está saudável e com carga total.
                    Se aparecer abaixo de 12.4V significa carga baixa ou fim de vida útil. Procure um especialista para avaliar possível substituição da bateria.
                    
                    2. Dê a partida e verifique novamente com o motor ligado:
                    Se no painel do multímetro aparecer 13.5V a 14.7V significa que o alternador está funcionando perfeitamente. Seu sistema elétrico está aprovado e o teste está concluído!
                    Se aparecer abaixo de 13.0V ou acima de 14.8V significa falha no alternador ou no regulador de tensão. Procure um autoelétrico para reparo imediato.
                    """,
                    image: .asset(
                        name: "step2_cbatery",
                        fallback: "battery.100percent"
                    ),
                    warningMessage: "Aviso: Se durante a partida a voltagem despencar para menos de 9.6V, as placas internas da bateria perderam a capacidade de retenção de corrente (hora de trocá-la).",
                    warningTitle: "Risco de danos ao automóvel"
                )
            ]
        )
    }
    
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
                    
                    Deite-se embaixo do motor e procure pelo filtro de óleo e pelo parafuso do cárter, uma bandeja metálica localizada na parte de baixo do motor.
                    
                    Posicione uma bacia embaixo do parafuso, solte-o com uma chave e deixe o óleo antigo escorrer até o fim.
                    """,
                    image: .asset(
                        name: "step1_oil",
                        fallback: "wrench.and.screwdriver.fill"
                    ),
                    warningMessage: "Aviso: Nunca fique embaixo do carro apoiado apenas pelo macaco hidráulico.",
                    warningTitle: "Risco de acidente grave"
                ),
                TutorialStep(
                    title: "Passo 2: Substituição do filtro e abastecimento",
                    description: """
                    Assim que o óleo antigo terminar de escorrer, desenrosque o filtro antigo e troque-o por um novo.
                    
                    Substitua a arruela de vedação do parafuso do cárter por uma nova. Em seguida, recoloque o parafuso no lugar e aperte com firmeza, sem colocar força excessiva para evitar espanar a rosca do cárter.
                    
                    Com o parafuso do cárter bem fechado, volte para cima e localize a tampa de óleo no topo do motor (ela tem o símbolo de uma latinha de óleo pingando ou a palavra "OIL"). Remova a tampa, use um funil para não derramar nas peças e despeje a quantidade indicada no manual. Por fim, use a vareta para conferir o nível antes de fechar a tampa.
                    """,
                    image: .asset(
                        name: "change_oil",
                        fallback: "drop.fill"
                    ),
                    warningMessage: "Aviso: Lubrifique a borracha do filtro novo com um pouco de óleo e aperte-o apenas com a força das mãos.",
                    warningTitle: "Risco de danos ao automóvel"
                )
            ]
        )
    }
}
