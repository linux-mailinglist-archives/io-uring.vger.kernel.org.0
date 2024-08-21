Return-Path: <io-uring+bounces-2869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CAB2959F90
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 16:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF7F8B214F3
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 14:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5A51AF4ED;
	Wed, 21 Aug 2024 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bUIWAngH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4B21AF4D2
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724249958; cv=none; b=H1HePLsD+yKmVTW0NZFhqnQHPrLVBW4HKSsDw2OSWvJUjawNvN8V9NUowuzgHy28HiLd2mep9O39uuaQ0qsPFfttq1FuKVb3ufSjdpubZLFCr7BIiV0IKlA7QqkXxEgmoJeRJqg4cZWufhbgmVLYhw/dbC3xUrNegISJP0M1yAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724249958; c=relaxed/simple;
	bh=xMoc4My7QZ8jZ5RQ5B8Hxyx6CrgWlRJp/Q9mFmCwZGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceh6nq8WUMl7s4/tEHnPgLILE5jaQm3CsTapiCIcPhFI7siNUGsUDQkmH8wy2sJI9QSQp+oKTesOO9b/frgkdNgJtfItkO6E5ocGg0RWjk69tB2ofboGHL74boT7Mfoaw/siOZUD2M53fEnANgMmtbzugxAegGhxwXSKfDAWtQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bUIWAngH; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-39d3cd4fa49so3025395ab.1
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 07:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724249953; x=1724854753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A6LTIh3DcVfrLOVFkRBBopt0cmnN3QyNN9FFhzOKYYo=;
        b=bUIWAngHGY0+adtTvpg0QQLsZfKdZD3u7EJl+4os4QJvFJqGvd2S16YscpVA6AGo5j
         UCto7bOHZg/Eeoggi84cxZouSEZuTRmjBwhol7I2nBNIH8RmMQ2RXpQJbvLWoWMPLmDk
         WVWyJCIRYX4aKY2nJ2RHJs1Kxz/yXSE+sMT/cKXxvcxq3fYVR4oUBYFkbIWX0Lqef2No
         iSA0BxFs0c8rwkZ5Q3Ybpu2220UM6WnLNqZ7iwlmPOY/L2VaDFWU1Ev/E9QyTxZZDiYL
         Ws2nRBBvWXLip5UbU+2akpBppDIX9ySbFFKvhHISNa7KIJ2xK7nA4zgkJkNmqyqKpDIR
         mBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724249953; x=1724854753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A6LTIh3DcVfrLOVFkRBBopt0cmnN3QyNN9FFhzOKYYo=;
        b=TUmmoik5ROgKQQKY6dI2NkipSEYECxph96N0f6iJh7/NV03eUg8P9xN0GlufMykSS/
         h7j/anS+XzouBVAnutC1yuEiQTz7rLg7z24muZAJ6A/5TUaLT7g4+3m89ANjJPwXav6c
         +66v9aQiGwPx8PCrdmPuhwJSx7fzCBx2vZ/FMtfRin/YZdf0/jc42Ah10OlPw4Q1VJe1
         z7lgAmd+tMIQ7fX4IrbLNHOJX0Tw5EhRjg88RwHyLCfPArSFXm5r+jGJWDYxUI/tuPoH
         WsxB4CqaYMbMQrqSn7PldzPEgAAWU1Rq1gRNyADO3T1tdYsMUFa5cc7UCyzWLZC2NRYu
         Xz8w==
X-Gm-Message-State: AOJu0Yx2oGssVq2hYp1Me95D8BbWHqNlghlysiPsy0jHK7S8p1w1Wvr+
	bGhd9O8E9eluvKgstdgLr1qEHyk1atFo3WJen8JIMWsKGHl91EZ6EVtLZmTdRVj/4QB46BnfLnI
	m
