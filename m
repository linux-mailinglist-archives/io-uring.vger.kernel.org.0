Return-Path: <io-uring+bounces-8650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC29B0282A
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 02:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C27843B4CD6
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 00:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43CBEC5;
	Sat, 12 Jul 2025 00:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rCUeyzcK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B81FB3
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 00:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278633; cv=none; b=plzQsbxIAi8bgqAj2m0EQjm3NiTi1xxflOKVGTSOcOJlr5+kbOieAWpa1sZV2Q5eYRZYJHzHSHW5Y7DNKAc9FKkGNgS80Zj7CoKiY92rYIlwsWgFZzKfFEaRF6ZOE6HWMqKQyAQ/ZeWKsq+nrXOcbMTKDD1UUnFyIYiGmT8YO0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278633; c=relaxed/simple;
	bh=J0uS0pdxrI7U+UTd6KfsY9n3Hi1D5EBVAHlwSX3JD3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeOrQ7ImPfJMvnrpgYPgNt3qB3QVvm+GxrFcqxuFoJ3P6H+AJHOhdIfjRAyZD//UbWtddSrhYu2YMR+tL1HlF7DbME/INQC0LSn4d7hbOvOQlVxC7sFPKeYpPZqb/ZbLrywK07NZ4XBplQ6HFteuMb2O/ZW4fu9L8kZoFu6X/6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rCUeyzcK; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3df4bdadca5so9966065ab.1
        for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 17:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752278629; x=1752883429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktzxq/tOZdGlUpc6KbAXtPc5ljt1IfQdpu7erwm8zwI=;
        b=rCUeyzcK0QneGGFF3mk9qosCL+V5Y+izmaFfaZWXIPksasYsBhw1YtCUOjRT2GEZZs
         c+wwYcedfG0WTbJY4fiqEPPZisuO9KrjczHBRRIpJmihTHbrvE4IcLtSwYGuAtWvHx8k
         C5wNYX27Pq+11jBrMo57Z/0yK1y0UPXMz5J4bMF3G/KmmvTQa+8XAHfziYFc6pOWpZOq
         k4+6SZZ5LGCHerDi4w5asyya99VcFy6xDz4kcGuntWV1HVP4oS6mVspk0oBRW56s+OT8
         f2DUU50zuPJt5jxJzx+2t03cCCCMjyY1dy5bTLkvucRrti1zttxBVie0DmobVEctEIFS
         K0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752278629; x=1752883429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktzxq/tOZdGlUpc6KbAXtPc5ljt1IfQdpu7erwm8zwI=;
        b=aOFaMWAvA4HqEkJ9+3t3DQ8+rsxCySbC8bHko87/IsznFKqKkOE6uC3Ri8Q1+El6ah
         7ZWGeuXaOYzCEcYD3HUoBgJoh7aTcPwf+p0D0UiV30WRz5wCf6Oe9XTCltpGfP6iUPUQ
         zyayDMmMqAxqxtFmAyEFcimvp8D2vxe+5jKiwJ6pRE7ctYPAVbyXQ+iOrtReT0iSKP+J
         8euWXcSawdG21dUQM38QIrZygh0S84Ft+R9OBp+tlyTEL6cqybzbzhwV4iXD6I6bUgRb
         Ef73icLCII0W0H39O2AJZrQSZK1tYcgH1EPn53f7PoW8MpTUeAgBgIw7QWv6fyxXEECe
         RISA==
X-Gm-Message-State: AOJu0YzP6wxT7CHnm/ZbowFvatsOMELlFZcpvf3HJGyBjOXrEx4j+okS
	BTpM7X0UXYm3Pu61/11Z62RY8azcw4uB8TTB7+R01TApWp9goMSXRjP/sBiyEh73lYsdwhQ9hlN
	tM1pr
X-Gm-Gg: ASbGnctE7SjO3lJrRXcaoRAuM33NwhaJRsNIg96BMtNFrB/I453X2KWV2usqykGYp0J
	g7+9TsCHQpmreMxIcPmOF6aKnfM8FCGa3EY37mjFcgGWEqlRgq6idnPVMWtIJg9amVhEMTypdSv
	iNWLt54wByE8QrQ698F0qaRPgLs80V9pdh8djdlwRCtba5q2PMoCAQG2qwmCmZBWye4/uKuFKd9
	1wzo6scRpcrZ4tYajCF2d784BWXZa7gMCgzn/kgzumM+mxWNqWCtSYq+Bxuoncn9E/qjekqk63z
	vLN5ppjelGc8KV6BOWSHW+lP6V7tOYgr/V6pz5R+A7ZIOy7GkHewP3pAZx2oXNe4pVnOHoE9RnX
	l3U1qSg==
X-Google-Smtp-Source: AGHT+IGV+COhrzgi4kF4Xds445isdWcXbEKFZfjOS8U1qKU3yNZv+x3M0CAGSr2tA6UPn5qRjo+IEw==
X-Received: by 2002:a05:6602:3a17:b0:879:26b0:1cca with SMTP id ca18e2360f4ac-87977fedb75mr668074939f.13.1752278628938;
        Fri, 11 Jul 2025 17:03:48 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc12eb9sm129810439f.24.2025.07.11.17.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 17:03:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/poll: cleanup apoll freeing
Date: Fri, 11 Jul 2025 17:59:23 -0600
Message-ID: <20250712000344.1579663-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250712000344.1579663-1-axboe@kernel.dk>
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No point having REQ_F_POLLED in both IO_REQ_CLEAN_FLAGS and in
IO_REQ_CLEAN_SLOW_FLAGS, and having both io_free_batch_list() and then
io_clean_op() check for it and clean it.

Move REQ_F_POLLED to IO_REQ_CLEAN_SLOW_FLAGS and drop it from
IO_REQ_CLEAN_FLAGS, and have only io_free_batch_list() do the check and
freeing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 895740c955d0..4ef69dd58734 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -114,11 +114,11 @@
 #define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_INFLIGHT | REQ_F_CREDS | REQ_F_ASYNC_DATA)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | IO_REQ_LINK_FLAGS | \
-				 REQ_F_REISSUE | IO_REQ_CLEAN_FLAGS)
+				 REQ_F_REISSUE | REQ_F_POLLED | \
+				 IO_REQ_CLEAN_FLAGS)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -392,11 +392,6 @@ static void io_clean_op(struct io_kiocb *req)
 		if (def->cleanup)
 			def->cleanup(req);
 	}
-	if ((req->flags & REQ_F_POLLED) && req->apoll) {
-		kfree(req->apoll->double_poll);
-		kfree(req->apoll);
-		req->apoll = NULL;
-	}
 	if (req->flags & REQ_F_INFLIGHT)
 		atomic_dec(&req->tctx->inflight_tracked);
 	if (req->flags & REQ_F_CREDS)
-- 
2.50.0


