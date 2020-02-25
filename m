Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1951A16EB2B
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgBYQTo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:19:44 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45159 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQTo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:19:44 -0500
Received: by mail-io1-f66.google.com with SMTP id w9so2064458iob.12
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qkq/H9+YPBQDggT7ZKYQnOeJK6BlMUm4iinp+onrTLs=;
        b=ljZ3xSOp74Ll9aM4nb7lP7/XvcqqyfTB8Q8WXLXTw65o1spQrOeS8Q48YiJ6CcUlo3
         fnTHXkMQUmbwtZz5nJvvT0dGaBgX55ND8+eSprDbyd+lFu7kNW83zVMOIS8DTceGUAqb
         IHSQt4IDRAryGFWI+C7GlcoLixsZ8C5OZcTlEbbsHsN8CSqfA2IOJAApqlKySCuJbfyo
         AupUKbZqAVLXczD0JDHEyV+69Oa+VpuwMC+yo/WPX0ZsI8XB3YN0aDoaGJYwX3QxuoE1
         /BVLw/DYH8gaPUQ4Lm5GFhAVcE5V8iFjj47TREWcrTfLr6B65VorII33xLunjULNVD6h
         fEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qkq/H9+YPBQDggT7ZKYQnOeJK6BlMUm4iinp+onrTLs=;
        b=ETdKpO6KMbhN0DTLbzWIZ/ps6Wo6R16hHIeEGRyV7vD/LGY0arCQNJ6jYP9CKV67H1
         1uTSvsnTjebbS54mdAtnQoMFwMvJHoUdAouzv5jMfoG/pBC0GU0ya2fCepeGgiJsrNdQ
         Q76pzjJUQJS2FrZwv4t/KJxLJ25F1DVRu8UwZu0UdigsMw/QxPX+uOU5s1Sx0DLsJfUY
         215IiHqyXw2AMzcMAagpCWMgYyEZuSl8bXtk+PrSmAHAgIzMZpppWHyL9DUSKQTsWIz0
         MKXcgR4q7E2ytVhtDY4ivp6apjQslYipHjXfxdkzKUEFwfHOPd7XIBPngcYQ6+uqxv+F
         cSDQ==
X-Gm-Message-State: APjAAAXxISUDD1NYsZnnPhZQ4co0rps4zFDmSHdfECHluWX/hRN5JZpV
        d0fAUHxNnq+8GFjBBpRoEMQ3G9pfSKw=
X-Google-Smtp-Source: APXvYqw/i625HwdxUW3u37RjzoRP1/zLl2HiLhxDi3+tNRHXPETXruZ6VsdpNtfBJf3xP3x6l3UhxQ==
X-Received: by 2002:a5d:9c05:: with SMTP id 5mr52639280ioe.18.1582647583491;
        Tue, 25 Feb 2020 08:19:43 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y11sm5652204ilp.46.2020.02.25.08.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:19:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: add IORING_OP_PROVIDE_BUFFERS
Date:   Tue, 25 Feb 2020 09:19:36 -0700
Message-Id: <20200225161938.11649-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225161938.11649-1-axboe@kernel.dk>
References: <20200225161938.11649-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_PROVIDE_BUFFERS uses the buffer registration infrastructure to
support passing in an addr/len that is associated with a buffer ID and
buffer group ID. The group ID is used to index and lookup the buffers,
while the buffer ID can be used to notify the application which buffer
in the group was used. The addr passed in is the starting buffer address,
and length is each buffer length. A number of buffers to add with can be
specified, in which case addr is incremented by length for each addition,
and each buffer increments the buffer ID specified.

No validation is done of the buffer ID. If the application provides
buffers within the same group with identical buffer IDs, then it'll have
a hard time telling which buffer ID was used. The only restriction is
that the buffer ID can be a max of 16-bits in size, so USHRT_MAX is the
maximum ID that can be used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 123 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   9 ++-
 2 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d985da9252a2..c4dcb7565a20 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -452,6 +452,15 @@ struct io_splice {
 	unsigned int			flags;
 };
 
