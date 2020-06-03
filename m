Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450591ED0CF
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 15:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgFCNbC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 09:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgFCNa7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 09:30:59 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D541C08C5C0;
        Wed,  3 Jun 2020 06:30:59 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l26so1937392wme.3;
        Wed, 03 Jun 2020 06:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dRLpRROVEy+U8T7/N9418rePaCXqJx/ZLudBr4bXilA=;
        b=a3UUeGUnTGqPdjJ6trt16jXj+TcZNh3EMTWPcWkckzX2lGF7YUbmBAvNWZusMwn2Vb
         UGsJEd/sWHejb/xvGJlyRnmlRF0pOlZRTvEJ/gX+Fy0UjCPRKUO1Cetvsn//YspORPkI
         56IiNYIu8dsKxFSInfJb3HCpd+f7jdguyWcwwdbTS5lE1kRXcj6P+VFaIcxBOFJ7pJx5
         f3zAu7QIEWnUGEuKq0gSvZq1pqM15HHKK5nYqKeZsUftTwbgihAmO70Nlb3YIdokUkzX
         aGmHhsbtLnHrJD6964xztIjI23BN1xitYtT8HnKWI/pUOG0Cvjrx1euufLK7I6DBa1c9
         t3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRLpRROVEy+U8T7/N9418rePaCXqJx/ZLudBr4bXilA=;
        b=c0sklmYuQ2+0XsA42yT9/toJAu/QrBREdFtMwQ2B1aonIiIF8sp4bJpAXzcpSEBcw9
         vJmc5g2t8Il0IAWLi2ZaIr+ZHjRWk3Odrde5mc8kP16dEfIxNEoBaFEo2+GdC961vSgY
         ZjcDth4JGrGCxTVs84Wkgu7rJoSM6+okXTUa8LK6/sQl3OvovJxJfk3bmOxv+fHZDTo8
         /z8p6AnMl/2KOIgihgkZ7GTEVBm/FNuwnvCx/7K+rHG5p5XY4SgSuqgbmlCt2ZV6mveh
         NW345z+0sSgDdQM+o+GzDFiXpv2qLwMb+PpET59beiOcxQEL36yvS6v3J0dEGH2kwhHL
         ueuA==
X-Gm-Message-State: AOAM533spL5qTxkc60Zkd0KdKCr1bHSUbOdT12jSWBK2NOV4tM/YM7cQ
        cW3DtwN/Yqn+4FwgpAoLHV8jCVKR
X-Google-Smtp-Source: ABdhPJxU0hKsN2wgC2V51lL7k2+ASm2zcZdXsPupPqP0n0Uy9QLwiAcx07tJb7q1RULTucoSD+TcBw==
X-Received: by 2002:a05:600c:22c1:: with SMTP id 1mr9330618wmg.50.1591191058180;
        Wed, 03 Jun 2020 06:30:58 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id a1sm3189716wmd.28.2020.06.03.06.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 06:30:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] io_uring: fix {SQ,IO}POLL with unsupported opcodes
Date:   Wed,  3 Jun 2020 16:29:29 +0300
Message-Id: <6f967848a9f2fea3d26033721adf6531474a6e15.1591190471.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591190471.git.asml.silence@gmail.com>
References: <cover.1591190471.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_SETUP_IOPOLL is defined only for read/write, other opcodes should
be disallowed, otherwise it'll get an error as below. Also refuse
open/cloes with SQPOLL, as the polling thread wouldn't know which file
table to use.

RIP: 0010:io_iopoll_getevents+0x111/0x5a0
Call Trace:
 ? _raw_spin_unlock_irqrestore+0x24/0x40
 ? do_send_sig_info+0x64/0x90
 io_iopoll_reap_events.part.0+0x5e/0xa0
 io_ring_ctx_wait_and_kill+0x132/0x1c0
 io_uring_release+0x20/0x30
 __fput+0xcd/0x230
 ____fput+0xe/0x10
 task_work_run+0x67/0xa0
 do_exit+0x353/0xb10
 ? handle_mm_fault+0xd4/0x200
 ? syscall_trace_enter+0x18c/0x2c0
 do_group_exit+0x43/0xa0
 __x64_sys_exit_group+0x18/0x20
 do_syscall_64+0x60/0x1e0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 732ec73ec3c0..2463aaca3172 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2765,6 +2765,8 @@ static int __io_splice_prep(struct io_kiocb *req,
 
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	sp->file_in = NULL;
 	sp->len = READ_ONCE(sqe->len);
@@ -2965,6 +2967,8 @@ static int io_fallocate_prep(struct io_kiocb *req,
 {
 	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->addr);
@@ -2990,6 +2994,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	const char __user *fname;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3023,6 +3029,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3107,6 +3115,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 
 	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
 		return -EINVAL;
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
 	if (!tmp || tmp > USHRT_MAX)
@@ -3174,6 +3184,8 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
 
@@ -3262,6 +3274,8 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #if defined(CONFIG_EPOLL)
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->epoll.epfd = READ_ONCE(sqe->fd);
 	req->epoll.op = READ_ONCE(sqe->len);
@@ -3306,6 +3320,8 @@ static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	if (sqe->ioprio || sqe->buf_index || sqe->off)
 		return -EINVAL;
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->madvise.addr = READ_ONCE(sqe->addr);
 	req->madvise.len = READ_ONCE(sqe->len);
@@ -3340,6 +3356,8 @@ static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (sqe->ioprio || sqe->buf_index || sqe->addr)
 		return -EINVAL;
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->fadvise.offset = READ_ONCE(sqe->off);
 	req->fadvise.len = READ_ONCE(sqe->len);
@@ -3373,6 +3391,8 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3417,6 +3437,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
@@ -4906,6 +4928,8 @@ static int io_files_update_prep(struct io_kiocb *req,
 {
 	if (sqe->flags || sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->files_update.offset = READ_ONCE(sqe->off);
 	req->files_update.nr_args = READ_ONCE(sqe->len);
-- 
2.24.0

