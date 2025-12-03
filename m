Return-Path: <io-uring+bounces-10924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 687D7C9D71E
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 896F14E4DC4
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CBB233711;
	Wed,  3 Dec 2025 00:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEtbsUNO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDC126B741
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722240; cv=none; b=QUcOM9o4bwGx5CAbuxX5dtRdNZNsQcBlS5vr6/lOH5CIMvXDjZtxz0io/KAWJGO45zF4UOuuKsQeXhSdSJyD748SAKGd8MSFFw7iOZ8UVvnfROeBdJstUJvlrAwCiD0HJoDclK3yxlnSP1P9yY3UewANMSs+lwyrnfsJhPML9cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722240; c=relaxed/simple;
	bh=DMkjqR8shvW4bN3ilg7Dok7s31aQcG9DWGsHnHxe8Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emExKwsiWbhQxA9gfae4HMjseiA0m33d0xxJy522EXE7JjOsRix5ng0NL291cOF3bJea1fM38yuqrnP9O5CmwyILl+AXAskzBDWKktlSWeGw6AeOBALB7ZSKe9FZXmNf1XVq1twuTEwdo073o1pLDEbpHRsvHbtgDVwtgr4NtXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEtbsUNO; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso4839236b3a.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722238; x=1765327038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrfgkvfzkdBGhrJnsYRFdO12TDYigZVsaV1W6cPbsC8=;
        b=EEtbsUNOD7kk03Qbldu8V889zbKNrmncoG1orLyysqAszOEJybmEEChsiLQvndU7Xc
         ZFth+ymIw0j1eyipi9s6B74WQa71WH6Gyon79bP44X8/rAfaryE/dAi4W7t1NUi5E+Z1
         bYpK1llhMmh74SflhOq1vwnrvdEttZh2jrABRuh47GXvu8dOHH0JBgSGZaNYs8U5StgT
         Zu8auz4HGkB9bmidrzg64+jIxfCvyImW9A0/Tq6vJmf3FqpTcO+vABWwxYh8pGR0DX3K
         dKZN9C44WqImqEoZc1Zu/OtO1V607DkxhyapGq6LOfFF0lUnayyJf4Tt1Bd35Tn2Achh
         9mtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722238; x=1765327038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hrfgkvfzkdBGhrJnsYRFdO12TDYigZVsaV1W6cPbsC8=;
        b=o6mGVdEpUro2TuGnQtF217coxhVcyLJVJLC7gW+DXrbxASj22wp0bVELhDYw9YKzKA
         TWMmkxlFA0AMZlecGPtif2FuHPVKJIMcn23K2DyMWUdyIy/2ycb4il4+2JAKNYxn0983
         DeM8HMTheaoIGqulsT8dfH5Q8kcAlWL5Df+z6SGJbkN71SWBgUHVBuPELsXIx4HSE8Uk
         oYyis8Moi5TOrUCEsUswWrFMr1ICx8Tcsrw3a9pRY8dlSFF/kZLYDxyGqvFV2/N0hg8j
         n8niuD2mEZdcmFFs+HtIHbfkRyaaimi+omR8PQNUDiz9t8aWGgZB/l+O9KDzSRFaLb4j
         W7Rw==
X-Forwarded-Encrypted: i=1; AJvYcCVvz1M+0p8PnujULdkFbxvg3BPCYCkRgRxQrrudub5geFHkhcIi5cTw7e612fUDxP9D0dQN6oT2NQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEVkqVMZkeXnOjdQfXa/bXbq9oCg43B4Q6gCWw90NS545Ui6RE
	7vM9J21ZEz+QmN6fyruYXeprPcER+10qiFMkQkX6dMEoane0sLrk3e2q
