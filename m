Return-Path: <io-uring+bounces-4156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64EC39B565C
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88EEB1C21A7D
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C67C20B1FC;
	Tue, 29 Oct 2024 23:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="vnsc3I9A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975C220ADFC
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 23:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243162; cv=none; b=TCbT9DUhLoUrZFuzzzDJfrd4Gb/GCJLW+SraB90nI4PrVQnuviR3flIZGINHDPxZo2s2oDy7BHquwO2DfylVKY0a6uXLwxZkVgqcUVt6rO/VL8mhDdslGVZrzZDuvXt+a/MhtXt4a7+eg+s2khAHjjI0sA0PPg6Bmqi+oynsmUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243162; c=relaxed/simple;
	bh=GmYXYqS56Q71ym4lYvVibSD//+mv9JJ8nnPgR9ssbiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYSdBu7J3Dpzv4nRP8uCgS4wJvCuVcSXIYCgrBgQdwBldLfDQjg6rvys4eCOGXP9NXeOz8kATmWUwy/A0EbdgR6OejFZaMftDMa4vpfvHPn7DA/c371ZnZ2vmTqaB3jQ3fX5GXaqU/69rqIP1v2fuvnqnccgsVJAJr0oZA52gR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=vnsc3I9A; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20cdda5cfb6so58565355ad.3
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 16:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1730243160; x=1730847960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2iyOiGEHYMsmcUpYi5USfAzSVTmDt+usnXuma/ITEc=;
        b=vnsc3I9AG5jfpAZok4e+XtLe0P9WMvMVT25fhSrrEpwXrU/eGUDmO+ra49jPXgIaZk
         3WMBswP0m6Mz9G4yvHk4i/gFHnyDMXSI9inJwJhiwda9a1ywtrlr56IqM4YV33ozKw/+
         Ds+RI9ClbnWZWKd4Q0DPUvlo+fpi174uLgz4CXZvZHuFU4+vQRusSroF+jOoAU8lOMWT
         lZLQdvZWI5Tv/J6ImCrU3S7dusIMsdJfII23YG993uynkFpkBXkez7IayjzJe942//FT
         T0rc06GNscojyzuAdB16qro3FPGUZ18OdUkYw9gPL1tcRNm1QUiRQxy3ytY0Fq3+cHvF
         YT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243160; x=1730847960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2iyOiGEHYMsmcUpYi5USfAzSVTmDt+usnXuma/ITEc=;
        b=SX2+dQag56scRk8zRq4ZEMBB9cq8/HrESfiQKh8Dhx2U2XQDBnsplEeTzIKM1ij5D1
         3M6C97S1PGqrHISKA1eiI3k8IMGt76j3JVsfPZAabEPWbO4ASzzVwq3GKVh7VtEp7+Xc
         AJy9oV7Dt7Tc1zzlt7N1xQDf/Aaov/Gp9vu7Llrsx8c6ypqhVJk4AYhXhy+TDy8LmjCw
         b0ysYa6SK1+eOJbRivVl+f3CbZpSuSRXfQ8KFhrW7VzamsS6DUgHQFMBHpGQWo+ycszi
         ypGKGGfwHKwhSv3+faXE+AFp8ZoGmcouGmKbPOCim5HcNFRdO5ccFqjTfiAg/B90oyXo
         1fJA==
X-Gm-Message-State: AOJu0YzwAv13HiGgBko+pO9o9QaKnOdBZYP65LiVNCLqlcXolMtMxYs9
	vXCXkPPTVs1CsLYwf2zSsfeZmJgTB41kc1bbvwT2jBvSKD8DMDWogRXC95e1b3SM3ESzI4ykpxl
	2HAA=
X-Google-Smtp-Source: AGHT+IHDm6noPY7LAq3LWwnwGGYQ/ZILlVwcG0oAdrU6k7o1zlbTW2pXJjJfQdOwZ2tJVV81zo763w==
X-Received: by 2002:a17:902:da86:b0:20b:8109:2c90 with SMTP id d9443c01a7336-210c6d6b2b2mr163255855ad.61.1730243159525;
        Tue, 29 Oct 2024 16:05:59 -0700 (PDT)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc012ed2sm70503285ad.146.2024.10.29.16.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 16:05:58 -0700 (PDT)
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
Subject: [PATCH v7 01/15] net: prefix devmem specific helpers
Date: Tue, 29 Oct 2024 16:05:04 -0700
Message-ID: <20241029230521.2385749-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029230521.2385749-1-dw@davidwei.uk>
References: <20241029230521.2385749-1-dw@davidwei.uk>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c |  2 +-
 net/core/devmem.h | 14 +++++++-------
 net/ipv4/tcp.c    |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 11b91c12ee11..858982858f81 100644
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
index 82cc4a5633ce..e928efc22f80 100644
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


