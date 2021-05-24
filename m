Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9478E38F686
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhEXXxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhEXXxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:09 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62136C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:39 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o127so15712109wmo.4
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xRzaKX1RUL6tEmowyiLD+2a29fLgUE0iA5aeO/c17VM=;
        b=XLTJmghCHLJONyWMujCc21lSf4rlt6isLoOf/uoBRwjBn4MQC2JKVY1iRWqbpfBCS9
         xF3Xl1aJ/MswaPYEMapLF0al/4d1ZVDJbbfjR5NsmgylOmcBlMbpmT8eH4jaTfgW7iqc
         MpbY8P7mxWe0VBgEOMnXGNaNjUWBdmrmPgusfj9gxPCwCY2EskDTQiYqvinZ817EQMlk
         yaxC/2IFS38b+e5vvtH2XAcZui/EzpVGcbIq0Twt8zaKkK2QPHLnjRsmO1szrT5A9qfM
         sgi2u+mbVs9nz7no9EAj+eqUT/8uYC/IREsInlKY87rHlnqBOO2F1FHTDx4LBIWdZZyH
         ZkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xRzaKX1RUL6tEmowyiLD+2a29fLgUE0iA5aeO/c17VM=;
        b=mcN1tYyasop1L60V31rO/PLrzf7rRSdA7Uj2mRR5X6doO54u9IBieL5srPhHGWwfbw
         vlcaT49WY3rYWEZhJtVp0MSpkYlQMeOsppRcINDSO1Bz37qnlvT66LVyZ4sw50wKzHVP
         NOw9F30WPr05XTPNLt3skNy4U79chXnIOZcjOfmooTmCGkhrU2O3lFfLUfA4J2QSmBMW
         GbG09PQV4dqG5ifYsIWGvcMEJqVe2+n2bdalCyTWH3eyHN01UTbWs9ctWRfgBG9FlcIG
         VSXfhV4ZuA23qeiZE+DrWmXW01ouyyaxhu3hHX1a5LqduDN+DCzY6zxnokbDpS3OvF8S
         cQcA==
X-Gm-Message-State: AOAM5302yOeUBkVmKbHf2SGv6zwZ0votjUDQ+n0cq1L6jXLOiU9//ph7
        V8Km9rMfPmZAPrpkmlXXqO4=
X-Google-Smtp-Source: ABdhPJzowdAgnzkiUDD8n+Y6/Dju5lDlOaJgAaFaOsLUnBFVvcuj+fuGRJ9E5xcTb6yx5TYgON30RQ==
X-Received: by 2002:a1c:6143:: with SMTP id v64mr21507146wmb.22.1621900298013;
        Mon, 24 May 2021 16:51:38 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/13] io_uring: don't vmalloc rsrc tags
Date:   Tue, 25 May 2021 00:51:10 +0100
Message-Id: <ab5b8b328a51f899e11dc01d414b9243e593724a.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
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
index 1cc2d16637ff..2b2d70a58a87 100644
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
@@ -8429,7 +8449,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
-		if (!iov.iov_base && data->tags[i]) {
+		if (!iov.iov_base && *io_get_tag_slot(data, i)) {
 			ret = -EINVAL;
 			break;
 		}
@@ -8502,7 +8522,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		}
 
 		ctx->user_bufs[i] = imu;
-		ctx->buf_data->tags[offset] = tag;
+		*io_get_tag_slot(ctx->buf_data, offset) = tag;
 	}
 
 	if (needs_switch)
-- 
2.31.1