X-Gm-Gg: ASbGncsytGACSNnnZx4sZRz4npZ87jke2DuBbFgFckkmX58MgoAdNcweUEfo2Mj9gDW
	XjviUQkaQkgGYCrZeJ5jMp9JO6hwljB+7cgqhSnNLNc8/FX3+FPRVwIIoDRqgwA3BH4bkEcHWxt
	W22uKD0vXE6Mwz+EMEY/BBk2Tk/u5wJ8YL5BWBQf5/LOCe/SHD8kSDVphaeqFH8BEoWkQv46kCj
	0y6YdT/Q0tEzwUQ8Qc0BA2FDktg+5mFDR0VN+dD3ZWUkAfhZOHq+p/aRJigKgh7OpxrAofFksnF
	Nz0BUZW7d6QI2lQd7KVQ7yRPMeBQGYPSN0t33h7Xjkr+whl3xkaWaDmwt0vlX/W2mcAkwdOHl4b
	OWuGtD3V7WbMpOQIL2qPApwAt54UW9gZYa69HtC8lLE4GEmYzsTB47RYU8kCQVX417hAFPxRmxD
	jEwWExGYsQV7zSf+DvaQ==
X-Google-Smtp-Source: AGHT+IHyHJyMTrVfiedRI6q4sqOspdlimaBR+kIYr+IMyJXJwwtVuOw7z1w4YsgrbQa154PCY8/PsA==
X-Received: by 2002:a05:6a00:929d:b0:7a2:6eb3:71ee with SMTP id d2e1a72fcca58-7e009c0d35amr466587b3a.9.1764722238017;
        Tue, 02 Dec 2025 16:37:18 -0800 (PST)
Received: from localhost ([2a03:2880:ff:44::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d150b68a98sm18102317b3a.5.2025.12.02.16.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:37:17 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 29/30] fuse: add zero-copy over io-uring
Date: Tue,  2 Dec 2025 16:35:24 -0800
Message-ID: <20251203003526.2889477-30-joannelkoong@gmail.com>
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

Implement zero-copy data transfer for fuse over io-uring, eliminating
memory copies between kernel and userspace for read/write operations.

This is only allowed on privileged servers and requires the server to
preregister the following:
a) a sparse buffer corresponding to the queue depth
b) a fixed buffer at index queue_depth (the tail of the buffers)
c) a kernel-managed buffer ring

The sparse buffer is where the client's pages reside. The fixed buffer
at the tail is where the headers (struct fuse_uring_req_header) are
placed. The kernel-managed buffer ring is where any non-zero-copied args
reside (eg out headers).

Benchmarks with bs=1M showed approximately the following differences in
throughput:
direct randreads: ~20% increase (~2100 MB/s -> ~2600 MB/s)
buffered randreads: ~25% increase (~1900 MB/s -> 2400 MB/s)
direct randwrites: no difference (~750 MB/s)
buffered randwrites: ~10% increase (950 MB/s -> 1050 MB/s)

The benchmark was run using fio on the passthrough_hp server:
fio --name=test_run --ioengine=sync --rw=rand{read,write} --bs=1M
--size=1G --numjobs=2 --ramp_time=30 --group_reporting=1

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c             |   7 +-
 fs/fuse/dev_uring.c       | 191 ++++++++++++++++++++++++++++++++------
 fs/fuse/dev_uring_i.h     |  12 +++
 fs/fuse/fuse_dev_i.h      |   1 +
 include/uapi/linux/fuse.h |   5 +-
 5 files changed, 187 insertions(+), 29 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 7d39c80da554..0e9c9d006118 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1229,8 +1229,11 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
 
 	for (i = 0; !err && i < numargs; i++)  {
 		struct fuse_arg *arg = &args[i];
-		if (i == numargs - 1 && argpages)
-			err = fuse_copy_folios(cs, arg->size, zeroing);
+		if (i == numargs - 1 && argpages) {
+			if (cs->skip_folio_copy)
+				return 0;
+			return fuse_copy_folios(cs, arg->size, zeroing);
+		}
 		else
 			err = fuse_copy_one(cs, arg->value, arg->size);
 	}
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 3600892ba837..02846203960f 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -89,12 +89,19 @@ static void fuse_uring_flush_bg(struct fuse_ring_queue *queue)
 	}
 }
 
