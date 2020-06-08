Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE01F1EBB
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 20:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgFHSKJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 14:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgFHSJy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 14:09:54 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71D5C08C5C2;
        Mon,  8 Jun 2020 11:09:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c35so14235477edf.5;
        Mon, 08 Jun 2020 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJH9XD/gsRGFvQ9dtgxug8Jz0MJvZsMvr2AlDxZ+XHw=;
        b=IUZGbhKpaPQ/80Mr01mqApaZYwenc+Mhe3VLCWVH7NabzzgZjUFt+1OCVZarmn2KW0
         OFMq2QPblC0XOkhFs3siTyKFEVMmeA1M0OAp3zdp0Tx5xdJcYlppq/6vQ+AELsP30peV
         6DEJLfStbyqYkYnMapv++/f9JjMycjfAsWh8dolz4+c6LzuGEFIc5lzrOpexobesIukD
         aeVSKSmuE0dczcSNNCU/2aEf7gd7D7PfMf2Nj6/sQ6rHnnKSPSKy6nZ5vCSNMkOv3+uD
         b608X0jz9GSersE+iD6cVrBsQ+rTybOBr7GBXfTBbclt5XbjrVi+lykaRSx38Q+YlktV
         iBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJH9XD/gsRGFvQ9dtgxug8Jz0MJvZsMvr2AlDxZ+XHw=;
        b=gB5b0IpvVjYcGOJHXshaP/rB6BpaPnf989Tf3h+yK4Mgbp32X4On50zRXYhzyWDdO6
         Hs/KuXy9Au7v3BGWV4o52TpekNTicowiTF+VK2bIE/ONstTSfk1DHZ1IIHvToK99bWU2
         tOrdQErEjk6DP3iYfWr7c4HSH9gIbJwbH0dMG+grhWYTfrUNVqSjn3FT3jZ5RtOPj3Ba
         Tclhzf1CUVSkMor9eOb1SpQHHgU4U89K5RuRF7hk8ml2N0/YztuKUyUYNYoEoqadpWsy
         vtMilWO/XNtIR7+Mu2QPGddRh9MpWC0B5GnY2iTpDPKFyIx4hfDXzl47458wWRlgOaAG
         65IA==
X-Gm-Message-State: AOAM532+OxzIitdAv6F/inKW9/nYyVUnKmPdP3htn+baiRc0k1nP5mvW
        ZLZ4wepGkTDtug+Q/kxTVuYbQEOJ
X-Google-Smtp-Source: ABdhPJxkKl7hmC8elYh0V7IlxH5KJML7VdNO3fULWJoz1PQcWhLvbr7awRDb1t7FAuQKQ1+s/uTJHA==
X-Received: by 2002:a50:eacb:: with SMTP id u11mr22800624edp.162.1591639791001;
        Mon, 08 Jun 2020 11:09:51 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id ok21sm10515029ejb.82.2020.06.08.11.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 11:09:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, xiaoguang.wang@linux.alibaba.com
Subject: [PATCH 2/4] io_uring: remove custom ->func handlers
Date:   Mon,  8 Jun 2020 21:08:18 +0300
Message-Id: <ad646a5dd1ab59a87a10b8c7a3091dc711497f5a.1591637070.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591637070.git.asml.silence@gmail.com>
References: <cover.1591637070.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation of getting rid of work.func, this removes almost all
custom instances of it, leaving only io_wq_submit_work() and
io_link_work_cb(). And the last one will be dealt later.

Nothing fancy, just routinely remove *_finish() function and inline
what's left. E.g. remove io_fsync_finish() + inline __io_fsync() into
io_fsync().

As no users of io_req_cancelled() are left, delete it as well. The patch
adds extra switch lookup on cold-ish path, but that's overweighted by
nice diffstat and other benefits of the following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 139 ++++++++++----------------------------------------
 1 file changed, 27 insertions(+), 112 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9acd695cc473..ce7f815658a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2940,23 +2940,15 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static bool io_req_cancelled(struct io_kiocb *req)
-{
-	if (req->work.flags & IO_WQ_WORK_CANCEL) {
-		req_set_fail_links(req);
-		io_cqring_add_event(req, -ECANCELED);
-		io_put_req(req);
-		return true;
-	}
-
-	return false;
-}
-
-static void __io_fsync(struct io_kiocb *req)
+static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 {
 	loff_t end = req->sync.off + req->sync.len;
 	int ret;
 
+	/* fsync always requires a blocking context */
+	if (force_nonblock)
+		return -EAGAIN;
+
 	ret = vfs_fsync_range(req->file, req->sync.off,
 				end > 0 ? end : LLONG_MAX,
 				req->sync.flags & IORING_FSYNC_DATASYNC);
@@ -2964,53 +2956,9 @@ static void __io_fsync(struct io_kiocb *req)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
-}
-
-static void io_fsync_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_fsync(req);
-	io_steal_work(req, workptr);
-}
-
-static int io_fsync(struct io_kiocb *req, bool force_nonblock)
-{
-	/* fsync always requires a blocking context */
-	if (force_nonblock) {
-		req->work.func = io_fsync_finish;
-		return -EAGAIN;
-	}
-	__io_fsync(req);
 	return 0;
 }
 
-static void __io_fallocate(struct io_kiocb *req)
-{
-	int ret;
-
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
-	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
-				req->sync.len);
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
-}
-
-static void io_fallocate_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_fallocate(req);
-	io_steal_work(req, workptr);
-}
-
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
@@ -3028,13 +2976,20 @@ static int io_fallocate_prep(struct io_kiocb *req,
 
 static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 {
+	int ret;
+
 	/* fallocate always requiring blocking context */
-	if (force_nonblock) {
-		req->work.func = io_fallocate_finish;
+	if (force_nonblock)
 		return -EAGAIN;
-	}
 
-	__io_fallocate(req);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
+				req->sync.len);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req(req);
 	return 0;
 }
 
@@ -3531,38 +3486,20 @@ static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static void __io_sync_file_range(struct io_kiocb *req)
+static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 {
 	int ret;
 
+	/* sync_file_range always requires a blocking context */
+	if (force_nonblock)
+		return -EAGAIN;
+
 	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
 				req->sync.flags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
-}
-
-
-static void io_sync_file_range_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_sync_file_range(req);
-	io_steal_work(req, workptr);
-}
-
-static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
-{
-	/* sync_file_range always requires a blocking context */
-	if (force_nonblock) {
-		req->work.func = io_sync_file_range_finish;
-		return -EAGAIN;
-	}
-
-	__io_sync_file_range(req);
 	return 0;
 }
 
@@ -3984,49 +3921,27 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int __io_accept(struct io_kiocb *req, bool force_nonblock)
+static int io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_accept *accept = &req->accept;
-	unsigned file_flags;
+	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	int ret;
 
-	file_flags = force_nonblock ? O_NONBLOCK : 0;
 	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
 					accept->addr_len, accept->flags,
 					accept->nofile);
 	if (ret == -EAGAIN && force_nonblock)
 		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail_links(req);
+	}
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
 	return 0;
 }
 
-static void io_accept_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	if (io_req_cancelled(req))
-		return;
-	__io_accept(req, false);
-	io_steal_work(req, workptr);
-}
-
-static int io_accept(struct io_kiocb *req, bool force_nonblock)
-{
-	int ret;
-
-	ret = __io_accept(req, force_nonblock);
-	if (ret == -EAGAIN && force_nonblock) {
-		req->work.func = io_accept_finish;
-		return -EAGAIN;
-	}
-	return 0;
-}
-
 static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = &req->connect;
-- 
2.24.0

