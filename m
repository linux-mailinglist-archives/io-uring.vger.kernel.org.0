Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08FC637343
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 09:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiKXIBp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 03:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiKXIBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 03:01:42 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E44FC6611
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 00:01:40 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 697CA816FF;
        Thu, 24 Nov 2022 08:01:36 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669276900;
        bh=GLK5b6QqmdJIXrUcwe6xKwQBsQh+Nnqfkuk9rNRB2lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgYU3ZFW8i7BRF6YGe0PscihakF62Z1EFlD+yFIA0BA6v5IDUu3Ti5xxEH1uzj+01
         HTQEJTLIKwOV4mFCvjJiImS9/3DvjFLD75DQlBp2EKhkpanxSg8MwqNo++G42lPCY5
         CT8oTV8mo42ftVHLMUka87xcgpo7ZMV2//WrFY37rLgbw+REr8mGrkplRsa3JYzBxE
         vVOu0AZmt2BBNQzAYuaS3V9utZ6dWKX3RgowO0ddLuPA0D/S8poWFyiBGsgrb2mYGW
         sLCTBJ4r7FmOSQ3AKkLvo03Pr0r41D7jdSEZjKazuW8+zT10FQAnde90Nb3EgxNzJd
         lqXsVLUzV6L1Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
Subject: [PATCH liburing v1 4/7] tests: Mark internal functions as static
Date:   Thu, 24 Nov 2022 15:00:59 +0700
Message-Id: <20221124075846.3784701-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124075846.3784701-1-ammar.faizi@intel.com>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Functions that are not used outside the translation unit should be
static.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/accept-link.c         |  2 +-
 test/accept-reuse.c        |  9 ++++-----
 test/ce593a6c480a.c        |  4 ++--
 test/defer-taskrun.c       |  2 +-
 test/exit-no-cleanup.c     |  2 +-
 test/hardlink.c            |  2 +-
 test/io_uring_setup.c      |  3 ++-
 test/link_drain.c          |  2 +-
 test/multicqes_drain.c     | 27 ++++++++++++++++-----------
 test/nvme.h                |  3 ++-
 test/poll-link.c           |  2 +-
 test/poll-mshot-overflow.c |  2 +-
 test/read-before-exit.c    |  2 +-
 test/ring-leak2.c          |  2 +-
 test/sq-poll-kthread.c     |  2 +-
 test/sqpoll-cancel-hang.c  |  2 +-
 test/symlink.c             |  3 ++-
 test/timeout-new.c         | 12 ++++++++----
 18 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/test/accept-link.c b/test/accept-link.c
index d0dc73b..4d42f15 100644
--- a/test/accept-link.c
+++ b/test/accept-link.c
@@ -77,7 +77,7 @@ static void *send_thread(void *arg)
 	return NULL;
 }
 
