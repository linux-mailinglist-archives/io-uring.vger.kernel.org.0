Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0353EF2A6
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhHQT3Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 15:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhHQT3Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 15:29:24 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFF7C061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f10so38983wml.2
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CwRhFPMnQLcJ3g6vU7SHlD67VAA3AK2Pip3m/MbVKkY=;
        b=ViU/c6IZXWPwUAQaLSntj3opCw7pl6Y0by1Iqws/ZlT7Q8sLERHoeMhT/LABVc/0+G
         WhwvC1gCK7B2WDodwSI0xtrjsODfkuQGUpC91ixZzQgethRLFJrZ4P+USBj7KCKutJPg
         4maKqNpjNJ/4xcqUFYCGEaaR9x48Ybgh2b2h7IzkVcXrTErmg9/8NTXdY4MTLhDNQ0+V
         SjpniLA1yvVXkdoq+CxzrORI9njj+eLoTTYst9AEYj3GOTxIjOJXUhlWZ+8/eDunwndc
         QcHniq7EVeHXMgxJOfbcGSxw4HoihTzD6vRm/R9rLAGMy5wQzYJq2qHBQHbetUwvQHM1
         jV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CwRhFPMnQLcJ3g6vU7SHlD67VAA3AK2Pip3m/MbVKkY=;
        b=LD6nVpGPWptL8kMzXzN1vxNB0iiqfZdgx3bulHKFyNFe2Q7OyUVbYSvGNwVTaxh4qs
         aiIRGzk9dyiFAU79oFG1f4l3wJFNcsYU/QvFzO5BPGVJ1lMVVvFflHVHD2RstfT8pXB2
         wo4DqaFZZTNmg1q0fFCHWAHqm4b1JQtvk1H5ZMOxOWjb8jJzS6PhZmDHIgRRRA6dMFTh
         G7h+mB1vv+1sDWZakXl4PuBXgAIksXxlDSatxeZLRwqrXewoQEETuPiTAD/aBKIGN8Rt
         HXq2aSDK7d54GCrBtq/BmigUbWbi6nWgXpWTopOm6DeUeZp3sahsBeK15KIOhfbUSb3T
         h8Vg==
X-Gm-Message-State: AOAM532qhKqpXFsJgOtPQCe8rxZyWb+9xN/SLunPKkd65zOli5cajB2g
        sooF50BEdGjCJHQWD18HaECMoeCXb94=
X-Google-Smtp-Source: ABdhPJwvfoeHfKFNNo+37ZNksKnCv/op6NBqm4dAaP/UmPwX7fD9xLydSGzJ4nXMqdAWxGJqoiskag==
X-Received: by 2002:a1c:7402:: with SMTP id p2mr596133wmc.111.1629228529951;
        Tue, 17 Aug 2021 12:28:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id e6sm3120388wme.6.2021.08.17.12.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:28:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: reuse io_req_complete_post()
Date:   Tue, 17 Aug 2021 20:28:09 +0100
Message-Id: <2c83463458a613f9d870e5147eb134da2aa70779.1629228203.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629228203.git.asml.silence@gmail.com>
References: <cover.1629228203.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have io_req_complete_post() to post a CQE and put the request. It
takes care of all synchronisation and is more concise and efficent, so
replace all hancoded occurrences of
"lock; post CQE; unlock; + put_req()" with io_req_complete_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 +++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 29e3ec6e9dbf..719d62b6e3d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5521,16 +5521,8 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_req_task_timeout(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock(&ctx->completion_lock);
-	io_cqring_fill_event(ctx, req->user_data, -ETIME, 0);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
 	req_set_fail(req);
-	io_put_req(req);
+	io_req_complete_post(req, -ETIME, 0);
 }
 
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
@@ -5658,14 +5650,9 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 					io_translate_timeout_mode(tr->flags));
 	spin_unlock_irq(&ctx->timeout_lock);
 
-	spin_lock(&ctx->completion_lock);
-	io_cqring_fill_event(ctx, req->user_data, ret, 0);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
 	if (ret < 0)
 		req_set_fail(req);
-	io_put_req(req);
+	io_req_complete_post(req, ret, 0);
 	return 0;
 }
 
@@ -5805,7 +5792,6 @@ static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
 }
 
 static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
-	__acquires(&req->ctx->completion_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -5813,15 +5799,19 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	WARN_ON_ONCE(req->task != current);
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	spin_lock(&ctx->completion_lock);
 	if (ret != -ENOENT)
 		return ret;
+
+	spin_lock(&ctx->completion_lock);
 	spin_lock_irq(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	spin_unlock_irq(&ctx->timeout_lock);
 	if (ret != -ENOENT)
-		return ret;
-	return io_poll_cancel(ctx, sqe_addr, false);
+		goto out;
+	ret = io_poll_cancel(ctx, sqe_addr, false);
+out:
+	spin_unlock(&ctx->completion_lock);
+	return ret;
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -5848,7 +5838,6 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_try_cancel_userdata(req, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
-	spin_unlock(&ctx->completion_lock);
 
 	/* slow path, try all io-wq's */
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
@@ -5861,17 +5850,10 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 			break;
 	}
 	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
-
-	spin_lock(&ctx->completion_lock);
 done:
-	io_cqring_fill_event(ctx, req->user_data, ret, 0);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
-
 	if (ret < 0)
 		req_set_fail(req);
-	io_put_req(req);
+	io_req_complete_post(req, ret, 0);
 	return 0;
 }
 
@@ -6411,20 +6393,12 @@ static inline struct file *io_file_get(struct io_ring_ctx *ctx,
 static void io_req_task_link_timeout(struct io_kiocb *req)
 {
 	struct io_kiocb *prev = req->timeout.prev;
-	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	if (prev) {
 		ret = io_try_cancel_userdata(req, prev->user_data);
-		if (!ret)
-			ret = -ETIME;
-		io_cqring_fill_event(ctx, req->user_data, ret, 0);
-		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
-		io_cqring_ev_posted(ctx);
-
+		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
-		io_put_req(req);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
 	}
-- 
2.32.0

