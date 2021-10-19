Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBFF434183
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 00:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhJSWqO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 18:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhJSWqL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 18:46:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E868CC06176D
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 15:43:56 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z77-20020a1c7e50000000b0030db7b70b6bso6116935wmc.1
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 15:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yjZFeQMCGwvnbEzsOjl1UtST52pGL90XLbGaMYmgI0g=;
        b=HjqdACPSgiKrCH2yX5TkM91VYszLQACkv5hsQ3qVwJDesETqra8k0F8nJSevdxLtoR
         lAPZOMN0JwYdi5cNmNVmKbjX2FMobN94h5reDM6eHbxpUemHUd0PqNCJ1Xv+f6l/H4Rr
         0/SO3nyRBhizFCoDkMDhRnTDVBgkeXH12QK4N6CkUlcNMSm9s3e9RhlZ6hQ6rrll4L8P
         6tVj73yqV4nDf2Ofrs4qcbNaewoPbazu2RvVTDZ7Fw4opac6D7lo+A2mS2QtOn1meGlH
         XAhAOSr8F9ysSpOBmJlKnq5klnEsos5FaaotaJMl6wb1RqMpfmdpuGTUoZUYzx2B/rmO
         7iBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yjZFeQMCGwvnbEzsOjl1UtST52pGL90XLbGaMYmgI0g=;
        b=byaovHvzcGR3wE3kdF3LZtZNlk3aZ8ki6H3tvDe0bcd1+5PmoQxg0ur3jk1J8jIJg1
         BIdYBoBaDoZq/7+qPm57Jd0orQ/fr1ps4xBoSW30boJecMr60JNGGL1yt0ebEM6YJJsO
         xZcHf2M9zaQSMsgAHG2PzAXxni+1m1M++HlidCexo62L2j+H9My7ol7Ze01vtyFieDsS
         TPfbyxDJqItM8ueD1VZ5VYUue2qgEOFT+ubQUp/iSlifqMLA3n2uO9yRvVH4ArkGXXN0
         JzKhlP8CxDepb+uNdHB6ovMQLYQGAsSWA92YpIsethQ9YUs8c+IWNulE1hxlvtsBnUE2
         A4pg==
X-Gm-Message-State: AOAM531RZ3FYHzt4H6OyLs2p0WeRUaenyMiajPSAT43DXczCYe+P4T6O
        jTfwX4VB2RTjw1LZYWC9UhONDSicrRitXg==
X-Google-Smtp-Source: ABdhPJwKg4VIHs4/7IWSq44/H+y5oHi8YVLbIY8CW/E7JN1D9CFN3bC5RSEX0hRI7QVwFyKwNWWs1w==
X-Received: by 2002:a5d:6481:: with SMTP id o1mr48201807wri.60.1634683435278;
        Tue, 19 Oct 2021 15:43:55 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id x24sm3626921wmk.31.2021.10.19.15.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 15:43:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.15] io_uring: apply max_workers limit to all future users
Date:   Tue, 19 Oct 2021 23:43:46 +0100
Message-Id: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently, IORING_REGISTER_IOWQ_MAX_WORKERS applies only to the task
that issued it, it's unexpected for users. If one task creates a ring,
limits workers and then passes it to another task the limit won't be
applied to the other task.

Another pitfall is that a task should either create a ring or submit at
least one request for IORING_REGISTER_IOWQ_MAX_WORKERS to work at all,
furher complicating the picture.

Change the API, save the limits and apply to all future users. Note, it
should be done first before giving away the ring or submitting new
requests otherwise the result is not guaranteed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Change the API as it was introduced in this cycles. Tested by hand
observing the number of workers created, but there are no regression
tests.

 fs/io_uring.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e68d27829bb2..e8b71f14ac8b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -456,6 +456,8 @@ struct io_ring_ctx {
 		struct work_struct		exit_work;
 		struct list_head		tctx_list;
 		struct completion		ref_comp;
+		u32				iowq_limits[2];
+		bool				iowq_limits_set;
 	};
 };
 
@@ -9638,7 +9640,16 @@ static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 		ret = io_uring_alloc_task_context(current, ctx);
 		if (unlikely(ret))
 			return ret;
+
 		tctx = current->io_uring;
+		if (ctx->iowq_limits_set) {
+			unsigned int limits[2] = { ctx->iowq_limits[0],
+						   ctx->iowq_limits[1], };
+
+			ret = io_wq_max_workers(tctx->io_wq, limits);
+			if (ret)
+				return ret;
+		}
 	}
 	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
 		node = kmalloc(sizeof(*node), GFP_KERNEL);
@@ -10674,13 +10685,19 @@ static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 		tctx = current->io_uring;
 	}
 
-	ret = -EINVAL;
-	if (!tctx || !tctx->io_wq)
-		goto err;
+	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
 
-	ret = io_wq_max_workers(tctx->io_wq, new_count);
-	if (ret)
-		goto err;
+	memcpy(ctx->iowq_limits, new_count, sizeof(new_count));
+	ctx->iowq_limits_set = true;
+
+	ret = -EINVAL;
+	if (tctx && tctx->io_wq) {
+		ret = io_wq_max_workers(tctx->io_wq, new_count);
+		if (ret)
+			goto err;
+	} else {
+		memset(new_count, 0, sizeof(new_count));
+	}
 
 	if (sqd) {
 		mutex_unlock(&sqd->lock);
-- 
2.33.1

