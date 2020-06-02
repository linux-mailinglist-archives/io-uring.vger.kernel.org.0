Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7301EBBC1
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgFBMff (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 08:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgFBMfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 08:35:32 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A44C08C5C0;
        Tue,  2 Jun 2020 05:35:31 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q25so2970160wmj.0;
        Tue, 02 Jun 2020 05:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=llzfaOtjtxotM2PdMXaLFeIV9ii4UvCM9qWQuLi/X6s=;
        b=hyOwp+Ai4LWZB8TCt2mfFwhM3dCVhBttcuAAAHwioJs5bvRFwpznVtz5QXgu1zxMwR
         hxCjcjuWtvJ0KGMtpr3+egt4vcjC0pwCdU9zMs3g45gHNsy1HAW7BJIOfd2lzAPS/PqO
         +Du2vS1ywWIi5KR3XSd8wsXbzjg9f7GXixRdWYW39e96rLC7B0WsGtd+fC/CeGef+mHz
         XgohHBpZwPh37UydsH40Zn1iFJ/vo+BI2ZYk5lSqEwi094cUCgB665l+/Z8bZq9uyqnB
         pbpvwLlHCtZsPMzjcT4MKn/fqoXVLPshgyH6IJIvudpqxGhV6gwuRYfYt+3SRihSaqqj
         9pBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=llzfaOtjtxotM2PdMXaLFeIV9ii4UvCM9qWQuLi/X6s=;
        b=KZBVwhUj+vylOHz4FvkBYt6FV2kzHEx5jPqV2Lop8teKAulHtb1L/eaFAt+ugWCxtG
         ChFoQTuiuijNtypnuYONF0QSR/10uSPVys9iU7ElF7zYG+OvE1HY185ivX5HlCecFE1x
         CXlXPpKUaJBUcsGX3uOWEKNMIjbJAIQEWM/hFrDgcKXlWnmXEHpU2illty500y4Zsi5O
         pmkDMWuUk1URrSu5SYNoDFyVKIa+UJLU65s6oLDfgAh095nVx6jvGT5ghIOc3qeK4LA3
         vlHcgEMc0JOqWUpdIDDq3S5da3bMnh2isi93fnBdkZGWMfcVYCaRf572AoSzJgkx3tM0
         IrXA==
X-Gm-Message-State: AOAM531tv1ITcEwQamn4GUyThgfhwCThg8g7XT0qby4zh4xG1nXa8ZMR
        q9RWPxsEf0iI+OG/sdv3O/o=
X-Google-Smtp-Source: ABdhPJwN88dWWlhtGhu2sYUQ95AcNC6E4LYG7kI2bZYSZ8Qs8hglQIe3nSCEtHwWIRQnK/OARuCExg==
X-Received: by 2002:a7b:c642:: with SMTP id q2mr3890931wmk.93.1591101329802;
        Tue, 02 Jun 2020 05:35:29 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id z22sm3347711wmf.9.2020.06.02.05.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 05:35:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io_uring: fix open/close/statx with {SQ,IO}POLL
Date:   Tue,  2 Jun 2020 15:34:01 +0300
Message-Id: <aacbeec9c7ed21971119aec3669dff7f707bccb2.1591100205.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591100205.git.asml.silence@gmail.com>
References: <cover.1591100205.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Trying to use them with IORING_SETUP_IOPOLL:

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

Also SQPOLL thread can't know which file table to use with
open/close. Disallow all these cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 732ec73ec3c0..7208f91e9e77 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2990,6 +2990,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	const char __user *fname;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3023,6 +3025,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3373,6 +3377,8 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -3417,6 +3423,8 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
-- 
2.24.0

