Return-Path: <io-uring+bounces-10716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BDDC77351
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 05:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 387524E4009
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 04:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2CC2BE646;
	Fri, 21 Nov 2025 04:01:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3477423F417;
	Fri, 21 Nov 2025 04:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763697670; cv=none; b=sWDQhNXB88wqkguUzgXkQm+1SYClI31O4ogr/3pqTRtnasbuYUP8tYNpXt6w93V1tDkeDcIfrz0NUwzGbvig5PY+Zc92JDGHZAen1ESvnoJUlQJESiVa2HObdAEqows3P92mT7T+HDjB6B5LYi/H/PEhW5aY5ey384nKVxQHySw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763697670; c=relaxed/simple;
	bh=R3w+Pxmy1NbEoyA0pE26djjrNB06U5hNWKTrXIFjXBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=AZsEkozHj2Mo8dw4YmJICSO6A9dX1IgCWDuCsdYR3ri+/EnJdxIcN4Z3yD/reDCCDewFDxm7AoMF1LR0vY3RFISkveKAd2+qQeFz6IEMDi+C7TbudNbmDLdeDMaJ9iS1MPsP72N3sJHiYoL6EBxmDhvND36VsH4hFclesOmzzX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-76-691fe3fa2e4d
From: Byungchul Park <byungchul@sk.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	hawk@kernel.org,
	andrew+netdev@lunn.ch,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	willy@infradead.org,
	toke@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	asml.silence@gmail.com,
	axboe@kernel.dk,
	ncardwell@google.com,
	kuniyu@google.com,
	dsahern@kernel.org,
	almasrymina@google.com,
	sdf@fomichev.me,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com,
	shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next 2/3] netmem, devmem, tcp: access pp fields through @desc in net_iov
Date: Fri, 21 Nov 2025 13:00:46 +0900
Message-Id: <20251121040047.71921-2-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251121040047.71921-1-byungchul@sk.com>
References: <20251121040047.71921-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRW0hTcRzH+29nZ2djw8NJ6rhMYWSBmGVp/QkRFcrTW1AvXUBHO7nRNtfm
	ZWbRpMQLpNZLzu1h68E5nU7mZRdK8pJpXlqZOs2ZztQoL6glXgrblN6+/L7f74cffDEm0YgI
	MKkim1YpRDIhykW4SzzTye3ZSOnpv3oC1m9qoHnayYJb1gUGNNS1AVjvq0Ch4cMTBP62bTNh
	o7uIAV3uBQB/VDWgcK7Hz4Zfa+YR+KrYwYT+il4ULhcNIdDTVs6CQ10WFDq002w47DagcMq6
	y4J91RYElky+RmCP8RDc6F8EcETnZkDTZDr81OVHoL6wHMCdzUBe/3aKnRxBtVjGGdRo1TOE
	8ra/Z1Cuah+bMtpzqObaaGp4MIey15WilH3tOZtyOdcZ1NPHyyi1OjeBUCvtIyg1YOxmU+v2
	iCshN7iJYlomzaVVp5IyuJJ3gR+U2hDN56IxVAtMvDLAwUg8nhxp3UHLALantb/Q4BnFT5Be
	7xYzqENxAbnqdLDLABdj4lYWaa5qBUHjIH6LHN+dQYIawaPIWe0ACHL4eAJZ+VGzj48k65ve
	7HE4+Dmy3a/bqxKBiLV0mhFkkrifTZqbtcz9QhjZUetFKgHfCA7UAUKqyJWLpLL4WEm+QqqJ
	vZ0lt4PAijUP/9x0gjXP1U6AY0DI4/dyIqUES5Srzpd3AhJjCkP5USnhUoIvFuXfp1VZ6aoc
	Ga3uBEcwRHiYf2YjT0zgmaJs+i5NK2nVf5eBcQRaoLvsUX5hKQ0CbP38Hd6o7VteU1zj1AOB
	pz8z1TFqI0pM+PHw4hnXC5+q0JbBuZRyzx9mXhoci+/zXVxJBup5CxrDn0/sFl+T7GY/GpaH
	t7oMPy8kvNTVfs+cSLMSachOqnmyQHRMspKUOBaz1aK3HHWcvc5pW2yI7RgfKhAiaokoLpqp
	Uov+AbuWMSnBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsXC5WfdrPvrsXymwe4HzBarf1RYLH+wg9Xi
	55rnTBZzVm1jtFh9t5/NYs75FhaLr+t/MVus29XKZLFz13NGi1cz1rJZPD32iN3i/rJnLBZ7
	2rczWzzqP8Fm8a71HIvF4bknWS0ubOtjtTh3eCWbxfaGB+wWl3fNYbO4t+Y/q8XJWStZLDru
	7GWxOLZAzOLb6TeMFldn7mKyWHgn3uLS4UcsFrMb+xgtfv8Aqp999B67g7zHlpU3mTyuzZjI
	4nFj3ykmj52z7rJ7LNhU6rF5hZbH5bOlHptWdbJ5bPo0id1j547PTB69ze/YPD4+vcXi8X7f
	VTaPxS8+MHmcWXCE3ePzJrkAgSgum5TUnMyy1CJ9uwSujONAhxQ08Fdcab3O1sC4kKeLkYND
	QsBEouELWxcjJwebgLrEjRs/mUFsEQEpiY87trN3MXJxMAusYZVYPmMrI0hCWCBG4ub/hywg
	NouAqsTjhjOMIHN4BUwlJlysAAlLCMhLrN5wAGwOp4CZxL5HM8FahYBK1nQ+YJrAyLWAkWEV
	o0hmXlluYmaOqV5xdkZlXmaFXnJ+7iZGYGQtq/0zcQfjl8vuhxgFOBiVeHhPcMpnCrEmlhVX
	5h5ilOBgVhLhVXWUyRTiTUmsrEotyo8vKs1JLT7EKM3BoiTO6xWemiAkkJ5YkpqdmlqQWgST
	ZeLglGpg1Pz+cZWWZO0ppof14eWv5oTK61TP2N6cYiKUWrx7Z/avBRz7PNQKmVaqZBZXa1x+
	f2KZ2+1V9zIO/5PpPcCosNPIZxJT7ny3OJVP3y4fa2LV6vtYfSlL1mZ573b3p6x9h71n7Xhi
	vmrKC+tASz2xy0c6r4m2WSdraZhF94jZBt2NcDN/mhSsxFKckWioxVxUnAgAthD0vqgCAAA=
