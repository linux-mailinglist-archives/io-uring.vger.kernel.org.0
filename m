Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551F96FE087
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbjEJOkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 10:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbjEJOkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 10:40:19 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F97A86B9;
        Wed, 10 May 2023 07:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1683729613;
        bh=koxG1YCExChvSpEVnSP+x7jAE+o8CIdHy2OpuhUjaJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=X+qHB8fvNCw86u2Cujt2PHfki8wfPRHo4zgUTEq//5z1JDq17dYGK3uB7vP5e0S0R
         Bge8beofZdAA74v47nAg84hxdELO/93OMfR3OG5PNoqppBsiIcijmNimfN3jysxa87
         lu5FLpbOjJhh3kXyehlDc1p8aEZHux8VbSj4ijeu7UFCqIJOHnw5NdE0C/20R+puGn
         6Jr8KlS/oesyVLJlzV4fcHynNp1il8G3FbBwHNj9Duq1ErXXYIAOLLBtdCPPmvvhP8
         zHsG0wDAKtJfXuc9IB2hx+czdDR+gOk5Zk/jT2aaSLVXjRR2Is2ZcANP0e6FcT/4dI
         fkScEkT1F/XHQ==
Received: from integral2.. (unknown [101.128.114.135])
        by gnuweeb.org (Postfix) with ESMTPSA id C6E48245CF5;
        Wed, 10 May 2023 21:40:10 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 1/2] recv-msgall: Fix undefined behavior in `recv_prep()`
Date:   Wed, 10 May 2023 21:39:26 +0700
Message-Id: <20230510143927.123170-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230510143927.123170-1-ammarfaizi2@gnuweeb.org>
References: <20230510143927.123170-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The lifetime of `struct msghdr msg;` must be long enough until the CQE
is generated because the recvmsg operation will write to that storage. I
found this test segfault when compiling with -O0 optimization. This is
undefined behavior and may behave randomly.

Fix this by making the lifetime of `struct msghdr msg;` long enough.

Fixes: https://github.com/axboe/liburing/issues/855
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/recv-msgall.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/test/recv-msgall.c b/test/recv-msgall.c
index ae123e4c381b2b1a..f809834b2e427fc5 100644
--- a/test/recv-msgall.c
+++ b/test/recv-msgall.c
@@ -18,14 +18,18 @@
 #define MAX_MSG	128
 #define HOST	"127.0.0.1"
 static __be16 bind_port;
+struct recv_data {
+	pthread_mutex_t mutex;
+	int use_recvmsg;
+	struct msghdr msg;
+};
 
 static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
-		     int use_recvmsg)
+		     struct recv_data *rd)
 {
 	struct sockaddr_in saddr;
 	struct io_uring_sqe *sqe;
 	int sockfd, ret, val;
-	struct msghdr msg = { };
 
 	memset(&saddr, 0, sizeof(saddr));
 	saddr.sin_family = AF_INET;
@@ -47,14 +51,17 @@ static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
 	bind_port = saddr.sin_port;
 
 	sqe = io_uring_get_sqe(ring);
-	if (!use_recvmsg) {
+	if (!rd->use_recvmsg) {
 		io_uring_prep_recv(sqe, sockfd, iov->iov_base, iov->iov_len,
 					MSG_WAITALL);
 	} else {
-		msg.msg_namelen = sizeof(struct sockaddr_in);
-		msg.msg_iov = iov;
-		msg.msg_iovlen = 1;
-		io_uring_prep_recvmsg(sqe, sockfd, &msg, MSG_WAITALL);
+		struct msghdr *msg = &rd->msg;
+
+		memset(msg, 0, sizeof(*msg));
+		msg->msg_namelen = sizeof(struct sockaddr_in);
+		msg->msg_iov = iov;
+		msg->msg_iovlen = 1;
+		io_uring_prep_recvmsg(sqe, sockfd, msg, MSG_WAITALL);
 	}
 
 	sqe->user_data = 2;
@@ -101,11 +108,6 @@ err:
 	return 1;
 }
 
-struct recv_data {
-	pthread_mutex_t mutex;
-	int use_recvmsg;
-};
-
 static void *recv_fn(void *data)
 {
 	struct recv_data *rd = data;
@@ -128,7 +130,7 @@ static void *recv_fn(void *data)
 		goto err;
 	}
 
-	ret = recv_prep(&ring, &iov, &sock, rd->use_recvmsg);
+	ret = recv_prep(&ring, &iov, &sock, rd);
 	if (ret) {
 		fprintf(stderr, "recv_prep failed: %d\n", ret);
 		goto err;
-- 
Ammar Faizi

