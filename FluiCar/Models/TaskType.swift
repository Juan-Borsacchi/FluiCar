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
        self.rawValue
    }
    
    var tutorialData: TutorialModel {
        switch self {
            
        // MARK: - Troca de Óleo
            
        case .oilChange:
            return TutorialModel(
                title: "Troca de Óleo",
                introImageName: "troca_oleo",
                introDescription: "Entenda como funciona a troca de óleo do motor e o que é feito nesse processo.",
                introNote: "Aviso: Antes de realizar a troca do óleo verifique o tutorial para saber o nivel do óleo.",
                materials: [
                    TutorialMaterial(
                        name: "Óleo de motor",
                        description: "Consulte o manual do veículo para confirmar o tipo do óleo (Sintético, Semissintético ou Mineral)."
                    ),
                    TutorialMaterial(
                        name: "Filtro de óleo",
                        description: "Precisa ser o modelo específico para o motor do seu carro (consulte o manual do veículo para confirmar)."
                    ),
                    TutorialMaterial(
                        name: "Arruela de vedação",
                        description: "É uma junta de metal que vai no parafuso do cárter (onde o óleo fica armazenado) para evitar vazamentos."
                    )
                ],
                steps: [
                    TutorialStep(
                        title: "Passo 1: Esvaziamento do óleo antigo",
                        description: "Você terá que ter acesso a parte de baixo do carro. Você pode usar um macaco automotivo acompanhado de cavaletes de segurança.\n\nDeite-se embaixo do motor e procure por uma peça redonda (o filtro de óleo) e um parafuso solitário na base do motor (o plugue do cárter).\n\nPosicione uma bacia embaixo desse parafuso, solte-o com uma chave e deixe o óleo velho escorrer até o fim.",
                        imageName: "passo1_oleo",
                        warningMessage: "Aviso: Nunca fique embaixo do carro segurado apenas pelo macaco hidráulico."
                    ),
                    TutorialStep(
                        title: "Passo 2: Substituição do filtro e abastecimento",
                        description: "Assim que óleo antigo terminar de escorrer, desenrosque o filtro de óleo antigo e troque-o por um novo.\n\nAntes de fechar a parte de baixo, substitua a arruela de vedação antiga por uma nova, recoloque o plugue no cárter e aperte.\n\nPara finalizar, vá para a parte de cima do carro e abra a tampa do motor. Com a ajuda de um funil, coloque o óleo novo na quantidade exata indicada pelo manual e use a vareta para checar se atingiu o nível ideal.",
                        imageName: "troca_oleo",
                        warningMessage: "Aviso: Lubrifique a borracha do filtro novo com um pouco de óleo antes de rosquear e aperte-o apenas com a força das mãos."
                    )
                ]
            )
            
        // MARK: - Verificação de Óleo
            
        case .oilCheck:
            return TutorialModel(
                title: "Verificação de Óleo",
                introImageName: "verificacao_oleo",
                introDescription: "Entenda como funciona para checar o óleo do motor e o que é feito nesse processo.",
                introNote: "Aviso: Faça a checagem somente se o motor estiver desligado há pelo menos 10 minutos e com o carro em uma superfície plana ou 100% nivelada.",
                materials: [
                    TutorialMaterial(
                        name: "Pano limpo ou papel toalha",
                        description: "Essencial para limpar a vareta de medição e garantir a leitura exata do nível."
                    )
                ],
                steps: [
                    TutorialStep(
                        title: "Passo 1: Localização e limpeza da vareta",
                        description: "Com o motor frio, abra o capô do carro e trave-o com a haste de segurança. Procure pela vareta de nível, que geralmente fica na parte superior ou lateral do bloco do motor e tem uma argola colorida na ponta (amarela, laranja ou vermelha).\n\nPuxe a vareta inteira para fora. Use o pano limpo para secar e limpar todo o óleo da ponta dela.\n\nCom a vareta totalmente limpa e seca, insira-a de volta no tubo até o final, garantindo que encaixou completamente.",
                        imageName: "verificacao_oleo",
                        warningMessage: "Aviso: Se o motor estiver funcionando ou recém-desligado, o óleo estará espalhado pelas peças e a medição parecerá mais baixa do que o real."
                    ),
                    TutorialStep(
                        title: "Passo 2: Medição do nível e diagnóstico",
                        description: "Aguarde de dois a três segundos e puxe-a para fora novamente, mantendo a ponta virada para baixo ou na horizontal para o óleo não escorrer e estragar a leitura.\n\nObserve a marcação na ponta da vareta: ela terá dois indicadores (podem ser furos, linhas, palavras \"MIN/MAX\" ou uma área hachurada).\n\nO óleo deve marcar exatamente no espaço entre a linha inferior e a superior. Se a marca estiver perto do mínimo, é necessário completar com o mesmo tipo de óleo que já está no motor.",
                        imageName: "verificacao_oleo",
                        warningMessage: "Aviso: O nível do óleo nunca deve ficar abaixo da marcação mínima (falta de lubrificação), nem ultrapassar a marcação máxima (excesso de pressão). Ambos os cenários podem danificar gravemente o motor."
                    )
                ]
            )
            
        // MARK: - Água / Arrefecimento
            
        case .waterCheck:
            return TutorialModel(
                title: "Ver e Trocar Água",
                introImageName: "verificar_agua",
                introDescription: "Entenda como funciona para checar e colocar o fluido de arrefecimento (Água) do radiador e o que é feito nesse processo.",
                introNote: "Aviso: Cheque com o motor totalmente frio de preferência antes de ligar o carro pela primeira vez no dia e certifique que o carro esteja estacionado em uma superfície plana.",
                materials: [
                    TutorialMaterial(
                        name: "Fluido de arrefecimento",
                        description: "Consulte o manual do veículo para confirmar o tipo recomendado para o ano, modelo e motor do seu carro (Orgânico, Híbrido ou Inorgânico)."
                    ),
                    TutorialMaterial(
                        name: "Água desmineralizada",
                        description: "Se o seu fluido for do tipo \"concentrado\", ele precisará ser diluído nesta água. Nunca use água da torneira (o cloro e os minerais enferrujam o motor por dentro)."
                    ),
                    TutorialMaterial(
                        name: "Pano Grosso",
                        description: "Para proteger sua mão ao abrir a tampa do reservatório."
                    )
                ],
                steps: [
                    TutorialStep(
                        title: "Passo 1: Localização e inspeção visual",
                        description: "Abra o capô do carro e trave-o com a haste de segurança. Procure pelo reservatório de expansão (um tanque de plástico transparente). Olhe para a lateral de plástico desse reservatório e procure por \"MÍN\" e \"MAX\".\n\nVocê não precisa abrir a tampa agora, deve apenas olhar contra a luz. O nível do líquido colorido deve estar exatamente entre as marcações de mínimo e máximo.",
                        imageName: "verificar_agua",
                        warningMessage: "Aviso: Nunca abra a tampa do radiador ou do reservatório com o motor quente. A água lá dentro trabalha sob alta pressão e corre risco do líquido extremamente quente explodir para fora podendo causar queimaduras graves. Faça apenas com o motor totalmente frio."
                    ),
                    TutorialStep(
                        title: "Passo 2: Adicionando o fluido",
                        description: "Se o nível do líquido estiver perto ou abaixo da linha \"MÍN\", é hora de adicionar. Coloque o pano grosso por cima da tampa e gire-a bem devagar no sentido anti-horário. Se ouvir um leve chiado de ar saindo, espere parar antes de terminar de abrir.\n\nDespeje a mistura de fluido com água desmineralizada até atingir a marca \"MÁX\", deixando um espaço vazio. O sistema precisa desse espaço vazio com ar no topo do reservatório para que a água tenha para onde subir quando esquentar. Ao terminar, feche a tampa com firmeza.\n\nCompletar o reservatório é uma manutenção rápida de garagem. A troca completa de todo o líquido para limpeza do sistema deve ser feita em uma oficina no prazo correto (a cada 1 a 5 anos, dependendo se o seu fluido é inorgânico, híbrido ou orgânico).",
                        imageName: "verificar_agua",
                        warningMessage: "Aviso: É normal o nível baixar ao longo de muitos meses. Mas, se você precisa adicionar líquido toda semana ou todo mês, o seu carro tem um vazamento (mangueira ressecada, tampa não vedando ou problema no motor). Leve a um mecânico."
                    )
                ]
            )
            
        // MARK: - Freios
            
        case .brakeCheck:
            return TutorialModel(
                title: "Checagem dos Freios",
                introImageName: "verificar_freios",
                introDescription: "Entenda como funciona para checar e avaliar o desgaste das pastilhas de freio e o que é feito nesse processo.",
                introNote: "Aviso: A verificação dos discos e tambores deve ser feita rigorosamente a cada 10.000 km. É recomendado fazer essa checagem sempre em conjunto com a revisão das pastilhas de freio.",
                materials: [
                    TutorialMaterial(
                        name: "Lanterna",
                        description: "A lanterna de um celular é suficiente para iluminar o interior da roda."
                    ),
                    TutorialMaterial(
                        name: "Histórico de Revisões",
                        description: "Ter uma noção de qual era a quilometragem do veículo na última troca."
                    )
                ],
                steps: [
                    TutorialStep(
                        title: "Passo 1: Localização e inspeção visual",
                        description: "Aponte a lanterna através dos buracos da roda. O disco de freio é uma grande placa redonda de metal brilhante. Dependendo do seu carro, você encontrará dois tipos: os Discos Sólidos (lisos e maciços, comuns em carros populares ou nas rodas traseiras) ou os Discos Ventilados (parecem um \"sanduíche\" com aberturas no meio para ajudar a dissipar o calor, usados na dianteira da maioria dos carros).\n\nSe você olhar para a roda traseira e não vir um disco brilhante, mas sim algo parecido com uma \"panela\" de metal fechada e escura, seu carro utiliza tambores de freio na traseira.",
                        imageName: "verificar_freios",
                        warningMessage: "Aviso: Nunca toque nos discos de freio logo após dirigir, pois os freios atingem temperaturas extremas durante o uso. Faça a inspeção apenas com o carro totalmente frio (estacionado há algumas horas)."
                    ),
                    TutorialStep(
                        title: "Passo 2: Inspeção do desgaste",
                        description: "Passe o dedo levemente (com o carro frio) da superfície do disco para a borda externa, verifique se há a formação de um “degrau”. Se o degrau for muito fundo ou se houver arranhões grossos e rachaduras, o disco está condenado.\n\nA regra geral de manutenção indica que a troca dos discos é feita em média a cada 2 trocas de pastilhas. Todo disco possui uma espessura mínima de segurança que vem gravada na própria borda da peça.\n\nA compra de discos novos varia pelo diâmetro (em milímetros) e pela furação da roda do seu modelo exato. A medição técnica da espessura exige a retirada da roda em uma oficina. Se você já trocou as pastilhas duas vezes, agende a substituição dos discos.",
                        imageName: "verificar_freios",
                        warningMessage: "Aviso: Fique muito atento aos sinais no volante! Se, ao pisar no freio (especialmente em descidas ou velocidades maiores), você sentir o pedal ou o volante vibrar com força, é o sinal clássico de que o disco de freio está empenado e a troca é urgente. Leve em um especialista."
                    )
                ]
            )
            
        // MARK: - Calibragem dos Pneus
            
        case .tireCalibration:
            return TutorialModel(
                title: "Calibragem dos Pneus",
                introImageName: "calibrar_pneus",
                introDescription: "Entenda como funciona a calibragem dos pneus e como realizar esse procedimento de forma simples, seja em casa ou em um posto de gasolina.",
                introNote: "Aviso: A calibragem deve ser feita preferencialmente com os pneus frios. Não utilize como referência a pressão máxima escrita na lateral do pneu; siga a pressão recomendada pelo fabricante do veículo.",
                materials: [
                    TutorialMaterial(
                        name: "Calibrador de pneus",
                        description: "Pode ser um compressor com medidor de pressão próprio para uso doméstico ou o equipamento disponível em postos de gasolina."
                    ),
                    TutorialMaterial(
                        name: "Manual do veículo",
                        description: "Consulte a pressão recomendada pelo fabricante para os pneus dianteiros, traseiros e, quando aplicável, para o estepe. A pressão correta também pode estar indicada em uma etiqueta na porta do motorista ou em outra área indicada pelo fabricante."
                    ),
                    TutorialMaterial(
                        name: "Medidor de pressão",
                        description: "Caso o compressor não tenha um medidor confiável, utilize um manômetro próprio para conferir a pressão."
                    )
                ],
                steps: [
                    TutorialStep(
                        title: "Passo 1: Conferência da pressão",
                        description: "Antes de começar, deixe o carro parado por um período suficiente para que os pneus estejam frios. Procure a etiqueta de pressão do veículo, normalmente localizada na coluna ou porta do motorista, na tampa do tanque de combustível ou indicada no manual.\n\nRetire a tampa da válvula do pneu e conecte o bico do calibrador. Confira a pressão indicada no equipamento e compare com a recomendação do fabricante. Faça isso nos quatro pneus e não se esqueça do estepe, caso o veículo possua um.",
                        imageName: "calibrar_pneus",
                        warningMessage: "Aviso: Nunca esvazie um pneu quente para tentar atingir a pressão indicada. O aquecimento altera a pressão interna e pode fazer a leitura ficar diferente da pressão de referência."
                    ),
                    TutorialStep(
                        title: "Passo 2: Ajuste da pressão",
                        description: "Se a pressão estiver abaixo da recomendada, conecte o compressor e adicione ar aos poucos, conferindo a pressão no equipamento até atingir o valor indicado pelo fabricante.\n\nSe estiver acima da recomendada, libere pequenas quantidades de ar e confira novamente até chegar ao valor correto.\n\nAo finalizar, retire o bico do calibrador, recoloque as tampas das válvulas e confira se todos os pneus estão na pressão indicada. Se o veículo possuir sistema de monitoramento da pressão dos pneus (TPMS), siga também as orientações do manual para verificar ou reiniciar o sistema, quando necessário.",
                        imageName: "calibrar_pneus",
                        warningMessage: "Aviso: A pressão recomendada pode ser diferente entre os pneus dianteiros e traseiros e também pode mudar quando o veículo estiver carregado. Sempre utilize a informação específica do seu veículo."
                    )
                ]
            )
            
        // MARK: - Bateria
            
        case .batteryCheck:
            return TutorialModel(
                title: "Checagem da Bateria",
                introImageName: "verificar_bateria",
                introDescription: "Entenda como fazer uma checagem visual e identificar sinais de que a bateria do carro pode estar fraca ou apresentando algum problema.",
                introNote: "Aviso: Faça a inspeção com o carro desligado, em local seguro e ventilado. Não aproxime chamas, faíscas ou cigarros da bateria.",
                materials: [
                    TutorialMaterial(
                        name: "Lanterna",
                        description: "Pode ser a lanterna do celular para facilitar a inspeção do compartimento do motor."
                    ),
                    TutorialMaterial(
                        name: "Multímetro",
                        description: "Equipamento utilizado para medir a tensão da bateria. É opcional para uma checagem visual, mas ajuda a identificar se a bateria apresenta tensão anormal."
                    ),
                    TutorialMaterial(
                        name: "Manual do veículo",
                        description: "Consulte as orientações específicas para a bateria e o sistema elétrico do seu carro."
                    )
                ],
                steps: [
                    TutorialStep(
                        title: "Passo 1: Inspeção visual e dos terminais",
                        description: "Com o carro desligado, abra o capô e localize a bateria. Observe se a caixa apresenta trincas, vazamentos ou deformações.\n\nConfira os terminais positivo (+) e negativo (−). Eles devem estar firmes e sem excesso de corrosão ou sujeira. Não desmonte a bateria para verificar seu interior. Muitas baterias modernas são seladas e não exigem reposição de água.\n\nSe houver vazamento, bateria estufada, trincada ou muito corroída, não tente fazer reparos em casa. Procure uma oficina ou profissional especializado.",
                        imageName: "verificar_bateria",
                        warningMessage: "Aviso: Nunca encoste objetos metálicos entre os dois terminais da bateria. Isso pode provocar um curto-circuito, faíscas e danos ao sistema elétrico."
                    ),
                    TutorialStep(
                        title: "Passo 2: Teste da tensão e diagnóstico",
                        description: "Se você tiver um multímetro, coloque-o na função de tensão contínua (V⎓) e, com o carro desligado, encoste a ponta positiva no terminal (+) e a negativa no terminal (−), sem deixar as pontas encostarem uma na outra.\n\nObserve a tensão indicada e compare com a especificação recomendada para o sistema do seu veículo. Uma leitura baixa pode indicar bateria descarregada ou desgastada, mas o resultado isolado não confirma sozinho que a bateria está condenada.\n\nSe a bateria estiver descarregada, se a luz da bateria permanecer acesa com o motor funcionando ou se o veículo continuar apresentando dificuldade para dar partida, procure uma oficina para testar também o alternador e o sistema de carga.",
                        imageName: "verificar_bateria",
                        warningMessage: "Aviso: Dificuldade para dar partida, principalmente quando o motor de arranque gira lentamente ou o carro apresenta falhas ao ligar, pode indicar problema na bateria ou no sistema de carga. Nesse caso, não considere automaticamente que apenas a bateria precisa ser trocada."
                    )
                ]
            )
        }
    }
}
