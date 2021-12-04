Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B560E468791
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 21:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhLDUx2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 15:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhLDUx1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 15:53:27 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1286C061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 12:50:01 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id a9so13451158wrr.8
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 12:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xohlp9o7zWvdbvbd181kepP+rfXaw8ZuQV3wWBGI0jM=;
        b=nnDDwl3AI0UP8gKsTMGkS8SWyRg7Q+ufrmz3Jg+19yJZ2gZk6TdlNmGtkCJLwRrSnk
         joaK4K5Uq1Szx8RDuPPZxZn0OqOOQnw7Ie6lUUWcuv3WU+0c6xi0IiMZM2fUdVr9GIKF
         OkRrT+QAZU7aN3xANBUTos4reBJTF9mb3hmuJYj1Qbo0M/dfMmeplWjqCenPhC8LH1Nd
         r5fXJVyiE32ShBM16sKfmR++YpSX3T++FZS2PYhqUE3p7XUQIitutrSFB+QioDNY61Qr
         5xGSBohUPnXUQriM21MBjpv+nYMjjg5SRwAT9PCfO4K33A2OPGna6dylZMSrY0gDQh8R
         vB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xohlp9o7zWvdbvbd181kepP+rfXaw8ZuQV3wWBGI0jM=;
        b=kpgqiXmgeqZVa3NJ7Ia7/1chxOvGmgRKfxnQ2xwctHwsLBuCZ3Y68hQfQwPqtr5pqJ
         kk/eMAw3hUsdSN3YSIsydekhNavrX6foF1kp+sBIG4O7fi5wdl6b09W5Ujy3HBtMeRC0
         j1h8gvX3u2NZxOzpThAQQ7Y0qbptplEkx3+NqziJvfPt26eTJQLw0aIivTvDj+NxlD1J
         cuCHRO3OoSZ96FM5ehN/0BWAjsZs5UwXcxltlbbAm7qWWf5JIkgfaQTvqoetVC3ZDQUA
         PoS/t2nTqua1mo25nvSwYr0AFi5ULZWn67rxB81GdP47ucIeMCT2zS1nCNO7sTzIlFY9
         HNvQ==
X-Gm-Message-State: AOAM531vda9LYFc/9ZdCQ5nbM646wr6B9NHOC2jprLsfZDfrG0lagZ3s
        KE/IAympoGOE3uRsGup4xc3vKRY1Cf4=
X-Google-Smtp-Source: ABdhPJxMIBVCUsadDk/qojHJfdFfYEIEb64Dg4HHsMZEqqkPi+WBHU/nc7/BuuYb1MvoP7MDW1yVog==
X-Received: by 2002:adf:f04d:: with SMTP id t13mr32033862wro.324.1638651000185;
        Sat, 04 Dec 2021 12:50:00 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id k187sm8393143wme.0.2021.12.04.12.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 12:49:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: simplify selected buf handling
Date:   Sat,  4 Dec 2021 20:49:28 +0000
Message-Id: <bd4a866d8d91b044f748c40efff9e4eacd07536e.1638650836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638650836.git.asml.silence@gmail.com>
References: <cover.1638650836.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As selected buffers are now stored in a separate field in a request, get
rid of rw/recv specific helpers and simplify the code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ffbe1b76f3a0..64add8260abb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1273,22 +1273,24 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 	}
 }
 
-static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
+static unsigned int __io_put_kbuf(struct io_kiocb *req)
 {
+	struct io_buffer *kbuf = req->kbuf;
 	unsigned int cflags;
 
 	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
 	cflags |= IORING_CQE_F_BUFFER;
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	kfree(kbuf);
+	req->kbuf = NULL;
 	return cflags;
 }
 
-static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
+static inline unsigned int io_put_kbuf(struct io_kiocb *req)
 {
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return io_put_kbuf(req, req->kbuf);
+	return __io_put_kbuf(req);
 }
 
 static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
@@ -2532,14 +2534,14 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-		u32 cflags;
 
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
-		cflags = io_put_rw_kbuf(req);
+
 		if (!(req->flags & REQ_F_CQE_SKIP))
-			__io_fill_cqe(ctx, req->user_data, req->result, cflags);
+			__io_fill_cqe(ctx, req->user_data, req->result,
+				      io_put_kbuf(req));
 		nr_events++;
 	}
 
@@ -2715,7 +2717,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	unsigned int cflags = io_put_rw_kbuf(req);
+	unsigned int cflags = io_put_kbuf(req);
 	int res = req->result;
 
 	if (*locked) {
@@ -2731,7 +2733,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 {
 	if (__io_complete_rw_common(req, res))
 		return;
-	__io_req_complete(req, issue_flags, req->result, io_put_rw_kbuf(req));
+	__io_req_complete(req, issue_flags, req->result, io_put_kbuf(req));
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res)
@@ -4979,11 +4981,6 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 	return io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
 }
 
-static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
-{
-	return io_put_kbuf(req, req->kbuf);
-}
-
 static int io_recvmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
@@ -5021,8 +5018,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
-	int min_ret = 0;
-	int ret, cflags = 0;
+	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	sock = sock_from_file(req->file);
@@ -5066,13 +5062,11 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		cflags = io_put_recv_kbuf(req);
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	__io_req_complete(req, issue_flags, ret, cflags);
+	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req));
 	return 0;
 }
 
@@ -5085,8 +5079,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	struct socket *sock;
 	struct iovec iov;
 	unsigned flags;
-	int min_ret = 0;
-	int ret, cflags = 0;
+	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	sock = sock_from_file(req->file);
@@ -5128,9 +5121,8 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
 	}
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		cflags = io_put_recv_kbuf(req);
-	__io_req_complete(req, issue_flags, ret, cflags);
+
+	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req));
 	return 0;
 }
 
@@ -6578,10 +6570,8 @@ static __cold void io_drain_req(struct io_kiocb *req)
 
 static void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		kfree(req->kbuf);
-		req->kbuf = NULL;
-	}
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		io_put_kbuf(req);
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		switch (req->opcode) {
-- 
2.34.0

