Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0C132B548
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhCCGlw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:41:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34567 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580514AbhCBSEG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 13:04:06 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210302161011epoutp02b828732fa70eaf660da1ea8193bbdd07~okmDuqlDq2337223372epoutp02i
        for <io-uring@vger.kernel.org>; Tue,  2 Mar 2021 16:10:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210302161011epoutp02b828732fa70eaf660da1ea8193bbdd07~okmDuqlDq2337223372epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614701411;
        bh=oYYJF2+0Q+nazX4eHeHQlijKnRKtjf1QNjpQm8uG0W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F71YKCM6mtEXa8aFvut+7rPQJfQwUwp+n27v5qHQucbj/0RX1wp+aNoz3XhwlYbBj
         dZoURe2UejKQG0tMm77zMZRv/sLxngbP5zDtwGppc59Q82XDnasIUsd9JiUWArFQTw
         NJUQG8zP2C0CjsdCSIlNSzDZpMENEV8xugHINvDA=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210302161010epcas5p3f181639ac3c6a13e3be06b4aa9d86a75~okmDMwt-r0522205222epcas5p3k;
        Tue,  2 Mar 2021 16:10:10 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.80.33964.2636E306; Wed,  3 Mar 2021 01:10:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83~okmCy6E-R2152321523epcas5p4X;
        Tue,  2 Mar 2021 16:10:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210302161010epsmtrp2914e3c68bd64783a29f3911909bfa95e~okmCxwOF80582505825epsmtrp2R;
        Tue,  2 Mar 2021 16:10:10 +0000 (GMT)
X-AuditID: b6c32a4b-ea1ff700000184ac-40-603e63622c85
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DA.5D.08745.2636E306; Wed,  3 Mar 2021 01:10:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210302161008epsmtip18302aae26aac4f1c9cf30025882965d4~okmBYJh5Q1292312923epsmtip1U;
        Tue,  2 Mar 2021 16:10:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC 3/3] nvme: wire up support for async passthrough
Date:   Tue,  2 Mar 2021 21:37:34 +0530
Message-Id: <20210302160734.99610-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302160734.99610-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsWy7bCmum5Ssl2CwcVnOhZNE/4yW6y+289m
        sXL1USaLd63nWCwe3/nMbnH0/1s2i0mHrjFazF/2lN3iypRFzA6cHpfPlnpsWtXJ5rF5Sb3H
        7psNbB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8WzvBJaCZXEVa2f0sTQwfvTtYuTgkBAw
        kfi2xLyLkYtDSGA3o8SJrffZIJxPjBIdLRegnM+MEsfb5zN2MXKCddy/c4wJIrGLUeL81+ks
        IKPAqlabgZhsApoSFyaXgpSLCBhJ7P90khWknFlgCqPEuYuHmUASwgJ2El82NbKA2CwCqhI7
        /+8Am88rYCFx7sYMdohd8hIzL31nB5nJKWApcWuvGkSJoMTJmU/AWpmBSpq3zmYGmS8h8Jdd
        4uiadiaIXheJl097oGxhiVfHt0DNlJL4/G4vG4RdLPHrzlGo5g5GiesNM1kgEvYSF/f8ZQJZ
        zAz0zPpd+hDL+CR6fz9hgoQcr0RHmxBEtaLEvUlPWSFscYmHM5ZA2R4Sr+f/BTtBSKCHUaLz
        l9cERvlZSF6YheSFWQjLFjAyr2KUTC0ozk1PLTYtMM5LLdcrTswtLs1L10vOz93ECE42Wt47
        GB89+KB3iJGJg/EQowQHs5IIr/hL2wQh3pTEyqrUovz4otKc1OJDjNIcLErivDsMHsQLCaQn
        lqRmp6YWpBbBZJk4OKUamAT4AkTOeVtHvQitWOwt9XiW8vcY9d7eltLW7F/peZMa/CVF1r5+
        5+59rWVl5LX7J3nt/aTMTI3f/l+0stzVIvDm8neR74Q++BbEKrR92386d024zT3hg28Ntu7S
        aDfYF8TKv+WyeX5X/a6l4hXWzl/afXy+v9XOzL1z9bn13+9PdNc0mlyc/vLGVqXAZfdzHkZI
        nyvzKiq9KNPuK1mlVn+d35ixY6GxrrBttCzHD4cZ6z46vVSbPO36H8EXvIrAeC2dPENG6Lqf
        lbHB+6e3hUOdRI+oLFYwKzyzodE94V7qhawJX62kr344wJAqwCE+1XJn+QblcteF620k3CKf
        T92hFe62fbubcITA7TQlluKMREMt5qLiRAD1rUNXpQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnG5Ssl2CwecdAhZNE/4yW6y+289m
        sXL1USaLd63nWCwe3/nMbnH0/1s2i0mHrjFazF/2lN3iypRFzA6cHpfPlnpsWtXJ5rF5Sb3H
        7psNbB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8WzvBJaCZXEVa2f0sTQwfvTtYuTkkBAw
        kbh/5xhTFyMXh5DADkaJ1xO2MEEkxCWar/1gh7CFJVb+e84OUfSRUWLxhiWMXYwcHGwCmhIX
        JpeC1IgImEksPbyGBcRmFpjBKLFhWTqILSxgJ/FlUyNYnEVAVWLn/x2MIDavgIXEuRszoObL
        S8y89J0dZCSngKXErb1qIGEhoJLJ6/6zQpQLSpyc+QRqvLxE89bZzBMYBWYhSc1CklrAyLSK
        UTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM42LW0djDuWfVB7xAjEwfjIUYJDmYlEV7x
        l7YJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTA1XOSr
        2G589vu6d1VHyx0mJ7+48/thtZTz7Uy7uac2vrnUWpG2c6NCp0WNp8Gb3Y5PpLd5Cr8rnxCZ
        +kXwpevOlbL6AU31OTXcH+em8Zim7zqd3Vobd+WJY8nckDiVCa9e6rolZPIYvHlcP1mg/Te3
        67Yzxt989iSyH2S63/VV5tx6zqqXh9g2C+/ImbHjo7Y218MjPl9MH20zWGlnuqO+ZY+adt7n
        T4+++0W2z/lxtFLoaMqtjhUVH/23Jsi+XHXiiXXO9qAko5TlRfP3zpM9Y8xmtOzs9T32jyVP
        t9+6KnKUR8F/RZwo0/wWjzZ+TVWRNt7tX30Klh8/Yynw9XZEieVR1keGL9/+2LfthNwqJZbi
        jERDLeai4kQAbR3UVeUCAAA=
