Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A8514593F
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgAVQCi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:02:38 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45542 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgAVQCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 11:02:37 -0500
Received: by mail-io1-f66.google.com with SMTP id i11so7091565ioi.12
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 08:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KSosYJIVrzvlE5E1FMUdzMtoabtqfcuKGndm1BKLKA0=;
        b=ScozufRVIjlbXUefOn+/TZ64qB1VAqwe5zD5MRgdNkGmITpEGnx4SgOsJEGzRwc/Lj
         bboCL1oK+Sru83+Mra/dPjmwRIK2mzbb8BmKkCI5SXPnQ15ahYgCXt+7WLUu4nK3ocCk
         wcfvKJApe8EJrHdluSj9/203sItgJ34DrqamFA31R41ISO7cbmG0CW1GNBvHMf58g0HD
         Jcm71viljY4QW84Kaw9JPCYIfY+xrVI6PyzIM00OA/gqvKwMqbI3roXt6ZkB2cfCdI9H
         cgHSCqIc2oi5ZcbIe3a9HguLPeGZJynGo2hoCIohyDz1jaIZgbF4T+gy5eMpXNCdQEeB
         4ZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KSosYJIVrzvlE5E1FMUdzMtoabtqfcuKGndm1BKLKA0=;
        b=Mk/Xhzv+Mw7u1Tau3wdAFJbqlAvJwIsOpAMru+mc/ytuNPPM2c2YcNqvqtlQpa6wtY
         7vV/ZIhS7k2MSF+U2edS9R8qwgRY3VvXGRZ8LsbP4UQANenFCok2tS85Bcdvewfxe27U
         PGk4rngf7jSSeZ5HHSYw8zAHZmfOnj54E6WGca0Q8rkVRyoldrfXa4Yvp/9jRbrmK4+G
         314pjHseie8k9Rq6xH36mz3t6jpUX9i2CwmqeF0VMfQPGB0F57x2p4wCgOvZ1Q3ENVC+
         /hKNFHF33xAXfrsfRyIRov2EaDEfQ1XFl9o8Bovg4FNHmq6fFsmRdO5+jSQPoPMuxcZq
         endA==
X-Gm-Message-State: APjAAAWGgyBT1vsYCjsyykRh/n5t3OdXT+jwfcOUt12o7OyMls/Bo2GP
        i5V+FDGG+4CzNLf4wdhdl7paVdyib2Q=
X-Google-Smtp-Source: APXvYqwBWAalVw4FoWA7D+ackaiPP9lzbini3VNwpiBcVhocQfghO/eG5jRFPDsEYOCVHmvDRvve1Q==
X-Received: by 2002:a6b:6311:: with SMTP id p17mr7160934iog.127.1579708956573;
        Wed, 22 Jan 2020 08:02:36 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v206sm796924iod.41.2020.01.22.08.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:02:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add support for epoll_ctl(2)
Date:   Wed, 22 Jan 2020 09:02:31 -0700
Message-Id: <20200122160231.11876-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122160231.11876-1-axboe@kernel.dk>
References: <20200122160231.11876-1-axboe@kernel.dk>
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
index 09503d1e9e45..b3bff464d2e7 100644
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
+	if (sqe->ioprio || sqe->buf_index || sqe->off)
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

