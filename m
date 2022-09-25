Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6D35E95EC
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 22:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIYUdi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 16:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiIYUdg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 16:33:36 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC872C13E
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 13:33:34 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220925203329epoutp029084333cf3773364a37041ca3b890aaf~YNLP8neUT0567205672epoutp02j
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 20:33:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220925203329epoutp029084333cf3773364a37041ca3b890aaf~YNLP8neUT0567205672epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664138009;
        bh=2f95MMw1JaP2a2qx6h2pgrT8vnSnYyP4Ul8WVop1exo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxkcOJRPKdl4Hw5sowp5AwClo67EuzscUq+ivGfdxM25QL6X1ttvwzFUbF2W2nVHI
         1uchF741E/NtYvivnzxbFe3t/M/jb8aNyrTEjVyWEY8y0Y9PP4BKY7BwdaafXW2C26
         L8bEtg37qpeMQ16Ohd7crn62++Hc6OeLiQqVFsz4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220925203328epcas5p272f03be1bd4a725a19d4a0447d21e384~YNLO7DXy02718327183epcas5p2F;
        Sun, 25 Sep 2022 20:33:28 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MbHdy1z8yz4x9Pt; Sun, 25 Sep
        2022 20:33:26 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.9F.26992.61BB0336; Mon, 26 Sep 2022 05:33:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203325epcas5p1e4e89d414aa7a268a6e526d3c7c2261c~YNLL2KP0I3207732077epcas5p1l;
        Sun, 25 Sep 2022 20:33:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220925203325epsmtrp2abb15881af91734ea6cb3f05afb52c10~YNLLyqxom1586315863epsmtrp2H;
        Sun, 25 Sep 2022 20:33:25 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-1e-6330bb16d009
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.11.14392.51BB0336; Mon, 26 Sep 2022 05:33:25 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203323epsmtip1bde5755fe210b4f0ce7d269315bdc744~YNLJ3O0fn0205902059epsmtip1H;
        Sun, 25 Sep 2022 20:33:23 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v9 2/7] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Mon, 26 Sep 2022 01:52:59 +0530
