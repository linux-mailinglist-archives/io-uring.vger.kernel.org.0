Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3D916EB29
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgBYQTn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:19:43 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:43023 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQTm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:19:42 -0500
Received: by mail-il1-f193.google.com with SMTP id p78so11278459ilb.10
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCjWZY2DA9SGQMYB8874unldp4qBpu8sVqc5dXs8Kts=;
        b=0QiOcpzrlfmCMSjAGDe/7rS4KgbT/CewdrQID9kjMku3XGi6/isZ3MzkuxnnGvvR22
         AjdjUZGusdgCDKLYoCfyYCZKXc9s8D6x1i2D2Rcy1+UNSjBVUmKVHn90tjW/oLMkq9ti
         V1Z2w4bUNpfXaIRYcEJtNnhzxzSC8b7Bia4gEQVwEMBLYZuM9P2tZ4mmPm6fBbXGazat
         kWHIkZKJaq9cXV8y1+lxDo1XV1GEi4yRjsaawlE7B608AwpiZmEcpAORWzpnKxQJrMKU
         fpmk72DXwmXQLn3ImW7fSDW8t1UwybtIhtEGpeCU6D4XjgLM5TvK//eUsBAzyXKrTEpU
         Y4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCjWZY2DA9SGQMYB8874unldp4qBpu8sVqc5dXs8Kts=;
        b=pypj7wrfBSj2DfmzsYQ58LQdws+vTM/DXAaKUkjy2xaKK/+LD+ZdZdM+BEIABTBUdN
         VX89WBtviw1Av6EnV/szleYfKXFXBsRDaHpQNRHYMFu0Tm8EDHGXtnoJP4MTQgfqMKef
         cvwwOuA6kHgMRBFJe5GVUw6645usuAFQED/O4y2ON5lH2+g+CtJ7ATqJwgeWD3lj5mNg
         A8m5FCSeUqNUR7vZIyJqUoWzGzCeir+pHn3hHj+Sh0AVTfUKT2ARZ5BPAY4Ovu0nzTZG
         eVOVDe3KjkkFTdmVxM5zzo5RqjHtDNnN0q5w0rc0DI4AXqv32k0OiMpxL2DntmigBaNi
         r//A==
X-Gm-Message-State: APjAAAV96g/1Ba826VHRvxgrFS5zc+P9UGPRUTRSEKZDLiyb+OCgM2Ei
        RcIvi5WgwyosRoiFeI2RZK46HK45kuM=
X-Google-Smtp-Source: APXvYqwsQFyVP5Qq5Tq7Td7JOzq1DON9J5QAHc2GfrWFboSPUrJq10mZnbhUPgOsjksp1z+CUL5TFg==
X-Received: by 2002:a92:413:: with SMTP id 19mr66618200ile.117.1582647581534;
        Tue, 25 Feb 2020 08:19:41 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y11sm5652204ilp.46.2020.02.25.08.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:19:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: add IORING_OP_PROVIDE_BUFFER
Date:   Tue, 25 Feb 2020 09:19:34 -0700
Message-Id: <20200225161938.11649-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225161938.11649-1-axboe@kernel.dk>
References: <20200225161938.11649-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_PROVIDE_BUFFER uses the buffer registration infrastructure to
support passing in an addr/len that is associated with a buffer ID and
buffer group ID. The group ID is used to index and lookup the buffers,
while the buffer ID can be used to notify the application which buffer
in the group was used.

At least for now, no validation is done of the buffer ID. If the
application provides buffers within the same group with identical buffer
IDs, then it'll have a hard time telling which buffer ID was used. The
only restriction is that the buffer ID can be a max of 16-bits in size,
so USHRT_MAX is the maximum ID that can be used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 86 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d985da9252a2..d28602f32936 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -452,6 +452,14 @@ struct io_splice {
 	unsigned int			flags;
 };
 
+struct io_provide_buf {
+	struct file			*file;
+	__u64				addr;
+	__s32				len;
+	__u32				gid;
+	__u16				bid;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -577,6 +585,7 @@ struct io_kiocb {
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
 		struct io_splice	splice;
+		struct io_provide_buf	pbuf;
 	};
 
 	struct io_async_ctx		*io;
@@ -804,7 +813,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
-	}
+	},
+	[IORING_OP_PROVIDE_BUFFER] = {},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2807,6 +2817,69 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return io_openat2(req, nxt, force_nonblock);
 }
 
+static int io_provide_buffer_prep(struct io_kiocb *req,
+				  const struct io_uring_sqe *sqe)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	u64 off;
+
+	p->addr = READ_ONCE(sqe->addr);
+	p->len = READ_ONCE(sqe->len);
+	p->gid = READ_ONCE(sqe->fd);
+	off = READ_ONCE(sqe->off);
+	if (off > USHRT_MAX)
+		return -EINVAL;
+	p->bid = off;
+	return 0;
+}
+
+static int io_provide_buffer(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct list_head *list;
+	struct io_buffer *buf;
+	int ret = 0;
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
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf) {
+		if (list_empty(list)) {
+			idr_remove(&ctx->io_buffer_idr, p->gid);
+			kfree(list);
+		}
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	buf->addr = p->addr;
+	buf->len = p->len;
+	buf->bid = p->bid;
+	list_add(&buf->list, list);
+	ret = buf->bid;
+out:
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
@@ -4422,6 +4495,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_SPLICE:
 		ret = io_splice_prep(req, sqe);
 		break;
+	case IORING_OP_PROVIDE_BUFFER:
+		ret = io_provide_buffer_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4699,6 +4775,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_splice(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_PROVIDE_BUFFER:
+		if (sqe) {
+			ret = io_provide_buffer_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_provide_buffer(req, nxt);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 53b36311cdac..7e2af5753bcc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -119,6 +119,7 @@ enum {
 	IORING_OP_OPENAT2,
 	IORING_OP_EPOLL_CTL,
 	IORING_OP_SPLICE,
+	IORING_OP_PROVIDE_BUFFER,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

