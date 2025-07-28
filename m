Return-Path: <io-uring+bounces-8818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3CC1B1397E
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 558B0189CB56
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0083B25DCE9;
	Mon, 28 Jul 2025 11:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUQP1HGg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606FD19AD70;
	Mon, 28 Jul 2025 11:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700604; cv=none; b=aCxz3hXkqQ55g2wVEWwq/Hc/+RhOCCPtXDKuZXq6c63G5nN5ZLi82EAXwdKO05QAii0TmcwSlIkklheMxYR/oKEOvNb091N34kuti4vWGtO0Au/3a+1S1k2h4obHAYQkszg1g2hLGCW/82NWqPgQ2ZWfaDBpo+8d8VcjSnbCLzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700604; c=relaxed/simple;
	bh=HFk+dUPhJIpbMvaN83kYNCFGlCrXXL7I78bxa8OmaKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k19CHf4YRO40zTfAfpu93W9EgGitjiaIjdHg1LKXU3WbAm/FCap8z7T8YJwkWWCvT78QVxssjXljuechltvpsJL3F/Y7ymITN4avKMMv2QMSEhRolFxhEuExWCPV8QIiWXdJ6v9uobkN2BxXGdwplOaG6oczAKkMzx//5Bai3hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUQP1HGg; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45555e3317aso21181635e9.3;
        Mon, 28 Jul 2025 04:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700602; x=1754305402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYanvuAOr20RGfFV5GLhxsX3ZelVGtmbLFqhfg89izY=;
        b=hUQP1HGgrDAY5won1kEawF4ITVkvaLHGoXpJvWPvWZVU1y3Q90otBcLrypzsnCKuIc
         G1H+1Alj2EnNS/D0eGF2pQTeagO1nYB3c50LJfEH9A9mVGv/Pruvo8ScK3p9kfISjEsq
         JTZDGN723+ncxyiAvvsnw8PXcYw/SjSLiPSxAG8CCqMwinYOBkcYhvrRtNBOFC6QdTkw
         Hngq7xm6BKokUPGKJZuLJPacLxXp0fN3w0xKs4pxAKSP47I4cTQSASucsWEu3emrHuQX
         iku4qkqNVby4TpH5Y7sWJEMqqQAwf+JFQ5EzIAbdhgTCFIyaGj16dKVf9ixwbvR3WUQx
         9jIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700602; x=1754305402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OYanvuAOr20RGfFV5GLhxsX3ZelVGtmbLFqhfg89izY=;
        b=aezF699BL/WOdEy0FTWF/pYiTcFFTkeKi9GMMnbyNr0tY9pRjGxY8zr0h/AVuWKBH4
         5cz5w7duPFH5OkkWuxhFHnxnrbZqQO7QgbWgrejp7GDDoHzg7ZmghTuIY5FYADG4et9p
         aU8GPTmOAcCYQmMjMtLgS8UsyeHx9ukbbUwXw+8YCr0SyLsIN5ohzbwCV/r8SdxTESV4
         4i3tp+9cfcw3sP8GCXOerqaJdzSVGVXyKW5Bm3J5f3EPz43IvkB7NI82fnJEOjCvoopZ
         26ptrvKDkUfWxfELa1zDglkULmlWC/SdC53C0grluC/X2AZ9W5by2fvaoedhopSeyMS0
         xjvw==
X-Forwarded-Encrypted: i=1; AJvYcCVV/G1zrzdlD8zjdgkygaWj5XrwixxMYyGPcCGhph20xZR3uYZZPglzb/0ICg7h8cyYk2bozEWO@vger.kernel.org, AJvYcCXkRiU5UWRe3bhSvzl03RJbcryvcW6CWJAGpHKt+xPuFrYZQKbsYREOhQz0wU86Q83QSWKVtMjVyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUJqgokKtSkdy3VKBeg/xsyrMEkURJn0afl7dB8NHZp+k8Xx/G
	QXfNqL4seEDJfx83ImC+md3ioalp3AdRQuXfv2/7yYQiY830nADjriqW
X-Gm-Gg: ASbGnctnnr/jNlKZvsYtZYcNEveuF8i80boiyTibQU9oH28mrs62vrv3219ZTY7evfl
	3Sdi/YA138VZALgZ2yAlJOwmT08Mh1vN3mrFi/smc422J1yxvojI648fPNH37FBeCR3NJg6rxz4
	yLLqRbQf+S1ftrySWYWTmFqs9E31tCeLejB2kH1M8gsQJMAODvCAgTysOHSc63vUNwxYcAYwpEV
	pHfAoQMMcIZmg7kT/vKVXBATPLdu32Ub5eJZsm0rbDBIoTJmGUT4Y6WML7WJtMD9CoEjVDQULaU
	Y5BQQDE+btRKDBKkzw+CtVL1+l6vtQr0p/46kTocHbh8QYgiMwrkOfqfjT/4RaZarD2bUdaFMr9
	3wto=
X-Google-Smtp-Source: AGHT+IE7ZtHZ46wwEtRcZCaak37UbF2KE1lCMaSKYSDAgZyNrc1LLwwauA+AjqR2SI/231go/H7CCw==
X-Received: by 2002:a05:600c:1f8d:b0:43e:bdf7:7975 with SMTP id 5b1f17b1804b1-4588525dd9cmr30930275e9.32.1753700601505;
        Mon, 28 Jul 2025 04:03:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com
Subject: [RFC v1 07/22] eth: bnxt: set page pool page order based on rx_page_size
Date: Mon, 28 Jul 2025 12:04:11 +0100
Message-ID: <513689ae6632db4fef02f9bff283b6ad36596e05.1753694913.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

If user decides to increase the buffer size for agg ring
we need to ask the page pool for higher order pages.
There is no need to use larger pages for header frags,
if user increase the size of agg ring buffers switch
to separate header page automatically.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 274ebd63bdd9..55685ed60519 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3806,6 +3806,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	pp.pool_size = bp->rx_agg_ring_size;
 	if (BNXT_RX_PAGE_MODE(bp))
 		pp.pool_size += bp->rx_ring_size;
+	pp.order = get_order(bp->rx_page_size);
 	pp.nid = numa_node;
 	pp.napi = &rxr->bnapi->napi;
 	pp.netdev = bp->dev;
@@ -3822,7 +3823,9 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	rxr->page_pool = pool;
 
 	rxr->need_head_pool = page_pool_is_unreadable(pool);
+	rxr->need_head_pool |= !!pp.order;
 	if (bnxt_separate_head_pool(rxr)) {
+		pp.order = 0;
 		pp.pool_size = max(bp->rx_ring_size, 1024);
 		pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 		pool = page_pool_create(&pp);
-- 
2.49.0


