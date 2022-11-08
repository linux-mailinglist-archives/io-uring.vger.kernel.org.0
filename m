Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6990B6208BE
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiKHFFe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiKHFFd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:33 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C26AE44
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:32 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7LKsiQ007050
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:31 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knnnvd7sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:31 -0800
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:29 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 1412C23B26017; Mon,  7 Nov 2022 21:05:22 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 08/15] io_uring: Add zctap buffer get/put functions and refcounting.
Date:   Mon, 7 Nov 2022 21:05:14 -0800
Message-ID: <20221108050521.3198458-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xr51wzU1SAZlO5BXf2jcwPwgYSL4sRUk
X-Proofpoint-GUID: xr51wzU1SAZlO5BXf2jcwPwgYSL4sRUk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
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

Flesh out the driver API functions introduced earlier.

The driver gets a buffer with the specified reference count.

If the driver specifies a large refcount (bias), it decrements
this as skb fragments go up the stack, and the driver releases
the references when finished with the buffer.

When ownership of the fragment is transferred to the user, a
user refcount is incremented, and correspondingly decremented
when returned.  When all refcounts are released, the buffer is safe
to reuse.  The user/kernel split is needed to differentiate between
"safe to reuse the buffer" and "still in use by the kernel".

The locking here can likely be improved.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/kbuf.c  |  13 +++++
 io_uring/kbuf.h  |   2 +
 io_uring/zctap.c | 131 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 145 insertions(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 25cd724ade18..aadc664aaa87 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -188,6 +188,19 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ret;
 }
 
