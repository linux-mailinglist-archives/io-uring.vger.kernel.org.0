Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3725D3F9CA5
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 18:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhH0Qj6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 12:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhH0Qj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 12:39:57 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626A7C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 09:39:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id u9so11315079wrg.8
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 09:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7etz9J+QibHgTfKpUyBhkNA2wDLQUNS9sVvfhn0L4kg=;
        b=CuPBHK6pWd7P5CGwE0JFQBH8zWxk7mbYUXqJWP0LLMsK+K3L/kcIdZCtETQ4quL0El
         aFopJe3RyNLGWcTJ/Qu0Wng2eo+fZzZY4DgO0lfzAKP49FMRasP5op8i3IbBssGYUtCH
         q9szsrRHhZd/aXE2n/rh/GrJzCq4CPkgaMXSlRHeJbzLxwKeBGihk3ihXG0cJE02TQTM
         CmmpZpevdpdPIQd3xtdVyxj/m/7J8dI3TYOlogVtBDNwmJS3BBxrtkrQ1MxH92ZdYKHS
         Z9H1adrFdupdTBal8asGkhE7EjotGi9F8wDzpsTcEFFfwBYqSvqliIUksvxuzkLQx731
         LPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7etz9J+QibHgTfKpUyBhkNA2wDLQUNS9sVvfhn0L4kg=;
        b=GWIwgqEZl7MbW5/GeFwNXLsW0k8ZwhdOIYVYDihkb8e7pVlGtHps0f5tqkFRJudUKC
         qN5iG+KKoVAoptZVFbJGW8tyEwTrkMWkBoOSueHLQITOHif4gId3hP5iIXogQhCFXw/g
         1AP7Zme4y3wlXLqj7yy/FOXB4SPPUtW72Mje365f7lo7gs4lwfmZ1N5EGCu2CK+RBTEG
         UKOeJRodWnNIOtHkVoxRFoHO486dLmMFvU+vtzhCeCzPg0RJGeBiOuulYVjLQqUAZvNp
         T3dCydAQQ/9vVf6chqmi4e6a9FfBcDg2AOaan6qJFkHtiyP8JEbIHK5QTCXDphDEuCY8
         w6Cg==
X-Gm-Message-State: AOAM531qckKRTS1hxFKhhUVCV0pmCZ16bU0oTcCJdhOAnYDXwhud/qca
        AZqtNeUdE6qaC4eat3VM6WnGqqVnXj8=
X-Google-Smtp-Source: ABdhPJykJnzUNYg9L6VgOQ0BI+EbHL6+ONKPJY3LDraEfKUYb/hUfYTPc16qzgqiIJxXbk/+mH5HoA==
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr11279782wrp.381.1630082346939;
        Fri, 27 Aug 2021 09:39:06 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id a77sm12075180wmd.31.2021.08.27.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:39:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: file create/unlink cleanup
Date:   Fri, 27 Aug 2021 17:38:23 +0100
Message-Id: <abbcfa9fa56fde7e740a2c887afef74a779bf36f.1630082134.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unlink earlier if possible right after getting an fd, so tests don't
leave files when exited abnormally. Also, improve test file naming in a
couple of cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/cq-overflow.c       | 13 +++++++------
 test/d4ae271dfaae-test.c |  4 ++--
 test/eeed8b54e0df-test.c | 11 +++--------
 test/fallocate.c         |  9 +++------
 test/fsync.c             |  4 ++--
 test/io-cancel.c         |  9 +++++----
 test/link_drain.c        |  3 +--
 test/read-write.c        |  2 +-
 test/sq-poll-dup.c       |  7 +++----
 test/sq-poll-share.c     |  6 ++----
 test/submit-reuse.c      | 25 +++++++++++--------------
 test/thread-exit.c       | 10 +++-------
 12 files changed, 43 insertions(+), 60 deletions(-)

