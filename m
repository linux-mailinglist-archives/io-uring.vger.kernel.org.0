Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29C32C9A4
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbhCDBKG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352749AbhCDAeA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:34:00 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FA5C061A2D
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:28 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q204so16481084pfq.10
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NlFW/o8bHDawd4Q2GokKmFPsvWi9xf+cUFLT3aycZ5o=;
        b=zYk0Hdhdj9u0JMLD4serkJgMMhDh2dff6D7BS6yTc7u1BxxC2s06nfzGZy5jkv+YR/
         u5YUBsQW7a61He3XOxs/p2edsAim31ScudAj9wsNwf7CHOLNE/jglQE7QcVKwpR/4NGU
         tTzRqkk8Jod8l9MnYY0zvYREgVq2ug0VcDrsMwSP5RwVo1dNO+0cLJzIZ6YNNjgBsssC
         G+2al28fQXOuNov9LXKho8q0TS/Jz3BqgjuIbU9s1iQ+vS2+w8Mhexbw+y9t0vCXPvjp
         aGS9cgvlmABkngSKAXgoUxCw8kA76Rq2zVjDI4vsplFWov1GX8nYEnrDVU4NU3TBr1Hq
         eszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlFW/o8bHDawd4Q2GokKmFPsvWi9xf+cUFLT3aycZ5o=;
        b=lKqnnGRDgVnyjsfbXXyVA++8EqO7G9/4tAlj2FDsgSGNbE1V/A/q5M5ggt6BEM/yyJ
         WmUCmAZNeaOV/iQqN6WpY2I8bBIN5qzJjWpdY7b3V8BJjk/sJNIX2wW48VFANwgBcjK5
         lfiW25cFKuhU86YaCKeuAzeZIJWQBMUR1vCEwiGZwx76XecvQKbxbHPuGgsRY8VnUTwU
         5RF7LHdTdCYEGxznvi7yNVv73l3eeVEhbElTyMhMbzS0GKkPBGnFx5BVLSNs+oS9Bw+b
         GYglvEGakBFImf7h0p0lqDrsbSVXKqKA1JaU15KVeG77aPIKePUvH7/qtfdlcAJmwoKQ
         ADJQ==
X-Gm-Message-State: AOAM531V5A8UL4kdD5IdMGIdnAQQPKpfwXSMexoDsH5+deacNgD4FLsE
        QujFTbrGr9/tw9LK1BurJGYDcyqDC2nEAXNP
X-Google-Smtp-Source: ABdhPJx7Ie/SzgpAhEvgqQ6hom1GK+K/Wj6l1yRSlMj8Xqrm/nh0rauldxi/P9RNRDEfi5BZ7OGiog==
X-Received: by 2002:a62:3c4:0:b029:1ee:9771:2621 with SMTP id 187-20020a6203c40000b02901ee97712621mr1220790pfd.47.1614817647953;
        Wed, 03 Mar 2021 16:27:27 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 19/33] io_uring: kill io_uring_flush()
Date:   Wed,  3 Mar 2021 17:26:46 -0700
Message-Id: <20210304002700.374417-20-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This was always a weird work-around or file referencing, and we don't
need it anymore. Get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 47 -----------------------------------------------
 1 file changed, 47 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index def9da1ddc3c..f6bc0254cd01 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8932,52 +8932,6 @@ void __io_uring_unshare(void)
 	}
 }
 
-static int io_uring_flush(struct file *file, void *data)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_ring_ctx *ctx = file->private_data;
-
-	/* Ignore helper thread files exit */
-	if (current->flags & PF_IO_WORKER)
-		return 0;
-
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
-		io_uring_cancel_task_requests(ctx, NULL);
-		io_req_caches_free(ctx);
-	}
-
-	io_run_ctx_fallback(ctx);
-
-	if (!tctx)
-		return 0;
-
-	/* we should have cancelled and erased it before PF_EXITING */
-	WARN_ON_ONCE((current->flags & PF_EXITING) &&
-		     xa_load(&tctx->xa, (unsigned long)file));
-
-	/*
-	 * fput() is pending, will be 2 if the only other ref is our potential
-	 * task file note. If the task is exiting, drop regardless of count.
-	 */
-	if (atomic_long_read(&file->f_count) != 2)
-		return 0;
-
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		/* there is only one file note, which is owned by sqo_task */
-		WARN_ON_ONCE(ctx->sqo_task != current &&
-			     xa_load(&tctx->xa, (unsigned long)file));
-		/* sqo_dead check is for when this happens after cancellation */
-		WARN_ON_ONCE(ctx->sqo_task == current && !ctx->sqo_dead &&
-			     !xa_load(&tctx->xa, (unsigned long)file));
-
-		io_disable_sqo_submit(ctx);
-	}
-
-	if (!(ctx->flags & IORING_SETUP_SQPOLL) || ctx->sqo_task == current)
-		io_uring_del_task_file(file);
-	return 0;
-}
-
 static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
@@ -9313,7 +9267,6 @@ static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
-	.flush		= io_uring_flush,
 	.mmap		= io_uring_mmap,
 #ifndef CONFIG_MMU
 	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
-- 
2.30.1

