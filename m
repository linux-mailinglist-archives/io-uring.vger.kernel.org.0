Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47B54D1C0E
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347959AbiCHPng (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbiCHPnX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:23 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902BA4EF64
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:18 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154217epoutp03caf5dd6b28c8b41ab97ed416107fe537~acimrozeN2451824518epoutp039
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154217epoutp03caf5dd6b28c8b41ab97ed416107fe537~acimrozeN2451824518epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754137;
        bh=vYkOrensJar+IrmlGpSyBioyW/8GQq4/dZ5JxuOyK8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAPWfs8qBZkIcOplrw9wm95xtTKQJnEtyDt2yYLMfMlb7Wb1sNsuCiDGGus/EHjGX
         UUoQwZBSvGaz29y/rPKX/A5r3bvepycCzT38vbeLamdVyCrNQ7RqpiQM8pbh6/a0y2
         qsD3UlnQCpVzb/9Mwn6Fs3wgNS97iLuOJ7VHGeLs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220308154216epcas5p1142420f56a22642c33b809f4cf1e1d82~acil6BfNG1651416514epcas5p1x;
        Tue,  8 Mar 2022 15:42:16 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KCfhh64DWz4x9Pr; Tue,  8 Mar
        2022 15:42:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.E6.46822.C7677226; Wed,  9 Mar 2022 00:30:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78~acVTGhoqz1816518165epcas5p1g;
        Tue,  8 Mar 2022 15:27:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152702epsmtrp2daca8881aad176cb697ecbf213155727~acVTD5dLI2706527065epsmtrp27;
        Tue,  8 Mar 2022 15:27:02 +0000 (GMT)
X-AuditID: b6c32a4a-dfbff7000000b6e6-0f-6227767c1c5f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.96.03370.6C577226; Wed,  9 Mar 2022 00:27:02 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152700epsmtip1b2f3c1f5f38aa1933d1439fa69114b59~acVRAS1aT3168431684epsmtip1-;
        Tue,  8 Mar 2022 15:27:00 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Date:   Tue,  8 Mar 2022 20:50:53 +0530
Message-Id: <20220308152105.309618-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmum5NmXqSwcFlOhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsa6t1uZClakVFybeY61gXFacBcjJ4eEgInEjNZudhBbSGA3o8SnS+ld
        jFxA9idGiXMTf7NCJD4zSkyfywTT8GzfE3aIol2MEi9/n2eCcICKHsxay9jFyMHBJqApcWFy
        KUiDiICXxP3b71lBapgFupgk3u67zwaSEBYIlDix6iHYBhYBVYmmG+8YQWxeAUuJrqe7mSG2
        yUvMvPQd7DxOASuJn7e2skLUCEqcnPmEBcRmBqpp3jqbGWSBhMARDomjDxeyQzS7SFzZ0MgC
        YQtLvDq+BSouJfH53V42CLtY4tedo1DNHYwS1xtmQjXYS1zc85cJ5BtmoG/W79KHCMtKTD21
        jgliMZ9E7+8n0GDhldgxD8ZWlLg36SkrhC0u8XDGElaQMRICHhJLZktDAquXUWLKyTeMExgV
        ZiH5ZxaSf2YhbF7AyLyKUTK1oDg3PbXYtMAoL7UcHsnJ+bmbGMHJWstrB+PDBx/0DjEycTAe
        YpTgYFYS4b1/XiVJiDclsbIqtSg/vqg0J7X4EKMpMMAnMkuJJucD80VeSbyhiaWBiZmZmYml
        sZmhkjjv6fQNiUIC6YklqdmpqQWpRTB9TBycUg1MC/enCh2b8yj30OkZssVlwYJ6/v2lXX0i
        S18dsbG8tLDXY8GT2UJuvhNV1PTP72EST4jPOl526sT+TVv7ssKuTZ9alrBJVW0no4SPkmd/
        +NFzhd2ren5cdN92ecUe64kqze/f5+zc/+bn4tWX5MqPnljs6GO7Y5Nf3eu0mTcy4tMff7vK
        mbNfdRPfiqkrTbepfTeYKbfx6cGqYpvI+GnOB5+WuLjevjPL3ii30L7s6Or+vdlSN/+85JRa
        tZ2TZWe+RqJ6MruBEBff+oZvFj/i17+K2Ptrp/namWuzNq1vWXd7+zUe3xfn5vJqyr3ab9IT
        Htbj+lWz2X2aiOuS1StjOf7/mc6UvulAaZlnZMH/90osxRmJhlrMRcWJAEcxHHJfBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTvdYqXqSweYfChbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoErY93brUwFK1Iqrs08x9rAOC24i5GTQ0LAROLZ
        vifsXYxcHEICOxglDj9ZwgqREJdovvaDHcIWllj57zlU0UdGiTPdf9m6GDk42AQ0JS5MLgWp
        EREIkDjYeBmshllgBpNET/NnFpCEsIC/xKXpU8GGsgioSjTdeMcIYvMKWEp0Pd3NDLFAXmLm
        pe9gyzgFrCR+3toKVi8EVLNi3W82iHpBiZMzn4DNZAaqb946m3kCo8AsJKlZSFILGJlWMUqm
        FhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIER5SW1g7GPas+6B1iZOJgPMQowcGsJMJ7/7xK
        khBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1MBWqNZa8+
        ue6bs4F1/2bbLeGPzmeeLoyMsWuIXHa0kHXxA681/2/wn1Vx4jtWXyGslaY8aU7gr4AK6VKu
        5x/ynvJzJD9/vmvKFRX2bANVS8tpukm/+zROM4qI9W071/q90/vVSuUP3SsuttZuPrpsbsxa
        HqfZd3q6rX8fvDtbNN7C+kYm52YT3mSzD66T5ts5BkQeS5jBu2lK0mtp4RvxUbE2LZJ5v2bf
        81WZGvQn93dkwrUW9rAitkN7H1Q//zOBbWFO4t1fyvpm9R4Tb27LCmYr3b6Fg3n52VcZW7Ve
        vz96YavCnqR/W7Yocb0MX9tVz3l2f2tv7FJnY7sij3oDl7ky5j/Mc3Orpm/6c19GiaU4I9FQ
        i7moOBEAVijQjxcDAAA=
X-CMS-MailID: 20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handler for fops->async_cmd(), implementing async passthru
on char device (/dev/ngX). The handler supports NVME_IOCTL_IO64_CMD for
read and write commands. Returns failure for other commands.
This is low overhead path for processing the inline commands housed
inside io_uring's sqe. Neither the commmand is fetched via
copy_from_user, nor the result (inside passthru command) is updated via
put_user.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c      |   1 +
 drivers/nvme/host/ioctl.c     | 205 ++++++++++++++++++++++++++++------
 drivers/nvme/host/multipath.c |   1 +
 drivers/nvme/host/nvme.h      |   3 +
 4 files changed, 178 insertions(+), 32 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 159944499c4f..3fe8f5901cd9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3667,6 +3667,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.release	= nvme_ns_chr_release,
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.async_cmd	= nvme_ns_chr_async_cmd,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 5c9cd9695519..1df270b47af5 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -18,6 +18,76 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 		ptrval = (compat_uptr_t)ptrval;
 	return (void __user *)ptrval;
 }
