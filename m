Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D6540AF0A
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 15:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhINNjG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 09:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbhINNjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 09:39:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D31C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 06:37:48 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i21so29010905ejd.2
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 06:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VVEFxp68V58IgxOUgyjBHqJhbtaMtslfm2VXdwuEHTo=;
        b=OP2hSsxXU4geEIgq0VZE1aZ+xLX1OYcKFgdXaflX3XKW1BiD4e3jhikQzop6jHePxG
         gPb01fKEqpcRvgpJnbS7bHl9yMAl7GeCwQXnZdoWCD79wXolsOHxlNjNtK6JDj3DBXxM
         EHrw2W0YxHXA+sayaQBEREbR4fI/NogI90babgQgGdLD+8Lyk/sS72NPUn9xC+XJ92v0
         CFQYbWs5GaurPvWipPciM4A5wJXkpAyyZZKzOkjdWwg3q2HAUPpc2EROBtSNPoHsVW34
         b0RCEfVwSIxCGoD7k4r8Hr5+iw/tQHhx7LlwDEmcVc/997wvwdAGZHAjF4XyMCmO6v1A
         0gUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VVEFxp68V58IgxOUgyjBHqJhbtaMtslfm2VXdwuEHTo=;
        b=RITawvQO4LlF8LVNAPcWjSG1Ae1g38jFVZP7H9oGm8jXvE5ek0lAAUI+B63+7o08UZ
         vKTtlQeSZHHmQhgQmSMVBUKufouWjjHjunVxy0eHWuShnKOjkF1vy57M3Yt5f058Mac+
         jc1xf/2y2ojNTQM8m5VIcz+kfoa/Au5IXd9uWRN6aEyaS6Bcim6bfgbJi1t2xVglr6se
         LK4nBJ0MApAj7aYuzoi8OXIaWfoE6VvdAdOOxhV3XdNIKhoZvpv7f1s7BcsgtqjqY/7a
         gF4DmnR8ja3uS6GBEi1x+DS2B5CfoECAidLXTwkvhozfR6z4iptIQ1TMlwOIv5JvEWG0
         hUzg==
X-Gm-Message-State: AOAM531k9eniu/Kl5/Ju9q9jsch7OePmCRc+XGwBCtF53og5cTIN+TmY
        b/c3Ruvwcl3xElB91/ZxdpXZkJ6mnh0=
X-Google-Smtp-Source: ABdhPJxpTdxsPvopc5+dqCfBcRXHqUt7yQBKXejiDgwrhnDVeTuUdGg219sGQ5PDXqY6z3xf+1SCIg==
X-Received: by 2002:a17:906:30d6:: with SMTP id b22mr19662887ejb.442.1631626667173;
        Tue, 14 Sep 2021 06:37:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id u11sm5222110edo.65.2021.09.14.06.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:37:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.15] io_uring: auto-removal for direct open/accept
Date:   Tue, 14 Sep 2021 14:37:04 +0100
Message-Id: <0ef71a006879b9168f0d1bd6a5b5511ac87e7c40.1631626476.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It might be inconvenient that direct open/accept deviates from the
update semantics and fails if the slot is taken instead of removing a
file sitting there. Implement the auto-removal.

Note that removal might need to allocate and so may fail. However, if an
empty slot is specified, it's guaraneed to not fail on the fd
installation side. It's needed for users that can't tolerate spuriously
closed files, e.g. accepts where the other end doesn't expect it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 59 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a864a94364c6..29bca3a1ddeb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7672,6 +7672,7 @@ static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 	}
 }
 
+/* before changing see io_install_fixed_file(), it might ignore errors */
 static int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 {
 	if (ctx->rsrc_backup_node)
@@ -8287,11 +8288,27 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
+static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
+				 struct io_rsrc_node *node, void *rsrc)
+{
+	struct io_rsrc_put *prsrc;
+
+	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
+	if (!prsrc)
+		return -ENOMEM;
+
+	prsrc->tag = *io_get_tag_slot(data, idx);
+	prsrc->rsrc = rsrc;
+	list_add(&prsrc->list, &node->rsrc_list);
+	return 0;
+}
+
 static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
 	int ret = -EBADF;
 
@@ -8304,12 +8321,31 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 	ret = -EINVAL;
 	if (slot_index >= ctx->nr_user_files)
 		goto err;
+	/*
+	 * Ignore error, ->rsrc_backup_node is not needed if the slot is empty,
+	 * and we'd rather not drop the file.
+	 */
+	io_rsrc_node_switch_start(ctx);
 
 	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
 	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
-	ret = -EBADF;
-	if (file_slot->file_ptr)
-		goto err;
+
+	if (file_slot->file_ptr) {
+		struct file *old_file;
+
+		if (!ctx->rsrc_backup_node) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
+					    ctx->rsrc_node, old_file);
+		if (ret)
+			goto err;
+		file_slot->file_ptr = 0;
+		needs_switch = true;
+	}
 
 	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 	io_fixed_file_set(file_slot, file);
@@ -8321,27 +8357,14 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 
 	ret = 0;
 err:
+	if (needs_switch)
+		io_rsrc_node_switch(ctx, ctx->file_data);
 	io_ring_submit_unlock(ctx, !force_nonblock);
 	if (ret)
 		fput(file);
 	return ret;
 }
 
-static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
-				 struct io_rsrc_node *node, void *rsrc)
-{
-	struct io_rsrc_put *prsrc;
-
-	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
-	if (!prsrc)
-		return -ENOMEM;
-
-	prsrc->tag = *io_get_tag_slot(data, idx);
-	prsrc->rsrc = rsrc;
-	list_add(&prsrc->list, &node->rsrc_list);
-	return 0;
-}
-
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update2 *up,
 				 unsigned nr_args)
-- 
2.33.0

