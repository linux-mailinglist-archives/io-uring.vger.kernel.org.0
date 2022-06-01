Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C00453A939
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 16:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354757AbiFAO3d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355037AbiFAO3T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 10:29:19 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6149A10D1
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 07:29:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k16so2616802wrg.7
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 07:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zYZxJSsiDIqWtlLkaHGpFEMWr8SnCqLLTeuEdEKFBw0=;
        b=kH2c+fwUAFopecg7ijWVuMh4VjCBzqqrOEP8XCrob3azsdGv71QMDvUc7v80Nbcef8
         jsFwHD/akcJHLRfiDWq0NuEAoAhJWRr1bJGmjF5FY0YkWoq63JwDB84L9yCyeBqMxBuo
         l4wLZx5GwuI6SvqVOucYWXUwbx+U4ZpfbG/4ZW4xGnnQqrpP3n7+/W/kHkm477oMZeLA
         jepxhly4H9Ssn5qY7PksWvI3tiOFuVr2bBP/U1NsCmkYPL0I8abgVm2E0Hkh9arxH4LF
         c6gfXyfqeiL/rwfYysZCqQhpVYjROOPzubo9a6QRHVQ09v3NRTZyANtmqRjoszLP4cZZ
         68vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zYZxJSsiDIqWtlLkaHGpFEMWr8SnCqLLTeuEdEKFBw0=;
        b=tfNlNlfB6jFiQgbmkCwjaeCvvkCXVhXuHtjLGR1WOBt9yb0zOCWDsf/myKgZ3QTXGR
         j9ztbPrh8HqgzaQGscUeEYc/YnYQ6Pr+Fna0DAesGcycXkGv+W5z7IfCSdUUxzoXZq62
         UluNvFUFWStKObqbPYEpXL55NxkzxS1QgKETBcFOwI3KtgE2HfiqsE88cTmGhN/HSruQ
         T2OOGjIg1IdQMB/XY11p2iRzYi9X40ci7vTHjf7vUt8SFutYzzg0lVG4gF5M4NNf7hDu
         4RLSXDOFjA4jZ1GEfYNt1zCTRODgARH3fAfzDj3dxLq7ekZ8BrrdLxIgqJq1nGvTASTB
         MCig==
X-Gm-Message-State: AOAM532AXu5vh+HdBfGMY6z7tSaa9e4PURZNnoupkf8yW5oL3BGz430E
        ZIthY1T8ip2+JAkxvJB5o5gyJJ64WWw/rQ==
X-Google-Smtp-Source: ABdhPJwYIybMnqm355Cai/l3Q+1jOcOJb0LByXj3RmCMejZHkJ3ZFrObamI30Mrk3T1DK6l2cSA6/g==
X-Received: by 2002:a5d:5954:0:b0:20c:4d55:1388 with SMTP id e20-20020a5d5954000000b0020c4d551388mr103816wri.90.1654093752737;
        Wed, 01 Jun 2022 07:29:12 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-236-74.dab.02.net. [82.132.236.74])
        by smtp.gmail.com with ESMTPSA id v5-20020a5d4b05000000b0020d0c37b350sm2198094wrq.27.2022.06.01.07.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 07:29:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC net-next v3 1/1] io_uring: fix deadlock on iowq file slot alloc
Date:   Wed,  1 Jun 2022 15:28:44 +0100
Message-Id: <64116172a9d0b85b85300346bb280f3657aafc26.1654087283.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_fixed_fd_install() can grab uring_lock in the slot allocation path
when called from io-wq, and then call into io_install_fixed_file(),
which will lock it again. Pull all locking out of
io_install_fixed_file() into io_fixed_fd_install().

Fixes: 1339f24b336db ("io_uring: allow allocated fixed files for openat/openat2")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 78990a130b66..051586a5371b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5791,26 +5791,22 @@ static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
+	io_ring_submit_lock(ctx, issue_flags);
+
 	if (alloc_slot) {
-		io_ring_submit_lock(ctx, issue_flags);
 		ret = io_file_bitmap_get(ctx);
-		if (unlikely(ret < 0)) {
-			io_ring_submit_unlock(ctx, issue_flags);
-			return ret;
-		}
-
+		if (unlikely(ret < 0))
+			goto err;
 		file_slot = ret;
 	} else {
 		file_slot--;
 	}
 
 	ret = io_install_fixed_file(req, file, issue_flags, file_slot);
-	if (alloc_slot) {
-		io_ring_submit_unlock(ctx, issue_flags);
-		if (!ret)
-			return file_slot;
-	}
-
+	if (!ret && alloc_slot)
+		ret = file_slot;
+err:
+	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
 
@@ -10663,21 +10659,19 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
-	int ret = -EBADF;
+	int ret;
 
-	io_ring_submit_lock(ctx, issue_flags);
 	if (file->f_op == &io_uring_fops)
-		goto err;
-	ret = -ENXIO;
+		return -EBADF;
 	if (!ctx->file_data)
-		goto err;
-	ret = -EINVAL;
+		return -ENXIO;
 	if (slot_index >= ctx->nr_user_files)
-		goto err;
+		return -EINVAL;
 
 	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
 	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
@@ -10708,7 +10702,6 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 err:
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);
-	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret)
 		fput(file);
 	return ret;
-- 
2.36.1

