Return-Path: <io-uring+bounces-5547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C33D79F5BB6
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C1281649EF
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D6412D758;
	Wed, 18 Dec 2024 00:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="H50uD3W4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ADB1D555
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482288; cv=none; b=jIEpatVpcJ1FemCXm5phLTNfG9ZMpjiHTZg2gaalT0kcFxYYe8WlmAwfFPPUEChoUR9tNpjjuPvVlDAmFWUQuKmiFf1X5GKN4YfjCn6rui6HvIthVB2T3qSzjLuSuDQSxeFGfeGiPlnEstm+yGpKG/3MGHgZZad710yXEUk7VVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482288; c=relaxed/simple;
	bh=vpb1RqE2oItfF+cd5OEWt41VjC/VVahEOuu/EmRc8Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzEIZijhnZx6rfhzNq/9ERsCSrlhKw5nuzabb48q7j9rSRvzLUBWf4BF2TVsrzps3NrdSGZbXtIdYuPqv9hEldb58lUL1qstfA5uasdftIW+ouyeXnLFCxsLk6JaWBMxRyWBG+xCtjaTKSBqsBbFTUGc5uEssyr05Xmk582xzlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=H50uD3W4; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-728f337a921so6146342b3a.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482286; x=1735087086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqHdgehgC1Ic8m6ep7wqnpAK9OPeHiEms51AX93eYRM=;
        b=H50uD3W4yo6bR4A2vdp28ASN52jXlz2Aclyi8Y7ddhOWZirV0J80NzSQLxrHpvtXBy
         sXZjpvYxFIYnMCweRnfL88YSzm9XOa+L1RicTGeh89yXiNoeif3loqFMH6efYNGODc8X
         nuDiYCpK0P2jqA0kzuxVoE/ELx1sZCWn8V/i31/uu0z89+o/T141CW0zjmYkaspIfTjU
         16QthKVwQvsRPrMWnAQwzcZJoqibLJVRD5HWyhiYdc5UxTDLHw4k8qtH3hSPraaoxtUU
         nc94V9x4q+bkWnsDdZMoecIGwK1hhHIwRRdZ9yxEiyrnQ38vJPvNHm7fPwjKJ+xTagh8
         mQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482286; x=1735087086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqHdgehgC1Ic8m6ep7wqnpAK9OPeHiEms51AX93eYRM=;
        b=rq2cDxhsaO3EaZfsMlxj1vpN/KQbuVdUoc41jCVn/1exs2ubIo9MuDRr1cR+NGDbnd
         m1swLaapYW57juvEmtwoO5pgqczIxxQijR3x8DHh8tn6gfSjokGhDeUHN3OuWwIRVH9E
         JvlRkZNz8Bqg9q3oiAXxyVhQC1wjw6Rxy8LTGrOm9UArxB+lep8TUXAuHeh+01d+cmne
         3V61JgSu8+alLHNwl0G5KmO1HrS3Ni3rI0H+gDcj3NAHDnRPQQfrpKdkH6yGCfoJ9zuv
         m7jl7KzqhzLEhT17ED7EbhPsUxODyQKKe8jLpQzHrhxY64U20GDNAirtcM7yZ8YuVi/U
         VxNA==
X-Gm-Message-State: AOJu0YyH4RjkpsiXePJ2ByAcLRufmgKxZMEj9tdr54GOSi0dTqvh0D70
	ACGDJDPStyM/6K/XN2QRJM55B6Qc8JIqlAS3eJl6cbesLpHLcJaafmD3y671qGNPtJL5K3ZbAED
	4
X-Gm-Gg: ASbGncscudRFaetzhUdE16m6wz+pZ8hG+voWlIp+sJD28U5u95ACC+6Z20sXG25jI9C
	stf/35beEC21Xc3rCGgKiPzyhpT3fwv3KGQJ1Lby/yjCKktB96u54GDeRJy5FuRHeE1p8f8UU+K
	77KTjRKWvx8HD5nqzkalKf8y1kJw6nJzyztITIvJ6/ZX2YHC3gH24F6aWV/vxzzCY34KRdQAhAl
	DeGAwwcFx6ixZ7sxf4sx071PQXikYeBK8hHdmgE
X-Google-Smtp-Source: AGHT+IFFQoNzZ7s9BEUd/ES5OjK9CbE7OXHMUBrVHctTHOMC4qslzXHcsbqarIdlq0Oi0TFpPqvcqg==
X-Received: by 2002:a05:6a21:8dc4:b0:1db:eead:c588 with SMTP id adf61e73a8af0-1e5b48733acmr1859163637.29.1734482286294;
        Tue, 17 Dec 2024 16:38:06 -0800 (PST)
Received: from localhost ([2a03:2880:ff:b::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5c0effasm6428842a12.60.2024.12.17.16.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:05 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v9 09/20] net: page_pool: introduce page_pool_mp_return_in_cache
Date: Tue, 17 Dec 2024 16:37:35 -0800
Message-ID: <20241218003748.796939-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add a helper that allows a page pool memory provider to efficiently
return a netmem off the allocation callback.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h |  2 ++
 net/core/page_pool.c            | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 872947179bae..d968eebc4322 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -486,6 +486,8 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 #if defined(CONFIG_PAGE_POOL)
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem);
 void page_pool_clear_pp_info(netmem_ref netmem);
+
+void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem);
 #else
 static inline void page_pool_set_pp_info(struct page_pool *pool,
 					 netmem_ref netmem)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 784a547b2ca4..bd7f33d02652 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1195,3 +1195,18 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
+
+/*
+ * page_pool_mp_return_in_cache() - return a netmem to the allocation cache.
+ * @pool:	pool from which pages were allocated
+ * @netmem:	netmem to return
+ *
+ * Return already allocated and accounted netmem to the page pool's allocation
+ * cache. The function doesn't provide synchronisation and can only be called
+ * off the mp_ops->alloc_netmems() path.
+ */
+void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem)
+{
+	page_pool_dma_sync_for_device(pool, netmem, -1);
+	pool->alloc.cache[pool->alloc.count++] = netmem;
+}
-- 
2.43.5


