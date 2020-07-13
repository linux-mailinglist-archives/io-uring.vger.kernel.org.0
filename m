Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC48821E189
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgGMUjT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGMUjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F00BC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:19 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g20so14960225edm.4
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IiCo3SXqpUMoBFJs1TnQvx2Tswu4de7IqqoYx+/WlOA=;
        b=LOVjkLBlMBc3bcebF4I2TqqoG/otkZFFMMbHwR4ChB/xtu5n2qk0Om96ppEeRAwiTO
         I+f9DKmPEX8PgRWwkvWU/4+fJMVZUuKQz+BZZthJrntlL/XM4vfh80GTAcL+I+5dc9RG
         6a/vHQ/takqHL2j2dgcYvO4wLkVV8gxqvF6tZTBiBI+VkEo+rKj2XvVuwYI/vT7vOmev
         mf5GfIMVKtzftAiyyUmRDSVlVlV7hR/0/x+il3W6m/2pb47VDkhf2YdMf9Jx9TBgyrgz
         wEodMwNyBD3vXE4Dcjh47FbvLk5ISIFiw3+KNtykq7rzZ37S/r2ZptUfNxQ+nYxCK4kt
         IaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IiCo3SXqpUMoBFJs1TnQvx2Tswu4de7IqqoYx+/WlOA=;
        b=QGBHqUh1yM/5Rfe8nM4miFU9EkARodR76YvLVzwRoaVJJk2sMrW5ABYPmfAuXgqwhJ
         Ik0QKZBDqO4ZW65+QJVK7a4uZ/h8XrRjqqElbgEQsHb9Q6f60NtunaPQJqo4DmjSVfof
         evOV5JsmBO1UAuS7fGr58fS4y/Hb5UZ3Mw62YM1EGC84ZPP0UmhwphNfM1k0gMVwOJqe
         3MT21uX4QUvu9rF/SfKnQzI8zO38yEssRWy5qzBqj49B2EfuYnK50RpXtPP6B59s/djs
         RTWGCwxKltuNYDdqcLDYmyUdM7wPUI+njI3hb+poY9z5o9XYkpVHTmN6u15UeUMxSOFS
         cpcg==
X-Gm-Message-State: AOAM5336ls3rRX+iSQ+gWAYcXQ6petVGbge+VnAhVCgFAoyZYc83GgmE
        Q0uwX2/WvgXMr+6KNWu8RfI=
X-Google-Smtp-Source: ABdhPJxjNnctgWowi90j8lKUgWSDcvo8OdF2wYpxHqej28I4jKMyNErXb3tP6PtODOWaK7kHuNj7Sw==
X-Received: by 2002:aa7:c909:: with SMTP id b9mr1146188edt.111.1594672757715;
        Mon, 13 Jul 2020 13:39:17 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/9] io_uring: share completion list w/ per-op space
Date:   Mon, 13 Jul 2020 23:37:08 +0300
Message-Id: <a315572342c11717bac4e3f580c8acf47a460d30.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling io_req_complete(req) means that the request is done, and there
nothing left but to clean it up. That also means that per-op data
after that should not be used, so we're free to reuse it in completion
path, e.g. to store overflow_list as done in this patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b9c0333d8c0..b60307a69599 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -487,6 +487,11 @@ struct io_statx {
 	struct statx __user		*buffer;
 };
 
+struct io_completion {
+	struct file			*file;
+	struct list_head		list;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -621,6 +626,8 @@ struct io_kiocb {
 		struct io_splice	splice;
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
+		/* use only after cleaning per-op data, see io_clean_op() */
+		struct io_completion	compl;
 	};
 
 	struct io_async_ctx		*io;
@@ -895,7 +902,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_grab_files(struct io_kiocb *req);
 static void io_complete_rw_common(struct kiocb *kiocb, long res,
 				  struct io_comp_state *cs);
-static void io_cleanup_req(struct io_kiocb *req);
+static void __io_clean_op(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req,
@@ -935,6 +942,12 @@ static void io_get_req_task(struct io_kiocb *req)
 	req->flags |= REQ_F_TASK_PINNED;
 }
 
+static inline void io_clean_op(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		__io_clean_op(req);
+}
+
 /* not idempotent -- it doesn't clear REQ_F_TASK_PINNED */
 static void __io_put_req_task(struct io_kiocb *req)
 {
@@ -1412,8 +1425,8 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 	while (!list_empty(&cs->list)) {
 		struct io_kiocb *req;
 
-		req = list_first_entry(&cs->list, struct io_kiocb, list);
-		list_del(&req->list);
+		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
+		list_del(&req->compl.list);
 		__io_cqring_fill_event(req, req->result, req->cflags);
 		if (!(req->flags & REQ_F_LINK_HEAD)) {
 			req->flags |= REQ_F_COMP_LOCKED;
@@ -1438,9 +1451,10 @@ static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
 		io_cqring_add_event(req, res, cflags);
 		io_put_req(req);
 	} else {
+		io_clean_op(req);
 		req->result = res;
 		req->cflags = cflags;
-		list_add_tail(&req->list, &cs->list);
+		list_add_tail(&req->compl.list, &cs->list);
 		if (++cs->nr >= 32)
 			io_submit_flush_completions(cs);
 	}
@@ -1514,8 +1528,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 
 static void io_dismantle_req(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		io_cleanup_req(req);
+	io_clean_op(req);
 
 	if (req->io)
 		kfree(req->io);
@@ -5380,7 +5393,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EIOCBQUEUED;
 }
 
-static void io_cleanup_req(struct io_kiocb *req)
+static void __io_clean_op(struct io_kiocb *req)
 {
 	struct io_async_ctx *io = req->io;
 
-- 
2.24.0

