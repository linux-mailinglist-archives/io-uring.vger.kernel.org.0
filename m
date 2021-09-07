Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32164024AF
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 09:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbhIGHr7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 03:47:59 -0400
Received: from verein.lst.de ([213.95.11.211]:34955 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233953AbhIGHr6 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 7 Sep 2021 03:47:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8B0CC67373; Tue,  7 Sep 2021 09:46:50 +0200 (CEST)
Date:   Tue, 7 Sep 2021 09:46:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de
Subject: Re: [RFC PATCH 2/6] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20210907074650.GB29874@lst.de>
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a@epcas5p1.samsung.com> <20210805125539.66958-3-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805125539.66958-3-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looking at this in isolation:

 - no need to also implement the legacy non-64 passthrough interface
 - no need to overlay the block_uring_cmd structure as that makes a
   complete mess

Below is an untested patch to fix that up a bit.

A few other notes:

 - I suspect the ioctl_cmd really should move into the core using_cmd
   infrastructure
 - please stick to the naming of the file operation instead of using
   something different.  That being said async_ioctl seems better
   fitting than uring_cmd
 - that whole mix of user space interface and internal data in the
   ->pdu field is a mess.  What is the problem with deferring the
   request freeing into the user context, which would clean up
   quite a bit of that, especially if io_uring_cmd grows a private
   field.

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d336e34aac410..8ceff441b6425 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -18,12 +18,12 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 		ptrval = (compat_uptr_t)ptrval;
 	return (void __user *)ptrval;
 }
-/*
- * This is carved within the io_uring_cmd, to avoid dynamic allocation.
- * Care should be taken not to grow this beyond what is available.
- * Expect build warning otherwise.
- */
-struct uring_cmd_data {
+
+/* This overlays struct io_uring_cmd pdu (40 bytes) */
+struct nvme_uring_cmd {
+	__u32	ioctl_cmd;
+	__u32	unused1;
+	void __user *argp;
 	union {
 		struct bio *bio;
 		u64 result; /* nvme cmd result */
@@ -32,57 +32,42 @@ struct uring_cmd_data {
 	int status; /* nvme cmd status */
 };
 
-inline u64 *nvme_ioucmd_data_addr(struct io_uring_cmd *ioucmd)
+static struct nvme_uring_cmd *nvme_uring_cmd(struct io_uring_cmd *ioucmd)
 {
-	return &(((struct block_uring_cmd *)&ioucmd->pdu)->unused2[1]);
+	return (struct nvme_uring_cmd *)&ioucmd->pdu;
 }
 
 static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
 {
-	struct uring_cmd_data *ucd;
-	struct nvme_passthru_cmd64 __user *ptcmd64 = NULL;
-	struct block_uring_cmd *bcmd;
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
+	struct nvme_passthru_cmd64 __user *ptcmd64 = cmd->argp;
 
-	bcmd = (struct block_uring_cmd *) &ioucmd->pdu;
-	ptcmd64 = (void __user *) bcmd->unused2[0];
-	ucd = (struct uring_cmd_data *) nvme_ioucmd_data_addr(ioucmd);
-
-	if (ucd->meta) {
+	if (cmd->meta) {
 		void __user *umeta = nvme_to_user_ptr(ptcmd64->metadata);
 
-		if (!ucd->status)
-			if (copy_to_user(umeta, ucd->meta, ptcmd64->metadata_len))
-				ucd->status = -EFAULT;
-		kfree(ucd->meta);
+		if (!cmd->status)
+			if (copy_to_user(umeta, cmd->meta, ptcmd64->metadata_len))
+				cmd->status = -EFAULT;
+		kfree(cmd->meta);
 	}
-	if (likely(bcmd->ioctl_cmd == NVME_IOCTL_IO64_CMD)) {
-		if (put_user(ucd->result, &ptcmd64->result))
-			ucd->status = -EFAULT;
-	} else {
-		struct nvme_passthru_cmd __user *ptcmd = (void *)bcmd->unused2[0];
 
-		if (put_user(ucd->result, &ptcmd->result))
-			ucd->status = -EFAULT;
-	}
-	io_uring_cmd_done(ioucmd, ucd->status);
+	if (put_user(cmd->result, &ptcmd64->result))
+		cmd->status = -EFAULT;
+	io_uring_cmd_done(ioucmd, cmd->status);
 }
 
 static void nvme_end_async_pt(struct request *req, blk_status_t err)
 {
-	struct io_uring_cmd *ioucmd;
-	struct uring_cmd_data *ucd;
-	struct bio *bio;
-
-	ioucmd = req->end_io_data;
-	ucd = (struct uring_cmd_data *) nvme_ioucmd_data_addr(ioucmd);
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
 	/* extract bio before reusing the same field for status */
-	bio = ucd->bio;
+	struct bio *bio = cmd->bio;
 
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
-		ucd->status = -EINTR;
+		cmd->status = -EINTR;
 	else
-		ucd->status = nvme_req(req)->status;
-	ucd->result = le64_to_cpu(nvme_req(req)->result.u64);
+		cmd->status = nvme_req(req)->status;
+	cmd->result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/* this takes care of setting up task-work */
 	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
@@ -95,14 +80,15 @@ static void nvme_end_async_pt(struct request *req, blk_status_t err)
 static void nvme_setup_uring_cmd_data(struct request *rq,
 		struct io_uring_cmd *ioucmd, void *meta, bool write)
 {
-	struct uring_cmd_data *ucd;
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
 
-	ucd = (struct uring_cmd_data *) nvme_ioucmd_data_addr(ioucmd);
 	/* to free bio on completion, as req->bio will be null at that time */
-	ucd->bio = rq->bio;
+	cmd->bio = rq->bio;
 	/* meta update is required only for read requests */
 	if (meta && !write)
-		ucd->meta = meta;
+		cmd->meta = meta;
+	else
+		cmd->meta = NULL;
 	rq->end_io_data = ioucmd;
 }
 
@@ -139,23 +125,19 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 out:
 	return ERR_PTR(ret);
 }
+
 static inline bool nvme_is_fixedb_passthru(struct io_uring_cmd *ioucmd)
 {
-	struct block_uring_cmd *bcmd;
-
 	if (!ioucmd)
 		return false;
-	bcmd = (struct block_uring_cmd *)&ioucmd->pdu;
-	if (bcmd && ((bcmd->ioctl_cmd == NVME_IOCTL_IO_CMD_FIXED) ||
-				(bcmd->ioctl_cmd == NVME_IOCTL_IO64_CMD_FIXED)))
-		return true;
-	return false;
+	return nvme_uring_cmd(ioucmd)->ioctl_cmd == NVME_IOCTL_IO64_CMD_FIXED;
 }
+
 /*
  * Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough.
  * And hopefully faster as well.
  */
-int nvme_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
+static int nvme_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
 		     void __user *ubuf, unsigned long len, gfp_t gfp_mask,
 		     struct io_uring_cmd *ioucmd)
 {
@@ -345,8 +327,7 @@ static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
 }
 
 static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd __user *ucmd,
-			struct io_uring_cmd *ioucmd)
+			struct nvme_passthru_cmd __user *ucmd)
 {
 	struct nvme_passthru_cmd cmd;
 	struct nvme_command c;
@@ -382,9 +363,9 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout, ioucmd);
+			0, &result, timeout, NULL);
 
