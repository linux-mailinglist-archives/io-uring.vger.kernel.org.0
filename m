Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A7726FAE4
	for <lists+io-uring@lfdr.de>; Fri, 18 Sep 2020 12:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIRKsE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Sep 2020 06:48:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23562 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726321AbgIRKry (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Sep 2020 06:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600426072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVI7z/gyWxuNU9lmFuHevz3YnhD3EBddziQPb3Cdghg=;
        b=TUm9b1JeElz0Sz+KWlVlaPGELgPYxOb4hvNz5yR4WGZy/U3lCW7Rlhwwxv1r9DGcXx1Tqa
        OPXK/LAI72C12UoKZb05HIyGGZNmATMckC42PW3hA4WhK9Ey+Ti6+DVwq1KE2DhRlMPnRE
        twAd3i4fDsY4RBt5hfN3wIbjbvmIaG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-rFmYyvX6Mr2BO4l08fO4nA-1; Fri, 18 Sep 2020 06:47:50 -0400
X-MC-Unique: rFmYyvX6Mr2BO4l08fO4nA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57FBD1084CA3
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98CBE3782
        for <io-uring@vger.kernel.org>; Fri, 18 Sep 2020 10:47:48 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH 2/5] test: make a distinction between successful and skipped test
Date:   Fri, 18 Sep 2020 12:47:43 +0200
Message-Id: <20200918104746.146747-2-lczerner@redhat.com>
In-Reply-To: <20200918104746.146747-1-lczerner@redhat.com>
References: <20200918104746.146747-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently when the test is skipped, it just returns zero and the test
will be assumed to have been successful so the only way to know
which tests were actually skipped is to search the output and inspect
the code.

Change the tests to return -1 in the case that the entire test
is skipped. Some of the tests are exercising multiple features some of
which may not be available and hence can be skipped - I am not
changing those for now. The rule for the test to be marked as skipped
is that nothing meaningful was actually tested with regards to liburing.

One exception are tests that don't run anything if test file is
provided. I am not sure if it's usefull to mark them as skipped so I am
leaving the original behavior for now.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 test/500f9fbadef8-test.c     |  2 +-
 test/accept-link.c           |  6 ++++--
 test/accept-reuse.c          |  2 +-
 test/accept.c                |  2 +-
 test/cq-overflow-peek.c      |  8 +++++---
 test/cq-size.c               |  3 +--
 test/d4ae271dfaae-test.c     |  2 +-
 test/d77a67ed5f27-test.c     |  2 +-
 test/eventfd-disable.c       |  2 +-
 test/eventfd-ring.c          |  2 +-
 test/eventfd.c               |  2 +-
 test/fadvise.c               |  2 +-
 test/fallocate.c             |  7 ++++---
 test/fc2a85cb02ef-test.c     |  2 +-
 test/madvise.c               |  2 +-
 test/open-close.c            | 25 ++++++++++++-------------
 test/openat2.c               | 19 ++++++++-----------
 test/personality.c           |  4 ++--
 test/poll-link.c             |  8 ++++++--
 test/poll-many.c             |  6 +++---
 test/probe.c                 |  2 +-
 test/register-restrictions.c |  2 +-
 test/runtests.sh             |  5 ++++-
 test/send_recvmsg.c          |  1 -
 test/shared-wq.c             |  5 +++--
 test/shutdown.c              |  6 ++++--
 test/splice.c                |  3 +++
 test/sq-poll-dup.c           |  5 +++++
 test/sq-poll-kthread.c       |  2 ++
 test/sq-poll-share.c         |  2 +-
 test/statx.c                 | 19 +++++++++----------
 test/timeout-overflow.c      |  2 +-
 32 files changed, 90 insertions(+), 72 deletions(-)

diff --git a/test/500f9fbadef8-test.c b/test/500f9fbadef8-test.c
index 9ebff43..d3cdb66 100644
--- a/test/500f9fbadef8-test.c
+++ b/test/500f9fbadef8-test.c
@@ -87,5 +87,5 @@ skipped:
 	fprintf(stderr, "Polling not supported in current dir, test skipped\n");
 	close(fd);
 	unlink(buf);
