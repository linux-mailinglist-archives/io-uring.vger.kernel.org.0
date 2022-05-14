Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A052720F
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiENOf1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiENOf0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:35:26 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14D020196
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b12so1163255pju.3
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vKvTHZjA5w7vmkGFyn6Ks44vmbW82kOdrzA0+97MO48=;
        b=IAQsbwwcK56J/VZgoF0+cbMRMCvsaxWf+Mje5M2rLDUfy8Jed2mHlKifO38Whzjhtm
         ANmvttVUVKQygk0M3iAq87AOwPc5prp7IkPusDsMLmCV0CqHu84WvFFcSB0XUCk7mQeP
         a2UIxzyK+51f+m0xJHbMQwFfnoOZfCQ6zsxmaBSo8NA4xKinBoBws7kdrS5kdCfeghVn
         +WTRDDNikUtOjusKxB7jHTh+OBI3fsf+pBpzOeC0SMurRSJxIAm1m3XdCtB2t7azJA1a
         NtHvHIV0G4a3bmG3WEukWDONhGbVMOlUy0SkqfKjZam0NWfxi1Yo0zZy9Nm9JULQlkn/
         fH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vKvTHZjA5w7vmkGFyn6Ks44vmbW82kOdrzA0+97MO48=;
        b=zoD97+rxUryFYHOdGFE4WKGtMkTtQAmRYi/h1PA0NILHMFm7IkadHC/bJx+9/ybu/b
         CDPjeo6F8D1gDVWyLc8iBbwkzQTczU0LDpAOb4QPiR8IeQxid0QorXT6huyXAwkzRSZi
         0gahU+GvGVGo7tXRwFj7b+dPJnZhsLlruu9MfBe13c2j6UtTXW+uCYrzPNlGnTIU4wRZ
         YN5TA3LnKFwqvWxr77FHNJkSL1MkrH5i1W631Sy2MjQATn5ioAFABALl1uij4t2AthTN
         rbBB3RtOp/VTnOzp206CrOslJh0Z4vi9PmWzHdtLua561ySPGXqS5gPpDjBEg1M2ewRi
         3aZA==
X-Gm-Message-State: AOAM532NO1pC/gm2X7pS7GCDB1lWLQE5ekuhfZMEy8umkS4cTy8LvfLe
        plku3H0QtwG38FLEG5pwTS7bc6OTFbb4yS5P
X-Google-Smtp-Source: ABdhPJxfzpwA/SuSxKgze30iDWXZHJddUjvafTvtEAwGWKfjcdwH1iSHiXr0vj5jDzY1VnTqYnFoGw==
X-Received: by 2002:a17:902:7444:b0:161:5a62:cf8b with SMTP id e4-20020a170902744400b001615a62cf8bmr1607052plt.77.1652538923293;
        Sat, 14 May 2022 07:35:23 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015ea95948ebsm3762179plj.134.2022.05.14.07.35.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:35:23 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/6] test/accept.c: add test for multishot mode accept
Date:   Sat, 14 May 2022 22:35:32 +0800
Message-Id: <20220514143534.59162-5-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514143534.59162-1-haoxu.linux@gmail.com>
References: <20220514143534.59162-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu@tencent.com>

Add an test for multishot mode accept

Signed-off-by: Hao Xu <haoxu@tencent.com>
---
 test/accept.c | 281 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 216 insertions(+), 65 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index a0f4a13f5975..897278a2a3c3 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <stdint.h>
 #include <assert.h>
+#include <limits.h>
 
 #include <errno.h>
 #include <fcntl.h>
@@ -22,6 +23,7 @@
 #include "helpers.h"
 #include "liburing.h"
 
