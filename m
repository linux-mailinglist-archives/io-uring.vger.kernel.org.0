Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8015F3AD5F9
	for <lists+io-uring@lfdr.de>; Sat, 19 Jun 2021 01:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhFRXeu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 19:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbhFRXeu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 19:34:50 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24D7C06175F
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 16:32:39 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n7so12467233wri.3
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 16:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=v2yQYj3K5U8cQ4y7f6KFOielPUSEgA/Yenne6pvQEOk=;
        b=DzFVfRVDSuMm7QHrltanc6v5dvZjwj0EMmdtKLSaj+MOly0/Q6G38S4zBnuqMczPMq
         nqNKkG6B1LoGgR1ior0lyyk+TQuy6bv7g0h5BuMEH1o17YUqJ8Gj9RJv2qx/9Kwu9AFo
         OP0+i75axwoCIgMqhXBesVL/VDmWfcx2AjBQ4EsWjLJbiZSA/dNagmrpWLUlQ2x28I0A
         IhN8fB4vFtw7LYA3kjzqH+Sx5UGe4ATLhkuVvlBrFx2D7AA/+CKS4n+JpHBjDS7hPk98
         oZYPBE8UlVDXfkK5AkredOrzeN+5qv0tGoDBNajLSMxMXGoDX85vCMuGStY/o6/EPs8i
         hJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v2yQYj3K5U8cQ4y7f6KFOielPUSEgA/Yenne6pvQEOk=;
        b=U+38tQ3xnsFZejNJb/Zy1S6exx5kbhrGi9q29fTN3nJlJOeQeleAD8s3AcMb3Z0MjS
         eNL7oXplVzW5q2PHM/yaa1SXqh0ywtZOekSY+9rMBbnRLruk2XtYHEf8PGKdM3hIZsSc
         HQa13dI+015qXpLzRMhLYLRPJNBORL8944FQ0y7ZY3OPRSJVmEB3smeTDQia6Q/YwWXp
         PGpUmR7Hlhno/EIyw5tdh0HujUmHnZDUex4/oCTgXGvpq6URdHjIXoED9Vkr8m11LQBE
         gYvVTwdS5q1fKJREXU83ip/HXZMoS064zA4C/8DtMRqMWE2UHE7nZ9KIEAlimo0+Orb/
         tuoQ==
X-Gm-Message-State: AOAM53280dvtSxPe2TqxO2IGQfw98jYEpthGAs4/8rYtQ+XZUyx+zFL6
        Kw1o2VdKi7d76vkbwHJN1/4=
X-Google-Smtp-Source: ABdhPJzoPpioYKRjEWwaJiH80Bi2y3FjqiMtsbVXvA9CDAKo9LjL+w0wW500yEh16/J2zprtlw8j6A==
X-Received: by 2002:a5d:4983:: with SMTP id r3mr10612284wrq.184.1624059158557;
        Fri, 18 Jun 2021 16:32:38 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.72])
        by smtp.gmail.com with ESMTPSA id o20sm11765774wms.3.2021.06.18.16.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 16:32:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: use kvmalloc for fixed files
Date:   Sat, 19 Jun 2021 00:32:16 +0100
Message-Id: <6cb62be31eb68274fb043d4eadc28454d64e28da.1624058853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624058853.git.asml.silence@gmail.com>
References: <cover.1624058853.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currenlty we hand code two-level tables for storing registered files,
pointers that requires more memory loads and a bunch of bit logic in the
hot path.

I expect for most cases it would be enough for applications to allocate
a small enough amount of fixed files, that would fit into a couple of
contiguous pages (512 entries per page of x64, 1024 for 2 pages). So, in
most cases I'd expect kvmalloc to be able to allocate contiguous memory
with no drawbacks but performance improvement.

If it can't (depends, around >=8 pages?), it will do vmalloc, so the
outcome is not clear, whether it's better to have 2 memory loads plus a
bunch of instructions or a TLB assisted virtual memory lookup.

Considering that we limit it to 64 pages max, and it should benefit
without disadvantages most of the users, it's the right thing to have.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3dfd52813bb6..2fd54a21ed8b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -90,13 +90,8 @@
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
-/*
- * Shift of 9 is 512 entries, or exactly one page on 64-bit archs
- */
-#define IORING_FILE_TABLE_SHIFT	9
-#define IORING_MAX_FILES_TABLE	(1U << IORING_FILE_TABLE_SHIFT)
-#define IORING_FILE_TABLE_MASK	(IORING_MAX_FILES_TABLE - 1)
-#define IORING_MAX_FIXED_FILES	(64 * IORING_MAX_FILES_TABLE)
+/* 512 entries per page on 64-bit archs, 64 pages max */
+#define IORING_MAX_FIXED_FILES	(1U << 15)
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
@@ -233,8 +228,7 @@ struct io_rsrc_put {
 };
 
 struct io_file_table {
-	/* two level table */
-	struct io_fixed_file **files;
+	struct io_fixed_file *files;
 };
 
 struct io_rsrc_node {
@@ -6320,12 +6314,9 @@ static void io_wq_submit_work(struct io_wq_work *work)
 #define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
 
 static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
-						      unsigned i)
+						       unsigned i)
 {
-	struct io_fixed_file *table_l2;
-
-	table_l2 = table->files[i >> IORING_FILE_TABLE_SHIFT];
-	return &table_l2[i & IORING_FILE_TABLE_MASK];
+	return &table->files[i];
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
@@ -7255,17 +7246,13 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 
 static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
-	size_t size = nr_files * sizeof(struct io_fixed_file);
-
-	table->files = (struct io_fixed_file **)io_alloc_page_table(size);
+	table->files = kvcalloc(nr_files, sizeof(table->files[0]), GFP_KERNEL);
 	return !!table->files;
 }
 
-static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
+static void io_free_file_tables(struct io_file_table *table)
 {
-	size_t size = nr_files * sizeof(struct io_fixed_file);
-
-	io_free_page_table((void **)table->files, size);
+	kvfree(table->files);
 	table->files = NULL;
 }
 
@@ -7290,7 +7277,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 			fput(file);
 	}
 #endif
-	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
+	io_free_file_tables(&ctx->file_table);
 	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
@@ -7757,7 +7744,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		if (file)
 			fput(file);
 	}
-	io_free_file_tables(&ctx->file_table, nr_args);
+	io_free_file_tables(&ctx->file_table);
 	ctx->nr_user_files = 0;
 out_free:
 	io_rsrc_data_free(ctx->file_data);
-- 
2.31.1

