Return-Path: <io-uring+bounces-5933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E51C5A14543
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 997D216B4C5
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6FEA244F85;
	Thu, 16 Jan 2025 23:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="1BvuGejL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40332232438
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069440; cv=none; b=mkRYrJuVoudDWncEdAL1oBwUaxlHhtYqyoXQxc4gXAkArlnHKX+Bk9hOSORARxiVlOAA5Dh3ZuZ/92LibzsRSNLpLH/nXPXjamtRSPZVa1U6tCzjGT6TD+Mtgz0vcra58lQPvLcGSG4EyqVz0tVBrVU0CTxJcw40Dl3U9eIh2mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069440; c=relaxed/simple;
	bh=Bd0rHranX1tldtf5eS5ic1T+HB/zykxgLBff110E+Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njsGn50veCbJQsaqfLdinvsvyBJtmNEzDOKQEdyZDt7k0fwEmKF6ZTKc+FJnOosxirMf6nQWIBEpYY7j3pNfRr37CsSvb42ia235qQyRq3rVQp8y8H5RwgQLzHPqTINJFsETTL8eR2n0BDGY9uRieNu8xysRwSd4acBZLtHzggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=1BvuGejL; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-216426b0865so26441765ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069438; x=1737674238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iXcgdxDm1mzjOKK5nUQi77bzCX5UD7reUTrJiMtg6k=;
        b=1BvuGejLUKIaFsJY01YRJJpxfShA9DDGu98LWb3kXEhtlS4OpKgwwH/gmRC3etK+WD
         aov8vpvXkLt/Vo0ClzCljk/s1O3FJZ7lYE1oCC73SahqRniljbVsdnrY35BI05AYn22P
         6Ou6rzU4AzXAuG11Aw/ei+8eZCgIwugJaJcGSVY4c/4vZLYi8Ymh0rND5t2jatI6j3MV
         ztFP3neUioXHNwAQxfcZTFLI4FAOC+ZFhl2BgPmO/k2GyXENnLLWgwEFpTHZ8Sv6n13v
         AMhLJzJFRr66wIGW0U46z2sp7WKrEPuqXqxBI28nSgGHKVakiE534QUqfMR0rCjxCu6z
         YuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069438; x=1737674238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/iXcgdxDm1mzjOKK5nUQi77bzCX5UD7reUTrJiMtg6k=;
        b=c9dHpEhmuK2BACek/5pLNm84D84abiXJpqzM42juAVsc3W13/zcWeLBfCbS6zdBu/X
         ZD8l0ZHPoFnjEcTArkHpd6YwkLxBcA4KEUKYoWZHLBkmNAiUcdAntkjFeQ6NhaLvB4DL
         edTzDKCvRgq1apm/yyjafX3eNzPyP2jBDslN0SY9vgyHZoGjDrzXzgBP5O6kcZRlC59V
         NNF+6BUctBjRPw1Wg6s6mI/dCA7vnVGVqMcrneFsiitSZWlDtHYyJ1yqzlusAZiOwMWR
         ok7ipsCtQLZP/0ZGRsbdrgFK+ETuyc8/jX5Kk1KDmE8wfvwtCXKKoDjSr9NqWZlI6PfI
         zmhQ==
X-Gm-Message-State: AOJu0YwRJ9Brp15OB5vALVTSoDRAfqWAPq0QbI53iQi6zpxc6BfT58F0
	XTftb4239sCXRlfp4lbX0/rVaU4nj75LkpnKm4FbZqowCouAbI/iTOfN7e+QY4nTEOxa+H9XRw/
	Q
X-Gm-Gg: ASbGncvhIHA7yePSLWb2OT3uIqgtC8KMXPVaTImKM6xcOv9q2Z8CiXD0gtKUs/bO2ym
	1JtcvGT0ppne5N9q8kLphwEQ5N94D2Su/c1bxaCi3GMYGHRH4fVWbCzMvQSOaHOaQcRZGP8qaVk
	8xl0oXN5pdtBuFvSvWzEZrVKP6YXZsTHg2Z3cBHbW5UhtZN8JAxy1j5Mm7Gc3uzD/QUBHo8qwxd
	lIeMWjHNI7Qb8NYQkwxHOpX6JhbKygDorMiM9c16g6QCvVhL2QQDfE=
X-Google-Smtp-Source: AGHT+IEUoQ3cQyeHfrq22BsAqcBQmEnXUFvqOsKhuiuJqY8cqjIMnKVKwPNr5PaVO+MY+927WWp7UQ==
X-Received: by 2002:a05:6a00:1f11:b0:71e:2a0:b0b8 with SMTP id d2e1a72fcca58-72daf92ac24mr972238b3a.1.1737069437894;
        Thu, 16 Jan 2025 15:17:17 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab9c8e5asm525688b3a.120.2025.01.16.15.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:17 -0800 (PST)
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
Subject: [PATCH net-next v11 08/21] net: prepare for non devmem TCP memory providers
Date: Thu, 16 Jan 2025 15:16:50 -0800
Message-ID: <20250116231704.2402455-9-dw@davidwei.uk>
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


