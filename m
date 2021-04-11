Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB735B111
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhDKAvW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKAvV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA51C06138C
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:06 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g18-20020a7bc4d20000b0290116042cfdd8so6671195wmk.4
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gEOIpkDWPMQQOs1zC7+O7ayYb5xAjm0PsuZrwGkNNo8=;
        b=gL+PHN5WForr7AKZSiIo23GhdWlqlhIX/PgCs1as8hOrNJRGu8h8H/zN9PsMSShURF
         hgB7AICXUeikFcuPWaaqN5j9rPCAG/tmTIf6fO4+1n9kvoYFDWrT68bSdPVumcD9GfBu
         Z5EtpWYJvKfAxkXWvTc2itTfbU5rhRI7G989gm0gaa8T+CbzJSXfVqTgfUhIW1Bp6PnE
         RIjO7CQOzFt+WAl2VSuLHqoaqbZrHro4LSd2nTjO4GzgwJWK5sJuBSpOnv/HM1pgZMxV
         pdqJz8uvA5DAY2N0uN1Gy7y4VEteiZEo6Jj+ztf5+M1z1Pp3Zf7EQQ89SPkTiTTvHPFz
         XP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEOIpkDWPMQQOs1zC7+O7ayYb5xAjm0PsuZrwGkNNo8=;
        b=CWUHjlWRuaE/bos+k7T2b8+CujvnP3nUpyZD8FGPae3N0Fzu9/3+XV1ERsWFgPGF0d
         itBY4uWkfC7SRr01LQdQNmWeX/BEnK15DjUsC9S/B/o7+p/cCn7Oa6tiJfBrfSwXnlK0
         AB3n/XVUSqvJ/1UBya9Yn80W1Pi+p9/SfO5yyMTSpzdKnCAvRD0ZcB7vMWF1WYoabgis
         y6/d/naBiaQkNydtQWlyYouV4IbjooDyP2G2K+IEVLRVNrxLdhZCgM3Hubf7g1vAlgtE
         BQHtoQMbiBR/IzvxNlW7+HU7v65xp3q3ufrCDl9z21rAWBd8VYsAP96XrH61SUo1Gtul
         jpSw==
X-Gm-Message-State: AOAM533p0KNPeAwfrKR+HBWQWVPbASdHmcr2mi0rY/63J8AtHFV9JU8D
        +WhpH5gvk4GeTP20HLkwy5U=
X-Google-Smtp-Source: ABdhPJz7/7vKwe+rp9h+IRgApVEgzIda7lett5P07h/sZEahz1rhWxJMlrF9nsXb2P11MSuoKsY9qQ==
X-Received: by 2002:a7b:c1c4:: with SMTP id a4mr19666614wmj.67.1618102265070;
        Sat, 10 Apr 2021 17:51:05 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/16] io_uring: split file table from rsrc nodes
Date:   Sun, 11 Apr 2021 01:46:37 +0100
Message-Id: <de9fc4cd3545f24c26c03be4556f58ba3d18b9c3.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need to store file tables in rsrc nodes, for now it's easier to
handle tables not generically, so move file tables into the context. A
nice side effect is having one less pointer dereference for request with
fixed file initialisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4be1f1efce26..d14a64cd2741 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -220,8 +220,9 @@ struct io_rsrc_put {
 	};
 };
 
