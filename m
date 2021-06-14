Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE533A5B63
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhFNBkD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:40:03 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:51775 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhFNBkD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:40:03 -0400
Received: by mail-wm1-f51.google.com with SMTP id l9so11140883wms.1
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Gs3KrKnbVra6qi2apJWeKgU8xCIjDeQclcnUQ38ruRs=;
        b=A8nI/u0cuuGTqw1IXIn7qTAp4v+0HE/GQ28ZNS/H/G3r8fWNAhll3ATvj3a5EPTjSF
         9p2gzexHkxfitvv/L6RyHYAUfBU88mAgaTdDyi+oSBSasTNlkdIMhPbaetRsP+NTQPMx
         TdgSpyBg2myF3eWGGudtdFxpVfTbaw9l/g+jlQnDxXhIO3eBDd+jGd0LdlPWlZdebWuE
         n39cxmjPh6/tpqqlpadv3CbroPXIO6vijdFDSCV9EenjL2clCAGElBMKEo0qTnqCE896
         N2cpCupQeesRIFDKdXa/vXE+OLp3wPwNU+SOJ4wU3XmsJWj3nzCJ9fkWZL1nXxxvy3Hf
         Y4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gs3KrKnbVra6qi2apJWeKgU8xCIjDeQclcnUQ38ruRs=;
        b=DNaHxo0YGsJYhZi90AX+Cq55UgYaWeOGAt70N1GMkqfIFsxEO9Uv3tiq+lncDX0wXd
         p9GmYgI0SZWeyuHdQGsu3mz7glYzJ5XWz3NzgjMB4yWAG7DQZKEGHUBIU9UK7a1bbxUz
         me5Bo22oOB+g1kD0R/BUk5IxiwrWGYJJA2uq4AiridrzT8fhvm6t+B9oahEZ6kW6sX04
         JUfoLvnAB1lOKLsZa17PT8okemmmIgXDyxmC67Jc+r2qAiLTOEohJ++h96VCgJYzQY5f
         WXo3VMG6zQG+Dz/efsSC7JVF3vqpqoANg97+fjnYcztZdo4Y7cFh6Elz1uz0IbNUxkae
         u0tw==
X-Gm-Message-State: AOAM530NHze0+8Su5n3MQynq0kEcpFXCUjaaj7MyNtSyPGiS3n+bFi50
        RvEIBCkRmQK77nNbhTX2Uj4=
X-Google-Smtp-Source: ABdhPJyMUPWM4Pheywe+W9N44dq8jEwnpNfnbTfQM8gev3FJoZ0foUZsUh8tMTQoAkuEI29gSY/g3g==
X-Received: by 2002:a1c:bb45:: with SMTP id l66mr30353163wmf.29.1623634610891;
        Sun, 13 Jun 2021 18:36:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/13] io_uring: hide rsrc tag copy into generic helpers
Date:   Mon, 14 Jun 2021 02:36:18 +0100
Message-Id: <5609680697bd09735de10561b75edb95283459da.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_rsrc_data_alloc() taking care of rsrc tags loading on
registration, so we don't need to repeat it for each new rsrc type.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 55 +++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cea3d0f5dad5..18ed6ecb1d76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7156,27 +7156,38 @@ static void io_rsrc_data_free(struct io_rsrc_data *data)
 	kfree(data);
 }
 
-static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
-					       rsrc_put_fn *do_put,
-					       unsigned nr)
+static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
+			      u64 __user *utags, unsigned nr,
+			      struct io_rsrc_data **pdata)
 {
 	struct io_rsrc_data *data;
+	unsigned i;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		return NULL;
+		return -ENOMEM;
 
 	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL);
 	if (!data->tags) {
 		kfree(data);
-		return NULL;
+		return -ENOMEM;
+	}
+	if (utags) {
+		for (i = 0; i < nr; i++) {
+			if (copy_from_user(&data->tags[i], &utags[i],
+					   sizeof(data->tags[i]))) {
+				io_rsrc_data_free(data);
+				return -EFAULT;
+			}
+		}
 	}
 
 	atomic_set(&data->refs, 1);
 	data->ctx = ctx;
 	data->do_put = do_put;
 	init_completion(&data->done);
-	return data;
+	*pdata = data;
+	return 0;
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
@@ -7628,7 +7639,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	struct file *file;
 	int fd, ret;
 	unsigned i;
-	struct io_rsrc_data *file_data;
 
 	if (ctx->file_data)
 		return -EBUSY;
@@ -7639,27 +7649,24 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
+	ret = io_rsrc_data_alloc(ctx, io_rsrc_file_put, tags, nr_args,
+				 &ctx->file_data);
+	if (ret)
+		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx, io_rsrc_file_put, nr_args);
-	if (!file_data)
-		return -ENOMEM;
-	ctx->file_data = file_data;
 	ret = -ENOMEM;
 	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		u64 tag = 0;
-
-		if ((tags && copy_from_user(&tag, &tags[i], sizeof(tag))) ||
-		    copy_from_user(&fd, &fds[i], sizeof(fd))) {
+		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
 			goto out_fput;
 		}
 		/* allow sparse sets */
 		if (fd == -1) {
 			ret = -EINVAL;
-			if (unlikely(tag))
+			if (unlikely(ctx->file_data->tags[i]))
 				goto out_fput;
 			continue;
 		}
@@ -7680,7 +7687,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		ctx->file_data->tags[i] = tag;
 		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
 	}
 
@@ -8398,9 +8404,9 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
-	data = io_rsrc_data_alloc(ctx, io_rsrc_buf_put, nr_args);
-	if (!data)
-		return -ENOMEM;
+	ret = io_rsrc_data_alloc(ctx, io_rsrc_buf_put, tags, nr_args, &data);
+	if (ret)
+		return ret;
 	ret = io_buffers_map_alloc(ctx, nr_args);
 	if (ret) {
 		io_rsrc_data_free(data);
@@ -8408,19 +8414,13 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
-		u64 tag = 0;
-
-		if (tags && copy_from_user(&tag, &tags[i], sizeof(tag))) {
-			ret = -EFAULT;
-			break;
-		}
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
 			break;
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
-		if (!iov.iov_base && tag) {
+		if (!iov.iov_base && data->tags[i]) {
 			ret = -EINVAL;
 			break;
 		}
@@ -8429,7 +8429,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 					     &last_hpage);
 		if (ret)
 			break;
-		data->tags[i] = tag;
 	}
 
 	WARN_ON_ONCE(ctx->buf_data);
-- 
2.31.1

