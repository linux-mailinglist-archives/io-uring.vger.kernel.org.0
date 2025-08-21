Return-Path: <io-uring+bounces-9161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D00B2FC92
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:29:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AA791D20E1C
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E352EC549;
	Thu, 21 Aug 2025 14:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cFM8UGDK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B6B219E8
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786007; cv=none; b=js6iONv3gUm51ezhFGWOjA8VJJkLlSM68rB5PjsK1hZq8uD0FZiOEtFivXEcscdQIY7eT7Zz+FfLIVg3vyP80r5Akni8SNGxQQwDQfG6VUjR+n9QjdjlVUUJafii6lUOOMvxSmM6IHxmyX+q73cdjTZeyx29gxOorrpT2lT3EBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786007; c=relaxed/simple;
	bh=vO6795s0uKMG8NM2FymYuiZ6UKNOQiyBnjOUZFZTygc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiCSPbnP2+2izyk7XZfHkhwXHx+wtYtVtXck38pG3agLK7li6YzTxva33+x1PZKOtmUKWqUz0KF835WJcbGiRmcT5XFUtMd+Mg5OCiMGUWTShaXE1fKpR1+fjxvGICSqvNGLQ5rwGG9bLxmb1NtjhybxF5BbINen4p5athz7imE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cFM8UGDK; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-435de8160dbso331304b6e.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786004; x=1756390804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/XYuUYyr+5xPLKOVRc4r6ioONJJsucqAAf5BtjgKfE=;
        b=cFM8UGDKp2zjDllAfprQkR/3B8STaxwxN6p5q/UmAcSfX3+kiYyX8WbO6RzNoSULoR
         2/loH12Trm6bFx4VAJ2zm8hDAIdvV43342NTfwOZQ0mDnbOEb0Bzg6Uofb352lDeoEyf
         blMKanw14FtYE4edjly4TmnbdKxxFtCWEpApqtyK3HPvtEQPEJJ01rA0kMRWqwm1jRMB
         KJ49JpBe66YpFchSGnx6KmEKRNeOjNvHqWPvl5pJ4pQgbkAC0cniTI48CMvtnr/aeKnh
         PMJjiSaVBtzg8xuPgo5K5Mu3MciuuoX/2NTCg8gCEOTofPoraeHP3buJIID2qY6hNpJ6
         gUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786004; x=1756390804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U/XYuUYyr+5xPLKOVRc4r6ioONJJsucqAAf5BtjgKfE=;
        b=by4BAdc9R+CEePUsQnkEvgMbJ1hknziKEaE7NBNm027lm48RoSliONYdEruVyU/hAV
         jfhDHPmZwIb/bp8NOFJaTVaBVdMjFRgBOyklhPJGeCD38+Xl2wUYeD7mAUeCNUlIs5Wf
         vJkjP7QVnkDxLwPHfgowGNixGQEuY94pmaI8Dd9kxHLyxqGXMp5O3Zgu599Dp1rKZQ5d
         h4733cvvZACHUs12m4diM7Q7Q3dGJFdbGWfX+ilnheiEAxhWRc+4bj+D/bTQnCOpeklt
         5Q3Xt9ETggCp+TyX8MEwTzZU8xlzDEpYdC1b+FEVGDP6mz5kHqvSd24Pr1DodrVZphu0
         gULg==
X-Gm-Message-State: AOJu0Yw1+V9DlNg0e/0D9UL9udd2tI6NRMXbxpkJ3ou8xkVWRq5LQVxI
	O/YUcvFuGzzDnby1QaArMEoxpvIjUCi9GnNonvgQBlJ9cJLVGTPyKkYCBrqGq/D3rManMDOKG94
	ei4Az
X-Gm-Gg: ASbGncsf3gWtTL0uUl/NmySdtOUewL4nY/6cB85YTGpDv2TfumlDU6Q0hcW7JPKFK39
	HePm/ojv45Hk6TPc6SJt3ztDBaLp8Kn5Kp2eliqWjeKXIgxnh2+22gdfrXp0lWwIJTxne9jJ2cJ
	VvFwdQ17phd+yrJj6H3CVtScy9zczf60khSoOofWLwzfLJhhJc664I7ZwI8biaDoPvDQha2bfN5
	jLS1b1IM1mjJwoOFl6pN/D3FJmXm3wiRuwyCnOK1prqhOPG5KvKT+yVKRCL1zMKwW1vq9bK41Iv
	wxx5+8qOcpHgSHUSEDcqlM/6o5FxNNPXyU4m7+WV48oRH3VBBpI9ucA6g3Tr7jK90hE9l6g0Yz8
	bKbwj0A==
X-Google-Smtp-Source: AGHT+IFxz0tPvl5+LgWA61RRiE2NW1ZAO1aSUdOiPSViT/z2o3MT/MJLqr/9lk1gwnjJxuLvYc6bYw==
X-Received: by 2002:a05:6808:3442:b0:409:f8e:72a7 with SMTP id 5614622812f47-4377d7b3fdbmr1010123b6e.33.1755786004193;
        Thu, 21 Aug 2025 07:20:04 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] io_uring/fdinfo: handle mixed sized CQEs
Date: Thu, 21 Aug 2025 08:18:03 -0600
Message-ID: <20250821141957.680570-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821141957.680570-1-axboe@kernel.dk>
References: <20250821141957.680570-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure that the CQ ring iteration handles differently sized CQEs, not
just a fixed 16b or 32b size per ring. These CQEs aren't possible just
yet, but prepare the fdinfo CQ ring dumping for handling them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 9798d6fb4ec7..5c7339838769 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -65,15 +65,12 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
-	unsigned int cq_shift = 0;
 	unsigned int sq_shift = 0;
-	unsigned int sq_entries, cq_entries;
+	unsigned int sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
 
-	if (ctx->flags & IORING_SETUP_CQE32)
-		cq_shift = 1;
 	if (ctx->flags & IORING_SETUP_SQE128)
 		sq_shift = 1;
 
@@ -125,18 +122,23 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		seq_printf(m, "\n");
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
-	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
-	for (i = 0; i < cq_entries; i++) {
-		unsigned int entry = i + cq_head;
-		struct io_uring_cqe *cqe = &r->cqes[(entry & cq_mask) << cq_shift];
+	while (cq_head < cq_tail) {
+		struct io_uring_cqe *cqe;
+		bool cqe32 = false;
 
+		cqe = &r->cqes[(cq_head & cq_mask)];
+		if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32)
+			cqe32 = true;
 		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x",
-			   entry & cq_mask, cqe->user_data, cqe->res,
+			   cq_head & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
-		if (cq_shift)
+		if (cqe32)
 			seq_printf(m, ", extra1:%llu, extra2:%llu\n",
 					cqe->big_cqe[0], cqe->big_cqe[1]);
 		seq_printf(m, "\n");
+		cq_head++;
+		if (cqe32)
+			cq_head++;
 	}
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-- 
2.50.1


