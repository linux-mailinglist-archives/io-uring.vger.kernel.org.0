Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636A92C770D
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgK2AvA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbgK2Auw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:52 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26811C061A51;
        Sat, 28 Nov 2020 16:50:15 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f17so7378838pge.6;
        Sat, 28 Nov 2020 16:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2KyH+/wGk4HQknxk65zFNHEp0tJSfqe/uAsgStVyfvY=;
        b=lFZsSL9pub3G/0NFoig6owjA9CG3G0QoaAUOmZilOwGkW7mXGdlz16jBJmjN5+mxq/
         ltA5TVdZsmx4HU4O6pN2vOOfMMh4dzQMKevAXW1dlsd0FxX5NbTjebtxWi5OUyAF2L/F
         HbQJkKgEri3n+DOLM0A7YxWX3cnJ20A3L5B/KPFkqeECNE2bvufUG9Q/NCGqh9uZuM4y
         L0rkFbfSqC1tLMh2/lAIrlDhKDMj2bJgL0nLUq/wwxHtPQVpMXbPoCffDKwW4yG9WEhd
         rlI7h9ddVZzFl7oGKEcz/ImTa4ltaQ8ki4+kah8Mr7DC2WBZg6Q0Du0cjhAqSaNlZelQ
         8ryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2KyH+/wGk4HQknxk65zFNHEp0tJSfqe/uAsgStVyfvY=;
        b=sZcThopWWMGMK4hbQi+AeblJb3SuS+Tq5ZCN6cyfuIm2EG1o4OP3xiybFSlb1kRHxD
         gf4fZZe1zYs9E/IoEh/7zJNGjX3OQQjuWyNmHU+w5iCW7XXb2dSYwwu989YjCNYhmz8m
         GRZuhhY1OZQS4w8gj01D7gcjJqxtM9dznXFdNooQ+xJ2U1MZ/ZSJ0l5fn3H3YJQq/4Lc
         kim9iVJ/iLLorLhX0kNikzzpPIuTb39aXDMKF+bCMkAckt/rOCNJBih4zEvRPt/he8My
         v9T/Nk9oJ5EwNeg/LCoLSOFoOOysawoBVTHxd7OGShHboU+HRG6r4cOXjKva0wzL9/PF
         s2CQ==
X-Gm-Message-State: AOAM5328VQkRMhxchIwumdWNfQLKMkaK7cBSfLqHrgz8jxFHRXNiMfNQ
        uTB2HC3hiwMbPSrSzE6wB7y4WRRJDjpG0A==
X-Google-Smtp-Source: ABdhPJwOAeJgbGc08xYYTiwmSiwcukwTDaW/evYd2VRd96RZz/FV/k9HNTqid39JCZaw50DmM1cD/g==
X-Received: by 2002:aa7:8641:0:b029:198:44d5:14f2 with SMTP id a1-20020aa786410000b029019844d514f2mr12850399pfo.29.1606611013985;
        Sat, 28 Nov 2020 16:50:13 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:13 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 13/13] selftests/vm/userfaultfd: iouring and polling tests
Date:   Sat, 28 Nov 2020 16:45:48 -0800
Message-Id: <20201129004548.1619714-14-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Add tests to check the use of userfaultfd with iouring, "write"
interface of userfaultfd and with the "poll" feature of userfaultfd.

Enabling the tests is done through new test "modifiers": "poll", "write"
"iouring" that are added to the test name after colon. The "shmem" test
does not work with "iouring" test. The signal test does not appear to be
suitable for iouring as it might leave the ring in dubious state.

Introduce a uffd_base_ops struct that holds functions for
read/copy/zero/etc operations using ioctls or alternatively writes or
iouring. Adapting the tests for iouring is slightly complicated, as
operations on iouring must be synchronized. Access to the iouring is
therefore protected by a mutex. Reads are performed to several
preallocated buffers and are protected by another mutex. Whenever the
iouring completion queue is polled, the caller must take care of any
read or write that were initiated, even if it waits for another event.

Each thread holds a local request ID which it uses to issue its own
non-read requests, under the assumption that only one request will be on
the fly at any given moment and that the issuing thread will wait for
its completion.

This change creates a dependency of the userfaultfd tests on iouring.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 tools/testing/selftests/vm/Makefile      |   2 +-
 tools/testing/selftests/vm/userfaultfd.c | 824 +++++++++++++++++++++--
 2 files changed, 757 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 30873b19d04b..4f88123530c5 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -127,6 +127,6 @@ warn_32bit_failure:
 endif
 endif
 
-$(OUTPUT)/userfaultfd: LDLIBS += -lpthread
+$(OUTPUT)/userfaultfd: LDLIBS += -lpthread -luring
 
 $(OUTPUT)/mlock-random-test: LDLIBS += -lcap
diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index f7e6cf43db71..9077167b3e77 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -55,6 +55,7 @@
 #include <setjmp.h>
 #include <stdbool.h>
 #include <assert.h>
+#include <liburing.h>
 
 #include "../kselftest.h"
 
@@ -73,6 +74,13 @@ static int bounces;
 #define TEST_SHMEM	3
 static int test_type;
 
+#define MOD_IOURING	(0)
+#define MOD_WRITE	(1)
+#define MOD_POLL	(2)
+#define N_MODIFIERS	(MOD_POLL+1)
+static bool test_mods[N_MODIFIERS];
+const char *mod_strs[N_MODIFIERS] = {"iouring", "write", "poll"};
+
 /* exercise the test_uffdio_*_eexist every ALARM_INTERVAL_SECS */
 #define ALARM_INTERVAL_SECS 10
 static volatile bool test_uffdio_copy_eexist = true;
