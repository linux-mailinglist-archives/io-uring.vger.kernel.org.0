Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1589C640C8C
	for <lists+io-uring@lfdr.de>; Fri,  2 Dec 2022 18:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiLBRsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Dec 2022 12:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiLBRsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Dec 2022 12:48:50 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929AEDEA75
        for <io-uring@vger.kernel.org>; Fri,  2 Dec 2022 09:48:48 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h7so2884728wrs.6
        for <io-uring@vger.kernel.org>; Fri, 02 Dec 2022 09:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrYhN8At7lRA3r7v6jfxG38dJqlpWb4W/HB7a0y1RSs=;
        b=GOMnd5uLyMQL2zojRoic+jluaoUSKOUJgnmXJ+k80Gx1MZnLgcOVBbjXf2cuhG59Qm
         caJP8cTijlU+TWEqDm38aBSqpXZ95IwVfts2W0XblHXc/RzkMkWbNgxqch7AP8EIDtIy
         unKnzRkMp/3RFMb9CejE2iQroXRRuK2T2C1pgDpK1TzqGbqq973KqkVkyDaCL2mLpmi3
         /nYGluNk1XAco1ZCo+JRy8kPNr7ckFnSYuMV/TQnxUx3N/QaS9IqvYqRx0OddWHO6cv4
         ofqk/DpFxPV4VC9osdnR5w8saiHDdqpbR8jjy889nwSBt2Uld6t76P+Ye5NV9vYd+KTW
         PVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GrYhN8At7lRA3r7v6jfxG38dJqlpWb4W/HB7a0y1RSs=;
        b=IoDL5nkOK58Dm/tW9QdorjmfLEilEJlvHbGyyytTYUtkKUILkQdyDlWmluWUJrfjfD
         arTP2WiinI0Lbd4Ff7DVIXk8X4iqG9BkBjX4IyNfkgfonMlXYj4JCV34ei1S7iEro02H
         GX+1m/JZvlAHpjrguWdJ0lXVjZayk8YWCfAA9s0mvrlZj16ZmTeJQIgX6PzjbwF+8sca
         uL+n/ROPsBXARFyHLXebZRaSJJuna8Nqf/NmGFd/mysq0T7xqqO17GRlFULS3COadLs9
         0+ZN4w28juHr4IB08IcouzAxziCRoM9ZHaHImI950yamc/DxaOi8PmLYpY0+f2MK5lIM
         Stbg==
X-Gm-Message-State: ANoB5pmDyi2YyFeh3IbMin9Hqu/AEOSs5tDjZfzEJvln5Kw9V18mdulm
        YwH7XtI/wnkm9rBSVZvfaQ7qqXI39X8=
X-Google-Smtp-Source: AA0mqf6Lg64KwWimsJ7COwwYGJ/CfwicAg6Kml8958js3kHgKW44pwIEo4C1MoDBTosq7NBUMCSpqA==
X-Received: by 2002:a5d:526b:0:b0:242:380:c10e with SMTP id l11-20020a5d526b000000b002420380c10emr24116556wrc.132.1670003326945;
        Fri, 02 Dec 2022 09:48:46 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id i1-20020adfaac1000000b002238ea5750csm9368585wrc.72.2022.12.02.09.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 09:48:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/4] io_uring: revise completion_lock locking
Date:   Fri,  2 Dec 2022 17:47:23 +0000
Message-Id: <88e75d481a65dc295cb59722bb1cf76402d1c06b.1670002973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670002973.git.asml.silence@gmail.com>
References: <cover.1670002973.git.asml.silence@gmail.com>
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

io_kill_timeouts() doesn't post any events but queues everything to
task_work. Locking there is needed for protecting linked requests
traversing, we should grab completion_lock directly instead of using
io_cq_[un]lock helpers. Same goes for __io_req_find_next_prep().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 ++++++++++++++--
 io_uring/io_uring.h | 11 -----------
 io_uring/timeout.c  |  8 ++++++--
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c30765579a8e..57c1c0da7648 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -582,6 +582,18 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		io_eventfd_flush_signal(ctx);
 }
 
+static inline void io_cq_lock(struct io_ring_ctx *ctx)
+	__acquires(ctx->completion_lock)
+{
+	spin_lock(&ctx->completion_lock);
+}
+
+static inline void io_cq_unlock(struct io_ring_ctx *ctx)
+	__releases(ctx->completion_lock)
+{
+	spin_unlock(&ctx->completion_lock);
+}
+
 /* keep it inlined for io_submit_flush_completions() */
 static inline void io_cq_unlock_post_inline(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
@@ -1038,9 +1050,9 @@ static void __io_req_find_next_prep(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_cq_lock(ctx);
+	spin_lock(&ctx->completion_lock);
 	io_disarm_next(req);
-	io_cq_unlock_post(ctx);
+	spin_unlock(&ctx->completion_lock);
 }
 
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2277c05f52a6..ff84c0cfa2f2 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -87,17 +87,6 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
-static inline void io_cq_lock(struct io_ring_ctx *ctx)
-	__acquires(ctx->completion_lock)
-{
-	spin_lock(&ctx->completion_lock);
-}
-
-static inline void io_cq_unlock(struct io_ring_ctx *ctx)
-{
-	spin_unlock(&ctx->completion_lock);
-}
-
 void io_cq_unlock_post(struct io_ring_ctx *ctx);
 
 static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 4c6a5666541c..eae005b2d1d2 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -624,7 +624,11 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	struct io_timeout *timeout, *tmp;
 	int canceled = 0;
 
-	io_cq_lock(ctx);
+	/*
+	 * completion_lock is needed for io_match_task(). Take it before
+	 * timeout_lockfirst to keep locking ordering.
+	 */
+	spin_lock(&ctx->completion_lock);
 	spin_lock_irq(&ctx->timeout_lock);
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
@@ -634,6 +638,6 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			canceled++;
 	}
 	spin_unlock_irq(&ctx->timeout_lock);
-	io_cq_unlock_post(ctx);
+	spin_unlock(&ctx->completion_lock);
 	return canceled != 0;
 }
-- 
2.38.1

