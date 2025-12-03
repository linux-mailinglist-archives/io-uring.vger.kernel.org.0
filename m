Return-Path: <io-uring+bounces-10916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7DCC9D6E2
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 100933A211F
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF2520CCCA;
	Wed,  3 Dec 2025 00:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dWOyxI29"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F9258CD7
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722229; cv=none; b=f0JUgxUNYo1b2RjVS8+GSKHedV8aLN+z/9Z6+Hn+gYp76ZvY78jVKgkfqBMxbInithjS+Sue5KdQnDzxxKvbgudpYtKahe4CWYUxn23nL560GhBJTHAvAFdwrOiPVUNMBLoAGR3niZZUpaASfrrPZVGDVXSjqsUNBPSI+0CV8KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722229; c=relaxed/simple;
	bh=POK76mSkZGQZW1V1OEtsMbG6sZIn8kc0pt+0RhlSe5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ko/hK3lWnyAv5h9M8aFANwy81vKB3gzLQXdyacPv6/OFomUQwOluOdNt/gjE6vBOw4dlaZQUgyS9Q/G6cFDb5sR5Z0blZ8FtrooR1i7I1BPm31E6kKOc7eXYivfkbOf4czIQz4DVJIgkznk81cfYU3StNHzlec6Tnm/TVO8490c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dWOyxI29; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7bb710d1d1dso9395307b3a.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722225; x=1765327025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b2gbS/Dt+kxpXhzycpEXEPakU6qy8KV8mHNwBnb8xAg=;
        b=dWOyxI2955CJ8iP7H/QeduBX6IuSILqxk/zY4FuVPaGuR1YUa4C9uxaiisln57qx6c
         JFis3wgAMUGNZWY+SdmgxwU3zIgs8MmoXeG8bUqffSzY6xdjo355/OZ9ZzO/eIcIBJQX
         YlNGmpM45UO4P5TwE+2Zr0h3sutOB3nEzsOFGo1/c8ju8+Y6hBfrMO0UiswtImSqAgdP
         CBEjVYi9YVAfzXBU+O32W/D7WG6oWWqyXCRrLknFCYlCB18ddHRRtb1iEO5mWvQb+XMv
         Odt1H6k16ynkSVF4lR/BcwnFUp9Gwqe/qlnfZgqCITpWjjDPQ1HSNLo2rfjSKX37rTcH
         A4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722225; x=1765327025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b2gbS/Dt+kxpXhzycpEXEPakU6qy8KV8mHNwBnb8xAg=;
        b=WoI50GiQKD9FKMdoLXHfaIIqo93JPE4tc+7sCOB9W8w/wvGIedhBmvY+3imKDQFbuT
         u/hjIG8mxBkTH0cpzr0zwO9sUp23pHM8RMNX9nglUm8A2toXO3ZVJT0SR9Bi44FQlTpj
         waz6iaN8xboJkzDfob/d9C86KnXsaf+ztrG5+WzVUqeBoHCunJlxZw3GjuMPIPdMzCzO
         imo5sjaC7SrFEFFGAHDkR1Ywt5fzJ1E47hekn29RhY54nb1tCNbpgJZt6Bzs1Dlurw9I
         pvXwFEMBJjXURRCuluJmqXQlqXvwBmdWzC1DTjxsPg0+66i0mDCVQHi91ttCP5PG1t3l
         Fm6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/DQu9SDEC4X53OQl0gYFn724VFxOMFBNFdB8vKFik29/JIxP8zw+lZ2aort9SXs34ZfXttZoIZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmg97HNpdiTD23PrF7sym6HAR0sc1pvREzqE6oCxYAqGh+6JkQ
	OmZEANaQuD/8zG/4dsb5KuHcm3gyokBEseyJDB0UR2ohJS34/DfWVOEa
