Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73529174290
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 23:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgB1WyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 17:54:13 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51986 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgB1WyN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 17:54:13 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so5104802wmi.1;
        Fri, 28 Feb 2020 14:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TxIpii5EB8dbjzC/7iOTHt0lPDBRjGiiz/7f8o1wRJQ=;
        b=hFMT9JoZ2k3rQGp/rhivw0KMoM/f3iCREGbUOrUmuCkR/lUFu2f8GHoA5rWWUGg0vj
         JmfhyXEB+uCubdv+aOCxS/JVGyeAeLzYvmtq1P7+iU2JaqwkXviba6Yjfthbih7NCGMx
         IyomSRJxTEzQy/gqJwcDhBF1zhSVUjJXmRxaOhjxlv4QpoZD+AON2O9kZ29/RiJcR9Bh
         mb/oGqafs9SUoRRH/JGS54Jwen8izQshqYkhtQU8YSKSiBYIaNL8Utwt33D0/t2YBsqA
         epY+RLvlg5lCvkjQkRp8jN8DHYwh94N4/XaE0Vw86og+2WOFh4OclOu/0dMV5j7d45Kf
         6lPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TxIpii5EB8dbjzC/7iOTHt0lPDBRjGiiz/7f8o1wRJQ=;
        b=a9FAJgy3L8PLlBsK7iEREJeu8mWVGAavip8VaoV5R2C66nSgpRZDDsdnfC9OIbiHJn
         8Pp+v7hq2Tb2eD86HlT8+aVKDlvz2PrLlP3h2ihgAvHVjn4m+0MSzgrtjdXRk0M5Coue
         fDFX+qQ6SRt1TgJ0MGxfzQc6PJZtRzjQiRw6UI8njM2/TVB74Fuo6AJW6YF+5OzBSI0Y
         3995JllbyMnig0Lbo8BxKLG/DBmprPDuRccfxm7Eqm7w0b3zGK5vjXWZc2slXg8azkw8
         V1lRxVTr1eHALG1xjl3s6/IIvQVBbQyu0U9+6BFPXmzA6PUS68EtsWKs6ODlLcSzowZq
         Hwpw==
X-Gm-Message-State: APjAAAWOUGDm8H0eVxDrQ+n24IuyUTu7bUtd09aPCOPX+eRdIWwjSTYg
        T53WY6rUOAX1Osl/55sTgcUd3l7u
X-Google-Smtp-Source: APXvYqzt3eFomEn9lavZMXLLcbW/ENgCGL1BqRoGVmCzxoo06IGTLW8NvZ4VV8+EFz6gnemO4fhsuQ==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr2540421wmj.41.1582930448082;
        Fri, 28 Feb 2020 14:54:08 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f1sm14603773wro.85.2020.02.28.14.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:54:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] io_uring: remove @nxt from the handlers
Date:   Sat, 29 Feb 2020 01:53:07 +0300
Message-Id: <dd9569e22b5afc60db428f0079c9ea2cebe76f89.1582929017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582929017.git.asml.silence@gmail.com>
References: <cover.1582929017.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After io_put_req_find_next() fix, no opcode handler can return non-NULL
nxt, that's because there is always a submission ref, which keeps them
from doing that. Remove @nxt from them, it's intrusive but
straightforward.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 250 ++++++++++++++++++--------------------------------
 1 file changed, 87 insertions(+), 163 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f5fbde552be7..c92bd6d8d630 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1795,17 +1795,6 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 	io_put_req(req);
 }
 
-static struct io_kiocb *__io_complete_rw(struct kiocb *kiocb, long res)
-{
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
-	struct io_kiocb *nxt = NULL;
-
-	io_complete_rw_common(kiocb, res);
-	io_put_req_find_next(req, &nxt);
-
-	return nxt;
-}
-
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
@@ -2000,14 +1989,14 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt)
+static void kiocb_done(struct kiocb *kiocb, ssize_t ret)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
-		*nxt = __io_complete_rw(kiocb, ret);
+		io_complete_rw(kiocb, ret, 0);
 	else
 		io_rw_done(kiocb, ret);
 }