+/*
+ * This overlays struct io_uring_cmd pdu.
+ * Expect build errors if this grows larger than that.
+ */
+struct nvme_uring_cmd_pdu {
+	u32 meta_len;
+	union {
+		struct bio *bio;
+		struct request *req;
+	};
+	void *meta; /* kernel-resident buffer */
+	void __user *meta_buffer;
+} __packed;
+
+static struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(struct io_uring_cmd *ioucmd)
+{
+	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
+}
+
+static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	struct request *req = pdu->req;
+	int status;
+	struct bio *bio = req->bio;
+
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		status = -EINTR;
+	else
+		status = nvme_req(req)->status;
+
+	/* we can free request */
+	blk_mq_free_request(req);
+	blk_rq_unmap_user(bio);
+
+	if (!status && pdu->meta_buffer) {
+		if (copy_to_user(pdu->meta_buffer, pdu->meta, pdu->meta_len))
+			status = -EFAULT;
+	}
+	kfree(pdu->meta);
+
+	io_uring_cmd_done(ioucmd, status);
+}
+
+static void nvme_end_async_pt(struct request *req, blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	/* extract bio before reusing the same field for request */
+	struct bio *bio = pdu->bio;
+
+	pdu->req = req;
+	req->bio = bio;
+	/* this takes care of setting up task-work */
+	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+}
+
+static void nvme_setup_uring_cmd_data(struct request *rq,
+		struct io_uring_cmd *ioucmd, void *meta,
+		void __user *meta_buffer, u32 meta_len)
+{
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+
+	/* to free bio on completion, as req->bio will be null at that time */
+	pdu->bio = rq->bio;
+	pdu->meta = meta;
+	pdu->meta_buffer = meta_buffer;
+	pdu->meta_len = meta_len;
+	rq->end_io_data = ioucmd;
+}
 
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 		unsigned len, u32 seed, bool write)
@@ -56,7 +126,8 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout)
+		u32 meta_seed, u64 *result, unsigned timeout,
+		struct io_uring_cmd *ioucmd)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -64,9 +135,15 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	struct request *req;
 	struct bio *bio = NULL;
 	void *meta = NULL;