@@ -111,6 +119,12 @@ struct uffd_stats {
 				 ~(unsigned long)(sizeof(unsigned long long) \
 						  -  1)))
 
+/*
+ * async indication that no result was provided. Must be different than any
+ * existing error code.
+ */
+#define RES_NOT_DONE		(-5555)
+
 const char *examples =
     "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
     "./userfaultfd anon 100 99999\n\n"
@@ -122,7 +136,10 @@ const char *examples =
     "./userfaultfd hugetlb_shared 256 50 /dev/hugepages/hugefile\n\n"
     "# 10MiB-~6GiB 999 bounces anonymous test, "
     "continue forever unless an error triggers\n"
-    "while ./userfaultfd anon $[RANDOM % 6000 + 10] 999; do true; done\n\n";
+    "while ./userfaultfd anon $[RANDOM % 6000 + 10] 999; do true; done\n"
+    "# Run anonymous memory test on 100MiB region with 99 bounces, "
+    "polling on faults with iouring interface\n"
+    "./userfaultfd anon:iouring:poll 100 99\n\n";
 
 static void usage(void)
 {
@@ -288,6 +305,13 @@ struct uffd_test_ops {
 	void (*alias_mapping)(__u64 *start, size_t len, unsigned long offset);
 };
 
+struct uffd_base_ops {
+	bool (*poll_msg)(int ufd, unsigned long cpu);
+	int (*read_msg)(int ufd, struct uffd_msg *msg);
+	int (*copy)(int ufd, struct uffdio_copy *uffdio_copy);
+	int (*zero)(int ufd, struct uffdio_zeropage *zeropage);
+};
+
 #define SHMEM_EXPECTED_IOCTLS		((1 << _UFFDIO_WAKE) | \
 					 (1 << _UFFDIO_COPY) | \
 					 (1 << _UFFDIO_ZEROPAGE))
@@ -465,13 +489,417 @@ static void *locking_thread(void *arg)
 	return NULL;
 }
 
