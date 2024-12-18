Return-Path: <io-uring+bounces-5537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA8C9F5BA9
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA08C7A54C7
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A5E43AA1;
	Wed, 18 Dec 2024 00:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="wi9teH3Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D0D3597F
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482166; cv=none; b=R+wiPVkucDOlcUX32bQB+tqxPh0ikJU7mDgLcChhBxKkqkagFbd/thFqVULLfC1LtzkLD19tx4m3hj85lACMCW5rAO4kPgg9TIS8C2KV5cSdZvcBsPUU0gEmBild6UpYqBPz54HFIBp93lDG3H6sMrkYQkUl0X6NqMnIGY6PCH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482166; c=relaxed/simple;
	bh=135g8sWdi14q9q8Itt2VZQPm7R0gFcz1ULHZpEn4dmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBHRy/I0hFJ4rN00KuFJ0RUGnTXenhiv8PGkYmxjHA98saTWxoosJpMfxwdpsKKRf1lstuu5LFxO2iz14NFKxnGIYAi+m16+DsNsXZvxu6q33Cm00QgcTb3AFex/tCE0KhqHrVJ7YH5S9KsNpBfg6D8cqb7/KnGN8qWnNlMKIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=wi9teH3Z; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7fcfb7db9bfso4038320a12.1
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482165; x=1735086965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQ73wFKVt12qccWHG7cPPzOfiVyAwI1MB/XTBNYCLeg=;
        b=wi9teH3Zjc4zmlVYJ+wxsCtSP4yXDkKkfv/oKxU54LFiymJrRurciP7UeTPHMXFwGj
         PSLC+7BLrwPwELcavZsc12jOGytCAnqwwq2pTKgeo/CNbKAE5YP5J7Pxt9pPzTEPQlsk
         n4EK5bUwW39A+WNQVMcpXIwON/vVxamvgGEM0OwmGL4BcrVfcIWlhxyediwaqZMVEXmr
         TzGUbMVbFUubiGxTas2A4ELA0LVPOcK+HBvV+JLy41ygDhjv54vNDg2tzA427i+284Rg
         q787crFEfEn09hSdpEYp4uRLjcg8ay4Nf+98GPtIExIzkSY402W1TtkfkeZuI1j8FTI+
         JqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482165; x=1735086965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQ73wFKVt12qccWHG7cPPzOfiVyAwI1MB/XTBNYCLeg=;
        b=qDwLW+Tt6cbIuN1W6mTG7A0nB0qQjbDZo3wSSjsfiHz1z1rIwF8DVB7CRplvUa4ZEM
         72HGR4kZ2tSwD1eXNeE++yqCjuqDNSPbhbhw13xIvdq1qIcuxpXwK8IUzmHkvSYIvXht
         EtXdNcg6HjVwLwFKcFdE3q/LXHC8zLpZ+Tvh4w/BDKPN5NjQCVhtKp6OyfUAWT0qc7mj
         AlaxB2kSGTK5TJ/6j3q/FCOKpt9RA8NtJkTxUGXi22t2/t7QjfMRnf98VJFZrskDbPEM
         W4gBRESvYdrBuMhnnk+LowbUIcPcLXutWoglwzIyWdE8Ohpxip53simS/5pACrBlER71
         ut/A==
X-Gm-Message-State: AOJu0YzZ/KxAu3wvTwg6AENwHwi36KTJOzACbdP5UXUerMt7PHGdY+hA
	e1YCuhw6daLFK8WEHWuijuU7qtaehEfO7wQ4W4i8JgDfjFrhu1k7Pmacjsdk1fMiPsN1U5WAphC
	7
X-Gm-Gg: ASbGncvbJt2A6jprnvwGr0iaQaivf02i6ubQzqVe/1NoS/deD4Fsy5EA4zh2p+hmnrR
	h5167S5eYoWAuzHHvCkoksyrG1ndAwCMnYxvste2CFDzDOBXt7KLQh7VPsYe53l4aad3ebY+lon
	dafxcAGy9JAbG/1ZxGVv7IQ55I7nDbkdus+EopwSxdt91RXTiz+rumsNS+SsToqBnpNBNaM9Apv
	0gBYrCXEX/9sJCkpeUS1hHXoYwO8O7SJmpy3UqQxA==
X-Google-Smtp-Source: AGHT+IEEmLhfsg3d8KRh7lYkeLWJXR5yLAID5ZTIPn5Yij4dunrusE+MZoJ2ZrylKcRPNbr7UU+E7g==
X-Received: by 2002:a17:90b:4c0e:b0:2ee:49c4:4a7c with SMTP id 98e67ed59e1d1-2f2e91feea3mr1318385a91.18.1734482164829;
        Tue, 17 Dec 2024 16:36:04 -0800 (PST)
Received: from localhost ([2a03:2880:ff:20::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed62b2afsm109623a91.12.2024.12.17.16.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:36:04 -0800 (PST)
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
Subject: [--bla-- 05/20] net: page_pool: add mp op for netlink reporting
Date: Tue, 17 Dec 2024 16:35:33 -0800
Message-ID: <20241218003549.786301-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003549.786301-1-dw@davidwei.uk>
References: <20241218003549.786301-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add a mandatory memory provider callback that prints information about
the provider.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/devmem.c             | 9 +++++++++
 net/core/page_pool_user.c     | 3 +--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index d6241e8a5106..a473ea0c48c4 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -157,6 +157,7 @@ struct memory_provider_ops {
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	int (*nl_report)(const struct page_pool *pool, struct sk_buff *rsp);
 };
 
 struct pp_memory_provider_params {
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 48903b7ab215..df51a6c312db 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -394,9 +394,18 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
 	return false;
 }
 
+static int mp_dmabuf_devmem_nl_report(const struct page_pool *pool,
+				      struct sk_buff *rsp)
+{
+	const struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
+
+	return nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id);
+}
+
 static const struct memory_provider_ops dmabuf_devmem_ops = {
 	.init			= mp_dmabuf_devmem_init,
 	.destroy		= mp_dmabuf_devmem_destroy,
 	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
 	.release_netmem		= mp_dmabuf_devmem_release_page,
+	.nl_report		= mp_dmabuf_devmem_nl_report,
 };
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 8d31c71bea1a..61212f388bc8 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -214,7 +214,6 @@ static int
 page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		  const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
 	size_t inflight, refsz;
 	void *hdr;
 
@@ -244,7 +243,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 			 pool->user.detach_time))
 		goto err_cancel;
 
-	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
+	if (pool->mp_ops && pool->mp_ops->nl_report(pool, rsp))
 		goto err_cancel;
 
 	genlmsg_end(rsp, hdr);
-- 
2.43.5


