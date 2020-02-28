Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2382174347
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 00:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgB1Xig (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 18:38:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51216 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1Xif (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 18:38:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so5203351wmi.1;
        Fri, 28 Feb 2020 15:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UF9jSGohbL/hAD5ZEksw3MHWG5pYVrP+TeYNbRFSeuM=;
        b=Uth0IELqDOYGJfANbYMcDxulXWv311Ldi9fMvKt6LTAqcXjvSS/swSJXlKFA6Siqbc
         f1mfGvGxtXlWaNvX37Ti4IKgnqfjhTlbQHYz9Fc20sGlz2WFh6qoLH1SB9MMvuG5RpEc
         mlNE72N7U/7Ybc3BLWra7E5Yxx09cVdLLHjCkVfhFZbt+Pvw1nzIYbzQFgd3I2TsiHGX
         yck6z1ArdRwqGOA//magDR1r6vUKQkxZyUJ7mDhwRjXstU+VHUFGq0/WtpKM04Jru0HD
         sad+/PBFI8o05Ikq/KVWdoVfK0tGk3IK4+ha4wpgNiuRLm9BdRX8SXMK7qXITS8v7S3Q
         lWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UF9jSGohbL/hAD5ZEksw3MHWG5pYVrP+TeYNbRFSeuM=;
        b=HHCaR0tx1nuxknqiFfIYAzryEq4LaAqEeIXUz2g25xQY2erqvRL7KF1j9QcNzTQ9aU
         ZtzvTZ23aLGSguDmTEQcRwXvN13ZtBvLOCHM/g7v+6j5dDzelYeShag2oe3kI/jirbBT
         jZ1w9Mk8FdnduLhn7WCv4Q1UscYTc80Nhk7ZPI7C6W/PzFgfrjN2z0U9XVMUC0ztBHbP
         R0KHVYirl3CJQK9VAQ2iQM18RmfCcpzpdqJZYCIpogzOXijtPVpKTUfXNKZAsHtkqazZ
         EwcbYht3aGGJxedEqy3zv1/f65wJ8Syg5PE2k+5nVXw6nANXyhEl5ICSlKd/AGlYVc0b
         V1EQ==
X-Gm-Message-State: APjAAAVJFwmh6aMf4ZdCo5kvjA6Ot83KjOCyUzJpzmvjaDNinS8EJgLk
        V3EqPngc3RSk0Z/VxZy6WdgANIwM
X-Google-Smtp-Source: APXvYqwn+C0EreqqbPQ/Winr6/r6VuyDcNo2lx+5p5G8m3tuKRu1YqnXU8wRM6xIb8Cn9WiQsqf2Mg==
X-Received: by 2002:a05:600c:21da:: with SMTP id x26mr4048349wmj.67.1582933111863;
        Fri, 28 Feb 2020 15:38:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q1sm13762512wrw.5.2020.02.28.15.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 15:38:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] io_uring: remove @nxt from the handlers
Date:   Sat, 29 Feb 2020 02:37:25 +0300
Message-Id: <895204fd63644bd31702d05650ba7ce63a3f2922.1582932860.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582932860.git.asml.silence@gmail.com>
References: <cover.1582932860.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 245 ++++++++++++++++++--------------------------------
 1 file changed, 86 insertions(+), 159 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d8d93adb9c2..ee75e503964d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1815,17 +1815,6 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
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
@@ -2020,14 +2009,14 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
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
@@ -2276,8 +2265,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
-		   bool force_nonblock)
+static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2317,7 +2305,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt);
+			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2366,8 +2354,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_write(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2431,7 +2418,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt);
+			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2488,8 +2475,7 @@ static bool io_splice_punt(struct file *file)
 	return !(file->f_mode & O_NONBLOCK);
 }
 
-static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
-		     bool force_nonblock)
+static int io_splice(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_splice *sp = &req->splice;
 	struct file *in = sp->file_in;
@@ -2516,7 +2502,7 @@ static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret != sp->len)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2568,28 +2554,7 @@ static bool io_req_cancelled(struct io_kiocb *req)
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
@@ -2600,23 +2565,19 @@ static void __io_fsync(struct io_kiocb *req, struct io_kiocb **nxt)
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
@@ -2624,11 +2585,11 @@ static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
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
 
