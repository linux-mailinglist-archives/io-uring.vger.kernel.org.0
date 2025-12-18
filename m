Return-Path: <io-uring+bounces-11199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 12385CCAF68
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B2A913020CCE
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8128334C20;
	Thu, 18 Dec 2025 08:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CeN9OjV2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33E5334C1C
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046908; cv=none; b=gHeZ8fMpWkiP8G0c4QmeUpZLbbVQM15k8D+mGLccaRDbxp2r5Sl9cKdG6Ng7lLZ2oBxaS8r7tqTt/5diaZi88q3Qf/wh6fG3Bgxf8z/mJHTALmuMJhbazisBmswieJLdQ7/D+7/DEHD2uLjKuUQxeYL0X2QVW3ZXbK60H9lAlp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046908; c=relaxed/simple;
	bh=SikUSmV29LKvUvpAGJ8smlMC3OhoyOKNc/ZjN4HxLSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqQVkrRzaoLM4WVH+741B7b9E8o5cp3BRlg8vAGPmNDDfZmjT8PYT7/eBRgnXNBYBuHlL0NsrofVjuvCRk5sOoBAu6Na1stbATz9muyYUngOFYEEz7jg+eUXG+Nfsqlyu2Eh0RmQ8G61nifnUIbn8xhyYuCLaaklP6FCI/fxyVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CeN9OjV2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a07fac8aa1so3936695ad.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046905; x=1766651705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRMOKfUUW0I13bgrd/TmTSLqICPtBxsIVfSHspVuA0o=;
        b=CeN9OjV2/SRxVwQEsgLECDKznSBhlTDBjYTmn9yYn3Mmb8DMa88pzNPQAOlb/fd5dO
         foMbopKtrRD9IoKsBsQeOlF927dSwSzaMQxDupUmNMSvtuYK28C4jjv/M1DOpT5CB5kn
         YOFYKmhQMEGW5sfcdAT7takYYSXz8b3mCg/l0b2zkyqWGPmKLgKuHpE0wYr6kFeSlh94
         44z/4lJ2WKt7+Dl8D7ehEeZ2NqJGXKfGuAZwjNvR2767BL/wOkIdvcYUw9vLPvEvNTrg
         D5A3WSHN+nlymwDkXk1q6ZGGFluhARDu+5PzUso+gIaqdDF9p7IlHJ+iVVGZs8l6FJ+v
         mlhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046905; x=1766651705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pRMOKfUUW0I13bgrd/TmTSLqICPtBxsIVfSHspVuA0o=;
        b=X/6NVS523D0ho39HV1+g7fLngRN2LMBBSYOd4nrMlSWdcpkdO85CqfeYjDtMY+DWtf
         +gErvQpNXdbZhc2Rm3sVHtebk9v7pgVHrIogpNRhTmlYoo5aITyw2ZsEC/xGgU4rkKrx
         +yphpkJdchimOgC5ajeNphBXV5gltNTWXh1hRWieX/1wZRe7R2AlNJiDIMRcbwUeKX+y
         26VhNI5jneD1YoASggTW3gqyGUFa/P3DT6pll0JtYtfkGVszjbmoQZSTxS4tTFmLFFe2
         G4IyTao06bapBmZNQIFvtOGnZ+nSUbn8AntsVa8xPbxN46fCCEVW2pVCggSE9159o4gH
         nEmA==
X-Forwarded-Encrypted: i=1; AJvYcCW07muy4lhKyKa+nVczJxLuT1BVxUJmRPEVB7o9dSyR2ZIBR+uLze8i20KZrVfyQvs9PDv5h3RDgg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3qLK0S2twiNz8cjXlPRozGqjcMDO4nwVyKMH8vOKLlnOwgjYd
	ELs0mve0Hoxqg91zTwmie0GekPVuVRSv8txZB23AmyUiIpl0r5L93Y9kEqLPva7z4fw=