+static bool can_zero_copy_req(struct fuse_ring_ent *ent, struct fuse_req *req)
+{
+	return ent->queue->use_zero_copy &&
+		(req->args->in_pages || req->args->out_pages);
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ent, struct fuse_req *req,
-			       int error)
+			       int error, unsigned issue_flags)
 {
 	struct fuse_ring_queue *queue = ent->queue;
 	struct fuse_ring *ring = queue->ring;
 	struct fuse_conn *fc = ring->fc;
+	int err;
 
 	lockdep_assert_not_held(&queue->lock);
 	spin_lock(&queue->lock);
@@ -109,6 +116,13 @@ static void fuse_uring_req_end(struct fuse_ring_ent *ent, struct fuse_req *req,
 
 	spin_unlock(&queue->lock);
 
+	if (ent->zero_copied) {
+		err = io_buffer_unregister(ent->queue->ring_ctx,
+					   ent->zero_copy_buf_id, issue_flags);
+		WARN_ON_ONCE(err);
+		ent->zero_copied = false;
+	}
+
 	if (error)
 		req->out.h.error = error;
 
@@ -198,6 +212,31 @@ bool fuse_uring_request_expired(struct fuse_conn *fc)
 	return false;
 }
 
+static void fuse_uring_zero_copy_teardown(struct fuse_ring_ent *ent,
+					  unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	spin_lock(&queue->lock);
+
+	if (queue->ring_killed) {
+		spin_unlock(&queue->lock);
+		return;
+	}
+
+	if (!percpu_ref_tryget_live(&queue->ring_ctx->refs)) {
+		spin_unlock(&queue->lock);
+		return;
+	}
+
+	spin_unlock(&queue->lock);
+
+	io_buffer_unregister(queue->ring_ctx, ent->zero_copy_buf_id,
+			     issue_flags);
+
+	percpu_ref_put(&queue->ring_ctx->refs);
+}
+
 static void fuse_uring_teardown_buffers(struct fuse_ring_queue *queue,
 					unsigned int issue_flags)
 {
@@ -322,9 +361,12 @@ static void io_ring_killed(void *priv)
 
 static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
 				     struct fuse_ring_queue *queue,
+				     bool zero_copy,
 				     unsigned int issue_flags)
 {
 	struct io_ring_ctx *ring_ctx = cmd_to_io_kiocb(cmd)->ctx;
+	const struct fuse_uring_cmd_req *cmd_req;
+	u16 headers_index;
 	int err;
 
 	err = io_uring_buf_ring_pin(ring_ctx, FUSE_URING_RINGBUF_GROUP,
@@ -342,8 +384,24 @@ static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
 	if (err)
 		goto error;
 
-	err = io_uring_cmd_import_fixed_index(cmd,
-					      FUSE_URING_FIXED_HEADERS_INDEX,
+	if (zero_copy) {
+		err = -EINVAL;
+		if (!capable(CAP_SYS_ADMIN))
+			goto error;
+
+		queue->use_zero_copy = true;
+
+		cmd_req = io_uring_sqe_cmd(cmd->sqe);
+		queue->depth = READ_ONCE(cmd_req->init.queue_depth);
+		if (!queue->depth)
+			goto error;
+
+		headers_index = queue->depth;
+	} else {
+		headers_index = FUSE_URING_FIXED_HEADERS_INDEX;
+	}
+
+	err = io_uring_cmd_import_fixed_index(cmd, headers_index,
 					      ITER_DEST, &queue->headers_iter,
 					      issue_flags);
 	if (err) {
@@ -367,7 +425,8 @@ static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
 
 static struct fuse_ring_queue *
 fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
-			int qid, bool use_bufring, unsigned int issue_flags)
+			int qid, bool use_bufring, bool zero_copy,
+			unsigned int issue_flags)
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
@@ -399,12 +458,13 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
 	fuse_pqueue_init(&queue->fpq);
 
 	if (use_bufring) {
-		err = fuse_uring_buf_ring_setup(cmd, queue, issue_flags);
-		if (err) {
-			kfree(pq);
-			kfree(queue);
-			return ERR_PTR(err);
-		}
+		err = fuse_uring_buf_ring_setup(cmd, queue, zero_copy,
+						issue_flags);
+		if (err)
+			goto cleanup;
+	} else if (zero_copy) {
+		err = -EINVAL;
+		goto cleanup;
 	}
 
 	spin_lock(&fc->lock);
@@ -422,6 +482,11 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
 	spin_unlock(&fc->lock);
 
 	return queue;
+
+cleanup:
+	kfree(pq);
+	kfree(queue);
+	return ERR_PTR(err);
 }
 
 static void fuse_uring_stop_fuse_req_end(struct fuse_req *req)
@@ -466,6 +531,9 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 
 	if (req)
 		fuse_uring_stop_fuse_req_end(req);
+
+	if (ent->zero_copied)
+		fuse_uring_zero_copy_teardown(ent, IO_URING_F_UNLOCKED);
 }
 
 static void fuse_uring_stop_list_entries(struct list_head *head,
@@ -831,6 +899,7 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
 		cs->is_kaddr = true;
 		cs->len = ent->payload_kvec.iov_len;
 		cs->kaddr = ent->payload_kvec.iov_base;
+		cs->skip_folio_copy = can_zero_copy_req(ent, req);
 	}
 
 	cs->is_uring = true;
@@ -863,11 +932,56 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	return err;
 }
 
