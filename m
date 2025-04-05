Return-Path: <io-uring+bounces-7413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 463FAA7C8B2
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 12:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E17AF3BAFF4
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 10:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7313519D8B2;
	Sat,  5 Apr 2025 10:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qkp1H0Uh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64F2182BC
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 10:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743848215; cv=none; b=qRIRZoxA4Tg1Xi2BtfDNVpeH5uiu1b2+71lEgkKEe35YwzQeY0ki0Yjd8kdhg2IYI5MhGECI91nn1qknqsfP8Is0greLFmiQBVvPIoOuiNkkBxAr1D1M5SxH75f9qHkko/OK4QBo1ZmrxbBPeigYzdDB7wlhA9W3IywzAHtKj4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743848215; c=relaxed/simple;
	bh=66+/iRmGmDO07e0YALA32bWKympOUvfbEhnyygZ91+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDz4iB/8Sm95qg+IBSx5O4ubNIqzcCwC0JCr9vkZGBFSTVNCGSVhCovBb/Lt5SvDC6AihrH+H9j7UsqVyh3+cjJjRvYxE1UnF5/u5SLVw37LjKVmasBr8maPuhyzj2qhIAmt6trVwxMYdWW/PzWf2UhXQar1gr1HZk5k4pq9iDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qkp1H0Uh; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so4627502a12.0
        for <io-uring@vger.kernel.org>; Sat, 05 Apr 2025 03:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743848211; x=1744453011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UAfjHQHHz0QGsCMU6bJDvCH4VKFWyZGAEGgVVNO6mh0=;
        b=Qkp1H0Uhc80O9KeN6Ebgp7JnHDgTxsjedoLs/lFLWzNLG/ntGVvmFnXB1POCFypePL
         LuA6cTmB37T2f0Pk8+1bkcLjMfFQEZGH6ZOQ26o+hWGteUDRDR1yF6fzBseZATw+0MkI
         8k+wwyz5Yugt9DtbEgFevH4DtydasZk+K7fmIzhCM3JFumMwK/liR47HP6effMXGryQE
         fnY1c5UdzKmugmLb+q4NhYi5PSTeSKfZH0DWIhN8kCvc30pGoM0setGQUW/vqbgIdeP0
         UivlrvXXgFouVRD9Of4Is3eH4jA8cBl+4rHVtek3r6/ieRo+R5ZiPA7HFedpE/3KL/gt
         gsjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743848211; x=1744453011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UAfjHQHHz0QGsCMU6bJDvCH4VKFWyZGAEGgVVNO6mh0=;
        b=Es1t9zM8P+cYwj144RJyyOcUWwnvQO+aHM4tTclceD0giZFgTP+Gc/rS+VW7zcW0fc
         MP2jWNFQDPm/PSTBuoM6VtVv7mpCY3W4QXF+r5XnD2hDqknKAd8/+TBe2z3vKJGuqNMa
         kNw0HfNzQdAgkLslYOBzjFjZuD4dS8W1JuyaaGXWJcgjYZjgA2a4fICULDw22zYNmfVS
         e9VmGnLNxdszzPsPzolkTwNPCNHDt+90byZ2RsHZ6TNuJ4ghy+n+QxBQz1lWa5JtGtQU
         yz57Z4fPZS/HymaVkBdrRjSfTMegFzaz3zp9bUZzj1WD41afq+XJSx5n3WGLTTCwRzPU
         Q2dA==
X-Gm-Message-State: AOJu0YyM19tSTVB/OdowPKASm1m7hJS0Rdv3kwrMUZFFOaj+on2zn9hz
	675ye5OwUz1UrglBInYoj5CED+hBYrVhCnGmdM4modSJaFObHgUrcvNgEA==
X-Gm-Gg: ASbGncsJxHBqimRxiIbpQEVwNkA7uPuaQAfQkWyBJNefJSnLm2O43wfE87UH9+yYZcz
	vN0YSYIVBPIa8corq6xQA9ZmzFVl+B31eH+JKCv8nMEAodsp6xuz8r1qraH8Z2aiUe1qfYdcj7y
	+CvHZvy3RpNxZkYhQALAV8sH5YvQasJOimIk2or4P9qPoPXHN+X5oN4JWmes1riSdQWizS0f0z3
	5SF0CtlGGZSmm1RuOInsyPoFO9z0cGEfd27eaOZ3TLJimpK5+IuDSSR4C3jop5UPWW9Oxc1p/IE
	3XFBWlixHGH9CPY2fzPlUbNlPEuziX01/u/EeRzH25NKvvu9c8DitxeWn/k=
X-Google-Smtp-Source: AGHT+IFF6TWaRWIk9jGTESG1UzSWvd70wp2/6nC5fJVv1/QcOF0HLiFn2+DjhJyJBKcaBgiBTnp8Vg==
X-Received: by 2002:a17:907:1ca7:b0:ac4:85b:f973 with SMTP id a640c23a62f3a-ac7d1819306mr465389666b.34.1743848211059;
        Sat, 05 Apr 2025 03:16:51 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9bb99sm397317866b.52.2025.04.05.03.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Apr 2025 03:16:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/zcrx: put refill data into separate cache line
Date: Sat,  5 Apr 2025 11:17:49 +0100
Message-ID: <6d1f598e27d623c07fc49d6baee13089a9b1216c.1743848241.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refill queue lock and other bits are only used from the allocation path
on the rx softirq side, but it shares the cache line with other fields
like ctx that are used also in the "syscall" path, which causes cache
bouncing when softirq runs on a different CPU.

Separate them into different cache lines. The first one now contains
constant fields used by both contextx, followed by a line responsible
for refill queue data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 706cc7300780..b59c560d5d84 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -26,11 +26,11 @@ struct io_zcrx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct io_zcrx_area		*area;
 
+	spinlock_t			rq_lock ____cacheline_aligned_in_smp;
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe	*rqes;
-	u32				rq_entries;
 	u32				cached_rq_head;
-	spinlock_t			rq_lock;
+	u32				rq_entries;
 
 	u32				if_rxq;
 	struct device			*dev;
-- 
2.48.1


