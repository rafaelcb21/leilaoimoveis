import 'package:intl/intl.dart';

class Queryes {

  String propostaValida(String proposta, String dataInicioProposta, String dataFimProposta) {
    DateTime agora = new DateTime.now();
    String agoraString = new DateFormat("yyyy-MM-dd").format(agora);
    List agoraLista = agoraString.split('-');
    DateTime hoje = new DateTime.utc(int.parse(agoraLista[0]), int.parse(agoraLista[1]), int.parse(agoraLista[2]));
    DateTime inicio = DateTime.parse(dataInicioProposta);
    DateTime fim = DateTime.parse(dataFimProposta);

    if(proposta == 'Sim') {
      if(
        hoje.isBefore(inicio) ||
        hoje.isAfter(inicio) && hoje.isBefore(fim) ||
        hoje.difference(inicio) == 0 ||
        hoje.difference(fim) == 0
      ) {
        return 'Sim';
      } else if(agora.isAfter(fim)) {
        return 'Não';
      }

    } else if(proposta == 'Não') {
      if(agora.isAfter(fim)) {
        return 'Não';
      } else {
        return 'Sim';
      }
    } else if(proposta == ' ') {
      return ' ';
    }
  }

  double toDouble(String x) {
    if(x != '0.0') {
      List ll01 = x.split(' ');
      List ll02 = ll01[1].split(',');
      double ll03 = double.parse(ll02[0].replaceAll('.', '') + '.' + ll02[1]);
      return ll03;
    } else {
      return 0.0;
    }
    
  }


  List resultadoQuery(Map<dynamic, dynamic> formSubmit, List fileContent) {
    List imoveis = [];
    String tipoLeilaoForm = formSubmit['tipoleilao'];
    String propostaForm = formSubmit['proposta'];
    String tipoImovelForm = formSubmit['tipo'];

    double valorMinimoVendaForm = toDouble(formSubmit['valor_minimo_venda']);
    double valorMaximoAvaliacaoForm = toDouble(formSubmit['valor_maximo_avaliacao']);

    String ocupadoDesocupadoForm = formSubmit['ocupado_desocupado'];
    String estadoForm = formSubmit['estado'];
    String cidadeForm = formSubmit['cidade'];

    for(var item in fileContent) {      
      String estadoFB = item['estado'];
      String cidadeFB = item['cidade'];
      String dataInicioProposta = item['data_inicio_proposta'];
      String dataFimProposta = item['data_termino_proposta'];
      String propostaFB = propostaValida(propostaForm, dataInicioProposta, dataFimProposta);
      String tipo_leilaoFB = item['tipo_leilao'];
      String tipoFB = item['tipo'];
      String situacaoFB = item['situacao'];
      double vlr_de_vendaFB = double.parse(item['vlr_de_venda']);
      double vlr_de_avaliacaoFB = double.parse(item['vlr_de_avaliacao']);

      //print([valorMaximoAvaliacaoForm, vlr_de_avaliacaoFB, valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB]);
      //print([valorMinimoVendaForm, vlr_de_vendaFB]);

      if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ') {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && valorMinimoVendaForm >= vlr_de_vendaFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && propostaForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && valorMinimoVendaForm >= vlr_de_vendaFB && propostaForm == ' ' && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && ocupadoDesocupadoForm == situacaoFB && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && tipoLeilaoForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && ocupadoDesocupadoForm == situacaoFB && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && propostaForm == ' ' && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && propostaForm == ' ' && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && ocupadoDesocupadoForm == situacaoFB && propostaForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && propostaForm == ' ' && tipoImovelForm == ' ' && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB  && propostaForm == ' ' && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && propostaForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && tipoLeilaoForm == ' ' && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ' && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ' && tipoImovelForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && valorMinimoVendaForm == 0.0 && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && ocupadoDesocupadoForm == situacaoFB && valorMinimoVendaForm == 0.0 && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoImovelForm == ' ' && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB && tipoImovelForm == ' ' && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoImovelForm == ' ' && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && propostaForm == ' ' && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB && propostaForm == ' ' && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && propostaForm == ' ' && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && propostaForm == ' ' && tipoImovelForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && tipoLeilaoForm == ' ' && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && tipoImovelForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ' && propostaForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && ocupadoDesocupadoForm == situacaoFB && valorMaximoAvaliacaoForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && valorMinimoVendaForm == 0.0)  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoImovelForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && propostaForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB && tipoLeilaoForm == ' ')  {imoveis.add(item);}
      else if(estadoForm == estadoFB && cidadeForm == cidadeFB && tipoLeilaoForm == tipo_leilaoFB && propostaForm == propostaFB && tipoImovelForm == tipoFB && valorMinimoVendaForm >= vlr_de_vendaFB && valorMaximoAvaliacaoForm >= vlr_de_avaliacaoFB && ocupadoDesocupadoForm == situacaoFB)  {imoveis.add(item);}
    }

    return imoveis;
  }
}