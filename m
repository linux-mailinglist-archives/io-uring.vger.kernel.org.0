Return-Path: <io-uring+bounces-1173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D18F18819B4
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3FA01C21066
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E0986120;
	Wed, 20 Mar 2024 22:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l/QjlQlA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BF785C74
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975496; cv=none; b=p1Bb8I+pwCVBMnEsemLp8ljMtBo9hWCmYK64+yL70bt5m2DiqqrSYGoN6kQYnc/4TMLjVTrFH7GvZsJF66pW8BwjMaAzVQXe+/0LXg+mNPb0g+R5wVYGtuinziA6B6F+ksPm7skCyWKbHUFk00UKNY1hmUhhCBYNI7oc/NVCGHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975496; c=relaxed/simple;
	bh=36tn+YsGIBAk751kyPcGoYlvo4+4/qvrxgKny/pS7IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIE74xETxaM5gmnq9S9UrQ2sco1ZVmUqY/FgdMRZYipFjNI/8SVa1JPs4p0+eojoTuatLxEI71DiAzc3ta7cjXbgSrnW/UJgxQeHfN3YU1iZEee6LlqnzdHPuGxXUIyShEpg0SSYgFPW41HSeL0Ztf+qB7z4Cw2ZtK8O9EqqL1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l/QjlQlA; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-367c7daa395so273285ab.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975492; x=1711580292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtW2hhQDKuo9tjpn5TZzJP9YHWlBdbIzpNr0s1mISCc=;
        b=l/QjlQlA36k97YUws5ifOYzSEhdkU07E6P4i+JAC0GhqMwLiw9ysk6vwZaxxsHFJsF
         Y3n5oId1uzm1gSQZD7ohPiX/7caMCup3KvJz3qgr3S4yI6nrnHkVV8YX0l0bTF0KVT9r
         5WvTACozUfeEtLV+0fZluh1ALMSLS1ACO/XAjRHD+rAbL3LbxZoFv8Iq72+vPsXu09i6
         RIinYT7SBTLAsLJB+gTMQuvIkdPtvP2YLZdHHJxk8k6SSTwFQg7HVz03ZovUCe1BkG5U
         jYmDN0jybOFojVruPTGFpxIudzjCkXGoD7BB3guoGwufyXbeHNeZEoJYdxEpgF+U6XLe
         mIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975492; x=1711580292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtW2hhQDKuo9tjpn5TZzJP9YHWlBdbIzpNr0s1mISCc=;
        b=nkSl7JmeCygd/PnVSbAp2CdcvByXm2SkPV5LxaNe6YxzxrOKs/ChMUwjDDAPq6uUp6
         lvi+khM9apKeK9LBz5xwzAcqYbgKmX6fGatDhzoR6X9r4UQDUqBL7rHzHurWSjTI00vu
         spEiubf5gtAbd6rQ68O1Gx21eqjxwaHOpBT4FBnArB772ji8teXNJQLSqftKhgA6js+t
         pduYrKSr36cGRD/+h888yjOPM3hTkkGWbFvqYxvee127TmnxpGNvT97Ah4GolPux63EQ
         2ZFPOp05KHMhaLCEOFWZF6ZNeSZ3aFT4yPNcmaZflS9qP5grDtHZtp2vFGPzJ9wMPleD
         inoQ==
X-Gm-Message-State: AOJu0YxBJ+NTPTYEeZMNFDV0u3uBImgmoPcL+3WVIQ2DzA0kYjmDjK5A
	Sq+/9UoBx0wgwVZkfG664LmtgdnfxIOlPvfAt8pRX4LZVkbECi9JJwAHp1VHzVHPKNMstazYjeb
	S
X-Google-Smtp-Source: AGHT+IFLhXVmipOy0Vq0po9SfP+YkFcaik8Oim9aIxdmP9YBQAMbfyFZEvPTkRNUTodrhOgvw7Lc5w==
X-Received: by 2002:a5e:9503:0:b0:7cf:ba0:7146 with SMTP id r3-20020a5e9503000000b007cf0ba07146mr5134853ioj.2.1710975491776;
        Wed, 20 Mar 2024 15:58:11 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/17] io_uring/rw: always setup io_async_rw for read/write requests
