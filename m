Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C0412D35D
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 19:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfL3SZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Dec 2019 13:25:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44731 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727571AbfL3SZe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Dec 2019 13:25:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so33427762wrm.11
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2019 10:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9/+2aMpBI6117zNW1j6ca4CX7c+Z9RvFJ0f7u6+hzmA=;
        b=FWU8SepZneQb/b8xLA+Ry4ti+zA747ZqbgBwLCp9WYTJcM0fi4yU58yvFkx6W72dzb
         m1LJffQL1S8Icel5TGhipRAE0yh6NMw6nfYoqd0mA1OzkCxdDK1rq1px6ScNWlDZwLm1
         +evvwBtRrLlMAXbGDLfmEVfajMXR6Kp8wG1uBnXVzDP0/mHmGgQxMF4EG45YuchxxdAG
         SPPxAjdFA2455fjOw6lWMT/ezGB3QM9gYvunBaP5fK+bEzx5RKDIQirBGXypsPrJv7Lx
         A/302nHzFSLnrbjvXyOPzOH1JC7wSR/ST99uZTDYK02QRnE8W0pRgaWGKWim0BlDkax5
         OCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/+2aMpBI6117zNW1j6ca4CX7c+Z9RvFJ0f7u6+hzmA=;
        b=CYLpAO7UmBTAOx9bzHIV4xInM53DC1dWibihPxh5d0lJ4jjhlJFTS7ITwVY97vUU0/
         ONIBvK/3jrFA/tHXAoCteg5Wptikv91bttcdvzCtl0dtbI2lFkcgJDWYnWtoBBqcZh2b
         su5j1Gn67/QQzvU+SAl+Ta2d80GyUg4edHE0VgB0JjMje50ShAVuRSHR0PcdE4vKbBpi
         0NZUik/rylHreG1CGuKY3defT/gu8KBPGNQpDAffBWUy/jPGhMlbD3BZ6HznOWFd1Ux4
         QKcXe3LVeIyeRU7WVcdELNiuXYRcmFUUaHUqQcf/ekprWdl8rdGNXqicc67iZ/KzO+HI
         TlxQ==
X-Gm-Message-State: APjAAAVQk7mT0X2ojzRCmwD3VXZKs5xnfbc5AMZ0tSfmAdiqC5T+pq6e
        syxoSJSZiLqQf2VBSPHxh+rwLwX7
X-Google-Smtp-Source: APXvYqyO75qBPVNOCztHQKapCpOKjW4JKsDtE1I/4C663q7l4EytOKLOi/SXl21kKetghIbaJLhJBA==
X-Received: by 2002:adf:ea8a:: with SMTP id s10mr66749142wrm.278.1577730332224;
        Mon, 30 Dec 2019 10:25:32 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id u24sm231590wml.10.2019.12.30.10.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:25:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: clamp to_submit in io_submit_sqes()
Date:   Mon, 30 Dec 2019 21:24:44 +0300
Message-Id: <b33e0a125497ddfe84310797ad6ccfa2f06b9de6.1577729827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1577729827.git.asml.silence@gmail.com>
References: <cover.1577729827.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_submit_sqes() to clamp @to_submit itself. It removes duplicated
code and prepares for following changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ee860cfad780..4105c0e591c7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4582,6 +4582,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			return -EBUSY;
 	}
 
+	nr = min(nr, ctx->sq_entries);
+
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 
@@ -4756,7 +4758,6 @@ static int io_sq_thread(void *data)
 			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
 		}
 
-		to_submit = min(to_submit, ctx->sq_entries);
 		mutex_lock(&ctx->uring_lock);
 		ret = io_submit_sqes(ctx, to_submit, NULL, -1, &cur_mm, true);
 		mutex_unlock(&ctx->uring_lock);
@@ -6094,7 +6095,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	} else if (to_submit) {
 		struct mm_struct *cur_mm;
 
-		to_submit = min(to_submit, ctx->sq_entries);
 		mutex_lock(&ctx->uring_lock);
 		/* already have mm, so io_submit_sqes() won't try to grab it */
 		cur_mm = ctx->sqo_mm;
-- 
2.24.0

