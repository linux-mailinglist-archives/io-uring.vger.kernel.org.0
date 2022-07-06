Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35ED567C9A
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 05:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiGFDlh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 23:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiGFDlg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 23:41:36 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952671CFD7
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 20:41:34 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id y18so12937716iof.2
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 20:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3C36Tj5XIbUfaHZXrkQ1xIFb4jKi8m5ryOom/rSuOuY=;
        b=M6hlR/XlKZ7Y/pIRSGk3HTsxaMvH6LJU9oikLO7JJiaF/wrpQtcsVX5mICV94p+L7s
         IF/EQXidRXq1d0xUJ/DWFdrGi2AVtMLS1p4YRsI8N89mKvrfD07zH5IzJ5J0fHZNtGo7
         DugTMgsVhkg/DhLj1N3dK9dKepGzRVRoqTIdRZn4Vg/PmkZdGe76aMwMw+57uvdsKySu
         Rjdq6JHWX8epOPXQIPy/PF9qnfpP1AL/P9hnytMLKGF9ipKzJutglAYkqYjz/DAgu9zJ
         XfRmT/BoO3HqXPwv4KX1D0Iw5Ubfbz8u2hegEUngsFjyDCquIssW56J3hutsi9aYlnPg
         n0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3C36Tj5XIbUfaHZXrkQ1xIFb4jKi8m5ryOom/rSuOuY=;
        b=sfNMN7eZfTMpeYKyNCAKyDFwhXEwe3wJ4D+S6/1OyQXSXq9Z0ab+5fm1TLqwDuD7IW
         v82XR7eArozndT+goMHzW4VCeLSv8qi6K+/gyPahbJRZzD5PToPfXvRdYjVvkik8Ctci
         ubDoxCJG2ZMK+oz4Q7qTDKeMMBZwzf91cMPTxjuOEiOMmWtdKwbrqS1TNFVLQrGxQ8hx
         yzIsYgr6IWtfKSjqF+mBmSORAvOkeCq53BD82PvId1xOZpn4KAvOKnCtp29fFHpVErmg
         XPIml5eCwx6y3njuK6/CzRNS1cu8vrwoV17ScyE8dBnGJJ3nVd793k8NYe8FuPuLvLAa
         3IhA==
X-Gm-Message-State: AJIora8vcGYdWj1MA4bB8V1UgkO7waf6npUgsPGsBILWys1wSu7u76eS
        kX/w1BKj2uvc7XdljN0JtgcV7P6UhUnnpJKO
X-Google-Smtp-Source: AGRyM1sXjexR2OPlYv18ub5jnwT3Sj4+7m1WqcN9auNWmte3PnuC+gI/rooxL2FZrA6SroNl38/G0Q==
X-Received: by 2002:a02:228d:0:b0:333:ffe9:864b with SMTP id o135-20020a02228d000000b00333ffe9864bmr23368426jao.277.1657078893215;
        Tue, 05 Jul 2022 20:41:33 -0700 (PDT)
Received: from didactylos.localdomain ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id z6-20020a05660217c600b006692192baf7sm16427854iox.25.2022.07.05.20.41.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:41:32 -0700 (PDT)
From:   Eli Schwartz <eschwartz93@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH liburing 3/6] tests: more work on updating exit codes to use enum-based status reporting
Date:   Tue,  5 Jul 2022 23:40:55 -0400
Message-Id: <20220706034059.2817423-4-eschwartz93@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706034059.2817423-1-eschwartz93@gmail.com>
References: <20220706034059.2817423-1-eschwartz93@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
---
 test/accept-reuse.c            |  2 +-
 test/accept.c                  |  8 ++++----
 test/connect.c                 |  2 +-
 test/double-poll-crash.c       |  4 ++--
 test/fadvise.c                 |  2 +-
 test/file-register.c           |  2 +-
 test/file-update.c             |  4 ++--
 test/files-exit-hang-timeout.c |  4 ++--
 test/fixed-reuse.c             |  2 +-
 test/io-cancel.c               | 14 +++++++-------
 test/io_uring_enter.c          |  8 ++++----
 test/io_uring_register.c       |  6 +++---
 test/io_uring_setup.c          |  7 ++++---
 test/iopoll.c                  |  6 +++---
 test/lfs-openat-write.c        |  4 +++-
 test/link-timeout.c            |  7 ++++---
 test/link.c                    |  9 +++++----
 test/madvise.c                 |  4 ++--
 test/mkdir.c                   |  5 +++--
 test/msg-ring.c                | 13 +++++++------
 test/multicqes_drain.c         |  5 +++--
 21 files changed, 63 insertions(+), 55 deletions(-)

