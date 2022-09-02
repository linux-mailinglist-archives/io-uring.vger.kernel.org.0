Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C615AB577
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiIBPlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbiIBPki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:40:38 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C4C117AF4
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 08:27:16 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220902152713epoutp02544a97fc593b61c050ab7e0841a55be8~RFKRiC5Qx1990519905epoutp023
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 15:27:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220902152713epoutp02544a97fc593b61c050ab7e0841a55be8~RFKRiC5Qx1990519905epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662132433;
        bh=ILUq2T7fRPv/zyXJyrYGRvaMUuZi/T01H6Bp/bPmDLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xour01JLW402yXaBQesUwKQ7gAu/kE9L9I4rWAHkNMe2ThSJfkG+PzcnVpfQwnXlV
         OqmKa7fjGmbyi+D//4tMQH5a670sIhbM7wO7PdBAipW9wtjNF8RliKQk5GET6J3TCV
         aSC2Hf3QCXTitDPAYRrKQtXTdoCVoNzrbFWJGJk4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220902152712epcas5p3bf5152e4a7d9b5cf8d786e9838a44d9e~RFKQsK5uR3034430344epcas5p3Z;
        Fri,  2 Sep 2022 15:27:12 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MK1xB1cyzz4x9Pr; Fri,  2 Sep
        2022 15:27:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.30.53458.EC022136; Sat,  3 Sep 2022 00:27:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220902152709epcas5p1a1bd433cac6040c492e347edae484ca5~RFKN1imt_0055200552epcas5p1D;
        Fri,  2 Sep 2022 15:27:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220902152709epsmtrp15f5ed19d44ac026bc96949461a8797a2~RFKN0xagT2718227182epsmtrp1V;
        Fri,  2 Sep 2022 15:27:09 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-25-631220ce8276
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.2C.14392.DC022136; Sat,  3 Sep 2022 00:27:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220902152708epsmtip2537ab4f0b5bdcc8db11b244ba6923b73~RFKMQtYOf1851618516epsmtip2T;
        Fri,  2 Sep 2022 15:27:07 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v3 2/4] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Fri,  2 Sep 2022 20:46:55 +0530
