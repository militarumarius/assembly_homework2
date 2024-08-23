### Nume: Militaru Ionut-Marius


### Descriere:

* In cadrul proiect am avut de implementat mai multe taskuri
dupa cum urmeaza descris in continuare

## Taskul 1
* am avut de verificat daca o furnica poate sa rezerve sau nu o camera,
in functie de valoarea bitului
* am verificat fiecare bit care e 1 in vectorul care imi spune ce camere
vrea furnica sa rezerve cu bitul corespunsator din bitul de permisiuni dat
in enunt
* la final afisez daca furnicare poate sau nu sa rezerve camerele


## Taskul 2

### subtask 1

* in cadrul acestui task am avut de sortat mai multe cereri
de request accesate pe o pagina web 
* a fost putin mai dificil de implementat pentru ca am cut de sortat
dupa mai multe criterii dupa cum urmeaza:
    - prima data sortez dupa bitul de admin, daca ambii sunt egali continui
    dupa urmatorul criteriu iar daca primul este mai mare decat primul fac swap
    - apoi verific dupa prioritate si efectuez acelasi algoritm doar ca sortez
    invers dupa prioritate deoarece asa era specificat in enunt
    - apoi daca si prioritatile erau egale verific dupa username si compar
    litera cu litera pana gasesc doua litere diferite
    - in fiecare caz fac swap la intreaga structura avand un vector
    de elemente de tipul request

### subtask 2

* in cadrul acestui task am avut de verificat daca requestul este dat de un hacker
sau nu , stiind detalii despre passkey-ul hackerului dupa cum umeaza
    - prima data verific daca primul si ultimul bit din passkey sunt 1,
    pentru a ma asigura ca este hacker
    - apoi verific daca cei mai semnificativi biti ramasi (cei 7 din bl),
    sunt in numar par de 1 si daca ceilalti biti(cei 7 din bh) sunt in numar
    impar de 1 , daca au loc aceste conditii atunci avem de aface cu 
    un hacker daca nu nu

## Task 3

* in cadrul acestui task am scris doi algoritmi descrisi in enuntul temei,
unul de decriptare si unul de criptare 
* cel de criptare a fost mai usor de implementat pentru ca folosesc o
singura bucla pentru a cripta , avand nevoie de mai putini registri
* cel de decriptare a fost putin mai complicat pentru ca am avut nevoie
de doi contori pentru cele doua bucle necesare algoritmului descris in enuntul temei

## Task 4

* in cadrul acestui task trebuia sa gasesc iesirea dintr-un labirint
* deoarece in enutul temei se precizeaza ca fiecare labirind are o
singura iesire si nu exista cazuri speciale de tratat verific cele 4 deplasari
posibile pana cand ajung la captul labirindului
* prima data verific daca se poate deplasa la stanga, apoi jos, apoi
la stanga si apoi in sus
* la fiecare mutare modific indexul curent din matrice si verific
daca am ajung pe ultima linie/coloana, atunci oprinduse programul
* la final scot de pe stiva adresle in care trebuia sa salvez capatul
labirintului si mut indixi in acestea
