Return-Path: <io-uring+bounces-8912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 369CBB1ED94
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15D221AA3C58
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33BE286424;
	Fri,  8 Aug 2025 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GMGBqSoX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEF97082F
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672631; cv=none; b=cHygAjBBiCUVe2pZA+pfg4MfY9qPaXbgtrBN0yKeao14Cw+WWwh0ABgmCPPuub6coL95xmh4OF8GxBGTF0y3ZdSLO3BfoosBG+wWPXS6J4Fw+hO4myEqNGgtEoEi/ZXn40XVLBlXUnOwciue5KX8mCOMDyJZvl5AU60tGx6eOa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672631; c=relaxed/simple;
	bh=vO6795s0uKMG8NM2FymYuiZ6UKNOQiyBnjOUZFZTygc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkWqoopsldFOXz9MD/h0snqN5CcjUrPzSRWbyt551dfX73l6apcFiTrxyxx+br4mErxrYBYoIz1+S/BG2SscS4Z+S3oDYfz/O257+Hx93CZ4vbyX9+sdYIx4vyG87bd78PrkcEfYMVbRg6OFjWL9aA23KALkOJemGMqODujVry8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GMGBqSoX; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-87653e3adc6so65336739f.3
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672628; x=1755277428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/XYuUYyr+5xPLKOVRc4r6ioONJJsucqAAf5BtjgKfE=;
        b=GMGBqSoXKGB8FBBD2pjk+jrMu4Rn/tUVxnBExZrRtkuyDt3frotK40Fw8gHH3bCWFv
         B51GzxkesYLz1ReT4XyBRmMfniJ5JbcNGvgwOVQh/9lmYXsjInfzfR8OvPfJb+kI74fo
         Rrc5t3EISBucYM5jokDI5Tlti2soqiX7rhZi9zIe5Ynk5Z/nMbn+WUDvGZYtUA12LE3x
         xzQEGyIijCyAC8VBlsBlRXJpn77V9o2RwYzZgI3b5orlTmyDlsP5ZscpKNu0rjJJqjhz
         6krkkAP5Vl50YkqXdUgrldghy7xJqTmw6mGYds54ukC7kug65hoVGLwPgWdxGWYy5UFs
         B/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672628; x=1755277428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U/XYuUYyr+5xPLKOVRc4r6ioONJJsucqAAf5BtjgKfE=;
        b=BUw9sjJ7I0dVjfFevw8AewS/cVkLu7bhyJX0mmW9NODoci3r9stpPPHAxN12FRGlZP
         Z7ruA2Ft7OkxV4r17eF03r4hOLr5MfPRvrhU+koKSUwEtw330snwOICA+A+KtXAfY4N5
         uG3vbqvYGpCuU42O7MRGUYwqYFUA7B7HaioyhsX2xbUJRQQdFLkRIB19g053DmDD4+ti
         UK1CIurRmYROHd/eKgPu6cp4VfPVsG5SYyE26+eM7P8vUWMEg5H325l2ahkzqw9nbdaK
         SQJGDAoac/8HtQOuDq6peXJuXfZJQ2xucTn138oqkwn+hUl/bBmgP8lSj5akcsCIPhF/
         IMGw==
X-Gm-Message-State: AOJu0YxzurqP/tqrRORhTFWs79mIdg9XLx0t57GEFKc6hFbCHfq4Jjln
	4MjfBJ/YBC5ne8agD2066esXpEpbDeBZCgfj9MQfpCjxNA+36zGb2LUmhDrnx/2gZHECu6s8p1x
	atQ3l
X-Gm-Gg: ASbGncs78d0+zrE2ru7LC7rFmlbUR/X2yV4T44kMWK5O6Ny1ms9HW6GMxBUPrxuMDzV
	EHs4FU5FOvz5ZDghmAe+qiiqKEGt36gFF5/DzGYi030GZi3o+VoAx2l+lNAwNTtxbD2SKAwdaRC
	kRR2imwM12Nf8EmkMfx3i1flBTY6ccGV3v++cVrswepg+5RLdhwWIFUVzLbbB5QKn5bWMktGI9K
	M/Ly/cBXkO/zpqjk2NCNsK4heatIe5Sjn7ECYIKWzw0h1DC41U4xuGdUR0pHdWMa69cAEXxx+4w
	+ARmsrxKlhpeqj5bA++GM/94Q2eQbKf7S35uOaEEzxAcEbb+rGjl2te3yAhN5OxbyTvpvOkNfHl
	7P/2HIA==
X-Google-Smtp-Source: AGHT+IG2sgx+dnewHmlCSJATJTuKloJwN1hgBjw8DI0y1lFAhy8MzzSkd6I2V2EgaVYXSWniiUx1xw==
X-Received: by 2002:a05:6602:2d8b:b0:881:983d:dd7b with SMTP id ca18e2360f4ac-883f121aaf7mr734186839f.8.1754672628087;
        Fri, 08 Aug 2025 10:03:48 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] io_uring/fdinfo: handle mixed sized CQEs
Date: Fri,  8 Aug 2025 11:03:03 -0600
Message-ID: <20250808170339.610340-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808170339.610340-1-axboe@kernel.dk>
References: <20250808170339.610340-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure that the CQ ring iteration handles differently sized CQEs, not
just a fixed 16b or 32b size per ring. These CQEs aren't possible just
yet, but prepare the fdinfo CQ ring dumping for handling them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 9798d6fb4ec7..5c7339838769 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -65,15 +65,12 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
-	unsigned int cq_shift = 0;
 	unsigned int sq_shift = 0;
-	unsigned int sq_entries, cq_entries;
+	unsigned int sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
 
-	if (ctx->flags & IORING_SETUP_CQE32)
-		cq_shift = 1;
 	if (ctx->flags & IORING_SETUP_SQE128)
 		sq_shift = 1;
 
@@ -125,18 +122,23 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		seq_printf(m, "\n");
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
-	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
-	for (i = 0; i < cq_entries; i++) {
-		unsigned int entry = i + cq_head;
-		struct io_uring_cqe *cqe = &r->cqes[(entry & cq_mask) << cq_shift];
+	while (cq_head < cq_tail) {
+		struct io_uring_cqe *cqe;
+		bool cqe32 = false;
 
+		cqe = &r->cqes[(cq_head & cq_mask)];
+		if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32)
+			cqe32 = true;
 		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x",
-			   entry & cq_mask, cqe->user_data, cqe->res,
+			   cq_head & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
-		if (cq_shift)
+		if (cqe32)
 			seq_printf(m, ", extra1:%llu, extra2:%llu\n",
 					cqe->big_cqe[0], cqe->big_cqe[1]);
 		seq_printf(m, "\n");
+		cq_head++;
+		if (cqe32)
+			cq_head++;
 	}
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-- 
2.50.1


