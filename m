Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18E56F23FC
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjD2JnO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjD2JnM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:43:12 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8232139
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:43:01 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230429094259epoutp01f19d6dfeb14260718a9aa5baa88a7471~aXo8XEwrC2551625516epoutp015
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230429094259epoutp01f19d6dfeb14260718a9aa5baa88a7471~aXo8XEwrC2551625516epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761379;
        bh=CUKxeRq1qvH1W4pJIKUNwrDgFpmbgSlJ0NlQ+has8Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrBsZ7a9J29Gqwk3I+F4NeEiqbqXFO63aiWLh5wU4cBfR8TIWBjIN4/NEiqgjhDgX
         HGsMFDkyAaAn7fCWB4JDvwv7wVfKpsuJjM4KKL1inrmtC+thEb8YDDKAZ6ajKy742F
         +TzFE8/eo+IPm2Iwu0zEtxG8BBris6tOFEVEBPbA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230429094258epcas5p3749184eb8850fc553547f2d2b2666528~aXo7f0xtb2426524265epcas5p3v;
        Sat, 29 Apr 2023 09:42:58 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Q7kzh6gJHz4x9Pq; Sat, 29 Apr
        2023 09:42:56 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.7C.54880.0A6EC446; Sat, 29 Apr 2023 18:42:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230429094255epcas5p11bcbe76772289f27c41a50ce502c998d~aXo4y0H0-1041010410epcas5p1v;
        Sat, 29 Apr 2023 09:42:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230429094255epsmtrp13906fe5c736973e4538870cd28553ca8~aXo4yJBAV0376803768epsmtrp1x;
        Sat, 29 Apr 2023 09:42:55 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-9b-644ce6a06d12
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.29.28392.F96EC446; Sat, 29 Apr 2023 18:42:55 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094253epsmtip28a893917aee13f32a8fc91fa9611a6ad~aXo23wiAu0703907039epsmtip2U;
        Sat, 29 Apr 2023 09:42:53 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [RFC PATCH 09/12] nvme: carve out a helper to prepare nvme_command
 from ioucmd->cmd
