Return-Path: <io-uring+bounces-10034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6B1BE3AAE
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 303FA4F7D6F
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0AF1FDA82;
	Thu, 16 Oct 2025 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+Jv2SPk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF8F1E5B73
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620933; cv=none; b=ml3AOWYxNNsRjVli5HJdGQQoSdf19EnSXewPVmSiY7FnFw9SLw5VQU9refkCD3MKYUezU2pg92sbKYkAGh4IqOPv2siXFBG19juY4Wy4PLtkfsC+2r1AmVyo3CLPSDrWmlg5SL87WE/24oOaHiAcF4i6whrj6y6pFOjNFRzZP3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620933; c=relaxed/simple;
	bh=6zb+Tw7/NXQ4k9AgY4IFK6Br+05zK29vGlxpEBCbKl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwwKltI6k5nLpN+q4FZTo5PSKIXRgW9UBj0yKLfT8GhlepP0wcTKB14JDYSf0WJu0eLKF2IK3z+23wFGYCHgsz29qKGvE7ZE91qsb+z7fM07LmWZyF5iwRbsvNVaoNn/2wE1lm2z76Z9ReZmIbbqCy2hEWxAVA4VzMEV7YpNGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+Jv2SPk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-471131d6121so5252195e9.1
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620929; x=1761225729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9t7XwOAnApuVbvLsyALCTei+82xzQgjGtDEwrHFoKpk=;
        b=d+Jv2SPk1kNo9bl2I7dhpcWCPU+iw1vcbo3iui/mhnYi2JfS5Zui+liXoTMCjP10GR
         yqS2jqB+DH7dr+70tnnL7+PoaffVlPkR5dXZ7WGaBHDE4i1mzwpkLcw4RdavnAMiW4xF
         ZoALIxNPo7ZSSjW5jetM99gclVF9qNc601I1knVAYCTPzKyDJdU6DuyTFKVXRyFbXbLQ
         tRQ8H08qYgxRyXTxW2jN4NDkbLJMn9PMtcnrasLVSLEOBE0LeMVIN+bsFxMemMJYVA3D
         8o//SLKEAI8dwYoUjpjN7l8DRr68Ot4oTsuLfExiMDJnPezib8z3rv1/qscRngbh2Joq
         NJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620929; x=1761225729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9t7XwOAnApuVbvLsyALCTei+82xzQgjGtDEwrHFoKpk=;
        b=hLFMEnECNG6RMVtBb5Csca/kcKa06PsnpyCLjpJsmeKeYBHeh9cJn3/UM1JHgv7c87
         Q0L1T/TbI8fTLqoU7v2O+hJ2WyVCIrCshm4kiEhWrLgP7t/E/s72oR98ifHuroDRhoZV
         5z7bjMVCIpO1lMSmevoDY/awPBxQPJKQgZlZ3Bbcr4Pt9ykTPB9OhwqjqKh6crQU2NVh
         gyLejOWxTB1LeXgD1ADWhKIRKCF2cpgU/z/C0zIv9jJGq/3qv6TpVF216wB/kIKhm0xo
         Ta/q84Aom1lYMcCN6zxEP+TlgxtNxv5uYcU7+ob0Z0iuO/uX5MfkNMw5je6OVIxN5UZR
         9UGw==
X-Gm-Message-State: AOJu0Ywxm38XfXmJQFhB8R21oW2qt8YnDTpk62BFbWeGqJRLXvhb2CbV
	O13PbUJZ4N2Lu0K45NE9ng48n4dt0lX7KOSGtSn5RbIxUSRdgVh/tVvSsDKhhw==
X-Gm-Gg: ASbGnctj2p8jPAMA7i9RaJSsoOSNU4ZdtPHkjEg0/6/+tJPZQucFU6z0w+wYNdyqtme
	WADBataR599Oroserpw/QaB+w9Pt/QlpJX0vxLe1oAH/3DoohBWsff/RgxokEy/yBDUFY2uKEXF
	I6S4DGWp50D3QVs6kUPucxm7QBxxqBnnp9tfWsnG+8q0es1OOrGiIX3wEi+hwtp4Wy5cJWKc3j0
	vIql6ur1QqkMhW25DrZJkas8SsJHrUfWUupZj9+6mNCXg1nmdjOXL2lTrdy90AGQUqvyc7q9o0n
	pOq+gCa/TUYYMjjxHpGlwGoT4OB3XYESpU/zDY942jAQPoF7GX++CuGYo9w4UK6UoTFX+CbAqdT
	+eqd9RAU+rWrWC/OnU8EbN2WlP9cWq8dsJANpXBlbJxpLYOHtGX+Ui89tVWc0wKPzLuBP4A==
X-Google-Smtp-Source: AGHT+IGiW2zDOduLBKdv/kO04CaNp1e64J0EGe8p8MecDY8ZmL3oZiN/fLqVDi+oCCw+g93U6rwWVQ==
X-Received: by 2002:a05:600c:c174:b0:471:1415:b545 with SMTP id 5b1f17b1804b1-4711415b71bmr12642135e9.7.1760620928938;
        Thu, 16 Oct 2025 06:22:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/7] io_uring: use no mmap safe region helpers on resizing
Date: Thu, 16 Oct 2025 14:23:19 +0100
Message-ID: <e5042c8863c4a60a2bb71638b05007181422f3a2.1760620698.git.asml.silence@gmail.com>
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

io_create_region_mmap_safe() is only needed when the created region is
exposed to userspace code via mmap. io_register_resize_rings() creates
them locally on stack, so the no mmap_safe version of the helper is
enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 2e4717f1357c..a809d95153e4 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -432,7 +432,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		rd.user_addr = p.cq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
-	ret = io_create_region_mmap_safe(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
+	ret = io_create_region(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
 	if (ret) {
 		io_register_free_rings(ctx, &p, &n);
 		return ret;
@@ -472,7 +472,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		rd.user_addr = p.sq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
-	ret = io_create_region_mmap_safe(ctx, &n.sq_region, &rd, IORING_OFF_SQES);
+	ret = io_create_region(ctx, &n.sq_region, &rd, IORING_OFF_SQES);
 	if (ret) {
 		io_register_free_rings(ctx, &p, &n);
 		return ret;
-- 
2.49.0