diff --git a/test/accept-reuse.c b/test/accept-reuse.c
index ff99da8..7822433 100644
--- a/test/accept-reuse.c
+++ b/test/accept-reuse.c
@@ -103,7 +103,7 @@ int main(int argc, char **argv)
 	ret = listen(listen_fd, SOMAXCONN);
 	if (ret < 0) {
 		perror("listen");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	memset(&sa, 0, sizeof(sa));
diff --git a/test/accept.c b/test/accept.c
index 0463173..f0d84f4 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -510,7 +510,7 @@ static int test_accept_cancel(unsigned usecs, unsigned int nr, bool multishot)
 	int fd, i, ret;
 
 	if (multishot && no_accept_multi)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(32, &m_io_uring, 0);
 	assert(ret >= 0);
@@ -605,7 +605,7 @@ static int test_multishot_accept(int count, bool before, bool overflow)
 	};
 
 	if (no_accept_multi)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(MAX_FDS + 10, &m_io_uring, 0);
 	assert(ret >= 0);
@@ -695,7 +695,7 @@ static int test_multishot_fixed_accept(void)
 	};
 
 	if (no_accept_multi)
-		return 0;
+		return T_EXIT_SKIP;
 
 	memset(fd, -1, sizeof(fd));
 	ret = io_uring_queue_init(MAX_FDS + 10, &m_io_uring, 0);
