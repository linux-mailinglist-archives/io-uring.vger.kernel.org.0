Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DC4468B6B
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 15:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbhLEOmn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 09:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbhLEOmn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 09:42:43 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D969C061714
        for <io-uring@vger.kernel.org>; Sun,  5 Dec 2021 06:39:16 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so32428193edu.4
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 06:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xohlp9o7zWvdbvbd181kepP+rfXaw8ZuQV3wWBGI0jM=;
        b=QNnwWux6TId0BhmS3SDkRuZLQTkm8RFhLqF4AwHoc+4Oa98btxO6//+AeurPqDpXCL
         fFbbCPUkC4c2c7/8MGOPbsjJs77UxXzVdg5XFL/lMBw96D7OrnUdWEV58j+yZzM4Tbe9
         QKznANs2WSUBBjAHaRls3iXZy/KPA5TKHcDTjtmzBGXzEeB4givfA1vchqtFmbnKDSul
         Cy4gggeCcPRLpL0sC5pV8+KDJnduQYF1/kSTjUCCxxBIIXz2MuD3rHgMjaEyDhOTTYDo
         AzAO//KjGaPQFQoY+2u24z26+p0Ub5KQv5L5hIeE8lImyrY4vMf+EYmtwEm3clT3cYi6
         mW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xohlp9o7zWvdbvbd181kepP+rfXaw8ZuQV3wWBGI0jM=;
        b=GecDKdPCLjTQOymI1dmTXjT0AuvJAEjpjBfMSmQUVBpjsbdg/w6t69cTqHZ3tSjgak
         Zp50GAAHGRHDc/rcZqDlaiskmYhoc7SAvpC2jU8f1i5hzXauPKd2oqwPsQ4VAUZJCFqK
         GhCREZgFebAKE7VJRr2GtPyTOAoFiQLE7Hn7R/oUM0shx3KefrD2yEp8fVawKJ1lvB5n
         Ruf9MMpF4PrfBHTbJ7MlRaUnTNQPVE9a6mRrS/uctgBU/ER/l45ZgIbne0tcbmRqX+QE
         n1ewK5BiUm48y1IljX3Zux27AmGPH4QYEbdXRJ6aE+aTyT3zvFwnFjtcFlcCDlKCxeVr
         joCQ==
X-Gm-Message-State: AOAM5301ZJF3Wp7eUGlnFDJQdWbsXchePKlDLWwo5w5sXBwLy2VaTiBh
        jAuPPX2quznft9p180R2243KVVxnaX0=
X-Google-Smtp-Source: ABdhPJyotztiub8fWDVeFUpgDrJZyksDv+U3lXXqTukAE8FKZ5y6MYRxffh3cxpgRy1ilwC98KQlaQ==
X-Received: by 2002:a17:906:3a9b:: with SMTP id y27mr38830132ejd.563.1638715154689;
        Sun, 05 Dec 2021 06:39:14 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.50])
        by smtp.gmail.com with ESMTPSA id ar2sm5224935ejc.20.2021.12.05.06.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:39:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH v2 2/4] io_uring: simplify selected buf handling
Date:   Sun,  5 Dec 2021 14:37:58 +0000
Message-Id: <bd4a866d8d91b044f748c40efff9e4eacd07536e.1638714983.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638714983.git.asml.silence@gmail.com>
References: <cover.1638714983.git.asml.silence@gmail.com>
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

