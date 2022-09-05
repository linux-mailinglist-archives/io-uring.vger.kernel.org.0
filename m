Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F375AD4B0
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 16:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiIEOXg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbiIEOXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 10:23:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3F73B958
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 07:23:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b16so11581274edd.4
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 07:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=hIx/uQLZr8G/oqBxR1JafNpk64QXFQUgFBNLn+IqcbQ=;
        b=lzz1RFQ9AZR42XudEozXp0RbZ7IjwuK8NAJYsQtsGZ1fwIKxreMhm+/YT7ixPxKk/U
         GZo1i/jzQ/V5KLiDUGxijuCouV2iDS8T0vC5BlzWKUivxjnoIGB7IT9n/Qsgumzfl7tg
         0Hzj6jkr37SvqaO/Ng4i4DKSHBJnlRoiSndUD34bwyYrYOCaFeL0J/3XAqUKwoN4uvyF
         OuSwC/bFOHCkJUGgZcS42g4Y0btGuDybav66znAD5V05+mife/1cT0vAwYKEJb3y/nm8
         RpA1kKfULhqCpTMHP8SRBNRO9p1Z8HdG3f2zj+gegob0vcIrdOwkWoUw0tPtEkMdHBe7
         DOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hIx/uQLZr8G/oqBxR1JafNpk64QXFQUgFBNLn+IqcbQ=;
        b=MFyG4m/xg9GvNuyONi6xY+GXRob8ek7t5YKBOQrflISMqfNk90ZOznWzm7/6Jhnh6v
         NZasR0Omd5fxeG56e8CqFD6e/MzOr1zrowbYZVdZjwesrb1D0ziR5SuiPog5cDDzuFad
         mb1gUR5Os+37sR0LJ9tqxYMvjld56XQa5zIknKoqrzqHgQyjQhABkdgFmXTjEY5e8QFh
         3mgylvB3GJxU97VVGckMiREjFXVEndJP4RubVBMMPoNM2eqOlAPg5INcrZ8oJ6hmVDfy
         SdipgEYUEZEP7g4bZwrkP95qtT+HM3oYa0kH8Yo9rbIO6GpxHGhX7Xf8qqvDGWrhWJss
         o06w==
X-Gm-Message-State: ACgBeo3N83SwDNvBaF9RwKZbWCWfC56o8mPUm8XuY9fkhaIWpVVxIJDx
        kYbf7Kr1VTWmTmSYDEp3Ue2EKPlKSo0=
X-Google-Smtp-Source: AA6agR5mq9IGSlttpWvWItpiptqVfoYoWblNGdyWLFraI0wrBAoJlAGFnzwHWFmO6FzffpLS+pmAsA==
X-Received: by 2002:a05:6402:1f01:b0:445:fbe8:4b2e with SMTP id b1-20020a0564021f0100b00445fbe84b2emr43561862edb.192.1662387807350;
        Mon, 05 Sep 2022 07:23:27 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a118])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709064bca00b0074182109623sm5168799ejv.39.2022.09.05.07.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 07:23:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/4] tests/zc: use io_uring for rx
Date:   Mon,  5 Sep 2022 15:21:04 +0100
Message-Id: <fa126293c94da4ca445bc606fcc6ff16c832eabe.1662387423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662387423.git.asml.silence@gmail.com>
References: <cover.1662387423.git.asml.silence@gmail.com>
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

Recieve via io_uring, this simplifies code by removing forking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 70 +++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 46 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 0a8531e..f80a5cd 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -44,7 +44,7 @@
 #define HOST	"127.0.0.1"
 #define HOSTV6	"::1"
 
-#define ZC_TAG 10000
+#define RX_TAG 10000
 #define BUFFER_OFFSET 41
 
 #ifndef ARRAY_SIZE
@@ -250,8 +250,6 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
-	pid_t p;
-	int wstatus;
 
 	memset(rx_buffer, 0, send_size);
 
@@ -289,42 +287,17 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			sqe->flags |= IOSQE_ASYNC;
 	}
 
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_recv(sqe, sock_server, rx_buffer, send_size, MSG_WAITALL);
+	sqe->user_data = RX_TAG;
+
 	ret = io_uring_submit(ring);
-	if (ret != nr_reqs) {
+	if (ret != nr_reqs + 1) {
 		fprintf(stderr, "submit failed, got %i expected %i\n", ret, nr_reqs);
 		return 1;
 	}
 
-	p = fork();
-	if (p == -1) {
-		fprintf(stderr, "fork() failed\n");
-		return 1;
-	} else if (p == 0) {
-		size_t bytes_received = 0;
-
-		while (bytes_received != send_size) {
-			ret = recv(sock_server,
-				   rx_buffer + bytes_received,
-				   send_size - bytes_received, 0);
-			if (ret <= 0) {
-				fprintf(stderr, "recv failed, got %i, errno %i\n",
-					ret, errno);
-				exit(1);
-			}
-			bytes_received += ret;
-		}
-
-		for (i = 0; i < send_size; i++) {
-			if (buf[i] != rx_buffer[i]) {
-				fprintf(stderr, "botched data, first mismated byte %i, "
-					"%u vs %u\n", i, buf[i], rx_buffer[i]);
-				exit(1);
-			}
-		}
-		exit(0);
-	}
-
-	nr_cqes = 2 * nr_reqs;
+	nr_cqes = 2 * nr_reqs + 1;
 	for (i = 0; i < nr_cqes; i++) {
 		int expected = chunk_size;
 
@@ -333,8 +306,18 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			fprintf(stderr, "io_uring_wait_cqe failed %i\n", ret);
 			return 1;
 		}
+		if (cqe->user_data == RX_TAG) {
+			if (cqe->res != send_size) {
+				fprintf(stderr, "rx failed %i\n", cqe->res);
+				return 1;
+			}
+			io_uring_cqe_seen(ring, cqe);
+			continue;
+		}
+
 		if (cqe->user_data >= nr_reqs) {
-			fprintf(stderr, "invalid user_data\n");
+			fprintf(stderr, "invalid user_data %lu\n",
+					(unsigned long)cqe->user_data);
 			return 1;
 		}
 		if (!(cqe->flags & IORING_CQE_F_NOTIF)) {
@@ -354,17 +337,12 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		io_uring_cqe_seen(ring, cqe);
 	}
 
-	if (waitpid(p, &wstatus, 0) == (pid_t)-1) {
-		perror("waitpid()");
-		return 1;
-	}
-	if (!WIFEXITED(wstatus)) {
-		fprintf(stderr, "child failed %i\n", WEXITSTATUS(wstatus));
-		return 1;
-	}
-	if (WEXITSTATUS(wstatus)) {
-		fprintf(stderr, "child failed\n");
-		return 1;
+	for (i = 0; i < send_size; i++) {
+		if (buf[i] != rx_buffer[i]) {
+			fprintf(stderr, "botched data, first mismated byte %i, "
+				"%u vs %u\n", i, buf[i], rx_buffer[i]);
+			return 1;
+		}
 	}
 	return 0;
 }
-- 
2.37.2