X-Gm-Gg: ASbGncvjBjjGS+8SPB2kBR5eStn4pMCwF/jTABBc39UjncrkG6WfA2BhkwVgOHQ2Cyi
	jnPxUPb4x8FcD3evK0F1Dcr/2aYN43Dne52OPrxeX0oL98aGY5Pf3cpLd9pQ4Bxza7k9y71Q+zD
	wuV+TyqHPHaa+E22c8fyr+xLgnY2RaRbIQzxPLqzNNcPhwkyHRzumtUF5F5RWK9ZYF1O4Z4+sHg
	xxwqW4QzOuVWThlv+mYdy61J0QShLoi4mEBw0J2oZMXMYpMUtsAJCfNhhaeOkzRL0NQTBcPaguz
	bfZoJxvjhXHp65RZ0RxgPRvI0oqb8MHkRPRUIQwUTZkkspfywtD4C4WmI+EvR9lshkmcod5Qmu5
	ksqE8vEn3O+cSTkYRG0YfsIcOZmm5aJXy01tKtjpAPwZ0AmOlPEGJ3mWyb5BmwPi3/5fS1JrV0j
	3ugIbR6zgRlERBG7of
X-Google-Smtp-Source: AGHT+IEggU7v7IYXrsXa9eBEuIfVgtF3QuI3ZnMGNRcCX30Iidr1zCnSGez8FMfBPGE3n9nghGWiNw==
X-Received: by 2002:a05:6a20:7d8b:b0:361:51d9:e18e with SMTP id adf61e73a8af0-363f5eb6274mr711963637.52.1764722225199;
        Tue, 02 Dec 2025 16:37:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be508a12229sm16233021a12.21.2025.12.02.16.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:04 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 21/30] fuse: add io-uring kernel-managed buffer ring
Date: Tue,  2 Dec 2025 16:35:16 -0800
Message-ID: <20251203003526.2889477-22-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io-uring kernel-managed buffer ring capability for fuse daemons
communicating through the io-uring interface.

This has two benefits:
a) eliminates the overhead of pinning/unpinning user pages and
translating virtual addresses for every server-kernel interaction

b) reduces the amount of memory needed for the buffers per queue and
allows buffers to be reused across entries. Incremental buffer
consumption, when added, will allow a buffer to be used across multiple
requests.

Buffer ring usage is set on a per-queue basis. In order to use this, the
daemon needs to have preregistered a kernel-managed buffer ring and a
fixed buffer at index 0 that will hold all the headers, and set the
"use_bufring" field during registration. The kernel-managed buffer ring
and fixed buffer will be pinned for the lifetime of the connection.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev_uring.c       | 452 +++++++++++++++++++++++++++++++++-----
 fs/fuse/dev_uring_i.h     |  35 ++-
 include/uapi/linux/fuse.h |  12 +-
 3 files changed, 437 insertions(+), 62 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b57871f92d08..3600892ba837 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -10,6 +10,8 @@
 #include "fuse_trace.h"
 
 #include <linux/fs.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring/buf.h>
 #include <linux/io_uring/cmd.h>
 
 static bool __read_mostly enable_uring;
