Return-Path: <io-uring+bounces-5545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D6B9F5BB4
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2C1816B197
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058867081D;
	Wed, 18 Dec 2024 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="y/uNsJon"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1CC57C93
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482286; cv=none; b=Z9HjrgYF6PLmaK9Ci3JXQlXEBPnABkBFw8Q3S/zPeYsqbZ0lvgJFyGWfcbG6/S7b4ViCt8fugfSk0dmqTM0cn8WZsJ/2ewScqZ8HIT3gzmpwdCeNvLvJQ/RrZHWowTpVkZtW1Twx55h3GnH8c0X7UpAJURQQRLjd70hUdjo87J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482286; c=relaxed/simple;
	bh=u8mGZDNB9Qjmsc/UlJUfk9+yqa87F2hF6bBOxlT29Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9PquNEJKgGBMQMpW8jKqI5gYiGFIaBRbPEVgEB2xHWYkZ2CTDWdyL+CLc8rxah4+PpwpOUf/prgAMcklmvzFxRjaN17QjHp22s0Pq8tTClFkws6p9dkYKhm1NRNmthGcUKp8zVx3iFDrYchGXbhPYX19coo7/yk4PgIqGVCATg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=y/uNsJon; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-725f2f79ed9so4716646b3a.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482284; x=1735087084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfBsLg62G3udJQ4BEA3v9yLwP4UTZUhvXQSSmczl4Gc=;
        b=y/uNsJonVkGAR4Y9RJlTtMp5RjcIPPaddX//xp21xRWymBP2JlBIoKCe9K5EHoL618
         sF2f7RGPNjhspZ2oqOJXENnFPQhUUQTFaB9cvOWlrnqjdtvsuPxdczW9CRIL1yp7Oh5u
         4H5MqbgP4ID3p20qT/TEF05g06zR+SBVtXs7YETrPYpBO5WsnePvZxJ0WCUgoGdmvV6H
         BhQvJzxKCOYZwYnJgkFMZIWBgDsyQImK2+z/fqbvBOuBf1+XuWElRaeaBgyJrBgTd8ei
         7IBSpWssqMUeyRD6dUTVOFcgkc0nfiSHYQ+GCPI0yUGDx/QEHW9Pgbw75CR7Fo+0k2+i
         E7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482284; x=1735087084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SfBsLg62G3udJQ4BEA3v9yLwP4UTZUhvXQSSmczl4Gc=;
        b=bJ0Zb4p6Ilwq2qJwHQLgO+HFvMINe8ob1fkZBWhgSESG/r/L49394KWJJdE2O//ky1
         pvbLEe3IXbRNjgH7SHH61Msz+VWcBHKel3yeNHVilempDKxbXQrvnPz5au2TONum1MpE
         PpRlp1oKNM8zP30raxA53Zfw+FYE2ey8ubByJLluPONla5T0No51dxZpjcCivl3rnpYR
         IVYgzNgaVsHs+P2VPYIsj06eESJVGXLNRKwfO/4cMCpGWl8H80ssSsjE/ZM81MmjQA+7
         4OzoZnMUrs+pRl/9R74hC37iV4M5OJEKDpRzKe/iKvedt7Ed6dmscc4DgV80+heG6W8I
         hIgw==
X-Gm-Message-State: AOJu0YxnfHq7AiNa7q7w2Bz9jW1/bB/nS62Mzb7uddvzqJlTAtVyq+wB
	a7MuzgX/Mwm+/0PIChNlpCycJ6xyoIT2xlu9mABA55OdR30te9aQgY4TXqJX2wPCDhjQuQK3jMH
	V
X-Gm-Gg: ASbGncth+R9p2gJVixDZ9rjsZBu8z7SXiMU7ZAdzK5AONRuEcMbRtNuiK9qV016H/0v
	ya2L6Yg0YEYDUW99srOVXBD5EbPCZ7ldoHnr8nrpxSTWPgCN2W/R0s7KUG2CcZx06/Q4teqSr3X
	s512aad+t7gKMhYbuBL/Wwun0rb6wZKrGG8hk0u59r/I3GzeYNk1nzVSxTIQvjOpcOrCGpZWGNW
	fC80pKOUflx9NgSVKoB3Odm6BMQwEp5+cUpv+2wSA==
X-Google-Smtp-Source: AGHT+IEw9r6pYaV+WZpZxDFOXvkhuSj4oVM1TjX5jqIldm+QJwQg57nxRHAvaycdcT0mPs5JISR8Fg==
X-Received: by 2002:a05:6a20:8408:b0:1e1:c26d:d7fd with SMTP id adf61e73a8af0-1e5b48a0f20mr1498011637.37.1734482283788;
        Tue, 17 Dec 2024 16:38:03 -0800 (PST)
Received: from localhost ([2a03:2880:ff:10::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5ad1db8sm6414671a12.44.2024.12.17.16.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:03 -0800 (PST)
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
Subject: [PATCH net-next v9 07/20] net: prepare for non devmem TCP memory providers
Date: Tue, 17 Dec 2024 16:37:33 -0800
Message-ID: <20241218003748.796939-8-dw@davidwei.uk>
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

There is a good bunch of places in generic paths assuming that the only
page pool memory provider is devmem TCP. As we want to reuse the net_iov
and provider infrastructure, we need to patch it up and explicitly check
the provider type when we branch into devmem TCP code.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c | 5 +++++
 net/core/devmem.h | 8 ++++++++
 net/ipv4/tcp.c    | 5 +++++
 3 files changed, 18 insertions(+)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 4ef67b63ea74..fd2be02564dc 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -28,6 +28,11 @@ static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
 static const struct memory_provider_ops dmabuf_devmem_ops;
 
+bool net_is_devmem_iov(struct net_iov *niov)
+{
+	return niov->pp->mp_ops == &dmabuf_devmem_ops;
+}
+
 static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
 					       struct gen_pool_chunk *chunk,
 					       void *not_used)
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 8e999fe2ae67..5ecc1b2877e4 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -115,6 +115,8 @@ struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
 void net_devmem_free_dmabuf(struct net_iov *ppiov);
 
+bool net_is_devmem_iov(struct net_iov *niov);
+
 #else
 struct net_devmem_dmabuf_binding;
 
@@ -163,6 +165,12 @@ static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 {
 	return 0;
 }
+
+static inline bool
+bool net_is_devmem_iov(struct net_iov *niov)
+{
+	return false;
+}
 #endif
 
 #endif /* _NET_DEVMEM_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b872de9a8271..7f43d31c9400 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2476,6 +2476,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 			}
 
 			niov = skb_frag_net_iov(frag);
+			if (!net_is_devmem_iov(niov)) {
+				err = -ENODEV;
+				goto out;
+			}
+
 			end = start + skb_frag_size(frag);
 			copy = end - offset;
 
-- 
2.43.5


