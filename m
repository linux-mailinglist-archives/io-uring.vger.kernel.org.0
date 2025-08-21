Return-Path: <io-uring+bounces-9165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6A3B2FC3F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E3EF7A5116
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCBE2857F7;
	Thu, 21 Aug 2025 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p2kR8xiq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272ED285C95
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786014; cv=none; b=qYFIHnoIM9HLeqLIgu0fhIEXoyzDZByjtpevKiVBmggtokjJAu8Kzeig50DoAq9Vy83J9BglaLznToqQWuNnsme+vX+inI7KiUtHMYcrVovOCqvzP6pjF+l9S2fPhYEZQp8v7SbqQk2+EUg8Oy0rwsFlxzNQMhOmRoh6tMxJnhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786014; c=relaxed/simple;
	bh=gz6dwRzlGof9UwEvCr6oxVdD1O3sc4i7bZh0GzIPLp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYCyXSXxbaSZV+3dWb51LxoJJEHf65b0H9OriF9EB0OvlEHhRc8Wf7r9xR+TN8chfkJGGlJHxLZr2VBKDCpQgpqaU4LIxhmTCD9ItuOh9ewidNANryWpq0bcaZ1oZbCyL3Sq/wE6M49afQkSqtgvmFH/EXl0TaM90POw4jYI2yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p2kR8xiq; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3e67d83ee4bso4249525ab.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786011; x=1756390811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6k4Z3g8NbKhFOpGBcojP6i2GvhTG+dA7Ts7uKiZhDAY=;
        b=p2kR8xiqTR+M1kKfFjafZQkZIOkOV9IORQxk+lzxsdyKbpR7hhuV1hW+zVcbUz4CLQ
         E6INahz1khxa7VFtc4yGmxOUfZb/hSgbO33S2Lny2nQXTcYwppb5mV+/Vbg+168qoOcr
         c+RzpkUJZWge9MuvpviL0GYKnF0NRWs8D7ua9eUoigiUhZhKfwfug7APWnhjS0XLaJ1B
         p9kGoutIXW4XwSeEa5L8iISp1mZfxmQhbhmopcf3Xt0wQdB8VbYXIP2jSvyR9TJ0R5Hs
         UkjE4h4ZBx1icRS7QMrUF34aHhmmhxQf341Jp113G/ew1d0fmmtEMfQ0wCcCvVW0VXte
         ua5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786011; x=1756390811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6k4Z3g8NbKhFOpGBcojP6i2GvhTG+dA7Ts7uKiZhDAY=;
        b=E3BYpq/dI6yVmBm3zssZmjyCcjUqW/fKIX4oibgvzXObqOLYmdWAyW7emm3G+xTs7S
         Z/eITAzzFjnJTk4jS5dOMGVnWZ+N0Qqsd0EI7uiuq2KLEILXDjN5V/QpUkPNKz+Ny6dS
         pHVXQ7DJlz3ab/LSoM8yTRIWW2T6hN0n7jUjuxtScNA/bLTeDaFszzOOy6ZkteVFfxDG
         9oRQiiexvb/HeKMF7zymSpJZzwFNrsDmMENQQjxP7i6F9W+DXbVCqNIaZ8aj/oyLqQ2P
         jve63XwXH0K0YcBooekLVQACBW2rG4CBpaReMOQYGpJPQ5ZbWx6HAutc+noA99VX8f8o
         bMeg==
X-Gm-Message-State: AOJu0Yz0oXKWOISmh+v/Qah+AZ4hTn9ZDlfcu9BVHXRcmNmvNPB1QVMU
	tJzZjz5Id5q1RYcFo7jLGcrNQOcLKVjOafxPQzOoV22pHg7TiPraa7AHQwR5sq3Cq5VXpLt4nd8
	5gFwM
X-Gm-Gg: ASbGncvoTUfnIwG88aDE6K2buQWGwILZOlexnwqx2z1/EJmouRhvIr+HOm5Pq43UbgF
	z+wRDnvJlcmUiOAWiC1Pt4yt0IX9ojm9nDt4TY5r1oJGmIBuoVMZXfEsCFiVpLQLs1t5jNcBxmy
	AXDh1WPZ1os4kCgd4YM+MIkaKBv3yEdqUvx7jd1M3fQaE9/QUbi7ZlAj8R4dgb5mfcC+jX5u775
	4vVmlHxEGW7jzD+9XeVV0V5t7GVTnDfe8zCBhNbkVEv2dVdRmbUB/OB4HX17tAeo3QcpUc0EVmI
	N2xfy5aB5kll4zaiAwDVdjalvZlZuvvDZtqXJoSvn/OwWMTJU0l8wWDDU3CAGlJHz9FHqRS27SJ
	8ci2XHi7uC1VYeOoc
X-Google-Smtp-Source: AGHT+IEn6p/MjUmjZghUoMpN+v2UmtA+TDQ2S6D5v7MSIjNY67mhV2FQn6/2UzwZvOh/lmE2BwJyQw==
X-Received: by 2002:a05:6e02:2502:b0:3e4:9a1:6542 with SMTP id e9e14a558f8ab-3e6d7d3930amr39704385ab.18.1755786011328;
        Thu, 21 Aug 2025 07:20:11 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring/uring_cmd: add support for IORING_SETUP_CQE_MIXED
Date: Thu, 21 Aug 2025 08:18:07 -0600
Message-ID: <20250821141957.680570-8-axboe@kernel.dk>
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
index 3cfb5d51b88a..90d3239df6bd 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -248,7 +248,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ctx->flags & IORING_SETUP_SQE128)
 		issue_flags |= IO_URING_F_SQE128;
-	if (ctx->flags & IORING_SETUP_CQE32)
+	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |= IO_URING_F_CQE32;
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
-- 
2.50.1


