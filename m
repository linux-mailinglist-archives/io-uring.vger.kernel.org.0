Return-Path: <io-uring+bounces-8997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF90B29586
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE4E31899EBD
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900F42253E0;
	Sun, 17 Aug 2025 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyi4QX+r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE18421767C
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470570; cv=none; b=U09McsmbFsbBlEugMztFzU7z6rYAgxz0sUoUgeJnMXNRLwFjiXuEVQoIbVr4XTS+mUs/u8MUjKujbgD8HcSaIr/iPhGmuw3ss3DsF1Wu3koFv1qtyj1Nb70jfaVEv1RcuitSJHTQiA0tt0v8UIiUVIM5QzbFxlX8rb2FprgxqFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470570; c=relaxed/simple;
	bh=PZ5xg8U/SXFg0ZHIKYOaL0OPEtyMfPyWWFS2goDajaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axGiyfXsqHev8wE7Cnb1EUHRGVQ5ytokCkYdOeWLhNJT/gOxzGCZhQK0MkTVuwghhOSic7KxG1Ho4o/C9k9EaFdji8VflOW0aHaqDzItSI+iE1MdW4zvznLDSnM6RjrTMSGPWveSNEBTcyPFOowdTX2QyI4RFv/HHjw1HKRiKy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyi4QX+r; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45a1b00a65fso16984915e9.0
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470566; x=1756075366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ka3PlkjDKcEmQrAR1wjy8kwh14rx6MQ/wZHRrXnZwoE=;
        b=gyi4QX+rc9pbYz6INfMPuliHPBNHhsylSP2b5pYJOwPux7s/cshUvLsKrPiR5zfPYy
         zF9zYrIIvc0NvoHNI33TyA6q/hdtum50jJyz6yYLSLBst/SnXkAt6eVTXWEKXVt7sSms
         SOz/Y0f0pdhA93AZMyRdnsqsz0XRXLE/oeLT51GPY3QZ4/Bn1GTjA0hIdk1bU55JXj0c
         6Pq6eAvK6OxIZ5qpQXaKAZpx63tKoNvc6yIQvkr9sxzPXwviQAsr1ehXZQmjDi20/TUP
         qU+suO7CfubukS1ZQ7bjnCejpLu+qV5DhVNBBczx+jo0TlXZ6Eji1MPdFdNZeUg/ZQ5L
         M03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470566; x=1756075366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ka3PlkjDKcEmQrAR1wjy8kwh14rx6MQ/wZHRrXnZwoE=;
        b=JAvwMV00LPTXOKpO8rCfF/yXISte7uQJev3H1l9txlBLeY6WsxXjiO7EbEEV1pgquT
         AF+fMmdGUuo7g/73ScM++NTgO3egxDhAHBFc5H+gistiR3T/UW/oZBSbPgYpg7rz7D1C
         7cLOG8wVXnVxu0N9iBz5T+ptR5jJOGYGhU2xNnwFAaXztFddIqvUn+29QOAnghwDm4TA
         ZgpU7CFgNEfKc4fq0qk7r0z2A6TEL8ouwNfCrZYpncfIEtFqn1WoozYdANgYkTFH5m1D
         RaO3JVJEldccvHid2thB3Y1Do7ZPz5GQLT/3QrHq+muluGFsGUaflVHYdJl6VvQAwusM
         qDww==
X-Gm-Message-State: AOJu0Ywi5g+bHi6Mh9Zc5TGp8DtsQRllHRvvk483wpKy8TAfcc/lQ1Gp
	pw6kCQREdQLbNtzVapzQtWr0p0PqLycKTRZC2kriuhTXQ2DUx/C41cQ4IdyyhQ==
X-Gm-Gg: ASbGnctJnMZhSVzjcJFdUkjkM8mPxVMvbCuEui+U/lxnhSbVauclYR3eClPusS5p8AI
	pVQcmj5FTOy87i/o8gpkfqPQCSrvw2wb6zv6TaBFbOheGSYZ/arb3jHDqsJrElCWQc7eYU4qLev
	oBvgUE9LCdg3TYgqI0HmDkfJ4jH+IgV5hjBbtOmb+TvdTBARTU3QgurHGFxvDTZaVfU3WTD5hI8
	i1thBHrws7EByf3k7jakHdZnBrqyJfGq6TU3tqSius4g84PcFQHZdaTFXAfCJoCyM7PPu7qNjU/
	VhEkkeh5zJIgH/QYr1sEiHjcKuCbn+9qxH7u2KAOn6P8T5EqYb42481KMJo2GGA5/U4VF/piGHA
	1AdPV1Z5SsZN4UVNdjz2W42tCWXtkx6E0xA==
X-Google-Smtp-Source: AGHT+IHVNezzDxIXOuSbbLmXKic/75cH1Y/gET0bCTiEbwnu9MUxbWATjSFMYi+qeBNstQsI6HLdBA==
X-Received: by 2002:a05:600c:46d0:b0:458:affe:a5c1 with SMTP id 5b1f17b1804b1-45a2340f7d9mr78170805e9.5.1755470565762;
        Sun, 17 Aug 2025 15:42:45 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 07/10] io_uring/zcrx: reduce netmem scope in refill
Date: Sun, 17 Aug 2025 23:43:33 +0100
Message-ID: <202f4926883fd3060824d40ee29c87f94ad26b2e.1755467432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467432.git.asml.silence@gmail.com>
References: <cover.1755467432.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reduce the scope of a local var netmem in io_zcrx_ring_refill.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 555d4d9ff479..44e6a0cb7916 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -735,7 +735,6 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 {
 	unsigned int mask = ifq->rq_entries - 1;
 	unsigned int entries;
-	netmem_ref netmem;
 
 	spin_lock_bh(&ifq->rq_lock);
 
@@ -751,6 +750,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		struct io_zcrx_area *area;
 		struct net_iov *niov;
 		unsigned niov_idx, area_idx;
+		netmem_ref netmem;
 
 		area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
 		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> PAGE_SHIFT;
-- 
2.49.0


