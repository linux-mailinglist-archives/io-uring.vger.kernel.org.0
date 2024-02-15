Return-Path: <io-uring+bounces-612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 062C6857094
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 23:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA00C1F270A9
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 22:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179611E894;
	Thu, 15 Feb 2024 22:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mg8tCXII"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380601E4AE
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 22:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708036369; cv=none; b=MYCr14JrB0Oq66UgYjdws1p4IGeHLkJxbDaNcbWdoQfnib3XTBrNgtnnATzZkzKowf6qd3k7hjhoHpOKM9XA6LtI5XYbmMI37AZaUHYqvHImwHQoaJQ2BdDqavNmahWWjd2rnDsnL0ra2xYn+D8c8Db8e0wqrVBJQHZfQJUhPQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708036369; c=relaxed/simple;
	bh=z1VLrsgfFUE22BlbkRpysI4ZqUxIm9GxfAHxXD2Ktjs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=iycii5LMoDoMqm/5OjMDLzT65DjVp50leDGP7dt/A23R3clC2gvQa2llrLfuY8QlAxpaQFqDFGdy5bZyBUDKogK9Cn7mE1a13PoTFYFjcKICp30/sU41eDi4+prJJMcgKWopC9cxA58hneXJcvZbbu8UvMCOG9YUBbvziqOctNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mg8tCXII; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso13065039f.0
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 14:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708036363; x=1708641163; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dy08JPI8Fd2WLnvYl32SBC7oLiYs8SoB6hQY/rEcp1Q=;
        b=Mg8tCXII1Os8cxIGRww6rdqsAutyaNrrzrvTYoW9RSNBsjOINwe70ySGkZ442YKHSq
         UyOpER9lbi8qjA61mzYl3iOCi4rGCpBDDDn0ieyhsuUGMPuJPapm2lrVyZY6aNjz1UxQ
         kquGmHC492AEcxZ+DBJ+pajMINIOwJx8P7Ha4qUNCFN2tI4zOP0MleC+LIx93fGGe1Qd
         AN/ObqgzIktwQZcGuFQxs73O9glCEk8xo+9ba4ClvBckEmTQGG6snW1ultjfoW3ySl6C
         TVFT57TSktjApr5Kix+QSTunuxBjQ3IqVpKk0tBy45IWpXaRDeqAhlzZOxYtBH7XkdUF
         AZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708036363; x=1708641163;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dy08JPI8Fd2WLnvYl32SBC7oLiYs8SoB6hQY/rEcp1Q=;
        b=nIFENwIlRC+458c8r8yBt3bqfh75Uzkvdzm4kND8AMkmv5C4kqkA6IbAqXjRSUF/Ax
         LGRqytNrrjYADRDzUzPPnkEDias95dzbCBezSW9njuCAFffJkscBjswm1NO3lGKqNKRY
         xGuEZdHRTcT/UYJ6Vx6PdtVw/4eG9udsohDwHbiHX8v+oM+YkKFa5HsE6q655WF418V/
         qDENtCHuVbH56rYlnGdGEYfzcnRVXdstkqhpIBAYb26g5BXjQXmOojWEQV9G3fKERY8P
         VzPOOeyOHXhTZ2NbFvOB/TMhlaIlzz6yL+CqriRPNb8f4czMhN/gUBna5NSwagIQvkax
         ra/A==
X-Gm-Message-State: AOJu0YyiVbeV5u8rTDtaZUkzHAMTDArWsu2FozE2iPXz7p+k5vjtOAbC
	GUDon+nmckn0MXF3y5vNKO6p6DMOYcQTQ0v/VKgWdW4pfdIjrxa5PQDDeTtpdVMbkGOYN5Dj5QG
	X
X-Google-Smtp-Source: AGHT+IEhYvtPaBAbjSgC0MPq7D6MUOdZkGDhK44SSmhoi9KZRd4/il5tMym41zKk8ghLh1FBZOGG7A==
X-Received: by 2002:a05:6e02:12e8:b0:363:c919:eee3 with SMTP id l8-20020a056e0212e800b00363c919eee3mr569351iln.0.1708036363163;
        Thu, 15 Feb 2024 14:32:43 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u2-20020a92da82000000b00362902d6818sm93310iln.62.2024.02.15.14.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 14:32:42 -0800 (PST)
Message-ID: <c7210193-a850-465c-bee2-ade5b36b4e2d@kernel.dk>
Date: Thu, 15 Feb 2024 15:32:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>, David Wei <dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/napi: enable even with a timeout of 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

1 usec is not as short as it used to be, and it makes sense to allow 0
for a busy poll timeout - this means just do one loop to check if we
have anything available. Add a separate ->napi_enabled to check if napi
has been enabled or not.

While at it, move the writing of the ctx napi values after we've copied
the old values back to userspace. This ensures that if the call fails,
we'll be in the same state as we were before, rather than some
indeterminate state.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4fe7af8a4907..bd7071aeec5d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -420,6 +420,7 @@ struct io_ring_ctx {
 	/* napi busy poll default timeout */
 	unsigned int		napi_busy_poll_to;
 	bool			napi_prefer_busy_poll;
+	bool			napi_enabled;
 
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
diff --git a/io_uring/napi.c b/io_uring/napi.c
index b234adda7dfd..e653927a376e 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -227,12 +227,12 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)
 		return -EINVAL;
 
-	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
-	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
-
 	if (copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
+	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
+	WRITE_ONCE(ctx->napi_enabled, true);
 	return 0;
 }
 
@@ -256,6 +256,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 
 	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
+	WRITE_ONCE(ctx->napi_enabled, true);
 	return 0;
 }
 
@@ -300,7 +301,7 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 {
 	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
 
-	if (!(ctx->flags & IORING_SETUP_SQPOLL) && iowq->napi_busy_poll_to)
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) && ctx->napi_enabled)
 		io_napi_blocking_busy_loop(ctx, iowq);
 }
 
-- 
Jens Axboe


