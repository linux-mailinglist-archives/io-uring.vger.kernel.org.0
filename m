Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6C11731E1
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 08:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgB1Hhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 02:37:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44619 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgB1Hhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 02:37:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id m16so1747478wrx.11
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 23:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kpwIw776beNUSr1nhhOVajK3TusTM7fF1ahjRCYDFKo=;
        b=A+E+I7Rp0OFlBMDuaODb6I+ZMs31N2qBcZGvPpc49ur9K5VBVtJCssxIHnCN1ImRR+
         OoSMUVa3KBPS5SITqizDOuvYSfC0PLaGuGsuvH4WmVRQKiKQtgN/qPcSHbqDohObPByS
         funUdCIYhn1sapcjyJAT/f8v+NWh5bLeLuOWkHlc9QzjTvUUXqyiOgYLafcy/+euwO0m
         VPwMvIdEM6Bj5eClJA/gWm9ptsn+L6a9fG8KnQ9A4Fc8u539XSd5Jh9e6THvWXNdZULx
         NuzA/a0fFRJ44gnWotGjI0IAa8Z1WlPIOKzm1fbSpOFwn4IjxEV08SE5i6j+vzlxvKhY
         zybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpwIw776beNUSr1nhhOVajK3TusTM7fF1ahjRCYDFKo=;
        b=GktAePcFNOmFdyX7sSuP0n5odi7jYJtIES1ZFTAQ+ArIjlwS6lXn/oyFwTVAzLkqeM
         qe6ChOzz2MGU55LMttG11InJmq/tBCeuTD9VO2gK3QS5lxH4+D2Qbtm7TV/j5a9Tj42P
         8IHHH1bbGpibdYA+FYarVQs2kQFYhmCCGYDtQunw8yaqcHXgO5cxxQFxorwCHXAX7RNd
         14hZu/gI9wBWvMCnpWteBHUvlh8l9om3ZlWCIuZJn/dMFddbKPBNen+jVTV37+LyvLSN
         RqddwCry8hp9cejbMJ+Xe+5ethx8JvOl6l7g0Iv+sdXzniBRg79TXlmfH0ePFFZCSKNx
         2ZeQ==
X-Gm-Message-State: APjAAAXJ4RGolNsyVqrEpQH8X8GTXGCOHxAvNI/uXsQKRHIZsrHmt2l7
        JWwZOFENUfV/TUHBVZqkt9sO2KGe
X-Google-Smtp-Source: APXvYqxPhRXozdinv92i9iuUagSipOIFahx87+kvt+0x9mS5dMXFv+xGFqLZCdwVx7T1QN1SS7DKeQ==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr3626725wru.220.1582875460097;
        Thu, 27 Feb 2020 23:37:40 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id h2sm11369425wrt.45.2020.02.27.23.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 23:37:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: remove IO_WQ_WORK_CB
Date:   Fri, 28 Feb 2020 10:36:38 +0300
Message-Id: <177e3005d8ae1548eda877e9c942a613aa08b32c.1582874853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582874853.git.asml.silence@gmail.com>
References: <cover.1582874853.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO_WQ_WORK_CB is used only for linked timeouts, which will be armed
before the work setup (i.e. mm, override creds, etc). The setup
shouldn't take long, so it's ok to arm it a bit later and get rid
of IO_WQ_WORK_CB.

Make io-wq call work->func() only once, callbacks will handle the rest.
i.e. the linked timeout handler will do the actual issue. And as a
bonus, it removes an extra indirect call.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 3 ---
 fs/io-wq.h    | 1 -
 fs/io_uring.c | 3 +--
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 72c73c7b7f28..1ceb12c58ae6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -479,9 +479,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 		worker->cur_work = work;
 		spin_unlock_irq(&worker->lock);
 
-		if (work->flags & IO_WQ_WORK_CB)
-			work->func(&work);
-
 		if (work->files && current->files != work->files) {
 			task_lock(current);
 			current->files = work->files;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 72c860f477d2..001194aef6ae 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -8,7 +8,6 @@ enum {
 	IO_WQ_WORK_HASHED	= 4,
 	IO_WQ_WORK_UNBOUND	= 32,
 	IO_WQ_WORK_INTERNAL	= 64,
-	IO_WQ_WORK_CB		= 128,
 	IO_WQ_WORK_NO_CANCEL	= 256,
 	IO_WQ_WORK_CONCURRENT	= 512,
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index a32a195407ac..f5fbde552be7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2554,7 +2554,7 @@ static void io_link_work_cb(struct io_wq_work **workptr)
 	struct io_kiocb *link = work->data;
 
 	io_queue_linked_timeout(link);
-	work->func = io_wq_submit_work;
+	io_wq_submit_work(workptr);
 }
 
 static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
@@ -2564,7 +2564,6 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 	io_prep_next_work(nxt, &link);
 	*workptr = &nxt->work;
 	if (link) {
-		nxt->work.flags |= IO_WQ_WORK_CB;
 		nxt->work.func = io_link_work_cb;
 		nxt->work.data = link;
 	}
-- 
2.24.0

