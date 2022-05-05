class Produit {
  final String img, prix, taille, titre, id, categorie;
  Produit(
      this.img, this.prix, this.taille, this.titre, this.id, this.categorie);
  bool operator ==(Object object) {
    Produit produit = object;
    return id == produit.id;
  }
}
