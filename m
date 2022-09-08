Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878035B261A
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiIHSpq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiIHSpm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:45:42 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D2895AE6
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 11:45:38 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220908184536epoutp046e43fd84b688fbbf9855da3422314aae~S9vMdgciU0953909539epoutp04f
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 18:45:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220908184536epoutp046e43fd84b688fbbf9855da3422314aae~S9vMdgciU0953909539epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662662736;
        bh=oAfQIPdjrU6Y1ANjWE7k4a6Wf9Pn3fR+z3Nn3SKsL5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgVIpK4+vh87R9y2vLobSu+pCAsGMnmNB4Aj0NcTmobvnLxTU2l3gWMWnJgbzJG41
         96Z8fX9DqvPIDEXy5XG2na/k3o+IC5zpzl3n0VkgVWswBRy5GELDwDjE33kOtg0Uj/
         XW0cnt9kG1VlrM/BHVyEZpUzdX1UUX8ky0qy9SDM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220908184535epcas5p1a455dbb3424bb46b9a996db0847718f8~S9vL6u9RU2308423084epcas5p1J;
        Thu,  8 Sep 2022 18:45:35 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MNp3K2Rrpz4x9Pt; Thu,  8 Sep
        2022 18:45:33 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.0B.53458.D483A136; Fri,  9 Sep 2022 03:45:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220908184532epcas5p2ca2ab735dab24937e24e44be9f440f92~S9vJMBE9T2042720427epcas5p2_;
        Thu,  8 Sep 2022 18:45:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220908184532epsmtrp1ee73b52f6ac42af2bd24455f16c97d01~S9vJLLZz93080730807epsmtrp1d;
        Thu,  8 Sep 2022 18:45:32 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-b8-631a384dbbe5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.9E.18644.C483A136; Fri,  9 Sep 2022 03:45:32 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220908184531epsmtip2f0e83c5565e4b042b19454cd715e8b81~S9vHsX5UE2337123371epsmtip2C;
        Thu,  8 Sep 2022 18:45:31 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v6 2/5] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Fri,  9 Sep 2022 00:05:08 +0530
Message-Id: <20220908183511.2253-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908183511.2253-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmlq6vhVSyQUsrn0XThL/MFnNWbWO0
        WH23n83i5oGdTBYrVx9lsnjXeo7F4uj/t2wWkw5dY7TYe0vbYv6yp+wOXB47Z91l97h8ttRj
        06pONo/NS+o9dt9sYPPo27KK0ePzJrkA9qhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
        XUNLC3MlhbzE3FRbJRefAF23zByg45QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5
        BSYFesWJucWleel6eaklVoYGBkamQIUJ2Rlv355iK/goWrFubhdzA+N3wS5GTg4JAROJOX/X
        MHYxcnEICexmlDj7ZjYzhPOJUaL3wFEmkCohgc9AzrlamI6tky+wQsR3MUr0bNaBaACq2dEw
        ia2LkYODTUBT4sLkUpAaEQEvifu337OC1DCDbHh7o5EdJCEsECPxftFcNhCbRUBVYtOBG2BD
        eQXMJa78Xs8CsUxeYual72D1nAIWEhe/PGSDqBGUODnzCVgNM1BN81aIqyUEOjkkOlqesYIc
        ISHgInF3hgfEHGGJV8e3sEPYUhIv+9ug7GSJSzPPMUHYJRKP9xyEsu0lWk/1M4OMYQb6Zf0u
        fYhVfBK9v58wQUznlehoE4KoVpS4N+kpK4QtLvFwxhIo20Ni55y7bJDg6WaUWPW9hW0Co/ws
        JB/MQvLBLIRtCxiZVzFKphYU56anFpsWGOWllsOjNTk/dxMjOIVqee1gfPjgg94hRiYOxkOM
        EhzMSiK8omslkoV4UxIrq1KL8uOLSnNSiw8xmgKDeCKzlGhyPjCJ55XEG5pYGpiYmZmZWBqb
        GSqJ807RZkwWEkhPLEnNTk0tSC2C6WPi4JRqYOouf3S3oTAqYWnF2yv3RS4zuLya9n3ungk/
        P7kbVoV9u35uZsrXm29r9A3FFBQLHj/g3D5j75Ekza1lVQ5Vefd+xr5tmHdg9/oMXmFfX7F9
        K8Q0TliafzG1zHHlyww2TEtZct8xbOtLza8zk3k2pX5V23zG/+SPad8X/PNxYZFbvefS1Ftu
        nmvXNLie9vw//6bM993ih51mRddlWCludk70nCY4Y6ph68yr/znt7L5cv3L+268j5zYGOxYp
        3521kHul+/HdT+NF3ihuFInikRbQufjuyPauiZe9DvjaJk3buuZAyQ2e5FLjJ1t2nK3IaCov
        mZjZm2n4z4yn5pPAsfKzD/WUJ0WZ7E+TeZhsd4FbiaU4I9FQi7moOBEAbYydJSoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvK6PhVSywc5phhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Mt6+PcVW8FG0Yt3cLuYG
        xu+CXYycHBICJhJbJ19g7WLk4hAS2MEocfDMSxaIhLhE87Uf7BC2sMTKf8/ZIYo+MkpMXXeF
        rYuRg4NNQFPiwuRSkBoRgQCJg42XwWqYBQ4ySlx+9gRskLBAlMS3s0sZQWwWAVWJTQdusILY
        vALmEld+r4daJi8x89J3sGWcAhYSF788ZAOxhYBqrv2ZzgxRLyhxcibETGag+uats5knMArM
        QpKahSS1gJFpFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcAxoae1g3LPqg94hRiYO
        xkOMEhzMSiK8omslkoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgST
        ZeLglGpgMpr//ftCkXve85qKD0gyWvyRL+WzFVrLuLdUzvfB0pjHVQ4FU37X1GsXRszVK7VU
        Fr4ZkdXJX/qL1/n5tKvhL61XdQQnP3n68K4YH/uhDzoCd/YrbLmwNfnqt92HAwK0rP79W5G1
        hi9KyOuizGLl7S1nZ/se1GrI4bx4dUaoV4G9g8OXT9O3LLtvdnyRVvPEyq0/4uM2xb78FVVe
        6sK307Ch9UP0zU9HvklHdWxc5zIx8LlG6c+ddju2TbGedvsPw75436Zde4LOLwzov/p5Q8Sh
        mxe0xPsaSleUSry8lKFaad6lYcGvHndsH5fbCubvfz6c3MD1QG3zRMf4uLtS3IK3a336D5//
        vC/dKXyfrRJLcUaioRZzUXEiAFERVPPwAgAA
X-CMS-MailID: 20220908184532epcas5p2ca2ab735dab24937e24e44be9f440f92
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220908184532epcas5p2ca2ab735dab24937e24e44be9f440f92
References: <20220908183511.2253-1-joshi.k@samsung.com>
        <CGME20220908184532epcas5p2ca2ab735dab24937e24e44be9f440f92@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
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
index 202d90bc2c88..81913f01bae0 100644
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
index 972b179bc07a..f94f377f2ae6 100644
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
@@ -218,6 +219,14 @@ enum io_uring_op {
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

