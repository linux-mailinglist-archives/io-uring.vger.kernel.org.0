Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3AF3E4CF1
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 21:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhHITTX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 15:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235942AbhHITTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 15:19:20 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566C4C061799
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 12:18:55 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q11so4611167wrr.9
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 12:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=P6dP66iS7MkDVzspdSSEWyGJ1ZHDFzVr7Nc1na2MZKQ=;
        b=fnpoPV7vvgo/I08c4PBQwit2GfFhjDh55/EyuJrSXljFXzu0LZLFpnx4VRBOpV11Py
         EKSa6TVfx2t4yP1k7m68NfSN02wb3EcDZCadhmEx8UviY1RquWxCgv9PQ8qZKK2xmKvI
         jsEubCqXq8SVe78R97uemN2tVvlslkK1nOs3A6ztlMIaUHW4HvP1syvrocjYPKP5QL1Z
         3oyFLm/yHLxHjCghQLAWUMZwTdIuAM3iXehtzHGYi6xA52WAMIZdHRmkYnZf0+o54GZp
         ePVhipiDEP+ZqowEF9TbTfqPmLf98X8jv2AH6YFKCfWMYKTKMSx9sLxUfQZ++I6MW2Zl
         cphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P6dP66iS7MkDVzspdSSEWyGJ1ZHDFzVr7Nc1na2MZKQ=;
        b=Y+IaBpZuRyPCHXg6MNyTRAaHX3UYeYFB88y3e7+83Ct1zIq5/kZY0jt/fz4j5MLc4d
         HIbv0uOVCoQibjIy/QQ0lviga5Ac7XCVb1IbCC4BDU+d+/R78RBuxMopBKFT9tRZca1j
         r14tmRnKCpqDi0kPZSZ0sGpdo7dHWSvyaHupe/PiQLdDAZZY0+mLD/kBygIts+bw94Li
         J2MDejQq05yYgmudCUjuyaumm98vnuXRecSBLqNpGi1OYhUatacUnesUsOPl9I7SqHNP
         7jnBWF2yMr2HF6zcCSkvt21/jEQpZAPOSxwdxdSC/Y/6s5Gr0GUJPSheZxuicBk/Ch7v
         ro4Q==
X-Gm-Message-State: AOAM5336VAEwp7HwSaMrO8WxbzGRdKXHV5wmmUYfbqBu0r/fd/BA4FxL
        JesU6er2r3qxGsIMIOvgR/I=
X-Google-Smtp-Source: ABdhPJzVhuqfhUdzIbmU1+Q3mwYEhtCug4at+4N4W2w9xd61wLnsU/C4Sw5i4LD2XHvDHSyMUbECLQ==
X-Received: by 2002:adf:dd07:: with SMTP id a7mr26100697wrm.377.1628536733998;
        Mon, 09 Aug 2021 12:18:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id h11sm13283074wrq.64.2021.08.09.12.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:18:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/7] io_uring: remove extra argument for overflow flush
Date:   Mon,  9 Aug 2021 20:18:12 +0100
Message-Id: <7594f869ca41b7cfb5a35a3c7c2d402242834e9e.1628536684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628536684.git.asml.silence@gmail.com>
References: <cover.1628536684.git.asml.silence@gmail.com>
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
index 4723eee24882..56ac7ded1615 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1520,7 +1520,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	return all_flushed;
 }
 
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
 	bool ret = true;
 
@@ -1528,7 +1528,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx, force);
+		ret = __io_cqring_overflow_flush(ctx, false);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
@@ -7051,7 +7051,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret;
 
 	do {
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx);
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
@@ -7089,7 +7089,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		/* if we can't even flush overflow, don't wait for more */
-		if (!io_cqring_overflow_flush(ctx, false)) {
+		if (!io_cqring_overflow_flush(ctx)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -9364,7 +9364,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx);
 
 		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sq_data->thread == NULL))
-- 
2.32.0

