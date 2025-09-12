Return-Path: <io-uring+bounces-9766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F70B55034
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 16:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90E9B1729AB
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 14:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1E930EF68;
	Fri, 12 Sep 2025 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="h4XuDkPg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A803093C1
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757685710; cv=none; b=Acfi8C1GBujWkSVvYTnmyHcTE5cLOSIEUiZ9z561w3SYTYyajnOIvP5DBMuPAWbPAY848TdBzN3EiyBvSXox+2KKT8yE6yMd+OgBhuD55cs8/lW03sr0ZY7GwUSCOri9JZ9mm+Hkn1RV2+SABS+5/O0TPxpBJTq2qUFzk9wr5iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757685710; c=relaxed/simple;
	bh=sTOimKal0OOupS0ld0czPYaXJXBqN6bh9JEXfgay0oY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L0SZ+Xb38rz/ivfKEiZvME9/RJafWVgUvQ+jfZiIQrfT5teVJIwsjZK9nRXqscFsZrCWt5QpoeQJ5bNg9bgDY6zz7mgmcnFpmUmsQwOms4Zv/zQo9x+yoAc3Ug4h7soevTxASaVzuHCRUqfokOqa4Tcf2YefoRroVr+Bo4/tX0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=h4XuDkPg; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32de096bf8aso1473912a91.2
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 07:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757685708; x=1758290508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zo2y5SuH7T8OLSqI5px4qVfoaEsoGvOPtgjER3NygYk=;
        b=h4XuDkPg7qKoxDjPaS6j/8vM3DvVnTdPsj06/sV9SMHq9UK+fqv96gyPVt4xXhTTIP
         yZrXKlWkhqDzPD+ICxLo1dSdcZKwWaHT9Zr+hAOzcabwQxUVWn+VALDOFYEwsBAXk8Qh
         vXjgZQBvdn7AS7idckYeCIgbnPfvZC1VyKspn2LWnyUVkV7qKJ0s8zHyaOl8TDzCPWOL
         xs7LPrt/wvm/U16WuFCtKOGgZaP5hrtCLytSPJ2PjX8h2Jswj1bhn6K6PivKvEn4PeHz
         7NjhvfXwdh+MF6/kTiyVzQF/58XtgYLH2gpAq+pEAWCw2QOi4v1xC2VrD6MdJ6d1RElS
         eeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757685708; x=1758290508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zo2y5SuH7T8OLSqI5px4qVfoaEsoGvOPtgjER3NygYk=;
        b=BgbTBzipmNpVWes9HzeA/8anrxpnXyc+F/fpc94IbZAXSoORyki9F4vK2IF2H/zew6
         f9d+ruTxf+MiBIWDPl054J9axE+s6T/IqqBC2sf8d3uOsrGgPCzV/F2f53QzGpQ5eHE2
         OK7lm8ZgAOctV0On4KXbuus+Y4cSdJ5XORph8G9fZs/OqY936ubVtMDLRw9kH+zPMYDi
         QcIplh8xJe9rTonWepb9rCclc0VJnB3s3cZQ0s0MN4mq4EnOAo9fpb2lL0Nvb9ouEGGY
         mKnRhVXIvjpkGj4B/6mEhDUzst/I3zfRTeT6XiAOvD5p2gDHlFNhIvwMdUgmL6rkEXZg
         NfJA==
X-Forwarded-Encrypted: i=1; AJvYcCVQq+BB5wOJeF+1Q0zzOqHnMAi+ZwMDaRjzHRqHytAcO23bCb6GLmOOGb8zEtQsdWF4SalKaeXFkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbFzJKlZLTIuTtxYgvnLMR+kgpO97awrSutzdx05+Zufzgc03V
	DiagaQQnDTktz2voGOCFNRNykdIWTDR8XWdZHtq79coNQdDW2FM6U52hyNzqxZ26YV0=
X-Gm-Gg: ASbGncv99vt7+SFuJW1m8DPlTleGiVcd5QTRt7jEShP09Oiug+oDb8K10FNZGV9ZC8w
	APgS/Yjb1ZstE4WUvm62V7WY9kQv1xpZHzM9mJDwjr73o3MW46MWUzuYft89dXX/Go0ygakp3Jt
	gJdJ7d8glfMTwIeEC73lb7uhYyYbClKA8ERG2ZpABHIVFcP9NGMkNUNC1RJtG6d+qE/JHs8gSPl
	XtoevjpieXqe740vz+CqtoY62ex8B035s4ef5jljwmpsgVT04RBv6eW++be6GoPJ0XOW4J6nyZ9
	FXRzoyn3Y5b/gUXwoYFuGlhnBTUYVesbo1NNK5MW1F6UC4TP3AuQxFsYwHvZ2QY4LnRxcUUjlSp
	hNWyUHG/Pw+7JzbYNqEri57ULqK1B8kxpYjKXiIQoEwYHTcqL9oJQQAnbT8CjwYbU/Pk6wFO1Gk
	Fe2YU=
X-Google-Smtp-Source: AGHT+IGlwh2at04jRE6M2RZ6OHTL1b2HeV6Knx2fVNeRz/Ss7Jdcb7XmGTwDAoceA2g0QWjt2DGjgw==
X-Received: by 2002:a17:90b:3849:b0:32d:f315:7b64 with SMTP id 98e67ed59e1d1-32df3157da6mr1404877a91.31.1757685705728;
        Fri, 12 Sep 2025 07:01:45 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd632692bsm6515374a91.25.2025.09.12.07.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 07:01:45 -0700 (PDT)
From: Feng zhou <zhoufeng.zf@bytedance.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	almasrymina@google.com,
	kuba@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	saeedm@nvidia.com,
	tariqt@nvidia.co,
	mbloch@nvidia.com,
	leon@kernel.org,
	andrew+netdev@lunn.ch,
	dtatulea@nvidia.com
Cc: netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yangzhenze@bytedance.com,
	wangdongdong.6@bytedance.com,
	zhoufeng.zf@bytedance.com
Subject: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get dma_dev is NULL
Date: Fri, 12 Sep 2025 22:01:33 +0800
Message-Id: <20250912140133.97741-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Feng Zhou <zhoufeng.zf@bytedance.com>

ifq->if_rxq has not been assigned, is -1, the correct value is
in reg.if_rxq.

Fixes: 59b8b32ac8d469958936fcea781c7f58e3d64742 ("io_uring/zcrx: add support for custom DMA devices")
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 319eddfd30e0..3639283c87ca 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -600,7 +600,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
-	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, ifq->if_rxq);
+	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
 	if (!ifq->dev) {
 		ret = -EOPNOTSUPP;
 		goto err;
-- 
2.30.2


