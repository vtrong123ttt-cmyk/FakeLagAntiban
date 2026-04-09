#include <substrate.h>
#include <unistd.h>
#include <sys/sysctl.h>

// --- FAKE LAG ---
ssize_t (*old_send)(int sockfd, const void *buf, size_t len, int flags);
ssize_t new_send(int sockfd, const void *buf, size_t len, int flags) {
    usleep(550000); 
    return old_send(sockfd, buf, len, flags);
}

// --- ANTIBAN ---
int (*old_access)(const char *path, int mode);
int new_access(const char *path, int mode) {
    if (strstr(path, "Library/MobileSubstrate") || strstr(path, "Cydia")) return -1;
    return old_access(path, mode);
}

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)access, (void *)new_access, (void **)&old_access);
    MSHookFunction((void *)send, (void *)new_send, (void **)&old_send);
}
 
