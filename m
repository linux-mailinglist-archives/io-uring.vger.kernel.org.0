Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4075AB576
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiIBPlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiIBPki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:40:38 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBCB79ED8
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 08:27:15 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220902152710epoutp02881e6882bf4cc677c26c29c0df5dd796~RFKOSIMVS1948519485epoutp025
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 15:27:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220902152710epoutp02881e6882bf4cc677c26c29c0df5dd796~RFKOSIMVS1948519485epoutp025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662132430;
        bh=A9eeh4RBJYaAco8jXNywjr3avubLO7fkkdnIseGNno0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKNYzuyoa2kIzfmmsYa6+/whVTa9bEfb9nayWEqU3SPb9EBWGDNZ8XnOCd48P3GNV
         jU1jlCCpq0a4p0JjgXQpf3r/FpvbHqP+dEIlatwqOywZ9GCofxAnYLGW1+E4LaVoSx
         YCQvSwR1WouuLPTLs936jAV04VIhkmuAKoI/GX8I=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220902152709epcas5p45ab565a5f3ec4ae2332904a0d94f8a14~RFKNtBsIV1431014310epcas5p4R;
        Fri,  2 Sep 2022 15:27:09 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MK1x71x7lz4x9Pp; Fri,  2 Sep
        2022 15:27:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.AE.54060.BC022136; Sat,  3 Sep 2022 00:27:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220902152706epcas5p11f1a11710a6ba985f4679a5cfe131bf8~RFKKdBa4z2163521635epcas5p1d;
        Fri,  2 Sep 2022 15:27:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220902152706epsmtrp20fbe6a87fdee07c0b120417cc49d97e5~RFKKb672S0776407764epsmtrp2c;
        Fri,  2 Sep 2022 15:27:06 +0000 (GMT)
X-AuditID: b6c32a4b-e33fb7000000d32c-40-631220cb0c2c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D5.BE.18644.9C022136; Sat,  3 Sep 2022 00:27:06 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220902152704epsmtip243a97ccab43acdb3d30aae73a246015e~RFKI58CXx1851718517epsmtip2O;
        Fri,  2 Sep 2022 15:27:04 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v3 1/4] io_uring: introduce
 io_uring_cmd_import_fixed
Date:   Fri,  2 Sep 2022 20:46:54 +0530
Message-Id: <20220902151657.10766-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220902151657.10766-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmlu5pBaFkgy9bOC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM7omjKHpWC1UMXWoz0sDYxr+bsYOTkkBEwkOs+t
        Ze1i5OIQEtjNKLHiy2smCOcTo8SRf80sEM5nRomdbxuZYFrW3XwFVbWLUWLtowPMcFXrJx1i
        72Lk4GAT0JS4MLkUpEFEwEvi/u33YDuYQXa8vdHIDpIQFgiQWHPmFSuIzSKgKvHsUgcLiM0r
        YCGx+8g1Roht8hIzL30Hq+cUsJR4evUNK0SNoMTJmU/A6pmBapq3zgY7QkKgl0Piy6PjzBDN
        LhK3H5yFOltY4tXxLewQtpTE53d72SDsZIlLM89B1ZRIPN5zEMq2l2g91c8M8gwz0DPrd+lD
        7OKT6P39hAkkLCHAK9HRJgRRrShxb9JTVghbXOLhjCWsECUeEu/fZUOCp4dRYuvSfvYJjPKz
        kHwwC8kHsxCWLWBkXsUomVpQnJueWmxaYJyXWg6P2OT83E2M4DSq5b2D8dGDD3qHGJk4GA8x
        SnAwK4nwTj0skCzEm5JYWZValB9fVJqTWnyI0RQYxBOZpUST84GJPK8k3tDE0sDEzMzMxNLY
        zFBJnHeKNmOykEB6YklqdmpqQWoRTB8TB6dUA9MxLX51ZX1W3j+pSR/zV57Pmb7A7KiN3BXb
        JEERgVMmqRwF1Y5fDlhJnGedpP/rT/8yy/qTimsZNtxlPfBO59UrzoSbRwMsBN1UV52db/d0
        stw5k0pP87RF1eIXfdVPfvlW02/CbPLV6fHNN/qWzG3y1km8dTNzrH76JKeXn9jmcFs+roZ1
        plrJkeDIlOxdW/6XWS77LFEk/v7Lcdlag8wbHmXHl2yK6Q/Qnr/q0fKPLOfYlr/I+tbJrrjR
        6K/KzMfzLI+seDDn/5mKotiK4Po3HtJzegozFbR+r4kovuLAoDspL68/8rWistrDZxczVe5F
        /jgi/emb7RxuNS7rEgOxLbErDrzua9rw/epDNyWW4oxEQy3mouJEAKEJ4PssBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvO4pBaFkg6NvmCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZXRNmcNSsFqoYuvRHpYG
        xrX8XYycHBICJhLrbr5i6mLk4hAS2MEoceXnUiaIhLhE87Uf7BC2sMTKf8/ZIYo+Mkp8ef2X
        uYuRg4NNQFPiwuRSkBoRgQCJg42XwWqYBQ4ySlx+9oQFJCEs4CexbeJeRhCbRUBV4tmlDrA4
        r4CFxO4j1xghFshLzLz0HWwZp4ClxNOrb1hBbCGgmh2TdrJB1AtKnJwJMZMZqL5562zmCYwC
        s5CkZiFJLWBkWsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERwDWlo7GPes+qB3iJGJ
        g/EQowQHs5II79TDAslCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
        yTJxcEo1MNmw2X7dx+Cq49v9XHvntXuOq7vmXgnr3PC9P94/wTnr7lum438XMnlNS5kUrNzv
        eLXu4jRX+fXyXm8vrr7Ses3KuGvqwbxJW/tCQnhUzpUd4PtxRqY0myfkqvEyPfOVR86JbRfy
        znnjmHzt8u1T2X8+fT107KPVIq8Auen/o4Xn7TmWqyIR/HT1Ee5YnXN/Tx35KsUeHbp7Zuzz
        YPPoR4V5u7dr+j8ROyYirH22d9I+BZeZl/tXbrn5cQLf7GzHzcX31PvYGHqTRE5+dOHMfiwT
        aaDzR6+zhiHv/4Kqr+1rvH7xHY06NPdUXH/z9tD3U/0v/D1zWSk5O0nscJb12SVtmukf7XVU
        u//UrBO4eFyJpTgj0VCLuag4EQCF6oxX8AIAAA==
X-CMS-MailID: 20220902152706epcas5p11f1a11710a6ba985f4679a5cfe131bf8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902152706epcas5p11f1a11710a6ba985f4679a5cfe131bf8
References: <20220902151657.10766-1-joshi.k@samsung.com>
        <CGME20220902152706epcas5p11f1a11710a6ba985f4679a5cfe131bf8@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 io_uring/uring_cmd.c     | 11 +++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 58676c0a398f..dba6fb47aa6c 100644
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
+		struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *));
@@ -59,6 +62,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
+		struct iov_iter *iter, void *ioucmd)
+{
+	return -1;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 6f99dbd5d550..8cddd18ad10b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -7,6 +7,7 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "rsrc.h"
 #include "uring_cmd.h"
 
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
@@ -124,3 +125,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
+
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_mapped_ubuf *imu = req->imu;
+
+	return io_import_fixed(rw, iter, imu, ubuf, len);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
-- 
2.25.1

