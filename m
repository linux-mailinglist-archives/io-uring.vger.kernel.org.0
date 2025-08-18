Return-Path: <io-uring+bounces-9023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3406B2A812
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 15:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 305C97AD0B5
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7674F322DAE;
	Mon, 18 Aug 2025 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCGCLtm2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05D5322A24;
	Mon, 18 Aug 2025 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525409; cv=none; b=f3EOLO955xrTr4GmhgCccFySN1stlQrPkvCOq15qcCSKzCS8+6dTGvviTSxE2tfhqtbO9R7iqaip0ANRa4EQVHh6rG7OlGRvFbPZDeaEVHyrYGNLdkYHyTY3Cy3Tv3J/UPdmqipzEcasR1lsCIovO5CnhqKNSAbJXj1W2mzIDHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525409; c=relaxed/simple;
	bh=3GMjb+lbBpFhbrGVSn65GBcvohAzWPx6gsl/4V25jU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsMx9UE7Jk33MIcHSmu0WLCzyXMKRAYy7e2Le4lKlRBur6PFXmhhWZw9pP18JeDoirtdpn9ARAefqvQ2ZRSY2tb95obZTzyaFuKDWvBBbH4589Edn8mOs0fJnm1fjuHfz/bqdrdr3Rw+OLDVU1IocnsJ6L0l8Z3vk+OtcxBVQgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCGCLtm2; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b9df0bffc3so2892966f8f.1;
        Mon, 18 Aug 2025 06:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525405; x=1756130205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+t66GhzgS8tUB6DAwObgo1BEyoN8jrBytfijH3iRZiA=;
        b=WCGCLtm2wWZtNPZUOCkRPch6AhldoeB3oVnVz7Dm5aEBv9zQ+evYqd5f3VXGkE+JhP
         M7ys6aDFqkOe9XYZrxuYGkvLlcy3/8ac2uXeRbV/j6OnhSgsku9pfqWETO9IeKhwpNgu
         pbtABu5OC0B/IiawCdtCbinXlGmSNz0/RhuICTplOwA5KqqYf76s8tfDDeAgubPOU2f9
         02L9wZpP86gM5q3amXfNEHa0WiK1KhE2DB87rLpZPEftqjWPznRjfF+wgirj+Pj4WAEI
         G1MZxkeihtA53qj6uAreaeg0wpWzJ2JnfShB1icy5HCyqQI104XPCSERLYOAzydWSnOZ
         4Dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525405; x=1756130205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+t66GhzgS8tUB6DAwObgo1BEyoN8jrBytfijH3iRZiA=;
        b=shVFC3IGLCwJM/Z7ITAPa82FBns4Gi8JYnl2PQtAEsqawOUrrWAZ/Q0aXO7m2Yxc6f
         wCWslD1RW5+QMGwX4quZRM0AtQ9meriYvWZW+eO8FReGCo/Dwar+SyUmyIVo77zI5T+w
         491CyX4uv7uOBZkNeyS4QC8HYDXN1CRz8q5LkIG+iobM8mIyuDUvdbSieTVFVk9zhiMz
         QN+BBo+UgocQ3daKXcEdry1nztt0fTMRr6fRSr/44XHAsZJgXfqIl5/rgTDPUB4Z64JK
         lmwhlgxvojyIm9xuQFZSQoOn4KejsOoIw3l4xamzLEnBhKsXw3XC6vLUG/fkPpzdZyBR
         OQcw==
X-Forwarded-Encrypted: i=1; AJvYcCUwxVgpDLmdgL6lH0gP1wZWZPtWUSR8N1N2jBAB/1y758NnunEx876x1jPQek3x3o7bjawprmeu@vger.kernel.org, AJvYcCVfHqNOzo5KZyp0GlHzO0cmeSCsM+SxSrrhhQ+950qh/X5bz3LTRtLhaYLPJPt0rDyrcUCz88PGEKAwb4HQ@vger.kernel.org, AJvYcCW+lcXqaL/uD+ROZRa9RhWSryxJeIUIjHAdeVlp/IKvBrYLAdXXFpALSodFMAVSNlTXq9QufHzv2g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8c2DucWs5tWmHENNOcOxVcDU7OUkC4whzJ428dCETcJGYKYlb
	xGxwUy5EjBf2p1rt2EX5RsSAEP+R8w7OzVr9mJS9+/qMSdhYU9TYshrf
X-Gm-Gg: ASbGncsfB8l6RS4qccfO0JzpDx3WnY4YeZPCtV+d+FRVfasvnz7HFVVD1ELHied+pwq
	LlO1I8xcpjEtZbgDSTiUK00kowYLfYQvUNqX0tWQpcQNaAWnToFDZZ3RxEvDnv8rMWtIAcf2mMg
	8MVwgQbvWOvmKmliqvdnsOi1ZXM48NexsiCyE4oLnl7OIetIx5kjo52vsT4Fcqtm33VFlzF6CWW
	Ig5ECLpsRlI2abCpZVZ/uFJ42r7UxN2YZTs41SqAtdvXq9fYJUqnVP5IAoG7ifItidoLGaJSar0
	87/+/jhU+4Dl+Jw6gCQ73al3LMtQsQgFCRfIQnlpm9Kt6WK1MyAIwTv9JVCGjYdP6XH127mkIS2
	QKp7+XB6LLRuuNK1v5fJ8ZsBOg64T+PeKPA==
X-Google-Smtp-Source: AGHT+IFWS+50cUTPIMdIhGYfua7eZN7PcLQyrWYfXTyoFLwVW+vWPYvtq8zqWpxs5aIj1ZQPnK/Cug==
X-Received: by 2002:a05:6000:1a8e:b0:3b9:7c1f:86b1 with SMTP id ffacd0b85a97d-3bb68548d36mr9603703f8f.37.1755525404694;
        Mon, 18 Aug 2025 06:56:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 08/23] eth: bnxt: set page pool page order based on rx_page_size
Date: Mon, 18 Aug 2025 14:57:24 +0100
Message-ID: <51c3dd0a3a8aab6175e2915d94f7f7aece8e74d3.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

If user decides to increase the buffer size for agg ring
we need to ask the page pool for higher order pages.
There is no need to use larger pages for header frags,
if user increase the size of agg ring buffers switch
to separate header page automatically.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[pavel: calculate adjust max_len]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5307b33ea1c7..d3d9b72ef313 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3824,11 +3824,13 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	pp.pool_size = bp->rx_agg_ring_size / agg_size_fac;
 	if (BNXT_RX_PAGE_MODE(bp))
 		pp.pool_size += bp->rx_ring_size / rx_size_fac;
+
+	pp.order = get_order(bp->rx_page_size);
 	pp.nid = numa_node;
 	pp.netdev = bp->dev;
 	pp.dev = &bp->pdev->dev;
 	pp.dma_dir = bp->rx_dir;
-	pp.max_len = PAGE_SIZE;
+	pp.max_len = PAGE_SIZE << pp.order;
 	pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |
 		   PP_FLAG_ALLOW_UNREADABLE_NETMEM;
 	pp.queue_idx = rxr->bnapi->index;
@@ -3839,7 +3841,10 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	rxr->page_pool = pool;
 
 	rxr->need_head_pool = page_pool_is_unreadable(pool);
+	rxr->need_head_pool |= !!pp.order;
 	if (bnxt_separate_head_pool(rxr)) {
+		pp.order = 0;
+		pp.max_len = PAGE_SIZE;
 		pp.pool_size = min(bp->rx_ring_size / rx_size_fac, 1024);
 		pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 		pool = page_pool_create(&pp);
-- 
2.49.0


