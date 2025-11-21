Return-Path: <io-uring+bounces-10715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 613A7C77346
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 05:01:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 631852C591
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 04:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A87D1A9F82;
	Fri, 21 Nov 2025 04:01:10 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5174D26059B;
	Fri, 21 Nov 2025 04:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763697670; cv=none; b=P7NZi9r7KfBcueH0WNsANnPwHjg57qDNDXz+0B1MMP0tVI7lM3v2JQZrTy5HSJCJxXh2SIta5M7Cfizq1xoyLpw/ZHc2A91F2aNdUAgV8inAjVBMO73oiW/t5RuQfhyyUdcWeVsXt5GWxxBntfuzCGOd7J6f8WCEC5lrSXCdfIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763697670; c=relaxed/simple;
	bh=0HzUDwXwMfMCeAP3d9l4+nBkDsbydg1O3czyM/voiz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ISCO+gtKhiW2KZDTay1MGbjwnNu5w2oVm9uEuChXfJA6q4hmdSV8Js8qa7cSIk4eQ3Ksnjd5WVbLLYOY4itQDUonEn0X/QQahBxYv8ef/mbVFJMJYQqPCjNL3toyFbEbwdA+0I9vbHRMtvpXWPN5D8W2aazvcjE85TMMEcgui/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-7f-691fe3fa945c
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
Subject: [PATCH net-next 3/3] netmem: remove the pp fields from net_iov
Date: Fri, 21 Nov 2025 13:00:47 +0900
Message-Id: <20251121040047.71921-3-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251121040047.71921-1-byungchul@sk.com>
References: <20251121040047.71921-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsXC9ZZnoe6vx/KZBgumilus/lFhsfzBDlaL
	n2ueM1nMWbWN0WL13X42iznnW1gsvq7/xWyxblcrk8XOXc8ZLV7NWMtm8fTYI3aL+8uesVjs
	ad/ObPGo/wSbxbvWcywWF7b1sVqcO7ySzWJ7wwN2i8u75rBZ3Fvzn9Xi5KyVLBYdd/ayWBxb
	IGbx7fQbRourM3cxWSy8E29x6fAjFovZjX2MFr9/ANXPPnqP3UHOY8vKm0we12ZMZPG4se8U
	k8fOWXfZPRZsKvXYvELL4/LZUo9NqzrZPDZ9msTusXPHZyaP3uZ3bB4fn95i8Xi/7yqbx5kF
	R9g9Pm+SC+CP4rJJSc3JLEst0rdL4Mpo3zCDtWC+YMWcH3kNjF95uxg5OSQETCRWXT7ODmO/
	/76eCcRmE1CXuHHjJzOILSIgJfFxx3agGi4OZoE1rBLLZ2xl7GLk4BAWcJdo3O4HUsMioCox
	b/4cRhCbV8BUYvu3RYwQM+UlVm84ADaHU8BMYt+jmWBxIaCaNZ0PmEBmSgg8Ypf4++oVG0SD
	pMTBFTdYJjDyLmBkWMUolJlXlpuYmWOil1GZl1mhl5yfu4kRGIvLav9E72D8dCH4EKMAB6MS
	D+8JTvlMIdbEsuLK3EOMEhzMSiK8qo4ymUK8KYmVValF+fFFpTmpxYcYpTlYlMR5jb6VpwgJ
	pCeWpGanphakFsFkmTg4pRoY1/nc706e/3nipjNPImzEZxWny4Xqbz380KqyjPsXk+j23Y0B
	p4r28EaceHbQYqvdQsH7nnXhodMNuud+z9ncfi/SxrGnwOnQm9UhG37/Nagv2FuzeNGVCudo
	jv/+R0NvLnj39/eTS3M19bbuu+j5ILFkU7D/XIuJLY4zaps0Vtg4y140lWlgV2Ipzkg01GIu
	Kk4EAL4K3ZPBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTYQCG+87Ozs6Gq+OUPK1oMpBAyDQ0vi5YEeEhyIKiG5SuPOjBOW1z
	y0vBxEQdpClFR525Fd5nrpXuUqlomualcBhL1GRiShfN21KLzBn9e3jfh/fPi3NE91ExzihS
	aaVCJpdiAlQQfTB79+qEhAlljTxYv5wGq8dtXLhimkKgvq4ZwPrRQgzq391G4VLjKgc+ceQg
	0O6YAvAL24DByS43D36q+ozCl7lWDnQXdmNwJmcAhR3lPVz4vrmACwc6ajFo1Y7zoNOhx+CY
	aY0Le0prUZg38gqFXYat0NP7DcChEgcCjSMxcLDDjcKyrAIAfy2v+2WdY7wjEup57UeE+sAW
	oZSr5S1C2UtHeZTBoqae1QRTzn41ZanLxyjLfDGPstsWEOpO9gxGzU0Oo9RsyxBGPZ7+gVB9
	htc8asGy8zRxSXAojpYzGlq5JzJWkJBrZrkpFb5p+mWFFiwJdYCPk0Q4OfuzEfEyRuwiXa4V
	jpf9CTE5Z7PydECAcwgTl6xmm4AO4LgfEUVmWaO9DkoEkQ8r9MDLQiKCtHoegX+bErLe3Lax
	wyf2kS3uko1ctO6Y8seRu0BgAJvqgD+j0CTJGHlEiCoxIV3BpIVcS06ygPWzqm79LrKBRWdU
	OyBwIPURdvMljIgr06jSk9oBiXOk/sKgozsYkTBOlp5BK5NjlGo5rWoH23FUGiA8cZ6OFRHx
	slQ6kaZTaOX/FsH5Yi2I9432yYmZOHX8wp8HPg1nLjJbdJ0BhpqsVO1SZviarthjTLzOVrqs
	TaETlb2V5Zm97GJ1xYHWw8nHXjjjptnN3zWKwKuWRWNko54zM2yP2rut7c2NMEN/q7Ds6+Q5
	5VnPTXReHf+0/3Kf+QqZESgezHP67T9ZOD/CulPMZ8T3pKgqQRYWzFGqZH8BoGkrzagCAAA=