+
+static int fuse_uring_set_up_zero_copy(struct fuse_ring_ent *ent,
+				       struct fuse_req *req,
+				       unsigned issue_flags)
+{
+	struct fuse_args_pages *ap;
+	size_t total_bytes = 0;
+	u16 buf_index;
+	struct bio_vec *bvs;
+	int err, ddir, i;
+
+	buf_index = ent->zero_copy_buf_id;
+
+	/* out_pages indicates a read, in_pages indicates a write */
+	ddir = req->args->out_pages ? ITER_DEST : ITER_SOURCE;
+
+	ap = container_of(req->args, typeof(*ap), args);
+
+	/*
+	 * We can avoid having to allocate the bvs array when folios and
+	 * descriptors are represented by bvecs in fuse
+	 */
+	bvs = kcalloc(ap->num_folios, sizeof(*bvs), GFP_KERNEL_ACCOUNT);
+	if (!bvs)
+		return -ENOMEM;
+
+	for (i = 0; i < ap->num_folios; i++) {
+		total_bytes += ap->descs[i].length;
+		bvs[i].bv_page = folio_page(ap->folios[i], 0);
+		bvs[i].bv_offset = ap->descs[i].offset;
+		bvs[i].bv_len = ap->descs[i].length;
+	}
+
+	err = io_buffer_register_bvec(ent->queue->ring_ctx, bvs, ap->num_folios,
+				      total_bytes, ddir, buf_index, issue_flags);
+	kfree(bvs);
+	if (err)
+		return err;
+
+	ent->zero_copied = true;
+
+	return 0;
+}
+
 /*
  * Copy data from the req to the ring buffer
  */
 static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
-				   struct fuse_ring_ent *ent)
+				   struct fuse_ring_ent *ent,
+				   unsigned int issue_flags)
 {
 	struct fuse_copy_state cs;
 	struct fuse_args *args = req->args;
@@ -900,6 +1014,11 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		num_args--;
 	}
 
