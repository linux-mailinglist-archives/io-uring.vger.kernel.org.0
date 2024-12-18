Return-Path: <io-uring+bounces-5540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE4A9F5BB0
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA2A97A0F94
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C564A3595F;
	Wed, 18 Dec 2024 00:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="0Z+H/K1I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99181CA84
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482279; cv=none; b=FtvbeqCY1xOQZez1VsuRbX+RKKaLcdTCRw+4pU7t0lp9jCugWwAZAwfVajmwe2bY3WORNtJmzeh2gU3I4v0iKQMSQCvx6cC9lnZS6S3T93PJ9B1N5opiCg/3cHUhMtRWxNHRkRJCkbZPP95DZvRnqnMoJa2MMZcq8IbEKU6Jxcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482279; c=relaxed/simple;
	bh=kokGPXOtKmJ8NMnDjbo7lcERhIq+pUTFKWNlFSMMVJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO7FlY4fSVdjshH5kC0PWGrFoTiG6VVZhtpjXSGeTfJjpwqX7KoYNYm+mKprMxPSI2xEgL+QBQ2vmWd0yo0NlzdYt4fEp8WNiWvEAmE3vbXbZzTMaRSAARvjdNd4pObiZAuHm/HC2S6B3l9KqQrLUWc6YGOeXtiGyfx8UtHJ8Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=0Z+H/K1I; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-725abf74334so5188453b3a.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482277; x=1735087077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysSCaIB4GXTEiUBi/fqYnu5BV5g5/6ElTQwwBF3xc+Y=;
        b=0Z+H/K1IAW6vINrpYYHp2BxAQHHXvwAgmLLciv3KpGbcxl+cp38lD/ujCpUhb3XB54
         rTMgxE+d3iA5QgVTJm5N69ogvB/p17m48mPzKa7ErRDKa2t2GDZyAQ/o+955LphXGdqa
         5gwl+2nxbjGTEwrD5jJUHzEJE7DPwsVbS4obFRzVCcgHOT75q0U6QmZIfusC9PL4MZEc
         T7J0+GvIpgh7M9DgYO972QBTwszHN5SAJ7DairNkRojoH+UOZiDxS0/cWFF9L2ts+VE/
         vY6zYDgeZNkD3pmuR2wAh9l6R0VKujUjNmMx6X96DtOrDu98/YkgUhnBlD+UgFz44vnR
         OQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482277; x=1735087077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ysSCaIB4GXTEiUBi/fqYnu5BV5g5/6ElTQwwBF3xc+Y=;
        b=s5Wl2QO7ls6EPyDGIMTeWFwzY4Kx51aN4scIk/QoZucCq2pl7WzDLLbg6jlPAWPchb
         Q7aCZgCLGP6UsE/yUZV4SZErIJal9VxICihWEejmgAjoLZyTsxBCOscY4MIJ7J/rQKPV
         ZgR8kQLXw5g7KMdDfn8UfwAk/jdr8DfHFrC9Z/Kwjgd6gMkMFwp0iCIbLDmAYryShIg9
         BJb44vRMijUjoe1dshcqE3sx+av2UX4bILsiQUNZQTqxTnZi+X685pLeQcFs5D2gZbdM
         L+3865EgYyx9Lu1KeiXCjKP1UJBmHLXt+oucr/4plCgk8o4T7tmERXLRVFdHceikFLpj
         3GhQ==
X-Gm-Message-State: AOJu0YwYyNyzocp5H5EWLxEQ2oAe6EM2xlW4vxlCOY8U94tNYpKpyQH1
	dLM2GRYaQSbyP60VD868wuCm1kA8QVFjn0tWle6uX9mfid+OB1qsi0EXR0IWRQuP2FlSHpLTarL
	h
