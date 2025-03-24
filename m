Return-Path: <io-uring+bounces-7220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5979BA6DEC2
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 16:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47FE8188E859
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 15:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE9D261394;
	Mon, 24 Mar 2025 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TS4cXKhP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2C481DD
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742830316; cv=none; b=l66yKpeFxv3vGrss0cE/D4+nmPnRAEI3LSRGt9uAtInENu6eck6HfQByWdHyf8BWef2QTVoP+jFHDu6Q/VY+PAPYLvOq3wz3cqpxczFadXJa6YaZD7S9O2BtnlPJcaG7Yb05Ao+OXjqx9rBwphnDfLLIYa1kcrU3GosOSYDz25I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742830316; c=relaxed/simple;
	bh=Y2A3npzHUHz+mW549dZ42iu8CtfZE74dgAsfW0g8mk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4F2YROnMAHMB1M//uUJh2DijXW8Rv4EHIkXPg0A5qu/ZBaM6i5PLshoIbQqRg58OzhHK5D8GzfSf0Ht6LX0gmQfoabJ2kV/OJsWMb8nnfqryOsiQNJDp/8UU9R1MvSq9i7bjzpRPe1bqfbh1w6FF0vZbeYD/Yd/FhadxUm8+X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TS4cXKhP; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac25313ea37so584335466b.1
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 08:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742830313; x=1743435113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9j5lw2JYG9+WUDbJ5i/ARuWUMashpkzuYd/ApvjOjJ8=;
        b=TS4cXKhPMIwYErytb8+G20BeaqznMCU2PYv5b+k1MheVgep5Qd8znwOquF7OM7Dtvr
         V7FcoN5hngzmNwxQLwgHheJAS9Oeib94Ks9aJuhBAAhtTr0Ifh1CpqRx8IOL45iYNGjS
         ypk7y8x/0GNqfhPFZD8hNqLXqH3k/yuGW8mHPRboFBVTdyCo7ykf6t6M0WnXsg0ftyjL
         5yoHPJ8BtatryZICsRbjQoiAfXGqzMB4dWTsqLMepWTpTYItvFvZoG25UjmZn4PKTRAU
         rWcRo1zq5ULUfW7sRFnXYiWu+o5uy6KasxqfRfP2kkP8MKt11+U1T+vtXtHR2jufMmxh
         e5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742830313; x=1743435113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9j5lw2JYG9+WUDbJ5i/ARuWUMashpkzuYd/ApvjOjJ8=;
        b=kksIzWc/O7AiaOg33GQNQSRIDJ7kUvkyx4pVgzN+SqgHmpdovxRT5krAPVhYk+yUFc
         KKvCiSYEjUHJI5XZCiVUrOC9bMSz/j11nbo5PfOtA/qzlpGK7RPlIltyEgaxvOa7BEPQ
         hGU59AIR02GoJh6XLmTDQfcbKiQG4lVi1Y6XIZ4KHetg7V0ltXZVRUz8A0UI5SKHH3c5
         TOdAedBkKoA1kyiF47qYTfsArg2P58jtYgWfx+HeFa+lqk0SNeBgFz8oKa5EIeXNvltV
         qnIdvNGbxWutU9lUNSmRoqOJ1MmfZqCiOCCZ3dtpMy0KAR5WXjyMsr/06zSk6jOMKza+
         Gm/w==
X-Gm-Message-State: AOJu0YysT5AOI6rP2IDJjWf5sI+Y5ccxzZL6A5mtanytKqJT61BXcOcM
	CU0iPSAhYoa+xCO/93s12/fSOKXigEHSNdy6qNCPtWpHQcYCDHuoaG3ILw==
X-Gm-Gg: ASbGncsrKTilIOG+kg8zsNH7yJcTvcQ9saUmyqDr3XnA9Oye9XnwnT/+j5stvo68uOS
	yefoZ6q4FfvyDnfoLJPiKvaD5Jye6UKiIzFXQun3tvA7oJsQgD0r0WcorYwhLFVWfnKFvrm7hT3
	OJFe+yvQNDRB5aMOS/shrR1z+D273WVwUsmZUgXz3qnTuaZ7Cx/KssXsu9iogBRMEGjNiiL+wLT
	yrTvmJPFpPIuqK1oDwPgUww6V3at8jbbMcEDhekQFbgrROEz90frBv2mcxTT1TtW1fPFuJNWyjh
	TRFZ3wzRkxLrPCZuv7iNEI7H5jZq
X-Google-Smtp-Source: AGHT+IHGpu8UkH0qxtUL0BZ4FP2Ywa0r1aTTLVLnt1iMiH9+3cO1fdzpWwWMEPI/ESfTF5JvyupYVw==
X-Received: by 2002:a17:906:ee8e:b0:ac1:f5a4:6da5 with SMTP id a640c23a62f3a-ac3f24b45f2mr1404946966b.37.1742830312447;
        Mon, 24 Mar 2025 08:31:52 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8aa1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef86e514sm688103866b.35.2025.03.24.08.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:31:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/5] io_uring: rename "min" arg in io_iopoll_check()
Date: Mon, 24 Mar 2025 15:32:35 +0000
Message-ID: <f52ce9d88d3bca5732a218b0da14924aa6968909.1742829388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1742829388.git.asml.silence@gmail.com>
References: <cover.1742829388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't name arguments "min", it shadows the namesake function.
min_events is also more consistent.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index df3685803ef7..6022a00de95b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1505,7 +1505,7 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
+static int io_iopoll_check(struct io_ring_ctx *ctx, long min_events)
 {
 	unsigned int nr_events = 0;
 	unsigned long check_cq;
@@ -1551,7 +1551,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		    io_task_work_pending(ctx)) {
 			u32 tail = ctx->cached_cq_tail;
 
-			(void) io_run_local_work_locked(ctx, min);
+			(void) io_run_local_work_locked(ctx, min_events);
 
 			if (task_work_pending(current) ||
 			    wq_list_empty(&ctx->iopoll_list)) {
@@ -1564,7 +1564,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    wq_list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, !min);
+		ret = io_do_iopoll(ctx, !min_events);
 		if (unlikely(ret < 0))
 			return ret;
 
@@ -1574,7 +1574,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			break;
 
 		nr_events += ret;
-	} while (nr_events < min);
+	} while (nr_events < min_events);
 
 	return 0;
 }
-- 
2.48.1