+/* Called from the network driver, in napi context. */
+u64 io_zctap_buffer(struct io_kiocb *req, size_t *len)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	void __user *ret = NULL;
+
+	bl = io_buffer_get_list(ctx, req->buf_index);
+	if (likely(bl))
+		ret = io_ring_buffer_select(req, len, bl, IO_URING_F_UNLOCKED);
+	return (u64)ret;
+}
+
 static __cold int io_init_bl_list(struct io_ring_ctx *ctx)
 {
 	int i;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c23e15d7d3ca..b530e987b438 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -50,6 +50,8 @@ unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
 void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
+u64 io_zctap_buffer(struct io_kiocb *req, size_t *len);
+
 static inline void io_kbuf_recycle_ring(struct io_kiocb *req)
 {
 	/*
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index fe4bb3781636..0da9e6510f36 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -24,6 +24,8 @@ struct ifq_region {
 	int			nr_pages;
 	u16			id;
 
+	spinlock_t		freelist_lock;
+
 	struct io_zctap_buf	*buf;
 	u16			freelist[];
 };
@@ -40,20 +42,146 @@ static u64 zctap_mk_page_info(u16 region_id, u16 pgid)
 	return (u64)0xface << 48 | (u64)region_id << 16 | (u64)pgid;
 }
 
+static u64 zctap_page_info(const struct page *page)
+{
+	return page_private(page);
+}
+
+static u16 zctap_page_id(const struct page *page)
+{
+	return zctap_page_info(page) & 0xffff;
+}
+
+/* driver bias cannot be larger than this */
+#define IO_ZCTAP_UREF		0x10000
+#define IO_ZCTAP_KREF_MASK	(IO_ZCTAP_UREF - 1)
+
+/* return user refs back, indicate whether buffer is reusable */
+static bool io_zctap_put_buf_uref(struct io_zctap_buf *buf)
+{
+	if (atomic_read(&buf->refcount) < IO_ZCTAP_UREF) {
+		WARN_ONCE(1, "uref botch: %x < %x, id:%d page:%px\n",
+			atomic_read(&buf->refcount), IO_ZCTAP_UREF,
+			zctap_page_id(buf->page),
+			buf->page);
+		return false;
+	}
+
+	return atomic_sub_and_test(IO_ZCTAP_UREF, &buf->refcount);
+}
+
+/* gets a user-supplied buffer from the fill queue */
+static struct io_zctap_buf *io_zctap_get_buffer(struct io_zctap_ifq *ifq,
+						u16 *buf_pgid)
+{
+	struct io_zctap_buf *buf;
+	struct ifq_region *ifr;
+	struct io_kiocb req;
+	int pgid, region_id;
+	size_t len = 0;
+	u64 addr;
+
+	ifr = ifq->region;
+retry:
+	req = (struct io_kiocb) {
+		.ctx = ifq->ctx,
+		.buf_index = ifq->fill_bgid,
+	};
+	/*  IN: uses buf_index as buffer group.
+	 * OUT: buf_index of actual buffer. (and req->buf_list set)
+	 *	(this comes from the user-supplied bufid)
+	 */
+	addr = io_zctap_buffer(&req, &len);
+	if (!addr)
+		return NULL;
+
+	pgid = addr & 0xffff;
+	region_id = (addr >> 16) & 0xffff;
+	if (region_id) {
+		WARN_RATELIMIT(1, "region_id %d > max 1", region_id);
+		return NULL;
+	}
+
+	if (pgid > ifr->nr_pages) {
+		WARN_RATELIMIT(1, "bufid %d > max %d", pgid, ifr->nr_pages);
+		return NULL;
+	}
+
+	buf = &ifr->buf[pgid];
+	if (!io_zctap_put_buf_uref(buf))
+		goto retry;
+
+	*buf_pgid = pgid;
+	return buf;
+}
+
+/* if on exit/teardown path, can skip this work */
+static void io_zctap_recycle_buf(struct ifq_region *ifr,
+				 struct io_zctap_buf *buf)
+{
+	spin_lock(&ifr->freelist_lock);
+
+	ifr->freelist[ifr->free_count++] = buf - ifr->buf;
+
+	spin_unlock(&ifr->freelist_lock);
+}
+
 struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
 {
-	return NULL;
+	struct ifq_region *ifr = ifq->region;
+	struct io_zctap_buf *buf;
+	u16 pgid;
+
+	spin_lock(&ifr->freelist_lock);
+
+	buf = NULL;
+	if (ifr->free_count) {
+		pgid = ifr->freelist[--ifr->free_count];
+		buf = &ifr->buf[pgid];
+	}
+
+	spin_unlock(&ifr->freelist_lock);
+
+	if (!buf) {
+		buf = io_zctap_get_buffer(ifq, &pgid);
+		if (!buf)
+			return NULL;
+	}
+
+	WARN_ON(atomic_read(&buf->refcount));
+	atomic_set(&buf->refcount, refc & IO_ZCTAP_KREF_MASK);
+
+	return buf;
 }
 EXPORT_SYMBOL(io_zctap_get_buf);
 
+/* called from driver and networking stack. */
 void io_zctap_put_buf(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf)
 {
+	struct ifq_region *ifr = ifq->region;
+
+	/* XXX move to inline function later. */
+	if (!atomic_dec_and_test(&buf->refcount))
+		return;
+
+	io_zctap_recycle_buf(ifr, buf);
 }
 EXPORT_SYMBOL(io_zctap_put_buf);
 
+/* called from driver and networking stack. */
 void io_zctap_put_buf_refs(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf,
 			   unsigned count)
 {
+	struct ifq_region *ifr = ifq->region;
+	unsigned refs;
+
+	refs = atomic_read(&buf->refcount) & IO_ZCTAP_KREF_MASK;
+	WARN(refs < count, "driver refcount botch: %u < %u\n", refs, count);
+
+	if (!atomic_sub_and_test(count, &buf->refcount))
+		return;
+
+	io_zctap_recycle_buf(ifr, buf);
 }
 EXPORT_SYMBOL(io_zctap_put_buf_refs);
 
@@ -176,6 +304,7 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 		return -ENOMEM;
 	}
 
+	spin_lock_init(&ifr->freelist_lock);
 	ifr->nr_pages = nr_pages;
 	ifr->imu = imu;
 	ifr->free_count = nr_pages;
-- 
2.30.2

