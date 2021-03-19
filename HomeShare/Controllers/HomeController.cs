using HomeShare.Models;
using HomeShare.Repositories;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HomeShare.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Home = "active";
            //return View();
           
            HomeViewModel hm = new HomeViewModel();

           return View(hm);
        }

        public ActionResult About()
        {
            ViewBag.About = "active";
            return View();
        }


        public ActionResult Echange()
        {
            ViewBag.Echange = "active";

            return View();
        }

      
        [HttpGet]
        public ActionResult Contact()
        {
            ViewBag.Contact = "active";
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Contact(ContactModel contact)
        {
            UnitOfWork ctx = new UnitOfWork(ConfigurationManager.ConnectionStrings["Cnstr"].ConnectionString);
            if (ctx.SaveContact(contact))
            {
                ViewBag.SuccessMessage = " Message bien envoyé";
                return View();
            }
            else
            {
                ViewBag.ErrorMessage = " Message non enregistré";
                return View();
            }
        }

        public ActionResult Echanger()
        {
            ViewBag.Echange = "active";
            return View();
        }

        public ActionResult Visiter()
        {
            ViewBag.Visiter = "active";

            return View();
        }

        
        public ActionResult Connection()
        {
            ViewBag.Connection = "active";
            return View();
        }


    }
}