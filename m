Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F1D5E776E
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 11:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiIWJmX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 05:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiIWJkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 05:40:45 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82782130BEB
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 02:39:22 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220923093919epoutp01ce43eb2df41fc9d995c5bec709cb9921~Xc9gH24_92118821188epoutp01N
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:39:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220923093919epoutp01ce43eb2df41fc9d995c5bec709cb9921~Xc9gH24_92118821188epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663925959;
        bh=6HR7pDfEWCQApaFHaY1z8P5ClzoEBjIEJhDVePj5Z8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mS9huhtF8Icv35QDt3bH4RcrAy0tWjp3Vc25t5r5NQoVzxTch7jz42CNIl5NoBU+H
         qEER2AsvMVmFKXS0YKAwIIRcLbW8+TjY95QzMhfcvKoY6fQxG5axAnCoPfkC1YeQSf
         pvJSRNB4/GuXtYOJ7Jv/6TiW9oxK97iSG6lYUDh0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220923093918epcas5p432ce7e34fc24a4e400b382e903067bad~Xc9fqoljb0959609596epcas5p4F;
        Fri, 23 Sep 2022 09:39:18 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MYnD32FSVz4x9Pq; Fri, 23 Sep
        2022 09:39:15 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.34.26992.FBE7D236; Fri, 23 Sep 2022 18:39:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220923093910epcas5p2624d93c6cb5caebb5f9203a1b8f4f5b1~Xc9YLx7H10642806428epcas5p2N;
        Fri, 23 Sep 2022 09:39:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220923093910epsmtrp2bae60d8f0d587a644ccb51b87a0ca903~Xc9YLBRyN1242312423epsmtrp2r;
        Fri, 23 Sep 2022 09:39:10 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-32-632d7ebf4c8e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.37.18644.EBE7D236; Fri, 23 Sep 2022 18:39:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220923093908epsmtip286d258d6baaf3a99162cb51a343e44c2~Xc9WiIe1N2720527205epsmtip26;
        Fri, 23 Sep 2022 09:39:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v8 1/5] io_uring: add io_uring_cmd_import_fixed
Date:   Fri, 23 Sep 2022 14:58:50 +0530
Message-Id: <20220923092854.5116-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923092854.5116-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTU3d/nW6ywaItshZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCd8X/WTKaCVUIVL19/ZWpgnMvfxcjJISFgIvGl9xgriC0ksJtRYusX
        7S5GLiD7E6PEy+7fzBDOZ0aJlrsvGWE6Dp5cDpXYxShxd+ZBVriq//c2snUxcnCwCWhKXJhc
        CtIgImAksf/TSbAaZpAVb280soPUCAt4SHxYaQdSwyKgKrGwZSIziM0rYC6x988tZohl8hIz
        L31nB7E5BSwkFm2+xQRRIyhxcuYTFhCbGaimeetssIMkBP6yS3w7MA+q2UVi950uNghbWOLV
        8S3sELaUxOd3e6HiyRKXZp5jgrBLJB7vOQhl20u0nupnBrmTGeiX9bv0IXbxSfT+fsIEEpYQ
        4JXoaBOCqFaUuDfpKSuELS7xcMYSKNtD4nbnWTZI8HQzSqz4/ZFpAqP8LCQvzELywiyEbQsY
        mVcxSqYWFOempxabFhjmpZbD4zU5P3cTIzhhannuYLz74IPeIUYmDsZDjBIczEoivLPvaCYL
        8aYkVlalFuXHF5XmpBYfYjQFhvFEZinR5Hxgys4riTc0sTQwMTMzM7E0NjNUEuddPEMrWUgg
        PbEkNTs1tSC1CKaPiYNTqoHJ5tVBnyrRd9kbdC02CG9o8dIsjq946reh+kFbVMtF1Tm9CV2f
        1+XGnL78Rmtaq2D+i8UdTU969BZOq1z8vuf+TW4X0QPMJnUsn91VeGsnbbHebZHDeaDW+7Fh
        TPkTAwclOWVRrqo6OcX+Hf/jOQo41/WvNJD6MEPrj940FUn+7gmc6XaGJiU7vx/hXfpQ+dv+
        7KhPb/hYX/e2pF1m2WzuzsgYvskmvDeHf/WN2/yWgbHL93L3rZtvVdZiOvNrGc/ZOJ2th9q2
        dnA/zZ17ImXawzXGkfITRTo+mzTJNbtr8Z7RyMkOcshzNBFnaGjUZ1XuE+Z9f/e2uBuvoPr+
        BVsLtF17leLbr6k38FQpsRRnJBpqMRcVJwIAZQAabiEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSvO6+Ot1kg53vRC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJXxf9ZMpoJVQhUvX39lamCcy9/FyMkhIWAi
        cfDkcuYuRi4OIYEdjBJbdz1mh0iISzRf+wFlC0us/PecHaLoI6PEjuXvgRwODjYBTYkLk0tB
        akQEzCSWHl7DAlLDLHCQUeLysycsIDXCAh4SH1bagdSwCKhKLGyZyAxi8wqYS+z9c4sZYr68
        xMxL38F2cQpYSCzafIsJxBYCqvlx6QUjRL2gxMmZICM5gebLSzRvnc08gVFgFpLULCSpBYxM
        qxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgoNdS2sH455VH/QOMTJxMB5ilOBgVhLh
        nX1HM1mINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGJkkl
        /rDf/33Xvbpeuf0R/8b2RqNK6Ye8je1dyzbIZ1w6d2ae5bqgja+THadvz+jq5G6/aRGefL74
        4h+B+K54/907lKX/Fn/WuSGRx3hgdrXThg17Ly132PXMI5GdOVApNvHHmsAClarpvCoZuR3J
        KfKR7np8Bm5mM1sTMt6GrFa8rrwg5rj5v+lb3l1Wu+igqhRx3XJ2b89eqYzFqU1pEx7P6nO9
        tKtlfgSXBpNtrERQZ/vcV4x7JzAnrtyUYbXxbdCFP/M8vFZdyLjxreVMwHbFUsXkR1ZlfxN8
        xR+Jb/h62SDU+m+GVhWn/cLHqQbmb2NPHCl5t2DmF543Aa5771csirl49twevVPdU67eVGIp
        zkg01GIuKk4EABl4Gh/lAgAA
X-CMS-MailID: 20220923093910epcas5p2624d93c6cb5caebb5f9203a1b8f4f5b1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093910epcas5p2624d93c6cb5caebb5f9203a1b8f4f5b1
References: <20220923092854.5116-1-joshi.k@samsung.com>
        <CGME20220923093910epcas5p2624d93c6cb5caebb5f9203a1b8f4f5b1@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

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

