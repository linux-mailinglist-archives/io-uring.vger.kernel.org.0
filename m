Return-Path: <io-uring+bounces-2082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6349A8D8AAD
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 22:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B5882810F1
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 20:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A930B3F9EC;
	Mon,  3 Jun 2024 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="svY0nSEa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B7246A4
	for <io-uring@vger.kernel.org>; Mon,  3 Jun 2024 20:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444871; cv=none; b=G7DHEQ5+sQx8b2dxcJJZfACt1Pxxe822V2iBT8fLaPXn8Aue5XrfSiI1oeOVqpxH7QR28J12wyoCnA/8f1r/7tWZWVzInNfcRnlc2760VXsips3EwYuSqowk2ipVwwDwNjGr5Exij2UAnVd/auk/BrukFeJZINecuueBzCcmqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444871; c=relaxed/simple;
	bh=SnzdjsNmn1/HjJ+xsXFSLtJPQTa078gCsoklUNrfFqw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=D0V349ZuGdi/uX0/vJlnEreKFmLapoUNYfANtScFD3oIQvl3wmQaCqYa2PwBM8/wh5ACC0fqn+LcT7KnnBdgg/ymIcwSknyufG6GEy8D8Lowa573GcPceFoh5hyxRa4tfRff+wwLwqv9OkBsbgSgV3HNXgVx19YDY6u8Hru/jtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=svY0nSEa; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6f8efa3140dso151392a34.3
        for <io-uring@vger.kernel.org>; Mon, 03 Jun 2024 13:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717444863; x=1718049663; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPbPUlLWRVZkHsMcBI6EenjE9qpLowAJxWeE6lDTLA4=;
        b=svY0nSEa3fGE5cfQGcPd9S+PC8Ct7sT4rcq13iwCHSwfrVxA1ZTrEmqeL1u/xyUN7p
         t0x8FGdGlQnCiFm5FBfqAa2skvi9F4bDn0Pc4qPqw1TFeXgVO+fzfjI1RMaJ66X7zPih
         IOcgl3IqgNKcGrZxcjv7qmp5zMWaqbH5lx0nWcSkuAQ5R5JP0NlznG3gCKNJJBddKKOJ
         OOg1U52+PHph+OWonbj1PR0SooALQaMgUJFGVPWw+zPdjS3ow8gWj3+I03z9fS25b6BD
         kSFL+lSlKCYS9coeCWrWQa38u4JHEs4WRL4Yo4A/qBgmDWTz070HN+JasRlkG+e6XqGI
         81xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717444863; x=1718049663;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XPbPUlLWRVZkHsMcBI6EenjE9qpLowAJxWeE6lDTLA4=;
        b=gb2TwLAeIgYLcD3SepaOw1QMmV6iT01bvuvzQoD+aQdRqyWNWKe5YdyqdFtNPBOYme
         Vi1rot7bhUJQRjAVCPf7YJESEYIovfpdcLtwPqZbOiYhPtytsU3w62dVDCRCt/ICtQn9
         e2rRV6lgYWdWHUoA7ekt8AeTX8CGJ5Z1HRtsoB1G6onUz8rE6Fmz0nUhK8ogfvD85rrQ
         eW/pFj3kvNT2eqHOfEkcK5WVS4x10VOCh8skLGCVOiaOofzbJ5DvTFZFlhCSeKey9znp
         zjd6MDrEnY3MQrpO/E4HLe6uPLeZNPLwoSzSIe19lpuY5FSNJKEe5ybT2iAzjUrGC78h
         zMDQ==
X-Gm-Message-State: AOJu0Ywnz7EvXvzBTmfm2JUkQ8dYhjYuYkhK+WGLnYy9EZ0xovkpRXr6
	dcRktmpAILsibP9aHcjAVq+EebMn3jvqxoOpo59u6uyLZlhbxDPXGJmGXhCn50cVzSJocKWy4qF
	x
X-Google-Smtp-Source: AGHT+IEuwT8RvaCc9CZIFb9/8pA477tIWhRQn2uHcn/6z5AlCPIccwnxT8p25PX3srfNDLSOCKj/EQ==
X-Received: by 2002:a9d:3e4c:0:b0:6f0:e4d4:b57d with SMTP id 46e09a7af769-6f93815a1camr344443a34.1.1717444862566;
        Mon, 03 Jun 2024 13:01:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f9105a805bsm1573858a34.65.2024.06.03.13.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 13:01:02 -0700 (PDT)
Message-ID: <f8e7d8b2-82d0-438e-886e-2d81bc68924c@kernel.dk>
Date: Mon, 3 Jun 2024 14:01:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/napi: fix timeout calculation
Cc: Lewis Baker <lewissbaker@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Not quite sure what __io_napi_adjust_timeout() was attemping to do, it's
adjusting both the NAPI timeout and the general overall timeout, and
calculating a value that is never used. The overall timeout is a super
set of the NAPI timeout, and doesn't need adjusting. The only thing we
really need to care about is that the NAPI timeout doesn't exceed the
overall timeout. If a user asked for a timeout of eg 5 usec and NAPI
timeout is 10 usec, then we should not spin for 10 usec.

Hence the only case we need to care about is if the NAPI timeout is
larger than the overall timeout. If it is, cap the NAPI timeout at what
the overall timeout is.

Cc: stable@vger.kernel.org
Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Reported-by: Lewis Baker <lewissbaker@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 883a1a665907..804f6ba79ca9 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -261,12 +261,14 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 }
 
 /*
- * __io_napi_adjust_timeout() - Add napi id to the busy poll list
+ * __io_napi_adjust_timeout() - adjust busy loop timeout
  * @ctx: pointer to io-uring context structure
  * @iowq: pointer to io wait queue
  * @ts: pointer to timespec or NULL
  *
  * Adjust the busy loop timeout according to timespec and busy poll timeout.
+ * If the specified NAPI timeout is bigger than the wait timeout, then adjust
+ * the NAPI timeout accordingly.
  */
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
 			      struct timespec64 *ts)
@@ -274,16 +276,12 @@ void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iow
 	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);
 
 	if (ts) {
-		struct timespec64 poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+		struct timespec64 poll_to_ts;
 
-		if (timespec64_compare(ts, &poll_to_ts) > 0) {
-			*ts = timespec64_sub(*ts, poll_to_ts);
-		} else {
-			u64 to = timespec64_to_ns(ts);
-
-			do_div(to, 1000);
-			ts->tv_sec = 0;
-			ts->tv_nsec = 0;
+		poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+		if (timespec64_compare(ts, &poll_to_ts) < 0) {
+			poll_to = timespec64_to_ns(ts);
+			do_div(poll_to, 1000);
 		}
 	}
 
-- 
Jens Axboe


