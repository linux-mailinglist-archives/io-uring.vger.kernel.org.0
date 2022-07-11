Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79D570092
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 13:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiGKL2y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 07:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiGKL2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 07:28:17 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8387B3AB
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 04:08:08 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220711110805epoutp016d889a3b87901121c01a2f3956a26feb~Awb4V966t1720717207epoutp01Q
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:08:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220711110805epoutp016d889a3b87901121c01a2f3956a26feb~Awb4V966t1720717207epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657537685;
        bh=Aj0orf3AGy8lpupI9YMEcuCUCc0IMiiZ5gDc6E5twOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaIKSCyHeYzQ4btrxO2LJHcqxndWA6z/KIzA7a19mtdyKD27FD+y188+qQIMvoM+q
         RwrVKP/ICPmFW1AY8ih3qI6E+AQPYyQ/FqiaB5l7n/9sGhGzMJURcJ/95L0+QglWfy
         i4oAwPJVTbO1TIpSOUpioumzW6SrCpJuY0Wnvncc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220711110803epcas5p12fe9f15cf54651f14188c1083cbc1b25~Awb3R-3b61352413524epcas5p1K;
        Mon, 11 Jul 2022 11:08:03 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LhLhc6fBTz4x9Py; Mon, 11 Jul
        2022 11:08:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.5A.09639.0940CC26; Mon, 11 Jul 2022 20:08:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220711110800epcas5p3d338dd486fd778c5ba5bfe93a91ec8bd~Awb0EQons0447004470epcas5p39;
        Mon, 11 Jul 2022 11:08:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220711110800epsmtrp25c9e35a541affd9ca4c353fe9b9c9a81~Awb0DWm0Y2556725567epsmtrp26;
        Mon, 11 Jul 2022 11:08:00 +0000 (GMT)
X-AuditID: b6c32a4b-e83ff700000025a7-de-62cc0490fb1c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.9A.08905.0940CC26; Mon, 11 Jul 2022 20:08:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220711110756epsmtip2a684f6bf482c84b759d98ae7414b7895~Awbwk_d090333603336epsmtip2O;
        Mon, 11 Jul 2022 11:07:56 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next 1/4] io_uring, nvme: rename a function