@@ -19,6 +21,8 @@ MODULE_PARM_DESC(enable_uring,
 
 #define FUSE_URING_IOV_SEGS 2 /* header and payload */
 
+#define FUSE_URING_RINGBUF_GROUP 0
+#define FUSE_URING_FIXED_HEADERS_INDEX 0
 
 bool fuse_uring_enabled(void)
 {
@@ -194,6 +198,37 @@ bool fuse_uring_request_expired(struct fuse_conn *fc)
 	return false;
 }
 
+static void fuse_uring_teardown_buffers(struct fuse_ring_queue *queue,
+					unsigned int issue_flags)
+{
+	if (!queue->use_bufring)
+		return;
+
+	spin_lock(&queue->lock);
+
+	if (queue->ring_killed) {
+		spin_unlock(&queue->lock);
+		return;
+	}
+
+	/*
+	 * Try to get a reference on it so the ctx isn't killed while we're
+	 * unpinning
+	 */
+	if (!percpu_ref_tryget_live(&queue->ring_ctx->refs)) {
+		spin_unlock(&queue->lock);
+		return;
+	}
+
+	spin_unlock(&queue->lock);
+
+	WARN_ON_ONCE(io_uring_buf_table_unpin(queue->ring_ctx, issue_flags));
+	WARN_ON_ONCE(io_uring_buf_ring_unpin(queue->ring_ctx,
+					     FUSE_URING_RINGBUF_GROUP,
+					     issue_flags));
+	percpu_ref_put(&queue->ring_ctx->refs);
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -276,20 +311,76 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 	return res;
 }
 
-static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
-						       int qid)
+static void io_ring_killed(void *priv)
+{
+	struct fuse_ring_queue *queue = (struct fuse_ring_queue *)priv;
+
+	spin_lock(&queue->lock);
+	queue->ring_killed = true;
+	spin_unlock(&queue->lock);
+}
+
+static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
+				     struct fuse_ring_queue *queue,
+				     unsigned int issue_flags)
+{
+	struct io_ring_ctx *ring_ctx = cmd_to_io_kiocb(cmd)->ctx;
+	int err;
+
+	err = io_uring_buf_ring_pin(ring_ctx, FUSE_URING_RINGBUF_GROUP,
+				    issue_flags, &queue->bufring);
+	if (err)
+		return err;
+
+	if (!io_uring_is_kmbuf_ring(ring_ctx, FUSE_URING_RINGBUF_GROUP,
+				    issue_flags)) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	err = io_uring_buf_table_pin(ring_ctx, issue_flags);
+	if (err)
+		goto error;
+
+	err = io_uring_cmd_import_fixed_index(cmd,
+					      FUSE_URING_FIXED_HEADERS_INDEX,
+					      ITER_DEST, &queue->headers_iter,
+					      issue_flags);
+	if (err) {
+		io_uring_buf_table_unpin(ring_ctx, issue_flags);
+		goto error;
+	}
+
+	io_uring_set_release_callback(ring_ctx, io_ring_killed, queue,
+				      issue_flags);
+	queue->ring_ctx = ring_ctx;
+
+	queue->use_bufring = true;
+
+	return 0;
+
+error:
+	io_uring_buf_ring_unpin(ring_ctx, FUSE_URING_RINGBUF_GROUP,
+				issue_flags);
+	return err;
+}
+
+static struct fuse_ring_queue *
+fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
+			int qid, bool use_bufring, unsigned int issue_flags)
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
 	struct list_head *pq;
