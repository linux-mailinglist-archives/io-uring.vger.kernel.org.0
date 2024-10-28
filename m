Return-Path: <io-uring+bounces-4073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6CE9B3453
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:05:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70473B20DE7
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFFD1DE3B6;
	Mon, 28 Oct 2024 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SIAiFtTR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467961DE2C4
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127893; cv=none; b=b7k+lJumPDYbznUsZ1FzBfErZ16H4T6rWLrFfcbYEA0riR2PS2ovReYtmLPLM57QRYIwfnluzL48IcxZASJkJ5+9h1Rf3P5r9K0Hqp9wRDimozYpoM09BDDFlH5wviUmU0d9mc3/kO1/mJe0Rorl/gZXWD74wNzc2aJtOfsDjC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127893; c=relaxed/simple;
	bh=/fVZOAilfDDBwA4j0A3RHIJMhEBKne+Py4wXuj7ry3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmBs/J4J/h2ZlcIm5ybj0ESbC6TkSHUZOYMeLxTTjkJ3yGylbyF92z1f6KKNEcGvuCCxgQfzOduq8NdKmaH9gTzxdBIUcyxNOW0PyYFwHTGqkjptZnKEkoN0QucKDC8cwj2xGGBipi9bH1XE+sJnPH0OxCOnWVNo4ZABwpeUDl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SIAiFtTR; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3e600add5dcso1976154b6e.2
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127889; x=1730732689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdiXgBsgaIl4AHuNvVMJAsYeocIhfg9+qcEY/qVH01A=;
        b=SIAiFtTRvHmdD9ba3Q96OY6EAsM6kNOOr9oFPsU7RZhfIDfdstQJnL8hzueNrigCtD
         KzsFT71AE0gGQ3493fFhc+fwILNusmnDVGI7qpTqoPG4zvuYwr1tzqMq12AW+VwxTJfE
         n5OPKkth0FzNAKNEXNaFfhS/yUaSYuhnoVRIzXlGh8Jvv1eorbpsJU4qMU44UXb7VEzd
         eCpV+Y1APUJKGEbTgXlc0gV+j9v9wZfFz3JzZkX4oWOJSf7daikU5teJbgYyAi/Ecjd3
         hiQJdCrcYLgl7faPAEzSiudeXqObdYn7fSd23+G7iHWZGr9+DB8qPW3tNVbesEkqYN/9
         9FdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127889; x=1730732689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KdiXgBsgaIl4AHuNvVMJAsYeocIhfg9+qcEY/qVH01A=;
        b=KmPVUyF6P1qvAYZSCBX45bZ+pO91bKK8Z2IHDH1ifVGPIn6VnPqEtp2CaNLfKIM0TD
         ieZBbYMG1jpGfYhhGEEiMd4vLMv8GDHT/nRjIjzBpp6qnRHpvi/7O5EBm4u5Yvb4wEp3
         jTSPBA0ADvXbsSmE+YtJnSTiBwXj6ZzcjF6+n3SphsphaNcMDLtgveen79uMhINMK8dW
         hLomHlg2TLYj0v40sZCGe9M2RFhIM8RQKqZzEgGHsM8d3Eac8i9VtjGO29ubwtyPKFWP
         OklGJpRGV7uMagj+ECVmTk3Ymp5Fu9AlFAjGC/vSCXQ0s3UvaabHNqGphtnLWf5VqFuz
         N9tw==
X-Gm-Message-State: AOJu0YxT/XKIrDaldxPuiyY+q3R4RGL/0/aFt5LwImbpikiMKfPoAM5n
	HV9VUC/NpK8SHLLg5dNZhI0DjCNxqsRF9oFTzlkTFhJi3PFfaZQaCxUdR5026UvMeeb/dT01+on
	k
X-Google-Smtp-Source: AGHT+IHDuek0JyhGxEoFTTdBKhuSsJzzkJ3KCVWX1+6YQUMd8Ea9vTNp2KUojk9ZRjNgHLFrO7W+TA==
X-Received: by 2002:a05:6808:182a:b0:3e6:2d97:ca67 with SMTP id 5614622812f47-3e6384ce4fcmr6009617b6e.44.1730127889154;
        Mon, 28 Oct 2024 08:04:49 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/13] io_uring/rsrc: kill io_charge_rsrc_node()
Date: Mon, 28 Oct 2024 08:52:35 -0600
Message-ID: <20241028150437.387667-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
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


