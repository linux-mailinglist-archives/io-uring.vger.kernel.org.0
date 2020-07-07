Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D44216DE7
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgGGNiT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 09:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGNiT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 09:38:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4107FC061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 06:38:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b6so45153499wrs.11
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 06:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r2OuxI05Ei1rxjuML2OAJMI4wspPb6WpNphf5yAjgaE=;
        b=h+FD+lsO6VY9oD41z6sBpimifIIwa1RaBC7nWIC7HwGfXNd2dx8KUQ0HVLnmxh4VVR
         udDOSOE3y4Ranlb/Gt1AuJ9mJlqOrvo2UQEppklcaaaQSUdshEZS1iSaWvlgjgDU6R7P
         1nyD7De6yKocJ8qoTpbkpRtlat4b/YUIlpl0LVcTkjkKGaHQz1CMxAU7ezeZB3DPPFV5
         KXYLXGRdydowsmkD+WWfZg4b3HYpmK3CIcI5CGHvSRi4XCh4XRhQ1nXwT8+aYuR0DYCl
         haNOjSQ+cBohiZ0sx32a5jQTGYS5/eDc89JlMP9119xwBCdMWv6ojV2/b6mTka8L0Klf
         ggLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r2OuxI05Ei1rxjuML2OAJMI4wspPb6WpNphf5yAjgaE=;
        b=X2aDXWDETK61BR27SVnxW32VOjZvSWRG+TQsxXGuWinUPPAqfnilWIdPK6HRDVQRra
         u81rlbKLYZ3JbjYBGi2E9VZMfE2NkbWlqtbNWzlR9h/PtvXj0sjejTFiUlJNBdBfCOXo
         HX1cwzvFqsw7YFdGjZ/fUCdhgOWLV9FXah0sJNmvJTFRrVuGL5uJTGVaucBM09bhsA7a
         vG6mxietdEwdZlYuWJCGStQYJ3UqT3beFHRHknpjDOtWxDUYW55WUHTOHjaaZfejbdqI
         BDdZ1Qne6LExBgnfgsCCutk8kcM9WcwlSFuf+VIQ1tHXAzPWKfktoaIo0FMHJivCaBLG
         +nFQ==
X-Gm-Message-State: AOAM53043K8ECvQYttU56b7cTVLbQVDFGajtnvvlPRLfNS3wmC7PYAQh
        KWyTqmqHjJI8R4xjC0Nr6gNF8b3g
X-Google-Smtp-Source: ABdhPJycZnsrkYakHZ92JeC9h1opK1WyKoJUILwgj/l9++oSrhUe3nad1SV1oxuSUULqFapFkbpAlw==
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr51068868wru.22.1594129097984;
        Tue, 07 Jul 2020 06:38:17 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 14sm1093663wmk.19.2020.07.07.06.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:38:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: remove nr_events arg from iopoll_check()
Date:   Tue,  7 Jul 2020 16:36:21 +0300
Message-Id: <d7a13a8acbfd0ecffe3106a25110fbbf17052cd3.1594128832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594128832.git.asml.silence@gmail.com>
References: <cover.1594128832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nobody checks io_iopoll_check()'s output parameter @nr_events.
Remove the parameter and declare it further down the stack.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index db8dd2cdd2cb..9c3f9ccb850d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2073,9 +2073,9 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
-			   long min)
+static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 {
+	unsigned int nr_events = 0;
 	int iters = 0, ret = 0;
 
 	/*
@@ -2109,11 +2109,11 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 			mutex_lock(&ctx->uring_lock);
 		}
 
-		ret = io_iopoll_getevents(ctx, nr_events, min);
+		ret = io_iopoll_getevents(ctx, &nr_events, min);
 		if (ret <= 0)
 			break;
 		ret = 0;
-	} while (min && !*nr_events && !need_resched());
+	} while (min && !nr_events && !need_resched());
 
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
@@ -7963,8 +7963,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			goto out;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
-		unsigned nr_events = 0;
-
 		min_complete = min(min_complete, ctx->cq_entries);
 
 		/*
@@ -7975,7 +7973,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		 */
 		if (ctx->flags & IORING_SETUP_IOPOLL &&
 		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
-			ret = io_iopoll_check(ctx, &nr_events, min_complete);
+			ret = io_iopoll_check(ctx, min_complete);
 		} else {
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
 		}
-- 
2.24.0