X-CMS-MailID: 20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83
References: <20210302160734.99610-1-joshi.k@samsung.com>
        <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handler for mq_ops->uring_cmd(), implementing async
passthrough on block-device.
The passthrough command is submitted to device as before, but it is not
waited upon. When device notifies completion, driver sets up a
task-work based callback which first updates ioctl specific
fields/buffers and after that completes uring_cmd.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c | 212 ++++++++++++++++++++++++++++++++-------
 drivers/nvme/host/nvme.h |   3 +
 drivers/nvme/host/pci.c  |   1 +
 3 files changed, 180 insertions(+), 36 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 15c9490b593f..e894ead04935 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1053,6 +1053,89 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
+/*
+ * Convert integer values from ioctl structures to user pointers, silently
+ * ignoring the upper bits in the compat case to match behaviour of 32-bit
+ * kernels.
+ */
+static void __user *nvme_to_user_ptr(uintptr_t ptrval)
+{
+	if (in_compat_syscall())
+		ptrval = (compat_uptr_t)ptrval;
+	return (void __user *)ptrval;
+}
+/*
+ * This is carved within the block_uring_cmd, to avoid dynamic allocation.
+ * Care should be taken not to grow this beyond what is available.
+ */
+struct uring_cmd_data {
+	union {
+		struct bio *bio;
+		u64 result; /* nvme cmd result */
+	};
+	void *meta; /* kernel-resident buffer */
+	int status; /* nvme cmd status */
+};
+
+inline u64 *ucmd_data_addr(struct io_uring_cmd *ioucmd)
+{
+	return &(((struct block_uring_cmd *)&ioucmd->pdu)->unused[0]);
+}
+
+void ioucmd_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct uring_cmd_data *ucd;
+	struct nvme_passthru_cmd __user *ptcmd;
+	struct block_uring_cmd *bcmd;
+
+	bcmd = (struct block_uring_cmd *) &ioucmd->pdu;
+	ptcmd = (void __user *) bcmd->addr;
+	ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
+
+	/* handle meta update */
+	if (ucd->meta) {
+		void __user *umeta = nvme_to_user_ptr(ptcmd->metadata);
+
+		if (!ucd->status)
+			if (copy_to_user(umeta, ucd->meta, ptcmd->metadata_len))
+				ucd->status = -EFAULT;
+		kfree(ucd->meta);
+	}
+	/* handle result update */
+	if (put_user(ucd->result, (u32 __user *)&ptcmd->result))
+		ucd->status = -EFAULT;
+	io_uring_cmd_done(ioucmd, ucd->status);
+}
+
+void nvme_end_async_pt(struct request *req, blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd;
+	struct uring_cmd_data *ucd;
+	struct bio *bio;
+	int ret;
+
+	ioucmd = req->end_io_data;
+	ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
+	/* extract bio before reusing the same field for status */
+	bio = ucd->bio;
+
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		ucd->status = -EINTR;
+	else
+		ucd->status = nvme_req(req)->status;
+	ucd->result = le64_to_cpu(nvme_req(req)->result.u64);
+
+	/* this takes care of setting up task-work */
+	ret = uring_cmd_complete_in_task(ioucmd, ioucmd_task_cb);
+	if (ret < 0)
+		kfree(ucd->meta);
+
+	/* unmap pages, free bio, nvme command and request */
+	blk_rq_unmap_user(bio);
+	kfree(nvme_req(req)->cmd);
+	blk_mq_free_request(req);
+}
+
 static u32 nvme_known_admin_effects(u8 opcode)
 {
 	switch (opcode) {
@@ -1149,10 +1232,27 @@ void nvme_execute_passthru_rq(struct request *rq)
 }
 EXPORT_SYMBOL_NS_GPL(nvme_execute_passthru_rq, NVME_TARGET_PASSTHRU);
 
+static void nvme_setup_uring_cmd_data(struct request *rq,
+		struct io_uring_cmd *ioucmd, void *meta, bool write)
+{
+	struct uring_cmd_data *ucd;
+
+	ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
+	/* to free bio on completion, as req->bio will be null at that time */
+	ucd->bio = rq->bio;
+	/* meta update is required only for read requests */
+	if (meta && !write)
+		ucd->meta = meta;
+	else
+		ucd->meta = NULL;
+	rq->end_io_data = ioucmd;
+}
+
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout)
+		u32 meta_seed, u64 *result, unsigned int timeout,
+		struct io_uring_cmd *ioucmd)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -1188,6 +1288,11 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			req->cmd_flags |= REQ_INTEGRITY;
 		}
 	}