@@ -2256,8 +2245,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
-		   bool force_nonblock)
+static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2297,7 +2285,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt);
+			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2346,8 +2334,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_write(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2411,7 +2398,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt);
+			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2468,8 +2455,7 @@ static bool io_splice_punt(struct file *file)
 	return !(file->f_mode & O_NONBLOCK);
 }
 
-static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
-		     bool force_nonblock)
+static int io_splice(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_splice *sp = &req->splice;
 	struct file *in = sp->file_in;
@@ -2496,7 +2482,7 @@ static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret != sp->len)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2548,28 +2534,7 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	return false;
 }
 
-static void io_link_work_cb(struct io_wq_work **workptr)
-{
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *link = work->data;
-
-	io_queue_linked_timeout(link);
-	io_wq_submit_work(workptr);
-}
-
-static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
-{
-	struct io_kiocb *link;
-
-	io_prep_next_work(nxt, &link);
-	*workptr = &nxt->work;
-	if (link) {
-		nxt->work.func = io_link_work_cb;
-		nxt->work.data = link;
-	}
-}
-
-static void __io_fsync(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_fsync(struct io_kiocb *req)
 {
 	loff_t end = req->sync.off + req->sync.len;
 	int ret;
@@ -2580,23 +2545,19 @@ static void __io_fsync(struct io_kiocb *req, struct io_kiocb **nxt)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static void io_fsync_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
-	__io_fsync(req, &nxt);
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	__io_fsync(req);
 }
 
-static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
@@ -2604,11 +2565,11 @@ static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 		req->work.func = io_fsync_finish;
 		return -EAGAIN;
 	}
-	__io_fsync(req, nxt);
+	__io_fsync(req);
 	return 0;
 }
 
-static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_fallocate(struct io_kiocb *req)
 {
 	int ret;
 
@@ -2620,17 +2581,14 @@ static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static void io_fallocate_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
-	__io_fallocate(req, &nxt);
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	__io_fallocate(req);
 }
 
 static int io_fallocate_prep(struct io_kiocb *req,
@@ -2645,8 +2603,7 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
-			bool force_nonblock)
+static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
@@ -2655,7 +2612,7 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	__io_fallocate(req, nxt);
+	__io_fallocate(req);
 	return 0;
 }
 
@@ -2728,8 +2685,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 {
 	struct open_flags op;
 	struct file *file;
@@ -2760,15 +2716,14 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
-static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
-		     bool force_nonblock)
+static int io_openat(struct io_kiocb *req, bool force_nonblock)
 {
 	req->open.how = build_open_how(req->open.how.flags, req->open.how.mode);
-	return io_openat2(req, nxt, force_nonblock);
+	return io_openat2(req, force_nonblock);
 }
 
 static int io_epoll_ctl_prep(struct io_kiocb *req,
@@ -2796,8 +2751,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_epoll_ctl(struct io_kiocb *req, struct io_kiocb **nxt,
-			bool force_nonblock)
+static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_EPOLL)
 	struct io_epoll *ie = &req->epoll;
@@ -2810,7 +2764,7 @@ static int io_epoll_ctl(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2832,8 +2786,7 @@ static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_madvise(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	struct io_madvise *ma = &req->madvise;
@@ -2846,7 +2799,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2864,8 +2817,7 @@ static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_fadvise *fa = &req->fadvise;
 	int ret;
@@ -2885,7 +2837,7 @@ static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2922,8 +2874,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_statx(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_open *ctx = &req->open;
 	unsigned lookup_flags;
@@ -2960,7 +2911,7 @@ static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2987,7 +2938,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 /* only called when __close_fd_get_file() is done */
-static void __io_close_finish(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_close_finish(struct io_kiocb *req)
 {
 	int ret;
 
@@ -2996,22 +2947,18 @@ static void __io_close_finish(struct io_kiocb *req, struct io_kiocb **nxt)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	fput(req->close.put_file);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static void io_close_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	/* not cancellable, don't do io_req_cancelled() */
-	__io_close_finish(req, &nxt);
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	__io_close_finish(req);
 }
 
-static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
@@ -3028,7 +2975,7 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 	 * No ->flush(), safely close from here and just punt the
 	 * fput() to async context.
 	 */
-	__io_close_finish(req, nxt);
+	__io_close_finish(req);
 	return 0;
 eagain:
 	req->work.func = io_close_finish;
@@ -3059,7 +3006,7 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_sync_file_range(struct io_kiocb *req)
 {
 	int ret;
 
@@ -3068,24 +3015,20 @@ static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 
 static void io_sync_file_range_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
-	__io_sync_file_range(req, &nxt);
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	__io_sync_file_range(req);
 }
 
-static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
-			      bool force_nonblock)
+static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 {
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
@@ -3094,7 +3037,7 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	__io_sync_file_range(req, nxt);
+	__io_sync_file_range(req);
 	return 0;
 }
 
@@ -3141,8 +3084,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
@@ -3196,15 +3138,14 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
 #endif
 }
 
-static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
-		   bool force_nonblock)
+static int io_send(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct socket *sock;
@@ -3247,7 +3188,7 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3283,8 +3224,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
@@ -3340,15 +3280,14 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
 #endif
 }
 
-static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
-		   bool force_nonblock)
+static int io_recv(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct socket *sock;
@@ -3392,7 +3331,7 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3420,8 +3359,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 #if defined(CONFIG_NET)
-static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
-		       bool force_nonblock)
+static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_accept *accept = &req->accept;
 	unsigned file_flags;
