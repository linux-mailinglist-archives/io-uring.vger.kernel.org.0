Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B58145A13
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgAVQmv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:42:51 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:47021 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgAVQmu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 11:42:50 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so7232101ioi.13
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 08:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lw+J2xi976wnKQAQkpo+sULjl/GCtrZo1kXXLVHWSQs=;
        b=1x3paWK2Cfi6ijmuaglijsnNVNAqxSIjpplllPrVPkY3Scrwee1dttVJHBtV2sYQd8
         CWevNHr2V4S+WaXcqVW8TpXi0GbnDKiDYDLBTpsItcvCOQnU7ZvG9GbPKOpZtqCQRNMU
         +y3K6I7cF22TLpxW4BUldwFH0M19IJQVCywGb/vUWC3MAM2JgeMEwPwxIvpuBKtstzjB
         yK/sTkmc/8xMYBqMfOcBvKZp6AZGHNzFwQYvUj9hNCnrdXeCvKFwAaJbkbfKc5JZwZV7
         GwVsCHIcwrWeW1j5gLoD6TriWf48q0WR5KIozQ68H7IPk4arSZmAbG6dz9YwMDWW7q4i
         gbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lw+J2xi976wnKQAQkpo+sULjl/GCtrZo1kXXLVHWSQs=;
        b=XG16TX0c9Spu7IjrKPC1ecQtZHBt1m57XEdckiJ2jvPLNXVAYgDSVrqARxbI8dJw8e
         Z475sV17w2tuUsQqcM1G79c1msKzsvQe8uN7XEsMUOcZ2oEDSj+rDGR+rqd9NGXPgmIp
         Y3p3NXsyHymtZmadzQ63bFfLYBCoy6C6iGilkHYYr9rX7VLBXhHrRyDy3RIKW6RpPLZD
         77wwXegsBpJ7Axh/54vSsVKm9yMpWtxDn2DKNr5fvX7bHn2gmfKqXhmwI61F2zFyCA2R
         wvzRHi8cag3OuWYkgOg08X8MJqceLqsr5tpxJgPXGwaF2ZxX83bctSqrFXkwLl8nI18p
         azgw==
X-Gm-Message-State: APjAAAVe86vYfJ0wsWQLdO0IWAd9Kw/2eSSWktTA2nY0y59cQ9AFVJcH
        em33bm05/Ek1QDM57/nGQdP3QqHcWig=
X-Google-Smtp-Source: APXvYqwUIUrCuVXxIF1ib3EmjDf3/PUroHs1scSnugdzhBGw7PikBwAl7cB7Rkw0JRqEV44Pbwv1YA==
X-Received: by 2002:a05:6638:24f:: with SMTP id w15mr8125624jaq.130.1579711369919;
        Wed, 22 Jan 2020 08:42:49 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o6sm14599681ilc.76.2020.01.22.08.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:42:49 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jannh@google.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add support for epoll_ctl(2)
Date:   Wed, 22 Jan 2020 09:42:44 -0700
Message-Id: <20200122164244.27799-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122164244.27799-1-axboe@kernel.dk>
References: <20200122164244.27799-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds IORING_OP_EPOLL_CTL, which can perform the same work as the
epoll_ctl(2) system call.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 73 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09503d1e9e45..64dc9e5df6d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -74,6 +74,7 @@
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
+#include <linux/eventpoll.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -421,6 +422,14 @@ struct io_madvise {
 	u32				advice;
 };
 
+struct io_epoll {
+	struct file			*file;
+	int				epfd;
+	int				op;
+	int				fd;
+	struct epoll_event		event;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -534,6 +543,7 @@ struct io_kiocb {
 		struct io_files_update	files_update;
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
+		struct io_epoll		epoll;
 	};
 
 	struct io_async_ctx		*io;
@@ -719,6 +729,9 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 	},
+	[IORING_OP_EPOLL_CTL] = {
+		.unbound_nonreg_file	= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2578,6 +2591,54 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return io_openat2(req, nxt, force_nonblock);
 }
 
+static int io_epoll_ctl_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_EPOLL)
+	if (sqe->ioprio || sqe->buf_index)
+		return -EINVAL;
+
+	req->epoll.epfd = READ_ONCE(sqe->fd);
+	req->epoll.op = READ_ONCE(sqe->len);
+	req->epoll.fd = READ_ONCE(sqe->off);
+
+	if (ep_op_has_event(req->epoll.op)) {
+		struct epoll_event __user *ev;
+
+		ev = u64_to_user_ptr(READ_ONCE(sqe->addr));
+		if (copy_from_user(&req->epoll.event, ev, sizeof(*ev)))
+			return -EFAULT;
+	}
+
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_epoll_ctl(struct io_kiocb *req, struct io_kiocb **nxt,
+			bool force_nonblock)
+{
+#if defined(CONFIG_EPOLL)
+	struct io_epoll *ie = &req->epoll;
+	int ret;
+
+	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
+	if (force_nonblock && ret == -EAGAIN) {
+		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+		return -EAGAIN;
+	}
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
@@ -4039,6 +4100,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_OPENAT2:
 		ret = io_openat2_prep(req, sqe);
 		break;
+	case IORING_OP_EPOLL_CTL:
+		ret = io_epoll_ctl_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4267,6 +4331,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_openat2(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_EPOLL_CTL:
+		if (sqe) {
+			ret = io_epoll_ctl_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_epoll_ctl(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 57d05cc5e271..cffa6fd33827 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -106,6 +106,7 @@ enum {
 	IORING_OP_SEND,
 	IORING_OP_RECV,
 	IORING_OP_OPENAT2,
+	IORING_OP_EPOLL_CTL,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.0

