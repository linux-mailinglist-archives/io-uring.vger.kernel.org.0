Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7516730B000
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 20:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhBATE6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 14:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbhBATEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 14:04:37 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAFEC0613D6
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 11:03:50 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i9so240952wmq.1
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 11:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QOhRvNMYNuHWI3X6bh9LvJRZWWUYVpitHbzQEsD5Gj8=;
        b=RWrQNH/0UmlOn2E8CwfiFy+k9CMlMjNp7X5SJYwrGJUU36qFA5Ka3ltmTXQ6A/d5MX
         h4o/3MqoQ3cgslDyTg0pgpArz7T1L6VyErSsU7+u4oAmRWnIYjBjsFjx7Oq88b825oOr
         4+PEWfg6dny2QJ5c1MjBqoAxe1oxg1bBzQeFBvWi3p42yiW+aagvRAPuJG9TN8kNIfQi
         enV1de/RseQfJuKphqBKUyA3usK3J+T1jz2lcPCB2BDM0nIVWkl3xmlw2OIwFYqdny5a
         GYnCKlA6zL0pniGtrBHTlhC99/OdBkPs6+lgPmVECOXb7ZqVYmEHEMr5s5PDzG2fwWI9
         Vyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QOhRvNMYNuHWI3X6bh9LvJRZWWUYVpitHbzQEsD5Gj8=;
        b=c3sVJDk8AXYk9BON1OS3F3xhU97/BWySpyDtLnrqWkSAGg0JAZ+6Z0E2UC/9FSVQrF
         0tjA13+7C0eef5OjxoqC4TfyCACuQaLg0hlxYfwY6lElzWFguFaQgaT8XSjdMLGD/P6m
         JRqPTiWvCx+TjRsT6BnObe9THHEplfc08sW8s5UTCsJ1p1aSlmFJgM1VGL5OMdGnDBxA
         UBEctezR68p1EpUp7/ERTTujQ3Jo8P9Nz42tfTSVT81p7vBP6vBEhkwhIW1lsB7+lECc
         PjfjCXDgSdVYa0hAL+FXG3Q6XgEEl8fSqUggd+8bfM9a2tbCE2CHui8DTHV2eV4A6X5Q
         lKLA==
X-Gm-Message-State: AOAM530lsrm66d3+E5BxGKVrNYg4WWI2jdOmRz8uhNpaXwSzbf42LteS
        BYcBrA7Ly1biM555Mw3vGTk=
X-Google-Smtp-Source: ABdhPJzHmf/zCHsP25g3g/p74o7zxB5L89t4Rh2vV0TDCb8rr3VF6uf7QCcnB/XKjt3gYRqjVzACOA==
X-Received: by 2002:a1c:5454:: with SMTP id p20mr289394wmi.128.1612206229136;
        Mon, 01 Feb 2021 11:03:49 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h14sm182728wmq.45.2021.02.01.11.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:03:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/6] io_uring: inline io_req_drop_files()
Date:   Mon,  1 Feb 2021 18:59:53 +0000
Message-Id: <4dc556e9c33cb5804a818132986bc68cd3a35302.1612205712.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612205712.git.asml.silence@gmail.com>
References: <cover.1612205712.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->files now have same lifetime as all other iowq-work resources,
inline io_req_drop_files() for consistency. Moreover, since
REQ_F_INFLIGHT is no more files specific, the function name became
very confusing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bcd623512d17..0ee452d43817 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1036,7 +1036,6 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
-static void io_req_drop_files(struct io_kiocb *req);
 static void io_req_task_queue(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
@@ -1402,8 +1401,23 @@ static void io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
-	if (req->flags & REQ_F_INFLIGHT)
-		io_req_drop_files(req);
+	if (req->work.flags & IO_WQ_WORK_FILES) {
+		put_files_struct(req->work.identity->files);
+		put_nsproxy(req->work.identity->nsproxy);
+		req->work.flags &= ~IO_WQ_WORK_FILES;
+	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_uring_task *tctx = req->task->io_uring;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->inflight_lock, flags);
+		list_del(&req->inflight_entry);
+		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+		req->flags &= ~REQ_F_INFLIGHT;
+		if (atomic_read(&tctx->in_idle))
+			wake_up(&tctx->wait);
+	}
 
 	io_put_identity(req->task->io_uring, req);
 }
@@ -6164,25 +6178,6 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EIOCBQUEUED;
 }
 
-static void io_req_drop_files(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_task *tctx = req->task->io_uring;
-	unsigned long flags;
-
-	if (req->work.flags & IO_WQ_WORK_FILES) {
-		put_files_struct(req->work.identity->files);
-		put_nsproxy(req->work.identity->nsproxy);
-	}
-	spin_lock_irqsave(&ctx->inflight_lock, flags);
-	list_del(&req->inflight_entry);
-	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-	req->flags &= ~REQ_F_INFLIGHT;
-	req->work.flags &= ~IO_WQ_WORK_FILES;
-	if (atomic_read(&tctx->in_idle))
-		wake_up(&tctx->wait);
-}
-
 static void __io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
-- 
2.24.0

