Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07112176539
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 21:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCBUq0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 15:46:26 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53060 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgCBUqZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 15:46:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so575443wmc.2;
        Mon, 02 Mar 2020 12:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eZvvwoTWQoLRzBIY7kDB1tlsEytviLYvbxIMGLY07ns=;
        b=NFat6C4AbMWp1b8C4A0xgGpjGeqgR3HmUpLvXC8tsvSkeewZyauzEdYiWh7Cv+SWP6
         0/KsSrb62fiJiFSQjjCEBaJFVAOjev6ZAZTzcJVZRHE98dcrNMCuaWn0rbxE4RZyIdt+
         Now0fi0t29QOlhqGJ6ozJis/5OF/356L7Z8z4INOCrkXK3UmaXURvaj5GMw0V9Vk94iL
         yFFS5wRbXgPIpPoL/Ap8VaprgtrPZ6wuz+vMeWG85/kQLHqvjFr1PTCplcbX2GvmtzD7
         JNy/NAPVSCmKmD+dtcsBozNXfBCtdnOLxCtToSaBU10q1cvta4V7pMWX64GrQ89V+BRp
         UM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZvvwoTWQoLRzBIY7kDB1tlsEytviLYvbxIMGLY07ns=;
        b=aovOaoILZ4XeN8nsu1OdDZGn5n02jklaX/EKTo9pl+B41SPAO9agrAQb3nyWWcKU8r
         +kXYdfBTr8HJNC+JiRDCuZbsg5okwAB+eyMWzGp7R5sisN7EbSk+kv0lRIRucbafm2F0
         HdHvIcmVnoxBl9jG6blnhxYncoHMUpE2Nmal9aBX0WBaRy6buDvlJrnIjisFdajM1dg6
         EHILuczX6Cd3tqXcnRmHTRyj039qeG7+Gpm3MgGj/2DNtqQJHt0D4F3H5fRSZ77KKacc
         GQchAfx14dHeWSzV6rlIzDjDf5rUW1VgwRehjeMHK5EGoYKkR24dg2delgFY5Idb103B
         VQGw==
X-Gm-Message-State: ANhLgQ2aScqdpW4KuoyXqtyKvwqhyLgizLHLyOc7npDCPky3Cj2F3LxE
        Gyy+Pwe8EswkV+Oq307k2/c=
X-Google-Smtp-Source: ADFU+vvpzH3HKBwvDLDnptk86q2l3ewx7QrWhc53+FFFZy04paDiQ5XjoO3Y2CXe0eAj7cWie2eYZA==
X-Received: by 2002:a05:600c:2154:: with SMTP id v20mr211778wml.175.1583181980754;
        Mon, 02 Mar 2020 12:46:20 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id b14sm20186549wrn.75.2020.03.02.12.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 12:46:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] io_uring: remove @nxt from handlers
Date:   Mon,  2 Mar 2020 23:45:18 +0300
Message-Id: <fbb722a208d77386b6a48380e35e4997ffb82e37.1583181841.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583181841.git.asml.silence@gmail.com>
References: <cover.1583181841.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There will be no use for @nxt in the handlers, and it's doesn't work
anyway, so purge it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 204 +++++++++++++++++++++-----------------------------
 1 file changed, 86 insertions(+), 118 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad8046a9bc0f..daf7c2095523 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1804,17 +1804,6 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
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
@@ -2009,14 +1998,14 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
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
@@ -2265,8 +2254,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
-		   bool force_nonblock)
+static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2306,7 +2294,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt);
+			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2355,8 +2343,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_write(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2420,7 +2407,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, nxt);
+			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
@@ -2477,8 +2464,7 @@ static bool io_splice_punt(struct file *file)
 	return !(file->f_mode & O_NONBLOCK);
 }
 
-static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
-		     bool force_nonblock)
+static int io_splice(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_splice *sp = &req->splice;
 	struct file *in = sp->file_in;
@@ -2505,7 +2491,7 @@ static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret != sp->len)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2578,7 +2564,7 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 	}
 }
 
