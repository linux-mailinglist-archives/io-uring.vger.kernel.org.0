Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB025F7F9B
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJGVRc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJGVR3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EBB3743C
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:17 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I5hq9008393
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:17 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k26gy8673-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:17 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub204.TheFacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:17 -0700
Received: from twshared3028.05.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:16 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 8221E21DAFDA6; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 8/9] io_uring: provide functions for the page_pool.
Date:   Fri, 7 Oct 2022 14:17:12 -0700
Message-ID: <20221007211713.170714-9-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: BEUKy5UjV6T0kxidTWmue8cH7J_O407D
X-Proofpoint-ORIG-GUID: BEUKy5UjV6T0kxidTWmue8cH7J_O407D
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

These functions are called by the page_pool, in order to refill
the pool with user-supplied pages, or returning excess pages back
from the pool.

If no pages are present in the region cache, then an attempt is
made to obtain more pages from the interface fill queue.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring.h | 24 ++++++++++++
 io_uring/kbuf.c          | 13 +++++++
 io_uring/kbuf.h          |  2 +
 io_uring/zctap.c         | 82 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 121 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 4a2f6cc5a492..b92e65e0a469 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -37,6 +37,14 @@ void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
 
+struct io_zctap_ifq;
+struct page *io_zctap_ifq_get_page(struct io_zctap_ifq *ifq,
+                                   unsigned int order);
+unsigned long io_zctap_ifq_get_bulk(struct io_zctap_ifq *ifq,
+                                    unsigned long nr_pages,
+                                    struct page **page_array);
+bool io_zctap_ifq_put_page(struct io_zctap_ifq *ifq, struct page *page);
+
 static inline void io_uring_files_cancel(void)
 {
 	if (current->io_uring) {
@@ -80,6 +88,22 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline struct page *io_zctap_ifq_get_page(struct io_zctap_ifq *ifq,
+                                   unsigned int order)
+{
+	return NULL;
+}
+sttaic unsigned long io_zctap_ifq_get_bulk(struct io_zctap_ifq *ifq,
+                                    unsigned long nr_pages,
+                                    struct page **page_array)
+{
+	return 0;
+}
+bool io_zctap_ifq_put_page(struct io_zctap_ifq *ifq, struct page *page)
+{
+	return false;
+}
+
 #endif
 
 #endif
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
index 746fbf31a703..1379e0e9f870 100644
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
index 9db3421fb9fa..8bebe7c36c82 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -311,3 +311,85 @@ int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags)
 
 	return -EEXIST;
 }
+
+/* gets a user-supplied buffer from the fill queue */
+static struct page *io_zctap_get_buffer(struct io_zctap_ifq *ifq)
+{
+	struct io_kiocb req = {
+		.ctx = ifq->ctx,
+		.buf_index = ifq->fill_bgid,
+	};
+	struct io_mapped_ubuf *imu;
+	struct ifq_region *ifr;
+	size_t len;
+	u64 addr;
+	int idx;
+
+	len = 0;
+	ifr = ifq->region;
+	imu = ifr->imu;
+
+	addr = io_zctap_buffer(&req, &len);
+	if (!addr)
+		goto fail;
+
+	/* XXX poor man's implementation of io_import_fixed */
+
+	if (addr < ifr->start || addr + len > ifr->end)
+		goto fail;
+
+	idx = (addr - ifr->start) >> PAGE_SHIFT;
+
+	return imu->bvec[ifr->imu_idx + idx].bv_page;
+
+fail:
+	/* warn and just drop buffer */
+	WARN_RATELIMIT(1, "buffer addr %llx invalid", addr);
+	return NULL;
+}
+
+struct page *io_zctap_ifq_get_page(struct io_zctap_ifq *ifq,
+				   unsigned int order)
+{
+	struct ifq_region *ifr = ifq->region;
+
+	if (WARN_RATELIMIT(order != 1, "order %d", order))
+		return NULL;
+
+	if (ifr->count)
+		return ifr->page[--ifr->count];
+
+	return io_zctap_get_buffer(ifq);
+}
+
+unsigned long io_zctap_ifq_get_bulk(struct io_zctap_ifq *ifq,
+				    unsigned long nr_pages,
+				    struct page **page_array)
+{
+	struct ifq_region *ifr = ifq->region;
+	int count;
+
+	count = min_t(unsigned long, nr_pages, ifr->count);
+	if (count) {
+		ifr->count -= count;
+		memcpy(page_array, &ifr->page[ifr->count],
+		       count * sizeof(struct page *));
+	}
+
+	return count;
+}
+
+bool io_zctap_ifq_put_page(struct io_zctap_ifq *ifq, struct page *page)
+{
+	struct ifq_region *ifr = ifq->region;
+
+	/* if page is not usermapped, then throw an error */
+
+	/* sanity check - leak pages here if hit */
+	if (WARN_RATELIMIT(ifr->count >= ifr->nr_pages, "page overflow"))
+		return true;
+
+	ifr->page[ifr->count++] = page;
+
+	return true;
+}
-- 
2.30.2

