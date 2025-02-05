Return-Path: <io-uring+bounces-6279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9BCDA29B26
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 21:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7696F165743
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 20:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C64E212FA0;
	Wed,  5 Feb 2025 20:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0m6u4qnr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5421FFC61
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 20:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787209; cv=none; b=VB3zNy1ln6HX0W549fhORvbkZfrhI3JFidpKbTSZlqWq9boPZaGnGl5A7vOGOmshYejFHCFGP22psE/FxdomEQTrODlJHJVtlxkjz1oBBIlZnT+J0xXYD9Ewpd+7vTWc4V1rF4Y+Hk9M4VhHZ+HXY0uzYWam3DDNgNTJPWB5xTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787209; c=relaxed/simple;
	bh=BaG0fC8mluz5KK+jZ5W5qp6lqQP67PRE8cYYmd9FqE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMF1EJmn9SDt0lat0E6HnCFOpuEEhpd+XO7cgXOoqruEvRT9AmmIfIo+9Oq11KTv57SsfVLIApdDoBpUBQ7/Az2US1bk7nT3N2D0lHGFcMakZCIs0D4NM717e82t9M+zW11W44ZGwnNfWd+CEM2uG+5DmcmzI7QaY5LTGjqiWL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0m6u4qnr; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d05b672ee6so304815ab.1
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 12:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738787206; x=1739392006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YIwFMglSOtaxOsPT8tG38CRBLxBiRH/jcEcw4vmicEE=;
        b=0m6u4qnr80OC0jqVyz4Ngp36N0Zbajq9nnpJsFiST/dA+rK9SBd5UtHZLLtb5LQ0OL
         SoOeNgnyrZM+/0QrvRDJndyYRitxIsYpr6xE+8moF9Q3q46cDrty7W/dF9aqPDQB0fV3
         qpElSSbaqKQ24s6N1l3Xt15SDa2H+oZYrxah4zQLFsPQz66ThEzXaDGQd4HCmV3eGhnN
         dIBGV9VEscB9p+BAm/7GOitSkVnu/wjCywt1vZAv+AGSEoAInPnfYJjYuWrF/CsHkUKF
         gs2o8lPrkS1885FcASJkqFOWREJNkZnM4k+DKTYK5rbXBhIFKCK/sOU51+19o66IJxuJ
         1yoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738787206; x=1739392006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YIwFMglSOtaxOsPT8tG38CRBLxBiRH/jcEcw4vmicEE=;
        b=VfSwpWwf+YiODjyFWZBQvaL3YONyEfLJ5MJgcqKdciTpPxe1ob5j3IAqTXw7Ca6Omk
         7bKbNjHa3EQrrOXEXhsT5q3Au5C+RjLmU+iZVVSMvfsxpTw15M1yQgceMP5EyNa9dpW9
         BZU0CvhogMi+VA8osF5kWknsEPKL1KQbMBmn/jO3KLIVwm3jUFugWvaeETjvIuhHr9uH
         rSRzEj3fRtMLrtJ8KK+Hyc6PU08ubxjouVf4Acyk5QA0aMrkt3WJnztV+AJMthLFzyQC
         hxXgXgsAhHlpyX9a6d6SB/m5n5fYYzj27NVebNx4Y2a+1cQg/IxoY7oxB3fmqJmVf9B+
         JZqg==
X-Gm-Message-State: AOJu0YzRj/RXC0gEWBikRAMESUu4xuEDdvaPMumTaeWg9cLbcnl/NBYv
	OoPXG8xDHC9nktkjLWoKt8Mzk51bO57jPPyBo1sIoBF6/aEDck8JAWj2kzDhF2OaYWgVus73KHt
	K
X-Gm-Gg: ASbGnct1xc+fjLFwiKYY6zRGV/UfdaVtUpPD4D9oANQ2l6EmTfr018UcVBZRYnat1xm
	BfXhRa5NwL0QcoLidLLnI6P1qvhFOOEVmiDSAziRGvM3uhIY4o1Epm0VYzXwjr9pvyh+vAs5ZY0
	ztnY8VbazjKaIPZX94bY6V6th8TEtihb8Uc9yDJpgisr/1UXdl9+4OaM5hWiAc6J+2Ks0zMw75g
	4cPYstTiXjUKYfmF7Xw9ahrwmQwrDtI8WPqeOn78t1UpNDw0px4n9MLLeH2E+hQ42dWOFI0hQ73
	Y0WBfy4OLA0MPzdO4Xc=
X-Google-Smtp-Source: AGHT+IGky6IrdcLrmZxqvOb3hvV2shJ170EyL51zhdUSUFSxfSIdEQVufiNdlqOUXl83+BFA8ChsDA==
X-Received: by 2002:a05:6e02:216b:b0:3a9:cc7f:2bc5 with SMTP id e9e14a558f8ab-3d05a56c270mr9547515ab.3.1738787206578;
        Wed, 05 Feb 2025 12:26:46 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ed51sm3352071173.23.2025.02.05.12.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 12:26:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/futex: convert to io_cancel_remove_all()
Date: Wed,  5 Feb 2025 13:26:09 -0700
Message-ID: <20250205202641.646812-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250205202641.646812-1-axboe@kernel.dk>
References: <20250205202641.646812-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the generic helper for cancelations.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 3159a2b7eeca..808eb57f1210 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -90,7 +90,7 @@ static bool io_futexv_claim(struct io_futex *iof)
 	return true;
 }
 
-static bool __io_futex_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static bool __io_futex_cancel(struct io_kiocb *req)
 {
 	/* futex wake already done or in progress */
 	if (req->opcode == IORING_OP_FUTEX_WAIT) {
@@ -128,7 +128,7 @@ int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		if (req->cqe.user_data != cd->data &&
 		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
 			continue;
-		if (__io_futex_cancel(ctx, req))
+		if (__io_futex_cancel(req))
 			nr++;
 		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
 			break;
@@ -144,21 +144,7 @@ int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 bool io_futex_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			 bool cancel_all)
 {
-	struct hlist_node *tmp;
-	struct io_kiocb *req;
-	bool found = false;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
-		if (!io_match_task_safe(req, tctx, cancel_all))
-			continue;
-		hlist_del_init(&req->hash_node);
-		__io_futex_cancel(ctx, req);
-		found = true;
-	}
-
-	return found;
+	return io_cancel_remove_all(ctx, tctx, &ctx->futex_list, cancel_all, __io_futex_cancel);
 }
 
 int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.47.2