diff --git a/test/cq-overflow.c b/test/cq-overflow.c
index 945dc93..057570e 100644
--- a/test/cq-overflow.c
+++ b/test/cq-overflow.c
@@ -243,6 +243,7 @@ err:
 
 int main(int argc, char *argv[])
 {
+	const char *fname = ".cq-overflow";
 	unsigned iters, drops;
 	unsigned long usecs;
 	int ret;
@@ -256,7 +257,7 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	t_create_file(".basic-rw", FILE_SIZE);
+	t_create_file(fname, FILE_SIZE);
 
 	vecs = t_create_buffers(BUFFERS, BS);
 
@@ -265,7 +266,7 @@ int main(int argc, char *argv[])
 	do {
 		drops = 0;
 
-		if (test_io(".basic-rw", usecs, &drops, 0)) {
+		if (test_io(fname, usecs, &drops, 0)) {
 			fprintf(stderr, "test_io nofault failed\n");
 			goto err;
 		}
@@ -275,19 +276,19 @@ int main(int argc, char *argv[])
 		iters++;
 	} while (iters < 40);
 
-	if (test_io(".basic-rw", usecs, &drops, 0)) {
+	if (test_io(fname, usecs, &drops, 0)) {
 		fprintf(stderr, "test_io nofault failed\n");
 		goto err;
 	}
 
-	if (test_io(".basic-rw", usecs, &drops, 1)) {
+	if (test_io(fname, usecs, &drops, 1)) {
 		fprintf(stderr, "test_io fault failed\n");
 		goto err;
 	}
 
-	unlink(".basic-rw");
+	unlink(fname);
 	return 0;
 err:
-	unlink(".basic-rw");
+	unlink(fname);
 	return 1;
 }
diff --git a/test/d4ae271dfaae-test.c b/test/d4ae271dfaae-test.c
index 10c7e98..397b94b 100644
--- a/test/d4ae271dfaae-test.c
+++ b/test/d4ae271dfaae-test.c
@@ -43,6 +43,8 @@ int main(int argc, char *argv[])
 	}
 
 	fd = open(fname, O_RDONLY | O_DIRECT);
+	if (fname != argv[1])
+		unlink(fname);
 	if (fd < 0) {
 		perror("open");
 		goto out;
@@ -89,8 +91,6 @@ int main(int argc, char *argv[])
 
 	close(fd);
 out:
-	if (fname != argv[1])
-		unlink(fname);
 	io_uring_queue_exit(&ring);
 	return ret;
 }
diff --git a/test/eeed8b54e0df-test.c b/test/eeed8b54e0df-test.c
index b6e27cc..62f6f45 100644
--- a/test/eeed8b54e0df-test.c
+++ b/test/eeed8b54e0df-test.c
@@ -26,6 +26,7 @@ static int get_file_fd(void)
 	int fd;
 
 	fd = open("testfile", O_RDWR | O_CREAT, 0644);
+	unlink("testfile");
 	if (fd < 0) {
 		perror("open file");
 		return -1;
@@ -54,12 +55,6 @@ err:
 	return fd;
 }
 
-static void put_file_fd(int fd)
-{
-	close(fd);
-	unlink("testfile");
-}
-
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -111,9 +106,9 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
-	put_file_fd(fd);
+	close(fd);
 	return 0;
 err:
-	put_file_fd(fd);
+	close(fd);
 	return 1;
 }
diff --git a/test/fallocate.c b/test/fallocate.c
index da90be8..ddb53a6 100644
--- a/test/fallocate.c
+++ b/test/fallocate.c
@@ -42,6 +42,7 @@ static int test_fallocate_rlimit(struct io_uring *ring)
 		perror("open");
 		return 1;
 	}
+	unlink(buf);
 
 	sqe = io_uring_get_sqe(ring);
 	if (!sqe) {
@@ -72,10 +73,8 @@ static int test_fallocate_rlimit(struct io_uring *ring)
 	}
 	io_uring_cqe_seen(ring, cqe);
 out:
-	unlink(buf);
 	return 0;
 err:
-	unlink(buf);
 	return 1;
 }
 
@@ -93,6 +92,7 @@ static int test_fallocate(struct io_uring *ring)
 		perror("open");
 		return 1;
 	}
+	unlink(buf);
 
 	sqe = io_uring_get_sqe(ring);
 	if (!sqe) {
@@ -136,10 +136,8 @@ static int test_fallocate(struct io_uring *ring)
 	}
 
 out:
-	unlink(buf);
 	return 0;
 err:
-	unlink(buf);
 	return 1;
 }
 
@@ -160,6 +158,7 @@ static int test_fallocate_fsync(struct io_uring *ring)
 		perror("open");
 		return 1;
 	}
