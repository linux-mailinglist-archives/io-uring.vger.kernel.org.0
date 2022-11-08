Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E206208C6
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 06:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiKHFFp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 8 Nov 2022 00:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiKHFFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 00:05:41 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F6913DC2
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 21:05:39 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7LKpss010010
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 21:05:39 -0800
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knq54wajv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 21:05:39 -0800
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 21:05:37 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 46E1F23B26025; Mon,  7 Nov 2022 21:05:22 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [PATCH v1 15/15] io_uring: Notify the application as the fillq is drained.
Date:   Mon, 7 Nov 2022 21:05:21 -0800
Message-ID: <20221108050521.3198458-16-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: t0aHdp26enFR9ERwmHglAucZKqu-VipG
X-Proofpoint-GUID: t0aHdp26enFR9ERwmHglAucZKqu-VipG
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

Userspace maintains a free count of space available in the fillq,
and only returns entries based on the available space.  As the
kernel removes these entries, it needs to notify the application
so more buffers can be queued.

Only one outstanding notifier per queue is used, and it provides
the most recent count of entries removed from the queue.

Also post a notifier when the NIC is unable to obtain any buffers.
When this happens, the NIC may just drop packets or stall.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 io_uring/zctap.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/io_uring/zctap.c b/io_uring/zctap.c
index c7897fe2ccf6..e6c7ed85d4ee 100644
--- a/io_uring/zctap.c
+++ b/io_uring/zctap.c
@@ -15,6 +15,7 @@
 #include "zctap.h"
 #include "rsrc.h"
 #include "kbuf.h"
+#include "refs.h"
 
 #define NR_ZCTAP_IFQS	1
 
@@ -26,7 +27,9 @@ struct ifq_region {
 	int			cache_count;
 	int			free_count;
 	int			nr_pages;
+	int			taken;
 	u16			id;
+	bool			empty;
 
 	spinlock_t		freelist_lock;
 	struct delayed_work	release_work;
@@ -44,8 +47,14 @@ struct ifq_region {
 struct io_zctap_ifq_priv {
 	struct io_zctap_ifq	ifq;
 	struct ubuf_info	uarg;
+	struct io_kiocb		req;
 };
 
+static struct io_kiocb *io_zctap_ifq_notifier(struct io_zctap_ifq *ifq)
+{
+	return &((struct io_zctap_ifq_priv *)ifq)->req;
+}
+
 static void io_zctap_ifq_put(struct io_zctap_ifq *ifq);
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
@@ -131,6 +140,34 @@ static void io_zctap_recycle_buf(struct ifq_region *ifr,
 	}
 }
 
+struct io_zctap_notif {
+	struct file *file;
+	u64 udata;
+	int res;
+	int cflags;
+};
+
+static void io_zctap_post_notify(struct io_kiocb *req, bool *locked)
+{
+	struct io_zctap_notif *n = io_kiocb_to_cmd(req, struct io_zctap_notif);
+
+	io_post_aux_cqe(req->ctx, n->udata,  n->res, n->cflags, true);
+	io_req_task_complete(req, locked);
+}
+
+static void io_zctap_notify(struct io_kiocb *req, int bgid, int count)
+{
+	struct io_zctap_notif *n = io_kiocb_to_cmd(req, struct io_zctap_notif);
+
+	n->udata = 0xface0000;		/* XXX */
+	n->res = (bgid << 16) | count;
+	n->cflags = IORING_CQE_F_BUFFER|IORING_CQE_F_NOTIF;
+
+	req_ref_get(req);
+	req->io_task_work.func = io_zctap_post_notify;
+	io_req_task_work_add(req);
+}
+
 /* gets a user-supplied buffer from the fill queue
  *   note: may drain N entries, but still have no usable buffers
  *   XXX add retry limit?
@@ -159,6 +196,7 @@ static struct io_zctap_buf *io_zctap_get_buffer(struct io_zctap_ifq *ifq,
 	if (!addr)
 		return NULL;
 
+	ifr->taken++;
 	pgid = addr & 0xffff;
 	region_id = (addr >> 16) & 0xffff;
 	if (region_id) {
@@ -196,6 +234,7 @@ struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
 {
 	struct io_zctap_buf *buf;
 	struct ifq_region *ifr;
+	struct io_kiocb *req;
 	int count;
 	u16 pgid;
 
@@ -218,6 +257,12 @@ struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
 	count = io_zctap_get_buffers(ifq, ifr->cache, REGION_REFILL_COUNT);
 	ifr->cache_count += count;
 
+	req = io_zctap_ifq_notifier(ifq);
+	if (ifr->taken && atomic_read(&req->refs) == 1) {
+		io_zctap_notify(req, ifq->fill_bgid, ifr->taken);
+		ifr->taken = 0;
+	}
+
 	if (ifr->cache_count)
 		goto out;
 
@@ -234,11 +279,17 @@ struct io_zctap_buf *io_zctap_get_buf(struct io_zctap_ifq *ifq, int refc)
 	if (ifr->cache_count)
 		goto out;
 
+	if (!ifr->empty && atomic_read(&req->refs) == 1) {
+		io_zctap_notify(req, ifq->fill_bgid, 0);
+		ifr->empty = true;
+	}
+
 	return NULL;
 
 out:
 	pgid = ifr->cache[--ifr->cache_count];
 	buf = &ifr->buf[pgid];
+	ifr->empty = false;
 
 	WARN_RATELIMIT(atomic_read(&buf->refcount),
 		       "pgid:%d refc:%d cache_count:%d\n",
@@ -445,6 +496,8 @@ int io_provide_ifq_region(struct io_zctap_ifq *ifq, u16 id)
 	ifr->id = id;
 	ifr->ifq = ifq;
 	ifr->delay_end = 0;
+	ifr->taken = 0;
+	ifr->empty = false;
 	ifr->cache_count = 0;
 
 	err = io_zctap_map_region(ifr, imu);
@@ -533,6 +586,11 @@ static struct io_zctap_ifq *io_zctap_ifq_alloc(struct io_ring_ctx *ctx)
 	priv->ifq.ctx = ctx;
 	priv->ifq.queue_id = -1;
 	priv->ifq.uarg = &priv->uarg;
+
+	priv->req.ctx = ctx;
+	priv->req.task = current;
+	io_req_set_refcount(&priv->req);
+
 	return &priv->ifq;
 }
 
-- 
2.30.2

