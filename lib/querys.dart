class Queryes {


  List resultadoQuery(Map<dynamic, dynamic> formSubmit, List fileContent) {
    List imoveis = [];
    String tipoLeilaoForm = formSubmit['tipoleilao'];
    String propostaForm = formSubmit['proposta'];
    String tipoImovelForm = formSubmit['tipo'];
    double valorMinimoVendaForm = formSubmit['valor_minimo_venda'];
    double valorMaximoAvaliacaoForm = formSubmit['valor_maximo_avaliacao'];
    String ocupadoDesocupadoForm = formSubmit['ocupado_desocupado'];
    String estadoForm = formSubmit['estado'];
    String cidadeForm = formSubmit['cidade'];

    for(var item in fileContent) {
      String estadoFB = item['estado'];
      String cidadeFB = item['cidade'];
      String propostaFB = item['proposta'];
      String tipo_leilaoFB = item['tipo_leilao'];
      String tipoFB = item['tipo'];
      String situacaoFB = item['situacao'];
      double vlr_de_vendaFB = item['vlr_de_venda'];
      double vlr_de_avaliacaoFB = item['vlr_de_avaliacao'];


      if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ') {
        imoveis.add(item);
      }
      
    }

    return imoveis;
  }
}