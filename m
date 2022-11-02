Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51216172D9
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKBXkU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiKBXj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2717F2700
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:33:06 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVscu023023
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:33:06 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkj3b8w77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:33:05 -0700
Received: from twshared6758.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:33:04 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id CC1F9235B618F; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 14/15] io_uring: Add a buffer caching mechanism for zctap.
Date:   Wed, 2 Nov 2022 16:32:43 -0700
Message-ID: <20221102233244.4022405-15-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: pXi47mmqesCe1eeffSdRwmlflO6F0R3w
X-Proofpoint-GUID: pXi47mmqesCe1eeffSdRwmlflO6F0R3w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is based on the same concept as the page pool.

Here, there are 4 separate buffer sources:
  cache - small (128) cache the driver can use locklessly.
  ptr_ring - buffers freed through skb_release_data()
  fillq - entries returned from the application
  freelist - spinlock protected pool of free entries.

The driver first tries the lockless cache, before attempting to
refill it from the ptr ring.  If there are still no buffers, then
the fill ring is examined, before going to the freelist.

If the ptr_ring is full when buffers are released as the skb is
dropped (or the driver returns the buffers), then they are placed
back on the freelist.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 128 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 99 insertions(+), 29 deletions(-)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 9eba916376c6..8515fff20ad5 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -18,8 +18,12 @@
 
 #define NR_ZCTAP_IFQS	1
 
+#define REGION_CACHE_COUNT	128
+#define REGION_REFILL_COUNT	64
+
 struct ifq_region {
 	struct io_zctap_ifq	*ifq;
+	int			cache_count;
 	int			free_count;
 	int			nr_pages;
 	u16			id;
@@ -28,6 +32,10 @@ struct ifq_region {
 	struct delayed_work	release_work;
 	unsigned long		delay_end;
 
+	u16			cache[REGION_CACHE_COUNT];
+
+	struct ptr_ring		ring;
+
 	struct io_zctap_buf	*buf;
 	u16			freelist[];
 };
@@ -103,8 +111,29 @@ static bool io_zctap_put_buf_uref(struct io_zctap_buf *buf)
 	return atomic_sub_and_test(IO_ZCTAP_UREF, &buf->refcount);
 }
 
+/* if on exit/teardown path, can skip this work */
+static void io_zctap_recycle_buf(struct ifq_region *ifr,
+				 struct io_zctap_buf *buf)
+{
+	int rc;
+
+	if (in_serving_softirq())
+		rc = ptr_ring_produce(&ifr->ring, buf);
+	else
+		rc = ptr_ring_produce_bh(&ifr->ring, buf);
+
+	if (rc) {
+		spin_lock(&ifr->freelist_lock);
+
+		ifr->freelist[ifr->free_count++] = buf - ifr->buf;
+
+		spin_unlock(&ifr->freelist_lock);
+	}
+}
+
 /* gets a user-supplied buffer from the fill queue
  *   note: may drain N entries, but still have no usable buffers
+ *   XXX add retry limit?
  */
 static struct io_zctap_buf *io_zctap_get_buffer(struct io_zctap_ifq *ifq,
 						u16 *buf_pgid)
@@ -146,40 +175,71 @@ static struct io_zctap_buf *io_zctap_get_buffer(struct io_zctap_ifq *ifq,
 	return buf;
 }
 
