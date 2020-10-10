Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E863C28A3EA
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389430AbgJJWzl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731247AbgJJTFM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D828C08EBB3
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:22 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e17so13681965wru.12
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Nf/fZxWlrOe1Vth7yUmfAhybq9u5x/XbC3b1InN7Rp4=;
        b=kJ8VBUpEoplFtUKfu1WZzuVlEkrG1O8att3YvUQ6XMJROxJFe5rTKYvAi5cRuGKCVn
         63tQ3DoRs5ethaQcutSnbz6/ahGP18xCQMnnsgBsrmNzPs0fR9mkbapooEuevuZWFtK0
         nvNn+/npPZDRrJDf4d+trF4fbM5SJlPSxxAD5odYXL+WpPtn2Ceqns66a8jR8/ooKaXc
         DSiMLRNbIvr50vvUNDQ/2R8ATsz/TPicXSFIWPrdJpnd0+9+OnfTIE1umuo+akCTkcec
         qERPFMz90Wq8j3RyrlW87uSxokpFSQrkpsxBYNwLVIQ3W76Yv5px4hALONwoBozxuKL6
         pSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nf/fZxWlrOe1Vth7yUmfAhybq9u5x/XbC3b1InN7Rp4=;
        b=Zz5OBpHKkIGem0kz0g9JOBbzqP3Xx1oDGT5jZCpWfmWxayka38IFHcdCq4z/tI3fqW
         vIONJAztXm9yWzER3Pa5v0U40p8Jfr5GvBwgKu64pvsfqbiZNZ5LD/reoHEIsUOVcAmk
         khDwNGwe3mXZH9l1pahwnrbPb0+/0n0MQTNTtKFA19PqFw5EqJtb9LLurAD+Okr2j1pu
         RlIO51Dyd5ykYHLzj3dkMeAocmzmKteQqA+ZLgNpv1ggNSRN2cMzCSXoUxGH8ww3Y0Az
         SdJzhv//UNY7Yp6TqF1kN3dyQRdAsLmT0Hva3rXFNLznaldNEXaj7NBzkL/NEq8t4q1H
         2ATQ==
X-Gm-Message-State: AOAM5337i5KomfTicLHYJ6OrdQEVbVCH+aiK6+MRhbmEjIkJ+ECdfIAM
        Ul9qxEw7UVtARquRaBqO0w8=
X-Google-Smtp-Source: ABdhPJwNwnmEVOUoxE+5tYpmDlng2XaL1ZeIo8IPSr6kuBTuqiWMyqqtsb0oeh2omBYoH5fW3F/SzQ==
X-Received: by 2002:adf:e685:: with SMTP id r5mr22708000wrm.340.1602351441235;
        Sat, 10 Oct 2020 10:37:21 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/12] io_uring: clean file_data access in files_register
Date:   Sat, 10 Oct 2020 18:34:14 +0100
Message-Id: <6c31be7e09c28a6d0f72dee8f441ec142b0ae3bf.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep file_data in a local var and replace with it complex references
such as ctx->file_data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 69 ++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 22d1fb9cc80f..c3ca82f20f3d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7099,13 +7099,13 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 }
 #endif
 
-static int io_sqe_alloc_file_tables(struct io_ring_ctx *ctx, unsigned nr_tables,
-				    unsigned nr_files)
+static int io_sqe_alloc_file_tables(struct fixed_file_data *file_data,
+				    unsigned nr_tables, unsigned nr_files)
 {
 	int i;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &ctx->file_data->table[i];
+		struct fixed_file_table *table = &file_data->table[i];
 		unsigned this_files;
 
 		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
@@ -7120,7 +7120,7 @@ static int io_sqe_alloc_file_tables(struct io_ring_ctx *ctx, unsigned nr_tables,
 		return 0;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &ctx->file_data->table[i];
+		struct fixed_file_table *table = &file_data->table[i];
 		kfree(table->files);
 	}
 	return 1;
@@ -7287,6 +7287,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	int fd, ret = 0;
 	unsigned i;
 	struct fixed_file_ref_node *ref_node;
+	struct fixed_file_data *file_data;
 
 	if (ctx->file_data)
 		return -EBUSY;
@@ -7295,37 +7296,33 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
 
-	ctx->file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
-	if (!ctx->file_data)
+	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
+	if (!file_data)
 		return -ENOMEM;
-	ctx->file_data->ctx = ctx;
-	init_completion(&ctx->file_data->done);
-	INIT_LIST_HEAD(&ctx->file_data->ref_list);
-	spin_lock_init(&ctx->file_data->lock);
+	file_data->ctx = ctx;
+	init_completion(&file_data->done);
+	INIT_LIST_HEAD(&file_data->ref_list);
+	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
-	ctx->file_data->table = kcalloc(nr_tables,
-					sizeof(struct fixed_file_table),
-					GFP_KERNEL);
-	if (!ctx->file_data->table) {
-		kfree(ctx->file_data);
-		ctx->file_data = NULL;
+	file_data->table = kcalloc(nr_tables, sizeof(file_data->table),
+				   GFP_KERNEL);
+	if (!file_data->table) {
+		kfree(file_data);
 		return -ENOMEM;
 	}
 
-	if (percpu_ref_init(&ctx->file_data->refs, io_file_ref_kill,
+	if (percpu_ref_init(&file_data->refs, io_file_ref_kill,
 				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		kfree(ctx->file_data->table);
-		kfree(ctx->file_data);
-		ctx->file_data = NULL;
+		kfree(file_data->table);
+		kfree(file_data);
 		return -ENOMEM;
 	}
 
-	if (io_sqe_alloc_file_tables(ctx, nr_tables, nr_args)) {
-		percpu_ref_exit(&ctx->file_data->refs);
-		kfree(ctx->file_data->table);
-		kfree(ctx->file_data);
-		ctx->file_data = NULL;
+	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args)) {
+		percpu_ref_exit(&file_data->refs);
+		kfree(file_data->table);
+		kfree(file_data);
 		return -ENOMEM;
 	}
 
@@ -7342,7 +7339,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			continue;
 		}
 
-		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+		table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
 		file = fget(fd);
 
@@ -7372,16 +7369,16 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				fput(file);
 		}
 		for (i = 0; i < nr_tables; i++)
-			kfree(ctx->file_data->table[i].files);
+			kfree(file_data->table[i].files);
 
-		percpu_ref_exit(&ctx->file_data->refs);
-		kfree(ctx->file_data->table);
-		kfree(ctx->file_data);
-		ctx->file_data = NULL;
+		percpu_ref_exit(&file_data->refs);
+		kfree(file_data->table);
+		kfree(file_data);
 		ctx->nr_user_files = 0;
 		return ret;
 	}
 
+	ctx->file_data = file_data;
 	ret = io_sqe_files_scm(ctx);
 	if (ret) {
 		io_sqe_files_unregister(ctx);
@@ -7394,11 +7391,11 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return PTR_ERR(ref_node);
 	}
 
-	ctx->file_data->cur_refs = &ref_node->refs;
-	spin_lock(&ctx->file_data->lock);
-	list_add(&ref_node->node, &ctx->file_data->ref_list);
-	spin_unlock(&ctx->file_data->lock);
-	percpu_ref_get(&ctx->file_data->refs);
+	file_data->cur_refs = &ref_node->refs;
+	spin_lock(&file_data->lock);
+	list_add(&ref_node->node, &file_data->ref_list);
+	spin_unlock(&file_data->lock);
+	percpu_ref_get(&file_data->refs);
 	return ret;
 }
 
-- 
2.24.0

