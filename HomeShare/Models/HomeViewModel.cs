using HomeShare.Repositories;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace HomeShare.Models
{
    public class HomeViewModel
    {
        private UnitOfWork ctx = new UnitOfWork(ConfigurationManager.ConnectionStrings["Cnstr"].ConnectionString);

        private List<BienModel> _bien;


        public HomeViewModel()
        {
           Bien = ctx.GetBienTop();
        }

        public List<BienModel> Bien { get => _bien; set => _bien = value; }
    }
}