-/* if on exit/teardown path, can skip this work */
-static void io_zctap_recycle_buf(struct ifq_region *ifr,
-				 struct io_zctap_buf *buf)
+static int io_zctap_get_buffers(struct io_zctap_ifq *ifq, u16 *cache, int n)
 {
-	spin_lock(&ifr->freelist_lock);
+	struct io_zctap_buf *buf;
+	int i;
 
-	ifr->freelist[ifr->free_count++] = buf - ifr->buf;
-
-	spin_unlock(&ifr->freelist_lock);
+	for (i = 0; i < n; i++) {
+		buf = io_zctap_get_buffer(ifq, &cache[i]);
+		if (!buf)
+			break;
+	}
+	return i;
 }
 
 struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
 {
-	struct ifq_region *ifr = ifq->region;
 	struct io_zctap_buf *buf;
+	struct ifq_region *ifr;
+	int count;
 	u16 pgid;
 
+	ifr = ifq->region;
+	if (ifr->cache_count)
+		goto out;
+
+	if (!__ptr_ring_empty(&ifr->ring)) {
+		do {
+			buf = __ptr_ring_consume(&ifr->ring);
+			if (!buf)
+				break;
+			ifr->cache[ifr->cache_count++] = buf - ifr->buf;
+		} while (ifr->cache_count < REGION_REFILL_COUNT);
+
+		if (ifr->cache_count)
+			goto out;
+	}
+
+	count = io_zctap_get_buffers(ifq, ifr->cache, REGION_REFILL_COUNT);
+	ifr->cache_count += count;
+
+	if (ifr->cache_count)
+		goto out;
+
 	spin_lock(&ifr->freelist_lock);
 
-	buf = NULL;
-	if (ifr->free_count) {
-		pgid = ifr->freelist[--ifr->free_count];
-		buf = &ifr->buf[pgid];
-	}
+	count = min_t(int, ifr->free_count, REGION_CACHE_COUNT);
+	ifr->free_count -= count;
+	ifr->cache_count += count;
+	memcpy(ifr->cache, &ifr->freelist[ifr->free_count],
+	       count * sizeof(u16));
 
 	spin_unlock(&ifr->freelist_lock);
 
-	if (!buf) {
-		buf = io_zctap_get_buffer(ifq, &pgid);
-		if (!buf)
-			return NULL;
-	}
+	if (ifr->cache_count)
+		goto out;
 
-	WARN_ON(atomic_read(&buf->refcount));
+	return NULL;
+
+out:
+	pgid = ifr->cache[--ifr->cache_count];
+	buf = &ifr->buf[pgid];
+
+	WARN_RATELIMIT(atomic_read(&buf->refcount),
+		       "pgid:%d refc:%d cache_count:%d\n",
+		       pgid, atomic_read(&buf->refcount),
+		       ifr->cache_count);
 	atomic_set(&buf->refcount, refc & IO_ZCTAP_KREF_MASK);
 
 	return buf;
@@ -274,6 +334,7 @@ static void io_remove_ifq_region_work(struct work_struct *work)
 	}
 
 	io_zctap_ifq_put(ifr->ifq);
+	ptr_ring_cleanup(&ifr->ring, NULL);
 	kvfree(ifr->buf);
 	kvfree(ifr);
 }
@@ -361,16 +422,18 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 	if (imu->ubuf & ~PAGE_MASK || imu->ubuf_end & ~PAGE_MASK)
 		return -EFAULT;
 
+	err = -ENOMEM;
 	nr_pages = imu->nr_bvecs;
 	ifr = kvmalloc(struct_size(ifr, freelist, nr_pages), GFP_KERNEL);
 	if (!ifr)
-		return -ENOMEM;
+		goto fail;
 
 	ifr->buf = kvmalloc_array(nr_pages, sizeof(*ifr->buf), GFP_KERNEL);
-	if (!ifr->buf) {
-		kvfree(ifr);
-		return -ENOMEM;
-	}
+	if (!ifr->buf)
+		goto fail_buf;
+
+	if (ptr_ring_init(&ifr->ring, 1024, GFP_KERNEL))
+		goto fail_ring;
 
 	spin_lock_init(&ifr->freelist_lock);
 	ifr->nr_pages = nr_pages;
@@ -378,18 +441,25 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 	ifr->id = id;
 	ifr->ifq = ifq;
 	ifr->delay_end = 0;
+	ifr->cache_count = 0;
 
 	err = io_zctap_map_region(ifr, imu);
-	if (err) {
-		kvfree(ifr->buf);
-		kvfree(ifr);
-		return err;
-	}
+	if (err)
+		goto fail_map;
 
 	ifq->region = ifr;
 	refcount_inc(&ifq->refcount);
 
 	return 0;
+
+fail_map:
+	ptr_ring_cleanup(&ifr->ring, NULL);
+fail_ring:
+	kvfree(ifr->buf);
+fail_buf:
+	kvfree(ifr);
+fail:
+	return err;
 }
 
 static int __io_queue_mgmt(struct net_device *dev, struct io_zctap_ifq *ifq,
-- 
2.30.2

