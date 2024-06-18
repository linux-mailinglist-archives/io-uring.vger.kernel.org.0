Return-Path: <io-uring+bounces-2252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CBFD90DBD8
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AAEC2814EA
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E07215ECD7;
	Tue, 18 Jun 2024 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qadNHiux"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC1215ECCE
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718736422; cv=none; b=pSSyEmzkuFraiGQHSGBMDROuAfgrY1Ljd04gJn/sJDiAQvQgrZqS8fKek4YsgqSc/5DysupSEW61R2lDI6tDiE3R3h0XRpdO4rQSLcK5Ap1NsU4zHIJB7toGuFlh7DIFhiFRaLZ6K7s1TRFbd/8Iu+qGMbCTKD6V2uOgUuQIBeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718736422; c=relaxed/simple;
	bh=pPM4qFrbUvbPHk67M3O3X5V9JmC4lxBwI5mQLqJjLgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKCbQtxmgUA12zpdBOUv9PzGLaKShBZTkIsnRqowwvpkH7OCmOwgTFDr+XyDAmMfceI9OCo2xil1nWk5TLWfVP2kEuPsvBGmtY7wWGfjL4gQ2Dw25v2ByF1MC7O4LhqL4dyhhRCcpyV6jkO1QMrZ8ZPEgUPq2lRmo+ETT2nyYTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qadNHiux; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-25944fb6f47so409107fac.3
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718736419; x=1719341219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWLyraWkNmsKDtgBatScqvZ8wG4J1vV6fqX3V8x1qdA=;
        b=qadNHiuxHjoe0rpvbluJvgRUVDYEeoazy6cBl2a/H1VTzkn0N3A8QYfSwB+f/pgWbP
         iM2HVlu32XY8WJzV57jYJqdFgL5eTuRFYgFJU9UMD6AVhxPYlLKzdQ/IAo7kIXcRjLdC
         XhplGtJYcYFKGqSjDOT6nwMu6rOEm4leyoCr4bG4n8RcyAKiHMNX597udwLAa1pyORNa
         2+FJ1cPTeYq6+fewZSPkCE5xBmTxtKGYHrrK1LO3cVGpjNoCSR602UAThIGtxxgpi+aW
         /2M066qgR1gti/gzRxz/AdggvhTg64L/8dA/ZiVIaWEeO7prOJITb7tCCnukqEGhDTdI
         OmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718736419; x=1719341219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWLyraWkNmsKDtgBatScqvZ8wG4J1vV6fqX3V8x1qdA=;
        b=Ns5oQLgyb/PsrtN0A1LI/XDcB8AWzjCxEeD60+CYUZzQaBTbf5AyiNdDEUxxHF/IC8
         7dBT7cY7ySdH814pdre3CokmsH2Ze8rPa2SRP0U4qTObKPmuDgz5L1LCAZ+BJba7KndW
         ERRb7SJ/BR0O8p7C/UGfYckT2aWFdzyMQUD5xFt0snG7AKWx/t3Iyg9LukYeL1x8AOOJ
         NAYMxte5rpw9FtlJaSFUpc8mrpmXSrD+KYeuEDU/yPrXQ0Jwj9M3pbXmsJFHr0SQ8BhS
         fHqgJLyxlAdwDw3Y1gIbadXktqmM1IpdL5h8DjIfZ8pcXbPoXdBMqebUmtuBOSrUQSc4
         5g+w==
X-Gm-Message-State: AOJu0YxS4+YhknAagpJZ5hR+GDkZTWY3tsx1puKyI+T/GaRx7ejaTalu
	zWygzHoFMsiGQsc8gIj4ME4UpXmGpwqybihcjo+r14Gsws2LqDvot2g17pZaRHB85ak26MeA0ss
	r
X-Google-Smtp-Source: AGHT+IEVRg6cD6qpGr8+XyJjDKivng6kEp+vVL5tOXubNDbwXJLlTvOiAqibHGeaWHPRv29C3p3zwA==
X-Received: by 2002:a05:6871:14f:b0:254:cae6:a812 with SMTP id 586e51a60fabf-25c94d8a94emr680952fac.3.1718736419170;
        Tue, 18 Jun 2024 11:46:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567aa5e68asm3297475fac.30.2024.06.18.11.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:46:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/3] io_uring/rsrc: remove redundant __set_current_state() post schedule()
Date: Tue, 18 Jun 2024 12:43:53 -0600
Message-ID: <20240618184652.71433-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618184652.71433-1-axboe@kernel.dk>
References: <20240618184652.71433-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're guaranteed to be in a TASK_RUNNING state post schedule, so we
never need to set the state after that. While in there, remove the
other __set_current_state() as well, and just call finish_wait()
when we now we're going to break anyway. This is easier to grok than
manual __set_current_state() calls.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e89c5e2326a2..60c00144471a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -224,7 +224,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0) {
-			__set_current_state(TASK_RUNNING);
+			finish_wait(&ctx->rsrc_quiesce_wq, &we);
 			mutex_lock(&ctx->uring_lock);
 			if (list_empty(&ctx->rsrc_ref_list))
 				ret = 0;
@@ -232,7 +232,6 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		}
 
 		schedule();
-		__set_current_state(TASK_RUNNING);
 		mutex_lock(&ctx->uring_lock);
 		ret = 0;
 	} while (!list_empty(&ctx->rsrc_ref_list));
-- 
2.43.0


