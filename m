Return-Path: <io-uring+bounces-5857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB3FA10E27
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 18:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4528B1887FF2
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 17:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E8D1CB501;
	Tue, 14 Jan 2025 17:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1WKTnpll"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B08E1B2193
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736876957; cv=none; b=BMaLtvhiFwuW2d1kQeS0o53VTQsLQTqLFSkLBvnewppjPry26mPStYrLyUtFw0pL3u9gMH9BvSEk+tVkDJWKFgmJM39f41rdQ02AkdFTxG1DGpSl5YGtm1zdMSOnyzUxdB7Tlr6UdQ75RkABGLHoalHYsK3kWaG8/oaVVGcnEws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736876957; c=relaxed/simple;
	bh=+z7ZnXqzo+JwTlyzEMh+aCsl6hsl7DxqJLFJMsWnKp0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Ji1canmDkxnzkS0XAEV02Cbao2GS+WbtxfAr74lfqPkpdJ9xhGk8z87njM+P0GwHAtygJTDozj14O5+b8NbgNuXG/cw4lH0dFlNkIVlMrDgmHYvoKcFEo5g/rWJKSd1flJPx7/63l3gL3HSE7NLTlutJkno41m8/cpQip10qwTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1WKTnpll; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso69765e9.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 09:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736876954; x=1737481754; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/EhUj+Z89V6RZrUYPhJfVMhULBGhnCEDRDY/TBf0Dc=;
        b=1WKTnpllxHYy9OCIJZeUAvXCuCLQWGMUHrC2mkU10FGafHBRZnVpdxREume+4AkVzU
         UOWZAoxjSZZwd5jEa0uuUwZp4iXzlF7cGQL1fm0JX0Ar2N7a2iZO+BKRywd6QfpMyI9e
         NkphNXdhLBo8EVL5J8gegaDwIOkPgSRFa0Ia48U1ZMCjyUeOr2TJ4ini0P12HVVktzoe
         3nbtK4OulmZVg7OaOgfqhF8kH4y+Hu8ySGC5pb+L6vpYBPz3edVTBefzUD7EoB8zHr9O
         dWkdmg7hug1BiLJvJeb+kyMyYocQVm1h5uLsYft1L9SOLh6su4BeeiqQh0CbHvYzPX34
         4gag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736876954; x=1737481754;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/EhUj+Z89V6RZrUYPhJfVMhULBGhnCEDRDY/TBf0Dc=;
        b=J5dSuUrIpEP8c6Q4tkHKUaMcVs2lODuVipQwacWppwcPKc53fek5iSMMsznw4xji5Y
         HEqXejaiGPaMuPrzFcNG5cu7Sd7MVjpxE1lFKCd9jIEqGmDuqD7H6IoS3zA+bcxFAjcQ
         JWJ18fAz5nRwBI/nVM86U865vRZUPuIXlanUUSx399EXN7StdW9avmlCacHfoYovdPUG
         4bSGU9UVZN5FGBWgxQ3rF/c5hyRA/a4Xgz1yFU/egAD5bIPcdDERB1T3MZQmAGzPj1fx
         pzMce9pD7ut8FPFcK6syC6bCXm2RhgTr8Es7Q+jX6jQtzSlWJdQ9xzer5UTykZNpbD+r
         BFVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpAPQwHT0F7YkUwWqhxrK9DBuHBXQgZH2PrQTUvf3diLDuZKCEyesWukRF62z9ob6+rfS64ENxIA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9MzAjECaaIQJA31S87dYTZhEDKmZ8kd69aEqk2GRfkCVn7tGA
	RekcNU+UCJlwD5R14NlYLwi8n+MmCIvG9IoGUJrJTkQEc5y4RKb0CaVojAVnZg==