-void *recv_thread(void *arg)
+static void *recv_thread(void *arg)
 {
 	struct data *data = arg;
 	struct io_uring ring;
diff --git a/test/accept-reuse.c b/test/accept-reuse.c
index 66eded2..7df5e56 100644
--- a/test/accept-reuse.c
+++ b/test/accept-reuse.c
@@ -13,15 +13,14 @@
 
 struct io_uring io_uring;
 
-int sys_io_uring_enter(const int fd,
-		       const unsigned to_submit,
-		       const unsigned min_complete,
-		       const unsigned flags, sigset_t * const sig)
+static int sys_io_uring_enter(const int fd, const unsigned to_submit,
+			      const unsigned min_complete,
+			      const unsigned flags, sigset_t * const sig)
 {
 	return __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
 }
 
-int submit_sqe(void)
+static int submit_sqe(void)
 {
 	struct io_uring_sq *sq = &io_uring.sq;
 	const unsigned tail = *sq->ktail;
diff --git a/test/ce593a6c480a.c b/test/ce593a6c480a.c
index 4c71fbc..9fa74a9 100644
--- a/test/ce593a6c480a.c
+++ b/test/ce593a6c480a.c
@@ -15,7 +15,7 @@
 
 static int use_sqpoll = 0;
 
-void notify_fd(int fd)
+static void notify_fd(int fd)
 {
 	char buf[8] = {0, 0, 0, 0, 0, 0, 1};
 	int ret;
@@ -25,7 +25,7 @@ void notify_fd(int fd)
 		perror("write");
 }
 
-void *delay_set_fd_from_thread(void *data)
+static void *delay_set_fd_from_thread(void *data)
 {
 	int fd = (intptr_t) data;
 
diff --git a/test/defer-taskrun.c b/test/defer-taskrun.c
index 9283f28..624285e 100644
--- a/test/defer-taskrun.c
+++ b/test/defer-taskrun.c
@@ -119,7 +119,7 @@ struct thread_data {
 	char buff[8];
 };
 
-void *thread(void *t)
+static void *thread(void *t)
 {
 	struct thread_data *td = t;
 
diff --git a/test/exit-no-cleanup.c b/test/exit-no-cleanup.c
index 4b8574d..aadef8c 100644
--- a/test/exit-no-cleanup.c
+++ b/test/exit-no-cleanup.c
@@ -26,7 +26,7 @@ static pthread_barrier_t init_barrier;
 static int sleep_fd, notify_fd;
 static sem_t sem;
 
-void *thread_func(void *arg)
+static void *thread_func(void *arg)
 {
 	struct io_uring ring;
 	int res;
diff --git a/test/hardlink.c b/test/hardlink.c
index aeb9ac6..2b5140e 100644
--- a/test/hardlink.c
+++ b/test/hardlink.c
@@ -44,7 +44,7 @@ err:
 	return 1;
 }
 
-int files_linked_ok(const char* fn1, const char *fn2)
+static int files_linked_ok(const char* fn1, const char *fn2)
 {
 	struct stat s1, s2;
 
diff --git a/test/io_uring_setup.c b/test/io_uring_setup.c
index 9e1a353..2e95418 100644
--- a/test/io_uring_setup.c
+++ b/test/io_uring_setup.c
@@ -21,7 +21,8 @@
 
 /* bogus: setup returns a valid fd on success... expect can't predict the
    fd we'll get, so this really only takes 1 parameter: error */
-int try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect)
+static int try_io_uring_setup(unsigned entries, struct io_uring_params *p,
+			      int expect)
 {
 	int ret;
 
diff --git a/test/link_drain.c b/test/link_drain.c
index b95168d..1a50c10 100644
--- a/test/link_drain.c
+++ b/test/link_drain.c
@@ -96,7 +96,7 @@ err:
 	return 1;
 }
 
-int test_link_drain_multi(struct io_uring *ring)
+static int test_link_drain_multi(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe[9];
diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
index f95c438..3755bee 100644
--- a/test/multicqes_drain.c
+++ b/test/multicqes_drain.c
@@ -42,12 +42,16 @@ struct sqe_info {
  * up an entry in multi_sqes when form a cancellation sqe.
  * multi_cap: limitation of number of multishot sqes
  */
-const unsigned sqe_flags[4] = {0, IOSQE_IO_LINK, IOSQE_IO_DRAIN,
-	IOSQE_IO_LINK | IOSQE_IO_DRAIN};
-int multi_sqes[max_entry], cnt = 0;
-int multi_cap = max_entry / 5;
+static const unsigned sqe_flags[4] = {
+	0,
+	IOSQE_IO_LINK,
+	IOSQE_IO_DRAIN,
+	IOSQE_IO_LINK | IOSQE_IO_DRAIN
+};
+static int multi_sqes[max_entry], cnt = 0;
+static int multi_cap = max_entry / 5;
 
-int write_pipe(int pipe, char *str)
+static int write_pipe(int pipe, char *str)
 {
 	int ret;
 	do {
@@ -57,7 +61,7 @@ int write_pipe(int pipe, char *str)
 	return ret;
 }
 
-void read_pipe(int pipe)
+static void read_pipe(int pipe)
 {
 	char str[4] = {0};
 	int ret;
@@ -67,7 +71,7 @@ void read_pipe(int pipe)
 		perror("read");
 }
 
-int trigger_event(int p[])
+static int trigger_event(int p[])
 {
 	int ret;
 	if ((ret = write_pipe(p[1], "foo")) != 3) {
@@ -78,7 +82,8 @@ int trigger_event(int p[])
 	return 0;
 }
 
-void io_uring_sqe_prep(int op, struct io_uring_sqe *sqe, unsigned sqe_flags, int arg)
+static void io_uring_sqe_prep(int op, struct io_uring_sqe *sqe,
+			      unsigned sqe_flags, int arg)
 {
 	switch (op) {
 		case multi:
@@ -98,7 +103,7 @@ void io_uring_sqe_prep(int op, struct io_uring_sqe *sqe, unsigned sqe_flags, int
 	sqe->flags = sqe_flags;
 }
 
-__u8 generate_flags(int sqe_op)
+static __u8 generate_flags(int sqe_op)
 {
 	__u8 flags = 0;
 	/*
@@ -136,7 +141,7 @@ __u8 generate_flags(int sqe_op)
  * - ensure number of multishot sqes doesn't exceed multi_cap
  * - don't generate multishot sqes after high watermark
  */
-int generate_opcode(int i, int pre_flags)
+static int generate_opcode(int i, int pre_flags)
 {
 	int sqe_op;
 	int high_watermark = max_entry - max_entry / 5;
@@ -163,7 +168,7 @@ static inline void add_multishot_sqe(int index)
 	multi_sqes[cnt++] = index;
 }
 
-int remove_multishot_sqe()
+static int remove_multishot_sqe(void)
 {
 	int ret;
 
diff --git a/test/nvme.h b/test/nvme.h
index 14dc338..52f4172 100644
--- a/test/nvme.h
+++ b/test/nvme.h
@@ -120,7 +120,8 @@ static inline int ilog2(uint32_t i)
 	return log;
 }
 
-int nvme_get_info(const char *file)
+__attribute__((__unused__))
+static int nvme_get_info(const char *file)
 {
 	struct nvme_id_ns ns;
 	int fd, err;
diff --git a/test/poll-link.c b/test/poll-link.c
index 39b48f5..b94f954 100644
--- a/test/poll-link.c
+++ b/test/poll-link.c
@@ -71,7 +71,7 @@ static void *send_thread(void *arg)
 	return 0;
 }
 
-void *recv_thread(void *arg)
+static void *recv_thread(void *arg)
 {
 	struct sockaddr_in addr = { };
 	struct data *data = arg;
diff --git a/test/poll-mshot-overflow.c b/test/poll-mshot-overflow.c
index 431a337..97d1cbe 100644
--- a/test/poll-mshot-overflow.c
+++ b/test/poll-mshot-overflow.c
@@ -12,7 +12,7 @@
 #include "liburing.h"
 #include "helpers.h"
 
-int check_final_cqe(struct io_uring *ring)
+static int check_final_cqe(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
 	int count = 0;
diff --git a/test/read-before-exit.c b/test/read-before-exit.c
index be36bd4..d57cdd2 100644
--- a/test/read-before-exit.c
+++ b/test/read-before-exit.c
@@ -22,7 +22,7 @@ struct data {
         uint64_t buf2;
 };
 
-void *submit(void *data)
+static void *submit(void *data)
 {
 	struct io_uring_sqe *sqe;
 	struct data *d = data;
diff --git a/test/ring-leak2.c b/test/ring-leak2.c
index a8c03fe..6e76717 100644
--- a/test/ring-leak2.c
+++ b/test/ring-leak2.c
@@ -46,7 +46,7 @@ static struct io_uring *client_ring;
 
 static int client_eventfd = -1;
 
-int setup_io_uring(struct io_uring *ring)
+static int setup_io_uring(struct io_uring *ring)
 {
 	struct io_uring_params p = { };
 	int ret;
diff --git a/test/sq-poll-kthread.c b/test/sq-poll-kthread.c
index 3f4a07b..bf5122a 100644
--- a/test/sq-poll-kthread.c
+++ b/test/sq-poll-kthread.c
@@ -117,7 +117,7 @@ err_pipe:
 	return ret;
 }
 
-int test_sq_poll_kthread_stopped(bool do_exit)
+static int test_sq_poll_kthread_stopped(bool do_exit)
 {
 	pid_t pid;
 	int status = 0;
diff --git a/test/sqpoll-cancel-hang.c b/test/sqpoll-cancel-hang.c
index ef62272..cd1c309 100644
--- a/test/sqpoll-cancel-hang.c
+++ b/test/sqpoll-cancel-hang.c
@@ -92,7 +92,7 @@ SIZEOF_IO_URING_CQE + 63) & ~63;
 }
 
 
-void trigger_bug(void)
+static void trigger_bug(void)
 {
     intptr_t res = 0;
     *(uint32_t*)0x20000204 = 0;
diff --git a/test/symlink.c b/test/symlink.c
index cf4aa96..7edb514 100644
--- a/test/symlink.c
+++ b/test/symlink.c
@@ -43,7 +43,8 @@ err:
 	return 1;
 }
 
-int test_link_contents(const char* linkname, const char *expected_contents)
+static int test_link_contents(const char* linkname,
+			      const char *expected_contents)
 {
 	char buf[128];
 	int ret = readlink(linkname, buf, 127);
diff --git a/test/timeout-new.c b/test/timeout-new.c
index 6efcfb4..8640678 100644
--- a/test/timeout-new.c
+++ b/test/timeout-new.c
@@ -111,7 +111,8 @@ static int test_return_after_timeout(struct io_uring *ring)
 	return 0;
 }
 
-int __reap_thread_fn(void *data) {
+static int __reap_thread_fn(void *data)
+{
 	struct io_uring *ring = (struct io_uring *)data;
 	struct io_uring_cqe *cqe;
 	struct __kernel_timespec ts;
@@ -123,12 +124,14 @@ int __reap_thread_fn(void *data) {
 	return io_uring_wait_cqe_timeout(ring, &cqe, &ts);
 }
 
-void *reap_thread_fn0(void *data) {
+static void *reap_thread_fn0(void *data)
+{
 	thread_ret0 = __reap_thread_fn(data);
 	return NULL;
 }
 
-void *reap_thread_fn1(void *data) {
+static void *reap_thread_fn1(void *data)
+{
 	thread_ret1 = __reap_thread_fn(data);
 	return NULL;
 }
@@ -137,7 +140,8 @@ void *reap_thread_fn1(void *data) {
  * This is to test issuing a sqe in main thread and reaping it in two child-thread
  * at the same time. To see if timeout feature works or not.
  */
-int test_multi_threads_timeout() {
+static int test_multi_threads_timeout(void)
+{
 	struct io_uring ring;
 	int ret;
 	bool both_wait = false;
-- 
Ammar Faizi

