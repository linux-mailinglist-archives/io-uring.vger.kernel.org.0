Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66E14D1C20
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347941AbiCHPo0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347917AbiCHPoZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:44:25 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429B5E17
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:43:27 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220308154325epoutp019a99e8502277a24d2bd46358a170e642~acjmmFDVh1233312333epoutp01a
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:43:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220308154325epoutp019a99e8502277a24d2bd46358a170e642~acjmmFDVh1233312333epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754205;
        bh=xblvuUbMlm8XGc4r3UcbItBHUpyrY9AabHvMcjXEnVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5D7F7AYK1LMe+K8B1OekPb3XzCx51MJRBsiJtKbVT+4iw48hAkPcHfo1HKiTok1t
         LiZldJknkhcAwX0IIy2xAczKyuOKcoF+Yf55E7BqCZ4QE/QeHily9EKFbUqRwMoFGJ
         YG9vcVinnmdnpVjUvgJvyOvFkiRF2ZV1ymxEqc8g=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220308154324epcas5p3f3f29ebd8b3578242dbe1433d85edc81~acjl2LE4K2611026110epcas5p3G;
        Tue,  8 Mar 2022 15:43:24 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KCfk16sr8z4x9Pp; Tue,  8 Mar
        2022 15:43:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.F6.46822.1C677226; Wed,  9 Mar 2022 00:31:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3~acVsiydo81632216322epcas5p1e;
        Tue,  8 Mar 2022 15:27:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152729epsmtrp17f1e09d2f31b8098aea660127729e8d6~acVsh7ndU0125001250epsmtrp1t;
        Tue,  8 Mar 2022 15:27:29 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-6e-622776c1034f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.96.03370.1E577226; Wed,  9 Mar 2022 00:27:29 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152727epsmtip157d88b77887039cf75d68faff64079c3~acVqghG8i1236312363epsmtip1N;
        Tue,  8 Mar 2022 15:27:27 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 17/17] nvme: enable non-inline passthru commands
Date:   Tue,  8 Mar 2022 20:51:05 +0530
Message-Id: <20220308152105.309618-18-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmpu7BMvUkg48NZhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsbnZdNZC9aKVdybdYWpgXGmUBcjJ4eEgInExPur2LsYuTiEBHYzSnyb
        /oUVwvnEKPHu83Qo5zOjxOSLF9hhWho+PmADsYUEdjFKPJ5iBWEDFa287djFyMHBJqApcWFy
        KUhYRMBL4v7t92BzmAW6mCTe7rvPBlIjLOAgsW2/MEgNi4CqxPa/q5lAbF4BK4m3P94zQayS
        l5h56TvYWk6g+M9bW1khagQlTs58wgJiMwPVNG+dzQwyX0LgCIfE2Uv9LBDNLhInt7xhg7CF
        JV4d3wJ1v5TEy/42KLtY4tedo1DNHYwS1xtmQjXbS1zc85cJ5FBmoGfW79KHCMtKTD21jgli
        MZ9E7+8nUIfySuyYB2MrStyb9JQVwhaXeDhjCZTtIXG88RUjJKx6GSXe/naawKgwC8k/s5D8
        Mwth8wJG5lWMkqkFxbnpqcWmBUZ5qeXwOE7Oz93ECE7VWl47GB8++KB3iJGJg/EQowQHs5II
        7/3zKklCvCmJlVWpRfnxRaU5qcWHGE2BAT6RWUo0OR+YLfJK4g1NLA1MzMzMTCyNzQyVxHlP
        p29IFBJITyxJzU5NLUgtgulj4uCUamDSnbKBoembkoi+oez8C6u4JeKliu1t596/VLc88IB2
        kVL6mt3+725u1tNZzidQtEG3gcFA+fOWG34s62d2O+7va7t02ujPn9IJ5++yOi49n33jhffb
        z43SwZrS5hzePv+eH5nn3HQysKghsrZ5x9V3dgdqdng9Y3D6L6L9LJGd7dzsHclz2X6mlpXM
        tTj5WmiS8E3H7AlLbka1yRlN/Cm3MLmh16Jbi838oRuzzfw+j7Lfy2b6dzJX1M0QjXosc7z6
        2Mc7jtZvrE7ts92tw9ZfW3vTOEcsfMfe+dMFTN6vEk1+c2z3oe+HWDgEOYwzErZ8Yd2jq3r6
        T3/EqaKZZY2frDKlDotITfRZaPAkNUiJpTgj0VCLuag4EQBq/uBgXgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTvdhqXqSwc1+M4vphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CV8XnZdNaCtWIV92ZdYWpgnCnUxcjJISFgItHw
        8QEbiC0ksINRYnmnPERcXKL52g92CFtYYuW/50A2F1DNR0aJxytWADVwcLAJaEpcmFwKUiMi
        ECBxsPEyWA2zwAwmiZ7mzywgNcICDhLb9guD1LAIqEps/7uaCcTmFbCSePvjPRPEfHmJmZe+
        g+3iBIr/vLWVFeIeS4kV636zQdQLSpyc+YQFxGYGqm/eOpt5AqPALCSpWUhSCxiZVjFKphYU
        56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeTltYOxj2rPugdYmTiYDzEKMHBrCTCe/+8SpIQ
        b0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTDnzHrHNPPRl
        371nF+coFyStvvSkiPfDChcTMect2xdv+OO49DXrqsXGW6yNVnVaXWVxXcz42v78HJmlWRv3
        xh8+3rm1v/pGvFfqYrfTtS/uMGwRX3gznmH6GZVfna0ZYulHCidNj4tdorBHtSCe9dGMo5NE
        /7lqeE9OWtZex/Mw+Q3Hwb3VjL8NPjCHsGfvX5w+/dTRv+oR/w/Xi02f43eyMcFxS8ScSefP
        PijPrDKLL+Bck3GnanPIH/bJJZEdioGX5P1/9RgZKJywYqvaeVTu9OY/nyXW9rWtDtkX1PSV
        8YSszZIl4jvXvH6bPUEuJrRt3dZlk+68rPklHT7ddNc18dX+XSfPn3F+sWKSyGNPJZbijERD
        Leai4kQAJ5cZgRUDAAA=