Message-Id: <20220925202304.28097-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220925202304.28097-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42LZdlhTU1dst0GywZF+LoumCX+ZLVbf7Wez
        uHlgJ5PFytVHmSzetZ5jsTj6/y2bxaRD1xgt9t7Stpi/7Cm7A6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjOOLJlImPBR9GK279msTUwfhfsYuTkkBAwkXj/7y9rFyMXh5DAbkaJ
        Q7/vMkI4nxgl/k5pYYZwvjFKzD3znAmm5dnVZqiqvYwSW/42Q1V9ZpTYdOM/WxcjBwebgKbE
        hcmlIA0iAkYS+z+dBNvBDLLj7Y1GdpCEsECMxKnJT9hAbBYBVYkT2y+zgPTyClhIHO9lgVgm
        LzHz0newck4BS4knc7cyg9i8AoISJ2c+AathBqpp3job7AYJgb/sEnd3ToFqdpF4vHAnM4Qt
        LPHq+BZ2CFtK4vO7vWwQdrLEpZnnoD4rkXi85yCUbS/ReqqfGeQeZqBf1u/Sh9jFJ9H7+wkT
        SFhCgFeio00IolpR4t6kp6wQtrjEwxlLoGwPiTnXvrFBgqeHUeL8n5mMExjlZyF5YRaSF2Yh
        bFvAyLyKUTK1oDg3PbXYtMAwL7UcHrHJ+bmbGMEpU8tzB+PdBx/0DjEycTAeYpTgYFYS4U25
        qJssxJuSWFmVWpQfX1Sak1p8iNEUGMQTmaVEk/OBSTuvJN7QxNLAxMzMzMTS2MxQSZx38Qyt
        ZCGB9MSS1OzU1ILUIpg+Jg5OqQamtV879h9w27Sn+VzMnKadp2cUvu9dknqBhVWm8ZvNti0R
        xsrb3tpwt+kXzSnOCJnxW3RXxEum7mjTORUOdX7lyxivvZo1LV/Y3VDZ9t3cS9fO8UwV/ljA
        tUmiwbXh/NN6t0XVom7N8xLzXR/9F3w94e7y9s375t1cVbFuoaIn5x7v7rQHswwdH13TqpXy
        uWv7p7E3R+2jwJF7cnbLLvbcuusfOLVwp1rMqj2VPdPiLC/mT9n424ftrLECV9G02s2b0pxt
        fhZYzdIRK7X7pVnjFPKxyOfIngVi36xLm5Plyoxdt//JXLvA7Mvcaeopu7MkLA6872RdVaGo
        I+mhJPv6ujvzNLH/5ir+4t8Np29RYinOSDTUYi4qTgQAzknYqiIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnK7oboNkg3MfJC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJVxZMtExoKPohW3f81ia2D8LtjFyMkhIWAi
        8exqM2MXIxeHkMBuRonZj9pYIBLiEs3XfrBD2MISK/89Z4co+sgosWxpG3MXIwcHm4CmxIXJ
        pSA1IgJmEksPr2EBqWEWOMgocfnZE7BBwgJREu9W72EFsVkEVCVObL/MAtLLK2AhcbwXape8
        xMxL38F2cQpYSjyZuxVsvBBQydbzWiBhXgFBiZMzISYyA5U3b53NPIFRYBaS1CwkqQWMTKsY
        JVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYJDXUtzB+P2VR/0DjEycTAeYpTgYFYS4U25
        qJssxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA5NMYdzX
        IgEty1+Gv+xVQlqybnyb9ezbeYaTp+RnByWUvup+di93xbPSnZphOu0qd94LnPl10VyfQy2H
        TWmKwcWYI7suMuxL5Np+tGGjUI9xkVIT36bVYeKCJziOiXdM71Ay/t/jW7ZJ4b8469bkFw/L
        9EvW3cvfE5LscMXd67uWvPCEOkHj8tTVbInMD6fVOukEC6jb9emt3rTsnHztB7m1Bz+E3eZm
        52RcNTXqz+nF5x/XP7umsu9R1jQ76+gIk8UvanbkrujxLCjL/PRLtlJhfX/hqnOnTc34/ojP
        mbzn84ZdbLnT86S+aPbX6R/d/nFvxLf+rE1nrj/M+Sg5sfgUywMPlvKrKley2TYySSmxFGck
        GmoxFxUnAgAKCEB35AIAAA==
X-CMS-MailID: 20220925203325epcas5p1e4e89d414aa7a268a6e526d3c7c2261c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220925203325epcas5p1e4e89d414aa7a268a6e526d3c7c2261c
References: <20220925202304.28097-1-joshi.k@samsung.com>
        <CGME20220925203325epcas5p1e4e89d414aa7a268a6e526d3c7c2261c@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add IORING_URING_CMD_FIXED flag that is to be used for sending io_uring
command with previously registered buffers. User-space passes the buffer
index in sqe->buf_index, same as done in read/write variants that uses
fixed buffers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h      |  2 +-
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/uring_cmd.c          | 16 +++++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 1dbf51115c30..e10c5cc81082 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -28,7 +28,7 @@ struct io_uring_cmd {
 		void *cookie;
 	};
 	u32		cmd_op;
-	u32		pad;
+	u32		flags;
 	u8		pdu[32]; /* available inline for free use */
 };
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92f29d9505a6..ab7458033ee3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -56,6 +56,7 @@ struct io_uring_sqe {
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
 		__u32		msg_ring_flags;
+		__u32		uring_cmd_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -219,6 +220,14 @@ enum io_uring_op {
 	IORING_OP_LAST,
 };
 
+/*
+ * sqe->uring_cmd_flags
+ * IORING_URING_CMD_FIXED	use registered buffer; pass thig flag
+ *				along with setting sqe->buf_index.
+ */
+#define IORING_URING_CMD_FIXED	(1U << 0)
+
+
 /*
  * sqe->fsync_flags
  */
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 6a6d69523d75..faefa9f6f259 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -4,6 +4,7 @@
 #include <linux/file.h>
 #include <linux/io_uring.h>
 #include <linux/security.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -77,8 +78,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	if (sqe->rw_flags || sqe->__pad1)
+	if (sqe->__pad1)
 		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		req->buf_index = READ_ONCE(sqe->buf_index);
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
-- 
2.25.1

