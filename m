Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB455AB581
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiIBPlZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbiIBPlI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:41:08 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BBB13D4F
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 08:28:54 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220902152851epoutp0413be37acda95c0f794c78eff2f026bae~RFLs9GwqQ0532605326epoutp04G
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 15:28:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220902152851epoutp0413be37acda95c0f794c78eff2f026bae~RFLs9GwqQ0532605326epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662132531;
        bh=R/7IxdDqZAFv1UkLuGaTnie2Vp6DVZlh+y9vQjzdh70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHP8sum6MxyhMtHvALoUPKmPAdSkYyowPrG+1IJ2rPheMX1/Yc16g89yehhK7pYcB
         kkl8DqBTs4hp0oNx9XxcG4a6+0uHDSqqVnt189IG0sVux+RfejQKfm6ZNBPWWQofQ9
         7vDbKAOuMaUifsssq17kKMj1G3pjuMy6HSWUHxk8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220902152851epcas5p3a505991ca6dbf1db9ed1d487f68f7f31~RFLsOysd51431414314epcas5p3t;
        Fri,  2 Sep 2022 15:28:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MK1xK5cQLz4x9Pv; Fri,  2 Sep
        2022 15:27:17 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.D5.59633.5D022136; Sat,  3 Sep 2022 00:27:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220902152717epcas5p26905ce7cb48e9d278976a301d73c297f~RFKUt6TBl0881008810epcas5p2J;
        Fri,  2 Sep 2022 15:27:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220902152717epsmtrp10650adaa11baa1794771ba9f9f2cc073~RFKUtHqKo2718227182epsmtrp1Z;
        Fri,  2 Sep 2022 15:27:17 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-ec-631220d5651d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.BE.18644.4D022136; Sat,  3 Sep 2022 00:27:17 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220902152715epsmtip22bfcaff5914460519ecbe6fcc63a1c98~RFKTRlgV_1295812958epsmtip25;
        Fri,  2 Sep 2022 15:27:15 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v3 4/4] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Fri,  2 Sep 2022 20:46:57 +0530
Message-Id: <20220902151657.10766-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220902151657.10766-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmhu5VBaFkgwsLtCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM44NHM+Y8Ff5YqnB6ewNjAulO1i5OSQEDCRWPXy
        P1sXIxeHkMBuRomTD+eyQDifGCXW/F3FAlIlJPAZyLleDdOxuP8vVNEuRon79+cxwxV9mCnU
        xcjBwSagKXFhcilIWETAS+L+7fesIPXMIBtW/33LCpIQFoiSWDjrAFgvi4CqxPWXr9lAbF4B
        C4muf8sYIZbJS8y89J0dxOYUsJR4evUNK0SNoMTJmU/AjmMGqmneOpsZor6XQ+LmNXkI20Xi
        6d9JbBC2sMSr41vYIWwpiZf9bVB2ssSlmeeYIOwSicd7DkLZ9hKtp/qZQX5hBvpl/S59iFV8
        Er2/nzCBhCUEeCU62oQgqhUl7k16ygphi0s8nLEEyvaQuPJ7FzMkqHoYJZZMv8I0gVF+FpIP
        ZiH5YBbCtgWMzKsYJVMLinPTU4tNCwzzUsvh0Zqcn7uJEZxCtTx3MN598EHvECMTB+MhRgkO
        ZiUR3qmHBZKFeFMSK6tSi/Lji0pzUosPMZoCg3gis5Rocj4wieeVxBuaWBqYmJmZmVgamxkq
        ifNO0WZMFhJITyxJzU5NLUgtgulj4uCUamCSeRArI3b/X+bxM3JRvH8WSPfl9dgGpD1mP7iu
        ZW1qzd/T+u8fR9Xee87pK160zz/I8lFI2Qr+Y5yxq92KesP8v01ofLJ4tdUu9idb1XPm2Rvu
        XZjdd//+ckl7fpMsqfRMbW+TzsUdM7mOzn9g8F/UpFDDiendxNMVyZY3TsVsln3CK72qNVPd
        26Nh4pOrDyet1n5jc4137pdzy5MMbnNczY4/U7P5W6Iog4GLvarptMh8vbmy5qbSV7Orep9X
        X+d78F9u0aLJSknbvdaknln4/82+a2qlGRFXv048wbyF6e/vXTfcQue/CJIy3hJ3rqxjs3jc
        Qz1n3YqGR1vqQ+Q4BdbWK7i73w/nad/y3FaJpTgj0VCLuag4EQAOP+vaKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvO5VBaFkg+V7mCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZRyaOZ+x4K9yxdODU1gb
        GBfKdjFyckgImEgs7v/L0sXIxSEksINRoqvpJzNEQlyi+doPdghbWGLlv+fsEEUfGSU6H25m
        62Lk4GAT0JS4MLkUpEZEIEDiYONlsBpmgYOMEuebvrGAJIQFIiQeNP8Hs1kEVCWuv3zNBmLz
        ClhIdP1bxgixQF5i5qXvYMs4BSwlnl59wwpiCwHV7Ji0E6peUOLkzCdgc5iB6pu3zmaewCgw
        C0lqFpLUAkamVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwTGgpbWDcc+qD3qHGJk4
        GA8xSnAwK4nwTj0skCzEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKY
        LBMHp1QDk+uVilaHy/sZDvxvKZK82PXV27BK7J3FZD4RR64Zf+Zx5SQuayu4VDNV67pZe3Hj
        LOcPn85+5uCbw///ZX7h3RZ3T8kDEjZ/b5pemv7vl8aJjx4vPm3Zu77K+/S7m3MubbK2L9H/
        UL6pevOXjr/39RVftnZ6rpQ9eyct+MWxw8u61qpzmNXfy0/IffXFecUilTtuM7SnSt+dUmFc
        92zh0oSGr7l/tvM6GQp1OaTZbZCd/dblbNPTm95bn3508zGf75euIMMWXuB8j9mySXlKo9zR
        Z983993kX7UzkMXuiPk03tuKfidvvF1p7KoyK+lhMAt7m7XWrEMbHheeO5rykMv/8fvFDiVP
        390LuO340leJpTgj0VCLuag4EQAmfqSK8AIAAA==
