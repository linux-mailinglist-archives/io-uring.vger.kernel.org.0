Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019E1603333
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJRTQY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 18 Oct 2022 15:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJRTQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:16:21 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED5F6AEB9
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:17 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IFKSae014433
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:15 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k9ky5gh68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 18 Oct 2022 12:16:15 -0700
Received: from twshared9269.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:16:14 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 60EA7227F0517; Tue, 18 Oct 2022 12:16:02 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v2 08/13] io_uring: Add zctap buffer get/put functions and refcounting.
Date:   Tue, 18 Oct 2022 12:15:57 -0700
Message-ID: <20221018191602.2112515-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: e_9PqEKcqhh3_JrjIoQQCef4Ih0O_QIq
X-Proofpoint-GUID: e_9PqEKcqhh3_JrjIoQQCef4Ih0O_QIq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
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

The driver should get a buffer reference, and get a reference.

The refcount is incremented as skb fragments go up the stack, and
the driver releases its ref when finished with the buffer.

When ownership of the fragment is transferred to the user, a
user refcount is incremented, and correspondingly decremented
when returned.  When all refcounts are released, the buffer is safe
to reuse.  The user/kernel split is needed to differentiate between
"safe to reuse the buffer" and "still in use by the kernel".

The locking here is non-optimal, and likely can be improved.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/kbuf.c  |  13 ++++++
 io_uring/kbuf.h  |   2 +
 io_uring/zctap.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 25cd724ade18..caae2755e3d5 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -188,6 +188,19 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ret;
 }
 
+/* XXX May called from the driver, in napi context. */
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
index a924e59513a4..a398270cc43d 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -23,6 +23,8 @@ struct ifq_region {
 	int			nr_pages;
 	u16			id;
 
+	spinlock_t		freelist_lock;
+
 	struct io_zctap_buf	*buf;
 	struct io_zctap_buf	*freelist[];
 };
@@ -39,14 +41,116 @@ static u64 zctap_mk_page_info(u16 region_id, u16 pgid)
 	return (u64)0xface << 48 | (u64)region_id << 16 | (u64)pgid;
 }
 
+/* driver bias cannot be larger than this */
+#define IO_ZCTAP_UREF		0x1000
+#define IO_ZCTAP_KREF_MASK	(IO_ZCTAP_UREF - 1)
+
+/* return user refs back, indicate whether buffer is reusable */
+static bool io_zctap_put_buf_uref(struct io_zctap_buf *buf)
+{
+	if (atomic_read(&buf->refcount) < IO_ZCTAP_UREF) {
+		WARN(1, "uref botch: %d < %d, page:%px\n",
+			atomic_read(&buf->refcount), IO_ZCTAP_UREF,
+			buf->page);
+		return false;
+	}
+
+	return atomic_sub_and_test(IO_ZCTAP_UREF, &buf->refcount);
+}
+
+/* gets a user-supplied buffer from the fill queue */
+static struct io_zctap_buf *io_zctap_get_buffer(struct io_zctap_ifq *ifq)
+{
+	struct io_kiocb req = {
+		.ctx = ifq->ctx,
+		.buf_index = ifq->fill_bgid,
+	};
+	struct io_mapped_ubuf *imu;
+	struct io_zctap_buf *buf;
+	struct ifq_region *ifr;
+	size_t len;
+	u64 addr;
+	int pgid;
+
+	len = 0;
+	ifr = ifq->region;
+	imu = ifr->imu;
+
+	/*  IN: uses buf_index as buffer group.
+	 * OUT: buf_index of actual buffer. (and req->buf_list set)
+	 *	(this comes from the user-supplied bufid)
+	 */
+	addr = io_zctap_buffer(&req, &len);
+	if (!addr)
+		goto fail;
+
+	if (addr < imu->ubuf || addr + len > imu->ubuf_end)
+		goto fail;
+
+	pgid = (addr - imu->ubuf) >> PAGE_SHIFT;
+
+	/* optimize here by passing in addr as <region>:<pgid> */
+	/* assume region == ifq->region */
+
+	buf = &ifr->buf[pgid];
+
+	if (!io_zctap_put_buf_uref(buf)) {
+		/* XXX add retry handling. */
+		WARN_RATELIMIT(1, "buffer %d still has nonzero refcount\n",
+				pgid);
+		return NULL;
+	}
+
+	return buf;
+
+fail:
+	/* warn and just drop buffer */
+	WARN_RATELIMIT(1, "buffer addr %llx invalid", addr);
+	return NULL;
+}
+
+static void io_zctap_recycle_buf(struct ifq_region *ifr,
+				 struct io_zctap_buf *buf)
+{
+	spin_lock(&ifr->freelist_lock);
+
+	ifr->freelist[ifr->count++] = buf;
+
+	spin_unlock(&ifr->freelist_lock);
+}
+
+/* returns with undefined refcount */
 struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq)
 {
-	return NULL;
+	struct ifq_region *ifr = ifq->region;
+	struct io_zctap_buf *buf;
+
+	spin_lock(&ifr->freelist_lock);
+
+	buf = NULL;
+	if (ifr->count)
+		buf = ifr->freelist[--ifr->count];
+
+	spin_unlock(&ifr->freelist_lock);
+
+	if (!buf)
+		/* XXX locking! */
+		return io_zctap_get_buffer(ifq);
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
 
@@ -157,6 +261,7 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 		return -ENOMEM;
 	}
 
+	spin_lock_init(&ifr->freelist_lock);
 	ifr->nr_pages = nr_pages;
 	ifr->imu = imu;
 	ifr->count = nr_pages;
-- 
2.30.2

