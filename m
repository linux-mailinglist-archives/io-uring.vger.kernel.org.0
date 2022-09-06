Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18B5ADFF6
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 08:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiIFGhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbiIFGhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 02:37:39 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34A422286
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 23:37:37 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220906063736epoutp0399855300cb21975afc45439ca3e6981d~SMg-kHCng1359313593epoutp03f
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 06:37:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220906063736epoutp0399855300cb21975afc45439ca3e6981d~SMg-kHCng1359313593epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662446256;
        bh=xYWDawx7wbel1WJGFM9Uma0BQ13A775WPFqjMQwRzQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7H7gigTYaO+dqw25Bt1CkRVfcipni5RIINB9mpPy6vXizr79lRvW8qLP5+NM2izp
         fpmPBZwWAXFjT995t6KuZntnkV5Aw0+J+NGidJa9fZdH0pwX/Qax+AZ+jBbBtZ5wGg
         zVKDV7xgi/yI2EmsfJLpwGyv66sDMeYv/mY86xyk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220906063735epcas5p1544c2e9e38f619e77d0788936d586a38~SMg_4z6B-1555715557epcas5p1H;
        Tue,  6 Sep 2022 06:37:35 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MMG092VHWz4x9QJ; Tue,  6 Sep
        2022 06:37:29 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.52.59633.6AAE6136; Tue,  6 Sep 2022 15:37:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220906063726epcas5p42f764b4c01b841dd1fc34abebcab02e6~SMg2ha3pd1147211472epcas5p4m;
        Tue,  6 Sep 2022 06:37:26 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220906063726epsmtrp16a5aedf0cde5f829276a94698a138dab~SMg2gpLcr2538925389epsmtrp1K;
        Tue,  6 Sep 2022 06:37:26 +0000 (GMT)
X-AuditID: b6c32a49-06ffe7000000e8f1-b1-6316eaa6a56e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.C7.18644.6AAE6136; Tue,  6 Sep 2022 15:37:26 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220906063724epsmtip2784df2284d6835586dc5adf3a67c13c4~SMg1ASCNz2854328543epsmtip21;
        Tue,  6 Sep 2022 06:37:24 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v5 2/4] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Tue,  6 Sep 2022 11:57:19 +0530
Message-Id: <20220906062721.62630-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906062721.62630-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmhu6yV2LJBlvOmlk0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8ruwOWxc9Zddo/LZ0s9
        Nq3qZPPYvKTeY/fNBjaPvi2rGD0+b5ILYI/KtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
        1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCS
        U2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ2xo/kMc8FbyYrlE3axNTD2iHYxcnJICJhI/Jl0
        kK2LkYtDSGA3o8SMWctZIZxPjBKXr79gB6kSEvjMKPFluy5Mx6Grf1kginYxShw918QE4QAV
        nVt9hbGLkYODTUBT4sLkUpAGEQEvifu334NNZQZZ8fZGI9hUYYEYiZ1ty1lAbBYBVYkfS5eB
        2bwCFhLTd01kg9gmLzHz0newek4BS4kJJ7+wQdQISpyc+QSsnhmopnnrbGaQBRICnRwS3192
        MEE0u0hcfrqaEcIWlnh1fAs7hC0l8bK/DcpOlrg08xxUfYnE4z0HoWx7idZT/cwgzzADPbN+
        lz7ELj6J3t9PmEDCEgK8Eh1tQhDVihL3Jj1lhbDFJR7OWAJle0gsa2pnhIRPD6PE6v9TWCcw
        ys9C8sIsJC/MQti2gJF5FaNkakFxbnpqsWmBYV5qOTxik/NzNzGC06iW5w7Guw8+6B1iZOJg
        PMQowcGsJMKbskMkWYg3JbGyKrUoP76oNCe1+BCjKTCMJzJLiSbnAxN5Xkm8oYmlgYmZmZmJ
        pbGZoZI47xRtxmQhgfTEktTs1NSC1CKYPiYOTqkGpvhu5mMPPSdqda76ndSTFrVz59G+TWHM
        OrwZ8k27fX0ZVW9wGejzBrh1Hy93+fy4PMX/5myW98uzI3NPdZpvvLBO90QE00+nW9Fs5wR3
        Ma9/bfbin/l+qfWLNl8QCX8RrztL6AdD0N49wldzvHNbrrJbaMgmXSxbcvbmsS89lTnXVvKX
        anT+VhbJehS7PDLVVlx2puufm/KzzgQK75PjsbzOf3diFrfL3SOmxgxTctk8I96FiZgUKjju
        9+F7Ep3xx/lu+v/Mtkfe5iGn2sU5FA8dsNBctsPydqHLlPBVyvrHPLi2Gew+f+e7wrlUF413
        F20YksLvruW6Imd1/oaM6uHN3h3TyjnlP2R4nJFXYinOSDTUYi4qTgQAo4BlPiwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvO6yV2LJBvc3SVk0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8ruwOWxc9Zddo/LZ0s9
        Nq3qZPPYvKTeY/fNBjaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgytjRfIa54K1kxfIJu9ga
        GHtEuxg5OSQETCQOXf3L0sXIxSEksINR4v7Mo6wQCXGJ5ms/2CFsYYmV/56zQxR9ZJRYf24P
        cxcjBwebgKbEhcmlIDUiAgESBxsvg9UwCxxklLj87AkLSEJYIEri2YNrTCA2i4CqxI+ly8Di
        vAIWEtN3TWSDWCAvMfPSd7BlnAKWEhNOfgGLCwHV3FlxlwmiXlDi5EyImcxA9c1bZzNPYBSY
        hSQ1C0lqASPTKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4BjQ0trBuGfVB71DjEwc
        jIcYJTiYlUR4U3aIJAvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgm
        y8TBKdXAxDXzcalGznb91fuWhctVnVt4Jl3Sims3z8OK2gdLdHhYt/VuZF22tXb29ElfxF63
        rxf7GXVkgc6aO7IN4fcPx0R4SovMYHc21XQv2fn9QKX7qyt3929RZZI9oLpsnbHThz2CkU9O
        XbWq3xHl53im+8nJklT18MCb6sd4/y4o2plqd+V2RVV+k7e/pNGbVpVDEZtiPD/vuX1+12Xv
        f6E9e6ROvuJpihA8M2vGM/njWc2qnGHuf6QSPqnU/Hsz5fv2aKP5vM+Kzy2QuNzuIHJ/uu/k
        +UetbZVsPN2vL/2qc5ijd7FddcoazdKV3nfzT7yZuDqdZXJ2jpH8wnT3VmvHZiWBtqPlVysi
        fROvL035qsRSnJFoqMVcVJwIAHlNCnrwAgAA
X-CMS-MailID: 20220906063726epcas5p42f764b4c01b841dd1fc34abebcab02e6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220906063726epcas5p42f764b4c01b841dd1fc34abebcab02e6
References: <20220906062721.62630-1-joshi.k@samsung.com>
        <CGME20220906063726epcas5p42f764b4c01b841dd1fc34abebcab02e6@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 202d90bc2c88..621b2c5469ed 100644
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
index 48e5c70e0baf..34be8dd31f17 100644
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
index b8f4dc84c403..f9189885edec 100644
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
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
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

