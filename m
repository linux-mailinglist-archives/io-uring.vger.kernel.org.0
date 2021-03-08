Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85139330F14
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 14:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCHNZO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 08:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhCHNY7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 08:24:59 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AEEC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 05:24:59 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo3791400wmq.4
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 05:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GXE8lUxoiImKaRDpBenRCSL8RCuWfQAP0hc6uJ+1tzM=;
        b=pyu98tD98HIrM92gDE+9P30QCSIiyTyXQEGl7q1PQVbJBC5oCRPue3ILKS2GRpefRy
         dxQGINvKlda5JvktGiBGNhcAHQAXkPM6TEgPf54i3VPlz/2KzmnwMWq5BkGnbR1TVPju
         kCzxM40tqByua21CsKJultBJ00zPjonA+H/WrUrGxM9rTVuHHuQjsxJZDy/XHnokNBLp
         PytXcIEzTczk8alUg3Ruk3Ux+0ZyFf7SXFIyiLPeJJCEhbVs67AOHB1bUSItytm5jP+n
         MXYSgvTEW3EBB5T6iRRGUlKLqkgJBMnQNK3k5v9i0mN+ys51wTQ7rgYsZdP9dOi0R5EL
         oRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GXE8lUxoiImKaRDpBenRCSL8RCuWfQAP0hc6uJ+1tzM=;
        b=ZR+ur4mzDyJN0vIhD6NwvEbpJeYw5DIdgYyQPDX8XGlfaOn3mZHbYxgy9G+gEhMSTb
         zYWU+B4NNpMFHAH9mwbr26gmqPtwuR9S0J3LBv2shSY8iMqpP8sJ6OwXM11MGh8IXfMX
         0U3ETRJxPic9pVRemeqXlWBj0D8dVa3ZcHjFdnK5W7ITKyRJa9f/osVvi3N1rMjzO4bG
         ceXrHYYVONvKuWrWumUvdXYQP2aGFuQoSwXpu9xHLQkZ7B1W3+wV98Y4dwlEF6GgIcZ9
         E463uMIVtndjRyqScoWslC7N11GuxiR6oHodDuASSACf852M609dFYGocm0NfeGecsfZ
         yHkw==
X-Gm-Message-State: AOAM533onAqBgyuD4LcOZSeBJPeSJPnQTvCmIw/Ym6YaYzHkdsr60xZ1
        lRNksOJP7ucUx77VZPyT4083rhra8r+48w==
X-Google-Smtp-Source: ABdhPJxU5ZUQU9J1xOByg0roNVtGYtAa0UvVbuVcsnUBVvUaTBRkw3iYvPXnJ+fgKfWSgVVsxnAtUw==
X-Received: by 2002:a1c:61c5:: with SMTP id v188mr21646438wmb.20.1615209897968;
        Mon, 08 Mar 2021 05:24:57 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id s8sm19571070wrn.97.2021.03.08.05.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 05:24:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: clean R_DISABLED startup mess
Date:   Mon,  8 Mar 2021 13:20:57 +0000
Message-Id: <057d200d7cc938d10b2f648a4a143a17e99b295f.1615209636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are enough of problems with IORING_SETUP_R_DISABLED, including the
burden of checking and kicking off the SQO task all over the codebase --
for exit/cancel/etc.

Rework it, always start the thread but don't do submit unless the flag
is gone, that's much easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5c6a54520be0..5ef9f836cccc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6607,7 +6607,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
-		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)))
+		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
+		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 	}
@@ -7865,6 +7866,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
+		complete(&sqd->startup);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7877,15 +7879,6 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static void io_sq_offload_start(struct io_ring_ctx *ctx)
-{
-	struct io_sq_data *sqd = ctx->sq_data;
-
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		complete(&sqd->startup);
-}
-
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)
 {
@@ -8746,11 +8739,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		/* never started, nothing to cancel */
-		if (ctx->flags & IORING_SETUP_R_DISABLED) {
-			io_sq_offload_start(ctx);
-			return;
-		}
 		io_sq_thread_park(ctx->sq_data);
 		task = ctx->sq_data->thread;
 		if (task)
@@ -9453,9 +9441,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	if (!(p->flags & IORING_SETUP_R_DISABLED))
-		io_sq_offload_start(ctx);
-
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
 	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
@@ -9672,7 +9657,9 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	io_sq_offload_start(ctx);
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
+		wake_up(&ctx->sq_data->wait);
 	return 0;
 }
 
-- 
2.24.0