+struct io_provide_buf {
+	struct file			*file;
+	__u64				addr;
+	__s32				len;
+	__u32				gid;
+	__u16				nbufs;
+	__u16				bid;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -577,6 +586,7 @@ struct io_kiocb {
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
 		struct io_splice	splice;
+		struct io_provide_buf	pbuf;
 	};
 
 	struct io_async_ctx		*io;
@@ -804,7 +814,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
-	}
+	},
+	[IORING_OP_PROVIDE_BUFFERS] = {},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2807,6 +2818,105 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return io_openat2(req, nxt, force_nonblock);
 }
 
+static int io_provide_buffers_prep(struct io_kiocb *req,
+				   const struct io_uring_sqe *sqe)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	u64 tmp;
+
+	if (sqe->ioprio || sqe->rw_flags)
+		return -EINVAL;
+
+	tmp = READ_ONCE(sqe->fd);
+	if (!tmp || tmp > USHRT_MAX)
+		return -EINVAL;
+	p->nbufs = tmp;
+	p->addr = READ_ONCE(sqe->addr);
+	p->len = READ_ONCE(sqe->len);
+	p->gid = READ_ONCE(sqe->buf_group);
+	tmp = READ_ONCE(sqe->off);
+	if (tmp > USHRT_MAX)
+		return -EINVAL;
+	p->bid = tmp;
+	return 0;
+}
+
+static int io_add_buffers(struct io_provide_buf *pbuf, struct list_head *list)
+{
+	struct io_buffer *buf;
+	u64 addr = pbuf->addr;
+	int i, bid = pbuf->bid;
+
+	for (i = 0; i < pbuf->nbufs; i++) {
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+		if (!buf)
+			break;
+
+		buf->addr = addr;
+		buf->len = pbuf->len;
+		buf->bid = bid;
+		list_add(&buf->list, list);
+		addr += pbuf->len;
+		bid++;
+	}
+
+	return i;
+}
+
+static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
+			      bool force_nonblock)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct list_head *list;
+	int ret = 0;
+
+	/*
+	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * grab it from the system call. Same is true for the SQPOLL offload.
+	 * The only exception is when we've detached the request and issue it
+	 * from an async worker thread, grab the lock for that case.
+	 */
+	if (!force_nonblock)
+		mutex_lock(&ctx->uring_lock);
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	list = idr_find(&ctx->io_buffer_idr, p->gid);
+	if (!list) {
+		list = kmalloc(sizeof(*list), GFP_KERNEL);
+		if (!list) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(list);
+		ret = idr_alloc(&ctx->io_buffer_idr, list, p->gid, p->gid + 1,
+					GFP_KERNEL);
+		if (ret < 0) {
+			kfree(list);
+			goto out;
+		}
+	}
+
+	ret = io_add_buffers(p, list);
+	if (!ret) {
+		/* no buffers added and list empty, remove entry */
+		if (list_empty(list)) {
+			idr_remove(&ctx->io_buffer_idr, p->gid);
+			kfree(list);
+		}
+		ret = -ENOMEM;
+	}
+out:
+	if (!force_nonblock)
+		mutex_unlock(&ctx->uring_lock);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+}
+
 static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
@@ -4422,6 +4532,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_SPLICE:
 		ret = io_splice_prep(req, sqe);
 		break;
+	case IORING_OP_PROVIDE_BUFFERS:
+		ret = io_provide_buffers_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4699,6 +4812,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_splice(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_PROVIDE_BUFFERS:
+		if (sqe) {
+			ret = io_provide_buffers_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_provide_buffers(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 53b36311cdac..1de1f683cc3c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -45,8 +45,12 @@ struct io_uring_sqe {
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
 		struct {
-			/* index into fixed buffers, if used */
-			__u16	buf_index;
+			union {
+				/* index into fixed buffers, if used */
+				__u16	buf_index;
+				/* for grouped buffer selection */
+				__u16	buf_group;
+			};
 			/* personality to use, if used */
 			__u16	personality;
 			__s32	splice_fd_in;
@@ -119,6 +123,7 @@ enum {
 	IORING_OP_OPENAT2,
 	IORING_OP_EPOLL_CTL,
 	IORING_OP_SPLICE,
+	IORING_OP_PROVIDE_BUFFERS,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

