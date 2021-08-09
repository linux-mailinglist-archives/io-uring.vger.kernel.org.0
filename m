Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60533E4531
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhHIMF0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHIMF0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEAFC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:05 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h14so21061474wrx.10
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zia81U9+EA5RBsp8lhfs+08hUmUH0RDz9Bkt2HKi5CI=;
        b=n5bQMxCjQwVc6/mIZGQmacEgaIeo7wsCHXdpggMJTRnwkOddwGkOXTCTwGjvemtPEG
         zSoPWjFkuHM78reYseyUcROCVVRtLHNWxIAq7DjVwL8rOfXvqWgiAN1LThutkuf/R9zU
         sFCpgXKdHS3emztw351GPHvtN1WTko1ToG6ySGK0Fet1hqKQ1nrh1UOdFbrfo5y7kjKF
         RxQ/dFZ6gRJs5BIHJnjRUK831UjKn2A2m2SrpgYaenPqvkFdHIZnXUZamOL/+j1jEjbT
         4UAQId5Wc30OfPBVED9S2pMcA2sttQx4Xi7ei4252ufEnEKwo2CX9YVUmUD6ted1LZ6B
         eCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zia81U9+EA5RBsp8lhfs+08hUmUH0RDz9Bkt2HKi5CI=;
        b=uDCX9CPzOIzdxBNDv+H8p4yB/XrSv6W869VuufvqCM41updy1u8QRsr3YOqVOmI5gf
         ZUX5vpXDA1LiS129e04VqmmMu5WgPr2w4EwrjMJnjUZmXxOJdFel4+Cxe+a4TjbaLP0a
         qqUvwwTtMm8Gon+kFfBN5DvGarwVuDHJrqGA2bV4ugShceGtXNqg10wOrYMlJtgXCogk
         0F2HCe3CZ08xOTCH5dnbzwujE6EgSV/dSOw0kFUsgvg8P1L+H2cyysJy7qzGQovtTLmq
         cGPqjVlc37q80Q5BY0np+Ghh4o5doumcABtUGu2IBIhtFm8Wa5vnyhjuWrNcKwPl6qfW
         NfzQ==
X-Gm-Message-State: AOAM531o0kbWMDMIcU4u61OPUx8aSzIqVCRRNZysjK6KvpWX1WOXO+hy
        iVErTO0VORIb5PfgQlzpG/ZCNfYdTkw=
X-Google-Smtp-Source: ABdhPJxIehEOgJuLY93cMMvtXHyVb0cyqdgeJ7rPf8sttlkMCTVnNfOiMal22mbE34JEIQfoTPtaSA==
X-Received: by 2002:adf:f90e:: with SMTP id b14mr22964719wrr.28.1628510704584;
        Mon, 09 Aug 2021 05:05:04 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/28] io_uring: use kvmalloc for fixed files
Date:   Mon,  9 Aug 2021 13:04:01 +0100
Message-Id: <280421d3b48775dabab773006bb5588c7b2dabc0.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of hand-coded two-level tables for registered files, allocate
them with kvmalloc(). In many cases small enough tables are enough, and
so can be kmalloc()'ed removing an extra memory load and a bunch of bit
logic instructions from the hot path. If the table is larger, we trade
off all the pros with a TLB-assisted memory lookup.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ebf467e0cb0f..5072f84ef99f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -91,13 +91,8 @@
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
 
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
 
@@ -234,8 +229,7 @@ struct io_rsrc_put {
 };
 
 struct io_file_table {
-	/* two level table */
-	struct io_fixed_file **files;
+	struct io_fixed_file *files;
 };
 
 struct io_rsrc_node {
@@ -6334,12 +6328,9 @@ static void io_wq_submit_work(struct io_wq_work *work)
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
@@ -7283,17 +7274,13 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 
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
 
@@ -7318,7 +7305,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 			fput(file);
 	}
 #endif
-	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
+	io_free_file_tables(&ctx->file_table);
 	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
@@ -7785,7 +7772,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		if (file)
 			fput(file);
 	}
-	io_free_file_tables(&ctx->file_table, nr_args);
+	io_free_file_tables(&ctx->file_table);
 	ctx->nr_user_files = 0;
 out_free:
 	io_rsrc_data_free(ctx->file_data);
-- 
2.32.0

