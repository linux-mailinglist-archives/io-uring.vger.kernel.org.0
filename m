Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEBE2DFFFE
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 19:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgLUSiR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 13:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgLUSiQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 13:38:16 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DABC061282
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 10:37:36 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m5so12066509wrx.9
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 10:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DgbyCwXen5Vms0GQmas8xZ8S7D11nxvTghM8zcqX4jw=;
        b=sMcr9FyhRYexCNuhEemDXhdV/5OsXjpjpLwFM1Ei3kiw5K4RBnx752nRG1ckRO8zIU
         /3cTNIQyoyAcD28uCSgvyxBWU1Wq7cmiydh0AXLj6fv2kwC7c6RpJta6dETkiRs2Nckc
         hZALQ7WNCkv7jFZOPKY0fKEeqlMUyuizGcU3vN1eV2GnP/yYFkgqYjEz0xqRJdRq5o0T
         k6mpqNuMTfLqKBDXC3/jibLY9Xvrj9a9W4Posb9bcDUyjd7QVgFeEmBVdHxJpCgQ4Nmx
         pMhSgLcL/QZnwUydkGrprewvox4phCBFI8wuWuxXPKoIN5u7ZdamUhWaRUM8iZWfCE2P
         qZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DgbyCwXen5Vms0GQmas8xZ8S7D11nxvTghM8zcqX4jw=;
        b=TQ8QSv8+isiJAOeJnlam04ZyBG9MFu9G5yTGF/ljiyBXPtZq+91/VI2lD7uITdjSxp
         KdxL7tVlrmBydezdkTeqOxr2cYpNWJd2doBTuvdznlnLGR8dAquFvA+4syq8HpfZMPKd
         XA3yYMbUhSA2DfMtkNeBpSHpuOkMJH38/PkqqgPKo5kGWENzPlUgFCiWYrdEtyvBhvJt
         8xzKniNuaqq06JVrnb8od2p30G0niz181ZsQhrWE8k6aZ9wYVtFSzTebQGKJ/dYXU2kd
         oNOZ9gfeUevfVFJcybhJmXZcKq4KQijYLJ6TUpiPRSQ1Y12fpXNGlyZodZAOZtSb3f/2
         RCaA==
X-Gm-Message-State: AOAM532RZwnP3D9JbKQWB/05BPqp9q1pk9EHKbA7knOWnWeGcR+/I94P
        kng8wZ/Re1EfRHHqeib1FLk=
X-Google-Smtp-Source: ABdhPJweYpGzEcoUES8i2FRoSF2/fcK+1Rickx1/HaC8hMthVHbTzT7jbVteR6WtJEvpcf7NemzEgQ==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr19405605wrt.223.1608575854843;
        Mon, 21 Dec 2020 10:37:34 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.158])
        by smtp.gmail.com with ESMTPSA id w21sm23551409wmi.45.2020.12.21.10.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 10:37:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring: fix double io_uring free
Date:   Mon, 21 Dec 2020 18:34:05 +0000
Message-Id: <647f77d0144186aadb77e77f1aa3272bad63db97.1608575562.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608575562.git.asml.silence@gmail.com>
References: <cover.1608575562.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Once we created a file for current context during setup, we should not
call io_ring_ctx_wait_and_kill() directly as it'll be done by fput(file)

Reported-by: syzbot+c9937dfb2303a5f18640@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 69 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 846c635d0620..19ec1898b934 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9379,55 +9379,52 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
+{
+	int ret, fd;
+
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	ret = io_uring_add_task_file(ctx, file);
+	if (ret) {
+		put_unused_fd(fd);
+		return ret;
+	}
+	fd_install(fd, file);
+	return fd;
+}
+
 /*
  * Allocate an anonymous fd, this is what constitutes the application
  * visible backing of an io_uring instance. The application mmaps this
  * fd to gain access to the SQ/CQ ring details. If UNIX sockets are enabled,
  * we have to tie this fd to a socket for file garbage collection purposes.
  */
-static int io_uring_get_fd(struct io_ring_ctx *ctx)
+static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 {
 	struct file *file;
 	int ret;
-	int fd;
 
 #if defined(CONFIG_UNIX)
 	ret = sock_create_kern(&init_net, PF_UNIX, SOCK_RAW, IPPROTO_IP,
 				&ctx->ring_sock);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 #endif
 
-	ret = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
-	if (ret < 0)
-		goto err;
-	fd = ret;
-
 	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
 					O_RDWR | O_CLOEXEC);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		ret = PTR_ERR(file);
-		goto err;
-	}
-
 #if defined(CONFIG_UNIX)
-	ctx->ring_sock->file = file;
-#endif
-	ret = io_uring_add_task_file(ctx, file);
-	if (ret) {
-		fput(file);
-		put_unused_fd(fd);
-		goto err;
+	if (IS_ERR(file)) {
+		sock_release(ctx->ring_sock);
+		ctx->ring_sock = NULL;
+	} else {
+		ctx->ring_sock->file = file;
 	}
-	fd_install(fd, file);
-	return fd;
-err:
-#if defined(CONFIG_UNIX)
-	sock_release(ctx->ring_sock);
-	ctx->ring_sock = NULL;
 #endif
-	return ret;
+	return file;
 }
 
 static int io_uring_create(unsigned entries, struct io_uring_params *p,
@@ -9435,6 +9432,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 {
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
+	struct file *file;
 	bool limit_mem;
 	int ret;
 
@@ -9582,13 +9580,22 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
+	file = io_uring_get_file(ctx);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto err;
+	}
+
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
 	 */
-	ret = io_uring_get_fd(ctx);
-	if (ret < 0)
-		goto err;
+	ret = io_uring_install_fd(ctx, file);
+	if (ret < 0) {
+		/* fput will clean it up */
+		fput(file);
+		return ret;
+	}
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
-- 
2.24.0

