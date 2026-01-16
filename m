Return-Path: <io-uring+bounces-11792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 073A5D38A40
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E9B7E30BF493
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF6B309DA5;
	Fri, 16 Jan 2026 23:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGBSHtLk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB10A32B9A6
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606309; cv=none; b=jlk8/aAJ0zfXvl8eI5kCX5h76/Nt8lJKuqQMJhLK9zRtt9QFyEuPiUxZKJtQbqT9OxJPxij1DJFPWFVjm7Dc0TLtD8PWV46RjviHuYDae3+HdRZIrph5EqcMjPKW2NEj/ilV5U/luZ+uk8C2Z1ltOLo64dU7kzcWC3KZ630KGYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606309; c=relaxed/simple;
	bh=xtmWzc4G++0gL+z25zbH0Ag4o+AdO5AeUDKS6Tj4ap0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JopVUfZywKGrapI0OFhkmOuNyYAEvStixD7M+ZPuXT4cj73f23iv46aq/jmPYPjuZzW/M3brr3GxLdGygdHbeGt5O+nK2iDSPhyFmmTHLVUi7gI6kAf85NFMCKNQ1EQ5QxY4ZKym1SibU41p+Ttrq2dHaTwMNzyd4/90cyHEozg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGBSHtLk; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34cf1e31f85so1341889a91.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606307; x=1769211107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWMXxatVfsaBFolp4BcPrTFm0V7QJPIf/30xzf9Zzys=;
        b=iGBSHtLkzccq9zKTuuQiyXWR1ZubBawel1PQNl9LOaI72TFWVQPtPljY0d1Y0496rd
         dO+SNwbin33ZtwxMCOJXM1o831wvpq1TveiBVAJQPk9mCtalBpFPF3+FnYqcbnxO8MJW
         050Aj5G7TX7tKflC4+vJJ4QJJV69LkWvT6ocl/jGFvSuf/0F1Q71uVcAL2t7KYbQZh8/
         FFpU4GAVKtDgW+Vco+AVjfbVziLCqqkG16l2p8XXSoCfmx7iDO6rVME0rDKZycYWeq/i
         BBORl6sNGFH2mnaOBBvn1KycNGLZWosf/wNkL0ldiZhNujAK7dib+RAXXDVVgXCvUz9B
         j49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606307; x=1769211107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BWMXxatVfsaBFolp4BcPrTFm0V7QJPIf/30xzf9Zzys=;
        b=l1Z6321+EpLF8ApWvrto4uXv44faEYHcQr17M+VMdeJ8dbtLA8ww0UYLAMEGYN2d2e
         z6q3Gr+x46Lf1Wr9wayMzdMS2OGqj213qU8e+vxg5eSyELiy3Nene+htIibrq55wICpr
         /CWW7K8yx6KsdOHCoiPxJozTWt9iDXuweWCeWharG8TMVf4l/D2Ctul+I5vyGelDTtjS
         t55RKjfvp4dQ+BD06TQekLzHQY9lSpgJ9GFYxZCYACusrOOvpay2jpHRenNgXkV0BzpZ
         73lBi5YiJMTV1vMLUATQivm2yZhpjh1z7kcUNv8ax8zsl53dFZyp/nfl0mreEym1kbZQ
         d7ww==
X-Forwarded-Encrypted: i=1; AJvYcCUXg2w8fKE160N6/uAoK+vErLCkPNKdM+9ruCZ+cjOirXtFZs7+LehgsTlagZhO9T3BJulLgbBcgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuSlFq2Det5U84HrCo9x3wkw/Bg3jSPfcv0sZIkEtcsvqO6pmH
	IHFwcYXV8gP3ACMt+OaRA9A7sBgT0mBnUQkKIoKD711guAEaveH5eOU8
X-Gm-Gg: AY/fxX5vKGZSUKqZe+4+sw5Mea5LT4cpbtRldQr4ZKl0ohdRicJN5RsJ3Wcmu9SZHdp
	ckrtUOLav9Q2JTiCO5kFR3joWv26WkzwHWk24w9V5TNatJknPpGO8QE3GahcPJSsF7FMDmdWN/V
	S6m18KVMuSZLwgA6gqVeMGx0rNdSLEXVI3A59yvaQRrWFnknXZqutcshxHHlK7Ymk+dGkPSH70v
	6GG4tNpDi7Jv9/sM1Zn3LCNKDAOsgEmpilDeHkrkxLdSFLhtF0EeIfkeQBw/HkPuhgTYJ9As6QP
	2+bEJKyq+MGRh1y2+13hZq+AmwLF3B/z/R03UE7yUQWmeyj7H4pn/Jx2IhpaeawaGYE2rItdLQR
	mdha0OpWSTIaQoDwnoCkve8nLzQhLhvikMm5fEM88nlQL3Oky8PT02wjjlVeNgtzsla7o9WRP6O
	ZltodFR2KhsVsdbBuZ