-static void __io_fsync(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_fsync(struct io_kiocb *req)
 {
 	loff_t end = req->sync.off + req->sync.len;
 	int ret;
@@ -2589,7 +2575,7 @@ static void __io_fsync(struct io_kiocb *req, struct io_kiocb **nxt)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static void io_fsync_finish(struct io_wq_work **workptr)
@@ -2599,25 +2585,24 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 
 	if (io_req_cancelled(req))
 		return;
-	__io_fsync(req, &nxt);
+	__io_fsync(req);
 	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
 
-static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
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
 
@@ -2626,7 +2611,7 @@ static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static void io_fallocate_finish(struct io_wq_work **workptr)
@@ -2636,7 +2621,7 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 
 	if (io_req_cancelled(req))
 		return;
-	__io_fallocate(req, &nxt);
+	__io_fallocate(req);
 	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
@@ -2654,8 +2639,7 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
-			bool force_nonblock)
+static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
@@ -2663,7 +2647,7 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	__io_fallocate(req, nxt);
+	__io_fallocate(req);
 	return 0;
 }
 
@@ -2736,8 +2720,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 {
 	struct open_flags op;
 	struct file *file;
@@ -2768,15 +2751,14 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -2804,8 +2786,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_epoll_ctl(struct io_kiocb *req, struct io_kiocb **nxt,
-			bool force_nonblock)
+static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_EPOLL)
 	struct io_epoll *ie = &req->epoll;
@@ -2818,7 +2799,7 @@ static int io_epoll_ctl(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2840,8 +2821,7 @@ static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_madvise(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	struct io_madvise *ma = &req->madvise;
@@ -2854,7 +2834,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2872,8 +2852,7 @@ static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_fadvise *fa = &req->fadvise;
 	int ret;
@@ -2893,7 +2872,7 @@ static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2930,8 +2909,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_statx(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_open *ctx = &req->open;
 	unsigned lookup_flags;
@@ -2968,7 +2946,7 @@ static int io_statx(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -2995,7 +2973,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 /* only called when __close_fd_get_file() is done */
-static void __io_close_finish(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_close_finish(struct io_kiocb *req)
 {
 	int ret;
 
@@ -3004,7 +2982,7 @@ static void __io_close_finish(struct io_kiocb *req, struct io_kiocb **nxt)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	fput(req->close.put_file);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static void io_close_finish(struct io_wq_work **workptr)
@@ -3013,14 +2991,13 @@ static void io_close_finish(struct io_wq_work **workptr)
 	struct io_kiocb *nxt = NULL;
 
 	/* not cancellable, don't do io_req_cancelled() */
-	__io_close_finish(req, &nxt);
+	__io_close_finish(req);
 	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
 
-static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
-		    bool force_nonblock)
+static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
@@ -3047,7 +3024,7 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 	 * No ->flush(), safely close from here and just punt the
 	 * fput() to async context.
 	 */
-	__io_close_finish(req, nxt);
+	__io_close_finish(req);
 	return 0;
 }
 
@@ -3069,7 +3046,7 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
+static void __io_sync_file_range(struct io_kiocb *req)
 {
 	int ret;
 
@@ -3078,7 +3055,7 @@ static void __io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt)
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 
@@ -3089,14 +3066,13 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 
 	if (io_req_cancelled(req))
 		return;
-	__io_sync_file_range(req, &nxt);
+	__io_sync_file_range(req);
 	io_put_req(req); /* put submission ref */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
 
-static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
-			      bool force_nonblock)
+static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 {
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
@@ -3104,7 +3080,7 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 
-	__io_sync_file_range(req, nxt);
+	__io_sync_file_range(req);
 	return 0;
 }
 
@@ -3156,8 +3132,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
@@ -3211,15 +3186,14 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -3262,7 +3236,7 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3303,8 +3277,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
@@ -3360,15 +3333,14 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -3412,7 +3384,7 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3440,8 +3412,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 #if defined(CONFIG_NET)
-static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
-		       bool force_nonblock)
+static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_accept *accept = &req->accept;
 	unsigned file_flags;
@@ -3457,7 +3428,7 @@ static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 }
 
@@ -3468,20 +3439,19 @@ static void io_accept_finish(struct io_wq_work **workptr)
 
 	if (io_req_cancelled(req))
 		return;
-	__io_accept(req, &nxt, false);
+	__io_accept(req, false);
 	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
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
@@ -3516,8 +3486,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #endif
 }
 
