Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB545EF52E
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiI2MVs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiI2MVc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:21:32 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21424148A21
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:21:28 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220929122126epoutp03f141dfe5e87e6b1229d249bce39c9978~ZVCxfjj-m2090920909epoutp03i
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:21:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220929122126epoutp03f141dfe5e87e6b1229d249bce39c9978~ZVCxfjj-m2090920909epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454086;
        bh=xMmj22Fm1UKQdbN5q3tCCFoK6cDTkB7H5tHv92rgbKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G72Qes9ctEl7ACWO8vNzzFfKeo6AdtkPP6OS9wW2LAn3iLKe2o/D/UQ+vutfKRAAU
         PSscBkMO62GFzw6wqtrsEtFhi9YXiLkXabXpmPIEh2e/1I3JfvVkQYmozXvbXRF4HK
         cwvDt2AQVPmPr6C3Lt8iXFY6aCVPT85L8Ad8IEpU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220929122126epcas5p4762a6d38976025c2534e41da35321155~ZVCwwMgIx3003630036epcas5p4T;
        Thu, 29 Sep 2022 12:21:26 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdXXN34KSz4x9Pt; Thu, 29 Sep
        2022 12:21:24 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.82.26992.4CD85336; Thu, 29 Sep 2022 21:21:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220929121637epcas5p2ff344c7951037f79d117d000e405dd45~ZU_kVncoA2731427314epcas5p22;
        Thu, 29 Sep 2022 12:16:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121637epsmtrp2af0f316a39759668bd5bf5b9cfb1042a~ZU_kU2dZI1794617946epsmtrp2N;
        Thu, 29 Sep 2022 12:16:37 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-83-63358dc4c423
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.43.14392.5AC85336; Thu, 29 Sep 2022 21:16:37 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121636epsmtip16ea7bb99dca714e76c33e617af52b8e1~ZU_i6fvKb2848328483epsmtip1X;
        Thu, 29 Sep 2022 12:16:36 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v11 02/13] io_uring: introduce fixed buffer support
 for io_uring_cmd
Date:   Thu, 29 Sep 2022 17:36:21 +0530
Message-Id: <20220929120632.64749-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmhu6RXtNkg/MHRC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyM06/aWQqOiVbMnLKauYHxsmAXIweHhICJxJO+jC5GTg4h
        gd2MEnvfWXcxcgHZnxgldv9dzA7hfGOUeLBlHytIFUjD09sbmCESexklrh1/xQThfGaU+Pzj
        CgtIFZuAusSR562MILaIgJHE/k8nWUGKmAVuMkoc2vuMGSQhLBAv0fXvGxuIzSKgKtFwsJMd
        xOYVsJTYuLyFDWKdvMTMS9/B4pwCVhKLr81hhagRlDg58wnYMmagmuats5kh6ls5JH7/lYKw
        XSTOTnvPCGELS7w6voUdwpaS+PxuL9T8dIkfl58yQdgFEs3H9kHV20u0nupnBoURs4CmxPpd
        +hBhWYmpp9YxQazlk+j9/QSqlVdixzwYW0mifeUcKFtCYu+5BijbQ2JB8wFoYPUyShxetoF9
        AqPCLCTvzELyziyE1QsYmVcxSqYWFOempxabFhjmpZbDIzk5P3cTIzipannuYLz74IPeIUYm
        DsZDjBIczEoivOIFpslCvCmJlVWpRfnxRaU5qcWHGE2B4T2RWUo0OR+Y1vNK4g1NLA1MzMzM
        TCyNzQyVxHkXz9BKFhJITyxJzU5NLUgtgulj4uCUamAKs9qx7GxXQVWEc9D/87ERZ8PdS9Ps
        Axfe599ismHGoVqfpsu57CkXPzw8I2s9w27h20LF7oaYy4rxz1cdLo3pihMLeDrHNMNt/yfB
        L75FpSb/b875tem6/DdVs+iqWyy59/NZheaWJvqW7GX4mdX72ff9UtsAqym10szLhQWv5vE/
        XN6w/86HmFV5ej6S/owps9vuH2da+qj9QsyX6Bb3A+XmP9mErWOkliWEWVun95iXZnxk+bHH
        a8/BYr9f59rjJyzZ3ca/c/q2KxuKDx88Zfruk1hGk51a4N23mmxFXMyxVnF67Ll1dq/+vrsW
        fHmDoMBDP31mA704L+mv7bau79z3lp4uOWOxRPCdkxJLcUaioRZzUXEiABpjYZgzBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnO7SHtNkg02bDCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bpV+0sBcdEK2ZOWc3cwHhZsIuR
        k0NCwETi6e0NzF2MXBxCArsZJfYdmMIOkZCQOPVyGSOELSyx8t9zdoiij4wSSxZdZAVJsAmo
        Sxx53gpWJCJgJrH08BoWEJtZ4D6jxILuEBBbWCBWYtv31cwgNouAqkTDwU6wBbwClhIbl7ew
        QSyQl5h56TtYnFPASmLxtTlA8zmAlllKbL+pAFEuKHFy5hOo8fISzVtnM09gFJiFJDULSWoB
        I9MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgsNfS3MG4fdUHvUOMTByMhxglOJiV
        RHjFC0yThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamDi
        /CD5zfhp/6vd8rveSe23DJ0jN3GT5Jx5XGdPZxRwf9TJn3jRf4btD+11B2Kzuq49+b3Pfc3t
        /6yX3v9uWm22Zv2SGzy2+05sd+AQ4NvafIHFSiNz+v36t7mHf4s/Pp5cXvQ+VfD/twbfGS83
        rS9srdxlU9wslL9NW3/luoZDwbLyJ85OTJff83aFaj3jTSvrVcKv5Ra/jPjcaCcoPKk+445k
        hfbew8d/R9yQe7Zbj+lZz/43s5Q8S788UdaVZKjnfPBul/W6HdIiJ5iNZ7zzOfH6bf2ef6kv
        1qjccDdy2LOEb9Ec0xn6/LVz7tRqh8zIq+M5pWL6xFLTiPHfpewLUfcmx86dbrD/N/uOabdW
        FCuxFGckGmoxFxUnAgB+Q3To6gIAAA==
X-CMS-MailID: 20220929121637epcas5p2ff344c7951037f79d117d000e405dd45
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121637epcas5p2ff344c7951037f79d117d000e405dd45
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121637epcas5p2ff344c7951037f79d117d000e405dd45@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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