+__thread int local_req_id;
+
+#define READ_QUEUE_DEPTH	(16)
+
+struct uffd_msg *iouring_read_msgs;
+
+static struct io_uring ring;
+
+/* ring_mutex - protects the iouring */
+pthread_mutex_t ring_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+/* async_mutex - protects iouring_read_msgs */
+pthread_mutex_t async_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+static volatile ssize_t *ring_results;
+
+enum {
+	BUF_IDX_MSG,
+	BUF_IDX_ZERO,
+	BUF_IDX_SRC,
+	BUF_IDX_ALIAS,
+};
+
+static void init_iouring_buffers(void)
+{
+	struct iovec iov[4] = { 0 };
+	int r;
+
+	io_uring_unregister_buffers(&ring);
+
+	iov[BUF_IDX_MSG].iov_base = iouring_read_msgs;
+	iov[BUF_IDX_MSG].iov_len = sizeof(struct uffd_msg) * READ_QUEUE_DEPTH;
+
+	iov[BUF_IDX_ZERO].iov_base = zeropage;
+	iov[BUF_IDX_ZERO].iov_len = page_size;
+
+	iov[BUF_IDX_SRC].iov_base = area_src;
+	iov[BUF_IDX_SRC].iov_len = nr_pages * page_size;
+
+	if (area_src_alias) {
+		iov[BUF_IDX_ALIAS].iov_base = area_src_alias;
+		iov[BUF_IDX_ALIAS].iov_len = nr_pages * page_size;
+	}
+
+	while ((r = io_uring_register_buffers(&ring, iov, (area_src_alias ? 4 : 3)))) {
+		if (r != -EINTR) {
+			fprintf(stderr, "Error registering buffers: %s\n", strerror(-r));
+			exit(1);
+		}
+	}
+}
+
+static bool ring_initialized;
+
+static void uffd_enqueue_async_read(int ufd, int req_id);
+
+static void init_iouring(void)
+{
+	struct io_uring_params io_uring_params = { 0 };
+	int n_msgs = nr_cpus * 3 + READ_QUEUE_DEPTH;
+	int n_private_msgs = nr_cpus * 3;
+	int fds[1] = { uffd };
+	int r, i;
+
+	if (!test_mods[MOD_IOURING])
+		return;
+
+	if (pthread_mutex_trylock(&ring_mutex)) {
+		fprintf(stderr, "ring_mutex taken during init\n");
+		exit(1);
+	}
+	if (pthread_mutex_trylock(&async_mutex)) {
+		fprintf(stderr, "ring_mutex taken during init\n");
+		exit(1);
+	}
+
+	if (ring_initialized)
+		io_uring_queue_exit(&ring);
+
+	ring_initialized = true;
+
+	io_uring_params.flags |= IORING_SETUP_SQPOLL;
+
+	/*
+	 * The ring size must allow all the possible reads to be enqueued and
+	 * at least one local request.
+	 */
+	r = io_uring_queue_init_params(n_msgs, &ring, &io_uring_params);
+	if (r) {
+		perror("io_uring_queue_init_params");
+		exit(-1);
+	}
+
+	if (!iouring_read_msgs) {
+		iouring_read_msgs = calloc(READ_QUEUE_DEPTH, sizeof(struct uffd_msg));
+		if (!iouring_read_msgs) {
+			fprintf(stderr, "malloc uffd_msg error\n");
+			exit(1);
+		}
+	}
+
+	if (!ring_results) {
+		ring_results = calloc(READ_QUEUE_DEPTH + n_private_msgs, sizeof(*ring_results));
+		if (!ring_results) {
+			fprintf(stderr, "calloc ring_results error\n");
+			exit(1);
+		}
+	}
+
+	for (i = 0; i < n_msgs; i++)
+		ring_results[i] = RES_NOT_DONE;
+
+	init_iouring_buffers();
+
+	/* Retry on EINTR */
+	do {
+		r = io_uring_register_files(&ring, fds, 1);
+	} while (r == -EINTR);
+	if (r) {
+		fprintf(stderr, "io_uring_register_files: %s\n", strerror(-r));
+		exit(-1);
+	}
+
+	pthread_mutex_unlock(&async_mutex);
+	pthread_mutex_unlock(&ring_mutex);
+
+	for (i = 0; i < READ_QUEUE_DEPTH; i++)
+		uffd_enqueue_async_read(uffd, i);
+}
+
+static int uffd_copy_ioctl(int ufd, struct uffdio_copy *uffdio_copy)
+{
+	return ioctl(ufd, UFFDIO_COPY, uffdio_copy);
+}
+
+static int uffd_copy_write(int ufd, struct uffdio_copy *uffdio_copy)
+{
+	off_t mode = uffdio_copy->mode & UFFDIO_COPY_MODE_WP;
+	int ret;
+
+	ret = pwrite(ufd, (void *)uffdio_copy->src, page_size, uffdio_copy->dst|mode);
+
+	if (ret == -1) {
+		uffdio_copy->copy = -errno;
+		return ret;
+	}
+
+	if (ret >= 0 && ret != uffdio_copy->len) {
+		fprintf(stderr, "unexpected partial write\n");
+		exit(1);
+	}
+
+	uffdio_copy->copy = uffdio_copy->len;
+	return 0;
+}
+
+static int uffd_zeropage_write(int ufd, struct uffdio_zeropage *uffdio_zeropage)
+{
+	int ret;
+
+	ret = pwrite(ufd, zeropage, uffdio_zeropage->range.len,
+			uffdio_zeropage->range.start|UFFDIO_WRITE_MODE_ZEROPAGE);
+
+	if (ret == -1) {
+		uffdio_zeropage->zeropage = -errno;
+		return ret;
+	}
+
+	if (ret >= 0 && ret != uffdio_zeropage->range.len) {
+		fprintf(stderr, "unexpected partial write\n");
+		exit(1);
+	}
+
+	uffdio_zeropage->zeropage = uffdio_zeropage->range.len;
+	return 0;
+}
+
+static int uffd_iouring_read_cqes(void)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	ret = io_uring_peek_cqe(&ring, &cqe);
+
+	if (ret == -EAGAIN)
+		return ret;
+
+	if (ret != 0) {
+		fprintf(stderr, "io_uring_peek_cqe: %s\n", strerror(-ret));
+		exit(1);
+	}
+
+	ring_results[cqe->user_data] = cqe->res;
+	io_uring_cqe_seen(&ring, cqe);
+
+	return 0;
+}
+
+static int uffd_iouring_search_done(int req_num_start, int req_num_end,
+				    int *idx, ssize_t *res)
+{
+	int ret = -EAGAIN;
+	int i;
+
+	for (i = req_num_start; i < req_num_end; i++) {
+		if (ring_results[i] == RES_NOT_DONE)
+			continue;
+
+		if (idx)
+			*idx = i;
+
+		if (res)
+			*res = ring_results[i];
+
+		ring_results[i] = RES_NOT_DONE;
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * Checks if there is any result that is ready between req_num_start and
+ * req_num_end. Returns the index and the real result.
+ */
+static int uffd_iouring_get_result(int req_num_start, int req_num_end, bool poll,
+			      int *idx, ssize_t *res, bool exclusive)
+{
+	const struct timespec zerotime = { 0 };
+	int ret = -EAGAIN;
+
+	/*
+	 * use nanosleep to create a cancellation point, which does not
+	 * exist when io-uring is used.
+	 */
+	nanosleep(&zerotime, NULL);
+
+	do {
+		if (exclusive || !pthread_mutex_trylock(&async_mutex)) {
+			ret = uffd_iouring_search_done(req_num_start,
+					req_num_end, idx, res);
+			if (!exclusive)
+				pthread_mutex_unlock(&async_mutex);
+		}
+
+		if (!pthread_mutex_trylock(&ring_mutex)) {
+			uffd_iouring_read_cqes();
+			pthread_mutex_unlock(&ring_mutex);
+		}
+	} while (poll && ret == -EAGAIN);
+
+	return ret;
+}
+
+static int uffd_iouring_get_result_single(int req_num, bool poll, int *idx,
+		ssize_t *res)
+{
+	return uffd_iouring_get_result(req_num, req_num+1, poll, idx, res, true);
+}
+
+/*
+ * uffd_iouring_submit() - submit into the io-uring while handling possible
+ * failures.
+ */
+static void uffd_iouring_submit(struct io_uring_sqe *sqe, int req_id)
+{
+	struct io_uring_sqe *ring_sqe;
+	int ret;
+
+	do {
+		ret = -EAGAIN;
+
+		pthread_mutex_lock(&ring_mutex);
+		ring_sqe = io_uring_get_sqe(&ring);
+		if (!ring_sqe)
+			goto retry;
+
+		*ring_sqe = *sqe;
+		ring_sqe->user_data = req_id;
+
+		ret = io_uring_submit(&ring);
+		if (ret < 0 && ret != -EAGAIN) {
+			fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
+			exit(1);
+		}
+
+retry:
+		/*
+		 * We do not have to read the cqes on success, but it is
+		 * cleaner this way.
+		 */
+		uffd_iouring_read_cqes();
+		pthread_mutex_unlock(&ring_mutex);
+	} while (ret <= 0);
+}
+
+static ssize_t uffd_iouring_submit_and_wait(struct io_uring_sqe *sqe)
+{
+	do {
+		ssize_t res;
+
+		if (local_req_id < READ_QUEUE_DEPTH) {
+			fprintf(stderr, "local_req_id < READ_QUEUE_DEPTH\n");
+			exit(1);
+		}
+
+		uffd_iouring_submit(sqe, local_req_id);
+
+		if (!uffd_iouring_get_result_single(local_req_id, true, NULL, &res))
+			return res;
+
+		pthread_yield();
+	} while (true);
+}
+
+/* uffd_enqueue_async_read must be called with ring_mutex taken */
+static void uffd_enqueue_async_read(int ufd, int req_id)
+{
+	struct io_uring_sqe sqe;
+
+	io_uring_prep_read_fixed(&sqe, 0, &iouring_read_msgs[req_id],
+			sizeof(struct uffd_msg), 0, 0);
+	sqe.flags |= IOSQE_FIXED_FILE;
+
+	uffd_iouring_submit(&sqe, req_id);
+}
+
+static int iouring_copy(int ufd, struct uffdio_copy *uffdio_copy)
+{
+	off_t mode = uffdio_copy->mode & UFFDIO_COPY_MODE_WP;
+	const char *src = (const char *)uffdio_copy->src;
+	struct io_uring_sqe sqe;
+	int buf_idx;
+	ssize_t res;
+
+	/* Find the index of the area */
+	if (src >= area_src && src < area_src + nr_pages * page_size)
+		buf_idx = BUF_IDX_SRC;
+	else if (src >= area_src_alias && src < area_src_alias + nr_pages * page_size)
+		buf_idx = BUF_IDX_ALIAS;
+	else {
+		fprintf(stderr, "could not find area\n");
+		exit(1);
+	}
+
+	io_uring_prep_write_fixed(&sqe, 0, src, uffdio_copy->len,
+			uffdio_copy->dst|mode, buf_idx);
+	sqe.flags |= IOSQE_FIXED_FILE;
+
+	res = uffd_iouring_submit_and_wait(&sqe);
+
+	/* Put res as if it was returned by the ioctl */
+	uffdio_copy->copy = res;
+
+	if (res >= 0 && res != uffdio_copy->len) {
+		fprintf(stderr, "uffd_iouring_copy got wrong size: %ld instead of %lld\n",
+				res, uffdio_copy->len);
+		exit(1);
+	}
+
+	return res < 0 ? res : 0;
+}
+
+static bool uffd_poll_msg_iouring(int ufd, unsigned long cpu)
+{
+	char tmp_chr;
+	int ret = 0;
+
+	ret = read(pipefd[cpu*2], &tmp_chr, 1);
+
+	return ret != 1;
+}
+
+static int uffd_read_msg_iouring(int ufd, struct uffd_msg *msg)
+{
+	ssize_t cqe_res;
+	int ret, idx;
+
+	ret = uffd_iouring_get_result(0, READ_QUEUE_DEPTH, false, &idx, &cqe_res, false);
+	if (ret == -EAGAIN)
+		return ret;
+
+	if (cqe_res == sizeof(struct uffd_msg)) {
+		*msg = iouring_read_msgs[idx];
+		ret = 0;
+	} else if (cqe_res < 0)
+		ret = cqe_res;
+	else {
+		fprintf(stderr, "cqe->res wrong size: %ld user_data: %d\n", cqe_res, idx);
+		exit(1);
+	}
+
+	/* Initialize for easier debugging of races, not really needed */
+	memset(&iouring_read_msgs[idx], 0, sizeof(iouring_read_msgs[idx]));
+
+	/* If we failed, we still insist on queueing it for later reads */
+	uffd_enqueue_async_read(ufd, idx);
+
+	return ret;
+}
+
+static const struct uffd_base_ops *uffd_base_ops;
+
 static void retry_copy_page(int ufd, struct uffdio_copy *uffdio_copy,
 			    unsigned long offset)
 {
 	uffd_test_ops->alias_mapping(&uffdio_copy->dst,
 				     uffdio_copy->len,
 				     offset);
-	if (ioctl(ufd, UFFDIO_COPY, uffdio_copy)) {
+	if (uffd_base_ops->copy(ufd, uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
 		if (uffdio_copy->copy != -EEXIST) {
 			fprintf(stderr, "UFFDIO_COPY retry error %Ld\n",
@@ -511,15 +939,20 @@ static int __copy_page(int ufd, unsigned long offset, bool retry)
 		uffdio_copy.mode = UFFDIO_COPY_MODE_WP;
 	else
 		uffdio_copy.mode = 0;
+retry:
 	uffdio_copy.copy = 0;
-	if (ioctl(ufd, UFFDIO_COPY, &uffdio_copy)) {
+	if (uffd_base_ops->copy(ufd, &uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
-		if (uffdio_copy.copy != -EEXIST) {
+		switch (uffdio_copy.copy) {
+		case -EEXIST:
+			wake_range(ufd, uffdio_copy.dst, page_size);
+			break;
+		case -EAGAIN:
+			goto retry;
+		default:
 			fprintf(stderr, "UFFDIO_COPY error %Ld\n",
-				uffdio_copy.copy);
-			exit(1);
+				uffdio_copy.copy), exit(1);
 		}
-		wake_range(ufd, uffdio_copy.dst, page_size);
 	} else if (uffdio_copy.copy != page_size) {
 		fprintf(stderr, "UFFDIO_COPY unexpected copy %Ld\n",
 			uffdio_copy.copy); exit(1);
@@ -561,6 +994,42 @@ static int uffd_read_msg(int ufd, struct uffd_msg *msg)
 	return 0;
 }
 
+/* Returns false if a break is needed */
+static bool uffd_poll_msg(int ufd, unsigned long cpu)
+{
+	struct pollfd pollfd[2];
+	char tmp_chr;
+	int ret;
+
+	pollfd[0].fd = ufd;
+	pollfd[0].events = POLLIN;
+	pollfd[1].fd = pipefd[cpu*2];
+	pollfd[1].events = POLLIN;
+
+	ret = poll(pollfd, 2, -1);
+	if (!ret) {
+		fprintf(stderr, "poll error %d\n", ret);
+		exit(1);
+	}
+	if (ret < 0) {
+		perror("poll");
+		exit(1);
+	}
+	if (pollfd[1].revents & POLLIN) {
+		if (read(pollfd[1].fd, &tmp_chr, 1) != 1) {
+			fprintf(stderr, "read pipefd error\n");
+			exit(1);
+		}
+		return false;
+	}
+	if (!(pollfd[0].revents & POLLIN)) {
+		fprintf(stderr, "pollfd[0].revents %d\n", pollfd[0].revents);
+		exit(1);
+	}
+
+	return true;
+}
+
 static void uffd_handle_page_fault(struct uffd_msg *msg,
 				   struct uffd_stats *stats)
 {
@@ -590,44 +1059,27 @@ static void uffd_handle_page_fault(struct uffd_msg *msg,
 	}
 }
 
+struct thread_arg {
+	struct uffd_stats *stats;
+	unsigned long cpu;
+	int req_id;
+};
+
 static void *uffd_poll_thread(void *arg)
 {
-	struct uffd_stats *stats = (struct uffd_stats *)arg;
+	struct thread_arg *thread_arg = (struct thread_arg *)arg;
+	struct uffd_stats *stats = thread_arg->stats;
 	unsigned long cpu = stats->cpu;
-	struct pollfd pollfd[2];
 	struct uffd_msg msg;
 	struct uffdio_register uffd_reg;
-	int ret;
-	char tmp_chr;
 
-	pollfd[0].fd = uffd;
-	pollfd[0].events = POLLIN;
-	pollfd[1].fd = pipefd[cpu*2];
-	pollfd[1].events = POLLIN;
+	local_req_id = thread_arg->req_id;
 
 	for (;;) {
-		ret = poll(pollfd, 2, -1);
-		if (!ret) {
-			fprintf(stderr, "poll error %d\n", ret);
-			exit(1);
-		}
-		if (ret < 0) {
-			perror("poll");
-			exit(1);
-		}
-		if (pollfd[1].revents & POLLIN) {
-			if (read(pollfd[1].fd, &tmp_chr, 1) != 1) {
-				fprintf(stderr, "read pipefd error\n");
-				exit(1);
-			}
+		if (!uffd_base_ops->poll_msg(uffd, cpu))
 			break;
-		}
-		if (!(pollfd[0].revents & POLLIN)) {
-			fprintf(stderr, "pollfd[0].revents %d\n",
-				pollfd[0].revents);
-			exit(1);
-		}
-		if (uffd_read_msg(uffd, &msg))
+
+		if (uffd_base_ops->read_msg(uffd, &msg))
 			continue;
 		switch (msg.event) {
 		default:
@@ -640,7 +1092,16 @@ static void *uffd_poll_thread(void *arg)
 		case UFFD_EVENT_FORK:
 			close(uffd);
 			uffd = msg.arg.fork.ufd;
-			pollfd[0].fd = uffd;
+			if (test_mods[MOD_IOURING]) {
+				static ssize_t r;
+
+				r = io_uring_register_files_update(&ring, 0, &uffd, 1);
+				if (r < 0) {
+					fprintf(stderr, "io_uring_register_files_update: %s\n",
+							strerror(-r));
+					exit(1);
+				}
+			}
 			break;
 		case UFFD_EVENT_REMOVE:
 			uffd_reg.range.start = msg.arg.remove.start;
@@ -664,14 +1125,25 @@ pthread_mutex_t uffd_read_mutex = PTHREAD_MUTEX_INITIALIZER;
 
 static void *uffd_read_thread(void *arg)
 {
-	struct uffd_stats *stats = (struct uffd_stats *)arg;
+	struct thread_arg *thread_arg = (struct thread_arg *)arg;
+	struct uffd_stats *stats = thread_arg->stats;
 	struct uffd_msg msg;
 
+	local_req_id = thread_arg->req_id;
+
 	pthread_mutex_unlock(&uffd_read_mutex);
 	/* from here cancellation is ok */
 
 	for (;;) {
-		if (uffd_read_msg(uffd, &msg))
+		const struct timespec zerotime = { 0 };
+
+		/*
+		 * use nanosleep to create a cancellation point, which does not
+		 * exist when io-uring is used.
+		 */
+		nanosleep(&zerotime, NULL);
+
+		if (uffd_base_ops->read_msg(uffd, &msg))
 			continue;
 		uffd_handle_page_fault(&msg, stats);
 	}
@@ -681,9 +1153,12 @@ static void *uffd_read_thread(void *arg)
 
 static void *background_thread(void *arg)
 {
-	unsigned long cpu = (unsigned long) arg;
+	struct thread_arg *thread_arg = (struct thread_arg *)arg;
+	unsigned long cpu = thread_arg->cpu;
 	unsigned long page_nr, start_nr, mid_nr, end_nr;
 
+	local_req_id = thread_arg->req_id;
+
 	start_nr = cpu * nr_pages_per_cpu;
 	end_nr = (cpu+1) * nr_pages_per_cpu;
 	mid_nr = (start_nr + end_nr) / 2;
@@ -717,6 +1192,10 @@ static int stress(struct uffd_stats *uffd_stats)
 	pthread_t locking_threads[nr_cpus];
 	pthread_t uffd_threads[nr_cpus];
 	pthread_t background_threads[nr_cpus];
+	struct thread_arg read_thread_args[nr_cpus];
+	struct thread_arg poll_thread_args[nr_cpus];
+	struct thread_arg background_thread_args[nr_cpus];
+	int req_id = READ_QUEUE_DEPTH;
 
 	finished = 0;
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
@@ -724,19 +1203,28 @@ static int stress(struct uffd_stats *uffd_stats)
 				   locking_thread, (void *)cpu))
 			return 1;
 		if (bounces & BOUNCE_POLL) {
+			poll_thread_args[cpu].req_id = req_id++;
+			poll_thread_args[cpu].stats = &uffd_stats[cpu];
+			poll_thread_args[cpu].cpu = cpu;
+
 			if (pthread_create(&uffd_threads[cpu], &attr,
 					   uffd_poll_thread,
-					   (void *)&uffd_stats[cpu]))
+					   (void *)&poll_thread_args[cpu]))
 				return 1;
 		} else {
+			read_thread_args[cpu].req_id = req_id++;
+			read_thread_args[cpu].stats = &uffd_stats[cpu];
+			read_thread_args[cpu].cpu = cpu;
 			if (pthread_create(&uffd_threads[cpu], &attr,
 					   uffd_read_thread,
-					   (void *)&uffd_stats[cpu]))
+					   (void *)&read_thread_args[cpu]))
 				return 1;
 			pthread_mutex_lock(&uffd_read_mutex);
 		}
+		background_thread_args[cpu].req_id = req_id++;
+		background_thread_args[cpu].cpu = cpu;
 		if (pthread_create(&background_threads[cpu], &attr,
-				   background_thread, (void *)cpu))
+				   background_thread, (void *)&background_thread_args[cpu]))
 			return 1;
 	}
 	for (cpu = 0; cpu < nr_cpus; cpu++)
@@ -786,6 +1274,12 @@ static int userfaultfd_open(int features)
 {
 	struct uffdio_api uffdio_api;
 
+	if (test_mods[MOD_POLL])
+		features |= UFFD_FEATURE_POLL;
+
+	if (test_iouring || test_write)
+		features |= UFFD_FEATURE_WRITE;
+
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
 	if (uffd < 0) {
 		fprintf(stderr,
@@ -805,6 +1299,8 @@ static int userfaultfd_open(int features)
 		return 1;
 	}
 
+	init_iouring();
+
 	return 0;
 }
 
@@ -954,6 +1450,34 @@ static int faulting_process(int signal_test)
 	return 0;
 }
 
+static int uffd_zeropage_ioctl(int ufd, struct uffdio_zeropage *uffdio_zeropage)
+{
+	return ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage);
+}
+
+static int uffd_zeropage_iouring(int ufd, struct uffdio_zeropage *uffdio_zeropage)
+{
+	struct io_uring_sqe sqe;
+	ssize_t res;
+
+	io_uring_prep_write_fixed(&sqe, 0, zeropage, uffdio_zeropage->range.len,
+			uffdio_zeropage->range.start|UFFDIO_WRITE_MODE_ZEROPAGE, BUF_IDX_ZERO);
+	sqe.flags |= IOSQE_FIXED_FILE;
+
+	res = uffd_iouring_submit_and_wait(&sqe);
+
+	/* Put res as if it was returned by the ioctl */
+	uffdio_zeropage->zeropage = res;
+
+	if (res >= 0 && res != uffdio_zeropage->range.len) {
+		fprintf(stderr, "%s got wrong size: %ld instead of %lld\n", __func__,
+				res, uffdio_zeropage->range.len);
+		exit(-1);
+	}
+
+	return res < 0 ? res : 0;
+}
+
 static void retry_uffdio_zeropage(int ufd,
 				  struct uffdio_zeropage *uffdio_zeropage,
 				  unsigned long offset)
@@ -961,7 +1485,7 @@ static void retry_uffdio_zeropage(int ufd,
 	uffd_test_ops->alias_mapping(&uffdio_zeropage->range.start,
 				     uffdio_zeropage->range.len,
 				     offset);
-	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
+	if (uffd_base_ops->zero(ufd, uffdio_zeropage)) {
 		if (uffdio_zeropage->zeropage != -EEXIST) {
 			fprintf(stderr, "UFFDIO_ZEROPAGE retry error %Ld\n",
 				uffdio_zeropage->zeropage);
@@ -988,7 +1512,7 @@ static int __uffdio_zeropage(int ufd, unsigned long offset, bool retry)
 	uffdio_zeropage.range.start = (unsigned long) area_dst + offset;
 	uffdio_zeropage.range.len = page_size;
 	uffdio_zeropage.mode = 0;
-	ret = ioctl(ufd, UFFDIO_ZEROPAGE, &uffdio_zeropage);
+	ret = uffd_base_ops->zero(ufd, &uffdio_zeropage);
 	if (ret) {
 		/* real retval in ufdio_zeropage.zeropage */
 		if (has_zeropage) {
@@ -1034,6 +1558,49 @@ static int uffdio_zeropage(int ufd, unsigned long offset)
 	return __uffdio_zeropage(ufd, offset, false);
 }
 
+static void userfaultfd_register(int uffd, struct uffdio_register *uffdio_register)
+{
+	int n_retries = 1000000;
+	int res;
+
+	/*
+	 * When using io-uring the release of the uffd might be slightly delayed.
+	 */
+	do {
+		res = 0;
+		if (!ioctl(uffd, UFFDIO_REGISTER, uffdio_register))
+			break;
+
+		res = errno;
+		if (res != EBUSY)
+			break;
+
+		pthread_yield();
+	} while (n_retries--);
+
+	if (!res)
+		return;
+
+	fprintf(stderr, "register failure: %s\n", strerror(res));
+	exit(1);
+}
+
+static void userfaultfd_close(void)
+{
+	if (close(uffd)) {
+		perror("close");
+		exit(1);
+	}
+
+	uffd = -1;
+
+	/* Exit the io_uring in order to drop the reference to the file */
+	if (ring_initialized) {
+		io_uring_queue_exit(&ring);
+		ring_initialized = false;
+	}
+}
+
 /* exercise UFFDIO_ZEROPAGE */
 static int userfaultfd_zeropage_test(void)
 {
@@ -1048,6 +1615,9 @@ static int userfaultfd_zeropage_test(void)
 
 	if (userfaultfd_open(0) < 0)
 		return 1;
+
+	local_req_id = READ_QUEUE_DEPTH;
+
 	uffdio_register.range.start = (unsigned long) area_dst;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
@@ -1073,7 +1643,13 @@ static int userfaultfd_zeropage_test(void)
 		}
 	}
 
-	close(uffd);
+	/* unregister */
+	if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range)) {
+		fprintf(stderr, "unregister failure\n");
+		return 1;
+	}
+
+	userfaultfd_close();
 	printf("done.\n");
 	return 0;
 }
@@ -1087,6 +1663,12 @@ static int userfaultfd_events_test(void)
 	pid_t pid;
 	char c;
 	struct uffd_stats stats = { 0 };
+	struct thread_arg thread_arg = {
+		.stats = &stats,
+		.req_id = READ_QUEUE_DEPTH,
+	};
+
+	local_req_id = READ_QUEUE_DEPTH + 1;
 
 	printf("testing events (fork, remap, remove): ");
 	fflush(stdout);
@@ -1105,10 +1687,8 @@ static int userfaultfd_events_test(void)
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
 	if (test_uffdio_wp)
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-		fprintf(stderr, "register failure\n");
-		exit(1);
-	}
+
+	userfaultfd_register(uffd, &uffdio_register);
 
 	expected_ioctls = uffd_test_ops->expected_ioctls;
 	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls) {
@@ -1116,7 +1696,7 @@ static int userfaultfd_events_test(void)
 		exit(1);
 	}
 
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats)) {
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &thread_arg)) {
 		perror("uffd_poll_thread create");
 		exit(1);
 	}
