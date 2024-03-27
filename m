Return-Path: <io-uring+bounces-1255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B8B88EF12
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71C72B23A5C
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2511514EA;
	Wed, 27 Mar 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MGQAUAg8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95B1150999
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567182; cv=none; b=kC5V5Ve/gdAgijkWli8jlXwLhLFOvMiaM7M87aKNng+gnU1xOjzgn4czy/N+v5pjVYlOX8W+nHLYy8yMo8b8hMMMCBs7EFHbytpzNSyKdGb4UVqhi+Gs112Wuu2YRRIOkUZRy+jcPzZgUTyURms/ep/oFoC77y54kqGz4SsgMps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567182; c=relaxed/simple;
	bh=IA363V3fu31t0PPCUsgoiiOfsNv8iW0Wnt/MjZXXrdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/pB3/Q6IZfKVpm7usEQ77xvh8OOBWrRPBb1S60bJaC4pu8dddoGXpfjEr3suspvpJPvkf5UIL+ko/WSVEmCC/5JAFPrwn+nv+GU/qGLGm+AHvrpq/qL4pp+lKGBgPNB1L5Ne1TFCXDlAvl8Uyd3R/dcYozv0OAIp6oIPN6K7Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MGQAUAg8; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6c38be762so41801b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567178; x=1712171978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQ3pMD8RptEK8J/o1yry4PoQVSvIoeVGC8WVz8qkQnE=;
        b=MGQAUAg8JBiuAndO1P/LkBeEsL+kBWIM5rKFLkh8WKIrfaiZ4pYwNz0FDtmqtTbBbN
         r9XtBJgJyRPVCvspvAEmaloOHoUZiZi7TkDfB+HC/3dCpSMLv8418wxZif0+EF1XgMyP
         gtfvNpIzIHtlMvF8sAXP5A5dJr40by4G98LMpXJ/PlMhTtW/GuivS5Noh1YURkccHwHb
         tThfeiUh++7XVFUAG1yqr6HYfGAOOsB4eOCv/yjExVaXDjQIB0P7oUqz8un/SF/ZQ/+a
         Ra/jVmJ+T2kcK7X1kO3B0UPjyA0esSodTfNh1cKz8UoYlVh/1BvkYFvjKofdpsv0jhhZ
         qwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567178; x=1712171978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQ3pMD8RptEK8J/o1yry4PoQVSvIoeVGC8WVz8qkQnE=;
        b=gPgDC9ID5s5/hfHNEqwa7jja2rNhVeXWYn/07zWGmLNEXV00MEwOPLJ5Ypi099y61g
         Z6K6CtGJ67bq+7pPzF53a1ZpPe2EZr2lkctFtQZm//aus1JTffRLloK+7N0hwsX5xFSp
         rI/fZ3YQ653cmvnsoRoBegjz3dEvdZ8lh9iBc6D318qNRnRXpkVLTJJXfN2E/19qtfvC
         rK8uKd0p1dsaTW/LVK31DrcntU9CsLGklsZSNALpTpzCMIBVlpiy6CVzmxAKpoCjKpVK
         lrGgtRK6tNGLQ0J5l2IthtID0jnY31aSeKemcRaELvyaMip2E9uOhnHAWhjhu9EbXV/o
         /CKg==
X-Gm-Message-State: AOJu0YxNhztb4+YiVYrN6FBAlXOsu+QazHpPaDK+qfeUKgLhFbDE8M/q
	ppb79oSRSGG6OCU0KWIvE0gDH6VBdXh+bHOrfhQNNDbYlpSVpnFUo2gzdUO4Qky2ui5GHnR5GL+
	w
X-Google-Smtp-Source: AGHT+IGDi776sKRTAaThr1/xhwh1sZyR+nsGH01NhnQYNzLClxWWhJ//PUYFuHG/OhE6yF4O4gzraA==
X-Received: by 2002:a05:6a00:39a3:b0:6e9:ca7b:c150 with SMTP id fi35-20020a056a0039a300b006e9ca7bc150mr830072pfb.3.1711567178023;
        Wed, 27 Mar 2024 12:19:38 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/10] mm: add nommu variant of vm_insert_pages()
Date: Wed, 27 Mar 2024 13:13:36 -0600
Message-ID: <20240327191933.607220-2-axboe@kernel.dk>
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

An identical one exists for vm_insert_page(), add one for
vm_insert_pages() to avoid needing to check for CONFIG_MMU in code using
it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/nommu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/nommu.c b/mm/nommu.c
index 5ec8f44e7ce9..a34a0e376611 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -355,6 +355,13 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_insert_pages);
+
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 			unsigned long num)
 {
-- 
2.43.0


