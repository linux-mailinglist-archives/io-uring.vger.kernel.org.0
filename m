Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400A22B412F
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 11:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgKPKce (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 05:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728511AbgKPKcd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 05:32:33 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C05C0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 02:32:33 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id l1so18076231wrb.9
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 02:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hzkyKiqs+WTIyPESwB7vk7YhR3LMlx+eAl6eye7WjyY=;
        b=q4cJvRdFIJ3JjJ7qqkwGS1dL3Xfl8Sq6enw/kTQRAkkRm/RVECl3fEuGV5by1yE5Vk
         +5wUqg9rhdbP97lDjtQI5YJuDFZvT0nsgsc62DMewE7n3IrCTXsz8bu4PzUWt4CVmXQH
         +hS3maK/eFp2bUtCTTD/IDtS+vqXdE/lP1x4HHjih8hF19nEuFnuTrti8knE07mXLGY5
         sfo/cJptH0a+4ZE6QwbGXryfHHWjzw6bojxoy0YrnBMkngpaud1ZrpEolcXXvjSuEd80
         Xk8K0pOyCrJAQJ0XWDX3aLJsxa0ynTcxToLjVXBPfAx+SJbY8JwF3dVAfD+oo1JMx5Ay
         gphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hzkyKiqs+WTIyPESwB7vk7YhR3LMlx+eAl6eye7WjyY=;
        b=L3EA+AlKUWm5/E4kHzq9/Pxt9wJ5fd8/y6U2mFUxUE7OKkGPF7tTzWT5aiBwTs8uTo
         dAiScE7GXmuAAh/0eI3B6kZQf3TXTfrA5dYPCbEoS+/TPT4p9JdNgbY2KVxsqYtDSBrm
         houdgH9SEeJu0oceGYObxR4XQ6bCYpTfOJovhZiITgfgZ6aMFJiboG32uN+JbNMOQIOy
         CKJ67rL9NXqgJBwtPy9Y8dYyC1rD17TTbNobMad2Sg05I1GK1XEW77ylYdeTmMaaKcQs
         fS01rDUNEO9yld3mlIaqSxUAxo/lFhOS1A++mQditmP3uhTv3T+UAK+Pp9PyKMF0uXLc
         fEHw==
X-Gm-Message-State: AOAM533ZvJQDDrKOW+fpa2PM+GXXVytuFkVkvdU/gJgdq6hnqdAE+i5V
        w1xLyCLZXzX7y6srlakbOjg=
X-Google-Smtp-Source: ABdhPJxwAYvuaUCypDyapYHGEYe0Nvimk8sacHP1nHmGBABltjZmJHZP2t5g87WLcIIcZqn+3vXc7A==
X-Received: by 2002:adf:e983:: with SMTP id h3mr17874411wrm.382.1605522752002;
        Mon, 16 Nov 2020 02:32:32 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id c6sm23930998wrh.74.2020.11.16.02.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 02:32:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] test: long iov recvmsg()/copy
Date:   Mon, 16 Nov 2020 10:29:13 +0000
Message-Id: <f613395a7bf9c7a70f956d96e9d7a5a9101992c4.1605522519.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in a long iov (larger than on-stack cache)  to test that it's
allocated correctly, and copied well if inline execution failed with
-EAGAIN.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send_recvmsg.c | 65 ++++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff --git a/test/send_recvmsg.c b/test/send_recvmsg.c
index 50c8e94..6b513bc 100644
--- a/test/send_recvmsg.c
+++ b/test/send_recvmsg.c
@@ -11,6 +11,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <pthread.h>
+#include <assert.h>
 
 #include "liburing.h"
 
@@ -24,7 +25,10 @@ static char str[] = "This is a test of sendmsg and recvmsg over io_uring!";
 #define BUF_BGID	10
 #define BUF_BID		89
 
-static int recv_prep(struct io_uring *ring, struct iovec *iov, int bgid)
+#define MAX_IOV_COUNT	10
+
+static int recv_prep(struct io_uring *ring, struct iovec iov[], int iov_count,
+		     int bgid)
 {
 	struct sockaddr_in saddr;
 	struct msghdr msg;
@@ -53,11 +57,6 @@ static int recv_prep(struct io_uring *ring, struct iovec *iov, int bgid)
 		goto err;
 	}
 