Date: Wed, 20 Mar 2024 16:55:25 -0600
Message-ID: <20240320225750.1769647-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

read/write requests try to put everything on the stack, and then alloc
and copy if we need to retry. This necessitates a bunch of nasty code
that deals with intermediate state.

Get rid of this, and have the prep side setup everything we need
upfront, which greatly simplifies the opcode handlers.

This includes adding an alloc cache for io_async_rw, to make it cheap
to handle.

In terms of cost, this should be basically free and transparent. For
the worst case of {READ,WRITE}_FIXED which didn't need it before,
performance is unaffected in the normal peak workload that is being
used to test that. Still runs at 122M IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   1 +
 io_uring/io_uring.c            |   3 +
 io_uring/opdef.c               |  15 +-
 io_uring/rw.c                  | 538 ++++++++++++++++-----------------
 io_uring/rw.h                  |  19 +-
 5 files changed, 278 insertions(+), 298 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f37caff64d05..2ba8676f83cc 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -300,6 +300,7 @@ struct io_ring_ctx {
 		struct io_hash_table	cancel_table_locked;
 		struct io_alloc_cache	apoll_cache;
 		struct io_alloc_cache	netmsg_cache;
+		struct io_alloc_cache	rw_cache;
 
 		/*
 		 * Any cancelable uring_cmd is added to this list in
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ff0e233ce3c9..cc8ce830ff4b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -308,6 +308,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct async_poll));
 	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
+	io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
+			    sizeof(struct io_async_rw));
 	io_futex_cache_init(ctx);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
@@ -2898,6 +2900,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
+	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index dd4a1e1425e1..fcae75a08f2c 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -67,7 +67,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
-		.prep			= io_prep_rwv,
+		.prep			= io_prep_readv,
 		.issue			= io_read,
 	},
 	[IORING_OP_WRITEV] = {
@@ -81,7 +81,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
-		.prep			= io_prep_rwv,
+		.prep			= io_prep_writev,
 		.issue			= io_write,
 	},
 	[IORING_OP_FSYNC] = {
@@ -99,7 +99,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.prep			= io_prep_rw_fixed,
+		.prep			= io_prep_read_fixed,
 		.issue			= io_read,
 	},
 	[IORING_OP_WRITE_FIXED] = {
@@ -112,7 +112,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.prep			= io_prep_rw_fixed,
+		.prep			= io_prep_write_fixed,
 		.issue			= io_write,
 	},
 	[IORING_OP_POLL_ADD] = {
@@ -239,7 +239,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.prep			= io_prep_rw,
+		.prep			= io_prep_read,
 		.issue			= io_read,
 	},
 	[IORING_OP_WRITE] = {
@@ -252,7 +252,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.prep			= io_prep_rw,
+		.prep			= io_prep_write,
 		.issue			= io_write,
 	},
 	[IORING_OP_FADVISE] = {
@@ -490,14 +490,12 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_READV] = {
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READV",
-		.prep_async		= io_readv_prep_async,
 		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITEV] = {
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITEV",
-		.prep_async		= io_writev_prep_async,
 		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
@@ -699,6 +697,7 @@ const struct io_cold_def io_cold_defs[] = {
 #endif
 	},
 	[IORING_OP_READ_MULTISHOT] = {
+		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ_MULTISHOT",
 	},
 	[IORING_OP_WAITID] = {
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 35216e8adc29..583fe61a0acb 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -75,7 +75,153 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 	return 0;
 }
 
-int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int __io_import_iovec(int ddir, struct io_kiocb *req,
+			     struct io_async_rw *io,
+			     unsigned int issue_flags)
+{
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	void __user *buf;
+	size_t sqe_len;
+
+	buf = u64_to_user_ptr(rw->addr);
+	sqe_len = rw->len;
+
+	if (!def->vectored || req->flags & REQ_F_BUFFER_SELECT) {
+		if (io_do_buffer_select(req)) {
+			buf = io_buffer_select(req, &sqe_len, issue_flags);
+			if (!buf)
+				return -ENOBUFS;
+			rw->addr = (unsigned long) buf;
+			rw->len = sqe_len;
+		}
+
+		return import_ubuf(ddir, buf, sqe_len, &io->s.iter);
+	}
+
+	io->free_iovec = io->s.fast_iov;
+	return __import_iovec(ddir, buf, sqe_len, UIO_FASTIOV, &io->free_iovec,
+				&io->s.iter, req->ctx->compat);
+}
+
+static inline int io_import_iovec(int rw, struct io_kiocb *req,
+				  struct io_async_rw *io,
+				  unsigned int issue_flags)
+{
+	int ret;
+
+	ret = __io_import_iovec(rw, req, io, issue_flags);
+	if (unlikely(ret < 0))
+		return ret;
+
+	iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+	return 0;
+}
+
+static void io_rw_iovec_free(struct io_async_rw *rw)
+{
+	if (rw->free_iovec) {
+		kfree(rw->free_iovec);
+		rw->free_iovec = NULL;
+	}
+}
+
+static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_async_rw *rw = req->async_data;
+
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_rw_iovec_free(rw);
+		return;
+	}
+	if (io_alloc_cache_put(&req->ctx->rw_cache, &rw->cache)) {
+		req->async_data = NULL;
+		req->flags &= ~REQ_F_ASYNC_DATA;
+	}
+}
+
+static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
+{
+	/*
+	 * Disable quick recycling for anything that's gone through io-wq.
+	 * In theory, this should be fine to cleanup. However, some read or
+	 * write iter handling touches the iovec AFTER having called into the
+	 * handler, eg to reexpand or revert. This means we can have:
+	 *
+	 * task			io-wq
+	 *   issue
+	 *     punt to io-wq
+	 *			issue
+	 *			  blkdev_write_iter()
+	 *			    ->ki_complete()
+	 *			      io_complete_rw()
+	 *			        queue tw complete
+	 *  run tw
+	 *    req_rw_cleanup
+	 *			iov_iter_count() <- look at iov_iter again
+	 *
+	 * which can lead to a UAF. This is only possible for io-wq offload
+	 * as the cleanup can run in parallel. As io-wq is not the fast path,
+	 * just leave cleanup to the end.
+	 *
+	 * This is really a bug in the core code that does this, any issue
+	 * path should assume that a successful (or -EIOCBQUEUED) return can
+	 * mean that the underlying data can be gone at any time. But that
+	 * should be fixed seperately, and then this check could be killed.
+	 */
+	if (!(req->flags & REQ_F_REFCOUNT)) {
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+		io_rw_recycle(req, issue_flags);
+	}
+}
+
+static int io_rw_alloc_async(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_cache_entry *entry;
+	struct io_async_rw *rw;
+
+	entry = io_alloc_cache_get(&ctx->rw_cache);
+	if (entry) {
+		rw = container_of(entry, struct io_async_rw, cache);
+		req->flags |= REQ_F_ASYNC_DATA;
+		req->async_data = rw;
+		goto done;
+	}
+
+	if (!io_alloc_async_data(req)) {
+		rw = req->async_data;
+done:
+		rw->free_iovec = NULL;
+		rw->bytes_done = 0;
+		return 0;
+	}
+
+	return -ENOMEM;
+}
+
+static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
+{
+	struct io_async_rw *rw;
+	int ret;
+
+	if (io_rw_alloc_async(req))
+		return -ENOMEM;
+
+	if (!do_import || io_do_buffer_select(req))
+		return 0;
+
+	rw = req->async_data;
+	ret = io_import_iovec(ddir, req, rw, 0);
+	if (unlikely(ret < 0))
+		return ret;
+
+	iov_iter_save_state(&rw->s.iter, &rw->s.iter_state);
+	return 0;
+}
+
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int ddir, bool do_import)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
@@ -100,34 +246,58 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
-	return 0;
+	return io_prep_rw_setup(req, ddir, do_import);
 }
 