-	return 0;
+	return -1;
 }
diff --git a/test/accept-link.c b/test/accept-link.c
index 7e4df48..c30bb3b 100644
--- a/test/accept-link.c
+++ b/test/accept-link.c
@@ -105,7 +105,7 @@ void *recv_thread(void *arg)
 		printf("Can't find good port, skipped\n");
 		data->stop = 1;
 		signal_var(&recv_thread_ready);
-		goto out;
+		goto skip;
 	}
 
         assert(listen(s0, 128) != -1);
@@ -158,12 +158,14 @@ ok:
 
 	signal_var(&recv_thread_done);
 
-out:
 	close(s0);
 	return NULL;
 err:
 	close(s0);
 	return (void *) 1;
+skip:
+	close(s0);
+	return (void *) -1;
 }
 
 static int test_accept_timeout(int do_connect, unsigned long timeout)
diff --git a/test/accept-reuse.c b/test/accept-reuse.c
index 59a2f79..1f2249f 100644
--- a/test/accept-reuse.c
+++ b/test/accept-reuse.c
@@ -55,7 +55,7 @@ int main(int argc, char **argv)
 	}
 	if (!(params.features & IORING_FEAT_SUBMIT_STABLE)) {
 		fprintf(stdout, "FEAT_SUBMIT_STABLE not there, skipping\n");
-		return 0;
+		return -1;
 	}
 
 	memset(&hints, 0, sizeof(hints));
diff --git a/test/accept.c b/test/accept.c
index faf81d6..24834f9 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -373,7 +373,7 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 	if (no_accept)
-		return 0;
+		return -1;
 
 	ret = test_accept_sqpoll();
 	if (ret) {
diff --git a/test/cq-overflow-peek.c b/test/cq-overflow-peek.c
index 72b6768..9fc1dea 100644
--- a/test/cq-overflow-peek.c
+++ b/test/cq-overflow-peek.c
@@ -35,7 +35,7 @@ static int test_cq_overflow(struct io_uring *ring)
 	flags = IO_URING_READ_ONCE(*ring->sq.kflags);
 	if (!(flags & IORING_SQ_CQ_OVERFLOW)) {
 		fprintf(stdout, "OVERFLOW not set on -EBUSY, skipping\n");
-		goto done;
+		goto skip;
 	}
 
 	while (issued) {
@@ -52,10 +52,11 @@ static int test_cq_overflow(struct io_uring *ring)
 		issued--;
 	}
 
-done:
 	return 0;
 err:
 	return 1;
+skip:
+	return -1;
 }
 
 int main(int argc, char *argv[])
@@ -74,7 +75,8 @@ int main(int argc, char *argv[])
 
 	ret = test_cq_overflow(&ring);
 	if (ret) {
-		fprintf(stderr, "test_cq_overflow failed\n");
+		if (ret != -1)
+			fprintf(stderr, "test_cq_overflow failed\n");
 		return 1;
 	}
 
