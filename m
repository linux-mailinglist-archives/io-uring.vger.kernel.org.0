Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682FB5B3548
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 12:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiIIKby (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 06:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiIIKbu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 06:31:50 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BB17D79E
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 03:31:44 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220909103140epoutp013925a23853239267c0fb8eeb868c15d9~TKpOcAsLq2341123411epoutp01e
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 10:31:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220909103140epoutp013925a23853239267c0fb8eeb868c15d9~TKpOcAsLq2341123411epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662719500;
        bh=6HR7pDfEWCQApaFHaY1z8P5ClzoEBjIEJhDVePj5Z8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Op1vqTEOQ3+FmH6OUxYfYFXzocDXCwNpPHKAAXJrh5EPhTpNVPdd+ppJfOoo8UW+H
         xjtyWwA6rGvFzjqABvWG8U+Iw1P3djvttdiXwWP2t50GhK00bpiqD+ChnC9uVBm03p
         1HxVkrVreI3TLeaV1BeCnPbgF9loya3KszXYEC2U=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220909103140epcas5p2371303ab561b508bde5501e32d028c26~TKpNxjnUM0262302623epcas5p29;
        Fri,  9 Sep 2022 10:31:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MPC2x4W2pz4x9Pr; Fri,  9 Sep
        2022 10:31:37 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.E6.54060.8061B136; Fri,  9 Sep 2022 19:31:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220909103136epcas5p38ea3a933e90d9f9d7451848dc3a60829~TKpJ8Miwn0111801118epcas5p3F;
        Fri,  9 Sep 2022 10:31:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220909103136epsmtrp26702fdbfbf713f153a92cc867912fca9~TKpJ7UWau1218912189epsmtrp2J;
        Fri,  9 Sep 2022 10:31:36 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-7d-631b160811f8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.61.14392.7061B136; Fri,  9 Sep 2022 19:31:35 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220909103134epsmtip177a23b114855293c91cfba5ac5b52f46~TKpIIYZwN1204612046epsmtip1Y;
        Fri,  9 Sep 2022 10:31:34 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v7 1/5] io_uring: add io_uring_cmd_import_fixed
Date:   Fri,  9 Sep 2022 15:51:32 +0530
Message-Id: <20220909102136.3020-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909102136.3020-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmli6HmHSywd5rchZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
        dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTk
        FJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGf8nzWTqWCVUMXL11+ZGhjn8ncxcnJICJhIXOxa
        x97FyMUhJLCbUWLFpaOsEM4nRolZuz4yQjjfGCX2nehig2m5ffw7E0RiL6PE8r6/UP2fGSU2
        Xr8E1M/BwSagKXFhcilIg4iAl8T92+/BxjKD7Hh7o5EdJCEs4CGxaOMxFhCbRUBVonXBFSYQ
        m1fAXOLMvL9MENvkJWZe+g5WzylgITH58zV2iBpBiZMzn4D1MgPVNG+dzQyyQEKglUPi+tlf
        jBDNLhIbn72CsoUlXh3fwg5hS0l8frcX6p1kiUszz0EtK5F4vOcglG0v0XqqnxnkGWagZ9bv
        0ofYxSfR+/sJE0hYQoBXoqNNCKJaUeLepKesELa4xMMZS6BsD4lfS5exQMKnm1Hi66efTBMY
        5WcheWEWkhdmIWxbwMi8ilEytaA4Nz212LTAOC+1HB6zyfm5mxjBiVTLewfjowcf9A4xMnEw
        HmKU4GBWEuEVXSuRLMSbklhZlVqUH19UmpNafIjRFBjGE5mlRJPzgak8ryTe0MTSwMTMzMzE
        0tjMUEmcd4o2Y7KQQHpiSWp2ampBahFMHxMHp1QDU/DCxI1mPzXOZ23kDyz9m+rWcfFjXY6c
        8pTwrvu/zfdHpSn+urXF4NacQ0weuzbyp03erhy7MTRz3kTOF9Nkjl61/DTVMnNdl2h9xJ7G
        KO2NXeyeAS/+zpYPt7Tj4NZi1D7Se4nH6ECYxtq5SQdEhK5fn1cu5iow7YRv4INuhvxJu8s9
        XI1SskIZ/iVLSbqZ1eXm8SyXvR5/tTXtdY7g1KqqaZYWChefGb+S/3CqcB6ni0CJtmZ6SeC5
        JXM0g4sn+x0zivD+GxJQPFvi7vnn5mueeRx8yu/Q8PFw36T37zrjqqxfHdsRWLF9RdiLhVlP
        Va65z3Bb01BkYhXyz9Q88vxJ76+q90T+7gq4cPWBEktxRqKhFnNRcSIAozxUzy0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSnC67mHSywYFZ1hZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Mv7PmslUsEqo4uXrr0wN
        jHP5uxg5OSQETCRuH//O1MXIxSEksJtRYvP/TiaIhLhE87Uf7BC2sMTKf8/ZIYo+MkqcXn4G
        qIiDg01AU+LC5FKQGhGBAImDjZfBapgFDjJKXH72hAUkISzgIbFo4zEwm0VAVaJ1wRWwBbwC
        5hJn5v2FWiYvMfPSd7BlnAIWEpM/XwOzhYBqXu/8xAJRLyhxcibETGag+uats5knMArMQpKa
        hSS1gJFpFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcAxoae5g3L7qg94hRiYOxkOM
        EhzMSiK8omslkoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLg
        lGpgSjNhj5qd/LMydte76I+x88oEBNwe+c2/05trtHBrsH7V8RXsqy7+rJbazD954cPG6mRh
        E7f7t2a8ZG/Y9DlnUcfXvX5dc3/pf4u+x6Ry1tJq97LUxVdmF5znW6b98mtvgco8eflJxgls
        jxIsLxpdFatslpIRKef3Pnnstty6mrCVUc+Y45a01N8xqGlvzq6slk1RyDxwQTLf7jPbpPXH
        qm+bXZC95msXUFBXpWXwd6vbhl//37jv3hVoGXHmr8PE9orXRd/Pdqmp+JYVnBSzuzxp/Y57
        D152OMxftUqu8EO20N7ttRPD9Y9Ma3Y+W6L1mEluysTE2xdzctyTr/9id1z9U7Bj7ZlipSt8
        YspblViKMxINtZiLihMBYLEBF/ACAAA=
X-CMS-MailID: 20220909103136epcas5p38ea3a933e90d9f9d7451848dc3a60829
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103136epcas5p38ea3a933e90d9f9d7451848dc3a60829
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103136epcas5p38ea3a933e90d9f9d7451848dc3a60829@epcas5p3.samsung.com>
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

