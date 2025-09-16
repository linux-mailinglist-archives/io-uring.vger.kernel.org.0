Return-Path: <io-uring+bounces-9817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DFA2B59A74
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B870466CA4
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA0F346A06;
	Tue, 16 Sep 2025 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DxS1agps"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E693469F6
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032833; cv=none; b=jE73ji+WkUe2396azBbmS2VXF83+XfD2BuQY5dVEV7qCSJkZWc4rilb8sCS2oeKNKzko8Qw1yx4CHtwo61w/sMyEXAg2qgXGgYkZyTlnmaOLaGeQw3VJiO6fzO/lkgshaxc+rAVpHUINzTuH5+brEmzjIV8gUSOS+ecDPp5eIdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032833; c=relaxed/simple;
	bh=yKWiCvQRgC3J0KI96aLqLNQbheMmdbJ5Kiatr/clvKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCpUlu/WwKDKJHGD7BsLnqClJY5M/Xn4D/0TcgsvThG4dim91tu5i67/8U5wTtxnZIZETPQZn2OpFFlTHzfNoHoB+Q9kGrKaEe6XMiAFJYw/LOhMN0VaH8TMiCk46S3YYIwwaenIhTycgjFrlLLAk8/IMNDQQabIrP3mOUqfqvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DxS1agps; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dcfecdc0fso55566725e9.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032830; x=1758637630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=08P5zo8MaqfJgIUNTWkT/44OqoALzq49oTtRNEBcbRY=;
        b=DxS1agpsblfYxay/jzcNsqjGtWnyC5SkKKEHoj0BnH0OSmWOpS0tREqQ3VjqZQXQYG
         vPdo5WU5n5Z72oO6RlG3LfE19jADefSY5K1poAm5EGtpPePQSuHiRSkLle07DP6reoSb
         F4nNVHW5vdxtfmaA25gapwzSujoc1Km18B1buIQ0Tf4L4lp+HPKDRHXKkhtTXRsV7HHf
         5khPSfYriWiesCIaAo88WhRObWoXa4kFg21HmHNBte2PTzFc8SjbUX3b50ZUtBzuKs/x
         ZELt9h4PzGagIxMPw/3NigQ3mlmXhHzIJvzqAcyMQNVBDw3uB90ui4cZnP/yiM1VSFx9
         Ivug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032830; x=1758637630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=08P5zo8MaqfJgIUNTWkT/44OqoALzq49oTtRNEBcbRY=;
        b=Q6y6ocgT22BYuX5vQErsbpQSvPxTSuxIBMGiTiPD/KXHfPHHQE0flmc2uS0XWfQmUg
         L9TX9qpsvhY5MkWrgpWRh8CPXQrWDQ3ZWO4qqWgNkBHvHDgsobWUSQfCCvcdRCqQwrB9
         95J7V+DJnWoIUcW5/kNqGDjjJY0D95hSD/NtvIPyHeeUPAtVrRp2Xg4dwauUnsgYO9Ja
         +b0S36E3V/gVzrSS8b7gQ8NHRUenMa7CmBlMX4vnQO52MB/EX/YEVo6NtfL6Wcbz2qQu
         7rcztXhpKXxNAoZ7eSgEztAlsh3if0ht3dpw9lbCzJgu/QGD5lfPY/XdcJe0KUIyr/Sg
         OfQw==
X-Gm-Message-State: AOJu0YzArbJtKOPFjDREQT4wRjDrPfSWOiSQL1QfuIQhYnifjnfM0dsQ
	ZKXuZKx9FBgWy1sWyiNZz/l0NsyTld+82wlpocWA//l7JNL4nMu5Uf68dQM5Eg==
X-Gm-Gg: ASbGncuvw9IWJ5gG5F1DaiqODwSCpsWa0fmaUwNwylFmCa4iJPdfEt5L39yhtRdl+rq
	qhmfTiwp0UtWXMS/STva784tBs7oN7RAs71xEgzqWyfVP3qcSktaOsBzky2jRSrviSQhdPSs7hq
	CJ+6R4JJ9vdD7uyoPOEI13Dr1yW63IdnxB1P80AuW2SL+OCWFWwQhH73W1XiPxX5I+KnMHXuajN
	HTrSMtn+w8P+Bytdw6ioha92rUKXTPwArxvnYdUHfMSU336HAKdU6QVeeHt6B5eIqR7JxOb8F9b
	gDzD5ZC5b3csHPceGRoh4zTPsPefMr1HRs1hgY8j6/f6JOJFzu6Ivgww4QRSPkM6/jnWK+Du0xM
	fzdyqJw==
X-Google-Smtp-Source: AGHT+IGqmqB83o1JvC+5Bh4Kf+5yZu+SXX9PvhWr/n7pxlsSvficK31Mxnms0yQNMFSzRtbz3/q3WQ==
X-Received: by 2002:a05:600c:6288:b0:45b:7b00:c129 with SMTP id 5b1f17b1804b1-45f211fc263mr136531775e9.35.1758032829487;
        Tue, 16 Sep 2025 07:27:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:27:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 17/20] io_uring/zcrx: don't adjust free cache space
Date: Tue, 16 Sep 2025 15:28:00 +0100
Message-ID: <c8e94ec4b524bb2efb91b8ae2636d830d6b56f0c.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cache should be empty when io_pp_zc_alloc_netmems() is called,
that's promised by page pool and further checked, so there is no need to
recalculate the available space in io_zcrx_ring_refill().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 630b19ebb47e..a805f744c774 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -759,7 +759,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 	guard(spinlock_bh)(&ifq->rq_lock);
 
 	entries = io_zcrx_rqring_entries(ifq);
-	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
+	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL);
 	if (unlikely(!entries))
 		return;
 
-- 
2.49.0


