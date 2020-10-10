Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A13E28A3EF
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389396AbgJJWzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731222AbgJJTEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:04:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9372BC08EADF
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:16 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s9so1608762wro.8
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YHd59vzjs6FRZr1Hpc7mayRBlxhNE6Vp82i02UAEHmU=;
        b=UZ/+xBH3paYQzGN41AM6INsOn6ojSPFl7Ohlxvnj4W4Tqa5OTXkynYRJ8WYKoiIg5+
         54Zlv7/GuMSEAer0wxwafI5jdGejKvv3DXtOXKf1y1cMrKBo1IiBLAI5/9LzDaGZbrxd
         q05ut/A2MgWLU59nmPzfv+g42XkwhKr0pRFlQEowIec+f+gPorZETQ2IdYLWhKeq0XRG
         Sv1YnE9s9p9lzA8SWMuptKbQ63OfC4sFgE6b1jhVvh2sohz8/DqgZ+wzhBIg0woL2yt+
         WC2JTxt2YmvRyeHHmdKIKXcWXlEZrP1Rqy3th6+bxzAEq4vgf34202DZT0bVHXYzxIqM
         Ficw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHd59vzjs6FRZr1Hpc7mayRBlxhNE6Vp82i02UAEHmU=;
        b=DY5eUehFcRErQZyRWX419GtPO5S0ZGWVm+b0TxwAJ8AVyrdCKjGR0YYyPhop4emUcZ
         vJ0pf3iAdvwZV6AnCU3RrQymkWblq+Qp2lF29ZSyLLiByHRyupI5xaXHUongz/9KuXK/
         tciPi5rLhLDC/Df0Fl0WwwpmgHuWCnd2rKG/2ga4VCILONVPy758uDFnNlH3TxqA0b0n
         eyrEXLqkRGV/L6vYUd09AU6iThKyo7yG6rhd4P1awQFo4A1BZTm/av1f5024acXsHNKi
         9zWHzGOhS4U89ek9K13rLuvmsibYKhof5ZI54svmHClQKjpEJZNKt6yuEwutTg+KxOq3
         Bi0w==
X-Gm-Message-State: AOAM531bp7W1aROoWpyK+q/fsEEMZ111oeQ6ys2MZLv/ojPr/fi1J2m7
        NuHt3P8yWmNuT+/uMZL27NQ=
X-Google-Smtp-Source: ABdhPJwcNXRpsXURgXs5jEbeI8E8Wo0Ni1i8G5Wyvelc32FNcBXOsestobwvfOzuUuDm+m3WMxr6Ng==
X-Received: by 2002:a05:6000:ce:: with SMTP id q14mr1736144wrx.199.1602351435264;
        Sat, 10 Oct 2020 10:37:15 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/12] io_uring: simplify io_file_get()
Date:   Sat, 10 Oct 2020 18:34:08 +0100
Message-Id: <6f17d37c23e7e4975ad17109f48c57018328937d.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep ->needs_file_no_error check out of io_file_get(), and let callers
handle it. It makes it more straightforward. Also, as the only error it
can hand back -EBADF, make it return a file or NULL.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39c37cef9ce0..ffdaea55e820 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -968,8 +968,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
 static void __io_clean_op(struct io_kiocb *req);
-static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
-		       int fd, struct file **out_file, bool fixed);
+static struct file *io_file_get(struct io_submit_state *state,
+				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
 static void io_file_put_work(struct work_struct *work);
 
@@ -3486,7 +3486,6 @@ static int __io_splice_prep(struct io_kiocb *req,
 {
 	struct io_splice* sp = &req->splice;
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
-	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3498,10 +3497,10 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 
-	ret = io_file_get(NULL, req, READ_ONCE(sqe->splice_fd_in), &sp->file_in,
-			  (sp->flags & SPLICE_F_FD_IN_FIXED));
-	if (ret)
-		return ret;
+	sp->file_in = io_file_get(NULL, req, READ_ONCE(sqe->splice_fd_in),
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!sp->file_in)
+		return -EBADF;
 	req->flags |= REQ_F_NEED_CLEANUP;
 
 	if (!S_ISREG(file_inode(sp->file_in)->i_mode)) {
@@ -5980,15 +5979,15 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	return table->files[index & IORING_FILE_TABLE_MASK];
 }
 
-static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
-			int fd, struct file **out_file, bool fixed)
+static struct file *io_file_get(struct io_submit_state *state,
+				struct io_kiocb *req, int fd, bool fixed)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file;
 
 	if (fixed) {
 		if (unlikely((unsigned int)fd >= ctx->nr_user_files))
-			return -EBADF;
+			return NULL;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file = io_file_from_index(ctx, fd);
 		if (file) {
@@ -6000,11 +5999,7 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		file = __io_file_get(state, fd);
 	}
 
-	if (file || io_op_defs[req->opcode].needs_file_no_error) {
-		*out_file = file;
-		return 0;
-	}
-	return -EBADF;
+	return file;
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
@@ -6016,7 +6011,10 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	if (unlikely(!fixed && io_async_submit(req->ctx)))
 		return -EBADF;
 
-	return io_file_get(state, req, fd, &req->file, fixed);
+	req->file = io_file_get(state, req, fd, fixed);
+	if (req->file || io_op_defs[req->opcode].needs_file_no_error)
+		return 0;
+	return -EBADF;
 }
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
-- 
2.24.0

