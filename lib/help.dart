import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class HelpPage extends StatefulWidget {
  HelpPage();
  List favoritos;
  @override
  HelpPageState createState() => new HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  Color azul = new Color(0xFF1387B3);
  Color azulCeleste = new Color(0xFF1667A6);
  Color cinzaDrawer = new Color(0xFF9E9E9E);
  Future<Null> _launched;

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);//, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Erro em abrir o site';
    }
  }
    
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Tipos de Leilões'),
        backgroundColor: this.azul,
      ),
      
      body: new ListView(
        children: <Widget>[          
          new Container(
            margin: new EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 64.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  'Leilão',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''Como previsto pela lei 9.514/97, que garante a alienação fiduciária, podem ser realizados até dois leilões com os imóveis devolvidos à Caixa.\n
O 1º leilão é feito 30 dias após a devolução do imóvel, o bem é oferecido pelo valor de mercado, conforme previsto em lei.\n
Se não existir lance vencedor, um 2º leilão é feito 15 dias depois. O bem é oferecido pelo valor da dívida.\n
Se o imóvel não for vendido nem no 1º nem no 2º leilão, ele será oferecido em Licitação Aberta, Fechada e Venda Direta.\n
''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  'Licitação Aberta',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''Na licitação aberta, vence o lance mais vantajoso para a Caixa. Acontece presencialmente nos auditórios da Caixa, por todo o Brasil, ou em espaço do próprio leiloeiro credenciado que realiza a licitação aberta.\n
Levar CPF, RG, e comprovante de endereço.\n
No local onde está sendo realizado, você faz a sua oferta verbalmente, respeitando o valor mínimo de venda.\n
Quem fizer o maior lance leva.\n''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  'Licitação Fechada',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''Na licitação fechada, basta você apresentar uma proposta de compra por escrito no local indicado e realizar o depósito-caução, depois que o edital for publicado. Os envelopes apresentados serão abertos e classificados. Quem fizer a melhor proposta, respeitando o preço mínimo de venda, é considerado o vencedor.\n''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  'Venda Direta',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''Na venda direta, o primeiro interessado que realizar caução e apresentar proposta de valor igual ou superior ao preço mínimo estabelecido garante a compra do imóvel. Essa é a única modalidade de venda que pode ser intermediada por um corretor/imobiliária credenciada e os custos de comissão são pagos pela Caixa.\n
O depósito-caução representa 5% do valor do imóvel, e deve ser feito em qualquer agência da Caixa ou no local informado pelo edital.\n''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  '\nOBSERVAÇÕES:\n',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),

                new Text(
                  'Financiamento',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''A Caixa possibilita que você financie o imóvel, com a alternativa de usar o FGTS, em todas as modalidades de compra: leilão, licitação fechada, licitação aberta e venda direta.\n''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  'Contas e imposto em dia',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''As contas de condomínio e IPTU em atraso até a data da venda serão pagas pela Caixa. Assim, quem comprar fica livre de qualquer dívida, desde que o comprador não seja o responsável pelos débitos existentes e que a aquisição não ocorra em 2º Leilão\n''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  'Desocupação',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''A desocupação fica por conta do novo proprietário.\n
Após adquirir um imóvel da Caixa, você deverá comparecer ao Cartório de Registro de Imóveis e fazer o registro de propriedade do bem, que é comprovado pela Escritura ou Contrato de Compra e Venda. A partir desse momento, você passa a ser o titular do Direito Real do imóvel, que possibilita usá-lo diretamente, emprestar, alugar, entre outros, e também solicitar ao juízo competente (foro judicial) o pedido de desocupação, e para isso, você precisará de um advogado.\n''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  'Depósito de caução',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Text(
'''Corresponde a 5% do valor de venda do imóvel que você deseja adquirir. Esse valor deve ser depositado em uma conta de caução, aberta em uma agência da Caixa, no seu nome, para habilitar a proposta apresentada.\n''',
                  style: new TextStyle(
                    color: this.cinzaDrawer,
                    fontFamily: "Futura",
                    fontSize: 14.0,
                  ),
                ),

                new Text(
                  'Mais informações',
                  style: new TextStyle(
                    color: this.azulCeleste,
                    fontFamily: "Futura",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      'Para mais informações acesso o ',
                      style: new TextStyle(
                        color: this.cinzaDrawer,
                        fontFamily: "Futura",
                        fontSize: 14.0,
                      ),
                    ),
                    new InkWell(
                      child: new Text(
                        " site",
                        style: new TextStyle(
                          color: this.azulCeleste,
                          fontFamily: "Futura",
                          fontSize: 14.0,
                        ),
                      ),
                      onTap: () => setState(() {
                        _launched = _launchInBrowser('http://www.caixa.gov.br/voce/habitacao/imoveis-venda/Paginas/default.aspx');
                      }),
                    ),
                  ],
                )
              ],
            )
          )
        ]
      )
    );
  }

}



