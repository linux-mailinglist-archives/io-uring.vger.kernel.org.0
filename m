Return-Path: <io-uring+bounces-10036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE43CBE3AB4
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A93A53B21E9
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A75724DFF4;
	Thu, 16 Oct 2025 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXshED0B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EB72417D1
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620935; cv=none; b=FAEcCL5Mc9Khm9MUMDooJRo6vVM1Q5XsvB61UKImHK3YasKgz/1u48mKJB7tMOpa+vVUw5tTovqc8SOwpKWhMdOkQR0M44cxFjIc9fKaz/3YF9FZBZwvssYdiDzNWdYqM9teSkAGyunzYtOeTC3hNN2nIx3U3fykyPY3tChPNiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620935; c=relaxed/simple;
	bh=5/lcdWtHLYuCTD7KOu8MVnH7xCBdhOLA7vHAGXWamGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjZnbaoG3d20k5rDNv2JArZMW6Kg7mn/u2Yed9uWFqE7GF1FbCUpcCSOSSWFVFeLufGji8V6DpKpzPs68OpoFGx1FueU4wShno1Vdk4NMS/eJFZ2MIHh7QJavCh5SHMStCE9J/097fdgKg7arEtPd63HU7xZWNAs9S1Kbow5G7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXshED0B; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4710022571cso5919205e9.3
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620930; x=1761225730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/l9UMEDDXir/7x27i96c4snrYuH81YYQUHa0RXZ0UGg=;
        b=iXshED0BFcWLf9+gTiHiD6p6Sz0gqF4NdrOCeEa2/WkaDzA6LSUAc2XthRE5miezz7
         AchnDMkiN7fwIKqZf5yDK57OQBV9WVBPBK98Kw8PxWaOEGLimx1Q1aeAKlf5cYKMBxbG
         XbmRBC8hm3e7S9dkiSNNfluv4tv6TGsUSn7Mx0xQOodsDgKtVUIoezWu+1oBUVbFkpQS
         QTrauDDZ+ytCFen7F322C17/GtvYmfZXkWSXPm0eD7S6cOjlYez6nMsOjr6MWztE/Sor
         719HXC6gc7r/Nd5M0IXfnBq4TdSrzhSC5m1Y3dVOITY6FV82tSNT1vrOiwVuOenk4ob2
         9KCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620930; x=1761225730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/l9UMEDDXir/7x27i96c4snrYuH81YYQUHa0RXZ0UGg=;
        b=UnhfdKt33fRA4C5A4H1CdTNVc4WBiZkA+tP6JAWVfmwXVpoHc26Fa+gkECgp6eeU3T
         HI530WXJqfyarlfKu1saydFHUO8rvABGryjVboklTGwAkCJSl8oQxNtOzhNsCl4J8K6U
         rgkX+mrcxyztDRxeNLqQ1X3HGRf5m7q7Hj7Dlm1aVSOnRNOaHzdTLLAx1YOTr7VXSaFE
         MdpztLDnehJEWXpKN/Ne3oDH32URNqLemvIGb7A/8fKWLp059W+nRxNAHd4i2N1KDOwc
         A+nHnqmPtqVbN0hJgy+SGO4U5J9XTtQe036dRi1oNrbfalMJJvS1mllmGlnKE6yFCox9
         /MZQ==
X-Gm-Message-State: AOJu0YwBAWjzw7vAAQk8Jom5fu2t46sTW4+8KTrlHBtbJ3BvjAKEDvJ+
	a/MdbFOYto6sUYQj0HWYIMch9xz6eAU067uPLXCuwlvFJShnhGopbcWNmG/s0g==
X-Gm-Gg: ASbGnctU7HtUCrL9SfwTjFHK0D6dvRsCNUfjimExLRpbAXCUTFC3HK0L0ql7IuaUQkZ
	eW/71zh9BilHVYfrZEczXxDNhMrme2UpYKJpZN9+BQE54wdoIDAJ+w344IMrSI8L4bmvYZjyy9j
	YxM7tnp7He0404eXHHfd1yRHCxk+BFx8Vq4Go8f+0NKSnVW8zkWyN3bQwrwtEsqEi4pPi5kOLfg
	V7mrOA2teePCr7/DFFPw9WwFyMrYj700uM2VwJ8xaE8kq0V25jEXjmJjWpKWJ24CDekZazB5YJy
	nQ8kkrbGlzJe6az/Y9hAlF4Bmmvf7TNv3sT3NNyL+E3GP65hKnIwOyNfeQJl+SgG2cBV5OYqoi2
	vtHgjNR9ZJ7uPbfyryBW5EmNPHBZ/TA7hPVOsnBilAukhR/5H63pnOLxX9w0=
X-Google-Smtp-Source: AGHT+IHwK4bDQ+mR5lYZr/iC+APzVVCrHfAdgth52cx+8+VDi1qcA2tNOBQ3CpSUHptFv6+Tz9LObw==
X-Received: by 2002:a5d:588f:0:b0:425:8591:8f5b with SMTP id ffacd0b85a97d-42704da4b6amr56971f8f.59.1760620929751;
        Thu, 16 Oct 2025 06:22:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/7] io_uring: remove extra args from io_register_free_rings
Date: Thu, 16 Oct 2025 14:23:20 +0100
Message-ID: <1117db2950b38d285561111f74d5722ac576f58d.1760620698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com>
References: <cover.1760620698.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_register_free_rings() doesn't use its "struct io_uring_params"
parameter, remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index a809d95153e4..f7f71f035b0d 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -379,7 +379,6 @@ struct io_ring_ctx_rings {
 };
 
 static void io_register_free_rings(struct io_ring_ctx *ctx,
-				   struct io_uring_params *p,
 				   struct io_ring_ctx_rings *r)
 {
 	io_free_region(ctx, &r->sq_region);
@@ -434,7 +433,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	}
 	ret = io_create_region(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
 	if (ret) {
-		io_register_free_rings(ctx, &p, &n);
+		io_register_free_rings(ctx, &n);
 		return ret;
 	}
 	n.rings = io_region_get_ptr(&n.ring_region);
@@ -453,7 +452,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	WRITE_ONCE(n.rings->cq_ring_entries, p.cq_entries);
 
 	if (copy_to_user(arg, &p, sizeof(p))) {
-		io_register_free_rings(ctx, &p, &n);
+		io_register_free_rings(ctx, &n);
 		return -EFAULT;
 	}
 
@@ -462,7 +461,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	else
 		size = array_size(sizeof(struct io_uring_sqe), p.sq_entries);
 	if (size == SIZE_MAX) {
-		io_register_free_rings(ctx, &p, &n);
+		io_register_free_rings(ctx, &n);
 		return -EOVERFLOW;
 	}
 
@@ -474,7 +473,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	}
 	ret = io_create_region(ctx, &n.sq_region, &rd, IORING_OFF_SQES);
 	if (ret) {
-		io_register_free_rings(ctx, &p, &n);
+		io_register_free_rings(ctx, &n);
 		return ret;
 	}
 	n.sq_sqes = io_region_get_ptr(&n.sq_region);
@@ -564,7 +563,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 out:
 	spin_unlock(&ctx->completion_lock);
 	mutex_unlock(&ctx->mmap_lock);
-	io_register_free_rings(ctx, &p, to_free);
+	io_register_free_rings(ctx, to_free);
 
 	if (ctx->sq_data)
 		io_sq_thread_unpark(ctx->sq_data);
-- 
2.49.0


