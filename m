Return-Path: <io-uring+bounces-1260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE2588EF13
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5178E1C2E312
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620C314D280;
	Wed, 27 Mar 2024 19:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xlE3xr6C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC2312E1F6
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567189; cv=none; b=NGHNlvpCRG9CavhjTQszNhGp9VI8gdURVV43+2/UHNweK6n5mrbbFOh1C8TN4SasReKH7ruFe4UkPi1hgP014HVweGngukBIK7viCUbQ/uy53aZjcNfEsmyyQcNq37pgCebPjKTvmPlSM7A/Qypnq6LuePFN+hD124s3vRCASmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567189; c=relaxed/simple;
	bh=8G3QN6wuHYeuEtMo+UdWrxs8c//P5kJMH+4+MKrhbiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/++33TdddQxIhm5tTC3LwlEq/ci+57WGBpUZtzhNWgHdHepjp3yplMk/YyQ/FVtzYTdtNg0Nfx4PjjEjMBE1BQV3uw7hrPd/MQNyIOuBnALTB3pGfQiti3uG2Xk6CYyXilmlSGPeJtMpglPFuTTKorqSsouFrvp7+/fYvH0MpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xlE3xr6C; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6c38be762so41826b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567187; x=1712171987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtvzBKul3lnX4UwRp+DUDb1X15hTCGMb7+BkwEEbcgU=;
        b=xlE3xr6CLZCNPI7eUHuHtHylNkDDBYbbv6ncr0RE9F0dm6bJjczOdPvyEgQAEQYocA
         m0jirY2dmAkGgYmAnqeKFVu26sEkxJcO18EQwHTpjxvQYRLRlbmTS/VZgBexithY1WYM
         pey3JpOaj3WIq3HBvF3Zg7VpxMdyDtU0xTmcs0kfbQvkeKnUotTzjpvkDZHUrwB1dvdE
         Q5uAKk5z2T7VNfGwidh+/HpGRhYVjK2Xd1knShNxeRLPuF84B0VXZrn/1JrsjeGhJEKd
         PweqjFFNI7rTlpJMK+RlAFCXmobk/PkzCRvZHRAU0lyVZjzjVAzV8C+VVaNbRv5fJ5f+
         aeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567187; x=1712171987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtvzBKul3lnX4UwRp+DUDb1X15hTCGMb7+BkwEEbcgU=;
        b=cUFmKw6sC5H79OCCjlGBJIZkDmhX+dwzi42NFCHHLU3wW/9iT0Yyn4WpZ2+eOYKntj
         ZRacuDiD937DmaV6MTPbroKPSw7tpc38VxaZijtNG6zuau3QnRjfpxl5W+qzU62i8ADi
         eNFXkffALuH9qXqFjibY0o+3hS6Pfm16PZDjYq6z9TC/XNAt0eIRSQP3XlkMkgboeGNK
         IXhcFPDH4QCMFaARw8s3F77ySR6ltswN97a6IHmyEioFq7qZvJMXigGFLbnR+fjFyKY/
         J5RX43ig6En1A89b0YkbzOp9Mmrujq5Tu9Min5I9oF4q9N/i3i21Gerl+5EIflwVpGwN
         +wrA==
X-Gm-Message-State: AOJu0YwUHC/E7yU51yuK7XM8fSED4k5Fg78v0TY690dsI9msQBg6gx+3
	3PkyplV02o569zSJ8iWXEcOwFQ225MokNOkHvUjU/gV5O1kR0Z/FDBf1hd64tWwhSSEP/66mxal
	Q
X-Google-Smtp-Source: AGHT+IE9aMH6EqLndqN3GSJUpuA8ZNoFlJCufQhyoApbOXdCJjHvWo/Av0qISLikK60X7/QrLvb4zw==
X-Received: by 2002:a05:6a00:39a3:b0:6e9:ca7b:c150 with SMTP id fi35-20020a056a0039a300b006e9ca7bc150mr830480pfb.3.1711567186770;
        Wed, 27 Mar 2024 12:19:46 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/10] io_uring/kbuf: get rid of bl->is_ready
Date: Wed, 27 Mar 2024 13:13:41 -0600
Message-ID: <20240327191933.607220-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327191933.607220-1-axboe@kernel.dk>
References: <20240327191933.607220-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that xarray is being exclusively used for the buffer_list lookup,
this check is no longer needed. Get rid of it and the is_ready member.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 8 --------
 io_uring/kbuf.h | 2 --
 2 files changed, 10 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8bf0121f00af..011280d873e7 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -61,7 +61,6 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
-	smp_store_release(&bl->is_ready, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -721,13 +720,6 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 
 	if (!bl || !bl->is_mmap)
 		return NULL;
-	/*
-	 * Ensure the list is fully setup. Only strictly needed for RCU lookup
-	 * via mmap, and in that case only for the array indexed groups. For
-	 * the xarray lookups, it's either visible and ready, or not at all.
-	 */
-	if (!smp_load_acquire(&bl->is_ready))
-		return NULL;
 
 	return bl->buf_ring;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 1c7b654ee726..fdbb10449513 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -29,8 +29,6 @@ struct io_buffer_list {
 	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
 	__u8 is_mmap;
-	/* bl is visible from an RCU point of view for lookup */
-	__u8 is_ready;
 };
 
 struct io_buffer {
-- 
2.43.0


