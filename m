Return-Path: <io-uring+bounces-557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1849D84BB0E
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9313288F42
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636DAAD52;
	Tue,  6 Feb 2024 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cgW4cvSY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B844C85
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707237278; cv=none; b=grgnVDhee1tZqXV9fA5cME9rnpHySqrS9FwyLykrcijcUEWMZ3eV0bqX70O3Ad0LbcqMWl3+Zt5e+2cXgE30Q9pWTS2w4m9BCZgu7sQWSrdZ9Jqnfd2HDkD7C1T+ovXcVYzk8a1gpCYqm5Z2kRg0iSlm6v+yMaWFHLdvxz/rHfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707237278; c=relaxed/simple;
	bh=HGkg8jn+1tiQhhHkeDvYdLT6P19EyKlQEBs4srDnGLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSZG/bieYIez5L3CvdMKcyUW4FF5UTuIpkGeyMPGHxEt9ILTmSThjPITWCe0hl8cprA7v3tYsEzBbv9KZodaDa6fGR6HmS0aSml+3OmcbVYoxEjjlizOJPejGD1kmKMG3tY2avfaIpxo0AGiFIv7n2IIJtuA9DkWB2yyApxVUL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cgW4cvSY; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7c3d923f7cbso16745339f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707237275; x=1707842075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKc3IuqsYtihfLzHWvhn751k2a+IQ40XzH/g9DCcLM8=;
        b=cgW4cvSYo1OgOCkhvzk4UPBGVR0AKOLSpnpi3B1J2qQ4oS1DkBcwBXdjStnc4TJX0p
         W019zozBIuhzRwyB7+xSXVyXtY6d/e9Z6oicoa0ts+UxiwyiRLDZSPerTcxa6y0nLSjS
         Zvo+OzfDkTJFWP1rSWZVVnUKxWOAamid1tDtcF6oW1BOf/oLjLNGG1NJR5p5xjoP98ty
         LqcOKFXD+P6+dBajeZGs7BPMccNuNhhb36NgmYtuUcIRpVbkDlcsEnqMIZXhnAjobT+7
         iyDk5jtviGv8Ol1bdUfqDqvtIfp2ijHHdLyXmaaUh0VYtFiNkBm0ItveZzzZyktDS6tK
         T+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707237275; x=1707842075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKc3IuqsYtihfLzHWvhn751k2a+IQ40XzH/g9DCcLM8=;
        b=w45VhlgkCQumbVAgE41KITq9/+NDbUW6SPpVZjrpQw7AT4HteMstrqxd1Om+vY2Ob1
         aasTfbtrM125QXCFBlu1ycBmXzLYnnE2VOmjGkbKbzWsrPycm00W2U3NOF2mhBpX7tYV
         e3aqsvkhxqS94AXB/gHu2VKw5uW1JHi1fPHbhpgixHitth7ClLyis4LNyHqDBAuCExqB
         6SiN2C7Pcdnw91fcKWEUKLkUYi1i/93KpoSUXsVkTL426Unvb+EKJbSrAVthcdGG+9F0
         j0ACyFsayN7v4ctdhHsOKmGYMpKwCqeeeHONZKSp6ZSy+NqwWgJ8A4ejmlW+5XsjK4In
         dd7g==
X-Gm-Message-State: AOJu0YxhLghWelMd76BhsiGQr7uLqHFOmD05W9boIy0E8C4uAeTXDF4i
	tknFShULIaQmg2shLiuLxfdr2aXKRgDhe2n0/yAIdDj/XGDnceVNmdUtVZDzozfRzQzIeeYZK/C
	9gLw=
X-Google-Smtp-Source: AGHT+IHGX09ZwU0r9KtnFAfB9k518CqpJMG77lsRWA/Zoc7I2VmqCxChPBvPfqhFxSQM6IDD6iliCw==
X-Received: by 2002:a6b:ef07:0:b0:7bf:cc4d:ea53 with SMTP id k7-20020a6bef07000000b007bfcc4dea53mr3488843ioh.0.1707237275253;
        Tue, 06 Feb 2024 08:34:35 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUqycd8BVtvgYWdnuco6aREtlfEnNV8TP4RSynXRhuhT7NfjrRUgjr9FS48gPpdoaMHD/gmK8t3gBL2JgW5PgTExD3T2L3F4ZBCvj/liG8kyZN+XFdsI81Y0vgKjeSAciH8d6+HsqINiz4AY/nZEZBqJTMMp5lxpH+CBkCJSY7kvcI=
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u8-20020a02aa88000000b00471337ff774sm573316jai.113.2024.02.06.08.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:34:33 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org,
	olivier@trillion01.com,
	Stefan Roesch <shr@devkernel.io>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io-uring: add sqpoll support for napi busy poll
Date: Tue,  6 Feb 2024 09:30:07 -0700
Message-ID: <20240206163422.646218-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206163422.646218-1-axboe@kernel.dk>
References: <20240206163422.646218-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Roesch <shr@devkernel.io>

This adds the sqpoll support to the io-uring napi.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
Link: https://lore.kernel.org/r/20230608163839.2891748-6-shr@devkernel.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/napi.c   | 24 ++++++++++++++++++++++++
 io_uring/napi.h   |  6 +++++-
 io_uring/sqpoll.c |  4 ++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 1112cc39153c..3e578df36cc5 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -252,4 +252,28 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 		io_napi_blocking_busy_loop(ctx, iowq);
 }
 
+/*
+ * io_napi_sqpoll_busy_poll() - busy poll loop for sqpoll
+ * @ctx: pointer to io-uring context structure
+ *
+ * Splice of the napi list and execute the napi busy poll loop.
+ */
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
+{
+	LIST_HEAD(napi_list);
+	bool is_stale = false;
+
+	if (!READ_ONCE(ctx->napi_busy_poll_to))
+		return 0;
+	if (list_empty_careful(&ctx->napi_list))
+		return 0;
+
+	rcu_read_lock();
+	is_stale = __io_napi_do_busy_loop(ctx, NULL);
+	rcu_read_unlock();
+
+	io_napi_remove_stale(ctx, is_stale);
+	return 1;
+}
+
 #endif
diff --git a/io_uring/napi.h b/io_uring/napi.h
index be8aa8ee32d9..b6d6243fc7fe 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -17,6 +17,7 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, struct timespec64 *ts);
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
 
 static inline bool io_napi(struct io_ring_ctx *ctx)
 {
@@ -83,7 +84,10 @@ static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
 				     struct io_wait_queue *iowq)
 {
 }
-
+static inline int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
+{
+	return 0;
+}
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 #endif
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 28bf0e085d31..f3979cacda13 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -15,6 +15,7 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "napi.h"
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
@@ -194,6 +195,9 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
+		if (io_napi(ctx))
+			ret += io_napi_sqpoll_busy_poll(ctx);
+
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
-- 
2.43.0


