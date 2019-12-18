Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBFC124EEE
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLRRSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:49 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35818 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:49 -0500
Received: by mail-io1-f66.google.com with SMTP id v18so2793809iol.2
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AODvOD5hf5ekhWoN8pzlC/2LEU95f6KX8e08YqZdqDE=;
        b=moO+aBHhFtmDH5X/z2txGfnARYJ6k0kQyzKeiES66tVwyWltAKMkhVOzVyyRzM/ECm
         rurCtJDZ/RJyu95F7Gql1NDJGBJMuBUtSzP2Oj3+rt+U8PhrglZ31QS4Mh33SomE8Gwy
         7VcxgKWOSv2k6RdpuTxQFNXOMb7ay2aMvbSk/tnmPrOGdIR7y4KkYP3bdIWDFPnJ2owi
         ffMrcp9C0CGJsu8woXYNrrJ0/wEpxS56N/Z58WeClGXgHFopmVO66diDDmJZaIDUfh+H
         fp+icwAW5MdPWSPOVDnlZyGxKC/iVt7xuKemCjKy7yd0JHV1Y2bsxu/w7mJLC7O+jcgK
         6pEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AODvOD5hf5ekhWoN8pzlC/2LEU95f6KX8e08YqZdqDE=;
        b=MWnsX0lUGd0xhcRWR17CoZ499lFDj0/xx3IVqJfYrEEBgzqbt+RZKcTAP+oX3DkwOq
         z7TeWSz+xCOwfywLpZANRPMIovacRw506LMSY3eo/tR7M8zXP7siSUCfIrluEmJwnQ/M
         t9S2hwXjykCvbaIcAa4Q0BJ5eE4FPHqYgYrcsRKFQ5eB3aee/B6av+Hs+6L5lwjSAfAr
         S8ARPZds5jP0iaVRzbaDxRN4jkG6eMtc4z8TowcZwZkzR+oTFkfCOs0FyveB83niKgkf
         RPkB/u8lvuhk4z606xhPzhj7zqRLZc6AORoCO0xv6pcp+Zj4ouzwRaEaCDrbs1bJrwK4
         /Lbw==
X-Gm-Message-State: APjAAAWSByG/kwQjekaiKtbmRg8Mr3TJ20JnahBgWtJFb4Tidmvp+m6c
        XoVmhIDO4bc+AKcUpn9QBO5rTMKqJvi47Q==
X-Google-Smtp-Source: APXvYqz4VkQs6XgD8vNPX6JfcT3yqq8Y9HsCASGX5mpQOImWPuPLhWpIgQHejYPZzoJnMON8KNYR1g==
X-Received: by 2002:a02:cb44:: with SMTP id k4mr3401383jap.26.1576689528248;
        Wed, 18 Dec 2019 09:18:48 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:47 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/13] io_uring: any deferred command must have stable sqe data
Date:   Wed, 18 Dec 2019 10:18:28 -0700
Message-Id: <20191218171835.13315-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're currently not retaining sqe data for accept, fsync, and
sync_file_range. None of these commands need data outside of what
is directly provided, hence it can't go stale when the request is
deferred. However, it can get reused, if an application reuses
SQE entries.

Ensure that we retain the information we need and only read the sqe
contents once, off the submission path. Most of this is just moving
code into a prep and finish function.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 223 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 172 insertions(+), 51 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0298dd0abac0..f4e95538f945 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -304,6 +304,20 @@ struct io_timeout_data {
 	u32				seq_offset;
 };
 