X-Gm-Gg: ASbGncvpKFNwzC3MYYKD5pZkcT5hRSPDS1n80a5Ycvh6sjT1kl2Us4oh7FSXakuD45d
	J5ORlsgbGOyQZK6Cp8Xm+rPKXNXLaOg5YacxLNft0/+3NPxeiEyek57I4pP/pPKB9+ytljDNYZ9
	ybrSMmE797GS95m2AjB3xudxH7iINtwZJQrokNLnDwe0gmBePLOlHrNXxe4ybrRKmIwwp6Egz/p
	SFkeLQttvnZ2PZvQ8XcWIpRFqNQ0D0M1vtSJteL5g==
X-Google-Smtp-Source: AGHT+IFiduWsFdTMQ7qJ3+csnpW5d6D63RLz/DAzXmw/lXvnVUdd9pwRGFj+/LTxRBsIl63Y1H4L0Q==
X-Received: by 2002:a05:6a20:c70a:b0:1e0:cbd1:8046 with SMTP id adf61e73a8af0-1e5b45164f2mr1526795637.0.1734482277120;
        Tue, 17 Dec 2024 16:37:57 -0800 (PST)
Received: from localhost ([2a03:2880:ff:13::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5aaf4a4sm6408269a12.25.2024.12.17.16.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:37:56 -0800 (PST)
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
Subject: [PATCH net-next v9 02/20] net: prefix devmem specific helpers
Date: Tue, 17 Dec 2024 16:37:28 -0800
Message-ID: <20241218003748.796939-3-dw@davidwei.uk>
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

Add prefixes to all helpers that are specific to devmem TCP, i.e.
net_iov_binding[_id].

Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c |  2 +-
 net/core/devmem.h | 14 +++++++-------
 net/ipv4/tcp.c    |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 0b6ed7525b22..5e1a05082ab8 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -93,7 +93,7 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 
 void net_devmem_free_dmabuf(struct net_iov *niov)
 {
-	struct net_devmem_dmabuf_binding *binding = net_iov_binding(niov);
+	struct net_devmem_dmabuf_binding *binding = net_devmem_iov_binding(niov);
 	unsigned long dma_addr = net_devmem_get_dma_addr(niov);
 
 	if (WARN_ON(!gen_pool_has_addr(binding->chunk_pool, dma_addr,
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 76099ef9c482..99782ddeca40 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -86,11 +86,16 @@ static inline unsigned int net_iov_idx(const struct net_iov *niov)
 }
 
 static inline struct net_devmem_dmabuf_binding *
-net_iov_binding(const struct net_iov *niov)
+net_devmem_iov_binding(const struct net_iov *niov)
 {
 	return net_iov_owner(niov)->binding;
 }
 
+static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
+{
+	return net_devmem_iov_binding(niov)->id;
+}
+
 static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 {
 	struct dmabuf_genpool_chunk_owner *owner = net_iov_owner(niov);
@@ -99,11 +104,6 @@ static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 	       ((unsigned long)net_iov_idx(niov) << PAGE_SHIFT);
 }
 
-static inline u32 net_iov_binding_id(const struct net_iov *niov)
-{
-	return net_iov_owner(niov)->binding->id;
-}
-
 static inline void
 net_devmem_dmabuf_binding_get(struct net_devmem_dmabuf_binding *binding)
 {
@@ -171,7 +171,7 @@ static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 	return 0;
 }
 
-static inline u32 net_iov_binding_id(const struct net_iov *niov)
+static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 {
 	return 0;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0d704bda6c41..b872de9a8271 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2494,7 +2494,7 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 
 				/* Will perform the exchange later */
 				dmabuf_cmsg.frag_token = tcp_xa_pool.tokens[tcp_xa_pool.idx];
-				dmabuf_cmsg.dmabuf_id = net_iov_binding_id(niov);
+				dmabuf_cmsg.dmabuf_id = net_devmem_iov_binding_id(niov);
 
 				offset += copy;
 				remaining_len -= copy;
-- 
2.43.5


