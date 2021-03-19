using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HomeShare.Models
{
    public class ContactModel
    {
        private string _nom, _email, _sujet, _message;

        public string Nom { get => _nom; set => _nom = value; }
        public string Email { get => _email; set => _email = value; }
        public string Sujet { get => _sujet; set => _sujet = value; }
        public string Message { get => _message; set => _message = value; }
    }
}