+	if (ioucmd) { /* async handling */
+		nvme_setup_uring_cmd_data(req, ioucmd, meta, write);
+		nvme_execute_passthru_rq_common(req, nvme_end_async_pt);
+		return 0;
+	}
 
 	nvme_execute_passthru_rq(req);
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
@@ -1553,18 +1658,6 @@ static void nvme_enable_aen(struct nvme_ctrl *ctrl)
 	queue_work(nvme_wq, &ctrl->async_event_work);
 }
 
-/*
- * Convert integer values from ioctl structures to user pointers, silently
- * ignoring the upper bits in the compat case to match behaviour of 32-bit
- * kernels.
- */
-static void __user *nvme_to_user_ptr(uintptr_t ptrval)
-{
-	if (in_compat_syscall())
-		ptrval = (compat_uptr_t)ptrval;
-	return (void __user *)ptrval;
-}
-
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
 	struct nvme_user_io io;
@@ -1625,14 +1718,16 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	return nvme_submit_user_cmd(ns->queue, &c,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
+			NULL);
 }
 
 static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd __user *ucmd)
+			struct nvme_passthru_cmd __user *ucmd,
+			struct io_uring_cmd *ioucmd)
 {
 	struct nvme_passthru_cmd cmd;
-	struct nvme_command c;
+	struct nvme_command c, *cptr;
 	unsigned timeout = 0;
 	u64 result;
 	int status;
@@ -1644,32 +1739,44 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	if (cmd.flags)
 		return -EINVAL;
 
-	memset(&c, 0, sizeof(c));
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
+	if (!ioucmd)
+		cptr = &c;
+	else {
+		/*for async - allocate cmd dynamically */
+		cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
+		if (!cptr)
+			return -ENOMEM;
+	}
+
+	memset(cptr, 0, sizeof(c));
+	cptr->common.opcode = cmd.opcode;
+	cptr->common.flags = cmd.flags;
+	cptr->common.nsid = cpu_to_le32(cmd.nsid);
+	cptr->common.cdw2[0] = cpu_to_le32(cmd.cdw2);
+	cptr->common.cdw2[1] = cpu_to_le32(cmd.cdw3);
+	cptr->common.cdw10 = cpu_to_le32(cmd.cdw10);
+	cptr->common.cdw11 = cpu_to_le32(cmd.cdw11);
+	cptr->common.cdw12 = cpu_to_le32(cmd.cdw12);
+	cptr->common.cdw13 = cpu_to_le32(cmd.cdw13);
+	cptr->common.cdw14 = cpu_to_le32(cmd.cdw14);
+	cptr->common.cdw15 = cpu_to_le32(cmd.cdw15);
 
 	if (cmd.timeout_ms)
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
-	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
+	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, cptr,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout);
+			0, &result, timeout, ioucmd);
 