@@ -1143,7 +1723,7 @@ static int userfaultfd_events_test(void)
 	if (pthread_join(uffd_mon, NULL))
 		return 1;
 
-	close(uffd);
+	userfaultfd_close();
 
 	uffd_stats_report(&stats, 1);
 
@@ -1160,6 +1740,12 @@ static int userfaultfd_sig_test(void)
 	pid_t pid;
 	char c;
 	struct uffd_stats stats = { 0 };
+	struct thread_arg thread_arg = {
+		.stats = &stats,
+		.req_id = READ_QUEUE_DEPTH,
+	};
+
+	local_req_id = READ_QUEUE_DEPTH + 1;
 
 	printf("testing signal delivery: ");
 	fflush(stdout);
@@ -1168,7 +1754,7 @@ static int userfaultfd_sig_test(void)
 		return 1;
 
 	features = UFFD_FEATURE_EVENT_FORK|UFFD_FEATURE_SIGBUS;
-	if (userfaultfd_open(features) < 0)
+	if (userfaultfd_open(features))
 		return 1;
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -1177,10 +1763,8 @@ static int userfaultfd_sig_test(void)
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
 	if (test_uffdio_wp)
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
-		fprintf(stderr, "register failure\n");
-		exit(1);
-	}
+
+	userfaultfd_register(uffd, &uffdio_register);
 
 	expected_ioctls = uffd_test_ops->expected_ioctls;
 	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls) {
@@ -1196,7 +1780,7 @@ static int userfaultfd_sig_test(void)
 	if (uffd_test_ops->release_pages(area_dst))
 		return 1;
 
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats)) {
+	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &thread_arg)) {
 		perror("uffd_poll_thread create");
 		exit(1);
 	}
