Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E147414EE75
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgAaO3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 09:29:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729052AbgAaO3z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 09:29:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580480993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dx3pOpClielJWDHHM+g3P4+R03HEUdyYBqWMUnj0RkQ=;
        b=iMUwxsrPfOBSxQNhymy86QduTedCT3yDjO0CYTX9vi+nWY0HSe0tgEMtAs3ioVZYtwlDEy
        SBIIjBVLZvZ1fGfNZz2a3mH2QTtkqfZTye6wSO8xVbxJhmHRNFUgtzz/vgGvtGdiIzXR+4
        3+qoMNH4QgYtwhfUS/EvuK87quNZHnY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-h2UQnNTmNii81zHDwW_J5Q-1; Fri, 31 Jan 2020 09:29:48 -0500
X-MC-Unique: h2UQnNTmNii81zHDwW_J5Q-1
Received: by mail-wr1-f70.google.com with SMTP id w6so3430563wrm.16
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 06:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dx3pOpClielJWDHHM+g3P4+R03HEUdyYBqWMUnj0RkQ=;
        b=M5h/lNHpF04hipAZbGVoAn5Te2QmppI7D7nfGnTPIkEaa/GzHbuX857399E5sgHZNk
         EM6KHl4/MIz3GNyQgfK4AzzUJiwQ5dJSSVOTWhqaCnauGXIk+ufHtNFIvDCSR383cRxG
         1dP2guNdqkt0+bMKP5oANunH7JVRLd5Ronc22i7/pZpS3vLO50rgN73/0rDoWQHPQVxd
         PBsIBo9JOYbJvySgzU/Hw5Y7k5/Me+LPv2bi8MSHVmV6FV8ht4lrXzVbbDd2Kx8372ml
         6MyDNA6nNoj9ZYmg6NJfqdMz9jLczRaV6rSdmoQufp+hEhkPWu7hl20iVgt9qEr+dZW/
         4jIw==
X-Gm-Message-State: APjAAAUT9sr95eS7t2Rp2O3B221rl/glSenNFByLZpy85uhhCYDCfn9M
        THbXY8J1xGFSMHmnmYTL10mm943SpwhR9AC7sPwSW+7QsoQtpO/D91yzhzGzM7ge/xHtr8DK34g
        TvB1aicihAkY+buX9mlk=
X-Received: by 2002:a5d:5263:: with SMTP id l3mr12309807wrc.405.1580480987249;
        Fri, 31 Jan 2020 06:29:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9Rnon9P6cIW0QNPpgWs2Wcdhl2kvBPDaYuKe01StSY16YedxLLGSmxLDXOsdrpjavVTxJKQ==
X-Received: by 2002:a5d:5263:: with SMTP id l3mr12309782wrc.405.1580480986888;
        Fri, 31 Jan 2020 06:29:46 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id z19sm10394558wmi.43.2020.01.31.06.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 06:29:45 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 1/1] test: add epoll test case
Date:   Fri, 31 Jan 2020 15:29:43 +0100
Message-Id: <20200131142943.120459-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131142943.120459-1-sgarzare@redhat.com>
References: <20200131142943.120459-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch add the epoll test case that has four sub-tests:
- test_epoll
- test_epoll_sqpoll
- test_epoll_nodrop
- test_epoll_sqpoll_nodrop

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v1 -> v2:
    - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
    - add 2 new tests to test epoll with IORING_FEAT_NODROP
    - cleanups
---
 .gitignore    |   1 +
 test/Makefile |   5 +-
 test/epoll.c  | 386 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+), 2 deletions(-)
 create mode 100644 test/epoll.c

diff --git a/.gitignore b/.gitignore
index bdff558..49903ca 100644
--- a/.gitignore
+++ b/.gitignore
@@ -37,6 +37,7 @@
 /test/d77a67ed5f27-test
 /test/defer
 /test/eeed8b54e0df-test
+/test/epoll
 /test/fadvise
 /test/fallocate
 /test/fc2a85cb02ef-test
