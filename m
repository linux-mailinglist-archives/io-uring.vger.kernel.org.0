Return-Path: <io-uring+bounces-8910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A76DB1ED92
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36F557A7BAD
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF56C275B0A;
	Fri,  8 Aug 2025 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yAGqVOo/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB667082F
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672628; cv=none; b=BtnZ2nXLYoI6DeKKxabjnZV1Abt+Y/20lMMVpHAEOP2bAe0gcjhxtlfYPhmNFSjHaE2soCgR0jC9UHmzTU5oVcbmEhkkyeqQwl5m0La9syrzcN7Z6XxLe7Ixa9NGZ28DJ65cmMPaTU9IZpZiFSRh6C9TWRr0U1EvrK5yHilKhJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672628; c=relaxed/simple;
	bh=fgHM+rZntxCSa54IsCQFhX+URiDGVaypF5q1Y11ywRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbw7oUcO/c12QUOm8yu7qjmgyqxbVxiXER6HMCAY0Hd0acETyyBeqwarxLQE3j4gUhPeiPoCgG9Pxm7VOz+Cu+Cg2H0UI1TxQnUiO8k2Jvswyd6RGoSmJzw99Ybxuc3x51wAnDibXrG053YAPgHwoL7hUfh3MUILVFOahTIx3Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yAGqVOo/; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-880f82dfc7fso153717639f.2
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672625; x=1755277425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKslmUKM0tBVV7bU5szpZJJNaXnRmuJ5VGHbClKBSNE=;
        b=yAGqVOo/HW309cQ/jvL8gx8pu9XMd6e4SRYjllXMTBV+BnyED4ZFdStqF7uzF1QukA
         kwQhx2ARv+ADAUwgg0Vd2KZgOWLm4cnTk9+d+1DQe3Du1Bh9OGAfsj1Yu2GvCcoZ2XaG
         +rnbrXgwebnd18Ic0hkn7KTMfFA1ogUyBBkYtG62ZAGkNv8vOMysJmsyYwpwKph4pJR1
         J+H2hQRCGr+m7piO66U+M++ZRB/QsSfyA3Lzi3RImmBaykwSYxBbv2f/oZSQB5jXoT0b
         k7T/xHJ2Dyi8i7v2qbkvzd8c855mgDFQG/paOdFqcw9Pz6PfW+ZuVL1+BqMbL28O2jEG
         1wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672625; x=1755277425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKslmUKM0tBVV7bU5szpZJJNaXnRmuJ5VGHbClKBSNE=;
        b=hllIiz3LdHUcLvccS3fx9eTpk5sYjajJpN+1Mil/E2s/Cbwy0nHMKw5EDfLhMCDcuL
         JMUL06U+YRuNN5TFE/fOKuD3SattDcedW/0qcteYuh+fBQyrQbAbdR834lWDsTRyeb9n
         kr8SaousynXwc+KQ5PMlC1sLgkBYzGih4sEx8mfUhAgH9hsaciBjJwqUKA+3nILFcZwo
         ECsIA7v/q3i742jHCqC3KjP2pnS999j+YnEXoTrTM/2NIsCeEm/de2IJV5C9qH2gu6jD
         RdWAZ4xJ++sO4kWZckVpJMB1UXtnnBAQSQ2gcRQ0dFvZNcFsogJUZHLH8jvhUjOk2S6o
         p0YQ==
X-Gm-Message-State: AOJu0Yxe5j/3yjx63coU9loTxqsaq9FEDBrtB0gai0DvdKHAXJ4Z+s9U
	BewW3jBEUeY/0+7eA9Y4bQU6WdvwPF2DAW7RjVpuItoXkx0H4ODX2TlLc5Jlo9htE2/gj3uh8vV
	pnoWK
X-Gm-Gg: ASbGncvqQCpU/iSsnw2u7hLNKB9KGDx232nQPIJ+lRpQJbwIHEuHnVQRK6j0fCvKSn8
	xRa0n6pNgJYjEjt/2HMY2W1fcZykHb0P6w9Sd91AF9tx8gEtJpp7T6c9892mXvOwI9nvSw5mFt4
	ClHYUaRgG9bwktkIrYfmSy3isemtpbLtvs07FE5OGZ1AichhFt66Y/sb1UXNwMAtzzNdTCuoHRT
	l8AgLgkuKM+QzZaMGFRtaPV1R6T8ZUP4J1kZ4hNoWMWDSett6rClkNcZvuo0GJU7ZBwXYHgkkLg
	PrPzZ8TObUykc9kmHnrB5Nh7aAGlZhXRuVffQV5kNy820k4zg79tsDzcm7pEpE2cic7kTtVf2l8
	rnh3Ra+ivTfNeT6qx
X-Google-Smtp-Source: AGHT+IE7P468rTf7KLk79qiL4CgVAjSMrwTkPy3gD+SV+HX6qBz84PJvxNKbpilJwQ3Q76e+JDEaKA==
X-Received: by 2002:a05:6602:14d2:b0:883:e9e5:477e with SMTP id ca18e2360f4ac-883f1283dc2mr760695939f.14.1754672624615;
        Fri, 08 Aug 2025 10:03:44 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring: remove io_ctx_cqe32() helper
Date: Fri,  8 Aug 2025 11:03:01 -0600
Message-ID: <20250808170339.610340-2-axboe@kernel.dk>
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

It's pretty pointless and only used for the tracing helper, get rid
of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h  | 6 ------
 include/trace/events/io_uring.h | 4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 80a178f3d896..6f4080ec968e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -727,10 +727,4 @@ struct io_overflow_cqe {
 	struct list_head list;
 	struct io_uring_cqe cqe;
 };
-
-static inline bool io_ctx_cqe32(struct io_ring_ctx *ctx)
-{
-	return ctx->flags & IORING_SETUP_CQE32;
-}
-
 #endif
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 178ab6f611be..6a970625a3ea 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -340,8 +340,8 @@ TP_PROTO(struct io_ring_ctx *ctx, void *req, struct io_uring_cqe *cqe),
 		__entry->user_data	= cqe->user_data;
 		__entry->res		= cqe->res;
 		__entry->cflags		= cqe->flags;
-		__entry->extra1		= io_ctx_cqe32(ctx) ? cqe->big_cqe[0] : 0;
-		__entry->extra2		= io_ctx_cqe32(ctx) ? cqe->big_cqe[1] : 0;
+		__entry->extra1		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[0] : 0;
+		__entry->extra2		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[1] : 0;
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x "
-- 
2.50.1


