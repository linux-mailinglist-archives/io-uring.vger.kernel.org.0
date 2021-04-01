Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D179B351844
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbhDARoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbhDARk2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:40:28 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0778AC0045F4
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:20 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g20so1180725wmk.3
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=J1ws8wADQ5zbdUYwYFwOasStGVDaUKDGtt0yYiKwPMI=;
        b=fKiqpDds5OZ01af/0WIfLorJM1VcQy7v0VU6rxMIsyjEdu3Gv1cNOmyGS/+qDXZX8v
         KL6UnUSwE1BrZQd4rKGGrwKO2S7q11PL5f1KCdx334YA09E9izBWQfBnTpU1aAilxn3J
         /pG3jO1DMCoIcHUtDpuJvfNGIu+WS8qQAuezf644mG15ujDXHbPlEJHCL3pvYsEsYqED
         X79oYHAnMYs3qLu3MXiHOCXZSkDezuOgeKplxP8fkGRwTnMg5MHl9jEyhSKd1opPEfew
         nQjHFxS1PCPUghVTteKYDt1o8zBf6BW5U6sfWvmZ423GEu39APqn7il0GFzgVGwIFgLf
         O92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J1ws8wADQ5zbdUYwYFwOasStGVDaUKDGtt0yYiKwPMI=;
        b=gBWvDJNms17jwYE4zV3ki+uvGOtOD31DkrqTJ+SgXI2/rbOnanPpcr5Chys9fU+2zw
         BXYEWHx8CW5O5jDMDa9zZBpj6KcTszsBvInDin9+5LCiCz1jPVFbNyWkRPXBGfrWKY4S
         pxiZbivnNNc0b5wmbLlXFcqnReuTMqG6doxMuamne3xnkZja3kJRPd+q4W08nGIQa7l7
         sF1p4pcmp3gR+TW0EdHWlYeR+5xgVLgr55A59AX5rwCJU7iteuEfqnBZAsdFgRJR0yrh
         XcukblY7yO8othGIxIFfOvSXZscBInMzNTIdEQjSSh7ovYkn4FDSsVv/X8Y04ECdzWDc
         uIiA==
X-Gm-Message-State: AOAM532ry1p1SqD49aLpclDmOoPy5rm2/isQVFKHlUhASGwye6zd8Zgi
        uWgbTiYi7RFG9mS6/pRvTRjRu4OHRfLxDg==
X-Google-Smtp-Source: ABdhPJxorOSDvuR5c+RzYf+78M3+Cevl4BwsDX2jbT4XepmarsnVyXD59/E0qpByw/NB98Q6axgWEw==
X-Received: by 2002:a1c:f701:: with SMTP id v1mr8445196wmh.69.1617288498847;
        Thu, 01 Apr 2021 07:48:18 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 03/26] io_uring: use rsrc prealloc infra for files reg
Date:   Thu,  1 Apr 2021 15:43:42 +0100
Message-Id: <cf87321e6be5e38f4dc7fe5079d2aa6945b1ace0.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep it consistent with update and use io_rsrc_node_prealloc() +
io_rsrc_node_get() in io_sqe_files_register() as well, that will be used
in future patches, not as error prone and allows to deduplicate
rsrc_node init.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f1a96988c3f5..b53ccac47440 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7605,13 +7605,6 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	return ref_node;
 }
 
-static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
-				     struct io_rsrc_node *ref_node)
-{
-	ref_node->rsrc_data = ctx->file_data;
-	ref_node->rsrc_put = io_ring_file_put;
-}
-
 static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
@@ -7624,7 +7617,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	__s32 __user *fds = (__s32 __user *) arg;
 	unsigned nr_tables, i;
 	struct file *file;
-	int fd, ret = -ENOMEM;
+	int fd, ret;
 	struct io_rsrc_node *ref_node;
 	struct io_rsrc_data *file_data;
 
@@ -7634,12 +7627,16 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	ret = io_rsrc_node_prealloc(ctx);
+	if (ret)
+		return ret;
 
 	file_data = io_rsrc_data_alloc(ctx);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
 
+	ret = -ENOMEM;
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
 				   GFP_KERNEL);
@@ -7692,13 +7689,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = io_rsrc_node_alloc(ctx);
-	if (!ref_node) {
-		io_sqe_files_unregister(ctx);
-		return -ENOMEM;
-	}
-	init_fixed_file_ref_node(ctx, ref_node);
-
+	ref_node = io_rsrc_node_get(ctx, ctx->file_data, io_ring_file_put);
 	io_rsrc_node_set(ctx, file_data, ref_node);
 	return ret;
 out_fput:
-- 
2.24.0

