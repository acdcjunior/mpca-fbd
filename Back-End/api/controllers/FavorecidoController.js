/* global Favorecido */
"use strict";

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
    let valorBuscado = (req.query.busca || '').replace(/['"]/g, ''); // tratamento de SQL injection minimo!

    Favorecido.query(`
    SELECT
      d.documento, d.dt_diaria, d.valor, f.nome, f.cpf
    FROM
      diaria d INNER JOIN favorecido f ON d.favorecido = f.codigo
    WHERE
      f.nome LIKE '%${valorBuscado}%' or f.cpf LIKE '%${valorBuscado}%'`,

    function(err, results) {
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