+	unlink(buf);
 
 	sqe = io_uring_get_sqe(ring);
 	if (!sqe) {
@@ -209,10 +208,8 @@ static int test_fallocate_fsync(struct io_uring *ring)
 		goto err;
 	}
 
-	unlink(buf);
 	return 0;
 err:
-	unlink(buf);
 	return 1;
 }
 
diff --git a/test/fsync.c b/test/fsync.c
index 8454398..5ae8441 100644
--- a/test/fsync.c
+++ b/test/fsync.c
@@ -63,11 +63,12 @@ static int test_barrier_fsync(struct io_uring *ring)
 	int i, fd, ret;
 	off_t off;
 
-	fd = open("testfile", O_WRONLY | O_CREAT, 0644);
+	fd = open("fsync-testfile", O_WRONLY | O_CREAT, 0644);
 	if (fd < 0) {
 		perror("open");
 		return 1;
 	}
+	unlink("fsync-testfile");
 
 	for (i = 0; i < ARRAY_SIZE(iovecs); i++) {
 		iovecs[i].iov_base = t_malloc(4096);
@@ -135,7 +136,6 @@ static int test_barrier_fsync(struct io_uring *ring)
 err:
 	ret = 1;
 out:
-	unlink("testfile");
 	for (i = 0; i < ARRAY_SIZE(iovecs); i++)
 		free(iovecs[i].iov_base);
 	return ret;
diff --git a/test/io-cancel.c b/test/io-cancel.c
index 63d2f7d..b5b443d 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -486,6 +486,7 @@ static int test_sqpoll_cancel_iowq_requests(void)
 
 int main(int argc, char *argv[])
 {
+	const char *fname = ".io-cancel-test";
 	int i, ret;
 
 	if (argc > 1)
@@ -511,7 +512,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	t_create_file(".basic-rw", FILE_SIZE);
+	t_create_file(fname, FILE_SIZE);
 
 	vecs = t_create_buffers(BUFFERS, BS);
 
@@ -520,7 +521,7 @@ int main(int argc, char *argv[])
 		int partial = (i & 2) != 0;
 		int async = (i & 4) != 0;
 
-		ret = test_io_cancel(".basic-rw", write, partial, async);
+		ret = test_io_cancel(fname, write, partial, async);
 		if (ret) {
 			fprintf(stderr, "test_io_cancel %d %d %d failed\n",
 				write, partial, async);
@@ -528,9 +529,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	unlink(".basic-rw");
+	unlink(fname);
 	return 0;
 err:
-	unlink(".basic-rw");
+	unlink(fname);
 	return 1;
 }
diff --git a/test/link_drain.c b/test/link_drain.c
index a50fe88..b95168d 100644
--- a/test/link_drain.c
+++ b/test/link_drain.c
@@ -111,6 +111,7 @@ int test_link_drain_multi(struct io_uring *ring)
 		perror("open");
 		return 1;
 	}
+	unlink("testfile");
 
 	iovecs.iov_base = t_malloc(4096);
 	iovecs.iov_len = 4096;
@@ -189,12 +190,10 @@ int test_link_drain_multi(struct io_uring *ring)
 
 	free(iovecs.iov_base);
 	close(fd);
-	unlink("testfile");
 	return 0;
 err:
 	free(iovecs.iov_base);
 	close(fd);
-	unlink("testfile");
 	return 1;
 
 }
diff --git a/test/read-write.c b/test/read-write.c
index 0c55159..885905b 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -670,6 +670,7 @@ static int test_write_efbig(void)
 		perror("file open");
 		goto err;
 	}
+	unlink(".efbig");
 
 	ret = io_uring_queue_init(32, &ring, 0);
 	if (ret) {
@@ -726,7 +727,6 @@ static int test_write_efbig(void)
 err:
 	if (fd != -1)
 		close(fd);
-	unlink(".efbig");
 	return 1;
 }
 
diff --git a/test/sq-poll-dup.c b/test/sq-poll-dup.c
index eeb619c..e688c9f 100644
--- a/test/sq-poll-dup.c
+++ b/test/sq-poll-dup.c
@@ -167,6 +167,9 @@ int main(int argc, char *argv[])
 	vecs = t_create_buffers(BUFFERS, BS);
 
 	fd = open(fname, O_RDONLY | O_DIRECT);