Date:   Sat, 29 Apr 2023 15:09:22 +0530
Message-Id: <20230429093925.133327-10-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmuu6CZz4pBn9261t8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZ1S2TUZqYkpq
        kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
        YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Izesw1sBUc0
        Kj4/fsjewLhHqYuRk0NCwERi647PTF2MXBxCArsZJZqbF7JAOJ8YJU59mcUO4XxmlDix9ysz
        TEvzt052EFtIYBejxJYP6RA2UNGNg9JdjBwcbAKaEhcml4KERQRcJJrWTmUDmcMs8I1RYtHr
        d6wgNcICcRJPd4G1sgioSqze+5oNxOYVsJJ4e30DG8QqeYmZl76DreIEin+fsZsZokZQ4uTM
        JywgNjNQTfPW2cwg8yUElnJIvNw8jQmi2UXi5LT57BC2sMSr41ugbCmJl/1tUHayxKWZ56Dq
        SyQe7zkIZdtLtJ7qZwa5kxnol/W79CF28Un0/n7CBBKWEOCV6GgTgqhWlLg36SkrhC0u8XDG
        ElaIEg+JM0sVICHYyyhx/Wwb+wRG+VlIPpiF5INZCMsWMDKvYpRMLSjOTU8tNi0wzEsth8dq
        cn7uJkZwmtXy3MF498EHvUOMTByMhxglOJiVRHh5K91ThHhTEiurUovy44tKc1KLDzGaAoN4
        IrOUaHI+MNHnlcQbmlgamJiZmZlYGpsZKonzqtueTBYSSE8sSc1OTS1ILYLpY+LglGpgcvp9
        SK96t3Ov1oli1S3u06dsDGJ1m6mfwVj3xzk34PCNzuwvS3/IHZA/mNhv/DW/KLf37Kbf++V/
        tLb2zn2ffp1HfuXJw8E2Ny/bm11cxvJrtui6LR86pRRzIi8zmBxeNeH3L5lpsmetF8eduMn2
        s3WneZru/U0CXw5OC8th/Wec4di2n1+l5V7rF5N1skYbJlyZaOvGOz/loanJUpdPm3mvZryR
        Feiyn38+vsDWI/al6m3tN4eWMnHfDQjgWum456u4kg17BdfhSdnbXQ28zhyzUw27rb28+lTa
        5LyUd7pHn33tkGF8Oktvy9favik1+9R2v5U/tzjoU9/qL45x+yvrhdqk2/Unaf83/3OrRoml
        OCPRUIu5qDgRABV1R5Y8BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWy7bCSvO78Zz4pBlM2SVl8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZxSXTUpqTmZZ
        apG+XQJXRu/ZBraCIxoVnx8/ZG9g3KPUxcjJISFgItH8rZO9i5GLQ0hgB6PExxv7WSES4hLN
        136wQ9jCEiv/PYcq+sgosbfvD1MXIwcHm4CmxIXJpSA1IgJeEu1vZ7GB1DAL/GOUePC+jQ0k
        ISwQIzH7+XOwQSwCqhKr974Gi/MKWEm8vb6BDWKBvMTMS9/BajiB4t9n7GYGmS8kYCnRuCAe
        olxQ4uTMJywgNjNQefPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9d
        Lzk/dxMjOE60tHYw7ln1Qe8QIxMH4yFGCQ5mJRFe3kr3FCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYlq9ba+xo5mBtE8uV9qZ32ZOZVvbv005Pce25
        Zf2nmNPymMmb4CVxbw8y2dXrWnybvjzlnN9xTmbjHwddDXdGCMRnHvR7/Pbi7JBfC/59CWp5
        eJBlE0e7TpHotDd6yzfseFYyb96qL3UTSr1j5itd8WPj3Vjds3vZdMErBef7vE4Ff21nqt/U
        6rioOr7a02PTDrVDpbeZfhlFxW8zPBKxMDdz8fuvnMqPb4r+ni6mbP1Rg+djr/lKTu9ps5Ze
        DMtdxnDo8y6PVZ2e4oEvVi5/tqY5/04o/zOLmzWRV+c9ndd9aWn+V4PO+heVqoJ3MhUY1WeL
        XeqOePda/NtKIZ7IsKf5Qou2+a1r+fS4buPp30osxRmJhlrMRcWJACAt69ECAwAA
X-CMS-MailID: 20230429094255epcas5p11bcbe76772289f27c41a50ce502c998d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094255epcas5p11bcbe76772289f27c41a50ce502c998d
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094255epcas5p11bcbe76772289f27c41a50ce502c998d@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This helper will be used in the subsequent patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c | 81 +++++++++++++++++++++------------------
 drivers/nvme/host/nvme.h  | 11 ++++++
 2 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 292a578686b6..18f4f20f5e76 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -430,14 +430,6 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	return status;
 }
 
