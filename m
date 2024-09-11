Return-Path: <io-uring+bounces-3153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 263D8975BBE
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D23FB1F2397D
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D748145B00;
	Wed, 11 Sep 2024 20:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cNYeSQPq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B84113B582
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726086629; cv=none; b=HRTry+gPF7/PD5g4aFzOvzefL+NsYjVfvTkJ7WYWOh/CuekkSD4kPHiSd2G/pzG5k14csZrVbcTthl6zuHH+Rl9eivvdfL7sKkjmVclVg6/+k7MgwTi4zE3aud8PrTkkxs/55Hip2ug9c+3oViSQbln7onLA08QS5+pEMe6V/Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726086629; c=relaxed/simple;
	bh=KeJ+1XAHXqnaZmYxhDYpSKKmPD++L8hs4mdmozoofeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3nK4yMTX3qcRYvrlWA+HNG7c9G1zsfma9lZoDtlXst2sP8TdJzd9GF0KVtUz7cswyMJxB4rj6e8vbv6WKYjMVCk4RXwfjZdoy144Ipe+znFFEkcxecLNyImNcw3yfB1eL9KztL+QDmHNzCUThbn9R7b6ziTF1zjKEGd8qwxjIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cNYeSQPq; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a0220c2c6bso1054835ab.0
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726086625; x=1726691425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnzcgKOPDhAIhk/fMldP5pkSJeyy04T5uncSe/6MQ6c=;
        b=cNYeSQPqp+g9iKswYphbKPgxfLzS8CUzdgDdxvRPuvFbIpoqxTaMhBOKGe4lYGt5v3
         NPFuHCadD1VtmNO+qZtkdN71FutpX32+quZWAVTRzY9CGowWrMTnR0yIx7LrshqGDvxF
         NRDWW+DaBRsLR18LKFpmLInhFwSlnbiLKH/T0vCTeDQQk4l+CgbZvK51jzU7+3taXany
         A2qfrBiVt5JqS/8hiFk5t102EYaxFoNJOxWG5wgmPu1aZBk93mGKxSf6i5mYj1VGNZFs
         H0Sid97EFDnbd9QEWCK9WWBI63peWK4/hNZAtkNm2ICxzyM5o4WoC8cDSAq3BwsSfqYj
         cDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726086625; x=1726691425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnzcgKOPDhAIhk/fMldP5pkSJeyy04T5uncSe/6MQ6c=;
        b=joWZSCyaFD7yPuUzznJqQLT7GA2WPc4CvnBQg4YI2EPZBwUffBwzZpx4AeOWgouSKY
         uY5SBkUszMpWg0D38I6Zj6TMcwQONol+5NVxRKPI1cC0zkwvCrLPRWVVN2pMVF8VbZUF
         rSbHglHkRn0iwCLHYUEFAu/99MuXyd9zwWAsh4LlfPN5lveD3riGxqY87IEmL+BtiXhX
         wFzfXiajFEgmRxRysr5U6/8b2fH0aj0aqWmAfh3pkC5Sz4wtPsZIPU4noNS3zPwNWiN8
         8KNCCxlpAdLVIySbT+gbEICCWISabx9Wf8Q7hTGNkvJb3rZNZXwKfR80iCAsjfnXRHIZ
         Wkqw==
X-Gm-Message-State: AOJu0YxXU3Wb91kr6i/sAxKdfjtLfJs5OXtLJqOKOPYpb7+SxHXqGWIs
	fDehZcGI+KxpQxa/czlHdT++7uCjYF8qmMvgkQhyYbHsBjPZRc+sP/QsjQ5vWeKmfOFhphsB7PM
	1Xw8=
X-Google-Smtp-Source: AGHT+IH53hq6SM9ev+g3+wFmH2hB/HQRyHZKO28RqcPCUIhQhHHjrBwMzCV5G+3Mtn9J6tCYcvJ+lg==
X-Received: by 2002:a05:6e02:2192:b0:3a0:4ba6:e45b with SMTP id e9e14a558f8ab-3a0848ac72emr5874265ab.1.1726086625015;
        Wed, 11 Sep 2024 13:30:25 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f433d60sm185173173.26.2024.09.11.13.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:30:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/rsrc: clear 'slot' entry upfront
Date: Wed, 11 Sep 2024 14:29:39 -0600
Message-ID: <20240911203021.416244-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240911203021.416244-1-axboe@kernel.dk>
References: <20240911203021.416244-1-axboe@kernel.dk>
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


