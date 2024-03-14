struct JeuResponse: Codable {
    let jeux: [JeuData]

   
}
struct JeuData: Codable {
       let Espace: Espace
       let Jeu: Jeu
       let idfestival: Int
       let idjeu: Int
       let idzonebenevole: Int
   }
