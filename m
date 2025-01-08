Return-Path: <io-uring+bounces-5764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5938DA067E0
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51B45167A2E
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04B5204F96;
	Wed,  8 Jan 2025 22:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="mqAecmdf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8278A204F65
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374037; cv=none; b=ZqIS01oRchWTGHfoWC6d0SjTv8Wt0LU4jF6z6xTu/LYdIj47lVB8FnTeVAvzk+4kNJhQyYFT6z343+zhbzQriMSTwklAQJ4ffeFeqepyl8gqJQddZWxMjnu9luv6hW+YLpQe3LZbEm1eyO7mGEYDVv9sDwH84YyKilKcNwZsiBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374037; c=relaxed/simple;
	bh=Bd0rHranX1tldtf5eS5ic1T+HB/zykxgLBff110E+Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWOQgX12pmrYMiLdieeL58QXI20juMlc+uGDEcAOwU/7HW2JjfsPIigl8IvMBveCQf6nhfyKBArr4w29Qj5xBtPyaFIqi2BBij9di34Jie97CAQjNUkYcrA/Pdz8cuZoVHE2/BD8ANW4QLK5OW26rzRL4iAZkTuieQtQnMwLxWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=mqAecmdf; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2164b1f05caso3364195ad.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374036; x=1736978836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iXcgdxDm1mzjOKK5nUQi77bzCX5UD7reUTrJiMtg6k=;
        b=mqAecmdfJtA0qCZk8yIIe4uo40IiwYIraz+RzxxSAjeOjL9THEJljoVM6KxOOTlJxL
         DfRA2uteIoGdfbt74i2a0ATMJkdYd6bnuMSrcH0OxSq0lddyyqRWsweqaqjvNjBsNBfv
         lCU54VhRcgKlbXfpESjctE7RZGOcM+tLEsqgu5tuWU30HpSslYoJMtD970vvBLEqGID+
         bCz8hpUVFjfOR3rR5wl2ol4/2au5b0dmEHA7RCgzYkJSYj1PNKzjwfh/MA+78yI0hHUZ
         I2mBRrWlAVoA7Lj7ZKubM6jDRZb1xbGjqNqA1mRSOrbTHWiuWHM5XiD8DduBaUNV5+Jy
         cQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374036; x=1736978836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/iXcgdxDm1mzjOKK5nUQi77bzCX5UD7reUTrJiMtg6k=;
        b=C835i0eF4JrdtbghaQ9rM9INc3bRvVrwz57G7avkMLuDHCWBIQSS1jJyZyN47tN3OA
         qbSbj0ArPZpLoppirAIYPixgrCUNZgTo/++nxs/mUrgC8ElHAPTugvh/Nlj+JVlRZqpF
         BLK8MQ6qoSCZPtIeCUsYX//8NoSYgtfawfGEY9qxrLIEUgHiCkABKMV0xSgHsquYh5UD
         iLrloonnpyWMIFSAIkXLoJtcrKxMJEjU7Qvab+dHzrwlH6TC8/fiaB3CteX4uQJn4+ot
         gstPv2mHAA6e45FaOpOJIfSCwfFAd/c632F2PHYPdSyOxk+XnQKC44XCVu1WMErX4oP0
         qR8A==
X-Gm-Message-State: AOJu0Yy55VVF0VeJLqKJTTb5gbnjt9K2M/omwAyuUZCamwHpf2OLLeKo
	jp75PkiZmGpJ3ADFTedl3QyTQSRdcvPUHP0Cb8nosWmrJFKnticZVGm72Jbl51iSKV+tPGdK8kO
	o
X-Gm-Gg: ASbGncuzhujKv4GixL0N7uju0ZqNjcJFgcWHa2JrZ9J3hfj/iJj6BQlN/2ezRkgHukq
	fuyO8gH14mFJ0wws8336PPUSlA6zNzgLxZyreHYow9Q+pmmYMF0vabFtVIyddUuheqqkHfSnCZG
	BKyf6GMVTFpS1v+/CGw8pU+XDXiQhpSpXxX8oAkr6rg52yIEOYebOtb3x7GJUTcJP4KkH1zxPt6
	y5GO4vARjqu+uHXAnMhxjk8/hcBwST8c81x46IJbg==
X-Google-Smtp-Source: AGHT+IEhULlhi05aHg7h595uBywuyU3yAhGRtdIPLo8jQjGgQZgTPBEXackKna6YQgxV88TWSVehMg==
X-Received: by 2002:a17:902:ea08:b0:216:3876:2cff with SMTP id d9443c01a7336-21a83fe4cb5mr58816885ad.54.1736374035821;
        Wed, 08 Jan 2025 14:07:15 -0800 (PST)
Received: from localhost ([2a03:2880:ff:10::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842aba72f44sm33318215a12.15.2025.01.08.14.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:15 -0800 (PST)
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
Subject: [PATCH net-next v10 10/22] net: prepare for non devmem TCP memory providers
Date: Wed,  8 Jan 2025 14:06:31 -0800
Message-ID: <20250108220644.3528845-11-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
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
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c | 5 +++++
 net/core/devmem.h | 7 +++++++
 net/ipv4/tcp.c    | 5 +++++
 3 files changed, 17 insertions(+)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 6f46286d45a9..8fcb0c7b63be 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -29,6 +29,11 @@ static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
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
index 8e999fe2ae67..7fc158d52729 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -115,6 +115,8 @@ struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
 void net_devmem_free_dmabuf(struct net_iov *ppiov);
 
+bool net_is_devmem_iov(struct net_iov *niov);
+
 #else
 struct net_devmem_dmabuf_binding;
 
@@ -163,6 +165,11 @@ static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 {
 	return 0;
 }
+
+static inline bool net_is_devmem_iov(struct net_iov *niov)
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


