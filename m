Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9168665B98D
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjACDF3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbjACDF0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:26 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA61BCA5
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:25 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id b24-20020a05600c4a9800b003d21efdd61dso22171382wmp.3
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLXUDtmB9EhqaBSicBvqsDUUk5cQrRfzMcjLmxZc7BY=;
        b=L5SbiIgoHeppEKCFwQXswQdD5PzZ0eWPeE5MuUe9+TXe21U44GZzhQTNBD7AXDibEw
         bP57zDZIXlnuqgpCctkJBsLynqSd0rJuWf+3wKNdRcdx9pKGMDL/P3BjdnOlKrpP4fMs
         vktEY1Gxijc0scQlK1kyDIslpQTOh6pATrlgGQKs7xcg75OWv0bfHikuFou+rIXGPt6V
         tecKjNvDTzmZsc5TBca/nbp1OBkRWFQ/CzXmSSC9aGfmnmuz7JDFsTIhX0bDBL1zel2w
         xZyH++FNVWu+3pa/anNfT8WQmQTSdfzInB3+8sjyMScUDcWLCJZOGIxxYWfhEBf+r/Ry
         JQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLXUDtmB9EhqaBSicBvqsDUUk5cQrRfzMcjLmxZc7BY=;
        b=dKFfW3D5yRXhtzJNNrxXHroBTUzLSr/T8BbGvcEEhnUr759MqSU02oKr9r3Bq3WUoy
         JHagcYL7S1tACW2/dsL61Is2md+Bi6bZIRgigy4RFy82QPqhqpkRzQS+KaiVUiNvrZrB
         tzzZH1uwrChikBQuGXuulTr6rf+2EqpIus1UUW/DdrIr/CkZDskyHmpyQZ0u7pdmczxn
         3MlZHbiRQKsBkj3HtO+BNgUv7ikfAqr5hA2fK2WRiIFnXzgYI41pUrBTCdze4mfXfj7j
         xXJJBlB/oS37GBcN1Zm0PMJxUYxrJMDa02o0eFKknCsY5hVcGdaQygDqSFk5/pucxaIQ
         DXgw==
X-Gm-Message-State: AFqh2kpoHl/SjJGd2mBitBDEcDh62nYpTBTxCVfehLjm2oOshc5uOmkn
        YxNpOwAANh5WV1wXisk/Y4FPui0BGEk=
X-Google-Smtp-Source: AMrXdXsuOPivGIsMjJPK0wQoQVm5CtjKGDP6bCSMjIPcAhMKEIl+mVmwoLYt9itL8oyUesD2lSZEAQ==
X-Received: by 2002:a05:600c:4e07:b0:3d3:5319:b6d3 with SMTP id b7-20020a05600c4e0700b003d35319b6d3mr30453558wmq.38.1672715123768;
        Mon, 02 Jan 2023 19:05:23 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 05/13] io_uring: parse check_cq out of wq waiting
Date:   Tue,  3 Jan 2023 03:03:56 +0000
Message-Id: <e28cb002457c26c6159de4d80e7c437fe13711b5.1672713341.git.asml.silence@gmail.com>
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

We already avoid flushing overflows in io_cqring_wait_schedule() but
only return an error for the outer loop to handle it. Minimise it even
further by moving all ->check_cq parsing there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ff457e525e7c..e3c5de299baa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2468,21 +2468,13 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  ktime_t timeout)
 {
 	int ret;
-	unsigned long check_cq;
 
+	if (unlikely(READ_ONCE(ctx->check_cq)))
+		return 1;
 	/* make sure we run task_work before checking for signals */
 	ret = io_run_task_work_sig(ctx);
 	if (ret || io_should_wake(iowq))
 		return ret;
-
-	check_cq = READ_ONCE(ctx->check_cq);
-	if (unlikely(check_cq)) {
-		/* let the caller flush overflows, retry */
-		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-			return 1;
-		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
-			return -EBADR;
-	}
 	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 
@@ -2548,13 +2540,25 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
-			finish_wait(&ctx->cq_wait, &iowq.wq);
-			io_cqring_do_overflow_flush(ctx);
-		}
+		unsigned long check_cq;
+
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+
+		check_cq = READ_ONCE(ctx->check_cq);
+		if (unlikely(check_cq)) {
+			/* let the caller flush overflows, retry */
+			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)) {
+				finish_wait(&ctx->cq_wait, &iowq.wq);
+				io_cqring_do_overflow_flush(ctx);
+			}
+			if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)) {
+				ret = -EBADR;
+				break;
+			}
+		}
+
 		if (__io_cqring_events_user(ctx) >= min_events)
 			break;
 		cond_resched();
-- 
2.38.1

