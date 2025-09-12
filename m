Return-Path: <io-uring+bounces-9763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C45CEB545AB
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 10:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 725BD167DEC
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 08:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492BB288C9D;
	Fri, 12 Sep 2025 08:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="SFhjdn0u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7760C273D7B
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 08:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757666384; cv=none; b=hxZUJoLLWFrUzdsr7yfpdQbsB8uQcACPvH9JRZUFDxjD3mbtKA0k+6WODBU5t7M0/GQBjniMSplx4620x0YDsXph2peGkOOzWrdPWszTEDDqGtUEk38cdlDX9UVfSrxKzkGII7wx8DpiNhEL5tIWDSMBnHb8pdsxuU4co9mV2TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757666384; c=relaxed/simple;
	bh=sTOimKal0OOupS0ld0czPYaXJXBqN6bh9JEXfgay0oY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JoOI/GKrigRkU6r+Wx6L6QGFiinz9fvtlPfcosu06NZPGnAtt6cjHp7gbcScU9zEChAXPEUkAHk1L0284BVyMYIg7m5VLIEV4H+HRSDdGfh05Hg3xN+jF6pcQ/OgH0sekcfOGS/o+com9sdJcrus/U7adlw6mQboHF0LkXSiRv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=SFhjdn0u; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-329b760080fso1721990a91.1
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 01:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757666382; x=1758271182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zo2y5SuH7T8OLSqI5px4qVfoaEsoGvOPtgjER3NygYk=;
        b=SFhjdn0u0lhYd3kAld0ElsPu5FM42QVESiNC0wpl8u4frizEAyj/4ozabCnuB+3tWs
         jtxi71BK50dSy5JSNsd2vYR/B1kvq/drd70ISe2oHhbGAkREakrTJVCSBYACsvPaBQ71
         MYZpDSCCwXI3Nk/1lYhNZ7Uqz5gVUgy8e4c0KQyYkrIXLd942UlJPo9C9rtZY326Hi3+
         l/HgVGbUsGWJM8+v5PA9vQd8D83raf9971ORCuhHliE1u7OhSRwaklmyz0+yNIoavbdg
         hWwagu9wL6yLzo1QstIR5PAKeyUGHdOobTVj9KCoy4HXfvCrcGRvFNXheywx11B4A/3Q
         dfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757666382; x=1758271182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zo2y5SuH7T8OLSqI5px4qVfoaEsoGvOPtgjER3NygYk=;
        b=kckboT3P+PZfZpKwysvyKN1P7/WnxtsmTcrtrqpbjSMbKDobj0jKBXmiwswj109ewD
         BwnemDFHhua4q3n25OKF5eVep52hTbShxsM62rPh8q8EESyYMA8QnPChOGdCRkxb4ZSb
         riFU5g/GbKS5zjwEm2cHIdiAwj+pmgHnU64yJKnXmaTOlgd7ynGgc0VNMhLn4f2Ldf6E
         cmibJfKs43g/YP/3+wwbaeIXo21mWDSo87R0xz2z84VUEwWIpDtOfbNfMrmM7ZQjxPtO
         srnVt6/Jro/KLoJcLzHZApLG36lrTksmFDJAothJJV3DQ+PHuCQskwHFyXd9+ibpOlI4
         CHKQ==
X-Gm-Message-State: AOJu0YxxJHdkb24Zx1A0LaUFDIYGLAF39X3q4CvvFNWJNKuY+Kyu4cc1
	EBoTmMXhSeMQj2jQGEaPp3NeTxpf5JwqXBiTCuuEDhgIrwRFPJWIvfik7PiWpi2YErs=
X-Gm-Gg: ASbGnctsqHvpLRwL95czNFamllASpKi5IbFRu5mPJMFQ0l34JbrL+FD9zKw5wq1DEUD
	8jNbFRL5wqonqDfCYSb6Zt4KHWVzJkXVEwsftysSMmQIdDrGtbU3fTXu4M1zWgWhDjKGzCGPE4z
	fqkCYi+FjoUUARl1kO6DX3/g1qa/xekvkrxQciviR4OI3jpKgco09O7cassrGzIyGXSkN/+Cg9m
	ticqDuL8EmKplcyl7in+WOSpQdklbQ/ci2W2F1vOnU6NY8IJaI4wTgn79FSMSgyURwmR+meK2qV
	VZBH/X1eCjiHBEqdn9StWRAbjwqr8QSmY5icFu1Bk7Wls4vQmnQ3GbUAFbxdACSZsegoFvwsTcu
	gQ+Zj13SAH2eQ5XbMvzGmYKWiJEuVXiErWlThm6AUUuDpGLU8JnBLLFR8UmyChv/XIhkynyNqRZ
	07sA==
X-Google-Smtp-Source: AGHT+IEqAukig5SK56pMA6nrwve3MWNwfRDwSWB7fLDadRbqTiOZACMZ5Ss4IFWNyQP9DaEbbiz5IA==
X-Received: by 2002:a17:90b:4c43:b0:32b:6cf2:a2cf with SMTP id 98e67ed59e1d1-32de4ecfef6mr2289797a91.14.1757666381742;
        Fri, 12 Sep 2025 01:39:41 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd62201edsm5335170a91.10.2025.09.12.01.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 01:39:41 -0700 (PDT)
From: Feng zhou <zhoufeng.zf@bytedance.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	almasrymina@google.com,
	kuba@kernel.org,
	dtatulea@nvidia.com
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yangzhenze@bytedance.com,
	wangdongdong.6@bytedance.com,
	zhoufeng.zf@bytedance.com
Subject: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get dma_dev is NULL
Date: Fri, 12 Sep 2025 16:39:30 +0800
Message-Id: <20250912083930.16704-1-zhoufeng.zf@bytedance.com>
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


