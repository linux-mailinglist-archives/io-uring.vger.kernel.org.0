Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E138215B
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhEPV7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhEPV7u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:50 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40859C061756
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:34 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id p7so684675wru.10
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dRdh5NxZlibjzLRpisXSeYlA8yZHpVLbuhskiWI+aig=;
        b=L6jY8kBPrbrFXhE5gqzxk+oIoVNGxa6w5oBujsmdwKSfO0LLmkqSg/j98mL1WUBec3
         B9X1TGnD66Vz4BDgOqVcrdx7UKLuGNgCm3V28OyN3I8Liuom+gyPTci+arxNhD/ShiKV
         ImZ2fpR4pCSsvArjIkJpuJcOnWAdZyrf8GdTH8B8Y3TaMPqr378gYPvev9Wr2CWMTsQH
         XFLT8nW7E/fJE5d3f5pO5OKmgIOn+GlwoF/7XV01FRh68cHyUmmTNt9rqMwV8zJdoMDR
         SCKyYiZIMxgQuMj+SwPJgZT0vI8t8AaPt+ENeTFHIkWufTZ8w4kSFJYKNQuXtINhEEYz
         1uIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRdh5NxZlibjzLRpisXSeYlA8yZHpVLbuhskiWI+aig=;
        b=fhDpergq3derCZNmmQF3ij21TEfB5cdSB3cgjbuGNivz8tAPMegOtrIU6smEzqstXF
         L2dMYuBypPCrJODfHkhMOEWQXHoPFjKRCJF3B6Sm8ycrF+kCi9EVav41hRKDT6ATsVCE
         DzUaRWpCPeQlvxIdjpnyOYw/COv+V6m9dmtxMRWfFzsdVHyHmZo5QYlyZOC3jOD6XqB0
         hESPULthv+8vGPSwYyPfkA9nkjgKggeIuy/EiED4H0mVqsVrBM3vfwLF+19HVDQyJ3f2
         4UZabR6NXew+ImIegIdRB2kEX4rYUgRvqiuFcZfR24ny2Ss1dpIDhSopm1uRxm0J/aR6
         8GeA==
X-Gm-Message-State: AOAM531cX4ImA9w3/Kri+DZj9/X9DoxfYGqVtHoTL0vF94/nX4pzjR6J
        qGQsg8K6Pk0u2u2WHC+iO6I=
X-Google-Smtp-Source: ABdhPJz0AEB8CuP89s2Rm8bsoca7bZiC/R+ILbK+lxB8l8LbU/V0pFg02qem1930FByaY/JpF3//5A==
X-Received: by 2002:adf:e58c:: with SMTP id l12mr8138028wrm.133.1621202313072;
        Sun, 16 May 2021 14:58:33 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/13] io_uring: better locality for rsrc fields
Date:   Sun, 16 May 2021 22:58:07 +0100
Message-Id: <05b34795bb4440f4ec4510f08abd5a31830f8ca0.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ring has two types of resource-related fields: used for request
submission, and field needed for update/registration. Reshuffle them
into these two groups for better locality and readability. The second
group is not in the hot path, so it's natural to place them somewhere in
the end. Also update an outdated comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 83104f3a009e..10970ed32f27 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -391,21 +391,17 @@ struct io_ring_ctx {
 	struct list_head	sqd_list;
 
 	/*
-	 * If used, fixed file set. Writers must ensure that ->refs is dead,
-	 * readers must ensure that ->refs is alive as long as the file* is
-	 * used. Only updated through io_uring_register(2).
+	 * Fixed resources fast path, should be accessed only under uring_lock,
+	 * and updated through io_uring_register(2)
 	 */
-	struct io_rsrc_data	*file_data;
+	struct io_rsrc_node	*rsrc_node;
+
 	struct io_file_table	file_table;
 	unsigned		nr_user_files;
-
-	/* if used, fixed mapped user buffers */
-	struct io_rsrc_data	*buf_data;
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	**user_bufs;
 
 	struct xarray		io_buffers;
-
 	struct xarray		personalities;
 	u32			pers_next;
 
@@ -437,16 +433,21 @@ struct io_ring_ctx {
 		bool			poll_multi_file;
 	} ____cacheline_aligned_in_smp;
 
-	struct delayed_work		rsrc_put_work;
-	struct llist_head		rsrc_put_llist;
-	struct list_head		rsrc_ref_list;
-	spinlock_t			rsrc_ref_lock;
-	struct io_rsrc_node		*rsrc_node;
-	struct io_rsrc_node		*rsrc_backup_node;
-	struct io_mapped_ubuf		*dummy_ubuf;
-
 	struct io_restriction		restrictions;
 
+	/* slow path rsrc auxilary data, used by update/register */
+	struct {
+		struct io_rsrc_node		*rsrc_backup_node;
+		struct io_mapped_ubuf		*dummy_ubuf;
+		struct io_rsrc_data		*file_data;
+		struct io_rsrc_data		*buf_data;
+
+		struct delayed_work		rsrc_put_work;
+		struct llist_head		rsrc_put_llist;
+		struct list_head		rsrc_ref_list;
+		spinlock_t			rsrc_ref_lock;
+	};
+
 	/* Keep this last, we don't need it for the fast path */
 	struct {
 		#if defined(CONFIG_UNIX)
-- 
2.31.1

