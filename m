Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63C14D1C1D
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbiCHPoU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347917AbiCHPoU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:44:20 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED69E35DF0
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:43:22 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220308154321epoutp049cc888706591be2d3a112e3755b8a24a~acjiltnr61362913629epoutp04b
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:43:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220308154321epoutp049cc888706591be2d3a112e3755b8a24a~acjiltnr61362913629epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754201;
        bh=uqZSicb94MLilTPRMRReRmaCfggMTLDRLlbMQ8tYAnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hREbLhkLEIWVaDrqnSRGtk7arQmu1KMYqW0HN4CRJiKnvJ9yrjMwyvPbtf/e55zx+
         LDwt7CUm2dXotjOCUP5Z85zcartcSfbmTXBZY3GUqHYOVtEcREfjIiH1gYWbZDUzp7
         aEIHeFX41XVp0i+23XM19wdqU2s7GsRuu5wgMES0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220308154320epcas5p108c23cb00779b6ea36ac8164da3038cf~acjiBWvVG2250922509epcas5p1G;
        Tue,  8 Mar 2022 15:43:20 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KCfjx1v35z4x9Pq; Tue,  8 Mar
        2022 15:43:17 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.67.06423.59977226; Wed,  9 Mar 2022 00:43:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220308152727epcas5p20e605718dd99e97c94f9232d40d04d95~acVqepfNG2419124191epcas5p2d;
        Tue,  8 Mar 2022 15:27:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152727epsmtrp286d7fd65322e1a0949884579c3063f79~acVqd31na2706527065epsmtrp2J;
        Tue,  8 Mar 2022 15:27:27 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-35-622779950d8e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.51.29871.FD577226; Wed,  9 Mar 2022 00:27:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152725epsmtip1b0c875bce0b2916868189b89eff1b74d~acVoYvW0E1072310723epsmtip1u;
        Tue,  8 Mar 2022 15:27:25 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 16/17] io_uring: add support for non-inline uring-cmd
Date:   Tue,  8 Mar 2022 20:51:04 +0530
Message-Id: <20220308152105.309618-17-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmhu7USvUkg1kzuCymH1a0aJrwl9li
        zqptjBar7/azWaxcfZTJ4l3rORaLztMXmCzOvz3MZDHp0DVGi723tC3mL3vKbrGk9TibxY0J
        Txkt1tx8ymLx+cw8Vgd+j2dXnzF67Jx1l92jecEdFo/LZ0s9Nq3qZPPYvKTeY/fNBjaPbYtf
        snr0bVnF6PF5k1wAV1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
        kotPgK5bZg7QD0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9
        vNQSK0MDAyNToMKE7Ixzi34xFvSKV2zYuoatgbFJuIuRk0NCwERi1qkHzF2MXBxCArsZJSZ0
        N7JBOJ8YJf42H4fKfGOUWNoxB8jhAGs5sosFIr6XUeL42ZmMEM5nRolZ108zgRSxCWhKXJhc
        CrJCRMBL4v7t96wgNcwCXUwSb/fdZwOpERZwlfh03xSkhkVAVeLg/3uMIDavgJXEuRnNTBDn
        yUvMvPSdHcTmBIr/vLWVFaJGUOLkzCcsIDYzUE3z1tlgh0oInOCQ2H72HwtEs4vE0e3noWxh
        iVfHt7BD2FISn9/tZYOwiyV+3TkK1dzBKHG9YSZUg73ExT1/wZ5hBnpm/S59iLCsxNRT65gg
        FvNJ9P5+AnUor8SOeTC2osS9SU9ZIWxxiYczlkDZHhLrNkxgggRWL6PEob6FTBMYFWYheWgW
        kodmIaxewMi8ilEytaA4Nz212LTAMC+1HB7Lyfm5mxjB6VrLcwfj3Qcf9A4xMnEwHmKU4GBW
        EuG9f14lSYg3JbGyKrUoP76oNCe1+BCjKTDEJzJLiSbnAzNGXkm8oYmlgYmZmZmJpbGZoZI4
        7+n0DYlCAumJJanZqakFqUUwfUwcnFINTAV88VrpHZwn3jVLfz/V6N4XfOHflevcAh2KazKa
        zx22jdg3O+CZqM6dwLJPFhsmzmqJ+pi37plE9tu40qn5Mne22MyOa1vvv84zXsKt0ej9rNSH
        Na4Mb/l6TTUCovdmWX74+G5Xi295gQXv5eWPFU1U/iWWLtFabPJ6T1SBtKRG09IstUdpKge7
        1V1bl8g+flstZcQdab7v+xStfxsuK0t/2vzt+4aUNaHvBDNPVUnLmXGcdy09ZWoUbWPpe3yS
        odCtN9sc/ZMsX1bnZ5688YDpC+tuduG2Jg6DK0se1J3piS1Z3bFSdPPTvTPXnp5g9ZVnYemk
        Hra2DVbqtQwfA07tmbvskFh6oe/OmvPZSizFGYmGWsxFxYkA/Ebj0GAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTvd+qXqSweSlqhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr49yiX4wFveIVG7auYWtgbBLuYuTgkBAwkTiy
        i6WLkYtDSGA3o8Te+c2sXYycQHFxieZrP9ghbGGJlf+es0MUfWSUOHv2KyNIM5uApsSFyaUg
        NSICARIHGy+D1TALzGCS6Gn+zAJSIyzgKvHpvilIDYuAqsTB//cYQWxeASuJczOamSDmy0vM
        vPQdbBcnUPznra1gNwgJWEqsWPebDaJeUOLkzCcsIDYzUH3z1tnMExgFZiFJzUKSWsDItIpR
        MrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIziatDR3MG5f9UHvECMTB+MhRgkOZiUR3vvn
        VZKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYJq0TaXz
        8CqlC01XljccF9j7VYqpSvFTm0vQpALOgMWqrpPVNqh80JBaqhZntPNedLGEkudUp9CFRwtj
        9ea7Xnf34ZaRdhY+FnSKl+N8SQLH4rTPe3fdENy7+hjL43IFr2r/XPY7+3/327D/ywxvvfXQ
        WMMg71HsMstPhYrcD5XXLZIP2rzm7sltvetsnx898vDGszKN2hzpHUpajRtm9faL3yt7Nkvs
        e+2Fr2X9FxUPsiV+9vsYLfL15mOWfxXTG6NeftF63TLr469/171iI7z9b9Y3ha+ac9fr+17f
        OS8/z2yIU2N5c5B9k+jUbRNadB3iz1i+3jGhLHK3WlTc9m8nXKaeFe5YyfH/x9rjt5YqsRRn
        JBpqMRcVJwIAHysdvBUDAAA=
