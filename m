Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CF3320694
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 19:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBTSIb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 13:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhBTSIb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 13:08:31 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53D7C06178B
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:50 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id f7so13251034wrt.12
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=whEXHvmXnIGlkGBTYoCCG3rqW7qXjn7YmPXWlA6VoUY=;
        b=OzUGlKTlaLozaEHebgLK41HFIdCl+eeGX9WV7dz3axDo2/wjtlyOVshLbR9FKPSQvo
         zQdWRvgAoHkQA5mZb0l/skQlXHdXgSM/8xZkpSiSOqrvKUadO0EV1GFzGmawuRoM5hzA
         JqOeDoXlrnYuKbg6W+96eNO9ZeVxSj+s2upNSTOXuI6OaWa8FhHLERESRMNGpBJc5xlM
         Y6bmb4qkmDxHXowsuNVTdMg6QyKMMkgxhsXHYx0UBRHZWvP6SKtSuBQqDK758cGJuD1u
         gU3j0PQuvCwXF1ttCyVout5+HEx8ASGFss8dF/1Fs9ZKaikWCHE6i47knHHyS5ATE/tN
         BWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=whEXHvmXnIGlkGBTYoCCG3rqW7qXjn7YmPXWlA6VoUY=;
        b=GqVF6u43JKi4YarO7aFicZE719dM7NUKhH0VUQbEpRslOUa5+yzmytT49lfLtyp8vS
         yicQJHWX8kp70bSLqU1KGN4iKb3tHHhGjJKOlDRjyCVO3+yom7eb0OD+4mlu9P/Xd06e
         ANEKrO+wE1O59Adobe5XXvmdr+4+5tCqm/ev6pNA/N9nmnvwkxMXlCIqSCpLmWvNC8nx
         R8nKvy8DCZdtIteehOJ8ex+WAFVhvwnp2lSYaja5u8OUAZ2PFCvcYZe2Y/HHNt1D/Hf9
         5VofWVgWWbk+HO+cU2PmFQZKOZ3ROJZ1km/XwFGaNgl9vUejJ2HdFkPEewED0kysRr4z
         y6Lg==
X-Gm-Message-State: AOAM530gSrz3QSv5kosl6OUSGDoLJVNsSNZ6XsPOXEkT6AqRJUf4eILw
        f77p9Rfv4kHPbE2SpNLLLEBhOcLzWBz4NA==
X-Google-Smtp-Source: ABdhPJz+6hRFzHAPZ/NDG0lDtrNIxcdDlXPqGxhxlM+YGiXk0EnLloZlD2L8FyHAHLlLlStI7nmNAw==
X-Received: by 2002:a5d:6a0b:: with SMTP id m11mr14397634wru.414.1613844469593;
        Sat, 20 Feb 2021 10:07:49 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id b83sm13594918wmd.4.2021.02.20.10.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 10:07:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/4] io_uring: keep generic rsrc infra generic
Date:   Sat, 20 Feb 2021 18:03:49 +0000
Message-Id: <28d5f9bb03bf548529f11115d9118f424a325f66.1613844023.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613844023.git.asml.silence@gmail.com>
References: <cover.1613844023.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_ref_quiesce() is a generic resource function, though now it
was wired to allocate and initialise ref nodes with file-specific
callbacks/etc. Keep it sane by passing in as a parameters everything we
need for initialisations, otherwise it will hurt us badly one day.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 292fba2b8e36..b00ab7138410 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1037,8 +1037,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
 static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
-static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
-				     struct fixed_rsrc_ref_node *ref_node);
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
 static bool io_rw_reissue(struct io_kiocb *req);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
@@ -7331,8 +7330,10 @@ static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_dat
 
 static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 			       struct io_ring_ctx *ctx,
-			       struct fixed_rsrc_ref_node *backup_node)
+			       void (*rsrc_put)(struct io_ring_ctx *ctx,
+			                        struct io_rsrc_put *prsrc))
 {
+	struct fixed_rsrc_ref_node *backup_node;
 	int ret;
 
 	if (data->quiesce)
@@ -7340,6 +7341,13 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 
 	data->quiesce = true;
 	do {
+		ret = -ENOMEM;
+		backup_node = alloc_fixed_rsrc_ref_node(ctx);
+		if (!backup_node)
+			break;
+		backup_node->rsrc_data = data;
+		backup_node->rsrc_put = rsrc_put;
+
 		io_sqe_rsrc_kill_node(ctx, data);
 		percpu_ref_kill(&data->refs);
 		flush_delayed_work(&ctx->rsrc_put_work);
@@ -7355,15 +7363,7 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
-
-		if (ret < 0)
-			break;
-		backup_node = alloc_fixed_rsrc_ref_node(ctx);
-		ret = -ENOMEM;
-		if (!backup_node)
-			break;
-		init_fixed_file_ref_node(ctx, backup_node);
-	} while (1);
+	} while (ret >= 0);
 	data->quiesce = false;
 
 	if (backup_node)
@@ -7399,7 +7399,6 @@ static void free_fixed_rsrc_data(struct fixed_rsrc_data *data)
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
-	struct fixed_rsrc_ref_node *backup_node;
 	unsigned nr_tables, i;
 	int ret;
 
@@ -7410,12 +7409,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 */
 	if (!data || percpu_ref_is_dying(&data->refs))
 		return -ENXIO;
-	backup_node = alloc_fixed_rsrc_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
-	init_fixed_file_ref_node(ctx, backup_node);
-
-	ret = io_rsrc_ref_quiesce(data, ctx, backup_node);
+	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
 	if (ret)
 		return ret;
 
-- 
2.24.0

