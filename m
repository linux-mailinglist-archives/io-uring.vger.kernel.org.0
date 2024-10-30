Return-Path: <io-uring+bounces-4213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FC09B68DC
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 251261F22A2F
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 16:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2BF2141A2;
	Wed, 30 Oct 2024 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pk3LE9GX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CA6433D5
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730304406; cv=none; b=FHi9tdwx36YrZ3lZkIJ+rxEckuhILmEjuH/OZbPbljszZgGqVArO4fwO86CeJ3Mas8e/EiG+5mPgG6c4/wvyI7yNNjTtYossSm/mEOCAYTCu2u+a+iBHMw4GjPYTPak1C1pOi2dq14DN/zbI+yvjdBBy2rFja3AaYvvsG8h1blw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730304406; c=relaxed/simple;
	bh=gvkjc01BPd0v/VKpIEZVOOK1LLd7ezudRCXkq6zWMwQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=imTaEwEGHe3hO+tPM8nQ4qFFoBv/DEwRy0WpF4hiLb1cllGO8FlELSubRHHrvajCfoMdwYr8LzlGrhOYQhwAzMkwxn6JkVfnbQcUS8a5HHhNZ5HRxwbxzxbEWZJRefbXRpEauN+D1pYLnbJwfmZ4mm5g6k/OyIdPzww3f2N5WIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pk3LE9GX; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-290d8d5332cso5774fac.2
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 09:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730304401; x=1730909201; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uhp0VtKKi7eIJiu49391VtqDoKuUcEgVEZ06XGXBnt8=;
        b=Pk3LE9GXmR/r1RkcL8sXq2r5s0OevcYjb0OvqT9FQq7HMAzVg8geS6U5RNF9GHybxw
         272F2wPnTHGE4Z+PgOBb5trimH8vM/9R8VEXx9YcFHBrP053VfaMBAb6imaQeF0W5NHk
         cIQ1cdnOF1S+RLRhxBuph9D01onA5aKbULq/bN7qMy5GCZbIqTdW2sGlZ8Jk/XcLDrSX
         EXE+iYyCLvMGY96woHwj8LZZdNEcKKni1zAulto7kfG/uBHe+GhYN8vCn74/dz6YsP/x
         qIXAEZ4578xxouCliWLSgk1fVo7o8/ioK43/Hj89SVFxxfJX4047WLKJDoQm97Lot1YA
         alFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730304401; x=1730909201;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uhp0VtKKi7eIJiu49391VtqDoKuUcEgVEZ06XGXBnt8=;
        b=AhRQeHQT1Q/7gM7iZNAsm29jKx9mQsjGbt9b6mqRonXrGZpolKrBJXRlM6sHbkN0EZ
         r1U/WcOzaUumUTiijTo6IUigjZM0ZfPSpto4EkT685kjQ8gh0/dwmbKreY4GfHQjaVQE
         MQ6jnQXviVgKox7JRHRdXqB4Bk1jiLdmYYcIamek7N7o654/DqCGqMaajMWwS4uyF1b5
         PJPJYE6jM4eRzN4hcclUeOXL6vSixN84SYGvVQehRWctD4pJX+N46ltTkbPYmJGRQQIw
         OnPA8F3G4qEh9BC5zbLAqTOAyelnqnpuZukLw5N14KbV0Bfy07Q5IQaRNaUtmqxuF6i9
         PlSw==
X-Gm-Message-State: AOJu0YxpzaFAjiwYGkpPhuQoL462LB9bT0nNmpNnh6miymoi5nzf3/cB
	/rVWwRDrjCBiNX/ujoDJ8iRTdgIoiI6aavcaxNqLMNZQ/3HETVWfpCE9XUUPcXMwesoscOOKNNP
	3hKc=
X-Google-Smtp-Source: AGHT+IGvaDbf8mn4KPrIKpK+U0etHi1Ex1T4n3ecCT2ShQ/vESvMxTC5w2lTLaQVGBFrFJVbln2F3g==
X-Received: by 2002:a05:6870:1cd:b0:25d:ff4c:bc64 with SMTP id 586e51a60fabf-29051af0f90mr13802479fac.6.1730304401382;
        Wed, 30 Oct 2024 09:06:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7263d5fasm2936322173.83.2024.10.30.09.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 09:06:40 -0700 (PDT)
Message-ID: <03b4ccfd-26af-494c-9fda-447d5259e825@kernel.dk>
Date: Wed, 30 Oct 2024 10:06:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/rsrc: get rid of the empty node and
 dummy_ubuf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The empty node was used as a placeholder for a sparse entry, but it
didn't really solve any issues. The caller still has to check for
whether it's the empty node or not, it may as well just check for a NULL
return instead.

The dummy_ubuf was used for a sparse buffer entry, but NULL will serve
the same purpose there of ensuring an -EFAULT on attempted import.

Just use NULL for a sparse node, regardless of whether or not it's a
file or buffer resource.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3a535e9e8ac3..44a772013c09 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -947,8 +947,8 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
 	req->ctx = ctx;
