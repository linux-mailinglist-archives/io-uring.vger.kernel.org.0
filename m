Return-Path: <io-uring+bounces-6870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E81A4A6C8
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AFA47A8FEA
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 23:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94DC91DFD8D;
	Fri, 28 Feb 2025 23:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="J3W2W/RC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37E11DF74E
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 23:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740787195; cv=none; b=V27zwpFLmhY/VJmEGLtaFSBymfUuL4krYjULsnbXXgSDkT5EWBO4N7cQZvcolxjuzOwjyeMNGY94FDAO4KrcUofYXSia+34SRhhDQtbAO3f8XanHWq2lsnpflKsE/rG87FccK8SnE8AEH7w1n3ws8+UBJphKKzeWcBaVuhNbj3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740787195; c=relaxed/simple;
	bh=AZLZzMJ0MTVnkoUKBeMQDCZ4HtU6js9qp5I5DPRcObM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7+/b5TOi8vBA11luAkQRMl8Tu6WozxYcoypU57MiDYuACQ/Wrhwvm2QmR9/VwIPKo/Sg/ZxMvsB7YGJ0IfJ5FEjFp9EmqYo+QXAB1xqmEAi9ga3EGv2T7WBi9kw1b9Px9Pn/+8bi7/bjZ5gasiCBdMjPKXUSiXqXaU8LaoPKPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=J3W2W/RC; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-2fea4cc08edso652103a91.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 15:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740787193; x=1741391993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9sAFpF9FEO4L/QlXHSxh/NHTnXAGTF5O5LuvRrb5CMs=;
        b=J3W2W/RCsKnCTerIHfTQUZMH0DW4rltDuBnLy/YR4nPXLUje8GCqwID7QUMo50w86p
         kMXFRHT84eIoCHRfgyp9FcFoToATXAyt9pUu/GrncZCSPhSLwwwXtIYFMqQZzE5z4fm2
         JEfnMM7jQBhU3MVIdwHJW5CtepXVtlfu+ePI1y+K1iKSMW6kYPcwMohMnoqw4IAKD4Cf
         h4LQMnhmul7qzOF7U9ON2KgVJSo7KvRe7WF3KH/iAWgF9zKtWPZjCLwReumIHw4YuPuh
         3KwtMMUMkU5/Ydx58oy/wfWe81r+eY0m5QHQ+3nGKlET4cAJHo/SoSX8+7mhEMjUkOKm
         +2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740787193; x=1741391993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9sAFpF9FEO4L/QlXHSxh/NHTnXAGTF5O5LuvRrb5CMs=;
        b=hnU+rXqSIuDQfm/KQPSEF3OXAhfCY8TGxoBxbq88wG9uXfDkbkISz8CxM2uRk91NjH
         MRbURhT5SvT/ytx+S9CSSdvX/llH1l4RXRd3W3EkiGp+H3JWMfKaL1mGDVnu3TEOOj8j
         YJ4iBBXCgZr0V0vfIYTjgCOgpc2jsh4GlKzOHJSTyx2XAijuRMq8LSczkgftq/6Y27Kc
         Z+3mt0Kwm0m3FkDY/eAWUd4REmkaVEvVNkrPLU7XIyaP2HU2fVLnK8DAIbOMqrS2BxZK
         5RlMX/ibho3kGBxrhKNYwzP3WOcxX1/vPpnUOPuyYCmn7IP0MMFhScyWoKLKcuJlWNNQ
         RBEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuad0ozkwnoZTvx6X6RW+DFXgpIOe0TvDnnQWqfRGsgD0RvnC7h0tf4c9xhAD6MU4CtXwGNe9eiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzV3Oc2VEt+QIzz8A9logUVmiXYpLMbH0Msg5JrFjTLHgKE2uc/
	1Uej59EYvKN2WhyHjFD+U0fvm+pPZOIXnFoPQErD7FZdWeWe2acXOV7axb392ETZD3oOtOdk4C1
	HA6c0PrGWPWos7lPRwWMlpamzSsYMqroe
X-Gm-Gg: ASbGncsv+iFguUl5fWGudvZR1Z2ddqI0MyT4f+yX4y8qrTsp5mGzGFsuAkNk6wlS2bJ
	VjXll2s/zL+k9Tof/t8xn/xiAZV+lBT203D+DbV55fjJ30/8wxLckUmDNIqj6HhZXzn0/4uwOaR
	KfvhV49xRfomZFHAQsuc0bcBBl31s2OB9ANQCu1cSneVIpdos88c9f3ZjjpYdoi/9s+/99gr2IX
	PA3kF/jVgq7E2D8sJ+dmAbgSmeG85FAsJavFNozVE/7AdzQqpzrC2U756XteLjbPcgNMWOekplG
	Lhn1kCMLQosSdRp+0LH0NiqpIzUE4qZXqSIrfD+UYG+Gmz7C
X-Google-Smtp-Source: AGHT+IEW1Xd6SYijTL09braAm7HsEL2GN7+54qihyn7XQtQRzFpzh2VrVsxovv2bmR4SodKogme58OERoUcL
X-Received: by 2002:a17:903:19e6:b0:220:e1e6:446e with SMTP id d9443c01a7336-22368fb8e9fmr30785535ad.1.1740787193090;
        Fri, 28 Feb 2025 15:59:53 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-223501d35casm2145365ad.17.2025.02.28.15.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 15:59:53 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8536734028F;
	Fri, 28 Feb 2025 16:59:52 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 78DA8E41A00; Fri, 28 Feb 2025 16:59:22 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] io_uring/rsrc: free io_rsrc_node using kfree()
Date: Fri, 28 Feb 2025 16:59:11 -0700
Message-ID: <20250228235916.670437-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250228235916.670437-1-csander@purestorage.com>
References: <20250228235916.670437-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_rsrc_node_alloc() calls io_cache_alloc(), which uses kmalloc() to
allocate the node. So it can be freed with kfree() instead of kvfree().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d941256f0d8c..748a09cfaeaa 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -488,11 +488,11 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 static void io_free_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	if (!io_alloc_cache_put(&ctx->node_cache, node))
-		kvfree(node);
+		kfree(node);
 }
 
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	if (node->tag)
-- 
2.45.2


