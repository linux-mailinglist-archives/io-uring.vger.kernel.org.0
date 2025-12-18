Return-Path: <io-uring+bounces-11204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 51997CCAF98
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:43:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 803933018196
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5A4335579;
	Thu, 18 Dec 2025 08:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MIQQ9LmH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAA9335568
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046916; cv=none; b=d6wCoIdeuWTZ0cPkU8llOFTwl9eugoZR6vFeYDV9CQvY34FrC4AfbuqvzE4dOdRRAsdXHf7GFO2AfzzZ/i9DfX8OKlpcYJZevcVYHGbSpLFygT2GZL36ZDW5FKQtP8F2a7T3N8QcDuKXWTyiXA+xqGbIVwVOFtFY29ZEu6zFmZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046916; c=relaxed/simple;
	bh=i7pmSi/IKj1SyF2ripKRSKBS8LrggFsnsrlvggpS1OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpNGnwsLPeO603v/Aw+e9OZCJcRxJmuWr4wwGc33VpbdnlnGC0TqSZ0PP7aSB9ORauXfQnfF8uNG+l0URuFwk7o1PQUVS/bpBr5i+2hQphfsag0cGBVk5GOeRpHbvx6K2m2JUykdgQjj+veU4N4JN+mTba9SwIm/KPz8t4frqGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MIQQ9LmH; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so434705b3a.2
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046913; x=1766651713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3+eePa2+hfAP7ShnM6JYrFDU+uo1Ny7wdnGfQoI3Z4s=;
        b=MIQQ9LmHcRBis80w21i7Hy0pag4yK+bl6QW8mi+cOklGYdVS8b0chnLOotfbw3EPEp
         lQ9B5xQH3tZEMXhlcBxUVdof3hamWb1rHigrlw54/xJFL6jttiD3/FtPy6+3zU9CBl64
         tQMIJnnUmz0LHO2FkA+SjqT6U+qMAtTRjU0n53RsKXqLq8ZThUfNF0a8HTlbdvuRWnVJ
         2OJeH2uxSa9LCBRbmjsFPk7iAbRtA0u4CohbMxJIQkNucmRc8yWaL4fAwOiJ+SMu8XNe
         /SqY40vMRi9NhhRvMYvlQJWdg2Vsib3JxlAED12dsTiw/NsRMReuVj7f/hfVcY2tZ/AU
         ldZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046913; x=1766651713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3+eePa2+hfAP7ShnM6JYrFDU+uo1Ny7wdnGfQoI3Z4s=;
        b=kDouTUUaSTMozxVsTXjDMd7/Kcd87WlJSJaSxcqZodGdWKyW4v0allKH7PsnGpnxku
         S94KYZ7JEXEU0PK58ALphRI6FXI5uKpp1NTAsF+3Nkq5B0g91QtR0fnSmnC3iokH5zj0
         uuqMTX2T3pPrps9kSgqECZPPM3xSqNwsyRv+rY9e5VwYMbb6uG/PpaLEehBeq6nOASQL
         dGUumXxQs0brgYadOXIEF0UwB0yXSW6NtZdXOpY7iLkuZAA0Bw3GTTQfabJ2y3VM/39e
         sDisZF20bIA1YX9zc5TDfYJw5Xqc8uJp9Lfl3QQb/4SXoWvFpKPbNRLaZpFlXTSnb+yQ
         606A==
X-Forwarded-Encrypted: i=1; AJvYcCW8mX2hH66oO19DktlDLzkmDg9svGrt7cb4yAAesBcD/ksKpwd+0UoLhR8AgTj7wkK5n/6Lk7NRMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfOnnf1GYH+o3mVC+FxCZRumfM3zTOY/+NfVQU0fMzUmGGWW/S
	Am1/Il/+Zunzd+7mPHAMFyZb9hzKJWzwPan8W0ihh2K5Sq3nn4kZkLYd