-	memset(&msg, 0, sizeof(msg));
-        msg.msg_namelen = sizeof(struct sockaddr_in);
-	msg.msg_iov = iov;
-	msg.msg_iovlen = 1;
-
 	sqe = io_uring_get_sqe(ring);
 	if (!sqe) {
 		fprintf(stderr, "io_uring_get_sqe failed\n");
@@ -66,11 +65,15 @@ static int recv_prep(struct io_uring *ring, struct iovec *iov, int bgid)
 
 	io_uring_prep_recvmsg(sqe, sockfd, &msg, 0);
 	if (bgid) {
-		sqe->user_data = (unsigned long) iov->iov_base;
 		iov->iov_base = NULL;
 		sqe->flags |= IOSQE_BUFFER_SELECT;
 		sqe->buf_group = bgid;
+		iov_count = 1;
 	}
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_namelen = sizeof(struct sockaddr_in);
+	msg.msg_iov = iov;
+	msg.msg_iovlen = iov_count;
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -89,9 +92,10 @@ struct recv_data {
 	pthread_mutex_t *mutex;
 	int buf_select;
 	int no_buf_add;
+	int iov_count;
 };
 
-static int do_recvmsg(struct io_uring *ring, struct iovec *iov,
+static int do_recvmsg(struct io_uring *ring, char buf[MAX_MSG + 1],
 		      struct recv_data *rd)
 {
 	struct io_uring_cqe *cqe;
@@ -112,8 +116,6 @@ static int do_recvmsg(struct io_uring *ring, struct iovec *iov,
 		int bid = cqe->flags >> 16;
 		if (bid != BUF_BID)
 			fprintf(stderr, "Buffer ID mismatch %d\n", bid);
-		/* just for passing the pointer to str */
-		iov->iov_base = (void *) (uintptr_t) cqe->user_data;
 	}
 
 	if (rd->no_buf_add && rd->buf_select) {
@@ -127,7 +129,7 @@ static int do_recvmsg(struct io_uring *ring, struct iovec *iov,
 		goto err;
 	}
 
-	if (strcmp(str, iov->iov_base)) {
+	if (strncmp(str, buf, MAX_MSG + 1)) {
 		fprintf(stderr, "string mismatch\n");
 		goto err;
 	}
@@ -137,20 +139,34 @@ err:
 	return 1;
 }
 
+static void init_iov(struct iovec iov[MAX_IOV_COUNT], int iov_to_use,
+		     char buf[MAX_MSG + 1])
+{
+	int i, last_idx = iov_to_use - 1;
+
+	assert(0 < iov_to_use && iov_to_use <= MAX_IOV_COUNT);
+	for (i = 0; i < last_idx; ++i) {
+		iov[i].iov_base = buf + i;
+		iov[i].iov_len = 1;
+	}
+
+	iov[last_idx].iov_base = buf + last_idx;
+	iov[last_idx].iov_len = MAX_MSG - last_idx;
+}
+
 static void *recv_fn(void *data)
 {
 	struct recv_data *rd = data;
 	pthread_mutex_t *mutex = rd->mutex;
 	char buf[MAX_MSG + 1];
-	struct iovec iov = {
-		.iov_base = buf,
-		.iov_len = sizeof(buf) - 1,
-	};
+	struct iovec iov[MAX_IOV_COUNT];
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	struct io_uring ring;
 	int ret;
 
+	init_iov(iov, rd->iov_count, buf);
+
 	ret = io_uring_queue_init(1, &ring, 0);
 	if (ret) {
 		fprintf(stderr, "queue init failed: %d\n", ret);
@@ -184,14 +200,14 @@ static void *recv_fn(void *data)
 		}
 	}
 
-	ret = recv_prep(&ring, &iov, rd->buf_select ? BUF_BGID : 0);
+	ret = recv_prep(&ring, iov, rd->iov_count, rd->buf_select ? BUF_BGID : 0);
 	if (ret) {
 		fprintf(stderr, "recv_prep failed: %d\n", ret);
 		goto err;
 	}
 
 	pthread_mutex_unlock(mutex);
-	ret = do_recvmsg(&ring, &iov, rd);
+	ret = do_recvmsg(&ring, buf, rd);
 
 	io_uring_queue_exit(&ring);
 
@@ -261,7 +277,7 @@ err:
 	return 1;
 }
 
-static int test(int buf_select, int no_buf_add)
+static int test(int buf_select, int no_buf_add, int iov_count)
 {
 	struct recv_data rd;
 	pthread_mutexattr_t attr;
@@ -278,6 +294,7 @@ static int test(int buf_select, int no_buf_add)
 	rd.mutex = &mutex;
 	rd.buf_select = buf_select;
 	rd.no_buf_add = no_buf_add;
+	rd.iov_count = iov_count;
 	ret = pthread_create(&recv_thread, NULL, recv_fn, &rd);
 	if (ret) {
 		fprintf(stderr, "Thread create failed\n");
@@ -299,19 +316,25 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return 0;
 
-	ret = test(0, 0);
+	ret = test(0, 0, 1);
 	if (ret) {
 		fprintf(stderr, "send_recvmsg 0 failed\n");
 		return 1;
 	}
 
-	ret = test(1, 0);
+	ret = test(0, 0, 10);
+	if (ret) {
+		fprintf(stderr, "send_recvmsg multi iov failed\n");
+		return 1;
+	}
+
+	ret = test(1, 0, 1);
 	if (ret) {
 		fprintf(stderr, "send_recvmsg 1 0 failed\n");
 		return 1;
 	}
 
-	ret = test(1, 1);
+	ret = test(1, 1, 1);
 	if (ret) {
 		fprintf(stderr, "send_recvmsg 1 1 failed\n");
 		return 1;
-- 
2.24.0

