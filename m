Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F34A50C40F
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiDVWoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiDVWni (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:43:38 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AA8212C5A
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:21 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w16so2710926pfj.2
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QNczvqhxHBwMMRKj3NdjaocdeCmCNWZgNQ3rdV8s06M=;
        b=rRsgHAD9F6uc/LGHa6+mduDEs/krXiJJyqhdcM3pTZutK4vzB0t2WmaHCE+PcCzmrn
         LZ3s98V3BNCzG+H0rjULPBzE6laVoSW8EcUd/Umnk0GICHjjvwNIbSY6W8RNf6Dti2c2
         qixzcq2LNSpl1V8cNOfk0OAwKvR/xF1x+KxHKljgP1POlTCMXvuReVlx2FTdnKYBkl3B
         Zcf6qbQwUqziThCzUjfe6boftvohxVPfJohnkHG7IO4Z7aqleQeBIJnL/FHZ1Nur3vGm
         +gUuzsU5ND0nQptxS7tWmVESsNKdadjdYfvMwO2zooWSydbQYSrgpH0hu713nhp2ymR7
         hqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QNczvqhxHBwMMRKj3NdjaocdeCmCNWZgNQ3rdV8s06M=;
        b=CUFslFrkT7vgPLCgA991BQiR883I0BdD9AKgGbaK/zRUBBNigYX7yyc7rvU2zGVzuQ
         ZBrqyz0Jb4f4IxHxWAmxQ5ZnSpW7alaKuORHDPY3P5NhkboXklYlkiQUdEcHgjOPaozX
         NbTrhiJHLeQYjSoRqdkN5Dpr6YC9GeeeBaUlcobgQif0kq0cw3w1HQ9/KKfmky+AmeEL
         7ZMPIr5HgLf+gSyD6dA7b7dI15bqkei5vD8Oe+c5XMDrr5a68kZq2lLYjAh1DNjWQC/a
         ep7QyOUDGlVB4nGkzNlITIJ4L0PtS+3y9WlQBuq1XwxQHK6yDSBhn7ejdJIQyuX+5Bhy
         bCHg==
X-Gm-Message-State: AOAM5308cCfrLxeMsVGW8Rtqm40wuvBMrqusU2mpjJDv+HBHV/JzTah2
        94aq9YkPsJkoORIYfaiMwR1Rxwjqn4WO9iv5
X-Google-Smtp-Source: ABdhPJzMHa58lSgOUNxY0bNs/8ew0kD5XQz7SJeH70bSaw/VFivI9hHxkgsrQyWp4KPZqHPB3UmAQw==
X-Received: by 2002:a05:6a00:84e:b0:50a:7a43:a2d1 with SMTP id q14-20020a056a00084e00b0050a7a43a2d1mr6887175pfk.51.1650663740204;
        Fri, 22 Apr 2022 14:42:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c5-20020a62f845000000b0050ceac49c1dsm3473098pfm.125.2022.04.22.14.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:42:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: serialize ctx->rings->sq_flags with cmpxchg()
Date:   Fri, 22 Apr 2022 15:42:11 -0600
Message-Id: <20220422214214.260947-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422214214.260947-1-axboe@kernel.dk>
References: <20220422214214.260947-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than require ctx->completion_lock for ensuring that we don't
clobber the flags, use try_cmpxchg() instead. This removes the need
to grab the completion_lock, in preparation for needing to set or
clear sq_flags when we don't know the status of this lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 54 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 626bf840bed2..38e58fe4963d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1999,6 +1999,34 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 		io_cqring_wake(ctx);
 }
 
+static void io_ring_sq_flag_clear(struct io_ring_ctx *ctx, unsigned int flag)
+{
+	struct io_rings *rings = ctx->rings;
+	unsigned int oldf, newf;
+
+	do {
+		oldf = READ_ONCE(rings->sq_flags);
+
+		if (!(oldf & flag))
+			break;
+		newf = oldf & ~flag;
+	} while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
+}
+
+static void io_ring_sq_flag_set(struct io_ring_ctx *ctx, unsigned int flag)
+{
+	struct io_rings *rings = ctx->rings;
+	unsigned int oldf, newf;
+
+	do {
+		oldf = READ_ONCE(rings->sq_flags);
+
+		if (oldf & flag)
+			break;
+		newf = oldf | flag;
+	} while (!try_cmpxchg(&rings->sq_flags, &oldf, newf));
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
@@ -2030,8 +2058,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	all_flushed = list_empty(&ctx->cq_overflow_list);
 	if (all_flushed) {
 		clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
-		WRITE_ONCE(ctx->rings->sq_flags,
-			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
+		io_ring_sq_flag_clear(ctx, IORING_SQ_CQ_OVERFLOW);
 	}
 
 	io_commit_cqring(ctx);
@@ -8105,23 +8132,6 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 	return READ_ONCE(sqd->state);
 }
 
-static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
-{
-	/* Tell userspace we may need a wakeup call */
-	spin_lock(&ctx->completion_lock);
-	WRITE_ONCE(ctx->rings->sq_flags,
-		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
-	spin_unlock(&ctx->completion_lock);
-}
-
-static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
-{
-	spin_lock(&ctx->completion_lock);
-	WRITE_ONCE(ctx->rings->sq_flags,
-		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
-	spin_unlock(&ctx->completion_lock);
-}
-
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
 	unsigned int to_submit;
@@ -8237,7 +8247,7 @@ static int io_sq_thread(void *data)
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-				io_ring_set_wakeup_flag(ctx);
+				io_ring_sq_flag_set(ctx, IORING_SQ_NEED_WAKEUP);
 
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
 				    !wq_list_empty(&ctx->iopoll_list)) {
@@ -8263,7 +8273,7 @@ static int io_sq_thread(void *data)
 				mutex_lock(&sqd->lock);
 			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_ring_clear_wakeup_flag(ctx);
+				io_ring_sq_flag_clear(ctx, IORING_SQ_NEED_WAKEUP);
 		}
 
 		finish_wait(&sqd->wait, &wait);
@@ -8273,7 +8283,7 @@ static int io_sq_thread(void *data)
 	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		io_ring_set_wakeup_flag(ctx);
+		io_ring_sq_flag_set(ctx, IORING_SQ_NEED_WAKEUP);
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
-- 
2.35.1

