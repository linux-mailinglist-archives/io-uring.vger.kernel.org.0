Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8736525E6
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 18:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiLTR7r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 12:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLTR7q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 12:59:46 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB4FDFDC
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 09:59:41 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o5-20020a05600c510500b003d21f02fbaaso11735503wms.4
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 09:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wo8R8yMpL7f0pHtHyXW+OhyukAzx8dC+V+mU0ZTzq0o=;
        b=hIVu8vJSEAWp4tyEKixOflJcdUOzhJz/BLkQYXo3sb8vUJdEJ9DExovoMbez4UNeDH
         8WyugqoDsp78g/zZ2dlLykqrsmmv0cBwoyL32GdP8NwTb2egYanZbWqYSmePQVjQqkba
         wytFQRtAmfaWeemnAcK3r4P+uGAeQHGMdx0eMhDir9f5ph691SXatbaqETkYKZsbj3hQ
         RnP+QC9f17JlQB09vL65i+pc0Nlk31ndEd2SP+Lp2pULCFxKYd4y7ZmZyXJaezr8pPTY
         lYTHHqpB1D4e76gTCEVMqkSmq1bv4T0/wQroyY5ezNGYEzWjki5enwZyjOd9e+nyQLnk
         fWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wo8R8yMpL7f0pHtHyXW+OhyukAzx8dC+V+mU0ZTzq0o=;
        b=LvnGFFaKFDvoUV5JDxJDLHAxx5sE/+Y6XmN5TrPfLkhUf77tmdp209xMR0VAGTLFGc
         WoGR/yzKe1bUzAcx5j4o+/OR9olX4KrgFfCLqGzq+Qou+CmQymQn0Ez2Nh92nkjJjJpM
         /zvuA0vqYf2WrQs62yxyyAstykVw4EzT8X2NpHKTMCgFxu6PUBezih2ItWSfaM3JaZaj
         +32B8hjXN3CWIGRDl0+9acsUisIy//Ab+HIoe8EQ76/r87RvnpODBuTxHhvxXe2KoVkg
         i12hCZAl39bYuVVEqXmAfrrDBdwo/MdhTlSSajW++CyPsK11FsmiTezCeZxzespVM9TB
         TtuQ==
X-Gm-Message-State: ANoB5pmL/rPH1cZUyIxSO4Tzb9DtOh2QeqjXr3GsbMw3V8CSNavq1Mn3
        9Wj8JfuHkZbrbKuQrr1we51/fF2fXDk=
X-Google-Smtp-Source: AA0mqf4AcYon+fjbffVuP6Y3iJPwW7E9JnNqeTMIkdvRakef+WxnECsE5xoQ2B+TAtMALAfUaiUK4g==
X-Received: by 2002:a1c:3802:0:b0:3d2:2043:9cbf with SMTP id f2-20020a1c3802000000b003d220439cbfmr27374401wma.10.1671559180125;
        Tue, 20 Dec 2022 09:59:40 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.109.17.threembb.co.uk. [188.28.109.17])
        by smtp.gmail.com with ESMTPSA id m22-20020a05600c3b1600b003cfd4cf0761sm27067165wms.1.2022.12.20.09.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 09:59:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC] io_uring: wake up optimisations
Date:   Tue, 20 Dec 2022 17:58:28 +0000
Message-Id: <81104db1a04efbfcec90f5819081b4299542671a.1671559005.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

NOT FOR INCLUSION, needs some ring poll workarounds

Flush completions is done either from the submit syscall or by the
task_work, both are in the context of the submitter task, and when it
goes for a single threaded rings like implied by ->task_complete, there
won't be any waiters on ->cq_wait but the master task. That means that
there can be no tasks sleeping on cq_wait while we run
__io_submit_flush_completions() and so waking up can be skipped.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16a323a9ff70..a57b9008807c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -618,6 +618,25 @@ static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_cqring_wake(ctx);
 }
 
+static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
+	__releases(ctx->completion_lock)
+{
+	io_commit_cqring(ctx);
+	__io_cq_unlock(ctx);
+	io_commit_cqring_flush(ctx);
+
+	/*
+	 * As ->task_complete implies that the ring is single tasked, cq_wait
+	 * may only be waited on by the current in io_cqring_wait(), but since
+	 * it will re-check the wakeup conditions once we return we can safely
+	 * skip waking it up.
+	 */
+	if (!ctx->task_complete) {
+		smp_mb();
+		__io_cqring_wake(ctx);
+	}
+}
+
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
@@ -1458,7 +1477,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			}
 		}
 	}
-	__io_cq_unlock_post(ctx);
+	__io_cq_unlock_post_flush(ctx);
 
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
-- 
2.38.1