+	if (fname != argv[1])
+		unlink(fname);
+
 	if (fd < 0) {
 		perror("open");
 		return -1;
@@ -191,11 +194,7 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
-	if (fname != argv[1])
-		unlink(fname);
 	return 0;
 err:
-	if (fname != argv[1])
-		unlink(fname);
 	return 1;
 }
diff --git a/test/sq-poll-share.c b/test/sq-poll-share.c
index a46b94f..99227d5 100644
--- a/test/sq-poll-share.c
+++ b/test/sq-poll-share.c
@@ -89,6 +89,8 @@ int main(int argc, char *argv[])
 	vecs = t_create_buffers(BUFFERS, BS);
 
 	fd = open(fname, O_RDONLY | O_DIRECT);
+	if (fname != argv[1])
+		unlink(fname);
 	if (fd < 0) {
 		perror("open");
 		return -1;
@@ -129,11 +131,7 @@ int main(int argc, char *argv[])
 		ios += BUFFERS;
 	}
 
-	if (fname != argv[1])
-		unlink(fname);
 	return 0;
 err:
-	if (fname != argv[1])
-		unlink(fname);
 	return 1;
 }
diff --git a/test/submit-reuse.c b/test/submit-reuse.c
index 74ba769..ca30e98 100644
--- a/test/submit-reuse.c
+++ b/test/submit-reuse.c
@@ -140,11 +140,6 @@ static int test_reuse(int argc, char *argv[], int split, int async)
 	int do_unlink = 1;
 	void *tret;
 
-	if (argc > 1) {
-		fname1 = argv[1];
-		do_unlink = 0;
-	}
-
 	ret = io_uring_queue_init_params(32, &ring, &p);
 	if (ret) {
 		fprintf(stderr, "io_uring_queue_init: %d\n", ret);
@@ -153,21 +148,29 @@ static int test_reuse(int argc, char *argv[], int split, int async)
 
 	if (!(p.features & IORING_FEAT_SUBMIT_STABLE)) {
 		fprintf(stdout, "FEAT_SUBMIT_STABLE not there, skipping\n");
+		io_uring_queue_exit(&ring);
 		no_stable = 1;
 		return 0;
 	}
 
-	if (do_unlink)
+	if (argc > 1) {
+		fname1 = argv[1];
+		do_unlink = 0;
+	} else {
 		t_create_file(fname1, FILE_SIZE);
-
-	t_create_file(".reuse.2", FILE_SIZE);
+	}
 
 	fd1 = open(fname1, O_RDONLY);
+	if (do_unlink)
+		unlink(fname1);
 	if (fd1 < 0) {
 		perror("open fname1");
 		goto err;
 	}
+
+	t_create_file(".reuse.2", FILE_SIZE);
 	fd2 = open(".reuse.2", O_RDONLY);
+	unlink(".reuse.2");
 	if (fd2 < 0) {
 		perror("open .reuse.2");
 		goto err;
@@ -206,15 +209,9 @@ static int test_reuse(int argc, char *argv[], int split, int async)
 	close(fd2);
 	close(fd1);
 	io_uring_queue_exit(&ring);
-	if (do_unlink)
-		unlink(fname1);
-	unlink(".reuse.2");
 	return 0;
 err:
 	io_uring_queue_exit(&ring);
-	if (do_unlink)
-		unlink(fname1);
-	unlink(".reuse.2");
 	return 1;
 
 }
diff --git a/test/thread-exit.c b/test/thread-exit.c
index c2f2148..7f66028 100644
--- a/test/thread-exit.c
+++ b/test/thread-exit.c
@@ -86,12 +86,12 @@ int main(int argc, char *argv[])
 	} else {
 		fname = ".thread.exit";
 		do_unlink = 1;
-	}
-
-	if (do_unlink)
 		t_create_file(fname, 4096);
+	}
 
 	fd = open(fname, O_WRONLY);
+	if (do_unlink)
+		unlink(fname);
 	if (fd < 0) {
 		perror("open");
 		return 1;
@@ -125,11 +125,7 @@ int main(int argc, char *argv[])
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
-	if (do_unlink)
-		unlink(fname);
 	return d.err;
 err:
-	if (do_unlink)
-		unlink(fname);
 	return 1;
 }
-- 
2.33.0