X-Received: by 2002:a17:90a:e708:b0:34a:b8fc:f1d1 with SMTP id 98e67ed59e1d1-35272f6ce80mr3712563a91.24.1768606307143;
        Fri, 16 Jan 2026 15:31:47 -0800 (PST)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3527422b425sm1360309a91.4.2026.01.16.15.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:46 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 24/25] fuse: add zero-copy over io-uring
Date: Fri, 16 Jan 2026 15:30:43 -0800
Message-ID: <20260116233044.1532965-25-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
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
 fs/fuse/dev_uring.c       | 166 ++++++++++++++++++++++++++++++--------
 fs/fuse/dev_uring_i.h     |  11 +++
 fs/fuse/fuse_dev_i.h      |   1 +
 include/uapi/linux/fuse.h |   6 +-
 5 files changed, 155 insertions(+), 36 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ceb5d6a553c0..bdb2b0d01e0c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1229,10 +1229,13 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
 
 	for (i = 0; !err && i < numargs; i++)  {
 		struct fuse_arg *arg = &args[i];
-		if (i == numargs - 1 && argpages)
+		if (i == numargs - 1 && argpages) {
+			if (cs->skip_folio_copy)
+				return 0;
 			err = fuse_copy_folios(cs, arg->size, zeroing);
-		else
+		} else {
 			err = fuse_copy_one(cs, arg->value, arg->size);
+		}
 	}
 	return err;
 }
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 40e8c2e6b77c..3e5319442d4f 100644
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
@@ -109,6 +115,11 @@ static void fuse_uring_req_end(struct fuse_ring_ent *ent, struct fuse_req *req,
 
 	spin_unlock(&queue->lock);
 
+	if (ent->zero_copied) {
+		io_buffer_unregister(ent->cmd, ent->fixed_buf_id, issue_flags);
+		ent->zero_copied = false;
+	}
+
 	if (error)
 		req->out.h.error = error;
 
@@ -282,6 +293,7 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 
 static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
 				     struct fuse_ring_queue *queue,
+				     bool zero_copy,
 				     unsigned int issue_flags)
 {
 	int err;
@@ -291,21 +303,37 @@ static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
 	if (err)
 		return err;
 
-	if (!io_uring_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP,
-				    issue_flags)) {
-		io_uring_buf_ring_unpin(cmd, FUSE_URING_RINGBUF_GROUP,
-					issue_flags);
-		return -EINVAL;
+	err = -EINVAL;
+
+	if (!io_uring_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP, issue_flags))
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
+	io_uring_buf_ring_unpin(cmd, FUSE_URING_RINGBUF_GROUP, issue_flags);
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
@@ -337,12 +365,13 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
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
@@ -360,6 +389,11 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring,
 	spin_unlock(&fc->lock);
 
 	return queue;
+
+cleanup:
+	kfree(pq);
+	kfree(queue);
+	return ERR_PTR(err);
 }
 
 static void fuse_uring_stop_fuse_req_end(struct fuse_req *req)
@@ -767,6 +801,7 @@ static int setup_fuse_copy_state(struct fuse_copy_state *cs,
 		cs->is_kaddr = true;
 		cs->len = ent->payload_kvec.iov_len;
 		cs->kaddr = ent->payload_kvec.iov_base;
+		cs->skip_folio_copy = can_zero_copy_req(ent, req);
 	}
 
 	cs->is_uring = true;
@@ -799,11 +834,53 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
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
@@ -836,6 +913,11 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
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
@@ -846,12 +928,17 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
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
@@ -869,7 +956,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
 		return err;
 
 	/* copy the request */