@@ -3437,32 +3375,28 @@ static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
 static void io_accept_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	io_put_req(req);
 
 	if (io_req_cancelled(req))
 		return;
-	__io_accept(req, &nxt, false);
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	__io_accept(req, false);
 }
 #endif
 
-static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
-		     bool force_nonblock)
+static int io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	int ret;
 
-	ret = __io_accept(req, nxt, force_nonblock);
+	ret = __io_accept(req, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
 		req->work.func = io_accept_finish;
 		return -EAGAIN;
@@ -3497,8 +3431,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_connect(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_ctx __io, *io;
@@ -3536,7 +3469,7 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3641,7 +3574,6 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 	struct io_poll_iocb *poll = &req->poll;
 	struct poll_table_struct pt = { ._key = poll->events };
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *nxt = NULL;
 	__poll_t mask = 0;
 	int ret = 0;
 
@@ -3676,9 +3608,7 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, &nxt);
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req(req);
 }
 
 static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
@@ -3826,7 +3756,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
-static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_poll_add(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3880,7 +3810,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 
 	if (mask) {
 		io_cqring_ev_posted(ctx);
-		io_put_req_find_next(req, nxt);
+		io_put_req(req);
 	}
 	return ipt.error;
 }
@@ -4129,7 +4059,7 @@ static int io_async_cancel_one(struct io_ring_ctx *ctx, void *sqe_addr)
 
 static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req, __u64 sqe_addr,
