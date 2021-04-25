Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194CC36A789
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhDYNdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhDYNdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:22 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B3BC061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:40 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l189-20020a1cbbc60000b0290140319ad207so1256359wmf.2
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TzbO9n6upSRZyEAAJ0Vl8eUPLB6pEzGVQtZ2/zMjW88=;
        b=b7HUd+0cHrze9JYYtcsbAIcEQP90rI9vSLfGq6ZzzVt8vFUgIW7IG3VrmXD0SqSYj3
         p1hvr3AWmX7AK6m4544SaJYmUAg3yCbfwqrzsqgvKqiVZRsL6VHLAixH7NBEKr/l1tiY
         Gd+unGVvT8Oc+Ss4bYYB7War+NruIEvrWMCorovxBPiztgCapbU0KcjPQdGZ6UefHXPQ
         aq3PotLgRkRfzI9KfB5x1SKj56lapZABDBVrMNG5guuOphs1tJhz3p28US5aBbOq+LOz
         pY6cr5riirMWUliBZps+6bnx9VfL/OvaabVxSMwNbUpnw/9NcQkRjvL5LvxSTyhnZjfY
         4Yew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzbO9n6upSRZyEAAJ0Vl8eUPLB6pEzGVQtZ2/zMjW88=;
        b=EVwvIcK9WjECQFYc4gwZKhV6KkIM32wxRU3/JKJmt7Hi+YITlpT9FtUdyy9bNu34H7
         gJiUnTQmpy7UDTb7ZsaWwms0HEEzdyR6Q4HGJoZIN3ALFatWfs3qockRyXvMTIfkJ0CY
         W3bCoi9lmCrK5Ixq7nBHFKFe2hAnp68Clz7yxOnJVkZ3oB4nAvmuLQtMsq7nmqxw0pIF
         55Iy+e1gSfnxDq+sYeh1Q5TkFxMk7o3f84DCcuGX/vbyxCef1EulYnEObwBrXRBjWkUU
         WqTHydMT3+Fd2SkZibTVlXFpHdbbxeWmiQWng0wbVvrsi1KsvH3nlYsfHATMSFIP3kRp
         jSKw==
X-Gm-Message-State: AOAM533GmTuiyuHWOPa/mfm8UosmYpaOP4jOrE8jZ2bUtEA/kfiXLjlq
        KZexjGjOBNBN8gt/WRtQcws=
X-Google-Smtp-Source: ABdhPJw0XK/bLGn7AHyEmbwpi/P1T21v4OfpIO1UibLBb2Thesx17r4dZTj4fevQrNGK7mfVikWGxA==
X-Received: by 2002:a05:600c:2112:: with SMTP id u18mr14242800wml.33.1619357559773;
        Sun, 25 Apr 2021 06:32:39 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 04/12] io_uring: preparation for rsrc tagging
Date:   Sun, 25 Apr 2021 14:32:18 +0100
Message-Id: <2e6beec5eabe7216bb61fb93cdf5aaf65812a9b0.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need a way to notify userspace when a lazily removed resource
actually died out. This will be done by associating a tag, which is u64
exactly like req->user_data, with each rsrc (e.g. buffer of file). A CQE
will be posted once a resource is actually put down.

Tag 0 is a special value set by default, for whcih it don't generate an
CQE, so providing the old behaviour.

Don't expose it to the userspace yet, but prepare internally, allocate
buffers, add all posting hooks, etc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23f052a1d964..8cc593da5cc4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -214,6 +214,7 @@ struct io_fixed_file {
 
 struct io_rsrc_put {
 	struct list_head list;
+	u64 tag;
 	union {
 		void *rsrc;
 		struct file *file;
@@ -239,6 +240,7 @@ typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 struct io_rsrc_data {
 	struct io_ring_ctx		*ctx;
 
+	u64				*tags;
 	rsrc_put_fn			*do_put;
 	atomic_t			refs;
 	struct completion		done;
@@ -7112,11 +7114,13 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 
 static void io_rsrc_data_free(struct io_rsrc_data *data)
 {
+	kvfree(data->tags);
 	kfree(data);
 }
 
 static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
-					       rsrc_put_fn *do_put)
+					       rsrc_put_fn *do_put,
+					       unsigned nr)
 {
 	struct io_rsrc_data *data;
 
@@ -7124,6 +7128,12 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 	if (!data)
 		return NULL;
 
+	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL);
+	if (!data->tags) {
+		kfree(data);
+		return NULL;
+	}
+
 	atomic_set(&data->refs, 1);
 	data->ctx = ctx;
 	data->do_put = do_put;
@@ -7488,6 +7498,20 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
+
+		if (prsrc->tag) {
+			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
+			unsigned long flags;
+
+			io_ring_submit_lock(ctx, lock_ring);
+			spin_lock_irqsave(&ctx->completion_lock, flags);
+			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
+			io_commit_cqring(ctx);
+			spin_unlock_irqrestore(&ctx->completion_lock, flags);
+			io_cqring_ev_posted(ctx);
+			io_ring_submit_unlock(ctx, lock_ring);
+		}
+
 		rsrc_data->do_put(ctx, prsrc);
 		kfree(prsrc);
 	}
@@ -7577,7 +7601,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx, io_rsrc_file_put);
+	file_data = io_rsrc_data_alloc(ctx, io_rsrc_file_put, nr_args);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
@@ -7678,7 +7702,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct io_rsrc_data *data,
+static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
@@ -7687,6 +7711,7 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data,
 	if (!prsrc)
 		return -ENOMEM;
 
+	prsrc->tag = data->tags[idx];
 	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
@@ -7727,7 +7752,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (file_slot->file_ptr) {
 			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, ctx->rsrc_node, file);
+			err = io_queue_rsrc_removal(data, up->offset + done,
+						    ctx->rsrc_node, file);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
-- 
2.31.1

