use olimpiadas;

create table if not exists olim_events
(
  ID INT,
  Name VARCHAR(255),
  Sex VARCHAR(50),
  Age VARCHAR(50),
  Height VARCHAR(10),
  Weight VARCHAR(100),
  Team VARCHAR(255),
  NOC VARCHAR(255),
  Games VARCHAR(255),
  Year varchar(10),
  Season VARCHAR(255),
  City VARCHAR(255),
  Sport VARCHAR(255),
  Event VARCHAR(255),
  Medal VARCHAR(255)
);

LOAD DATA INFILE 'D:\\PROGRAMACION 2023\\EJERSICIO OLIMPIADAS\\athlete_events.csv'
INTO TABLE olim_events
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
IGNORE 1 ROWS;

CREATE INDEX IDX_NOC on olim_events(NOC);
CREATE INDEX IDX_GAMES on olim_events(GAMES);

  
  
