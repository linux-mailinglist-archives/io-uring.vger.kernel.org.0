Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4D178279
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 20:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgCCSeU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 13:34:20 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54999 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgCCSeU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 13:34:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id i9so3041706wml.4
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 10:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LiVaYMYbUqVkP59cyO56jsLqHdgbJcbPk8cCf+c5iQk=;
        b=DFPTaK2GsI0pLTzoL7v2XoYTglmqZqYi1yhHDZ2OdxmdmAhpiZGyLVrtLH1kj8UTwk
         nYwOjTFl81veZMdryUbXZg+Rc/IDEhExdmGYJ14Mvrnvln7XOi/0FlRiZKxi9MjiDiRv
         3BWO63zhAOOJVEcA27maWUG2nW1umrYXat+Wg77p+xLZexyl8QFPK4PWu22Y+Hh8m0ph
         P7vmbFip7DsxpGLBisKUk1m43diSTISWLiOW/jYprTxBY5otdtFHZL1O840VMwvMgUQq
         mt1YZmIg6ujiPfPDO4brGJQqPIf+aMh1D3sCx1nLGP738L5fJVg0vjP3Vp2DuDQnvnep
         +Aag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LiVaYMYbUqVkP59cyO56jsLqHdgbJcbPk8cCf+c5iQk=;
        b=gR4G1PEPmqMe5+5ZepTwt/r+IuV4RYxwkw+xy/nRUBIBaffUGow0GCfV8X8Hcc2UqO
         UQcwkAddkvQlSlDya1kkgiXtTMnTDFxswHvbUShh5bxqjsvqbhdPOJVlAKx1juYogLfu
         mfGt/KlVEzkCBHH3dFWcizS6IEaqw4K78Yzv7WlvLG0rsfL3IFXJrtL//0faMOz3Tojf
         SnIiJRt/Efw9+fPusVkfDLGc/6d8bhHwwWtTy4eBM/tNNSgehM3d8Evc3HFrrQe39YFS
         XAVb2PpChKO7zT1Pl7FHWz8nif6gVv5v/RlrhkrRgSHztW8IWXtp04PL0DAp9mJh1meV
         J+Lw==
X-Gm-Message-State: ANhLgQ1ajxmTR5yvSLa11Ah6CeSBRo0+52AiyOc0rEaAlYQ0qjGUWZoU
        vv41kiSNIeUElZiXlk1ex2t86cYQ
X-Google-Smtp-Source: ADFU+vtZ9bYVWqMOn2LmfDgMwDVvu/NfjytF42xQetTAdmTZ6Mb5PP2aogZDcNJkorau6v/wKaZbrg==
X-Received: by 2002:a05:600c:205:: with SMTP id 5mr5257384wmi.157.1583260457219;
        Tue, 03 Mar 2020 10:34:17 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f3sm4548191wrs.26.2020.03.03.10.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 10:34:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 1/3] io_uring: make submission ref putting consistent
Date:   Tue,  3 Mar 2020 21:33:11 +0300
Message-Id: <cacd5ebe32f0ba8771362c1d2f91e5bbc25f6f9b.1583258348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583258348.git.asml.silence@gmail.com>
References: <cover.1583258348.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The rule is simple, any async handler gets a submission ref and should
put it at the end. Make them all follow it, and so more consistent.

This is a preparation patch, and as io_wq_assign_next() currently won't
ever work, this doesn't care to use io_put_req_find_next() instead of
io_put_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff6cc05b86c7..ad8046a9bc0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2550,7 +2550,7 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	if (req->work.flags & IO_WQ_WORK_CANCEL) {
 		req_set_fail_links(req);
 		io_cqring_add_event(req, -ECANCELED);
-		io_put_req(req);
+		io_double_put_req(req);
 		return true;
 	}
 
@@ -2600,6 +2600,7 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_fsync(req, &nxt);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2609,7 +2610,6 @@ static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 {
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_fsync_finish;
 		return -EAGAIN;
 	}
@@ -2621,9 +2621,6 @@ static void __io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt)
 {
 	int ret;
 
-	if (io_req_cancelled(req))
-		return;
-
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
 	if (ret < 0)
@@ -2637,7 +2634,10 @@ static void io_fallocate_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
+	if (io_req_cancelled(req))
+		return;
 	__io_fallocate(req, &nxt);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -2659,7 +2659,6 @@ static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
 {
 	/* fallocate always requiring blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_fallocate_finish;
 		return -EAGAIN;
 	}
@@ -3015,6 +3014,7 @@ static void io_close_finish(struct io_wq_work **workptr)
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req, &nxt);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -3038,6 +3038,8 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 		 * the file again and cause a double CQE entry for this request
 		 */
 		io_queue_async_work(req);
+		/* submission ref will be dropped, take it for async */
+		refcount_inc_not_zero(&req->refs);
 		return 0;
 	}
 
@@ -3088,6 +3090,7 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 	__io_sync_file_range(req, &nxt);
+	io_put_req(req); /* put submission ref */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -3097,7 +3100,6 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 {
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
-		io_put_req(req);
 		req->work.func = io_sync_file_range_finish;
 		return -EAGAIN;
 	}
@@ -3464,11 +3466,10 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
-	io_put_req(req);
-
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, &nxt, false);
+	io_put_req(req); /* drop submission reference */
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
@@ -4733,17 +4734,14 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		} while (1);
 	}
 
-	/* drop submission reference */
-	io_put_req(req);
-
 	if (ret) {
 		req_set_fail_links(req);
 		io_cqring_add_event(req, ret);
 		io_put_req(req);
 	}
 
-	/* if a dependent link is ready, pass it back */
-	if (!ret && nxt)
+	io_put_req(req); /* drop submission reference */
+	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
 
-- 
2.24.0

