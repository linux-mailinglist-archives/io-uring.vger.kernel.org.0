Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAD2132C63
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 18:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgAGRAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 12:00:40 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33252 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgAGRAk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 12:00:40 -0500
Received: by mail-io1-f68.google.com with SMTP id z8so95847ioh.0
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 09:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kLAa950381IHiWSMUCFQoLvVLA8UvLKXWI1RYKTGU10=;
        b=UNWzIE7R4TpHwJwLYvaRc60Hg38NY0sj28tsFEcq7DRYWHysxyr6WKZ8nOVmNhop3V
         jBsvdQLFqXDkfm7wRFBA9asKzJFIX0N4S6tHZ5FqQetJ9QD4sXFyEs/E4/syWD2Vcyy7
         pMC9tR9Efzp8EezRKY9sdy4Re+VPJBO1KzAab/DO1Lf0FObmCYOLC/3LLQ9TEFWzCC2/
         8Q3PocJGGtSIOMlYITUQ1yDqLJjZ2gIm4YbBN+JmGiFIH0PPZBLkwUuHHLmMk9kOIKxS
         FcFPi0AIoazdu3GxlQaWd2ekPrdAqicekrnqWFV7dRg/fsUzdW6cElVDYwE70z/Mhk9I
         r34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLAa950381IHiWSMUCFQoLvVLA8UvLKXWI1RYKTGU10=;
        b=NaYehtudzbCzosN5PacKXJUPBwjgUmm8OEddoVsqyZlei9y0kswlYAW0ebKpntdkEj
         XqtS2x2aCS1mCJSI48of3jFQzQSorgztIP5PkiDJ4+waAYjM/EU6iagfmxUjzmUWy+nM
         ZjaMfgHkuJcDaeAXeDjpGmDvSLoEobfYJKMRKbAmjyDvaaXaI9oLEmQ9eccDUywemFIj
         5bfZeklr+Ku2mOwLmi40zQIsNviPdWy8NcGMHdGM6gfmbWZYl78VTBJKDMnyBwCJBEP0
         c2HaisC2UEz18rwF6PBVpFY1K3XJPfL9HIQA4bIps0dkZnvcEL++s9e23IhMclJlQShn
         GQsw==
X-Gm-Message-State: APjAAAVgo87PjZIPNtrzYHmI+ae2D9akgmmKeRm78idWQQiwXkAU2Op3
        1T7F8l5rPkGa69LbJS+I04RfeeJJT1E=
X-Google-Smtp-Source: APXvYqza5WKNNqZbpiRhQg6I3g6gfQedkb94vmr6kTCTXtmY0g/1fwyuxcjbZ3PiV8z/+KuUG6QxjA==
X-Received: by 2002:a5d:844d:: with SMTP id w13mr75321336ior.83.1578416439246;
        Tue, 07 Jan 2020 09:00:39 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g4sm42547iln.81.2020.01.07.09.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:00:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: add support for IORING_OP_OPENAT
Date:   Tue,  7 Jan 2020 10:00:31 -0700
Message-Id: <20200107170034.16165-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107170034.16165-1-axboe@kernel.dk>
References: <20200107170034.16165-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This works just like openat(2), except it can be performed async. For
the normal case of a non-blocking path lookup this will complete
inline. If we have to do IO to perform the open, it'll be done from
async context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 107 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1822bf9aba12..53ff67ab5c4b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -70,6 +70,8 @@
 #include <linux/sizes.h>
 #include <linux/hugetlb.h>
 #include <linux/highmem.h>
+#include <linux/namei.h>
+#include <linux/fsnotify.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -353,6 +355,15 @@ struct io_sr_msg {
 	int				msg_flags;
 };
 
