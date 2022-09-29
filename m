Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E76A5EF529
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbiI2MVV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiI2MVQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:21:16 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F90147F3D
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:21:15 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220929122112epoutp0258a77f7d91532946d88f6ffcec0b5077~ZVCjyGu0C0536605366epoutp02k
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:21:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220929122112epoutp0258a77f7d91532946d88f6ffcec0b5077~ZVCjyGu0C0536605366epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454072;
        bh=iirM43BcaFmNufDrlcC4cnJ4qMGLT6ODyYNtDEbayfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3oKm9cq1tUy3NrwH0U1jcmy8H7gEedTS96jugFPHaSXcpMSt1GwMTb7JGg6aUg7O
         yG1+L0JuVsst3gNKTF4EM6NQnRsiuP0ODVOsRkWwUYXSqzS/yVfdRZlmnVWR3OGLBf
         yFJqhsksF1cDgHW9T3wB0EoaYiXoYnVe3jrmpZtc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220929122111epcas5p15f7ec8ef37540964c64e874780abc6db~ZVCjWrVwW2617526175epcas5p18;
        Thu, 29 Sep 2022 12:21:11 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdXX56R2Nz4x9Pt; Thu, 29 Sep
        2022 12:21:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.82.26992.5BD85336; Thu, 29 Sep 2022 21:21:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220929121634epcas5p27400b84f8a8b43a91c4199ec39d50b51~ZU_gxZxSi2579425794epcas5p2v;
        Thu, 29 Sep 2022 12:16:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220929121633epsmtrp1bae654eccfe047e51fac2532f8850756~ZU_gwZMW11820918209epsmtrp1O;
        Thu, 29 Sep 2022 12:16:33 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-56-63358db506e8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.2C.18644.1AC85336; Thu, 29 Sep 2022 21:16:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121632epsmtip13e97ea335b162e573e81cdf2ab02f7d9~ZU_fTwVzD2856128561epsmtip1R;
        Thu, 29 Sep 2022 12:16:32 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v11 01/13] io_uring: add io_uring_cmd_import_fixed
Date:   Thu, 29 Sep 2022 17:36:20 +0530
Message-Id: <20220929120632.64749-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmhu7WXtNkg+sT9CyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMJ8cnsRT8F6zYPfkyYwPjT74uRk4OCQETiRnNz9i6GLk4
        hAR2M0osntfNBJIQEvjEKLGmoQAi8ZlRorPjFTtMx9NZs5kgErsYJVp3bGKB6ACqOtYmDWKz
        CahLHHneyghiiwgYSez/dJIVpIFZ4CajxKG9z5hBEsIC3hInuj6BTWURUJXYvWwjUAMHB6+A
        pcSxf34Qy+QlZl76DlbCKWAlsfjaHFYQm1dAUOLkzCdge5mBapq3zmYGmS8h0Mgh8burjQWi
        2UViUUsnlC0s8er4FqgPpCRe9rdB2ekSPy4/ZYKwCySaj+1jhLDtJVpP9TOD3MMsoCmxfpc+
        RFhWYuqpdUwQe/kken8/gWrlldgxD8ZWkmhfOQfKlpDYe64ByvaQmNS+mRUScL2MEk96H7NN
        YFSYheSfWUj+mYWwegEj8ypGydSC4tz01GLTAsO81HJ4JCfn525iBCdVLc8djHcffNA7xMjE
        wXiIUYKDWUmEV7zANFmINyWxsiq1KD++qDQntfgQoykwvCcyS4km5wPTel5JvKGJpYGJmZmZ
        iaWxmaGSOO/iGVrJQgLpiSWp2ampBalFMH1MHJxSDUzpTIcczTU0q7sCltwOuC+lcqL3ft5s
        3gvRp35ovX14b/X6u2w7vhZqei5ef2pbZGMS55kXqp7rpmxW0ntSmP1ysZ10g3hM+PPi7LAn
        Ia2LXosEss+Ypj7rueX1f8wCyhqxiY93Ksbe2yXdflc7VHFCauqKxJwLXxnfbK3frrTIoCJ0
        rnNdwoqenyn3olv41hu9swiYtab93Y6W66/ZY60PFFxq7/hSx3rk+zKTi8/eRnvotS/ueWft
        E/bG5MHkZQfjT6xgYtz9Lc11/uoFSzVWHT0bWRJ3K934N8tClTP/bxl3Vl97HMIecXlnqwqP
        LIPPEsV8xQ792S9PPD+53OTLos+bjKbXfWCtXL12pVuHEktxRqKhFnNRcSIAsrODNjMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSnO7CHtNkgykvzS2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aT45NYCv4LVuyefJmxgfEnXxcj
        J4eEgInE01mzmboYuTiEBHYwSjSfn8cCkZCQOPVyGSOELSyx8t9zdoiij4wSi1ZPZgNJsAmo
        Sxx53gpWJCJgJrH08BqwZmaB+4wSC7pDQGxhAW+JE12f2EFsFgFVid3LNgLVc3DwClhKHPvn
        BzFfXmLmpe9gJZwCVhKLr81hBSkRAirZflMBJMwrIChxcuYTqOnyEs1bZzNPYBSYhSQ1C0lq
        ASPTKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4KDX0trBuGfVB71DjEwcjIcYJTiY
        lUR4xQtMk4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpg
        2pYX6H36hOwxzgc3+Y9tPqqarVRUdGW/RPlHk5nLpphKG5kayKRqtWm31W/JuF+dK/KmuDmr
        WCpN6/Lxl1c3M13j4o6fWdQfVaZ/afXtwk6dnMty2laivey3dor49pjf/OmhO/EF8+yy+Vxu
        Gtc2GMy+seTnnDX/dXmX/RHyWxmz7LiK35nHH5R/pbcu2rd4/ce/G39dCPnk7R1efuLM6gsh
        nY//2H3j3bCyX+dE5V2ztWt2zPu7Q+GrbADnkrBFL/0UZ03N2G22wvYMx2SxoAmG5/ed7n9T
        IvM0kzPhwra8qu43qx/+tfodkalzwZdbwZZX5FDSohP8F/2f+IiVfv7Dq2zg0+Ltwz7fQ/uz
        txJLcUaioRZzUXEiAKnmJzzpAgAA
X-CMS-MailID: 20220929121634epcas5p27400b84f8a8b43a91c4199ec39d50b51
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121634epcas5p27400b84f8a8b43a91c4199ec39d50b51
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121634epcas5p27400b84f8a8b43a91c4199ec39d50b51@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a new helper that callers can use to obtain a bvec iterator for
the previously mapped buffer. This is preparatory work to enable
fixed-buffer support for io_uring_cmd.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h |  8 ++++++++
 io_uring/uring_cmd.c     | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 58676c0a398f..1dbf51115c30 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -4,6 +4,7 @@
 
 #include <linux/sched.h>
 #include <linux/xarray.h>
+#include <uapi/linux/io_uring.h>
 
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
@@ -32,6 +33,8 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *));
@@ -59,6 +62,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd)
+{
+	return -EOPNOTSUPP;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f3ed61e9bd0f..6a6d69523d75 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -8,6 +8,7 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "rsrc.h"
 #include "uring_cmd.h"
 
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
@@ -129,3 +130,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
+
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+			      struct iov_iter *iter, void *ioucmd)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_import_fixed(rw, iter, req->imu, ubuf, len);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
-- 
2.25.1