X-Google-Smtp-Source: AGHT+IHYoxO7kjfbBsDXbVUJLAGr5MmQ4Afq5NyUBt5LDoVdknrp46HPripSzP2q2zbjiy7addY1QQ==
X-Received: by 2002:a05:6e02:152b:b0:39d:2e6f:bb19 with SMTP id e9e14a558f8ab-39d6c3c0e6cmr18502195ab.10.1724249953467;
        Wed, 21 Aug 2024 07:19:13 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1eb0bc93sm50967285ab.19.2024.08.21.07.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:19:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: encapsulate extraneous wait flags into a separate struct
Date: Wed, 21 Aug 2024 08:16:22 -0600
Message-ID: <20240821141910.204660-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240821141910.204660-1-axboe@kernel.dk>
References: <20240821141910.204660-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than need to pass in 2 or 3 separate arguments, add a struct
to encapsulate the timeout and sigset_t parts of waiting. In preparation
for adding another argument for waiting.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20229e72b65c..37053d32c668 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2384,13 +2384,18 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+struct ext_arg {
+	size_t argsz;
+	struct __kernel_timespec __user *ts;
+	const sigset_t __user *sig;
+};
+
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
  */
 static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
-			  const sigset_t __user *sig, size_t sigsz,
-			  struct __kernel_timespec __user *uts)
+			  struct ext_arg *ext_arg)
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
@@ -2415,10 +2420,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.timeout = KTIME_MAX;
 
-	if (uts) {
+	if (ext_arg->ts) {
 		struct timespec64 ts;
 
-		if (get_timespec64(&ts, uts))
+		if (get_timespec64(&ts, ext_arg->ts))
 			return -EFAULT;
 
 		iowq.timeout = timespec64_to_ktime(ts);
@@ -2426,14 +2431,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
 	}
 
-	if (sig) {
+	if (ext_arg->sig) {
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
-			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
-						      sigsz);
+			ret = set_compat_user_sigmask((const compat_sigset_t __user *)ext_arg->sig,
+						      ext_arg->argsz);
 		else
 #endif
-			ret = set_user_sigmask(sig, sigsz);
+			ret = set_user_sigmask(ext_arg->sig, ext_arg->argsz);
 
 		if (ret)
 			return ret;
@@ -3112,9 +3117,8 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 	return 0;
 }
 
-static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
-			  struct __kernel_timespec __user **ts,
-			  const sigset_t __user **sig)
+static int io_get_ext_arg(unsigned flags, const void __user *argp,
+			  struct ext_arg *ext_arg)
 {
 	struct io_uring_getevents_arg arg;
 
@@ -3123,8 +3127,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 	 * is just a pointer to the sigset_t.
 	 */
 	if (!(flags & IORING_ENTER_EXT_ARG)) {
-		*sig = (const sigset_t __user *) argp;
-		*ts = NULL;
+		ext_arg->sig = (const sigset_t __user *) argp;
+		ext_arg->ts = NULL;
 		return 0;
 	}
 
@@ -3132,15 +3136,15 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 	 * EXT_ARG is set - ensure we agree on the size of it and copy in our
 	 * timespec and sigset_t pointers if good.
 	 */
-	if (*argsz != sizeof(arg))
+	if (ext_arg->argsz != sizeof(arg))
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
 	if (arg.pad)
 		return -EINVAL;
-	*sig = u64_to_user_ptr(arg.sigmask);
-	*argsz = arg.sigmask_sz;
-	*ts = u64_to_user_ptr(arg.ts);
+	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
+	ext_arg->argsz = arg.sigmask_sz;
+	ext_arg->ts = u64_to_user_ptr(arg.ts);
 	return 0;
 }
 
@@ -3246,15 +3250,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			}
 			mutex_unlock(&ctx->uring_lock);
 		} else {
-			const sigset_t __user *sig;
-			struct __kernel_timespec __user *ts;
+			struct ext_arg ext_arg = { .argsz = argsz };
 
-			ret2 = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
+			ret2 = io_get_ext_arg(flags, argp, &ext_arg);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
 				ret2 = io_cqring_wait(ctx, min_complete, flags,
-						      sig, argsz, ts);
+						      &ext_arg);
 			}
 		}
 
-- 
2.43.0


