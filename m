Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC811522C59
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbiEKGbx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242138AbiEKGbu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:31:50 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392CA3C729
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:31:48 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220511063145epoutp036adc7628a244de4d98e5982898d98756~t_UMzXnps0767407674epoutp03A
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:31:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220511063145epoutp036adc7628a244de4d98e5982898d98756~t_UMzXnps0767407674epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652250705;
        bh=1ptUEzOg6uj1Eko/JzEKw4VyEma4y/5pughQoib4Uck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQmhan2QU3F/tWRib7hUGLBN20P4F7faiGek3ADZ+yvteC8cYJlqFOzaeeysduQFx
         au4cOSKqPfhCrxjsPkn0vIBK1qDoLbuxwqqEY33T/jc83z2TtmpfEEDNMXD5yQbQ3g
         yB2K9LXJtgTUxE9SArXby2ehpqX7wSJlS9kRZ8b4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220511063144epcas5p11ced98639ea4e765f4139498156e2c4c~t_UMRoy5G0983409834epcas5p14;
        Wed, 11 May 2022 06:31:44 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KylRw2sWtz4x9QJ; Wed, 11 May
        2022 06:31:40 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.C0.09762.9485B726; Wed, 11 May 2022 15:31:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055319epcas5p1d78cb03bd1b145a6d58c8e616795af14~t9yo74Bbe1582115821epcas5p15;
        Wed, 11 May 2022 05:53:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220511055319epsmtrp14505266b94408f1a2b45c19026ea75fd~t9yo7AhVI0124601246epsmtrp1H;
        Wed, 11 May 2022 05:53:19 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-7d-627b5849df51
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.D2.08924.E4F4B726; Wed, 11 May 2022 14:53:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055314epsmtip13f28bfbfd0059da101fe2b214813a152~t9yk4aTkU2658826588epsmtip1X;
        Wed, 11 May 2022 05:53:14 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v5 5/6] nvme: add vectored-io support for uring-cmd
Date:   Wed, 11 May 2022 11:17:49 +0530
Message-Id: <20220511054750.20432-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmlq5nRHWSwdoz3BZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzy5E1XwS7hi1Yup
        TA2MjwS6GDk5JARMJK7eOMTYxcjFISSwm1Hi3ufvbBDOJ0aJE/fPs4JUCQl8ZpTY8TKxi5ED
        rOP0nziI8C5GiQt9ZRD1QCWfv01lAalhE9CUuDC5FKRGREBe4svttSwgNcwCZxklpt06BDZT
        WMBZ4v3TBjCbRUBVYtO2RjCbV8BC4uzzC0wQ18lLzLz0nR3E5hSwlNiyeR47RI2gxMmZT1hA
        bGagmuats5lBFkgILOWQOPL3BAtEs4vE63NrGSFsYYlXx7ewQ9hSEi/726DsZInW7ZfZIR4r
        kViyQB0ibC9xcc9fJpAwM9Av63fpQ4RlJaaeWscEsZZPovf3E6gzeSV2zIOxFSXuTXrKCmGL
        SzycsQTK9pB4v/UWMySsehglbv3uYJnAqDALyTuzkLwzC2H1AkbmVYySqQXFuempxaYFxnmp
        5fAYTs7P3cQITrxa3jsYHz34oHeIkYmD8RCjBAezkgjv/r6KJCHelMTKqtSi/Pii0pzU4kOM
        psDwnsgsJZqcD0z9eSXxhiaWBiZmZmYmlsZmhkrivKfSNyQKCaQnlqRmp6YWpBbB9DFxcEo1
        MEV5dlcbhWbrclpoLlkbxX/K8dsZ1svZr9x/SESK1Xq8/KaSK8+aVu5Wanjbknn91qvM0xa+
        WtZ84/nKa049R5f3pW3fwur+ft4z+fsaH0zUby0R9m0zKiwMXhEfenM/y6F/z20Klrf5+eXW
        1U5lvp8R9f5X595Dr/q2b7FZK3BJXyPb/+rXA752yZUfheoePfsm8XqfZr+U/hcfu0W5/vUz
        Fl+OcF7EnRGwYNNyvwzeb043+d/sWjX1jabWu0UfemO2PwoOjxVQZWa2rH/k+eLDTEmrsPmb
        Cv3u3fI8KpptKbN4iWfcrXOHXkpa8W64GHJkedsKwzrlaWKS6xn1s49v2cD0btZhs3CDMxN/
        blJiKc5INNRiLipOBAA3mS/wRQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSnK6ff3WSwdwtlhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgyntyJKvglXLHqxVSmBsZHAl2MHBwSAiYSp//EdTFycggJ7GCUWNtsDWJLCIhLNF/7wQ5h
        C0us/PccyOYCqvnIKPF1cTs7SC+bgKbEhcmlIDUiAooSGz82MYLUMAvcZJR43HqNGSQhLOAs
        8f5pAyuIzSKgKrFpWyOYzStgIXH2+QUmiAXyEjMvfQdbxilgKbFl8zx2iIMsJI4umcgGUS8o
        cXLmExYQmxmovnnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yf
        u4kRHB1aWjsY96z6oHeIkYmD8RCjBAezkgjv/r6KJCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
        F7pOxgsJpCeWpGanphakFsFkmTg4pRqYnLnnvNHNel1t+T568u2fyi6nfX4t4CuzF567wKVO
        Sj/9wv+cHV9/fYg09rS4NzVyilSlz/6o3emTZ04+2nZshvW6EJtdL9bPPKHIcWuf7lrDtyeb
        Pv0zT1Sc9C2H/d7qBPvt0/74qT96dPHw0Y9PWrcde/pbQHvLrO9xBxLnRkfEXf3B1urZYtSm
        P/16tOzf+79UUvb71Vh2bzy6e09bQ1hc8mQmvo44/0mOy2TF+9g7MhpVFCaXP1f5e+Ja/pKt
        hg1Zmvced4kmfvwwRYNzpcQB7jXrrM11P+5rOXF0WoXRrozYF0dkS+0Xhq2/GZRmb5GQsLNu
        3ZSj5VPKi94Kq+jafXfcGC1769CHpxvvzFRiKc5INNRiLipOBACL4Dh9/QIAAA==
