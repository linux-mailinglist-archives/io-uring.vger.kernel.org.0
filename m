Return-Path: <io-uring+bounces-8284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EA0AD2515
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 19:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2503D16EAF5
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 17:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A9B21A931;
	Mon,  9 Jun 2025 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IqgY5Hvh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A3E21B191
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749490754; cv=none; b=dIFruiBLIOSz0GE/Q5NThnFmnhy5DwkA5wEWe+8hem/6WHupwT4bMbZKzmf2vEJNAM9/d6O8xvyu3DPjL8+phY7+4CgK6Nmz5/yFPBmblIpHce80hEKXs91cx3QuLXDowUlUs44nhVFR5degDtoY4CX8OTLdvGpJZ9NiBVAZavE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749490754; c=relaxed/simple;
	bh=STn+ztrE6NJW07svoUHmlKM66vOPGmawxypN0MvmQnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dde1UZFRpb8Nu9yaYoQM0e3xOFWxdf80h728AyLY6Ubv/P/WXv/ui6a0tvUlGnRuSZ+Uon7F4+6dlqBqmKK92zWGOhLpbInRuQdJPvwYwFVjeUl5McdlVpw6qScmOtKH5w6EJos4XFdbzjmCcvUeGx1N2oOrwnLG9wX/0jBUjaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IqgY5Hvh; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86d0c5981b3so153936139f.3
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 10:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749490751; x=1750095551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7P/+YdjdpsEE10P0sQZ1zhUk6eM4/bv0WEfoprwSJpw=;
        b=IqgY5HvhvA8/XnytuArNwYxYlEW5v3mGl+uiOm8RxTMcGBqfawBjCcpN6oUeFJ6Xkn
         2akxz1Fkp2ArB2CSgZtW8BuwnpJSbCje9VtPFsMqW9CmfCYD5AEOEpF4UoZTjs4S/PsF
         /hUmWo+XouLYsB8fcvCxtu5lCsJe/9zVKuJpCDaZdoFGepLV3BaKBvun7W0p343aM8o/
         rDoBs7TGS97+rFDGPnkYAZJPWUQBOsk6RwGTLE/0PlFwl23+NVGv90iLAwbnlv0JQ+q6
         0c8NTieArZSrtV8dpdx9jIHRgmJ+m5glc/eYDgWSYbi5oj+hecxfF+cxRClKhdKHjAGU
         lKLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749490751; x=1750095551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7P/+YdjdpsEE10P0sQZ1zhUk6eM4/bv0WEfoprwSJpw=;
        b=Rao6tipEVHb/zWoXVFXo1uQ/s2cE637qwRJUqGFHSe27tyJN7DiFe9J86eY4glzJOp
         a1+Odrx9AMruYLzKa5v4pV3DkrDMzRSq0SNgd8jT6s/X+HpXOveH93pTmB83dRWRPrBG
         a4g6axf1YwNMvyxvE3z59ip6rEbFptI3jQyg0vIjNDvIBYRIwYulr5HNGwQKb7jgVpi9
         M3mZvug24fjDcwONPkV5uBz5r2q90Yz+5VGJX1D63KfKAz84LvuQkiQLfSOyGCaVH5qW
         wqKaUVRNIs8myyQ60ANLNtaxlnu+qZMQMo10ZfY5dTMUvdN2NdIKGXgI4ZDjYSpv/Ccs
         WIcw==
X-Gm-Message-State: AOJu0Yx59LjMEAwJZzqWuwXvpcAKHDiFa95V+nYw9EhCbCa5YgGgL+Vj
	H19BzxwVRRHaiRR+6hm3cZWlLhMNiYskKaxhOHFXhL+d8UcRlBvORMdpH+aasIXjcBYO0xEJNKI
	uhK6K
X-Gm-Gg: ASbGncs/kUOlplY8s0O8SZ4hRDdooXX+ansKCyrsLNeldZ4Gh4sPkPF2ugZRKezdZ6V
	mfIO+T2e16tWX6lXFU52v03bhhm70ILsTRREdyr/Y3mXkBsPyvVMuhHWKW0cR3AJG7AfjqCV4TJ
	GMp8J882HdHZhSW4FUUWSmpzO6rOQ7PYdp35dLl9Uj6q/GmFSUqR92bM60H1wI2ci+cD0iaBREf
	KAh52vrRM/KA5mPnxAtzGXZWVGfu+x8xXDCPjndlltAz/jHGdudG7HkgKKweOJPTXjPQ8fddrBc
	j1DYQg8GgXxnYF1O7vBmifHkC55mE8Hy+P2VeJsNAVKddT/OOygbwGfF
