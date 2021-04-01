Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810B2351BE5
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhDASLq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbhDASHh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:07:37 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6481C00458F
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:40 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so1051421wmj.1
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2LjyfYXzXA1la/QDFN+3KlX8lUV8vmHzNnU55kjgdmU=;
        b=pHADcGhikEhOG8SE5H/H+fnQQ0Z3bZ2SPyaYeS7It+k8O+pBO3XdIuNVNH0wTSHfkw
         gs8UQ1xesQ4ZBdD4WO+wWELwT1JajAAdjrz+k3qXR3/38Zov9GmR2ScgvYK8YB9aDhXG
         Lf4KELz7Jvtnubgs15YDOLsoPyaxOqmkYGjNOpyTU8DKB9iH7PjypPC9dtNRq/GyKAFj
         iAQ2oZuoxU8iZuf6yuaU3ae+BjilZGgXEwD4Kb2oCP4yUysHrN4kD+LQ46i78t6Nh3oX
         CT/KdohCnXgBA7qhfjpbc+BMxE3l2h6l6GNiLWbOkpZBRnE/DzntC9EDMNj/wTTINJt/
         mFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2LjyfYXzXA1la/QDFN+3KlX8lUV8vmHzNnU55kjgdmU=;
        b=ob7OeyHm0dhneA9FloITzHgAuG9E9hZ4zrxQONdyeQg6ZhMtOITKqXlMIMCX5CEH2F
         RevPAKp6J9cG906+fEW07qr7qAP/3I2ewLNvuYwNjKncOzCCNcVCFE/3tetJ9jCigVM5
         flCKXpufNifXwYbiLDL4QNrlaRnnRbZraq3sGILrBNbYSozIDzr9Yva4z1PncLC9D8hG
         qy4DpcteXUqBcapZUA5CCpbcrcqblq9NQ/t2IirqCyx+BMJkuBDNxOSHMqXwKFjXX05m
         68B6yMrrRd6/TrbkTAYg4UOLBuHjrhzLxYMrmshwv5dtsqxv8JKMDKbOIDOd/cv6v+EQ
         ADGA==
X-Gm-Message-State: AOAM532FSOH/7mU4SBmQ2pOf6GXcxZX9JnbGX5Du/cYt7XRqRp88H000
        h49Xz4vuPKAD9wOIcSSPSnF0ZrAEwcsKqw==
X-Google-Smtp-Source: ABdhPJwDjgJJSnjYnUt5yJ4TUoh1gl7tpmsrxX/qRxMvIZZIhvKgkcMmHg8a1yHGD0bk7NpNtdg2tw==
X-Received: by 2002:a1c:f701:: with SMTP id v1mr8446693wmh.69.1617288519509;
        Thu, 01 Apr 2021 07:48:39 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 22/26] io_uring: set proper FFS* flags on reg file update
Date:   Thu,  1 Apr 2021 15:44:01 +0100
Message-Id: <df29a841a2d3d3695b509cdffce5070777d9d942.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Set FFS_* flags (e.g. FFS_ASYNC_READ) not only in initial registration
but also on registered files update. Not a bug, but may miss getting
profit out of the feature.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 421e9d7d02fd..c5dd00babf59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6272,6 +6272,19 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	return (struct file *) ((unsigned long) *file_slot & FFS_MASK);
 }
 
+static void io_fixed_file_set(struct file **file_slot, struct file *file)
+{
+	unsigned long file_ptr = (unsigned long) file;
+
+	if (__io_file_supports_async(file, READ))
+		file_ptr |= FFS_ASYNC_READ;
+	if (__io_file_supports_async(file, WRITE))
+		file_ptr |= FFS_ASYNC_WRITE;
+	if (S_ISREG(file_inode(file)->i_mode))
+		file_ptr |= FFS_ISREG;
+	*file_slot = (struct file *)file_ptr;
+}
+
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed)
 {
@@ -7608,8 +7621,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		unsigned long file_ptr;
-
 		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
 			goto out_fput;
@@ -7634,14 +7645,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		file_ptr = (unsigned long) file;
-		if (__io_file_supports_async(file, READ))
-			file_ptr |= FFS_ASYNC_READ;
-		if (__io_file_supports_async(file, WRITE))
-			file_ptr |= FFS_ASYNC_WRITE;
-		if (S_ISREG(file_inode(file)->i_mode))
-			file_ptr |= FFS_ISREG;
-		*io_fixed_file_slot(file_data, i) = (struct file *) file_ptr;
+		io_fixed_file_set(io_fixed_file_slot(file_data, i), file);
 	}
 
 	ret = io_sqe_files_scm(ctx);
@@ -7783,7 +7787,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			*file_slot = file;
+			io_fixed_file_set(file_slot, file);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
 				*file_slot = NULL;
-- 
2.24.0