Message-Id: <20220902151657.10766-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220902151657.10766-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmpu45BaFkgx+H2SyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM54NX0aS8FryYppL7ezNzD2iHYxcnJICJhIPDz6
        k72LkYtDSGA3o8S3ze0sEM4nRokJ93czQzjfGCU2f97GBtPy+clbqJa9jBLnJn9mAkkICXxm
        lHj+Sr6LkYODTUBT4sLkUpCwiICXxP3b71lB6plBVry90cgOkhAWiJH4OPEdI4jNIqAqsXZW
        L9gCXgELiQX/N7NALJOXmHnpO1g9p4ClxNOrb1ghagQlTs58AlbDDFTTvHU22KUSAp0cEs/P
        zWMDOUJCwEVizXZJiDnCEq+Ob2GHsKUkXva3QdnJEpdmnmOCsEskHu85CGXbS7Se6mcGGcMM
        9Mv6XfoQq/gken8/YYKYzivR0SYEUa0ocW/SU1YIW1zi4YwlrBAlHhJr1rtBQqqHUeLNnt3M
        ExjlZyF5YBaSB2YhLFvAyLyKUTK1oDg3PbXYtMAoL7UcHq3J+bmbGMEpVMtrB+PDBx/0DjEy
        cTAeYpTgYFYS4Z16WCBZiDclsbIqtSg/vqg0J7X4EKMpMIQnMkuJJucDk3heSbyhiaWBiZmZ
        mYmlsZmhkjjvFG3GZCGB9MSS1OzU1ILUIpg+Jg5OqQamnk8aquZslRd1KrzXKzeunBw9pWxK
        hfSO09/uWerV9Mq90o2etLjp20feMw8W7/K5ZnXWTrwgQD3omvO95Qp/bqdP51yvs3b7zEVX
        VuQfkGWZ9CN3obC7cv15prqknG3t3CIzg+pYmazvvMv+phFY93jDKgE7WYV/ARP2bzsdkeke
        0CSh+f1t17tEmb31okHn5vII3PCplb+wQbKkiCt5iZCM+tyKGzMOSbX8Vt98/KXk3oOONTO7
        dUSWqvPliR/+2CX++aNU0wT/hivbPL5oqsSEBq7eYq1dPM0sq3XpTOHrZXJKlz9x97sGnbj7
        a8sh3rtMbzccvFefdXKHmtyapwl/7301WXu7WmDJpMd/lFiKMxINtZiLihMBA59yUyoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSvO5ZBaFkg+XNahZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Ml5Nn8ZS8FqyYtrL7ewN
        jD2iXYycHBICJhKfn7xlB7GFBHYzSnw/VgwRF5dovvaDHcIWllj57zmQzQVU85FR4tnas6xd
        jBwcbAKaEhcml4LUiAgESBxsvAxWwyxwkFHi8rMnLCA1wgJREu+fV4DUsAioSqyd1csGYvMK
        WEgs+L+ZBWK+vMTMS9/BdnEKWEo8vfqGFeIeC4kdk3ZC1QtKnJz5BKyeGai+eets5gmMArOQ
        pGYhSS1gZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREc/lqaOxi3r/qgd4iRiYPx
        EKMEB7OSCO/UwwLJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgsky
        cXBKNTBNTzi0IrW899Cy+byPtG7Yc7A4bizg/J44Y5rXOdPIjsSYG5NXPt3HeODRDt0VO3Iu
        /Lktvml9tfif4lxJmdxcxov3Nlpv3nOnttErZq5m7M+EpYLNgfIvt8teX/7ANXf/s2QLaaPL
        P06K3bJ9tFpMMHLb5PNb4vM3qf82KL4TK/LqxUfmvyubzWxZpn3OszobmCkmyZe63UDtvEdo
        sepVv6nG+Y5bSrcF9TD8Vc16umb6n+712Ua6DLv33v2pMHMvv3vTyVkMs3YIt7PsWjLj4sw3
        FZ+8brlpz/iR+W/Get9tHuv9056az82e+oc13flIfOHU6H8imvPuLZl24+OlFRl3Xt7bdktn
        r5HmRa8PZ5VYijMSDbWYi4oTAX57DqzuAgAA
X-CMS-MailID: 20220902152709epcas5p1a1bd433cac6040c492e347edae484ca5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902152709epcas5p1a1bd433cac6040c492e347edae484ca5
References: <20220902151657.10766-1-joshi.k@samsung.com>
        <CGME20220902152709epcas5p1a1bd433cac6040c492e347edae484ca5@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 include/linux/io_uring.h      |  3 ++-
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/uring_cmd.c          | 18 +++++++++++++++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index dba6fb47aa6c..6ca633b88816 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -16,6 +16,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= 4,
 	IO_URING_F_CQE32		= 8,
 	IO_URING_F_IOPOLL		= 16,
+	IO_URING_F_FIXEDBUFS		= 32,
 };
 
 struct io_uring_cmd {
@@ -28,7 +29,7 @@ struct io_uring_cmd {
 		void *cookie;
 	};
 	u32		cmd_op;
-	u32		pad;
+	u32		flags;
 	u8		pdu[32]; /* available inline for free use */
 };
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 48e5c70e0baf..c80ce6912d8d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -56,6 +56,7 @@ struct io_uring_sqe {
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
 		__u32		msg_ring_flags;
+		__u16		uring_cmd_flags;
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
index 8cddd18ad10b..ea989a348d98 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -76,8 +77,21 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
-	if (sqe->rw_flags || sqe->__pad1)
+	if (sqe->__pad1)
 		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
@@ -102,6 +116,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		req->iopoll_completed = 0;
 		WRITE_ONCE(ioucmd->cookie, NULL);
 	}
+	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+		issue_flags |= IO_URING_F_FIXEDBUFS;
 
 	if (req_has_async_data(req))
 		ioucmd->cmd = req->async_data;
-- 
2.25.1

