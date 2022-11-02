Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904346172D8
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiKBXkQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 2 Nov 2022 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiKBXj4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:56 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D5B2AEB
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:32:59 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVql7014628
        for <io-uring@vger.kernel.org>; Wed, 2 Nov 2022 16:32:58 -0700
Received: from maileast.thefacebook.com ([163.114.130.3])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkva13p5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 16:32:58 -0700
Received: from twshared9088.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:32:57 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 7A8AC235B6175; Wed,  2 Nov 2022 16:32:44 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
CC:     <kernel-team@meta.com>
Subject: [RFC PATCH v3 03/15] io_uring: add register ifq opcode
Date:   Wed, 2 Nov 2022 16:32:32 -0700
Message-ID: <20221102233244.4022405-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
References: <20221102233244.4022405-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: mA0lnUEowPbdkves5WIBFqTSqava6VDQ
X-Proofpoint-ORIG-GUID: mA0lnUEowPbdkves5WIBFqTSqava6VDQ
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

Add initial support for support for hooking in zero-copy interface
queues to io_uring.  This command requests a user-managed queue
from the specified network device.

This only includes the register opcode, unregistration is currently
done implicitly when the ring is removed.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/linux/io_uring.h |  15 ++++
 io_uring/Makefile             |   3 +-
 io_uring/io_uring.c           |   8 +++
 io_uring/zctap.c              | 131 ++++++++++++++++++++++++++++++++++
 io_uring/zctap.h              |   9 +++
 5 files changed, 165 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/zctap.c
 create mode 100644 io_uring/zctap.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ab7458033ee3..3e8375b25a84 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -490,6 +490,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* register a network ifq for zerocopy RX */
+	IORING_REGISTER_IFQ			= 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -666,6 +669,18 @@ struct io_uring_recvmsg_out {
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
+	__u16	region_id;
+	__u16	__pad[2];
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
index 6cc16e39b27f..a9ed288f4b74 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -91,6 +91,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "zctap.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2800,6 +2801,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
+	io_unregister_zctap_all(ctx);
 	if (ctx->rings)
 		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
@@ -4032,6 +4034,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 000000000000..295505c2b1ed
--- /dev/null
+++ b/io_uring/zctap.c
@@ -0,0 +1,131 @@
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
+#define NR_ZCTAP_IFQS	1
+
+typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+
+static int __io_queue_mgmt(struct net_device *dev, struct io_zctap_ifq *ifq,
+			   u16 queue_id)
+{
+	struct netdev_bpf cmd;
+	bpf_op_t ndo_bpf;
+
+	ndo_bpf = dev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return -EINVAL;
+
+	cmd.command = XDP_SETUP_ZCTAP;
+	cmd.zct.ifq = ifq;
+	cmd.zct.queue_id = queue_id;
+
+	return ndo_bpf(dev, &cmd);
+}
+
+static int io_open_zctap_ifq(struct io_zctap_ifq *ifq, u16 queue_id)
+{
+	return __io_queue_mgmt(ifq->dev, ifq, queue_id);
+}
+
+static int io_close_zctap_ifq(struct io_zctap_ifq *ifq, u16 queue_id)
+{
+	return __io_queue_mgmt(ifq->dev, NULL, queue_id);
+}
+
+static struct io_zctap_ifq *io_zctap_ifq_alloc(struct io_ring_ctx *ctx)
+{
+	struct io_zctap_ifq *ifq;
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	if (!ifq)
+		return NULL;
+
+	ifq->ctx = ctx;
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
+	kfree(ifq);
+}
+
+int io_register_ifq(struct io_ring_ctx *ctx,
+		    struct io_uring_ifq_req __user *arg)
+{
+	struct io_uring_ifq_req req;
+	struct io_zctap_ifq *ifq;
+	int err;
+
+	if (copy_from_user(&req, arg, sizeof(req)))
+		return -EFAULT;
+
+	if (req.ifq_id >= NR_ZCTAP_IFQS)
+		return -EFAULT;
+
+	if (ctx->zctap_ifq)
+		return -EBUSY;
+
+	ifq = io_zctap_ifq_alloc(ctx);
+	if (!ifq)
+		return -ENOMEM;
+
+	ifq->fill_bgid = req.fill_bgid;
+
+	err = -ENODEV;
+	ifq->dev = dev_get_by_index(&init_net, req.ifindex);
+	if (!ifq->dev)
+		goto out;
+
+	/* region attachment TBD */
+
+	err = io_open_zctap_ifq(ifq, req.queue_id);
+	if (err)
+		goto out;
+	ifq->queue_id = req.queue_id;
+
+	ctx->zctap_ifq = ifq;
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
+	ifq = ctx->zctap_ifq;
+	if (!ifq)
+		return -EINVAL;
+
+	ctx->zctap_ifq = NULL;
+	io_zctap_ifq_free(ifq);
+
+	return 0;
+}
+
+void io_unregister_zctap_all(struct io_ring_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < NR_ZCTAP_IFQS; i++)
+		io_unregister_zctap_ifq(ctx, i);
+}
diff --git a/io_uring/zctap.h b/io_uring/zctap.h
new file mode 100644
index 000000000000..bbe4a509408b
--- /dev/null
+++ b/io_uring/zctap.h
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ZCTAP_H
+#define IOU_ZCTAP_H
+
+int io_register_ifq(struct io_ring_ctx *ctx,
+		    struct io_uring_ifq_req __user *arg);
+void io_unregister_zctap_all(struct io_ring_ctx *ctx);
+
+#endif
-- 
2.30.2

