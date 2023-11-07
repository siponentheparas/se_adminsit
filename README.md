# se_adminsit
Admin keissi scripti joka auttaa admineita tekemään keissejä :)

## Mikä tämä on
Tämä on yhdessä päivässä tehty admin scripti, joka auttaa fivem servujen admineita pitämään admin keissejä.

## Toiminnot
- Voit luoda/poistaa admin keissejä.
- Voit lisätä tai poistaa pelaajia admin keisseistä.
- Palauttaa pelaajan alkuperäiselle paikalle kun hänet poistetaan keissistä.
- Jos pelaaja lähtee serveriltä niin hän lähtee automaattisesti pois admin keissistä.

## Käyttöopas
/adminkeissi (id)

Luo adminkeissin. Lisää sinut ja pelaajan (id) juuri luotuun adminkeissiin.

/adminkeissi_lisaa (id) (keissi_id)

Lisää pelaajan (id) admin keissiin (keissi_id).

/adminkeissi_poista (id)

Poistaa pelaajan (id) admin keissistä.

/epäadminkeissi (keissi_id)

Poistaa adminkeissin (keissi_id) ja palauttaa kaikki pelaajat, jotka liittyivät adminkeissiin (keissi_id) entisille paikoilleen.

/keissinumero

Kertoo sinulle keissinumeron johon sinut on liitetty

Kaikki pelaajat voivat käyttää vain komentoa /keissinumero. Muut komennot ovat vain admineille.

## Asennus
1. Laitat scriptin resources kansioon
2. Lisäät server.cfg start/ensure se_adminsit
3. Lisäät server.cfg (add_ace group.admin "se_adminsit" allow) jotta adminit voivat käyttää komentoja

## Muuta
Tämä scripti on testattu yksin. Eli jos tulee ongelmia niin voit kertoa minulle discordissa @siponen ja minä pyrin korjaamaan sen.

Tein kommentteja koodiin niin scriptin muokkaus pitäisi olla helppoa, jos tarvitset selvennystä jostain osasta koodia niin voin koittaa selittää sen mahdollisimman hyvin.

