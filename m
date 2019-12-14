Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9EF11F276
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLNPaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 10:30:17 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34917 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfLNPaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 10:30:17 -0500
Received: by mail-lj1-f193.google.com with SMTP id j6so2036456lja.2;
        Sat, 14 Dec 2019 07:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tKpbIIukiPmWkfZZ0EPYoAUPjMssF3lF5pcZV5QAq7w=;
        b=FI9asMhypX+iTTK2QHrnbE/CnjXZpRBH0VnHuI7sg0lQ26kpoQhi+t/008a08zsTrp
         +x2Zul36wICIbBvMHhGVj9qPVyKERWdJdI0h/k+4EWcyS793kujUGE47eEUrxjP2781y
         B/PaRzBo0tQD5Oyljm1DWX7UBVzn8Q0RTs7/DMPBaDnX+zH4lM4qaPwxzMsyfewSSull
         q/xwq5K3Misoy8QiJyf2y1HAoKvXmkyXYhSTkYwMSOgmFeOLSGscCx3g/rwsxEATgso+
         TGGQoY/3nxR3HtGVG7hfQCUVtRNeUySrGD6XKIurkVsb3Fp/WICXidYOzsneqxdZrx4m
         +uMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tKpbIIukiPmWkfZZ0EPYoAUPjMssF3lF5pcZV5QAq7w=;
        b=lNbRWCK30LSrB1dJzE4auNJecrUuy+OKbpdrZVqd1pRdDoKGjyCgOhbd1bx/12KkCU
         yHESvWhb+TSL8mWvmftC6L2gXtBAO58r8sbxswjyZgybHCdJ1h0glf83xDEt235jg32G
         RxGnCv/9sK8EyKe6SToMIR0PeI41aR7S8n4KFv4rGClROIXAcetd1qRFbyGP9Hkdi6qF
         CrETenNmeHt8dCvfHJ4g22EOgzUK2oommihRs6JCd2JtQ1H4xddXWcJWF19h9cZnUz4b
         Otpf8+iiuyFYNDygRJ58qF+guY8XJjpmp58cTE2TYrKM2DCFi0exNOKUwa49nYdmUK2a
         BAzA==
X-Gm-Message-State: APjAAAWKasiRuAP6FOgFo/lf1idqB0INdKX1QDoy8kTD1v6/csCtcL7b
        x12Od/ou1qrqTZFEJLKfwdo=
X-Google-Smtp-Source: APXvYqz7YvUAePzepyy2r7W2pjTM1uI8FZQuy4Wu9rB+JMMJVUy09vzHbdSDCQDE0lbTZ4P7X6HP6A==
X-Received: by 2002:a2e:b52a:: with SMTP id z10mr12828515ljm.178.1576337414874;
        Sat, 14 Dec 2019 07:30:14 -0800 (PST)
Received: from localhost.localdomain ([212.122.72.247])
        by smtp.gmail.com with ESMTPSA id k5sm6007919lfd.86.2019.12.14.07.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 07:30:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] io_uring: add support for IORING_OP_IOCTL
Date:   Sat, 14 Dec 2019 18:29:49 +0300
Message-Id: <f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This works almost like ioctl(2), except it doesn't support a bunch of
common opcodes, (e.g. FIOCLEX and FIBMAP, see ioctl.c), and goes
straight to a device specific implementation.

The case in mind is dma-buf, drm and other ioctl-centric interfaces.

Not-yet Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

It clearly needs some testing first, though works fine with dma-buf,
but I'd like to discuss whether the use cases are convincing enough,
and is it ok to desert some ioctl opcodes. For the last point it's
fairly easy to add, maybe except three requiring fd (e.g. FIOCLEX)

P.S. Probably, it won't benefit enough to consider using io_uring
in drm/mesa, but anyway.

 fs/io_uring.c                 | 33 +++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  7 ++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5dfc805ec31c..6269c51dd02f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -72,6 +72,7 @@
 #include <linux/highmem.h>
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
+#include <linux/security.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -3164,6 +3165,35 @@ static int io_req_defer(struct io_kiocb *req)
 	return -EIOCBQUEUED;
 }
 
+static int io_ioctl(struct io_kiocb *req,
+		    struct io_kiocb **nxt, bool force_nonblock)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+	unsigned int cmd = READ_ONCE(sqe->ioctl_cmd);
+	unsigned long arg = READ_ONCE(sqe->ioctl_arg);
+	int ret;
+
+	if (!req->file)
+		return -EBADF;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->ioprio || sqe->addr || sqe->buf_index
+		|| sqe->rw_flags))
+		return -EINVAL;
+	if (force_nonblock)
+		return -EAGAIN;
+
+	ret = security_file_ioctl(req->file, cmd, arg);
+	if (!ret)
+		ret = (int)vfs_ioctl(req->file, cmd, arg);
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+}
+
 __attribute__((nonnull))
 static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 			bool force_nonblock)
@@ -3237,6 +3267,9 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 	case IORING_OP_FILES_UPDATE:
 		ret = io_files_update(req, force_nonblock);
 		break;
+	case IORING_OP_IOCTL:
+		ret = io_ioctl(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cafee41efbe5..88d38364746a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -22,9 +22,13 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u64	ioctl_arg;
 	};
 	__u64	addr;		/* pointer to buffer or iovecs */
-	__u32	len;		/* buffer size or number of iovecs */
+	union {
+		__u32	len;	/* buffer size or number of iovecs */
+		__u32	ioctl_cmd;
+	};
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
@@ -81,6 +85,7 @@ enum {
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
 	IORING_OP_FILES_UPDATE,
+	IORING_OP_IOCTL,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.0

