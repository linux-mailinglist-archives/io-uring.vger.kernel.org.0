Return-Path: <io-uring+bounces-9805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F803B59A37
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCAC11C07EC6
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2073375B5;
	Tue, 16 Sep 2025 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVRiD5Kf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCAE286890
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032817; cv=none; b=KaEGYGsFbjf/IgJWchhVM/7QY38Rs1un5QY23Ypx+p3zRaIl5r9ltaJlAsvmXfSE3dMwPmBlceDzxZaqa49XaCdkBHK8O1Y+UiLpFM7RIsMGSxs97KlP88Ldvnen9Ay6/Gewk4aeUQRMPjOVlY5FEOSQDWSE03GvZK2c1MO8ul4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032817; c=relaxed/simple;
	bh=v5MfKTL5OaBB/TYhkrY+YTJ9ipou4p8N1M+WBJL1v/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwAgXR1gwzj6GLnJNyru9Au9sAvvxYTreICbNh/5EupWBswp0fJbWA3XvYHZhmdYg61nrjpzDu1Kz3AZBDM/usA8KArV+gsSPuXsUnEt005qxUw0A+dLGfv3EchAszJcgyJbEoNEHnf+DNJ/RBAwhDSKpWwdeqs6FaEYKPckBNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LVRiD5Kf; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45f2fa8a1adso16021725e9.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032813; x=1758637613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVgwK3F7FwSjd75w6fCwZeFfF5ahI5kLep0RPJ8gENY=;
        b=LVRiD5Kfh9LVkuyhVXWkI+7HqmskYAnfX9pFq/cM86waF+ZX4KdXVfzbImDXJWVzwo
         it1OsTLUm0n6yclbHrgtBDsNZWLbWbiIZ2/ZX4QgAPf/AeAISAfCRmjv8XpDuv7AtuqF
         dF/EoXm7W6GzZWR+3t5Oj+4VXz4nVrWTgAi+IiJ0y+ktaseU9CASyUEWXBoh3f7jpMaO
         UYp6A/tYsE0X4R4YT3DiBbod2PKP3bpxnLoSuq6yR3YUGBzjB7Zw9JGmIHumV4v+Wral
         kGwLEfr7syoKcseWVWi3Iqc8qlwxtod+nH65RwVAbfol5ZkvqsKVz/to05G8lJYo5Ipn
         gGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032813; x=1758637613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVgwK3F7FwSjd75w6fCwZeFfF5ahI5kLep0RPJ8gENY=;
        b=ffh8tyorn5X9ifHVGjY+ZsRW9s0He4juVsv1vgBE2IrJhzE6XNFJuQVFrBIMShOnQF
         YAmuYglzXnG1R9YVIWztc9HDZooP7YMyxgA/xjisjAzU99KWw7KBxo6kejQ5DzGwfS4B
         ElWsdPibSzXkqQSmETblaBUfWhiceaEQcfpKgjazfNRYExbe8elRdINf4vLSGmfEoyeb
         /yYq6EUSbiF3Nh0ZEO4r9bb+blJw/eXQ0JJJki42ryMiftsE9Eo8WyAbtZKTsoxQg1nB
         mc66aVO4NhDQ6V67NgtbCUzACZRo/wztEI/jq6TjK3NHYBuSMfxQBiRfCWGTXZUTx1EH
         ASow==
X-Gm-Message-State: AOJu0YytTXRcPx8c69ooQk5LulVmeBvOfXjFm75sjoivZAQ2GNUWffgq
	0SnTX/RI1EI9YC9zheNzIvdq1WhNd57ax0vLRCRVD8eobL+IS+/1QZMDUqUtzw==
X-Gm-Gg: ASbGncvSDBC0sDI4CUr1gGzcjKb8iSUetKWrVemgTzBwNhN3zSyHM/kz2cZ5447Rsfc
	tfa0AJtRDNcX2plJIUDYhyjmxMNzmwchlB/xAhT7a1ndTXfoMmaDa15cMua2T4YwRCwRU5KrSaj
	W6eh+Sid9vqSy6XNTGQegfzTY0BJPo+2UxDYx3jTAtmsmRvvRpDC97Zi0OMd40Dhhn9BrINhJgz
	x7mKDX0na8LofkKKJRYoMVCfpUldZzBkbv+JEM/NQ1XVohDsqNTL7cDnO8sdsrW1ODRbC8Qhjm5
	aYhIscWbJ50N8nH9JzTUC3pHDpCfl8u+xlfJxPqaQ1TJfkKcr0aTktLMidGtAtlXlF8shTzqQc6
	CRdDM+Q==
X-Google-Smtp-Source: AGHT+IE1u83evQctNZDIG0xt/GdZk/rK5A1KJd2AoC65XklH57KuUcIfXPERofKD0uQTZLJDvK+37w==
X-Received: by 2002:a05:6000:1448:b0:3dc:2f0e:5e2e with SMTP id ffacd0b85a97d-3ec9e686554mr2742771f8f.13.1758032812530;
        Tue, 16 Sep 2025 07:26:52 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 05/20] io_uring/zcrx: don't pass slot to io_zcrx_create_area
Date: Tue, 16 Sep 2025 15:27:48 +0100
Message-ID: <6ce9cb89296cb3ca4828f1d82a5d6e31ebfd0dd5.1758030357.git.asml.silence@gmail.com>
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

Don't pass a pointer to a pointer where an area should be stored to
io_zcrx_create_area(), and let it handle finding the right place for a
new area. It's more straightforward and will be needed to support
multiple areas.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7a46e6fc2ee7..c64b8c7ddedf 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -397,8 +397,16 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 
 #define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
 
+static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
+				struct io_zcrx_area *area)
+{
+	if (ifq->area)
+		return -EINVAL;
+	ifq->area = area;
+	return 0;
+}
+
 static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
-			       struct io_zcrx_area **res,
 			       struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct io_zcrx_area *area;
@@ -455,8 +463,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	area->area_id = 0;
 	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
 	spin_lock_init(&area->freelist_lock);
-	*res = area;
-	return 0;
+
+	ret = io_zcrx_append_area(ifq, area);
+	if (!ret)
+		return 0;
 err:
 	if (area)
 		io_zcrx_free_area(area);
@@ -610,7 +620,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	get_device(ifq->dev);
 
-	ret = io_zcrx_create_area(ifq, &ifq->area, &area);
+	ret = io_zcrx_create_area(ifq, &area);
 	if (ret)
 		goto err;
 
-- 
2.49.0


