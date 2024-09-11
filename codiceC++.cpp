#include <iostream>
#include <iomanip>
#include <string>
#include "dependencies/include/libpq-fe.h"

using namespace std;

#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"
#define PG_PORT 5432
#define PG_DB "TheArtGallery"

bool controllaStato(PGconn* conn,PGresult * result){
    if (PQresultStatus(result) != PGRES_TUPLES_OK)
		{ 
			cout << "\nRisultati inconsistenti in esecuzione!" << PQerrorMessage(conn) << endl; 
			PQclear(result); 
			result = 0;
			return false;
		}
    return true;
}
void controlloPreparazione(PGconn* conn,PGresult * stmt){
    if (PQresultStatus(stmt) != 1) 
    { 
        cout << "Risultati inconsistenti in preparazione!" << PQerrorMessage(conn) << endl; 
        PQclear(stmt); 
        stmt = 0;
        PQfinish(conn); 
        system("pause");
        exit(1);
    }
}
void stampaQuery(PGresult* risultato){
    int nrRighe = PQntuples(risultato);
    if(nrRighe != 0){
        int nrColonne = PQnfields(risultato);
    string  ris[nrRighe +1][nrColonne];
    int lunghezzaMax[nrColonne];

    // popolamento della matrice ris con i risultati e i titoli delle colonne e calcolo lunghezza massima campi per ogni colonna
    for(int i = 0; i<nrColonne; i++){
        ris[0][i] = PQfname(risultato, i);
        lunghezzaMax[i] = ris[0][i].length();
    };

    // controllo lugnhezza dei risultati della query per colonna
    for(int i=1; i<nrRighe +1; i++){ 
            for(int j = 0; j<nrColonne; j++) {
            ris[i][j] = PQgetvalue(risultato, i-1, j);
            int lunghezza = ris[i][j].length();
            if(lunghezza > lunghezzaMax[j]) lunghezzaMax[j] = lunghezza;
            }
    }
    cout<<endl<<endl;
    // stampa risultati in colonna            
    for(int i=0; i<nrRighe +1; i++){
        for(int j = 0; j<nrColonne; j++){
            cout << setw(lunghezzaMax[j]) <<ris[i][j] <<"\t";
        }
        cout << "\n";
    }
    cout<<endl<<endl;
    }
    else{
        cout<< "\n\nIl risultato di questa query e' composto da 0 tuple. Nel database non sono presenti tuple corrispondenti a questa query.\n\n";
    }
    PQclear(risultato);
};

