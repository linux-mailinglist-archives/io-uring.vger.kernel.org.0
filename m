Return-Path: <io-uring+bounces-8916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C457BB1ED9B
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB37D1AA0FFF
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD06267F48;
	Fri,  8 Aug 2025 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lLQvODG+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A75249641
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672638; cv=none; b=fuqUTNzNqmEayo64IDuNYLD4T7eJTNOFd3i+0NCjnV4WjZ9Yu3DTwHti8qrYsq+9Yp68zuNFxao9kY5AZeMsqLeMQsCXGVdMtiYeyhguoX5H5jh/wnPSzEqZ2OiByM/vFgz/8hbmRxFnS9y69+6bZ4oXluGNbJlL2saH0y4UnDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672638; c=relaxed/simple;
	bh=/bMehdeC0apVPhxXmP+OGZya1SHpX0jzi0fxBfG/Jh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJF39AyUf0yop7LnAK79ArynlQHRNAPHAo3snvxJOyAiDUnBdHdTWisg4JAxqSf4COph6Au2UdKDHn+npUco31ZQKul/3y4j4Bvfw8VYl3rDNvV5qffQrpw+cBBD+T8iLmM4s3UTwf1M4euQqdl1HuZtKFkcO3EI1FMOoXoFEMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lLQvODG+; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-875dd57d63bso61469039f.0
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672636; x=1755277436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKIL7res6oESSX9unkeItOhIf7YTm1AF+XjRJRlxVd0=;
        b=lLQvODG+sDhmP5Zw8c4Dsbs7zyQgUs1lIoHwgjLaSr2HgKX2xmN2/QJUR65l6okV+n
         bSuNpQkQM6MzsWCoU0Q9PIN8ooM5igunbtgLkP8Rv1MqB2g0KnGmjX+0F7v9HAtPcxBh
         LhlOt6sJTaBVsFCBmzz/cd8EhAjl9hx8+f9lZNCHYjN+0w4S39K0nV+MczkZRU1vCQ9V
         X3+waOYn3xXgaInAmKXxukaA24eV8vzNm+3yLoWJmhNo8AlQv9v/fVq1chRilQFH5N4I
         TBWRcoqC6SgmboMF+E+/SU1La1CIiNdRxAm29Y9dIRHW+wW1cQ5eLSMAYMNcwLygtJFl
         nVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672636; x=1755277436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKIL7res6oESSX9unkeItOhIf7YTm1AF+XjRJRlxVd0=;
        b=sBe9CknHq4X5gD44wEuc79rgqvj2gCWs8W6CfJZTkghUV80eYK2j9ZZ7RYUlXU/NLX
         UasQ1ESJeo7P+VM4Axf/MBIW2S0++FTSY9JX5Sz0Vcjd00mHVxNv1XYC/JPsx89kZfvt
         G+BcegGpcjBASAXhw+GDpzsZ5DkEd0YwO7pe6rMyuVppmoWIaGAMM3uLIIQFLVEUNbov
         bSah2uFJl2jFxySFEbb/wIJzKcTzZWNEqBDehqSKiRFSs98evbfnOXRF12wpXkvQaU/y
         0rUJec7irxSuuWF0BQUjnbOtxcAtBZP0+4wGHt8KctoJ8S/NgZbj+iJ9ZpTSdXByV2Gz
         7UDg==
X-Gm-Message-State: AOJu0YyeFJKOCKU0oI8+SSZ+DA/xPWF4xC5AJFu4yIU2UhDqW/Ash0Vn
	qSYt0uo6y+KXyNV3KT5JiCWc9iH1OdwxDHMWRxFR/jvvScncbgN0y6z2Q5/DzQ9eTTLNnui0gly
	7n75b
X-Gm-Gg: ASbGncuagX4705kFc1kpnid1RA2YxkzFAbcD6WFnr7Y9An5v7LCvfK16Q6yM0dM2VT6
	qH3Tmi+jfNiQGRPxV6PkqEAc/J3HWmAD1T8itMvMKsZ+doIYT+9pnynqnNOFzLlA5Qtpr/FoVJ5
	4aoKCedKp7yjG//4l4MrHqiZrxeKsGpGQvMwvM7gL3V7d5iRzXChPYkWf6BzlPGH9Ussy1OdA5S
	bO6eSVgXo7ZNkORMVHi65Y/YpddXkVjjQFBbn9SNFPvI19opiLLpzrWxmFdSFKbfNGnDYPP1c2o
	l+VrUFNOQJDylAVHvKiQRpcH4/SoT0TIwO85bPGCN4MIHjYZG3sOW5s7sPNixIseyxSy2O5AlH7
	r6Q5Fvw==
X-Google-Smtp-Source: AGHT+IHN+kFRGCX1SLL7g46Fgx15+RsjeGUgGJIlKiOWGl0ry16UYo2LF24c3iSUMYbrRQJHOY3H7Q==
X-Received: by 2002:a05:6602:1654:b0:87c:31b1:8a47 with SMTP id ca18e2360f4ac-883f186344emr639462639f.7.1754672635790;
        Fri, 08 Aug 2025 10:03:55 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring/uring_cmd: add support for IORING_SETUP_CQE_MIXED
Date: Fri,  8 Aug 2025 11:03:07 -0600
Message-ID: <20250808170339.610340-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808170339.610340-1-axboe@kernel.dk>
References: <20250808170339.610340-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Certain users of uring_cmd currently require fixed 32b CQE support,
which is propagated through IO_URING_F_CQE32. Allow
IORING_SETUP_CQE_MIXED to cover that case as well, so not all CQEs
posted need to be 32b in size.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cmd_net.c   | 3 ++-
 io_uring/uring_cmd.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 3866fe6ff541..27a09aa4c9d0 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -4,6 +4,7 @@
 #include <net/sock.h>
 
 #include "uring_cmd.h"
+#include "io_uring.h"
 
 static inline int io_uring_cmd_getsockopt(struct socket *sock,
 					  struct io_uring_cmd *cmd,
@@ -73,7 +74,7 @@ static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
 
 	cqe->user_data = 0;
 	cqe->res = tskey;
-	cqe->flags = IORING_CQE_F_MORE;
+	cqe->flags = IORING_CQE_F_MORE | ctx_cqe32_flags(cmd_to_io_kiocb(cmd)->ctx);
 	cqe->flags |= tstype << IORING_TIMESTAMP_TYPE_SHIFT;
 	if (ret == SOF_TIMESTAMPING_TX_HARDWARE)
 		cqe->flags |= IORING_CQE_F_TSTAMP_HW;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 053bac89b6c0..450d5be260a2 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -234,7 +234,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ctx->flags & IORING_SETUP_SQE128)
 		issue_flags |= IO_URING_F_SQE128;
-	if (ctx->flags & IORING_SETUP_CQE32)
+	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |= IO_URING_F_CQE32;
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
-- 
2.50.1