X-CMS-MailID: 20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

On submission,just fetch the commmand from userspace pointer and reuse
everything else. On completion, update the result field inside the
passthru command.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 701feaecabbe..ddb7e5864be6 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -65,6 +65,14 @@ static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
 	}
 	kfree(pdu->meta);
 
+	if (ioucmd->flags & IO_URING_F_UCMD_INDIRECT) {
+		struct nvme_passthru_cmd64 __user *ptcmd64 = ioucmd->cmd;
+		u64 result = le64_to_cpu(nvme_req(req)->result.u64);
+
+		if (put_user(result, &ptcmd64->result))
+			status = -EFAULT;
+	}
+
 	io_uring_cmd_done(ioucmd, status);
 }
 
@@ -143,6 +151,13 @@ static inline bool nvme_is_fixedb_passthru(struct io_uring_cmd *ioucmd)
 	return ((ioucmd) && (ioucmd->flags & IO_URING_F_UCMD_FIXEDBUFS));
 }
 
+static inline bool is_inline_rw(struct io_uring_cmd *ioucmd, struct nvme_command *cmd)
+{
+	return ((ioucmd->flags & IO_URING_F_UCMD_INDIRECT) ||
+			(cmd->common.opcode == nvme_cmd_write ||
+			 cmd->common.opcode == nvme_cmd_read));
+}
+
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
@@ -193,8 +208,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		}
 	}
 	if (ioucmd) { /* async dispatch */
-		if (cmd->common.opcode == nvme_cmd_write ||
-				cmd->common.opcode == nvme_cmd_read) {
+		if (is_inline_rw(ioucmd, cmd)) {
 			if (bio && is_polling_enabled(ioucmd, req)) {
 				ioucmd->bio = bio;
 				bio->bi_opf |= REQ_POLLED;
@@ -204,7 +218,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
 			return 0;
 		} else {
-			/* support only read and write for now. */
+			/* support only read and write for inline */
 			ret = -EINVAL;
 			goto out_meta;
 		}
@@ -372,7 +386,14 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	} else {
 		if (ioucmd->cmd_len != sizeof(struct nvme_passthru_cmd64))
 			return -EINVAL;
-		cptr = (struct nvme_passthru_cmd64 *)ioucmd->cmd;
+		if (ioucmd->flags & IO_URING_F_UCMD_INDIRECT) {
+			ucmd = (struct nvme_passthru_cmd64 __user *)ioucmd->cmd;
+			if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
+				return -EFAULT;
+			cptr = &cmd;
+		} else {
+			cptr = (struct nvme_passthru_cmd64 *)ioucmd->cmd;
+		}
 	}
 	if (cptr->flags & NVME_HIPRI)
 		rq_flags |= REQ_POLLED;
-- 
2.25.1

