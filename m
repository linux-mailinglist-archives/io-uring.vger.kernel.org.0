Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D96132C7F
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 18:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgAGRF5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 12:05:57 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39319 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGRF5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 12:05:57 -0500
Received: by mail-il1-f195.google.com with SMTP id x5so191806ila.6
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 09:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ePeYHHCrlTvEcFwyclV0yiNhluauNmITK5H/gPcNCZs=;
        b=w4OBuTNpFkZ4P/FmzBu8dU6b7fw2GPLYj8pleo8iRtZJO3i1KMgKjdE+uc6QlqLF9V
         3ndAKwCK+v1K4RYNyrbhwtNaCjkMji+vG0ljRk1JHvn5eVD/OWGPCyDl+MDhh9+xoHin
         n2Z2zbTUOeKqOB0mi5JFeHcvJ4Rpmys+9bBFSTMSNyWgkdFql9T2uJ8MUMC/Th2Md56D
         UIc9SFPW3c6zCgwqjjDbPQ8urpXjtzqIfLcvEnb7BbroDc/VA9Hm+lDoCOcSTIltQm+4
         7UsgGiQ7y0cNNfYm4j5xejwBme95wzyz3cw7sLMmzwLpPUEndQBkpoXKIaSMnRQCCX0M
         c6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ePeYHHCrlTvEcFwyclV0yiNhluauNmITK5H/gPcNCZs=;
        b=te6cks7CXNX23kSzmjd5PIcJ8kw6YHwMXpg6zQraGvJoCkQNBQi6FfRAqQcTnMiJ8S
         ZOUkgY8Q+JTfNLHvc0wbUXp/7b9/JA5vrcW6rv4V5nQaEWMTJEmAnXa4aCsv9HEl/zDG
         b4OKznUrS9mo4U1b/KQN/pW3fiAzm/rZJCOVpjJJJWbjWoO0Dwm0zrQmgjHw4cX46yfI
         8O7Hbi0zWNRPkTsMGuerv65sZbjXn/DSGQEIzPJ9ak/IR06xePW+NZ2sKS0lx8G8TVuf
         nc4ra6PbXor+4ccmhZ/yhMBymh5jRq3NmAN8xlvfhkxRO9NrM+Gwp7Gjh1AVh5oB+sRC
         jiig==
X-Gm-Message-State: APjAAAXGZxgfohQlzeO7tLfkx8OPcoomIZAdS0C5LCXUoIeafmz99H9V
        BnGpsH6di65EC1FxTU/TP5WRh8S0Hig=
X-Google-Smtp-Source: APXvYqyVhoR2MHFjRJJVk9dUkuTnVEahiu9aLULC9GiNl3LJdTYQk5LIkVBuQsAQYQCHSn4ZKU4Z6w==
X-Received: by 2002:a92:9cc6:: with SMTP id x67mr30621ill.31.1578416441495;
        Tue, 07 Jan 2020 09:00:41 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g4sm42547iln.81.2020.01.07.09.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:00:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: add support for IORING_OP_CLOSE
Date:   Tue,  7 Jan 2020 10:00:34 -0700
Message-Id: <20200107170034.16165-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107170034.16165-1-axboe@kernel.dk>
References: <20200107170034.16165-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This works just like close(2), unsurprisingly. We remove the file
descriptor and post the completion inline, then offload the actual
(potential) last file put to async context.

Mark the async part of this work as uncancellable, as we really must
guarantee that the latter part of the close is run.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 109 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 110 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e12b1545468d..39abe20220d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -301,6 +301,12 @@ struct io_poll_iocb {
 	struct wait_queue_entry		wait;
 };
 
+struct io_close {
+	struct file			*file;
+	struct file			*put_file;
+	int				fd;
+};
+
 struct io_timeout_data {
 	struct io_kiocb			*req;
 	struct hrtimer			timer;
@@ -414,6 +420,7 @@ struct io_kiocb {
 		struct io_connect	connect;
 		struct io_sr_msg	sr_msg;
 		struct io_open		open;
+		struct io_close		close;
 	};
 
 	struct io_async_ctx		*io;
@@ -2225,6 +2232,94 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	/*
+	 * If we queue this for async, it must not be cancellable. That would
+	 * leave the 'file' in an undeterminate state.
+	 */
+	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
+
+	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
+	    sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+	if (sqe->flags & IOSQE_FIXED_FILE)
+		return -EINVAL;
+
+	req->close.fd = READ_ONCE(sqe->fd);
+	if (req->file->f_op == &io_uring_fops ||
+	    req->close.fd == req->ring_fd)
+		return -EBADF;
+
+	return 0;
+}
+
+static void io_close_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	/* Invoked with files, we need to do the close */
+	if (req->work.files) {
+		int ret;
+
+		ret = filp_close(req->close.put_file, req->work.files);
+		if (ret < 0) {
+			req_set_fail_links(req);
+		}
+		io_cqring_add_event(req, ret);
+	}
+
+	fput(req->close.put_file);
+
+	/* we bypassed the re-issue, drop the submission reference */
+	io_put_req(req);
+	io_put_req_find_next(req, &nxt);
+	if (nxt)
+		*workptr = &nxt->work;
+}
+
+static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
+		    bool force_nonblock)
+{
+	int ret;
+
+	req->close.put_file = NULL;
+	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
+	if (ret < 0)
+		return ret;
+
+	/* if the file has a flush method, be safe and punt to async */
+	if (req->close.put_file->f_op->flush && !io_wq_current_is_worker()) {
+		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+		goto eagain;
+	}
+
+	/*
+	 * No ->flush(), safely close from here and just punt the
+	 * fput() to async context.
+	 */
+	ret = filp_close(req->close.put_file, current->files);
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+
+	if (io_wq_current_is_worker()) {
+		struct io_wq_work *old_work, *work;
+
+		old_work = work = &req->work;
+		io_close_finish(&work);
+		if (work && work != old_work)
+			*nxt = container_of(work, struct io_kiocb, work);
+		return 0;
+	}
+
+eagain:
+	req->work.func = io_close_finish;
+	return -EAGAIN;
+}
+
 static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3253,6 +3348,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_OPENAT:
 		ret = io_openat_prep(req, sqe);
 		break;
+	case IORING_OP_CLOSE:
+		ret = io_close_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -3423,6 +3521,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_openat(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_CLOSE:
+		if (sqe) {
+			ret = io_close_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_close(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -3578,6 +3684,9 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (!req->ring_file)
+		return -EBADF;
+
 	rcu_read_lock();
 	spin_lock_irq(&ctx->inflight_lock);
 	/*
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 02af580754ce..42a7f0e8dee3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -79,6 +79,7 @@ enum {
 	IORING_OP_CONNECT,
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
+	IORING_OP_CLOSE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1

