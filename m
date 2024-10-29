Return-Path: <io-uring+bounces-4108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D62689B4DB8
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EA1C1F20FE1
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DAB1953BD;
	Tue, 29 Oct 2024 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E+hWgWhb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDB8194C86
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215392; cv=none; b=scidT9Nu4niV8jLOsZyPsFXTwOLJ7UDU2hX3tUxLnW9euU7K0/x7hCWUfMUn53sf6/4mJIbPod5gHO28Jfuk314tYyz3+n1T1B+uA/r5JOX2muvMJ5pYd3IdC/c4mcJ8tgXzOtSpSL7fnnPL8+2xyUxzijrDLa1ri5XJjTzfdpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215392; c=relaxed/simple;
	bh=/fVZOAilfDDBwA4j0A3RHIJMhEBKne+Py4wXuj7ry3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiggElKptD4ERRVv0UGruN1axKFgSqDcIPxFfwneL71kUzyhZ1nmY/JIOkYNqJbKROHm9FI+P2VS9kXe1n4i4fkIp1MV7bGcGoISrEkdawfYNeAGMEIwIN1BQ1XKu/sAZ3BlvT7uuYHa9rvAtalaC+q53WwS+teNkk8H9rlfBHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E+hWgWhb; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83ab694ebe5so212160939f.0
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215389; x=1730820189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdiXgBsgaIl4AHuNvVMJAsYeocIhfg9+qcEY/qVH01A=;
        b=E+hWgWhbyemzudHxa9xxKnA702wpQxhloO4+8kEn7hq49vZYvVD1u8Tk/Efe28o6nd
         Y2B7kUdebEZOnq0mK+5TIqL+GZX2GT46AI1azxuN31ohENDP6F9NuOSeb31xa9adwCJH
         TQexYejIBQr0OzdPGX/6t9we+BdRFyvb3EzzTty/p/RYK5VTmkDJJM9CR/EeMb4TFt+D
         N/L3DE7JibBZFQplKdrXWhEN9b8tqE2rHbrYor/WAfKweeqky+hcePKtc0AyYSQEdGgX
         +mfXu8KyLNYrAanKT1EkVR3o0mq6PXefPF1VY/wtwCkqXhCowvQSuismcNi1WBQ9VVY1
         Hs+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215389; x=1730820189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KdiXgBsgaIl4AHuNvVMJAsYeocIhfg9+qcEY/qVH01A=;
        b=J6AJRDKNHuqE193t28iJu1yt/fqLMZz6aH8l0dvLJUdsAseX4dpeZw8C6858I+vE6n
         TE7U+plPbwOfksGW/NMX4sYeftx76Hl0jTBoZ4I5HOzdaSeNgRbjheTI6y4hS59Gy92S
         wi4MiocpBQOC1YxldW9pSBRqfM6w8K0IhFZEEio6//rzAcdKb7822XQhYSjN0a89kafW
         ohES9bj/9646pRFxfM8VFbL/uEBvzd9z3x8AvYuwKlQMK1KT+hkfCAFpHFcdOlugdX8T
         KT2cOA6UFMQpO/L2sQoTkgEUGDSR70ah8E8ILjeI+kpX5rzFEJBnU2nlN61auWNERr93
         5+4w==
X-Gm-Message-State: AOJu0YzX/e/v/CjJsO3hHozwHc0nepb/JSDUlQaF5YTnG9NWq9U0657X
	dUJms8GatTfV2I3UGxThlj5p9Pf1Gmwu/HqfnPmVJH4J9Sfep6qs3UFkUlgxzP5MHVwckRheFW8
	R
X-Google-Smtp-Source: AGHT+IHG6PyuKepxv9mBktGmzcCtLCx8Lj4OfLvqeS4HdlUR0M8yshsCPi9Y6f975JuRcGAcAHtFaA==
X-Received: by 2002:a05:6602:1589:b0:837:7d54:acf1 with SMTP id ca18e2360f4ac-83b1c3b7c50mr1150274639f.2.1730215389232;
        Tue, 29 Oct 2024 08:23:09 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/14] io_uring/rsrc: kill io_charge_rsrc_node()
Date: Tue, 29 Oct 2024 09:16:34 -0600
Message-ID: <20241029152249.667290-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's only used from __io_req_set_rsrc_node(), and it takes both the ctx
and node itself, while never using the ctx. Just open-code the basic
refs++ in __io_req_set_rsrc_node() instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index e072fb3ee351..1589c9740083 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -97,18 +97,12 @@ static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node
 		io_rsrc_node_ref_zero(node);
 }
 
-static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx,
-				       struct io_rsrc_node *node)
-{
-	node->refs++;
-}
-
 static inline void __io_req_set_rsrc_node(struct io_kiocb *req,
 					  struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 	req->rsrc_node = ctx->rsrc_node;
-	io_charge_rsrc_node(ctx, ctx->rsrc_node);
+	ctx->rsrc_node->refs++;
 }
 
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
-- 
2.45.2


