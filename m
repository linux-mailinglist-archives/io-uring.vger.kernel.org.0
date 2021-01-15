Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FA32F82B8
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbhAORm4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbhAORm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:56 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065BFC061799
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:43 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 7so2873876wrz.0
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=q/kbB2yl4JMzuUUyArw2H3oqms2jeDxoFoI02WDWwHc=;
        b=npRMh5e/y62OR6MaqkF2JpmaSYTVDt55dEQ6MhSIszGZK5/Oz3Vt72HzALFHz497b8
         agbpmff7g9fMVOMEzWEvvvLnK18NuRzc+VjGwAsnlmEBZHeYFJcnH+cu2VCZA/0MjpvV
         oQL0MzG1IdbDGQOrQdLBIMLOD8q5gNCow6HOGmSDelxtVjVXBGMzTxE6mUTWt/617nsh
         VWm9oL/dfMmAWLUSrDx6lHF525yY1TRWVKlnZVFsyNOvxWcr0aB2roRLwiN11fwsRrNG
         57xFS+YQekDhfWjjucJPTZhWi2xI8GN43UjoZJqosTnYCnHhRWP6uu9V+et/Kgd3+21M
         v6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/kbB2yl4JMzuUUyArw2H3oqms2jeDxoFoI02WDWwHc=;
        b=J6BFPUc1II06kTloNAohQO4jnimDT3QdaHupiVqp6AK8oObopL+pvLHrSXpZ5vEqbh
         8Ok+z7MZOfNy7KMz6BzBZfRsg8I5GsZao2vRQtx8F6HEMN7LVjnqZCaNHlsqfmWnyt4L
         JwdpnOJ8WSm8qvMReeHOcnVL8Mfs7M+fknuydaanUiymnPIV+I19O0vasqYD+bN1bYA5
         bMmEZC5DqT44CKRNIcWStDdKaeA2O6/P7UvYRtsv67x7wwTIEvc+jVnNuHH76mfOSP0Z
         aodhb6NT7Wtt2w0yIsb864I8Vkmy0icQAhM6B03SaE+8t/gSSCkTWv/jLS1Q3Fz0QXz+
         Zz3A==
X-Gm-Message-State: AOAM532mru0ICdbCjHdbHY1tITBPC1wkvQP29SX88b7Ui3SUDEwho/4g
        YDdOhRH9reg/MRafpFHc05I=
X-Google-Smtp-Source: ABdhPJyDQiRD6ljOBamkCULsk1X5o9kwmCIxYyh8MQxy3ZiKd7zJhxRch1kTmgvLX4QvFiBKjuJKcg==
X-Received: by 2002:a5d:4dc6:: with SMTP id f6mr14545203wru.336.1610732501725;
        Fri, 15 Jan 2021 09:41:41 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 7/9] io_uring: create common fixed_rsrc_ref_node handling routines
Date:   Fri, 15 Jan 2021 17:37:50 +0000
Message-Id: <30591560f44318e1e95a88b0fb5bd1df530c284e.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Create common routines to be used for both files/buffers registration.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
[merge, quiesce only for files]
[remove io_sqe_rsrc_set_node substitution]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f149b32bcf5d..44b5472cd425 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7297,20 +7297,13 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
+			       struct io_ring_ctx *ctx,
+			       struct fixed_rsrc_ref_node *backup_node)
 {
-	struct fixed_rsrc_data *data = ctx->file_data;
-	struct fixed_rsrc_ref_node *backup_node, *ref_node = NULL;
-	unsigned nr_tables, i;
+	struct fixed_rsrc_ref_node *ref_node;
 	int ret;
 
-	if (!data)
-		return -ENXIO;
-	backup_node = alloc_fixed_rsrc_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
-	init_fixed_file_ref_node(ctx, backup_node);
-
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
 	io_rsrc_ref_unlock(ctx);
@@ -7334,6 +7327,28 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		}
 	} while (1);
 
+	destroy_fixed_rsrc_ref_node(backup_node);
+	return 0;
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data = ctx->file_data;
+	struct fixed_rsrc_ref_node *backup_node;
+	unsigned nr_tables, i;
+	int ret;
+
+	if (!data)
+		return -ENXIO;
+	backup_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!backup_node)
+		return -ENOMEM;
+	init_fixed_file_ref_node(ctx, backup_node);
+
+	ret = io_rsrc_ref_quiesce(data, ctx, backup_node);
+	if (ret)
+		return ret;
+
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
@@ -7343,7 +7358,6 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
-	destroy_fixed_rsrc_ref_node(backup_node);
 	return 0;
 }
 
-- 
2.24.0

