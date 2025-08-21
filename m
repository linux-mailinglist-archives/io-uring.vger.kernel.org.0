Return-Path: <io-uring+bounces-9139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97289B2EB16
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F0A4567630
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFCF194124;
	Thu, 21 Aug 2025 02:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aA9S96ya"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1452D8DB9
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742119; cv=none; b=GS4Kz+P/Xljptas92R1NiQ1zLqgsU+Yo+zmP1Vpi+xMhq3gAiw4zwmdewjzVIVOp12czpTGNayqnkIKe288B4foGzSF9BFrpezLXREgSnzY9J91rM6p95UtU+XfgLW71dUgqG1tQW/64WZw7ixTFwWtbAmBm+bCiNttOHIbt07U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742119; c=relaxed/simple;
	bh=sJ96v/IZlwTbv/vzEaXk2rdfA851eqlTdXRDJh0w1Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfKAS7pKXMOgJJpzjB3pqvequzLMjvT9c4XI0gEcQvOVBohvmxlnZeRncOSOdb+j/SIhloiuRozc7W9rYmreHsD+feXOtGJMNDIAV+dmSIskbDZwpliWjkaRTfl4e0BKeECUGeJPJ2pqrApmqwKS9YfGUMskszDS0mstdksx64Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aA9S96ya; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2ea79219so680245b3a.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742117; x=1756346917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dlN/A28hWFRX0QCIk49ABAjw8n623UwJjvvdh/fyKk=;
        b=aA9S96ya5U62/se2ZD91XykSUq71LurA9E9yYhJ3rIyPhLm5VDziUnSkUsp3LQLYkU
         zvS93U+qdA3gh1kUI1TfBACVyZGdMFwbesx6NK/5dmT3p1V5KKZC1h+pzI/GjN8dLuP/
         9HxQj6RgF31in8s1p3BJz8FkJsbMtsKUa7cxmvKsEaznW42uswkFxo73WZ4MTOW1ueTw
         TUvY8e7DPWUlSjm0Cfs4WIT28IxgMbL6V4RrDZoxJk/cxV8loO+21BSJZKpbMaWyLUS7
         UWUkX+p0RKc6XYdXqZWEQMXk6zJ6wmN4baFTyVYH4m6O32Wjo4yM5U8GUNgnE06ZFqi6
         e2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742117; x=1756346917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2dlN/A28hWFRX0QCIk49ABAjw8n623UwJjvvdh/fyKk=;
        b=hqJifkt+Pwo+SzTy1LCG/suaFc9jEjrZkFQM87LLPCyAHTEw2wTudfEm7a+nu5STUc
         7Ky3onBh3vn3JIDBtVSm6dDR7DFZUY5ufU5NaqtsQELtwyZC6yu+mp+8dy2bSu571+ii
         R7g2xvNxLFL7dAZa4CUSWxlwYjeanP2y8hyBPVLyxp6hiqsJHz3iwut4PAH4TqxP8XiK
         KeB1TS9oLPCQvz1T840DYNfgyBdZufQDc9j85qdqi9vBrXmHvuBLbExC20x/vwiP8/ww
         RshSIUYCvU6TwyJcESmMxdqqqFxIqSELwZWB1CH6WWUKpp5h4leVOlb1d9sv4pXDzTeJ
         zV0A==
X-Gm-Message-State: AOJu0Yx8brFBuL4F+WoF/lAstkpCMx031WaHfTPFb68cWGvqsvmD94Ev
	gr1obwbHLX4noIhJL5HI+CxxGZhjozh/y0T9qL1LprZBGjmg1YVyvAzaCc4cZmQuDdQq3ZygbPi
	QzmKq
X-Gm-Gg: ASbGnctNW4tJFfJV4qK3+hGvmA69S2nZPugiKzFpfEndfwaMw4rgzlcIqp9/d0AV3+6
	JsTyH4Jj5hukmfpswIVfaJ2eg0aLYpnFPCAD3GFZKDwC03/dCwetq94lm71iA5eFysa8Hpa0nWZ
	Bk7YFrc7W8X8+Q29Knwa8/iu9D8W+mz11/2ll2skP/pLjSsaq1dymdbdZNg9qO+iklzeV+AIlXI
	Xrk9Ri8K1MB5+O5v8hkVoDzVLvflgKJxB1P/ZIUNd88LgIhtOK5M0Vs5Yo7QdHOpy/VQilz+hAR
	WmgS4gjr7GIvyDQF+qyDbvtZ1iA1c7sJnyL4LUNy1VKJm3bFlQPyBbOTZzs72TA2Jn2mOnxjLLt
	zbCHPgFk=
