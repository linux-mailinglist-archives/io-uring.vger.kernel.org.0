Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD524EEEEB
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 16:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346700AbiDAOM4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 10:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346701AbiDAOMz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 10:12:55 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0F61D41A5
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 07:11:05 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220401141103epoutp032ce439c6a1762550781d34121a0ae65c~hyxzwlSAU2561825618epoutp03q
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 14:11:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220401141103epoutp032ce439c6a1762550781d34121a0ae65c~hyxzwlSAU2561825618epoutp03q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648822263;
        bh=r/KUjLt4Bg/gA0dLYWa5Eqs9yE5XqhklDfr+/HPLehQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yegwej5NNU1Oy4n5Tf8KbXMoerJp+TKGAfzmsQXRWUKeIoy8Ufxok5rFgXZy/wcMF
         OipRY3IdhRFkQjW5wQRBedeITxO8Io6LIbl11tGW8GMhqB/l7Gc25xmqoFCJFESqyj
         H/q6q+oZ74yP5uKGN8wC5yBOaP47rID07slg1pMs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220401141103epcas5p2ba46f7074212a9c98c284b64bf54af3f~hyxzI-aNX2063220632epcas5p2x;
        Fri,  1 Apr 2022 14:11:03 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KVMXN0xfzz4x9Pp; Fri,  1 Apr
        2022 14:11:00 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.92.06423.3F707426; Fri,  1 Apr 2022 23:10:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150~hwSiOqPHU0372703727epcas5p2L;
        Fri,  1 Apr 2022 11:08:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220401110838epsmtrp279e4817d21cc3e2584f1500f138ddf8c~hwSiN6kC02799827998epsmtrp2u;
        Fri,  1 Apr 2022 11:08:38 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-11-624707f31d08
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.63.24342.63DD6426; Fri,  1 Apr 2022 20:08:38 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220401110836epsmtip1fe2ae738631ac657a193c0ac0b10f28d~hwSgmR7A-2320023200epsmtip1Q;
        Fri,  1 Apr 2022 11:08:36 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        pankydev8@gmail.com, javier@javigon.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [RFC 5/5] nvme: wire-up support for async-passthru on char-device.
Date:   Fri,  1 Apr 2022 16:33:10 +0530
Message-Id: <20220401110310.611869-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401110310.611869-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGJsWRmVeSWpSXmKPExsWy7bCmuu5ndvckg39bTSyaJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ3z/eJq9oDG6YvnU
        FSwNjL+8uxg5OSQETCQ+bdnJ3sXIxSEksJtR4vTBOawQzidGiTWbzkFlvjFKzL+6lRGm5VfH
        ATaIxF5GiV93u6Ccz4wSfYe7gKo4ONgENCUuTC4FaRARkJf4cnstC0gNs8A1RonHrw6xgSSE
        Bbwlls2/wgpiswioSjQs7wfbwCtgKXHt1jpWiG3yEjMvfWcHsTkFrCQO/dvIBlEjKHFy5hMW
        EJsZqKZ562xmkAUSAks5JLrvzWCGaHaRmHvyCguELSzx6vgWdghbSuLzu71sEHayROv2y+wg
        R0sIlEgsWaAOEbaXuLjnLxNImBnol/W79CHCshJTT61jgljLJ9H7+wkTRJxXYsc8GFtR4t6k
        p1Dni0s8nLEEyvaQOL18AiMkrHoZJdYd/ck8gVFhFpJ3ZiF5ZxbC6gWMzKsYJVMLinPTU4tN
        CwzzUsvhsZycn7uJEZyAtTx3MN598EHvECMTB+MhRgkOZiUR3quxrklCvCmJlVWpRfnxRaU5
        qcWHGE2B4T2RWUo0OR+YA/JK4g1NLA1MzMzMTCyNzQyVxHlPp29IFBJITyxJzU5NLUgtgulj
        4uCUamCaf+NA3vT6fZb7njxN+u3GfePKHeMWrzeb74nsUzHRe/wuIyjz3c+ucLcSpeSAQ/Vc
        j2TvTXXZeEtIyLT94JxaDtUTaw+cventsOrntn6TlIu+iUFbtA7f6SjW5zdK2b85zfCYnU0a
        W1VE7E/ZusW358z+5nSHbdP1AO0HVw+uZTu6NOdmboXs0QUPsxc+n9Obbz+pc8ndol2tCywr
        tOLrFkRG8r6Xn5bP1d/tUGvntrez4Rbv1gUmyvEcKmxdQpcTuF1ES1NvX2p69Fx1/bd/Di/u
        Z9q7NL9UeCYQrHkizaBAg3uNxTdOWYMjJ86t/TptbknB07prbf/L8h01GeYpfTibzNl2PMfj
        YkO7CqsSS3FGoqEWc1FxIgCM/4AVSQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnK7ZXbckgylfpSyaJvxltpizahuj
        xeq7/WwWK1cfZbJ413qOxaLz9AUmi/NvDzNZzF/2lN3ixoSnjBaHJjczWay5+ZTFgdtj56y7
        7B7NC+6weFw+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        Ergyvn88zV7QGF2xfOoKlgbGX95djJwcEgImEr86DrB1MXJxCAnsZpSY+u4CO0RCXKL52g8o
        W1hi5b/n7BBFHxklFiz7ytTFyMHBJqApcWFyKUiNiICixMaPTYwgNcwCDxgl7k//zQaSEBbw
        llg2/woriM0ioCrRsLyfEcTmFbCUuHZrHSvEAnmJmZe+gy3jFLCSOPRvI1ivEFDN/qnzWCDq
        BSVOznwCZjMD1Tdvnc08gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLz
        czcxgmNES3MH4/ZVH/QOMTJxMB5ilOBgVhLhvRrrmiTEm5JYWZValB9fVJqTWnyIUZqDRUmc
        90LXyXghgfTEktTs1NSC1CKYLBMHp1QDk+URlRd6WuuC+C45HN/dOd18Ru0aE6UfBcFSkxxb
        Zhw2TlJ7ez/1uduydbrvmkIKPs/2T7x8Tvqsx2Wu5wlzjHfPuaCZ59Ipr52VNDGK+2bFUUVm
        j61ztpaf/z7390edUJOz/4Xbn1UZFsh9Lam6/8fs/Bkn2Tuff5euOzb/5DNHgX7fmf+PzDDY
        7LnZ7lOIt/kun6XM/3R0vAP23tcIvHuqbor43i9q51r0V01v/cmYuuP0BqYjqnLOXNMjH+5U
        ynict33anBnTzid0TopY98H72faTj38u7n8zOyDvQVDVtG8/fTe+nDbBYsfMmo6TE0Jnh8bq
        /c/fplwovaXRd4mn9dIbz3i9yvKCr+w+pLRMiaU4I9FQi7moOBEAgdHejQADAAA=
