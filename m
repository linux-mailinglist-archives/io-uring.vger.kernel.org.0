Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22FF650F53
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiLSPxj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiLSPxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E85830E
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:45 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 244D981907;
        Mon, 19 Dec 2022 15:50:42 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465045;
        bh=T11BVbjIGkgUQLrgzwfeR0xAUc/KGNhY9elGZuv7VKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOTeoEyu42pizvEiucuq5rUId8vV+Ybo3pxdzjJBvn2heKwu/q96650LGbuy3fN7i
         ZV+rLU2xFKKOyMWvb7RvrScB2DO8r1g6l9m61OWevBMmHjjUocIC89c5o/MxHU4Lu1
         WRy5Dzx6wfi6BJWekG5uu5XpY7OXqwX3A4R6nX721cwWVHa05MRx0qk3NSkBazEH9t
         yqLF0h/+DqgWJMjegHRLc3N1IgB3cer/Ue9gG17rcySRSZHWp/6G3OBMh81BnUtTv/
         oaEqDjttcoqiyEyw/HozQyqk61bXCRb0/iDhWK1Tt0+kvIxPLI9w4MBgkxzv9e8kID
         sKYrI3agfZ4zg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 6/8] tests: Declare internal variables as static
Date:   Mon, 19 Dec 2022 22:49:58 +0700
Message-Id: <20221219155000.2412524-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a preparation patch to add `-Wmissing-variable-declarations`
to the GitHub bot CI. It ensures variables that are not used outside
the translation unit be declared as static.

The error message looks like this:

  35fa71a030ca.c:265:1: note: declare 'static' if the variable is not intended \
                              to be used outside of this translation unit
  uint64_t r[1] = {0xffffffffffffffff};
  ^
  1 error generated.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/232c93d07b74.c            | 6 +++---
 test/35fa71a030ca.c            | 2 +-
 test/a0908ae19763.c            | 2 +-
 test/accept-link.c             | 4 ++--
 test/accept-reuse.c            | 2 +-
 test/double-poll-crash.c       | 2 +-
 test/fc2a85cb02ef.c            | 2 +-
 test/files-exit-hang-timeout.c | 4 ++--
 test/nvme.h                    | 4 ++--
 test/poll-link.c               | 4 ++--
 test/pollfree.c                | 2 +-
 test/sqpoll-cancel-hang.c      | 2 +-
 test/test.h                    | 3 ++-
 test/timeout-new.c             | 6 +++---
 14 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/test/232c93d07b74.c b/test/232c93d07b74.c
index 74cc063..4c65b39 100644
--- a/test/232c93d07b74.c
+++ b/test/232c93d07b74.c
@@ -26,23 +26,23 @@
 
 #define RECV_BUFF_SIZE 2
 #define SEND_BUFF_SIZE 3
 
 struct params {
 	int tcp;
 	int non_blocking;
 	__be16 bind_port;
 };
 
-pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
-pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
-int rcv_ready = 0;
+static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
+static int rcv_ready = 0;
 
 static void set_rcv_ready(void)
 {
 	pthread_mutex_lock(&mutex);
 
 	rcv_ready = 1;
 	pthread_cond_signal(&cond);
 
 	pthread_mutex_unlock(&mutex);
 }
diff --git a/test/35fa71a030ca.c b/test/35fa71a030ca.c
index 5540d8d..3e2eddb 100644
--- a/test/35fa71a030ca.c
+++ b/test/35fa71a030ca.c
@@ -255,21 +255,21 @@ static void loop(void)
         break;
       sleep_ms(1);
       if (current_time_ms() - start < 5 * 1000)
         continue;
       kill_and_wait(pid, &status);
       break;
     }
   }
 }
 
