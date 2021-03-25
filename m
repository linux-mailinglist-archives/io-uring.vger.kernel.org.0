Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB9E3492C9
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhCYNMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhCYNMT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDAAC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:18 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o16so2292473wrn.0
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Z2zZj/aiIhNJTpuzvLuXnJ1+EL0qjhqf+0Ycj3Mk9Nc=;
        b=Yf0XyjPwG/HqHxI5iglImNJg++XPlzMGQmcPuXcphyhfMN02tAbHhKib57PBWUP04x
         w8os2HDx5Wj8rKT0wimvVA1XdfFZFZydpyTW3QQGqVa7rsEVCIcCiAQ5XpqVmlLnFV9V
         XovTBqX3DxCgRluuagJuBYaW+J662fXbPRG10rQwqBWvk4G9V+O0pdqDrIz8jTt1lzLb
         ym0g85AVKRPGqxynwJCzvA9vTE2pcqyohwRGFgpnII6kZvKCdbjUrFQ4fpA9+wbLutrf
         TTNgQbhAqLgySISnDz3HUqCL4jRkFbIKeWTnCQrI2PkcTU3p8tfN1AoV1X1G/iamOSNl
         27Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z2zZj/aiIhNJTpuzvLuXnJ1+EL0qjhqf+0Ycj3Mk9Nc=;
        b=GLOZOq9819JnqBYxBeG7flfvM8yYWHcyFXzjy4fzyQcFY9C+RAnJWBc4xyG6uxlqHW
         ice2ldYz6uCnFRmS+WRNO2D+nZsVgkOMVeevJN/7dK8ItH8IYE2Qi7P7nhdlcEhzFLyi
         hclM4PBIJb7r2OGILVVGXLuHyBXMJjnWEvEEGBYQzBkI7Tjn+/us1zfEFvzSCsJGq3KB
         Js1gHk99CCYpfbDmfcBZrKvIXOKiVBxfgQ3jbdFssiZdKjRX3pdohISPITMraURLOuk0
         TlCEA2A3gdIuX5YnUwhIBroHgy0feyrU+Qk3OTUGyqNoCSwKJgIWiO2HbLurP1IH2/WM
         jruA==
X-Gm-Message-State: AOAM531UFZYsygR1UQtR87M1lkSNHHq8mTtq9KLiybDQTMfXUMKTB2E2
        TK1V/q6oe8hGo7x4ZMnskaw=
X-Google-Smtp-Source: ABdhPJzOUkoeBAZFtTShdFJN8dKumkKDnIEgyCfoU+OxuGnxwzVUixSp29xMVBYgDmrmwT2O6nqd2w==
X-Received: by 2002:adf:ba94:: with SMTP id p20mr9035453wrg.300.1616677937215;
        Thu, 25 Mar 2021 06:12:17 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 03/17] io_uring: use rsrc prealloc infra for files reg
Date:   Thu, 25 Mar 2021 13:07:52 +0000
Message-Id: <addd76e0b2bd53b3f60c581990ad56b5d94d9120.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep it consistent with update and use io_rsrc_node_prealloc() +
io_rsrc_node_get() in io_sqe_files_register() as well, that will be used
in future patches, not as error prone and allows to deduplicate
rsrc_node init.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 502b0f6c755b..a494850e4539 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7493,13 +7493,6 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	return ref_node;
 }
 
-static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
-				     struct io_rsrc_node *ref_node)
-{
-	ref_node->rsrc_data = ctx->file_data;
-	ref_node->rsrc_put = io_ring_file_put;
-}
-
 static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
@@ -7512,7 +7505,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	__s32 __user *fds = (__s32 __user *) arg;
 	unsigned nr_tables, i;
 	struct file *file;
-	int fd, ret = -ENOMEM;
+	int fd, ret;
 	struct io_rsrc_node *ref_node;
 	struct io_rsrc_data *file_data;
 
@@ -7522,12 +7515,16 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	ret = io_rsrc_node_prealloc(ctx);
+	if (ret)
+		return ret;
 
 	file_data = io_rsrc_data_alloc(ctx);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
 
+	ret = -ENOMEM;
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
 				   GFP_KERNEL);
@@ -7580,13 +7577,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = io_rsrc_node_alloc(ctx);
-	if (!ref_node) {
-		io_sqe_files_unregister(ctx);
-		return -ENOMEM;
-	}
-	init_fixed_file_ref_node(ctx, ref_node);
-
+	ref_node = io_rsrc_node_get(ctx, ctx->file_data, io_ring_file_put);
 	io_rsrc_node_set(ctx, file_data, ref_node);
 	return ret;
 out_fput:
-- 
2.24.0

