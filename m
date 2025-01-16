Return-Path: <io-uring+bounces-5926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8449DA14532
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4733188B7BA
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEA3236EAE;
	Thu, 16 Jan 2025 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="od2ha1vm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A51DDC00
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069433; cv=none; b=Ye/9Q4KOXNytNTX6/lUY93kAlTBvTXd3bZUVqozGgHRtIOI16aPP+4rrwky3AGQPaIlCJb0n99dyiwNXiNqnFcf0gr7dPSxJij5i8TPT3aZ4NaRcIKTcRHqqFPQAolQTxkEkc0gJC1FH9OgB29/Q2++VEo2zJjd7DOOEapWYz3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069433; c=relaxed/simple;
	bh=RN9FRieTmgxqv0c+YKrWG+l7gQJLp/gap7HunHQoqkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZhI7iEzc/T4Ql9r4vCuzw1RBvfHILQFLSC9P7eSdVx0bAhWTshqyH8+ZzodNLLcJl2mMgjVlrcO0jLI0cijRzkVp7UyFZdUk6cSzZMDy+9ZPM2qFnAzGxnPVtSOef2mdgu4apy13Sol3TZyXjA4j8XAdysJn6JYvL1/FN4yzxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=od2ha1vm; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-216728b1836so25925775ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069431; x=1737674231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4BJhQIF+q/BdwFZrWY61E+04UcDJKhF4LPhTAqO37Wg=;
        b=od2ha1vmCSnx2GPPc2VFpwBis9SehbZGYgEg6D85/YltIu0aibdL6cNBMudEYe26bu
         lSpXNQWqzWFRzYELuLvWX0CI4yECAoWWdFHisB5IJr6YAZfKfe4+poXBL/iGjjAjDFAr
         jxvdlxgnRKbNe8xaDmSecDKkf4TlPxD1cpQ7PFHC0maccd1URseX3xXKRY+8q4IsgsBs
         X9Q8WyqcVCRMwk1L36ewZ/IzGRYI5qeEsUapwjx97KwZukrAQZ719vy9v0lzkYodxiRz
         JFHO1paHwBENbRoqAHROPdYMf+a84V2+NFuQklf6jBZI6pOk0/Yz1bt79xNNfZBE+Go+
         B5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069431; x=1737674231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4BJhQIF+q/BdwFZrWY61E+04UcDJKhF4LPhTAqO37Wg=;
        b=h3HAY413lFwUE+1g1zQGd2SvWL737chAGz0R5I3ZX5yrofgNiSyGvJoFrW5Iqyx9Rx
         JT2AJbO5NaO/+05HYuX6U0ri5wPRIJsbKIC/V+65jiqg9HhxMc8AjRzZhC0g0v8+eiSp
         WARdD7TwhJVqp+QR+W10072G3cLn/4UNqKMXsf/iwVF52bkAJOcO3DgSPwP47be8LLUj
         B0zsN4RvKc/JSg0IXBBVvTa1mK75CF7cgoKvAtGV1093KJiLkIpE79miNAdasUjAGKbP
         0t3jFrfuiUoXpCrY4ZvgXidHPCEHJcR9IYXOIpQndt7hmxn2yqyHmsM4WIOdIARH3IPj
         mViw==
X-Gm-Message-State: AOJu0YxyIVhFdmKxeMYTzEkSH4BAKFhowzWvw19XVTlIrtZtZDkVpmI1
	5+r6a1kex6UE/jTQmgMcxh8r2MHcc4i+OtaQ3NJ+VyMSPP1f5p7cYU4YF72mG5JvolFlyifufvl
	4
X-Gm-Gg: ASbGnctpiYJSEg3wC5nr/SCEcGMYj2bfq2ep6KGhMQCtEWZNAWQF5aZTYCe/SegWNdK
	mgC9MZxR+icWXzY9DhuFXqAREqrC87aOap2Rd+waU5LBo8BVdJRM6EWLL/H+0bync0OMkwxEZob
	HXeM4Fu6R2/0r/wGGygwnvaiFy6axo1D/9+IJw51nDMP30gLMof5iqeGkjXhqki/yU/HHaNV6a1
	qQiP/lH3TgIdIO4S/cO1jBLUzaRxQ7YWnlcY2eRyA==
X-Google-Smtp-Source: AGHT+IE+7rz3+FtLlOzp302hQQdyqhKM3dH46xWgJ2OQJD08zD8IPa2x4VJMSn0MPslS5ttQnIdHyQ==
X-Received: by 2002:a17:903:244d:b0:215:b5c6:9ed3 with SMTP id d9443c01a7336-21c353e4d1emr10178125ad.12.1737069431391;
        Thu, 16 Jan 2025 15:17:11 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1c::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3ac461sm4986015ad.112.2025.01.16.15.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:11 -0800 (PST)
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
Subject: [PATCH net-next v11 01/21] net: page_pool: don't cast mp param to devmem
Date: Thu, 16 Jan 2025 15:16:43 -0800
Message-ID: <20250116231704.2402455-2-dw@davidwei.uk>
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

page_pool_check_memory_provider() is a generic path and shouldn't assume
anything about the actual type of the memory provider argument. It's
fine while devmem is the only provider, but cast away the devmem
specific binding types to avoid confusion.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/page_pool_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 48335766c1bf..8d31c71bea1a 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -353,7 +353,7 @@ void page_pool_unlist(struct page_pool *pool)
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq)
 {
-	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
+	void *binding = rxq->mp_params.mp_priv;
 	struct page_pool *pool;
 	struct hlist_node *n;
 
-- 
2.43.5


