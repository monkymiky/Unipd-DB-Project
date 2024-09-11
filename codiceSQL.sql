drop table if exists Indirizzo;
drop table if exists Proprietario;
drop table if exists Mostra;
drop table if exists Visitatore;
drop table if exists Entrata;
drop table if exists Opera;
drop table if exists Trasferimento;
drop table if exists SpazioEsposizione;
drop table if exists ListinoPrezzi;
drop table if exists PrezziMostra;


CREATE TABLE Indirizzo (
	ID INT PRIMARY KEY,
	Stato VARCHAR(20) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	CAP CHAR(10) NOT NULL,
	NrCivico VARCHAR(10) NOT NULL,
	Città VARCHAR(50) NOT NULL,
	UNIQUE(Stato, Via, CAP, NrCivico)
);

CREATE TABLE Proprietario (
	ID INT PRIMARY KEY,
	TipoDocumento VARCHAR(30) NOT NULL,
	NrDocumento VARCHAR(30) NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL,
	Telefono VARCHAR(30) NOT NULL,
	Email VARCHAR(30) NOT NULL,
	IBAN VARCHAR(30),
	IDIndirizzo INT NOT NULL,
	UNIQUE(TipoDocumento,NrDocumento,Nome,Cognome),
	FOREIGN KEY (IDIndirizzo) REFERENCES Indirizzo(ID)
);

CREATE TABLE Mostra (
	ID INT PRIMARY KEY,
	DataInizio DATE NOT NULL,
	DataFine DATE NOT NULL CHECK (DataInizio<=DataFine),
	Nome VARCHAR(100) NOT NULL,
	Tema VARCHAR(100) NOT NULL,
	OrarioApertura TIME NOT NULL,
	OrarioChiusura TIME NOT NULL,
	NrSpaziDisponibili INT NOT NULL
);

CREATE TABLE Visitatore (
	ID INT PRIMARY KEY,
	TipoDocumento VARCHAR(30) NOT NULL,
	NrDocumento VARCHAR(30) NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL,
	Telefono VARCHAR(30) NOT NULL,
	Email VARCHAR(30) NOT NULL,
	UNIQUE(TipoDocumento,NrDocumento,Nome,Cognome)
);

CREATE TABLE Entrata (
	ID INT PRIMARY KEY,
	Importo Decimal(7,2) NOT NULL,
	DataOraPagamento TIMESTAMP NOT NULL,
	DataIngresso DATE,
	IDMostra INT NOT NULL,
	IDVisitatore INT,
	FOREIGN KEY (IDMostra) REFERENCES Mostra(ID),
	FOREIGN KEY (IDVisitatore) REFERENCES Visitatore(ID) ON UPDATE CASCADE
);

CREATE TABLE Opera (
	ID INT PRIMARY KEY,
	Titolo VARCHAR(100) NOT NULL,
	Artista VARCHAR(50) NOT NULL,
	Descrizione VARCHAR(500) NOT NULL,
	Materiali VARCHAR(500) NOT NULL,
	StatoVendita BOOLEAN NOT NULL,
	AnnoCreazione INT,
	Prezzo Decimal(7,2),
	PercentualeArtista INT,
	IDProprietario INT NOT NULL,
	IDBonifico INT,
	IDAcquirente INT,
	FOREIGN KEY (IDProprietario) REFERENCES Proprietario(ID) ON UPDATE CASCADE,
	FOREIGN KEY (IDBonifico) REFERENCES Entrata(ID),
	FOREIGN KEY (IDAcquirente) REFERENCES Proprietario(ID) ON UPDATE CASCADE
);

CREATE TABLE Trasferimento (
	ID INT PRIMARY KEY,
	Costo Decimal(7,2) NOT NULL,
	DataPartenza DATE NOT NULL,
	DataArrivo DATE NOT NULL,
	Tipo BOOL NOT NULL,
	CompagniaSpedizioni VARCHAR(50) NOT NULL,
	IDOpera INT NOT NULL,
	FOREIGN KEY (IDOpera) REFERENCES Opera(ID),
	UNIQUE (IDOpera, DataPartenza)
);

