Return-Path: <io-uring+bounces-2694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A400194E3AB
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 00:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F2FCB219D6
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 22:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FE4163A9B;
	Sun, 11 Aug 2024 22:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="uAlyXlbJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4284115C13B
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 22:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723415331; cv=none; b=Ulx1mOVWuAdTzG+2JyWsLRD9OdM4PgXH2DdwwOX9dToeTWOwD6+5HQFNNXPolPP7iYekK3ZZzTKlqHrc9mIVgOSO2/yT1Nf3xXy6HSMq+2RPC9jH41dLdfJ8JDem51JfixSqGABMJqiq95HyNblLtVVq7Tf8DmR8hf8tbqAO4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723415331; c=relaxed/simple;
	bh=SvuBgeyo27tgYl4Mr5AlkANtSM/xC+yG8m8oOENgZv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VtCgr9PcVVcJJP0vLSyGbUbfL9NwGql1yUo5Dr6+zIuhR9cuPc3FGcjZrgYynGcpc6rtjJCVNUlBTbrS8Mufib9CMPLg7fCrPE/PApWUIrUHfjzbJrk4MisjIRiNEBlfUz325bcMv9dm+dD7nAwppZXD4jF+pPC00VCaanyyyvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=uAlyXlbJ; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52f04150796so4816198e87.3
        for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 15:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1723415328; x=1724020128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9kZmqufziw/U+BnNxjrYdFrOXuxXNNyKWmcKd111XVA=;
        b=uAlyXlbJc8Kmw1xRFgAaXH8L6C6YOTFcL6tlJRhDSQ3zJNMxdLPjhpxu6lAgXgwa5i
         hvShzlJFE3a4S72bgezsmUrwVMDXg6nkBezSMo+EaQmgvroCipaMdskz7GGwIma3nklA
         tIPnyImvXpY1kgL0hoboF4zVL7yG5LSwFQMGti99dW8/5xC6WwTNovTH17r28v5+tuAq
         zNrZR+V4BKKKKSKLIxhJbEnRsgMMOe8IWe1PvoViPlugc28pUx5Dc7oWkUzgvEfQjY5i
         4ugGME4zEHW99MOV2UAlBCd7IO4F+3MZrcA5NVGKnrYDZQKGF3yA2K8YeIq+GA2odoPc
         z8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723415328; x=1724020128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9kZmqufziw/U+BnNxjrYdFrOXuxXNNyKWmcKd111XVA=;
        b=vsY4kaR2ZYpW5MV+LHMttLauB6QPIJemwvftdNpNULc3HkC+/tQ8zWtePN+GpHGvaU
         ssGjQLV0akRgMPFKqj+AIgRtk8kp0Kt4EvXh3GG6iEWftxt9gMmvYK/VxD+gB8hfnkai
         +RiEudsc8HpfpvpqYJwg3T05cT7QeKBiTcjV8d8p7MrVymWIbgS4bCBkGtYEwmBu/D59
         4FZHbXFhfz6muMtX9YiES0Jwq+T9W7gxrBEwPmbNql5IALTHOuyi7gObg/BeLqPgIqnP
         9QAvOYO7aTi+18wxkQ9DiyeZWBQP/nHKXXb7foUx7vl6N/9+vgWzrxkmvIdHqTs4TbC4
         uL4g==
X-Gm-Message-State: AOJu0YwxZLEMjeH8N+vWmPBzsQJ3hUIPuZyaYFigZ04LrVE33UmA7ACm
	4NCEAxA4u2PfmaQmz48CbC1AzC0Lodpij+m98uhqIlt4rm2sI9kKwzvC3LYPkeU=
X-Google-Smtp-Source: AGHT+IENX86CxS1gvrkgJ3UUqgNCjaYT47MBR3MYQB8KT1yLME4fAVlu2X15Xe16bQ5f2lcEQ4b8hA==
X-Received: by 2002:a05:6512:2248:b0:52b:bf8e:ffea with SMTP id 2adb3069b0e04-530ee9cf30fmr6123089e87.40.1723415324643;
        Sun, 11 Aug 2024 15:28:44 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-163.dynamic.mnet-online.de. [62.216.208.163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80bb1cce18sm176097366b.124.2024.08.11.15.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 15:28:44 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] io_uring: Remove unneeded if check in io_free_batch_list()
Date: Mon, 12 Aug 2024 00:28:18 +0200
Message-ID: <20240811222817.24610-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kfree() already checks if its argument is NULL. Remove the unneeded if
check and fix the following Coccinelle/coccicheck warning reported by
ifnullfree.cocci:

  WARNING: NULL check before some freeing functions is not needed

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3942db160f18..7597b9dcab28 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1382,8 +1382,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 			if ((req->flags & REQ_F_POLLED) && req->apoll) {
 				struct async_poll *apoll = req->apoll;
 
-				if (apoll->double_poll)
-					kfree(apoll->double_poll);
+				kfree(apoll->double_poll);
 				if (!io_alloc_cache_put(&ctx->apoll_cache, apoll))
 					kfree(apoll);
 				req->flags &= ~REQ_F_POLLED;
-- 
2.46.0


