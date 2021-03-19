using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HomeShare.Entities
{
    public class MembreEntity
    {
        private int _idMembre, _pays;
        private string _nom, _prenom, _email, _telephone, _login, _password;
     

        public int IdMembre { get => _idMembre; set => _idMembre = value; }
        public string Nom { get => _nom; set => _nom = value; }
        public string Prenom { get => _prenom; set => _prenom = value; }
        public string Email { get => _email; set => _email = value; }
        public string Telephone { get => _telephone; set => _telephone = value; }
        public string Login { get => _login; set => _login = value; }
        public string Password { get => _password; set => _password = value; }
        public int Pays { get => _pays; set => _pays = value; }
    }
}