+	if (can_zero_copy_req(ent, req)) {
+		err = fuse_uring_set_up_zero_copy(ent, req, issue_flags);
+		if (err)
+			return err;
+	}
 	/* copy the payload */
 	err = fuse_copy_args(&cs, num_args, args->in_pages,
 			     (struct fuse_arg *)in_args, 0);
@@ -910,12 +1029,17 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 	}
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
+	if (cs.skip_folio_copy && args->in_pages)
+		ent_in_out.payload_sz +=
+			args->in_args[args->in_numargs - 1].size;
+
 	return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
 				   &ent_in_out, sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
-				   struct fuse_req *req)
+				   struct fuse_req *req,
+				   unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ent->queue;
 	struct fuse_ring *ring = queue->ring;
@@ -933,7 +1057,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 		return err;
 
 	/* copy the request */
-	err = fuse_uring_args_to_ring(ring, req, ent);
+	err = fuse_uring_args_to_ring(ring, req, ent, issue_flags);
 	if (unlikely(err)) {
 		pr_info_ratelimited("Copy to ring failed: %d\n", err);
 		return err;
@@ -944,11 +1068,20 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 				   sizeof(req->in.h));
 }
 
-static bool fuse_uring_req_has_payload(struct fuse_req *req)
+static bool fuse_uring_req_has_copyable_payload(struct fuse_ring_ent *ent,
+						struct fuse_req *req)
 {
 	struct fuse_args *args = req->args;
 
-	return args->in_numargs > 1 || args->out_numargs;
+	if (!can_zero_copy_req(ent, req))
+		return args->in_numargs > 1 || args->out_numargs;
+
+	if ((args->in_numargs > 1) && (!args->in_pages || args->in_numargs > 2))
+		return true;
+	if (args->out_numargs && (!args->out_pages || args->out_numargs > 1))
+		return true;
+
+	return false;
 }
 
 static int fuse_uring_select_buffer(struct fuse_ring_ent *ent,
@@ -1014,7 +1147,7 @@ static int fuse_uring_next_req_update_buffer(struct fuse_ring_ent *ent,
 	ent->headers_iter.data_source = false;
 
 	buffer_selected = ent->payload_kvec.iov_base != 0;
-	has_payload = fuse_uring_req_has_payload(req);
+	has_payload = fuse_uring_req_has_copyable_payload(ent, req);
 
 	if (has_payload && !buffer_selected)
 		return fuse_uring_select_buffer(ent, issue_flags);
@@ -1040,22 +1173,23 @@ static int fuse_uring_prep_buffer(struct fuse_ring_ent *ent,
 	ent->headers_iter.data_source = false;
 
 	/* no payload to copy, can skip selecting a buffer */
-	if (!fuse_uring_req_has_payload(req))
+	if (!fuse_uring_req_has_copyable_payload(ent, req))
 		return 0;
 
 	return fuse_uring_select_buffer(ent, issue_flags);
 }
 
 static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
-				   struct fuse_req *req)
+				   struct fuse_req *req,
+				   unsigned int issue_flags)
 {
 	int err;
 
-	err = fuse_uring_copy_to_ring(ent, req);
+	err = fuse_uring_copy_to_ring(ent, req, issue_flags);
 	if (!err)
 		set_bit(FR_SENT, &req->flags);
 	else
-		fuse_uring_req_end(ent, req, err);
+		fuse_uring_req_end(ent, req, err, issue_flags);
 
 	return err;
 }
@@ -1158,7 +1292,7 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
 
 	err = fuse_uring_copy_from_ring(ring, req, ent);
 out:
