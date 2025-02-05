Return-Path: <io-uring+bounces-6266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC78A28965
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AB2D3A5961
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82A5322ACF3;
	Wed,  5 Feb 2025 11:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j9gj5YfG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4EB22A7EF
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755412; cv=none; b=ay3lY46Yg/HaEpxf8kh5CdcY+En5HjZFs4rb+ihFLiK0CF/J0EcOghMu6c0N/iEFm5IA4BEjxEAkQ0FF857pqOCkgzzzlpnUHEU3WzFbi9uSRT4i5ZyuS5DOykL/73kL0dgPkQRwv1svcPWcRuPEBw4ymKhRfcUYR3KVsb+zjKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755412; c=relaxed/simple;
	bh=2ePhBV5dU0vBGOGo6Yf2+eDlMzr7q4dCMoUf81Lbt0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSzisF0ojcguURer1YTo1u5/Gr3EI71p7DJJMfvsrikibgzt/x2iIGNUWDzvLvGXlDfZdSxiswexGSDNIY4+dU/PPZYDBL9otDJ5AR5NvmsUdkZiL1Uwi9iH7vipNhpeIXWUy4QSNRKCX5kcH3se0Yh2o5mx0MvDuphglGo5syg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j9gj5YfG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-436a39e4891so45782625e9.1
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755408; x=1739360208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVgW6hEFQQ7YI5zAH9fN6CiNeQYki6D9SMOXqmnbQ1Q=;
        b=j9gj5YfGlo/teMn1Yy3P12tZ6m0Ne7RKfOZfnK780xUHG/BvGE/9WQK+uppru+orwn
         Y/qr/UAJp9kvOcpCpsVbhCXcSzCU2stuh86o135dm5PrakrimnjzTFxT40FcXaf89vU0
         2tsJZ2VdDtXm0hpWCgj1tl+mU1Yj1yd0kP8k9QYJ8NlbaOFp+fCNaRe8O7BkYDQaAjd2
         2rSoRe/D/vKEtTcr1aWD8Sm2MAMnJHV6t/9+RymxjglArOJ5A3zQa/sa+T013Q+u3/iM
         SRxU++PoXSE347YgFCEeNHIpD/48w7oQIzH2N4/Z6wkeBJSYCbPlUal8UYCr9o7pjEB/
         kj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755408; x=1739360208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RVgW6hEFQQ7YI5zAH9fN6CiNeQYki6D9SMOXqmnbQ1Q=;
        b=iSetgdAY9BJM45jTQenO7V/UnNjCueVzUBEp+eVCkdxUo5ty7I2bujpyi7VwsCs/uw
         mBT4QOyxHIG8+yTXRbgKyC/R6kNQo9jssXZI9sBZgwAp6J2saliiNqCplAiE2Zj2hRz1
         mB6bjeyY9JVT4aDVUn07QOLAMOfbmInnVch2aObQtiZWj50PIEx24dtdX4gspkdXfCkF
         /SCp+otpYN9gOg8PWPNwIOkr8pgpvkg/MaWm550FIN3aT5vfPtSHzLSRHSWANU02qrcj
         WmFbzpR+ypDb2hNJQGRCBTwbe0dcadfv8watbKB9EzYozmmnO2Zhjf94a1Xo+YUXrN/m
         UGqw==
X-Gm-Message-State: AOJu0Yz8281+8JIX/uu68JGIBTunftaX/V6xPO80GjtxfXhg5fB84shC
	ESUtZl9DnjDoieYQutK0kZKkgoKgwDV+qeXGKw2M/LPRjwFsVco3f0ZQjQ==
X-Gm-Gg: ASbGncucmNXDUXdDYQpks/mPHZiREVJKOminPLsx/ksYiGNa6AKeUejN59XbPwFKg5C
	DW3oH9M9gB0w5qS/mbqZFpQIPFXsnEc8m8hiDxxm9SKe1cLYlsX7W0H7QI9QPt3Fguq8HuDDej0
	yr83sHjT34f8hJ/q0CR3A6TFiCGzdUT6WtV0vhIuOLh4ubU+rBRxZN4IvAxALR5mkRWtqWoyjTj
	GOclNOBrKQLZCRhPTMOhm4xSHdG5kIKlLI9bBNt84ydjmSDOJfvlN4CUrCFqgMuVHp6Bdk1l0/l
	nTZvPNFDTR5vidj51YAEERpdaPs=
X-Google-Smtp-Source: AGHT+IFXLbRIO3pJ86xQMpxZIiVon+0LI5KjFWQVFFWQkZiPc3Bb4a0idfHEBsMAhxVMuKVLEC62/w==
X-Received: by 2002:a5d:5f56:0:b0:38a:88bc:ace1 with SMTP id ffacd0b85a97d-38db4929f66mr1767154f8f.34.1738755407121;
        Wed, 05 Feb 2025 03:36:47 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/8] io_uring/kbuf: remove legacy kbuf bulk allocation
Date: Wed,  5 Feb 2025 11:36:42 +0000
Message-ID: <a064d70370e590efed8076e9501ae4cfc20fe0ca.1738724373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738724373.git.asml.silence@gmail.com>
References: <cover.1738724373.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy provided buffers are slow and discouraged in favour of the ring
variant. Remove the bulk allocation to keep it simpler as we don't care
about performance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 04bf493eecae0..0bed40f6fe3a5 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -494,12 +494,9 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
-#define IO_BUFFER_ALLOC_BATCH 64
-
 static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
 {
-	struct io_buffer *bufs[IO_BUFFER_ALLOC_BATCH];
-	int allocated;
+	struct io_buffer *buf;
 
 	/*
 	 * Completions that don't happen inline (eg not under uring_lock) will
@@ -517,27 +514,10 @@ static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
 		spin_unlock(&ctx->completion_lock);
 	}
 
-	/*
-	 * No free buffers and no completion entries either. Allocate a new
-	 * batch of buffer entries and add those to our freelist.
-	 */
-
-	allocated = kmem_cache_alloc_bulk(io_buf_cachep, GFP_KERNEL_ACCOUNT,
-					  ARRAY_SIZE(bufs), (void **) bufs);
-	if (unlikely(!allocated)) {
-		/*
-		 * Bulk alloc is all-or-nothing. If we fail to get a batch,
-		 * retry single alloc to be on the safe side.
-		 */
-		bufs[0] = kmem_cache_alloc(io_buf_cachep, GFP_KERNEL);
-		if (!bufs[0])
-			return -ENOMEM;
-		allocated = 1;
-	}
-
-	while (allocated)
-		list_add_tail(&bufs[--allocated]->list, &ctx->io_buffers_cache);
-
+	buf = kmem_cache_alloc(io_buf_cachep, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	list_add_tail(&buf->list, &ctx->io_buffers_cache);
 	return 0;
 }
 
-- 
2.47.1


