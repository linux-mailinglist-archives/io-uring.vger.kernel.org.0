Return-Path: <io-uring+bounces-5927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CF7A14533
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 823641682A3
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFBE242240;
	Thu, 16 Jan 2025 23:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="b3izO1BA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED2922CF2C
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069434; cv=none; b=WBQN54BbUrKj3DsAPPUKUwX8EE2NXtxL6Z3S4hY6Pj6UZcxZPf9JhhDsO+9F+DTSB05jBegSQoRRyEZiC+z+MX7Ls/W5YN5aHnRaYqFKJTlAWQ0onDvlUmOQSZRPNVPI6plKbN8RJxkfStAJqIJUqptpn/fRH/xfIK+lyETVKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069434; c=relaxed/simple;
	bh=1iGhFb5yYmlt+N/E7uhnersaFVha+jc84E0nut9lM44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXxR8H698K9FzLq2u7fGiaL+YmxeGNBaEBj/y2G1Sl6YffFkSQPNhzzkF23aeabGug624zxtXYwQsNHTP3h73MpRSvkT4DrX7167PhI62k55Se9bJTAcMvO3CTOThaxhv111AHPfL4HXBJaropGX2zpVMqulcShDGj4Sk5PFRHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=b3izO1BA; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21644aca3a0so34602705ad.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069432; x=1737674232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ls7TIJmWbtjH6cQ+zvuFtI+oK15m0KZtEVTJMdgXvRQ=;
        b=b3izO1BA5enllOrhuBplPAeuLTQsPKGKZND8TL+h7KLgVqGJfafX3s6OdSyRml9+pf
         pVK+6GIuQ55gkIGyNgHfuXeb0JgXQQMYM7zkIP33ai8UxhFrhLj2B/KQrugiKt4X7En6
         zV+QKnpS7outUWrNaNa1Y6CTUj7D0Oixr1LhpZHJJ9TzV7byP9fvMaJTPn2hraNf4ZGQ
         opHZUI/fTtnjjQFtyt7bQFw+7K90S43ZpC5Ko1khIqDHjWKfT8pWtdgT2981xy+PSWgx
         u7wBvKz7QFNZ7RQL8PKkMYQcAxKzX047UPfmYD9WgzZo7vXUJBQLcJRs6bjQcoqeZbkE
         yFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069432; x=1737674232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ls7TIJmWbtjH6cQ+zvuFtI+oK15m0KZtEVTJMdgXvRQ=;
        b=I9bccOJ3tRUlNXfQlXMOWupxD1yHbWY+hsr6g0u2PRU04Pg/CTPi0NgbJRD2ah5Rod
         /471Ux5f7ya3bPLK8uHpKpW6hh5grQRSyD66vdYeBU+JQvGrRiz8b0ha0ZFpJQyvEWZX
         ISI1epeXFeRh41usgMFiwvy9286BQYXEf5V5/mdAYgYVAC+tSzuPVDmzdhwkkIe63sci
         6tgSKwlFyGsestpaFN5d82AmfWuldeXtWV1QigwcbZ7Q0xov7NfmrnIxldt3x9YZ1FZ9
         ZPBZmlYy7k2abP/BwjqWAsiVJevDLTPp3mhjA55hQDxEOP7bfas9MVrpEnDAEXVBoNEE
         ZB3Q==
X-Gm-Message-State: AOJu0YxPDDAVIqvyeti/ZA7//nJ4t8goPEdCA6ZwaFJ1QvfcWQ902w2P
	DQBUHN1/8N7mwX6Sr3AhydEB8sax2W1GF9KPO94Rthdc9+azTYkHoC+ChbFC8T+F0BkckBRnpDZ
	0
X-Gm-Gg: ASbGncvGWXbbt5Eg1BJR/MP524TtY5nXQZ4bA0ITR7gbEMAbfSz7tNXwqPxwLB8bVo4
	1ukWKNZneauPWhGtPrFlv0MJjWa06ay2kaLg0zyJCkE3t64cNWL4KN3EY9rr9APjbFpEG/w2VAV
	AEetxT7WHPwhFDbarawdqhr2HaTlrp8ua1cTCR7q/kUjp9P5i/v5lKE3B33VdMRbBt1Nhn2vYvX
	8v/ljrz4jz/kx4dnL02cL7BZ4EDEMi53POHRen2xA==
X-Google-Smtp-Source: AGHT+IE71cVmkTwlhEWppykLzPgYxNM7h4dJ+MNl7UXVZ10XHLjhkMrqkn8AlPhME2DxTq+/xg7ZYA==
X-Received: by 2002:a17:902:d58e:b0:215:a57e:88e7 with SMTP id d9443c01a7336-21c352de0damr8272885ad.3.1737069432322;
        Thu, 16 Jan 2025 15:17:12 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1c::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f77611d5d1sm751552a91.4.2025.01.16.15.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:12 -0800 (PST)
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
Subject: [PATCH net-next v11 02/21] net: prefix devmem specific helpers
Date: Thu, 16 Jan 2025 15:16:44 -0800
Message-ID: <20250116231704.2402455-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
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

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
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


