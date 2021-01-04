Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07E02E8F54
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 03:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbhADCDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 21:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbhADCDk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 21:03:40 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541BAC061795
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 18:03:00 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id y23so17931900wmi.1
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 18:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IqYeSvtyVB3RbMTy5hQZrqGdD4JGSluat7WAL3zJ0F0=;
        b=OD42X77hBQYt2MYhy65Wnebk6aEg4zK68VDMRn3SbkkqbZ8f2ocjfYyJZAhNNmMXRP
         Ob8W5Ao/+nz+tW7xrVlUXyD0QfAdi3fyGLIzOFdUlzsfuiq6wlVJ4GXnf8anROyhZRLq
         UMnk/jkFPaShb1ZjHLczzeOqwNcAKwk/X22hG2IbAXL4nxpPnXsnagEhv61QuL2Uo7xC
         +TvZEqsEvO2g2jAewzpJgJCgANMeFCd5QY96S5oXGaje7gCHoFR3F7JMbn02spVHyhyt
         LRBNm1cwnVTmXIShzHLpzmOzsjch82ZU18aKOxMgafgnFYR3vYxCvvYF1dLdN+9myoFZ
         WBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IqYeSvtyVB3RbMTy5hQZrqGdD4JGSluat7WAL3zJ0F0=;
        b=B3xAhLmQFYmTg4mXrN/7/eQeDjls8k0E2t9+wexZ5WTXmqHmS4yhr2CDX8qk7c2B0O
         rAqu3T3BjuBMUgOsGEdyDpV0a9eeHyaCkGdRPF2rMlvy6hrvYiniFjf1+/lGBkiFnz7q
         qPAqldQWs6m3k2ZTSCitpjMVKmdf9NJOPLmBXHKjZdfNFgN5J0I4RIxjDtHZXcalUdCu
         iYSr3hBDxOOfo1AdGtdZMyBlkFKkwD/H8kENEc8uKkxETsYVd8wCrGySiri6Xr1nlrX6
         xstVnLo4mwoEQzvZJghlbzXwa6lzMgHugSeW0Yxea1ApQtq9J6JkwQmr4QemaqfPlScR
         4jNA==
X-Gm-Message-State: AOAM533HyMO8dVPbu8JAK0GncuCCgMoJXixFJ2+OMAa0lZMsjS06LTZ1
        dHiRwki6dZloP++H6O6Oya2EEMzm8mEqPQ==
X-Google-Smtp-Source: ABdhPJzsR97fNbefWzNJdptG2sjZizAIYsVNfukBBhXd97po7hqk6LwkggsWq/VEGEWbU/Egxm/Jbg==
X-Received: by 2002:a1c:4107:: with SMTP id o7mr25008997wma.69.1609725779083;
        Sun, 03 Jan 2021 18:02:59 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id c4sm96632893wrw.72.2021.01.03.18.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 18:02:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/6] io_uring: trigger eventfd for IOPOLL
Date:   Mon,  4 Jan 2021 01:59:16 +0000
Message-Id: <46d2507d1c704ed5189b9327767db767c617ff03.1609725418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609725418.git.asml.silence@gmail.com>
References: <cover.1609725418.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure io_iopoll_complete() tries to wake up eventfd, which currently
is skipped together with io_cqring_ev_posted() for non-SQPOLL IOPOLL.

Add an iopoll version of io_cqring_ev_posted(), duplicates a bit of
code, but they actually use different sets of wait queues may be for
better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cacb14246dbb..2beb1e72302d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1715,6 +1715,16 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
+static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
+{
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		if (waitqueue_active(&ctx->wait))
+			wake_up(&ctx->wait);
+	}
+	if (io_should_trigger_evfd(ctx))
+		eventfd_signal(ctx->cq_ev_fd, 1);
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 				     struct task_struct *tsk,
@@ -2427,8 +2437,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	io_commit_cqring(ctx);
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		io_cqring_ev_posted(ctx);
+	io_cqring_ev_posted_iopoll(ctx);
 	io_req_free_batch_finish(ctx, &rb);
 
 	if (!list_empty(&again))
-- 
2.24.0