+	int err = 0;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
 	if (!pq) {
 		kfree(queue);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	queue->qid = qid;
@@ -307,6 +398,15 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
 
+	if (use_bufring) {
+		err = fuse_uring_buf_ring_setup(cmd, queue, issue_flags);
+		if (err) {
+			kfree(pq);
+			kfree(queue);
+			return ERR_PTR(err);
+		}
+	}
+
 	spin_lock(&fc->lock);
 	if (ring->queues[qid]) {
 		spin_unlock(&fc->lock);
@@ -452,6 +552,7 @@ static void fuse_uring_async_stop_queues(struct work_struct *work)
 			continue;
 
 		fuse_uring_teardown_entries(queue);
+		fuse_uring_teardown_buffers(queue, IO_URING_F_UNLOCKED);
 	}
 
 	/*
@@ -487,6 +588,7 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 			continue;
 
 		fuse_uring_teardown_entries(queue);
+		fuse_uring_teardown_buffers(queue, IO_URING_F_UNLOCKED);
 	}
 
 	if (atomic_read(&ring->queue_refs) > 0) {
@@ -584,6 +686,35 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 	return err;
 }
 
+static int get_kernel_ring_header(struct fuse_ring_ent *ent,
+				  enum fuse_uring_header_type type,
+				  struct iov_iter *headers_iter)
+{
+	size_t offset;
+
+	switch (type) {
+	case FUSE_URING_HEADER_IN_OUT:
+		/* No offset - start of header */
+		offset = 0;
+		break;
+	case FUSE_URING_HEADER_OP:
+		offset = offsetof(struct fuse_uring_req_header, op_in);
+		break;
+	case FUSE_URING_HEADER_RING_ENT:
+		offset = offsetof(struct fuse_uring_req_header, ring_ent_in_out);
+		break;
+	default:
+		WARN_ONCE(1, "Invalid header type: %d\n", type);
+		return -EINVAL;
+	}
+
+	*headers_iter = ent->headers_iter;
+	if (offset)
+		iov_iter_advance(headers_iter, offset);
+
+	return 0;
+}
+
 static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
 					 enum fuse_uring_header_type type)
 {
@@ -605,17 +736,38 @@ static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
 					       const void *header,
 					       size_t header_size)
 {
-	void __user *ring = get_user_ring_header(ent, type);
+	bool use_bufring = ent->queue->use_bufring;
+	int err = 0;
 
-	if (!ring)
-		return -EINVAL;
+	if (use_bufring) {
+		struct iov_iter iter;
+
+		err =  get_kernel_ring_header(ent, type, &iter);
+		if (err)
+			goto done;
 
-	if (copy_to_user(ring, header, header_size)) {
-		pr_info_ratelimited("Copying header to ring failed.\n");
-		return -EFAULT;
+		if (copy_to_iter(header, header_size, &iter) != header_size)
+			err = -EFAULT;
+	} else {
+		void __user *ring = get_user_ring_header(ent, type);
+
+		if (!ring) {
+			err = -EINVAL;
+			goto done;
+		}
+
+		if (copy_to_user(ring, header, header_size))
+			err = -EFAULT;
 	}
 
-	return 0;
+done:
+	if (err)
+		pr_info_ratelimited("Copying header to ring failed: "
+				    "header_type=%u, header_size=%lu, "
+				    "use_bufring=%d\n", type, header_size,
+				    use_bufring);
+
+	return err;
 }
 
 static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
@@ -623,17 +775,38 @@ static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
 						 void *header,
 						 size_t header_size)
 {
-	const void __user *ring = get_user_ring_header(ent, type);
+	bool use_bufring = ent->queue->use_bufring;
+	int err = 0;
 
-	if (!ring)
-		return -EINVAL;
+	if (use_bufring) {
+		struct iov_iter iter;
 
-	if (copy_from_user(header, ring, header_size)) {
-		pr_info_ratelimited("Copying header from ring failed.\n");
-		return -EFAULT;
+		err =  get_kernel_ring_header(ent, type, &iter);
+		if (err)
+			goto done;
+
+		if (copy_from_iter(header, header_size, &iter) != header_size)
+			err = -EFAULT;
+	} else {
+		const void __user *ring = get_user_ring_header(ent, type);
+
+		if (!ring) {
+			err = -EINVAL;
+			goto done;
+		}
+
+		if (copy_from_user(header, ring, header_size))
+			err = -EFAULT;
 	}
 
-	return 0;
+done:
+	if (err)
+		pr_info_ratelimited("Copying header from ring failed: "
+				    "header_type=%u, header_size=%lu, "
+				    "use_bufring=%d\n", type, header_size,
+				    use_bufring);
+
+	return err;
 }
 
 static int setup_fuse_copy_state(struct fuse_copy_state *cs,
@@ -643,14 +816,23 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
 {
 	int err;
 
-	err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
-	if (err) {
-		pr_info_ratelimited("fuse: Import of user buffer failed\n");
-		return err;
+	if (!ent->queue->use_bufring) {
+		err = import_ubuf(dir, ent->payload, ring->max_payload_sz, iter);
+		if (err) {
+			pr_info_ratelimited("fuse: Import of user buffer "
+					    "failed\n");
+			return err;
+		}
 	}
 
 	fuse_copy_init(cs, dir == ITER_DEST, iter);
 
+	if (ent->queue->use_bufring) {
+		cs->is_kaddr = true;
+		cs->len = ent->payload_kvec.iov_len;
+		cs->kaddr = ent->payload_kvec.iov_base;
+	}
+
 	cs->is_uring = true;
 	cs->req = req;
 
@@ -762,6 +944,108 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 				   sizeof(req->in.h));
 }
 
+static bool fuse_uring_req_has_payload(struct fuse_req *req)
+{
+	struct fuse_args *args = req->args;
+
+	return args->in_numargs > 1 || args->out_numargs;
+}
+
+static int fuse_uring_select_buffer(struct fuse_ring_ent *ent,
+				    unsigned int issue_flags)
+	__must_hold(&queue->lock)
+{
+	struct io_br_sel sel;
+	size_t len = 0;
+
+	lockdep_assert_held(&ent->queue->lock);
+
+	/* Get a buffer to use for the payload */
+	sel = io_ring_buffer_select(cmd_to_io_kiocb(ent->cmd), &len,
+				    ent->queue->bufring, issue_flags);
+	if (sel.val)
+		return sel.val;
+	if (!sel.kaddr)
+		return -ENOENT;
+
+	ent->payload_kvec.iov_base = sel.kaddr;
+	ent->payload_kvec.iov_len = len;
+	ent->ringbuf_buf_id = sel.buf_id;
+
+	return 0;
+}
+
+static int fuse_uring_clean_up_buffer(struct fuse_ring_ent *ent,
+				      struct io_uring_cmd *cmd)
+	__must_hold(&queue->lock)
+{
+	struct kvec *kvec = &ent->payload_kvec;
+	int err;
+
+	lockdep_assert_held(&ent->queue->lock);
+
+	if (!ent->queue->use_bufring)
+		return 0;
+
+	if (kvec->iov_base) {
+		err = io_uring_kmbuf_recycle_pinned(cmd_to_io_kiocb(ent->cmd),
+						    ent->queue->bufring,
+						    (u64)kvec->iov_base,
+						    kvec->iov_len,
+						    ent->ringbuf_buf_id);
+		if (WARN_ON_ONCE(err))
+			return err;
+		memset(kvec, 0, sizeof(*kvec));
+	}
+
+	return 0;
+}
+
+static int fuse_uring_next_req_update_buffer(struct fuse_ring_ent *ent,
+					     struct fuse_req *req,
+					     unsigned int issue_flags)
+{
+	bool buffer_selected;
+	bool has_payload;
+
+	if (!ent->queue->use_bufring)
+		return 0;
+
+	ent->headers_iter.data_source = false;
+
+	buffer_selected = ent->payload_kvec.iov_base != 0;
+	has_payload = fuse_uring_req_has_payload(req);
+
+	if (has_payload && !buffer_selected)
+		return fuse_uring_select_buffer(ent, issue_flags);
+
+	if (!has_payload && buffer_selected)
+		fuse_uring_clean_up_buffer(ent, ent->cmd);
+
+	return 0;
+}
+
+static int fuse_uring_prep_buffer(struct fuse_ring_ent *ent,
+				  struct fuse_req *req, unsigned int dir,
+				  unsigned issue_flags)
+{
+	if (!ent->queue->use_bufring)
+		return 0;
+
+	if (dir == ITER_SOURCE) {
+		ent->headers_iter.data_source = true;
+		return 0;
+	}
+
+	ent->headers_iter.data_source = false;
+
+	/* no payload to copy, can skip selecting a buffer */
+	if (!fuse_uring_req_has_payload(req))
+		return 0;
+
+	return fuse_uring_select_buffer(ent, issue_flags);
+}
+
 static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
 				   struct fuse_req *req)
 {
@@ -824,7 +1108,8 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
 }
 
 /* Fetch the next fuse request if available */
-static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
+static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent,
+						  unsigned int issue_flags)
 	__must_hold(&queue->lock)
 {
 	struct fuse_req *req;
@@ -835,8 +1120,13 @@ static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
 
 	/* get and assign the next entry while it is still holding the lock */
 	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
-	if (req)
+	if (req) {
+		if (fuse_uring_next_req_update_buffer(ent, req, issue_flags))
+			return NULL;
 		fuse_uring_add_req_to_ring_ent(ent, req);
+	} else {
+		fuse_uring_clean_up_buffer(ent, ent->cmd);
+	}
 
 	return req;
 }