diff --git a/test/cq-size.c b/test/cq-size.c
index b7dd5b4..184626a 100644
--- a/test/cq-size.c
+++ b/test/cq-size.c
@@ -28,7 +28,7 @@ int main(int argc, char *argv[])
 	if (ret) {
 		if (ret == -EINVAL) {
 			printf("Skipped, not supported on this kernel\n");
-			goto done;
+			return -1;
 		}
 		printf("ring setup failed\n");
 		return 1;
@@ -50,7 +50,6 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
-done:
 	return 0;
 err:
 	io_uring_queue_exit(&ring);
diff --git a/test/d4ae271dfaae-test.c b/test/d4ae271dfaae-test.c
index 6f263c6..b571b56 100644
--- a/test/d4ae271dfaae-test.c
+++ b/test/d4ae271dfaae-test.c
@@ -48,7 +48,7 @@ int main(int argc, char *argv[])
 
 	if (geteuid()) {
 		fprintf(stdout, "Test requires root, skipping\n");
-		return 0;
+		return -1;
 	}
 
 	memset(&p, 0, sizeof(p));
diff --git a/test/d77a67ed5f27-test.c b/test/d77a67ed5f27-test.c
index f3ef071..11e8d2b 100644
--- a/test/d77a67ed5f27-test.c
+++ b/test/d77a67ed5f27-test.c
@@ -32,7 +32,7 @@ int main(int argc, char *argv[])
 	if (ret) {
 		if (geteuid()) {
 			fprintf(stdout, "SQPOLL requires root, skipped\n");
-			return 0;
+			return -1;
 		}
 		fprintf(stderr, "ring create failed: %d\n", ret);
 		return 1;
diff --git a/test/eventfd-disable.c b/test/eventfd-disable.c
index f172fd7..283a004 100644
--- a/test/eventfd-disable.c
+++ b/test/eventfd-disable.c
@@ -56,7 +56,7 @@ int main(int argc, char *argv[])
 	ret = io_uring_cq_eventfd_toggle(&ring, false);
 	if (ret) {
 		fprintf(stdout, "Skipping, CQ flags not available!\n");
-		return 0;
+		return -1;
 	}
 
 	sqe = io_uring_get_sqe(&ring);
diff --git a/test/eventfd-ring.c b/test/eventfd-ring.c
index 67e102c..20f0b65 100644
--- a/test/eventfd-ring.c
+++ b/test/eventfd-ring.c
@@ -31,7 +31,7 @@ int main(int argc, char *argv[])
 	}
 	if (!(p.features & IORING_FEAT_CUR_PERSONALITY)) {
 		fprintf(stdout, "Skipping\n");
-		return 0;
+		return -1;
 	}
 	ret = io_uring_queue_init(8, &ring2, 0);
 	if (ret) {
diff --git a/test/eventfd.c b/test/eventfd.c
index 1a7e3f3..8db54f9 100644
--- a/test/eventfd.c
+++ b/test/eventfd.c
@@ -37,7 +37,7 @@ int main(int argc, char *argv[])
 	}
 	if (!(p.features & IORING_FEAT_CUR_PERSONALITY)) {
 		fprintf(stdout, "Skipping\n");
-		return 0;
+		return -1;
 	}
 
 	evfd = eventfd(0, EFD_CLOEXEC);
diff --git a/test/fadvise.c b/test/fadvise.c
index 0759446..7a522a6 100644
--- a/test/fadvise.c
+++ b/test/fadvise.c
@@ -92,7 +92,7 @@ static int do_fadvise(struct io_uring *ring, int fd, off_t offset, off_t len,
 	if (ret == -EINVAL || ret == -EBADF) {
 		fprintf(stdout, "Fadvise not supported, skipping\n");
 		unlink(".fadvise.tmp");
-		exit(0);
+		exit(-1);
 	} else if (ret) {
 		fprintf(stderr, "cqe->res=%d\n", cqe->res);
 	}
diff --git a/test/fallocate.c b/test/fallocate.c
index e662a6a..d6cb657 100644
--- a/test/fallocate.c
+++ b/test/fallocate.c
@@ -71,6 +71,7 @@ static int test_fallocate_rlimit(struct io_uring *ring)
 		goto err;
 	}
 	io_uring_cqe_seen(ring, cqe);
+
 out:
 	unlink(buf);
 	return 0;
@@ -151,9 +152,6 @@ static int test_fallocate_fsync(struct io_uring *ring)
 	char buf[32];
 	int fd, ret, i;
 
-	if (no_fallocate)
-		return 0;
-
 	sprintf(buf, "./XXXXXX");
 	fd = mkstemp(buf);
 	if (fd < 0) {
@@ -236,6 +234,9 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	if (no_fallocate)
+		return -1;
+
 	ret = test_fallocate_fsync(&ring);
 	if (ret) {
 		fprintf(stderr, "test_fallocate_fsync failed\n");
diff --git a/test/fc2a85cb02ef-test.c b/test/fc2a85cb02ef-test.c
index e922d17..e4bebed 100644
--- a/test/fc2a85cb02ef-test.c
+++ b/test/fc2a85cb02ef-test.c
@@ -92,7 +92,7 @@ int main(int argc, char *argv[])
   mmap((void *) 0x20000000ul, 0x1000000ul, 3ul, 0x32ul, -1, 0);
   if (setup_fault()) {
     printf("Test needs failslab/fail_futex/fail_page_alloc enabled, skipped\n");
-    return 0;
+    return -1;
   }
   intptr_t res = 0;
   *(uint32_t*)0x20000000 = 0;
diff --git a/test/madvise.c b/test/madvise.c
index e3af4f1..330cb5e 100644
--- a/test/madvise.c
+++ b/test/madvise.c
@@ -93,7 +93,7 @@ static int do_madvise(struct io_uring *ring, void *addr, off_t len, int advice)
 	if (ret == -EINVAL || ret == -EBADF) {
 		fprintf(stdout, "Madvise not supported, skipping\n");
 		unlink(".madvise.tmp");
-		exit(0);
+		exit(-1);
 	} else if (ret) {
 		fprintf(stderr, "cqe->res=%d\n", cqe->res);
 	}
diff --git a/test/open-close.c b/test/open-close.c
index cb74d91..fdfbf18 100644
--- a/test/open-close.c
+++ b/test/open-close.c
@@ -100,7 +100,7 @@ int main(int argc, char *argv[])
 {
 	struct io_uring ring;
 	const char *path, *path_rel;
-	int ret, do_unlink;
+	int ret, do_unlink, err = 0;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
@@ -131,38 +131,37 @@ int main(int argc, char *argv[])
 	if (ret < 0) {
 		if (ret == -EINVAL) {
 			fprintf(stdout, "Open not supported, skipping\n");
-			goto done;
+			err = -1;
+			goto out;
 		}
 		fprintf(stderr, "test_openat absolute failed: %d\n", ret);
-		goto err;
+		err = 1;
+		goto out;
 	}
 
 	ret = test_openat(&ring, path_rel, AT_FDCWD);
 	if (ret < 0) {
 		fprintf(stderr, "test_openat relative failed: %d\n", ret);
-		goto err;
+		err = 1;
+		goto out;
 	}
 
 	ret = test_close(&ring, ret, 0);
 	if (ret) {
 		fprintf(stderr, "test_close normal failed\n");
-		goto err;
+		err = 1;
+		goto out;
 	}
 
 	ret = test_close(&ring, ring.ring_fd, 1);
 	if (ret != -EBADF) {
 		fprintf(stderr, "test_close ring_fd failed\n");
-		goto err;
+		err = 1;
 	}
 
-done:
-	unlink(path);
-	if (do_unlink)
-		unlink(path_rel);
-	return 0;
-err:
+out:
 	unlink(path);
 	if (do_unlink)
 		unlink(path_rel);
-	return 1;
+	return err;
 }
diff --git a/test/openat2.c b/test/openat2.c
index 197821a..de59c4b 100644
--- a/test/openat2.c
+++ b/test/openat2.c
@@ -69,7 +69,7 @@ int main(int argc, char *argv[])
 {
 	struct io_uring ring;
 	const char *path, *path_rel;
-	int ret, do_unlink;
+	int ret, do_unlink, err = 0;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
@@ -100,26 +100,23 @@ int main(int argc, char *argv[])
 	if (ret < 0) {
 		if (ret == -EINVAL) {
 			fprintf(stdout, "openat2 not supported, skipping\n");
-			goto done;
+			err = -1;
+			goto out;
 		}
 		fprintf(stderr, "test_openat2 absolute failed: %d\n", ret);
-		goto err;
+		err = 1;
+		goto out;
 	}
 
 	ret = test_openat2(&ring, path_rel, AT_FDCWD);
 	if (ret < 0) {
 		fprintf(stderr, "test_openat2 relative failed: %d\n", ret);
-		goto err;
+		err = 1;
 	}
 
-done:
-	unlink(path);
-	if (do_unlink)
-		unlink(path_rel);
-	return 0;
-err:
+out:
 	unlink(path);
 	if (do_unlink)
 		unlink(path_rel);
-	return 1;
+	return err;
 }
diff --git a/test/personality.c b/test/personality.c
index 591ec83..be8fc08 100644
--- a/test/personality.c
+++ b/test/personality.c
@@ -171,7 +171,7 @@ int main(int argc, char *argv[])
 
 	if (geteuid()) {
 		fprintf(stderr, "Not root, skipping\n");
-		return 0;
+		return -1;
 	}
 
 	ret = io_uring_queue_init(8, &ring, 0);
@@ -186,7 +186,7 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 	if (no_personality)
-		return 0;
+		return -1;
 
 	ret = test_invalid_personality(&ring);
 	if (ret) {
diff --git a/test/poll-link.c b/test/poll-link.c
index d0786d4..3bb0e3c 100644
--- a/test/poll-link.c
+++ b/test/poll-link.c
@@ -102,7 +102,7 @@ void *recv_thread(void *arg)
 		fprintf(stderr, "Can't find good port, skipped\n");
 		data->stop = 1;
 		signal_var(&recv_thread_ready);
-		goto out;
+		goto skip;
 	}
 
         assert(listen(s0, 128) != -1);
@@ -150,7 +150,6 @@ void *recv_thread(void *arg)
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
-out:
 	signal_var(&recv_thread_done);
 	close(s0);
 	io_uring_queue_exit(&ring);
@@ -160,6 +159,11 @@ err:
 	close(s0);
 	io_uring_queue_exit(&ring);
 	return (void *) 1;
+skip:
+	signal_var(&recv_thread_done);
+	close(s0);
+	io_uring_queue_exit(&ring);
+	return (void *) -1;
 }
 
 static int test_poll_timeout(int do_connect, unsigned long timeout)
diff --git a/test/poll-many.c b/test/poll-many.c
index 723a353..85322b0 100644
--- a/test/poll-many.c
+++ b/test/poll-many.c
@@ -156,7 +156,7 @@ int main(int argc, char *argv[])
 		rlim.rlim_max = rlim.rlim_cur;
 		if (setrlimit(RLIMIT_NOFILE, &rlim) < 0) {
 			if (errno == EPERM)
-				goto err_nofail;
+				goto err_skip;
 			perror("setrlimit");
 			goto err_noring;
 		}
@@ -191,8 +191,8 @@ err:
 err_noring:
 	fprintf(stderr, "poll-many failed\n");
 	return 1;
-err_nofail:
+err_skip:
 	fprintf(stderr, "poll-many: not enough files available (and not root), "
 			"skipped\n");
-	return 0;
+	return -1;
 }
diff --git a/test/probe.c b/test/probe.c
index 1961176..bc49744 100644
--- a/test/probe.c
+++ b/test/probe.c
@@ -123,7 +123,7 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 	if (no_probe)
-		return 0;
+		return -1;
 
 	ret = test_probe_helper(&ring);
 	if (ret) {
diff --git a/test/register-restrictions.c b/test/register-restrictions.c
index 4f64c41..d46f860 100644
--- a/test/register-restrictions.c
+++ b/test/register-restrictions.c
@@ -569,7 +569,7 @@ int main(int argc, char *argv[])
 	ret = test_restrictions_sqe_op();
 	if (ret == TEST_SKIPPED) {
 		printf("test_restrictions_sqe_op: skipped\n");
-		return 0;
+		return -1;
 	} else if (ret == TEST_FAILED) {
 		fprintf(stderr, "test_restrictions_sqe_op failed\n");
 		return ret;
diff --git a/test/runtests.sh b/test/runtests.sh
index 5107a0a..acefe33 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -95,7 +95,7 @@ run_test()
 	# Check test status
 	if [ "$status" -eq 124 ]; then
 		echo "Test $test_name timed out (may not be a failure)"
-	elif [ "$status" -ne 0 ]; then
+	elif [ "$status" -ne 0 ] && [ "$status" -ne 255 ]; then
 		echo "Test $test_name failed with ret $status"
 		FAILED="$FAILED <$test_string>"
 		RET=1
@@ -103,6 +103,9 @@ run_test()
 		echo "Test $test_name failed dmesg check"
 		FAILED="$FAILED <$test_string>"
 		RET=1
+	elif [ "$status" -eq 255 ]; then
+		echo "Test skipped"
+		SKIPPED="$SKIPPED <$test_string>"
 	elif [ -n "$dev" ]; then
 		sleep .1
 		ps aux | grep "\[io_wq_manager\]" > /dev/null
diff --git a/test/send_recvmsg.c b/test/send_recvmsg.c
index 50c8e94..3f64f38 100644
--- a/test/send_recvmsg.c
+++ b/test/send_recvmsg.c
@@ -177,7 +177,6 @@ static void *recv_fn(void *data)
 		if (ret == -EINVAL) {
 			fprintf(stdout, "PROVIDE_BUFFERS not supported, skip\n");
 			goto out;
-			goto err;
 		} else if (ret < 0) {
 			fprintf(stderr, "PROVIDER_BUFFERS %d\n", ret);
 			goto err;
diff --git a/test/shared-wq.c b/test/shared-wq.c
index c0571e6..795d7b8 100644
--- a/test/shared-wq.c
+++ b/test/shared-wq.c
@@ -42,7 +42,7 @@ static int test_attach(int ringfd)
 	ret = io_uring_queue_init_params(1, &ring2, &p);
 	if (ret == -EINVAL) {
 		fprintf(stdout, "Sharing not supported, skipping\n");
-		return 0;
+		return -1;
 	} else if (ret) {
 		fprintf(stderr, "Attach to id: %d\n", ret);
 		goto err;
@@ -76,7 +76,8 @@ int main(int argc, char *argv[])
 
 	ret = test_attach(ring.ring_fd);
 	if (ret) {
-		fprintf(stderr, "test_attach failed\n");
+		if (ret != -1)
+			fprintf(stderr, "test_attach failed\n");
 		return ret;
 	}
 
diff --git a/test/shutdown.c b/test/shutdown.c
index eb66ded..533a9aa 100644
--- a/test/shutdown.c
+++ b/test/shutdown.c
@@ -102,7 +102,7 @@ int main(int argc, char *argv[])
 		if (cqe->res) {
 			if (cqe->res == -EINVAL) {
 				fprintf(stdout, "Shutdown not supported, skipping\n");
-				goto done;
+				goto skip;
 			}
 			fprintf(stderr, "writev: %d\n", cqe->res);
 			goto err;
@@ -140,10 +140,12 @@ int main(int argc, char *argv[])
 		io_uring_cqe_seen(&m_io_uring, cqe);
 	}
 
-done:
 	io_uring_queue_exit(&m_io_uring);
 	return 0;
 err:
 	io_uring_queue_exit(&m_io_uring);
 	return 1;
+skip:
+	io_uring_queue_exit(&m_io_uring);
+	return -1;
 }
diff --git a/test/splice.c b/test/splice.c
index e67bb10..d2b5a6d 100644
--- a/test/splice.c
+++ b/test/splice.c
@@ -472,6 +472,9 @@ int main(int argc, char *argv[])
 	if (!has_tee)
 		fprintf(stdout, "skip, doesn't support tee()\n");
 
+	if (!has_splice && !has_tee)
+		return -1;
+
 	ret = test_splice(&ring, &ctx);
 	if (ret) {
 		fprintf(stderr, "basic splice tests failed\n");
diff --git a/test/sq-poll-dup.c b/test/sq-poll-dup.c
index 79e623a..a8b39ce 100644
--- a/test/sq-poll-dup.c
+++ b/test/sq-poll-dup.c
@@ -23,6 +23,7 @@
 
 static struct iovec *vecs;
 static struct io_uring rings[NR_RINGS];
+static int no_nonfixed;
 
 static int create_buffers(void)
 {
@@ -142,6 +143,7 @@ static int test(int fd, int do_dup_and_close, int close_ring)
 		/* no sharing for non-fixed either */
 		if (!(p.features & IORING_FEAT_SQPOLL_NONFIXED)) {
 			fprintf(stdout, "No SQPOLL sharing, skipping\n");
+			no_nonfixed = 1;
 			return 0;
 		}
 	}
@@ -215,6 +217,9 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
+	if (no_nonfixed)
+		return -1;
+
 	ret = test(fd, 0, 1);
 	if (ret) {
 		fprintf(stderr, "test 0 1 failed\n");
diff --git a/test/sq-poll-kthread.c b/test/sq-poll-kthread.c
index ed7d0bf..f3b6ad3 100644
--- a/test/sq-poll-kthread.c
+++ b/test/sq-poll-kthread.c
@@ -153,6 +153,7 @@ int main(int argc, char *argv[])
 	ret = test_sq_poll_kthread_stopped(true);
 	if (ret == TEST_SKIPPED) {
 		printf("test_sq_poll_kthread_stopped_exit: skipped\n");
+		return -1;
 	} else if (ret == TEST_FAILED) {
 		fprintf(stderr, "test_sq_poll_kthread_stopped_exit failed\n");
 		return ret;
@@ -161,6 +162,7 @@ int main(int argc, char *argv[])
 	ret = test_sq_poll_kthread_stopped(false);
 	if (ret == TEST_SKIPPED) {
 		printf("test_sq_poll_kthread_stopped_noexit: skipped\n");
+		return -1;
 	} else if (ret == TEST_FAILED) {
 		fprintf(stderr, "test_sq_poll_kthread_stopped_noexit failed\n");
 		return ret;
diff --git a/test/sq-poll-share.c b/test/sq-poll-share.c
index 0f25389..0e1b438 100644
--- a/test/sq-poll-share.c
+++ b/test/sq-poll-share.c
@@ -140,7 +140,7 @@ int main(int argc, char *argv[])
 		/* no sharing for non-fixed either */
 		if (!(p.features & IORING_FEAT_SQPOLL_NONFIXED)) {
 			fprintf(stdout, "No SQPOLL sharing, skipping\n");
-			return 0;
+			return -1;
 		}
 	}
 
diff --git a/test/statx.c b/test/statx.c
index c846a4a..a371c4f 100644
--- a/test/statx.c
+++ b/test/statx.c
@@ -149,7 +149,7 @@ int main(int argc, char *argv[])
 {
 	struct io_uring ring;
 	const char *fname;
-	int ret;
+	int ret, err = 0;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
@@ -171,23 +171,22 @@ int main(int argc, char *argv[])
 	if (ret) {
 		if (ret == -EINVAL) {
 			fprintf(stdout, "statx not supported, skipping\n");
-			goto done;
+			err = -1;
+			goto out;
 		}
 		fprintf(stderr, "test_statx failed: %d\n", ret);
-		goto err;
+		err = 1;
+		goto out;
 	}
 
 	ret = test_statx_fd(&ring, fname);
 	if (ret) {
 		fprintf(stderr, "test_statx_fd failed: %d\n", ret);
-		goto err;
+		err = 1;
+		goto out;
 	}
-done:
-	if (fname != argv[1])
-		unlink(fname);
-	return 0;
-err:
+out:
 	if (fname != argv[1])
 		unlink(fname);
-	return 1;
+	return err;
 }
diff --git a/test/timeout-overflow.c b/test/timeout-overflow.c
index f952f80..baa674b 100644
--- a/test/timeout-overflow.c
+++ b/test/timeout-overflow.c
@@ -192,7 +192,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (not_supported)
-		return 0;
+		return -1;
 
 	ret = test_timeout_overflow();
 	if (ret) {
-- 
2.26.2

