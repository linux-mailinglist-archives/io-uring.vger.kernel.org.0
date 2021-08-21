Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982EB3F3B48
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhHUPzM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 11:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbhHUPzM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 11:55:12 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9836C061575
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 08:54:32 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h13so18792437wrp.1
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 08:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yGWty/PQoMaIx7vt2Q6QfZkV9HCQJfMgUtOhZYx9FMc=;
        b=D9kxxZhZVomcpW1sg15gZg9JPaiO1edNKyF2Isn2mwRcBU4AGsyQqhXlNfyxQsnkL3
         mv13CyNCITO2vlz77zYAW3H76li8ZMnD4tWO2lx6HZcE7rsHzyups/e1MKoY/5KSKe2S
         2twi0eBk0hd4iHKhN7/UWnrnhXAzvbSOBT4ML8vqwsyWRD3E8N1hhUKracLm1CIW6lfw
         7gvOaIZZXSEQnS4EP8x0uF47+L8cUQodRGXuD2PRCxwEREp7Z+IoLXGQVeZPJ0SaAvU0
         xCMUp6oBGQMvsvB648SUQQzz3ZkX9FcjdzAYlubTy3HkKKIDlYJcSUZ1l7v9DajCRBFW
         Jxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yGWty/PQoMaIx7vt2Q6QfZkV9HCQJfMgUtOhZYx9FMc=;
        b=DO3O1KzhtwKKkifDW/Out9FyNEC+W3l9grhaeslsvvu1OQI1xinalrsstFwivs/NoJ
         FWYS7uEX59uhOJ4xRg3OdMNkNKsncenHUraXnuxYOwI7p5XUDnnUWDztZqOikhYTL1Q1
         3yeYlEJdiH4ufDFa7HC3HCp+NgZ5FDoRL9LzET29FjTF54+t4O0Z+Fx7qj46hyjMB1J6
         99kpQdBO2Tr2Oa2sCYnMbVzdlNSk7E9HfKVfJ6BLfz1ZcPsm/LZ27qrOhZDCptBcG8Ue
         GvNgEydgtNDc6LQfYVm9nHc9NhMAgoJObLcJ/M9qay1MxbnUT7Gn0g4Ca/lbQnaDuAPg
         KCSw==
X-Gm-Message-State: AOAM5327XHGg9tfpEGx87xFRKUSzeLI/voZxufA7I6amPdSPaK/B1/fy
        IIALyrLTSZYKlwkMRt1/iwF2GCETD1U=
X-Google-Smtp-Source: ABdhPJwvooIkCRAe6kWLDibOEtTmWvoZ9fQ4aGAQI+a9QAIC6mPcaEvVJbaCt2+g2H8mL9btivusLw==
X-Received: by 2002:adf:8169:: with SMTP id 96mr2822462wrm.207.1629561271404;
        Sat, 21 Aug 2021 08:54:31 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id s13sm13451959wmc.47.2021.08.21.08.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 08:54:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH liburing 1/1] tests: test open/accept directly into fixed table
Date:   Sat, 21 Aug 2021 16:53:53 +0100
Message-Id: <e4326cd1629f9f3c5db3aee7cd976d99df18aff9.1629560358.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test a new feature allowing to open/accept directly into io_uring's
fixed table bypassing normal fdtable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/accept.c  |  74 ++++++++++++++++++------
 test/openat2.c | 152 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 199 insertions(+), 27 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index f096f8a..41caa48 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -39,9 +39,10 @@ static void queue_send(struct io_uring *ring, int fd)
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_writev(sqe, fd, &d->iov, 1, 0);
+	sqe->user_data = 1;
 }
 
-static void queue_recv(struct io_uring *ring, int fd)
+static void queue_recv(struct io_uring *ring, int fd, bool fixed)
 {
 	struct io_uring_sqe *sqe;
 	struct data *d;
@@ -52,16 +53,21 @@ static void queue_recv(struct io_uring *ring, int fd)
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_readv(sqe, fd, &d->iov, 1, 0);
+	sqe->user_data = 2;
+	if (fixed)
+		sqe->flags |= IOSQE_FIXED_FILE;
 }
 
-static int accept_conn(struct io_uring *ring, int fd)
+static int accept_conn(struct io_uring *ring, int fd, bool fixed)
 {
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
-	int ret;
+	int ret, fixed_idx = 0;
 
 	sqe = io_uring_get_sqe(ring);
 	io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+	if (fixed)
+		sqe->splice_fd_in = fixed_idx + 1;
 
 	ret = io_uring_submit(ring);
 	assert(ret != -1);
@@ -70,6 +76,15 @@ static int accept_conn(struct io_uring *ring, int fd)
 	assert(!ret);
 	ret = cqe->res;
 	io_uring_cqe_seen(ring, cqe);
+
+	if (fixed) {
+		if (ret > 0) {
+			close(ret);
+			return -EINVAL;
+		} else if (!ret) {
+			ret = fixed_idx;
+		}
+	}
 	return ret;
 }
 
