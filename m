Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1809D5F0509
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiI3GnK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiI3GnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:43:07 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046CD1C612C
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:43:04 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220930064302epoutp01faee9009dc2551a6b6a4b294e5c6de08~ZkElc85Xz0097600976epoutp01t
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220930064302epoutp01faee9009dc2551a6b6a4b294e5c6de08~ZkElc85Xz0097600976epoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520182;
        bh=iirM43BcaFmNufDrlcC4cnJ4qMGLT6ODyYNtDEbayfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udMfmdNy3h53CYy1rL82WFdN53ocdsR3GvQ75vBpDmb2uWwvCumPCZtJXP7tzrczb
         AJ5Kg2mpvj3wJD81VHpVOaiz9dkWtkCXicY6B9Xe3DnumeRhY6fZVfdB0wnQO2nXak
         Tpyl9fZNYXR86oYT/d/Ip72Vbxmd4jIh0Wbkajrc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220930064301epcas5p470c8c3a98d97db4ffce9fc1b004f520a~ZkEk94old0991309913epcas5p4G;
        Fri, 30 Sep 2022 06:43:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Mf0zR5QcNz4x9Pv; Fri, 30 Sep
        2022 06:42:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.81.56352.1FF86336; Fri, 30 Sep 2022 15:42:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063805epcas5p2c8eb80f32507f011baedc6d6b4d3f38d~ZkARgs2-G0421904219epcas5p2J;
        Fri, 30 Sep 2022 06:38:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220930063805epsmtrp2029d4b9faa8809abbf41e4dfa7a134c1~ZkARf8VOj2166321663epsmtrp2N;
        Fri, 30 Sep 2022 06:38:05 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-8d-63368ff14d90
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AA.59.14392.DCE86336; Fri, 30 Sep 2022 15:38:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063804epsmtip2eb631af26284418926a8f1c7d83a45c3~ZkAP-bYK-1483614836epsmtip26;
        Fri, 30 Sep 2022 06:38:04 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v12 01/12] io_uring: add io_uring_cmd_import_fixed
Date:   Fri, 30 Sep 2022 11:57:38 +0530
Message-Id: <20220930062749.152261-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmlu7HfrNkg5MneCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMJ8cnsRT8F6zYPfkyYwPjT74uRk4OCQETiV+PPrJ1MXJx
        CAnsZpR48+oFI4TziVFi59LrUM43RomeI2dZYVo6d02FatnLKLH+yDqoqs+MEo2T2thAqtgE
        1CWOPG9lBLFFBIwk9n86yQpSxCxwk1Hi0N5nzCAJYQFvibZP71lAbBYBVYmjj7rBbF4BK4mH
        B56xQKyTl5h56Tt7FyMHB6eAtUTzohyIEkGJkzOfgJUwA5U0b53NDDJfQuAvu8StNT+YIXpd
        JBqnXmeCsIUlXh3fwg5hS0l8freXDcJOl/hx+SlUTYFE87F9jBC2vUTrqX5mkL3MApoS63fp
        Q4RlJaaeWscEsZdPovf3E6hWXokd82BsJYn2lXOgbAmJvecaoGwPiR2TnkEDq49R4vPdvywT
        GBVmIflnFpJ/ZiGsXsDIvIpRMrWgODc9tdi0wDgvtRwezcn5uZsYwYlVy3sH46MHH/QOMTJx
        MB5ilOBgVhLhFS8wTRbiTUmsrEotyo8vKs1JLT7EaAoM74nMUqLJ+cDUnlcSb2hiaWBiZmZm
        YmlsZqgkzrt4hlaykEB6YklqdmpqQWoRTB8TB6dUAxPDQq7fCUGuWUdswk/OuZ9f3nW/UlDb
        +Jjvy6uJrNqHF0XP9Bb6mBq4R/ObmEz0Bs4093MuUe6H9t850qB3o7n6mDn7TI/+rcflPVcE
        5a/67rh19W+2m4cnl4Qd8T6y4WxQUd30C72WXwIN2s3j9si+Xu86vWKS393Ns0IPLWK/zTX9
        tNMx1bfTF8Wuq3KPfv/8bVbTVf/osqsNP7jWHRRi2pQ2fZLYCX/r5St9PLKYqqqL9zG/X6Ju
        EW+3rZg7+l/SDvW9GRJyZ4u22Pxd7Lt6z0bWefszGJYmP+5Pai22EqjZUur7vuvaV5tClZCJ
        7JPXhj9qvHLtpM6Jz0W2nzdd8+hy2VNd3rTeqMPkrLASS3FGoqEWc1FxIgDFK+ZONQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO7ZPrNkg127NCyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aT45NYCv4LVuyefJmxgfEnXxcj
        J4eEgIlE566pbF2MXBxCArsZJR7u+MIIkZCQOPVyGZQtLLHy33N2iKKPjBJP9v1kBkmwCahL
        HHneClYkImAmsfTwGhYQm1ngPqPEgu4QEFtYwFui7dN7sDiLgKrE0UfdYDavgJXEwwPPWCAW
        yEvMvPQdaAEHB6eAtUTzohyQsBBQyec979khygUlTs58AjVeXqJ562zmCYwCs5CkZiFJLWBk
        WsUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERz2Wpo7GLev+qB3iJGJg/EQowQHs5II
        r3iBabIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTIeO
        sd4r/tv9Wb/hVeLbRS8LLwpksb96r230Kv6IqX7CxKk3bqqL/D1S8niDipN70fMe6+0zVvpx
        ZSwRExeyTn77Z237bTMG/vcHPFdPPzjlc9eGZY7/+3p/enSp2K1T4bMx5AkWXZV045xoRLbD
        KwltYXVJq2PptsK/qjiWNkX9q+ZT3cFp+2K518pbm3dpaW/bcOvDIj8Tc84lMjmM5f5yKWeu
        2754FPDF+tNymzWGjCJfZ4d93bLybr/qycbnFtPPZAQUHsitM+gLjyy8UahTrL3Ra7qxEd/0
        4rUHb3XGdkS+Mv3CuvLFFbEUvQ2pmt5/X+28e3+y8GveQrnVis+mCkx+8/wlH1/qpW0bbJRY
        ijMSDbWYi4oTAYjiMrzqAgAA
X-CMS-MailID: 20220930063805epcas5p2c8eb80f32507f011baedc6d6b4d3f38d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063805epcas5p2c8eb80f32507f011baedc6d6b4d3f38d
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063805epcas5p2c8eb80f32507f011baedc6d6b4d3f38d@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