X-Gm-Gg: AY/fxX65U1kj5M688i4Vtm3EiWbRMYGHo7VCt2o9StXOWZdkFe8Gg9LUN0EiMNaFaIO
	wIRL91B7nmM6QuPH1Gd7MUQ2tYCs/0vkMywkKNHH8er5636HKQbykX/FtBd1/BImEHur9b0xBW7
	9SxbFrkVC0X23OFrp6eXr2ZfS+uLVNoflMUbKkCOwI2Nye9Rkn8tFv4+0cslACXKthgetMmEkUU
	hpmiyx1AtdtChNpDAynkYnElkioGuFfZBDImsJPl+sZTKFnkAafpcqr1CTe3FDc9XYuIfdEfRKp
	xB3dc0thgNYrM6XaQ1W4mS3FGOXfae/MrTbqJB3oV2gjF2rA3vnoXATaMsbu5Ma0B+AnbX7IAXb
	HlV4ZIbtscIsvtbwrCd2pjyCL4f6cLZWjNhBsGb17FYpUUtV7ZxLhGMHDs5+3QrbapZJs+U2ZFs
	X50LLz2VRCg3kw3/rM/Q==
X-Google-Smtp-Source: AGHT+IE99Dd9Dn13cZy26j+bmZyKApBUtJ9Tj6uKt53o4Fp3Ag0WXMDfDqJJGIc8igaPKspxV0W5Mg==
X-Received: by 2002:a05:6a00:3318:b0:7e8:450c:61bf with SMTP id d2e1a72fcca58-7f671962c7fmr19179913b3a.47.1766046913291;
        Thu, 18 Dec 2025 00:35:13 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5e::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe14179645sm1836943b3a.47.2025.12.18.00.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:35:13 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 24/25] fuse: add zero-copy over io-uring
Date: Thu, 18 Dec 2025 00:33:18 -0800
Message-ID: <20251218083319.3485503-25-joannelkoong@gmail.com>
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
 fs/fuse/dev_uring.c       | 176 +++++++++++++++++++++++++++++++-------
 fs/fuse/dev_uring_i.h     |  11 +++
 fs/fuse/fuse_dev_i.h      |   1 +
 include/uapi/linux/fuse.h |   6 +-
 5 files changed, 164 insertions(+), 37 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ceb5d6a553c0..0f7f2d8b3951 100644
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
index d028cdd57f45..ff8531558785 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -89,8 +89,14 @@ static void fuse_uring_flush_bg(struct fuse_ring_queue *queue)
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
@@ -109,6 +115,12 @@ static void fuse_uring_req_end(struct fuse_ring_ent *ent, struct fuse_req *req,
 
 	spin_unlock(&queue->lock);
 
+	if (ent->zero_copied) {
+		WARN_ON_ONCE(io_buffer_unregister(ent->cmd, ent->fixed_buf_id,
+						  issue_flags));
+		ent->zero_copied = false;
+	}
+
 	if (error)
 		req->out.h.error = error;
 
@@ -282,6 +294,7 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 
 static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
 				     struct fuse_ring_queue *queue,
+				     bool zero_copy,
 				     unsigned int issue_flags)
 {
 	int err;
@@ -291,22 +304,39 @@ static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
 	if (err)
 		return err;
 
+	err = -EINVAL;
+
 	if (!io_uring_cmd_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP,
-					issue_flags)) {
-		io_uring_cmd_buf_ring_unpin(cmd,
-					    FUSE_URING_RINGBUF_GROUP,
-					    issue_flags);
-		return -EINVAL;
+					issue_flags))
+		goto error;
+
+	if (zero_copy) {
+		const struct fuse_uring_cmd_req *cmd_req =
+			io_uring_sqe_cmd(cmd->sqe);
+
+		if (!capable(CAP_SYS_ADMIN))
+			goto error;
+
+		queue->use_zero_copy = true;
+		queue->zero_copy_depth = READ_ONCE(cmd_req->init.queue_depth);
+		if (!queue->zero_copy_depth)
+			goto error;
 	}
 
 	queue->use_bufring = true;
 
 	return 0;
