//
//  LegalDocument.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 06/10/26.
//


import SwiftUI
import Observation


enum LegalDocument {
    case termsOfUse
    case privacyPolicy
    
    var title: String {
        switch self {
        case .termsOfUse: return "Termos de Uso"
        case .privacyPolicy: return "Política de Privacidade"
        }
    }
    var content: String {
        switch self {
        case .termsOfUse:
            return """
            # TERMOS DE USO - FLUICAR

            **Última atualização:** 06/10/2026

            Bem-vindo ao FluiCar! um aplicativo totalmente gratuito. Ao utilizar nosso aplicativo, você concorda com os termos descritos abaixo. Se você não concordar com qualquer uma das condições, recomendamos que não utilize o aplicativo.

            ## 1. Escopo do Serviço
            O FluiCar é uma ferramenta de apoio para organização e lembrete de manutenções rotineiras de veículos (como troca de óleo, água, etc.). O aplicativo também fornece informações técnicas e valores da Tabela FIPE por meio de consultas automatizadas, além de guias e tutoriais informativos sobre cuidados automotivos.

            ## 2. Isenção de Responsabilidade
            * **Conteúdo Meramente Informativo:** Todos os tutoriais, dicas e guias passo a passo disponibilizados no FluiCar são estritamente informativos. Eles ilustram procedimentos simples e gerais.
            * **Riscos Físicos e Mecânicos:** Manutenções automotivas envolvem riscos de acidentes graves, queimaduras, ferramentas pesadas e danos permanentes ao motor ou componentes do veículo. O FluiCar não se responsabiliza por quaisquer acidentes pessoais, ferimentos, prejuízos financeiros ou danos materiais causados pela execução das dicas contidas no app.
            * **Recomendação de Profissional:** O FluiCar recomenda expressamente que qualquer atividade que ofereça dúvidas ou complexidade seja realizada exclusivamente por um profissional qualificado (mecânico especializado). Use as dicas por sua conta e risco.

            ## 3. Exatidão dos Dados (Dados de Terceiros)
            O FluiCar exibe informações sobre os veículos e valores baseados na Tabela FIPE por meio de integrações com APIs externas. Nós não garantimos a precisão absoluta, infalibilidade ou atualização em tempo real desses dados. As informações são exibidas "como fornecidas" pela API parceira.

            ## 5. Alterações nos Termos e no Aplicativo
            O FluiCar é uma ferramenta em constante evolução. Por isso, nós nos reservamos o direito de, a qualquer momento e sem aviso prévio:
            * **Modificar as funcionalidades:** Alterar, atualizar, suspender, descontinuar ou remover qualquer recurso, tutorial, integração com APIs ou ferramenta do aplicativo.
            * **Atualizar os Termos de Uso:** Modificar este documento para refletir melhorias no app ou mudanças na legislação. A versão atualizada entrará em vigor assim que publicada no aplicativo. O uso contínuo do FluiCar após as alterações significará que você aceita os novos termos.

            ## 6. Isenção de Disponibilidade e Falhas Técnicas (Bugs)
            Embora trabalhemos para entregar a melhor experiência possível, nós não garantimos que o aplicativo funcionará por tempo indeterminado, de forma ininterrupta ou totalmente livre de erros, e bugs.
            * **Falhas no Serviço:** Nós não nos responsabilizamos por falhas de carregamento nos dados da Tabela FIPE, indisponibilidade temporária de APIs parceiras, perda de dados locais decorrente de falhas no sistema operacional do seu celular ou interrupções no funcionamento do aplicativo.
            * **Falta de Notificação:** Como as informações de manutenção dependem do armazenamento local do seu dispositivo, o FluiCar não será responsável caso um lembrete falhe ou não seja exibido devido a problemas técnicos do aparelho ou configurações do usuário.

            ## 7. Propriedade Intelectual
            Todo o design, código, textos dos tutoriais e marcas do FluiCar são de propriedade exclusiva do designer e dos desenvolvedores do aplicativo, protegidos pelas leis de direitos autorais.

            ## 8. LEGISLAÇÃO E FORO
            Os Termos e Condições de Uso serão regidos, interpretados e executados de acordo com as Leis da República Federativa do Brasil, sendo competente o foro de domicílio do Usuário para dirimir qualquer dúvida decorrente destes Termos.

            Em caso de dúvidas, sugestões ou solicitações sobre seus dados, entre em contato conosco pelo e-mail: fluicarstaff@gmail.com
            """
            
        case .privacyPolicy:
            return """
            # POLÍTICA DE PRIVACIDADE – FLUICAR
            **Última atualização: 01/10/2026**

            A sua privacidade é uma prioridade absoluta para nós. O FluiCar foi desenhado para que você tenha controle total sobre os dados do seu veículo, operando com o máximo de transparência.

            ## 1. Não Coleta de Dados Pessoais
            Nós não coletamos, não armazenamos e não solicitamos nenhum dado pessoal do usuário. O aplicativo não exige a criação de contas com e-mail/senha e nunca pedirá informações confidenciais ou de identificação civil como o seu nome, CPF, número da CNH ou a placa do seu veículo.

            ## 2. Base Legal e Conformidade (LGPD)
            Embora o FluiCar opere de forma local e anônima, sem realizar o tratamento direto de dados pessoais identificáveis, o aplicativo foi desenvolvido respeitando os princípios fundamentais de transparência, segurança e minimização de dados previstos pela Lei Geral de Proteção de Dados (LGPD - Lei nº 13.709/2018) no Brasil e demais regulamentações internacionais de privacidade.

            ## 3. Uso de APIs de Terceiros e Dados do Veículo
            Para fornecer informações detalhadas e o valor de mercado do automóvel, o usuário insere voluntariamente dados gerais do carro (como ano, marca e modelo).
            Esses dados genéricos são enviados para uma API externa parceira apenas para realizar a consulta técnica.
            Nenhum identificador pessoal ou do seu celular é enviado junto com essa requisição. A API recebe apenas o modelo, o ano e a marca do carro de forma anônima.

            ## 4. Armazenamento 100% Local e Volátil
            O FluiCar não possui servidores próprios para armazenar dados de usuários. Todas as informações que você digita para organizar a sua rotina ficam salvas exclusivamente na memória interna do seu próprio dispositivo.
            Se você desconectar o seu carro no painel do aplicativo ou se você apagar o aplicativo do seu celular, todos os dados serão permanentemente excluídos do aparelho e não poderão ser recuperados, pois nós não guardamos cópias de segurança (backups).

            ## 5. Links para Sites de Terceiros
            Nosso aplicativo pode conter links para sites externos. Esta Política de Privacidade aplica-se apenas ao FluiCar, portanto, recomendamos que você leia as políticas de privacidade desses outros sites ao visitá-los.

            ## 6. Alterações nesta Política
            Esta Política de Privacidade pode ser atualizada caso novas funcionalidades sejam adicionadas. Qualquer mudança será informada dentro do aplicativo, sempre mantendo nosso compromisso com sua segurança e privacidade.

            ## 7. Contato
            Em caso de dúvidas, sugestões ou solicitações sobre seus dados, entre em contato conosco pelo e-mail: fluicarstaff@gmail.com
            """
        }
    }
}

@Observable
class LegalDocumentViewModel {
    let documentType: LegalDocument
    var markdownText: AttributedString = AttributedString("")
    
    init(documentType: LegalDocument) {
        self.documentType = documentType
        processMarkdown()
    }
    
    // Converte a string instantaneamente na inicialização
    private func processMarkdown() {
        if let attributed = try? AttributedString(markdown: documentType.content) {
            self.markdownText = attributed
        } else {
            self.markdownText = AttributedString("Erro ao renderizar o documento.")
        }
    }
}
