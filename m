Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9BF5B3540
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 12:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiIIKb5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 06:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiIIKby (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 06:31:54 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7B6B1B91
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 03:31:51 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220909103148epoutp02dee2cee080bc02a8b3b4a3496e1770a6~TKpVWJZ1c1618816188epoutp02o
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 10:31:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220909103148epoutp02dee2cee080bc02a8b3b4a3496e1770a6~TKpVWJZ1c1618816188epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662719508;
        bh=Dka7Z5UEBNznU9rnZN263arRHHrQheZ74m48btxfW30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJhFOx72SSNLU3JwNLfAUMG/cLW1KHqJ9fjkta1BVXIAU6cFFoQ8yJDMNWlYlJbx2
         xGLxGiEZ6pajicv3WQUGYP3C3ejR3H3r20/xc9D4E8qtcQgYrsfjZ0HVNP8qx3RKXJ
         Py6PsuDdZHPg6KeHFcvigo3PpviFOTuzmzoRIiDs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220909103147epcas5p3ca3c93059aea93d6e94f8a93d8b75a97~TKpUxq-9A0115401154epcas5p3z;
        Fri,  9 Sep 2022 10:31:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MPC350w6Dz4x9Pt; Fri,  9 Sep
        2022 10:31:45 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.DB.59633.D061B136; Fri,  9 Sep 2022 19:31:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220909103140epcas5p36689726422eb68e6fdc1d39019a4a8ba~TKpOXl-Tg0115401154epcas5p3t;
        Fri,  9 Sep 2022 10:31:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220909103140epsmtrp10cbe43d34e34eda09f4f9937a1be9067~TKpOW1iFy1097010970epsmtrp1I;
        Fri,  9 Sep 2022 10:31:40 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-a3-631b160d52f6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.B1.18644.C061B136; Fri,  9 Sep 2022 19:31:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220909103139epsmtip121b3208ae6a042f2e54c7e62b02f37d1~TKpM5TZXh1205712057epsmtip1W;
        Fri,  9 Sep 2022 10:31:39 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v7 2/5] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Fri,  9 Sep 2022 15:51:33 +0530
Message-Id: <20220909102136.3020-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909102136.3020-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmui6vmHSywcGTlhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
        dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTk
        FJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGc8/d7IUvBRtGLRGfUGxu+CXYycHBICJhL7jz1j
        7mLk4hAS2M0osXb3XlYI5xOjxPKfR5kgnM+MEvu7ZzDCtDx5txCqahejROv0L8wgCbCquaf0
        uxg5ONgENCUuTC4FCYsIeEncv/0erJ4ZZMXbG43sIAlhgRiJpZd2sIDYLAKqEpv2fmADsXkF
        zCXOL29ig1gmLzHz0newek4BC4nJn6+xQ9QISpyc+QSslxmopnnrbLAfJARaOSSmzXzHAtHs
        IrF421tmCFtY4tXxLewQtpTEy/42KDtZ4tLMc0wQdonE4z0HoWx7idZT/cwgzzADPbN+lz7E
        Lj6J3t9PmEDCEgK8Eh1tQhDVihL3Jj1lhbDFJR7OWAJle0g8XHmTFRI83YwSX55VTGCUn4Xk
        g1lIPpiFsGwBI/MqRsnUguLc9NRi0wLDvNRyeLQm5+duYgSnUC3PHYx3H3zQO8TIxMF4iFGC
        g1lJhFd0rUSyEG9KYmVValF+fFFpTmrxIUZTYBBPZJYSTc4HJvG8knhDE0sDEzMzMxNLYzND
        JXHeKdqMyUIC6YklqdmpqQWpRTB9TBycUg1MxecuL+VSWxm16lq/61+xJ/cmztv+/1nhntXC
        13y+u34SeeXazfR79Y/meTtWaeZkWRhMUi6cop/U9jvl99vlGi/m9xZczOTIdjdW1yz5Nmlj
        Rmlh9mof4+vPl0o6SEhYtZ5y/nj/4wWmz+nfvrRvfb28tFaY5/rahRPlDK0u/F7irS+2UJNv
        s1CK2Z3chvalJoJ7Ckw1FkycsWelOfeZzc9fG16tVdboiUl8/uDTl49JKbHTluusvz15/79l
        JyQ36y0tOqabdZf19M5cjn9+okr/zny7fs+fp1bk8+zdXetfOoa9mLgxoq5i/fbHMVfvXH18
        1/XcDvHQ7wXsx/2cNx2QaLop2vz8PbOCd/l7r/1KLMUZiYZazEXFiQC9OwsYKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSnC6PmHSyQedpHYumCX+ZLeas2sZo
        sfpuP5vFzQM7mSxWrj7KZPGu9RyLxdH/b9ksJh26xmix95a2xfxlT9kduDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGU+/N7IUfBStWHRGvYHx
        u2AXIyeHhICJxJN3C1m7GLk4hAR2MEo8nbGRFSIhLtF87Qc7hC0ssfLfc3aIoo+MEg/OHwUq
        4uBgE9CUuDC5FKRGRCBA4mDjZbAaZoGDjBKXnz1hAUkIC0RJ9EyZxAhiswioSmza+4ENxOYV
        MJc4v7yJDWKBvMTMS9/BlnEKWEhM/nwNzBYCqnm98xMLRL2gxMmZEDOZgeqbt85mnsAoMAtJ
        ahaS1AJGplWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMERoKW1g3HPqg96hxiZOBgP
        MUpwMCuJ8IqulUgW4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJ
        g1Oqgcn/6kHPABcTq/VbVpROfbxp4Uyz/y/LjptbObAK6rJr5nIvm++4piekyK/X4IA0hwq3
        I9POWdu7nSqNgyal35/xYftFaSv1spOHY/5xGL2zNtnzI4O7Qs5JKV9kaan+/U8Jfw/cNU66
        GS/c+4szt+WCTl/LUaV5hrvNV+7ZtFwydhnXrucXhS+W9V27XBlzYenZqJzuAIffe92CHKZO
        Pu19IPj7l5rHhaEi4dIPW16/8px5+KbRBSXet5lr+h9GdUUzRHrPVUzdWvBBaLXYuoa1jBl1
        wqkJQWzXOLWO6MiVr9PlielMiWy5ldwhmRJ57WpkqdCuyKxY++uirBOe/xf03zv3+KfvBwo3
        Kx4MV2Ipzkg01GIuKk4EAFoXtrzvAgAA
X-CMS-MailID: 20220909103140epcas5p36689726422eb68e6fdc1d39019a4a8ba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103140epcas5p36689726422eb68e6fdc1d39019a4a8ba
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103140epcas5p36689726422eb68e6fdc1d39019a4a8ba@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