-uint64_t r[1] = {0xffffffffffffffff};
+static uint64_t r[1] = {0xffffffffffffffff};
 
 void execute_call(int call)
 {
   long res;
   switch (call) {
   case 0:
     *(uint32_t*)0x20000040 = 0;
     *(uint32_t*)0x20000044 = 0;
     *(uint32_t*)0x20000048 = 0;
     *(uint32_t*)0x2000004c = 0;
diff --git a/test/a0908ae19763.c b/test/a0908ae19763.c
index 8f6aaad..d0c2855 100644
--- a/test/a0908ae19763.c
+++ b/test/a0908ae19763.c
@@ -7,21 +7,21 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <unistd.h>
 
 #include "liburing.h"
 #include "helpers.h"
 #include "../src/syscall.h"
 
-uint64_t r[1] = {0xffffffffffffffff};
+static uint64_t r[1] = {0xffffffffffffffff};
 
 int main(int argc, char *argv[])
 {
   if (argc > 1)
     return T_EXIT_SKIP;
   mmap((void *) 0x20000000, 0x1000000, 3, 0x32, -1, 0);
   intptr_t res = 0;
   *(uint32_t*)0x20000080 = 0;
   *(uint32_t*)0x20000084 = 0;
   *(uint32_t*)0x20000088 = 0;
diff --git a/test/accept-link.c b/test/accept-link.c
index 4d42f15..32f73f4 100644
--- a/test/accept-link.c
+++ b/test/accept-link.c
@@ -9,22 +9,22 @@
 #include <pthread.h>
 #include <sys/socket.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
 #include <poll.h>
 #include <arpa/inet.h>
 
 #include "liburing.h"
 #include "helpers.h"
 
-pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
-pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
+static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 
 static int recv_thread_ready = 0;
 static int recv_thread_done = 0;
 
 static void signal_var(int *var)
 {
         pthread_mutex_lock(&mutex);
         *var = 1;
         pthread_cond_signal(&cond);
         pthread_mutex_unlock(&mutex);
diff --git a/test/accept-reuse.c b/test/accept-reuse.c
index 7df5e56..0808866 100644
--- a/test/accept-reuse.c
+++ b/test/accept-reuse.c
@@ -4,21 +4,21 @@
 #include <string.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <errno.h>
 #include "liburing.h"
 #include "helpers.h"
 #include "../src/syscall.h"
 
-struct io_uring io_uring;
+static struct io_uring io_uring;
 
 static int sys_io_uring_enter(const int fd, const unsigned to_submit,
 			      const unsigned min_complete,
 			      const unsigned flags, sigset_t * const sig)
 {
 	return __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
 }
 
 static int submit_sqe(void)
 {
diff --git a/test/double-poll-crash.c b/test/double-poll-crash.c
index a0cc985..54f88f4 100644
--- a/test/double-poll-crash.c
+++ b/test/double-poll-crash.c
@@ -102,21 +102,21 @@ static long syz_open_dev(volatile long a0, volatile long a1, volatile long a2)
     strncpy(buf, (char*)a0, sizeof(buf) - 1);
     buf[sizeof(buf) - 1] = 0;
     while ((hash = strchr(buf, '#'))) {
       *hash = '0' + (char)(a1 % 10);
       a1 /= 10;
     }
     return open(buf, a2, 0);
   }
 }
 
-uint64_t r[4] = {0xffffffffffffffff, 0x0, 0x0, 0xffffffffffffffff};
+static uint64_t r[4] = {0xffffffffffffffff, 0x0, 0x0, 0xffffffffffffffff};
 
 int main(int argc, char *argv[])
 {
   void *mmap_ret;
 #if !defined(__i386) && !defined(__x86_64__)
   return T_EXIT_SKIP;
 #endif
 
   if (argc > 1)
     return T_EXIT_SKIP;
diff --git a/test/fc2a85cb02ef.c b/test/fc2a85cb02ef.c
index c828f67..cd1af39 100644
--- a/test/fc2a85cb02ef.c
+++ b/test/fc2a85cb02ef.c
@@ -72,21 +72,21 @@ static int setup_fault(void)
   unsigned i;
   for (i = 0; i < sizeof(files) / sizeof(files[0]); i++) {
     if (!write_file(files[i].file, files[i].val)) {
       if (files[i].fatal)
 	return 1;
     }
   }
   return 0;
 }
 
-uint64_t r[2] = {0xffffffffffffffff, 0xffffffffffffffff};
+static uint64_t r[2] = {0xffffffffffffffff, 0xffffffffffffffff};
 
 int main(int argc, char *argv[])
 {
   if (argc > 1)
     return T_EXIT_SKIP;
   mmap((void *) 0x20000000ul, 0x1000000ul, 3ul, 0x32ul, -1, 0);
   if (setup_fault()) {
     printf("Test needs failslab/fail_futex/fail_page_alloc enabled, skipped\n");
     return T_EXIT_SKIP;
   }
diff --git a/test/files-exit-hang-timeout.c b/test/files-exit-hang-timeout.c
index 45f01ea..6f77b7c 100644
--- a/test/files-exit-hang-timeout.c
+++ b/test/files-exit-hang-timeout.c
@@ -14,23 +14,23 @@
 #include <sys/socket.h>
 #include <unistd.h>
 #include <poll.h>
 #include "liburing.h"
 #include "helpers.h"
 
 #define BACKLOG 512
 
 #define PORT 9100
 
-struct io_uring ring;
+static struct io_uring ring;
 
-struct __kernel_timespec ts = {
+static struct __kernel_timespec ts = {
 	.tv_sec		= 300,
 	.tv_nsec	= 0,
 };
 
 static void add_timeout(struct io_uring *ring, int fd)
 {
 	struct io_uring_sqe *sqe;
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_timeout(sqe, &ts, 100, 0);
diff --git a/test/nvme.h b/test/nvme.h
index 52f4172..1254b92 100644
--- a/test/nvme.h
+++ b/test/nvme.h
@@ -50,22 +50,22 @@ struct nvme_uring_cmd {
 
 enum nvme_admin_opcode {
 	nvme_admin_identify		= 0x06,
 };
 
 enum nvme_io_opcode {
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
 };
 
-int nsid;
-__u32 lba_shift;
+static int nsid;
+static __u32 lba_shift;
 
 struct nvme_lbaf {
 	__le16			ms;
 	__u8			ds;
 	__u8			rp;
 };
 
 struct nvme_id_ns {
 	__le64			nsze;
 	__le64			ncap;
diff --git a/test/poll-link.c b/test/poll-link.c
index b94f954..c0b1cf5 100644
--- a/test/poll-link.c
+++ b/test/poll-link.c
@@ -9,22 +9,22 @@
 #include <pthread.h>
 #include <sys/socket.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
 #include <poll.h>
 #include <arpa/inet.h>
 
 #include "helpers.h"
 #include "liburing.h"
 
-pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
-pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
+static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 
 static int recv_thread_ready = 0;
 static int recv_thread_done = 0;
 
 static void signal_var(int *var)
 {
         pthread_mutex_lock(&mutex);
         *var = 1;
         pthread_cond_signal(&cond);
         pthread_mutex_unlock(&mutex);
diff --git a/test/pollfree.c b/test/pollfree.c
index ebd88b1..010db65 100644
--- a/test/pollfree.c
+++ b/test/pollfree.c
@@ -335,21 +335,21 @@ static void loop(void)
       kill_and_wait(pid, &status);
       break;
     }
   }
 }
 
 #ifndef __NR_io_uring_enter
 #define __NR_io_uring_enter 426
 #endif
 
-uint64_t r[4] = {0xffffffffffffffff, 0xffffffffffffffff, 0x0, 0x0};
+static uint64_t r[4] = {0xffffffffffffffff, 0xffffffffffffffff, 0x0, 0x0};
 
 void execute_call(int call)
 {
   intptr_t res = 0;
   switch (call) {
   case 0:
     *(uint64_t*)0x200000c0 = 0;
     res = syscall(__NR_signalfd4, -1, 0x200000c0ul, 8ul, 0ul);
     if (res != -1)
       r[0] = res;
diff --git a/test/sqpoll-cancel-hang.c b/test/sqpoll-cancel-hang.c
index cd1c309..7faefa2 100644
--- a/test/sqpoll-cancel-hang.c
+++ b/test/sqpoll-cancel-hang.c
@@ -32,21 +32,21 @@ static uint64_t current_time_ms(void)
 static void kill_and_wait(int pid, int* status)
 {
     kill(-pid, SIGKILL);
     kill(pid, SIGKILL);
     while (waitpid(-1, status, __WALL) != pid) {
     }
 }
 
 #define WAIT_FLAGS __WALL
 
-uint64_t r[3] = {0xffffffffffffffff, 0x0, 0x0};
+static uint64_t r[3] = {0xffffffffffffffff, 0x0, 0x0};
 
 static long syz_io_uring_setup(volatile long a0, volatile long a1,
 volatile long a2, volatile long a3, volatile long a4, volatile long
 a5)
 {
     uint32_t entries = (uint32_t)a0;
     struct io_uring_params* setup_params = (struct io_uring_params*)a1;
     void* vma1 = (void*)a2;
     void* vma2 = (void*)a3;
     void** ring_ptr_out = (void**)a4;
diff --git a/test/test.h b/test/test.h
index 3628163..e99a8d2 100644
--- a/test/test.h
+++ b/test/test.h
@@ -7,21 +7,22 @@
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 typedef struct io_uring_test_config {
 	unsigned int flags;
 	const char *description;
 } io_uring_test_config;
 
-io_uring_test_config io_uring_test_configs[] = {
+__attribute__((__unused__))
+static io_uring_test_config io_uring_test_configs[] = {
 	{ 0, 						"default" },
 	{ IORING_SETUP_SQE128, 				"large SQE"},
 	{ IORING_SETUP_CQE32, 				"large CQE"},
 	{ IORING_SETUP_SQE128 | IORING_SETUP_CQE32, 	"large SQE/CQE" },
 };
 
 #define FOR_ALL_TEST_CONFIGS							\
 	for (int i = 0; i < sizeof(io_uring_test_configs) / sizeof(io_uring_test_configs[0]); i++)
 
 #define IORING_GET_TEST_CONFIG_FLAGS() (io_uring_test_configs[i].flags)
diff --git a/test/timeout-new.c b/test/timeout-new.c
index 8640678..35cb7bb 100644
--- a/test/timeout-new.c
+++ b/test/timeout-new.c
@@ -5,23 +5,23 @@
  */
 #include <stdio.h>
 #include <sys/time.h>
 #include <unistd.h>
 #include <pthread.h>
 #include "liburing.h"
 
 #define TIMEOUT_MSEC	200
 #define TIMEOUT_SEC	10
 
-int thread_ret0, thread_ret1;
-int cnt = 0;
-pthread_mutex_t mutex;
+static int thread_ret0, thread_ret1;
+static int cnt = 0;
+static pthread_mutex_t mutex;
 
 static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
 {
 	ts->tv_sec = msec / 1000;
 	ts->tv_nsec = (msec % 1000) * 1000000;
 }
 
 static unsigned long long mtime_since(const struct timeval *s,
 				      const struct timeval *e)
 {
-- 
Ammar Faizi

