Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEBE3205E3
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 16:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBTPT5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 10:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhBTPT4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 10:19:56 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527FCC061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 07:19:12 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id n10so10445334wmq.0
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 07:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nPM5JwrBZrlUZqh30dXDQ96Zj6ruaV2pGAuGRBEaLZM=;
        b=slzoXQ6xTY0OZoCPZ2eSqU/Bzg9RkNMCHR6OMK+Tw3fHwR2QxFr+WDw/9NUmO1p+12
         W01Ib5AGLznnty0FAkskg68r5qS7Ik9JC2ZuI3HrWeqUZyyIhW7WTi3RcO+yc/KPgnW5
         GDVEm9U3vFgjm8c1vnsMR3ShCzS5eSdxhqdBC2CR0SHDTS+4hZxIH/PYlnP4T8zfq3wQ
         I2fgAe8FyU7/cmPIYTagZbpb2D9tBxV8XZIxA6RVCOIK2nsWIR+35gP301N17aKQ+VTG
         2epUbCzhZUnWz7WIZ0KHFESaAijeTAfhSUC3IUOKaV/CQVMyv15fzNj9UpzR2XaXqWvN
         YYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nPM5JwrBZrlUZqh30dXDQ96Zj6ruaV2pGAuGRBEaLZM=;
        b=jlvhyz7LZ5WDsmsbqoEVNQgIu687bUKF66E3z/D0BRZGz1xLNPLVzo86uPCkKkFajY
         6JyOH7N325PoO8G05MxSjgE6+wZJmgbzh0deCJ3a4MT+nyMmT4MSo3dr/5em6lUZR/+H
         Wg4uGnXCyz4w6du1fsoLBG70eMgmhvUkbO8WpBM3bSn8FoMzkTtEB+q4jco+dMEHokJe
         VzBYxnmejCQgjc0ZikJIvEi2IUtWk+L/+TjJ39h0XBI57VjRf+JjamNG7qiHpL5hvZ2L
         wHPGiXVCpWO29npAEZ634fYMFlwE+72fPfll7UZISFPVAzaKZQPWI6uF+DrMdbd3k7SR
         Ytnw==
X-Gm-Message-State: AOAM532bcP7HcpNOg3zfUjUvp+AwPG39S4AD0rb6UVgnJiHRcdklod9W
        f4bnQE+WgkiOeNqhWmG41mw=
X-Google-Smtp-Source: ABdhPJzBIZv+hsM4eVfWCMVVlelZiTOmc2yFnOjvZI8pHzia57uEsHGZUzux1U+/tIYW4JImO775kg==
X-Received: by 2002:a05:600c:148a:: with SMTP id c10mr11262264wmh.158.1613834351112;
        Sat, 20 Feb 2021 07:19:11 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id y4sm13038320wrs.66.2021.02.20.07.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 07:19:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH 1/1] io_uring: disallow concurrent rsrc quiesce
Date:   Sat, 20 Feb 2021 15:15:12 +0000
Message-Id: <7ab1ec56db576746ff2c6045b3f6eeb4af950eff.1613833993.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613833993.git.asml.silence@gmail.com>
References: <cover.1613833993.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a flag for marking a rsrc data quiescing to disallow doing it from
several tasks concurrently.

Cc: Hao Xu <haoxu@linux.alibaba.com>
Fixes: 853a012bdbddce869561 ("io_uring: fix io_rsrc_ref_quiesce races")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3af499b12a9..ff8f50d3cf44 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -236,6 +236,7 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7335,10 +7336,15 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	struct fixed_rsrc_ref_node *backup_node;
 	int ret;
 
+	if (data->quiesce)
+		return -ENXIO;
+
+	data->quiesce = true;
 	do {
 		backup_node = alloc_fixed_rsrc_ref_node(ctx);
+		ret = -ENOMEM;
 		if (!backup_node)
-			return -ENOMEM;
+			break;
 		backup_node->rsrc_data = data;
 		backup_node->rsrc_put = rsrc_put;
 
@@ -7352,16 +7358,17 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 
 		percpu_ref_resurrect(&data->refs);
 		io_sqe_rsrc_set_node(ctx, data, backup_node);
+		backup_node = NULL;
 		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
-		if (ret < 0)
-			return ret;
-	} while (1);
+	} while (ret >= 0);
+	data->quiesce = false;
 
-	destroy_fixed_rsrc_ref_node(backup_node);
-	return 0;
+	if (backup_node)
+		destroy_fixed_rsrc_ref_node(backup_node);
+	return ret;
 }
 
 static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
@@ -7400,7 +7407,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 * Since we possibly drop uring lock later in this function to
 	 * run task work.
 	 */
-	if (!data || percpu_ref_is_dying(&data->refs))
+	if (!data)
 		return -ENXIO;
 	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
 	if (ret)
-- 
2.24.0

