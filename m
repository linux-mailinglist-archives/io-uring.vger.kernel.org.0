Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD4351A93
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbhDASCG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbhDAR7X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:59:23 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CBCC004595
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:42 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id e18so2097225wrt.6
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Lts/+5hOa/YhPSU2wiR4/8PByloonIOYAkIaAxbEMFg=;
        b=FwxETJCN4jne9U2I7ILFR0LxuESImL95sF3NGA3qq76q1ToUkPl/rvJ4tW6xHhHFJ3
         JaDlsH6cewc72F1GrigpLVVa2V2OJrOK07PwbcFt5hMlUl+LNaKXqOcl1b5CkG+Ks4Wl
         Lo/wiQ3SgccCZqcUHVnc5k60DO6ojPAwaa8/F+E7MkY6CCN/pYD8PRhyUATNdYEWrVKh
         cRF1AQAMEsVQvqGE+qGMQ6WyA+1KlPRIgzRqvwdGQIUtd94w7rgEpliGNr1I6uH6CQch
         zAnXVuwS94wk/8B8Q3gSjre554g8TIugbs4x9/AKCvTBwThUfOzZyCB97Km9+s0GZgAP
         bS1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lts/+5hOa/YhPSU2wiR4/8PByloonIOYAkIaAxbEMFg=;
        b=MOhtLAnvVFLDNg9i0GRLij18x3MDResR2Wx0+qD4mxG1NSp5ShBlpylTw7Dv3gjfUa
         mMVgTmeRCLOIhjB+O1377EhDzAOdczRgkXRYxJiWgbTtPEw7Lf0ekE1wP93v8ts8dPPM
         G8DVd7kupaKVpX7VJFxv9bY2kDq6nZVTubR5hor07WEMF7HAz+vc10Djn13lJtjvZ8oH
         TxBDY7v+hVWvMVNwVBEf9s0tPjpFldky2LY1rFvy8ryhERZtAVaW3AmpaBMQ/HypGiuU
         NccSrNtbXqM0jEk2psLx1vTZLXKzEjogH4v17k0J+uLOmox8zKfnVqAGr+a/jN1po5OV
         0C2Q==
X-Gm-Message-State: AOAM530O7isJBC8NhymXIZvIPA7IARsMu4L0uJbzMMRV5P8YrMoFieVk
        yUh9xgrrD8I+uI0fSGKpeqOoiCv26CnIhA==
X-Google-Smtp-Source: ABdhPJychMB7qdw/P3I+q6lVHAzKotBZCV1a5e8HE9H9vaLGc/QGxBJXG8w0y8dH8kPCOi9KxNGP5A==
X-Received: by 2002:a5d:4686:: with SMTP id u6mr10106732wrq.60.1617288521304;
        Thu, 01 Apr 2021 07:48:41 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 24/26] io_uring: refactor file tables alloc/free
Date:   Thu,  1 Apr 2021 15:44:03 +0100
Message-Id: <502a84ebf41ff119b095e59661e678eacb752bf8.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a heler io_free_file_tables() doing all the cleaning, there
are several places where it's hand coded. Also move all allocations into
io_sqe_alloc_file_tables() and rename it, so all of it is in one place.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 +++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2b8496f76baa..a9984ca025ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7031,6 +7031,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
+static void io_free_file_tables(struct io_rsrc_data *data, unsigned nr_files)
+{
+	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
+
+	for (i = 0; i < nr_tables; i++)
+		kfree(data->table[i].files);
+	kfree(data->table);
+	data->table = NULL;
+}
+
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 #if defined(CONFIG_UNIX)
@@ -7167,14 +7177,12 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 static void io_rsrc_data_free(struct io_rsrc_data *data)
 {
 	percpu_ref_exit(&data->refs);
-	kfree(data->table);
 	kfree(data);
 }
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct io_rsrc_data *data = ctx->file_data;
-	unsigned nr_tables, i;
 	int ret;
 
 	if (!data)
@@ -7184,9 +7192,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		return ret;
 
 	__io_sqe_files_unregister(ctx);
-	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
-	for (i = 0; i < nr_tables; i++)
-		kfree(data->table[i].files);
+	io_free_file_tables(data, ctx->nr_user_files);
 	io_rsrc_data_free(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
@@ -7416,16 +7422,20 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 }
 #endif
 
-static int io_sqe_alloc_file_tables(struct io_rsrc_data *file_data,
-				    unsigned nr_tables, unsigned nr_files)
+static bool io_alloc_file_tables(struct io_rsrc_data *file_data,
+				 unsigned nr_files)
 {
-	int i;
+	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
+
+	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
+				   GFP_KERNEL);
+	if (!file_data->table)
+		return false;
 
 	for (i = 0; i < nr_tables; i++) {
 		struct fixed_rsrc_table *table = &file_data->table[i];
-		unsigned this_files;
+		unsigned int this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 
-		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 		table->files = kcalloc(this_files, sizeof(struct file *),
 					GFP_KERNEL);
 		if (!table->files)
@@ -7434,13 +7444,10 @@ static int io_sqe_alloc_file_tables(struct io_rsrc_data *file_data,
 	}
 
 	if (i == nr_tables)
-		return 0;
+		return true;
 
-	for (i = 0; i < nr_tables; i++) {
-		struct fixed_rsrc_table *table = &file_data->table[i];
-		kfree(table->files);
-	}
-	return 1;
+	io_free_file_tables(file_data, nr_tables * IORING_MAX_FILES_TABLE);
+	return false;
 }
 
 static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
@@ -7590,9 +7597,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
-	unsigned nr_tables, i;
 	struct file *file;
 	int fd, ret;
+	unsigned i;
 	struct io_rsrc_data *file_data;
 
 	if (ctx->file_data)
@@ -7611,13 +7618,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	ctx->file_data = file_data;
 
 	ret = -ENOMEM;
-	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
-	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
-				   GFP_KERNEL);
-	if (!file_data->table)
-		goto out_free;
-
-	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
+	if (!io_alloc_file_tables(file_data, nr_args))
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
@@ -7662,8 +7663,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		if (file)
 			fput(file);
 	}
-	for (i = 0; i < nr_tables; i++)
-		kfree(file_data->table[i].files);
+	io_free_file_tables(file_data, nr_args);
 	ctx->nr_user_files = 0;
 out_free:
 	io_rsrc_data_free(ctx->file_data);
-- 
2.24.0

