Return-Path: <io-uring+bounces-9000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6229B2958A
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7CDC7A38CE
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A33621D3E4;
	Sun, 17 Aug 2025 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fH7Ayv6L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D821DD877
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470573; cv=none; b=ZLyl2Fd6MwYDQYwEKTuIVJ6GNF/zYHAX7l/0zYhZ748xnXpxSEFv2jqrtb4LdepDVkvl2S3LoqRetIxb4j6zTnwifHnVEc+7zWz0nLmZsVvoAmJmipJJapA83I7Tv9Ub+f9K6SpZcshGw6+h6GncRXIL6pHwrm3LMpJuA7SKB+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470573; c=relaxed/simple;
	bh=tEthOzWFCw7GWyqbJNZ+pZjGuqRsUaQKVo8FRPGHmWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFiAKF5LZCVKTCc+FNb+HTUebL/NCdgwCkk+UuzTDoo8AetjtViYIdxF2s64Cas+bPuc5wxCY//6BOo1AQHaQJfRBbxEz2Afn9YeMp3uErP9bPoaMC/A/nWy3lByZ5l6EjD0uOcunUDzdYZCZVyCe+F3SKHq182PBz1D12iQXgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fH7Ayv6L; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b9edf0e4efso2534407f8f.2
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470570; x=1756075370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puhPpVvSQV2jMQYQLnffITfJFI6IbvhH0eV93awXgz4=;
        b=fH7Ayv6LYK5KuSwrmE57iherMBTcfwV5P/hhDcu1EvPnCE34pmfxDaGIfZcGAp3+bl
         UkPrXhNKhfab3llyIVXjy/lx1C1QQlx8D03/yU5NuhtrSvU79z5/mrNF+UuchsGtRQ9O
         8j386kwDsFk1K0HrLjAvaWnY72rKepT2mnM5jzFhgsYk8sty1RQM1V4ZennnqI3WbJtM
         /dJRIFZfuKL1dNvZdnXycOS3LmsaFiewvyLuphZR5lgYTaBfqsEhV03R1IzHBBHnkJHu
         ea+g2GqEMCJQe158vDUdVM38rfICeImzRz/vt2X4fV+ASgnohg9eyF9bIKM0m3nc+6jn
         bc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470570; x=1756075370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=puhPpVvSQV2jMQYQLnffITfJFI6IbvhH0eV93awXgz4=;
        b=fjFWAOFBFyvzqfJ3kQGuNmlBGNkeCsK5Pq9tj99ADiB4mu6BQHfgj2wSWkqkWsVubr
         ratqTZHsKzsJaFjyVdwu9qrKn02pZp3jIFJBHfiiSkXLhHSXTxPvQLfDCfBu9p0bYdyO
         TY9ZtzJqeGMN3Rg5zvRvWIatwrBah5NKPrlx5imNIRVIXvFUompSWNOMeBubTZjuGzf9
         clq7aTaZ/guTzXgZRMUhVyR0Phv6E9v2CWT4TIUORv+EF5IfEBaBefZwdend3YlAoX6/
         a0vcwINUA2COKPg0y2ro2i/OJR8xCpdO42hdDmGq+VoRM12TrvXkYXYIwaNzF+sP12WX
         pBqg==
X-Gm-Message-State: AOJu0YwsgoZ3HVwcljvJ6TKZlkxQPNOsqsVsPR4Ev88ycrBURN1lmJ38
	bO7nsbUhjOpDFY9oj4TxCTMBFNNE5PeuvafW8hRRx0auWn8Stv1/mFVihgIHXQ==
X-Gm-Gg: ASbGncuNb6PPxgQPLb/Kl5ShmMun0mOr5O0fFMX4+8JClVqHslLbFN5hsFZLRPXfQM0
	5d2ZItludiMqeU9jTW2vRSAgrtI3FZL++E1WL6wh0U8vJckOYB1g7fYXdYsbBuuO5GyaBvxOK8C
	qIjssuntCDHz+JhUB+nT5D7L4D576vUS1UEMY7X5Q52FS48sBYlFdsZ69Cir78oZzn2l84LJwHj
	pl3JuZ5h6d6AtGJ17WAFY72NmAt9m4AsZx0IYZkOJZltoHHH5bPUeNUEWI+ojOxnFQAWCdQ/ZGQ
	fZt8595LrbmN9wXHw7mjvwteJAhbDuTWzSYlsNPDnw7ta5GCvzo8L/3Xw0oISwCG55/TyWhSq6A
	bNBzi3z1Tq1qcJcOecvDIwwcbVmh37qK4VA==
X-Google-Smtp-Source: AGHT+IH6lZ5/Nq/pWYoDNXP60VH9Dhr3Cuy3t8ka2KZTfYm6F2tA5cyNCzYxpliU0MwdEcAkpIjeOw==
X-Received: by 2002:a05:6000:430e:b0:3ba:d257:b662 with SMTP id ffacd0b85a97d-3bb6710022cmr6241650f8f.18.1755470569899;
        Sun, 17 Aug 2025 15:42:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 10/10] io_uring/zcrx: rely on cache size truncation on refill
Date: Sun, 17 Aug 2025 23:43:36 +0100
Message-ID: <0c2f21938000e9d7b5ae6285cca20b787f439d06.1755467432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467432.git.asml.silence@gmail.com>
References: <cover.1755467432.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value of io_zcrx_rqring_entries() is truncated by rq_size so
that refilling doesn't loop indefinitely. However, io_zcrx_ring_refill()
is already protected against that by iterating no more than
PP_ALLOC_CACHE_REFILL times. Remove the truncation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6d6b09b932d2..859bb5f54892 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -716,10 +716,7 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
 {
-	u32 entries;
-
-	entries = smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_rq_head;
-	return min(entries, ifq->rq_entries);
+	return smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_rq_head;
 }
 
 static struct io_uring_zcrx_rqe *io_zcrx_get_rqe(struct io_zcrx_ifq *ifq,
@@ -738,8 +735,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 
 	guard(spinlock_bh)(&ifq->rq_lock);
 
-	entries = io_zcrx_rqring_entries(ifq);
-	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL);
+	entries = min(PP_ALLOC_CACHE_REFILL, io_zcrx_rqring_entries(ifq));
 	if (unlikely(!entries))
 		return;
 
-- 
2.49.0


