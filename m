Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E815F7F97
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJGVR3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiJGVR2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:17:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906502B60B
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:17:17 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I3rgq026075
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:17:17 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k2807yh8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:17:17 -0700
Received: from twshared3028.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:17:16 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 594C721DAFD9C; Fri,  7 Oct 2022 14:17:13 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC v1 3/9] io_uring: add register ifq opcode
Date:   Fri, 7 Oct 2022 14:17:07 -0700
Message-ID: <20221007211713.170714-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007211713.170714-1-jonathan.lemon@gmail.com>
References: <20221007211713.170714-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GV2cLDcAdRU-xvFMTpwmVhI2jRqmzQPh
X-Proofpoint-GUID: GV2cLDcAdRU-xvFMTpwmVhI2jRqmzQPh
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

Add initial support for support for hooking in zero-copy interface
queues to io_uring.  This command requests a user-managed queue
from the specified network device.

This only includes the register opcode, unregistration is currently
done implicitly when the ring is removed.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/linux/io_uring.h |  14 ++++
 io_uring/Makefile             |   3 +-
 io_uring/io_uring.c           |  10 +++
 io_uring/zctap.c              | 146 ++++++++++++++++++++++++++++++++++
 io_uring/zctap.h              |  11 +++
 5 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/zctap.c
 create mode 100644 io_uring/zctap.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6b83177fd41d..bc5108d65c0a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -473,6 +473,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* register a network ifq for zerocopy RX */
+	IORING_REGISTER_IFQ			= 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -649,6 +652,17 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+/*
+ * Argument for IORING_REGISTER_IFQ
+ */
+struct io_uring_ifq_req {
+	__u32	ifindex;
+	__u16	queue_id;
+	__u16	ifq_id;
+	__u16	fill_bgid;
+	__u16	__pad[3];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 8cc8e5387a75..9d87e2e45ef9 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o \
+					notif.o zctap.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b9640ad5069f..8dd988b33af0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -91,6 +91,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "zctap.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -321,6 +322,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	xa_init(&ctx->zctap_ifq_xa);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2639,6 +2641,8 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
+	xa_for_each(&ctx->zctap_ifq_xa, index, creds)
+		io_unregister_zctap_ifq(ctx, index);
 	if (ctx->rings)
 		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
@@ -3839,6 +3843,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_IFQ:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_ifq(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zctap.c b/io_uring/zctap.c
new file mode 100644
index 000000000000..41feb76b7a35
--- /dev/null
+++ b/io_uring/zctap.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/io_uring.h>
+#include <linux/netdevice.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "zctap.h"
+
+static DEFINE_XARRAY_ALLOC1(io_zctap_ifq_xa);
+
+typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+
+static int __io_queue_mgmt(struct net_device *dev, struct io_zctap_ifq *ifq,
+			   u16 *queue_id)
+{
+	struct netdev_bpf cmd;
+	bpf_op_t ndo_bpf;
+	int err;
+
+	ndo_bpf = dev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return -EINVAL;
+
+	cmd.command = XDP_SETUP_ZCTAP;
+	cmd.zct.ifq = ifq;
+	cmd.zct.queue_id = *queue_id;
+
+	err = ndo_bpf(dev, &cmd);
+	if (!err)
+		*queue_id = cmd.zct.queue_id;
+
+	return err;
+}
+
+static int io_open_zctap_ifq(struct io_zctap_ifq *ifq, u16 *queue_id)
+{
+	return __io_queue_mgmt(ifq->dev, ifq, queue_id);
+}
+
+static int io_close_zctap_ifq(struct io_zctap_ifq *ifq, u16 queue_id)
+{
+	return __io_queue_mgmt(ifq->dev, NULL, &queue_id);
+}
+
+static struct io_zctap_ifq *io_zctap_ifq_alloc(void)
+{
+	struct io_zctap_ifq *ifq;
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	if (!ifq)
+		return NULL;
+
+	ifq->queue_id = -1;
+	return ifq;
+}
+
+static void io_zctap_ifq_free(struct io_zctap_ifq *ifq)
+{
+	if (ifq->queue_id != -1)
+		io_close_zctap_ifq(ifq, ifq->queue_id);
+	if (ifq->dev)
+		dev_put(ifq->dev);
+	if (ifq->id)
+		xa_erase(&io_zctap_ifq_xa, ifq->id);
+	kfree(ifq);
+}
+
+int io_register_ifq(struct io_ring_ctx *ctx,
+		    struct io_uring_ifq_req __user *arg)
+{
+	struct io_uring_ifq_req req;
+	struct io_zctap_ifq *ifq;
+	int id, err;
+
+	if (copy_from_user(&req, arg, sizeof(req)))
+		return -EFAULT;
+
+	ifq = io_zctap_ifq_alloc();
+	if (!ifq)
+		return -ENOMEM;
+	ifq->ctx = ctx;
+	ifq->fill_bgid = req.fill_bgid;
+
+	err = -ENODEV;
+	ifq->dev = dev_get_by_index(&init_net, req.ifindex);
+	if (!ifq->dev)
+		goto out;
+
+	err = io_open_zctap_ifq(ifq, &req.queue_id);
+	if (err)
+		goto out;
+	ifq->queue_id = req.queue_id;
+
+	/* aka idr */
+	err = xa_alloc(&io_zctap_ifq_xa, &id, ifq,
+		       XA_LIMIT(1, PAGE_SIZE - 1), GFP_KERNEL);
+	if (err)
+		goto out;
+	ifq->id = id;
+	req.ifq_id = id;
+
+	err = xa_err(xa_store(&ctx->zctap_ifq_xa, id, ifq, GFP_KERNEL));
+	if (err)
+		goto out;
+
+	if (copy_to_user(arg, &req, sizeof(req))) {
+		xa_erase(&ctx->zctap_ifq_xa, id);
+		err = -EFAULT;
+		goto out;
+	}
+
+	return 0;
+
+out:
+	io_zctap_ifq_free(ifq);
+	return err;
+}
+
+int io_unregister_zctap_ifq(struct io_ring_ctx *ctx, unsigned long index)
+{
+	struct io_zctap_ifq *ifq;
+
+	ifq = xa_erase(&ctx->zctap_ifq_xa, index);
+	if (!ifq)
+		return -EINVAL;
+
+	io_zctap_ifq_free(ifq);
+	return 0;
+}
+
+int io_unregister_ifq(struct io_ring_ctx *ctx,
+		      struct io_uring_ifq_req __user *arg)
+{
+	struct io_uring_ifq_req req;
+
+	if (copy_from_user(&req, arg, sizeof(req)))
+		return -EFAULT;
+
+	return io_unregister_zctap_ifq(ctx, req.ifq_id);
+}
diff --git a/io_uring/zctap.h b/io_uring/zctap.h
new file mode 100644
index 000000000000..bda15d218fe3
--- /dev/null
+++ b/io_uring/zctap.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ZCTAP_H
+#define IOU_ZCTAP_H
+
+int io_register_ifq(struct io_ring_ctx *ctx,
+		    struct io_uring_ifq_req __user *arg);
+int io_unregister_ifq(struct io_ring_ctx *ctx,
+		      struct io_uring_ifq_req __user *arg);
+int io_unregister_zctap_ifq(struct io_ring_ctx *ctx, unsigned long index);
+
+#endif
-- 
2.30.2