-	fuse_uring_req_end(ent, req, err);
+	fuse_uring_req_end(ent, req, err, issue_flags);
 }
 
 /*
@@ -1181,7 +1315,7 @@ static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
 	spin_unlock(&queue->lock);
 
 	if (req) {
-		err = fuse_uring_prepare_send(ent, req);
+		err = fuse_uring_prepare_send(ent, req, issue_flags);
 		if (err)
 			goto retry;
 	}
@@ -1284,7 +1418,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 
 	err = fuse_uring_prep_buffer(ent, req, ITER_SOURCE, issue_flags);
 	if (WARN_ON_ONCE(err))
-		fuse_uring_req_end(ent, req, err);
+		fuse_uring_req_end(ent, req, err, issue_flags);
 	else
 		fuse_uring_commit(ent, req, issue_flags);
 
@@ -1409,6 +1543,9 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 
 		buf_index = READ_ONCE(cmd->sqe->buf_index);
 
+		if (queue->use_zero_copy)
+			ent->zero_copy_buf_id = buf_index;
+
 		/* set up the headers */
 		ent->headers_iter = queue->headers_iter;
 		iov_iter_advance(&ent->headers_iter, buf_index * header_size);
@@ -1459,6 +1596,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 {
 	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
 	bool use_bufring = READ_ONCE(cmd_req->init.use_bufring);
+	bool zero_copy = READ_ONCE(cmd_req->init.zero_copy);
 	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
@@ -1480,11 +1618,12 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 	queue = ring->queues[qid];
 	if (!queue) {
 		queue = fuse_uring_create_queue(cmd, ring, qid, use_bufring,
-						issue_flags);
+						zero_copy, issue_flags);
 		if (IS_ERR(queue))
 			return PTR_ERR(queue);
 	} else {
-		if (queue->use_bufring != use_bufring)
+		if ((queue->use_bufring != use_bufring) ||
+		    (queue->use_zero_copy != zero_copy))
 			return -EINVAL;
 	}
 
@@ -1587,7 +1726,7 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 	int err;
 
 	if (!tw.cancel) {
-		err = fuse_uring_prepare_send(ent, ent->fuse_req);
+		err = fuse_uring_prepare_send(ent, ent->fuse_req, issue_flags);
 		if (err) {
 			if (!fuse_uring_get_next_fuse_req(ent, queue,
 							  issue_flags))
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index a8a849c3497e..3398b43fb1df 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -56,6 +56,11 @@ struct fuse_ring_ent {
 			 * the buffer when done with it
 			 */
 			unsigned int ringbuf_buf_id;
+
+			/* True if the request's pages are being zero-copied */
+			bool zero_copied;
+			/* Buf id for this ent's zero-copied pages */
+			unsigned int zero_copy_buf_id;
 		};
 	};
 
@@ -128,6 +133,13 @@ struct fuse_ring_queue {
 	struct iov_iter headers_iter;
 	/* synchronized by the queue lock */
 	struct io_buffer_list *bufring;
+	/*
+	 * True if zero copy should be used for payloads. This is only enabled
+	 * on privileged servers. Kernel-managed ring buffers must be enabled
+	 * in order to use zero copy.
+	 */
+	bool use_zero_copy : 1;
+	unsigned int depth;
 };
 
 /**
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index aa1d25421054..67b5bed451fe 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -39,6 +39,7 @@ struct fuse_copy_state {
 	bool is_uring:1;
 	/* if set, use kaddr; otherwise use pg */
 	bool is_kaddr:1;
+	bool skip_folio_copy:1;
 	struct {
 		unsigned int copied_sz; /* copied size into the user buffer */
 	} ring;
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 3041177e3dd8..c98ea7a4ddde 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -243,6 +243,7 @@
  *
  *  7.46
  *  - add fuse_uring_cmd_req use_bufring
+ *  - add fuse_uring_cmd_req zero_copy and queue_depth
  */
 
 #ifndef _LINUX_FUSE_H
@@ -1312,10 +1313,12 @@ struct fuse_uring_cmd_req {
 	union {
 		struct {
 			bool use_bufring;
+			bool zero_copy;
+			uint16_t queue_depth;
 		} init;
 	};
 
-	uint8_t padding[5];
+	uint8_t padding[2];
 };
 
 #endif /* _LINUX_FUSE_H */
-- 
2.47.3