+#define MAX_FDS 32
 static int no_accept;
 
 struct data {
@@ -29,6 +31,15 @@ struct data {
 	struct iovec iov;
 };
 
+struct accept_test_args {
+	int accept_should_error;
+	bool fixed;
+	bool nonblock;
+	bool queue_accept_before_connect;
+	bool multishot;
+	int extra_loops;
+};
+
 static void queue_send(struct io_uring *ring, int fd)
 {
 	struct io_uring_sqe *sqe;
@@ -59,20 +70,32 @@ static void queue_recv(struct io_uring *ring, int fd, bool fixed)
 		sqe->flags |= IOSQE_FIXED_FILE;
 }
 
-static void queue_accept_conn(struct io_uring *ring,
-			      int fd, int fixed_idx,
-			      int count)
+static void queue_accept_conn(struct io_uring *ring, int fd,
+			      struct accept_test_args args)
 {
 	struct io_uring_sqe *sqe;
 	int ret;
+	int fixed_idx = args.fixed ? 0 : -1;
+	int count = 1 + args.extra_loops;
+	bool multishot = args.multishot;
 
 	while (count--) {
 		sqe = io_uring_get_sqe(ring);
-		if (fixed_idx < 0)
-			io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
-		else
-			io_uring_prep_accept_direct(sqe, fd, NULL, NULL, 0,
-						    fixed_idx);
+		if (fixed_idx < 0) {
+			if (!multishot)
+				io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+			else
+				io_uring_prep_multishot_accept(sqe, fd, NULL,
+							       NULL, 0);
+		} else {
+			if (!multishot)
+				io_uring_prep_accept_direct(sqe, fd, NULL, NULL,
+							    0, fixed_idx);
+			else
+				io_uring_prep_multishot_accept_direct(sqe, fd,
+								      NULL, NULL,
+								      0);
+		}
 
 		ret = io_uring_submit(ring);
 		assert(ret != -1);
@@ -131,71 +154,103 @@ static int start_accept_listen(struct sockaddr_in *addr, int port_off,
 	return fd;
 }
 
-struct accept_test_args {
-	int accept_should_error;
-	bool fixed;
-	bool nonblock;
-	bool queue_accept_before_connect;
-	int extra_loops;
-};
-
-
-static int test_loop(struct io_uring *ring,
-		     struct accept_test_args args,
-		     int recv_s0,
-		     struct sockaddr_in *addr)
+static int set_client_fd(struct sockaddr_in *addr)
 {
-	struct io_uring_cqe *cqe;
-	uint32_t head, count = 0;
-	int ret, p_fd[2], done = 0;
 	int32_t val;
+	int fd, ret;
 
-	p_fd[1] = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
+	fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
 
 	val = 1;
-	ret = setsockopt(p_fd[1], IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
+	ret = setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
 	assert(ret != -1);
 
-	int32_t flags = fcntl(p_fd[1], F_GETFL, 0);
+	int32_t flags = fcntl(fd, F_GETFL, 0);
 	assert(flags != -1);
 
 	flags |= O_NONBLOCK;
-	ret = fcntl(p_fd[1], F_SETFL, flags);
+	ret = fcntl(fd, F_SETFL, flags);
 	assert(ret != -1);
 
-	ret = connect(p_fd[1], (struct sockaddr *)addr, sizeof(*addr));
+	ret = connect(fd, (struct sockaddr *)addr, sizeof(*addr));
 	assert(ret == -1);
 
-	flags = fcntl(p_fd[1], F_GETFL, 0);
+	flags = fcntl(fd, F_GETFL, 0);
 	assert(flags != -1);
 
 	flags &= ~O_NONBLOCK;
-	ret = fcntl(p_fd[1], F_SETFL, flags);
+	ret = fcntl(fd, F_SETFL, flags);
 	assert(ret != -1);
 
-	if (!args.queue_accept_before_connect)
-		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1, 1);
+	return fd;
+}
 
-	p_fd[0] = accept_conn(ring, args.fixed ? 0 : -1);
-	if (p_fd[0] == -EINVAL) {
-		if (args.accept_should_error)
+static int test_loop(struct io_uring *ring,
+		     struct accept_test_args args,
+		     int recv_s0,
+		     struct sockaddr_in *addr)
+{
+	struct io_uring_cqe *cqe;
+	uint32_t head, count = 0;
+	int i, ret, s_fd[MAX_FDS], c_fd[MAX_FDS], done = 0;
+	bool fixed = args.fixed;
+	bool multishot = args.multishot;
+	unsigned int multishot_mask = 0;
+
+	for (i = 0; i < MAX_FDS; i++) {
+		c_fd[i] = set_client_fd(addr);
+		if (!multishot)
+			break;
+	}
+
+	if (!args.queue_accept_before_connect)
+		queue_accept_conn(ring, recv_s0, args);
+
+	for (i = 0; i < MAX_FDS; i++) {
+		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1);
+		if (s_fd[i] == -EINVAL) {
+			if (args.accept_should_error)
+				goto out;
+			fprintf(stdout,
+				"%s %s Accept not supported, skipping\n",
+				fixed ? "Fixed" : "",
+				multishot ? "Multishot" : "");
+			no_accept = 1;
 			goto out;
-		if (args.fixed)
-			fprintf(stdout, "Fixed accept not supported, skipping\n");
-		else
-			fprintf(stdout, "Accept not supported, skipping\n");
-		no_accept = 1;
+		} else if (s_fd[i] < 0) {
+			if (args.accept_should_error &&
+			    (s_fd[i] == -EBADF || s_fd[i] == -EINVAL))
+				goto out;
+			fprintf(stderr, "%s %s Accept[%d] got %d\n",
+				fixed ? "Fixed" : "",
+				multishot ? "Multishot" : "",
+				i, s_fd[i]);
+			goto err;
+		}
+
+		if (multishot && fixed) {
+			if (s_fd[i] >= MAX_FDS) {
+				fprintf(stderr,
+					"Fixed Multishot Accept[%d] got outbound index: %d\n",
+					i, s_fd[i]);
+				goto err;
+			}
+			multishot_mask |= (1 << (s_fd[i] - 1));
+		}
+		if (!multishot)
+			break;
+	}
+
+	if (multishot) {
+		if (fixed && multishot_mask != UINT_MAX) {
+			fprintf(stderr, "Fixed Multishot Accept misses events\n");
+			goto err;
+		}
 		goto out;
-	} else if (p_fd[0] < 0) {
-		if (args.accept_should_error &&
-		    (p_fd[0] == -EBADF || p_fd[0] == -EINVAL))
-			goto out;
-		fprintf(stderr, "Accept got %d\n", p_fd[0]);
-		goto err;
 	}
 
-	queue_send(ring, p_fd[1]);
-	queue_recv(ring, p_fd[0], args.fixed);
+	queue_send(ring, c_fd[0]);
+	queue_recv(ring, s_fd[0], args.fixed);
 
 	ret = io_uring_submit_and_wait(ring, 2);
 	assert(ret != -1);
@@ -219,14 +274,32 @@ static int test_loop(struct io_uring *ring,
 	}
 
 out:
-	if (!args.fixed)
-		close(p_fd[0]);
-	close(p_fd[1]);
+	if (!args.fixed) {
+		for (i = 0; i < MAX_FDS; i++) {
+			close(s_fd[i]);
+			if (!multishot)
+				break;
+		}
+	}
+	for (i = 0; i < MAX_FDS; i++) {
+		close(c_fd[i]);
+		if (!multishot)
+			break;
+	}
 	return 0;
 err:
-	if (!args.fixed)
-		close(p_fd[0]);
-	close(p_fd[1]);
+	if (!args.fixed) {
+		for (i = 0; i < MAX_FDS; i++) {
+			close(s_fd[i]);
+			if (!multishot)
+				break;
+		}
+	}
+	for (i = 0; i < MAX_FDS; i++) {
+		close(c_fd[i]);
+		if (!multishot)
+			break;
+	}
 	return 1;
 }
 
@@ -238,8 +311,7 @@ static int test(struct io_uring *ring, struct accept_test_args args)
 	int32_t recv_s0 = start_accept_listen(&addr, 0,
 					      args.nonblock ? O_NONBLOCK : 0);
 	if (args.queue_accept_before_connect)
-		queue_accept_conn(ring, recv_s0, args.fixed ? 0 : -1,
-				  1 + args.extra_loops);
+		queue_accept_conn(ring, recv_s0, args);
 	for (loop = 0; loop < 1 + args.extra_loops; loop++) {
 		ret = test_loop(ring, args, recv_s0, &addr);
 		if (ret)
@@ -364,7 +436,7 @@ out:
 	return ret;
 }
 
-static int test_accept_cancel(unsigned usecs, unsigned int nr)
+static int test_accept_cancel(unsigned usecs, unsigned int nr, bool multishot)
 {
 	struct io_uring m_io_uring;
 	struct io_uring_cqe *cqe;
@@ -378,7 +450,10 @@ static int test_accept_cancel(unsigned usecs, unsigned int nr)
 
 	for (i = 1; i <= nr; i++) {
 		sqe = io_uring_get_sqe(&m_io_uring);
-		io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+		if (!multishot)
+			io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+		else
+			io_uring_prep_multishot_accept(sqe, fd, NULL, NULL, 0);
 		sqe->user_data = i;
 		ret = io_uring_submit(&m_io_uring);
 		assert(ret == 1);
@@ -449,6 +524,23 @@ static int test_accept(int count, bool before)
 	return ret;
 }
 
+static int test_multishot_accept(int count, bool before)
+{
+	struct io_uring m_io_uring;
+	int ret;
+	struct accept_test_args args = {
+		.queue_accept_before_connect = before,
+		.multishot = true,
+		.extra_loops = count - 1
+	};
+
+	ret = io_uring_queue_init(MAX_FDS + 10, &m_io_uring, 0);
+	assert(ret >= 0);
+	ret = test(&m_io_uring, args);
+	io_uring_queue_exit(&m_io_uring);
+	return ret;
+}
+
 static int test_accept_nonblock(bool queue_before_connect, int count)
 {
 	struct io_uring m_io_uring;
@@ -483,6 +575,25 @@ static int test_accept_fixed(void)
 	return ret;
 }
 
+static int test_multishot_fixed_accept(void)
+{
+	struct io_uring m_io_uring;
+	int ret, fd[100];
+	struct accept_test_args args = {
+		.fixed = true,
+		.multishot = true
+	};
+
+	memset(fd, -1, sizeof(fd));
+	ret = io_uring_queue_init(MAX_FDS + 10, &m_io_uring, 0);
+	assert(ret >= 0);
+	ret = io_uring_register_files(&m_io_uring, fd, MAX_FDS);
+	assert(ret == 0);
+	ret = test(&m_io_uring, args);
+	io_uring_queue_exit(&m_io_uring);
+	return ret;
+}
+
 static int test_accept_sqpoll(void)
 {
 	struct io_uring m_io_uring;
@@ -512,7 +623,6 @@ int main(int argc, char *argv[])
 
 	if (argc > 1)
 		return 0;
-
 	ret = test_accept(1, false);
 	if (ret) {
 		fprintf(stderr, "test_accept failed\n");
@@ -557,36 +667,78 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_multishot_fixed_accept();
+	if (ret) {
+		fprintf(stderr, "test_multishot_fixed_accept failed\n");
+		return ret;
+	}
+
 	ret = test_accept_sqpoll();
 	if (ret) {
 		fprintf(stderr, "test_accept_sqpoll failed\n");
 		return ret;
 	}
 
-	ret = test_accept_cancel(0, 1);
+	ret = test_accept_cancel(0, 1, false);
 	if (ret) {
 		fprintf(stderr, "test_accept_cancel nodelay failed\n");
 		return ret;
 	}
 
-	ret = test_accept_cancel(10000, 1);
+	ret = test_accept_cancel(10000, 1, false);
 	if (ret) {
 		fprintf(stderr, "test_accept_cancel delay failed\n");
 		return ret;
 	}
 
-	ret = test_accept_cancel(0, 4);
+	ret = test_accept_cancel(0, 4, false);
 	if (ret) {
 		fprintf(stderr, "test_accept_cancel nodelay failed\n");
 		return ret;
 	}
 
-	ret = test_accept_cancel(10000, 4);
+	ret = test_accept_cancel(10000, 4, false);
 	if (ret) {
 		fprintf(stderr, "test_accept_cancel delay failed\n");
 		return ret;
 	}
 
+	ret = test_accept_cancel(0, 1, true);
+	if (ret) {
+		fprintf(stderr, "test_accept_cancel multishot nodelay failed\n");
+		return ret;
+	}
+
+	ret = test_accept_cancel(10000, 1, true);
+	if (ret) {
+		fprintf(stderr, "test_accept_cancel multishot delay failed\n");
+		return ret;
+	}
+
+	ret = test_accept_cancel(0, 4, true);
+	if (ret) {
+		fprintf(stderr, "test_accept_cancel multishot nodelay failed\n");
+		return ret;
+	}
+
+	ret = test_accept_cancel(10000, 4, true);
+	if (ret) {
+		fprintf(stderr, "test_accept_cancel multishot delay failed\n");
+		return ret;
+	}
+
+	ret = test_multishot_accept(1, false);
+	if (ret) {
+		fprintf(stderr, "test_multishot_accept(1, false) failed\n");
+		return ret;
+	}
+
+	ret = test_multishot_accept(1, true);
+	if (ret) {
+		fprintf(stderr, "test_multishot_accept(1, true) failed\n");
+		return ret;
+	}
+
 	ret = test_accept_many((struct test_accept_many_args) {});
 	if (ret) {
 		fprintf(stderr, "test_accept_many failed\n");
@@ -621,6 +773,5 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "test_accept_pending_on_exit failed\n");
 		return ret;
 	}
-
 	return 0;
 }
-- 
2.36.0

