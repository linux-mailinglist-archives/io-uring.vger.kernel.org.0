Return-Path: <io-uring+bounces-9116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D70B2E4DF
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C5E65E2A18
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC2F2765E1;
	Wed, 20 Aug 2025 18:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZGQklMBm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0842279794
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714372; cv=none; b=eGAi9WSy1xN0WLtgVnIXxRUS99ihxTmvEO16/bnEf78OpDiOG2wRqJL7/D5id8sgZt1xNJOH9YI57sG5W7MtrwA5FlW7tW+IoBF+gIaw+weJvAugqwFyJLUNVqSf08dsZgC+6qKuqybpVvGn7QnZnd6aYBLUTXYdVvQboVgE+3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714372; c=relaxed/simple;
	bh=U7SmDrJrPH03qM/wwGgKIO62L/XXIbBRHTf9kEP6+Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMP3DkLAGkgGJnYrA7U66tkTMxiwZG6XeR6wsRi9tC3+O1zerN2+6WKgQEalx0V2vBVIA+bgrqkQsDT1XIW4h9fSFopOiC433vfKBfzux+yb6d5VmdPSSbghZBVVGl41caUonAB6LlM7d2kQn0vgaToiV/v+JlXY0AJg3IL5VbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZGQklMBm; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-88432e2975cso3865139f.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714369; x=1756319169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrT3kc/LETmQoRWlJbXxXbxG3ovzmdMtwMWztk2TN2E=;
        b=ZGQklMBmzMnYxvoOsv/6p7Szfp33dXFSOU0thc6w6LnaoZ+LFUddqL3udmVlJgXGDD
         rpM9z7E3jJfTR/LZxY5AvD0C6xecF0kPEcrPqihfFBmtlZ/fi/LIDFGJ92ypy2a3/Vu3
         2cdgvqxubwWBpaS4rEOdODvOLW3PSRFRwfqSZTQsr64pU86MCAdGZrtXoNuoUTmt0AHG
         Hu2mvStOxpphaYRtolChBYCfDeDfFQlQ/vOA7MbhFQJdOPtgDq32hEE7yYhlJk4oJOnD
         D0QD3Q7dLvBy2SIUIWtCgFL9OsBTkkjfDVPYn4npMbNzZtkwqVPSfxEtEXweZ6sv/TOV
         ylHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714369; x=1756319169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LrT3kc/LETmQoRWlJbXxXbxG3ovzmdMtwMWztk2TN2E=;
        b=bJVsZ/SAhdUJSN5fvfkPrR+coGnK/En/6ycEL+LTKx24bGPfcSudNMVDFxWTQ4Bc/K
         RmQY+jYGutK0hxchtRgOCkHEx0/fGfvKFG7FfDiyOtYx2c43Vp5tpWzrNY169Nv2PbFA
         qNdvN6qmeH1qpXL8FOFzFZ4Z71giCxggm8Jp/UjiamcjGa7ZGxTsHUXTi7SpiCL8dJak
         r4jlnoliFRejuxYXvpFLC2RQjK1r9xhtsf06lBlxeTFdXT4xdWdk0UPVhyjzB12F+jR0
         gQikTD+1NvDaqOpC2YWC3A7bdEOP7EPBRRQ0FCizT828ufsAG4q4eKUCC+UdhP02ayrt
         cbKA==
X-Gm-Message-State: AOJu0YygzLIQcYpDm69Poc2k2g6+fsth2jN7pk29RUnBeFAIG/y+z1Md
	MWpkjVY/cTzaO6Wy4zoJsXTVuxWpFSWaAXI61hCJkpH7mCaaAZJkvmd2MoarqdGROC1TppHMIvl
	KUAp+
X-Gm-Gg: ASbGncuETMRpVSJ0t69nzkrwZ3YvJ3kZ8KhoTaF1cOwPBUFW79IXhE+YNA3cn7hXbmD
	Pi5wiy5jsc9bMVF1iqu1DLDm48YzEh3VNTg/VnRjzHOhOXf0JS9fpFXl+BoT5hhi267/rvlnhgR
	hvLJOXk5Dcc1ip8WY3+1tQDCPzmTTeX414wM+hFJnWNzRmWdRP+zN7bgnCl8Xxd7ZOwsgTBLQCV
	Ii68D7tZNTZSheGeRfoTNvp/NMpYycujFlzLvKDpJPzFPklfVjVy/h4fRO5sXu+xf+ZvTn94ZHo
	miEjkFE2sKQlmLA4yu1tTRFVjHGsUYT6gkR/6No1lxeULRcEQQtT4YBdlA0iHUHhOXP5PWGvcnG
	Iy7x+R3676+GTilfG
