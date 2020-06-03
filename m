Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69571ED2ED
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgFCPE5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 11:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgFCPE4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 11:04:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3790EC08C5C0;
        Wed,  3 Jun 2020 08:04:56 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l10so2725843wrr.10;
        Wed, 03 Jun 2020 08:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=krXLmzuyWCTdkRgl1P7N/SHG/Xof1z6wTAHRzF7zfSk=;
        b=pg5Mw5wk707KNib8CLOUj2pIdGTAwsAl5Kb4JvUmQSqYqzilMPoQ7XKinJcBzLuv7d
         KYpdM8jLiwVfJFJaLO9UP4TRT2Vl1ZFcwXsRO4ydoSL2D+3IbH5JeO/YX79vWJH1lCRU
         GS6tgNl4QA0D5Inn+ETuGFdNfrl8+8rxKZ0LhSO9tAh2ilLegN0fB9qNgYQCXQ4V8/Bv
         Z2grO6POWa+IxZXW7R7X6da31O8AyxUi6IO7U3YYS2YIvsINw/dloUO/XWd7i27cClO7
         ZSJbgbIDeYXcxsZcP3NTv5Retmuc/dniOX/BwfhdeR0DUDDAUUHFOxgljtDg9sbzL3Ya
         YO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=krXLmzuyWCTdkRgl1P7N/SHG/Xof1z6wTAHRzF7zfSk=;
        b=c9L76sFvWtE2UW14my6B+Q+0RwPUa/0GRMH+Ep225Wht2ouRCTPaWYgOQrCiKQEKNN
         f6Armno3b+/js91LAsXaOqq9iQA79Ep0Au5tfuHhmt0YcibzIHR8W/l/Xcg8qsbjkboj
         xbtBkGexy9WEeX8RfOBeh1z5Q8UJnXw8+dTynwpsSfpd5Ikk9G+DuW/nbm/b8AiQVnWH
         kBHj63EWhteuWq5tFUNWv++4RIzs/3NFIWx3v1jhQ6XkhwpD3rwlFCw6YXwsGQ/yacYc
         8ZFZQBAuQcPFWLDGFMz2FrSLSYulm1Pmcvti4gFMmqeicy9Kd/Z71/sf5qO+GbY7i1RU
         T+QQ==
X-Gm-Message-State: AOAM531ukxZtQpZm0nFy+xiPwkTMUIDX660Fv2lW9CeoF6IH4YNFEctY
        oH47zOaCqMHqUffXrcMvbvRLcumN
X-Google-Smtp-Source: ABdhPJz0uTW5nfvxgWsXTlVqhpUkZPuayqnS7/ps2XlEBAFFweJjkdqGMOB7E8/ZsbPx+V1WWLxT3w==
X-Received: by 2002:adf:f389:: with SMTP id m9mr29469044wro.195.1591196694903;
        Wed, 03 Jun 2020 08:04:54 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id f71sm3074808wmf.22.2020.06.03.08.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 08:04:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] io_uring: fix {SQ,IO}POLL with unsupported opcodes
Date:   Wed,  3 Jun 2020 18:03:22 +0300
Message-Id: <917e992a6efc417ee1d36afb29623f577634f907.1591196426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591196426.git.asml.silence@gmail.com>
References: <cover.1591196426.git.asml.silence@gmail.com>
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
index 732ec73ec3c0..fc55c44dcafe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2765,6 +2765,8 @@ static int __io_splice_prep(struct io_kiocb *req,
 
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	sp->file_in = NULL;
 	sp->len = READ_ONCE(sqe->len);
@@ -2965,6 +2967,8 @@ static int io_fallocate_prep(struct io_kiocb *req,
 {
 	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
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
@@ -3105,6 +3113,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
 		return -EINVAL;
 
@@ -3174,6 +3184,8 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
 
@@ -3262,6 +3274,8 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #if defined(CONFIG_EPOLL)
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->epoll.epfd = READ_ONCE(sqe->fd);
 	req->epoll.op = READ_ONCE(sqe->len);
@@ -3306,6 +3320,8 @@ static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	if (sqe->ioprio || sqe->buf_index || sqe->off)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 
 	req->madvise.addr = READ_ONCE(sqe->addr);
 	req->madvise.len = READ_ONCE(sqe->len);
@@ -3340,6 +3356,8 @@ static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (sqe->ioprio || sqe->buf_index || sqe->addr)
 		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
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

