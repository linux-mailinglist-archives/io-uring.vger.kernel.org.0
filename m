Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3BA51F224
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 03:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiEIB27 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 21:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiEHXxG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 19:53:06 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB2DBF4C
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 16:49:15 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p12so10870767pfn.0
        for <io-uring@vger.kernel.org>; Sun, 08 May 2022 16:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j/d0p5pWSP9wHU3nKy29DnMcueFakMykBlOZYQLF7EQ=;
        b=j78iUJ85jPNNOdw6BhJfp74TG6w19ZYFjc/WeUgxpOldkU+1JGydyJm7LZX5gu2Y14
         dikUOGdzFV+doiVkiDyajC+kJT67lbgvk/N3sqHUzFeE4/S2perxuXbFFWRv7zWOiIEV
         +iiDsXdpQRPWS/e9OkhNWY+mTuSF0YbA4o9RxslmSIm65UMVVYwf/IZp07PGvUjeQCud
         owghEpUmDQNtoKxau8twXQfXx9VvVBnqW8z9Ii1gsdUYQz8TcS6M+qWXCqwEjI36TGqO
         Er79p5mYGSIkrfof2n7YP4o8GZ1ixCjD11txaE5esMf5xu5+XWWdEBpYhzSedovuxw82
         a/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j/d0p5pWSP9wHU3nKy29DnMcueFakMykBlOZYQLF7EQ=;
        b=ad3ybRH5hr9+8zD8L/dC1WBTTlmvOfIndEVXu1FY0QR8Rc7fSM7xoO+orkROxpDaC6
         GsOGYdiuiLowCDS3N1OmgrF4wevRK7p1LqjhS/LuqTVxZ7Z6TxpH7KrWb7z0UDA5ldOZ
         OHkvII++C9U3ECoqzCp948ZeOLwPlzeNcPmTCQdzWj3T8Htn1UotFZEg9t5j7XSVpOcA
         fUrBOGkfQv6cTHawMaO6PZEZZdDDl95Hvo1lKJTReJJDXgw5f9XxrSFzvBS446zmzSwx
         E32jxtAtqFLmZnW3/+ejK5rqcxIBt0h786klm+CTgr1g8b9oa5wJHJjXkF1E37aU08P4
         URrQ==
X-Gm-Message-State: AOAM533EvIMDGMA8z7LSkJIDi+U1gdfRzhJdPACTSHDrX7EjTa5zZGQv
        tRYDmlHhOv8gwY6NV3tmrfNO/mQ3fQrDdnRh
X-Google-Smtp-Source: ABdhPJzTtiDllsVjdC2aazpIADfnDwHMQucM04pRcBxzaJ8jqHYnjQQiEDsZCqSHfL4Vtk9givIaFA==
X-Received: by 2002:a05:6a00:1252:b0:50e:9fc:d5b7 with SMTP id u18-20020a056a00125200b0050e09fcd5b7mr13435469pfi.85.1652053753808;
        Sun, 08 May 2022 16:49:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a170902ccd100b0015e8d4eb2a2sm5675249ple.236.2022.05.08.16.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 16:49:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: track fixed files with a bitmap
Date:   Sun,  8 May 2022 17:49:06 -0600
Message-Id: <20220508234909.224108-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508234909.224108-1-axboe@kernel.dk>
References: <20220508234909.224108-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for adding a basic allocator for direct descriptors,
add helpers that set/clear whether a file slot is used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6d491c9a25f..6eac6629e7d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -257,6 +257,7 @@ struct io_rsrc_put {
 
 struct io_file_table {
 	struct io_fixed_file *files;
+	unsigned long *bitmap;
 };
 
 struct io_rsrc_node {
@@ -7573,6 +7574,7 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx, 0);
+	WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
@@ -8639,13 +8641,35 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
 	table->files = kvcalloc(nr_files, sizeof(table->files[0]),
 				GFP_KERNEL_ACCOUNT);
-	return !!table->files;
+	if (unlikely(!table->files))
+		return false;
+
+	table->bitmap = bitmap_zalloc(nr_files, GFP_KERNEL_ACCOUNT);
+	if (unlikely(!table->bitmap)) {
+		kvfree(table->files);
+		return false;
+	}
+
+	return true;
 }
 
 static void io_free_file_tables(struct io_file_table *table)
 {
 	kvfree(table->files);
+	bitmap_free(table->bitmap);
 	table->files = NULL;
+	table->bitmap = NULL;
+}
+
+static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
+{
+	WARN_ON_ONCE(test_bit(bit, table->bitmap));
+	__set_bit(bit, table->bitmap);
+}
+
+static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
+{
+	__clear_bit(bit, table->bitmap);
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
@@ -8660,6 +8684,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 			continue;
 		if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
 			continue;
+		io_file_bitmap_clear(&ctx->file_table, i);
 		fput(file);
 	}
 #endif
@@ -9063,6 +9088,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		}
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 		io_fixed_file_set(file_slot, file);
+		io_file_bitmap_set(&ctx->file_table, i);
 	}
 
 	io_rsrc_node_switch(ctx, NULL);
@@ -9123,6 +9149,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 		if (ret)
 			goto err;
 		file_slot->file_ptr = 0;
+		io_file_bitmap_clear(&ctx->file_table, slot_index);
 		needs_switch = true;
 	}
 
@@ -9130,13 +9157,16 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	if (!ret) {
 		*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 		io_fixed_file_set(file_slot, file);
+		io_file_bitmap_set(&ctx->file_table, slot_index);
 	}
 err:
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);
 	io_ring_submit_unlock(ctx, issue_flags);
-	if (ret)
+	if (ret) {
+		io_file_bitmap_clear(&ctx->file_table, slot_index);
 		fput(file);
+	}
 	return ret;
 }
 
@@ -9171,6 +9201,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 		goto out;
 
 	file_slot->file_ptr = 0;
+	io_file_bitmap_clear(&ctx->file_table, offset);
 	io_rsrc_node_switch(ctx, ctx->file_data);
 	ret = 0;
 out:
@@ -9220,6 +9251,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
+			io_file_bitmap_clear(&ctx->file_table, i);
 			needs_switch = true;
 		}
 		if (fd != -1) {
@@ -9248,6 +9280,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			}
 			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
+			io_file_bitmap_set(&ctx->file_table, i);
 		}
 	}
 
-- 
2.35.1