X-CMS-MailID: 20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150
References: <20220401110310.611869-1-joshi.k@samsung.com>
        <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handler for fops->async_cmd(), implementing async passthru
on char device (/dev/ngX). The handler supports NVME_IOCTL_IO64_CMD.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c      |   1 +
 drivers/nvme/host/ioctl.c     | 187 ++++++++++++++++++++++++++++------
 drivers/nvme/host/multipath.c |   1 +
 drivers/nvme/host/nvme.h      |   3 +
 4 files changed, 161 insertions(+), 31 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 961a5f8a44d2..38b9630c2cb7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3665,6 +3665,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.release	= nvme_ns_chr_release,
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.async_cmd	= nvme_ns_chr_async_cmd,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 22314962842d..1d15694d411c 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -19,6 +19,81 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
+/*
+ * This overlays struct io_uring_cmd pdu.
+ * Expect build errors if this grows larger than that.
+ */
+struct nvme_uring_cmd_pdu {
+	union {
+		struct bio *bio;
+		struct request *req;
+	};
+	void *meta; /* kernel-resident buffer */
+	void __user *meta_buffer;
+	u32 meta_len;
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
+	struct bio *bio = req->bio;
+	bool write = (req_op(req) == REQ_OP_DRV_OUT);
+	int status;
+	u64 result;
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
+	if (pdu->meta && !status && !write) {
+		if (copy_to_user(pdu->meta_buffer, pdu->meta, pdu->meta_len))
+			status = -EFAULT;
+	}
+	kfree(pdu->meta);
+
+	result = le64_to_cpu(nvme_req(req)->result.u64);
+	io_uring_cmd_done(ioucmd, status, result);
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
+
+	/* this takes care of moving rest of completion-work to task context */
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
+
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 		unsigned len, u32 seed, bool write)
 {
@@ -56,7 +131,8 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout)
+		u32 meta_seed, u64 *result, unsigned timeout,
+		struct io_uring_cmd *ioucmd)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -93,6 +169,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		}
 	}
 
+	if (ioucmd) { /* async dispatch */
+		nvme_setup_uring_cmd_data(req, ioucmd, meta, meta_buffer,
+				meta_len);
+		blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
+		return -EIOCBQUEUED;
+	}
 	ret = nvme_execute_passthru_rq(req);
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
@@ -170,7 +252,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	return nvme_submit_user_cmd(ns->queue, &c,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0, NULL);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -224,7 +306,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout);
+			0, &result, timeout, NULL);
 
 	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
@@ -235,45 +317,51 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
 
@@ -296,7 +384,7 @@ static int nvme_ctrl_ioctl(struct nvme_ctrl *ctrl, unsigned int cmd,
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp);
+		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	default:
 		return sed_ioctl(ctrl->opal_dev, cmd, argp);
 	}
@@ -340,7 +428,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, argp);
 	case NVME_IOCTL_IO64_CMD:
-		return nvme_user_cmd64(ns->ctrl, ns, argp);
+		return nvme_user_cmd64(ns->ctrl, ns, argp, NULL);
 	default:
 		return -ENOTTY;
 	}
@@ -369,6 +457,29 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
+static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
+{
+	int ret;
+
+	switch (ioucmd->cmd_op) {
+	case NVME_IOCTL_IO64_CMD:
+		ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	return ret;
+}
+
+int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+	return nvme_ns_async_ioctl(ns, ioucmd);
+}
+
+
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -435,6 +546,20 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+
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
 #endif /* CONFIG_NVME_MULTIPATH */
 
 static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
@@ -480,7 +605,7 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
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
index a162f6c6da6e..7b801c241d26 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -751,6 +752,8 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd);
+int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
-- 
2.25.1

