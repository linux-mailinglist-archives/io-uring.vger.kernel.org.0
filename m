Return-Path: <io-uring+bounces-11593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1265D13A75
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4C6BC3057DA6
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208522DCF72;
	Mon, 12 Jan 2026 15:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wjGFSLFr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973F82DF130
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768231156; cv=none; b=SBdthGR5ZB6uMd5HQZ+MdL2NKO0k/2YqY9DIyw58ePZ3usM3HqlASqMWxbKU4DHU1nafmMrOePoczrEEi6DA0d7+yVoQHopdgK6bhc4cCh/tFEH230zK0ySr8iZ0jIEBwIHCJ1gTyGkx7vEBM4eSEd/YHrYVRMAdo21JefoJxjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768231156; c=relaxed/simple;
	bh=Q1LgYG1HPukg2Le/wLk3kDh+2eCI8KWYlE0Q9tEzb8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQSwIrvXusDlsCvOKyYm6+9M5wFqKR8f3Zy22khukpPZy25anmNtb1ZEUThAWpp7Px++pZ1uFN1eLyq7JdxwUQ7IAB/ZSiOg4Jpt4jI9ZM7DYs0DMQykk6Kc3QELk5nKHbrpqGTcONuFjxmeTFSlNxReMPrJ9gEKx4tFlYeXmX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wjGFSLFr; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-45a815c1cfdso1296340b6e.0
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 07:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768231153; x=1768835953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzcF3sVSzey+DUM+OZqniy2PpOrjBbYMNdpRTROXYac=;
        b=wjGFSLFrggZrqbTZUQjiv5BxZVLLBb9j4+eQXpFf+cPrVsRJsX4K53KLRydOdYgQi/
         iMhL6OzJNmZGAxEGyyEeko92t1V7SsD4cTkrRlV+C0FcxEWq29kAVjZagbUqD9Wq4ooX
         nd/M7Ij/wFge5CGR5D4HN95ZqmyNuKo5WySaaf+WZZrU3ZujMIUBD3vxbYCyR96ChuBp
         37dyn6AOuqb9ECSq2mQa19fEtiAOCSbtgbOqPP5TbVTJdee06wGWgAICqiugJ4LgbIhK
         ZTZEbwGuQtADl96o6w7t6EuiAzyKRIYLytV/bQWMdQ0DbIYVwxXurUsUmDJ37xUBIkd4
         HC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231153; x=1768835953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WzcF3sVSzey+DUM+OZqniy2PpOrjBbYMNdpRTROXYac=;
        b=bend0159z2HSwbi7BZydmn79xLRVPl/impBykBvHi70LFoBx0EVTrl8wgz2SFCSY8Q
         uzKJ/ptw4QY7mwXlwd0z7sS056N4rasVj3Djpu9Q5awt3jWq38PrfOshiCwTWvkV0VQn
         b8Tfbhp552N8tpudQF9L0Sqt3rzSNBY6PpF8CUp3HPwsQJJSQdmmfcfe6zJnHn18yEBJ
         L+pqzAwYysTrt2TUp32GVKCmdBvekYHDSG8A5zBSWqCg+elm2JbETQXbN3tW9gVwDoHW
         z1+6bQNUQg8ckMzHivTeyWzTt+fsDq+fs00WNs05S0YPbUbsyVhTujRcZSOa4CHEfnnt
         BzIw==
X-Gm-Message-State: AOJu0Ywn3G7iflCGqDys9CySKjZfnDg6PO/Es5+pSvNdVhXiZAeuPblT
	LNMHXHAnGve6g0zm/adG73apLK0ydPQumFRDXiZd7W2Mgv7A1DEPphBFy2xsY7y3MjP9bWfJ9fs
	d9+ss
X-Gm-Gg: AY/fxX6529RDW1SUm281bOdqfVS4NKfRRLPtgnZpRdthpiBlzTGHj1spdVNGD5C+Yhj
	2/iqRU9rssuqxQ4HUEy1PflXMb9JR2dRIUs8mBBYuSM0u/jUU3sdAUBaG1buwy99sV6SVCVTT+h
	LRrO2OvCOXZFk3NwsFepopeWReWCisEHzA+dSmAYoXZ4xF22klAan8x5Q2zFRD2zDDoJaKvZvPT
	2uhkFDDH6mY6jmCbpGUGoFTGJTaFh7bISCsH83B8rDDnyGQQ7D7H+xT4XWk5x3kx2N8P+WCw306
	fc/ZmX2lWFqsdgA2FKwsf9BXeuNmUFOA2s3MKHzwv1Sfd9C1y7gCACmgWroa6qjpojYyZu9n31E
	xi65ocjzUD2NS6DXdhpGEYonav7DWMpNcOoehLLvoKf+e+1C/Z3ItlmAlSss+zmxQAtA1N74=
X-Google-Smtp-Source: AGHT+IFMyJ3yunErcUWPE/j083TGoBBtV80KGHhsKCRq4mPcfIWMRRxWTkAwh5Wq+hVrYpg8OqA/aw==
X-Received: by 2002:a05:6808:23c7:b0:450:b781:3731 with SMTP id 5614622812f47-45a6bdc1067mr8699404b6e.26.1768231152953;
        Mon, 12 Jan 2026 07:19:12 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a8c6b3fdfsm4210561b6e.17.2026.01.12.07.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:19:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: move ctx->restricted check into io_check_restriction()
Date: Mon, 12 Jan 2026 08:14:44 -0700
Message-ID: <20260112151905.200261-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112151905.200261-1-axboe@kernel.dk>
References: <20260112151905.200261-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just a cleanup, makes the code easier to read without too many dependent
nested checks.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1aebdba425e8..452d87057527 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2056,6 +2056,8 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 					struct io_kiocb *req,
 					unsigned int sqe_flags)
 {
+	if (!ctx->restricted)
+		return true;
 	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
 		return false;
 
@@ -2158,7 +2160,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
-		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
+		if (!io_check_restriction(ctx, req, sqe_flags))
 			return io_init_fail_req(req, -EACCES);
 		/* knock it to the slow queue path, will be drained there */
 		if (ctx->drain_active)
-- 
2.51.0