+struct io_accept {
+	struct file			*file;
+	struct sockaddr __user		*addr;
+	int __user			*addr_len;
+	int				flags;
+};
+
+struct io_sync {
+	struct file			*file;
+	loff_t				len;
+	loff_t				off;
+	int				flags;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -343,6 +357,8 @@ struct io_kiocb {
 		struct file		*file;
 		struct kiocb		rw;
 		struct io_poll_iocb	poll;
+		struct io_accept	accept;
+		struct io_sync		sync;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -378,6 +394,7 @@ struct io_kiocb {
 #define REQ_F_INFLIGHT		16384	/* on inflight list */
 #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
 #define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
+#define REQ_F_PREPPED		131072	/* request already opcode prepared */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1954,6 +1971,8 @@ static int io_prep_fsync(struct io_kiocb *req)
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -1962,39 +1981,70 @@ static int io_prep_fsync(struct io_kiocb *req)
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 
+	req->sync.flags = READ_ONCE(sqe->fsync_flags);
+	if (unlikely(req->sync.flags & ~IORING_FSYNC_DATASYNC))
+		return -EINVAL;
+
+	req->sync.off = READ_ONCE(sqe->off);
+	req->sync.len = READ_ONCE(sqe->len);
+	req->flags |= REQ_F_PREPPED;
 	return 0;
 }
 
+static bool io_req_cancelled(struct io_kiocb *req)
+{
+	if (req->work.flags & IO_WQ_WORK_CANCEL) {
+		req_set_fail_links(req);
+		io_cqring_add_event(req, -ECANCELED);
+		io_put_req(req);
+		return true;
+	}
+
+	return false;
+}
+
+static void io_fsync_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	loff_t end = req->sync.off + req->sync.len;
+	struct io_kiocb *nxt = NULL;
+	int ret;
+
+	if (io_req_cancelled(req))
+		return;
+
+	ret = vfs_fsync_range(req->rw.ki_filp, req->sync.off,
+				end > 0 ? end : LLONG_MAX,
+				req->sync.flags & IORING_FSYNC_DATASYNC);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, &nxt);
+	if (nxt)
+		*workptr = &nxt->work;
+}
+
 static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 		    bool force_nonblock)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
-	loff_t sqe_off = READ_ONCE(sqe->off);
-	loff_t sqe_len = READ_ONCE(sqe->len);
-	loff_t end = sqe_off + sqe_len;
-	unsigned fsync_flags;
+	struct io_wq_work *work, *old_work;
 	int ret;
 
-	fsync_flags = READ_ONCE(sqe->fsync_flags);
-	if (unlikely(fsync_flags & ~IORING_FSYNC_DATASYNC))
-		return -EINVAL;
-
 	ret = io_prep_fsync(req);
 	if (ret)
 		return ret;
 
 	/* fsync always requires a blocking context */
-	if (force_nonblock)
+	if (force_nonblock) {
+		io_put_req(req);
+		req->work.func = io_fsync_finish;
 		return -EAGAIN;
+	}
 
-	ret = vfs_fsync_range(req->rw.ki_filp, sqe_off,
-				end > 0 ? end : LLONG_MAX,
-				fsync_flags & IORING_FSYNC_DATASYNC);
-
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	work = old_work = &req->work;
+	io_fsync_finish(&work);
+	if (work && work != old_work)
+		*nxt = container_of(work, struct io_kiocb, work);
 	return 0;
 }
 
@@ -2002,8 +2052,9 @@ static int io_prep_sfr(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
-	int ret = 0;
 
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -2012,16 +2063,36 @@ static int io_prep_sfr(struct io_kiocb *req)
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 
-	return ret;
+	req->sync.off = READ_ONCE(sqe->off);
+	req->sync.len = READ_ONCE(sqe->len);
+	req->sync.flags = READ_ONCE(sqe->sync_range_flags);
+	req->flags |= REQ_F_PREPPED;
+	return 0;
+}
+
+static void io_sync_file_range_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+	int ret;
+
+	if (io_req_cancelled(req))
+		return;
+
+	ret = sync_file_range(req->rw.ki_filp, req->sync.off, req->sync.len,
+				req->sync.flags);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, &nxt);
+	if (nxt)
+		*workptr = &nxt->work;
 }
 
 static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 			      bool force_nonblock)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
-	loff_t sqe_off;
-	loff_t sqe_len;
-	unsigned flags;
+	struct io_wq_work *work, *old_work;
 	int ret;
 
 	ret = io_prep_sfr(req);
@@ -2029,19 +2100,16 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 		return ret;
 
 	/* sync_file_range always requires a blocking context */