-int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	return io_prep_rw(req, sqe, ITER_DEST, true);
+}
+
+int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return io_prep_rw(req, sqe, ITER_SOURCE, true);
+}
+
+static int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		       int ddir)
+{
+	const bool do_import = !(req->flags & REQ_F_BUFFER_SELECT);
 	int ret;
 
-	ret = io_prep_rw(req, sqe);
+	ret = io_prep_rw(req, sqe, ddir, do_import);
 	if (unlikely(ret))
 		return ret;
+	if (do_import)
+		return 0;
 
 	/*
 	 * Have to do this validation here, as this is in io_read() rw->len
 	 * might have chanaged due to buffer selection
 	 */
-	if (req->flags & REQ_F_BUFFER_SELECT)
-		return io_iov_buffer_select_prep(req);
+	return io_iov_buffer_select_prep(req);
+}
 
-	return 0;
+int io_prep_readv(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return io_prep_rwv(req, sqe, ITER_DEST);
+}
+
+int io_prep_writev(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return io_prep_rwv(req, sqe, ITER_SOURCE);
 }
 
-int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			    int ddir)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_async_rw *io;
 	u16 index;
 	int ret;
 
-	ret = io_prep_rw(req, sqe);
+	ret = io_prep_rw(req, sqe, ddir, false);
 	if (unlikely(ret))
 		return ret;
 