+	unsigned int rq_flags = 0;
+	blk_mq_req_flags_t blk_flags = 0;
 	int ret;
 
-	req = nvme_alloc_request(q, cmd, 0, 0);
+	if (ioucmd && (ioucmd->flags & IO_URING_F_NONBLOCK)) {
+		rq_flags |= REQ_NOWAIT;
+		blk_flags |= BLK_MQ_REQ_NOWAIT;
+	}
+	req = nvme_alloc_request(q, cmd, blk_flags, rq_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -92,6 +169,19 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			req->cmd_flags |= REQ_INTEGRITY;
 		}
 	}
+	if (ioucmd) { /* async dispatch */
+		if (cmd->common.opcode == nvme_cmd_write ||
+				cmd->common.opcode == nvme_cmd_read) {
+			nvme_setup_uring_cmd_data(req, ioucmd, meta, meta_buffer,
+					meta_len);
+			blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
+			return 0;
+		} else {
+			/* support only read and write for now. */
+			ret = -EINVAL;
+			goto out_meta;
+		}
+	}
 
 	ret = nvme_execute_passthru_rq(req);
 	if (result)
@@ -100,6 +190,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		if (copy_to_user(meta_buffer, meta, meta_len))
 			ret = -EFAULT;
 	}
+ out_meta:
 	kfree(meta);
  out_unmap:
 	if (bio)
@@ -170,7 +261,8 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	return nvme_submit_user_cmd(ns->queue, &c,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
+			NULL);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -224,7 +316,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout);
+			0, &result, timeout, NULL);
 
 	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
@@ -235,45 +327,53 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 }
 
 static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd64 __user *ucmd)
