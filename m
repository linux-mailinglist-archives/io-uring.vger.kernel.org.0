Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7CA5E95E6
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiIYUd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 16:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIYUd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 16:33:28 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEE52BE35
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 13:33:26 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220925203324epoutp019e4a6f342893f0d4c963f19c6590e008~YNLLL1kZ_1134511345epoutp01Z
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 20:33:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220925203324epoutp019e4a6f342893f0d4c963f19c6590e008~YNLLL1kZ_1134511345epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664138004;
        bh=6HR7pDfEWCQApaFHaY1z8P5ClzoEBjIEJhDVePj5Z8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3II1XB6Mb7JpZKItp7rO3WCn/rEjf0oGX80oUnUDSFJjHTgZl/vqw9pzGgBF+MuH
         6wHY9/4hxtUADBWmPMiKopI3THnk0O5dMz6QgknDEgj+nXTycRDtzH/WYH4R/E9K3A
         kWMOcryzoIY5ZH+jdjJ/2FPZN5rSv4qcY0tgiIq0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220925203324epcas5p46e2107b0bbd681ebbfee7daaef224a26~YNLKeelDl2831828318epcas5p40;
        Sun, 25 Sep 2022 20:33:24 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MbHds6wTTz4x9Pr; Sun, 25 Sep
        2022 20:33:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0B.9F.26992.11BB0336; Mon, 26 Sep 2022 05:33:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220925203320epcas5p28fcc3c9ff8669c56213547725ea71001~YNLHVM4Hy0635906359epcas5p2N;
        Sun, 25 Sep 2022 20:33:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220925203320epsmtrp1f4b4dce3b8bf644757873c2e902fcfcf~YNLHUcKFT1867318673epsmtrp1T;
        Sun, 25 Sep 2022 20:33:20 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-19-6330bb11bc5e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.01.14392.01BB0336; Mon, 26 Sep 2022 05:33:20 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203317epsmtip194879d7811d4001d91d4eab2979d16df~YNLEvpQMm0205602056epsmtip1K;
        Sun, 25 Sep 2022 20:33:17 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v9 1/7] io_uring: add io_uring_cmd_import_fixed
Date:   Mon, 26 Sep 2022 01:52:58 +0530
Message-Id: <20220925202304.28097-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220925202304.28097-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTU1dwt0GyQcsyU4umCX+ZLVbf7Wez
        uHlgJ5PFytVHmSzetZ5jsTj6/y2bxaRD1xgt9t7Stpi/7Cm7A6fH5bOlHptWdbJ5bF5S77H7
        ZgObR9+WVYwenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
        2iq5+AToumXmAJ2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L
        18tLLbEyNDAwMgUqTMjO+D9rJlPBKqGKl6+/MjUwzuXvYuTgkBAwkdj33a2LkZNDSGA3o8T+
        09FdjFxA9idGiU87dzBBON8YJdYdWscIUgXS0Ht4HzNEYi+jxPcHy1khnM+MEgf+HmUBGcsm
        oClxYXIpSIOIgJHE/k8nwWqYQVa8vdHIDpIQFvCQmNh+nQnEZhFQlTj2rIcVxOYVsJA4+uk9
        E8Q2eYmZl76D1XMKWEo8mbuVGaJGUOLkzCcsIDYzUE3z1tlgF0kI/GWX2LLzMzNEs4vEk/7b
        7BC2sMSr41ugbCmJl/1tUHayxKWZ56CWlUg83nMQyraXaD3VzwzyDDPQM+t36UPs4pPo/f2E
        CRJ0vBIdbUIQ1YoS9yY9ZYWwxSUezlgCZXtIHJk/hx0SPj2MEudmPGWbwCg/C8kLs5C8MAth
        2wJG5lWMkqkFxbnpqcWmBYZ5qeXweE3Oz93ECE6YWp47GO8++KB3iJGJg/EQowQHs5IIb8pF
        3WQh3pTEyqrUovz4otKc1OJDjKbAMJ7ILCWanA9M2Xkl8YYmlgYmZmZmJpbGZoZK4ryLZ2gl
        CwmkJ5akZqemFqQWwfQxcXBKNTD5ub7fUCUUu46Hz2RO+O59yk+yTvHG84bMuCd5zkIgJSDc
        pvODucCNu58edqp/4OE6ZBK2Z/elLe/2u79ft72/rf2ARYzI5mknfL/f8G6MYKvrmcz6r6ZM
        nGMH9+uuBwbSQqzmrHW5ZYYViYXPjbhPbQ8VydvkPefquR38db4/tdeeT9oub8t6qdSkZNUR
        vwMyjf25tp7X5qQH9U921pLZeinP6Pz017/Ft7fNl7Dmndbjerdyh/+MGKkv+hErbZKmb1/q
        63DV82up6avDzxdYKMuL9eRM+/gpdYrP10rzmV6JMqvq9/3cKbLlVt0V+X0rMibu0zdm3969
        W1KUMSFpRgJXMO9LV22eb8+Pb1RiKc5INNRiLipOBABrhmfHIQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnK7AboNkgyMPVSyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJXxf9ZMpoJVQhUvX39lamCcy9/FyMkhIWAi
        0Xt4H3MXIxeHkMBuRon35xYyQyTEJZqv/WCHsIUlVv57zg5R9JFRYnrXBqYuRg4ONgFNiQuT
        S0FqRATMJJYeXsMCUsMscJBR4vKzJywgCWEBD4mJ7deZQGwWAVWJY896WEFsXgELiaOf3jNB
        LJCXmHnpO9gyTgFLiSdztzKDzBcCqtl6XguiXFDi5EyIkcxA5c1bZzNPYBSYhSQ1C0lqASPT
        KkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4GDX0tzBuH3VB71DjEwcjIcYJTiYlUR4
        Uy7qJgvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA1Gn5
        SOHt3rNLRM2MVC+Zsf89JWlwYtZnuUTh/uLfRd/DJskdFFazd77I85bpos3zv3d2BGY+WXV4
        6q7GiamS/y4davJPX++TlSm+QmSP9NPTJRu91h56aF2rJNYZfksuyz2oYeG8zy4JK0zXV0k8
        yupgiX0yJ8NZztXstNfE2tN++iZHdaayHzs492rZhN78knlPamVj/okJJyTeEe34sv/ebjlF
        wesvLU9cU1h9+fPBKQGbntx2Lg/+c/h4wYbbqqvEtu7iDGDTvx700XZ511+3Pb3zjXe9Ndlk
        Lbt6ZdFVi7UtlSxVD9QMucVS07dWmdzlSDO5vjn01sGQ++2LDSUyH92TXHGkkX9usxaTtRJL
        cUaioRZzUXEiALY3/5zlAgAA
X-CMS-MailID: 20220925203320epcas5p28fcc3c9ff8669c56213547725ea71001
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220925203320epcas5p28fcc3c9ff8669c56213547725ea71001
References: <20220925202304.28097-1-joshi.k@samsung.com>
        <CGME20220925203320epcas5p28fcc3c9ff8669c56213547725ea71001@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

