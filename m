Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF32F82B9
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbhAORm6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbhAORm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:57 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E37C06179A
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:44 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id m187so1871072wme.2
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=u4byiZVedOdCxgejLGFmUKcKgEBiHcubVkaZDLCbVok=;
        b=atYv4+k3INrog/LIE0ideJn4pLfO8zBI6QnY3a5+Vr3CV+eAuoBACMleXHydjuhAvy
         jq5EOEM+QIdsIRFaoY6iJaED5mgQdoQz+67MjLDXdEqCO2lYZQfn/myaOH3eyvpdxvRt
         QcXek+GRIIQRAbpb5+yZ1lqtgdGwAIcgVWPT2eMDvV45LttV/YFQftyomq77igJqnj34
         FnvmZU6IgLxAAks7XpnQHtt1eVFR5DO6Yj8l9clVg2d2tRwTdIV7DQjWNFiKG8NGF9Dk
         xVgm/RbGB7Hysw+w+7MzKSVp4R/c8/je1A2wobJf24BcuNm8ubOIzpyqPJhYLPDTbGFp
         Zjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u4byiZVedOdCxgejLGFmUKcKgEBiHcubVkaZDLCbVok=;
        b=AAfm+BZ2bpGPHpKXl1jen8W2bWyJiEarK1+abj7/VknzCGheosJHipe1UbA8btqu4N
         gxw7D11HJzyHci6w8m3Ewz0s8N2geCQ/0jUeXtNNcyBeh8Q7iyf+Ph0hXt5mb8fcFRpr
         wZs8g+DA/y2rLVrZxHw5ywmZN1t63ppNICn5QsIO0gHtXxuE/jDQkJavFVLgtdFU1LB4
         1ay2qR4z4DEojX9eAc/tDvvKBEbCW0kg1ba6owTDWMmLqAWOdIrWuvfSUN0IdZTvvQo2
         0Z7i70NSQ5nbi9KYN+kPebBrPEB7TJKTyO6BJ5r2rEqU2uaIGuNtG2S29o8p/MxWLwJ/
         sKkg==
X-Gm-Message-State: AOAM532ZqfACvwq2wJZCW9rNijFB+jjBtsWPPxuGce2bEM/jwaLSms3f
        +n7MaJRZsd+xjlgjKMAG3NQ=
X-Google-Smtp-Source: ABdhPJzHwVFBbYkOCERlVEf0Lxo/+mtPuX7V2AU0VM1Dig4tfGg3l0QzW9PV3RCo0pyQ0kk/zcs/JQ==
X-Received: by 2002:a05:600c:4e87:: with SMTP id f7mr9781263wmq.163.1610732502956;
        Fri, 15 Jan 2021 09:41:42 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 8/9] io_uring: create common fixed_rsrc_data allocation routines
Date:   Fri, 15 Jan 2021 17:37:51 +0000
Message-Id: <424704187f56bac1cc2c844be3111815ab9a97e9.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Create common alloc/free fixed_rsrc_data routines for both files and
buffers.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
[remove buffer part]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44b5472cd425..5b83f689051b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7331,6 +7331,31 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	return 0;
 }
 
+static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	if (percpu_ref_init(&data->refs, io_rsrc_ref_kill,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		kfree(data);
+		return NULL;
+	}
+	data->ctx = ctx;
+	init_completion(&data->done);
+	return data;
+}
+
+static void free_fixed_rsrc_data(struct fixed_rsrc_data *data)
+{
+	percpu_ref_exit(&data->refs);
+	kfree(data->table);
+	kfree(data);
+}
+
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
@@ -7353,9 +7378,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
 		kfree(data->table[i].files);
-	kfree(data->table);
-	percpu_ref_exit(&data->refs);
-	kfree(data);
+	free_fixed_rsrc_data(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;
@@ -7790,11 +7813,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
 
-	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
+	file_data = alloc_fixed_rsrc_data(ctx);
 	if (!file_data)
 		return -ENOMEM;
-	file_data->ctx = ctx;
-	init_completion(&file_data->done);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7802,12 +7823,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (!file_data->table)
 		goto out_free;
 
-	if (percpu_ref_init(&file_data->refs, io_rsrc_ref_kill,
-				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
-		goto out_free;
-
 	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
-		goto out_ref;
+		goto out_free;
 	ctx->file_data = file_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
@@ -7867,11 +7884,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	for (i = 0; i < nr_tables; i++)
 		kfree(file_data->table[i].files);
 	ctx->nr_user_files = 0;
-out_ref:
-	percpu_ref_exit(&file_data->refs);
 out_free:
-	kfree(file_data->table);
-	kfree(file_data);
+	free_fixed_rsrc_data(ctx->file_data);
 	ctx->file_data = NULL;
 	return ret;
 }
-- 
2.24.0

