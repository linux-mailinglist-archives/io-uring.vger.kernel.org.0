Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5F652019D
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiEIPy4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbiEIPyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:54:55 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218604E3B7
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 08:51:00 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id z12so9573084ilp.8
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 08:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IZxPNfFuGLTrjOo64W6lrRV96iZlzy1JKXgyBGh12F0=;
        b=slG4Lf4TXeH4Ka7zsxfDf1A45aj9BKe0ltsJkRsSZsxPx3w9VMv5jh03lg5NF7XYjx
         XSkxVD/jPH/hF+OwVTyjVUdNjoLqlRMcr8quydYUvkEliZxeGfrTfjFW6WtGDv4cgXgP
         BBksAgjqHuzYrOzMRRgZpM2rGH7nj3jkk1Lt+QRPXWilfvnaUwwT0S86eCd8reRhLNqt
         lfZxArt+4O6+C6AzTxRWUUzDRPJtjE5Ki8Ooo6EK6ap4kQOxzI65r05p8EIk8njTMTCS
         oXjqO2ANCgZDoCLzzVE2OMCSjO84UBBTGBzN92F3NqpuEciMgt4NNsDve8cVWToCSFjx
         sMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IZxPNfFuGLTrjOo64W6lrRV96iZlzy1JKXgyBGh12F0=;
        b=V6nL77pg7bBH8ACZCabDokKzUYpT9m6fsVaEPcTfLCwES5iQzGkfk1EpX5X5+xgfaO
         /Z+AHv9Gj1+zOgVVG2kw1lF1Jveozjy0o8jWmtpMo5DwomwMhVyV5TgDXrVYGFkNVc22
         2I9rMsaesf3FZpnOtMq729i2C/CaBJjY6JnjJZbKEzPu2izECK30IZ3gobunqNJyEpXH
         wed1cc7ije5+lauWSk6zaEQn1/OhOHaXby4nfIcvC3CovBljg1l3LBuepFbX4AihFEe1
         9Y8Kb1GmiGvdHh849PLGUzuMgm4NKUnaxIihw1yOcvfN/O2xV0dceQNDK6/Tsp83kvVJ
         vnhw==
X-Gm-Message-State: AOAM532qzGSfUKVD7nf7MU6MdKfmhR0ArXPuMFlyXAvm4pqaC6QijzXa
        oWzZNGrQ8Y3sXWD+yIK+UD6W1NxC9j8neg==
X-Google-Smtp-Source: ABdhPJxN6dOXSJYdp6jquAx8DoXSXdQWSHonL0fJj42hY3zMci0LTda4iQeGF3KV4461HSxoi4hsYw==
X-Received: by 2002:a05:6e02:128e:b0:2cd:aeb3:ab6 with SMTP id y14-20020a056e02128e00b002cdaeb30ab6mr6675684ilq.291.1652111458923;
        Mon, 09 May 2022 08:50:58 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1-20020a056638004100b0032b3a78177esm3696499jap.66.2022.05.09.08.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:50:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: track fixed files with a bitmap
Date:   Mon,  9 May 2022 09:50:50 -0600
Message-Id: <20220509155055.72735-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
References: <20220509155055.72735-1-axboe@kernel.dk>
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
 fs/io_uring.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 22699cb359e9..f8a685cc0363 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -257,6 +257,7 @@ struct io_rsrc_put {
 
 struct io_file_table {
 	struct io_fixed_file *files;
+	unsigned long *bitmap;
 };
 
 struct io_rsrc_node {
@@ -7572,6 +7573,7 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx, 0);
+	WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
@@ -8638,13 +8640,35 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
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
@@ -8659,6 +8683,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 			continue;
 		if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
 			continue;
+		io_file_bitmap_clear(&ctx->file_table, i);
 		fput(file);
 	}
 #endif
@@ -9062,6 +9087,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		}
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 		io_fixed_file_set(file_slot, file);
+		io_file_bitmap_set(&ctx->file_table, i);
 	}
 
 	io_rsrc_node_switch(ctx, NULL);
@@ -9122,6 +9148,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 		if (ret)
 			goto err;
 		file_slot->file_ptr = 0;
+		io_file_bitmap_clear(&ctx->file_table, slot_index);
 		needs_switch = true;
 	}
 
@@ -9129,6 +9156,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	if (!ret) {
 		*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 		io_fixed_file_set(file_slot, file);
+		io_file_bitmap_set(&ctx->file_table, slot_index);
 	}
 err:
 	if (needs_switch)
@@ -9170,6 +9198,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 		goto out;
 
 	file_slot->file_ptr = 0;
+	io_file_bitmap_clear(&ctx->file_table, offset);
 	io_rsrc_node_switch(ctx, ctx->file_data);
 	ret = 0;
 out:
@@ -9219,6 +9248,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
+			io_file_bitmap_clear(&ctx->file_table, i);
 			needs_switch = true;
 		}
 		if (fd != -1) {
@@ -9247,6 +9277,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			}
 			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
+			io_file_bitmap_set(&ctx->file_table, i);
 		}
 	}
 
-- 
2.35.1

