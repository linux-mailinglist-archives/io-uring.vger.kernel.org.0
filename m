Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6279B333D82
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 14:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCJNSK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 08:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbhCJNR7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 08:17:59 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73071C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:17:59 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w11so23293483wrr.10
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=q/GrBYTLzdfbexw1gABCX3Hr2c2lKm4adl8mrGgmCbI=;
        b=twDLyVOcGINePHS0ATSpi5ZbqJFzO5At0JDzH5rSMgQsHKAArMlGvERp5se6M2dQv4
         6mAJwwWpiVWKe9x+1jc38D/nSn2iw6wj5bqhaYHfEBhPZEl2whgqayWWjFZnQB00PViM
         Rr8HVAEIB9RCo3EKlWj78ypqbCxUX/8WAhJC2JYVzZ3/FFJd3WS2rbl2SR8KoEQfX72O
         VrCenCnOC3oT+aeqZx6b1+GfOnd11MnzpF4sQXXOD5PUSjKB3p8DOyHAxal87goYehxq
         03eljv90091k4x5VuCKGd/GVhiAQOiQTe9LeTGfyu50odhfelqgDUwPGu9EHMDwmTeZS
         +7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/GrBYTLzdfbexw1gABCX3Hr2c2lKm4adl8mrGgmCbI=;
        b=CMYw6/dlrYqtKT7srWWvQ+snAxDwLWBLaUR7m52koxi3cNVlYl1/TsYaV19H1LFF57
         QCauh4P6CpjmOxUBPV8/VtgfwidgfWlL9zad4K9JBNbQtUk+9mHD9VK9vx2tdv9WOFGS
         IiZEYc+Gr70tRpj00QgAtOfW+7ydBT7GjYQGdmFNVIYzsYvGhqhXLx0evCzH/ANzZ73s
         gxqkIQh4bXsOG+bH6wiFV55x+1lS7lk0FBuqBmuDHlaS8GrK3+HLEu7OjPBvGPo+4LmD
         gW8fwStM+2CTmVwwszRTsN/VbZZiU7wUj3i/tc3H599XUlxCgPIrXsIeCYgPOgkQtzZm
         JrfQ==
X-Gm-Message-State: AOAM533cgnWkD9iRyBIVReYuEs84CYsqR086BWy3xvmG78zLOwHIEUOv
        ueRWp6EiYFYz3VV8jvk2cozIBWciWRL5Ww==
X-Google-Smtp-Source: ABdhPJxzmxhy5rmNsC5QHqnMj+scebvHrSuKOfvzkm9E0pqg/rPpemCL+E+I6txt5DWjdhuE4XBR9w==
X-Received: by 2002:adf:fe09:: with SMTP id n9mr3555246wrr.104.1615382278218;
        Wed, 10 Mar 2021 05:17:58 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id u63sm9328004wmg.24.2021.03.10.05.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 05:17:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: remove indirect ctx into sqo injection
Date:   Wed, 10 Mar 2021 13:13:54 +0000
Message-Id: <bef22cfe6ba3fdf2cfeb83359ff4536c981e15f7.1615381765.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615381765.git.asml.silence@gmail.com>
References: <cover.1615381765.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use ->ctx_new_list to notify sqo about new ctx pending, then sqo
should stop and splice it to its sqd->ctx_list, paired with
->sq_thread_comp.

The last one is broken because nobody reinitialises it, and trying to
fix it would only add more complexity and bugs. And the first isn't
really needed as is done under park(), that protects from races well.
Add ctx into sqd->ctx_list directly (under park()), it's much simpler
and allows to kill both, ctx_new_list and sq_thread_comp.

note: apparently there is no real problem at the moment, because
sq_thread_comp is used only by io_sq_thread_finish() followed by
parking, where list_del(&ctx->sqd_list) removes it well regardless
whether it's in the new or the active list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b39c3818809..d2a26faa3bda 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -262,7 +262,6 @@ struct io_sq_data {
 
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
-	struct list_head	ctx_new_list;
 
 	struct task_struct	*thread;
 	struct wait_queue_head	wait;
@@ -398,7 +397,6 @@ struct io_ring_ctx {
 	struct user_struct	*user;
 
 	struct completion	ref_comp;
-	struct completion	sq_thread_comp;
 
 #if defined(CONFIG_UNIX)
 	struct socket		*ring_sock;
@@ -1136,7 +1134,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
-	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -6632,19 +6629,6 @@ static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 	sqd->sq_thread_idle = sq_thread_idle;
 }
 
-static void io_sqd_init_new(struct io_sq_data *sqd)
-{
-	struct io_ring_ctx *ctx;
-
-	while (!list_empty(&sqd->ctx_new_list)) {
-		ctx = list_first_entry(&sqd->ctx_new_list, struct io_ring_ctx, sqd_list);
-		list_move_tail(&ctx->sqd_list, &sqd->ctx_list);
-		complete(&ctx->sq_thread_comp);
-	}
-
-	io_sqd_update_thread_idle(sqd);
-}
-
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
@@ -6675,11 +6659,8 @@ static int io_sq_thread(void *data)
 			up_read(&sqd->rw_lock);
 			cond_resched();
 			down_read(&sqd->rw_lock);
-			continue;
-		}
-		if (unlikely(!list_empty(&sqd->ctx_new_list))) {
-			io_sqd_init_new(sqd);
 			timeout = jiffies + sqd->sq_thread_idle;
+			continue;
 		}
 		if (fatal_signal_pending(current)) {
 			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
@@ -7097,9 +7078,6 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 	if (sqd) {
 		complete(&sqd->startup);
-		if (sqd->thread)
-			wait_for_completion(&ctx->sq_thread_comp);
-
 		io_sq_thread_park(sqd);
 		list_del(&ctx->sqd_list);
 		io_sqd_update_thread_idle(sqd);
@@ -7151,7 +7129,6 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 
 	refcount_set(&sqd->refs, 1);
 	INIT_LIST_HEAD(&sqd->ctx_list);
-	INIT_LIST_HEAD(&sqd->ctx_new_list);
 	init_rwsem(&sqd->rw_lock);
 	init_waitqueue_head(&sqd->wait);
 	init_completion(&sqd->startup);
@@ -7832,7 +7809,8 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			ctx->sq_thread_idle = HZ;
 
 		io_sq_thread_park(sqd);
-		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
+		list_add(&ctx->sqd_list, &sqd->ctx_list);
+		io_sqd_update_thread_idle(sqd);
 		io_sq_thread_unpark(sqd);
 
 		if (sqd->thread)
-- 
2.24.0

