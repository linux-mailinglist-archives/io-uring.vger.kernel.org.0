Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F53155E83
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 20:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgBGTFy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 14:05:54 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34571 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgBGTFy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 14:05:54 -0500
Received: by mail-ed1-f66.google.com with SMTP id r18so687488edl.1;
        Fri, 07 Feb 2020 11:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSD+/MyGckOhhbwb/tU2htUKh/x0Nzj5MmWX6rBV+kY=;
        b=XG9MHMHcWKPJnHvQl3frfWHLyMQX5KTup70ecQRMiCIlhA+6zKVM+W+DgVJbniLesl
         VOs0nr3Nsy/wQpHYmz1ENXZOcNEg3E0X5E1hPPHcJCRWoTE34h4a9KZKhTP5AgZmQwZz
         aFNJwmSk8wE5SoTYdRZOGfh5Z7tmSoIGP1uB2bhU6LZ4sqjqWSG3rTYlEDS2TjwzCeYQ
         ijPMtsfMhcg2WHWMRcs74sLdYo4+u6RhgSQ4ThQc7AIFkoouKM9+pDwaNWhlGyBFZ3gE
         lMsvRx+cTim2xc6/UPa8KuYBWGJWRj/H4gWkzZn2W/GJKKsMckxE3GOEVs4kEpQ18Zie
         wfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSD+/MyGckOhhbwb/tU2htUKh/x0Nzj5MmWX6rBV+kY=;
        b=hflF1/rUQ6r7RZeOIIznKiUlJdUMfZdJenoHRG5c1/2sgwbNXEUM4P3Jsa7PCGBLGe
         dMMxojSb3Xc5Go7/ferqNSRWAVixqfk5qwSBoZst//7VUq9LaOV/hDlw/iYSR2cBU4Ib
         2+jfmSFHGYp6OFut5iOwVQ34XPM8ZLRXOWBVpobNVszOJQSl4f/Dg5ICijknBvn0Gn2A
         KiWfSZJszlzG7FLJgyDPeKVCkBt9uPyl7g2GciUADHDR7UoXlL2YyuocDlZSML6a+x+8
         VC4oM/a8QMbGYR8Twrf55G2vByuZ4K50HI+1fm7OmZOgVcU9TK7ZoQbGKfy4bu2+/MXh
         671w==
X-Gm-Message-State: APjAAAWYNZcWFBpP7L3ROvxONnZrJg9G78Vin6W8wvJCCyPcyPG0nhk7
        /7CVe0ufm439ksZcfCJsnd1gaEag
X-Google-Smtp-Source: APXvYqzMob8iNgIfTcpgW4FBsEPNCanuHK3zBI1R7nXMXM6zD+UQuJn0lBtNv79T7v7uzF12IY59pQ==
X-Received: by 2002:a17:906:2db1:: with SMTP id g17mr736631eji.240.1581102351921;
        Fri, 07 Feb 2020 11:05:51 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id s11sm458975ejx.90.2020.02.07.11.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 11:05:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix iovec leaks
Date:   Fri,  7 Feb 2020 22:04:45 +0300
Message-Id: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allocated iovec is freed only in io_{read,write,send,recv)(), and just
leaves it if an error occured. There are plenty of such cases:
- cancellation of non-head requests
- fail grabbing files in __io_queue_sqe()
- set REQ_F_NOWAIT and returning in __io_queue_sqe()
- etc.

Add REQ_F_NEED_CLEANUP, which will force such requests with custom
allocated resourses go through cleanup handlers on put.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1914351ebd5e..d699695ef809 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -478,6 +478,7 @@ enum {
 	REQ_F_MUST_PUNT_BIT,
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
+	REQ_F_NEED_CLEANUP_BIT,
 };
 
 enum {
@@ -516,6 +517,8 @@ enum {
 	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
 	/* completion under lock */
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
+	/* needs cleanup */
+	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 
 };
 
@@ -749,6 +752,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args);
 static int io_grab_files(struct io_kiocb *req);
 static void io_ring_file_ref_flush(struct fixed_file_data *data);
+static void io_cleanup_req(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -1236,6 +1240,9 @@ static void __io_free_req(struct io_kiocb *req)
 {
 	__io_req_aux_free(req);
 
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		io_cleanup_req(req);
+
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
 		unsigned long flags;
@@ -2129,6 +2136,8 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 		req->io->rw.iov = req->io->rw.fast_iov;
 		memcpy(req->io->rw.iov, fast_iov,
 			sizeof(struct iovec) * iter->nr_segs);
+	} else {
+		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 }
 
@@ -2239,6 +2248,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	}
 out_free:
 	kfree(iovec);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	return ret;
 }
 
@@ -2343,6 +2353,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 	}
 out_free:
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	kfree(iovec);
 	return ret;
 }
@@ -2943,6 +2954,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
+	int ret;
 
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -2952,8 +2964,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
-	return sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.iov);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -3011,6 +3026,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 					kfree(kmsg->iov);
 				return -ENOMEM;
 			}
+			req->flags |= REQ_F_NEED_CLEANUP;
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
 			return -EAGAIN;
 		}
@@ -3020,6 +3036,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -3087,6 +3104,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 #if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
+	int ret;
 
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -3096,8 +3114,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
-	return recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.uaddr, &io->msg.iov);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -3158,6 +3179,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 				return -ENOMEM;
 			}
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
+			req->flags |= REQ_F_NEED_CLEANUP;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -3166,6 +3188,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -4176,6 +4199,30 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EIOCBQUEUED;
 }
 
+static void io_cleanup_req(struct io_kiocb *req)
+{
+	struct io_async_ctx *io = req->io;
+
+	switch (req->opcode) {
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		if (io->rw.iov != io->rw.fast_iov)
+			kfree(io->rw.iov);
+		break;
+	case IORING_OP_SENDMSG:
+	case IORING_OP_RECVMSG:
+		if (io->msg.iov != io->msg.fast_iov)
+			kfree(io->msg.iov);
+		break;
+	}
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+}
+
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			struct io_kiocb **nxt, bool force_nonblock)
 {
-- 
2.24.0

