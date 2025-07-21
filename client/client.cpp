#include <iostream>
#include <curl/curl.h>
#include <curl/easy.h>

#define C2URL "http://10.0.0.109:8080/beacon"

int main() {
    const long curltimeout = 5;
    const char* curlagent = "beacon";

    CURL *curl = curl_easy_init();
    if (!curl) {
        std::cerr << "CE1V1; curl error => failed to init" << std::endl;
        return 1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, C2URL);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, curltimeout);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, curlagent); // TODO: error handling for this when im not as lazy :(

    if (curl_easy_perform(curl) != CURLE_OK) {
        std::cerr << "CE1V2; curl error => perform failed" << std::endl;
        curl_easy_cleanup(curl);
        return 1;
    }

    curl_easy_cleanup(curl);
    return 0;
}