@@ -136,7 +306,21 @@ int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
 	req->imu = ctx->user_bufs[index];
 	io_req_set_rsrc_node(req, ctx, 0);
-	return 0;
+
+	io = req->async_data;
+	ret = io_import_fixed(ddir, &io->s.iter, req->imu, rw->addr, rw->len);
+	iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+	return ret;
+}
+
+int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return io_prep_rw_fixed(req, sqe, ITER_DEST);
+}
+
+int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return io_prep_rw_fixed(req, sqe, ITER_SOURCE);
 }
 
 /*
@@ -152,7 +336,7 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 
-	ret = io_prep_rw(req, sqe);
+	ret = io_prep_rw(req, sqe, ITER_DEST, false);
 	if (unlikely(ret))
 		return ret;
 
@@ -165,9 +349,7 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 void io_readv_writev_cleanup(struct io_kiocb *req)
 {
-	struct io_async_rw *io = req->async_data;
-
-	kfree(io->free_iovec);
+	io_rw_iovec_free(req->async_data);
 }
 
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
@@ -188,14 +370,11 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 }
 
 #ifdef CONFIG_BLOCK
-static bool io_resubmit_prep(struct io_kiocb *req)
+static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
 
-	if (!req_has_async_data(req))
-		return !io_req_prep_async(req);
 	iov_iter_restore(&io->s.iter, &io->s.iter_state);
-	return true;
 }
 
 static bool io_rw_should_reissue(struct io_kiocb *req)
@@ -224,9 +403,8 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	return true;
 }
 #else
-static bool io_resubmit_prep(struct io_kiocb *req)
+static void io_resubmit_prep(struct io_kiocb *req)
 {
-	return false;
 }
 static bool io_rw_should_reissue(struct io_kiocb *req)
 {
@@ -308,6 +486,7 @@ void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
 		req->cqe.flags |= io_put_kbuf(req, 0);
 
+	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(req, ts);
 }
 
@@ -388,6 +567,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 			io_req_io_end(req);
 			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
+			io_req_rw_cleanup(req, issue_flags);
 			return IOU_OK;
 		}
 	} else {
@@ -396,71 +576,12 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
-		if (io_resubmit_prep(req))
-			return -EAGAIN;
-		else
-			io_req_task_queue_fail(req, final_ret);
+		io_resubmit_prep(req);
+		return -EAGAIN;
 	}
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
-static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
-				       struct io_rw_state *s,
-				       unsigned int issue_flags)
-{
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	struct iov_iter *iter = &s->iter;
-	u8 opcode = req->opcode;
-	struct iovec *iovec;
-	void __user *buf;
-	size_t sqe_len;
-	ssize_t ret;
-
-	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
-		ret = io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len);
-		if (ret)
-			return ERR_PTR(ret);
-		return NULL;
-	}
-
-	buf = u64_to_user_ptr(rw->addr);
-	sqe_len = rw->len;
-
-	if (!io_issue_defs[opcode].vectored || req->flags & REQ_F_BUFFER_SELECT) {
-		if (io_do_buffer_select(req)) {
-			buf = io_buffer_select(req, &sqe_len, issue_flags);
-			if (!buf)
-				return ERR_PTR(-ENOBUFS);
-			rw->addr = (unsigned long) buf;
-			rw->len = sqe_len;
-		}
-
-		ret = import_ubuf(ddir, buf, sqe_len, iter);
-		if (ret)
-			return ERR_PTR(ret);
-		return NULL;
-	}
-
-	iovec = s->fast_iov;
-	ret = __import_iovec(ddir, buf, sqe_len, UIO_FASTIOV, &iovec, iter,
-			      req->ctx->compat);
-	if (unlikely(ret < 0))
-		return ERR_PTR(ret);
-	return iovec;
-}
-
-static inline int io_import_iovec(int rw, struct io_kiocb *req,
-				  struct iovec **iovec, struct io_rw_state *s,
-				  unsigned int issue_flags)
-{
-	*iovec = __io_import_iovec(rw, req, s, issue_flags);
-	if (IS_ERR(*iovec))
-		return PTR_ERR(*iovec);
-
-	iov_iter_save_state(&s->iter, &s->iter_state);
-	return 0;
-}
-
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
 {
 	return (kiocb->ki_filp->f_mode & FMODE_STREAM) ? NULL : &kiocb->ki_pos;
@@ -532,89 +653,6 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 	return ret;
 }
 
-static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
-			  const struct iovec *fast_iov, struct iov_iter *iter)
-{
-	struct io_async_rw *io = req->async_data;
-
-	memcpy(&io->s.iter, iter, sizeof(*iter));
-	io->free_iovec = iovec;
-	io->bytes_done = 0;
-	/* can only be fixed buffers, no need to do anything */
-	if (iov_iter_is_bvec(iter) || iter_is_ubuf(iter))
-		return;
-	if (!iovec) {
-		unsigned iov_off = 0;
-
-		io->s.iter.__iov = io->s.fast_iov;
-		if (iter->__iov != fast_iov) {
-			iov_off = iter_iov(iter) - fast_iov;
-			io->s.iter.__iov += iov_off;
-		}
-		if (io->s.fast_iov != fast_iov)
-			memcpy(io->s.fast_iov + iov_off, fast_iov + iov_off,
-			       sizeof(struct iovec) * iter->nr_segs);
-	} else {
-		req->flags |= REQ_F_NEED_CLEANUP;
-	}
-}
-
-static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
-			     struct io_rw_state *s, bool force)
-{
-	if (!force && !io_cold_defs[req->opcode].prep_async)
-		return 0;
-	/* opcode type doesn't need async data */
-	if (!io_cold_defs[req->opcode].async_size)
-		return 0;
-	if (!req_has_async_data(req)) {
-		struct io_async_rw *iorw;
-
-		if (io_alloc_async_data(req)) {
-			kfree(iovec);
-			return -ENOMEM;
-		}
-
-		io_req_map_rw(req, iovec, s->fast_iov, &s->iter);
-		iorw = req->async_data;
-		/* we've copied and mapped the iter, ensure state is saved */
-		iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
-	}
-	return 0;
-}
-
-static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
-{
-	struct io_async_rw *iorw = req->async_data;
-	struct iovec *iov;
-	int ret;
-
-	iorw->bytes_done = 0;
-	iorw->free_iovec = NULL;
-
-	/* submission path, ->uring_lock should already be taken */
-	ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
-	if (unlikely(ret < 0))
-		return ret;
-
-	if (iov) {
-		iorw->free_iovec = iov;
-		req->flags |= REQ_F_NEED_CLEANUP;
-	}
-
-	return 0;
-}
-
-int io_readv_prep_async(struct io_kiocb *req)
-{
-	return io_rw_prep_async(req, ITER_DEST);
-}
-
-int io_writev_prep_async(struct io_kiocb *req)
-{
-	return io_rw_prep_async(req, ITER_SOURCE);
-}
-
 /*
  * This is our waitqueue callback handler, registered through __folio_lock_async()
  * when we initially tried to do the IO with the iocb armed our waitqueue.
@@ -754,54 +792,28 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 
 static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	struct io_rw_state __s, *s = &__s;
-	struct iovec *iovec;
+	struct io_async_rw *io = req->async_data;
 	struct kiocb *kiocb = &rw->kiocb;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	struct io_async_rw *io;
-	ssize_t ret, ret2;
+	ssize_t ret;
 	loff_t *ppos;
 
-	if (!req_has_async_data(req)) {
-		ret = io_import_iovec(ITER_DEST, req, &iovec, s, issue_flags);
+	if (io_do_buffer_select(req)) {
+		ret = io_import_iovec(ITER_DEST, req, io, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
-	} else {
-		io = req->async_data;
-		s = &io->s;
-
-		/*
-		 * Safe and required to re-import if we're using provided
-		 * buffers, as we dropped the selected one before retry.
-		 */
-		if (io_do_buffer_select(req)) {
-			ret = io_import_iovec(ITER_DEST, req, &iovec, s, issue_flags);
-			if (unlikely(ret < 0))
-				return ret;
-		}
-
-		/*
-		 * We come here from an earlier attempt, restore our state to
-		 * match in case it doesn't. It's cheap enough that we don't
-		 * need to make this conditional.
-		 */
-		iov_iter_restore(&s->iter, &s->iter_state);
-		iovec = NULL;
 	}
