using System.Web;
using System.Web.Optimization;

namespace HomeShare
{
    public class BundleConfig
    {
        // Pour plus d'informations sur le regroupement, visitez https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            //bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
            //            "~/Scripts/jquery.validate*"));

            //// Utilisez la version de développement de Modernizr pour le développement et l'apprentissage. Puis, une fois
            //// prêt pour la production, utilisez l'outil de génération à l'adresse https://modernizr.com pour sélectionner uniquement les tests dont vous avez besoin.
           
            bundles.Add(new StyleBundle("~/Content/css").Include
                (
                      "~/Content/bootstrap.css",
                      "~/css/style.css",
                    //Owl stylesheet:
                      "~/css/owl.carousel.css",
                      "~/css/owl.theme.css",
                    //slitslider :
                      "~/css/slitslider/style.css",
                      "~/css/slitslider/custom.css"
                 ));
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                       "~/Scripts/jquery-{version}.js"
                       
                 ));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                    "~/Scripts/bootstrap.js"
                 ));

            bundles.Add(new ScriptBundle("~/bundles/js").Include(
                     "~/js/script.js",
                     "~/js/owl.carousel.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"
                ));
            bundles.Add(new ScriptBundle("~/bundles/jquerySlitslider").Include(
                    "~/js/jquery.slitslider.js"

               ));
            bundles.Add(new ScriptBundle("~/bundles/jqueryBaCond").Include(
                   "~/js/jquery.ba-cond.min.js"

              ));
        }
    }
    
}
