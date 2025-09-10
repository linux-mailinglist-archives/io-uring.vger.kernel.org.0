Return-Path: <io-uring+bounces-9708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F7AFB51E07
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 18:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72F103BB04E
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 16:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A786F24BD04;
	Wed, 10 Sep 2025 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IoQ4JRlm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28160262FD4
	for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757522520; cv=none; b=O6L6nXRrY/aTZZ+dOeLruLmQrO6/d9BkWB6PUBzQPUMN1RHlI9Prt0SiIpUl+7r3h8QezRi4BV8wCNB3nKv3mVUHxTDBw1hXuGRZS/ykP2UWIK5rhOdlJyouwLu7HLa9kwx7VZK/waojoJ7oJ94AvDFKw09lhD9U4nQ48dtlWdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757522520; c=relaxed/simple;
	bh=jCVPR7IIZ5PZU5YxcnpeJ5AKfIC5Y+HQRlKQja3QNzo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=PhjPNkuaoA5YPa9ueBMo/40tz2r2XjTE1es3BhAWoRbXwPiQfwae5/8nMcFOGxUVkjVT14N8MylWgXjcJxgzllwKFF/i/rgbpAcLIJ7V7eFpvo785oZD9MMCSDGwKkAdHZjRlaSpkCUxIvm7M8m1bJICIkoStl1lqQGfM/p/tYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IoQ4JRlm; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-88432e27c77so181433039f.2
        for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 09:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757522518; x=1758127318; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yICo4ElbHn2+SNj/OLGM5GPFFm1s1aMoBbbtPb8poAA=;
        b=IoQ4JRlmByZoaF+0m6bR3yfuffCNBO/fkHZmsjzahxhPcxrZUpUGEAfWGkd6k/9jWK
         4MOn0+KIkvIOIY8EmZFnOU0Y3P38AdwYGOWPqg8v5s2bGJKEBIdUyL3pP07Ik6ABQET+
         flM4vopK4gE4xQwQGjNIBhlR0RSxf+BSw2tfZoapTWh0CdE5Xo4zUh5u/uvHJ50zpZ17
         kCTn4nIdZgZxbRnEyFM61WHLFr8PmpCoiazVzg0/C1dr21liYq1FOsJCsQ/G891ExQgZ
         uR2bC0vEB2LPrPbxGfsIYHnYqGPYwUpqTGL99kST0VtfgXYiHmsVLsxGo0rS4iq0fhpZ
         q66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757522518; x=1758127318;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yICo4ElbHn2+SNj/OLGM5GPFFm1s1aMoBbbtPb8poAA=;
        b=LDkuuN9I9sIYnaR6Tdz6Ma+c481osvdLXqbX4+0zaA3QyZXtDaGXgx/+HdiBbT0Urv
         +q9F5uPVtPHJ9XeydLU1hgCCaGA4vAPQ9ztiE29FfJgM5Rck9O9l8pVsxVGzJ6T4qrsz
         dS+qJAObZJXhOOeGsTu+BJ4cyjoMqDcQTNUoRDa/hSSM1jpRVW2UKPRsqf7t1QUmeQmV
         H6Xv+inJU3cm8YeB/i0EmpVBz4RtVYQIRSjfBTwMq0pmvgqKIj5WbvOzed/37V6qur/L
         RIPmBlXawdxQu5r9EKVK+/K+ysiDh2cySYF8sobExFtz65bOOGGCZ35LQnnoractO50J
         MxbQ==
X-Gm-Message-State: AOJu0Yy1HrungHBxK8qrKwpF7S47ZcyyWmnCbdTzHyLO8pcyfeqTOwKB
	Zjrk9vMvtQha9Vgz1y6f1gstullGNEF1VvxIR5uCL+SuAMmK1ZKRs+6SLCvGYUqTAtN8mSmr9mb
	jYt1M
X-Gm-Gg: ASbGncu5OBGPPhysXoBdhOh5YOi2OZzZx805IiFkBRgtAPH+aaaAg4GKTh+R2bGYCJM
	ncaKD1Ec6GlFSaf/acKCKkPRd6URvTjdxD6kXe4wG14ILPenQsu6Wv9+eZBwjIoWJ25iyLjsxAW
	f89wjBi1AlTe5aDfiPz2Ombe6d5PNAHMkOSrR3z64NkposfAoeC60mjD7VFMypBeErx8hOUorrk
	NIZ/3u1dPoC9MvtSPEeL6GM0GQM8VusmQPaOzeTHAvc6popiqtzYrdjPC14JGSfmTL0foviPx5L
	VnJZaA2ttAklEmXRmaA5Q2fceTB9xng7MJKRbhHjM98KoMz/BctqERsGk8QV9FP1Tvtkq/6gIRv
	d8/B7+nARW1PuIGyktlZmBf+pT2LwnA==
X-Google-Smtp-Source: AGHT+IFGFvzvtCqhSXd0UndmI89z8Jclfmgma9LGRxFKO2yANdzCqCgRX9DUR9brGoxplemghDvNJw==
X-Received: by 2002:a05:6e02:450a:10b0:3fd:b143:a031 with SMTP id e9e14a558f8ab-3fdb143a1b1mr205017255ab.31.1757522517933;
        Wed, 10 Sep 2025 09:41:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-416f1e96f04sm10272235ab.46.2025.09.10.09.41.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 09:41:57 -0700 (PDT)
Message-ID: <f2ab91d9-0d62-4bae-8efc-aece69d407d7@kernel.dk>
Date: Wed, 10 Sep 2025 10:41:56 -0600
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
Subject: [PATCH for-next] io_uring: correct size of overflow CQE calculation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If a 32b CQE is required, don't double the size of the overflow struct,
just add the size of the io_uring_cqe addition that is needed. This
avoids allocating too much memory, as the io_overflow_cqe size includes
the list member required to queue them too.

Fixes: e26dca67fde1 ("io_uring: add support for IORING_SETUP_CQE_MIXED")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6d62f10416eb..1bfa124565f7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -756,7 +756,7 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 
 	if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32) {
 		is_cqe32 = true;
-		ocq_size <<= 1;
+		ocq_size += sizeof(struct io_uring_cqe);
 	}
 
 	ocqe = kzalloc(ocq_size, gfp | __GFP_ACCOUNT);

-- 
Jens Axboe