X-Google-Smtp-Source: AGHT+IFJeOjWIktp3DOMZ+wphWda/N80RDWqsKVfbeFFJhEDtNs9CCO17rThIhoCawNwaSWzpORcIw==
X-Received: by 2002:a05:6602:3608:b0:86d:60:702f with SMTP id ca18e2360f4ac-8733651c11bmr1573192939f.0.1749490750706;
        Mon, 09 Jun 2025 10:39:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87338a1eb84sm166607639f.44.2025.06.09.10.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 10:39:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
Date: Mon,  9 Jun 2025 11:36:34 -0600
Message-ID: <20250609173904.62854-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250609173904.62854-1-axboe@kernel.dk>
References: <20250609173904.62854-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Will be called by the core of io_uring, if inline issue is not going
to be tried for a request. Opcodes can define this handler to defer
copying of SQE data that should remain stable.

Only called if IO_URING_F_INLINE is set. If it isn't set, then there's a
bug in the core handling of this, and -EFAULT will be returned instead
to terminate the request. This will trigger a WARN_ON_ONCE(). Don't
expect this to ever trigger, and down the line this can be removed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            | 27 +++++++++++++++++++++++++--
 io_uring/opdef.h               |  1 +
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 054c43c02c96..a0331ab80b2d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -504,6 +504,7 @@ enum {
 	REQ_F_BUF_NODE_BIT,
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
+	REQ_F_SQE_COPY_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -593,6 +594,8 @@ enum {
 	 * For SEND_ZC, whether to import buffers (i.e. the first issue).
 	 */
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
+	/* ->sqe_copy() has been called, if necessary */
+	REQ_F_SQE_COPY		= IO_REQ_FLAG(REQ_F_SQE_COPY_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0f9f6a173e66..3768d426c2ad 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1935,14 +1935,34 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 	return file;
 }
 
-static void io_queue_async(struct io_kiocb *req, int ret)
+static int io_req_sqe_copy(struct io_kiocb *req, unsigned int issue_flags)
+{
+	const struct io_cold_def *def = &io_cold_defs[req->opcode];
+
+	if (req->flags & REQ_F_SQE_COPY)
+		return 0;
+	req->flags |= REQ_F_SQE_COPY;
+	if (!def->sqe_copy)
+		return 0;
+	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_INLINE)))
+		return -EFAULT;
+	def->sqe_copy(req);
+	return 0;
+}
+
+static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int ret)
 	__must_hold(&req->ctx->uring_lock)
 {
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
+fail:
 		io_req_defer_failed(req, ret);
 		return;
 	}
 
+	ret = io_req_sqe_copy(req, issue_flags);
+	if (unlikely(ret))
+		goto fail;
+
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
 		io_kbuf_recycle(req, 0);
@@ -1971,7 +1991,7 @@ static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (unlikely(ret))
-		io_queue_async(req, ret);
+		io_queue_async(req, issue_flags, ret);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
@@ -1986,6 +2006,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		req->flags |= REQ_F_LINK;
 		io_req_defer_failed(req, req->cqe.res);
 	} else {
+		/* can't fail with IO_URING_F_INLINE */
+		io_req_sqe_copy(req, IO_URING_F_INLINE);
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
@@ -2197,6 +2219,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 */
 	if (unlikely(link->head)) {
 		trace_io_uring_link(req, link->last);
+		io_req_sqe_copy(req, IO_URING_F_INLINE);
 		link->last->link = req;
 		link->last = req;
 
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 719a52104abe..c2f0907ed78c 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -38,6 +38,7 @@ struct io_issue_def {
 struct io_cold_def {
 	const char		*name;
 
+	void (*sqe_copy)(struct io_kiocb *);
 	void (*cleanup)(struct io_kiocb *);
 	void (*fail)(struct io_kiocb *);
 };
-- 
2.49.0


