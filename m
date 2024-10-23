Return-Path: <io-uring+bounces-3942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C049ACF9F
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E64FCB2460C
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 15:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2901CACC1;
	Wed, 23 Oct 2024 15:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O77vwv4O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA31A1C9DCE
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699005; cv=none; b=WCa4ijN9iWFNMzslHNq+E37xnoslTiJy2PsHjc8MCQN9h7ZK8via0Oiof8EODfmpc6mY4+5rWaBt7A/+yxWvnPAat7/CzTbq+9l3IJaUSaOINi2WGogMoMasfXicHGV04KdtgkjAo0Yzdu53Zc+64xWdPMkP9r53ZxPo+PQZasI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699005; c=relaxed/simple;
	bh=IaJHGPEnG4FwAl81uj6oQFgeVUEh5ilo+0SBvR1Qvsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNqOBuCLb6qycSty4aS8DxmZa5trnnyjCpOX2YJzp8q+Nl+y5+SGYzWaVcV4lAGIeSkcYtUY8sTQLLk69zOPcwNWGR6mr5fBzrOZ6mO+5/SGps++JgNxHxvNr1BQ+HZK1nRZ9pddcwbDjt1wWxBhepQKLPdVfaBdh7tpz9aX0+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O77vwv4O; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a3a5cd2a3bso28402215ab.3
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 08:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699002; x=1730303802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=877Civ4zwX5SMS6lpgNa8Hw02O/Hug6rwORSlmT0bwA=;
        b=O77vwv4O90i74SUnGC0Kevuv/vRulQzC5QDvZnrGtn9hUk/iHzHBlqQwTDrptWv6OU
         UHiho1ieDw7UpDkDcZajFq1nBq1cHMdktqZte6uJIu8Gzfv9ufAZC023Y52aO0sTZboK
         C2UJgQoBDtu5Ho6DcgyjQVeHNyRIFV7oIfXls0u1EAtAuJVdFa3LA9tv1HmH/8qktf0Q
         DnSKyCeDl4Spknl1pWVLUpcFtgYGLVXvxQQ+6w8dEkwruFnez59gdQ5/A3HHp/qw0UbF
         udt1Je+ebDfKjdi9s8AlPaZh/OHdiYA1jHqIehyztlsZsCHDkHPIulY4Tzh7u1tmV02o
         9+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699002; x=1730303802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=877Civ4zwX5SMS6lpgNa8Hw02O/Hug6rwORSlmT0bwA=;
        b=t+WTjCEYq6ruw1+XR2wb8ekWtn9hAQf8i3MNNupZlvIkMdnQ+w9BvJciIl1ngo701M
         NXTaxN57mjNKRb61MOpvRXTS6Z+HteNXr463eOQvJGr2BgtntbmUkuC8ZM2XAO0eJe1o
         Z65P+PHMB7uRD+Yhojlw8dgGniak0lexDiV4VevUSgKPyfqKIS2fphIbHviwvKnCd2ui
         o0ztYWzigXYzRiepVDhOxOVFaaSgLVYXfO13t3LoFGOthcdRmqdFgbJc3tKvlllez4dt
         RrZQk3U08+gEerMmDBo3Y+u/2gWC5xt1VOZv81wK0rqyCBTEx/H5/Owcjc+dfQGtkH9R
         zYdA==
X-Gm-Message-State: AOJu0YxjwF2SHJVwzGEScj0+0iFeozeKSM6kEZjXJVwHO9XcfrDcixRM
	yT1Ww1xsCnYbiG/6JuZ/pD+uhsXwkO3ad6fOb7PxEpEaWpM7T55lcbTPfDc2RNHlzhXFrI+O+hr
	g
X-Google-Smtp-Source: AGHT+IHX+tF2oMT96nYi0O8pS0cbcc8f6jDNgOnQnKHRBaMyNW7Sxveb6MyzKBqwIHx2DCuvjOHybg==
X-Received: by 2002:a05:6e02:138a:b0:39f:558a:e404 with SMTP id e9e14a558f8ab-3a4d5930270mr40829845ab.4.1729699002237;
        Wed, 23 Oct 2024 08:56:42 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6091bfsm2131572173.97.2024.10.23.08.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 08:56:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: switch struct ext_arg from __kernel_timespec to timespec64
Date: Wed, 23 Oct 2024 09:54:32 -0600
Message-ID: <20241023155639.1124650-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023155639.1124650-1-axboe@kernel.dk>
References: <20241023155639.1124650-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This avoids intermediate storage for turning a __kernel_timespec
user pointer into an on-stack struct timespec64, only then to turn it
into a ktime_t.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b5974bdad48b..8952453ea807 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2494,9 +2494,10 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 
 struct ext_arg {
 	size_t argsz;
-	struct __kernel_timespec __user *ts;
+	struct timespec64 ts;
 	const sigset_t __user *sig;
 	ktime_t min_time;
+	bool ts_set;
 };
 
 /*
@@ -2534,13 +2535,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.timeout = KTIME_MAX;
 	start_time = io_get_time(ctx);
 
-	if (ext_arg->ts) {
-		struct timespec64 ts;
-
-		if (get_timespec64(&ts, ext_arg->ts))
-			return -EFAULT;
-
-		iowq.timeout = timespec64_to_ktime(ts);
+	if (ext_arg->ts_set) {
+		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
 		if (!(flags & IORING_ENTER_ABS_TIMER))
 			iowq.timeout = ktime_add(iowq.timeout, start_time);
 	}
@@ -3251,7 +3247,6 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 	 */
 	if (!(flags & IORING_ENTER_EXT_ARG)) {
 		ext_arg->sig = (const sigset_t __user *) argp;
-		ext_arg->ts = NULL;
 		return 0;
 	}
 
@@ -3266,7 +3261,11 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
-	ext_arg->ts = u64_to_user_ptr(arg.ts);
+	if (arg.ts) {
+		if (get_timespec64(&ext_arg->ts, u64_to_user_ptr(arg.ts)))
+			return -EFAULT;
+		ext_arg->ts_set = true;
+	}
 	return 0;
 }
 
-- 
2.45.2