+
 	ret = io_rw_init_file(req, FMODE_READ);
-	if (unlikely(ret)) {
-		kfree(iovec);
+	if (unlikely(ret))
 		return ret;
-	}
-	req->cqe.res = iov_iter_count(&s->iter);
+	req->cqe.res = iov_iter_count(&io->s.iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req))) {
-			ret = io_setup_async_rw(req, iovec, s, true);
-			return ret ?: -EAGAIN;
-		}
+		if (unlikely(!io_file_supports_nowait(req)))
+			return -EAGAIN;
 		kiocb->ki_flags |= IOCB_NOWAIT;
 	} else {
 		/* Ensure we clear previously set non-block flag */
@@ -811,20 +823,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ppos = io_kiocb_update_pos(req);
 
 	ret = rw_verify_area(READ, req->file, ppos, req->cqe.res);
-	if (unlikely(ret)) {
-		kfree(iovec);
+	if (unlikely(ret))
 		return ret;
-	}
 
-	ret = io_iter_do_read(rw, &s->iter);
+	ret = io_iter_do_read(rw, &io->s.iter);
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
-		/*
-		 * If we can poll, just do that. For a vectored read, we'll
-		 * need to copy state first.
-		 */
-		if (io_file_can_poll(req) && !io_issue_defs[req->opcode].vectored)
+		/* If we can poll, just do that. */
+		if (io_file_can_poll(req))
 			return -EAGAIN;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -834,8 +841,6 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 			goto done;
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
-		if (iovec)
-			kfree(iovec);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
 		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
@@ -848,21 +853,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * untouched in case of error. Restore it and we'll advance it
 	 * manually if we need to.
 	 */
-	iov_iter_restore(&s->iter, &s->iter_state);
-
-	ret2 = io_setup_async_rw(req, iovec, s, true);
-	iovec = NULL;
-	if (ret2) {
-		ret = ret > 0 ? ret : ret2;
-		goto done;
-	}
-
-	io = req->async_data;
-	s = &io->s;
-	/*
-	 * Now use our persistent iterator and state, if we aren't already.
-	 * We've restored and mapped the iter to match.
-	 */
+	iov_iter_restore(&io->s.iter, &io->s.iter_state);
 
 	do {
 		/*
@@ -870,11 +861,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * above or inside this loop. Advance the iter by the bytes
 		 * that were consumed.
 		 */
-		iov_iter_advance(&s->iter, ret);
-		if (!iov_iter_count(&s->iter))
+		iov_iter_advance(&io->s.iter, ret);
+		if (!iov_iter_count(&io->s.iter))
 			break;
 		io->bytes_done += ret;
-		iov_iter_save_state(&s->iter, &s->iter_state);
+		iov_iter_save_state(&io->s.iter, &io->s.iter_state);
 
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
@@ -882,24 +873,22 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 
-		req->cqe.res = iov_iter_count(&s->iter);
+		req->cqe.res = iov_iter_count(&io->s.iter);
 		/*
 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
 		 * we get -EIOCBQUEUED, then we'll get a notification when the
 		 * desired page gets unlocked. We can also get a partial read
 		 * here, and if we do, then just retry at the new offset.
 		 */
-		ret = io_iter_do_read(rw, &s->iter);
+		ret = io_iter_do_read(rw, &io->s.iter);
 		if (ret == -EIOCBQUEUED)
 			return IOU_ISSUE_SKIP_COMPLETE;
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
-		iov_iter_restore(&s->iter, &s->iter_state);
+		iov_iter_restore(&io->s.iter, &io->s.iter_state);
 	} while (ret > 0);
 done:
 	/* it's faster to check here then delegate to kfree */
-	if (iovec)
-		kfree(iovec);
 	return ret;
 }
 