X-Google-Smtp-Source: AGHT+IFqHDaXDxDrG7aFHl8SO6XgAJzTr7V+5h9dcSkwySwkjqpgeILD7mj7i6R5Hou822PB1Dy8Uw==
X-Received: by 2002:a05:6e02:3e04:b0:3e6:6487:9a9f with SMTP id e9e14a558f8ab-3e67c9edaf2mr60020305ab.5.1755714369426;
        Wed, 20 Aug 2025 11:26:09 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/9] io_uring/kbuf: pass in struct io_buffer_list to commit/recycle helpers
Date: Wed, 20 Aug 2025 12:22:49 -0600
Message-ID: <20250820182601.442933-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than have this implied being in the io_kiocb, pass it in directly
so it's immediately obvious where these users of ->buf_list are coming
from.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  6 +++---
 io_uring/kbuf.c     |  9 +++++----
 io_uring/kbuf.h     | 21 +++++++++++++--------
 io_uring/net.c      | 28 ++++++++++++++--------------
 io_uring/poll.c     |  6 +++---
 io_uring/rw.c       | 14 +++++++-------
 6 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 402363725a66..53dcdd13fbf6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1007,7 +1007,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, res, IO_URING_F_UNLOCKED));
+	io_req_set_res(req, res, io_put_kbuf(req, res, req->buf_list, IO_URING_F_UNLOCKED));
 	if (def->fail)
 		def->fail(req);
 	io_req_complete_defer(req);
@@ -2025,11 +2025,11 @@ static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int r
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f2d2cc319faa..b8b2f6dee754 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -354,9 +354,9 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
 }
 
-static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
+static inline bool __io_put_kbuf_ring(struct io_kiocb *req,
+				      struct io_buffer_list *bl, int len, int nr)
 {
-	struct io_buffer_list *bl = req->buf_list;
 	bool ret = true;
 
 	if (bl)
@@ -366,7 +366,8 @@ static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
 	return ret;
 }
 
-unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs)
+unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
+			    int len, int nbufs)
 {
 	unsigned int ret;
 
@@ -377,7 +378,7 @@ unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs)
 		return ret;
 	}
 
-	if (!__io_put_kbuf_ring(req, len, nbufs))
+	if (!__io_put_kbuf_ring(req, bl, len, nbufs))
 		ret |= IORING_CQE_F_BUF_MORE;
 	return ret;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 723d0361898e..20ad4fe716e6 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -80,14 +80,16 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 void io_kbuf_drop_legacy(struct io_kiocb *req);
 
-unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs);
+unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
+			    int len, int nbufs);
 bool io_kbuf_commit(struct io_kiocb *req,
 		    struct io_buffer_list *bl, int len, int nr);
 
 struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 					    unsigned int bgid);
 
-static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
+static inline bool io_kbuf_recycle_ring(struct io_kiocb *req,
+					struct io_buffer_list *bl)
 {
 	/*
 	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
@@ -96,7 +98,7 @@ static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 	 * The exception is partial io, that case we should increment bl->head
 	 * to monopolize the buffer.
 	 */
-	if (req->buf_list) {
+	if (bl) {
 		req->flags &= ~(REQ_F_BUFFER_RING|REQ_F_BUFFERS_COMMIT);
 		return true;
 	}
@@ -110,30 +112,33 @@ static inline bool io_do_buffer_select(struct io_kiocb *req)
 	return !(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING));
 }
 
-static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
+static inline bool io_kbuf_recycle(struct io_kiocb *req, struct io_buffer_list *bl,
+				   unsigned issue_flags)
 {
 	if (req->flags & REQ_F_BL_NO_RECYCLE)
 		return false;
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return io_kbuf_recycle_legacy(req, issue_flags);
 	if (req->flags & REQ_F_BUFFER_RING)
-		return io_kbuf_recycle_ring(req);
+		return io_kbuf_recycle_ring(req, bl);
 	return false;
 }
 
 static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
+				       struct io_buffer_list *bl,
 				       unsigned issue_flags)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return __io_put_kbufs(req, len, 1);
+	return __io_put_kbufs(req, bl, len, 1);
 }
 
 static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
