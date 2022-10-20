Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE0160552E
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJTBvF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiJTBvE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:51:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD00615D0A1
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id w18so44020232ejq.11
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45GHw6V/7uqAj8k1un4TXI/4zJ+SdB7YUmTI6896xLY=;
        b=NzJM18oeIKRaiXASR/lKCKDpGlUtITOu7tLiZWrV8y3G+43xhUjl/v7HPTOJT5ow7e
         r0w5TnXFxYi8pG2YbRlaR9n/xf7J4bYzc9nH4sW0t1TWZK4+9SG4lWyhsh67oMDKaqMr
         0uiV1XCk0XsIZXuQaqI61Ke/pmeyUdkwiWKjYGw1c/pXvyyeKXo6S6xtx9nQqhe/kcI6
         gs5eGOpxWGMwsbtFuFiw1+Bc9z1lHktx7uveZ9KToA9SSg1ahnZDSZaIRFA+Y7/YfGpI
         cNpuboLDVvueXc1+GwOgeWxZO6XTwrO0cRMXqRuL50grJAnzpi5KeS/AzDR46ohxuqit
         4I2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45GHw6V/7uqAj8k1un4TXI/4zJ+SdB7YUmTI6896xLY=;
        b=vs8eR12vfoeDNQhKYjqodFZ7dnzsiO7wcxenGOHs7oNyOocLnIkSwVV/O9/nWU+2EV
         4w3X+5Cf5cLhv1cwP381eFRLqerlPqSJkjYHgp05THhUu63i9cD0+3S+KRBe85rcvPha
         vreEcOuztuC9ogmHQyzn5ULfd/+ummkEe8MeTXOvM7gS+XjaCrO30kiQ/WqslMLkLuec
         kJDe00iS8gfxjpJ5Xo7QbdLH4aQJqkmJXczuUP24SS4AHyJjfQC96OOZc9rcVgtwZvzD
         vpKWdA1K4L6QljD51h3or816LXTKMlh57+gW0+YX2NAbQuJo5ycYJyrHURoUrH6M3VkX
         0iug==
X-Gm-Message-State: ACrzQf3na0rDji52JC9dKZ9sX2U8gnvuMxnZCWP3s9d8RxpwC7lC47ll
        6/kmWxU56dHEg39yX7dMBZQGxmwo4lE=
X-Google-Smtp-Source: AMsMyM4RFhuLEIvu1V7oRjxScLUz3yvbRYxd5iMICixmQa6tmveW1yI60iuaRIcbM55xhmnrSUmJvg==
X-Received: by 2002:a17:906:ef8b:b0:791:9980:b7b9 with SMTP id ze11-20020a170906ef8b00b007919980b7b9mr9038738ejb.636.1666230661137;
        Wed, 19 Oct 2022 18:51:01 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a50ff0d000000b00451319a43dasm11318420edu.2.2022.10.19.18.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:51:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing for-next 1/5] tests: improve zc cflags handling
Date:   Thu, 20 Oct 2022 02:49:51 +0100
Message-Id: <8ce91fa37051e2b36d5fbb1735a19e2573b2838d.1666230529.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666230529.git.asml.silence@gmail.com>
References: <cover.1666230529.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a couple of tweaks, count nr_cqes on in the loop, so it's easier to
adapt for other test cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 4db102b..005220d 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -288,9 +288,9 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		if (mix_register)
 			real_fixed_buf = rand() & 1;
 
-		if (cork && i != nr_reqs - 1)
+		if (i != nr_reqs - 1)
 			msg_flags |= MSG_MORE;
-		if (i == nr_reqs - 1)
+		else
 			cur_size = chunk_size_last;
 
 		sqe = io_uring_get_sqe(ring);
@@ -335,7 +335,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		return 1;
 	}
 
-	nr_cqes = 2 * nr_reqs + 1;
+	nr_cqes = nr_reqs + 1;
 	for (i = 0; i < nr_cqes; i++) {
 		int expected = chunk_size;
 
@@ -352,13 +352,19 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			io_uring_cqe_seen(ring, cqe);
 			continue;
 		}
-
+		if ((cqe->flags & IORING_CQE_F_MORE) && (cqe->flags & IORING_CQE_F_NOTIF)) {
+			fprintf(stderr, "unexpected cflags %i res %i\n",
+					cqe->flags, cqe->res);
+			return 1;
+		}
 		if (cqe->user_data >= nr_reqs) {
 			fprintf(stderr, "invalid user_data %lu\n",
 					(unsigned long)cqe->user_data);
 			return 1;
 		}
 		if (!(cqe->flags & IORING_CQE_F_NOTIF)) {
+			if (cqe->flags & IORING_CQE_F_MORE)
+				nr_cqes++;
 			if (cqe->user_data == nr_reqs - 1)
 				expected = chunk_size_last;
 			if (cqe->res != expected) {
@@ -367,12 +373,6 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 				return 1;
 			}
 		}
-		if ((cqe->flags & IORING_CQE_F_MORE) ==
-		    (cqe->flags & IORING_CQE_F_NOTIF)) {
-			fprintf(stderr, "unexpected cflags %i res %i\n",
-					cqe->flags, cqe->res);
-			return 1;
-		}
 		io_uring_cqe_seen(ring, cqe);
 	}
 
-- 
2.38.0

