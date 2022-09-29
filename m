Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C7E5EEA67
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 02:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiI2AFB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 20:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiI2AE7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 20:04:59 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D465B051
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:58 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id cc5so22100045wrb.6
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xuf35eDdmgnfP746vQ9rPpPl8nRl8vGm+d8UsiKTck0=;
        b=GSn66RQfrq7IuerFkmJ7mNz4N/1c2quOvSvAEwIk8Km2YBxH9oeEmIifg7yu/6hqIb
         vl4+rZI6R2RWhy9nS3ZI9JQZXsQ87P4aHC+ZdTCFWy/q5DWadagCyuojgW5XYd/NSbDG
         Xo9ZtfMqz2T/Y30iMWdPJxNSjt6FkOMurhEAThCOsSs1pxGt0u0HvzCEFJijvri6y3nY
         VqXchglIvcJ1wiyCf67Qf6U1+/eQdHkgN32X2QPOfOrmSOvrqrzJijwKP9sdDdJM/a5r
         ZtfJZrNCwPAN5Q3wglfzmRe1v/MIRzSueCpiemmCGcHwQjn79+KQjVcCrx18u9vtdUmr
         7hPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xuf35eDdmgnfP746vQ9rPpPl8nRl8vGm+d8UsiKTck0=;
        b=IzRWUs1dweYcTOLLjHdAhQ293lrOwTNDX89dK0T+1tUa0JZxiWmiAe7MHrr0vURvJt
         OiVtaal3F0JrVi8+0JhsYCnNCyVKTGcPe83rsy7FWF5HH7Ekaz69oVxAQpfvJ0uqEA2F
         USOX8Dm4en4267CNQ6MggZ3Sdu20b992gUIODVO1dsfhSI/EQkVRTy5vkg62lrBENsj2
         WSVVp527fuTewYFZki683G2RgmEI76cOKVqhBfn627sCsOQ9k6GaoZOf73luqJeX3IcE
         u+eNvvTqd7FwBg536LT5HveZVew+dRE+DN9Lc/GxJN3R9C10pnhzj0/eDtkEzQ+4OWWI
         dGyw==
X-Gm-Message-State: ACrzQf3mb/Pkk+QsxBGe2DaoR3whiRfCQu6/HS/XAf1ngYR2Keyp0PaI
        +t0h70Z0dsBHTqfFp+5lBLXWEnAcfWI=
X-Google-Smtp-Source: AMsMyM7BaCWPYc5X7t3oQR/OaGh5HxMNH1gASb09qS2TP9CBcGBJsA5i1qb5ipRVR0KBaTACmJTYmQ==
X-Received: by 2002:adf:f501:0:b0:22c:cbea:240a with SMTP id q1-20020adff501000000b0022ccbea240amr238877wro.78.1664409896305;
        Wed, 28 Sep 2022 17:04:56 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c4e8e00b003b47e75b401sm3284705wmq.37.2022.09.28.17.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 17:04:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/4] tests: improve zc cflags handling
Date:   Thu, 29 Sep 2022 01:03:49 +0100
Message-Id: <4ab6329e9a9dc619e009dd8273345bca5ee36584.1664409593.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664409593.git.asml.silence@gmail.com>
References: <cover.1664409593.git.asml.silence@gmail.com>
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
index 31d66e3..e58b11c 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -283,9 +283,9 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		if (mix_register)
 			real_fixed_buf = rand() & 1;
 
-		if (cork && i != nr_reqs - 1)
+		if (i != nr_reqs - 1)
 			msg_flags |= MSG_MORE;
-		if (i == nr_reqs - 1)
+		else
 			cur_size = chunk_size_last;
 
 		sqe = io_uring_get_sqe(ring);
@@ -330,7 +330,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		return 1;
 	}
 
-	nr_cqes = 2 * nr_reqs + 1;
+	nr_cqes = nr_reqs + 1;
 	for (i = 0; i < nr_cqes; i++) {
 		int expected = chunk_size;
 
@@ -347,13 +347,19 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
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
@@ -362,12 +368,6 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
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
2.37.2

