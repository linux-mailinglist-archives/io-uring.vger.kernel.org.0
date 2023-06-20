Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED819736B11
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjFTLdL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjFTLdI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:33:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D2D10E2
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HEPUBv3V9+ZWs9gYEpLcOWvdWubsLh0s75fklAsOQg0=; b=trISI0otxVkr1X6MzYr/vrX1oz
        PNzYtet2vLp004Mb1HwU/EtWpW7bvIlkBUGaGd5ZR1ZGIaR6kZgMer9CRRsCEvtlxsBHQTixqlJoj
        mCa4ktt09F4Ycg9jY5ZJQpHD5j+nXZz2GRyPVxr/aEG/q0xWoLHUYZFsxFvHZQ5WIlxr59N7+JcV0
        4/G6Jgim+Tj0/AgeRqcJOUO74M6wOMSjueZmAZQrBR5pdxYO/dvVx1cRzLAP/MGzMYmDex/q4irex
        zHLxzGmNIOQJckeXrRtVO0yCxiYZx4JtBxTLwOtCnkb6Edpb6YSe1sf2ApszXhLUiyHlkmUpGItQ3
        BpUUsxMQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbd-00B8cN-1g;
        Tue, 20 Jun 2023 11:33:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 8/8] io_uring: add helpers to decode the fixed file file_ptr
Date:   Tue, 20 Jun 2023 13:32:35 +0200
Message-Id: <20230620113235.920399-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620113235.920399-1-hch@lst.de>
References: <20230620113235.920399-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove all the open coded magic on slot->file_ptr by introducing two
helpers that return the file pointer and the flags instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/filetable.c | 11 ++++-------
 io_uring/filetable.h | 22 +++++++++++++++-------
 io_uring/io_uring.c  | 10 ++++------
 io_uring/rsrc.c      |  8 ++++----
 4 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 0f6fa791a47de6..e7d749991de426 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -78,10 +78,8 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
 
 	if (file_slot->file_ptr) {
-		struct file *old_file;
-
-		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-		ret = io_queue_rsrc_removal(ctx->file_data, slot_index, old_file);
+		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
+					    io_slot_file(file_slot));
 		if (ret)
 			return ret;
 
@@ -140,7 +138,6 @@ int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 {
 	struct io_fixed_file *file_slot;
-	struct file *file;
 	int ret;
 
 	if (unlikely(!ctx->file_data))
@@ -153,8 +150,8 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 	if (!file_slot->file_ptr)
 		return -EBADF;
 
-	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-	ret = io_queue_rsrc_removal(ctx->file_data, offset, file);
+	ret = io_queue_rsrc_removal(ctx->file_data, offset,
+				    io_slot_file(file_slot));
 	if (ret)
 		return ret;
 
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 697cb68adc8169..b47adf170c314d 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -5,10 +5,6 @@
 #include <linux/file.h>
 #include <linux/io_uring_types.h>
 
-#define FFS_NOWAIT		0x1UL
-#define FFS_ISREG		0x2UL
-#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
-
 bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files);
 void io_free_file_tables(struct io_file_table *table);
 
@@ -43,12 +39,24 @@ io_fixed_file_slot(struct io_file_table *table, unsigned i)
 	return &table->files[i];
 }
 
+#define FFS_NOWAIT		0x1UL
+#define FFS_ISREG		0x2UL
+#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
+
+static inline unsigned int io_slot_flags(struct io_fixed_file *slot)
+{
+	return (slot->file_ptr & ~FFS_MASK) << REQ_F_SUPPORT_NOWAIT_BIT;
+}
+
+static inline struct file *io_slot_file(struct io_fixed_file *slot)
+{
+	return (struct file *)(slot->file_ptr & FFS_MASK);
+}
+
 static inline struct file *io_file_from_index(struct io_file_table *table,
 					      int index)
 {
-	struct io_fixed_file *slot = io_fixed_file_slot(table, index);
-
-	return (struct file *) (slot->file_ptr & FFS_MASK);
+	return io_slot_file(io_fixed_file_slot(table, index));
 }
 
 static inline void io_fixed_file_set(struct io_fixed_file *file_slot,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1f348753694bfe..ae4cb3c4e73034 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2028,19 +2028,17 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 				      unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_fixed_file *slot;
 	struct file *file = NULL;
-	unsigned long file_ptr;
 
 	io_ring_submit_lock(ctx, issue_flags);
 
 	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 		goto out;
 	fd = array_index_nospec(fd, ctx->nr_user_files);
-	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
-	file = (struct file *) (file_ptr & FFS_MASK);
-	file_ptr &= ~FFS_MASK;
-	/* mask in overlapping REQ_F and FFS bits */
-	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
+	slot = io_fixed_file_slot(&ctx->file_table, fd);
+	file = io_slot_file(slot);
+	req->flags |= io_slot_flags(slot);
 	io_req_set_rsrc_node(req, ctx, 0);
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d46f72a5ef7323..a2dce7ef3a7877 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -354,7 +354,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	__s32 __user *fds = u64_to_user_ptr(up->data);
 	struct io_rsrc_data *data = ctx->file_data;
 	struct io_fixed_file *file_slot;
-	struct file *file;
 	int fd, i, err = 0;
 	unsigned int done;
 
@@ -382,15 +381,16 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 
 		if (file_slot->file_ptr) {
-			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, i, file);
+			err = io_queue_rsrc_removal(data, i,
+						    io_slot_file(file_slot));
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
 			io_file_bitmap_clear(&ctx->file_table, i);
 		}
 		if (fd != -1) {
-			file = fget(fd);
+			struct file *file = fget(fd);
+
 			if (!file) {
 				err = -EBADF;
 				break;
-- 
2.39.2