X-CFilter-Loop: Reflected
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Now that the pp fields in net_iov have no users, remove them from
net_iov and clean up.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/net/netmem.h | 38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 9e10f4ac50c3..46def457dc65 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -93,23 +93,7 @@ enum net_iov_type {
  *		supported.
  */
 struct net_iov {
-	union {
-		struct netmem_desc desc;
-
-		/* XXX: The following part should be removed once all
-		 * the references to them are converted so as to be
-		 * accessed via netmem_desc e.g. niov->desc.pp instead
-		 * of niov->pp.
-		 */
-		struct {
-			unsigned long _flags;
-			unsigned long pp_magic;
-			struct page_pool *pp;
-			unsigned long _pp_mapping_pad;
-			unsigned long dma_addr;
-			atomic_long_t pp_ref_count;
-		};
-	};
+	struct netmem_desc desc;
 	struct net_iov_area *owner;
 	enum net_iov_type type;
 };
@@ -123,26 +107,6 @@ struct net_iov_area {
 	unsigned long base_virtual;
 };
 
-/* net_iov is union'ed with struct netmem_desc mirroring struct page, so
- * the page_pool can access these fields without worrying whether the
- * underlying fields are accessed via netmem_desc or directly via
- * net_iov, until all the references to them are converted so as to be
- * accessed via netmem_desc e.g. niov->desc.pp instead of niov->pp.
- *
- * The non-net stack fields of struct page are private to the mm stack
- * and must never be mirrored to net_iov.
- */
-#define NET_IOV_ASSERT_OFFSET(desc, iov)                    \
-	static_assert(offsetof(struct netmem_desc, desc) == \
-		      offsetof(struct net_iov, iov))
-NET_IOV_ASSERT_OFFSET(_flags, _flags);
-NET_IOV_ASSERT_OFFSET(pp_magic, pp_magic);
-NET_IOV_ASSERT_OFFSET(pp, pp);
-NET_IOV_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
-NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
-NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
-#undef NET_IOV_ASSERT_OFFSET
-
 static inline struct net_iov_area *net_iov_owner(const struct net_iov *niov)
 {
 	return niov->owner;
-- 
2.17.1


