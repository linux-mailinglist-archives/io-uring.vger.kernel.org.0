Return-Path: <io-uring+bounces-10023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 98320BE1C47
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 08:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D691E4E8A5F
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 06:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A302DEA8C;
	Thu, 16 Oct 2025 06:37:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B829A2DE6F8;
	Thu, 16 Oct 2025 06:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760596636; cv=none; b=KQd0dhFjfFtgiMhtT11SZN/0GjhSYiDRCugV+qej7v0lhgnNSw3tFhZuQfA3ncPdfabzw3Z38ucr9EH5a7/xXn05rZYTw4x0nDCvoWaAbmncjsKBsBUjGAPqljcHGA7GRI8k1ub7Ek9/xXp3Zw+r/xnAf70twzdjQeSZG/CNrTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760596636; c=relaxed/simple;
	bh=K34ehr8RNb8WkyEDgQ2XhDAjvJhbuEBHYZnegCjBiwo=;
	h=From:To:Cc:Subject:Date:Message-Id; b=ecJGTYEMhVy3qZ2tSbLE8fo3ghe37XMNNviKtoYIjj0oEmjHvwhx55swCk18egBXgk6VFuWpZY6V9WNIF2ct+WoLaieF+vkT1LRvqr6aq0YCu8dsMW6EfLCSilKgUxbpuG6OaDhz5PrChD1vaZNGZDppru6L5FNVcyQkB09rMrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-31-68f092937ca6
From: Byungchul Park <byungchul@sk.com>
To: axboe@kernel.dk,
	kuba@kernel.org,
	pabeni@redhat.com,
	almasrymina@google.com,
	asml.silence@gmail.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	hawk@kernel.org,
	ilias.apalodimas@linaro.org,
	sdf@fomichev.me,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com,
	byungchul@sk.com,
	toke@redhat.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel_team@skhynix.com,
	max.byungchul.park@gmail.com