+struct io_open {
+	struct file			*file;
+	int				dfd;
+	umode_t				mode;
+	const char __user		*fname;
+	struct filename			*filename;
+	int				flags;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -371,12 +382,17 @@ struct io_async_rw {
 	ssize_t				size;
 };
 
+struct io_async_open {
+	struct filename			*filename;
+};
+
 struct io_async_ctx {
 	union {
 		struct io_async_rw	rw;
 		struct io_async_msghdr	msg;
 		struct io_async_connect	connect;
 		struct io_timeout_data	timeout;
+		struct io_async_open	open;
 	};
 };
 
@@ -397,6 +413,7 @@ struct io_kiocb {
 		struct io_timeout	timeout;
 		struct io_connect	connect;
 		struct io_sr_msg	sr_msg;
+		struct io_open		open;
 	};
 
 	struct io_async_ctx		*io;
@@ -2135,6 +2152,79 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	if (sqe->ioprio || sqe->buf_index)
+		return -EINVAL;
+
+	req->open.dfd = READ_ONCE(sqe->fd);
+	req->open.mode = READ_ONCE(sqe->len);
+	req->open.fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	req->open.flags = READ_ONCE(sqe->open_flags);
+
+	req->open.filename = getname(req->open.fname);
+	if (IS_ERR(req->open.filename)) {
+		ret = PTR_ERR(req->open.filename);
+		req->open.filename = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static void io_openat_async(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct filename *filename = req->open.filename;
+
+	io_wq_submit_work(workptr);
+	putname(filename);
+}
+
+static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
+		     bool force_nonblock)
+{
+	struct open_flags op;
+	struct open_how how;
+	struct file *file;
+	int ret;
+
+	how = build_open_how(req->open.flags, req->open.mode);
+	ret = build_open_flags(&how, &op);
+	if (ret)
+		goto err;
+	if (force_nonblock)
+		op.lookup_flags |= LOOKUP_NONBLOCK;
+
+	ret = get_unused_fd_flags(how.flags);
+	if (ret < 0)
+		goto err;
+
+	file = do_filp_open(req->open.dfd, req->open.filename, &op);
+	if (IS_ERR(file)) {
+		put_unused_fd(ret);
+		ret = PTR_ERR(file);
+		if (ret == -EAGAIN) {
+			req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+			req->work.func = io_openat_async;
+			return -EAGAIN;
+		}
+	} else {
+		fsnotify_open(file);
+		fd_install(ret, file);
+	}
+err:
+	if (!io_wq_current_is_worker())
+		putname(req->open.filename);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+}
+
 static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3160,6 +3250,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_FALLOCATE:
 		ret = io_fallocate_prep(req, sqe);
 		break;
+	case IORING_OP_OPENAT:
+		ret = io_openat_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -3322,6 +3415,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_fallocate(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_OPENAT:
+		if (sqe) {
+			ret = io_openat_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_openat(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -3403,7 +3504,7 @@ static bool io_req_op_valid(int op)
 	return op >= IORING_OP_NOP && op < IORING_OP_LAST;
 }
 
-static int io_req_needs_file(struct io_kiocb *req)
+static int io_req_needs_file(struct io_kiocb *req, int fd)
 {
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -3413,6 +3514,8 @@ static int io_req_needs_file(struct io_kiocb *req)
 	case IORING_OP_ASYNC_CANCEL:
 	case IORING_OP_LINK_TIMEOUT:
 		return 0;
+	case IORING_OP_OPENAT:
+		return fd != -1;
 	default:
 		if (io_req_op_valid(req->opcode))
 			return 1;
@@ -3442,7 +3545,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	if (flags & IOSQE_IO_DRAIN)
 		req->flags |= REQ_F_IO_DRAIN;
 
-	ret = io_req_needs_file(req);
+	ret = io_req_needs_file(req, fd);
 	if (ret <= 0)
 		return ret;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index bdbe2b130179..02af580754ce 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -34,6 +34,7 @@ struct io_uring_sqe {
 		__u32		timeout_flags;
 		__u32		accept_flags;
 		__u32		cancel_flags;
+		__u32		open_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -77,6 +78,7 @@ enum {
 	IORING_OP_LINK_TIMEOUT,
 	IORING_OP_CONNECT,
 	IORING_OP_FALLOCATE,
+	IORING_OP_OPENAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1