-				     struct io_kiocb **nxt, int success_ret)
+				     int success_ret)
 {
 	unsigned long flags;
 	int ret;
@@ -4155,7 +4085,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -4171,11 +4101,11 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_async_cancel(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_async_find_and_cancel(ctx, req, req->cancel.addr, nxt, 0);
+	io_async_find_and_cancel(ctx, req, req->cancel.addr, 0);
 	return 0;
 }
 
@@ -4382,7 +4312,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			struct io_kiocb **nxt, bool force_nonblock)
+			bool force_nonblock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -4399,7 +4329,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_read(req, nxt, force_nonblock);
+		ret = io_read(req, force_nonblock);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
@@ -4409,7 +4339,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_write(req, nxt, force_nonblock);
+		ret = io_write(req, force_nonblock);
 		break;
 	case IORING_OP_FSYNC:
 		if (sqe) {
@@ -4417,7 +4347,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_fsync(req, nxt, force_nonblock);
+		ret = io_fsync(req, force_nonblock);
 		break;
 	case IORING_OP_POLL_ADD:
 		if (sqe) {
@@ -4425,7 +4355,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_poll_add(req, nxt);
+		ret = io_poll_add(req);
 		break;
 	case IORING_OP_POLL_REMOVE:
 		if (sqe) {
@@ -4441,7 +4371,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_sync_file_range(req, nxt, force_nonblock);
+		ret = io_sync_file_range(req, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
@@ -4451,9 +4381,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				break;
 		}
 		if (req->opcode == IORING_OP_SENDMSG)
-			ret = io_sendmsg(req, nxt, force_nonblock);
+			ret = io_sendmsg(req, force_nonblock);
 		else
-			ret = io_send(req, nxt, force_nonblock);
+			ret = io_send(req, force_nonblock);
 		break;
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
@@ -4463,9 +4393,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				break;
 		}
 		if (req->opcode == IORING_OP_RECVMSG)
-			ret = io_recvmsg(req, nxt, force_nonblock);
+			ret = io_recvmsg(req, force_nonblock);
 		else
-			ret = io_recv(req, nxt, force_nonblock);
+			ret = io_recv(req, force_nonblock);
 		break;
 	case IORING_OP_TIMEOUT:
 		if (sqe) {
@@ -4489,7 +4419,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_accept(req, nxt, force_nonblock);
+		ret = io_accept(req, force_nonblock);
 		break;
 	case IORING_OP_CONNECT:
 		if (sqe) {
@@ -4497,7 +4427,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_connect(req, nxt, force_nonblock);
+		ret = io_connect(req, force_nonblock);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
 		if (sqe) {
@@ -4505,7 +4435,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_async_cancel(req, nxt);
+		ret = io_async_cancel(req);
 		break;
 	case IORING_OP_FALLOCATE:
 		if (sqe) {
@@ -4513,7 +4443,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_fallocate(req, nxt, force_nonblock);
+		ret = io_fallocate(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT:
 		if (sqe) {
@@ -4521,7 +4451,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_openat(req, nxt, force_nonblock);
+		ret = io_openat(req, force_nonblock);
 		break;
 	case IORING_OP_CLOSE:
 		if (sqe) {
@@ -4529,7 +4459,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_close(req, nxt, force_nonblock);
+		ret = io_close(req, force_nonblock);
 		break;
 	case IORING_OP_FILES_UPDATE:
 		if (sqe) {
@@ -4545,7 +4475,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_statx(req, nxt, force_nonblock);
+		ret = io_statx(req, force_nonblock);
 		break;
 	case IORING_OP_FADVISE:
 		if (sqe) {
@@ -4553,7 +4483,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_fadvise(req, nxt, force_nonblock);
+		ret = io_fadvise(req, force_nonblock);
 		break;
 	case IORING_OP_MADVISE:
 		if (sqe) {
@@ -4561,7 +4491,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_madvise(req, nxt, force_nonblock);
+		ret = io_madvise(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT2:
 		if (sqe) {
@@ -4569,7 +4499,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_openat2(req, nxt, force_nonblock);
+		ret = io_openat2(req, force_nonblock);
 		break;
 	case IORING_OP_EPOLL_CTL:
 		if (sqe) {
@@ -4577,7 +4507,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_epoll_ctl(req, nxt, force_nonblock);
+		ret = io_epoll_ctl(req, force_nonblock);
 		break;
 	case IORING_OP_SPLICE:
 		if (sqe) {
@@ -4585,7 +4515,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_splice(req, nxt, force_nonblock);
+		ret = io_splice(req, force_nonblock);
 		break;
 	default:
 		ret = -EINVAL;
@@ -4618,7 +4548,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret = 0;
 
 	/* if NO_CANCEL is set, we must still run the work */
@@ -4629,7 +4558,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, NULL, &nxt, false);
+			ret = io_issue_sqe(req, NULL, false);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -4649,10 +4578,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_cqring_add_event(req, ret);
 		io_put_req(req);
 	}
-
-	/* if a dependent link is ready, pass it back */
-	if (!ret && nxt)
-		io_wq_assign_next(workptr, nxt);
 }
 
 static int io_req_needs_file(struct io_kiocb *req, int fd)
@@ -4778,8 +4703,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 	if (prev) {
 		req_set_fail_links(prev);
-		io_async_find_and_cancel(ctx, req, prev->user_data, NULL,
-						-ETIME);
+		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req(prev);
 	} else {
 		io_cqring_add_event(req, -ETIME);
@@ -4845,7 +4769,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			old_creds = override_creds(req->work.creds);
 	}
 
-	ret = io_issue_sqe(req, sqe, &nxt, true);
+	ret = io_issue_sqe(req, sqe, true);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.24.0

