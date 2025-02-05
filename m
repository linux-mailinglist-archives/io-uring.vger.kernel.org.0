Return-Path: <io-uring+bounces-6280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2244EA29B27
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 21:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75A503A3A46
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 20:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB19212FBC;
	Wed,  5 Feb 2025 20:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xhz3cJfS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DD11519AD
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 20:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787211; cv=none; b=amEadifTwydt3mv5kbycEIR871sZi3fOEp1yEyzb0dE2Wd4J7IwRVigdYLC2gf117AtdbrpmUq4hUutGvScvKVsBSLO4FKZBa2Gig9YLZdBpsH59pKIQa7xTm2o15UW7kUYBNWtNmuz75ljLWaKITKR2TxvvnhyCgQW3NoX9Iv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787211; c=relaxed/simple;
	bh=XTlAYiw5UKAMNfS75alH+uIT5uySR0K5F0uAEM5VvdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEvNn+vC5B4zrcLBfRdCXW+nfwlbJCget4zdtKq564HlzInSqJ0DsS2PE3sd6aOSC1AiLBxFVqfL2Dfvk25yebrabDqXqMa4tJi8f7JLoFnYb2o4foXG6xlKGoN7ZbDjESCjwbUWC5xv10uff1DiUNMkjNKXGXkxgWEQ6SZMhW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xhz3cJfS; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d051dca3b6so539495ab.1
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 12:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738787208; x=1739392008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rs2bYp+mu5LOxnJJsb9Nh078jFzipYdZ38rrKzvGzEA=;
        b=Xhz3cJfSQh4mzgwcgQHVDPD6SvXGyheIcKoIFfVpKyGTIodv/IwPkVAp/M0Tzye3hY
         N488hlhMWq5YQMxYhj+V7z4PAGTt7nQzKoUjw9V181Ewtvu+Iu8jev7MPzClaflbUQs2
         oWacqcWYmMJdmd72aWhH/lmwoXW1qAkyPtKW6TEp8UILUU/UV/KO8Vbtj4oA4jbWiLHi
         /5OKJVaFmKyzS5o4c9foKeOVcRiHHpnaXBWdIsmUmdgXQEbNKFp21KzSF934WRHfw8ug
         opTlULRO85hp4hT8cwlZfh3GqzCmwGEl5vh94iORyFAN9p7aP4lvxc0TsoLBbGuQ2wju
         CuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738787208; x=1739392008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rs2bYp+mu5LOxnJJsb9Nh078jFzipYdZ38rrKzvGzEA=;
        b=Y1/2UaHivoYzFv3/IcZIH+6mv+C05VSQ4Q1YdbkUMJV4ZwWub/+Fc70EgYKSSSYpbP
         xy/OGQjobke5/HudlLxGlQiWJ4zbDo3/w1LVSHS4CGzfuyTYDgWDKQNDWGtORgdKeOk/
         iyPbWOCQ9XLsD6xDbu2eTlHLEJMhq9xhLOM2hK8a65xqGYuf73rfrcK08PAQWnYEHVtF
         dxgRE9ke/vC+CDSY1J1S44nv7W9fAbV1oDnEJPCGHW6MLi+i9pNoPR+GO4kdZVWKej3r
         3UmT2rGpLxx1y6/QY3Ag9xwUpAwjJF1kKHWIFMchH2SVkfetIkZiUcIYQxjE/p3QJdwq
         9mBQ==
X-Gm-Message-State: AOJu0Yxzc+rqgltDFsfIABPjLRxrBlXlOJueeeorn82m5+rYFeUdmTnL
	7SYO4Z8VkysakMeId5sLoCh05bY8JllmSFBOCx94ux+UEiNvKFtTIOGqpMhnklxbwI0ZpXvpsyU
	E
X-Gm-Gg: ASbGncv0tZNjbd3y9NmSyYZtYDnPjoIBnXWvGrmt0FodxjPxugouQ6FlWQ2CS4xo9Mm
	NBPpsDiHFBc03r8B5+chXmCNra8RDtI2f8PeJrjGCKm2xlDvBu5iGF0fn1LGGQ0yyReqOxVsrqr
	A63nwHuhtHrMJOxQQFsBfPj0ANk0c0u3i6c6xel31osx6Ra001a9Vs2ribRuAS/wE5uX4znIaAQ
	qABLBVH/YGgeaQG+uiCIYE5hSHg+URYScX0poOJbvdGxf9TR2qLE6gmXx93IFFEVHToPCWdGu4o
	DljYZfB7tpDs3t21QGE=
X-Google-Smtp-Source: AGHT+IEXUjZKKsNuKThvEY5zv+hDPxB+J5aaArYiNIZV/6eRu5dRxmzAx5UFUnc1POKfyghbMwqIOw==
X-Received: by 2002:a05:6e02:1746:b0:3d0:24c0:bd37 with SMTP id e9e14a558f8ab-3d04f459238mr38569475ab.11.1738787207975;
        Wed, 05 Feb 2025 12:26:47 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ed51sm3352071173.23.2025.02.05.12.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 12:26:47 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring/waitid: convert to io_cancel_remove_all()
Date: Wed,  5 Feb 2025 13:26:10 -0700
Message-ID: <20250205202641.646812-4-axboe@kernel.dk>
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
 io_uring/waitid.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 853e97a7b0ec..ed7c76426358 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -134,7 +134,7 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 	io_req_task_complete(req, &ts);
 }
 
-static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static bool __io_waitid_cancel(struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 	struct io_waitid_async *iwa = req->async_data;
@@ -171,7 +171,7 @@ int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		if (req->cqe.user_data != cd->data &&
 		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
 			continue;
-		if (__io_waitid_cancel(ctx, req))
+		if (__io_waitid_cancel(req))
 			nr++;
 		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
 			break;
@@ -187,21 +187,7 @@ int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  bool cancel_all)
 {
-	struct hlist_node *tmp;
-	struct io_kiocb *req;
-	bool found = false;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
-		if (!io_match_task_safe(req, tctx, cancel_all))
-			continue;
-		hlist_del_init(&req->hash_node);
-		__io_waitid_cancel(ctx, req);
-		found = true;
-	}
-
-	return found;
+	return io_cancel_remove_all(ctx, tctx, &ctx->waitid_list, cancel_all, __io_waitid_cancel);
 }
 
 static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)
-- 
2.47.2


