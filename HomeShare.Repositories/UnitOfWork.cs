﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HomeShare.Entities;
using HomeShare.Models;
using GestionDb.Repositories;

namespace HomeShare.Repositories
{
    public class UnitOfWork
    {
        IConcreteRepository<MembreEntity> _membreRepo;
        IConcreteRepository<BienEntity> _bienRepo;
        IConcreteRepository<MessageEntity> _messageRepo;

        public UnitOfWork(string connectionString)
        {
            _membreRepo = new MembreRepository(connectionString);
            _bienRepo = new BienRepository(connectionString);
            _messageRepo = new MessageRepository(connectionString);
        }

        public List<BienModel> GetBienTop()
        {
         
            List<BienEntity> bienFromDb = _bienRepo.Get();
            List<BienModel> biens = new List<BienModel>();
          
            foreach (BienEntity item in bienFromDb)
            {
                //mapping:
                BienModel Bien = new BienModel();

                Bien.Titre = item.Titre;
                Bien.DescCourt = item.DescCourt;
                Bien.NombrePerson = item.NombrePerson;
                Bien.Ville = item.Ville;
                Bien.Rue = item.Rue;
                Bien.Numero = item.Numero;
                Bien.CodePostal = item.CodePostal;
                Bien.Photo = "/images/"+item.Photo;
                biens.Add(Bien);
            }

            return biens;
        }

        public bool SaveSignUp(MembreModel mm)
        {
            MembreEntity me = new MembreEntity();
            me.Nom = mm.Nom;
            me.Prenom = mm.Prenom;
            me.Email = mm.Email;
            me.Pays = mm.Pays;
            me.Telephone = mm.Telephone;
            me.Login = mm.Login;
            me.Password = mm.Password;
            return _membreRepo.Insert(me);

        }

        public bool SaveContact(ContactModel cm)
        {
            MessageEntity me = new MessageEntity();
            me.Nom = cm.Nom;
            me.Email = cm.Email;
            me.Sujet = cm.Sujet;
            me.Information = cm.Message;
            return _messageRepo.Insert(me);
        }


    }
}