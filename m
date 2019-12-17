Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A6123A50
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLQWy4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:54:56 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37451 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQWyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:54:55 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so54433plz.4
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 14:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L9zblBlEdJO69oGiN+ju2Wg5GQOGAyQnEZEIVqudM4U=;
        b=TSgkabgpcwURIHKnTxw5cGyCw+BPHoWnKv8cZIXyUO61GaJK35GnWRyfepU8AWvSVN
         u6hAjwjdz6TCjDb9KgOkPs4jmrlszJKb8a6Ts29yohMqoecD2mTp9yyrppO6PrfzjBoT
         7stTZW9MmvTtFV0YZh2sCMcGSwW2ZaXV5lIokat5ZnSDweTTzKXMk+U2AVwzxd16i3dw
         76S95vTQ+PIlw/KMIB2oTZld42BefNVhxKDYpOzwDGZ76hsL4+6GUs9NB24SFxuTVqA/
         02AdBTBuWqtk9Stf2OHDDkVXBv/oosU/5LT5mLkpvSOigKVEQ0wU09sHQr92yXCtV8zn
         eNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L9zblBlEdJO69oGiN+ju2Wg5GQOGAyQnEZEIVqudM4U=;
        b=ct1JuCEVUpAmud2rMTwhMwIHtHCqsd2mDUgwgjJuAIHXxeyHdFxwVWxIG+2Lg52GUM
         Ej8YAi1v6gM+aTX3fXq9RXF7aUnobIDq5s8dklbYfsoxE80LsvtA3InfxBlngCRh7wrK
         6fuZG8qlQTKUlzDwq3LHdDpQr6gRUOHiZIVb40au3LDMYMJWx9xZAnaHyjENVuUSxIEu
         QICRoZE7nOttufp+9tF0/gqTdQZ9o6AE5ZpLd793fT2cogRcCoNbEQxHg2MYXSOnviIH
         RvJ3KH5WQGjByuPPPRHG5vR7cF+ghUbGYmwTp4NVzkDBA56Kexe3geYYDPXWRMHGM52S
         m9Mg==
X-Gm-Message-State: APjAAAVF4cH0NjetyWdjBG7+hFJSUb4uShUW+6crqjewKyXFHt+ajDpG
        zeN51lJULm4Wl5A9FMOF+2BOgDUwK7pBtw==
X-Google-Smtp-Source: APXvYqxEZ5wuYCmLPTm7i5bwStRepVa6NOLqmdOeoIPJKbbEk0HpJaVtaTC5ChKonIkuiK6RTY/Cyg==
X-Received: by 2002:a17:902:bf0b:: with SMTP id bi11mr493134plb.282.1576623294332;
        Tue, 17 Dec 2019 14:54:54 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm59320pfe.113.2019.12.17.14.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:54:53 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring: any deferred command must have stable sqe data
Date:   Tue, 17 Dec 2019 15:54:44 -0700
Message-Id: <20191217225445.10739-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217225445.10739-1-axboe@kernel.dk>
References: <20191217225445.10739-1-axboe@kernel.dk>
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
 fs/io_uring.c | 219 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 169 insertions(+), 50 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f6dd4d3215e..667785634848 100644
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
@@ -344,6 +358,8 @@ struct io_kiocb {
 		struct file		*file;
 		struct kiocb		rw;
 		struct io_poll_iocb	poll;
+		struct io_accept	accept;
+		struct io_sync		sync;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -379,6 +395,7 @@ struct io_kiocb {
 #define REQ_F_INFLIGHT		16384	/* on inflight list */
 #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
 #define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
+#define REQ_F_PREPPED		131072	/* request already opcode prepared */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1956,6 +1973,8 @@ static int io_prep_fsync(struct io_kiocb *req)
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -1964,39 +1983,70 @@ static int io_prep_fsync(struct io_kiocb *req)
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
 
@@ -2004,8 +2054,9 @@ static int io_prep_sfr(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
-	int ret = 0;
 
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -2014,16 +2065,36 @@ static int io_prep_sfr(struct io_kiocb *req)
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
@@ -2031,19 +2102,16 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
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
 
@@ -2225,31 +2293,40 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
-static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
-		     bool force_nonblock)
-{
 #if defined(CONFIG_NET)
+static int io_accept_prep(struct io_kiocb *req)
+{
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
+}
 
-	ret = __sys_accept4_file(req->file, file_flags, addr, addr_len, flags);
-	if (ret == -EAGAIN && force_nonblock) {
-		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
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
@@ -2257,6 +2334,39 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
 	return 0;
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
+#endif
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
+	return 0;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2914,6 +3024,12 @@ static int io_req_defer_prep(struct io_kiocb *req)
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
@@ -2929,6 +3045,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
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

