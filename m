Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87D73E98EC
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhHKTlX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKTlW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:41:22 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908EDC061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a8so5202786pjk.4
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l4q9fiTD0vU7+Jt6vsakWJwhSlwvXxDC4B5VGrxgTng=;
        b=mDFeWbbkU+G6ljmVJApuIlpAGRG+OKb5vJ+zW2pT+wCbblv+0PppSI+Fm/7Cewzcvo
         M3FBJXSEBee/noWGNlSW6NZfZJRiQJP51HDQYKkvGwXTT/YsJkPmDybPvVr/i6UiCQWd
         sMEJFtZ7zPeO4Lk4BmMsaPK0UHXDRgzNjxP/v+rWvzret+ZDN1dQCgWqR/xARHvEEIQk
         IWFUMCzJ9jidQHQ3I0vCJPYrvhRHRHm5Zp6PnD7peCEJre8LmQq+zspzlUcaDxHNg1JK
         qWBCR7Ps0Z/8nUh+w9LB7zX4GmDOa4JDLnUdu3V8Lz8/ThICRd5YeI6SyHTWX9tKm7sN
         IvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l4q9fiTD0vU7+Jt6vsakWJwhSlwvXxDC4B5VGrxgTng=;
        b=B4219L5BjBU2UBIcRoVZZQudgXti8R+UioVJak43kczpxJiDklZDypfpdWpV1+kgZk
         oOOvGdLH616iDwT67nTJMb3kV7uxLXwAh4pTHSPrAgEEyiccp//1TuoM1FUIdgP0VKA/
         fxYx8hiIplHRVV/cei7RQ/tSmm9sJUzliASx8S/wGHts2nJfHtm50e/EF/JckJOGWt2n
         6nSp7t0N4hGF1mar11KTvXQAz9Fy3amVdYRIIXBQ57cb5LAuzP7ocSsJi/lZtfC8fKUT
         FSGTjHQ4DqpTIyAHlUOEaE3z8JVVpr9VYu7uu7BAa+YVF2M0c0MCWTBHFGyyvRdfZ6XT
         4Rqw==
X-Gm-Message-State: AOAM531l3OgkjkkUt4zHpfDKRz2j7fv50IdsSqmX5DTIgjS7URN/J0Pm
        20eeTvJivitPYKashv4603ybqJgvPG9YY6UU
X-Google-Smtp-Source: ABdhPJyh/xDy6HJpdj1e6kzLv96SW/CisTZoP9aik9cigTDjrTf1UTPSs+RQHQ7lhmCKBER2fKzeTg==
X-Received: by 2002:a63:5908:: with SMTP id n8mr339209pgb.202.1628710857901;
        Wed, 11 Aug 2021 12:40:57 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm336118pfe.146.2021.08.11.12.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:40:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: run linked timeouts from task_work
Date:   Wed, 11 Aug 2021 13:40:51 -0600
Message-Id: <20210811194053.767588-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811194053.767588-1-axboe@kernel.dk>
References: <20210811194053.767588-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation to making the completion lock work outside of
hard/soft IRQ context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06cd7d229501..5a5551cfdad2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -538,6 +538,8 @@ struct io_timeout {
 	struct list_head		list;
 	/* head of the link, used by linked timeouts only */
 	struct io_kiocb			*head;
+	/* for linked completions */
+	struct io_kiocb			*prev;
 };
 
 struct io_timeout_rem {
@@ -1841,6 +1843,7 @@ static inline void io_remove_next_linked(struct io_kiocb *req)
 
 static bool io_kill_linked_timeout(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
+	__must_hold(&req->ctx->timeout_lock)
 {
 	struct io_kiocb *link = req->link;
 
@@ -1885,8 +1888,13 @@ static bool io_disarm_next(struct io_kiocb *req)
 {
 	bool posted = false;
 
-	if (likely(req->flags & REQ_F_LINK_TIMEOUT))
+	if (likely(req->flags & REQ_F_LINK_TIMEOUT)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->timeout_lock);
 		posted = io_kill_linked_timeout(req);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
 	if (unlikely((req->flags & REQ_F_FAIL) &&
 		     !(req->flags & REQ_F_HARDLINK))) {
 		posted |= (req->link != NULL);
@@ -6351,6 +6359,20 @@ static inline struct file *io_file_get(struct io_ring_ctx *ctx,
 		return io_file_get_normal(ctx, req, fd);
 }
 
+static void io_req_task_link_timeout(struct io_kiocb *req)
+{
+	struct io_kiocb *prev = req->timeout.prev;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (prev) {
+		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
+		io_put_req(prev);
+		io_put_req(req);
+	} else {
+		io_req_complete_post(req, -ETIME, 0);
+	}
+}
+
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -6359,7 +6381,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	spin_lock_irqsave(&ctx->timeout_lock, flags);
 	prev = req->timeout.head;
 	req->timeout.head = NULL;
 
@@ -6372,15 +6394,11 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 		if (!req_ref_inc_not_zero(prev))
 			prev = NULL;
 	}
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	req->timeout.prev = prev;
+	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
-	if (prev) {
-		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
-		io_put_req_deferred(prev, 1);
-		io_put_req_deferred(req, 1);
-	} else {
-		io_req_complete_post(req, -ETIME, 0);
-	}
+	req->io_task_work.func = io_req_task_link_timeout;
+	io_req_task_work_add(req);
 	return HRTIMER_NORESTART;
 }
 
@@ -6388,7 +6406,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	/*
 	 * If the back reference is NULL, then our linked request finished
 	 * before we got a chance to setup the timer
@@ -6400,7 +6418,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
 				data->mode);
 	}
-	spin_unlock_irq(&ctx->completion_lock);
+	spin_unlock_irq(&ctx->timeout_lock);
 	/* drop submission reference */
 	io_put_req(req);
 }
-- 
2.32.0