int main(int argc, char** argv) {
    cout<< " inserire la password del database:";
    char pass[50];
    cin >> pass;
    char conninfo[250];
	sprintf(conninfo , "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , pass , PG_DB , PG_HOST , PG_PORT);
	
	PGconn* conn;
	conn = PQconnectdb(conninfo);

	if(PQstatus(conn) != CONNECTION_OK) { // verifica connessione riuscita
		cout << "Errore di connessione \n\n" << PQerrorMessage(conn); 
		PQfinish(conn); 
        system("pause");
		exit(1);
	} else { 
		cout << "Connessione avvenuta correttamente! \n\n";
	}

    PGresult *stmt0 = PQprepare(conn,
                                "Query 0", // Visualizzare tutte le Mostre aperte nel periodo corrente o che apriranno in futuro
                                "SELECT m.ID, m.DataInizio, m.DataFine, m.Nome, m.Tema \
                                FROM Mostra m \
                                WHERE m.DataFine >= CURRENT_DATE; ",
                                0,
                                NULL);
    controlloPreparazione(conn, stmt0);

    PGresult *stmt1 = PQprepare(conn,
                                "Query 1", //Visualizzare tutte le opere esposte in una mostra
                                "SELECT o.Artista, o.Titolo, o.Descrizione, o.Materiali, o.AnnoCreazione \
                                FROM Opera o \
                                JOIN SpazioEsposizione s \
                                ON o.ID = s.IDOpera \
                                JOIN Mostra m \
                                ON s.IDMostra = m.ID \
                                WHERE m.ID = $1::int;",
                                1,
                                NULL);
    controlloPreparazione(conn, stmt1);
                            
    PGresult *stmt2 = PQprepare(conn,
                                "Query 2", //Calcolare il Totale delle entrate dovute all’acquisto di opere di una mostra
                                "SELECT SUM(Entrata.Importo) as Totale_Entrate \
                                FROM Entrata \
                                JOIN Opera \
                                ON Entrata.ID = Opera.IDBonifico \
                                WHERE IDMostra =  $1::int;",
                                1,
                                NULL);
    controlloPreparazione(conn, stmt2);

    PGresult *stmt3 = PQprepare(conn, 
                                "Query 3", // Stampare il numero di visitatori totale per ogni giorno di apertura di una data Mostra
                                "SELECT COUNT(IDVisitatore) as NrVisitatori ,DataIngresso \
                                FROM Entrata \
                                JOIN Mostra \
                                ON Entrata.IDMostra = $1::int AND Mostra.ID = $1::int \
                                WHERE DataIngresso IS NOT NULL \
                                GROUP BY DataIngresso \
                                ORDER BY DataIngresso;",
                                1,
                                NULL);
    controlloPreparazione(conn, stmt3);

    PGresult *stmt4 = PQprepare(conn,
                                "Query 4", // Visualizzare i 5 proprietari che hanno speso di più comprando opere e il totale degli introiti a loro dovuti
                                "SELECT p.ID, p.Nome, p.Cognome, p.Telefono, p.Email, SUM( e.Importo) as TotaleAcquisti \
                                FROM Proprietario p \
                                JOIN Opera o \
                                ON o.IDAcquirente = p.ID  \
                                JOIN Entrata e \
                                ON e.ID = o.IDBonifico \
                                GROUP BY p.ID \
                                ORDER BY TotaleAcquisti DESC  \
                                LIMIT 5;",
                                0,
                                NULL);
    controlloPreparazione(conn, stmt4);

    PGresult *stmt5 = PQprepare(conn,
                                "Query 5",//Visualizzare i proprietari che hanno comprato più di un’opera e il numero di opere da loro comprate
                                "SELECT p.ID, p.Nome, p.Cognome, p.Telefono, p.Email, COUNT(Opera.ID) AS TotaleAcquisti \
                                FROM Opera \
                                JOIN Proprietario p ON Opera.IDAcquirente = p.ID \
                                GROUP BY p.ID \
                                HAVING COUNT(Opera.ID) > 1 \
                                ORDER BY COUNT(Opera.ID) DESC;",
                                0,
                                NULL);
    controlloPreparazione(conn, stmt5);
    
    bool continua = true;
    while (continua){
        cout << "Vuoi eseguire una delle query disponibili? \ndigita il numero corrispondente per scegliere una query ed eseguirla: (qualsiasi altro tasto per uscire)\n\n"
        <<"0 - Visualizzare tutte le Mostre aperte nel periodo corrente o che apriranno in futuro.\n"
        <<"1 - Visualizzare tutte le opere esposte in una mostra, parametri esempio: 1, 2, 3\n"
        <<"2 - Calcolare il Totale delle entrate dovute all'acquisto di opere di una mostra, parametri esempio: 1, 2, 3 \n"
        <<"3 - Stampare il numero di visitatori totale per ogni giorno di apertura di una data Mostra, parametri esempio: 1, 2, 3\n" // è uguale a 2!
        <<"4 - Visualizzare i 5 proprietari che hanno speso di piu comprando opere e il totale degli introiti a loro dovuti\n"
        <<"5 - Visualizzare i proprietari che hanno comprato piu di un'opera e il numero di opere da loro comprate\n\n";
        int a;
        cin>> a;
        const char* parametri[5];
        PGresult* risultato = NULL;
        bool successo = false;
        string id;
        switch(a){
            case 0:
                risultato = PQexecPrepared(conn, "Query 0", 0, NULL, NULL, 0, 0);
                successo = controllaStato(conn, risultato);
                break;
            case 1:
                cout<<"inserisci l'ID della mostra: ";
                cin >> id;
                parametri[0] = id.c_str();
                risultato = PQexecPrepared(conn, "Query 1", 1, parametri, NULL, 0, 0);
                successo = controllaStato(conn, risultato);
                break;
            case 2:
                cout<<"inserisci l'ID della mostra: ";
                cin >> id;
                parametri[0] = id.c_str();
                risultato = PQexecPrepared(conn, "Query 2", 1, parametri, NULL, 0, 0);
                successo = controllaStato(conn, risultato);
                break;
            case 3:
                cout<<"inserisci l'ID della mostra: ";
                cin >> id;
                parametri[0] = id.c_str();
                risultato = PQexecPrepared(conn, "Query 3", 1, parametri, NULL, 0, 0);
                successo = controllaStato(conn, risultato);
                break;
            case 4:
                risultato = PQexecPrepared(conn, "Query 4", 0, parametri, NULL, 0, 0);
                successo = controllaStato(conn, risultato);
                break;
            case 5:
                risultato = PQexecPrepared(conn, "Query 5", 0, NULL, NULL, 0, 0);
                successo = controllaStato(conn, risultato);
                break;
            default:
                continua = false;
        }
        if(successo){
            stampaQuery(risultato);
        }
    }
    
    PQfinish(conn);
    return 0;
}