X-Gm-Gg: AY/fxX6mqdNadxKVF7THrE3dG14afSvba0VlJvbx5jbvtZgfk3zTSubcZMnAi/iIT4C
	Sl4PUoSBnkLqdNm0gdOgtKKLVXJXbncVMLbCfh+Y1M7NTWAJ6QXWTdE37ZIHTCp6oxHyzH7QZwC
	a5al0vntIjti2EAODFfeQxKUuKyNrL1kV9LZMqyp4Zi9OD8A3uDliKXkdn/Yltpuwf/IXYQwzgt
	xvIQf2XnlRc3latJrcE4Lp9QFn+EJ+OlQYJ3AJdpymos4uDbGUigYNVOsEW8k5vueOnPJku3zSx
	rNQA/xb+1AnMlnTrAhDLHXhSrz7zJqw7s4zrdpYx47YgfmL+GnqMslbfRjL2OWiq8JZh9T6/jMD
	CHXzUVm5dakEGBVEiTtC+M3mHgI9WdmrtQYbAIuC3ATVzVDjjCY+65fHhUx6PNN6fR7bh6OOEWL
	9TAAH3jbRQ2Y6yiRn9TXVNjx+7X43W
X-Google-Smtp-Source: AGHT+IERumgYj7JUPCCzSjtlGIWege6b11BZWaY/b6UctaQA65sM6cjT9PNAUT/SgOiB7D6nbnv/wQ==
X-Received: by 2002:a17:902:da89:b0:2a1:e19:ff0 with SMTP id d9443c01a7336-2a10e191112mr128985495ad.39.1766046904703;
        Thu, 18 Dec 2025 00:35:04 -0800 (PST)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d0888e22sm17662015ad.30.2025.12.18.00.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:35:04 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 19/25] fuse: add io-uring kernel-managed buffer ring
Date: Thu, 18 Dec 2025 00:33:13 -0800
Message-ID: <20251218083319.3485503-20-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
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
will be pinned for the lifetime of the connection.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev_uring.c       | 422 ++++++++++++++++++++++++++++++++------
 fs/fuse/dev_uring_i.h     |  30 ++-
 include/uapi/linux/fuse.h |  12 +-
 3 files changed, 395 insertions(+), 69 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b57871f92d08..d028cdd57f45 100644
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
+#define FUSE_URING_FIXED_HEADERS_OFFSET 0
 
 bool fuse_uring_enabled(void)
 {
@@ -276,20 +280,46 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 	return res;
 }
 
-static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
-						       int qid)
+static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
+				     struct fuse_ring_queue *queue,
+				     unsigned int issue_flags)
+{
+	int err;
+
+	err = io_uring_cmd_buf_ring_pin(cmd, FUSE_URING_RINGBUF_GROUP,
+					issue_flags, &queue->bufring);
+	if (err)
+		return err;
+
+	if (!io_uring_cmd_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP,
+					issue_flags)) {
+		io_uring_cmd_buf_ring_unpin(cmd,
+					    FUSE_URING_RINGBUF_GROUP,
+					    issue_flags);
+		return -EINVAL;
+	}
+
+	queue->use_bufring = true;
+
+	return 0;
+}
+
+static struct fuse_ring_queue *
+fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
+			int qid, bool use_bufring, unsigned int issue_flags)
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
 	struct list_head *pq;
