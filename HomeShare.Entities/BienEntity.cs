using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HomeShare.Entities
{
    public class BienEntity
    {
        private int _idBien;
        private string _titre, _descCourte, _descLong, _pays, _ville, _rue, _codePostal, _photo;
        private int _nombrePerson, _paysId, _numero;

        public int IdBien { get => _idBien; set => _idBien = value; }
        public string Titre { get => _titre; set => _titre = value; }
   
        public string Pays { get => _pays; set => _pays = value; }
     
        public string Rue { get => _rue; set => _rue = value; }
        public string CodePostal { get => _codePostal; set => _codePostal = value; }
        public string Photo { get => _photo; set => _photo = value; }
        public int NombrePerson { get => _nombrePerson; set => _nombrePerson = value; }
        public int PaysId { get => _paysId; set => _paysId = value; }
        public int Numero { get => _numero; set => _numero = value; }
        public string Ville { get => _ville; set => _ville = value; }
        public string DescCourte { get => _descCourte; set => _descCourte = value; }
        public string DescLong { get => _descLong; set => _descLong = value; }
    }
}
