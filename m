Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785636F2940
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 16:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjD3OgO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 10:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjD3OgM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 10:36:12 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA7E1BFF;
        Sun, 30 Apr 2023 07:36:10 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f19afc4fd8so8602545e9.2;
        Sun, 30 Apr 2023 07:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682865370; x=1685457370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k23ex7RimvLu0p4j9qUercROahTdeSFRLj0ExynF2G0=;
        b=XpCXJF1wUuad2iXbhWFEd8lr/hsLupBTiKoDTsim2EgvazHBJz0DSysIRRutuD+O1m
         RflXVe+nwxtN8+qYk9j61QjCIpmLCdlg9WVIE2A22CT/HwFw3koENXj3V+Y67R4rI7sz
         xxBNv+hPGE4IJJ+XzMc/mXgG9ZnP9ui9Akpd1sj8UapNOzNXA3+icb0TuS9WeU8Ceba3
         1AG+drjIl9U9pYE5MiF+I8gYEfpjXxtXtRKsPlX3+3fLcetNsV3iyWM19mtu2TGCyHjC
         Bg3p9XkkTY/NbDMJcOcSCuGosFTEVkR1xotpKuQ3owCLPpVPR3Mifg5eOyRQ9ZdYIkC9
         lluA==
X-Gm-Message-State: AC+VfDxl9+Tur18Di2slaMoIHUAdVIhs0NoR8rE2RdkApSUBw256oAKD
        Mx1trtSVtiUxuX4AGZWafu8ULo50S++k/w==
X-Google-Smtp-Source: ACHHUZ6NgjI8hY5U0kWNOftPpVXFnZaxTEqy883QrKbYdbf0y3frSWyb1AyUSwVJtyIG0msFLmmX8g==
X-Received: by 2002:a7b:c047:0:b0:3f1:7a44:317c with SMTP id u7-20020a7bc047000000b003f17a44317cmr8613355wmc.24.1682865369774;
        Sun, 30 Apr 2023 07:36:09 -0700 (PDT)
Received: from localhost (fwdproxy-cln-026.fbsv.net. [2a03:2880:31ff:1a::face:b00c])
        by smtp.gmail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm17707286wrl.82.2023.04.30.07.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 07:36:09 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        hch@lst.de, kbusch@kernel.org
Subject: [PATCH v3 4/4] block: ublk_drv: Add a helper instead of casting
Date:   Sun, 30 Apr 2023 07:35:32 -0700
Message-Id: <20230430143532.605367-5-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230430143532.605367-1-leitao@debian.org>
References: <20230430143532.605367-1-leitao@debian.org>
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

ublk driver is using casts to get private data from uring cmd struct.
Let's use a proper helper, as an interface that requires casts in all
callers is one asking for bugs.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/block/ublk_drv.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index ec23a3c9fac8..1fa6a4d54d6d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1261,9 +1261,21 @@ static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
 	ublk_queue_cmd(ubq, req);
 }
 
+static inline struct ublksrv_ctrl_cmd *ublk_uring_ctrl_cmd(
+		struct io_uring_cmd *cmd)
+{
+	return (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+}
+
+static inline struct ublksrv_io_cmd *ublk_uring_io_cmd(
+		struct io_uring_cmd *cmd)
+{
+	return (struct ublksrv_io_cmd *)cmd->sqe->cmd;
+}
+
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
-	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->sqe->cmd;
+	struct ublksrv_io_cmd *ub_cmd = ublk_uring_io_cmd(cmd);
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
 	struct ublk_io *io;
@@ -1567,7 +1579,7 @@ static struct ublk_device *ublk_get_device_from_id(int idx)
 
 static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	int ublksrv_pid = (int)header->data[0];
 	struct gendisk *disk;
 	int ret = -EINVAL;
@@ -1630,7 +1642,7 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 static int ublk_ctrl_get_queue_affinity(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	cpumask_var_t cpumask;
 	unsigned long queue;
@@ -1681,7 +1693,7 @@ static inline void ublk_dump_dev_info(struct ublksrv_ctrl_dev_info *info)
 
 static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublksrv_ctrl_dev_info info;
 	struct ublk_device *ub;
@@ -1844,7 +1856,7 @@ static int ublk_ctrl_del_dev(struct ublk_device **p_ub)
 
 static inline void ublk_ctrl_cmd_dump(struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 
 	pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len %u\n",
 			__func__, cmd->cmd_op, header->dev_id, header->queue_id,
@@ -1863,7 +1875,7 @@ static int ublk_ctrl_stop_dev(struct ublk_device *ub)
 static int ublk_ctrl_get_dev_info(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 
 	if (header->len < sizeof(struct ublksrv_ctrl_dev_info) || !header->addr)
@@ -1894,7 +1906,7 @@ static void ublk_ctrl_fill_params_devt(struct ublk_device *ub)
 static int ublk_ctrl_get_params(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublk_params_header ph;
 	int ret;
@@ -1925,7 +1937,7 @@ static int ublk_ctrl_get_params(struct ublk_device *ub,
 static int ublk_ctrl_set_params(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublk_params_header ph;
 	int ret = -EFAULT;
@@ -1983,7 +1995,7 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	int ret = -EINVAL;
 	int i;
 
@@ -2025,7 +2037,7 @@ static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	int ublksrv_pid = (int)header->data[0];
 	int ret = -EINVAL;
 
@@ -2092,7 +2104,7 @@ static int ublk_char_dev_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	bool unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	char *dev_path = NULL;
@@ -2171,7 +2183,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
+	struct ublksrv_ctrl_cmd *header = ublk_uring_ctrl_cmd(cmd);
 	struct ublk_device *ub = NULL;
 	int ret = -EINVAL;
 
-- 
2.34.1