@@ -908,8 +897,9 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	ret = __io_read(req, issue_flags);
-	if (ret >= 0)
-		return kiocb_done(req, ret, issue_flags);
+	if (ret >= 0) {
+		ret = kiocb_done(req, ret, issue_flags);
+	}
 
 	return ret;
 }
@@ -974,6 +964,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 * multishot request, hitting overflow will terminate it.
 	 */
 	io_req_set_res(req, ret, cflags);
+	io_req_rw_cleanup(req, issue_flags);
 	if (issue_flags & IO_URING_F_MULTISHOT)
 		return IOU_STOP_MULTISHOT;
 	return IOU_OK;
@@ -981,42 +972,28 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	struct io_rw_state __s, *s = &__s;
-	struct iovec *iovec;
+	struct io_async_rw *io = req->async_data;
 	struct kiocb *kiocb = &rw->kiocb;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
-	if (!req_has_async_data(req)) {
-		ret = io_import_iovec(ITER_SOURCE, req, &iovec, s, issue_flags);
-		if (unlikely(ret < 0))
-			return ret;
-	} else {
-		struct io_async_rw *io = req->async_data;
-
-		s = &io->s;
-		iov_iter_restore(&s->iter, &s->iter_state);
-		iovec = NULL;
-	}
 	ret = io_rw_init_file(req, FMODE_WRITE);
