Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE221A10E4
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgDGQDK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:03:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42897 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgDGQDK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:03:10 -0400
Received: by mail-pg1-f195.google.com with SMTP id g6so1926585pgs.9
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 09:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m278NEfPURnLfLcoq5XUdI3T/R4WKj93EFAmMOODL4A=;
        b=1dy/aQUzmLs3PVQjjVh2uTPPVr+wvQwYYwTTDqa5oEfcOt/wOHRsD1V0kjQ75bnv5d
         mm7+MJD+cMqd0Yv/KPlN10pBb5FDGlWxvKTs9SFtpRAegn3QYnlosFaEp+//YP/if6JI
         GSJc6hmNdrvN7dJpnEMxeIlYqNQl6anIslAADcp1pHHonk0b6B1goUyN5iKYJyxhG5ur
         3rK+Cf4T0DC5I21Ln/0qEZFGDJauJOEd1hxBQheDXWyI2AHXrJwCu8lB39sGoES2SUmo
         tYaRLbQbidtff9VfI6zgqNe3sEDOqWGwGqJkZh5HOsoIyY/oqZxpYgwGxDHgcVBzqVtH
         fppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m278NEfPURnLfLcoq5XUdI3T/R4WKj93EFAmMOODL4A=;
        b=FmQIdiZ8NtgnHTE/EJ4sH/ovMoI+DQDIiN6sV5yOzidA+XKrBhS0msoEMe1zcarSXf
         Hq9+e86suoGieP+RdTzmrIsMixdBKOn0tedoens/8gYNf+KMShP35L/659bAF5gr+Wbu
         S9hHKkxxeDu9YPBnqkAOhLRNvm79Yj7nJJFm+ZGQPUFlsHBBvyA7EBHKs9xmLKgYBhcU
         18Ql7e/r94WZF2q69KJr5iSBJPaoFpK6lHcRrFRcUjOViLYGjNExjTq25mFWWIPhRtLR
         /RBBW4MFj5nttgWZXaieduLk+mLi1RYOhY5O838Unu1Dxu26NAzr9l09LTzp9XFf8Oo3
         lzYw==
X-Gm-Message-State: AGi0PubIlLhBLnRjVgEbHKDY1HoHcx435Xqkkj/k2reZE3lOefUSRuHm
        pYKiHx0pPJBeYbPG769czBAjV1gyapLyVw==
X-Google-Smtp-Source: APiQypL1s7OVh4+WrnR0D6PBZ0ZpZ8Ml3ZCNkqkyUAo5EXQk4vG8Ti8RMt9ct3ngHCv0z2Kg+t8Vkw==
X-Received: by 2002:a63:bf4a:: with SMTP id i10mr2863918pgo.120.1586275385838;
        Tue, 07 Apr 2020 09:03:05 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id y22sm14366955pfr.68.2020.04.07.09.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 09:03:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, Jens Axboe <axboe@kernel.dk>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/4] io_uring: flush task work before waiting for ring exit
Date:   Tue,  7 Apr 2020 10:02:58 -0600
Message-Id: <20200407160258.933-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407160258.933-1-axboe@kernel.dk>
References: <20200407160258.933-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We could have triggered task work when we removed poll completions.
Be sure to check if we're called off the exit path, as the exit task
work could have already been queued. If it is, then the poll flush
will have queued to the io-wq helper thread, so there's no need to run
the work.

Ensure we do so before flushing the CQ ring overflow, in case the poll
flush puts us into overflow mode.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7fb51c383e51..4e760b7cd772 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7293,10 +7293,15 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_wq_cancel_all(ctx->io_wq);
 
 	io_iopoll_reap_events(ctx);
+	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+
+	if (current->task_works != &task_work_exited)
+		task_work_run();
+
 	/* if we failed setting up the ctx, we might not have any rings */
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+
 	wait_for_completion(&ctx->completions[0]);
 	io_ring_ctx_free(ctx);
 }
-- 
2.26.0

