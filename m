Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866742E8806
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 17:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbhABQLq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 11:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbhABQLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 11:11:44 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1B4C0613C1
        for <io-uring@vger.kernel.org>; Sat,  2 Jan 2021 08:11:03 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id q75so13833523wme.2
        for <io-uring@vger.kernel.org>; Sat, 02 Jan 2021 08:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmEmmy4b8ME/8DpWd6hgJuxNUZqbGRFMKcjYCulklUI=;
        b=PYbDHfJVqWM1iOIC0JMxgDRxjVq94VKbAgnRbZPubO8nfumIJYZf76gKQYzU9sFm+7
         KUrYLL/4xw/W3/3oWomg9oGSxbigHEQqIVh0oVP1hZQFxTIQcx9naiFfX3GEwD+UCb3K
         uCBwBfNbIsJm4DL6FyMhf2vZTVlE/TrcPjjXXUpnCHTyVr3bOuqvjdG/tNvBUewYdE8L
         EGLE/YG4Tiw1OWn7eWXr29axXhnyMmt/fC9dg6xNHlFdJmKeE1HDbkCLjA+aUy20JqL6
         xaZDFUDBaKP39i6ox6d8ogBOI3aJycLsCgdtqDU4b5LIlWdA0w4csRHSfmEq4s7ax2Tq
         KKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmEmmy4b8ME/8DpWd6hgJuxNUZqbGRFMKcjYCulklUI=;
        b=myDEsdm9U3RqKmXTxnW+JJYb4JJahW7UadsIWrQXpBWj/dAWF8QwZgIGFlj3o9a4n7
         yVXU/B1Qf/3XNuLIXGJpJ5NJsOrEUxOgfQmzuKTo4sa+kqTlKmm7wTtWeK+4LDgDVTmT
         v9p1HR72zdeZqCPtWMq2ek+KzwSKI32tDKGRtU8gkLUKYc5N5WUFHcLVUJfWFDE/2kWU
         Y46E2mx74Il0iMIJ16ihEMvTRjNK0SH2+nLn/SBf5a6Elk+zm0wLQuay9C4P2Nus0vpp
         xV5h2P5PQTuPUganf0qrfuIM12l7U0FUPsgIHiuzmcxrmncUifv+Q15OYqf92k3tGpGx
         CGpA==
X-Gm-Message-State: AOAM530aEkW+k/CaYx3TNocj+RMUH6wkqtgOf1bS1tYlqNDmCQg0scYZ
        8AZ5wGCyHYuh6zHvzEpbrRo=
X-Google-Smtp-Source: ABdhPJwOFHdEMve0e/L2rCQ8xkPczIGCuG00Wzon2rPE+CqdkQLDwmHD8RmuJeNCdnl5B4FWJVuLFw==
X-Received: by 2002:a05:600c:224b:: with SMTP id a11mr19785997wmm.97.1609603862141;
        Sat, 02 Jan 2021 08:11:02 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id b83sm25222377wmd.48.2021.01.02.08.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 08:11:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Subject: [PATCH 1/4] io_uring: dont kill fasync under completion_lock
Date:   Sat,  2 Jan 2021 16:06:51 +0000
Message-Id: <e51028690f7415a018403d3607739693188b5f7b.1609600704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609600704.git.asml.silence@gmail.com>
References: <cover.1609600704.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

      CPU0                    CPU1
       ----                    ----
  lock(&new->fa_lock);
                               local_irq_disable();
                               lock(&ctx->completion_lock);
                               lock(&new->fa_lock);
  <Interrupt>
    lock(&ctx->completion_lock);

 *** DEADLOCK ***

Move kill_fasync() out of io_commit_cqring() to io_cqring_ev_posted(),
so it doesn't hold completion_lock while doing it. That saves from the
reported deadlock, and it's just nice to shorten the locking time and
untangle nested locks (compl_lock -> wq_head::lock).

Reported-by: syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..00dd85acd039 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1342,11 +1342,6 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 
 	/* order cqe stores with ring update */
 	smp_store_release(&rings->cq.tail, ctx->cached_cq_tail);
-
-	if (wq_has_sleeper(&ctx->cq_wait)) {
-		wake_up_interruptible(&ctx->cq_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
@@ -1710,6 +1705,10 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-- 
2.24.0

