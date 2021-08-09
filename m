Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195E83E454B
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbhHIMFy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbhHIMFt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:49 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E1EC06179A
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:29 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n12so11035599wrr.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Wa91wsboRsUNKqsKp6WT/xumVIIOMSBMDBJ84scN+Tw=;
        b=V4GnREmysEppVv2MSsUO1C25pZpS8TKv5knS9gjZh6CyP1jfQJtV60GQFazZLABXf4
         XJ88vOMAdT/DCv1gtPr8Y5PRjGVWWRqa7e7gWPANu/oUP2lREiq38efK1lW2EyzfS97K
         OoDlBBdm1ir5GN1XGx8/6+9i8KByhSrEDMzoHlzHG5xFKFD0wexBLrfp4KdCqFeZT47M
         OFXcIP9MUDJvI0AezD3Afe5H2V3ehABjlrC1qT7jMayb3zj9ntwKO7HEIJi/g8VAALmZ
         +5+CYHl/APwmA1nBENm8ps0m/rsldejqqtJor7HItvvh+9yOwuRnUTla+ayeb/p2wXOv
         IRRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wa91wsboRsUNKqsKp6WT/xumVIIOMSBMDBJ84scN+Tw=;
        b=E8g3PC3FiVgOl0G8r5L46p0TE+vC56PWxNQVoadqmZuK4lHFY4tGI/+H3hd6knLv8E
         HIszJawesvKEp65w8T0qOtLs961ARlhECns49+zPK4b5UqA4j8o1M0yVI38l4+HCsCc4
         1mSx1ndl2jQh5fsHng8bdJ1WSKun9il4q0Xe4SKjBIf28MgUxZgGuDRUyD+g9WheAyHi
         8CmHlPnqqGXOwKyrGlgz+fEAj8QMvgmZcs+Vtcuvb9ZqDBYHxJw2fLGQEwZWsz+NYIdX
         tEeor51195rMv+ADi+ADAakCn6hhuMJ1uehKduSYmXb0aWjxmleWudCi/V/EBjHm0ngZ
         G1aA==
X-Gm-Message-State: AOAM533uu1Y8XO3gL8XGXO8kC4SsovNYv6hSEMPFPxo/ZklDOLgd5Oam
        xVrCam9EppTzRF7hmwEKty8=
X-Google-Smtp-Source: ABdhPJz5sQH12K4lFa/rHLEelkSD+SfQxKEagaWTJmrBTrjdllvnz/QrmcFn0UU+rWkze/H5h299Lg==
X-Received: by 2002:adf:f704:: with SMTP id r4mr25232856wrp.389.1628510728027;
        Mon, 09 Aug 2021 05:05:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 27/28] io_uring: remove extra argument for overflow flush
Date:   Mon,  9 Aug 2021 13:04:27 +0100
Message-Id: <5e43f3e926d1a23689534c134409fd412040c3c9.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index 749c0712d98e..9070b7cbd1c3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1533,7 +1533,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	return all_flushed;
 }
 
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
 	bool ret = true;
 
@@ -1541,7 +1541,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx, force);
+		ret = __io_cqring_overflow_flush(ctx, false);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
@@ -7075,7 +7075,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret;
 
 	do {
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx);
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
@@ -7113,7 +7113,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		/* if we can't even flush overflow, don't wait for more */
-		if (!io_cqring_overflow_flush(ctx, false)) {
+		if (!io_cqring_overflow_flush(ctx)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -9388,7 +9388,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx);
 
 		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sq_data->thread == NULL))
-- 
2.32.0