X-CMS-MailID: 20220902152717epcas5p26905ce7cb48e9d278976a301d73c297f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902152717epcas5p26905ce7cb48e9d278976a301d73c297f
References: <20220902151657.10766-1-joshi.k@samsung.com>
        <CGME20220902152717epcas5p26905ce7cb48e9d278976a301d73c297f@epcas5p2.samsung.com>
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

if io_uring sends passthrough command with IO_URING_F_FIXEDBUFS flag,
use the pre-registered buffer to form the bio.
While at it modify nvme_submit_user_cmd to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 7756b439a688..5a4649293e86 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -65,10 +65,11 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 }
 
 static struct request *nvme_alloc_user_request(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, void **metap, unsigned timeout, bool vec,
-		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
+		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags,
+		struct io_uring_cmd *ioucmd, bool fixedbufs)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -89,14 +90,27 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 
 	if (ubuffer && bufflen) {
 		if (!vec)
-			ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
+			if (fixedbufs) {
+				struct iov_iter iter;
+
+				ret = io_uring_cmd_import_fixed(ubuffer,
+						bufflen, rq_data_dir(req),
+						&iter, ioucmd);
+				if (ret < 0)
+					goto out;
+				ret = blk_rq_map_user_bvec(req, &iter);
+			} else {
+				ret = blk_rq_map_user(q, req, NULL,
+						nvme_to_user_ptr(ubuffer),
+						bufflen, GFP_KERNEL);
+			}
 		else {
 			struct iovec fast_iov[UIO_FASTIOV];
 			struct iovec *iov = fast_iov;
 			struct iov_iter iter;
 
-			ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
+			ret = import_iovec(rq_data_dir(req),
+					nvme_to_user_ptr(ubuffer), bufflen,
 					UIO_FASTIOV, &iov, &iter);
 			if (ret < 0)
 				goto out;
@@ -132,7 +146,7 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -142,7 +156,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	int ret;
 
 	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
+			meta_len, meta_seed, &meta, timeout, vec, 0, 0, NULL, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -220,7 +234,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -274,7 +288,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -320,7 +334,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -457,11 +471,11 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		rq_flags |= REQ_POLLED;
 
 retry:
-	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
+	req = nvme_alloc_user_request(q, &c, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, 0, &meta, d.timeout_ms ?
 			msecs_to_jiffies(d.timeout_ms) : 0, vec, rq_flags,
-			blk_flags);
+			blk_flags, ioucmd, issue_flags & IO_URING_F_FIXEDBUFS);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req->end_io = nvme_uring_cmd_end_io;
-- 
2.25.1

