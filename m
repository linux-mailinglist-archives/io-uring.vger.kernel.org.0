Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EAD5F7FA9
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJGVRf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiJGVRc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FD965660
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:26 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I5iKr027912
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:26 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k2hshchc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:26 -0700
Received: from twshared0933.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:24 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 60B2521DAFD9E; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 4/9] io_uring: add provide_ifq_region opcode
Date:   Fri, 7 Oct 2022 14:17:08 -0700
Message-ID: <20221007211713.170714-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DYxPHV_uMetLLjXnRm5_g-fD4QX0C33S
X-Proofpoint-GUID: DYxPHV_uMetLLjXnRm5_g-fD4QX0C33S
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

This opcode takes part or all of a memory region that was previously
registered with io_uring, and assigns it as the backing store for
the specified ifq.

The entire region is registered instead of providing individual
bufferrs, as this allows the hardware to select the optimal buffer
size for incoming packets.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 include/uapi/linux/io_uring.h  |  1 +
 io_uring/opdef.c               |  9 ++++
 io_uring/zctap.c               | 96 ++++++++++++++++++++++++++++++++++
 io_uring/zctap.h               |  4 ++
 5 files changed, 111 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 680fbf1f34e7..56257e8afd0a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -582,6 +582,7 @@ struct io_overflow_cqe {
 struct io_zctap_ifq {
 	struct net_device	*dev;
 	struct io_ring_ctx	*ctx;
+	void			*region;	/* XXX relocate? */
 	u16			queue_id;
 	u16			id;
 	u16			fill_bgid;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index bc5108d65c0a..3b392f8270dc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -206,6 +206,7 @@ enum io_uring_op {
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
+	IORING_OP_PROVIDE_IFQ_REGION,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c4dddd0fd709..bf28c43117c3 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -33,6 +33,7 @@
 #include "poll.h"
 #include "cancel.h"
 #include "rw.h"
+#include "zctap.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -488,6 +489,14 @@ const struct io_op_def io_op_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_PROVIDE_IFQ_REGION] = {
+		.audit_skip		= 1,
+		.iopoll			= 1,
+		.buffer_select		= 1,
+		.name			= "PROVIDE_IFQ_REGION",
+		.prep			= io_provide_ifq_region_prep,
+		.issue			= io_provide_ifq_region,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index 41feb76b7a35..728f7c938b7b 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -6,11 +6,14 @@
 #include <linux/mm.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
 #include "zctap.h"
+#include "rsrc.h"
+#include "kbuf.h"
 
 static DEFINE_XARRAY_ALLOC1(io_zctap_ifq_xa);
 
@@ -144,3 +147,96 @@ int io_unregister_ifq(struct io_ring_ctx *ctx,
 
 	return io_unregister_zctap_ifq(ctx, req.ifq_id);
 }
+
+struct io_ifq_region {
+	struct file		*file;
+	struct io_zctap_ifq	*ifq;
+	__u64			addr;
+	__u32			len;
+	__u32			bgid;
+};
+
+struct ifq_region {
+	struct io_mapped_ubuf	*imu;
+	u64			start;
+	u64			end;
+	int			count;
+	int			imu_idx;
+	int			nr_pages;
+	struct page		*page[];
+};
+
+int io_provide_ifq_region_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
+{
+	struct io_ifq_region *r = io_kiocb_to_cmd(req, struct io_ifq_region);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu;
+	u32 index;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return -EINVAL;
+
+	r->addr = READ_ONCE(sqe->addr);
+	r->len = READ_ONCE(sqe->len);
+	index = READ_ONCE(sqe->fd);
+
+	if (!r->addr || r->addr & ~PAGE_MASK)
+		return -EFAULT;
+
+	if (!r->len || r->len & ~PAGE_MASK)
+		return -EFAULT;
+
+	r->ifq = xa_load(&ctx->zctap_ifq_xa, index);
+	if (!r->ifq)
+		return -EFAULT;
+
+	/* XXX for now, only allow one region per ifq. */
+	if (r->ifq->region)
+		return -EFAULT;
+
+	if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+		return -EFAULT;
+	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+	imu = ctx->user_bufs[index];
+
+	if (r->addr < imu->ubuf || r->addr + r->len > imu->ubuf_end)
+		return -EFAULT;
+	req->imu = imu;
+
+	io_req_set_rsrc_node(req, ctx, 0);
+
+	return 0;
+}
+
+int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ifq_region *r = io_kiocb_to_cmd(req, struct io_ifq_region);
+	struct ifq_region *ifr;
+	int i, idx, nr_pages;
+	struct page *page;
+
+	nr_pages = r->len >> PAGE_SHIFT;
+	idx = (r->addr - req->imu->ubuf) >> PAGE_SHIFT;
+
+	ifr = kvmalloc(struct_size(ifr, page, nr_pages), GFP_KERNEL);
+	if (!ifr)
+		return -ENOMEM;
+
+
+	ifr->nr_pages = nr_pages;
+	ifr->imu_idx = idx;
+	ifr->count = nr_pages;
+	ifr->imu = req->imu;
+	ifr->start = r->addr;
+	ifr->end = r->addr + r->len;
+
+	for (i = 0; i < nr_pages; i++, idx++) {
+		page = req->imu->bvec[idx].bv_page;
+		ifr->page[i] = page;
+	}
+
+	WRITE_ONCE(r->ifq->region,  ifr);
+
+	return 0;
+}
diff --git a/io_uring/zctap.h b/io_uring/zctap.h
index bda15d218fe3..709c803220f4 100644
--- a/io_uring/zctap.h
+++ b/io_uring/zctap.h
@@ -8,4 +8,8 @@ int io_unregister_ifq(struct io_ring_ctx *ctx,
 		      struct io_uring_ifq_req __user *arg);
 int io_unregister_zctap_ifq(struct io_ring_ctx *ctx, unsigned long index);
 
+int io_provide_ifq_region_prep(struct io_kiocb *req,
+                               const struct io_uring_sqe *sqe);
+int io_provide_ifq_region(struct io_kiocb *req, unsigned int issue_flags);
+
 #endif
-- 
2.30.2

