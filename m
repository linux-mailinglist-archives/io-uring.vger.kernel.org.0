Return-Path: <io-uring+bounces-9004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A77B29590
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD4D64E7D7E
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE5B1DD877;
	Sun, 17 Aug 2025 22:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THHw1X/g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD3422ACEF
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470599; cv=none; b=lFRlYSBsnizND5uzQUASbF3sEYTwzs3kVnKtMr3ZymKYubt719iSt8yxU05rOJ4k/+r7293r97sRHWgEPy+ALLyHLFBxqDGm3zv62msstOvBG+vm7wxHGreH8pD1q/UPIFuoTiALpDZp0bEBTy0oqZNOYPCkuJz9hlCfCnN23lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470599; c=relaxed/simple;
	bh=QkObTeD1MHgc9Chm4Mrhdwfy+9QuYynPFl0+PT7z7gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrZzMtM33SqlSbmYkLLhvNRJrsZwCshQRbpl73vOjD/VL68Mh/z6IPp4BVfUjbcv9h1S6eyqtpGuf7U+nQEh1NthCG7NTjh7B7kV/OsVWT/F19ZFnxIH0+LqOWiy+k9XdXCX/Ye2BAgMPjvWxMyYbVGVdjcQtV2DPUDFg5F4WPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THHw1X/g; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45a1ac7c066so19075165e9.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470595; x=1756075395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yT7SV6kVQIpjPh2r8Lz9vRTTrnLVcJN9bZnxg+xGdMo=;
        b=THHw1X/gKwvNVKJ/J34JWZpi7BMceUWbcnC9qKB3AjGpoxgeZcITgDuH2V4XKZhooV
         3QS1wPvpzDtFWtqPxNxobPebinTHdcmoXQivZpPb2vHr/euBOAsYLV/41hXZqaeJOoEJ
         laMD/kBbL5I6rl4gdDVcPvOmrjUowTeWERzKW642mv3zUhdY5QAI4S7UVujP4XsOc5HY
         v8qyZ5Mwi85WPUy9w8yyKDw3ThZoxq94bRhbHelMGf9dsBP6trF+6GO90oEkOGyJTctd
         AvSz773xJUJffN12rQMAsqqVyCuW5Xj0RmEjN4VsEyzL3Lwtk5zZh+Dl09C6RPOfoMtR
         2nhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470595; x=1756075395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yT7SV6kVQIpjPh2r8Lz9vRTTrnLVcJN9bZnxg+xGdMo=;
        b=A2kvTOk62mc8G8W4txlJxEKCydvPBsc9PtiJprx82MscuCt7QDDWJgNp2S1wCaxV7V
         HPIabglOnts130eVw1HTFyuhqmZj8Tzmn6Nwv50hMAinF0xxFzeMkNbPWuFzLsajYk5h
         eLlQbat08zDSLkEE1OBU7uXSjoss5rwcAI8FLP9gwwy/y/OgAnKg1+d5ekMQrnwKRxnA
         T0fXKNLay9cnDCmZ0llrpQzAIwadN6TcU5X9YL0lSjmf2bABtrNI1pNWjq9C0St1vbCU
         nRyK1X9ZafYsin989+HP+I77i7QcYe951ioNS6xUeqcX3ZJ1IuqN/LR5ZHbHRdNgkjGJ
         dxLw==
X-Gm-Message-State: AOJu0YydZLR/TNCS9GgrxJ33D+syI/1fw+McWy/+ppTwGV1yaSxEIwcv
	aIC3vj1AYGyj2pZwnTbeTSY+itrP9E96NuGrGMReEkMK+3/H5pc/scf7QtZl0A==
X-Gm-Gg: ASbGncvuhVAZlcot1SHHadguThS/nfZQsLK6T59fm0L1n81VMep1OJ44MgTuT2iJvfq
	d+dVZDbw0sMlye+mWlt8qRBhT0AhsKROHBfGa+RO/OiX14XhY17ugp9eu8mD+Ra5qKmmuertbLy
	AG7VQD3tU9Vx4rv+z8kIxTOuKIINYl5siw4Q2Rf8dDAzdPQBFixG2hZWDf5ahkXBuEOo45TjTgm
	0CPYUp7UudBrliF9zq/9bRAxJ7hGQTjyfbRMq0/Sw+OacacWsPVfwhbk2qHkqSlT0OXqf/8izJY
	avpWMWaF/GR/nCRIQnY2bD/t9bMjpnI4i2X5psMOYC3gR7BnKKqOzkY07fUeGA+peifdscL1BUT
	Z0DZR8v4oqLMgqLokS6eBWYbgT8i/LvwTDA==
X-Google-Smtp-Source: AGHT+IFq8jXYavgvwN6UxA98IL1dIT0dDZLJxBTzBKd8jGbKj4+PM3+uDIhoUNi752yGpmfLSwMnWg==
X-Received: by 2002:a05:600c:19d3:b0:456:2139:456a with SMTP id 5b1f17b1804b1-45a21868957mr72013735e9.15.1755470595406;
        Sun, 17 Aug 2025 15:43:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 3/8] io_uring/zcrx: check all niovs filled with dma addresses
Date: Sun, 17 Aug 2025 23:44:14 +0100
Message-ID: <0701d3dbaaeb27afe9e92dc04cb593ed5db9592f.1755467608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467608.git.asml.silence@gmail.com>
References: <cover.1755467608.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a warning if io_populate_area_dma() can't fill in all net_iovs, it
should never happen.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index ea62e13b9500..be6d59401dc7 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -77,6 +77,9 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 			niov_idx++;
 		}
 	}
+
+	if (WARN_ON_ONCE(niov_idx != area->nia.num_niovs))
+		return -EFAULT;
 	return 0;
 }
 
-- 
2.49.0