@@ -1207,8 +1791,10 @@ static int userfaultfd_sig_test(void)
 		exit(1);
 	}
 
-	if (!pid)
+	if (!pid) {
+		local_req_id++;
 		exit(faulting_process(2));
+	}
 
 	waitpid(pid, &err, 0);
 	if (err) {
@@ -1223,11 +1809,14 @@ static int userfaultfd_sig_test(void)
 	if (pthread_join(uffd_mon, (void **)&userfaults))
 		return 1;
 
-	printf("done.\n");
 	if (userfaults)
 		fprintf(stderr, "Signal test failed, userfaults: %ld\n",
 			userfaults);
-	close(uffd);
+
+	if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range))
+		perror("unregister failure");
+
+	userfaultfd_close();
 	return userfaults != 0;
 }
 
@@ -1248,9 +1837,6 @@ static int userfaultfd_stress(void)
 	if (!area_dst)
 		return 1;
 
-	if (userfaultfd_open(0) < 0)
-		return 1;
-
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
 	if (!count_verify) {
 		perror("count_verify");
@@ -1290,7 +1876,9 @@ static int userfaultfd_stress(void)
 	zeropage = area;
 	bzero(zeropage, page_size);
 
-	pthread_mutex_lock(&uffd_read_mutex);
+	/* Call only once all memory allocation is done */
+	if (userfaultfd_open(0) < 0)
+		return 1;
 
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, 16*1024*1024);
@@ -1420,13 +2008,17 @@ static int userfaultfd_stress(void)
 		area_dst_alias = tmp_area;
 
 		uffd_stats_report(uffd_stats, nr_cpus);
