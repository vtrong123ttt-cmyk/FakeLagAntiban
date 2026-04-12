#import <substrate.h>
#import <mach-o/dyld.h>
#import <unistd.h>

// --- LỚP GIÁP ANTI-BAN ---
// Dùng static để bảo mật hơn
static bool (*old_is_file_exist)(void *path);
static bool new_is_file_exist(void *path) {
    // Trả về false để game không tìm thấy bất kỳ file hack nào
    return false; 
}

// --- LỆNH FAKE LAG (NGƯNG ĐỊCH) ---
static void (*old_SendPacket)(void *packet);
static void new_SendPacket(void *packet) {
    // Chỉ lag nhẹ để né đạn, đừng để lâu quá bị văng kết nối
    usleep(100000); // 0.1s
    old_SendPacket(packet);
}

// --- HÀM TÌM ĐỊA CHỈ THỰC TẾ (ASLR) ---
uintptr_t get_address(uintptr_t offset) {
    return _dyld_get_image_vmaddr_slide(0) + offset;
}

// --- KHỞI CHẠY ---
void setup() {
    // Đợi game ổn định 10 giây rồi mới hack để tránh bị phát hiện sớm
    sleep(10); 

    // CHÚ Ý: Thay 0x1234567 bằng Offset mày soi được từ IDA/Hopper
    // Hook Anti-ban
    MSHookFunction((void *)get_address(0x1234567), (void *)new_is_file_exist, (void **)&old_is_file_exist);

    // Hook Fake Lag
    MSHookFunction((void *)get_address(0x89ABCDE), (void *)new_SendPacket, (void **)&old_SendPacket);
}

// Hàm này tự chạy khi dylib được nạp vào game
static __attribute__((constructor)) void init() {
    // Chạy ngầm để không làm treo màn hình loading của game
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        setup();
    });
}
