Return-Path: <io-uring+bounces-5985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7566A153DC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 654FC1637FE
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6ED1A00F2;
	Fri, 17 Jan 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRRUKEY6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9F819F419;
	Fri, 17 Jan 2025 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130289; cv=none; b=YuMGvU/350i9fM8V0OCC/8YGH915Mn55aInybZ5TcUjvd9nysgw4NDYkfIa0R0677Gp4BCG33Tu+1A3nXnt43XNn6x+ICvG0UO0nw+OC/+swiWv/+2CWyeCS5sXPeROShzAQYr1KoZ9fkUN6UWonKxvYNjrMGhC/Enr3aNoFcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130289; c=relaxed/simple;
	bh=ly53jWrQZYf+pNZW151TipXpqUbbhUTcHCDgsjtMd+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OESrSKnuaTK47pLrq3mszhfo9gopM0Fyq226M34UaT5QpikNtrZUIPVEz0LlG47Us6uHZeFu7lx0VWGXLMFD+AeqtOzrxrwkYKCIh0jE1bZYABR9iXZHFYhlJaAmbuDJ83ciLf3Lonn8DPt7GsvoIwpZdqdbEml5fuZpnETYXZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRRUKEY6; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so3644206a12.1;
        Fri, 17 Jan 2025 08:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130285; x=1737735085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pV0TBsETouNvQcQA3TQi1mvH/PDQhNV5J//Yfsg0S3k=;
        b=DRRUKEY6YW9pELU7optdz6GYfdMzXt+s71jEZ+0GR0u3tiCCqK0yFzVqBsccr/d1hy
         gDajFUMYywgPmp+HO+DbwVoJP7JIRuHTeQjFk8meaibHBdaJUQqIG43RVCq6a8/2WE5l
         R+2eHNIiI1V9AYIaakmXgcieHQqgZcGe80gmgswNWvs2T/WN2M8fWpPxLqmekqsQ08tn
         5xuzzbYnNSJvf0CFKeRIyqR6aptUG5isgQSPmyCfdR4Au3gABeQAq+LUXRx5TdIJHDLR
         +fz93n3M9pwl5n3KpchtyI/oT1M2jWMEw/7pY8CosbqsiYP0vXVJH0hM0Xz3UaXd6ak6
         uvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130285; x=1737735085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pV0TBsETouNvQcQA3TQi1mvH/PDQhNV5J//Yfsg0S3k=;
        b=PMNBskZzJhgprKdyp6yVPvZ9oEEoykNYfPqcZI98v2R4a8PXq7lVqZ1lKrZA5riHhc
         n9bgoacfGEHI1DrBT1nPGMXP0Um0ONIFijOChPMedkvF3MqJnR3RxkYruHWI+EQbvwOK
         7BEAcOCCuCdoy7PehxX3cLW7YznVQamcHKvL/kC7mw9exOTLDzW019SIbvUTwHJjlUDR
         2oRhCy2MaUSAOlpOUFSyXAgLRZgUm2q3HpUz+9qe9NzqMKqam6/Z14wneRoIjRWE8rGM
         zSGkvyUfCtwA5G6dj7MJRiq/SSD01yrc3qatZZUCpxfNmOhyN8nj4eTLHENdloqtqXFP
         iHdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRPiQOmgUd990FyeTVNp9gLIIoPK6dEuxCh2ddzeqRmAOUT01rsfheUalRyg7Vh1GrWHaIbck=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzez8VflzOY0XOSiseXU07qQ24S7xBKcErgKq8rAoENVjiBmWRT
	LoKGB9jiyOxObLbyudqP1hG9JasDvAUO74WLvFmIz2eWrGwlBObyXYWSfw==
X-Gm-Gg: ASbGncvzYQyu8fKq+vPMZQE/eJnfAnHKnuoconjJih6NkaoyEjVa/2hmpZG2gj/gbmW
	eO5XU8VuKJUGMKCzGd2WCckcnfy6grtyPuJZrTcaOvVFEUez9FfDj4MR5b4Q3U3xPw7FiwzmKpu
	CQoONukMlw8unZc/i4dYw33Brz1fOODxh1La+mPDge97fWRuwVTiJckAGJEOfGvxnVbgKf4lZKz
	CoF+FEo5JlUe15Pp/ZBc9baeurfHlKKrZLC5WCk
X-Google-Smtp-Source: AGHT+IF5yfGP9qJlrYDhBOYPkvANvVEe8Iv7JhW93RvGDz1ZlGF4qcC+677vPM1G2+sjnxiIjPwhuA==
X-Received: by 2002:a17:907:2d2a:b0:ab3:ed0:cda with SMTP id a640c23a62f3a-ab38b191674mr331868266b.9.1737130284777;
        Fri, 17 Jan 2025 08:11:24 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:24 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 08/10] net: prepare for non devmem TCP memory providers
Date: Fri, 17 Jan 2025 16:11:46 +0000
Message-ID: <97d1697b6c6535b24f2184a9662574811b36731f.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a good bunch of places in generic paths assuming that the only
page pool memory provider is devmem TCP. As we want to reuse the net_iov
and provider infrastructure, we need to patch it up and explicitly check
the provider type when we branch into devmem TCP code.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/devmem.c | 5 +++++
 net/core/devmem.h | 7 +++++++
 net/ipv4/tcp.c    | 5 +++++
 3 files changed, 17 insertions(+)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index ebb77d2f30f4..2f46f271b80e 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -30,6 +30,11 @@ static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
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
2.47.1


