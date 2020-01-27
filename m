Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE114A7EA
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgA0QRR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 11:17:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37306 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729505AbgA0QRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 11:17:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580141836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eiEBpcB+U9NnqJgpAYiIRI1u/COCRHXpo5tb3jZjkMU=;
        b=WHxwXxwwpdnGFF+qVmFuCORRbQ+wSFJK28FEDEZ5bEBLaxXmUYML/KuIVKZ7T4j6qw6AfD
        dJZ27hWF9yqjYwYQgqRGFdtJIdTBzae3jq2a40oOZpSlbrvxMI1NVYoZ2XI9fp1IQjoGk9
        n16XO/nnARPRY2EqIQG8HMslpXK58Gs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Wac6nlwhODO-2pf-GWiw-w-1; Mon, 27 Jan 2020 11:17:05 -0500
X-MC-Unique: Wac6nlwhODO-2pf-GWiw-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 230D9107ACCA;
        Mon, 27 Jan 2020 16:17:04 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.43.2.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EB0A88838;
        Mon, 27 Jan 2020 16:17:03 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH liburing 1/1] test: add epoll test case
Date:   Mon, 27 Jan 2020 17:17:01 +0100
Message-Id: <20200127161701.153625-2-sgarzare@redhat.com>
In-Reply-To: <20200127161701.153625-1-sgarzare@redhat.com>
References: <20200127161701.153625-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .gitignore    |   1 +
 test/Makefile |   5 +-
 test/epoll.c  | 307 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 311 insertions(+), 2 deletions(-)
 create mode 100644 test/epoll.c

diff --git a/.gitignore b/.gitignore
index fdb4b32..76170c9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -36,6 +36,7 @@
 /test/d77a67ed5f27-test
 /test/defer
 /test/eeed8b54e0df-test
+/test/epoll
 /test/fc2a85cb02ef-test
 /test/file-register
 /test/fixed-link
diff --git a/test/Makefile b/test/Makefile
index efdc3aa..773ba0e 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -19,7 +19,7 @@ all_targets +=3D poll poll-cancel ring-leak fsync io_ur=
ing_setup io_uring_register
 		poll-many b5837bd5311d-test accept-test d77a67ed5f27-test \
 		connect 7ad0e4b2f83c-test submit-reuse fallocate open-close \
 		file-update statx accept-reuse poll-v-poll fadvise madvise \
-		short-read openat2 probe shared-wq
+		short-read openat2 probe shared-wq epoll
=20
 include ../Makefile.quiet
=20
@@ -45,7 +45,7 @@ test_srcs :=3D poll.c poll-cancel.c ring-leak.c fsync.c=
 io_uring_setup.c \
 	b5837bd5311d-test.c accept-test.c d77a67ed5f27-test.c connect.c \
 	7ad0e4b2f83c-test.c submit-reuse.c fallocate.c open-close.c \
 	file-update.c statx.c accept-reuse.c poll-v-poll.c fadvise.c \
-	madvise.c short-read.c openat2.c probe.c shared-wq.c
+	madvise.c short-read.c openat2.c probe.c shared-wq.c epoll.c
=20
 test_objs :=3D $(patsubst %.c,%.ol,$(test_srcs))
=20
@@ -56,6 +56,7 @@ poll-link: XCFLAGS =3D -lpthread
 accept-link: XCFLAGS =3D -lpthread
 submit-reuse: XCFLAGS =3D -lpthread
 poll-v-poll: XCFLAGS =3D -lpthread
