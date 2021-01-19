Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4B62FBA78
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391733AbhASOzk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394449AbhASNiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:38:00 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBF0C061793
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:41 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m4so19744194wrx.9
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MyxZYqq3iy76P+Celjv4S+iMACoKlZKkvOY//lN2biE=;
        b=EpnKxIaP5B5Gznbq/1bFRiFD3ZOIW9Uv2y2cl0oHUYbjtVr2P8Bclfl0lR45N/LmjN
         +8gx2aFUocHclfiDn1Kjq19GS3K0Sde7aq7h0PvIzRjxAJpVGRNVd65ab6vSrLOneZV5
         lKu3V9oKOketx0GU5aZ2NKeOGBkpV+kyRZ9hHLeIs3JssiGLGLbjwrAk4uadv2FIdZYx
         v31XhvIDNoONsSWvp7Ie6AMcu0bzPomxeeVuyNmcLwjKpDa0NGVzXTe+jPgFh9AOdiYQ
         T7iVnyN8bZgUOIvhl8jFoOAUt3GeX0umlF8gWpn01aK31T6OPhh7N7EwnpNv5azR/s9h
         S/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MyxZYqq3iy76P+Celjv4S+iMACoKlZKkvOY//lN2biE=;
        b=FOHmG5guPHUJh2bBp7MMXiWEqBzEp8/7rY/6yW8FMSlaORD+7w5B5ky+RLfzpcqSqz
         Xg72uu84QNCzr20sM01detmeV4i56pVnI1RaPJ1bU6Y61Q6ackDovAAdULCYlOKvIAzR
         Gs7kzutdR0lKBQlcBwSIUMjV0Spp2XHhAPZsDH58Vevl4WJ205+6CWIJ0VYUXQLcCP7k
         LXFtbNNoGqUwTZ3ph82P7qB8KyGdRV0uNpz9a+Fv8HlaexQjcj58YEO2Tu/q/R+TSlyN
         8vYK3Hi5MuRsG+QCPYr0EyapF/77xnjeRLtwg6AoDUECAO38Vq+j2ovon7w5apSEeVVe
         2J1w==
X-Gm-Message-State: AOAM531w5Hn14CwlLxHAR0++rFduzWIXCxM/zCKhQB2ebAYqsdqKXqsD
        0A+jBW43/dtu3RL468Po+1c=
X-Google-Smtp-Source: ABdhPJwjIRspORD3HDD/kAqOw3f0eyEshJMeOC+aaaiUUARNddvygAIIuuLP6LUiQ+h+x1RD8dAcoA==
X-Received: by 2002:adf:f511:: with SMTP id q17mr1411959wro.264.1611063400672;
        Tue, 19 Jan 2021 05:36:40 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/14] io_uring: deduplicate failing task_work_add
Date:   Tue, 19 Jan 2021 13:32:42 +0000
Message-Id: <3266c4386dc8a49237390f71d005389e3ba5584e.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When io_req_task_work_add() fails, the request will be cancelled by
enqueueing via task_works of io-wq. Extract a function for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 93c14bc970d3..c895e42201c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2146,6 +2146,16 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	return ret;
 }
 
+static void io_req_task_work_add_fallback(struct io_kiocb *req,
+					  void (*cb)(struct callback_head *))
+{
+	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
+
+	init_task_work(&req->task_work, cb);
+	task_work_add(tsk, &req->task_work, TWA_NONE);
+	wake_up_process(tsk);
+}
+
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2200,14 +2210,8 @@ static void io_req_task_queue(struct io_kiocb *req)
 	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		init_task_work(&req->task_work, io_req_task_cancel);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
@@ -2325,13 +2329,8 @@ static void io_free_req_deferred(struct io_kiocb *req)
 
 	init_task_work(&req->task_work, io_put_req_deferred_cb);
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
 }
 
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
@@ -3400,15 +3399,8 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		/* queue just for cancelation */
-		init_task_work(&req->task_work, io_req_task_cancel);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	return 1;
 }
 
@@ -5119,12 +5111,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 */
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
 		WRITE_ONCE(poll->canceled, true);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
+		io_req_task_work_add_fallback(req, func);
 	}
 	return 1;
 }
-- 
2.24.0