+
+error:
+	io_uring_cmd_buf_ring_unpin(cmd, FUSE_URING_RINGBUF_GROUP,
+				    issue_flags);
+	return err;
 }
 
 static struct fuse_ring_queue *
 fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
-			int qid, bool use_bufring, unsigned int issue_flags)
+			int qid, bool use_bufring, bool zero_copy,
+			unsigned int issue_flags)
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
@@ -338,12 +368,13 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
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
@@ -361,6 +392,11 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
 	spin_unlock(&fc->lock);
 
 	return queue;
+
+cleanup:
+	kfree(pq);
+	kfree(queue);
+	return ERR_PTR(err);
 }
 
 static void fuse_uring_stop_fuse_req_end(struct fuse_req *req)
@@ -768,6 +804,7 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
 		cs->is_kaddr = true;
 		cs->len = ent->payload_kvec.iov_len;
 		cs->kaddr = ent->payload_kvec.iov_base;
+		cs->skip_folio_copy = can_zero_copy_req(ent, req);
 	}
 
 	cs->is_uring = true;
@@ -800,11 +837,53 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	return err;
 }
 
+static int fuse_uring_set_up_zero_copy(struct fuse_ring_ent *ent,
+				       struct fuse_req *req,
+				       unsigned issue_flags)
+{
+	struct fuse_args_pages *ap;
+	size_t total_bytes = 0;
+	struct bio_vec *bvs;
+	int err, ddir, i;
+
+	/* out_pages indicates a read, in_pages indicates a write */
+	ddir = req->args->out_pages ? ITER_DEST : ITER_SOURCE;
+
+	ap = container_of(req->args, typeof(*ap), args);
+
+	/*
+	 * We can avoid having to allocate the bvs array when folios and
+	 * descriptors are internally represented by bvs in fuse
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
+	err = io_buffer_register_bvec(ent->cmd, bvs, ap->num_folios,
+				      total_bytes, ddir, ent->fixed_buf_id,
+				      issue_flags);
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
@@ -837,6 +916,11 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
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
@@ -847,12 +931,17 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
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
@@ -870,7 +959,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 		return err;
 
 	/* copy the request */
-	err = fuse_uring_args_to_ring(ring, req, ent);
+	err = fuse_uring_args_to_ring(ring, req, ent, issue_flags);
 	if (unlikely(err)) {
 		pr_info_ratelimited("Copy to ring failed: %d\n", err);
 		return err;
@@ -881,11 +970,20 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
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
@@ -946,7 +1044,7 @@ static int fuse_uring_next_req_update_buffer(struct fuse_ring_ent *ent,
 	ent->headers_iter.data_source = false;
 
 	buffer_selected = ent->payload_kvec.iov_base != 0;
-	has_payload = fuse_uring_req_has_payload(req);
+	has_payload = fuse_uring_req_has_copyable_payload(ent, req);
 
 	if (has_payload && !buffer_selected)
 		return fuse_uring_select_buffer(ent, issue_flags);
@@ -972,22 +1070,23 @@ static int fuse_uring_prep_buffer(struct fuse_ring_ent *ent,
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
@@ -1092,7 +1191,7 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
 
 	err = fuse_uring_copy_from_ring(ring, req, ent);
 out:
-	fuse_uring_req_end(ent, req, err);
+	fuse_uring_req_end(ent, req, err, issue_flags);
 }
 
 /*
@@ -1115,7 +1214,7 @@ static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
 	spin_unlock(&queue->lock);
 
 	if (req) {
-		err = fuse_uring_prepare_send(ent, req);
+		err = fuse_uring_prepare_send(ent, req, issue_flags);
 		if (err)
 			goto retry;
 	}
@@ -1155,11 +1254,15 @@ static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
 static void fuse_uring_headers_cleanup(struct fuse_ring_ent *ent,
 				       unsigned int issue_flags)
 {
+	u16 headers_index = FUSE_URING_FIXED_HEADERS_OFFSET;
+
 	if (!ent->queue->use_bufring)
 		return;
 
-	WARN_ON_ONCE(io_uring_cmd_fixed_index_put(ent->cmd,
-						  FUSE_URING_FIXED_HEADERS_OFFSET,
+	if (ent->queue->use_zero_copy)
+		headers_index += ent->queue->zero_copy_depth;
+
+	WARN_ON_ONCE(io_uring_cmd_fixed_index_put(ent->cmd, headers_index,
 						  issue_flags));
 }
 
@@ -1167,6 +1270,7 @@ static int fuse_uring_headers_prep(struct fuse_ring_ent *ent, unsigned int dir,
 				   unsigned int issue_flags)
 {
 	size_t header_size = sizeof(struct fuse_uring_req_header);
+	u16 headers_index = FUSE_URING_FIXED_HEADERS_OFFSET;
 	struct io_uring_cmd *cmd = ent->cmd;
 	unsigned int offset;
 	int err;
@@ -1176,11 +1280,15 @@ static int fuse_uring_headers_prep(struct fuse_ring_ent *ent, unsigned int dir,
 
 	offset = ent->fixed_buf_id * header_size;
 
-	err = io_uring_cmd_fixed_index_get(cmd, FUSE_URING_FIXED_HEADERS_OFFSET,
-					   offset, header_size, dir,
+	if (ent->queue->use_zero_copy)
+		headers_index += ent->queue->zero_copy_depth;
+
+	err = io_uring_cmd_fixed_index_get(cmd, headers_index, offset,
+					   header_size, dir,
 					   &ent->headers_iter, issue_flags);
 
 	WARN_ON_ONCE(err);
+
 	return err;
 }
 
@@ -1251,7 +1359,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 
 	err = fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
 	if (err)
-		fuse_uring_req_end(ent, req, err);
+		fuse_uring_req_end(ent, req, err, issue_flags);
 	else
 		fuse_uring_commit(ent, req, issue_flags);
 
@@ -1412,6 +1520,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 {
 	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
 	bool use_bufring = READ_ONCE(cmd_req->init.use_bufring);
+	bool zero_copy = READ_ONCE(cmd_req->init.zero_copy);
 	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
@@ -1433,11 +1542,12 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
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
 
@@ -1544,7 +1654,7 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 		if (fuse_uring_headers_prep(ent, ITER_DEST, issue_flags))
 			return;
 
-		if (fuse_uring_prepare_send(ent, ent->fuse_req))
+		if (fuse_uring_prepare_send(ent, ent->fuse_req, issue_flags))
 			send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
 		fuse_uring_headers_cleanup(ent, issue_flags);
 		if (!send)
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index eff14557066d..b24f89adabc1 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -57,6 +57,9 @@ struct fuse_ring_ent {
 			 */
 			unsigned int ringbuf_buf_id;
 			unsigned int fixed_buf_id;
+
+			/* True if the request's pages are being zero-copied */
+			bool zero_copied;
 		};
 	};
 
@@ -123,6 +126,14 @@ struct fuse_ring_queue {
 
 	/* synchronized by the queue lock */
 	struct io_buffer_list *bufring;
+
+	/*
+	 * True if zero copy should be used for payloads. This is only enabled
+	 * on privileged servers. Kernel-managed ring buffers must be enabled
+	 * in order to use zero copy.
+	 */
+	bool use_zero_copy : 1;
+	unsigned int zero_copy_depth;
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
index 3041177e3dd8..f5a67d27f145 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -242,7 +242,7 @@
  *  - add FUSE_NOTIFY_PRUNE
  *
  *  7.46
- *  - add fuse_uring_cmd_req use_bufring
+ *  - add fuse_uring_cmd_req use_bufring, zero_copy, and queue_depth
  */
 
 #ifndef _LINUX_FUSE_H
@@ -1312,10 +1312,12 @@ struct fuse_uring_cmd_req {
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


