Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60773689B3
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbhDWAUU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbhDWAUT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4689AC06174A
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h4so37504903wrt.12
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aQG4jTT7YcrwNfDP6CXuUUy04D+QKli+V496CCL1Nqk=;
        b=vhJDxvrapgLttBeiRekqcMDPZUNUoj5qW+Vnl58jTxUjGZtJXmLt9J74zbs1lVYIvw
         4hHXQt4nok9/t71ZNsxmwozjOnGFSbgGO26T5cBio9zub9ikYnPGsCJODbBnjkGBS8Wx
         7xQQSlJZgOBO7UZS+X/ghqsU53A0uQ+Uucs2WuVSRR+vQBebVWZpGGm230lv72Egn2KJ
         3yW+kxQ/nn9M3mjSU7tNfKELHc7lu+XFcudLqfs5aEjZ5y9HOdBFzJd4cA0VvVApdFAq
         tvZig3NQu5YdOrl1u/ZSSPbNE3PT97U4EJKYqPYDO6AiltFZfmniPzOm/uzLpHmRvyiS
         7hNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aQG4jTT7YcrwNfDP6CXuUUy04D+QKli+V496CCL1Nqk=;
        b=c9m/Du9YO36vdLLP35qbLYmcen6UG5XgcC3eFuUMnL5mj0L0maN+dKIXflZUEP6twR
         yazUx/KVaswvIblmjcD0noBAm94G5Cnau2Br4Y+iGz6BeDjlQjf1tDyqh5zHBWvSMFfq
         6kmddQ9P4KW4k5vj9KB1+Z4N+3rosjD6B8sDP/iJSWRh4YQdrwVbAzcMLAxCBc2f4GLV
         xkHUd3vIWDV95su6kH6XQGP7E0SvQ6xhG1IP4qfNA9c0TAAEH0eyEZiZljsYVmK1m+UV
         XPc4w+i2mi6q/v6nWWgSPirGc5EHPgWGQPZJdwsJEe1TvDDGDcZpStG4w7zb4APYTxb8
         vAgg==
X-Gm-Message-State: AOAM531GQ6eH0HpWLMUttqH1bl4DhRbltycNu57nJH3CNkL/rvwEw37F
        +O22woUBKYVv0GNgtqn0sFc=
X-Google-Smtp-Source: ABdhPJx24sjxZzQdULknrw9JFeYyeOf2LfvAgkOCG2mjrAEItlbJ1FyQqgryeVaq80DdGSJ12D4NYg==
X-Received: by 2002:a5d:414c:: with SMTP id c12mr1070441wrq.392.1619137182124;
        Thu, 22 Apr 2021 17:19:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/11] io_uring: preparation for rsrc tagging
Date:   Fri, 23 Apr 2021 01:19:21 +0100
Message-Id: <83729010aa9b34121aa6c2c3110d8d39e693e22f.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23f052a1d964..0c3936fe1943 100644
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
@@ -7488,6 +7498,21 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
+
+		if (prsrc->tag) {
+			bool ring_lock = ctx->flags & IORING_SETUP_IOPOLL;
+			unsigned long flags;
+
+			io_ring_submit_lock(ctx, ring_lock);
+			spin_lock_irqsave(&ctx->completion_lock, flags);
+			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
+			/* TODO: drain cq accounting */
+			io_commit_cqring(ctx);
+			spin_unlock_irqrestore(&ctx->completion_lock, flags);
+			io_cqring_ev_posted(ctx);
+			io_ring_submit_unlock(ctx, ring_lock);
+		}
+
 		rsrc_data->do_put(ctx, prsrc);
 		kfree(prsrc);
 	}
@@ -7577,7 +7602,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx, io_rsrc_file_put);
+	file_data = io_rsrc_data_alloc(ctx, io_rsrc_file_put, nr_args);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
@@ -7678,7 +7703,7 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct io_rsrc_data *data,
+static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
@@ -7687,6 +7712,7 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data,
 	if (!prsrc)
 		return -ENOMEM;
 
+	prsrc->tag = data->tags[idx];
 	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
@@ -7727,7 +7753,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
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