CREATE TABLE SpazioEsposizione (
	ID INT PRIMARY KEY,
	Costo Decimal (7,2),
	IDAffitto INT,
	IDMostra INT NOT NULL,
	IDOpera INT,
	FOREIGN KEY (IDAffitto) REFERENCES Entrata(ID),
	FOREIGN KEY (IDMostra) REFERENCES Mostra(ID) ON DELETE CASCADE,
	FOREIGN KEY (IDOpera) REFERENCES Opera(ID) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE ListinoPrezzi (
	ID INT PRIMARY KEY,
	Prezzo DECIMAL(7,2) NOT NULL,
	Descrizione VARCHAR(500) NOT NULL
);

CREATE TABLE PrezziMostra (
	ID INT PRIMARY KEY,
	IDPrezzo INT NOT NULL,
	IDMostra INT NOT NULL,
	FOREIGN KEY (IDPrezzo) REFERENCES ListinoPrezzi(ID),
	FOREIGN KEY (IDMostra) REFERENCES Mostra(ID)
);
	
INSERT INTO Indirizzo (ID, Stato, Via, CAP, NrCivico, Città) VALUES
(1,'UK','Houston Road','PA11','57','Bridge of Weir'),
(2,'Australia','Needlewood St','WA6442','12','Kambalda West'),
(3,'Canada','Withrow Ave','ONM4K1E4','248','Toronto'),
(4,'USA','John St','38703','1318','Greenville'),
(5,'Spagna','Ronda Leticia','45211','174','Puertollano'),
(6,'Cina','Shuang Jing Qiao Nan','655000','9','Qujing'),
(7,'Russia','Arzamasskaya','454000','3','Chelyabinsk'),
(8,'USA','Ferguson Street','02141','1865','Cambridge'),
(9,'Austria','Ruster Strasse','8753','52','Passhammer'),
(10,'Danimarca','Trollegade','1760','88','Kobenhavn'),
(11,'USA','Junkins Avenue','31601','51','Valdosta'),
(12,'Uruguay','Paysandu','91400','3713','Tala'),
(13,'Tunisia','Rue de Rabat','8010','73','Ksirat'),
(14,'Portogallo','Estrada Abrantes','6050-123','28','Villa Flor'),
(15,'Malesia','Jalan Rubber Kuching','93400','295','Kuching'),
(16,'Italia','Via Vicenza','40121','69','Bologna'),
(17,'UK','Folkestone Road','BH238YW','69','Winkton'),
(18,'Singapore','Kaki Bukit','415941','1','Singapore');


INSERT INTO Proprietario (ID, TipoDocumento, NrDocumento, Nome, Cognome, Telefono, Email,
						  IBAN, IDIndirizzo) VALUES
(1,'Patente','MOR99705272JO9OM','Jorgen','Mor','+4401505613218','jorgenmor@gmail.com','GB80BARC20040166695266',1),
(2,'Passaporto','535370359','Zdena','Akbar','+610395603656','zdenaakbar@gmail.com','AU76871084767948209895157993',2),
(3,'Passaporto','194334764','Rajko','Zeno','+13067510517','rajkozeno@gmail.com','CA45783323848567230712067775',3),
(4,'Passaporto','202163844','Jess','Jensen','+17854995345','jessjensen@gmail.com','US68336180735015377996514194',4),
(5,'Passaporto','770191775','Gavriel','Evino','+34780498538','gavrielevino@gmail.com','ES9320808447736147275718',5),
(6,'Passaporto','835567616','Ed','Hang','+8613063843721','edhang@gmail.com','CN61472661437202336163439931',6),
(7,'Passaporto','580992513','Veronica','Miroslav','+73515220973','veronicamiroslav@gmail.com','RU43826279202586060882254414',7),
(8,'Patente','503231073','Enea','Kelsi','+15084340339','eneakelsi@gmail.com','US15745508002902914179180113',8),
(9,'Passaporto','708015942','Tamila','Isa','+4206803778611','tamilaisa@gmail.com','AT121100059838547387',9),
(10,'Passaporto','827653090','Blandina','Perceval','+4531592570','blandinaperceval@gmail.com','DK7550514343211946',10),
(11,'Passaporto','199431181','Wei','Merike','+8613052896399','weimerike@gmail.com','CN64777222494967039666679055',6),
(12,'Patente','RF632015','Darrin','Mildburg','+12295159722','darrinmildburh@gmail.com','US05559974714224045157636302',11),
(13,'Passaporto','085144473','Magda','Alexios','+59891794946','magdaalexios@gmail.com',null,5),
(14,'Passaporto','816984327','Paula','Pastor','+59891794946','paulapastor@gmail.com',null,12),
(15,'Passaporto','418874946','Fatmir','Saliha','+21672280717','fatmirsaliha@gmail.com',null,13),
(16,'Passaporto','455962228','Siorus','Aristides','+351212452842839','siorusaristides@gmail.com',null,14),
(17,'Passaporto','770254579','Yawen','Shari','+60082246819','yawenshari@gmail.com',null,15),
(18,'Codice Fiscale','BLDKVN80A25H501C','Kevin','Baldo','+3903475307292','kevinbaldo@gmail.com',null,16),
(19,'Patente','SULLI705272VI9US','Victor','Sullivan','+4407914739039','victorsullivan@gmail.com',null,17),
(20,'Passaporto','135684654','Roman','Latif','+6567457428','romanlatif@gmail.com',null,18),
(21,'Passaporto','343813794','Marek','Daniel','','marekdaniel@gmail.com',null,12);


INSERT INTO Mostra (ID, DataInizio, DataFine, Nome, Tema, OrarioApertura, OrarioChiusura, NrSpaziDisponibili) VALUES
(1,'2020-11-10','2020-12-8','Nel Nostro Corpo','Raccolta di opere basate sul rapporto con il proprio corpo e quello altrui.',
 '8:30','16:30','4'),
(2,'2020-12-10','2021-01-10','Scelte e Apparizioni','Si vuole dar luce a tutte le nuove stelle in ambito artistico.',
 '8:00','15:30','7'),
(3,'2021-01-15','2021-02-20','Spazio in Transizione','Insieme di opere che trattano di spazio e tempo.',
 '14:00','18:40','3'),
(4,'2021-02-26','2021-03-31','Nuove Vedute','Raccolta di vedute e paesaggi del passato e del futuro.',
 '10:30','16:30','2'),
(5,'2021-04-3','2021-05-15','Arte del Futuro','Viene chiesto a vari artisti di immaginarsi il futuro.',
 '7:30','13:30','8');
(6,'2022-06-3','2022-09-15','Arte libera','Opere di fantasia dei grandi artisti contemporanei.',
 '7:30','13:30','0');

INSERT INTO Visitatore (ID, TipoDocumento, NrDocumento, Nome, Cognome, Telefono, Email) VALUES
(1,'Carta d Identità','CA548667HG','Mona', 'Hansford', 'mhansford0@t.co', '3776639323'),
(2,'Carta d Identità','CA931145RT','Orville', 'Ballaam', 'oballaam1@hp.com', '3776639357'),
(3,'Carta d Identità','CA986424DF','Gennifer', 'Cotmore', 'gcotmore2@salon.com', '3776639391'),
(4,'Carta d Identità','CA789543PO','Viki', 'Kubyszek', 'vkubyszek3@prweb.com', '3776639425'),
(5,'Carta d Identità','CA456776RR','Tyne', 'Piddington', 'tpiddington4@rediff.com', '3776639459'),
(6,'Carta d Identità','CA986426PO','Courtenay', 'Lathaye', 'clathaye5@vistaprint.com', '3776639493'),
(7,'Carta d Identità','CA246786VD','Gracie', 'Smolan', 'gsmolan6@is.gd', '3776639527'),
(8,'Carta d Identità','CA567754RD','Baxy', 'Baldacco', 'bbaldacco7@umn.edu', '3776639561'),
(9,'Carta d Identità','CA370555PA','Lilllie', 'Brakewell', 'lbrakewell8@digg.com', '3776639595'),
(10,'Carta d Identità','CA637753RA','Lavinie', 'Feacham', 'lfeacham9@mozilla.com', '3776639629'),
(11,'Carta d Identità','CA085245QQ','Papageno', 'Cridge', 'pcridgea@xinhuanet.com', '3776639663'),
(12,'Carta d Identità','CA087473BH','Wolf', 'Phlippsen', 'wphlippsenb@hc360.com', '3776639697'),
(13,'Carta d Identità','CA235753EH','Raff', 'Inkpin', 'rinkpinc@geocities.jp', '3776639731'),
(14,'Carta d Identità','CA234674UH','Tedman', 'Abriani', 'tabrianid@sphinn.com', '3776639765'),
(15,'Carta d Identità','CA653246QP','Bennie', 'Hould', 'bhoulde@i2i.jp', '3776639799'),
(16,'Carta d Identità','CA906426WE','Jesus', 'Aysik', 'jaysikf@wikipedia.org', '3776639833'),
(17,'Carta d Identità','CA988784IH','Linet', 'Thewlis', 'lthewlisg@blog.com', '3776639867'),
(18,'Carta d Identità','CA134757UH','Dorolice', 'Siveyer', 'dsiveyerh@google.co.uk', '3776639901'),
(19,'Carta d Identità','CA659844YH','Alexandro', 'Foskett', 'afosketti@usgs.gov', '3776639935'),
(20,'Carta d Identità','CA346367UI','Kessia', 'Layfield', 'klayfieldj@wired.com', '3776639969'),
(21,'Carta d Identità','CA245625WQ','Elia', 'Mcsarry', 'emcsarryk@godaddy.com', '3776640003'),
(22,'Carta d Identità','CA592969PO','Brok', 'Petcher', 'bpetcherl@dyndns.org', '3776640037'),
(23,'Carta d Identità','CA235853RT','Joscelin', 'Wilsone', 'jwilsonem@blogs.com', '3776640079'),
(24,'Carta d Identità','CA705885OT','Charles', 'Rash', 'crashn@bbb.org', '3776640105'),
(25,'Carta d Identità','CA684872ER','Clementia', 'Bantham', 'cbanthamo@homestead.com', '3776640139'),
(26,'Carta d Identità','CA245867QQ','Nils', 'Coppock.', 'ncoppockp@is.gd', '3776640173'),
(27,'Carta d Identità','CA096858YO','Phillip', 'Loeber', 'ploeberq@cdbaby.com', '3776640207'),
(28,'Carta d Identità','CA236984GH','Lona', 'Romagosa', 'lromagosar@foxnews.com', '3776640241'),
(29,'Carta d Identità','CA348575OL','Oswell', 'Forri', 'oforris@sphinn.com', '3776640275'),
(30,'Carta d Identità','CA238564TY','Lois', 'Redemile', 'lredemilet@seattletimes.com', '3776640309');

INSERT INTO Entrata (ID, Importo, DataOraPagamento, DataIngresso, IDMostra, IDVisitatore) VALUES
(1,10,'2020-11-12 13:48:00','2020-11-12',1,1),
(2,10,'2020-11-12 10:56:00','2020-11-12',1,2),
(3,10,'2020-11-13 12:24:00','2020-11-13',1,3),
(4,8,'2020-11-14 9:49:00','2020-11-14',1,4),
(5,15,'2020-11-18 13:56:00','2020-11-18',1,5),
(6,8,'2020-11-28 11:45:00','2020-11-28',1,6),
(7,10,'2020-11-28 9:45:00','2020-11-28',2,7),
(8,6,'2020-12-18 9:33:00','2020-12-18',2,8),
(9,10,'2020-12-18 8:34:00','2020-12-18',2,9),
(10,10,'2020-12-19 8:35:00','2020-12-19',2,10),
(11,22,'2021-01-15 16:30:00','2021-01-15',3,11),
(12,21,'2021-01-15 15:44:00','2021-01-15',3,12),
(13,24,'2021-01-15 15:06:00','2021-01-15',3,13),
(14,24,'2021-01-22 14:13:00','2021-01-22',3,14),
(15,22,'2021-01-22 14:13:00','2021-01-22',3,15),
(16,21,'2021-01-23 13:56:00','2021-01-23',3,16),
(17,22,'2021-01-23 16:01:00','2021-01-23',3,17),
(18,21,'2021-01-24 13:56:00','2021-01-24',3,18),
(19,10,'2021-03-02 11:40:00','2021-03-02',4,19),
(20,8,'2021-03-02 11:40:00','2021-03-02',4,20),
(21,15,'2021-03-02 11:40:00','2021-03-02',4,21),
(22,15,'2021-03-02 11:40:00','2021-03-02',4,22),
(23,15,'2021-03-02 11:40:00','2021-03-02',4,23),
(24,10,'2021-04-15 8:00:00','2021-04-15',5,24),
(25,10,'2021-04-15 8:00:00','2021-04-15',5,25),
(26,10,'2021-04-15 8:00:00','2021-04-15',5,26),
(27,6,'2021-04-19 9:00:00','2021-04-15',5,27),
(28,10,'2021-04-19 10:45:00','2021-04-15',5,28),
(29,10,'2021-04-22 11:22:00','2021-04-15',5,29),
(30,6,'2021-04-23 11:22:00','2021-04-15',5,30),
(31,670.2,'2020-11-13 12:24:00',null,1,null),
(32,431.4,'2020-11-28 11:45:00',null,2,null),
(33,440,'2020-12-19 8:35:00',null,2,null),
(34,550,'2021-01-22 14:13:00',null,3,null),
(35,550,'2021-01-22 14:13:00',null,3,null),
(36,458.5,'2021-01-23 13:56:00',null,3,null),
(37,65.2,'2021-01-23 13:56:00',null,3,null),
(38,557,'2021-03-02 11:40:00',null,4,null),
(39,354,'2021-03-02 11:40:00',null,4,null),
(40,345,'2021-03-02 11:40:00',null,4,null),
(41,569.2,'2021-03-03 12:40:00',null,4,null),
(42,543.42,'2021-03-04 10:40:00',null,4,null),
(43,567,'2021-04-15 8:00:00',null,5,null),
(44,320,'2021-04-15 8:00:00',null,5,null),
(45,357,'2021-04-15 8:00:00',null,5,null),
(46,230,'2021-04-15 15:30:00',null,5,null),
(47,134.6,'2021-04-15 15:30:00',null,5,null),
(48,222.2,'2021-04-15 15:30:00',null,5,null),
(49,3000,'2022-03-05 19:55:54',null,1,null),
(50,900,'2021-06-29 20:17:25',null,2,null),
(51,800,'2021-09-14 13:58:21',null,2,null),
(52,1100,'2021-06-19 18:01:09',null,4,null),
(53,600,'2021-08-19 10:55:57',null,4,null),
(54,2500,'2022-05-28 22:42:09',null,5,null),
(55,600,'2022-01-10 01:52:34',null,5,null),
(56,3000,'2022-03-14 07:45:11',null,5,null),
(57,1500,'2022-04-20 19:39:18',null,5,null),
(58,1200,'2021-10-21 13:52:28',null,5,null);

INSERT INTO Opera (ID, Titolo, Artista, Descrizione, Materiali, StatoVendita, AnnoCreazione,
				   Prezzo, PercentualeArtista, IDProprietario, IDBonifico, IDAcquirente) VALUES
(1,'Redenzione','Leonard Antonia','Libera interpretazione','Olio su tela',false,2017,400,30,13,null,null),
(2,'Luisa','Jorgen Mor','Libera interpretazione','Acrilici su tela',true,2020,1000,40,1,null,null),
(3,'Dolore e sorpresa','Agilmar Odoacre','Libera interpretazione','Ferro',false,2021,1200,45,14,null,null),
(4,'La Bambola','Mirjam Magda','Libera interpretazione','Olio su tela',false,2014,800,20,15,null,null),
(5,'L Infanzia','Fabiano Kerem','Libera interpretazione','Marmo',false,2018,1900,50,16,null,null),
(6,'Santità','Jorgen Mor','Libera interpretazione','Tecnica mista',false,2022,2000,60,17,null,null),
(7,'Contemplazione del Chaos','Zdena Akbar','Libera interpretazione','Acquerello',true,2020,500,30,2,null,null),
(8,'Futuro Infinito','Constantijn Kalyan','Libera interpretazione','Bronzo',false,2019,3000,40,18,49,18),
(9,'Medaglia d onore','Warwick Brighid','Libera interpretazione','Bronzo',false,2007,2000,30,19,null,null),
(10,'Senza nome','Chetan Adelle','Libera interpretazione','Acrilico su tavola',false,2018,900,25,20,50,20),
(11,'Paese di libertà','Sebastiao Amar','Libera interpretazione','Olio su tela',false,2016,800,30,21,null,null),
(12,'Trono','Uranus Thalia','Libera interpretazione','Ferro',false, 2018,2500,50,13,null,null),
(13,'Candele','Alvise Nora','Libera interpretazione','Carta e paglia',false,2020,600,30,17,null,null),
(14,'Saggezza della foresta','Young-Ho Siarhei','Libera interpretazione','Olio su tela',false,2021,1200,25,18,null,null),
(15,'Joseph','Rajko Geno','Libera interpretazione','Olio su tavola',true,2016,1000,30,3,null,null),
(16,'Vergogna','Shepherd Hameed','Libera interpretazione','Legno',false,2020,1200,40,18,null,null),
(17,'Indovinelli','Gabriel Mariano','Libera interpretazione','Tela',false,1999,2400,25,16,null,null),
(18,'Curiosità Velata','Laurentius Uxía','Libera interpretazione','Tecnica mista',false,2015,1000,30,16,51,16),
(19,'Questioni di Prospettiva','Jess Jensen','Libera interpretazione','Plexiglass',false,2018,2000,35,21,null,null),
(20,'Ombre','Jess Jensen','Libera interpretazione','Plexiglass',true,2020,3000,45,4,null,null),
(21,'Elezione','Akachi Anan','Libera interpretazione','Olio su tela',false,2015,800,20,15,null,null),
(22,'Natura','Sajjad Nela','Libera interpretazione','Acrilico su tela',false,2000,1200,40,14,null,null),
(23,'Veduta I','Gavriel Egino','Libera interpretazione','Pastello su tela',true,2019,600,30,5,null,null),
(24,'Veduta II','Gavriel Egino','Libera interpretazione','Pastello su tela',true,2019,600,30,5,null,null),
(25,'Il Prezzo','Ed Hang','Libera interpretazione','Argento',true,2021,4000,50,6,null,null),
(26,'Battaglia','Ed Hang','Libera interpretazione','Bronzo',true,2021,3000,50,6,null,null),
(27,'Successo','Brand Joan','Libera interpretazione','Oro',false,2021,4500,45,19,null,null),
(28,'Priorità','Priyanka Akua','Libera interpretazione','Olio su tela',false,2018,1100,50,16,52,16),
(29,'Foto di famiglia','Griogair Demir','Libera interpretazione','Stampa',false,2017,600,20,16,53,16),
(30,'Ombre','Maria Wit','Libera interpretazione','Argilla',false,2019,1400,30,14,null,null),
(31,'Linguaggio dei segni','Veronica Miroslav','Libera interpretazione','Cartone',true,2016,1800,55,7,null,null),
(32,'Divisione astratta','Veronica Miroslav','Libera interpretazione','Cartone',true,2016,1800,55,7,null,null),
(33,'Il cambiamento','Enea Kelsi','Libera interpretazione','Carta',true,2021,2000,35,8,null,null),
(34,'Segnale','Veronica Miroslav','Libera interpretazione','Ferro',false,2015,2500,20,20,54,20),
(35,'Senza nome','Ealdwine Kamen','Libera interpretazione','Acrilico su tela',false,2015,600,30,19,55,19),
(36,'Sospetto di desiderio','Blanche Louisa','Libera interpretazione','Stoffa',false,2016,3000,50,11,56,11),
(37,'Celebrazione','Calleigh Frangag','Libera interpretazione','Olio su tela',false,2018,2500,40,9,null,null),
(38,'Territorio Olistico','Tamila Isa','Libera interpretazione','Pietra',true,2019,5000,40,9,null,null),
(39,'I giardini','Tamila Isa','Libera interpretazione','Acquerello',true,2018,3000,30,9,null,null),
(40,'Esistenza','Tamila Isa','Libera interpretazione','Acquerello',false,2018,1500,30,14,57,14),
(41,'Visione di Costa','Cleon Todor','Libera interpretazione','Acrilico su tela',false,2015,800,35,19,null,null),
(42,'Senza Nome','Cleon Todor','Libera interpretazione','Acrilico su tela',false,2015,900,35,15,null,null),
(43,'Aspirazione','Eve Marina','Libera interpretazione','Argilla',false,2018,1200,50,17,58,17),
(44,'Fragilità','Eve Marina','Libera interpretazione','Argilla',false,2019,1400,40,21,null,null),
(45,'Il fato','Blandina Perceval','Libera interpretazione','Tecnica mista',true,2021,1700,55,10,null,null),
(46,'Nessuno','Blandina Perceval','Libera interpretazione','Legno',true,2021,1500,60,10,null,null),
(47,'Senza nome','Blandina Perceval','Libera interpretazione','Acciaio',true,2020,3000,45,10,null,null),
(48,'In Città','Wei Merike','Libera interpretazione','Cemento',true,2020,4000,30,11,null,null),
(49,'Orrore','Darrin Mildburg','Libera interpretazione','Olio su tela',true,2021,1200,45,12,null,null),
(50,'Amore','Darrin Mildburg','Libera interpretazione','Olio su tela',true,2020,1000,40,12,null,null);

INSERT INTO Trasferimento (ID, Costo, DataPartenza, DataArrivo, Tipo, CompagniaSpedizioni, IDOpera) VALUES
(1, 59.02, '2021-01-27', '2021-02-23', true,'DHL',1),
(2, 34.57, '2021-01-29', '2021-08-25', false,'DHL',1),
(3, 80.8, '2020-12-05', '2021-05-31', true,'DHL',2),
(4, 59.3, '2022-03-02', '2021-11-15', false,'DHL',2),
(5, 51.42, '2021-11-16', '2021-12-06', false,'DHL',3),
(6, 80.37, '2021-03-10', '2021-07-28', true,'DHL',3),
(7, 100.68, '2022-02-05', '2022-03-26', false,'DHL',4),
(8, 69.56, '2022-03-11', '2021-02-10', false,'DHL',4),
(9, 117.24, '2021-03-31', '2021-12-02', false,'DHL',5),
(10, 115.61, '2021-03-25', '2021-01-26', true,'DHL',5),
(11, 80.43, '2021-10-18', '2021-12-05', true,'DHL',6),
(12, 62.82, '2021-03-23', '2022-03-11', false,'DHL',6),
(13, 62.62, '2022-01-20', '2021-08-03', true,'DHL',7),
(14, 83.88, '2021-10-27', '2021-04-15', true,'DHL',7),
(15, 93.0, '2021-05-21', '2021-12-17', true,'DHL',8),
(16, 106.73, '2021-04-19', '2021-02-13', false,'DHL',8),
(17, 48.4, '2021-11-28', '2021-06-11', false,'DHL',9),
(18, 49.05, '2021-12-28', '2021-02-09', true,'DHL',9),
(19, 96.64, '2021-04-06', '2022-04-12', true,'DHL',10),
(20, 69.99, '2021-10-03', '2021-03-05', true,'DHL',10),
(21, 47.9, '2022-04-28', '2022-03-13', true,'DHL',11),
(22, 116.12, '2021-09-07', '2021-12-08', true,'DHL',12),
(23, 60.19, '2021-03-16', '2021-03-30', true,'DHL',13),
(24, 71.15, '2022-03-16', '2021-07-19', true,'DHL',12),
(25, 60.66, '2022-05-11', '2021-12-31', false,'DHL',13),
(26, 100.71, '2021-02-23', '2021-03-11', false,'DHL',14),
(27, 92.29, '2021-11-02', '2021-06-24', true,'DHL',14),
(28, 102.11, '2021-05-27', '2021-11-06', true,'DHL',15),
(29, 73.64, '2020-11-16', '2022-04-30', false,'DHL',15),
(30, 105.91, '2021-07-07', '2022-03-09', false,'DHL',16),
(31, 110.33, '2021-12-05', '2021-08-23', true,'DHL',16),
(32, 58.52, '2021-05-05', '2021-06-25', false,'DHL',17),
(33, 69.52, '2022-01-26', '2021-12-26', false,'DHL',17),
(34, 101.74, '2021-07-11', '2022-05-05', false,'DHL',18),
(35, 79.43, '2022-03-06', '2021-03-21', true,'DHL',18),
(36, 64.71, '2022-04-27', '2021-10-27', true,'DHL',19),
(37, 52.1, '2021-06-17', '2021-05-13', false,'DHL',19),
(38, 96.89, '2022-03-20', '2021-12-22', false,'DHL',20),
(39, 66.14, '2021-11-19', '2022-04-11', false,'DHL',20),
(40, 88.63, '2022-02-16', '2021-10-23', false,'DHL',21),
(41, 67.48, '2021-02-22', '2021-01-17', false,'DHL',22),
(42, 42.03, '2020-11-01', '2021-10-05', false,'DHL',21),
(43, 72.11, '2021-05-31', '2021-05-16', true,'DHL',22),
(44, 33.28, '2021-10-16', '2022-02-07', false,'DHL',23),
(45, 47.28, '2021-02-06', '2022-04-13', true,'DHL',23),
(46, 52.06, '2022-05-03', '2022-04-10', true,'DHL',24),
(47, 32.1, '2021-10-08', '2021-01-25', true,'DHL',24),
(48, 116.54, '2021-08-02', '2022-02-16', false,'DHL',25),
(49, 43.51, '2021-10-17', '2021-01-17', false,'DHL',25),
(50, 32.39, '2021-05-20', '2021-11-02', false,'DHL',26),
(51, 83.34, '2021-01-21', '2021-03-27', true,'GLS',26),
(52, 52.55, '2021-06-10', '2021-04-06', false,'GLS',27),
(53, 117.54, '2020-12-19', '2022-05-27', true,'GLS',27),
(54, 83.27, '2022-03-29', '2021-10-18', true,'GLS',28),
(55, 117.85, '2021-04-21', '2022-05-04', false,'GLS',28),
(56, 65.08, '2022-05-13', '2022-04-05', false,'GLS',29),
(57, 117.95, '2021-10-08', '2021-08-16', true,'GLS',29),
(58, 36.89, '2021-04-28', '2021-01-30', false,'GLS',30),
(59, 110.67, '2021-07-09', '2021-11-17', false,'GLS',30),
(60, 116.13, '2021-06-16', '2022-01-30', false,'GLS',31),
(61, 82.69, '2020-12-03', '2022-01-13', true,'GLS',31),
(62, 106.65, '2021-10-13', '2021-09-02', true,'GLS',32),
(63, 40.27, '2022-05-10', '2021-06-01', true,'GLS',32),
(64, 109.43, '2021-09-03', '2021-04-16', false,'GLS',33),
(65, 65.99, '2021-11-27', '2021-03-17', true,'GLS',33),
(66, 44.12, '2021-04-04', '2021-09-18', true,'GLS',34),
(67, 92.63, '2022-04-10', '2022-03-18', false,'GLS',34),
(68, 110.39, '2021-05-02', '2022-02-12', false,'GLS',35),
(69, 61.36, '2021-06-17', '2022-03-05', true,'GLS',35),
(70, 101.42, '2022-02-05', '2021-06-29', true,'GLS',36),
(71, 102.58, '2021-09-09', '2021-06-09', false,'GLS',36),
(72, 57.32, '2022-04-27', '2021-05-17', false,'GLS',37),
(73, 77.59, '2020-11-04', '2022-02-07', true,'GLS',37),
(74, 45.76, '2020-12-19', '2021-08-26', false,'GLS',38),
(75, 66.56, '2021-11-18', '2021-04-22', true,'GLS',38),
(76, 116.94, '2021-01-25', '2021-02-13', true,'GLS',39),
(77, 80.6, '2021-01-04', '2021-03-18', false,'GLS',39),
(78, 105.42, '2022-03-13', '2021-01-17', true,'GLS',40),
(79, 74.58, '2020-12-21', '2021-01-20', false,'GLS',40),
(80, 44.42, '2021-01-22', '2021-03-01', true,'GLS',41),
(81, 92.28, '2022-04-30', '2021-01-14', false,'GLS',41),
(82, 80.81, '2022-01-05', '2022-03-13', true,'GLS',42),
(83, 54.57, '2022-03-12', '2021-04-18', true,'GLS',42),
(84, 81.1, '2020-12-18', '2022-03-28', true,'GLS',43),
(85, 79.37, '2022-04-26', '2021-10-07', true,'GLS',43),
(86, 86.57, '2022-04-03', '2021-05-06', false,'GLS',44),
(87, 71.96, '2021-01-23', '2021-07-15', false,'GLS',44),
(88, 108.88, '2021-01-29', '2022-04-18', false,'GLS',45),
(89, 101.88, '2021-12-26', '2021-02-18', false,'GLS',45),
(90, 44.86, '2021-09-03', '2022-01-12', true,'GLS',46),
(91, 45.96, '2021-04-28', '2021-05-18', true,'GLS',46),
(92, 63.56, '2021-05-06', '2022-05-13', false,'GLS',47),
(93, 61.99, '2021-10-02', '2021-10-26', false,'GLS',47),
(94, 65.43, '2022-04-21', '2022-05-13', true,'GLS',48),
(95, 52.4, '2021-10-10', '2021-10-06', true,'GLS',48),
(96, 30.05, '2022-01-15', '2021-09-24', true,'GLS',49),
(97, 107.79, '2021-07-22', '2021-09-01', true,'GLS',49),
(98, 96.89, '2021-02-04', '2021-07-07', true,'GLS',50),
(99, 108.18, '2021-02-15', '2021-06-24', true,'GLS',50);

INSERT INTO SpazioEsposizione (ID, Costo, IDAffitto, IDMostra, IDOpera) VALUES
(1,null,null,1,1),
(2,670.2,31,1,2),
(3,null,null,1,3),
(4,null,null,1,4),
(5,null,null,1,5),
(6,null,null,1,6),
(7,null,null,1,7),
(8,null,null,1,8),
(9,null,null,1,9),
(10,null,null,2,10),
(11,null,null,2,11),
(12,null,null,2,12),
(13,null,null,2,13),
(14,null,null,2,14),
(15,431.4,32,2,15),
(16,null,null,2,16),
(17,null,null,2,17),
(18,null,null,2,18),
(19,null,null,2,19),
(20,440,33,2,20),
(21,null,null,3,21),
(22,null,null,3,22),
(23,550,34,3,23),
(24,550,35,3,24),
(25,458.5,36,3,25),
(26,65.2,37,3,26),
(27,null,null,3,27),
(28,null,null,3,28),
(29,null,null,3,29),
(30,null,null,4,30),
(31,557,38,4,31),
(32,354,39,4,32),
(33,345,40,4,33),
(34,null,null,4,34),
(35,null,null,4,35),
(36,null,null,4,36),
(37,null,null,4,37),
(38,569.2,41,4,38),
(39,543,42,4,39),
(40,null,null,4,40),
(41,null,null,5,41),
(42,null,null,5,42),
(43,null,null,5,43),
(44,null,null,5,44),
(45,567,43,5,45),
(46,320,44,5,46),
(47,357,45,5,47),
(48,230,46,5,48),
(49,134.6,47,5,49),
(50,222.2,48,5,50),
(51,null,null,1,null),
(52,null,null,1,null),
(53,null,null,1,null),
(54,null,null,1,null),
(55,null,null,2,null),
(56,null,null,2,null),
(57,null,null,2,null),
(58,null,null,2,null),
(59,null,null,2,null),
(60,null,null,2,null),
(61,null,null,2,null),
(62,null,null,3,null),
(63,null,null,3,null),
(64,null,null,3,null),
(65,null,null,4,null),
(66,null,null,4,null),
(67,null,null,5,null),
(68,null,null,5,null),
(69,null,null,5,null),
(70,null,null,5,null),
(71,null,null,5,null),
(72,null,null,5,null),
(73,null,null,5,null),
(74,null,null,5,null);


INSERT INTO ListinoPrezzi (ID, Prezzo, Descrizione) VALUES
(1,10,'visitatori under 35'),
(2,8,'visitatori under 18'),
(3,15,'visitatori over 35'),
(4,10,'standard'),
(5,6,'sconto studenti'),
(6,0,'bambini alti meno di 1,20 metri'),
(7,22,'visitatori under 35'),
(8,21,'visitatori under 18'),
(9,24,'visitatori over 35');

INSERT INTO PrezziMostra (ID, IDPrezzo, IDMostra) VALUES
(1,1,1),
(2,2,1),
(3,3,1),
(4,4,2),
(5,5,2),
(6,6,2),
(7,7,3),
(8,8,3),
(9,9,3),
(10,1,4),
(11,2,4),
(12,3,4),
(13,4,5),
(14,5,5),
(15,6,5);

-- Visualizzare tutte le Mostre aperte nel periodo corrente o che apriranno in futuro
SELECT m.ID, m.DataInizio, m.DataFine, m.Nome, m.Tema
FROM Mostra m
WHERE m.DataFine >= CURRENT_DATE;

-- Visualizzare tutte le opere esposte in una mostra (1)
SELECT o.Artista, o.Titolo, o.Descrizione, o.Materiali, o.AnnoCreazione
FROM Opera o
JOIN SpazioEsposizione s
ON o.ID = s.IDOpera
JOIN Mostra m
ON s.IDMostra = m.ID
WHERE m.ID = 1;

-- Calcolare il Totale delle entrate dovute all’acquisto di opere di una mostra (1)
SELECT SUM(Entrata.Importo) as Totale_Entrate
FROM Entrata
JOIN Opera
ON Entrata.ID = Opera.IDBonifico
WHERE IDMostra = 1;

-- Stampare il numero di visitatori totale per ogni giorno di apertura di una data Mostra (1)
SELECT COUNT(IDVisitatore) as NrVisitatori ,DataIngresso
FROM Entrata
JOIN Mostra
ON Entrata.IDMostra = 1 AND Mostra.ID = 1
WHERE DataIngresso IS NOT NULL
GROUP BY DataIngresso
ORDER BY DataIngresso;

--  Visualizzare i 5 proprietari che hanno speso di più comprando opere e il totale degli introiti a loro dovuti
SELECT p.ID, p.Nome, p.Cognome, p.Telefono, p.Email, SUM( e.Importo) as TotaleAcquisti
FROM Proprietario p
JOIN Opera o
ON o.IDAcquirente = p.ID 
JOIN Entrata e
ON e.ID = o.IDBonifico
GROUP BY p.ID
ORDER BY TotaleAcquisti DESC 
LIMIT 5

-- Visualizzare i proprietari che hanno comprato più di un’opera e il numero di opere da loro comprate
SELECT p.ID, p.Nome, p.Cognome, p.Telefono, p.Email, COUNT(Opera.ID) AS TotaleAcquisti
FROM Opera
JOIN Proprietario p ON Opera.IDAcquirente = p.ID
GROUP BY p.ID
HAVING COUNT(Opera.ID) > 1
ORDER BY COUNT(Opera.ID) DESC

-- indice
CREATE INDEX spazimostra
ON SpazioEsposizione (IDMostra); 

