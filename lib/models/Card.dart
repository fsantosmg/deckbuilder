class Card {
  final int id;
  final String edicao;
  final String precoMedio;
  final String? poder;
  final String? resistencia;
  final String custoMana;
  final String cores;

  Card(this.id, this.edicao, this.precoMedio, this.poder, this.resistencia,
      this.custoMana, this.cores);

  @override
  String toString() {
    return 'Card{id: $id, edicao: $edicao, precoMedio: $precoMedio, poder: $poder, resistencia: $resistencia, custoMana: $custoMana, cores: $cores}';
  }
}
