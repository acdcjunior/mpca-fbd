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
  }

};
