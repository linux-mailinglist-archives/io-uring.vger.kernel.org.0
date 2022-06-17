Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FCC54F943
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiFQOgU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382489AbiFQOgT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:36:19 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D44855482
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:36:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655476577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zSkVl+4rPf4mNONh6RBRRAHUQaelVQxjdXobd53sQyE=;
        b=PTI3UJH3wCmBFQ0O4LSj02x6ExvafNZ2uyeWOumvMA2xd15tQuMxfJrOf4pZd/WWojFZmT
        mzTVcw9uHVA8yp9JeH5ZHsmemf2/s05RyQgZip2trebnqJyzWt/Mhn4FJk6rVkraSE6s/4
        Dv38qAZQagTzgAcEZn9qMtKzn+GE1V8=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/3] test/accept: clean code of accept test
Date:   Fri, 17 Jun 2022 22:36:03 +0800
Message-Id: <20220617143603.179277-4-hao.xu@linux.dev>
In-Reply-To: <20220617143603.179277-1-hao.xu@linux.dev>
References: <20220617143603.179277-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

This does three things:
 - change multishot_mask from uint to uint32_t
 - change multishot_mask != UINT_MAX check to ~multishot_mask != 0

The above two avoid compiler and arch influence. Make the logic more robost.

 - other cleaning to make code clearer.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 test/accept.c | 66 +++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index b322c018c7a9..78eba352a943 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -41,6 +41,21 @@ struct accept_test_args {
 	int extra_loops;
 };
 
+static void close_fds(int fds[], int nr)
+{
+	int i;
+
+	for (i = 0; i < nr; i++)
+		close(fds[i]);
+}
+
+static void close_sock_fds(int s_fd[], int c_fd[], int nr, bool fixed)
+{
+	if (!fixed)
+		close_fds(s_fd, nr);
+	close_fds(c_fd, nr);
+}
+
 static void queue_send(struct io_uring *ring, int fd)
 {
 	struct io_uring_sqe *sqe;
@@ -198,19 +213,17 @@ static int test_loop(struct io_uring *ring,
 	int i, ret, s_fd[MAX_FDS], c_fd[MAX_FDS], done = 0;
 	bool fixed = args.fixed;
 	bool multishot = args.multishot;
-	unsigned int multishot_mask = 0;
+	uint32_t multishot_mask = 0;
+	int nr_fds = multishot ? MAX_FDS : 1;
 
-	for (i = 0; i < MAX_FDS; i++) {
+	for (i = 0; i < nr_fds; i++)
 		c_fd[i] = set_client_fd(addr);
-		if (!multishot)
-			break;
-	}
 
 	if (!args.queue_accept_before_connect)
 		queue_accept_conn(ring, recv_s0, args);
 
-	for (i = 0; i < MAX_FDS; i++) {
-		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1, multishot);
+	for (i = 0; i < nr_fds; i++) {
+		s_fd[i] = accept_conn(ring, fixed ? 0 : -1, multishot);
 		if (s_fd[i] == -EINVAL) {
 			if (args.accept_should_error)
 				goto out;
@@ -241,14 +254,17 @@ static int test_loop(struct io_uring *ring,
 					i, s_fd[i]);
 				goto err;
 			}
+			/*
+			 * for fixed multishot accept test, the file slots
+			 * allocated are [0, 32), this means we finally end up
+			 * with each bit of a u32 being 1.
+			 */
 			multishot_mask |= (1U << s_fd[i]);
 		}
-		if (!multishot)
-			break;
 	}
 
 	if (multishot) {
-		if (fixed && multishot_mask != UINT_MAX) {
+		if (fixed && (~multishot_mask != 0U)) {
 			fprintf(stderr, "Fixed Multishot Accept misses events\n");
 			goto err;
 		}
@@ -256,7 +272,7 @@ static int test_loop(struct io_uring *ring,
 	}
 
 	queue_send(ring, c_fd[0]);
-	queue_recv(ring, s_fd[0], args.fixed);
+	queue_recv(ring, s_fd[0], fixed);
 
 	ret = io_uring_submit_and_wait(ring, 2);
 	assert(ret != -1);
@@ -280,32 +296,10 @@ static int test_loop(struct io_uring *ring,
 	}
 
 out:
-	if (!args.fixed) {
-		for (i = 0; i < MAX_FDS; i++) {
-			close(s_fd[i]);
-			if (!multishot)
-				break;
-		}
-	}
-	for (i = 0; i < MAX_FDS; i++) {
-		close(c_fd[i]);
-		if (!multishot)
-			break;
-	}
+	close_sock_fds(s_fd, c_fd, nr_fds, fixed);
 	return 0;
 err:
-	if (!args.fixed) {
-		for (i = 0; i < MAX_FDS; i++) {
-			close(s_fd[i]);
-			if (!multishot)
-				break;
-		}
-	}
-	for (i = 0; i < MAX_FDS; i++) {
-		close(c_fd[i]);
-		if (!multishot)
-			break;
-	}
+	close_sock_fds(s_fd, c_fd, nr_fds, fixed);
 	return 1;
 }
 
@@ -627,7 +621,7 @@ static int test_accept_fixed(void)
 static int test_multishot_fixed_accept(void)
 {
 	struct io_uring m_io_uring;
-	int ret, fd[100];
+	int ret, fd[MAX_FDS];
 	struct accept_test_args args = {
 		.fixed = true,
 		.multishot = true
-- 
2.25.1