-	req->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
-	req->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
+	req->rsrc_nodes[IORING_RSRC_FILE] = NULL;
+	req->rsrc_nodes[IORING_RSRC_BUFFER] = NULL;
 	req->link = NULL;
 	req->async_data = NULL;
 	/* not necessary, but safer to zero */
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 44bf21c0f810..4f02e969cf08 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -117,8 +117,8 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->file = NULL;
 	notif->task = current;
 	io_get_task_refs(1);
-	notif->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
-	notif->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
+	notif->rsrc_nodes[IORING_RSRC_FILE] = NULL;
+	notif->rsrc_nodes[IORING_RSRC_BUFFER] = NULL;
 
 	nd = io_notif_to_data(notif);
 	nd->zc_report = false;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 378f33746457..af60d9f597be 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -32,17 +32,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
-static const struct io_mapped_ubuf dummy_ubuf = {
-	/* set invalid range, so io_import_fixed() fails meeting it */
-	.ubuf = -1UL,
-	.len = UINT_MAX,
-};
-
-const struct io_rsrc_node empty_node = {
-	.type = IORING_RSRC_BUFFER,
-	.buf = (struct io_mapped_ubuf *) &dummy_ubuf,
-};
-
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -116,7 +105,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	unsigned int i;
 
-	if (node->buf != &dummy_ubuf) {
+	if (node->buf) {
 		struct io_mapped_ubuf *imu = node->buf;
 
 		if (!refcount_dec_and_test(&imu->refs))
@@ -265,20 +254,21 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(iov);
 		if (err)
 			break;
-		if (!iov->iov_base && tag) {
-			err = -EINVAL;
-			break;
-		}
 		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
 		}
+		if (tag) {
+			if (!node) {
+				err = -EINVAL;
+				break;
+			}
+			node->tag = tag;
+		}
 		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		io_reset_rsrc_node(&ctx->buf_table, i);
 		ctx->buf_table.nodes[i] = node;
-		if (tag)
-			node->tag = tag;
 		if (ctx->compat)
 			user_data += sizeof(struct compat_iovec);
 		else
@@ -742,7 +732,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	bool coalesced;
 
 	if (!iov->iov_base)
-		return rsrc_empty_node;
+		return NULL;
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
@@ -850,10 +840,6 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 				ret = -EFAULT;
 				break;
 			}
-			if (tag && !iov->iov_base) {
-				ret = -EINVAL;
-				break;
-			}
 		}
 
 		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
@@ -861,8 +847,13 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			ret = PTR_ERR(node);
 			break;
 		}
-		if (tag)
+		if (tag) {
+			if (!node) {
+				ret = -EINVAL;
+				break;
+			}
 			node->tag = tag;
+		}
 		data.nodes[i] = node;
 	}
 
@@ -957,8 +948,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		struct io_rsrc_node *dst_node, *src_node;
 
 		src_node = io_rsrc_node_lookup(&src_ctx->buf_table, i);
-		if (src_node == rsrc_empty_node) {
-			dst_node = rsrc_empty_node;
+		if (!src_node) {
+			dst_node = NULL;
 		} else {
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 43b19e516f5f..a40fad783a69 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -67,9 +67,6 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
 
-extern const struct io_rsrc_node empty_node;
-#define rsrc_empty_node	(struct io_rsrc_node *) &empty_node
-
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
 						       int index)
 {
@@ -80,7 +77,7 @@ static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data
 
 static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
-	if (node != rsrc_empty_node && !--node->refs)
+	if (node && !--node->refs)
 		io_free_rsrc_node(node);
 }
 
@@ -97,23 +94,17 @@ static inline bool io_reset_rsrc_node(struct io_rsrc_data *data, int index)
 
 static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 {
-	if (req->rsrc_nodes[IORING_RSRC_FILE] != rsrc_empty_node) {
-		io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_FILE]);
-		req->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
-	}
-	if (req->rsrc_nodes[IORING_RSRC_BUFFER] != rsrc_empty_node) {
-		io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_BUFFER]);
-		req->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
-	}
+	io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_FILE]);
+	io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_BUFFER]);
+	req->rsrc_nodes[IORING_RSRC_FILE] = NULL;
+	req->rsrc_nodes[IORING_RSRC_BUFFER] = NULL;
 }
 
 static inline void io_req_assign_rsrc_node(struct io_kiocb *req,
 					   struct io_rsrc_node *node)
 {
-	if (node != rsrc_empty_node) {
-		node->refs++;
-		req->rsrc_nodes[node->type] = node;
-	}
+	node->refs++;
+	req->rsrc_nodes[node->type] = node;
 }
 
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/splice.c b/io_uring/splice.c
index deeb8bb18651..e8ed15f4ea1a 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -35,7 +35,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
-	sp->rsrc_node = rsrc_empty_node;
+	sp->rsrc_node = NULL;
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }

-- 
Jens Axboe


