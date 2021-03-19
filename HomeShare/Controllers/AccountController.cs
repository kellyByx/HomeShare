using HomeShare.infra;
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
    public class AccountController : Controller
    {
        // GET: Account
        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public ActionResult Deconnection()
        {
            Session.Abandon();
            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public ActionResult Connection()
        {
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Connection(LoginModel lm)
        {
            //UnitOfWork ctx = new UnitOfWork(ConfigurationManager.ConnectionStrings["Cnstr"].ConnectionString);
            if (ModelState.IsValid)
            {
                if (lm.Login != "pandi" && lm.Password != "panda")
                {

                    ViewBag.Error = "Erreur Login/Password";
                    return View();
                }

                else
                {
                    SessionUtils.IsLogged = true;
                    return RedirectToAction("Index", "Home", new { area = "Membre" });
                }
            }
            else
            {
                return View();
            }
        }
        [HttpGet]
        public ActionResult NewMembre()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult NewMembre(MembreModel membre)
        {

           
            UnitOfWork ctx = new UnitOfWork(ConfigurationManager.ConnectionStrings["Cnstr"].ConnectionString);
            if (ctx.SaveSignUp(membre))
            {
                    ViewBag.SuccessMessage = " Inscription réussie";
                    //return RedirectToAction("Connection", "Home");
                
                    return View();
            }
            else
            {
                ViewBag.ErrorMessage = "inscription non valide ";
                //return RedirectToAction("NewMembre", "Home");
                return View();

            }
      

        }


    }
}

