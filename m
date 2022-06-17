Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436B854F36B
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381355AbiFQIpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381359AbiFQIpi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:45:38 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595B06A048
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:45:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c13so799064eds.10
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YOid4TZPDFSstLq1udFewCAf/k9umRs9BDiZHIXtkMU=;
        b=kLmSeuRWdlwURdPRisYlj3lkSd/1zcdFwML+hESEE1KSIxdNmuc6RlU+4LAU/8EdvY
         11pe61NQC7EzDboPy3i8FN/Vg7vjoo5eb52r+58RfGEsTaYiqfFG2U2HQTExCoIedt3i
         Dl4ERyXo7gNlARMJFuHtIn/0+Z9shtQbEtnW109KB58yxzFTrXXIiGO6uWp809xQrB1w
         ZaKxmMd5CpeDChEvMgF9QpHnV87l/2qSQHhoseQaoeZXxW47s7UrJxMyKiYokJSoLCs7
         OETJwjtnxds/nlCgc340W7jodJHScfn6TX69H5jxY0h3tEhap6Q/9/+SJazMJnqq2s5Q
         z3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YOid4TZPDFSstLq1udFewCAf/k9umRs9BDiZHIXtkMU=;
        b=GbX1pYJfRMmZ4Iar3HsG22UCEybq4zXWS/RET6JiXH54ahW8rcGqyDjXqdYAm8/UIS
         ccJiKTRoSei0G2AzPwrfKa7A4wFTWIflfnN3lpjq2tHM/9GulnuL9agdCvcYb7U1IcvY
         SVsNJSse2YV0KzGVBZ1PFR/zm8jcstrfDqkYd32ZmIi75HwGZ7JMHQRmtWD0z88AHe51
         TVd0HLkGuf0oFPQFhHW6LbwMMlxKJc2AKXz0aEGLeyjl9LTrQOPMv0TqiWrVZpT0c9NN
         oAxPZjeaNfz55ZMpMbis1Ryj/sHX7QDKYOv/9HllFaGKXrqUZ49ObBw97QWxJ7Dtvmr8
         XSQQ==
X-Gm-Message-State: AJIora+vjw/TV8AzPN7pg8Ag/KmZwnVgVLdiVTjJAcBKy3kvakPzXWJj
        2ZyMajyuMjGHMR9ydXiDm56wb4p9E88rGQ==
X-Google-Smtp-Source: AGRyM1vClHFQkMjzD5zBfXs6BknaFHqT045o15B3ZamGtkIAP/qa7ziT3MRlxbozf4LU3/a90b02tw==
X-Received: by 2002:a05:6402:2804:b0:431:7dde:6fb5 with SMTP id h4-20020a056402280400b004317dde6fb5mr11115700ede.379.1655455526589;
        Fri, 17 Jun 2022 01:45:26 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id ot21-20020a170906ccd500b006f3ef214e0esm1844106ejb.116.2022.06.17.01.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:45:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/2] tests: fix and improve nop tests
Date:   Fri, 17 Jun 2022 09:42:42 +0100
Message-Id: <92f01041e5ef933a6018bd89dd54cc1fae57c6f6.1655455225.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455225.git.asml.silence@gmail.com>
References: <cover.1655455225.git.asml.silence@gmail.com>
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

We removed CQE32 for nops from the kernel, fix the tests and instead
test that we return zeroes in the extra fields instead of garbage.
Loop over the tests multiple times so it exhausts CQ and we also test
CQ entries recycling and internal caching mechanism. Also excersie
IOSQE_ASYNC.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/nop.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/test/nop.c b/test/nop.c
index ce223b3..1aa88fc 100644
--- a/test/nop.c
+++ b/test/nop.c
@@ -15,7 +15,7 @@
 
 static int seq;
 
-static int test_single_nop(struct io_uring *ring)
+static int test_single_nop(struct io_uring *ring, unsigned req_flags)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -29,11 +29,8 @@ static int test_single_nop(struct io_uring *ring)
 	}
 
 	io_uring_prep_nop(sqe);
-	if (cqe32) {
-		sqe->addr = 1234;
-		sqe->addr2 = 5678;
-	}
 	sqe->user_data = ++seq;
+	sqe->flags |= req_flags;
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -51,12 +48,12 @@ static int test_single_nop(struct io_uring *ring)
 		goto err;
 	}
 	if (cqe32) {
-		if (cqe->big_cqe[0] != 1234) {
+		if (cqe->big_cqe[0] != 0) {
 			fprintf(stderr, "Unexpected extra1\n");
 			goto err;
 
 		}
-		if (cqe->big_cqe[1] != 5678) {
+		if (cqe->big_cqe[1] != 0) {
 			fprintf(stderr, "Unexpected extra2\n");
 			goto err;
 		}
@@ -67,7 +64,7 @@ err:
 	return 1;
 }
 
-static int test_barrier_nop(struct io_uring *ring)
+static int test_barrier_nop(struct io_uring *ring, unsigned req_flags)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -84,11 +81,8 @@ static int test_barrier_nop(struct io_uring *ring)
 		io_uring_prep_nop(sqe);
 		if (i == 4)
 			sqe->flags = IOSQE_IO_DRAIN;
-		if (cqe32) {
-			sqe->addr = 1234;
-			sqe->addr2 = 5678;
-		}
 		sqe->user_data = ++seq;
+		sqe->flags |= req_flags;
 	}
 
 	ret = io_uring_submit(ring);
@@ -111,11 +105,11 @@ static int test_barrier_nop(struct io_uring *ring)
 			goto err;
 		}
 		if (cqe32) {
-			if (cqe->big_cqe[0] != 1234) {
+			if (cqe->big_cqe[0] != 0) {
 				fprintf(stderr, "Unexpected extra1\n");
 				goto err;
 			}
-			if (cqe->big_cqe[1] != 5678) {
+			if (cqe->big_cqe[1] != 0) {
 				fprintf(stderr, "Unexpected extra2\n");
 				goto err;
 			}
@@ -132,7 +126,7 @@ static int test_ring(unsigned flags)
 {
 	struct io_uring ring;
 	struct io_uring_params p = { };
-	int ret;
+	int ret, i;
 
 	p.flags = flags;
 	ret = io_uring_queue_init_params(8, &ring, &p);
@@ -143,18 +137,21 @@ static int test_ring(unsigned flags)
 		return 1;
 	}
 
-	ret = test_single_nop(&ring);
-	if (ret) {
-		fprintf(stderr, "test_single_nop failed\n");
-		goto err;
-	}
+	for (i = 0; i < 1000; i++) {
+		unsigned req_flags = (i & 1) ? IOSQE_ASYNC : 0;
 
-	ret = test_barrier_nop(&ring);
-	if (ret) {
-		fprintf(stderr, "test_barrier_nop failed\n");
-		goto err;
-	}
+		ret = test_single_nop(&ring, req_flags);
+		if (ret) {
+			fprintf(stderr, "test_single_nop failed\n");
+			goto err;
+		}
 
+		ret = test_barrier_nop(&ring, req_flags);
+		if (ret) {
+			fprintf(stderr, "test_barrier_nop failed\n");
+			goto err;
+		}
+	}
 err:
 	io_uring_queue_exit(&ring);
 	return ret;
-- 
2.36.1