X-CMS-MailID: 20220308152727epcas5p20e605718dd99e97c94f9232d40d04d95
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152727epcas5p20e605718dd99e97c94f9232d40d04d95
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152727epcas5p20e605718dd99e97c94f9232d40d04d95@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Lifetime of inline commands (within sqe) is upto submission, and maximum
length is 80 bytes. This can be limiting for certain commands.
Add option to accept command pointer via same sqe->cmd field. User need to
set IORING_URING_CMD_INDIRECT flag in sqe->uring_cmd_flags.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c                 | 13 +++++++++++--
 include/linux/io_uring.h      |  1 +
 include/uapi/linux/io_uring.h |  6 ++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8bd9401f9964..d88c6601a556 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4189,8 +4189,12 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+	u32 ucmd_flags = READ_ONCE(sqe->uring_cmd_flags);
 
-	if (!req->file->f_op->async_cmd || !(req->ctx->flags & IORING_SETUP_SQE128))
+	if (!req->file->f_op->async_cmd)
+		return -EOPNOTSUPP;
+	if (!(req->ctx->flags & IORING_SETUP_SQE128) &&
+			!(ucmd_flags & IORING_URING_CMD_INDIRECT))
 		return -EOPNOTSUPP;
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		ioucmd->flags = IO_URING_F_UCMD_POLLED;
@@ -4206,7 +4210,12 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 		ioucmd->flags |= IO_URING_F_UCMD_FIXEDBUFS;
 	}
 
-	ioucmd->cmd = (void *) &sqe->cmd;
+	if (ucmd_flags & IORING_URING_CMD_INDIRECT) {
+		ioucmd->flags |= IO_URING_F_UCMD_INDIRECT;
+		ioucmd->cmd = (void *) sqe->cmd;
+	} else {
+		ioucmd->cmd = (void *) &sqe->cmd;
+	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	ioucmd->cmd_len = READ_ONCE(sqe->cmd_len);
 	return 0;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 65db83d703b7..c534a6fcef4f 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -10,6 +10,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_UNLOCKED		= 2,
 	IO_URING_F_UCMD_FIXEDBUFS	= 4,
 	IO_URING_F_UCMD_POLLED		= 8,
+	IO_URING_F_UCMD_INDIRECT	= 16,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 };
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ee84be4b6be8..a4b9db37ecf1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -47,6 +47,7 @@ struct io_uring_sqe {
 		__u32		rename_flags;
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
+		__u32		uring_cmd_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -198,6 +199,11 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
+/*
+ * sqe->uring_cmd_flags
+ */
+#define IORING_URING_CMD_INDIRECT	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.25.1

