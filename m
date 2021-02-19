Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A7931FFFF
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 21:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBSUuI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 15:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBSUuH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 15:50:07 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A56C06178A
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:27 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v14so10303682wro.7
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mna/qMEu2IDkhbzs+ZbfuwrDvMK4H/T/MtuMq/KgtHY=;
        b=sinKisFheUprEQPO8Jvc+G3TpavnbfltbsplapU3zo82A4ioPz8zqAxdeW1HRSH08R
         XEF/ePM6qwez1ErFvfvhwdeNw/SByYh/piRjQ+l3GWZrxANVtt6zpviX+XBoB1T/1X59
         4cIZYOPeBazaBcASWFx9ZYhB76Ml9pR9TULHj7D36Um5y+Tsl6mQnEKdwnBy/3FDH+rF
         3kzoZFbNAmBdrWrqOQtGRAfsXphx7dysylOxRPQpfexkGVewBkQK7ZqTZQxAnrpMez9l
         NVkL/9Yy889xfjM5TOO1Qe4GXTKWSn0qdwK+nmVv/VLGvlrQAbubWhrmiGd5glo7MGIU
         wA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mna/qMEu2IDkhbzs+ZbfuwrDvMK4H/T/MtuMq/KgtHY=;
        b=XC20l1A9Lkei33C+46tm71snnXJ5VbiostarNBGq0CA6pLFI77Ypc/DLv9KtuCHkTe
         fsIN2ZQ7USwWq7UJFa6lAiBrrwIcPsyXD5mDuhM0zEJVYyylC4p+HfdVJgbgzVw+elBJ
         uYAQHoJJ1HIhHAPSyVcbwJJxm5I0YVxG1n/f9ZztzrFTG3H+RHDjdnCzMi69HGGtvRap
         MjyOMdGb0Q7qIeGdsohPD7OhLE011LzUmaInCOUUySXGjzCUX8dMYXIHjHHgUpO3ix8w
         4QvpVd9sXhixvlSS5R8OdBDu+OboRgpf8gGKjyMHYFRDnDOEyVIhA8qczQfKNeVBDZV3
         TmRQ==
X-Gm-Message-State: AOAM531hlIUSoaXA4xp99MU8fSHU36qoCGkiGmtHZ2ThL35qIEt7Sy9O
        yyldhQsVi8D+bjfw4jPXQas=
X-Google-Smtp-Source: ABdhPJz8jTMDRFyKQ/dvgfYrs+XG7VQoQbCHbAS5C74mTVHQZVgxHHomKVpvGXcoRK/Agl1uQSRW9Q==
X-Received: by 2002:a5d:5603:: with SMTP id l3mr10778740wrv.381.1613767765875;
        Fri, 19 Feb 2021 12:49:25 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id l17sm3207298wmq.46.2021.02.19.12.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 12:49:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: fix io_rsrc_ref_quiesce races
Date:   Fri, 19 Feb 2021 20:45:25 +0000
Message-Id: <1b71f4059f088b035ec72307321f051a7be2d44f.1613767375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613767375.git.asml.silence@gmail.com>
References: <cover.1613767375.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are different types of races in io_rsrc_ref_quiesce()  between
->release() of percpu_refs and reinit_completion(), fix them by always
resurrecting between iterations. BTW, clean the function up, because
DRY.

Fixes: 0ce4a72632317 ("io_uring: don't hold uring_lock when calling io_run_task_work*")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 46 +++++++++++++---------------------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 50d4dba08f82..38ed52065a29 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7316,19 +7316,6 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static int io_sqe_rsrc_add_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
-{
-	struct fixed_rsrc_ref_node *backup_node;
-
-	backup_node = alloc_fixed_rsrc_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
-	init_fixed_file_ref_node(ctx, backup_node);
-	io_sqe_rsrc_set_node(ctx, data, backup_node);
-
-	return 0;
-}
-
 static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
 {
 	struct fixed_rsrc_ref_node *ref_node = NULL;
@@ -7347,36 +7334,29 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 {
 	int ret;
 
-	io_sqe_rsrc_kill_node(ctx, data);
-	percpu_ref_kill(&data->refs);
-
-	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->rsrc_put_work);
 	do {
+		io_sqe_rsrc_kill_node(ctx, data);
+		percpu_ref_kill(&data->refs);
+		flush_delayed_work(&ctx->rsrc_put_work);
+
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
 			break;
 
-		ret = io_sqe_rsrc_add_node(ctx, data);
-		if (ret < 0)
-			break;
-		/*
-		 * There is small possibility that data->done is already completed
-		 * So reinit it here
-		 */
+		percpu_ref_resurrect(&data->refs);
+		io_sqe_rsrc_set_node(ctx, data, backup_node);
 		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
-		io_sqe_rsrc_kill_node(ctx, data);
-	} while (ret >= 0);
 
-	if (ret < 0) {
-		percpu_ref_resurrect(&data->refs);
-		reinit_completion(&data->done);
-		io_sqe_rsrc_set_node(ctx, data, backup_node);
-		return ret;
-	}
+		if (ret < 0)
+			return ret;
+		backup_node = alloc_fixed_rsrc_ref_node(ctx);
+		if (!backup_node)
+			return -ENOMEM;
+		init_fixed_file_ref_node(ctx, backup_node);
+	} while (1);
 
 	destroy_fixed_rsrc_ref_node(backup_node);
 	return 0;
-- 
2.24.0

