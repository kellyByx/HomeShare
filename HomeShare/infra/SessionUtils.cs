using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HomeShare.infra
{
    public class SessionUtils
    {
        public static bool IsLogged
        {
            get
            {
                if (HttpContext.Current.Session["logged"] == null)
                {
                    HttpContext.Current.Session["logged"] = false;
                }
                return (bool)HttpContext.Current.Session["logged"];
            }

            set { HttpContext.Current.Session["logged"] = value; }
        }
    }
}