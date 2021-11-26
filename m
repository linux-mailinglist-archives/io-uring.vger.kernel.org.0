Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22D845F03B
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 15:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350882AbhKZPCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 10:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbhKZPAn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 10:00:43 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03722C06139B
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 06:38:26 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id a18so19111425wrn.6
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 06:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tjVbAJWfp0o9fqH7pXO04cL2VHMhiynHzV6LniKBYaY=;
        b=ZAkJa9igsAmBEBBtGOBHhAdNxyHzwIUeclugLcrvD8t7kpOY2Wb/Q8SO8m/kFmX5dr
         Ste4OiTu2wwl15/tQ4/N4mNixoy7gQfjNpIrL0EAPLLWfb4SQvucs976UycCjsClmuhS
         5FNDy1Z02nbJ+QNLIxs92fllWVJZH8d7GhxuOsURdvCaz607aBHbSgvUzFeugbNYKdaT
         mPCAjpoZlZYxDDzO7C5XGuT6cqklFwrNXsUE9ptIUIMP/W76kYfhP15Ldkbi212iKssH
         DDgBIUU67782YOCe8p3zPuKPp7akjGo2HbLNAXxymeg9typsaifHpBBPlChacLpa05qV
         MLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tjVbAJWfp0o9fqH7pXO04cL2VHMhiynHzV6LniKBYaY=;
        b=y2pYEBCEaPuB13YEON1xQO5zOOthVRs1VcIZ0o0kAy9x9ezsEF3k05EaItTdQ2p6+u
         J9eM0KbA5Sd4MbOmrERyoBOcvzAcirrEvSI2BXBK3vZfaZfM2UIWBlb7/z3K6XmGEZuM
         6eM0oVRvwAPnvZWUkpnCFDesFXXlX0SHTIzMaEXwzpBlV07dshH5rJBPE2lr6PMe4jzV
         UxrYXH77Vpw80I0RTehHEOE+aasU5y9+9acwmx+oJAV34GWMX0uLgz4TNqmXHbDbBceq
         DtHfxivI8QXI3ww9tcBx73cyuTOqBfaNRn9gnaALjvvVhl23VLcltxuOMxi+8PWKjAYB
         7Gew==
X-Gm-Message-State: AOAM5300O9Ap17fN5Wimo/xTjDcy/Qs5AYEffD+qmRqv4mNOo+IPVeNf
        r3pi+t/Z3efsAp7tC+UMYmfZHS2TSCY=
X-Google-Smtp-Source: ABdhPJwiwuniWGN9hmXODKK4RMk5Tgc4+7GPIGB9+pVKK/S7RI27gbhsKP6cpH/MqO7TF/FS5JOu3w==
X-Received: by 2002:a05:6000:15c8:: with SMTP id y8mr15035695wry.55.1637937504454;
        Fri, 26 Nov 2021 06:38:24 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id j134sm6588640wmj.3.2021.11.26.06.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 06:38:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: fail cancellation for EXITING tasks
Date:   Fri, 26 Nov 2021 14:38:14 +0000
Message-Id: <4c41c5f379c6941ad5a07cd48cb66ed62199cf7e.1637937097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1637937097.git.asml.silence@gmail.com>
References: <cover.1637937097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 1 PID: 20 at fs/io_uring.c:6269 io_try_cancel_userdata+0x3c5/0x640 fs/io_uring.c:6269
CPU: 1 PID: 20 Comm: kworker/1:0 Not tainted 5.16.0-rc1-syzkaller #0
Workqueue: events io_fallback_req_func
RIP: 0010:io_try_cancel_userdata+0x3c5/0x640 fs/io_uring.c:6269
Call Trace:
 <TASK>
 io_req_task_link_timeout+0x6b/0x1e0 fs/io_uring.c:6886
 io_fallback_req_func+0xf9/0x1ae fs/io_uring.c:1334
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

We need original task's context to do cancellations, so if it's dying
and the callback is executed in a fallback mode, fail the cancellation
attempt.

Reported-by: syzbot+ab0cfe96c2b3cd1c1153@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a4c508a1e0cf..7dd112d44adf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6882,10 +6882,11 @@ static inline struct file *io_file_get(struct io_ring_ctx *ctx,
 static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 {
 	struct io_kiocb *prev = req->timeout.prev;
-	int ret;
+	int ret = -ENOENT;
 
 	if (prev) {
-		ret = io_try_cancel_userdata(req, prev->user_data);
+		if (!(req->task->flags & PF_EXITING))
+			ret = io_try_cancel_userdata(req, prev->user_data);
 		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
 	} else {
-- 
2.34.0

