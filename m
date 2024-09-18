Return-Path: <io-uring+bounces-3229-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB73A97BFF5
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 20:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47AE0B212BF
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 18:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50FEC17C98E;
	Wed, 18 Sep 2024 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C5Kfwxog"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67F21898E0
	for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 18:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726682594; cv=none; b=OzrVxERDREspafaFMV6zApnWauJl+SQb1IH9fmm8JL1DVQ4IwjUuBdAhSPjrsRuPM6vEMBM8V0HcavK1jQRDpZDi3hcDJu1Bzcsdtsc/z7rzBK/RjXowdJafMTPX5FU6xMubSFtyaAavKBVWPrO3DmvyZeY7y5r85E4suYc9orw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726682594; c=relaxed/simple;
	bh=woMyOS6rWIHEWNHmgVgv2Yg593RDiNG3ZPWOzswcgqE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=X+dfFAlvSeYM8klTqPUYu0Y6TAsLFl/SBE0eJ6YFi2SpGVB1cX5OEAYTmgtcImvMoPFdabNHFir6glaYp9WWaBg3iQ51OyXJjO1LsmeQQfe7tVj0s8nxZhqjXl77i2x2nhgXCNhq1pyLAXT9XUHi7txP6dJab4jsN38dfaVVt0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C5Kfwxog; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c4226a56a8so7034055a12.2
        for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 11:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726682588; x=1727287388; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16zNGW3/o+08dw9iIqmKJWHomta8NQVMJ/qTJkMt4Dg=;
        b=C5KfwxogGNizwF9ukh/qcHwdJg/IcjmLDi4VD6E02ez2C92M+LSUYJXXnRAdMLeVcN
         Z+ZCcC1Vx48UBwKJzQJdtYfx2FXUY23Lk2JXwvdeIhKAVRDqgG3wOLmAc57bajkY8m+g
         j33mT2j6YrA03S1tGt8SmV5yixqssPcYKuBQURvGXNsADkX1ygN6PoTrk1rVcSaItmf/
         pSZMwaCvBJXmB8pXMp9vbWP9diJ3PhnY5LuOeKNvhdyay61Bt4iP7HjoaORIk8q8GEZg
         6Jzf9VTnuz65SfVhYQa+WiE4wjLDw4UB2oHFBL37MaEwO9EXSfafPzalCfjxs4WVqQ8p
         FLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726682588; x=1727287388;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=16zNGW3/o+08dw9iIqmKJWHomta8NQVMJ/qTJkMt4Dg=;
        b=unKeFcc3v1XBpZsu7l6PmJJe9klvXdAV32pyNW2wpB+QoMB/LAZXcKwhGf2P6TwVRw
         0JzjSW3WDLd3GdpbvrdqroxVMIcAPxPX2a7pNZKJ8HzAXU7pWWAhC/uj/c8rCsnwzCX2
         rDdEMY48D39RRzxjTix0Xy6SdHm7y6P8hhlPSGwNFb6ormStvOUYBCc5ssaLXagebWfd
         6Yf5uA2q6LYNa/N+ZxaTNAVEKYkql9cprj3p+IzhHqLRBwKn7QS+6dkl6EwwbZFfV8m8
         jOjQT7rjnFzbWZYSLo+Dn9Zqn9P/yss7GlThM+x/Jzp4OmoaRJY+TQI4HIOY9BHbLUef
         kKwg==
X-Gm-Message-State: AOJu0Yw8xvZ008nvJBWZRQS26RwV8tF16BorRW5vqsNBj8CXIA6BlTPK
	rRGPuBCjhaFfQV0vkW2Jd2eGYlxWBSkRnXd/nAAiv2l1FOuJK7AjBOW+fBQRbNW7W4oGyHaXm+A
	XDauuuA==
X-Google-Smtp-Source: AGHT+IFLqdl7H+uleF9AgNQoHqgpwrpixUgd+njAnQL5BI5rjzwch+cD0fQnMPkse8GJVKnVCsk+uw==
X-Received: by 2002:a17:907:e686:b0:a8d:75ab:17ca with SMTP id a640c23a62f3a-a902949a224mr2218621666b.31.1726682587701;
        Wed, 18 Sep 2024 11:03:07 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610966d7sm617940566b.39.2024.09.18.11.03.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 11:03:07 -0700 (PDT)
Message-ID: <8e3894e3-2609-4233-83df-1633fba7d4dd@kernel.dk>
Date: Wed, 18 Sep 2024 12:03:06 -0600
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
Subject: [PATCH] io_uring: run normal task_work AFTER local work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_cqring_wait() doesn't run normal task_work after the local work, and
it's the only location to do it in that order. Normally this doesn't
matter, except if:

1) The ring is setup with DEFER_TASKRUN
2) The local work item may generate normal task_work

For condition 2, this can happen when closing a file and it's the final
put of that file, for example. This can cause stalls where a task is
waiting to make progress, but there's nothing else that will wake it up.

Link: https://github.com/axboe/liburing/issues/1235
Cc: stable@vger.kernel.org
Fixes: 846072f16eed ("io_uring: mimimise io_cqring_wait_schedule")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1aca501efaf6..d6a2cd351525 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
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


