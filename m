Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E263265B98C
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbjACDF2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbjACDFZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:25 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5132733
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:24 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g25-20020a7bc4d9000000b003d97c8d4941so16615381wmk.4
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jaEqFc+iCMwpGJhqH81jmmQEa3DfQMsul7/hQkLGvk=;
        b=QrXjygBzewKh7F65FBgvbLSfl3m7OReHrurOGMcLIr2WY1CCEjQ8/np/H9h8WBivSF
         RjQ3S5PPwZ8zJL2j6ErMy+qjKuupTNFq7J3efQspd//WLzKFZXGSAWJtcpVL0jECYYyf
         vI+BJwp8ph1NURcNbgeOCNnTyoelEIkdzxqiTpm6nXE+JIz4upp5GItQwaoaouBbt/5Q
         MLzqI+3GR2xCzkolJAcs6bcgqdRKCyIBRJn2ehrsxabB6Vbf+p8ypacI+88nQKgu+hxz
         FQCM8K7i8w/jK3SZ+0X9Q7F+yRLP5S3Y7ur2kqB8GHMn+hPLQNe3P4BxSUvzup2Pady/
         dI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4jaEqFc+iCMwpGJhqH81jmmQEa3DfQMsul7/hQkLGvk=;
        b=6KFxZihYRlJsJH8mysSYjJgXDZJw6vznXYtg+eL+fAx0TJoKJaJrjKmWTMREbH2rGa
         Yr+bnQULJ08QPyFycJ1GvtipX319BJyc7rHcw3NMLBChnhm6icxYwtQBea5vVqvgfg9j
         3HhJ27q2WUOaLC+hSt6C9W08dFdlMW13OLq5udZ1JZKVSHTtYojX/sp2yWm0M+J+4mFE
         VPccE4xX6j9HQGA3xjJybI8M/e04Ip4KvcZMnptnlZdtxC+29CJydr8m3Tm1o9CVYEOC
         iodN3//We4CvjG/qoZYixL5nFQvaTqU8ImduP7HKNBElq8toVQeGt9rYez1Xzn/+SjSk
         V5Jw==
X-Gm-Message-State: AFqh2kqwKbMQ1Zk8Ox1VUhDfWHVUd103028XJRbucq9F98Tp45OzKMPK
        6cACNVYNfEe2gNWqUr9WfNEs3oU0d6I=
X-Google-Smtp-Source: AMrXdXvXf4fhySgApQv83YXUzQAwQNtCj/QbnRNin5K1rkVbHGcBUe1aoLS/gbH8GqfIKxXovFGQzA==
X-Received: by 2002:a05:600c:4307:b0:3d3:494f:6a39 with SMTP id p7-20020a05600c430700b003d3494f6a39mr30219769wme.16.1672715123015;
        Mon, 02 Jan 2023 19:05:23 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 04/13] io_uring: move defer tw task checks
Date:   Tue,  3 Jan 2023 03:03:55 +0000
Message-Id: <5ec52d3ab11d92bd8fef0376aca9f0fde38ab4e7.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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

Most places that want to run local tw explicitly and in advance check if
they are allowed to do so. Don't rely on a similar check in
__io_run_local_work(), leave it as a just-in-case warning and make sure
callers checks capabilities themselves.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 15 ++++++---------
 io_uring/io_uring.h |  5 +++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a22c6778a988..ff457e525e7c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1296,14 +1296,13 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
 	struct llist_node *node;
 	struct llist_node fake;
 	struct llist_node *current_final = NULL;
-	int ret;
+	int ret = 0;
 	unsigned int loops = 1;
 
-	if (unlikely(ctx->submitter_task != current))
+	if (WARN_ON_ONCE(ctx->submitter_task != current))
 		return -EEXIST;
 
 	node = io_llist_xchg(&ctx->work_llist, &fake);
-	ret = 0;
 again:
 	while (node != current_final) {
 		struct llist_node *next = node->next;
@@ -2511,11 +2510,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
-	if (!llist_empty(&ctx->work_llist)) {
-		ret = io_run_local_work(ctx);
-		if (ret < 0)
-			return ret;
-	}
+	if (!llist_empty(&ctx->work_llist))
+		io_run_local_work(ctx);
 	io_run_task_work();
 	io_cqring_overflow_flush(ctx);
 	/* if user messes with these they will just get an early return */
@@ -3052,7 +3048,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		}
 	}
 
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
+	    io_allowed_defer_tw_run(ctx))
 		ret |= io_run_local_work(ctx) > 0;
 	ret |= io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 8a5c3affd724..9b7baeff5a1c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -352,6 +352,11 @@ static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	return container_of(node, struct io_kiocb, comp_list);
 }
 
+static inline bool io_allowed_defer_tw_run(struct io_ring_ctx *ctx)
+{
+	return likely(ctx->submitter_task == current);
+}
+
 static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
 {
 	return likely(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN) ||
-- 
2.38.1