-static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
-		      bool force_nonblock)
+static int io_connect(struct io_kiocb *req, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
 	struct io_async_ctx __io, *io;
@@ -3555,7 +3524,7 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3951,7 +3920,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
-static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_poll_add(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3973,7 +3942,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 
 	if (mask) {
 		io_cqring_ev_posted(ctx);
-		io_put_req_find_next(req, nxt);
+		io_put_req(req);
 	}
 	return ipt.error;
 }
@@ -4222,7 +4191,7 @@ static int io_async_cancel_one(struct io_ring_ctx *ctx, void *sqe_addr)
 
 static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req, __u64 sqe_addr,
-				     struct io_kiocb **nxt, int success_ret)
+				     int success_ret)
 {
 	unsigned long flags;
 	int ret;
@@ -4248,7 +4217,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req_find_next(req, nxt);
+	io_put_req(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -4264,11 +4233,11 @@ static int io_async_cancel_prep(struct io_kiocb *req,
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
 
@@ -4475,7 +4444,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			struct io_kiocb **nxt, bool force_nonblock)
+			bool force_nonblock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -4492,7 +4461,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_read(req, nxt, force_nonblock);
+		ret = io_read(req, force_nonblock);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
@@ -4502,7 +4471,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_write(req, nxt, force_nonblock);
+		ret = io_write(req, force_nonblock);
 		break;
 	case IORING_OP_FSYNC:
 		if (sqe) {
@@ -4510,7 +4479,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_fsync(req, nxt, force_nonblock);
+		ret = io_fsync(req, force_nonblock);
 		break;
 	case IORING_OP_POLL_ADD:
 		if (sqe) {
@@ -4518,7 +4487,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_poll_add(req, nxt);
+		ret = io_poll_add(req);
 		break;
 	case IORING_OP_POLL_REMOVE:
 		if (sqe) {
@@ -4534,7 +4503,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_sync_file_range(req, nxt, force_nonblock);
+		ret = io_sync_file_range(req, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
@@ -4544,9 +4513,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4556,9 +4525,9 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4582,7 +4551,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_accept(req, nxt, force_nonblock);
+		ret = io_accept(req, force_nonblock);
 		break;
 	case IORING_OP_CONNECT:
 		if (sqe) {
@@ -4590,7 +4559,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_connect(req, nxt, force_nonblock);
+		ret = io_connect(req, force_nonblock);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
 		if (sqe) {
@@ -4598,7 +4567,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_async_cancel(req, nxt);
+		ret = io_async_cancel(req);
 		break;
 	case IORING_OP_FALLOCATE:
 		if (sqe) {
@@ -4606,7 +4575,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_fallocate(req, nxt, force_nonblock);
+		ret = io_fallocate(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT:
 		if (sqe) {
@@ -4614,7 +4583,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_openat(req, nxt, force_nonblock);
+		ret = io_openat(req, force_nonblock);
 		break;
 	case IORING_OP_CLOSE:
 		if (sqe) {
@@ -4622,7 +4591,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_close(req, nxt, force_nonblock);
+		ret = io_close(req, force_nonblock);
 		break;
 	case IORING_OP_FILES_UPDATE:
 		if (sqe) {
@@ -4638,7 +4607,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_statx(req, nxt, force_nonblock);
+		ret = io_statx(req, force_nonblock);
 		break;
 	case IORING_OP_FADVISE:
 		if (sqe) {
@@ -4646,7 +4615,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_fadvise(req, nxt, force_nonblock);
+		ret = io_fadvise(req, force_nonblock);
 		break;
 	case IORING_OP_MADVISE:
 		if (sqe) {
@@ -4654,7 +4623,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_madvise(req, nxt, force_nonblock);
+		ret = io_madvise(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT2:
 		if (sqe) {
@@ -4662,7 +4631,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_openat2(req, nxt, force_nonblock);
+		ret = io_openat2(req, force_nonblock);
 		break;
 	case IORING_OP_EPOLL_CTL:
 		if (sqe) {
@@ -4670,7 +4639,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret)
 				break;
 		}
-		ret = io_epoll_ctl(req, nxt, force_nonblock);
+		ret = io_epoll_ctl(req, force_nonblock);
 		break;
 	case IORING_OP_SPLICE:
 		if (sqe) {
@@ -4678,7 +4647,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (ret < 0)
 				break;
 		}
-		ret = io_splice(req, nxt, force_nonblock);
+		ret = io_splice(req, force_nonblock);
 		break;
 	default:
 		ret = -EINVAL;
@@ -4722,7 +4691,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, NULL, &nxt, false);
+			ret = io_issue_sqe(req, NULL, false);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -4868,8 +4837,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 	if (prev) {
 		req_set_fail_links(prev);
-		io_async_find_and_cancel(ctx, req, prev->user_data, NULL,
-						-ETIME);
+		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req(prev);
 	} else {
 		io_cqring_add_event(req, -ETIME);
@@ -4938,7 +4906,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			old_creds = override_creds(req->work.creds);
 	}
 
-	ret = io_issue_sqe(req, sqe, &nxt, true);
+	ret = io_issue_sqe(req, sqe, true);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.24.0

