Return-Path: <io-uring+bounces-8476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 049B1AE66B7
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 15:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D14AB3ADC84
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 13:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBEA2C15AE;
	Tue, 24 Jun 2025 13:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NipIlS8W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA302BEC34
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772362; cv=none; b=V2tIA/v5+TcqlrNGDX3lrR9K8TjqdILVouu2cZ+PDkaBKlF40YN2sjciLEUyba+jzp/ckD3eSfx2uxCumQtGNMRJ1XBO0DBYF9p+MGDJExP0wAMoLyRNGBiEVn3JPJ1600+kX9Y0CNrJVWjJT3MB4J8aZu0OnrJ6P9h9u4C7BhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772362; c=relaxed/simple;
	bh=Wn/bqcCEqGApAS4RfPsXYOjPUvM0NR2fw/ZAi/XY9sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKs/RqfeWLesy0h17WQfk4PZus+dmQhuKBUm/AAtD3Dpk8jriu5KniSPTY8vr+Louw3CXnyzdI7eTzGTbaOCQXpLdiGZx3v0emJM2fjp/PyHFzKcE8Ey3c6oo3OmExvbN1+Fre45dMGTDkO1ZrQGt7ITTvai3dbNR1LtueLskwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NipIlS8W; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-607cc1a2bd8so8148544a12.2
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 06:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750772359; x=1751377159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyOCdPuLawNfgL+0Pou/O/oYV6YFvbIpEw/DOCw3jRk=;
        b=NipIlS8WVo8XjXs1TB0Ti2A9JeiBdY4mqeGMmkBG2ZUv7DgjDskOtenCMMdY/k1obI
         pMYrx8U+10U24sneCSV7nIh+Tsp/sJ12FswfgrjVn2dA5/hUIu6axorVH1TUrfWMn+de
         cYU6ninxNUgo8Ppo7zviRlMf7WnKEtEQ1FReQ6vanwKbJB30T9teLBUlnbq0Pk8omrQ+
         eN+uZDVI/RS4tuHR1ov6Omu14Kj+sGeZlC9sgQZyWflCZ+oaiQZsXPZU8cL6Fhu4nZBQ
         VAJBSr2A3IFthjK89ipOUHKa1knNjuNH8sw6hCd2sx9OcH4/s2cX/IxdC3KGWUgOPbi5
         0W8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772359; x=1751377159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyOCdPuLawNfgL+0Pou/O/oYV6YFvbIpEw/DOCw3jRk=;
        b=Zv5rfIV6cMZomG7Xac9XaBtfEvcP3yW9df5NpoNNnFcqhSEAGXR9W11ofM8BOylPN2
         JOWquax3zi4fJ1WosfY0dZmCbqWNsAMe46jS43TXj19aCtRVfaJQxXIsxtJBJX17dX/F
         TgG+nR00iIqKKMtBOYTo3PbLEJxmxv+4bTkAIarNLrhXdiGAz8/XT9qkWUuLayrHaXZ2
         ATHFKAluAl1yoVqtdUeD0bScYe7JCdSOQyIiW7/6izfXjhQIORQ8GzuY40L5Gph56ZPv
         +Vf4JO2lAM2bV9OYnLoXJgb5+uVX03QSNGKCf5D4a1UNPJK670Prlzwh1a0S6nGyUoQv
         ELGg==
X-Gm-Message-State: AOJu0Yxb5lB5k7bB0M70TNKdrvP8UBbiyQ9mytj8VgAt04hvuBgtCRYp
	3zdcNXWLimVDJncn2/Di2RW9wxUPxCLLGvLwfU5eHydgs4VDG7Wg3TXQZg2LqQ==
X-Gm-Gg: ASbGncvuA1onJOhqWDpMSKgQIm/z729547TqMUyWy9n+osOqjhXvAQW5g/RhMgDSWU2
	Q2OKNSHw8eAvB5UpInJppvKFOrjlAI+N50X2lWIa+4h3psT3iaghurgfClFMwuf+ZIJu7lxRS5S
	IpSo4HQDI/o86lihqjjutjPRjf3vgK9N+ag0RQNtoAa0hld5I/e0emlxilqUTaJgdUjQJU8DC6M
	QdH6M/54w55rn9ey1htz4qHg5+7iDbTxaXy+mGYHn4GZ/SYXfMKjUU2JsFA6bXGXr0nA0m0ZeJv
	HhPnv4mIQCcHLLgIuzvWcn+roLQ1e5E7N5xxqtKvBUlG5Q==
X-Google-Smtp-Source: AGHT+IF+mZcTCjYq0z47HmwQgHa6qGkFM5tfLKXaVb6S9Ds8798MWI/rXjl7LpSExB4BAyA1ski4lA==
X-Received: by 2002:a05:6402:51c8:b0:606:c388:636d with SMTP id 4fb4d7f45d1cf-60a1cf2e33amr15249461a12.27.1750772359087;
        Tue, 24 Jun 2025 06:39:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f196e13sm1052892a12.11.2025.06.24.06.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:39:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 3/3] io_uring: don't assume uaddr alignment in io_vec_fill_bvec
Date: Tue, 24 Jun 2025 14:40:35 +0100
Message-ID: <19530391f5c361a026ac9b401ff8e123bde55d98.1750771718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750771718.git.asml.silence@gmail.com>
References: <cover.1750771718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no guaranteed alignment for user pointers. Don't use mask
trickery and adjust the offset by bv_offset.

Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@redhat.com>
Fixes: 9ef4cbbcb4ac3 ("io_uring: add infra for importing vectored reg buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8b06c732d136..c58fe736f297 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1336,7 +1336,6 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 {
 	unsigned long folio_size = 1 << imu->folio_shift;
 	unsigned long folio_mask = folio_size - 1;
-	u64 folio_addr = imu->ubuf & ~folio_mask;
 	struct bio_vec *res_bvec = vec->bvec;
 	size_t total_len = 0;
 	unsigned bvec_idx = 0;
@@ -1358,8 +1357,13 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 		if (unlikely(check_add_overflow(total_len, iov_len, &total_len)))
 			return -EOVERFLOW;
 
-		/* by using folio address it also accounts for bvec offset */
-		offset = buf_addr - folio_addr;
+		offset = buf_addr - imu->ubuf;
+		/*
+		 * Only the first bvec can have non zero bv_offset, account it
+		 * here and work with full folios below.
+		 */
+		offset += imu->bvec[0].bv_offset;
+
 		src_bvec = imu->bvec + (offset >> imu->folio_shift);
 		offset &= folio_mask;
 
-- 
2.49.0


