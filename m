Return-Path: <io-uring+bounces-10250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 151D8C11B52
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8EF314E928D
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612F232E15B;
	Mon, 27 Oct 2025 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GOqPj2cL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B79332E14F
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761604194; cv=none; b=LP425k1xVUEQHumS3YVlZ+OnHBeNKiVENJ/KOcSIR5mcoAkAX8SEqe1gn9SgpUz4wSefeQ1D/2aTGU5HpcF7jTnkHdcs8+D3JIvz1TmcIhpLJ03QollwLApD6zSjgbFS/d67M/Um1SGJsUtbZ1UBWqreMBVLo1rbEoLcS/VYlBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761604194; c=relaxed/simple;
	bh=4fwyzOF8sHT2n+2qvGQr4+u67XqzVXw/NjrRotvSNf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkXx2k9dR+JP1NI7MbDVbuUgQvcbUJn14h3TVlpI3lYlXLNIZEvQmo6DSB+8491CrL4MbYLOhj2BEEdsGbblKpeqz/+hK+uQuIYKljFpoSQvtnFn1VCQNuB6TJoUKzwK8M7Jd73PjNDNUf6iXDbYEWfcooHWVnUqDnt3b7ouK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GOqPj2cL; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a2754a7f6aso6574965b3a.1
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 15:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761604192; x=1762208992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DrBZZg1wHdq2i5ZHEczcCKJGTkH+fPoSv1UJot++t/U=;
        b=GOqPj2cLxOvF0G18pwYQ1+o6sB2tSWFydsR8OdDHsT0uey8GGT5AjUCe4tz32hz9P5
         GNVgbzkCaJy0XvOxmkZJrrC86vrk3l/u964JetC463jMXnn3uiT04XFPayYwBJFbQXpS
         ApS/h7caCwst0czxixq9j53F0C+g8LbgTYSS1ixNt9rPnD65hyWNp33wvHLng1prH+7D
         YjF88K1sDcwLta76iTC3ykPxw0oNbeKYLd4emyYKaIaA9LEsxn8NnvnQSNf5l8zTHX9P
         jHQGwKNh9BzOgaRmEX+Tm7nvlUxzzyczTte79ibhNhUsHmiKy8Ryt9LsBJQ963KPoUs+
         RdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761604192; x=1762208992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DrBZZg1wHdq2i5ZHEczcCKJGTkH+fPoSv1UJot++t/U=;
        b=A+FbbVhVJXuxpZm70Okz6G7+Is5aq6uqV63DKpwg0gIVIPHsPcm9t//QtUW5VNrQei
         m9ZBSxGDRPC80tDM5dMDEBdXX2GBTRcVLe5G9G7KIs33pXaFVIgQbaMACePljiJJMYdO
         ALLBFU7vwNW+AWyaxwPyVUiUYXJHdeOoA8E9CVzk5OKWMNKCCHguomQYk+Qjr/RZlZs3
         z/iKAmZqnt+vEjK0ZJulHjhici1j4nZSyvj1lrjJWWLyPLk3ZfVJYSe2CHttEN7+zuck
         DoAUGiB9ys+7ugVQ4PAjEHxnveDlq0ExbqaByPiuO0xozBptVgHBUtQDBYVDqlfFxL2g
         N02g==
X-Forwarded-Encrypted: i=1; AJvYcCWeAloj038HTh8IJNqYtXELePxIPXBvaADNNISeOelQ4l2iZjMJfFv3RyCwv73jYxOY8t/f6jBt2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSto0JaIWoL/bcE9suWhghyXedyiI7BBd9x2Zix5VGoYrQcYYb
	aYlsp402iBGlonB16zvCueCjtFfl3WM3hpkFFmE2HAm1R34Qpne7R3+W
