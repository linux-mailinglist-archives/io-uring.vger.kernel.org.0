Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3D40B2B7
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhINPPB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 11:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbhINPOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 11:14:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E85C0613DF
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:13:34 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t6so19064108edi.9
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zBjAWBEvWTQ8tV0DHfgCCwa+kTgKCpFQo4QRnq6amW4=;
        b=GLuA7IR9iyammPRN18+1+SqrmmzN3lzxA5kmd8aykDd978/4Ni1cVwite46tpzvaTv
         8GNc9JT+CfRPMIJAoV7FE3CJPSKNiGt1r/WD64GqrvdYqWGG12XlK3F7ZZM/nFZ7J+JL
         ChYbqP+DCmlovI4ITVVEpQKFZuZsO0jAJVYLZkeq8Uyq0yxvK2Xf0L625TMDjDvRyzKJ
         yvadOQxcY+7FrUmOQecFAFbjo6m3d9X4SBqBJK4nNOGNMcvunwPyeujx1BTy74qni4qj
         0Dhm6SHstMMeAzZdtsDfSHo7bv2vo4Zq98f9gfrnvx/Ov0GM2iiANsB194vFXgmgEVu1
         7NOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zBjAWBEvWTQ8tV0DHfgCCwa+kTgKCpFQo4QRnq6amW4=;
        b=wg5VqGU2kDRV//SfGkAj3DL8AX0pa8ITIvfijugOc6f6cUoXU08eJoW51kORgy0e4M
         Rck9XkIOK9AKynyWm43PikNGZWHyFnldClyuS636PFokFAcPFFCWapM/5Q4480FsEpah
         GlqOJ01Q3lFaJFPXwmb5RRoUhJVzW1r0DNmC+mTFSi4hJTub0wwsbU6UisxOgtCZIbpD
         bAQ6IItyXdZ5zcj5Z9nI0kvi9hLq8T/Gghel+YrpoTRJ9IA65BUMs6jGXaBLKySLnCNN
         tCUv6SSpJhqwlUWmmQ9j02viVVY0Iae3oWkWsYlRyBZJUo+we/MzlyzXBhfAp8Ga13xx
         YgPw==
X-Gm-Message-State: AOAM532OKMFIWUUSViUtDWeJoXHOXwONmpmeQYsoav27oooWekcsQiNp
        i8VUoA1L6PGBZ9lq4mjc8/DFbNJvPJU=
X-Google-Smtp-Source: ABdhPJzbsZ9BiFkzyCYkpCcLv3/gFNwuLH0wFJFy6fxD0eGVnii9+Jkmsb+nKyUVR+4/MsfmNMoMWA==
X-Received: by 2002:a05:6402:1241:: with SMTP id l1mr7618467edw.123.1631632413407;
        Tue, 14 Sep 2021 08:13:33 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id bm26sm5085520ejb.16.2021.09.14.08.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:13:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
Subject: [PATCH v2 5.15] io_uring: auto-removal for direct open/accept
Date:   Tue, 14 Sep 2021 16:12:52 +0100
Message-Id: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It might be inconvenient that direct open/accept deviates from the
update semantics and fails if the slot is taken instead of removing a
file sitting there. Implement this auto-removal.

Note that removal might need to allocate and so may fail. However, if an
empty slot is specified, it's guaraneed to not fail on the fd
installation side for valid userspace programs. It's needed for users
who can't tolerate such failures, e.g. accept where the other end
never retries.

Suggested-by: Franz-B. Tuneke <franz-bernhard.tuneke@tu-dortmund.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: simplify io_rsrc_node_switch_start() handling

 fs/io_uring.c | 52 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a864a94364c6..58c0cbfdd128 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8287,11 +8287,27 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
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
 
@@ -8307,9 +8323,22 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 
 	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
 	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
-	ret = -EBADF;
-	if (file_slot->file_ptr)
-		goto err;
+
+	if (file_slot->file_ptr) {
+		struct file *old_file;
+
+		ret = io_rsrc_node_switch_start(ctx);
+		if (ret)
+			goto err;
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
@@ -8321,27 +8350,14 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 
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