Subject: [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to confirm its usage as pp for net_iov
Date: Thu, 16 Oct 2025 15:36:57 +0900
Message-Id: <20251016063657.81064-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsXC9ZZnoe7kSR8yDDqfWlis/lFh8XPNcyaL
	Oau2MVqsvtvPZjHnfAuLxc5dzxktXs1Yy2bx9Ngjdos97duZLR71n2Cz6G35zWzxrvUci8WF
	bX2sFpd3zWGzuDCxl9Xi2AIxi2+n3zBaXJ25i8ni0uFHLA7CHltW3mTyuDZjIovHjX2nmDx2
	zrrL7rFgU6nH5bOlHptWdbJ53Lm2h82jt/kdm8f7fVfZPD5vkgvgjuKySUnNySxLLdK3S+DK
	6Hi/gaXglGzFjPdXGBsYl0l0MXJySAiYSMw81MQOY0/8eoEZxGYTUJe4ceMnmC0ikC9xaMdW
	pi5GLg5mgX9MEnMX9LGCJIQFMiR2vmwDa2YRUJU4d+YRI4jNK2AqMf/tX2aIofISqzccYAZp
	lhB4zybxZcZ/FoiEpMTBFTdYJjByL2BkWMUolJlXlpuYmWOil1GZl1mhl5yfu4kRGMzLav9E
	72D8dCH4EKMAB6MSD++DFe8zhFgTy4orcw8xSnAwK4nwMhR8yBDiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOa/StPEVIID2xJDU7NbUgtQgmy8TBKdXAaJ+2PEhQ8WX/5lC597Ki8w+lszDfUi/2
	ydioxmfwuPrukjT1dVME2A+zbWk++677d/5Dpn4fl9u3E17KlXz6c+wq86xtUnMPL86/3Cyz
	VEymsmtTfHyO8hGGx2HJVXlrQxzi/Ngiq9tnSElcDDx9mGn2opLLa/Rvv5ji4j9lmvcOnyaN
	LPZmJZbijERDLeai4kQAlyq2smICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAwFSAq39CAMSvwMaCGludGVybmFsIgYKBApOO4Mtk5LwaDCpyys4q/h4OPms
	5wI4nKq2ATir3Y8GOM6UmwY4nM+EBDi5uucBOOqYrQY45cbiBzi8h7cDOOKPyAY4jYT7Azju
	hc4EOMOdyQU40LaOBTjTupwGONCRjQU4xqAWOPbL7AE41Zm6AjjSw+IEQBVItKnZAkjWmJEE
	SNi+ygJIuZrdB0igsnVI0811SLKqiQZI3Na8BkiNg+4GSO++1QZI9ttISKPo8AJI87IeUA1a
	CjxkZWxpdmVyLz5gCmiI77AEcModeJjv1AGAAaYYigEJCBgQNBiR9dADigEJCAYQJxjY2PkD
	igEJCBQQbxjCuLUCigEKCAMQ/gIYnaCOBYoBCQgTEGgYuemGB4oBCQgEECUYzsziAYoBCQgN
	EDUYn+39A4oBCQgYEB8Yq7DAA5ABCKABAKoBFGludm1haWw1LnNraHluaXguY29tsgEGCgSm
	ffyRuAH000fCARAIASIMDeCo72gSBWF2c3ltwgEYCAMiFA0AcPBoEg1kYXl6ZXJvX3J1bGVz
	wgEbCAQiFw1KV2VgEhBnYXRla2VlcGVyX3J1bGVzwgECCAkagAEcoB1FfvYRkChl5zqcwYZN
	zHZD4qtyrTXlnd0IhKxlQwlmxl0dTsgDEJMgBUZoFoegYmLTfcizDeoELaPIelMI35Fe9c5/
	CcUgcc+Hw9CgKzgoM8SGz8W7cZHptyuoSM1r+r9npqGbJzPLum90AhvFyLLNIDfyr8kdppRN
	d4in5yIEc2hhMSoDcnNheM0lv1ICAAA=
X-CFilter-Loop: Reflected
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

->pp_magic field in struct page is current used to identify if a page
belongs to a page pool.  However, ->pp_magic will be removed and page
type bit in struct page e.g. PGTY_netpp should be used for that purpose.

As a preparation, the check for net_iov, that is not page-backed, should
avoid using ->pp_magic since net_iov doens't have to do with page type.
Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
page pool, by making sure nmdesc->pp is NULL otherwise.

For page-backed netmem, just leave unchanged as is, while for net_iov,
make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
check.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 io_uring/zcrx.c        |  4 ++++
 net/core/devmem.c      |  1 +
 net/core/netmem_priv.h |  6 ++++++
 net/core/page_pool.c   | 16 ++++++++++++++--
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 723e4266b91f..cf78227c0ca6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -450,6 +450,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		area->freelist[i] = i;
 		atomic_set(&area->user_refs[i], 0);
 		niov->type = NET_IOV_IOURING;
+
+		/* niov->desc.pp is already initialized to NULL by
+		 * kvmalloc_array(__GFP_ZERO).
+		 */
 	}
 
 	area->free_count = nr_iovs;
diff --git a/net/core/devmem.c b/net/core/devmem.c
index d9de31a6cc7f..f81b700f1fd1 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -291,6 +291,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 			niov = &owner->area.niovs[i];
 			niov->type = NET_IOV_DMABUF;
 			niov->owner = &owner->area;
+			niov->desc.pp = NULL;
 			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
 						      net_devmem_get_dma_addr(niov));
 			if (direction == DMA_TO_DEVICE)
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 23175cb2bd86..fb21cc19176b 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -22,6 +22,12 @@ static inline void netmem_clear_pp_magic(netmem_ref netmem)
 
 static inline bool netmem_is_pp(netmem_ref netmem)
 {
+	/* Use ->pp for net_iov to identify if it's pp, which requires
+	 * that non-pp net_iov should have ->pp NULL'd.
+	 */
+	if (netmem_is_net_iov(netmem))
+		return !!netmem_to_nmdesc(netmem)->pp;
+
 	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
 }
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a5edec485f1..2756b78754b0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -699,7 +699,13 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
-	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+
+	/* For page-backed, pp_magic is used to identify if it's pp.
+	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
+	 * and nmdesc->pp is NULL if it's not.
+	 */
+	if (!netmem_is_net_iov(netmem))
+		netmem_or_pp_magic(netmem, PP_SIGNATURE);
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -714,7 +720,13 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
+	/* For page-backed, pp_magic is used to identify if it's pp.
+	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
+	 * and nmdesc->pp is NULL if it's not.
+	 */
+	if (!netmem_is_net_iov(netmem))
+		netmem_clear_pp_magic(netmem);
+
 	netmem_set_pp(netmem, NULL);
 }
 

base-commit: e1f5bb196f0b0eee197e06d361f8ac5f091c2963
-- 
2.17.1


