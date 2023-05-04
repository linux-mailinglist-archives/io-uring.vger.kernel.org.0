Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEE06F6B07
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 14:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjEDMTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 08:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjEDMTJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 08:19:09 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A4B6186;
        Thu,  4 May 2023 05:19:07 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f19a7f9424so4250905e9.2;
        Thu, 04 May 2023 05:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683202746; x=1685794746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9NGNi6mRkVCR2qGgOfiAwQ62RvEBOIDTb5fwVl75RrU=;
        b=P0oBQgZFRpY+X1bfQrQPSDmArzEd3S6kjm9VgJ80oTQgbuNr5yWS08oMv9HLJpjowt
         j81yfNyhPEZP9locj1soCps8XoDJ3HiZHuMgmEEv4jAd0BB7Srruhlz2CEblrg8Vdj5H
         uOxCSIgwsHCYTvC54txmLw/frWstI1iAaeLqf2BmF9aCYtnfbrn/JF4rDHEMLY2t+110
         1deIzWv5EISLWJQIahoKPh7NFUsZ/dvQrj2zO14Fi8K9bkyY2suF6KIMNT+oOndT62IL
         fzYJwcXqcINO9G2ZiZX6eFM+KgfAp1PMQNK8PDGsTW/XUxKoWTLtxmbAFI9RroK/ywrn
         ZEYw==
X-Gm-Message-State: AC+VfDwlGs+jE0GmVIbRGNiqyVcKUmHQTw1fTref95EL1IaEk0PvSTT3
        JcFw2RZqNDZdrWZOjwzk0+cQ+1rmSJlh8g==
X-Google-Smtp-Source: ACHHUZ75FunCVCcbYfiW5LlO1abDrDow/4py6f9oGCuMkvrxTImsMfvbqk9FDNnFommVIcSLCizahw==
X-Received: by 2002:a7b:cb8f:0:b0:3f1:885f:2e52 with SMTP id m15-20020a7bcb8f000000b003f1885f2e52mr17525032wmi.16.1683202746028;
        Thu, 04 May 2023 05:19:06 -0700 (PDT)
