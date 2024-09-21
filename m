Return-Path: <io-uring+bounces-3247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E01F97DC0C
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 10:03:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C88DA1F21F67
	for <lists+io-uring@lfdr.de>; Sat, 21 Sep 2024 08:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4941C14E2E8;
	Sat, 21 Sep 2024 08:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MSAuFgds"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDE9149C50
	for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 08:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726905806; cv=none; b=JfHXBYIbiFPt3bJfCuIGli16/BueV2mDyVC37u65lxQnIw5LCUVFlYk/5hCboWBQx/fNzfdCekOF/+Uapc25bkKHk22AsBSoR+PKGD+aQWVMaqZ2qzwBnXqSmjCBRmCJYW5dbP/59QxGJJKxnAWeRwSx6XYmYhwHB4fawnTJWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726905806; c=relaxed/simple;
	bh=iqtEPxxhQJufhJEFjqHKqOcxDDJaeezgD3I9swoZLmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWkbZXb2egevWvyaelVFoV5weBtDWt97lBQL/fA223V94SIRu6RYoyuYPOS7tfCkJCtEZUm6mou+evfXCm4kg2mn7bEodozwR+ob27nPRyOVUmaiOWQ8bBvU898zjRTu8ngy2jFFwSRyr2BC1kGRBJLNwBb/mLQS7/SHYiwkAWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MSAuFgds; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d60e23b33so327623966b.0
        for <io-uring@vger.kernel.org>; Sat, 21 Sep 2024 01:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726905801; x=1727510601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5DwLe1xcgJOT4lqdoFCiVsuxMWz9fD5sQA3LuR06z0=;
        b=MSAuFgdsdPIVjQBJhZ+BkIhYBXJtlCZh6U+Hetey0fT5h4+faZTGz1JpeXOEtcspUV
         HSzGOqvGW2C9jSfqj48KKYGPAiD3raTWIvRC9ITaf7olGHBsQWdz0xrin6iLCW58ncW5
         x/q1n0BJS8MH1MTx7LEz0DWQ5CkEEJ8JIdM7/OPPbkTbxpZ5PBZxsQVyyjRisqetpTBU
         v5bhwVMm1v7yYSlFoHUQMB7b67dMFEqth8+ArG37PzWjzDj7UxwtlCcPykVB+AvR3I6p
         H0fuydh01ytcV0nGpYvhSKqO/G5JeRM8cgDqOR1CAlFHzxpETK8mhAZIq2O+qisjaGv4
         GwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726905801; x=1727510601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t5DwLe1xcgJOT4lqdoFCiVsuxMWz9fD5sQA3LuR06z0=;
        b=BEj4el5iriNvcNpEeV9tr9OM5Ep2hY0B4kSZWOKdNsJBAU+7CGIlJhTVGvPMVzUQig
         98dL8AcRZ0uuMiKo2h3Jbg1PEv8y2vUTo8FqzVPBqjISHTB3z56JifEEM1jIeveITbDZ
         me3ULI3EkbJYTJ3enr3csgPjIiiYxuAL/lYgHIJ5dqcSgiqQeQsGYz9H1bc668iMrdK1
         XZ5ubgZSNKzWyGBnDgnHfATiheSoD3g7SNCwTXv1NPXxCnsWMqoASpjuBvdLvhrhMD2t
         w8G5mFOXRuQqJKuC6Cah7ll5OPMfKD/22/ZseJ8M55amgjgH1ibV3SJAXYCeF8JwtPmW
         BhSg==
X-Gm-Message-State: AOJu0YyG7nlzgSiBxKN00ptbYszzJEXmZkWOOAyjpCjjLqGbpienligk
	/J84T+Zy2Pw4Hmo3u8kqnFtLRZYozcfJHFTWyPHZAe8shyHp8mLRyHwj1/RCBPqjPQRRWtqDFe0
	EEcqxuq0X
X-Google-Smtp-Source: AGHT+IGyfALNaxvW65+Gq2y9YdFcHVIhSbx8uw6MC7PVWrYrCUvVUJqk2aWiouNdTWJ7pB+2Yl6z3A==
X-Received: by 2002:a17:907:d599:b0:a8d:5e1a:8d80 with SMTP id a640c23a62f3a-a90d5779864mr477572566b.40.1726905800640;
        Sat, 21 Sep 2024 01:03:20 -0700 (PDT)
Received: from localhost.localdomain (cpe.ge-7-3-6-100.bynqe11.dk.customer.tdc.net. [83.91.95.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df51asm964583666b.148.2024.09.21.01.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 01:03:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/eventfd: check for the need to async notifier earlier
Date: Sat, 21 Sep 2024 01:59:48 -0600
Message-ID: <20240921080307.185186-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240921080307.185186-1-axboe@kernel.dk>
References: <20240921080307.185186-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's not necessary to do this post grabbing a reference. With that, we
can drop the out goto path as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/eventfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 8b628ab6bbff..829873806f9f 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -69,10 +69,10 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 	 */
 	if (unlikely(!ev_fd))
 		return;
+	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
+		return;
 	if (!refcount_inc_not_zero(&ev_fd->refs))
 		return;
-	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
-		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
 		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
@@ -82,7 +82,6 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 			return;
 		}
 	}
-out:
 	io_eventfd_put(ev_fd);
 }
 
-- 
2.45.2


