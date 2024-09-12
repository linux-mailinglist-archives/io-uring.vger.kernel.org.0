Return-Path: <io-uring+bounces-3178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F5F976EE6
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF745281FC7
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4290F1B533E;
	Thu, 12 Sep 2024 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F1ikzfQm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2FB1B9833
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159227; cv=none; b=S2h459IwCAK+4MFS39WFyWHzvfi8FIt/mt1aMBQXB0gfvbIwdmo0/3ZL+D2T+FDts40ifG28XvZMkmJtKrSotJBGxfm4uEcNOAK6HuFyKs0SVHqW4U0ii+Czt4c6eXt+Tfb2HdaghCY2BIBAXtAA1lqhdmveHn04XDVhy+x5EVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159227; c=relaxed/simple;
	bh=KeJ+1XAHXqnaZmYxhDYpSKKmPD++L8hs4mdmozoofeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/+nHYFdY+KBw5+lRhx4Y5QVBSyo5Ch5QIRfpuhAYtIlts/5pTgK5OoX8VoPgpMrhtCwCiJaTtOw+9ILF9JqYO9dI1+ECzezAt4WoRHL8frcbdWOYS0gCDGZvf18c1M3Xm0SKQpkR47ROFOyND5orOtwKdg2aT+V44kId4sV4Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F1ikzfQm; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-39d30f0f831so283475ab.0
        for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 09:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726159223; x=1726764023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnzcgKOPDhAIhk/fMldP5pkSJeyy04T5uncSe/6MQ6c=;
        b=F1ikzfQmohxjfIahao+enzNhY6NyyXfzh0YrKPY+uuZjnE+IJO0+hmEY2GsCXemksX
         tbDjcm7MbozGnb37wRvFy8gpsi5SeBFmUjOaFtGZ5mQncLuIdpmYGK3TC1fT1b+xQ7HV
         N1/WNon/dReT66Jdi9zAa+FklR24hIX+0bDJnfFjMdtuqG62sEH3fO83W8+1iW5+QRd9
         5tXljhnV+6KcaUTX9wjzexemAgt7LyXfxFr4JgS/PjrdPdTc8RI4GQASqseq75tVrdxa
         nLpjmOt5fmYAyvX6yzrESRY/Wv3FaF1L0tMCC3BnM0YPHFwuNhAmqOHL+uW3jmwAt2Z9
         eBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726159223; x=1726764023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnzcgKOPDhAIhk/fMldP5pkSJeyy04T5uncSe/6MQ6c=;
        b=cd/zlPj2bjWGJYIhKteV9jEy5zBecOTY3LzXip68Dd6SiDJqU59O5kJ1wq7h80IpYc
         TYB2AgOG4wHFCPc5PiTvWq9EoOwOJrB6QE/+cMhb6hawOZV1+JKdbzGHVXKFi6EwEJcc
         +k2jkDiXC/R/9J3yKLgG+k4yQDwIc89hUDLU9XW6jDuo8D9ZFM5sTrchqOkRE6oYRisk
         JSTK8FhVTxPY1SF0JaaBmwPg1Rp9wc+c34rMsA0AHsjD7YuF67NGHXNQ2LAb+Z4EM5Bn
         V+XrclTqZN5EnoYSZ8S18Du5vFAR68vgX1MVGB1/0WEULY+qH0/Z8TpYntkTBnpnVf0C
         Lncw==
X-Gm-Message-State: AOJu0YwqEDzqc9a8yu5egoilWxWWzf8qWX6Ozs5Ed6rpdwd5uBV/VHu+
	yc3I97z6XxgLo8lmopeNALYuQgx2fP6fU8Aj1P2V3so+M6hw0jcG9PrNzIqtn9ctQCPM4lh4VM0
	F
X-Google-Smtp-Source: AGHT+IEtL66kklFkepxK9CyJ+PRiFPO+yAQRMWm3Zrf2RPIw0I48x6XIPaFeQ9BwPfub7B+e8mOYfw==
X-Received: by 2002:a05:6e02:1aa1:b0:39d:25ef:541e with SMTP id e9e14a558f8ab-3a08497f3d8mr31691115ab.26.1726159223082;
        Thu, 12 Sep 2024 09:40:23 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a05901625esm32564985ab.85.2024.09.12.09.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:40:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/rsrc: clear 'slot' entry upfront
Date: Thu, 12 Sep 2024 10:38:20 -0600
Message-ID: <20240912164019.634560-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912164019.634560-1-axboe@kernel.dk>
References: <20240912164019.634560-1-axboe@kernel.dk>
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