-	if (unlikely(ret)) {
-		kfree(iovec);
+	if (unlikely(ret))
 		return ret;
-	}
-	req->cqe.res = iov_iter_count(&s->iter);
+	req->cqe.res = iov_iter_count(&io->s.iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
 		if (unlikely(!io_file_supports_nowait(req)))
-			goto copy_iov;
+			goto ret_eagain;
 
 		/* File path supports NOWAIT for non-direct_IO only for block devices. */
 		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
 			!(kiocb->ki_filp->f_mode & FMODE_BUF_WASYNC) &&
 			(req->flags & REQ_F_ISREG))
-			goto copy_iov;
+			goto ret_eagain;
 
 		kiocb->ki_flags |= IOCB_NOWAIT;
 	} else {
@@ -1027,19 +1004,17 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ppos = io_kiocb_update_pos(req);
 
 	ret = rw_verify_area(WRITE, req->file, ppos, req->cqe.res);
-	if (unlikely(ret)) {
-		kfree(iovec);
+	if (unlikely(ret))
 		return ret;
-	}
 
 	if (req->flags & REQ_F_ISREG)
 		kiocb_start_write(kiocb);
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (likely(req->file->f_op->write_iter))
-		ret2 = call_write_iter(req->file, kiocb, &s->iter);
+		ret2 = call_write_iter(req->file, kiocb, &io->s.iter);
 	else if (req->file->f_op->write)
-		ret2 = loop_rw_iter(WRITE, rw, &s->iter);
+		ret2 = loop_rw_iter(WRITE, rw, &io->s.iter);
 	else
 		ret2 = -EINVAL;
 
@@ -1060,11 +1035,9 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
-			goto copy_iov;
+			goto ret_eagain;
 
 		if (ret2 != req->cqe.res && ret2 >= 0 && need_complete_io(req)) {
-			struct io_async_rw *io;
-
 			trace_io_uring_short_write(req->ctx, kiocb->ki_pos - ret2,
 						req->cqe.res, ret2);
 
@@ -1073,33 +1046,22 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 			 * in the worker. Also update bytes_done to account for
 			 * the bytes already written.
 			 */
-			iov_iter_save_state(&s->iter, &s->iter_state);
-			ret = io_setup_async_rw(req, iovec, s, true);
-
-			io = req->async_data;
-			if (io)
-				io->bytes_done += ret2;
+			iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+			io->bytes_done += ret2;
 
 			if (kiocb->ki_flags & IOCB_WRITE)
 				io_req_end_write(req);
-			return ret ? ret : -EAGAIN;
+			return -EAGAIN;
 		}
 done:
 		ret = kiocb_done(req, ret2, issue_flags);
 	} else {
-copy_iov:
-		iov_iter_restore(&s->iter, &s->iter_state);
-		ret = io_setup_async_rw(req, iovec, s, false);
-		if (!ret) {
-			if (kiocb->ki_flags & IOCB_WRITE)
-				io_req_end_write(req);
-			return -EAGAIN;
-		}
-		return ret;
+ret_eagain:
+		iov_iter_restore(&io->s.iter, &io->s.iter_state);
+		if (kiocb->ki_flags & IOCB_WRITE)
+			io_req_end_write(req);
+		return -EAGAIN;
 	}
