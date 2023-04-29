Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40A06F23F8
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjD2JnG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjD2JnE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:43:04 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7351FD4
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:56 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230429094254epoutp013f6e6713bb366e71b1ef506321809f26~aXo34QHN22551625516epoutp013
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230429094254epoutp013f6e6713bb366e71b1ef506321809f26~aXo34QHN22551625516epoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761374;
        bh=a1Ko1tJ8viYuiqNUaXjSspplUkqNdUYdAc0cZ2nFHa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBoJIh+BEUdg+ATzYJ4kr7UxqdffA/2CBFbvs1DAudtHxbqxq40yp87OxERx7sD8U
         WpfGCIbgFba2MWuaKAdXpLq1j+bDwlXIeAyt9ybqga1ZPOV9Z70RKF1/RNAkSiEy+n
         5gOFPWnKJPYTTYsglv3JXcfWmOWg/KnNV3i+45Ds=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230429094254epcas5p283c806bab6a38a6d31d6a904f4a00fd8~aXo3VFAsx2155821558epcas5p2Z;
        Sat, 29 Apr 2023 09:42:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Q7kzc5lKkz4x9Pr; Sat, 29 Apr
        2023 09:42:52 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.60.55646.C96EC446; Sat, 29 Apr 2023 18:42:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230429094251epcas5p144d042853e10f090e3119338c2306546~aXo08lRSK1041010410epcas5p1r;
        Sat, 29 Apr 2023 09:42:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230429094251epsmtrp2157b2d867c16b6daf4e4dfcab05fa906~aXo078rgo3077530775epsmtrp2f;
        Sat, 29 Apr 2023 09:42:51 +0000 (GMT)
X-AuditID: b6c32a4b-b71fa7000001d95e-ef-644ce69c2d19
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.29.28392.B96EC446; Sat, 29 Apr 2023 18:42:51 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094249epsmtip2e3eae92ba5f7cf001b2e1a9aff515f82~aXozaVkkq0575905759epsmtip2U;
        Sat, 29 Apr 2023 09:42:49 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 07/12] io_uring: support for using registered queue in
 uring-cmd