@@ -2640,17 +2601,14 @@ static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
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
@@ -2665,8 +2623,7 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
-			bool force_nonblock)
+static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
@@ -2675,7 +2632,7 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	__io_fallocate(req, nxt);
+	__io_fallocate(req);
 	return 0;
 }
 
@@ -2748,8 +2705,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 {
 	struct open_flags op;
 	struct file *file;
@@ -2780,15 +2736,14 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -2816,8 +2771,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_epoll_ctl(struct io_kiocb *req, struct io_kiocb **nxt,
-			bool force_nonblock)
+static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_EPOLL)
 	struct io_epoll *ie = &req->epoll;
@@ -2830,7 +2784,7 @@ static int io_epoll_ctl(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2852,8 +2806,7 @@ static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_madvise(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	struct io_madvise *ma = &req->madvise;
@@ -2866,7 +2819,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2884,8 +2837,7 @@ static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_fadvise *fa = &req->fadvise;
 	int ret;
@@ -2905,7 +2857,7 @@ static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2942,8 +2894,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_statx(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_open *ctx = &req->open;
 	unsigned lookup_flags;
@@ -2980,7 +2931,7 @@ static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -3007,7 +2958,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 /* only called when __close_fd_get_file() is done */
-static void __io_close_finish(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_close_finish(struct io_kiocb *req)
 {
 	int ret;
 
@@ -3016,22 +2967,18 @@ static void __io_close_finish(struct io_kiocb *req, struct io_kiocb **nxt)
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
 
@@ -3048,7 +2995,7 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 	 * No ->flush(), safely close from here and just punt the
 	 * fput() to async context.
 	 */
-	__io_close_finish(req, nxt);
+	__io_close_finish(req);
 	return 0;
 eagain:
 	req->work.func = io_close_finish;
@@ -3079,7 +3026,7 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_sync_file_range(struct io_kiocb *req)
 {
 	int ret;
 
@@ -3088,24 +3035,20 @@ static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
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
@@ -3114,7 +3057,7 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	__io_sync_file_range(req, nxt);
+	__io_sync_file_range(req);
 	return 0;
 }
 
@@ -3166,8 +3109,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
@@ -3221,15 +3163,14 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -3272,7 +3213,7 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3313,8 +3254,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
@@ -3370,15 +3310,14 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -3422,7 +3361,7 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3450,8 +3389,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 #if defined(CONFIG_NET)
-static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
-		       bool force_nonblock)
+static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_accept *accept = &req->accept;
 	unsigned file_flags;
@@ -3467,32 +3405,28 @@ static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -3527,8 +3461,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_connect(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_ctx __io, *io;
@@ -3566,7 +3499,7 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3957,7 +3890,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
-static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_poll_add(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3979,7 +3912,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 
 	if (mask) {
 		io_cqring_ev_posted(ctx);
-		io_put_req_find_next(req, nxt);
+		io_put_req(req);
 	}
 	return ipt.error;
 }
@@ -4228,7 +4161,7 @@ static int io_async_cancel_one(struct io_ring_ctx *ctx, void *sqe_addr)
 
 static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req, __u64 sqe_addr,
-				     struct io_kiocb **nxt, int success_ret)
+				     int success_ret)
 {
 	unsigned long flags;
 	int ret;
@@ -4254,7 +4187,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -4270,11 +4203,11 @@ static int io_async_cancel_prep(struct io_kiocb *req,
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
 
@@ -4481,7 +4414,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			struct io_kiocb **nxt, bool force_nonblock)
+			bool force_nonblock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -4498,7 +4431,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_read(req, nxt, force_nonblock);
+		ret = io_read(req, force_nonblock);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
@@ -4508,7 +4441,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_write(req, nxt, force_nonblock);
+		ret = io_write(req, force_nonblock);
 		break;
 	case IORING_OP_FSYNC:
 		if (sqe) {
@@ -4516,7 +4449,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_fsync(req, nxt, force_nonblock);
+		ret = io_fsync(req, force_nonblock);
 		break;
 	case IORING_OP_POLL_ADD:
 		if (sqe) {
@@ -4524,7 +4457,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_poll_add(req, nxt);
+		ret = io_poll_add(req);
 		break;
 	case IORING_OP_POLL_REMOVE:
 		if (sqe) {
@@ -4540,7 +4473,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_sync_file_range(req, nxt, force_nonblock);
+		ret = io_sync_file_range(req, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
@@ -4550,9 +4483,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4562,9 +4495,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4588,7 +4521,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_accept(req, nxt, force_nonblock);
+		ret = io_accept(req, force_nonblock);
 		break;
 	case IORING_OP_CONNECT:
 		if (sqe) {
@@ -4596,7 +4529,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_connect(req, nxt, force_nonblock);
+		ret = io_connect(req, force_nonblock);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
 		if (sqe) {
@@ -4604,7 +4537,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_async_cancel(req, nxt);
+		ret = io_async_cancel(req);
 		break;
 	case IORING_OP_FALLOCATE:
 		if (sqe) {
@@ -4612,7 +4545,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_fallocate(req, nxt, force_nonblock);
+		ret = io_fallocate(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT:
 		if (sqe) {
@@ -4620,7 +4553,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_openat(req, nxt, force_nonblock);
+		ret = io_openat(req, force_nonblock);
 		break;
 	case IORING_OP_CLOSE:
 		if (sqe) {
@@ -4628,7 +4561,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_close(req, nxt, force_nonblock);
+		ret = io_close(req, force_nonblock);
 		break;
 	case IORING_OP_FILES_UPDATE:
 		if (sqe) {
@@ -4644,7 +4577,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_statx(req, nxt, force_nonblock);
+		ret = io_statx(req, force_nonblock);
 		break;
 	case IORING_OP_FADVISE:
 		if (sqe) {
@@ -4652,7 +4585,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_fadvise(req, nxt, force_nonblock);
+		ret = io_fadvise(req, force_nonblock);
 		break;
 	case IORING_OP_MADVISE:
 		if (sqe) {
@@ -4660,7 +4593,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_madvise(req, nxt, force_nonblock);
+		ret = io_madvise(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT2:
 		if (sqe) {
@@ -4668,7 +4601,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_openat2(req, nxt, force_nonblock);
+		ret = io_openat2(req, force_nonblock);
 		break;
 	case IORING_OP_EPOLL_CTL:
 		if (sqe) {
@@ -4676,7 +4609,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_epoll_ctl(req, nxt, force_nonblock);
+		ret = io_epoll_ctl(req, force_nonblock);
 		break;
 	case IORING_OP_SPLICE:
 		if (sqe) {
@@ -4684,7 +4617,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_splice(req, nxt, force_nonblock);
+		ret = io_splice(req, force_nonblock);
 		break;
 	default:
 		ret = -EINVAL;
@@ -4717,7 +4650,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret = 0;
 
 	/* if NO_CANCEL is set, we must still run the work */
@@ -4728,7 +4660,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, NULL, &nxt, false);
+			ret = io_issue_sqe(req, NULL, false);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -4748,10 +4680,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_cqring_add_event(req, ret);
 		io_put_req(req);
 	}
-
-	/* if a dependent link is ready, pass it back */
-	if (!ret && nxt)
-		io_wq_assign_next(workptr, nxt);
 }
 
 static int io_req_needs_file(struct io_kiocb *req, int fd)
@@ -4877,8 +4805,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 	if (prev) {
 		req_set_fail_links(prev);
-		io_async_find_and_cancel(ctx, req, prev->user_data, NULL,
-						-ETIME);
+		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req(prev);
 	} else {
 		io_cqring_add_event(req, -ETIME);
@@ -4947,7 +4874,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			old_creds = override_creds(req->work.creds);
 	}
 
-	ret = io_issue_sqe(req, sqe, &nxt, true);
+	ret = io_issue_sqe(req, sqe, true);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.24.0