Date:   Mon, 11 Jul 2022 16:31:52 +0530
Message-Id: <20220711110155.649153-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711110155.649153-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmhu4EljNJBlPfGFs0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaLSYeuMVrsvaVtMX/ZU3aLda/fszjw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHn1bVjF6fN4kF8ARlW2TkZqYklqkkJqX
        nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SrkkJZYk4pUCggsbhYSd/O
        pii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE740DLOZaCd2IVvY+u
        MTUwnhPuYuTkkBAwkfi67TdTFyMXh5DAbkaJru4frBDOJ0aJRY1b2CCcb4wSk18uY+9i5ABr
        +X/XASK+l1HiRMNDqI7PjBJT7r4BK2IT0JS4MLkUZIWIgItEZ9N0sBpmgbuMEg27VjOCJIQF
        7CWudsxlA7FZBFQlVl+aDxbnFbCUmDNhCQvEffISMy99ZwexOQWsJGZu/wdVIyhxcuYTsBpm
        oJrmrbOZQRZICCzkkPg3/Q8TRLOLxL+1m5ghbGGJV8e3sEPYUhKf3+1lg7CTJS7NPAdVXyLx
        eM9BKNteovVUPzPIM8xAz6zfpQ+xi0+i9/cTJkhA8Ep0tAlBVCtK3Jv0lBXCFpd4OGMJlO0h
        cX1qM9jJQgK9jBL7zhRPYJSfheSDWUg+mIWwbAEj8ypGydSC4tz01GLTAuO81HJ4vCbn525i
        BKdYLe8djI8efNA7xMjEwXiIUYKDWUmE98/ZU0lCvCmJlVWpRfnxRaU5qcWHGE2BQTyRWUo0
        OR+Y5PNK4g1NLA1MzMzMTCyNzQyVxHm9rm5KEhJITyxJzU5NLUgtgulj4uCUamBye97S9N/N
        TGPJosY35T9Ud+zICBJUKTCa+fPUxd+rJNJ80nYFXzadFJG2ze6Ab1FUxfz675sv+8mVt4sW
        ilS+nVOyLdtkw8PWE1cdvukkNd3tDwiscukpsrW1zvsyy1zvuMSDuv6XAX+Zvz17eWHBcn7l
        XxvMLhTqqNVGrvuV2lSaJhzoF7BB0+tS6IEZv+3/rHV2aZ5iUahZYtByrsuhq/hsvtX/SeI7
        Pt08d7Z/xXtrpu6rV2Ye4FH8ILHS4vSRuEk/te5VTizLSGOUM2QsNNyct+PEebaLWoV2sQV9
        c7O7V93qFv/gd3LN/6UXnn+yqznPUPWrMHz50785t7fcNnZI+DO5/zPv0VNLUmqVWIozEg21
        mIuKEwGPnRbOOgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvO4EljNJBlP/8Vs0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaLSYeuMVrsvaVtMX/ZU3aLda/fszjw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
        wJVxoOUcS8E7sYreR9eYGhjPCXcxcnBICJhI/L/r0MXIxSEksJtR4uzX+2xdjJxAcXGJ5ms/
        2CFsYYmV/56zQxR9ZJS4+nw9I0gzm4CmxIXJpSA1IgJeEit6/jCB1DALPGWUmDyrnxEkISxg
        L3G1Yy7YUBYBVYnVl+aDxXkFLCXmTFjCArFAXmLmpe9gyzgFrCRmbv8HViMEVHPq7kwmiHpB
        iZMzn4DVMwPVN2+dzTyBUWAWktQsJKkFjEyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNz
        NzGC40NLcwfj9lUf9A4xMnEwHmKU4GBWEuH9c/ZUkhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
        C10n44UE0hNLUrNTUwtSi2CyTBycUg1MAl4ygnvDIpUqGguWun04cWXvl2DhK3Wyd7zqDbrm
        nv9z9kQ074S6bxzKu3v6U+T0L0oK79Ta9Z5bZXp7w4GV03IaD1eHiH+X4784z/KVGUc3a+PK
        LfKhM2z7O7PkM1d925680sSG+/7/BZ+2frkk7HVhwVtb9px+QzdGz6YtR5Tf2VT39MYsUChk
        CDudUBnmetJ+R31GcUC/zXu1CM752mkPF3D0C683W6J8sGnzl61qCY03wuRCmbRFvjhf4SqJ
        uZDWfWbBHIWqm89KjSY9E/Bs3eph72E+OWjNjGrBLra7C+Vv56TdlFu/6YxzaPiGXW+yMrZN
        TomcYlfw+Fes/bR+0ff5Jccu/ExfU6HEUpyRaKjFXFScCAACFG9b/gIAAA==
X-CMS-MailID: 20220711110800epcas5p3d338dd486fd778c5ba5bfe93a91ec8bd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110800epcas5p3d338dd486fd778c5ba5bfe93a91ec8bd
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110800epcas5p3d338dd486fd778c5ba5bfe93a91ec8bd@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_cmd_complete_in_task() is bit of a misnomer. It schedules a
callback function for execution in task context. What callback does is
private to provider, and does not have to be completion. So rename it to
io_uring_cmd_execute_in_task() to allow more generic use.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 2 +-
 include/linux/io_uring.h  | 4 ++--
 io_uring/uring_cmd.c      | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a2e89db1cd63..9227e07f717e 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -395,7 +395,7 @@ static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
 	pdu->req = req;
 	req->bio = bio;
 	/* this takes care of moving rest of completion-work to task context */
-	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
+	io_uring_cmd_execute_in_task(ioucmd, nvme_uring_task_cb);
 }
 
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 4a2f6cc5a492..54063d67506b 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -29,7 +29,7 @@ struct io_uring_cmd {
 
 #if defined(CONFIG_IO_URING)
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+void io_uring_cmd_execute_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
@@ -59,7 +59,7 @@ static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2)
 {
 }
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+static inline void io_uring_cmd_execute_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *))
 {
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 0a421ed51e7e..d409b99abac5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -16,7 +16,7 @@ static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
 	ioucmd->task_work_cb(ioucmd);
 }
 
-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+void io_uring_cmd_execute_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *))
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
@@ -25,7 +25,7 @@ void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 	req->io_task_work.func = io_uring_cmd_work;
 	io_req_task_work_add(req);
 }
-EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
+EXPORT_SYMBOL_GPL(io_uring_cmd_execute_in_task);
 
 static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 					  u64 extra1, u64 extra2)
-- 
2.25.1

