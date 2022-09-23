Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60865E7770
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 11:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiIWJmY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 05:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiIWJkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 05:40:45 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2676130BEF
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 02:39:23 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220923093920epoutp046e7e9e234b37def7bdda04a94a80045a~Xc9hQYcrC1029510295epoutp04B
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:39:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220923093920epoutp046e7e9e234b37def7bdda04a94a80045a~Xc9hQYcrC1029510295epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663925960;
        bh=2f95MMw1JaP2a2qx6h2pgrT8vnSnYyP4Ul8WVop1exo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNmMuW+FxZa9oLjoPhVRbAv5Mrzh5GtlOznC/uCUwaObxPLh0qQf1X3twjwd/JURi
         zNWGZ/7OrpSjbUfBaHjDrndA1s2luxrZR60Iv3wo0Xmn2eQqXr4x6VGUc2FqQvXuSh
         dDpsQRrvjU7TnL1j8r9hahVS/nJBHYUnIL0EJPRc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220923093919epcas5p44589eb00c12ab1e537feb4375df5b4fc~Xc9gxBMTY0422904229epcas5p4_;
        Fri, 23 Sep 2022 09:39:19 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MYnD45cYPz4x9Pt; Fri, 23 Sep
        2022 09:39:16 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.34.26992.2CE7D236; Fri, 23 Sep 2022 18:39:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220923093913epcas5p4d91766a750d6f5e87a1da0b92f6c4a2e~Xc9a4yphH0959609596epcas5p48;
        Fri, 23 Sep 2022 09:39:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220923093913epsmtrp125a3d7ed3ebdfb5432e7dd4b714f42eb~Xc9a4GpMB0923409234epsmtrp1W;
        Fri, 23 Sep 2022 09:39:13 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-39-632d7ec28545
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.37.18644.1CE7D236; Fri, 23 Sep 2022 18:39:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220923093911epsmtip2deed05ee44574274cd4d418bf7e5afdb~Xc9ZIsjTz2919729197epsmtip2E;
        Fri, 23 Sep 2022 09:39:11 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v8 2/5] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Fri, 23 Sep 2022 14:58:51 +0530
Message-Id: <20220923092854.5116-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923092854.5116-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTU/dQnW6ywf6d7BZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCdcWTLRMaCj6IVt3/NYmtg/C7YxcjBISFgIrH1p3oXIxeHkMBuRol3
        R6cwQzifGCUebfwP5XxmlFj7ZQUzTMf13XoQ8V2MEm2NUxCK9j09xgZSxCagKXFhcmkXIyeH
        iICRxP5PJ1lBaphBVry90cgOkhAWiJG4uuoSC4jNIqAqMX3CH7A4r4C5xNM765hAbAkBeYmZ
        l76DxTkFLCQWbb7FBFEjKHFy5hOwXmagmuats8GOkBD4yy7RfnwLI0Szi8Tii2egbGGJV8e3
        sEPYUhIv+9ug7GSJSzPPQS0rkXi85yCUbS/Reqof7GNmoGfW79KH2MUn0fv7CRMkIHglOtqE
        IKoVJe5NesoKYYtLPJyxBMr2kLh3tJcJEj7djBJbXm9kmsAoPwvJC7OQvDALYdsCRuZVjJKp
        BcW56anFpgWGeanl8HhNzs/dxAhOmFqeOxjvPvigd4iRiYPxEKMEB7OSCO/sO5rJQrwpiZVV
        qUX58UWlOanFhxhNgWE8kVlKNDkfmLLzSuINTSwNTMzMzEwsjc0MlcR5F8/QShYSSE8sSc1O
        TS1ILYLpY+LglGpg8k+8NqPt8NFp6TsLFPXaVjHyn7SaEtmv7mYkdef6pW9ZR/8WLW4Tcr0L
        NKh7nsrrsAeNK+/qKtyw/140c//shorvh/R92KeV3ShcOHXJa70DUcHuMgH9T3+o21VFXvx7
        7Xi2TFbYEaXSFKPa0pjbf72VWVumneRKCc1e5aWsFDD/3a9WhhMtxnENkon78y0vmj+dnOSa
        Ziyb0/B8ZUZU8bUVwk9uHex+kzg5bYOZ3r2Jdl2Cs3/m+wizzPZ/xLXUmjuF+eukbWxNpX4v
        tDZu2GC79PGKc9zJXQzx9gVK/tK+rSGHjXWv/v5g6Ka4fKfNkvI2g/qAhrhpDpOXpMiWKFr5
        rmu7W1/vqs8WqMRSnJFoqMVcVJwIAEZ5/mwhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSvO7BOt1kg3X7BCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJVxZMtExoKPohW3f81ia2D8LtjFyMEhIWAi
        cX23XhcjF4eQwA5GidOHjrJ3MXICxcUlmq/9gLKFJVb+e84OUfSRUaLl6EQmkGY2AU2JC5NL
        QWpEBMwklh5ewwJSwyxwkFHi8rMnLCAJYYEoidcf74MNYhFQlZg+4Q+YzStgLvH0zjomiAXy
        EjMvfQeLcwpYSCzafAssLgRU8+PSC0aIekGJkzMhZjID1Tdvnc08gVFgFpLULCSpBYxMqxgl
        UwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgoNdS2sH455VH/QOMTJxMB5ilOBgVhLhnX1H
        M1mINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGptPpwZUy
        06P9N17Y3li+T6377bynJ6VeCTs0Nut6//gr2xu1e+VrjRUGPu+WHU8+qWFuMZ/fQleoi83l
        aMu19I/17bO37M1p8Gk8tavgw8o58xTrLFun/F16Rvf2JrVHx87F29/p0BSaFZu9Ll+k76pa
        2L3PpitOTH3vbOPyebpJ/ipvKRPJhMcT0jvmKpnFHNqhoLds6q7Kprz54l6i35xWPk+efVvo
        kKmIe4xI0uc7fyevPGW1euYst++3HjBx5If7vr9xuyLT86GB2beTR9Lu3/+t6rr5uLPAEU3L
        mUHrnIMOvdp/clcvj+SruIoTsyryxWQ5mV0eXH8cIFc3TShnzrOrBTuUXT4IOX/5N02JpTgj
        0VCLuag4EQBQMhzQ5QIAAA==
X-CMS-MailID: 20220923093913epcas5p4d91766a750d6f5e87a1da0b92f6c4a2e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093913epcas5p4d91766a750d6f5e87a1da0b92f6c4a2e
References: <20220923092854.5116-1-joshi.k@samsung.com>
        <CGME20220923093913epcas5p4d91766a750d6f5e87a1da0b92f6c4a2e@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

