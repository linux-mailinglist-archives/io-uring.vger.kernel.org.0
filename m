Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4071786B2
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 00:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgCCXvF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 18:51:05 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37215 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgCCXvF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 18:51:05 -0500
Received: by mail-pg1-f196.google.com with SMTP id z12so71052pgl.4
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 15:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vATRXfTIlDXTByf2gHnT6AFId1+u8DDZ9c6nSKo6oZU=;
        b=SK3SNShT2LHtmmphRkaEy0/iEELtDGJIIJWHuhtz3NE+4sgEx8D6vPODuVWLkl/QPJ
         f0UTea9clNbqadAYjyFZ91NsqDEOCOvT4yOkQaWqsZ3K2QqW8kwxFVSG+58roR224bqI
         2oWUEfbXQPRO5E8pExlaGuqLw1WUNj/gUm5+MdgHn1IVNOJAIkjvb5S/1Iik4735N9Yr
         Me9HYGDnii/VBFuOIRpEWF4U/wEGGM3UfkhC4euXXU/TSqH+F1P6JBo3sFOp8J+uM2H8
         0k/FEnOjsQRiGCAjGGAyZ+peLCINptfuVex2qTNvDCxQgOSv2zV1i4upp6+9N6bb+bae
         KQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vATRXfTIlDXTByf2gHnT6AFId1+u8DDZ9c6nSKo6oZU=;
        b=VTSHGZuQkZZ0AaEazy+qiX53iLusDZZG93/rhc3yc5D68XP2CNQBjOt9tIb7QYmOqe
         LH8AUhqjkjdIoL+MHw77NkSWjsPsZSFANI/Vjoliv3MiqhJmq5NTDp+lzQmsmi27GHxe
         pSb1i+Xw7nkdfbOY/MzOSqysO2brf5oKb6EGwtD/nCujV2x7hbddbYuF4j+gvrH59SJ9
         5X4rUTRUtdNL9SLZgpt18Q44JLkIFWwwnk7U9dAbda3o4b373HNm3g1e2U9UoXlGyhbf
         uZsWLEIyvyFPm+PU5zuFB6c5T+jVIMB6RPuob+BPzCIzuRsGr3P4FwcUUBkMD10vZYrf
         /utQ==
X-Gm-Message-State: ANhLgQ1POKgjXcflLEatgxZFvXiOQ2aGonYYNYtmM4E3uvNmXLgAy0mM
        /gwFigsGpEPCNYMC5PyaiH4QEE6Vg9o=
X-Google-Smtp-Source: ADFU+vtB/URgcodCxw1JU4LsB9Uc1YYiGtMwJ1lgbWqe345LnBXNTySlZp1lz65a7BqX76uXnTPTOA==
X-Received: by 2002:a62:cd41:: with SMTP id o62mr221008pfg.150.1583279463768;
        Tue, 03 Mar 2020 15:51:03 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d24sm27041503pfq.75.2020.03.03.15.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 15:51:03 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: test patch for fd passing
Date:   Tue,  3 Mar 2020 16:50:53 -0700
Message-Id: <20200303235053.16309-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303235053.16309-1-axboe@kernel.dk>
References: <20200303235053.16309-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This allows a chain link to set ->fd to IOSQE_FD_LAST_OPEN, which will
then be turned into the results from the last open (or accept) request
in the chain. If no open has been done, this isn't valid and the request
will be errored with -EBADF.

With this, we can define chains of open+read+close, where the read and
close part can work on the fd instantiated by the open request.