@@ -878,7 +1168,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
  * Else, there is no next fuse request and this returns false.
  */
 static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
-					 struct fuse_ring_queue *queue)
+					 struct fuse_ring_queue *queue,
+					 unsigned int issue_flags)
 {
 	int err;
 	struct fuse_req *req;
@@ -886,7 +1177,7 @@ static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
 retry:
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ent, queue);
-	req = fuse_uring_ent_assign_req(ent);
+	req = fuse_uring_ent_assign_req(ent, issue_flags);
 	spin_unlock(&queue->lock);
 
 	if (req) {
@@ -990,7 +1281,12 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 
 	/* without the queue lock, as other locks are taken */
 	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
-	fuse_uring_commit(ent, req, issue_flags);
+
+	err = fuse_uring_prep_buffer(ent, req, ITER_SOURCE, issue_flags);
+	if (WARN_ON_ONCE(err))
+		fuse_uring_req_end(ent, req, err);
+	else
+		fuse_uring_commit(ent, req, issue_flags);
 
 	/*
 	 * Fetching the next request is absolutely required as queued
@@ -998,7 +1294,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	 * and fetching is done in one step vs legacy fuse, which has separated
 	 * read (fetch request) and write (commit result).
 	 */
-	if (fuse_uring_get_next_fuse_req(ent, queue))
+	if (fuse_uring_get_next_fuse_req(ent, queue, issue_flags))
 		fuse_uring_send(ent, cmd, 0, issue_flags);
 	return 0;
 }