X-Gm-Gg: ASbGnculS4tIxJaO0y2mDq9+UTi/D0zO93d96M4w0/kyQ0X2lnJ6dW1V17iG9/AGnCQ
	AEpu5PMxCXJoojdAkMmXkbCJ7fCzvTKOjdJXYLye9KcyGcmIMU0XNBUXPJFPVl+mQPcbSAHshrf
	WPX7eHgtgTTmehSah3/gk9zixtIgAKYKnVF5lKNGm3xkRB619jnO+xM2DdmLfNrEPIA8jt3wGyo
	kPzpzX3be68oa6MizE5s0woH5BXX5qRKBfhnqiZpdfpcrjWElpl5vnFc/MI218kNNd3ahDjfXYk
	7W0lTo6g52FzX0p6qmDBLBfFMEMoOsU5Hy/KePQ0ECa4hvHNplE+xCRUINvYbWgkIoo+DWA9hk3
	ksm04znDDysdgoIOqbz/9XtJoIjTxt3TbuvcU9oe2j66curfYac1qtG+sYlPNKqLulJ8TQ6+9Pt
	WCm/MlkgYpbIy9aTbIt+uM7AvwTbM=
X-Google-Smtp-Source: AGHT+IFRi3GHAPVj2U/rXdnyJiI97LCFcBdtqyqZ1hR7JhDVH0pzqyYtyf1UgSUdZB09g/jMqjTymw==
X-Received: by 2002:a05:6a00:1817:b0:7a2:84f3:cefc with SMTP id d2e1a72fcca58-7a441aa6a05mr1804275b3a.0.1761604191800;
        Mon, 27 Oct 2025 15:29:51 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a443b6c371sm504700b3a.69.2025.10.27.15.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 15:29:51 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	xiaobing.li@samsung.com,
	csander@purestorage.com,
	kernel-team@meta.com
Subject: [PATCH v2 8/8] fuse: support io-uring registered buffers
Date: Mon, 27 Oct 2025 15:28:07 -0700
Message-ID: <20251027222808.2332692-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027222808.2332692-1-joannelkoong@gmail.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for io-uring registered buffers for fuse daemons
communicating through the io-uring interface. Daemons may register
buffers ahead of time, which will eliminate the overhead of
pinning/unpinning user pages and translating virtual addresses for every
server-kernel interaction.

To support page-aligned payloads, the buffer is structured such that the
payload is at the front of the buffer and the fuse_uring_req_header is
offset from the end of the buffer.

To be backwards compatible, fuse uring still needs to support non-registered
buffers as well.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev_uring.c   | 200 +++++++++++++++++++++++++++++++++---------
 fs/fuse/dev_uring_i.h |  27 +++++-
 2 files changed, 183 insertions(+), 44 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index c6b22b14b354..f501bc81f331 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -580,6 +580,22 @@ static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
 	return err;
 }
 