X-CFilter-Loop: Reflected
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Convert all the legacy code directly accessing the pp fields in net_iov
to access them through @desc in net_iov.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/skbuff.h | 4 ++--
 net/core/devmem.c      | 6 +++---
 net/ipv4/tcp.c         | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ff90281ddf90..86737076101d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3778,8 +3778,8 @@ static inline dma_addr_t __skb_frag_dma_map(struct device *dev,
 					    enum dma_data_direction dir)
 {
 	if (skb_frag_is_net_iov(frag)) {
-		return netmem_to_net_iov(frag->netmem)->dma_addr + offset +
-		       frag->offset;
+		return netmem_to_net_iov(frag->netmem)->desc.dma_addr +
+		       offset + frag->offset;
 	}
 	return dma_map_page(dev, skb_frag_page(frag),
 			    skb_frag_off(frag) + offset, size, dir);
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 1d04754bc756..ec4217d6c0b4 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -97,9 +97,9 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 	index = offset / PAGE_SIZE;
 	niov = &owner->area.niovs[index];
 
-	niov->pp_magic = 0;
-	niov->pp = NULL;
-	atomic_long_set(&niov->pp_ref_count, 0);
+	niov->desc.pp_magic = 0;
+	niov->desc.pp = NULL;
+	atomic_long_set(&niov->desc.pp_ref_count, 0);
 
 	return niov;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dee578aad690..f035440c475a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2587,7 +2587,7 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 				if (err)
 					goto out;
 
-				atomic_long_inc(&niov->pp_ref_count);
+				atomic_long_inc(&niov->desc.pp_ref_count);
 				tcp_xa_pool.netmems[tcp_xa_pool.idx++] = skb_frag_netmem(frag);
 
 				sent += copy;
-- 
2.17.1