Received: from localhost (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0ac700b003f1958eeadcsm4757182wmr.17.2023.05.04.05.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 05:19:05 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, hch@lst.de, axboe@kernel.dk,
        ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        kbusch@kernel.org
Subject: [PATCH v4 2/3] io_uring: Pass whole sqe to commands
Date:   Thu,  4 May 2023 05:18:55 -0700
Message-Id: <20230504121856.904491-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504121856.904491-1-leitao@debian.org>
References: <20230504121856.904491-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently uring CMD operation relies on having large SQEs, but future
operations might want to use normal SQE.

The io_uring_cmd currently only saves the payload (cmd) part of the SQE,
but, for commands that use normal SQE size, it might be necessary to
access the initial SQE fields outside of the payload/cmd block.  So,
saves the whole SQE other than just the pdu.

This changes slightly how the io_uring_cmd works, since the cmd
structures and callbacks are not opaque to io_uring anymore. I.e, the
callbacks can look at the SQE entries, not only, in the cmd structure.

The main advantage is that we don't need to create custom structures for
simple commands.

Creates io_uring_sqe_cmd() that returns the cmd private data as a null
pointer and avoids casting in the callee side.
Also, make most of ublk_drv's sqe->cmd priv structure into const, and use
io_uring_sqe_cmd() to get the private structure, removing the unwanted
cast. (There is one case where the cast is still needed since the
header->{len,addr} is updated in the private structure)

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 drivers/block/ublk_drv.c  | 26 +++++++++++++-------------
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/io_uring.h  |  7 ++++++-
 io_uring/opdef.c          |  2 +-
 io_uring/uring_cmd.c      |  9 +++------
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c73cc57ec547..42f4d7ca962e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1019,7 +1019,7 @@ static int ublk_ch_mmap(struct file *filp, struct vm_area_struct *vma)
 }
 
 static void ublk_commit_completion(struct ublk_device *ub,
-		struct ublksrv_io_cmd *ub_cmd)
+		const struct ublksrv_io_cmd *ub_cmd)
 {
 	u32 qid = ub_cmd->q_id, tag = ub_cmd->tag;
 	struct ublk_queue *ubq = ublk_get_queue(ub, qid);
@@ -1263,7 +1263,7 @@ static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
 
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
-	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
+	const struct ublksrv_io_cmd *ub_cmd = io_uring_sqe_cmd(cmd->sqe);
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
 	struct ublk_io *io;
@@ -1567,7 +1567,7 @@ static struct ublk_device *ublk_get_device_from_id(int idx)
 
 static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	int ublksrv_pid = (int)header->data[0];
 	struct gendisk *disk;
 	int ret = -EINVAL;
@@ -1630,7 +1630,7 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 static int ublk_ctrl_get_queue_affinity(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	cpumask_var_t cpumask;
 	unsigned long queue;
@@ -1681,7 +1681,7 @@ static inline void ublk_dump_dev_info(struct ublksrv_ctrl_dev_info *info)
 
 static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublksrv_ctrl_dev_info info;
 	struct ublk_device *ub;
@@ -1844,7 +1844,7 @@ static int ublk_ctrl_del_dev(struct ublk_device **p_ub)
 
 static inline void ublk_ctrl_cmd_dump(struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 
 	pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len %u\n",
 			__func__, cmd->cmd_op, header->dev_id, header->queue_id,
@@ -1863,7 +1863,7 @@ static int ublk_ctrl_stop_dev(struct ublk_device *ub)
 static int ublk_ctrl_get_dev_info(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 
 	if (header->len < sizeof(struct ublksrv_ctrl_dev_info) || !header->addr)
@@ -1894,7 +1894,7 @@ static void ublk_ctrl_fill_params_devt(struct ublk_device *ub)
 static int ublk_ctrl_get_params(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublk_params_header ph;
 	int ret;
@@ -1925,7 +1925,7 @@ static int ublk_ctrl_get_params(struct ublk_device *ub,
 static int ublk_ctrl_set_params(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublk_params_header ph;
 	int ret = -EFAULT;
@@ -1983,7 +1983,7 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	int ret = -EINVAL;
 	int i;
 
@@ -2025,7 +2025,7 @@ static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	int ublksrv_pid = (int)header->data[0];
 	int ret = -EINVAL;
 
@@ -2092,7 +2092,7 @@ static int ublk_char_dev_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)io_uring_sqe_cmd(cmd->sqe);
 	bool unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	char *dev_path = NULL;
@@ -2171,7 +2171,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
 	struct ublk_device *ub = NULL;
 	int ret = -EINVAL;
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d24ea2e05156..81c5c9e38477 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -552,7 +552,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
+	const struct nvme_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
 	struct nvme_uring_data d;
 	struct nvme_command c;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b9328ca335..3399d979ee1c 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -24,7 +24,7 @@ enum io_uring_cmd_flags {
 
 struct io_uring_cmd {
 	struct file	*file;
-	const void	*cmd;
+	const struct io_uring_sqe *sqe;
 	union {
 		/* callback to defer completions to task context */
 		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
@@ -66,6 +66,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
+
+static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
+{
+	return sqe->cmd;
+}
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cca7c5b55208..3b9c6489b8b6 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -627,7 +627,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
-		.async_size		= uring_cmd_pdu_size(1),
+		.async_size		= 2 * sizeof(struct io_uring_sqe),
 		.prep_async		= io_uring_cmd_prep_async,
 	},
 	[IORING_OP_SEND_ZC] = {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5113c9a48583..ed536d7499db 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -69,15 +69,12 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 int io_uring_cmd_prep_async(struct io_kiocb *req)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	size_t cmd_size;
 
 	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
 	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
 
-	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
-
-	memcpy(req->async_data, ioucmd->cmd, cmd_size);
-	ioucmd->cmd = req->async_data;
+	memcpy(req->async_data, ioucmd->sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = req->async_data;
 	return 0;
 }
 
@@ -103,7 +100,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->imu = ctx->user_bufs[index];
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
-	ioucmd->cmd = sqe->cmd;
+	ioucmd->sqe = sqe;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
 }
-- 
2.34.1

