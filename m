Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40A628A3EC
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389441AbgJJWzm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731269AbgJJTFU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6129C08EBB4
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h7so13739407wre.4
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Rc6NRiK/DSb9atUjmXunq0MGhvdovdcGEJ2qcjHNWHU=;
        b=jgS/vyhJhfqJCQBhL9QHjKnEQo50U9wfvEyQVFZIezNITDpL16YSfAD6erGys7TA7M
         25rXnBTLjrx1H7mbqpHv+EUfIXJLV4ttVMAuV1Gf39k9vY+zWDT33E505lxInGMxVvH7
         hMiBaWLEVSJuPsxcDSDcM36Gs2ENXlklgilxuRvqRAobziUhX9L1Oopi9vlViLA4rTu8
         u/uP1SnTs6Vjy7nIjBgYR8A+vG9hAAzgjq+v0mX282xYhTAzgVuBxNIOLzqtQk8Pagp8
         zu9LyXz6v133+lLk6zu4kTkwlBHrg1sa/LJOh2cHiGHBUvxbJxMqbm+tmwqGedp0Fy9e
         okNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rc6NRiK/DSb9atUjmXunq0MGhvdovdcGEJ2qcjHNWHU=;
        b=H2d0zKEMVORh1AWz/EacpJ+1EuNxkMmHrXTnO9ZLutOS5Z6c6xLtQyEDcLR2R1yVKw
         8yr7Ux5KZHKPG4qESTj2U52xHVHFNTvsi01RdvL9gjm4GvtInCDtIqdBuiStOOD9GQYT
         YkgCMIbGvNPIvCQHgc1JDylmaz7RlI7AFc2CICplSwBITX4ijw7Bww2ysg8aaClPvseI
         T+RsOxlDFx7+DI7neT8TlNdaflfPdLLjpW3CPcZkvUp2A05USRK9QENg1w6Ot41lcWPY
         +TSdzszdA96HWilxruOcQaNNSJnPXfuGcMOZkaF/oTHqaaikvq4Ii+g959c9zQJ56Y/W
         Jbiw==
X-Gm-Message-State: AOAM5305m04AK0S7RAPsB0jjj3kvH5PVkLznR3poi8ooPHBqALt4b1V2
        EBhUcfe8qiZ6GS+4ZPzSpF0=
X-Google-Smtp-Source: ABdhPJzNtCxVKVRrbjvbZhl7ub8Gwy/6gXhLPNmjG7wOR5gOHhfrzuWxrMnvPlnteB9fjVoC4Mt7hg==
X-Received: by 2002:adf:e8cf:: with SMTP id k15mr20801874wrn.262.1602351442367;
        Sat, 10 Oct 2020 10:37:22 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/12] io_uring: refactor *files_register()'s error paths
Date:   Sat, 10 Oct 2020 18:34:15 +0100
Message-Id: <d3bd3012b7686ae7e6135652d97dceb09e4ef9ee.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't keep repeating cleaning sequences in error paths, write it once
in the and use labels. It's less error prone and looks cleaner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 78 +++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 46 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c3ca82f20f3d..fc4ef725ae09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7282,10 +7282,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
-	unsigned nr_tables;
+	unsigned nr_tables, i;
 	struct file *file;
-	int fd, ret = 0;
-	unsigned i;
+	int fd, ret = -ENOMEM;
 	struct fixed_file_ref_node *ref_node;
 	struct fixed_file_data *file_data;
 
@@ -7307,45 +7306,32 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(file_data->table),
 				   GFP_KERNEL);
-	if (!file_data->table) {
-		kfree(file_data);
-		return -ENOMEM;
-	}
+	if (!file_data->table)
+		goto out_free;
 
 	if (percpu_ref_init(&file_data->refs, io_file_ref_kill,
-				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		kfree(file_data->table);
-		kfree(file_data);
-		return -ENOMEM;
-	}
+				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+		goto out_free;
 
-	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args)) {
-		percpu_ref_exit(&file_data->refs);
-		kfree(file_data->table);
-		kfree(file_data);
-		return -ENOMEM;
-	}
+	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
+		goto out_ref;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
 		struct fixed_file_table *table;
 		unsigned index;
 
-		ret = -EFAULT;
-		if (copy_from_user(&fd, &fds[i], sizeof(fd)))
-			break;
+		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
+			ret = -EFAULT;
+			goto out_fput;
+		}
 		/* allow sparse sets */
-		if (fd == -1) {
-			ret = 0;
+		if (fd == -1)
 			continue;
-		}
 
-		table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-		index = i & IORING_FILE_TABLE_MASK;
 		file = fget(fd);
-
 		ret = -EBADF;
 		if (!file)
-			break;
+			goto out_fput;
 
 		/*
 		 * Don't allow io_uring instances to be registered. If UNIX
@@ -7356,28 +7342,13 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		 */
 		if (file->f_op == &io_uring_fops) {
 			fput(file);
-			break;
+			goto out_fput;
 		}
-		ret = 0;
+		table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+		index = i & IORING_FILE_TABLE_MASK;
 		table->files[index] = file;
 	}
 
-	if (ret) {
-		for (i = 0; i < ctx->nr_user_files; i++) {
-			file = io_file_from_index(ctx, i);
-			if (file)
-				fput(file);
-		}
-		for (i = 0; i < nr_tables; i++)
-			kfree(file_data->table[i].files);
-
-		percpu_ref_exit(&file_data->refs);
-		kfree(file_data->table);
-		kfree(file_data);
-		ctx->nr_user_files = 0;
-		return ret;
-	}
-
 	ctx->file_data = file_data;
 	ret = io_sqe_files_scm(ctx);
 	if (ret) {
@@ -7397,6 +7368,21 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	spin_unlock(&file_data->lock);
 	percpu_ref_get(&file_data->refs);
 	return ret;
+out_fput:
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		file = io_file_from_index(ctx, i);
+		if (file)
+			fput(file);
+	}
+	for (i = 0; i < nr_tables; i++)
+		kfree(file_data->table[i].files);
+	ctx->nr_user_files = 0;
+out_ref:
+	percpu_ref_exit(&file_data->refs);
+out_free:
+	kfree(file_data->table);
+	kfree(file_data);
+	return ret;
 }
 
 static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
-- 
2.24.0

