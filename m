Return-Path: <io-uring+bounces-10270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1140AC16502
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1912840313C
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0C12853F8;
	Tue, 28 Oct 2025 17:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="0Ppi41bB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC2C34D933
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673607; cv=none; b=Ni2ZSHiSTIfOv5TlGahR6IKfRigi33i2/dPLTZ7eh5HzSnjFJaBSBc97qV2nhH2fZFkrg9p5KIuxRteX/05OhvYHAyO/RqXjmz5hpRtRyIXJDY0gzkpG61Op8QZfwfCrgFf5BWCjTTJXcVBnzaoZn3pHMX77RJbt3O3Fklr+qro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673607; c=relaxed/simple;
	bh=OnQwrnQwwUqEblqMRbXwbgusXkiUsVAwoIi0re25Rj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkQdiMz/S+l4FxMdqr1cAvyFz7jWYgj1BLFtNIMuf5dQWI23DPbu15+2fM11Wrv3l5g4+XEvFLuuUGv32DoBJ18ZFRREsp87sbPfkTmtpymIyxepQV0vdrp8Qptus18Cr5tV2vmYRn7O1rKj+AsoDZ+vH57KTN8H3GV/icXfFNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=0Ppi41bB; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c0e8367d4eso2149892a34.1
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673605; x=1762278405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zl5AueX9y69Syh0VRS3pOT1pG6hKOR/QkhQ5Z2KXFk0=;
        b=0Ppi41bBOWKDu3DCv8ZnY8Kq6R53fdS58NEW0h5zQDiiKIT7JkzMJzz1P9TEzMF/tg
         zCgddzB8wE2cFDWjj+SpYii7oo/hiNEwTFXijVozHonArDgA5oDnrICTxRqMNxkvtaJb
         +zMB57CeCeKaBRo+UMmGrnc/5LUyC9TFFTSTxvh8mB17OJn+oCfRuibOxLP6YkzvS2A/
         BUNRFyI3ZWprLNR68R3Ur+E/z01IupKRFwpAioE660d2aVsHN5f+ZcG1m7m1lqW2SNm9
         2o4j2TOgmGl6g0xExOT4881xUpmLstQC1Gl4ytuM6MDcMg0kkjZTZuU4FhYoo9zuCLJQ
         uhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673605; x=1762278405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zl5AueX9y69Syh0VRS3pOT1pG6hKOR/QkhQ5Z2KXFk0=;
        b=Qq7t7XrC1phIeSmwveoB04LBW/RPkQTbsiH6mohQBBV66YlN9FQh31KrwwELP1it2r
         0mre0G5tSIpBnl7/3jVvZfBJBwGCdZjamBa/SNZ1vtXsFyjjqDkPVfMI6DQIrxp6JsQn
         qFIg3RVhq5h7xQvmNT3wVJqPO3ETqnl5X5DtRDLnsOQGEViGDhBHJ8ap4d2y6AnzZVjs
         ES+lcGBHUuO4z+OdhtabrPlRGgEW5LnqznxcMXVPvEwJgVPM2MBnPQZCCDqWo3vK/W+E
         qyJ2SryuErYFWfCysAEkeWLyFn7M6+2Aq+evt0nWDRTJWpR899oSY68PtCQoMvz83fOC
         N8og==
X-Gm-Message-State: AOJu0YzYlUer2iTeAqij/2SquK1v43JRdISJh31W1gdBnf/0Ofa53ZL8
	s3N/LN481w4KrpRcryXuqEwEJbm7njaOPKnh9+7W4UJ10g2gDtSq9UZkJd810fOjsiASjUzMm5e
	LFAst
X-Gm-Gg: ASbGncugwhaAdmip/NhjrVUeoZWIIjwxdkSa1NzcOc+KHfOCksYxOTXr6ujhGfHHdRX
	vVETesCHFicYrlQacotXqPJ1+zhu99tCVmCFt0PEpLTaZn27xoverO9gghjd/Yi7DwoGYDEuBw2
	RwNKi88Jcfa+wTO6+Rm82nXbyHTCURpzzey/30myz4AlcZG4kuvDUNuj2AhMesd9Vh6zOJnT5Pe
	OpQZoYkW07oVvM3H+KBmDQNlWQR84cQkhnE3JdWD3vgoc/PwY3nRorzvt7f3jMDb9iUKqD6UOsY
	UiFdZXNLoWwrh4fDyggt4Cd6MykwhUkMha6D0wC/8Kk8nAWDlVc61tjYEZMEf/7oBUsLGhG3AAq
	ZFp8MGNh1puqBTIUO6qdorxoWtXLj+nJTuuJuQnU+U8AzNWK+DFC9ZWObIpTgJql1nDD4tSy3MK
	/SL5NoV1n4vfEeNoQxyFRYSodLhVH2
X-Google-Smtp-Source: AGHT+IGrxV8VRXLwzI8ZUDKhUTSO9sPDokAhGp67pxHG9LSNQNBKQ0nbskd7Wuvb8DnN3lWAfQo7Tw==
X-Received: by 2002:a05:6830:3c8c:b0:746:db50:7dea with SMTP id 46e09a7af769-7c683065aaamr142561a34.9.1761673605077;
        Tue, 28 Oct 2025 10:46:45 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:5::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c530206929sm3406204a34.24.2025.10.28.10.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:44 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 4/8] io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
Date: Tue, 28 Oct 2025 10:46:35 -0700
Message-ID: <20251028174639.1244592-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028174639.1244592-1-dw@davidwei.uk>
References: <20251028174639.1244592-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_zcrx_ifq arg to io_zcrx_free_area(). A QOL change to reduce line
widths.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 30d3a7b3c407..5c90404283ff 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -383,9 +383,10 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 	ifq->rqes = NULL;
 }
 
-static void io_zcrx_free_area(struct io_zcrx_area *area)
+static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
+			      struct io_zcrx_area *area)
 {
-	io_zcrx_unmap_area(area->ifq, area);
+	io_zcrx_unmap_area(ifq, area);
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
@@ -464,7 +465,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		return 0;
 err:
 	if (area)
-		io_zcrx_free_area(area);
+		io_zcrx_free_area(ifq, area);
 	return ret;
 }
 
@@ -523,7 +524,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	io_close_queue(ifq);
 
 	if (ifq->area)
-		io_zcrx_free_area(ifq->area);
+		io_zcrx_free_area(ifq, ifq->area);
 	if (ifq->dev)
 		put_device(ifq->dev);
 
-- 
2.47.3


