using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace GestionDb.Repositories
{
    public abstract class BaseRepository<T> 
        where T : class, new()
    {
        protected SqlConnection connection;

        #region Constructor
        public BaseRepository(string connectionString)
        {
            connection = new SqlConnection(connectionString);
        }
        #endregion
        #region Methods
        #region Public
        protected  List<T> Get(string requete)
        {
            if (Connect())
            {
                //Ma variable de retour                 
                //List<Utilisateur> retour = new List<Utilisateur>();            
                // si pas de contraintes (Where T :....) ==> (List<T>)Activator.CreateInstance(typeof(List<T>));
                List<T> retour = new List<T>();
                //Création de commande
                SqlCommand oCmd = new SqlCommand(requete, connection);
                SqlDataReader oDr = oCmd.ExecuteReader();
                //Je lis ligne par ligne
                while (oDr.Read())
                {
                    retour.Add(MapTo(oDr));
                }
                //!!!!!!!!!!!!!!!!!WARNING : FERMETURE DE L'oDR OBLIGATOIRE!!!!!!!!!!!!!!!!
                oDr.Close();
                Disconnect();
                //renvoyer la liste des utilisateurs de db
                return retour;
            }
            else
            {
                return null;
            }
        }

        protected List<T> Get(string requete, Dictionary<string, object> parametres)
        {
            if (Connect())
            {
                //Ma variable de retour                 
                //List<Utilisateur> retour = new List<Utilisateur>();            
                // si pas de contraintes (Where T :....) ==> (List<T>)Activator.CreateInstance(typeof(List<T>));
                List<T> retour = new List<T>();
                SqlCommand oCmd = new SqlCommand(requete, connection);
                foreach (var item in parametres)
                {
                    oCmd.Parameters.Add(new SqlParameter(item.Key, item.Value));
                }
                //Création de commande

                SqlDataReader oDr = oCmd.ExecuteReader();
                //Je lis ligne par ligne
                while (oDr.Read())
                {
                    retour.Add(MapTo(oDr));
                }
                //!!!!!!!!!!!!!!!!!WARNING : FERMETURE DE L'oDR OBLIGATOIRE!!!!!!!!!!!!!!!!
                oDr.Close();
                Disconnect();
                //renvoyer la liste des utilisateurs de db
                return retour;
            }
            else
            {
                return null;
            }
        }

        protected T GetOne(int PK, string requete)
        {
            if (Connect())
            {
                //Ma variable de retour
                T retour = new T(); //Possible car on a contraint le type avec class, new()

                //Faire ma requête select ==> récuperée par le paramètre

                //Création de commande
                SqlCommand oCmd = new SqlCommand(requete, connection);
                SqlParameter paramId = new SqlParameter("id", PK);
                oCmd.Parameters.Add(paramId);
                SqlDataReader oDr = oCmd.ExecuteReader();
                //Y'a-t-il un retour de la db ?
                if (oDr.HasRows)
                {
                    //je récupère l'unique enregistrement
                    oDr.Read();
                    retour = MapTo(oDr);
                }

                //!!!!!!!!!!!!!!!!!WARNING : FERMETURE DE L'oDR OBLIGATOIRE!!!!!!!!!!!!!!!!
                oDr.Close();
                Disconnect();
                //renvoyer la liste des utilisateurs de db
                return retour;
            }
            else
            {
                return null;
            }
        }

        protected bool Insert(T toInsert, string insertRequete)
        {
            if (Connect())
            {
                SqlCommand oCmd = new SqlCommand(insertRequete, connection);

                //Je suppose que le nom des paramètres dans la requête = le nom de la propriété dans l'objet T
                oCmd.Parameters.AddRange(MapToSqlParameter(toInsert)); 

                bool isInserted = false;
                try
                {
                    int info = oCmd.ExecuteNonQuery();
                    isInserted = true;
                }
                catch (Exception ex)
                {

                    isInserted = false;
                }

                //fermer ma connexion vers la DB
                Disconnect();
                //renvoyer le résultat de l'insertion
                return isInserted;

            }
            else
            {
                return false;
            }


        }

        protected bool Update(T toUPdate, string updateRequete)
        {

            if (Connect())
            {
                SqlCommand oCmd = new SqlCommand(updateRequete, connection);

                //Je suppose que le nom des paramètres dans la requête = le nom de la propriété dans l'objet T
                oCmd.Parameters.AddRange(MapToSqlParameter(toUPdate));

                bool isUpdated = false;
                try
                {
                    int info = oCmd.ExecuteNonQuery();
                    isUpdated = true;
                }
                catch (Exception ex)
                {

                    isUpdated = false;
                }

                //fermer ma connexion vers la DB
                Disconnect();
                //renvoyer le résultat de l'insertion
                return isUpdated;

            }
            else
            {
                return false;
            }
        }

        protected bool Delete(T toDelete, string deleteRequete)
        {
            if (Connect())
            {
                SqlCommand oCmd = new SqlCommand(deleteRequete, connection);

                //Je suppose que le nom des paramètres dans la requête = le nom de la propriété dans l'objet T
                oCmd.Parameters.AddRange(MapToSqlParameter(toDelete));

                bool isDeleted = false;
                try
                {
                    int info = oCmd.ExecuteNonQuery();
                    isDeleted = true;
                }
                catch (Exception ex)
                {

                    isDeleted = false;
                }

                //fermer ma connexion vers la DB
                Disconnect();
                //renvoyer le résultat de l'insertion
                return isDeleted;

            }
            else
            {
                return false;
            }
        }



        #endregion
        #region Private

        /// <summary>
        /// Permet d'ouvrir la connexion vers la db
        /// </summary>
        /// <returns>False si une exception se produit</returns>
        private bool Connect()
        {
            try
            {
                connection.Open();
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        /// <summary>
        /// Permet de me deconnecter de la db
        /// </summary>
        /// <returns>return false si une exception se produit</returns>
        private bool Disconnect()
        {
            try
            {
                connection.Close();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }



        /// <summary>
        /// Permet de mapper les colonnes du datareader aux propriétés de l'objet T à renvoyer
        /// </summary>
        /// <param name="oDr">Un SqlDataReader ouvert et ayant une row (odr.read())</param>
        /// <returns>un objet de type T contenant les infos de la DB</returns>
        private T MapTo(SqlDataReader oDr)
        {
            T retour = new T();
            //JE considère que les propriétés de l'objet T = Colonnes de la table T
            //                                       T.... =   odr["..."]
            // Nom de la propriété = Nom de la colonne
            //Parcourir les propriétés de l'objet T
            //via la reflection (!!!! Performance !!!)
            //typeof(T) ==> Utilisateur ou Produit ==> la classe
            Type maClasse = typeof(T);
            //maClasse.GetProperties() ==> tous les get set de la classe
            // pour récupérer une valeur retour.Nom = "valeur";
            //Mapping
            foreach (PropertyInfo item in maClasse.GetProperties())
            {
                //item = monUtilisateur.Nom
                //item.Name = nom de la propriété
                //item.GetValue() ==> retour.Nom
                //item.SetValue(retour,"") ==> retour.Nom=""
                //if (oDr["Nom"] == DBNull.Value)
                try
                {
                    if (oDr[item.Name] == DBNull.Value)
                    {
                        //    retour.Nom = null;
                        item.SetValue(retour, null);
                    }
                    else
                    {
                        //    retour.Nom = oDr["Nom"].ToString();
                        item.SetValue(retour, oDr[item.Name]);
                    }
                }
                catch (IndexOutOfRangeException Iex)
                {
                    Debug.WriteLine(Iex.Message); 
                }
            }
            return retour;
        }
       
        /// <summary>
        /// Permet de mapper les propriétés d'un objet à un tableau de SqlParameters
        /// </summary>
        /// <param name="toMap">L'objet (Utilisateur, Produits,...) T qui contient les props à mapper</param>
        /// <returns>un tableau de <see cref="SqlParameter"/> contenant les données</returns>
        private SqlParameter[] MapToSqlParameter(T toMap)
        {
            List<SqlParameter> parametres = new List<SqlParameter>();


            Type maClasse = typeof(T); 
            //Mapping
            foreach (PropertyInfo item in maClasse.GetProperties())
            {
                SqlParameter param = new SqlParameter();
                param.ParameterName = item.Name;

                //Un Sqlparameter = null (c#) ==> default côté DB
                //Un sqlparameter = DBNull.Value(c#) ==> null côté DB


                param.Value = item.GetValue(toMap)?? DBNull.Value; //Coalesce
                // if(item.GetValue(toMap)==null) 
                //       param.Value =DBNull.value ;
                // else
                //       param.Value =item.GetValue(toMap);

                // param.Value = item.GetValue(toMap) ==null? DBNull.value : item.GetValue(toMap);



                //Exemple :
                //  param.SqlDbType= System.Data.SqlDbType.NVarChar ~= string ==> Dépend du type de la propriété
                //  param.Size = 50;
                parametres.Add(param);
            }

            return parametres.ToArray();
         }

        #endregion
        #endregion
    }
}
