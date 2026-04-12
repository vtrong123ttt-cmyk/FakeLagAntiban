#include <substrate.h>
#include <mach-o/dyld.h>
#include <unistd.h>
#include <iostream>

// --- LỚP GIÁP ANTI-BAN ---
// Chặn game quét các file lạ trong thư mục
bool (*old_is_file_exist)(void *path);
bool new_is_file_exist(void *path) {
    // Nếu game quét tìm file .dylib của mình, trả về "Không có"
    return false; 
}

// --- LỆNH NGƯNG ĐỊCH (FAKE LAG) ---
void (*old_SendPacket)(void *packet);
void new_SendPacket(void *packet) {
    // Giả sử mày muốn lag khi nhấn một nút ảo hoặc điều kiện nào đó
    // Ở đây tao để mặc định trễ nhẹ để địch khựng mà ko bị 999+
    usleep(150000); // Trễ 0.15s mỗi gói tin (Ping ~150-200ms)
    old_SendPacket(packet);
}

// --- KHỞI CHẠY ---
void setup() {
    // Đợi game load xong mới bơm code để tránh văng (Crash)
    sleep(5); 

    // 1. Kích hoạt Anti-ban: Chặn quét file
    // Lưu ý: Offset này phải cập nhật theo bản game mới nhất
    MSHookFunction((void *)0x102xxxxxx, (void *)new_is_file_exist, (void **)&old_is_file_exist);

    // 2. Kích hoạt Ngưng địch (Fake Lag)
    MSHookFunction((void *)0x103xxxxxx, (void *)new_SendPacket, (void **)&old_SendPacket);
}

static __attribute__((constructor)) void test() {
    setup();
}
