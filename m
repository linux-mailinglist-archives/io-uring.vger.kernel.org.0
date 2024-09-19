Return-Path: <io-uring+bounces-3235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0350C97CD6E
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 20:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A31EB22D3F
	for <lists+io-uring@lfdr.de>; Thu, 19 Sep 2024 18:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783891802E;
	Thu, 19 Sep 2024 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vGpLY7sS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB0B17545
	for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 18:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726768998; cv=none; b=TkgBYyHJsrIWwlxAf5kLWN22Utx+uiMNF4/tB2nkPih8pUj+IQ82dDvkbgGubEaDQ+33oGREn6WXYeOPwxh/3RUHaEbFQqYAVPzROVlIMQIahReIDdOwn4+PMKy7WoIZ8SkaC80pX2K+S4aSfYCf5wg+2EsaWVy5/IAJlhkk3MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726768998; c=relaxed/simple;
	bh=YxMn/On2UXA48+wkAYzuZQfXdSFwLBYn3zCTqV4Qy7o=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=Oa5l2rusT3uYMR2qtVXgImAQIU4GJmcxL1yr7qMSQ1xC5GZd+UU+Tpv2b4VVxiYlCzj4vy63DvSpYjxspVwymLfv0UGxm/ZTZluNNOB9R+ChH7mttYuZF0fCWRnwz4y2KFNWgMTl1loXqyEvRj8HUQMzFJawyrSbu1G4CtxCKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vGpLY7sS; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8d446adf6eso156374266b.2
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726768992; x=1727373792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXVRfT+yoZythaSvBsmhrTBDMrMoPuo75euumhLOVXI=;
        b=vGpLY7sSIn+eYRGp8wbYTvxFsIiGVX433sa83sd/DD3bqdAg3opKO1G0r1V2xlivQu
         3uJpD77E564JPalV4D5lim71+B7ORUYgWiypXbswisCmRbiZ7RGOVVX0pHgXmOGJG3qF
         /aVlZm1DbDqYZwDWTFTUZ/gYRuOiZCaYLl4HrNPAgsXLYIgZKdXN9COcqFzDYhTO2UJ9
         Hs4My1DAddKbfaXms6HxJfBdDqq5xV5XN4LaN8w7N8MeQR/Ps7KWKfJ3+5qDFfYjAdBw
         gt07JczspR7LNg4XbcfhtdjQV9BTgGBUWdcA0vYqD+E/1aWldDJ8DZ4fNSWJC+tvpzsR
         SUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726768992; x=1727373792;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SXVRfT+yoZythaSvBsmhrTBDMrMoPuo75euumhLOVXI=;
        b=Kfy3aSVpnvfsaCClUYUSG23UsyQNNBjXQE7kYfBSSFr0KFTn0Q1ek5+fPmoSxOEj1a
         Hw70hMs+GEY6JE7U5OpSegzBMPXqaoIOMRUDJvCo/eZoP7ctGmly3dHND1HPIPWIYddr
         qhv4DtzA+w3jgGIuw9SQlVOnPP/AwBXJ4+heOoyY00Rc4m7rndxNCAt4q54PuwOkCgyD
         /QcAGOQ/tWjME0/5XPnBNmG8T/DpW759pDGL+p053NTnDBf4zdK7XSA2p67KmYqyFKDO
         dPl6rU//M7AAYwLQK+M01nkbHsAY5NCA4NETPI4/kMPKduK5/sQSnu3yeK4+VKRdSR89
         iVhg==
X-Gm-Message-State: AOJu0YxqziRt9n0K6/uU3pw2oidaOfFvzg2upzGGj0e+cRz/QlCA4BhK
	LJdCE06XZ0V49ACmZA3LHm1hSUbQ3Ptg/2cRYi54rJfRAh+R395uytaxorAEqnf+MNE7eOsKNdV
	kiPeJRg==
X-Google-Smtp-Source: AGHT+IEM/4uE3j/HTkZmRixMFt76i6jtwI1ZRg67UAR24T9dRPHtk3ksIHoIwaiyxa3ooxdq9VtqYw==
X-Received: by 2002:a17:907:d59c:b0:a86:799d:f8d1 with SMTP id a640c23a62f3a-a90d50d1160mr5291266b.47.1726768991667;
        Thu, 19 Sep 2024 11:03:11 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90613315d8sm749659866b.214.2024.09.19.11.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 11:03:10 -0700 (PDT)
Message-ID: <466da1fb-afc7-4e1c-b59f-010f31f757b5@kernel.dk>
Date: Thu, 19 Sep 2024 12:03:10 -0600
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
Subject: [PATCH v2] io_uring: check for presence of task_work rather than
 TIF_NOTIFY_SIGNAL
Cc: Jan Hendrik Farr <kernel@jfarr.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If some part of the kernel adds task_work that needs executing, in terms
of signaling it'll generally use TWA_SIGNAL or TWA_RESUME. Those two
directly translate to TIF_NOTIFY_SIGNAL or TIF_NOTIFY_RESUME, and can
be used for a variety of use case outside of task_work.

However, io_cqring_wait_schedule() only tests explicitly for
TIF_NOTIFY_SIGNAL. This means it can miss if task_work got added for
the task, but used a different kind of signaling mechanism (or none at
all). Normally this doesn't matter as any task_work will be run once
the task exits to userspace, except if:

1) The ring is setup with DEFER_TASKRUN
2) The local work item may generate normal task_work

For condition 2, this can happen when closing a file and it's the final
put of that file, for example. This can cause stalls where a task is
waiting to make progress inside io_cqring_wait(), but there's nothing else
that will wake it up. Hence change the "should we schedule or loop around"
check to check for the presence of task_work explicitly, rather than just
TIF_NOTIFY_SIGNAL as the mechanism. While in there, also change the
ordering of what type of task_work first in terms of ordering, to both
make it consistent with other task_work runs in io_uring, but also to
better handle the case of defer task_work generating normal task_work,
like in the above example.

Reported-by: Jan Hendrik Farr <kernel@jfarr.cc>
Link: https://github.com/axboe/liburing/issues/1235
Cc: stable@vger.kernel.org
Fixes: 846072f16eed ("io_uring: mimimise io_cqring_wait_schedule")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2:
	- Improve commit message
	- In addition to re-ordering the task_work type runs, change
	  the io_cqring_wait_schedule() check to explicitly check
	  for the presence of task_work rather than the notification
	  method.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1aca501efaf6..11c455b638a2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2461,7 +2461,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return 1;
 	if (unlikely(!llist_empty(&ctx->work_llist)))
 		return 1;
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
+	if (unlikely(task_work_pending(current)))
 		return 1;
 	if (unlikely(task_sigpending(current)))
 		return -EINTR;
@@ -2568,9 +2568,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		 * If we got woken because of task_work being processed, run it
 		 * now rather than let the caller do another wait loop.
 		 */
-		io_run_task_work();
 		if (!llist_empty(&ctx->work_llist))
 			io_run_local_work(ctx, nr_wait);
+		io_run_task_work();
 
 		/*
 		 * Non-local task_work will be run on exit to userspace, but

-- 
Jens Axboe


