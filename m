Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA753159A28
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731723AbgBKUCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:02:55 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34419 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731721AbgBKUCx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:02:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so14094587wrr.1;
        Tue, 11 Feb 2020 12:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3SI9u72fo5cJ0TIBN+wvbW4gQlALYBAazjp3lqhu/Z8=;
        b=oUNP5yoJ0X4qhyAS4LHN5XVijCAq4jDufVNMA02ogdKvzgcm7KUIRnGEUi9qS38z1t
         23N84o+4+/lsymJeOhX5YWV6Eil01GT1SXgDsMFzy9YFzFd0MYYe/3kHmZVV4CDw8ZZz
         jSxS8dEOk+94Bp5A4mER3JziUaBPQi7uOGTvgFVB8XusP3OWVsV3e6O8gYa4DW0l/+jR
         Yz16V2N4Ja4kwrp/zkQmmSSAr5JYDS0FD8onJSOgdnoBYD/+mdBKwlsTBSQbCXj2r3K2
         lVbyc1cUbajLl5Q0avHb1AUgBELogRmBQilbrcECW6Dqk4523YsbVlCGRTvRl1lmwy39
         hc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3SI9u72fo5cJ0TIBN+wvbW4gQlALYBAazjp3lqhu/Z8=;
        b=HCdW4Ggx5yzgZoT5b8ltd/8tVUUZp61pKZl8zIft9eYCyas7GmJoBnFOriIPpyHCgN
         Tw9U7Twg+rCmWhny95jncBS/zGr3Ujm9EVBfimEqF4PW8K7b/5ToKqNhaQ60mfyE8U95
         k1spI2uBEH3DP2t1GcnwtTwPQQF1NDAWJPFd558v6y81J5PMrJ0bLLIpby29QlC2B/K9
         BDpctBvOtaFouWmuq4xmHqtNXVIjBO8Op4SqXvq8MtesSVZQ3ZPuAnDAgAFYC3asNzn4
         nLrdSIlTHpVqTjVA0Lj/avTWcSrsQQ/jX63GuRh88R0gsw87IeOcwWokW7NBuCWT+2fx
         EkHA==
X-Gm-Message-State: APjAAAXLzxG3UMy72gA6SDtJTtDYcqa4Ak7K/xcI3K6OVJ2993WnUfpO
        CAmALaQh++faCNoAtp8dmQu9Sg9S
X-Google-Smtp-Source: APXvYqzriqDUy583pnDPFNXz9k3WAhYda2vWSl3WqfvN1tjWdjBq+MqlFlIhBnr+lbTuv+gwMfKH9w==
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr9892618wro.231.1581451371776;
        Tue, 11 Feb 2020 12:02:51 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id 4sm4955101wmg.22.2020.02.11.12.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:02:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] io_uring: fix reassigning work.task_pid from io-wq
Date:   Tue, 11 Feb 2020 23:01:56 +0300
Message-Id: <728f583e7835cf0c74b8dc8fbeddb58970f477a5.1581450491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581450491.git.asml.silence@gmail.com>
References: <cover.1581450491.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a request got into io-wq context, io_prep_async_work() has already
been called. Most of the stuff there is idempotent with an exception
that it'll set work.task_pid to task_pid_vnr() of an io_wq worker thread

Do only what's needed, that's io_prep_linked_timeout() and setting
IO_WQ_WORK_UNBOUND.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 04680d2c205c..f3108bce4afe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -948,6 +948,17 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
+static inline void io_prep_next_work(struct io_kiocb *req,
+				     struct io_kiocb **link)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
+	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
+			req->work.flags |= IO_WQ_WORK_UNBOUND;
+
+	*link = io_prep_linked_timeout(req);
+}
+
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
@@ -2453,7 +2464,7 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
 
-	io_prep_async_work(nxt, &link);
+	io_prep_next_work(nxt, &link);
 	*workptr = &nxt->work;
 	if (link) {
 		nxt->work.flags |= IO_WQ_WORK_CB;
-- 
2.24.0