Date:   Sat, 29 Apr 2023 15:09:20 +0530
Message-Id: <20230429093925.133327-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmuu6cZz4pBku36lh8/PqbxWL13X42
        i5sHdjJZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYv5y56yW6x7/Z7FYtPfk0wO3B47Z91l
        9zh/byOLx+WzpR6bVnWyeex8aOmxeUm9x+6bDWwefVtWMXp83iQXwBmVbZORmpiSWqSQmpec
        n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKqSQlliTilQKCCxuFhJ386m
        KL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj24SDTAVvxSu2vj/I
        1MD4WriLkZNDQsBE4uWlVsYuRi4OIYHdjBI9J/5DOZ8YJf6/XccO4XxmlLiy8gIzTMuzDbuY
        IRK7GCW2Tv7ECFd1bcUpti5GDg42AU2JC5NLQRpEBFwkmtZOZQOpYRa4CLTj0yEWkISwQJjE
        zZPnGUFsFgFViWNrellBbF4BS4m9HXNZIbbJS8y89J0dxOYUsJL4PmM3M0SNoMTJmU/A5jAD
        1TRvnQ12kYTAXA6J4/MnM0E0u0hcP/+QDcIWlnh1fAs7hC0l8fndXqh4ssSlmeeg6kskHu85
        CGXbS7Se6mcGeYYZ6Jn1u/QhdvFJ9P5+wgQSlhDglehoE4KoVpS4N+kp1MniEg9nLIGyPSR2
        HOtigoRPL6PE+QPbWSYwys9C8sIsJC/MQti2gJF5FaNkakFxbnpqsWmBcV5qOTxmk/NzNzGC
        k6yW9w7GRw8+6B1iZOJgPMQowcGsJMLLW+meIsSbklhZlVqUH19UmpNafIjRFBjGE5mlRJPz
        gWk+ryTe0MTSwMTMzMzE0tjMUEmcV932ZLKQQHpiSWp2ampBahFMHxMHp1QD04PGg1dO5TAx
        XFDd+uLdmeWyE9boBfbISR55O3XCZdUFB2W37NrQyHRb7mbNSoMXf49y6tkuUruowJYpnRax
        pyJjrtPmzXKdev1nuSpEckuqVn3l/Xl43s5frBuirqx4uqNcLtrg5eyd845k2EjsW6DEvOTN
        u5Ntgo8ffIjhM81Z9/iwZuDUa5fFfkXNa6je9rb32Qf2Pzdvxa3+FP5I0dXIcQfjgo8F96WZ
        606LRhcXWZj2fXa9pMJ3uDkx/LVB04KgpSZtTL7txlfX5DPNuRWebfFIoWCvW6qZ8sPVhXX3
        LVktmufoHEyd9JF7Q2zzL+UVC1be+ix26s6lUq+Z/jq5bzTPH73ulbIk4orTb1ElluKMREMt
        5qLiRAD2X2TAOwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSvO7sZz4pBgs3SVh8/PqbxWL13X42
        i5sHdjJZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYv5y56yW6x7/Z7FYtPfk0wO3B47Z91l
        9zh/byOLx+WzpR6bVnWyeex8aOmxeUm9x+6bDWwefVtWMXp83iQXwBnFZZOSmpNZllqkb5fA
        lbFtwkGmgrfiFVvfH2RqYHwt3MXIySEhYCLxbMMu5i5GLg4hgR2MEs3HtjFBJMQlmq/9YIew
        hSVW/nvODlH0kVHi6rLfQB0cHGwCmhIXJpeC1IgIeEm0v53FBlLDLHCTUWLf7r1gzcICIRJt
        ax+CDWURUJU4tqaXFcTmFbCU2NsxlxVigbzEzEvfweo5Bawkvs/YDTZfCKimcUE8RLmgxMmZ
        T1hAbGag8uats5knMArMQpKahSS1gJFpFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZG
        cHRoae1g3LPqg94hRiYOxkOMEhzMSiK8vJXuKUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3Sd
        jBcSSE8sSc1OTS1ILYLJMnFwSjUw9Xb/CrprpvtdguP59h+8TiozOXRSg1z73dOOL7iU9WFm
        jBVTybrcuLyHr7/eCHiaePt20TM7tUf7H/ElhCo5hN7QSP/ln/faInIXr1hd9VOxs3vn5XX+
        u8LdtayXNSpkRrbLOYXknrVPfxs+mD7z9TObQN8Jt/dNzypu6uo7Mjm5667wjWSXpu97o/K/
        n59ptP31Wdlz8dOzn2xTkwv9vu/SsR/b9ObmlumZa30VSp2we88m6R6rzf6HlL8+3bugfwUX
        k1TgtBXCH9UXRXw02eybPc3q34+Ypd5qswql4+qqHvu/1GN5IsUttaFMdXnDo7JFjOXMNbFh
        Cy/5q1m/UNUO8w1deWtLlI1Fl/xuJZbijERDLeai4kQAbCskBv0CAAA=
X-CMS-MailID: 20230429094251epcas5p144d042853e10f090e3119338c2306546
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094251epcas5p144d042853e10f090e3119338c2306546
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094251epcas5p144d042853e10f090e3119338c2306546@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new flag IORING_URING_CMD_DIRECT that user-space can spcifiy in SQE.
If queue is registered with the ring, this flag goes down to the provider
of ->uring_cmd. Provider may choose to do things differently or ignore
this flag.
Also export a helper that allows retrieving the identifier of the
registered queue.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h      |  6 ++++++
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/uring_cmd.c          | 14 +++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b9328ca335..bb6f900411e1 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -37,6 +37,7 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
+int io_uring_cmd_import_qid(void *ioucmd);
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
@@ -67,6 +68,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static inline int io_uring_cmd_import_qid(void *ioucmd)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a9d59bfd26f7..67fbcfd3f676 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -232,8 +232,10 @@ enum io_uring_op {
  * sqe->uring_cmd_flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ * IORING_URING_CMD_DIRECT	use registered queue for this cmd.
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
+#define IORING_URING_CMD_DIRECT	(1U << 1)
 
 
 /*
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5113c9a48583..2a543b490045 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -89,9 +89,12 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
-	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
+	if (ioucmd->flags & ~(IORING_URING_CMD_FIXED | IORING_URING_CMD_DIRECT))
 		return -EINVAL;
 
+	if (ioucmd->flags & IORING_URING_CMD_DIRECT &&
+			req->ctx->dev_qid == -EINVAL)
+		return -EINVAL;
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
 		struct io_ring_ctx *ctx = req->ctx;
 		u16 index;
@@ -162,3 +165,12 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	return io_import_fixed(rw, iter, req->imu, ubuf, len);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
+
+int io_uring_cmd_import_qid(void *ioucmd)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	return ctx->dev_qid;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_qid);
-- 
2.25.1