X-Google-Smtp-Source: AGHT+IGl90COCuSSqBOyD6E+TQrfQckOghMqJnAcKcTyieXwjE/+XHKvHvX0Um+BA05p8jzdNWO9wA==
X-Received: by 2002:a05:6a20:7488:b0:240:406b:194c with SMTP id adf61e73a8af0-24330a69b4amr831472637.41.1755742116794;
        Wed, 20 Aug 2025 19:08:36 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/12] io_uring/kbuf: introduce struct io_br_sel
Date: Wed, 20 Aug 2025 20:03:34 -0600
Message-ID: <20250821020750.598432-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than return addresses directly from buffer selection, add a
struct around it. No functional changes in this patch, it's in
preparation for storing more buffer related information locally, rather
than in struct io_kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 26 +++++++++++++-------------
 io_uring/kbuf.h | 19 +++++++++++++++++--
 io_uring/net.c  | 18 +++++++++---------
 io_uring/rw.c   | 34 ++++++++++++++++++++--------------
 4 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index b8b2f6dee754..61d9a8d439ba 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -151,18 +151,18 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 1;
 }
 
-static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
-					  struct io_buffer_list *bl,
-					  unsigned int issue_flags)
+static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+					      struct io_buffer_list *bl,
+					      unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
+	struct io_br_sel sel = { };
 	struct io_uring_buf *buf;
-	void __user *ret;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
-		return NULL;
+		return sel;
 
 	if (head + 1 == tail)
 		req->flags |= REQ_F_BL_EMPTY;
@@ -173,7 +173,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
-	ret = u64_to_user_ptr(buf->addr);
+	sel.addr = u64_to_user_ptr(buf->addr);
 
 	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
@@ -189,27 +189,27 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		io_kbuf_commit(req, bl, *len, 1);
 		req->buf_list = NULL;
 	}
-	return ret;
+	return sel;
 }
 
-void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned buf_group, unsigned int issue_flags)
+struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
+				  unsigned buf_group, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_br_sel sel = { };
 	struct io_buffer_list *bl;
-	void __user *ret = NULL;
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
 		if (bl->flags & IOBL_BUF_RING)
-			ret = io_ring_buffer_select(req, len, bl, issue_flags);
+			sel = io_ring_buffer_select(req, len, bl, issue_flags);
 		else
-			ret = io_provided_buffer_select(req, len, bl);
+			sel.addr = io_provided_buffer_select(req, len, bl);
 	}
 	io_ring_submit_unlock(req->ctx, issue_flags);
-	return ret;
+	return sel;
 }
 
 /* cap it at a reasonable 256, will be one page even for 4K */
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 58451ab4ab8a..e14a43b125c3 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -62,8 +62,23 @@ struct buf_sel_arg {
 	unsigned short partial_map;
 };
 
-void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned buf_group, unsigned int issue_flags);
+/*
+ * Return value from io_buffer_list selection. Just returns the error or
+ * user address for now, will be extended to return the buffer list in the
+ * future.
+ */
+struct io_br_sel {
+	/*
+	 * Some selection parts return the user address, others return an error.
+	 */
+	union {
+		void __user *addr;
+		ssize_t val;
+	};
+};
+
+struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
+				  unsigned buf_group, unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		      unsigned int issue_flags);
 int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
diff --git a/io_uring/net.c b/io_uring/net.c
index 54e13d1b0d0b..12dcc21f2259 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1035,22 +1035,22 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		void __user *buf;
+		struct io_br_sel sel;
 		size_t len = sr->len;
 