@@ -102,15 +117,12 @@ static int start_accept_listen(struct sockaddr_in *addr, int port_off)
 	return fd;
 }
 
-static int test(struct io_uring *ring, int accept_should_error)
+static int test(struct io_uring *ring, int accept_should_error, bool fixed)
 {
 	struct io_uring_cqe *cqe;
 	struct sockaddr_in addr;
-	uint32_t head;
-	uint32_t count = 0;
-	int done = 0;
-	int p_fd[2];
-        int ret;
+	uint32_t head, count = 0;
+	int ret, p_fd[2], done = 0;
 
 	int32_t val, recv_s0 = start_accept_listen(&addr, 0);
 
@@ -137,11 +149,14 @@ static int test(struct io_uring *ring, int accept_should_error)
 	ret = fcntl(p_fd[1], F_SETFL, flags);
 	assert(ret != -1);
 
-	p_fd[0] = accept_conn(ring, recv_s0);
+	p_fd[0] = accept_conn(ring, recv_s0, fixed);
 	if (p_fd[0] == -EINVAL) {
 		if (accept_should_error)
 			goto out;
-		fprintf(stdout, "Accept not supported, skipping\n");
+		if (fixed)
+			fprintf(stdout, "Fixed accept not supported, skipping\n");
+		else
+			fprintf(stdout, "Accept not supported, skipping\n");
 		no_accept = 1;
 		goto out;
 	} else if (p_fd[0] < 0) {
@@ -153,7 +168,7 @@ static int test(struct io_uring *ring, int accept_should_error)
 	}
 
 	queue_send(ring, p_fd[1]);
-	queue_recv(ring, p_fd[0]);
+	queue_recv(ring, p_fd[0], fixed);
 
 	ret = io_uring_submit_and_wait(ring, 2);
 	assert(ret != -1);
@@ -161,7 +176,8 @@ static int test(struct io_uring *ring, int accept_should_error)
 	while (count < 2) {
 		io_uring_for_each_cqe(ring, head, cqe) {
 			if (cqe->res < 0) {
-				fprintf(stderr, "Got cqe res %d\n", cqe->res);
+				fprintf(stderr, "Got cqe res %d, user_data %i\n",
+						cqe->res, (int)cqe->user_data);
 				done = 1;
 				break;
 			}
@@ -176,12 +192,14 @@ static int test(struct io_uring *ring, int accept_should_error)
 	}
 
 out:
-	close(p_fd[0]);
+	if (!fixed)
+		close(p_fd[0]);
 	close(p_fd[1]);
 	close(recv_s0);
 	return 0;
 err:
-	close(p_fd[0]);
+	if (!fixed)
+		close(p_fd[0]);
 	close(p_fd[1]);
 	close(recv_s0);
 	return 1;
@@ -302,7 +320,7 @@ static int test_accept_cancel(unsigned usecs)
 	sqe = io_uring_get_sqe(&m_io_uring);
 	io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
 	sqe->user_data = 1;
-        ret = io_uring_submit(&m_io_uring);
+	ret = io_uring_submit(&m_io_uring);
 	assert(ret == 1);
 
 	if (usecs)
@@ -355,7 +373,21 @@ static int test_accept(void)
 
 	ret = io_uring_queue_init(32, &m_io_uring, 0);
 	assert(ret >= 0);
-	ret = test(&m_io_uring, 0);
+	ret = test(&m_io_uring, 0, false);
+	io_uring_queue_exit(&m_io_uring);
+	return ret;
+}
+
+static int test_accept_fixed(void)
+{
+	struct io_uring m_io_uring;
+	int ret, fd = -1;
+
+	ret = io_uring_queue_init(32, &m_io_uring, 0);
+	assert(ret >= 0);
+	ret = io_uring_register_files(&m_io_uring, &fd, 1);
+	assert(ret == 0);
+	ret = test(&m_io_uring, 0, true);
 	io_uring_queue_exit(&m_io_uring);
 	return ret;
 }
@@ -377,7 +409,7 @@ static int test_accept_sqpoll(void)
 	if (p.features & IORING_FEAT_SQPOLL_NONFIXED)
 		should_fail = 0;
 
-	ret = test(&m_io_uring, should_fail);
+	ret = test(&m_io_uring, should_fail, false);
 	io_uring_queue_exit(&m_io_uring);
 	return ret;
 }
@@ -397,6 +429,12 @@ int main(int argc, char *argv[])
 	if (no_accept)
 		return 0;
 