-	if (force_nonblock)
+	if (force_nonblock) {
+		io_put_req(req);
+		req->work.func = io_sync_file_range_finish;
 		return -EAGAIN;
+	}
 
-	sqe_off = READ_ONCE(sqe->off);
-	sqe_len = READ_ONCE(sqe->len);
-	flags = READ_ONCE(sqe->sync_range_flags);
-
-	ret = sync_file_range(req->rw.ki_filp, sqe_off, sqe_len, flags);
-
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	work = old_work = &req->work;
+	io_sync_file_range_finish(&work);
+	if (work && work != old_work)
+		*nxt = container_of(work, struct io_kiocb, work);
 	return 0;
 }
 
@@ -2226,31 +2294,44 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
-static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
-		     bool force_nonblock)
+static int io_accept_prep(struct io_kiocb *req)
 {
 #if defined(CONFIG_NET)
 	const struct io_uring_sqe *sqe = req->sqe;
-	struct sockaddr __user *addr;
-	int __user *addr_len;
-	unsigned file_flags;
-	int flags, ret;
+	struct io_accept *accept = &req->accept;
+
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->len || sqe->buf_index)
 		return -EINVAL;
 
-	addr = (struct sockaddr __user *) (unsigned long) READ_ONCE(sqe->addr);
-	addr_len = (int __user *) (unsigned long) READ_ONCE(sqe->addr2);
-	flags = READ_ONCE(sqe->accept_flags);
-	file_flags = force_nonblock ? O_NONBLOCK : 0;
+	accept->addr = (struct sockaddr __user *)
+				(unsigned long) READ_ONCE(sqe->addr);
+	accept->addr_len = (int __user *) (unsigned long) READ_ONCE(sqe->addr2);
+	accept->flags = READ_ONCE(sqe->accept_flags);
+	req->flags |= REQ_F_PREPPED;
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
 
-	ret = __sys_accept4_file(req->file, file_flags, addr, addr_len, flags);
-	if (ret == -EAGAIN && force_nonblock) {
-		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+#if defined(CONFIG_NET)
+static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
+		       bool force_nonblock)
+{
+	struct io_accept *accept = &req->accept;
+	unsigned file_flags;
+	int ret;
+
+	file_flags = force_nonblock ? O_NONBLOCK : 0;
+	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
+					accept->addr_len, accept->flags);
+	if (ret == -EAGAIN && force_nonblock)
 		return -EAGAIN;
-	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 	if (ret < 0)
@@ -2258,9 +2339,40 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
 	return 0;
-#else
-	return -EOPNOTSUPP;
+}
+
+static void io_accept_finish(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
+
+	if (io_req_cancelled(req))
+		return;
+	__io_accept(req, &nxt, false);
+	if (nxt)
+		*workptr = &nxt->work;
+}
 #endif
+
+static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
+		     bool force_nonblock)
+{
+#if defined(CONFIG_NET)
+	int ret;
+
+	ret = io_accept_prep(req);
+	if (ret)
+		return ret;
+
+	ret = __io_accept(req, nxt, force_nonblock);
+	if (ret == -EAGAIN && force_nonblock) {
+		req->work.func = io_accept_finish;
+		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+		io_put_req(req);
+		return -EAGAIN;
+	}
+#endif
+	return 0;
 }
 
 static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
@@ -2915,6 +3027,12 @@ static int io_req_defer_prep(struct io_kiocb *req)
 		io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
 		ret = 0;
 		break;
+	case IORING_OP_FSYNC:
+		ret = io_prep_fsync(req);
+		break;
+	case IORING_OP_SYNC_FILE_RANGE:
+		ret = io_prep_sfr(req);
+		break;
 	case IORING_OP_SENDMSG:
 		ret = io_sendmsg_prep(req, io);
 		break;
@@ -2930,6 +3048,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	case IORING_OP_LINK_TIMEOUT:
 		ret = io_timeout_prep(req, io, true);
 		break;
+	case IORING_OP_ACCEPT:
+		ret = io_accept_prep(req);
+		break;
 	default:
 		ret = 0;
 		break;
-- 
2.24.1

