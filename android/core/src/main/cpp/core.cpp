#include <jni.h>
#include <malloc.h>

#ifndef M_PURGE
#define M_PURGE (-101)
#endif
#ifndef M_PURGE_ALL
#define M_PURGE_ALL (-104)
#endif

// bionic only exposes mallopt() (and the M_PURGE* options) from API 26 on.
// This app still supports API levels below 26, so declare it weak: the
// runtime resolves the symbol normally on API 26+ and leaves it null on older
// releases.
#if defined(__ANDROID_API__) && __ANDROID_API__ < 26
extern "C" int mallopt(int option, int value) __attribute__((weak));
#endif

extern "C"
JNIEXPORT void JNICALL
Java_com_appshub_bettbox_core_Core_purgeMemory(JNIEnv *, jobject, jboolean all) {
#if defined(__ANDROID_API__) && __ANDROID_API__ < 26
    if (mallopt == nullptr) {
        return;
    }
#endif
    if (all && mallopt(M_PURGE_ALL, 0) == 1) {
        return;
    }
    mallopt(M_PURGE, 0);
}

#ifdef LIBCLASH
#include <cstring>
#include "jni_helper.h"
#include "libmeta.h"

extern "C"
JNIEXPORT jboolean JNICALL
Java_com_appshub_bettbox_core_Core_startTun(JNIEnv *env, jobject, const jint fd, jobject cb) {
    const auto interface = new_global(cb);
    return startTUN(fd, interface) ? JNI_TRUE : JNI_FALSE;
}

extern "C"
JNIEXPORT void JNICALL
Java_com_appshub_bettbox_core_Core_stopTun(JNIEnv *) {
    stopTun();
}

extern "C"
JNIEXPORT void JNICALL
Java_com_appshub_bettbox_core_Core_suspend(JNIEnv *, jobject, jint suspended) {
    suspend(suspended);
}

extern "C"
JNIEXPORT void JNICALL
Java_com_appshub_bettbox_core_Core_setScreenState(JNIEnv *, jobject, jint on) {
    setScreenState(on);
}

extern "C"
JNIEXPORT void JNICALL
Java_com_appshub_bettbox_core_Core_networkChanged(JNIEnv *, jobject) {
    networkChanged();
}

extern "C"
JNIEXPORT jstring JNICALL
Java_com_appshub_bettbox_core_Core_getTraffic(JNIEnv *env, jobject) {
    char *traffic = getTraffic();
    const auto result = new_string(traffic != nullptr ? traffic : "");
    freeCString(traffic);
    return result;
}


static jmethodID m_tun_interface_protect;
static jmethodID m_tun_interface_resolve_process;


static void release_jni_object_impl(void *obj) {
    ATTACH_JNI();
    del_global(static_cast<jobject>(obj));
}

static void call_tun_interface_protect_impl(void *tun_interface, const int fd) {
    if (tun_interface == nullptr) return;
    ATTACH_JNI();
    env->CallVoidMethod(static_cast<jobject>(tun_interface),
                        m_tun_interface_protect,
                        fd);
    jni_catch_exception(env);
}

static const char *
call_tun_interface_resolve_process_impl(void *tun_interface, int protocol,
                                        const char *source,
                                        const char *target,
                                        const int uid) {
    if (tun_interface == nullptr) return strdup("");
    ATTACH_JNI();
    if (env->PushLocalFrame(8) < 0) {
        return strdup("");
    }
    const auto src_str = new_string(source != nullptr ? source : "");
    const auto dst_str = new_string(target != nullptr ? target : "");
    const auto packageName = reinterpret_cast<jstring>(env->CallObjectMethod(static_cast<jobject>(tun_interface),
                                                                       m_tun_interface_resolve_process,
                                                                       protocol,
                                                                       src_str,
                                                                       dst_str,
                                                                       uid));
    jni_catch_exception(env);
    const auto result = get_string(packageName);
    env->PopLocalFrame(nullptr);
    return result;
}

extern "C"
JNIEXPORT jint JNICALL
JNI_OnLoad(JavaVM *vm, void *) {
    JNIEnv *env = nullptr;
    if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) != JNI_OK) {
        return JNI_ERR;
    }

    initialize_jni(vm, env);

    const auto c_tun_interface = find_class("com/appshub/bettbox/core/TunInterface");

    m_tun_interface_protect = find_method(c_tun_interface, "protect", "(I)V");
    m_tun_interface_resolve_process = find_method(c_tun_interface, "resolverProcess",
                                                  "(ILjava/lang/String;Ljava/lang/String;I)Ljava/lang/String;");

    registerCallbacks(&call_tun_interface_protect_impl,
                      &call_tun_interface_resolve_process_impl,
                      &release_jni_object_impl);
    return JNI_VERSION_1_6;
}
#endif
