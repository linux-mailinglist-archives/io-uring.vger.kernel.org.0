Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8066208C4
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiKHFFn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiKHFFj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:39 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE5117A91
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:38 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A80CG6p029458
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:37 -0800
Received: from maileast.thefacebook.com ([163.114.130.3])
        by m0001303.ppops.net (PPS) with ESMTPS id 3kqcc5hm0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:37 -0800
Received: from twshared13940.35.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:36 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 05B0023B26013; Mon,  7 Nov 2022 21:05:22 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 06/15] io_uring: Provide driver API for zctap packet buffers.
Date:   Mon, 7 Nov 2022 21:05:12 -0800
Message-ID: <20221108050521.3198458-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Nkd2yl1HRKXUjHlPF4m3jhaL8vjEpxLh
X-Proofpoint-GUID: Nkd2yl1HRKXUjHlPF4m3jhaL8vjEpxLh
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

Introduce 'struct io_zctap_buf', representing a buffer used by
the network drivers, and the get/put functions which are used
by the network driver to obtain the buffers.

The code for these will be fleshed out in a following patch.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring.h | 47 ++++++++++++++++++++++++++++++++++++++++
 io_uring/zctap.c         | 23 ++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 43bc8a2edccf..97c1a2e37077 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -32,6 +32,13 @@ struct io_uring_cmd {
 	u8		pdu[32]; /* available inline for free use */
 };
 
+struct io_zctap_buf {
+	dma_addr_t	dma;
+	struct page	*page;
+	atomic_t	refcount;
+	u8		_pad[4];
+};
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
@@ -44,6 +51,21 @@ void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
 
+struct io_zctap_ifq;
+struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc);
+void io_zctap_put_buf(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf);
+void io_zctap_put_buf_refs(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf,
+			   unsigned count);
+bool io_zctap_put_page(struct io_zctap_ifq *ifq, struct page *page);
+
+static inline dma_addr_t io_zctap_buf_dma(struct io_zctap_buf *buf)
+{
+	return buf->dma;
+}
+static inline struct page *io_zctap_buf_page(struct io_zctap_buf *buf)
+{
+	return buf->page;
+}
 static inline void io_uring_files_cancel(void)
 {
 	if (current->io_uring) {
@@ -92,6 +114,31 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline dma_addr_t io_zctap_buf_dma(struct io_zctap_buf *buf)
+{
+	return 0;
+}
+static inline struct page *io_zctap_buf_page(struct io_zctap_buf *buf)
+{
+	return NULL;
+}
+static inline struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq,
+						    int refc)
+{
+	return NULL;
+}
+void io_zctap_put_buf(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf)
+{
+}
+void io_zctap_put_buf_refs(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf,
+			   unsigned count)
+{
+}
+bool io_zctap_put_page(struct io_zctap_ifq *ifq, struct page *page)
+{
+	return false;
+}
+
 #endif
 
 #endif
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 7426feee1e04..69a04de87f8f 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -37,6 +37,29 @@ static u64 zctap_mk_page_info(u16 region_id, u16 pgid)
 	return (u64)0xface << 48 | (u64)region_id << 16 | (u64)pgid;
 }
 
+struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(io_zctap_get_buf);
+
+void io_zctap_put_buf(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf)
+{
+}
+EXPORT_SYMBOL(io_zctap_put_buf);
+
+void io_zctap_put_buf_refs(struct io_zctap_ifq *ifq, struct io_zctap_buf *buf,
+			   unsigned count)
+{
+}
+EXPORT_SYMBOL(io_zctap_put_buf_refs);
+
+bool io_zctap_put_page(struct io_zctap_ifq *ifq, struct page *page)
+{
+	return false;
+}
+EXPORT_SYMBOL(io_zctap_put_page);
+
 static void io_remove_ifq_region(struct ifq_region *ifr)
 {
 	struct io_mapped_ubuf *imu;
-- 
2.30.2

