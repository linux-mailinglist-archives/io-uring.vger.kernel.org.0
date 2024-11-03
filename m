Return-Path: <io-uring+bounces-4365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B98E9BA74B
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 18:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F131A1F21538
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 17:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536C217BB1A;
	Sun,  3 Nov 2024 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OkSMzhpv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC71487C8
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656277; cv=none; b=m76ElinB/wM/qKuL4oBtgekPstmKt4kWnWuuo1CUsAxRqwdbP/SiEhVetv2pwqHvtZm19Dqh7i5rqGstoj57ljxlPuBbTtUNkkhjAM3Suvb0CcbGPlQilSI/To707Kl4j+lZ07u3SAOHBOAdaEVwiFnusZcOT5DDIOggLFlpamI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656277; c=relaxed/simple;
	bh=BOhmFQy9YCXBXWoCU3U85N2dQ5+tPrmHCA1u+9WAY5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMC4gGQ6C+z7Hjn8OgqNLihN/Cdg0sd0YTiCXpphdBFpMAanQhIEvIz1VxHq06v6O5+aIlPho6SE1FckaVkW3wgPssMvSeM6PMU5fnO3Pjhe/Im/3/Xcq9bcSp/RRgqOLWtsxYT4v8lFA+c+XYSb9/8/+tAnMagduJiPVyx59+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OkSMzhpv; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71e79f73aaeso2884549b3a.3
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 09:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730656274; x=1731261074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IKi1F1T+2whGV3YbG2GP9ZpQKIUMU9EZEp39uzeazqQ=;
        b=OkSMzhpvao/eDLzPmr9pl1i/NiKSvs1MWuSNIxp6MaqHwMmRy8z0v6aTfuU6wclqvs
         MXzuAPkFqqX3+x6S55dXr3tVW+9P987ItvgMbSNwRz0I7sO8uATVMqPgr4yQc1BQ7QHa
         FM7/W0A0wh005rT/HCIHm4NudhViHLfczDA+VYiaXexAhs83U2SYFMLhXX7U6QNAG29u
         n2V1I+cpBi3bo9cbkySZAeWvVMoZEdS/CbONz7D5r00OTYonFHx4J/O76N9Vpu4MHJoO
         ntvPLXSXdulv2LLyh71W8TwB+ynqb681fvyf+4PJqkEuFlmZfdsrh3Ox8ZOq+6RnVxaK
         cQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656274; x=1731261074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IKi1F1T+2whGV3YbG2GP9ZpQKIUMU9EZEp39uzeazqQ=;
        b=LWgQnVUd1BSkB2cgINxNTVsD3uZY8xX5sBSCLC9P1Srq/VQ+MN8am2yY+trcCofshO
         wlW6wpOwgbbghYzUprSZPNogJO9fwmNNdiwOoDLBWREljemT5ul1Tv5msmQYKPBEvhH9
         oZCIUdTxtNMY4P/eeimryGJibj9rxg5A5jjf+uF+zcRMZ2gqIHu4eEUTKNZbGtLlIzRs
         Y3602phrbJZgY/WHx8AIazk8RdAfi1aihpvM0lF7TQd/N8bZTK1BNiCGAE9kuApEvDQG
         F7w1DUePK6/bl5vkWMn6N/yT3IpqmyWVG2lj9lF3zAKtRR03vNdqeLyBe7idWjl4U83S
         hU6g==
X-Gm-Message-State: AOJu0YycIJwkv+zbE/XSHPRbfLV9RvkNmb3qYZ8HRMkn0Piv4LdDUGc+
	H/SQZeCBrJasSTC6mcXCEv1hRi28rUWgKYHef0gRApub1Jup+4CVWQRtmsJjHtiuA90EcKO2YUo
	B1zQ=
X-Google-Smtp-Source: AGHT+IEt/fGsq8iGGa22c8wrWo5IV3CHlj8x72U0kULzcAHtdWuGeSxx6vMqLFi5kmzHaiX7/O9tdQ==
X-Received: by 2002:a05:6a00:845:b0:71e:6e4a:507a with SMTP id d2e1a72fcca58-72062f4f6c2mr40223954b3a.3.1730656274621;
        Sun, 03 Nov 2024 09:51:14 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1ed4e6sm5875109b3a.80.2024.11.03.09.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 09:51:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: remove task ref helpers
Date: Sun,  3 Nov 2024 10:49:34 -0700
Message-ID: <20241103175108.76460-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241103175108.76460-1-axboe@kernel.dk>
References: <20241103175108.76460-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They are only used right where they are defined, just open-code them
inside io_put_task().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 701cbd4670d8..496f61de0f9b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -678,30 +678,19 @@ static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-/* can be called by any task */
-static void io_put_task_remote(struct task_struct *task)
-{
-	struct io_uring_task *tctx = task->io_uring;
-
-	percpu_counter_sub(&tctx->inflight, 1);
-	if (unlikely(atomic_read(&tctx->in_cancel)))
-		wake_up(&tctx->wait);
-	put_task_struct(task);
-}
-
-/* used by a task to put its own references */
-static void io_put_task_local(struct task_struct *task)
-{
-	task->io_uring->cached_refs++;
-}
-
 /* must to be called somewhat shortly after putting a request */
 static inline void io_put_task(struct task_struct *task)
 {
-	if (likely(task == current))
-		io_put_task_local(task);
-	else
-		io_put_task_remote(task);
+	struct io_uring_task *tctx = task->io_uring;
+
+	if (likely(task == current)) {
+		tctx->cached_refs++;
+	} else {
+		percpu_counter_sub(&tctx->inflight, 1);
+		if (unlikely(atomic_read(&tctx->in_cancel)))
+			wake_up(&tctx->wait);
+		put_task_struct(task);
+	}
 }
 
 void io_task_refs_refill(struct io_uring_task *tctx)
-- 
2.45.2