@@ -1094,39 +1390,64 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 	struct iovec iov[FUSE_URING_IOV_SEGS];
 	int err;
 
+	err = -ENOMEM;
+	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
+	if (!ent)
+		return ERR_PTR(err);
+
+	INIT_LIST_HEAD(&ent->list);
+
+	ent->queue = queue;
+
+	err = -EINVAL;
+	if (queue->use_bufring) {
+		size_t header_size = sizeof(struct fuse_uring_req_header);
+		u16 buf_index;
+
+		if (!(cmd->flags & IORING_URING_CMD_FIXED))
+			goto error;
+
+		buf_index = READ_ONCE(cmd->sqe->buf_index);
+
+		/* set up the headers */
+		ent->headers_iter = queue->headers_iter;
+		iov_iter_advance(&ent->headers_iter, buf_index * header_size);
+		iov_iter_truncate(&ent->headers_iter, header_size);
+		if (iov_iter_count(&ent->headers_iter) != header_size)
+			goto error;
+
+		atomic_inc(&ring->queue_refs);
+		return ent;
+	}
+
 	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
 	if (err) {
 		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
 				    err);
-		return ERR_PTR(err);
+		goto error;
 	}
 
 	err = -EINVAL;
 	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
 		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
-		return ERR_PTR(err);
+		goto error;
 	}
 
 	payload_size = iov[1].iov_len;
 	if (payload_size < ring->max_payload_sz) {
 		pr_info_ratelimited("Invalid req payload len %zu\n",
 				    payload_size);
-		return ERR_PTR(err);
+		goto error;
 	}
-
-	err = -ENOMEM;
-	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
-	if (!ent)
-		return ERR_PTR(err);
-
-	INIT_LIST_HEAD(&ent->list);
-
-	ent->queue = queue;
 	ent->headers = iov[0].iov_base;
 	ent->payload = iov[1].iov_base;
 
 	atomic_inc(&ring->queue_refs);
 	return ent;
