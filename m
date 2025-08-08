Return-Path: <io-uring+bounces-8917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4BAB1ED9A
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E78BF3A8015
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18A049641;
	Fri,  8 Aug 2025 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pO5//WqZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D3F182D3
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672639; cv=none; b=LZuQLK+r8Nvz+N+HfERsVxLcVXS5PcwK7ke84L4H66Wk5jDThkYi530hJxthsLgoHn5tcGYgbnZ6tTiMZ/f9Lh0r5hlCPoAx7JlsR8B+69ExQ8BeY/8r3pTKX5B96mb4HeRHOy4R9jvFy2JSvfPdrsf8U/Sz6vz7jeU30zOQmaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672639; c=relaxed/simple;
	bh=fWKgL6VoaSyFUMidal+T+j/25nnV3b7zKYZx2WTuao8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxnGEUrSd47kOpVQjzIXHqGxRSqNTUkTYGosKjPoaJ7aP3+S7gjCdz7qxhRcfUlVROGDr2y1jNIOHPsX+JlVndMmFFTYltVZIItvLRaSSkudIm2EIcm+oAuh1RkjbVL4ps9UMHpRMyqvCsVwiL7sF2OhK4/hyrI0fQ8VyelqARY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pO5//WqZ; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-87c0166df31so135453039f.3
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672637; x=1755277437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFPWpzG1AUv8OCk64kABjKhF1scMWkPhH3E9mkWcvq4=;
        b=pO5//WqZhsWV44mH4U4LE4O6u6T/fGmpyrdAPG/CuxRTOD3votXE74U2vSq1TF6Y64
         NVqzghq8kkYAkFnTj+9t0M1feGg32+mrBm3yZRAwujyl27xJr6YBi9lCjAl39hV6dR5q
         HtCDakQxezmB/4Qp69JQZ88rwkJxOlItJaGl3Q14MqnG8H9aWhTBx0mMD58+ech8qjyx
         fUnUMx+i4mVJUiOwZ9WEcxMSmdOUzcHrU02Ilab7vuSOo85RlRHDTWWMV9DegF8u/tg4
         05sHDaOR6YgJsCYSFIVGZjSTWYz05PYx86XXzG9CWm789FtedYl6gwEISm4QTPlbTvzP
         T7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672637; x=1755277437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KFPWpzG1AUv8OCk64kABjKhF1scMWkPhH3E9mkWcvq4=;
        b=C2YOHTGVxn2KpTZ7fnwf4Xo0KkZOxzJ+mv264iUwxTyvLkJBC+lWGYkksmRmtpP5KR
         bafZZ0pHs2Lw+flCah5llko9we0UrtrHGvSV7smNYAk+7EJt/n2odolM8ocZ+UZa29oD
         7NXm9gAqy+QCVVHgaafH9AH9ZnuqmhjLsaoZE1RHN1Bh21sT4GEb9u51F0KUOTYR2C5T
         60RG/SVl35LRI7XydgUtOZC0Ig4exUhahVSXuts3xWFzJAhX9x9967VRv7Zlm7gCo9BT
         gpmvaFsh/gv+KWYltciQOgWyCYp6u4FIlZb8v83PQgetHPaPDYFipdsheUbh4VaNdagp
         N7gg==
X-Gm-Message-State: AOJu0YwhTgOR+IWfchtTpt+L82odeBRIe2ijNfLxo/ydTx3AkoTTVfp+
	tietw8/l9fpJJ9glR2dE8/74y0j/t3DV7vnOVHN/L/LENfbUgHWkPJqlcbizUEyMnneH9g9a0tR
	lENxJ
X-Gm-Gg: ASbGncvB+u2IIZpAMRWLWK99GJyROvxuRmHGe7Rn98wdKaPOBl04jjkwBranJ9M9i+Z
	hjLHWX6G4una8DqVlZtXpitIz4HU2z330uJ9nGGWRqEyZ3OyEAycoK+Z5eeTxcmZNMiw6q8g8b6
	pNlmDtMFNOVxCctI/n/T9Wg9OV7NX38jAeM7jLiG324VxiKIzy/ipqeWA4yRHiIGzqiNRPKkrf4
	zCCM7BxOYQdEZz6uMBbvPuPuGTL+Vx9FIkmWCOF/I6bKcA5S602EBw2byUL02IB64lrRwoNp9qA
	m+DnWBHWD8DxFIDoVHZ37a8jh+OJgXVTNecXG2TFV1JavoZpkWumfC5b0DWrLRzXk+F23+XE/6x
	U471IOA==
X-Google-Smtp-Source: AGHT+IH2djPjlBW+iQCFI7WX4luDaGg7PAo0zqaze7buBjxW3obb2koW97Ke3ldjR0zRbbKeGpX/AQ==
X-Received: by 2002:a05:6602:3425:b0:876:b8a0:6a16 with SMTP id ca18e2360f4ac-883f126997cmr704335339f.13.1754672637215;
        Fri, 08 Aug 2025 10:03:57 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring/zcrx: add support for IORING_SETUP_CQE_MIXED
Date: Fri,  8 Aug 2025 11:03:08 -0600
Message-ID: <20250808170339.610340-9-axboe@kernel.dk>
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

zcrx currently requires the ring to be set up with fixed 32b CQEs,
allow it to use IORING_SETUP_CQE_MIXED as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 Documentation/networking/iou-zcrx.rst | 2 +-
 io_uring/zcrx.c                       | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
index 0127319b30bb..54a72e172bdc 100644
--- a/Documentation/networking/iou-zcrx.rst
+++ b/Documentation/networking/iou-zcrx.rst
@@ -75,7 +75,7 @@ Create an io_uring instance with the following required setup flags::
 
   IORING_SETUP_SINGLE_ISSUER
   IORING_SETUP_DEFER_TASKRUN
-  IORING_SETUP_CQE32
+  IORING_SETUP_CQE32 or IORING_SETUP_CQE_MIXED
 
 Create memory area
 ------------------
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..f1da852c496b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -554,8 +554,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EPERM;
 
 	/* mandatory io_uring features for zc rx */
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
-	      ctx->flags & IORING_SETUP_CQE32))
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EINVAL;
+	if (!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)))
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-- 
2.50.1