-	err = fuse_uring_args_to_ring(ring, req, ent);
+	err = fuse_uring_args_to_ring(ring, req, ent, issue_flags);
 	if (unlikely(err)) {
 		pr_info_ratelimited("Copy to ring failed: %d\n", err);
 		return err;
@@ -880,11 +967,20 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
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
@@ -942,7 +1038,7 @@ static int fuse_uring_next_req_update_buffer(struct fuse_ring_ent *ent,
 	ent->headers_iter.data_source = false;
 
 	buffer_selected = ent->payload_kvec.iov_base != NULL;
-	has_payload = fuse_uring_req_has_payload(req);
+	has_payload = fuse_uring_req_has_copyable_payload(ent, req);
 
 	if (has_payload && !buffer_selected)
 		return fuse_uring_select_buffer(ent, issue_flags);
@@ -962,22 +1058,23 @@ static int fuse_uring_prep_buffer(struct fuse_ring_ent *ent,
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
@@ -1082,7 +1179,7 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
 
 	err = fuse_uring_copy_from_ring(ring, req, ent);
 out:
-	fuse_uring_req_end(ent, req, err);
+	fuse_uring_req_end(ent, req, err, issue_flags);
 }
 
 /*
@@ -1105,7 +1202,7 @@ static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
 	spin_unlock(&queue->lock);
 
 	if (req) {
-		err = fuse_uring_prepare_send(ent, req);
+		err = fuse_uring_prepare_send(ent, req, issue_flags);
 		if (err)
 			goto retry;
 	}
@@ -1156,6 +1253,7 @@ static int fuse_uring_headers_prep(struct fuse_ring_ent *ent, unsigned int dir,
 				   unsigned int issue_flags)
 {
 	size_t header_size = sizeof(struct fuse_uring_req_header);
+	u16 headers_index = FUSE_URING_FIXED_HEADERS_OFFSET;
 	struct io_uring_cmd *cmd = ent->cmd;
 	struct io_rsrc_node *node;
 	unsigned int offset;
@@ -1165,9 +1263,11 @@ static int fuse_uring_headers_prep(struct fuse_ring_ent *ent, unsigned int dir,
 
 	offset = ent->fixed_buf_id * header_size;
 
-	node = io_uring_fixed_index_get(cmd, FUSE_URING_FIXED_HEADERS_OFFSET,
-					offset, header_size, dir,
-					&ent->headers_iter, issue_flags);
+	if (ent->queue->use_zero_copy)
+		headers_index += ent->queue->zero_copy_depth;
+
+	node = io_uring_fixed_index_get(cmd, headers_index, offset, header_size,
+					dir, &ent->headers_iter, issue_flags);
 	if (IS_ERR(node))
 		return PTR_ERR(node);
 
@@ -1242,7 +1342,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 
 	err = fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
 	if (err)
-		fuse_uring_req_end(ent, req, err);
+		fuse_uring_req_end(ent, req, err, issue_flags);
 	else
 		fuse_uring_commit(ent, req, issue_flags);
 
@@ -1404,6 +1504,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
 	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
 	unsigned int init_flags = READ_ONCE(cmd_req->init.flags);
 	bool use_bufring = init_flags & FUSE_URING_BUF_RING;
+	bool zero_copy = init_flags & FUSE_URING_ZERO_COPY;
 	struct fuse_ring *ring = smp_load_acquire(&fc->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
@@ -1425,11 +1526,12 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
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
 
@@ -1536,7 +1638,7 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 		if (fuse_uring_headers_prep(ent, ITER_DEST, issue_flags))
 			return;
 
-		if (fuse_uring_prepare_send(ent, ent->fuse_req))
+		if (fuse_uring_prepare_send(ent, ent->fuse_req, issue_flags))
 			send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
 		fuse_uring_headers_cleanup(ent, issue_flags);
 		if (!send)
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index ac6da80c3d70..e32405d7b3bd 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -58,6 +58,9 @@ struct fuse_ring_ent {
 			 */
 			unsigned int ringbuf_buf_id;
 			unsigned int fixed_buf_id;
+
+			/* True if the request's pages are being zero-copied */
+			bool zero_copied;
 		};
 	};
 
@@ -124,6 +127,14 @@ struct fuse_ring_queue {
 
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
index b49c8d3b9ab6..2c44219f0062 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -242,7 +242,7 @@
  *  - add FUSE_NOTIFY_PRUNE
  *
  *  7.46
- *  - add fuse_uring_cmd_req init flags
+ *  - add fuse_uring_cmd_req init flags and queue_depth
  */
 
 #ifndef _LINUX_FUSE_H
@@ -1299,6 +1299,7 @@ enum fuse_uring_cmd {
 
 /* fuse_uring_cmd_req init flags */
 #define FUSE_URING_BUF_RING	(1 << 0)
+#define FUSE_URING_ZERO_COPY	(1 << 1)
 
 /**
  * In the 80B command area of the SQE.
@@ -1315,10 +1316,11 @@ struct fuse_uring_cmd_req {
 	union {
 		struct {
 			uint16_t flags;
+			uint16_t queue_depth;
 		} init;
 	};
 
-	uint8_t padding[4];
+	uint8_t padding[2];
 };
 
 #endif /* _LINUX_FUSE_H */
-- 
2.47.3


