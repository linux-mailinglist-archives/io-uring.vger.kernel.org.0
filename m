Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6F431FD98
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBSRKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhBSRKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:35 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D130CC061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:20 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id y15so5050867ilj.11
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uoxk9ncnDxvUggsCWAkqnGgWjucReMNR6ju/WriwevQ=;
        b=I83aDomcIpxlV3vUIQuZowLqOXapi8+jD7tKtnVO2iRjzk1l5XhGQVMjDEejqJtuNS
         75KCUxSCloj4V3fFebObvUngGNyEwUauTZH5449zlnwdtquQ2S5/wS7G0SHRK0ENnXOr
         2EWLj5GZLWUCHGgm1Tri608OpXZ1ArRV8aNcxfgnbpL/c/M7Wwwl4Lw3RLp6Qm1WHJ5s
         ++8T82pyjghkCW8/szP3pv61Lb9DI04GusXd4O6M6c/NMZ7UvkgCWCAU3Jb+ZI3Rm68j
         zpRHlmSTJoPetAXrjffeN6bzNsTOoaXZUeUXnxzU6TjfsspSivcePLcHsviyzFSq2Jsy
         Or0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uoxk9ncnDxvUggsCWAkqnGgWjucReMNR6ju/WriwevQ=;
        b=k6BdFw+mtMFzK1UCIzFRzhTBF7TY1FMptCyQeux3Mnl5tf1x8CizQcDubG/lczEOQC
         CD9WN4LJ9M+xinx8i9dAMtAoMApD24dlq3GJcuDXf8edFnhiAC+trhgp0tCT2f3YzzFB
         kvX4SViz1NG6z4zt629qxb58aTlUPPMRlp7HBa1CGFOL8HH46oKrdWFW4KiU08IRCiHh
         z4to6JHVJkutS4BKH7Tmx1TyuekFIgQI6Omrv6dxCkirBWpqAqhdmhgLSp6GrFsTDfUI
         dkcPMwBCwQpNaQFa8trDr183FvAv2YqSSFqmC7VysaskADw/3reGYzgT8CQAb1jo2Wil
         MzmA==
X-Gm-Message-State: AOAM531+yYRythdQVbn1JjmFh6rRq78jgV9UHNvVmq0GimdXN4typmjL
        aVO1QHNZBUqgsuS+Scn4pTe0C6/u67Mib0Wg
X-Google-Smtp-Source: ABdhPJzArTVUr4jG1E9o46J8Xj6o2Eu/Bkt0yjdDM61zdEdXpamONbdhFcSAS5Fs1PTGeLWzM7u1Hg==
X-Received: by 2002:a05:6e02:16c7:: with SMTP id 7mr4485424ilx.202.1613754619973;
        Fri, 19 Feb 2021 09:10:19 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/18] io_uring: disable io-wq attaching
Date:   Fri, 19 Feb 2021 10:09:55 -0700
Message-Id: <20210219171010.281878-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Moving towards making the io_wq per ring per task, so we can't really
share it between rings. Which is fine, since we've now dropped some
of that fat from it.

Retain compatibility with how attaching works, so that any attempt to
attach to an fd that doesn't exist, or isn't an io_uring fd, will fail
like it did before.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 55 +++++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bbd1ec7aa9e9..0eeb2a1596c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8130,12 +8130,9 @@ static struct io_wq_work *io_free_work(struct io_wq_work *work)
 	return req ? &req->work : NULL;
 }
 
-static int io_init_wq_offload(struct io_ring_ctx *ctx,
-			      struct io_uring_params *p)
+static int io_init_wq_offload(struct io_ring_ctx *ctx)
 {
 	struct io_wq_data data;
-	struct fd f;
-	struct io_ring_ctx *ctx_attach;
 	unsigned int concurrency;
 	int ret = 0;
 
@@ -8143,37 +8140,15 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	data.free_work = io_free_work;
 	data.do_work = io_wq_submit_work;
 
-	if (!(p->flags & IORING_SETUP_ATTACH_WQ)) {
-		/* Do QD, or 4 * CPUS, whatever is smallest */
-		concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
-
-		ctx->io_wq = io_wq_create(concurrency, &data);
-		if (IS_ERR(ctx->io_wq)) {
-			ret = PTR_ERR(ctx->io_wq);
-			ctx->io_wq = NULL;
-		}
-		return ret;
-	}
-
-	f = fdget(p->wq_fd);
-	if (!f.file)
-		return -EBADF;
-
-	if (f.file->f_op != &io_uring_fops) {
-		ret = -EINVAL;
-		goto out_fput;
-	}
+	/* Do QD, or 4 * CPUS, whatever is smallest */
+	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
 
-	ctx_attach = f.file->private_data;
-	/* @io_wq is protected by holding the fd */
-	if (!io_wq_get(ctx_attach->io_wq, &data)) {
-		ret = -EINVAL;
-		goto out_fput;
+	ctx->io_wq = io_wq_create(concurrency, &data);
+	if (IS_ERR(ctx->io_wq)) {
+		ret = PTR_ERR(ctx->io_wq);
+		ctx->io_wq = NULL;
 	}
 
-	ctx->io_wq = ctx_attach->io_wq;
-out_fput:
-	fdput(f);
 	return ret;
 }
 
@@ -8225,6 +8200,20 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 {
 	int ret;
 
+	/* Retain compatibility with failing for an invalid attach attempt */
+	if ((ctx->flags & (IORING_SETUP_ATTACH_WQ | IORING_SETUP_SQPOLL)) ==
+				IORING_SETUP_ATTACH_WQ) {
+		struct fd f;
+
+		f = fdget(p->wq_fd);
+		if (!f.file)
+			return -ENXIO;
+		if (f.file->f_op != &io_uring_fops) {
+			fdput(f);
+			return -EINVAL;
+		}
+		fdput(f);
+	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sqd;
 
@@ -8282,7 +8271,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 	}
 
 done:
-	ret = io_init_wq_offload(ctx, p);
+	ret = io_init_wq_offload(ctx);
 	if (ret)
 		goto err;
 
-- 
2.30.0