X-CMS-MailID: 20220511055319epcas5p1d78cb03bd1b145a6d58c8e616795af14
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055319epcas5p1d78cb03bd1b145a6d58c8e616795af14
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055319epcas5p1d78cb03bd1b145a6d58c8e616795af14@epcas5p1.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

wire up support for async passthru that takes an array of buffers (using
iovec). Exposed via a new op NVME_URING_CMD_IO_VEC. Same 'struct
nvme_uring_cmd' is to be used with -

1. cmd.addr as base address of user iovec array
2. cmd.data_len as count of iovec array elements

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c       | 9 ++++++---
 include/uapi/linux/nvme_ioctl.h | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 92d695262d8f..7b0e2c9cdcae 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -399,7 +399,7 @@ static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
 }
 
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-		struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
@@ -449,7 +449,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, 0, &meta, d.timeout_ms ?
-			msecs_to_jiffies(d.timeout_ms) : 0, 0, rq_flags,
+			msecs_to_jiffies(d.timeout_ms) : 0, vec, rq_flags,
 			blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -575,7 +575,10 @@ static int nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd,
 
 	switch (ioucmd->cmd_op) {
 	case NVME_URING_CMD_IO:
-		ret = nvme_uring_cmd_io(ctrl, ns, ioucmd, issue_flags);
+		ret = nvme_uring_cmd_io(ctrl, ns, ioucmd, issue_flags, false);
+		break;
+	case NVME_URING_CMD_IO_VEC:
+		ret = nvme_uring_cmd_io(ctrl, ns, ioucmd, issue_flags, true);
 		break;
 	default:
 		ret = -ENOTTY;
diff --git a/include/uapi/linux/nvme_ioctl.h b/include/uapi/linux/nvme_ioctl.h
index 04e458c649ab..0b1876aa5a59 100644
--- a/include/uapi/linux/nvme_ioctl.h
+++ b/include/uapi/linux/nvme_ioctl.h
@@ -107,5 +107,6 @@ struct nvme_uring_cmd {
 
 /* io_uring async commands: */
 #define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
+#define NVME_URING_CMD_IO_VEC	_IOWR('N', 0x81, struct nvme_uring_cmd)
 
 #endif /* _UAPI_LINUX_NVME_IOCTL_H */
-- 
2.25.1

