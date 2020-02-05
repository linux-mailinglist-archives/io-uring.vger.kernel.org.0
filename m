Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628521538BF
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 20:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgBETId (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 14:08:33 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38703 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgBETIc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 14:08:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id a9so4163477wmj.3;
        Wed, 05 Feb 2020 11:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1c7r8xYvCU30iFYVP8Jf/X8RFEGRAQQ2k+nRXggEl0s=;
        b=Lp8ii9SHceGXfF1qndmGvDtFzAPYbrYRtiFx18fs82ZwByRjeNEWO0YC6VoAXEKPSt
         C8rA07H9Z55gQjgzKQZkZCNfvOCdwYBRA32Kylcej4hyY0zoce6LQRw3BxKDIaUlunJH
         mTtlyjQyZ9O6lsrcKcRc1YXSvG1GkUu7JIYMZdxTuBKi384a4lHhhpU/XkHYaX3Htyg/
         JcE1cy2AhgRE5YvzsWjuwwFHiPdrlddcpSV9WfRfuZhJb/lAQbiNodjSAzen0l1PmRFw
         GNvv+SX8y94Wc/kcAOn1y0Kyfw/FvsxIt26vTL5KYOzTWaw0tEoxi94a/a6pPL0DTZhQ
         De3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1c7r8xYvCU30iFYVP8Jf/X8RFEGRAQQ2k+nRXggEl0s=;
        b=VrZWHc6FuADIui3snt/SVBs1+qJkwYtaiGaDihXixmZVcVYK8IufdwtFLlKqkmunjO
         jYaVtWA+zB4kE+ee/jAdSYFM2tR+KY8hz/lAd6swpaIRH/0XN+lupLj5HG1KV1No4Yc8
         FBf7qGoB2JVTltzP6UM2dMjgcqWUIMDAnh5vuynn3nlJGMs6GRAltzVm0PsWKdutgjDN
         PXiZnSzaQIRoOd8jo3ieXddDm8UCqPnghxI5ORilXj2hnBpSV0P2HWGyx50L9VDI1L7/
         t1GkOS2wvWT4xyKm0v80lY1hw/z0c/XHwUQn9uKpGogIcT0SOlu5qLZgcGwdsh4W9reK
         8UMg==
X-Gm-Message-State: APjAAAX8++1xsmw6Rr21dZWDvnzo5CAaMTYfMp6tEuK7z/JdGzZLmWkR
        yKRL2uWabZGBaeuEC44lovQ=
X-Google-Smtp-Source: APXvYqxUf3Bp6prPOcaKf1M0lU0F5E1QUKJk6upgj3k6AbMFsiOTMDl3cL75StnR4cJehAEIhubQSQ==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr7210235wma.87.1580929710197;
        Wed, 05 Feb 2020 11:08:30 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id b10sm915568wrw.61.2020.02.05.11.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 11:08:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: deduce force_nonblock in io_issue_sqe()
Date:   Wed,  5 Feb 2020 22:07:32 +0300
Message-Id: <37aed8346c4e5ef02f5d2439fd090515d43cc7b8.1580928112.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580928112.git.asml.silence@gmail.com>
References: <cover.1580928112.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It passes "@sqe == NULL" IIF it's in wq context. Don't pass
@force_nonblock but deduce it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e18056af5672..b24d3b975344 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4207,10 +4207,11 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			struct io_kiocb **nxt, bool force_nonblock)
+			struct io_kiocb **nxt)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
+	bool force_nonblock = (sqe != NULL);
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -4448,7 +4449,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		req->has_user = (work->flags & IO_WQ_WORK_HAS_MM) != 0;
 		req->in_async = true;
 		do {
-			ret = io_issue_sqe(req, NULL, &nxt, false);
+			ret = io_issue_sqe(req, NULL, &nxt);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -4643,7 +4644,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	ret = io_issue_sqe(req, sqe, &nxt, true);
+	ret = io_issue_sqe(req, sqe, &nxt);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.24.0