+static void *get_kernel_ring_header(struct fuse_ring_ent *ent,
+				    enum fuse_uring_header_type type)
+{
+	switch (type) {
+	case FUSE_URING_HEADER_IN_OUT:
+		return &ent->headers->in_out;
+	case FUSE_URING_HEADER_OP:
+		return &ent->headers->op_in;
+	case FUSE_URING_HEADER_RING_ENT:
+		return &ent->headers->ring_ent_in_out;
+	}
+
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
 static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
 					 enum fuse_uring_header_type type)
 {
@@ -600,16 +616,22 @@ static int copy_header_to_ring(struct fuse_ring_ent *ent,
 			       enum fuse_uring_header_type type,
 			       const void *header, size_t header_size)
 {
-	void __user *ring = get_user_ring_header(ent, type);
+	if (ent->fixed_buffer) {
+		void *ring = get_kernel_ring_header(ent, type);
 
-	if (!ring)
-		return -EINVAL;
+		if (!ring)
+			return -EINVAL;
+		memcpy(ring, header, header_size);
+	} else {
+		void __user *ring = get_user_ring_header(ent, type);
 
-	if (copy_to_user(ring, header, header_size)) {
-		pr_info_ratelimited("Copying header to ring failed.\n");
-		return -EFAULT;
+		if (!ring)
+			return -EINVAL;
+		if (copy_to_user(ring, header, header_size)) {
+			pr_info_ratelimited("Copying header to ring failed.\n");
+			return -EFAULT;
+		}
 	}
-
 	return 0;
 }
 
@@ -617,14 +639,21 @@ static int copy_header_from_ring(struct fuse_ring_ent *ent,
 				 enum fuse_uring_header_type type,
 				 void *header, size_t header_size)
 {
-	const void __user *ring = get_user_ring_header(ent, type);
+	if (ent->fixed_buffer) {
+		const void *ring = get_kernel_ring_header(ent, type);
 
-	if (!ring)
-		return -EINVAL;
+		if (!ring)
+			return -EINVAL;
+		memcpy(header, ring, header_size);
+	} else {
+		const void __user *ring = get_user_ring_header(ent, type);
 
-	if (copy_from_user(header, ring, header_size)) {
-		pr_info_ratelimited("Copying header from ring failed.\n");
-		return -EFAULT;
+		if (!ring)
+			return -EINVAL;
+		if (copy_from_user(header, ring, header_size)) {
+			pr_info_ratelimited("Copying header from ring failed.\n");
+			return -EFAULT;
+		}
 	}
 
 	return 0;
@@ -637,11 +666,15 @@ static int setup_fuse_copy_state(struct fuse_ring *ring, struct fuse_req *req,
 {
 	int err;
 
-	err = import_ubuf(rw, ent->user_payload, ring->max_payload_sz,
-			  iter);
-	if (err) {
-		pr_info_ratelimited("fuse: Import of user buffer failed\n");
-		return err;
+	if (ent->fixed_buffer) {
+		*iter = ent->payload_iter;
+	} else {
+		err = import_ubuf(rw, ent->user_payload, ring->max_payload_sz,
+				  iter);
+		if (err) {
+			pr_info_ratelimited("fuse: Import of user buffer failed\n");
+			return err;
+		}
 	}
 
 	fuse_copy_init(cs, rw == ITER_DEST, iter);
@@ -754,6 +787,62 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 				   sizeof(req->in.h));
 }
 
+/*
+ * Prepare fixed buffer for access. Sets up the payload iter and kmaps the
+ * header.
+ *
+ * Callers must call fuse_uring_unmap_buffer() in the same scope to release the
+ * header mapping.
+ *
+ * For non-fixed buffers, this is a no-op.
+ */
+static int fuse_uring_map_buffer(struct fuse_ring_ent *ent)
+{
+	size_t header_size = sizeof(struct fuse_uring_req_header);
+	struct iov_iter iter;
+	struct page *header_page;
+	size_t count, start;
+	ssize_t copied;
+	int err;
+
+	if (!ent->fixed_buffer)
+		return 0;
+
+	err = io_uring_cmd_import_fixed_full(ITER_DEST, &iter, ent->cmd, 0);
+	if (err)
+		return err;
+
+	count = iov_iter_count(&iter);
+	if (count < header_size || count & (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	/* Adjust the payload iter to protect the header from any overwrites */
+	ent->payload_iter = iter;
+	iov_iter_truncate(&ent->payload_iter, count - header_size);
+
+	/* Set up the headers */
+	iov_iter_advance(&iter, count - header_size);
+	copied = iov_iter_get_pages2(&iter, &header_page, header_size, 1, &start);
+	if (copied < header_size)
+		return -EFAULT;
+	ent->headers = kmap_local_page(header_page) + start;
+
+	/*
+	 * We can release the acquired reference on the header page immediately
+	 * since the page is pinned and io_uring_cmd_import_fixed_full()
+	 * prevents it from being unpinned while we are using it.
+	 */
+	put_page(header_page);
+
+	return 0;
+}
+
+static void fuse_uring_unmap_buffer(struct fuse_ring_ent *ent)
+{
+	if (ent->fixed_buffer)
+		kunmap_local(ent->headers);
+}
+
 static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
 				   struct fuse_req *req)
 {
@@ -932,6 +1021,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	unsigned int qid = READ_ONCE(cmd_req->qid);
 	struct fuse_pqueue *fpq;
 	struct fuse_req *req;
+	bool next_req;
 
 	err = -ENOTCONN;
 	if (!ring)
@@ -982,6 +1072,13 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 
 	/* without the queue lock, as other locks are taken */
 	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
+
+	err = fuse_uring_map_buffer(ent);
+	if (err) {
+		fuse_uring_req_end(ent, req, err);
+		return err;
+	}
+
 	fuse_uring_commit(ent, req, issue_flags);
 
 	/*
@@ -990,7 +1087,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	 * and fetching is done in one step vs legacy fuse, which has separated
 	 * read (fetch request) and write (commit result).
 	 */
-	if (fuse_uring_get_next_fuse_req(ent, queue))
+	next_req = fuse_uring_get_next_fuse_req(ent, queue);
+	fuse_uring_unmap_buffer(ent);
+	if (next_req)
 		fuse_uring_send(ent, cmd, 0, issue_flags);
 	return 0;
 }
@@ -1086,39 +1185,49 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
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
+	if (READ_ONCE(cmd->sqe->uring_cmd_flags) & IORING_URING_CMD_FIXED) {
+		ent->fixed_buffer = true;
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
 	ent->user_headers = iov[0].iov_base;
 	ent->user_payload = iov[1].iov_base;
 
 	atomic_inc(&ring->queue_refs);
 	return ent;
+
+error:
+	kfree(ent);
+	return ERR_PTR(err);
 }
 
 /*
@@ -1249,20 +1358,29 @@ static void fuse_uring_send_in_task(struct io_uring_cmd *cmd,
 {
 	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
 	struct fuse_ring_queue *queue = ent->queue;
+	bool send_ent = true;
 	int err;
 
-	if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
-		err = fuse_uring_prepare_send(ent, ent->fuse_req);
-		if (err) {
-			if (!fuse_uring_get_next_fuse_req(ent, queue))
-				return;
-			err = 0;
-		}
-	} else {
-		err = -ECANCELED;
+	if (issue_flags & IO_URING_F_TASK_DEAD) {
+		fuse_uring_send(ent, cmd, -ECANCELED, issue_flags);
+		return;
+	}
+
+	err = fuse_uring_map_buffer(ent);
+	if (err) {
+		fuse_uring_req_end(ent, ent->fuse_req, err);
+		return;
+	}
+
+	err = fuse_uring_prepare_send(ent, ent->fuse_req);
+	if (err) {
+		send_ent = fuse_uring_get_next_fuse_req(ent, queue);
+		err = 0;
 	}
+	fuse_uring_unmap_buffer(ent);
 
-	fuse_uring_send(ent, cmd, err, issue_flags);
+	if (send_ent)
+		fuse_uring_send(ent, cmd, err, issue_flags);
 }
 
 static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 381fd0b8156a..fe14acccd6a6 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -7,6 +7,7 @@
 #ifndef _FS_FUSE_DEV_URING_I_H
 #define _FS_FUSE_DEV_URING_I_H
 
+#include <linux/uio.h>
 #include "fuse_i.h"
 
 #ifdef CONFIG_FUSE_IO_URING
@@ -38,9 +39,29 @@ enum fuse_ring_req_state {
 
 /** A fuse ring entry, part of the ring queue */
 struct fuse_ring_ent {
-	/* userspace buffer */
-	struct fuse_uring_req_header __user *user_headers;
-	void __user *user_payload;
+	/*
+	 * If true, the buffer was pre-registered by the daemon and the
+	 * pages backing it are pinned in kernel memory. The fixed buffer layout
+	 * is: [payload][header at end]. Use payload_iter and headers for
+	 * copying to/from the ring.
+	 *
+	 * Otherwise, use user_headers and user_payload which point to userspace
+	 * addresses representing the ring memory.
+	 */
+	bool fixed_buffer;
+
+	union {
+		/* fixed_buffer == false */
+		struct {
+			struct fuse_uring_req_header __user *user_headers;
+			void __user *user_payload;
+		};
+		/* fixed_buffer == true */
+		struct {
+			struct fuse_uring_req_header *headers;
+			struct iov_iter payload_iter;
+		};
+	};
 
 	/* the ring queue that owns the request */
 	struct fuse_ring_queue *queue;
-- 
2.47.3


