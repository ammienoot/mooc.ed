USE `vpodata_warhol002`; -- change schema name here to process different Coursera datasets

/*
// DO NOT EDIT BELOW THIS LINE
//////////////////////////////////*/

ALTER TABLE coursera_pii 
DROP access_group,
DROP email_address,
DROP full_name,
DROP deleted;

# Tidy up proxied IP addresses - the first IP is the real one.
UPDATE coursera_pii
    SET last_access_ip = SUBSTRING_INDEX(last_access_ip,',',1)
where INSTR (last_access_ip, ',') > 0;

DROP TABLE IF EXISTS coursera_ip_country;

CREATE TABLE coursera_ip_country (
	coursera_user_id varchar(120),
	last_access_ip VARCHAR(255) NOT NULL,
	ip_country varchar(255),
	ip_continent varchar(45),
	PRIMARY KEY (coursera_user_id),
	INDEX (coursera_user_id)
) ENGINE=InnoDB CHARACTER SET = utf8mb4
SELECT coursera_user_id, last_access_ip, country_name as ip_country, continent_name as ip_continent
FROM coursera_pii, vpodata_helper.ip-- Edit this line to reflect where you have stored the ip lookup table in the format database.table
WHERE ip_from <= INET_ATON(last_access_ip) and ip_to >= INET_ATON(last_access_ip);

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_summary cs
INNER JOIN coursera_ip_country ip
ON cs.user_id = ip.coursera_user_id
SET cs.ip_country = ip.ip_country, cs.ip_continent = ip.ip_continent;

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'ISLAMIC REPUBLIC OF IRAN'
where ip_country = 'IRAN, ISLAMIC REPUBLIC OF';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'REPUBLIC OF MOLDOVA'
where ip_country = 'MOLDOVA, REPUBLIC OF';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'PROVINCE OF CHINA TAIWAN'
where ip_country = 'TAIWAN, PROVINCE OF CHINA';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'REPUBLIC OF KOREA'
where ip_country = 'KOREA, REPUBLIC OF';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'THE FORMER YUGOSLAV REPUBLIC OF MACEDONIA'
where ip_country = 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'UNITED REPUBLIC OF TANZANIA'
where ip_country = 'TANZANIA, UNITED REPUBLIC OF';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'OCCUPIED PALESTINIAN TERRITORY'
where ip_country = 'PALESTINIAN TERRITORY, OCCUPIED';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'BRITISH VIRGIN ISLANDS'
where ip_country = 'VIRGIN ISLANDS, BRITISH';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'U.S. VIRGIN ISLANDS'
where ip_country = 'VIRGIN ISLANDS, U.S.';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'FEDERATED STATES OF MICRONESIA '
where ip_country = 'MICRONESIA, FEDERATED STATES OF';

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_ip_country
SET ip_country = 'THE DEMOCRATIC REPUBLIC OF THE CONGO'
where ip_country = 'CONGO, THE DEMOCRATIC REPUBLIC OF THE';
