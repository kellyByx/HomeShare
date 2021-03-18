using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HomeShare.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
            //ViewBag.Home = "active";
            //HomeViewModel hm = new HomeViewModel();

            //return View(hm);
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

        public ActionResult Contact()
        {
            ViewBag.Contact = "active";
            return View();
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