-struct nvme_uring_data {
-	__u64	metadata;
-	__u64	addr;
-	__u32	data_len;
-	__u32	metadata_len;
-	__u32	timeout_ms;
-};
-
 /*
  * This overlays struct io_uring_cmd pdu.
  * Expect build errors if this grows larger than that.
@@ -548,11 +540,50 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
 	return RQ_END_IO_NONE;
 }
 
+int nvme_prep_cmd_from_ioucmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
+		struct io_uring_cmd *ioucmd, struct nvme_command *c,
+		struct nvme_uring_data *d)
+{
+	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
+
+	c->common.opcode = READ_ONCE(cmd->opcode);
+	c->common.flags = READ_ONCE(cmd->flags);
+	if (c->common.flags)
+		return -EINVAL;
+
+	c->common.command_id = 0;
+	c->common.nsid = cpu_to_le32(cmd->nsid);
+	if (!nvme_validate_passthru_nsid(ctrl, ns, le32_to_cpu(c->common.nsid)))
+		return -EINVAL;
+
+	c->common.cdw2[0] = cpu_to_le32(READ_ONCE(cmd->cdw2));
+	c->common.cdw2[1] = cpu_to_le32(READ_ONCE(cmd->cdw3));
+	c->common.metadata = 0;
+	c->common.dptr.prp1 = c->common.dptr.prp2 = 0;
+	c->common.cdw10 = cpu_to_le32(READ_ONCE(cmd->cdw10));
+	c->common.cdw11 = cpu_to_le32(READ_ONCE(cmd->cdw11));
+	c->common.cdw12 = cpu_to_le32(READ_ONCE(cmd->cdw12));
+	c->common.cdw13 = cpu_to_le32(READ_ONCE(cmd->cdw13));
+	c->common.cdw14 = cpu_to_le32(READ_ONCE(cmd->cdw14));
+	c->common.cdw15 = cpu_to_le32(READ_ONCE(cmd->cdw15));
+
+	if (!nvme_cmd_allowed(ns, c, 0, ioucmd->file->f_mode))
+		return -EACCES;
+
+	d->metadata = READ_ONCE(cmd->metadata);
+	d->addr = READ_ONCE(cmd->addr);
+	d->data_len = READ_ONCE(cmd->data_len);
+	d->metadata_len = READ_ONCE(cmd->metadata_len);
+	d->timeout_ms = READ_ONCE(cmd->timeout_ms);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvme_prep_cmd_from_ioucmd);
+
+
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
 	struct nvme_uring_data d;
 	struct nvme_command c;
@@ -562,35 +593,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	void *meta = NULL;
 	int ret;
 
-	c.common.opcode = READ_ONCE(cmd->opcode);
-	c.common.flags = READ_ONCE(cmd->flags);
-	if (c.common.flags)
-		return -EINVAL;
-
-	c.common.command_id = 0;
-	c.common.nsid = cpu_to_le32(cmd->nsid);
-	if (!nvme_validate_passthru_nsid(ctrl, ns, le32_to_cpu(c.common.nsid)))
-		return -EINVAL;
-
-	c.common.cdw2[0] = cpu_to_le32(READ_ONCE(cmd->cdw2));
-	c.common.cdw2[1] = cpu_to_le32(READ_ONCE(cmd->cdw3));
-	c.common.metadata = 0;
-	c.common.dptr.prp1 = c.common.dptr.prp2 = 0;
-	c.common.cdw10 = cpu_to_le32(READ_ONCE(cmd->cdw10));
-	c.common.cdw11 = cpu_to_le32(READ_ONCE(cmd->cdw11));
-	c.common.cdw12 = cpu_to_le32(READ_ONCE(cmd->cdw12));
-	c.common.cdw13 = cpu_to_le32(READ_ONCE(cmd->cdw13));
-	c.common.cdw14 = cpu_to_le32(READ_ONCE(cmd->cdw14));
-	c.common.cdw15 = cpu_to_le32(READ_ONCE(cmd->cdw15));
-
-	if (!nvme_cmd_allowed(ns, &c, 0, ioucmd->file->f_mode))
-		return -EACCES;
-
-	d.metadata = READ_ONCE(cmd->metadata);
-	d.addr = READ_ONCE(cmd->addr);
-	d.data_len = READ_ONCE(cmd->data_len);
-	d.metadata_len = READ_ONCE(cmd->metadata_len);
-	d.timeout_ms = READ_ONCE(cmd->timeout_ms);
+	ret = nvme_prep_cmd_from_ioucmd(ctrl, ns, ioucmd, &c, &d);
+	if (ret)
+		return ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK) {
 		rq_flags |= REQ_NOWAIT;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 4619a7498f8e..4eb45afc9484 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -168,6 +168,14 @@ struct nvme_request {
 	struct nvme_ctrl	*ctrl;
 };
 
+struct nvme_uring_data {
+	__u64	metadata;
+	__u64	addr;
+	__u32	data_len;
+	__u32	metadata_len;
+	__u32	timeout_ms;
+};
+
 /*
  * Mark a bio as coming in through the mpath node.
  */
@@ -811,6 +819,9 @@ static inline bool nvme_is_unique_nsid(struct nvme_ctrl *ctrl,
 		(ctrl->ctratt & NVME_CTRL_CTRATT_NVM_SETS);
 }
 
+int nvme_prep_cmd_from_ioucmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
+		struct io_uring_cmd *ioucmd, struct nvme_command *c,
+		struct nvme_uring_data *d);
 int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buf, unsigned bufflen);
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
-- 
2.25.1

