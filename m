Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670823DA724
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbhG2PGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbhG2PGq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:46 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F9AC0613C1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:43 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o5-20020a1c4d050000b02901fc3a62af78so7058811wmh.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DKeaNIyiic7HY4DANtGEnyE3YLFmKncmNyFqKC7FGc4=;
        b=N1XA0xMcS7K3+ZUx4rfJXgEIfSB8s6y76yxoCgdGCoVIE5CaILmdGYM9d+oNae1m+j
         BNz5ciPXM7plZQhuvQHfAKw+pet/9CjuxIwuh1M31dD72YyOVvCFD51DhtVyE5PXWaE1
         zNLh7VfxXcFJtta8qYZQfzaeo4V+956BDznb1rUwF0kCblmjaLdSD8XYeieezmB18Loy
         Sh/bow3A/ZdxzmsBxz/csMNaeaPGF8u0aifChVO7fvohTaKbK8BOSGFF2zmUI+KT0std
         kpIbJkMZRYhqanlWS8T7Jq3GgYMMaGDGZZvOTh9FLRCGWRog0MvhbSBD1Qu84wmTYeJk
         fzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DKeaNIyiic7HY4DANtGEnyE3YLFmKncmNyFqKC7FGc4=;
        b=LWEeO9YNa5hwwsqWqGhQqNRgrOdClzUsWVrXNxPAl6DU9Trr1yFNSpSYGK6CZv7e5m
         7T5nWkz2BwsHam+zVjepE64HQIa2zqY7YBpzX59yIc9cZqYXGQWU144LovuIx6GYry+9
         ugyXogC/OHj/MCGQOp1hMijBSahAdDB7qnDDnecW7AJVQ4D052981jEaJloBKYNptt+C
         95/ouwkTCbVoVQ0VIvcjoUgZEmYIA2iPiwQgdFVdPRqUqa10KtV3mPzmuUGUgmHbgtXo
         Fm5SbZu+8FUCe1lSdmsFpeh9o3EvhkyzAuoCs/VfSNGCJTNgmXrZKJ0oUaOu5JMyIn1r
         VedA==
X-Gm-Message-State: AOAM5318HH0TNfkRWcS+Ndz1IiHRBIfAJiwSoINTnu6HImdVM+loOkVW
        eP+6JdTZw3N1cdHMg2tXo0AryNGmqLc=
X-Google-Smtp-Source: ABdhPJydlAs4UD/yqcdaLFfehXk8jyMM09zWDDaGFC4SkhMmNR64/5RmmGd734eHQ4g0PzXPQeBR8Q==
X-Received: by 2002:a1c:2282:: with SMTP id i124mr5281212wmi.166.1627571202018;
        Thu, 29 Jul 2021 08:06:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 22/23] io_uring: remove extra argument for overflow flush
Date:   Thu, 29 Jul 2021 16:05:49 +0100
Message-Id: <e15b092701c86cbcb0f41e7be11261c9744890f1.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unlike __io_cqring_overflow_flush(), nobody does forced flushing with
io_cqring_overflow_flush(), so removed the argument from it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c14206003725..e3fb15cc113c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1524,7 +1524,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	return all_flushed;
 }
 
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
 	bool ret = true;
 
@@ -1532,7 +1532,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx, force);
+		ret = __io_cqring_overflow_flush(ctx, false);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
@@ -7052,7 +7052,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret;
 
 	do {
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx);
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
@@ -7090,7 +7090,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		/* if we can't even flush overflow, don't wait for more */
-		if (!io_cqring_overflow_flush(ctx, false)) {
+		if (!io_cqring_overflow_flush(ctx)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -9377,7 +9377,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx);
 
 		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sq_data->thread == NULL))
-- 
2.32.0