+
+error:
+	kfree(ent);
+	return ERR_PTR(err);
 }
 
 /*
@@ -1137,6 +1458,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags, struct fuse_conn *fc)
 {
 	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	bool use_bufring = READ_ONCE(cmd_req->init.use_bufring);
 	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
@@ -1157,9 +1479,13 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 
 	queue = ring->queues[qid];
 	if (!queue) {
-		queue = fuse_uring_create_queue(ring, qid);
-		if (!queue)
-			return err;
+		queue = fuse_uring_create_queue(cmd, ring, qid, use_bufring,
+						issue_flags);
+		if (IS_ERR(queue))
+			return PTR_ERR(queue);
+	} else {
+		if (queue->use_bufring != use_bufring)
+			return -EINVAL;
 	}
 
 	/*
@@ -1263,7 +1589,8 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 	if (!tw.cancel) {
 		err = fuse_uring_prepare_send(ent, ent->fuse_req);
 		if (err) {
-			if (!fuse_uring_get_next_fuse_req(ent, queue))
+			if (!fuse_uring_get_next_fuse_req(ent, queue,
+							  issue_flags))
 				return;
 			err = 0;
 		}
@@ -1325,14 +1652,20 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 	req->ring_queue = queue;
 	ent = list_first_entry_or_null(&queue->ent_avail_queue,
 				       struct fuse_ring_ent, list);
-	if (ent)
-		fuse_uring_add_req_to_ring_ent(ent, req);
-	else
-		list_add_tail(&req->list, &queue->fuse_req_queue);
-	spin_unlock(&queue->lock);
+	if (ent) {
+		err = fuse_uring_prep_buffer(ent, req, ITER_DEST,
+					     IO_URING_F_UNLOCKED);
+		if (!err) {
+			fuse_uring_add_req_to_ring_ent(ent, req);
+			spin_unlock(&queue->lock);
+			fuse_uring_dispatch_ent(ent);
+			return;
+		}
+		WARN_ON_ONCE(err != -ENOENT);
+	}
 
-	if (ent)
-		fuse_uring_dispatch_ent(ent);
+	list_add_tail(&req->list, &queue->fuse_req_queue);
+	spin_unlock(&queue->lock);
 
 	return;
 
@@ -1350,6 +1683,7 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
 	struct fuse_ring *ring = fc->ring;
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent = NULL;
+	int err;
 
 	queue = fuse_uring_task_to_queue(ring);
 	if (!queue)
@@ -1382,14 +1716,16 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
 	req = list_first_entry_or_null(&queue->fuse_req_queue, struct fuse_req,
 				       list);
 	if (ent && req) {
-		fuse_uring_add_req_to_ring_ent(ent, req);
-		spin_unlock(&queue->lock);
-
-		fuse_uring_dispatch_ent(ent);
-	} else {
-		spin_unlock(&queue->lock);
+		err = fuse_uring_prep_buffer(ent, req, ITER_DEST,
+					     IO_URING_F_UNLOCKED);
+		if (!err) {
+			fuse_uring_add_req_to_ring_ent(ent, req);
+			spin_unlock(&queue->lock);
+			fuse_uring_dispatch_ent(ent);
+			return true;
+		}
 	}
-
+	spin_unlock(&queue->lock);
 	return true;
 }
 
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 51a563922ce1..a8a849c3497e 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -7,6 +7,8 @@
 #ifndef _FS_FUSE_DEV_URING_I_H
 #define _FS_FUSE_DEV_URING_I_H
 
+#include <linux/uio.h>
+
 #include "fuse_i.h"
 
 #ifdef CONFIG_FUSE_IO_URING
@@ -38,9 +40,24 @@ enum fuse_ring_req_state {
 
 /** A fuse ring entry, part of the ring queue */
 struct fuse_ring_ent {
-	/* userspace buffer */
-	struct fuse_uring_req_header __user *headers;
-	void __user *payload;
+	union {
+		/* queue->use_bufring == false */
+		struct {
+			/* userspace buffers */
+			struct fuse_uring_req_header __user *headers;
+			void __user *payload;
+		};
+		/* queue->use_bufring == true */
+		struct {
+			struct iov_iter headers_iter;
+			struct kvec payload_kvec;
+			/*
+			 * This needs to be tracked in order to properly recycle
+			 * the buffer when done with it
+			 */
+			unsigned int ringbuf_buf_id;
+		};
+	};
 
 	/* the ring queue that owns the request */
 	struct fuse_ring_queue *queue;
@@ -99,6 +116,18 @@ struct fuse_ring_queue {
 	unsigned int active_background;
 
 	bool stopped;
+
+	bool ring_killed : 1;
+
+	/* true if kernel-managed buffer ring is used */
+	bool use_bufring: 1;
+
+	/* the below fields are only used if the bufring is used */
+	struct io_ring_ctx *ring_ctx;
+	/* iter for the headers buffer for all the ents */
+	struct iov_iter headers_iter;
+	/* synchronized by the queue lock */
+	struct io_buffer_list *bufring;
 };
 
 /**
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index c13e1f9a2f12..3041177e3dd8 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -240,6 +240,9 @@
  *  - add FUSE_COPY_FILE_RANGE_64
  *  - add struct fuse_copy_file_range_out
  *  - add FUSE_NOTIFY_PRUNE
+ *
+ *  7.46
+ *  - add fuse_uring_cmd_req use_bufring
  */
 
 #ifndef _LINUX_FUSE_H
@@ -1305,7 +1308,14 @@ struct fuse_uring_cmd_req {
 
 	/* queue the command is for (queue index) */
 	uint16_t qid;
-	uint8_t padding[6];
+
+	union {
+		struct {
+			bool use_bufring;
+		} init;
+	};
+
+	uint8_t padding[5];
 };
 
 #endif /* _LINUX_FUSE_H */
-- 
2.47.3