+	int err;
 
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
@@ -307,6 +337,15 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
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
@@ -584,6 +623,35 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
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
@@ -605,17 +673,38 @@ static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
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
+
+		if (copy_to_iter(header, header_size, &iter) != header_size)
+			err = -EFAULT;
+	} else {
+		void __user *ring = get_user_ring_header(ent, type);
+
+		if (!ring) {
+			err = -EINVAL;
+			goto done;
+		}
 
-	if (copy_to_user(ring, header, header_size)) {
-		pr_info_ratelimited("Copying header to ring failed.\n");
-		return -EFAULT;
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
@@ -623,17 +712,38 @@ static __always_inline int copy_header_from_ring(struct fuse_ring_ent *ent,
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
+
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
 
-	if (copy_from_user(header, ring, header_size)) {
-		pr_info_ratelimited("Copying header from ring failed.\n");
-		return -EFAULT;
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
@@ -643,14 +753,23 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
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
 
@@ -762,6 +881,103 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
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
+static void fuse_uring_clean_up_buffer(struct fuse_ring_ent *ent,
+				       unsigned int issue_flags)
+	__must_hold(&queue->lock)
+{
+	struct kvec *kvec = &ent->payload_kvec;
+
+	lockdep_assert_held(&ent->queue->lock);
+
+	if (!ent->queue->use_bufring || !kvec->iov_base)
+		return;
+
+	WARN_ON_ONCE(io_uring_cmd_kmbuffer_recycle(ent->cmd,
+						   FUSE_URING_RINGBUF_GROUP,
+						   (u64)kvec->iov_base,
+						   kvec->iov_len,
+						   ent->ringbuf_buf_id,
+						   issue_flags));
+
+	memset(kvec, 0, sizeof(*kvec));
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
+		fuse_uring_clean_up_buffer(ent, issue_flags);
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
@@ -824,21 +1040,29 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
 }
 
 /* Fetch the next fuse request if available */
-static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
+static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent,
+						  unsigned int issue_flags)
 	__must_hold(&queue->lock)
 {
 	struct fuse_req *req;
 	struct fuse_ring_queue *queue = ent->queue;
 	struct list_head *req_queue = &queue->fuse_req_queue;
+	int err;
 
 	lockdep_assert_held(&queue->lock);
 
 	/* get and assign the next entry while it is still holding the lock */
 	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
-	if (req)
-		fuse_uring_add_req_to_ring_ent(ent, req);
+	if (req) {
+		err = fuse_uring_next_req_update_buffer(ent, req, issue_flags);
+		if (!err) {
+			fuse_uring_add_req_to_ring_ent(ent, req);
+			return req;
+		}
+	}
 
-	return req;
+	fuse_uring_clean_up_buffer(ent, issue_flags);
+	return NULL;
 }
 
 /*
@@ -878,7 +1102,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
  * Else, there is no next fuse request and this returns false.
  */
 static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
-					 struct fuse_ring_queue *queue)
+					 struct fuse_ring_queue *queue,
+					 unsigned int issue_flags)
 {
 	int err;
 	struct fuse_req *req;
@@ -886,7 +1111,7 @@ static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
 retry:
 	spin_lock(&queue->lock);
 	fuse_uring_ent_avail(ent, queue);
-	req = fuse_uring_ent_assign_req(ent);
+	req = fuse_uring_ent_assign_req(ent, issue_flags);
 	spin_unlock(&queue->lock);
 
 	if (req) {
@@ -927,6 +1152,38 @@ static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
 	io_uring_cmd_done(cmd, ret, issue_flags);
 }
 
+static void fuse_uring_headers_cleanup(struct fuse_ring_ent *ent,
+				       unsigned int issue_flags)
+{
+	if (!ent->queue->use_bufring)
+		return;
+
+	WARN_ON_ONCE(io_uring_cmd_fixed_index_put(ent->cmd,
+						  FUSE_URING_FIXED_HEADERS_OFFSET,
+						  issue_flags));
+}
+
+static int fuse_uring_headers_prep(struct fuse_ring_ent *ent, unsigned int dir,
+				   unsigned int issue_flags)
+{
+	size_t header_size = sizeof(struct fuse_uring_req_header);
+	struct io_uring_cmd *cmd = ent->cmd;
+	unsigned int offset;
+	int err;
+
+	if (!ent->queue->use_bufring)
+		return 0;
+
+	offset = ent->fixed_buf_id * header_size;
+
+	err = io_uring_cmd_fixed_index_get(cmd, FUSE_URING_FIXED_HEADERS_OFFSET,
+					   offset, header_size, dir,
+					   &ent->headers_iter, issue_flags);
+
+	WARN_ON_ONCE(err);
+	return err;
+}
+
 /* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
 static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 				   struct fuse_conn *fc)
@@ -940,6 +1197,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	unsigned int qid = READ_ONCE(cmd_req->qid);
 	struct fuse_pqueue *fpq;
 	struct fuse_req *req;
+	bool send;
 
 	err = -ENOTCONN;
 	if (!ring)
@@ -990,7 +1248,12 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 
 	/* without the queue lock, as other locks are taken */
 	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
-	fuse_uring_commit(ent, req, issue_flags);
+
+	err = fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
+	if (err)
+		fuse_uring_req_end(ent, req, err);
+	else
+		fuse_uring_commit(ent, req, issue_flags);
 
 	/*
 	 * Fetching the next request is absolutely required as queued
@@ -998,7 +1261,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	 * and fetching is done in one step vs legacy fuse, which has separated
 	 * read (fetch request) and write (commit result).
 	 */
-	if (fuse_uring_get_next_fuse_req(ent, queue))
+	send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
+	fuse_uring_headers_cleanup(ent, issue_flags);
+	if (send)
 		fuse_uring_send(ent, cmd, 0, issue_flags);
 	return 0;
 }
@@ -1094,39 +1359,48 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 	struct iovec iov[FUSE_URING_IOV_SEGS];
 	int err;
 
+	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
+	if (!ent)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&ent->list);
+
+	ent->queue = queue;
+
+	if (queue->use_bufring) {
+		ent->fixed_buf_id = READ_ONCE(cmd->sqe->buf_index);
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
@@ -1137,6 +1411,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags, struct fuse_conn *fc)
 {
 	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	bool use_bufring = READ_ONCE(cmd_req->init.use_bufring);
 	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
@@ -1157,9 +1432,13 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 
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
@@ -1258,15 +1537,19 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
 	struct fuse_ring_queue *queue = ent->queue;
+	bool send = true;
 	int err;
 
 	if (!tw.cancel) {
-		err = fuse_uring_prepare_send(ent, ent->fuse_req);
-		if (err) {
-			if (!fuse_uring_get_next_fuse_req(ent, queue))
-				return;
-			err = 0;
-		}
+		if (fuse_uring_headers_prep(ent, ITER_DEST, issue_flags))
+			return;
+
+		if (fuse_uring_prepare_send(ent, ent->fuse_req))
+			send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
+		fuse_uring_headers_cleanup(ent, issue_flags);
+		if (!send)
+			return;
+		err = 0;
 	} else {
 		err = -ECANCELED;
 	}
@@ -1325,14 +1608,20 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
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
 
@@ -1350,6 +1639,7 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
 	struct fuse_ring *ring = fc->ring;
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent = NULL;
+	int err;
 
 	queue = fuse_uring_task_to_queue(ring);
 	if (!queue)
@@ -1382,14 +1672,16 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
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
index 51a563922ce1..eff14557066d 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -7,6 +7,8 @@
 #ifndef _FS_FUSE_DEV_URING_I_H
 #define _FS_FUSE_DEV_URING_I_H
 
+#include <linux/uio.h>
+
 #include "fuse_i.h"
 
 #ifdef CONFIG_FUSE_IO_URING
@@ -38,9 +40,25 @@ enum fuse_ring_req_state {
 
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
+			unsigned int fixed_buf_id;
+		};
+	};
 
 	/* the ring queue that owns the request */
 	struct fuse_ring_queue *queue;
@@ -99,6 +117,12 @@ struct fuse_ring_queue {
 	unsigned int active_background;
 
 	bool stopped;
+
+	/* true if kernel-managed buffer ring is used */
+	bool use_bufring: 1;
+
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