-	if (!ioucmd && status >= 0) {
+	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
 			return -EFAULT;
 	}
@@ -453,7 +434,7 @@ static int nvme_ctrl_ioctl(struct nvme_ctrl *ctrl, unsigned int cmd,
 {
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ctrl, NULL, argp, NULL);
+		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
 		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	default:
@@ -487,7 +468,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		force_successful_syscall_return();
 		return ns->head->ns_id;
 	case NVME_IOCTL_IO_CMD:
-		return nvme_user_cmd(ns->ctrl, ns, argp, NULL);
+		return nvme_user_cmd(ns->ctrl, ns, argp);
 	/*
 	 * struct nvme_user_io can have different padding on some 32-bit ABIs.
 	 * Just accept the compat version as all fields that are used are the
@@ -532,22 +513,13 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
 {
-	struct block_uring_cmd *bcmd = (struct block_uring_cmd *)&ioucmd->pdu;
-	void __user *argp = (void __user *) bcmd->unused2[0];
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
 	int ret;
 
-	BUILD_BUG_ON(sizeof(struct uring_cmd_data) >
-			sizeof(struct block_uring_cmd) -
-			offsetof(struct block_uring_cmd, unused2[1]));
-
-	switch (bcmd->ioctl_cmd) {
-	case NVME_IOCTL_IO_CMD:
-	case NVME_IOCTL_IO_CMD_FIXED:
-		ret = nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);
-		break;
+	switch (cmd->ioctl_cmd) {
 	case NVME_IOCTL_IO64_CMD:
 	case NVME_IOCTL_IO64_CMD_FIXED:
-		ret = nvme_user_cmd64(ns->ctrl, ns, argp, ioucmd);
+		ret = nvme_user_cmd64(ns->ctrl, ns, cmd->argp, ioucmd);
 		break;
 	default:
 		ret = -ENOTTY;
@@ -674,7 +646,7 @@ static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
 	kref_get(&ns->kref);
 	up_read(&ctrl->namespaces_rwsem);
 
-	ret = nvme_user_cmd(ctrl, ns, argp, NULL);
+	ret = nvme_user_cmd(ctrl, ns, argp);
 	nvme_put_ns(ns);
 	return ret;
 
@@ -691,7 +663,7 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ctrl, NULL, argp, NULL);
+		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
 		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_IO_CMD:
diff --git a/include/uapi/linux/nvme_ioctl.h b/include/uapi/linux/nvme_ioctl.h
index fc05c6024edd6..a65e648a57928 100644
--- a/include/uapi/linux/nvme_ioctl.h
+++ b/include/uapi/linux/nvme_ioctl.h
@@ -78,7 +78,6 @@ struct nvme_passthru_cmd64 {
 #define NVME_IOCTL_RESCAN	_IO('N', 0x46)
 #define NVME_IOCTL_ADMIN64_CMD	_IOWR('N', 0x47, struct nvme_passthru_cmd64)
 #define NVME_IOCTL_IO64_CMD	_IOWR('N', 0x48, struct nvme_passthru_cmd64)
-#define NVME_IOCTL_IO_CMD_FIXED	_IOWR('N', 0x49, struct nvme_passthru_cmd)
 #define NVME_IOCTL_IO64_CMD_FIXED _IOWR('N', 0x50, struct nvme_passthru_cmd64)
 
 #endif /* _UAPI_LINUX_NVME_IOCTL_H */