-	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
 	return ret;
 }
 
@@ -1174,6 +1136,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			break;
 		nr_events++;
 		req->cqe.flags = io_put_kbuf(req, 0);
+		if (req->opcode != IORING_OP_URING_CMD)
+			io_req_rw_cleanup(req, 0);
 	}
 	if (unlikely(!nr_events))
 		return 0;
@@ -1187,3 +1151,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	__io_submit_flush_completions(ctx);
 	return nr_events;
 }
+
+void io_rw_cache_free(struct io_cache_entry *entry)
+{
+	struct io_async_rw *rw;
+
+	rw = container_of(entry, struct io_async_rw, cache);
+	kfree(rw);
+}
diff --git a/io_uring/rw.h b/io_uring/rw.h
index f9e89b4fe4da..f7905070d10b 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -9,21 +9,26 @@ struct io_rw_state {
 };
 
 struct io_async_rw {
+	union {
+		size_t			bytes_done;
+		struct io_cache_entry	cache;
+	};
 	struct io_rw_state		s;
-	const struct iovec		*free_iovec;
-	size_t				bytes_done;
+	struct iovec			*free_iovec;
 	struct wait_page_queue		wpq;
 };
 
-int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_readv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_writev(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read(struct io_kiocb *req, unsigned int issue_flags);
-int io_readv_prep_async(struct io_kiocb *req);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
-int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
 void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts);
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
+void io_rw_cache_free(struct io_cache_entry *entry);
-- 
2.43.0