-		buf = io_buffer_select(req, &len, sr->buf_group, issue_flags);
-		if (!buf)
+		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
+		if (!sel.addr)
 			return -ENOBUFS;
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
-			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);
+			ret = io_recvmsg_prep_multishot(kmsg, sr, &sel.addr, &len);
 			if (ret) {
 				io_kbuf_recycle(req, req->buf_list, issue_flags);
 				return ret;
 			}
 		}
 
-		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, buf, len);
+		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, sel.addr, len);
 	}
 
 	kmsg->msg.msg_get_inq = 1;
@@ -1153,13 +1153,13 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
 	} else {
-		void __user *buf;
+		struct io_br_sel sel;
 
 		*len = sr->len;
-		buf = io_buffer_select(req, len, sr->buf_group, issue_flags);
-		if (!buf)
+		sel = io_buffer_select(req, len, sr->buf_group, issue_flags);
+		if (!sel.addr)
 			return -ENOBUFS;
-		sr->buf = buf;
+		sr->buf = sel.addr;
 		sr->len = *len;
 map_ubuf:
 		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7fe188872279..ef94cdde5f1f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -107,34 +107,35 @@ static int io_import_vec(int ddir, struct io_kiocb *req,
 }
 
 static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
-			     struct io_async_rw *io,
-			     unsigned int issue_flags)
+				 struct io_async_rw *io, struct io_br_sel *sel,
+				 unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	void __user *buf = u64_to_user_ptr(rw->addr);
 	size_t sqe_len = rw->len;
 
+	sel->addr = u64_to_user_ptr(rw->addr);
 	if (def->vectored && !(req->flags & REQ_F_BUFFER_SELECT))
-		return io_import_vec(ddir, req, io, buf, sqe_len);
+		return io_import_vec(ddir, req, io, sel->addr, sqe_len);
 
 	if (io_do_buffer_select(req)) {
-		buf = io_buffer_select(req, &sqe_len, io->buf_group, issue_flags);
-		if (!buf)
+		*sel = io_buffer_select(req, &sqe_len, io->buf_group, issue_flags);
+		if (!sel->addr)
 			return -ENOBUFS;
-		rw->addr = (unsigned long) buf;
+		rw->addr = (unsigned long) sel->addr;
 		rw->len = sqe_len;
 	}
-	return import_ubuf(ddir, buf, sqe_len, &io->iter);
+	return import_ubuf(ddir, sel->addr, sqe_len, &io->iter);
 }
 
 static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
 				      struct io_async_rw *io,
+				      struct io_br_sel *sel,
 				      unsigned int issue_flags)
 {
 	int ret;
 
-	ret = __io_import_rw_buffer(rw, req, io, issue_flags);
+	ret = __io_import_rw_buffer(rw, req, io, sel, issue_flags);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -306,10 +307,12 @@ static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 static int io_rw_do_import(struct io_kiocb *req, int ddir)
 {
+	struct io_br_sel sel = { };
+
 	if (io_do_buffer_select(req))
 		return 0;
 
-	return io_import_rw_buffer(ddir, req, req->async_data, 0);
+	return io_import_rw_buffer(ddir, req, req->async_data, &sel, 0);
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -899,7 +902,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	return 0;
 }
 
-static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
+		     unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -913,7 +917,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret))
 			return ret;
 	} else if (io_do_buffer_select(req)) {
-		ret = io_import_rw_buffer(ITER_DEST, req, io, issue_flags);
+		ret = io_import_rw_buffer(ITER_DEST, req, io, sel, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
 	}
@@ -1015,9 +1019,10 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_br_sel sel = { };
 	int ret;
 
-	ret = __io_read(req, issue_flags);
+	ret = __io_read(req, &sel, issue_flags);
 	if (ret >= 0)
 		return kiocb_done(req, ret, issue_flags);
 
@@ -1027,6 +1032,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_br_sel sel = { };
 	unsigned int cflags = 0;
 	int ret;
 
@@ -1038,7 +1044,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* make it sync, multishot doesn't support async execution */
 	rw->kiocb.ki_complete = NULL;
-	ret = __io_read(req, issue_flags);
+	ret = __io_read(req, &sel, issue_flags);
 
 	/*
 	 * If we get -EAGAIN, recycle our buffer and just let normal poll
-- 
2.50.1


