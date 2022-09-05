Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7755ADB1D
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiIEWIQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiIEWIP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:08:15 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F3F51A0D
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:08:13 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n17so12894629wrm.4
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=hIx/uQLZr8G/oqBxR1JafNpk64QXFQUgFBNLn+IqcbQ=;
        b=TtkupnSCgAV8btJwBl92bWeryNQbLKzrK8YlgJdjolRLQQhWpw4bney3JokuOV7Qco
         +pCkOMsVv9KbuEzhHIYNkqGHlV+xF9VO0VxyiwpdXPpZw37vCQy7ipgK6VHeaEeqeWvY
         hBvQd8yav9S8CSeDSJq+OILC6lQxN2F0SyFTt2jRHNXT5z8B38jMQt1bkntrYRcbNkKQ
         UpGHLKO4ksUsUTRXx+yA40izwWiLHQGVAI3lbA0RpLiPZOImVvNz3J/BJkU+pDyL5YEo
         vCeFw+UryMo1uqLNEFpcHFaxig+YNdpKhDARAfj0xDepldvgZL1xBGihfnXvKArQAGea
         CyRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=hIx/uQLZr8G/oqBxR1JafNpk64QXFQUgFBNLn+IqcbQ=;
        b=GvNWWeQpqL8VDMTxoBiM8+atQaTtn0eWsX+NdaWLvOquy6uy8n/sZiCypMIFo5Xlg8
         WKSOLn8DzzfZO9IxRDb/6rVGjAjT1p23UKq4Oml1KrMfpStfoK36TV4C7cbFTsZxAVXv
         ocGxmioFPiC3sdRG8pbv8IyP3AlyR0rbg1XD7nw4sT9o8OeyYxQ/41a9beImwJ+snRTu
         Qp+UHU5S0wtxNY/UeLBEiC/XYCWxAIDgLz3bTUH8axd9cj/zfPNgyaaAnVIF4FOkrQw4
         Bbjr0Jo5cD4eHqxpgpFXsyyPkk/BHvwHhEBlKBO6RoiKC/3KgT4MLXREtcKZMwAPJPX1
         xzuQ==
X-Gm-Message-State: ACgBeo3p06uco/deeGneovbj+FUSZVHheIemBxrOlyEpwAq0BNUOhPeL
        KiRzH40GXcPVyVXX5f95RuKleRZvgTw=
X-Google-Smtp-Source: AA6agR4vRjucT5s/JY2VXDMlosO84w15pPZqboLNcSbRcrXae3Bi7NMNRizSST8ny66kqwOGr1qI9g==
X-Received: by 2002:a5d:544a:0:b0:228:64cd:243b with SMTP id w10-20020a5d544a000000b0022864cd243bmr5069752wrv.238.1662415691829;
        Mon, 05 Sep 2022 15:08:11 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id z7-20020a05600c0a0700b003a5c1e916c8sm33791067wmp.1.2022.09.05.15.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:08:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 2/5] tests/zc: use io_uring for rx
Date:   Mon,  5 Sep 2022 23:05:59 +0100
Message-Id: <fa126293c94da4ca445bc606fcc6ff16c832eabe.1662404421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662404421.git.asml.silence@gmail.com>
References: <cover.1662404421.git.asml.silence@gmail.com>
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

