/* global Favorecido */

module.exports = {

  experimento: function(req, res) {
    Favorecido.query('SELECT * FROM favorecido', function(err, results) {
      if (err) {
        res.send(400);
      }
      else {
        res.send(results);
      }
    });
  },

  diariasPorFavorecido: function(req, res) {
    var valorBuscado = req.query.busca || '';
    Favorecido.query(`SELECT d.documento, d.dt_diaria, d.valor, f.nome, f.cpf
    FROM diaria d INNER JOIN favorecido f
    ON d.favorecido = f.codigo
    WHERE
    f.nome LIKE $1 or f.cpf LIKE $1`, [`%${valorBuscado}%`], function(err, results) {
      if (err) {
        console.error("Erro na busca!");
        console.error(err);
        res.send(400);
      }
      else {
        res.send(results);
      }
    });
  }

};