+			struct nvme_passthru_cmd64 __user *ucmd,
+			struct io_uring_cmd *ioucmd)
 {
-	struct nvme_passthru_cmd64 cmd;
+	struct nvme_passthru_cmd64 cmd, *cptr;
 	struct nvme_command c;
 	unsigned timeout = 0;
 	int status;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
-		return -EFAULT;
-	if (cmd.flags)
+	if (!ioucmd) {
+		if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
+			return -EFAULT;
+		cptr = &cmd;
+	} else {
+		if (ioucmd->cmd_len != sizeof(struct nvme_passthru_cmd64))
+			return -EINVAL;
+		cptr = (struct nvme_passthru_cmd64 *)ioucmd->cmd;
+	}
+	if (cptr->flags)
 		return -EINVAL;
-	if (!nvme_validate_passthru_nsid(ctrl, ns, cmd.nsid))
+	if (!nvme_validate_passthru_nsid(ctrl, ns, cptr->nsid))
 		return -EINVAL;
 
 	memset(&c, 0, sizeof(c));
-	c.common.opcode = cmd.opcode;
-	c.common.flags = cmd.flags;
-	c.common.nsid = cpu_to_le32(cmd.nsid);
-	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
-	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
-	c.common.cdw10 = cpu_to_le32(cmd.cdw10);
-	c.common.cdw11 = cpu_to_le32(cmd.cdw11);
-	c.common.cdw12 = cpu_to_le32(cmd.cdw12);
-	c.common.cdw13 = cpu_to_le32(cmd.cdw13);
-	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
-	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
-
-	if (cmd.timeout_ms)
-		timeout = msecs_to_jiffies(cmd.timeout_ms);
+	c.common.opcode = cptr->opcode;
+	c.common.flags = cptr->flags;
+	c.common.nsid = cpu_to_le32(cptr->nsid);
+	c.common.cdw2[0] = cpu_to_le32(cptr->cdw2);
+	c.common.cdw2[1] = cpu_to_le32(cptr->cdw3);
+	c.common.cdw10 = cpu_to_le32(cptr->cdw10);
+	c.common.cdw11 = cpu_to_le32(cptr->cdw11);
+	c.common.cdw12 = cpu_to_le32(cptr->cdw12);
+	c.common.cdw13 = cpu_to_le32(cptr->cdw13);
+	c.common.cdw14 = cpu_to_le32(cptr->cdw14);
+	c.common.cdw15 = cpu_to_le32(cptr->cdw15);
+
+	if (cptr->timeout_ms)
+		timeout = msecs_to_jiffies(cptr->timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
-			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &cmd.result, timeout);
+			nvme_to_user_ptr(cptr->addr), cptr->data_len,
+			nvme_to_user_ptr(cptr->metadata), cptr->metadata_len,
+			0, &cptr->result, timeout, ioucmd);
 
-	if (status >= 0) {
-		if (put_user(cmd.result, &ucmd->result))
+	if (!ioucmd && status >= 0) {
+		if (put_user(cptr->result, &ucmd->result))
 			return -EFAULT;
 	}
 
@@ -296,7 +396,7 @@ static int nvme_ctrl_ioctl(struct nvme_ctrl *ctrl, unsigned int cmd,
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp);
+		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	default:
 		return sed_ioctl(ctrl->opal_dev, cmd, argp);
 	}
@@ -340,7 +440,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, argp);
 	case NVME_IOCTL_IO64_CMD:
-		return nvme_user_cmd64(ns->ctrl, ns, argp);
+		return nvme_user_cmd64(ns->ctrl, ns, argp, NULL);
 	default:
 		return -ENOTTY;
 	}
@@ -369,6 +469,33 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
+static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
+{
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
+
+	switch (ioucmd->cmd_op) {
+	case NVME_IOCTL_IO64_CMD:
+		ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	if (ret >= 0)
+		ret = -EIOCBQUEUED;
+	return ret;
+}
+
+int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+
+	return nvme_ns_async_ioctl(ns, ioucmd);
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -412,6 +539,20 @@ int nvme_ns_head_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
+int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	int ret = -EWOULDBLOCK;
+
+	if (ns)
+		ret = nvme_ns_async_ioctl(ns, ioucmd);
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
+
 long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg)
 {
@@ -480,7 +621,7 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp);
+		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f8bf6606eb2f..1d798d09456f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -459,6 +459,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.release	= nvme_ns_head_chr_release,
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.async_cmd	= nvme_ns_head_chr_async_cmd,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index b32f4e2c68fd..e6a30543d7c8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -752,6 +753,8 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd);
+int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
-- 
2.25.1