X-Gm-Gg: ASbGncvI+OKiF+bViAXyRUXv0cXH7b1tuU6YBT5aen35/DWGg5tLcEO2vKtdisHfvaK
	LkA7KwrM8mlZNtsm6J2VTEbEvKzDs1XRlmsptuPtbaLPIGFWB4cl5U/KMKVykR6PRVx49CZdqfn
	KKsgcJIsPuaQ1+dzKhfbf4e/EKCXcRon0xSmW2YElCydT8dnvt7tsuxNAlOuSeOqOmuMej+9JqU
	2K0C38yzZ5aZzgIkAPXfohqEs4zL4QzdXrBeMB1RDY5ZQ==
X-Google-Smtp-Source: AGHT+IHB5PEFMbygc74F/+oeDv4I6J+5PXKLGLeXGDUSZBKuRtqQ+Nu5FLfyHIAgxEZOSAQ6TxIaRQ==
X-Received: by 2002:a05:600c:1c26:b0:436:186e:13a6 with SMTP id 5b1f17b1804b1-437735f9974mr1504555e9.6.1736876953451;
        Tue, 14 Jan 2025 09:49:13 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:f0c9:ad9d:2327:39f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9d8fd03sm188665915e9.6.2025.01.14.09.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 09:49:12 -0800 (PST)
From: Jann Horn <jannh@google.com>
Date: Tue, 14 Jan 2025 18:49:00 +0100
Subject: [PATCH] io_uring/rsrc: require cloned buffers to share accounting
 contexts
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-uring-check-accounting-v1-1-42e4145aa743@google.com>
X-B4-Tracking: v=1; b=H4sIAIujhmcC/x2MWwqAIBAArxL7naC96yrRR22rLYGFVgTh3bM+Z
 2DmAU+OyUOXPODoYs+bjaDSBHAZrSHBc2TIZFZKpQpxOrZG4EK4ihFxO+3xiSIvK91MrcK8hhj
 vjjTf/7gfQngBZfYV3mgAAAA=
X-Change-ID: 20250114-uring-check-accounting-4356f8b91c37
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736876949; l=1948;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=+z7ZnXqzo+JwTlyzEMh+aCsl6hsl7DxqJLFJMsWnKp0=;
 b=rT6imj0L69M67jWPfzUa4j3r15LHqo9N/M1tgoPDIYs3PyYjjQaqkzUMEUM0rjLK+d71yUF7K
 VfBwaaiceztBH5kuBGGFABgLUxRisIXDO9iYv6BJm4AvG3e4CrZlc3M
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=

When IORING_REGISTER_CLONE_BUFFERS is used to clone buffers from uring
instance A to uring instance B, where A and B use different MMs for
accounting, the accounting can go wrong:
If uring instance A is closed before uring instance B, the pinned memory
counters for uring instance B will be decremented, even though the pinned
memory was originally accounted through uring instance A; so the MM of
uring instance B can end up with negative locked memory.

Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/r/CAG48ez1zez4bdhmeGLEFxtbFADY4Czn3CV0u9d_TMcbvRA01bg@mail.gmail.com
Fixes: 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS method")
Signed-off-by: Jann Horn <jannh@google.com>
---
To be clear, I think this is a very minor issue, feel free to take your
time landing it.

I put a stable marker on this, but I'm ambivalent about whether this
issue even warrants landing a fix in stable - feel free to remove the
Cc stable marker if you think it's unnecessary.
---
 io_uring/rsrc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 077f84684c18a0b3f5e622adb4978b6a00353b2f..caecc18dd5be03054ae46179bc0918887bf609a4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -931,6 +931,13 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	int i, ret, off, nr;
 	unsigned int nbufs;
 
+	/*
+	 * Accounting state is shared between the two rings; that only works if
+	 * both rings are accounted towards the same counters.
+	 */
+	if (ctx->user != src_ctx->user || ctx->mm_account != src_ctx->mm_account)
+		return -EINVAL;
+
 	/* if offsets are given, must have nr specified too */
 	if (!arg->nr && (arg->dst_off || arg->src_off))
 		return -EINVAL;

---
base-commit: c45323b7560ec87c37c729b703c86ee65f136d75
change-id: 20250114-uring-check-accounting-4356f8b91c37

-- 
Jann Horn <jannh@google.com>


