Return-Path: <io-uring+bounces-3744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 516669A11F0
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5073B221AB
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5DB2144B1;
	Wed, 16 Oct 2024 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="plXN6UGW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3A2141D9
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104789; cv=none; b=entJw0i4ZHJlFxkZ/C2u+tiMwoNtp/v0lSYzW9QfcHIxir5MDxT8B2HxXxEDKajIqer94xuyK+W0K3ZXcApBie7Ctfw3AtUQnZCigOrBY1t8Fnjw0X4a9nlXHepRrZRFT3lD0BkR7+FqEU3mnmd7oTodq2dTNogn4ILj5H6cUiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104789; c=relaxed/simple;
	bh=N3Lp9/YMutyVAvs4ge9B26lNnGjZAtdOVSMB+PgeaiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id5n85zZZomqcJHr28wB0dV7s0XvsmcZbo1F3ts+1h2dKx40MBfy/53PxPCoDH/1N7D1Zbt1uUmNLbNtAIoAGyjJwGyZxSBuRNTO5JzHH4p2uPT1Js3Jeg6f6aHw4UhWs93i/vgjwzsQalGMnYwW1Oo6tyMCMlZYRY0hgKlVc+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=plXN6UGW; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20bb39d97d1so1199825ad.2
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104787; x=1729709587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqnj2vEyFSNWAQ9NLMcT3cBERALcNmYBRjCTByCN/C4=;
        b=plXN6UGWVI0s58g2c13bqr68rgHXY/CfC1Ody1QYQY1vxsMooTd+rwJyMlsJg+l0Hv
         p1AGyGACS44E/Mh4xb8IYK2SgH+D/HBTwQlSNWDv9hhWTSBhAbeXE9NwBKIM2cae13H9
         Uvt6PWRu7naD2LCrqSpH+hQcNZw1vZdUC9bMLNRr8SfDCcDlPOdxYBcjiAponu9/2fsW
         uDv17UsuVVU6nMkupl+hZQehLPTMjDSDPugQNmerj896ZxwTZIjN88R/aEYA1VxzuVed
         /ctKPAkWRaLmZNpC8JpsONr06eyVQyXHBx+htQkd1o95zaxStIYLOUFCOLVazaQZFgSd
         keUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104787; x=1729709587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqnj2vEyFSNWAQ9NLMcT3cBERALcNmYBRjCTByCN/C4=;
        b=dh9Tpd8dUts8JOvJHeKadcb3q2twUIs/5lPwtv8n9rCr7P3/ZQgkEroZl2eC8w906Z
         y/xo3HXTNddnALBLldjOw+CF+D5HR4hpyXrzXgF05pj64dlhp2xXJPns1yvDEaqQ66fE
         Dgncg7+OEoeUQzMb3x+46gVco6qnbhm+o1+U9tahfTCg/iEhwub+eIjsXw7tIZ3nKUOf
         u8PXz46y0pbBW4ccDY+/CaHnQQ5AlE029yEumL+XNjv+YdKYQiB1Lw+1vjbMZqWl0lgK
         inbswgKVyrTkButd/uXQk/cKHrGEzOhnPnSDR8cZzP714cyS1vzcvWc3xbAme//MVjRG
         pJLw==
X-Gm-Message-State: AOJu0YwP8M3JqXlkzl/evJAl9p0HWxPztMqeFBaRjPq2Ppd2oN7kqZMR
	18Geh+oDqJ+rkLm7JGGUoWlER/mpdnuUKAhIrsulbfVcdkxNlmfB/PTaG1zifusYVECnmMXLZ0s
	+
X-Google-Smtp-Source: AGHT+IEwAQMbKcO2swe43BJm87R77nv1ylDvAa5ptxGJajdS3oBkRi+JXcNlOYLFwPMwDCELFcU/bw==
X-Received: by 2002:a17:902:ce09:b0:20d:2e83:6995 with SMTP id d9443c01a7336-20d2e836aa1mr55849845ad.47.1729104787172;
        Wed, 16 Oct 2024 11:53:07 -0700 (PDT)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d17f9d3f8sm31819785ad.80.2024.10.16.11.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:06 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v6 05/15] net: page_pool: add ->scrub mem provider callback
Date: Wed, 16 Oct 2024 11:52:42 -0700
Message-ID: <20241016185252.3746190-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
References: <20241016185252.3746190-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Some page pool memory providers like io_uring need to catch the point
when the page pool is asked to be destroyed. ->destroy is not enough
because it relies on the page pool to wait for its buffers first, but
for that to happen a provider might need to react, e.g. to collect all
buffers that are currently given to the user space.

Add a new provider's scrub callback serving the purpose and called off
the pp's generic (cold) scrubbing path, i.e. page_pool_scrub().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/page_pool.c          | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 8a35fe474adb..fd0376ad0d26 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -157,6 +157,7 @@ struct memory_provider_ops {
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	void (*scrub)(struct page_pool *pool);
 };
 
 struct pp_memory_provider_params {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index c21c5b9edc68..9a675e16e6a4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1038,6 +1038,9 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 
 static void page_pool_scrub(struct page_pool *pool)
 {
+	if (pool->mp_ops && pool->mp_ops->scrub)
+		pool->mp_ops->scrub(pool);
+
 	page_pool_empty_alloc_cache_once(pool);
 	pool->destroy_cnt++;
 
-- 
2.43.5