Totally a work in progress, POC so far.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 56 ++++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  6 ++++
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8044dec4e793..63a1a4f01e7e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -511,6 +511,7 @@ enum {
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_OPEN_FD_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -562,6 +563,8 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* use chain previous open fd */
+	REQ_F_OPEN_FD		= BIT(REQ_F_OPEN_FD_BIT),
 };
 
 struct async_poll {
@@ -600,6 +603,9 @@ struct io_kiocb {
 	bool				needs_fixed_file;
 	u8				opcode;
 
+	int			last_open_fd;
+	struct file		*last_open_file;
+
 	struct io_ring_ctx	*ctx;
 	struct list_head	list;
 	unsigned int		flags;
@@ -1344,7 +1350,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 {
 	if (fixed)
 		percpu_ref_put(&req->ctx->file_data->refs);
-	else
+	else if (!(req->flags & REQ_F_OPEN_FD))
 		fput(file);
 }
 
@@ -1487,6 +1493,14 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 		list_del_init(&req->link_list);
 		if (!list_empty(&nxt->link_list))
 			nxt->flags |= REQ_F_LINK;
+		if (nxt->flags & REQ_F_OPEN_FD) {
+			WARN_ON_ONCE(nxt->file);
+			if (unlikely(!req->last_open_file))
+				nxt->flags |= REQ_F_FAIL_LINK;
+			nxt->last_open_file = req->last_open_file;
+			nxt->last_open_fd = req->last_open_fd;
+			nxt->file = req->last_open_file;
+		}
 		*nxtptr = nxt;
 		break;
 	}
@@ -2965,8 +2979,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 {
+	struct file *file = NULL;
 	struct open_flags op;
-	struct file *file;
 	int ret;
 
 	if (force_nonblock)
@@ -2991,8 +3005,12 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < 0) {
 		req_set_fail_links(req);
+	} else if (req->flags & REQ_F_LINK) {
+		req->last_open_file = file;
+		req->last_open_fd = ret;
+	}
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
 	return 0;
@@ -3410,6 +3428,14 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
+	if (req->flags & REQ_F_OPEN_FD) {
+		if (req->close.fd != IOSQE_FD_LAST_OPEN)
+			return -EBADF;
+		req->close.fd = req->last_open_fd;
+		req->last_open_file = NULL;
+		req->last_open_fd = -1;
+	}
+
 	if (req->file->f_op == &io_uring_fops ||
 	    req->close.fd == req->ctx->ring_fd)
 		return -EBADF;
@@ -3962,8 +3988,14 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 		return -EAGAIN;
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
-	if (ret < 0)
+	if (ret < 0) {
 		req_set_fail_links(req);
+	} else if (req->flags & REQ_F_LINK) {
+		rcu_read_lock();
+		req->last_open_file = fcheck_files(current->files, ret);
+		rcu_read_unlock();
+		req->last_open_fd = ret;
+	}
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
 	return 0;
@@ -4999,6 +5031,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
+	if ((req->flags & REQ_F_OPEN_FD) && !req->file)
+		return -EBADF;
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req);
@@ -5335,6 +5370,14 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 		return 0;
 
 	fixed = (flags & IOSQE_FIXED_FILE);
+	if (fd == IOSQE_FD_LAST_OPEN) {
+		if (fixed)
+			return -EBADF;
+		req->flags |= REQ_F_OPEN_FD;
+		req->file = NULL;
+		return 0;
+	}
+
 	if (unlikely(!fixed && req->needs_fixed_file))
 		return -EBADF;
 
@@ -5646,6 +5689,9 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		trace_io_uring_link(ctx, req, head);
 		list_add_tail(&req->link_list, &head->link_list);
 
+		req->last_open_fd = -1;
+		req->last_open_file = NULL;
+
 		/* last request of a link, enqueue the link */
 		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
 			io_queue_link_head(head);
@@ -5658,6 +5704,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 			req->flags |= REQ_F_LINK;
+			req->last_open_fd = -1;
+			req->last_open_file = NULL;
 			INIT_LIST_HEAD(&req->link_list);
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5eea0cfafb59..8206f075dd26 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -84,6 +84,12 @@ enum {
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 
+/*
+ * 'magic' ->fd values don't point to a real fd, but rather define how fds
+ * can be inherited through links in a chain
+ */
+#define IOSQE_FD_LAST_OPEN	(-4096)	/* previous result is fd */
+
 /*
  * io_uring_setup() flags
  */
-- 
2.25.1

