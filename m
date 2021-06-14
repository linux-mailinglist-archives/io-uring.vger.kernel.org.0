Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1E43A5B64
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhFNBkG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:40:06 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:41503 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhFNBkF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:40:05 -0400
Received: by mail-wr1-f51.google.com with SMTP id o3so12614686wri.8
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9qsZi/SF4wCMnUSiWE0EI7Q10uFEp1UEPU5q2ok/z30=;
        b=Ssk/6vo+40ctDlms5ayB9tLPDXVrL7Tf78vhc2B1LIJAwJew/E4W7+G7VX4M13bvRD
         eFwr7/3HTp/6hfHM0NGhtaqA/0MWL9QV3fJeKoJTT8UZHy205zKuPdzyV8yzYvYRxaw9
         GL6SXwaqoyD5w1PZnrpm3pTnhIIIVhR88ELjkzzA7iWSNrvlzZuRlkAvq18t6SYARs9e
         miLL6W2AHEwjCH7OfVD0LxftWqvwJNkG31INCZPkpKb0d2T3NltJ/fjVrj5wMNRs5ld5
         N5aVbz6Nsz2f/kHJ1ki+ZnXp5O1X1uM6LVXIrq45ej9g8IKKcJNe9QA0y9NU7i2RDZZV
         1fjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9qsZi/SF4wCMnUSiWE0EI7Q10uFEp1UEPU5q2ok/z30=;
        b=gFGn574ZitZn6og4N4VfzD2QLZjf8Qo5C2V1aNUP1GthBuQRvnI+d362K1af7wBE8P
         9MrzYHSsoTIVcx1To2IloJDrnYSCjN7cHXqxVGtEP+Gi2YwLqR5+pfeRRQAM+gQzDLnu
         papW3thyinK4qBGhMt2XahV5fdsoq1NFebkCiGMCg/Qz2jTi3x4ujNk5lEKusHXjBAud
         XhI785EmFXZ2DJDAYqy0WIZvuAMSH6l1C3ZUaK4XZWcz+MdpsokQ4X6xEy6dlSofSv7D
         LYF0ScUL2+jESZyL0IktiQsqJD5aKPDctXNGFi7stN8K9+AksNCf2c1efAZEidITY/v9
         q6sA==
X-Gm-Message-State: AOAM531Dp9HPbst0aLEBJCeCdODFjqTlBUjIJpO7H6SSi2GPc49xdaMa
        ro/yWcZMVh3glXz1X/RI9nK3S5FyquMD2g==
X-Google-Smtp-Source: ABdhPJx90n30xsKcqm+CdWteLQO5+GjvxaAFB31pa1VzWsFft8NneQco80P78N8IJGZbc8X6eaALfQ==
X-Received: by 2002:adf:f5c9:: with SMTP id k9mr15481547wrp.180.1623634613933;
        Sun, 13 Jun 2021 18:36:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/13] io_uring: don't vmalloc rsrc tags
Date:   Mon, 14 Jun 2021 02:36:21 +0100
Message-Id: <241a3422747113a8909e7e1030eb585d4a349e0d.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't really need vmalloc for keeping tags, it's not a hot path and
is there out of convenience, so replace it with two level tables to not
litter kernel virtual memory mappings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d6c1322119d6..692c91d03054 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -100,6 +100,10 @@
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
+#define IO_RSRC_TAG_TABLE_SHIFT	9
+#define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
+#define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
+
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
@@ -243,7 +247,8 @@ typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 struct io_rsrc_data {
 	struct io_ring_ctx		*ctx;
 
-	u64				*tags;
+	u64				**tags;
+	unsigned int			nr;
 	rsrc_put_fn			*do_put;
 	atomic_t			refs;
 	struct completion		done;
@@ -7172,9 +7177,20 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 	return ret;
 }
 
+static u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
+{
+	unsigned int off = idx & IO_RSRC_TAG_TABLE_MASK;
+	unsigned int table_idx = idx >> IO_RSRC_TAG_TABLE_SHIFT;
+
+	return &data->tags[table_idx][off];
+}
+
 static void io_rsrc_data_free(struct io_rsrc_data *data)
 {
-	kvfree(data->tags);
+	size_t size = data->nr * sizeof(data->tags[0][0]);
+
+	if (data->tags)
+		io_free_page_table((void **)data->tags, size);
 	kfree(data);
 }
 
@@ -7183,33 +7199,37 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 			      struct io_rsrc_data **pdata)
 {
 	struct io_rsrc_data *data;
+	int ret = -ENOMEM;
 	unsigned i;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-
-	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL);
+	data->tags = (u64 **)io_alloc_page_table(nr * sizeof(data->tags[0][0]));
 	if (!data->tags) {
 		kfree(data);
 		return -ENOMEM;
 	}
+
+	data->nr = nr;
+	data->ctx = ctx;
+	data->do_put = do_put;
 	if (utags) {
+		ret = -EFAULT;
 		for (i = 0; i < nr; i++) {
-			if (copy_from_user(&data->tags[i], &utags[i],
-					   sizeof(data->tags[i]))) {
-				io_rsrc_data_free(data);
-				return -EFAULT;
-			}
+			if (copy_from_user(io_get_tag_slot(data, i), &utags[i],
+					   sizeof(data->tags[i])))
+				goto fail;
 		}
 	}
 
 	atomic_set(&data->refs, 1);
-	data->ctx = ctx;
-	data->do_put = do_put;
 	init_completion(&data->done);
 	*pdata = data;
 	return 0;
+fail:
+	io_rsrc_data_free(data);
+	return ret;
 }
 
 static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
@@ -7678,7 +7698,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		/* allow sparse sets */
 		if (fd == -1) {
 			ret = -EINVAL;
-			if (unlikely(ctx->file_data->tags[i]))
+			if (unlikely(*io_get_tag_slot(ctx->file_data, i)))
 				goto out_fput;
 			continue;
 		}
@@ -7776,7 +7796,7 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->tag = data->tags[idx];
+	prsrc->tag = *io_get_tag_slot(data, idx);
 	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
@@ -7846,7 +7866,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			data->tags[up->offset + done] = tag;
+			*io_get_tag_slot(data, up->offset + done) = tag;
 			io_fixed_file_set(file_slot, file);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
@@ -8432,7 +8452,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
-		if (!iov.iov_base && data->tags[i]) {
+		if (!iov.iov_base && *io_get_tag_slot(data, i)) {
 			ret = -EINVAL;
 			break;
 		}
@@ -8505,7 +8525,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		}
 
 		ctx->user_bufs[i] = imu;
-		ctx->buf_data->tags[offset] = tag;
+		*io_get_tag_slot(ctx->buf_data, offset) = tag;
 	}
 
 	if (needs_switch)
-- 
2.31.1