+	ret = test_accept_fixed();
+	if (ret) {
+		fprintf(stderr, "test_accept_fixed failed\n");
+		return ret;
+	}
+
 	ret = test_accept_sqpoll();
 	if (ret) {
 		fprintf(stderr, "test_accept_sqpoll failed\n");
diff --git a/test/openat2.c b/test/openat2.c
index 65f81b1..8964208 100644
--- a/test/openat2.c
+++ b/test/openat2.c
@@ -13,7 +13,8 @@
 #include "helpers.h"
 #include "liburing.h"
 
-static int test_openat2(struct io_uring *ring, const char *path, int dfd)
+static int test_openat2(struct io_uring *ring, const char *path, int dfd,
+			int fixed_slot)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -23,30 +24,151 @@ static int test_openat2(struct io_uring *ring, const char *path, int dfd)
 	sqe = io_uring_get_sqe(ring);
 	if (!sqe) {
 		fprintf(stderr, "get sqe failed\n");
-		goto err;
+		return -1;
 	}
 	memset(&how, 0, sizeof(how));
-	how.flags = O_RDONLY;
+	how.flags = O_RDWR;
 	io_uring_prep_openat2(sqe, dfd, path, &how);
+	sqe->splice_fd_in = fixed_slot;
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
 		fprintf(stderr, "sqe submit failed: %d\n", ret);
-		goto err;
+		return -1;
 	}
 
 	ret = io_uring_wait_cqe(ring, &cqe);
 	if (ret < 0) {
 		fprintf(stderr, "wait completion %d\n", ret);
-		goto err;
+		return -1;
 	}
 	ret = cqe->res;
 	io_uring_cqe_seen(ring, cqe);
+
+	if (fixed_slot && ret > 0) {
+		close(ret);
+		return -EINVAL;
+	}
 	return ret;
-err:
-	return -1;
 }
 
+static int test_open_fixed(const char *path, int dfd)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	const char pattern = 0xac;
+	char buffer[] = { 0, 0 };
+	int i, ret, fd = -1;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return -1;
+	}
+	ret = io_uring_register_files(&ring, &fd, 1);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		return -1;
+	}
+
+	ret = test_openat2(&ring, path, dfd, 1);
+	if (ret == -EINVAL) {
+		printf("fixed open isn't supported\n");
+		return 1;
+	} else if (ret) {
+		fprintf(stderr, "direct open failed %d\n", ret);
+		return -1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_write(sqe, 0, &pattern, 1, 0);
+	sqe->user_data = 1;
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read(sqe, 0, buffer, 1, 0);
+	sqe->user_data = 2;
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 2) {
+		fprintf(stderr, "%s: got %d, wanted 2\n", __FUNCTION__, ret);
+		return -1;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "wait completion %d\n", ret);
+			return -1;
+		}
+		if (cqe->res != 1) {
+			fprintf(stderr, "unexpectetd ret %d\n", cqe->res);
+			return -1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+	if (memcmp(&pattern, buffer, 1) != 0) {
+		fprintf(stderr, "buf validation failed\n");
+		return -1;
+	}
+
+	ret = test_openat2(&ring, path, dfd, 1);
+	if (ret != -EBADF) {
+		fprintf(stderr, "bogus double register %d\n", ret);
+		return -1;
+	}
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int test_open_fixed_fail(const char *path, int dfd)
+{
+	struct io_uring ring;
+	int ret, fd = -1;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return -1;
+	}
+
+	ret = test_openat2(&ring, path, dfd, 1);
+	if (ret != -ENXIO) {
+		fprintf(stderr, "install into not existing table, %i\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_files(&ring, &fd, 1);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		return -1;
+	}
+
+	ret = test_openat2(&ring, path, dfd, 2);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "install out of bounds, %i\n", ret);
+		return 1;
+	}
+
+	ret = test_openat2(&ring, path, dfd, (1u << 16));
+	if (ret != -EINVAL) {
+		fprintf(stderr, "install out of bounds or u16 overflow, %i\n", ret);
+		return 1;
+	}
+
+	ret = test_openat2(&ring, path, dfd, (1u << 16) + 1);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "install out of bounds or u16 overflow, %i\n", ret);
+		return 1;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -74,7 +196,7 @@ int main(int argc, char *argv[])
 	if (do_unlink)
 		t_create_file(path_rel, 4096);
 
-	ret = test_openat2(&ring, path, -1);
+	ret = test_openat2(&ring, path, -1, 0);
 	if (ret < 0) {
 		if (ret == -EINVAL) {
 			fprintf(stdout, "openat2 not supported, skipping\n");
@@ -84,12 +206,24 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
-	ret = test_openat2(&ring, path_rel, AT_FDCWD);
+	ret = test_openat2(&ring, path_rel, AT_FDCWD, 0);
 	if (ret < 0) {
 		fprintf(stderr, "test_openat2 relative failed: %d\n", ret);
 		goto err;
 	}
 
+	ret = test_open_fixed(path, -1);
+	if (ret > 0)
+		goto done;
+	if (ret) {
+		fprintf(stderr, "test_open_fixed failed\n");
+		goto err;
+	}
+	ret = test_open_fixed_fail(path, -1);
+	if (ret) {
+		fprintf(stderr, "test_open_fixed_fail failed\n");
+		goto err;
+	}
 done:
 	unlink(path);
 	if (do_unlink)
-- 
2.32.0