@@ -742,7 +742,7 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 	if (no_accept)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = test_accept(2, false);
 	if (ret) {
diff --git a/test/connect.c b/test/connect.c
index d31bd05..b8f8f22 100644
--- a/test/connect.c
+++ b/test/connect.c
@@ -380,7 +380,7 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 	if (no_connect)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = test_connect(&ring);
 	if (ret == -1) {
diff --git a/test/double-poll-crash.c b/test/double-poll-crash.c
index 0d6154b..a0cc985 100644
--- a/test/double-poll-crash.c
+++ b/test/double-poll-crash.c
@@ -123,10 +123,10 @@ int main(int argc, char *argv[])
 
   mmap_ret = mmap((void *)0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
   if (mmap_ret == MAP_FAILED)
-    return 0;
+    return T_EXIT_SKIP;
   mmap_ret = mmap((void *)0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
   if (mmap_ret == MAP_FAILED)
-    return 0;
+    return T_EXIT_SKIP;
   intptr_t res = 0;
   *(uint32_t*)0x20000484 = 0;
   *(uint32_t*)0x20000488 = 0;
diff --git a/test/fadvise.c b/test/fadvise.c
index d259223..889f447 100644
--- a/test/fadvise.c
+++ b/test/fadvise.c
@@ -73,7 +73,7 @@ static int do_fadvise(struct io_uring *ring, int fd, off_t offset, off_t len,
 	if (ret == -EINVAL || ret == -EBADF) {
 		fprintf(stdout, "Fadvise not supported, skipping\n");
 		unlink(".fadvise.tmp");
-		exit(0);
+		exit(T_EXIT_SKIP);
 	} else if (ret) {
 		fprintf(stderr, "cqe->res=%d\n", cqe->res);
 	}
diff --git a/test/file-register.c b/test/file-register.c
index e713233..ae35c37 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -1034,7 +1034,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (no_update)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = test_additions(&ring);
 	if (ret) {
diff --git a/test/file-update.c b/test/file-update.c
index b8039c9..57355ed 100644
--- a/test/file-update.c
+++ b/test/file-update.c
@@ -131,7 +131,7 @@ static int test_sqe_update(struct io_uring *ring)
 	free(fds);
 	if (ret == -EINVAL) {
 		fprintf(stdout, "IORING_OP_FILES_UPDATE not supported, skipping\n");
-		return 0;
+		return T_EXIT_SKIP;
 	}
 	return ret != 10;
 }
@@ -171,5 +171,5 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	return 0;
+	return T_EXIT_PASS;
 }
diff --git a/test/files-exit-hang-timeout.c b/test/files-exit-hang-timeout.c
index 318f0e1..45f01ea 100644
--- a/test/files-exit-hang-timeout.c
+++ b/test/files-exit-hang-timeout.c
@@ -95,7 +95,7 @@ int main(int argc, char *argv[])
 			break;
 		if (errno != EADDRINUSE) {
 			fprintf(stderr, "bind: %s\n", strerror(errno));
-			return 1;
+			return T_EXIT_FAIL;
 		}
 		if (i == 99) {
 			printf("Gave up on finding a port, skipping\n");
@@ -105,7 +105,7 @@ int main(int argc, char *argv[])
 
 	if (listen(sock_listen_fd, BACKLOG) < 0) {
 		perror("Error listening on socket\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	if (setup_io_uring())
diff --git a/test/fixed-reuse.c b/test/fixed-reuse.c
index 8bcda4b..401251a 100644
--- a/test/fixed-reuse.c
+++ b/test/fixed-reuse.c
@@ -132,7 +132,7 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 	if (!(p.features & IORING_FEAT_CQE_SKIP))
-		return 0;
+		return T_EXIT_SKIP;
 
 	memset(files, -1, sizeof(files));
 	ret = io_uring_register_files(&ring, files, ARRAY_SIZE(files));
diff --git a/test/io-cancel.c b/test/io-cancel.c
index 13bf84f..dfe4e43 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -508,26 +508,26 @@ int main(int argc, char *argv[])
 	int i, ret;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	if (test_dont_cancel_another_ring()) {
 		fprintf(stderr, "test_dont_cancel_another_ring() failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	if (test_cancel_req_across_fork()) {
 		fprintf(stderr, "test_cancel_req_across_fork() failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	if (test_cancel_inflight_exit()) {
 		fprintf(stderr, "test_cancel_inflight_exit() failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	if (test_sqpoll_cancel_iowq_requests()) {
 		fprintf(stderr, "test_sqpoll_cancel_iowq_requests() failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	t_create_file(fname, FILE_SIZE);
@@ -548,8 +548,8 @@ int main(int argc, char *argv[])
 	}
 
 	unlink(fname);
-	return 0;
+	return T_EXIT_PASS;
 err:
 	unlink(fname);
-	return 1;
+	return T_EXIT_FAIL;
 }
diff --git a/test/io_uring_enter.c b/test/io_uring_enter.c
index ef00bf6..941c5b7 100644
--- a/test/io_uring_enter.c
+++ b/test/io_uring_enter.c
@@ -185,14 +185,14 @@ int main(int argc, char **argv)
 	unsigned completed, dropped;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(IORING_MAX_ENTRIES, &ring, 0);
 	if (ret == -ENOMEM)
 		ret = io_uring_queue_init(IORING_MAX_ENTRIES_FALLBACK, &ring, 0);
 	if (ret < 0) {
 		perror("io_uring_queue_init");
-		exit(1);
+		exit(T_EXIT_FAIL);
 	}
 	mask = *sq->kring_mask;
 
@@ -254,8 +254,8 @@ int main(int argc, char **argv)
 	}
 
 	if (!status)
-		return 0;
+		return T_EXIT_PASS;
 
 	fprintf(stderr, "FAIL\n");
-	return -1;
+	return T_EXIT_FAIL;
 }
diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index 05868e1..311bfdf 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -459,20 +459,20 @@ int main(int argc, char **argv)
 	struct rlimit rlim;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	/* setup globals */
 	pagesize = getpagesize();
 	ret = getrlimit(RLIMIT_MEMLOCK, &rlim);
 	if (ret < 0) {
 		perror("getrlimit");
-		return 1;
+		return T_EXIT_PASS;
 	}
 	mlock_limit = rlim.rlim_cur;
 	devnull = open("/dev/null", O_RDWR);
 	if (devnull < 0) {
 		perror("open /dev/null");
-		exit(1);
+		exit(T_EXIT_FAIL);
 	}
 
 	/* invalid fd */
diff --git a/test/io_uring_setup.c b/test/io_uring_setup.c
index 7752c97..3c50e2a 100644
--- a/test/io_uring_setup.c
+++ b/test/io_uring_setup.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <sys/sysinfo.h>
 #include "liburing.h"
+#include "helpers.h"
 
 #include "../syscall.h"
 
@@ -130,7 +131,7 @@ main(int argc, char **argv)
 	struct io_uring_params p;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	memset(&p, 0, sizeof(p));
 	status |= try_io_uring_setup(0, &p, -1, EINVAL);
@@ -179,8 +180,8 @@ main(int argc, char **argv)
 	}
 
 	if (!status)
-		return 0;
+		return T_EXIT_PASS;
 
 	fprintf(stderr, "FAIL\n");
-	return -1;
+	return T_EXIT_FAIL;
 }
diff --git a/test/iopoll.c b/test/iopoll.c
index f3c22d6..51b192f 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -323,7 +323,7 @@ int main(int argc, char *argv[])
 	char *fname;
 
 	if (probe_buf_select())
-		return 1;
+		return T_EXIT_FAIL;
 
 	if (argc > 1) {
 		fname = argv[1];
@@ -364,9 +364,9 @@ int main(int argc, char *argv[])
 
 	if (fname != argv[1])
 		unlink(fname);
-	return 0;
+	return T_EXIT_PASS;
 err:
 	if (fname != argv[1])
 		unlink(fname);
-	return 1;
+	return T_EXIT_FAIL;
 }
diff --git a/test/lfs-openat-write.c b/test/lfs-openat-write.c
index 6bbf78d..b413a11 100644
--- a/test/lfs-openat-write.c
+++ b/test/lfs-openat-write.c
@@ -14,6 +14,8 @@
 #include <sys/resource.h>
 #include <unistd.h>
 
+#include "helpers.h"
+
 static const int RSIZE = 2;
 static const int OPEN_FLAGS = O_RDWR | O_CREAT;
 static const mode_t OPEN_MODE = S_IRUSR | S_IWUSR;
@@ -100,7 +102,7 @@ int main(int argc, char *argv[])
 	int dfd, ret;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	dfd = open("/tmp", O_RDONLY | O_DIRECTORY);
 	if (dfd < 0)
diff --git a/test/link-timeout.c b/test/link-timeout.c
index ad638e9..5e56d5a 100644
--- a/test/link-timeout.c
+++ b/test/link-timeout.c
@@ -12,6 +12,7 @@
 #include <poll.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 static int test_fail_lone_link_timeouts(struct io_uring *ring)
 {
@@ -1011,12 +1012,12 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
 		printf("ring setup failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_timeout_link_chain1(&ring);
@@ -1103,5 +1104,5 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	return 0;
+	return T_EXIT_PASS;
 }
diff --git a/test/link.c b/test/link.c
index 41d3899..3c8d991 100644
--- a/test/link.c
+++ b/test/link.c
@@ -11,6 +11,7 @@
 #include <fcntl.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 static int no_hardlink;
 
@@ -435,19 +436,19 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
 		printf("ring setup failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 
 	}
 
 	ret = io_uring_queue_init(8, &poll_ring, IORING_SETUP_IOPOLL);
 	if (ret) {
 		printf("poll_ring setup failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_single_link(&ring);
@@ -492,5 +493,5 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	return 0;
+	return T_EXIT_PASS;
 }
diff --git a/test/madvise.c b/test/madvise.c
index b85aba8..8848143 100644
--- a/test/madvise.c
+++ b/test/madvise.c
@@ -187,9 +187,9 @@ int main(int argc, char *argv[])
 	if (fname != argv[1])
 		unlink(fname);
 	io_uring_queue_exit(&ring);
-	return 0;
+	return T_EXIT_PASS;
 err:
 	if (fname != argv[1])
 		unlink(fname);
-	return 1;
+	return T_EXIT_FAIL;
 }
diff --git a/test/mkdir.c b/test/mkdir.c
index 363fe1e..6b3497c 100644
--- a/test/mkdir.c
+++ b/test/mkdir.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 static int do_mkdirat(struct io_uring *ring, const char *fn)
 {
@@ -59,7 +60,7 @@ int main(int argc, char *argv[])
 	struct io_uring ring;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
@@ -104,5 +105,5 @@ err1:
 	unlinkat(AT_FDCWD, fn, AT_REMOVEDIR);
 err:
 	io_uring_queue_exit(&ring);
-	return 1;
+	return T_EXIT_FAIL;
 }
diff --git a/test/msg-ring.c b/test/msg-ring.c
index 48c4a64..aec498d 100644
--- a/test/msg-ring.c
+++ b/test/msg-ring.c
@@ -12,6 +12,7 @@
 #include <pthread.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 static int no_msg;
 
@@ -183,22 +184,22 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
 		fprintf(stderr, "ring setup failed: %d\n", ret);
-		return 1;
+		return T_EXIT_FAIL;
 	}
 	ret = io_uring_queue_init(8, &ring2, 0);
 	if (ret) {
 		fprintf(stderr, "ring setup failed: %d\n", ret);
-		return 1;
+		return T_EXIT_FAIL;
 	}
 	ret = io_uring_queue_init(8, &pring, IORING_SETUP_IOPOLL);
 	if (ret) {
 		fprintf(stderr, "ring setup failed: %d\n", ret);
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	ret = test_own(&ring);
@@ -208,7 +209,7 @@ int main(int argc, char *argv[])
 	}
 	if (no_msg) {
 		fprintf(stdout, "Skipped\n");
-		return 0;
+		return T_EXIT_SKIP;
 	}
 	ret = test_own(&pring);
 	if (ret) {
@@ -232,5 +233,5 @@ int main(int argc, char *argv[])
 
 	pthread_join(thread, &tret);
 
-	return 0;
+	return T_EXIT_PASS;
 }
diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
index b16dc52..b7448ac 100644
--- a/test/multicqes_drain.c
+++ b/test/multicqes_drain.c
@@ -17,6 +17,7 @@
 #include <poll.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 enum {
 	multi,
@@ -360,12 +361,12 @@ int main(int argc, char *argv[])
 	int i, ret;
 
 	if (argc > 1)
-		return 0;
+		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(1024, &ring, 0);
 	if (ret) {
 		printf("ring setup failed\n");
-		return 1;
+		return T_EXIT_FAIL;
 	}
 
 	for (i = 0; i < 5; i++) {
-- 
2.35.1