-struct fixed_rsrc_table {
-	struct io_fixed_file *files;
+struct io_file_table {
+	/* two level table */
+	struct io_fixed_file **files;
 };
 
 struct io_rsrc_node {
@@ -236,7 +237,6 @@ struct io_rsrc_node {
 typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
 struct io_rsrc_data {
-	struct fixed_rsrc_table		*table;
 	struct io_ring_ctx		*ctx;
 
 	rsrc_put_fn			*do_put;
@@ -400,6 +400,7 @@ struct io_ring_ctx {
 	 * used. Only updated through io_uring_register(2).
 	 */
 	struct io_rsrc_data	*file_data;
+	struct io_file_table	file_table;
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
@@ -6270,19 +6271,19 @@ static void io_wq_submit_work(struct io_wq_work *work)
 #endif
 #define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
 
-static inline struct io_fixed_file *io_fixed_file_slot(struct io_rsrc_data *file_data,
+static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
 						      unsigned i)
 {
-	struct fixed_rsrc_table *table;
+	struct io_fixed_file *table_l2;
 
-	table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-	return &table->files[i & IORING_FILE_TABLE_MASK];
+	table_l2 = table->files[i >> IORING_FILE_TABLE_SHIFT];
+	return &table_l2[i & IORING_FILE_TABLE_MASK];
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 					      int index)
 {
-	struct io_fixed_file *slot = io_fixed_file_slot(ctx->file_data, index);
+	struct io_fixed_file *slot = io_fixed_file_slot(&ctx->file_table, index);
 
 	return (struct file *) (slot->file_ptr & FFS_MASK);
 }
@@ -6312,7 +6313,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 		if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
-		file_ptr = io_fixed_file_slot(ctx->file_data, fd)->file_ptr;
+		file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
 		file = (struct file *) (file_ptr & FFS_MASK);
 		file_ptr &= ~FFS_MASK;
 		/* mask in overlapping REQ_F and FFS bits */
@@ -7049,14 +7050,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-static void io_free_file_tables(struct io_rsrc_data *data, unsigned nr_files)
+static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
 {
 	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
 
 	for (i = 0; i < nr_tables; i++)
-		kfree(data->table[i].files);
-	kfree(data->table);
-	data->table = NULL;
+		kfree(table->files[i]);
+	kfree(table->files);
+	table->files = NULL;
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
@@ -7196,7 +7197,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		return ret;
 
 	__io_sqe_files_unregister(ctx);
-	io_free_file_tables(data, ctx->nr_user_files);
+	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
@@ -7426,23 +7427,20 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 }
 #endif
 
-static bool io_alloc_file_tables(struct io_rsrc_data *file_data,
-				 unsigned nr_files)
+static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
 	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
 
-	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
-				   GFP_KERNEL);
-	if (!file_data->table)
+	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL);
+	if (!table->files)
 		return false;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_rsrc_table *table = &file_data->table[i];
 		unsigned int this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 
-		table->files = kcalloc(this_files, sizeof(struct file *),
+		table->files[i] = kcalloc(this_files, sizeof(*table->files[i]),
 					GFP_KERNEL);
-		if (!table->files)
+		if (!table->files[i])
 			break;
 		nr_files -= this_files;
 	}
@@ -7450,7 +7448,7 @@ static bool io_alloc_file_tables(struct io_rsrc_data *file_data,
 	if (i == nr_tables)
 		return true;
 
-	io_free_file_tables(file_data, nr_tables * IORING_MAX_FILES_TABLE);
+	io_free_file_tables(table, nr_tables * IORING_MAX_FILES_TABLE);
 	return false;
 }
 
@@ -7618,9 +7616,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
-
 	ret = -ENOMEM;
-	if (!io_alloc_file_tables(file_data, nr_args))
+	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
@@ -7648,7 +7645,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		io_fixed_file_set(io_fixed_file_slot(file_data, i), file);
+		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
 	}
 
 	ret = io_sqe_files_scm(ctx);
@@ -7665,7 +7662,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		if (file)
 			fput(file);
 	}
-	io_free_file_tables(file_data, nr_args);
+	io_free_file_tables(&ctx->file_table, nr_args);
 	ctx->nr_user_files = 0;
 out_free:
 	kfree(ctx->file_data);
@@ -7761,7 +7758,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
-		file_slot = io_fixed_file_slot(ctx->file_data, i);
+		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 
 		if (file_slot->file_ptr) {
 			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-- 
2.24.0

