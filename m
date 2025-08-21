Return-Path: <io-uring+bounces-9162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6ECB2FC95
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4686E1D20FD2
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D19281510;
	Thu, 21 Aug 2025 14:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bd/qWCCO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF7324DCF6
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786009; cv=none; b=lz7r7W/YXJ6ax4ZEFLE9HBRCzVy3FrrpAD+Tj5miE3Vr00RsTifkPsoJ/ztgf5yJlMgCSFm2err26VxQdwQGKsRtWSFmRgNRrRg4tYi3Ve943JHDf/CHHV39lCVAeT1cP2MBpA3Zjpd47OTHhm/2QyZs+2Ar3DW6mVAeCScvdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786009; c=relaxed/simple;
	bh=eOpOcG9mNnOvunH+6HUTWGnFNFfkCUEmeRi0lvZOms8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxuTkBx+ysNJOQoTJBG3G7i6QwrYgpw8btSpgT0hg3/K5hmyoKd6Akmm3u+1c33F2G8bNzd2o1WJsgKxTS/YwhnrQ/gur+2dA4sZDAX3OoLASai2qKB1UaDm0hcS5+DYQxGh3Z0v4ZDy2x+Yinko648fVar5kH/XFwIZYjdEf+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bd/qWCCO; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-88470af142bso85585639f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786006; x=1756390806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXs8RA8orWwnolYDYMRWEMjo7fPdEdY/frZXY5Mo8so=;
        b=Bd/qWCCO2ySPN1r+lITs724qIHoYbIr8D/QTrfHOJC6rGlAa938c4dIhxAKs7OhtW5
         WikM4LOx9p33igMdzdxJo2t4IW41A7vIHCyFvNhMngBL7h2p3e9XtQ7rFDfzngK1cFJa
         BbqNmLpm/Uf2+Opx1zufSaQp/Kh1xzY19IlayrsstD1QKu4vAT07nApJSoEhJuPKa7Eq
         0sAG7XYzdV/4e8uYT9raRVFfQS4Hc/kcsqbP0MQWmT7Meqa+LfgM29Ahv+rgbyf+oj3D
         +7QzUS1ee9wtcQ04hEm8vEvTUPKRBmNhNwgD+w5+QHKhUt1ul6Kgp2xTT5WJHd/T5eDA
         Ab0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786006; x=1756390806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXs8RA8orWwnolYDYMRWEMjo7fPdEdY/frZXY5Mo8so=;
        b=mfd+ijBzaCUvdf/OSgAxm6C5J4IYtPbdjLiTli40Qr+4zXq+fYn0ssrssFWabEdilV
         rKLNkVShAawpjqt6pBO4VV4jMvuMVPWcb/h7HoSXBRKileM8gfcwDr/F9MUV8Apufh8P
         qNi/Rbpw60lX9lrUNwvLYM28CHE50kQokQezRHCFX3IJ2nEoH6B14VfujLbb4nY935Ru
         0wyu7lAL2kw1PbPHcAmdAA8fZFBigXAbOTax0XaW66bjcQNOGgxmQPGDbKeh4UJKUFv3
         HW7n8LPD5SF0HxI5wyueuwBVof+i4zbKXFyhp9RY+zFXL8azhDyzzFvKmW2T3Z2qcV7T
         S97w==
X-Gm-Message-State: AOJu0Yx6S2jT8PmW8FXRAeSxqLZQyXE/dC6AQuZbvzMvKEBAzE89tAX+
	qwm/hGKBMgCuaruV0sbWa6sNM1SpXINeHFE2tQOrzX7qa+B7AY8kABGD/7EHTBNScQpJz9EAdf7
	9GvDU
X-Gm-Gg: ASbGncvuTE0uqoGsq+tUrX8tEEfveYUmBGEepA5JdUmW828UoDVr5Y9JtUPYtpE6X70
	NakpmOFmF9KQg++lhvR0bRUwgfLfvlmM0zfijC9Xc3q05hlbv7REj0XuYrLAOOKeDph8t8fO/qV
	T8it9rwGWYM885o2uq1v5XNBQEWRV/aLpWAuc7LErwwyt2HK76ZITnjApqJV0ELbdCqYOmy8gdG
	2e5K1XWmpKpRw8GfjslWzinzthBUyC+/CJExvHTonyX/vjc1aViNV2/3jaEqA0fx5eeUbHWDXOk
	umBvk8UTY18EHABcIRBVn4+1tGylcU6URyqNdwcAMqVykRDHRtBJDY0acrtxtAc4rO5AEI8DMCH
	CRPqeDrMim1WTiAHL
X-Google-Smtp-Source: AGHT+IFxWETOIfjVP90dRWDN0m/+Qnw/Gmr/4eUoVRfNs9QzFCXW0TY/wiNpIuzgArZPQbZ+wQ6QcQ==
X-Received: by 2002:a05:6e02:1909:b0:3e5:4a07:e6f with SMTP id e9e14a558f8ab-3e6d444040amr43749975ab.9.1755786005921;
        Thu, 21 Aug 2025 07:20:05 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring/trace: support completion tracing of mixed 32b CQEs
Date: Thu, 21 Aug 2025 08:18:04 -0600
Message-ID: <20250821141957.680570-5-axboe@kernel.dk>
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

Check for IORING_CQE_F_32 as well, not just if the ring was setup with
IORING_SETUP_CQE32 to only support big CQEs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/trace/events/io_uring.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 6a970625a3ea..45d15460b495 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -340,8 +340,8 @@ TP_PROTO(struct io_ring_ctx *ctx, void *req, struct io_uring_cqe *cqe),
 		__entry->user_data	= cqe->user_data;
 		__entry->res		= cqe->res;
 		__entry->cflags		= cqe->flags;
-		__entry->extra1		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[0] : 0;
-		__entry->extra2		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[1] : 0;
+		__entry->extra1		= ctx->flags & IORING_SETUP_CQE32 || cqe->flags & IORING_CQE_F_32 ? cqe->big_cqe[0] : 0;
+		__entry->extra2		= ctx->flags & IORING_SETUP_CQE32 || cqe->flags & IORING_CQE_F_32 ? cqe->big_cqe[1] : 0;
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x "
-- 
2.50.1


