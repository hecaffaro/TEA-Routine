class Noticia {
  final String titulo;
  final String descricao;
  final String urlImagem;
  final String url;

  Noticia({required this.titulo, required this.descricao, required this.urlImagem, required this.url});

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['title'] ?? '',
      descricao: json['description'] ?? '',
      urlImagem: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
