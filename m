Return-Path: <io-uring+bounces-10714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 681A4C7733F
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 05:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F2A784E45E2
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 04:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6669123C4E9;
	Fri, 21 Nov 2025 04:01:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347DB248F68;
	Fri, 21 Nov 2025 04:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763697670; cv=none; b=ID0xututA0Htz29S3H+JgHjl1gMKESg+LGcF6SV/e9azbu1BiG6GPBmwjIWArvo43szrXObWFub+PPunjwGrjjbSsQb+5uE28HXlvS+F3o9Ffa6zFKd5IVF47638n/dKrEbt/8omKA+pnVs5Ig9QKdKqvhqYR+hsUz0RYmgti/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763697670; c=relaxed/simple;
	bh=6qIHlhM+MCUdvVq4j3wN5PWzi4h0LIZ0znmf+vGPkR8=;
	h=From:To:Cc:Subject:Date:Message-Id; b=kFi6bs7+MXtdtMFiv1IZWacQmEv//fp8INYbXSnGhyD0TCMMvfZsCit1+6F1ICXZoMoxnyTGInRtvCQQGyf+x+oxl782BFrumoPxtmD8Al3sz9ee7Tpn/1ExZSiwu4kMYBynK+ATpF5BkKuAkJBkl5gcUYxjpz525PT94zyyMn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-6d-691fe3faf41f
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
Subject: [PATCH net-next 1/3] netmem, io_uring/zcrx: access pp fields through @desc in net_iov
Date: Fri, 21 Nov 2025 13:00:45 +0900
Message-Id: <20251121040047.71921-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsXC9ZZnke6vx/KZBku28lus/lFhsfzBDlaL
	n2ueM1nMWbWN0WL13X42iznnW1gsvq7/xWyxblcrk8XOXc8ZLV7NWMtm8fTYI3aL+8uesVjs
	ad/ObPGo/wSbxbvWcywWF7b1sVqcO7ySzWJ7wwN2i8u75rBZ3Fvzn9Xi5KyVLBYdd/ayWBxb
	IGbx7fQbRourM3cxWSy8E29x6fAjFovZjX2MFr9/ANXPPnqP3UHOY8vKm0we12ZMZPG4se8U
	k8fOWXfZPRZsKvXYvELL4/LZUo9NqzrZPDZ9msTusXPHZyaP3uZ3bB4fn95i8Xi/7yqbx5kF
	R9g9Pm+SC+CP4rJJSc3JLEst0rdL4MpoXvKDreALT0XP7ZNMDYynuboYOTkkBEwkVi5/wAhj
	f2tsZAex2QTUJW7c+MkMYosISEl83LEdKM7FwSywhlVi+YytYA3CAnESD38sAGtgEVCVWL92
	MRuIzStgKtGxZznUUHmJ1RsOMIM0SwgcY5d4+vMPG0RCUuLgihssExi5FzAyrGIUyswry03M
	zDHRy6jMy6zQS87P3cQIjK9ltX+idzB+uhB8iFGAg1GJh/cEp3ymEGtiWXFl7iFGCQ5mJRFe
	VUeZTCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Rt/KU4QE0hNLUrNTUwtSi2CyTBycUg2MVpsu
	mxzp2FScyusT47rj7h/Jt9XWX17XSL5c+7j15fLtK1IiLjDMl6gXf+/YtTnnwISotbOcnslx
	bjywIe38p6+714bZn92puMN8S+K+Az17XwufMLLdpxGvspnPqaYrceVTBc3uzQGXeLt/qKTp
	XjSX13BcLrd/yxb2ks7y5eVdH8R/aq+3U2Ipzkg01GIuKk4EAKkE5lqrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAAwGRAm79CAMS/gMaCGludGVybmFsIgYKBApOO4Mt+uMfaTCOOjir+Hg4p+C4
	BTj5rOcCOJyqtgE4q92PBjicz4QEOPWv+gM4rrqFAji5uucBOOqYrQY45cbiBzjfpuYEOLyH
	twM44o/IBjjuhc4EOMOdyQU40LaOBTjOw6kGOLeA4Ac407qcBjjerP8FOMmaqQQ4iNy9BDjG
	oBY49svsATjVmboCOKHcXzjSw+IEOJuBjgE4+/icBjibxd4HQB9ItKnZAkjWmJEESNi+ygJI
	uZrdB0igsnVIs6gqSNPNdUiyqokGSLLykgdIubjzAkiNg+4GSPHl2gRI777VBkij6PACSMyg
	xAdI87IeUBBaCjxkZWxpdmVyLz5gCmiDpPgGcPQMeIzbyQKAAcsKigEJCBgQNBj2gYEHigEJ
	CAYQJxjY2PkDigEJCBQQGhjxuLcHigEKCAMQrAUYp5i1AYoBCQgTEF4Y4figB4oBCQgEECUY
	r62jBooBCQgNEDUYiLynAYoBCQgYEB8Yq7DAA5ABCKABAKoBFGludm1haWw1LnNraHluaXgu
	Y29tsgEGCgSmffyRuAH000fCARAIASIMDcgJH2kSBWF2c3ltwgEYCAMiFA0lQRxpEg1kYXl6
	ZXJvX3J1bGVzwgEbCAQiFw1KV2VgEhBnYXRla2VlcGVyX3J1bGVzwgECCAkagAEAuSxiYklG
	aIusnnStzTc8+QxM5e5ncem5ZVHeb2HzY8QvfOiwsiQCnYkGWFDtu8S2Ar5WHICr0h8eVG2M
	n0ylQba81grQiQi1FX7kvPun43q8VverMW7mqYosZAjnp9DMwqkK7//qyr366Oew1XhNs8kw
	HOSkVpsXN2KzXzeuHyIEc2hhMSoDcnNhp4l8S5ECAAA=
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
 io_uring/zcrx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b1b723222cdb..f3ba04ce97ab 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -693,12 +693,12 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
 
-	if (!niov->pp) {
+	if (!niov->desc.pp) {
 		/* copy fallback allocated niovs */
 		io_zcrx_return_niov_freelist(niov);
 		return;
 	}
-	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
+	page_pool_put_unrefed_netmem(niov->desc.pp, netmem, -1, false);
 }
 
 static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
@@ -800,7 +800,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		if (!page_pool_unref_and_test(netmem))
 			continue;
 
-		if (unlikely(niov->pp != pp)) {
+		if (unlikely(niov->desc.pp != pp)) {
 			io_zcrx_return_niov(niov);
 			continue;
 		}
@@ -1074,8 +1074,8 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return io_zcrx_copy_frag(req, ifq, frag, off, len);
 
 	niov = netmem_to_net_iov(frag->netmem);
-	if (!niov->pp || niov->pp->mp_ops != &io_uring_pp_zc_ops ||
-	    io_pp_to_ifq(niov->pp) != ifq)
+	if (!niov->desc.pp || niov->desc.pp->mp_ops != &io_uring_pp_zc_ops ||
+	    io_pp_to_ifq(niov->desc.pp) != ifq)
 		return -EFAULT;
 
 	if (!io_zcrx_queue_cqe(req, niov, ifq, off + skb_frag_off(frag), len))
-- 
2.17.1