-	if (status >= 0) {
+	if (!ioucmd && status >= 0) {
 		if (put_user(result, &ucmd->result))
 			return -EFAULT;
 	}
 
+	if (ioucmd && status < 0)
+		kfree(cptr);
+
 	return status;
 }
 
@@ -1707,7 +1814,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &cmd.result, timeout);
+			0, &cmd.result, timeout, NULL);
 
 	if (status >= 0) {
 		if (put_user(cmd.result, &ucmd->result))
@@ -1769,7 +1876,7 @@ static int nvme_handle_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		ret = nvme_user_cmd(ctrl, NULL, argp);
+		ret = nvme_user_cmd(ctrl, NULL, argp, NULL);
 		break;
 	case NVME_IOCTL_ADMIN64_CMD:
 		ret = nvme_user_cmd64(ctrl, NULL, argp);
@@ -1808,7 +1915,7 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 		ret = ns->head->ns_id;
 		break;
 	case NVME_IOCTL_IO_CMD:
-		ret = nvme_user_cmd(ns->ctrl, ns, argp);
+		ret = nvme_user_cmd(ns->ctrl, ns, argp, NULL);
 		break;
 	case NVME_IOCTL_SUBMIT_IO:
 		ret = nvme_submit_io(ns, argp);
@@ -1827,6 +1934,39 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
+int nvme_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
+		enum io_uring_cmd_flags flags)
+{
+	struct nvme_ns_head *head = NULL;
+	struct block_device *bdev = I_BDEV(ioucmd->file->f_mapping->host);
+	struct block_uring_cmd *bcmd = (struct block_uring_cmd *)&ioucmd->pdu;
+	struct nvme_ns *ns;
+	int srcu_idx, ret;
+	void __user *argp = (void __user *) bcmd->addr;
+
+	BUILD_BUG_ON(sizeof(struct uring_cmd_data) >
+			sizeof(struct block_uring_cmd) -
+			offsetof(struct block_uring_cmd, unused));
+
+	ns = nvme_get_ns_from_disk(bdev->bd_disk, &head, &srcu_idx);
+	if (unlikely(!ns))
+		return -EWOULDBLOCK;
+
+	switch (bcmd->ioctl_cmd) {
+	case NVME_IOCTL_IO_CMD:
+		ret = nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	if (ret >= 0)
+		ret = -EIOCBQUEUED;
+	nvme_put_ns_from_disk(head, srcu_idx);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_uring_cmd);
+
 #ifdef CONFIG_COMPAT
 struct nvme_user_io32 {
 	__u8	opcode;
@@ -3318,7 +3458,7 @@ static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
 	kref_get(&ns->kref);
 	up_read(&ctrl->namespaces_rwsem);
 
-	ret = nvme_user_cmd(ctrl, ns, argp);
+	ret = nvme_user_cmd(ctrl, ns, argp, NULL);
 	nvme_put_ns(ns);
 	return ret;
 
@@ -3335,7 +3475,7 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ctrl, NULL, argp);
+		return nvme_user_cmd(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_ADMIN64_CMD:
 		return nvme_user_cmd64(ctrl, NULL, argp);
 	case NVME_IOCTL_IO_CMD:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 07b34175c6ce..19b58311d8f7 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -19,6 +19,7 @@
 #include <linux/t10-pi.h>
 
 #include <trace/events/block.h>
+#include <linux/io_uring.h>
 
 extern unsigned int nvme_io_timeout;
 #define NVME_IO_TIMEOUT	(nvme_io_timeout * HZ)
@@ -620,6 +621,8 @@ int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
 void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
+int nvme_uring_cmd(struct request_queue *q, struct io_uring_cmd *ucmd,
+		enum io_uring_cmd_flags flags);
 struct request *nvme_alloc_request(struct request_queue *q,
 		struct nvme_command *cmd, blk_mq_req_flags_t flags);
 void nvme_cleanup_cmd(struct request *req);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7b6632c00ffd..6c84dc964259 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1629,6 +1629,7 @@ static const struct blk_mq_ops nvme_mq_ops = {
 	.map_queues	= nvme_pci_map_queues,
 	.timeout	= nvme_timeout,
 	.poll		= nvme_poll,
+	.uring_cmd	= nvme_uring_cmd,
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
-- 
2.25.1

