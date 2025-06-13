Return-Path: <io-uring+bounces-8341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEFCAD9757
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 23:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D3E54A29DF
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 21:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC8528D8C2;
	Fri, 13 Jun 2025 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i714X6y3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5A82397A4
	for <io-uring@vger.kernel.org>; Fri, 13 Jun 2025 21:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749850040; cv=none; b=PgiloO4JRHymBXYlIAoD1zcuYpWovJ+gl+YpZ79QDp14Kq1Q68IoKn5paLBM44xDhPv6z47/8mI8NjRGgalf3jq9Ub4jIFp93L+uqT1wmcz5Vb4ZeEQR9ptksjtvKJVPulo4F6u9PCw9LW8MYs2nS9BkjAmoWWaiMZbBtPPVkP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749850040; c=relaxed/simple;
	bh=/rtsZiKqh+BpEeT3ur5yak++W7lzYJSvPK4rtp6+lHc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=KC51kdS1IRKoG7a8rYymp5KiqZqpTMuqloRQw6SqpeXyb2g2nWWLX8Os/jEQMuBtHAD3HCETaXiEjgdpjTayvPekYRPlCFsAsCjB39RvFDyczEoiwd0X2GHEAKf5oVw6c53D+b5GmlU1H+/spHA1YtzlHTNirHWJbFs1Gzm8jn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i714X6y3; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86d0bd7ebb5so81876639f.0
        for <io-uring@vger.kernel.org>; Fri, 13 Jun 2025 14:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749850034; x=1750454834; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBoWRqg97MB7VhThzx45udnvKyBLOOHIFI41B/WCaw0=;
        b=i714X6y3akpTbBVj561NwUQpxcAnbDf6L4luxEbMx+QJSpi7Us5GnLfuUi8KDWupyl
         oqwfo2RG1Dkn8QjnjCYQfirRj5cH7T6ZCjAIytBjxKZ5Nq5AyMwRUNWsWhON5Liym4yd
         /GiMbhkMam9OgIHLE9JZhL0IqEpG9F3W/ucZDwi6Lfc7D6ABqx8LbMkog3rK4swphs6s
         uUZ9QlQqF2e42uZOQeR4EdntLDxaD2MK6eyDfiryrr2xWpkAKMhfHf9S9TkAs4s3/SvR
         rDqeZaC2OZOIAhydgyGYT+R86OME5UsLLQsWgaE1MHdA+zCF08GpDrqzjhOmxtrOq87z
         UTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749850034; x=1750454834;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HBoWRqg97MB7VhThzx45udnvKyBLOOHIFI41B/WCaw0=;
        b=iI389hpbQb6n36vbDZdo29MY+XskRDrvCAsws/ojaqtMad8x1f8kAUNVVrDxFTmOpv
         9A1KnibsddxKjSZa7cQBWlfzIdxmOC43fCwdJbOCQAU6M7Io21F6dE5UQuIYmiS8nd5y
         O3Z6TBoEVAwrnSU9bBNoPXJQl1eDUC3F2eQs4OkozTCmtZJUWowF3FsnU5l+P0Wb0aDh
         bKN17d9QkVEKyv3XuPFTSDKaNwEXXn0Xa4VLbMh8132i8qxl07zYKM8qw48YFDemjQi0
         MkTnsr6bYN57HZpQM0m6tY97rncrevivBcN3hDoW4Yi1O8UnLS4ehocm6SI0RYIgw1l5
         eqyg==
X-Gm-Message-State: AOJu0YxsVQ1AM8TDfYcmdPc/ZBbjiTizZeUGC0UnQWw+mv+ju8ZZ3Ou0
	Ujwx4vaA9Dr+vn6kNtGOchjMt7i87nO7Fm3k5T7IXmYo88nrAWeJC/lFrzxJOK4NlJqJ2L+paf6
	qU/9n
X-Gm-Gg: ASbGnctFBWjzPwcUE6fy2HBY+uk+FHoyqOYd0UhefnFoZlzzQ+kDt6nbrorx2LNTwj4
	wtcM9Qy3+vuNKo8qQLDcOlBPh6esKabkQQ25ZrzzIXXAbrW8H42fo24zKxaigYKrd6AOMaQvPn1
	cimmN/lmirleTEWeTr4D0dkG22dBAfabdPgyoxjqtd8rQGCa7qLZBillEKXSAfzuOz76MjtJeYz
	+cJXuj7bexV+yWWjqQY+wuCqlarmowavtZw8Mpgc4Oija0LuZp+SZ6J9CLa1H4hA51vHpbVd0+c
	jD/r4FvVuqxPr8fzpAEua8xdG5ckJLhPN60ntTjjUGemfbY2049zPP2dFQU=
X-Google-Smtp-Source: AGHT+IHvmYEYN8iR5w6U9dLU1nqmm9ICzQZToG64iJHA77i5ZHMNo1CBx0XS2EPkMnVTEPzoJVylOw==
X-Received: by 2002:a05:6602:6ccd:b0:873:1a0e:a496 with SMTP id ca18e2360f4ac-875dedcce16mr103635939f.10.1749850034216;
        Fri, 13 Jun 2025 14:27:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875dbfd06c2sm28724339f.0.2025.06.13.14.27.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 14:27:13 -0700 (PDT)
Message-ID: <8c6f00c7-443c-4e24-8e4e-ed3b6e98065e@kernel.dk>
Date: Fri, 13 Jun 2025 15:27:12 -0600
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
Subject: [PATCH] io_uring: run local task_work from ring exit IOPOLL reaping
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In preparation for needing to shift NVMe passthrough to always use
task_work for polled IO completions, ensure that those are suitably
run at exit time. See commit:

9ce6c9875f3e ("nvme: always punt polled uring_cmd end_io work to task_work")

for details on why that is necessary.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4e32f808d07d..5111ec040c53 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1523,6 +1523,9 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		}
 	}
 	mutex_unlock(&ctx->uring_lock);
+
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		io_move_task_work_from_local(ctx);
 }
 
 static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)

-- 
Jens Axboe