diff --git a/test/Makefile b/test/Makefile
index a975999..3f1d2f6 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -19,7 +19,7 @@ all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register
 		poll-many b5837bd5311d-test accept-test d77a67ed5f27-test \
 		connect 7ad0e4b2f83c-test submit-reuse fallocate open-close \
 		file-update statx accept-reuse poll-v-poll fadvise madvise \
-		short-read openat2 probe shared-wq personality
+		short-read openat2 probe shared-wq personality epoll
 
 include ../Makefile.quiet
 
@@ -46,7 +46,7 @@ test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
 	7ad0e4b2f83c-test.c submit-reuse.c fallocate.c open-close.c \
 	file-update.c statx.c accept-reuse.c poll-v-poll.c fadvise.c \
 	madvise.c short-read.c openat2.c probe.c shared-wq.c \
-	personality.c
+	personality.c epoll.c
 
 test_objs := $(patsubst %.c,%.ol,$(test_srcs))
 
@@ -57,6 +57,7 @@ poll-link: XCFLAGS = -lpthread
 accept-link: XCFLAGS = -lpthread
 submit-reuse: XCFLAGS = -lpthread
 poll-v-poll: XCFLAGS = -lpthread
+epoll: XCFLAGS = -lpthread
 
 install: $(all_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/epoll.c b/test/epoll.c
new file mode 100644
index 0000000..610820a
--- /dev/null
+++ b/test/epoll.c
@@ -0,0 +1,386 @@
+/*
+ * Description: test io_uring poll handling using a pipe
+ *
+ *              Three threads involved:
+ *              - producer: fills SQ with write requests for the pipe
+ *              - cleaner: consumes CQ, freeing the buffers that producer
+ *                         allocates
+ *              - consumer: read() blocking on the pipe
+ *
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/poll.h>
+#include <sys/wait.h>
+#include <sys/epoll.h>
+
+#include "liburing.h"
+
+#define TIMEOUT         10
+#define ITERATIONS      100
+#define RING_ENTRIES    2
+#define BUF_SIZE        2048
+#define PIPE_SIZE       4096 /* pipe capacity below the page size are silently
+			      * rounded up to the page size
+			      */
+
+enum {
+	TEST_OK = 0,
+	TEST_SKIPPED = 1,
+	TEST_FAILED = 2,
+};
+
+struct thread_data {
+	struct io_uring *ring;
+
+	volatile uint32_t submitted;
+	volatile uint32_t freed;
+	uint32_t entries;
+	int pipe_read;
+	int pipe_write;
+	bool sqpoll;
+	bool nodrop;
+};
+
+static void sig_alrm(int sig)
+{
+	fprintf(stderr, "Timed out!\n");
+	exit(1);
+}
+
+static struct iovec *alloc_vec(void)
+{
+	struct iovec *vec;
+
+	vec = malloc(sizeof(struct iovec));
+	if (!vec) {
+		perror("malloc iovec");
+		exit(1);
+	}
+	vec->iov_base = malloc(BUF_SIZE);
+	if (!vec->iov_base) {
+		perror("malloc buffer");
+		exit(1);
+	}
+	vec->iov_len = BUF_SIZE;
+
+	return vec;
+}
+
+static void free_vec(struct iovec *vec)
+{
+	free(vec->iov_base);
+	free(vec);
+}
+
+static void *do_test_epoll_produce(void *data)
+{
+	struct thread_data *td = data;
+	struct io_uring_sqe *sqe;
+	struct epoll_event ev;
+	void *th_ret = (void *)1;
+	int fd, ret;
+
+	fd = epoll_create1(0);
+	if (fd < 0) {
+		perror("epoll_create");
+		return th_ret;
+	}
+
+	ev.events = EPOLLOUT;
+	ev.data.fd = td->ring->ring_fd;
+
+	if (epoll_ctl(fd, EPOLL_CTL_ADD, td->ring->ring_fd, &ev) < 0) {
+		perror("epoll_ctrl");
+		goto ret;
+	}
+
+	while (td->submitted < ITERATIONS) {
+		bool submit = false;
+
+		ret = epoll_wait(fd, &ev, 1, -1);
+		if (ret < 0) {
+			perror("epoll_wait");
+			goto ret;
+		}
+
+		while (td->submitted < ITERATIONS) {
+			struct iovec *vec;
+
+			/*
+			 * If IORING_FEAT_NODROP is not supported, we want to
+			 * avoid the drop of completion event.
+			 */
+			if (!td->nodrop &&
+			    (td->submitted - td->freed >= td->entries))
+				break;
+
+			sqe = io_uring_get_sqe(td->ring);
+			if (!sqe)
+				break;
+
+			vec = alloc_vec();
+			io_uring_prep_writev(sqe, td->pipe_write, vec, 1, 0);
+
+			if (td->sqpoll)
+				sqe->flags |= IOSQE_FIXED_FILE;
+
+			io_uring_sqe_set_data(sqe, vec);
+			td->submitted++;
+			submit = true;
+		}
+
+		if (!submit)
+			continue;
+
+		ret = io_uring_submit(td->ring);
+		while (td->nodrop && ret == -EBUSY) {
+			usleep(10000);
+			ret = io_uring_submit(td->ring);
+		}
+		if (ret <= 0) {
+			fprintf(stderr, "io_uring_submit failed - ret: %d\n",
+				ret);
+			goto ret;
+		}
+	}
+
+	printf("Successfully submitted %d requests\n", td->submitted);
+
+	th_ret = 0;
+ret:
+	close(fd);
+	return th_ret;
+}
+
+static void *do_test_epoll_free(void *data)
+{
+	struct thread_data *td = data;
+	struct io_uring_cqe *cqe;
+	struct epoll_event ev;
+	int fd, ret;
+	void *th_ret = (void *)1;
+
+	fd = epoll_create1(0);
+	if (fd < 0) {
+		perror("epoll_create");
+		return th_ret;
+	}
+
+	ev.events = EPOLLIN;
+	ev.data.fd = td->ring->ring_fd;
+
+	if (epoll_ctl(fd, EPOLL_CTL_ADD, td->ring->ring_fd, &ev) < 0) {
+		perror("epoll_ctrl");
+		goto ret;
+	}
+
+	while (td->freed < ITERATIONS) {
+		ret = epoll_wait(fd, &ev, 1, -1);
+		if (ret < 0) {
+			perror("epoll_wait");
+			goto ret;
+		}
+
+		while (td->freed < ITERATIONS) {
+			struct iovec *vec;
+
+			ret = io_uring_peek_cqe(td->ring, &cqe);
+			if (!cqe || ret) {
+				if (ret == -EAGAIN)
+					break;
+				fprintf(stderr,
+					"io_uring_peek_cqe failed - ret: %d\n",
+					ret);
+				goto ret;
+			}
+
+			vec = io_uring_cqe_get_data(cqe);
+			io_uring_cqe_seen(td->ring, cqe);
+			free_vec(vec);
+			td->freed++;
+		}
+	}
+
+	printf("Successfully completed %d requests\n", td->freed);
+
+	th_ret = 0;
+ret:
+	close(fd);
+	return th_ret;
+}
+
+
+static void *do_test_epoll_consume(void *data)
+{
+	struct thread_data *td = data;
+	static uint8_t buf[BUF_SIZE];
+	int ret, iter = 0;
+	void *th_ret = (void *)1;
+
+	while (iter < ITERATIONS) {
+		errno = 0;
+		ret = read(td->pipe_read, &buf, BUF_SIZE);
+		if (ret != BUF_SIZE)
+			break;
+		iter++;
+	};
+
+	if (ret < 0) {
+		perror("read");
+		goto ret;
+	}
+
+	if (iter != ITERATIONS) {
+		fprintf(stderr, "Wrong iterations: %d [expected %d]\n",
+			iter, ITERATIONS);
+		goto ret;
+	}
+
+	printf("Successfully received %d messages\n", iter);
+
+	th_ret = 0;
+ret:
+	return th_ret;
+}
+
+static int do_test_epoll(bool sqpoll, bool nodrop)
+{
+	int ret = 0, pipe1[2];
+	struct io_uring_params param;
+	struct thread_data td;
+	pthread_t threads[3];
+	struct io_uring ring;
+	void *ret_th[3];
+
+	if (geteuid() && sqpoll) {
+		fprintf(stderr, "sqpoll requires root!\n");
+		return TEST_SKIPPED;
+	}
+
+	if (pipe(pipe1) != 0) {
+		perror("pipe");
+		return TEST_FAILED;
+	}
+
+	ret = fcntl(pipe1[0], F_SETPIPE_SZ, PIPE_SIZE);
+	if (ret < 0) {
+		perror("fcntl");
+		ret = TEST_FAILED;
+		goto err_pipe;
+	}
+
+	memset(&param, 0, sizeof(param));
+	memset(&td, 0, sizeof(td));
+
+	td.sqpoll = sqpoll;
+	td.nodrop = nodrop;
+	td.pipe_read = pipe1[0];
+	td.pipe_write = pipe1[1];
+	td.entries = RING_ENTRIES;
+
+	if (td.sqpoll)
+		param.flags |= IORING_SETUP_SQPOLL;
+
+	ret = io_uring_queue_init_params(td.entries, &ring, &param);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		ret = TEST_FAILED;
+	}
+
+	if (nodrop && !(param.features & IORING_FEAT_NODROP)) {
+		fprintf(stderr, "IORING_FEAT_NODROP not supported!\n");
+		ret = TEST_SKIPPED;
+		goto err_pipe;
+	}
+
+	td.ring = &ring;
+
+	if (td.sqpoll) {
+		ret = io_uring_register_files(&ring, &td.pipe_write, 1);
+		if (ret) {
+			fprintf(stderr, "file reg failed: %d\n", ret);
+			ret = TEST_FAILED;
+			goto err_uring;
+		}
+
+		td.pipe_write = 0;
+	}
+
+	pthread_create(&threads[0], NULL, do_test_epoll_produce, &td);
+	pthread_create(&threads[1], NULL, do_test_epoll_free, &td);
+	pthread_create(&threads[2], NULL, do_test_epoll_consume, &td);
+
+	pthread_join(threads[0], &ret_th[0]);
+	pthread_join(threads[1], &ret_th[1]);
+	pthread_join(threads[2], &ret_th[2]);
+
+	if (ret_th[0] || ret_th[1] || ret_th[2]) {
+		fprintf(stderr, "threads ended with errors\n");
+		ret = TEST_FAILED;
+		goto err_uring;
+	}
+
+	ret = TEST_OK;
+
+err_uring:
+	io_uring_queue_exit(&ring);
+err_pipe:
+	close(pipe1[0]);
+	close(pipe1[1]);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct sigaction act;
+	int ret;
+
+	memset(&act, 0, sizeof(act));
+	act.sa_handler = sig_alrm;
+	act.sa_flags = SA_RESTART;
+	sigaction(SIGALRM, &act, NULL);
+	alarm(TIMEOUT);
+
+	ret = do_test_epoll(false, false);
+	if (ret == TEST_SKIPPED) {
+		printf("test_epoll: skipped\n");
+	} else if (ret == TEST_FAILED) {
+		fprintf(stderr, "test_epoll failed\n");
+		return ret;
+	}
+
+	ret = do_test_epoll(true, false);
+	if (ret == TEST_SKIPPED) {
+		printf("test_epoll_sqpoll: skipped\n");
+	} else if (ret == TEST_FAILED) {
+		fprintf(stderr, "test_epoll_sqpoll failed\n");
+		return ret;
+	}
+
+	ret = do_test_epoll(false, true);
+	if (ret == TEST_SKIPPED) {
+		printf("test_epoll_nodrop: skipped\n");
+	} else if (ret == TEST_FAILED) {
+		fprintf(stderr, "test_epoll_nodrop failed\n");
+		return ret;
+	}
+
+	ret = do_test_epoll(true, true);
+	if (ret == TEST_SKIPPED) {
+		printf("test_epoll_sqpoll_nodrop: skipped\n");
+	} else if (ret == TEST_FAILED) {
+		fprintf(stderr, "test_epoll_sqpoll_nodrop failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
2.24.1