-					int nbufs, unsigned issue_flags)
+					int nbufs, struct io_buffer_list *bl,
+					unsigned issue_flags)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return __io_put_kbufs(req, len, nbufs);
+	return __io_put_kbufs(req, bl, len, nbufs);
 }
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 73281f31c856..5ce0f5470d17 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -494,12 +494,12 @@ static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
 	return nbufs;
 }
 
-static int io_net_kbuf_recyle(struct io_kiocb *req,
+static int io_net_kbuf_recyle(struct io_kiocb *req, struct io_buffer_list *bl,
 			      struct io_async_msghdr *kmsg, int len)
 {
 	req->flags |= REQ_F_BL_NO_RECYCLE;
 	if (req->flags & REQ_F_BUFFERS_COMMIT)
-		io_kbuf_commit(req, req->buf_list, len, io_bundle_nbufs(kmsg, len));
+		io_kbuf_commit(req, bl, len, io_bundle_nbufs(kmsg, len));
 	return IOU_RETRY;
 }
 
@@ -512,11 +512,11 @@ static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, *ret, issue_flags);
+		cflags = io_put_kbuf(req, *ret, req->buf_list, issue_flags);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), issue_flags);
+	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), req->buf_list, issue_flags);
 
 	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
 		goto finish;
@@ -682,7 +682,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -873,7 +873,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		size_t this_ret = *ret - sr->done_io;
 
 		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
-				      issue_flags);
+				      req->buf_list, issue_flags);
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		if (sr->mshot_len && *ret >= sr->mshot_len)
@@ -895,7 +895,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, *ret, issue_flags);
+		cflags |= io_put_kbuf(req, *ret, req->buf_list, issue_flags);
 	}
 
 	/*
@@ -1047,7 +1047,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);
 			if (ret) {
-				io_kbuf_recycle(req, issue_flags);
+				io_kbuf_recycle(req, req->buf_list, issue_flags);
 				return ret;
 			}
 		}
@@ -1072,13 +1072,13 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			if (issue_flags & IO_URING_F_MULTISHOT)
-				io_kbuf_recycle(req, issue_flags);
+				io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 			return IOU_RETRY;
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1092,7 +1092,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 	else
-		io_kbuf_recycle(req, issue_flags);
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
@@ -1216,7 +1216,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			if (issue_flags & IO_URING_F_MULTISHOT)
-				io_kbuf_recycle(req, issue_flags);
+				io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 			return IOU_RETRY;
 		}
@@ -1224,7 +1224,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1240,7 +1240,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 	else
-		io_kbuf_recycle(req, issue_flags);
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c786e587563b..07ab22380c78 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -316,10 +316,10 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 
 	ret = io_poll_check_events(req, tw);
 	if (ret == IOU_POLL_NO_ACTION) {
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}
@@ -686,7 +686,7 @@ int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-	io_kbuf_recycle(req, issue_flags);
+	io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask, issue_flags);
 	if (ret)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 52a5b950b2e5..7ad0f77abd54 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -576,7 +576,7 @@ void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, 0);
+		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, req->buf_list, 0);
 
 	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(req, tw);
@@ -659,7 +659,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		 * from the submission path.
 		 */
 		io_req_io_end(req);
-		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, issue_flags));
+		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, req->buf_list, issue_flags));
 		io_req_rw_cleanup(req, issue_flags);
 		return IOU_COMPLETE;
 	} else {
@@ -1049,15 +1049,15 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * Reset rw->len to 0 again to avoid clamping future mshot
 		 * reads, in case the buffer size varies.
 		 */
-		if (io_kbuf_recycle(req, issue_flags))
+		if (io_kbuf_recycle(req, req->buf_list, issue_flags))
 			rw->len = 0;
 		return IOU_RETRY;
 	} else if (ret <= 0) {
-		io_kbuf_recycle(req, issue_flags);
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 		if (ret < 0)
 			req_set_fail(req);
 	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		cflags = io_put_kbuf(req, ret, issue_flags);
+		cflags = io_put_kbuf(req, ret, req->buf_list, issue_flags);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
@@ -1065,7 +1065,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
-		cflags = io_put_kbuf(req, ret, issue_flags);
+		cflags = io_put_kbuf(req, ret, req->buf_list, issue_flags);
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1362,7 +1362,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res, 0);
+		req->cqe.flags = io_put_kbuf(req, req->cqe.res, req->buf_list, 0);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}
-- 
2.50.1


