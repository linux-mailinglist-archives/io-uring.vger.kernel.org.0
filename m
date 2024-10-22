Return-Path: <io-uring+bounces-3924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E899AB7F0
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 22:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE27A1F23E7B
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 20:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4061CCB5E;
	Tue, 22 Oct 2024 20:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V+Hbs5sb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE643EA83
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 20:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729630037; cv=none; b=Bl8Bnzq33idAbrvoWwybhLXAbwF/IWa46kq7U9WV6oJvrK2o0/81xPUDUnhSCttj2OtcN7hCl0Wfbl6ZnQpZ8SU7bXFY+XxSpuHtKfzyOGxQL9MIhUza3hiV1ykIBP8f/p0LVSpbr341DL8vY3uBYl3f4l6ZBgjFYupPVg8vU3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729630037; c=relaxed/simple;
	bh=IaJHGPEnG4FwAl81uj6oQFgeVUEh5ilo+0SBvR1Qvsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv/0umEH+5jyz+gd8NK54mQnU8YcIcNgVI0fi9agQx95vSWBSP86hZ8rXhQwXwXLSUyeR356zWA7CwqHKNz9jLswKKcsHuDoqpE9ecIRGaFiFfWLJMC4YiiTwMfirkgAKMxYtU1OnJLcdPnoqHa4mawQdN+zDz7WOz33GG8Xym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V+Hbs5sb; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83aad4a05eeso243832239f.1
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729630034; x=1730234834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=877Civ4zwX5SMS6lpgNa8Hw02O/Hug6rwORSlmT0bwA=;
        b=V+Hbs5sbR9KqUK4wKqUyxVGnZKwtUpkE+TIlkU+GrY9yuxfrfKPzWbkCsKTOZ5/P9H
         PlGGsF0kcQASleAjNXjrM/o0BXbmyVmCdFtarnYd50GVI8LPXx9eZ+KB0qttzfaO0CGT
         sOn6C4EYBRmmtLdGOhSwGF7OSjDXnA7cR6/d5K3ZtGiRQ+W+PCmCfrjBwKd0WqwlvS1v
         EOCILEj2ygWL/QgA48fp12m8xx6xkOYpPT/2ISH2TQfFbjxXqHpS1/IaWZo2ywb2Vlbk
         9gpwwIaCmS2APBpv/O9SXUVg3tbAQdElXowt6wNEWKGX3k2t4RA2l6VjBftPuyMyjU3k
         bgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729630034; x=1730234834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=877Civ4zwX5SMS6lpgNa8Hw02O/Hug6rwORSlmT0bwA=;
        b=sCVGaVO8U+dJ2+DSaOoUT0UFGE7myy1PZUPvFpWBKEZWDVrRk1VTVh7rvRtQBevfh+
         ajmv1ZCiEfrl1lpbLOnfyYuuM5wbHzSklgDfIf0d5Aph7usuIrNO/6kTr5TICs8Ccnxv
         Y+IQDigbOHCqhvZBmO9hnEZriSh86H8lUvr5ChOrZD9BMWgSbrixjJM3TdR3dE1uDFhG
         5u531M63NIo3OizPjcLkvw5dYZRmhSV27POs7McUzeGq1WaVfSe1VSG4oKNClLot4J/4
         xh9z1sA07dbAZoOD8StRG8k0EnIjT8ertEKVCFVOiFbhkl5+FYpLpgUdl8weybBS/ee4
         LsPw==
X-Gm-Message-State: AOJu0Yx1LagUtxQgKPt1i3GV4MkQJLj151fPKVWMNGdlhmW/NVhMTbhL
	9WnP8S1zRRgOCoLxNM89NJULgfX8LaTwNxLSfQpGOnXk5DzAz39qqQIiGIr5ciAxiArW/SwsI/n
	q
X-Google-Smtp-Source: AGHT+IFbwRoUwywR1bMhfw/q0f0mZiUrHjDoTQq9WWJq2f+TszM/qxRFu5wa72Ahdu2HG84YdBS+Tw==
X-Received: by 2002:a05:6602:2c94:b0:82d:16fa:52dd with SMTP id ca18e2360f4ac-83af6192782mr38088639f.7.1729630033721;
        Tue, 22 Oct 2024 13:47:13 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a5571d1sm1697385173.52.2024.10.22.13.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 13:47:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: switch struct ext_arg from __kernel_timespec to timespec64
Date: Tue, 22 Oct 2024 14:39:02 -0600
Message-ID: <20241022204708.1025470-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022204708.1025470-1-axboe@kernel.dk>
References: <20241022204708.1025470-1-axboe@kernel.dk>
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