+epoll: XCFLAGS =3D -lpthread
=20
 install: $(all_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/epoll.c b/test/epoll.c
new file mode 100644
index 0000000..d082f21
--- /dev/null
+++ b/test/epoll.c
@@ -0,0 +1,307 @@
+/*
+ * Description: test io_uring poll handling using a pipe
+ *
+ *              Three threads involved:
+ *              - producer: fills SQ with write requests for the pipe
+ *              - freer: consume CQ, freeing the buffers that producer a=
llocates
+ *              - consumer: read() blocking on the pipe
+ *
+ */
+#include <errno.h>
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
+#define TIMEOUT 	2
+#define BUF_SIZE        16
+#define ITERATIONS      100
+
+struct thread_data {
+	struct io_uring *ring;
+	int pipe_read;
+	int pipe_write;
+	bool sqpoll;
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
+	vec =3D malloc(sizeof(struct iovec));
+	if (!vec) {
+		perror("malloc iovec");
+		exit(1);
+	}
+	vec->iov_base =3D malloc(BUF_SIZE);
+	if (!vec->iov_base) {
+		perror("malloc buffer");
+		exit(1);
+	}
+	vec->iov_len =3D BUF_SIZE;
+
+	return vec;
+}
+
+static void free_vec(struct iovec *vec) {
+	free(vec->iov_base);
+	free(vec);
+}
+
+static void *do_test_epoll_produce(void *data)
+{
+	struct thread_data *td =3D data;
+	struct io_uring_sqe *sqe;
+	struct epoll_event ev;
+	int fd, ret, iter =3D 0;
+	void *th_ret =3D (void *)1;
+
+	fd =3D epoll_create1(0);
+	if (fd < 0) {
+		perror("epoll_create");
+		return th_ret;
+	}
+
+	ev.events =3D EPOLLOUT;
+	ev.data.fd =3D td->ring->ring_fd;
+
+	if (epoll_ctl(fd, EPOLL_CTL_ADD, td->ring->ring_fd, &ev) < 0) {
+		perror("epoll_ctrl");
+		goto ret;
+	}
+
+	while (iter < ITERATIONS) {
+		bool submit =3D false;
+
+		ret =3D epoll_wait(fd, &ev, 1, -1);
+		if (ret < 0) {
+			perror("epoll_wait");
+			goto ret;
+		}
+
+		while (iter < ITERATIONS &&
+		       (sqe =3D io_uring_get_sqe(td->ring))) {
+			struct iovec *vec =3D alloc_vec();
+
+			io_uring_prep_writev(sqe, td->pipe_write, vec, 1, 0);
+
+			if (td->sqpoll)
+				sqe->flags |=3D IOSQE_FIXED_FILE;
+
+			io_uring_sqe_set_data(sqe, vec);
+			iter++;
+			submit =3D true;
+		}
+
+		if (!submit)
+			continue;
+
+		ret =3D io_uring_submit(td->ring);
+		if (ret <=3D 0) {
+			fprintf(stderr, "child: sqe submit failed - ret: %d\n",
+				ret);
+			goto ret;
+		}
+	}
+
+	printf("Successfully submitted %d requests\n", iter);
+
+	th_ret =3D 0;
+ret:
+	close(fd);
+	return th_ret;
+}
+
+static void *do_test_epoll_free(void *data)
+{
+	struct thread_data *td =3D data;
+	struct io_uring_cqe *cqe;
+	struct epoll_event ev;
+	int fd, ret, iter =3D 0;
+	void *th_ret =3D (void *)1;
+
+	fd =3D epoll_create1(0);
+	if (fd < 0) {
+		perror("epoll_create");
+		return th_ret;
+	}
+
+	ev.events =3D EPOLLIN;
+	ev.data.fd =3D td->ring->ring_fd;
+
+	if (epoll_ctl(fd, EPOLL_CTL_ADD, td->ring->ring_fd, &ev) < 0) {
+		perror("epoll_ctrl");
+		goto ret;
+	}
+
+	while (iter < ITERATIONS) {
+		ret =3D epoll_wait(fd, &ev, 1, -1);
+		if (ret < 0) {
+			perror("epoll_wait");
+			goto ret;
+		}
+
+		while (iter < ITERATIONS) {
+			struct iovec *vec;
+
+			ret =3D io_uring_peek_cqe(td->ring, &cqe);
+			if (ret) {
+				if (ret !=3D -EAGAIN) {
+					goto ret;
+				}
+				break;
+			}
+
+			vec =3D io_uring_cqe_get_data(cqe);
+			free_vec(vec);
+			io_uring_cqe_seen(td->ring, cqe);
+			iter++;
+		}
+	}
+
+	printf("Successfully completed %d requests\n", iter);
+
+	th_ret =3D 0;
+ret:
+	close(fd);
+	return th_ret;
+}
+
+
+static void *do_test_epoll_consume(void *data)
+{
+	struct thread_data *td =3D data;
+	static uint8_t buf[BUF_SIZE];
+	int ret, iter =3D 0;
+	void *th_ret =3D (void *)1;
+
+	while(iter < ITERATIONS) {
+		errno =3D 0;
+		ret =3D read(td->pipe_read, &buf, BUF_SIZE);
+		if (ret !=3D BUF_SIZE)
+			break;
+		iter++;
+	};
+
+	if (ret < 0) {
+		perror("read");
+		goto ret;
+	}
+
+	if (iter !=3D ITERATIONS) {
+		fprintf(stderr, "Wrong iterations: %d [expected %d]\n",
+			iter, ITERATIONS);
+		goto ret;
+	}
+
+	printf("Successfully received %d messages\n", iter);
+
+	th_ret =3D 0;
+ret:
+	return th_ret;
+}
+
+static int do_test_epoll(bool sqpoll)
+{
+	int ret, pipe1[2],flags =3D 0;
+	struct thread_data td;
+	pthread_t threads[3];
+	struct io_uring ring;
+	void *ret_th[3];
+
+	if (pipe(pipe1) !=3D 0) {
+		perror("pipe");
+		return 1;
+	}
+
+	td.sqpoll =3D sqpoll;
+	td.pipe_read =3D pipe1[0];
+	td.pipe_write =3D pipe1[1];
+
+	if (td.sqpoll)
+		flags |=3D IORING_SETUP_SQPOLL;
+
+	ret =3D io_uring_queue_init(1, &ring, flags);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+	td.ring =3D &ring;
+
+	if (td.sqpoll) {
+		ret =3D io_uring_register_files(&ring, &td.pipe_write, 1);
+		if (ret) {
+			fprintf(stderr, "file reg failed: %d\n", ret);
+			return 1;
+		}
+
+		td.pipe_write =3D 0;
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
+		return 1;
+	}
+
+	close(pipe1[0]);
+	close(pipe1[1]);
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct sigaction act;
+	int ret, no_sqthread =3D 0;
+
+	memset(&act, 0, sizeof(act));
+	act.sa_handler =3D sig_alrm;
+	act.sa_flags =3D SA_RESTART;
+	sigaction(SIGALRM, &act, NULL);
+	alarm(TIMEOUT);
+
+	if (geteuid()) {
+		no_sqthread =3D 1;
+	}
+
+	if (no_sqthread) {
+		printf("test_epoll_sqpoll: skipped, not root\n");
+	} else {
+		ret =3D do_test_epoll(true);
+		if (ret) {
+			fprintf(stderr, "test_epoll_sqpoll failed\n");
+			return ret;
+		}
+	}
+
+	ret =3D do_test_epoll(false);
+	if (ret) {
+		fprintf(stderr, "test_epoll failed\n");
+		return ret;
+	}
+
+	return 0;
+}
--=20
2.24.1

