Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394975F7F9E
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiJGVRc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJGVRa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47365D0E5
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:23 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 297I5EHY006830
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:23 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3k2acdekgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:22 -0700
Received: from twshared19720.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:21 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 7B0A521DAFDA4; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 7/9] page_pool: add page allocation and free hooks.
Date:   Fri, 7 Oct 2022 14:17:11 -0700
Message-ID: <20221007211713.170714-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: D9Qslwxk4TApAMcvHPvXEVFE0medB46G
X-Proofpoint-GUID: D9Qslwxk4TApAMcvHPvXEVFE0medB46G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In order to allow for user-allocated page backing, add hooks to the
page pool so pages can be obtained and released from a user-supplied
provider instead of the system page allocator.

skbs are marked with skb_mark_for_recycle() if they contain pages
belonging to a page pool, and page_put() will deliver the pages back
to the pool instead of freeing them to the system page allocator.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/page_pool.h |  6 ++++++
 net/core/page_pool.c    | 41 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..85c8423f9a7e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -82,6 +82,12 @@ struct page_pool_params {
 	unsigned int	offset;  /* DMA addr offset */
 	void (*init_callback)(struct page *page, void *arg);
 	void *init_arg;
+	struct page *(*alloc_pages)(void *arg, int nid, gfp_t gfp,
+				    unsigned int order);
+	unsigned long (*alloc_bulk)(void *arg, gfp_t gfp, int nid,
+				    unsigned long nr_pages,
+				    struct page **page_array);
+	void (*put_page)(void *arg, struct page *page);
 };
 
 #ifdef CONFIG_PAGE_POOL_STATS
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b203d8660e4..21c6ee97bc7f 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -342,19 +342,47 @@ static void page_pool_clear_pp_info(struct page *page)
 	page->pp = NULL;
 }
 
+/* hooks to either page provider or system page allocator */
+static void page_pool_mm_put_page(struct page_pool *pool, struct page *page)
+{
+	if (pool->p.put_page)
+		return pool->p.put_page(pool->p.init_arg, page);
+	put_page(page);
+}
+
+static unsigned long page_pool_mm_alloc_bulk(struct page_pool *pool,
+					     gfp_t gfp,
+					     unsigned long nr_pages)
+{
+	if (pool->p.alloc_bulk)
+		return pool->p.alloc_bulk(pool->p.init_arg, gfp,
+					  pool->p.nid, nr_pages,
+					  pool->alloc.cache);
+	return alloc_pages_bulk_array_node(gfp, pool->p.nid,
+					   nr_pages, pool->alloc.cache);
+}
+
+static struct page *page_pool_mm_alloc(struct page_pool *pool, gfp_t gfp)
+{
+	if (pool->p.alloc_pages)
+		return pool->p.alloc_pages(pool->p.init_arg, pool->p.nid,
+					   gfp, pool->p.order);
+	return alloc_pages_node(pool->p.nid, gfp, pool->p.order);
+}
+
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 						 gfp_t gfp)
 {
 	struct page *page;
 
 	gfp |= __GFP_COMP;
-	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
+	page = page_pool_mm_alloc(pool, gfp);
 	if (unlikely(!page))
 		return NULL;
 
 	if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
 	    unlikely(!page_pool_dma_map(pool, page))) {
-		put_page(page);
+		page_pool_mm_put_page(pool, page);
 		return NULL;
 	}
 
@@ -389,8 +417,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
 	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
 
-	nr_pages = alloc_pages_bulk_array_node(gfp, pool->p.nid, bulk,
-					       pool->alloc.cache);
+	nr_pages = page_pool_mm_alloc_bulk(pool, gfp, bulk);
 	if (unlikely(!nr_pages))
 		return NULL;
 
@@ -401,7 +428,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		page = pool->alloc.cache[i];
 		if ((pp_flags & PP_FLAG_DMA_MAP) &&
 		    unlikely(!page_pool_dma_map(pool, page))) {
-			put_page(page);
+			page_pool_mm_put_page(pool, page);
 			continue;
 		}
 
@@ -501,7 +528,7 @@ static void page_pool_return_page(struct page_pool *pool, struct page *page)
 {
 	page_pool_release_page(pool, page);
 
-	put_page(page);
+	page_pool_mm_put_page(pool, page);
 	/* An optimization would be to call __free_pages(page, pool->p.order)
 	 * knowing page is not part of page-cache (thus avoiding a
 	 * __page_cache_release() call).
@@ -593,7 +620,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 	recycle_stat_inc(pool, released_refcnt);
 	/* Do not replace this with page_pool_return_page() */
 	page_pool_release_page(pool, page);
-	put_page(page);
+	page_pool_mm_put_page(pool, page);
 
 	return NULL;
 }
-- 
2.30.2

