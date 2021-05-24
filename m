Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E5738F681
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhEXXxG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhEXXxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2492C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n4so4264791wrw.3
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lZ/2WRpstdEOOdg5dyHIK4OlG8wFtj/TAXu3Jnpyb8g=;
        b=X34GCUNhdg8lPt/oTX3DdsH04KU9U/4UxkV0vKPQI7HNwa0loOhoRT++RzfxEDAWN4
         Nw7xhn/0dwJqRXojUsSMycIty+aR0iO1HIcnmF4CizZCJ3crMcTfsUv6t4HvOgeRKtws
         M3Uhtlb5HcHfWbjhraeWJfruq0kyXdnZDikuzL7ihnHc0AshhbTIKuFo3WzhtshDmrOE
         QphXjJpeKhxLrwJUBvJRY0skX855mYstQ5PYIKUDxKRoY/mZ9i+l/LSvmIW6TOPoU55n
         DTISb8LW4Vw66cynHS/TKVEJgsntaOb+Nuq9KdFXVTaSjvtdPUUXFfFZgCwaOw/O8IG5
         wEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZ/2WRpstdEOOdg5dyHIK4OlG8wFtj/TAXu3Jnpyb8g=;
        b=LK0NB9JhdxbnjrCSXfp3K/ylh7NYlIHryO07QlTA0iQS4h2ne6uvvRELK7uwQk3wLy
         bw9NicwGgi88K4Aexg94hN4uJw9T+5ZvmmeMHkGKLUcXv1xO4/ExXJAyRunGLIU8of9z
         8UKfJsdbiPVzSB8JNLmupT3fIa2H+U7UQg8uNYXbSUHmduJv2LpRVC4b7wGqxKyT8FNs
         Gj1gcxhWt/EvYwjLV91VnyO/OBmGm2ULDVQWeNhPh6nAQORKHh1QSKQVJWpaJjpTwQwk
         CpomEZn1X82bCbjTPohQfMJH4mo/5bB5tVrtJa3GAz0hLRvI/qVvFqH+Z0WfR5DwEVZP
         hjcQ==
X-Gm-Message-State: AOAM533J91mnr+FNvLUrFfXr/AqA9FCrKAHASpWVXZDetlcIkDdomyJS
        xsRg/qnQ4hEzuct4XM3wVF8=
X-Google-Smtp-Source: ABdhPJzJRhQ8PIZENbT030RGXSvuPfDrIhx6Iagm+GPGGOEkPxjKEHaPRMfJYr6OYdaKYxLUsB1WgQ==
X-Received: by 2002:adf:cd06:: with SMTP id w6mr24526734wrm.25.1621900295404;
        Mon, 24 May 2021 16:51:35 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/13] io_uring: hide rsrc tag copy into generic helpers
Date:   Tue, 25 May 2021 00:51:07 +0100
Message-Id: <bf1e73697166d91d688cfedda5f77ca24a41f0fc.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
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
index c34df3e01151..24178ca660c4 100644
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
 
@@ -8395,9 +8401,9 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8405,19 +8411,13 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8426,7 +8426,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 					     &last_hpage);
 		if (ret)
 			break;
-		data->tags[i] = tag;
 	}
 
 	WARN_ON_ONCE(ctx->buf_data);
-- 
2.31.1