+
+		init_iouring();
 	}
 
 	if (err)
 		return err;
 
-	close(uffd);
-	return userfaultfd_zeropage_test() || userfaultfd_sig_test()
+	userfaultfd_close();
+
+	return userfaultfd_zeropage_test()
+		|| (!test_mods[MOD_IOURING] && userfaultfd_sig_test())
 		|| userfaultfd_events_test();
 }
 
@@ -1454,8 +2046,70 @@ unsigned long default_huge_page_size(void)
 	return hps;
 }
 
-static void set_test_type(const char *type)
+static const struct uffd_base_ops uffd_sync_ops = {
+	.read_msg = uffd_read_msg,
+	.poll_msg = uffd_poll_msg,
+	.copy = uffd_copy_ioctl,
+	.zero = uffd_zeropage_ioctl,
+};
+
+static const struct uffd_base_ops uffd_write_ops = {
+	.read_msg = uffd_read_msg,
+	.poll_msg = uffd_poll_msg,
+	.copy = uffd_copy_write,
+	.zero = uffd_zeropage_write,
+};
+
+static const struct uffd_base_ops uffd_iouring_ops = {
+	.read_msg = uffd_read_msg_iouring,
+	.poll_msg = uffd_poll_msg_iouring,
+	.copy = iouring_copy,
+	.zero = uffd_zeropage_iouring,
+};
+
+static const char **get_test_types(const char *arg)
 {
+	char *null_delimited;
+	const char **types;
+	int types_num = 1;
+	int type_idx = 0;
+	int i;
+
+	null_delimited = calloc(strlen(arg) + 1, 1);
+	if (!null_delimited) {
+		fprintf(stderr, "Error allocating null delimited arg string\n");
+		exit(1);
+	}
+
+	for (i = 0; i < strlen(arg); i++) {
+		if (arg[i] == ':')
+			types_num++;
+	}
+
+	types = calloc(types_num + 1, sizeof(*types));
+	if (!types) {
+		fprintf(stderr, "Error allocating types array\n");
+		exit(1);
+	}
+
+	types[0] = null_delimited;
+	for (i = 0; i < strlen(arg); i++) {
+		if (arg[i] == ':') {
+			types[++type_idx] = &null_delimited[i+1];
+			continue;
+		}
+		null_delimited[i] = arg[i];
+	}
+	return types;
+}
+
+static void set_test_type(const char *raw_types)
+{
+	const char **types = get_test_types(raw_types);
+	const char **modifiers = &types[1];
+	const char *type = types[0];
+	int i, j;
+
 	if (!strcmp(type, "anon")) {
 		test_type = TEST_ANON;
 		uffd_test_ops = &anon_uffd_test_ops;
@@ -1490,6 +2144,30 @@ static void set_test_type(const char *type)
 		fprintf(stderr, "Impossible to run this test\n");
 		exit(2);
 	}
+
+	/* Process test modifiers */
+	for (i = 0; modifiers[i] != NULL; i++) {
+		for (j = 0; j < N_MODIFIERS; j++) {
+			if (!strcmp(modifiers[i], mod_strs[j]))
+				break;
+		}
+		if (j == N_MODIFIERS) {
+			fprintf(stderr, "Unknown test modifier: %s\n", modifiers[i]);
+			exit(1);
+		}
+
+		test_mods[j] = true;
+	}
+
+	uffd_base_ops = &uffd_sync_ops;
+	if (test_mods[MOD_IOURING]) {
+		if (test_type == TEST_SHMEM) {
+			fprintf(stderr, "shmem test is incompatible with iouring\n");
+			exit(1);
+		}
+		uffd_base_ops = &uffd_iouring_ops;
+	} else if (test_mods[MOD_WRITE])
+		uffd_base_ops = &uffd_write_ops;
 }
 
 static void sigalrm(int sig)
@@ -1522,6 +2200,16 @@ int main(int argc, char **argv)
 		usage();
 	}
 
+	if (test_mods[MOD_IOURING]) {
+		/* Do not overload the system in the async tests */
+		nr_cpus = (nr_cpus - 1) / 3;
+
+		if (nr_cpus < 1) {
+			fprintf(stderr, "CPUs are overcommitted for async, slow test is expected\n");
+			nr_cpus = 1;
+		}
+	}
+
 	bounces = atoi(argv[3]);
 	if (bounces <= 0) {
 		fprintf(stderr, "invalid bounces\n");
-- 
2.25.1

