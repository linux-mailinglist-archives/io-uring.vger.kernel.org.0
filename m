Return-Path: <io-uring+bounces-3148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD13975B56
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A10161C22292
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492431BAEFA;
	Wed, 11 Sep 2024 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Rs5LBesu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD391BAEF0
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085236; cv=none; b=fgozF2TwQ2Z9N+5EGsRZFzDLbi2HiqdQ2OGlsLhqMRJ9VctG+VRTEg2HIerbWWYWeTYE88yokQ9mu+iyGBALA5/4thRDMBXY26YJCG9whajipZxBE3PZyJlke3201KOZksCpNt2wh+zOyO+OyLoAip+Ac3UeoPStUV2BON2Q6pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085236; c=relaxed/simple;
	bh=KeJ+1XAHXqnaZmYxhDYpSKKmPD++L8hs4mdmozoofeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXmLfhDn0xAoeOMnGJbGV4+wwLHZmfd6s24okmVNEnge0XSOrHh3Y2RC/VDXRzro6uJRwhVYAmoowPEIm4PtkoTv4xLAtYecg5f3emIRNhp+QpZX65buC420kyWewYIRTmel606Tztuwx+EkHK+EOlnvNmjWs1pF+0s/RaN8hT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Rs5LBesu; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-82cdadeeb2eso8948039f.2
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726085232; x=1726690032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnzcgKOPDhAIhk/fMldP5pkSJeyy04T5uncSe/6MQ6c=;
        b=Rs5LBesutYfcMUG34IG5HDsbPJMr9mc6UrE0zmR/W+8LmhYUdz0lYqOYx6VuVqe6lX
         j97bAxeNmZqG4cP+bD5eiBYCef0e6ppQcvaYde+0V9VxVeTuCBwzXfecuA0pwgrR2hUJ
         zQBgKagrLH/aOzLJvTTrQrsrxVBtE6EhE2sopcZh9Hgl33fd1pxI0rWhVH7ZbuS8M1Ui
         81H+H/jz/azbK/QQjHbHq0XypzwGdNsLhSXtowaethyK+kgqUXiIt+EqfCQMl2t7jMmT
         5q9ku0Gx0D1itcYZZNKvKV0ScoArpcVokeZSg+Tq9BnjSYh5HC9DcW7JDsBYGk3shjze
         cxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726085232; x=1726690032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnzcgKOPDhAIhk/fMldP5pkSJeyy04T5uncSe/6MQ6c=;
        b=DPrhh+ktfNeKJpnZTOYUn70d+Mz2qStQAC8IG0xmdtHBGTZFiCjbS2kypqbuCLINPo
         NwLdgxSk6T6ViUMKcfGppMHXpHOAJWeIWUi5CexMjeixfx90iof3XuBT5BIruEQGHSrk
         6YrzCyRgWGEKYHjbiGRECsOShYkE2OFhJiUc68G/MaOgBIcv19X1GgSd9eMrvJUS1RFT
         el4iEFLHHsIkK9nqizNRb6/EnA5zrcEGkVrdG02HSRgxNSQWc66aTqMWg2l2e1KqJb+V
         mqL0q9A89cbCBNYT75Js0WHAhvAp2LaAklVc6F5blgk08k435u+XvcCnHNP3lNj8j8yU
         WXfg==
X-Gm-Message-State: AOJu0YzGpc0NVtbnRfd9tngEgDTkyv8VbkcCzSDsQ1zVduSNmDfL6pW4
	MEDwfNOm1jikP1SjTcIBYBcEa3jZ/Nz+vsQkQ4nqXwTydZ0rkLA12MibTrGyK+8PQLwrtpO4Z9B
	cba4=
X-Google-Smtp-Source: AGHT+IHc1zqcTxV/RY0N9UK9Z2iAkE5hpXmdqjuKLVES6UfaWArXzD/z1V14rUJjfLU3H/fQcg75kg==
X-Received: by 2002:a05:6602:15cb:b0:82c:d744:2936 with SMTP id ca18e2360f4ac-82d1f80b5demr112426139f.0.1726085231711;
        Wed, 11 Sep 2024 13:07:11 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa733a1d6sm289860239f.1.2024.09.11.13.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:07:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/rsrc: clear 'slot' entry upfront
Date: Wed, 11 Sep 2024 14:03:52 -0600
Message-ID: <20240911200705.392343-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240911200705.392343-1-axboe@kernel.dk>
References: <20240911200705.392343-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, but clearing the slot pointer
earlier will be required by a later change.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7d639a996f28..d42114845fac 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -114,6 +114,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	struct io_mapped_ubuf *imu = *slot;
 	unsigned int i;
 
+	*slot = NULL;
 	if (imu != &dummy_ubuf) {
 		for (i = 0; i < imu->nr_bvecs; i++)
 			unpin_user_page(imu->bvec[i].bv_page);
@@ -121,7 +122,6 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 			io_unaccount_mem(ctx, imu->acct_pages);
 		kvfree(imu);
 	}
-	*slot = NULL;
 }
 
 static void io_rsrc_put_work(struct io_rsrc_node *node)
-- 
2.45.2


