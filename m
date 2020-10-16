Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781A0290919
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410535AbgJPQCj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410466AbgJPQCj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E326AC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y14so1731116pfp.13
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0/3OjceFQvDrtrEvZxO0Kp9nsYQxCs33ugsAC0C+ZaY=;
        b=H/5YFGyZXwO8vNxt1lh+ryjnz8VDQyXDogCjwXhFtSFvngl1XRUXu649l4ZsiXJFc/
         5FJ22gn0a9CVn4Xpur3WmgxlfEBEsZmxhEqoUTrKLEIsAmuDaVQ9zNj+OeXjhaKDfyg0
         AR5v+obSkNIiq1lOH2c7NoB5WUd4l7HKEGdZIJHMRCcAgW4HHM1gLvOXsqG+fEV2nGTt
         ooeRv2JAWOR+o9wtDge9Do5/8LiOtDgRlZHhwHRKmIkYyvpP+y4cmtNMPn9Q/p9EmcNZ
         xbMDnVKf1Fzz4NzthuyuKSUbzu534XaN2dfD3Ty4SKNpzpPRN/v6l73BXVLLhxjDOvvW
         2uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0/3OjceFQvDrtrEvZxO0Kp9nsYQxCs33ugsAC0C+ZaY=;
        b=lkOskDz/q5wip/rK1N4LOVtFADyJLsBzbNntdLh5ZMiQwzZOqvF0briTBSWwMZCRci
         HE/P+D5eYS8Sl1Ukf4S+C7ru+EguBaDeMsKSyI1QSrxHigImKhkR7HVYVdQmv/lvkFdb
         ypoawwmdqIeWaVQxLoot189/guvzEK1OuY4K/hnEW+2/NX9yPycG1+Bn8C0/kGYVC96e
         mOjUM90vqCkJBkHlfZVHSQokR+Vm1o8juh5dWQ6fqi+XDoiEw9T7QWI3iZVU9bQ373EM
         b0HlWBEAUdURR5cWmFlnMNPcVmES5PacVy0O5wLLvFYCQZlctYob9Tvr8DtWrFsHr/4S
         EXbA==
X-Gm-Message-State: AOAM533Lp9U6x13kF1tg8OUEBMZeCeX3MlHiQ8jTvPgVE0LVR0arIsjL
        KZX+43n/ttMwwI7YcXsRpzIEVoNJXOE4LZ/H
X-Google-Smtp-Source: ABdhPJxBN9R+94VSbui2FNlb5R1VeJivAFxxUhtRv6ZD1jm11WjY256nLgER+NyxYHoEMzV8LXK/+w==
X-Received: by 2002:aa7:875a:0:b029:155:7c08:f2ed with SMTP id g26-20020aa7875a0000b02901557c08f2edmr4582206pfo.52.1602864157429;
        Fri, 16 Oct 2020 09:02:37 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/18] io_uring: dig out COMP_LOCK from deep call chain
Date:   Fri, 16 Oct 2020 10:02:13 -0600
Message-Id: <20201016160224.1575329-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

io_req_clean_work() checks REQ_F_COMP_LOCK to pass this two layers up.
Move the check up into __io_free_req(), so at least it doesn't looks so
ugly and would facilitate further changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 728df7c6324c..b76aecb3443d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1181,14 +1181,10 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-/*
- * Returns true if we need to defer file table putting. This can only happen
- * from the error path with REQ_F_COMP_LOCKED set.
- */
-static bool io_req_clean_work(struct io_kiocb *req)
+static void io_req_clean_work(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
-		return false;
+		return;
 
 	req->flags &= ~REQ_F_WORK_INITIALIZED;
 
@@ -1207,9 +1203,6 @@ static bool io_req_clean_work(struct io_kiocb *req)
 	if (req->work.fs) {
 		struct fs_struct *fs = req->work.fs;
 
-		if (req->flags & REQ_F_COMP_LOCKED)
-			return true;
-
 		spin_lock(&req->work.fs->lock);
 		if (--fs->users)
 			fs = NULL;
@@ -1218,8 +1211,6 @@ static bool io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.fs = NULL;
 	}
-
-	return false;
 }
 
 static void io_prep_async_work(struct io_kiocb *req)
@@ -1699,7 +1690,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 		fput(file);
 }
 
-static bool io_dismantle_req(struct io_kiocb *req)
+static void io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
@@ -1708,7 +1699,7 @@ static bool io_dismantle_req(struct io_kiocb *req)
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 
-	return io_req_clean_work(req);
+	io_req_clean_work(req);
 }
 
 static void __io_free_req_finish(struct io_kiocb *req)
@@ -1731,21 +1722,15 @@ static void __io_free_req_finish(struct io_kiocb *req)
 static void io_req_task_file_table_put(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-	struct fs_struct *fs = req->work.fs;
-
-	spin_lock(&req->work.fs->lock);
-	if (--fs->users)
-		fs = NULL;
-	spin_unlock(&req->work.fs->lock);
-	if (fs)
-		free_fs_struct(fs);
-	req->work.fs = NULL;
+
+	io_dismantle_req(req);
 	__io_free_req_finish(req);
 }
 
 static void __io_free_req(struct io_kiocb *req)
 {
-	if (!io_dismantle_req(req)) {
+	if (!(req->flags & REQ_F_COMP_LOCKED)) {
+		io_dismantle_req(req);
 		__io_free_req_finish(req);
 	} else {
 		int ret;
@@ -2057,7 +2042,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	}
 	rb->task_refs++;
 
-	WARN_ON_ONCE(io_dismantle_req(req));
+	io_dismantle_req(req);
 	rb->reqs[rb->to_free++] = req;
 	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
 		__io_req_free_batch_flush(req->ctx, rb);
-- 
2.28.0

