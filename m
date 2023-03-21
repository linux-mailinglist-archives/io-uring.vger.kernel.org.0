Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55B86C27BC
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 03:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCUCGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 22:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCUCGU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 22:06:20 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CC22F06B
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 19:06:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id kq3so2137765plb.13
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 19:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679364378; x=1681956378;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tjN4opgTz6XoF+JL1uegrK/9eRhyvfFnPa8psKIoKo=;
        b=DkBBXu0evQibHsMsKoAHV2L6dv1OAmyXMfyg9ww808USIEZdhgVoxxw7S35Cl3k+7M
         +zWlOO6Ip2GMI+T7O3EwjXKvQ3YhF1ZQhLHGZ6KhP64/0d7Psg93Mbk5/Xz1t2FBMvXX
         +pVOZawrqIp1BzhH3Hx3RE6dEBmFot7zdEyDSyI4MyvF3kRESeYdpbG/1JyknJND8+Fa
         OwevDcaE2py1J5CfN3JDZOrZVIcCERL1jlWVfSroC8U2pJvD8EX+QH93ebZR1F49vhUO
         Lx7fSE7JApJXPhQOIq0VA4iDiU4aD2qOE9jMinaBPKG8e+R9B0ETm93UYxpVWEbimoJl
         bsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679364378; x=1681956378;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9tjN4opgTz6XoF+JL1uegrK/9eRhyvfFnPa8psKIoKo=;
        b=DxOLaltIv9RuVCGSdMzeNbX/6D/bNTCithrR1IEjB7lWlG1OVGKrfJs+YF8s3tT/Hi
         JN+ruchNqXB0xW/Ym7/myFsidIvDEihqa8ggewfXwrH0eGVD2wEJeRcYumXghOFYxzdy
         eViYk1molCx4Pc+W5X7AR6XMQZ0yIWsFWjdu7rZrVMn7495Kk/brkIcm2z2RV5S9CCif
         DYAIfSNKXsnHbZXcgDwrYT2H+HN5cCnat+B00qivQKPGFh9qwjGBIStzs4fGRCRZCrBm
         nx1qwGihglgvaxM9bDHWbhDw/GFmRYSVepeNygtG7u65J+Bfymx1KkPELY045YJv5171
         n4Gg==
X-Gm-Message-State: AO0yUKWh0Hoc/yuu+gq5I0floNLRabCxkvnX78cWtc/x426/7lO8jQVi
        6IlnbbJamQ7kBjZQw+TvFXvqw6SuFrYykOh8jlgcAg==
X-Google-Smtp-Source: AK7set8rVnrTbdzwQpN9KZruPpbq2k73mFdK+7t61gkEE9OmZxeppFIJDesv/8Kj4HYHOJIbAHrciQ==
X-Received: by 2002:a05:6a20:6914:b0:cd:2c0a:6ec0 with SMTP id q20-20020a056a20691400b000cd2c0a6ec0mr522783pzj.3.1679364378062;
        Mon, 20 Mar 2023 19:06:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79143000000b0059261bd5bacsm6904365pfi.202.2023.03.20.19.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 19:06:17 -0700 (PDT)
Message-ID: <c56fc63e-7e6b-480e-dfdc-417b00802f11@kernel.dk>
Date:   Mon, 20 Mar 2023 20:06:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block/io_uring: pass in issue_flags for uring_cmd task_work
 handling
Cc:     Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_cmd_done() currently assumes that the uring_lock is held
when invoked, and while it generally is, this is not guaranteed.
Pass in the issue_flags associated with it, so that we have
IO_URING_F_UNLOCKED available to be able to lock the CQ ring
appropriately when completing events.

Cc: stable@vger.kernel.org
Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index fb5a557afde8..c73cc57ec547 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -715,7 +715,8 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 	}
 }
 
-static void ubq_complete_io_cmd(struct ublk_io *io, int res)
+static void ubq_complete_io_cmd(struct ublk_io *io, int res,
+				unsigned issue_flags)
 {
 	/* mark this cmd owned by ublksrv */
 	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
@@ -727,7 +728,7 @@ static void ubq_complete_io_cmd(struct ublk_io *io, int res)
 	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
 
 	/* tell ublksrv one io request is coming */
-	io_uring_cmd_done(io->cmd, res, 0);
+	io_uring_cmd_done(io->cmd, res, 0, issue_flags);
 }
 
 #define UBLK_REQUEUE_DELAY_MS	3
@@ -744,7 +745,8 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }
 
-static inline void __ublk_rq_task_work(struct request *req)
+static inline void __ublk_rq_task_work(struct request *req,
+				       unsigned issue_flags)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	int tag = req->tag;
@@ -782,7 +784,7 @@ static inline void __ublk_rq_task_work(struct request *req)
 			pr_devel("%s: need get data. op %d, qid %d tag %d io_flags %x\n",
 					__func__, io->cmd->cmd_op, ubq->q_id,
 					req->tag, io->flags);
-			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA);
+			ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA, issue_flags);
 			return;
 		}
 		/*
@@ -820,17 +822,18 @@ static inline void __ublk_rq_task_work(struct request *req)
 			mapped_bytes >> 9;
 	}
 
-	ubq_complete_io_cmd(io, UBLK_IO_RES_OK);
+	ubq_complete_io_cmd(io, UBLK_IO_RES_OK, issue_flags);
 }
 
-static inline void ublk_forward_io_cmds(struct ublk_queue *ubq)
+static inline void ublk_forward_io_cmds(struct ublk_queue *ubq,
+					unsigned issue_flags)
 {
 	struct llist_node *io_cmds = llist_del_all(&ubq->io_cmds);
 	struct ublk_rq_data *data, *tmp;
 
 	io_cmds = llist_reverse_order(io_cmds);
 	llist_for_each_entry_safe(data, tmp, io_cmds, node)
-		__ublk_rq_task_work(blk_mq_rq_from_pdu(data));
+		__ublk_rq_task_work(blk_mq_rq_from_pdu(data), issue_flags);
 }
 
 static inline void ublk_abort_io_cmds(struct ublk_queue *ubq)
@@ -842,12 +845,12 @@ static inline void ublk_abort_io_cmds(struct ublk_queue *ubq)
 		__ublk_abort_rq(ubq, blk_mq_rq_from_pdu(data));
 }
 
-static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd)
+static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
 {
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
 
-	ublk_forward_io_cmds(ubq);
+	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
 static void ublk_rq_task_work_fn(struct callback_head *work)
@@ -856,8 +859,9 @@ static void ublk_rq_task_work_fn(struct callback_head *work)
 			struct ublk_rq_data, work);
 	struct request *req = blk_mq_rq_from_pdu(data);
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	unsigned issue_flags = IO_URING_F_UNLOCKED;
 
-	ublk_forward_io_cmds(ubq);
+	ublk_forward_io_cmds(ubq, issue_flags);
 }
 
 static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
@@ -1111,7 +1115,8 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 		struct ublk_io *io = &ubq->ios[i];
 
 		if (io->flags & UBLK_IO_FLAG_ACTIVE)
-			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0);
+			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
+						IO_URING_F_UNLOCKED);
 	}
 
 	/* all io commands are canceled */
@@ -1351,7 +1356,7 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
 	return -EIOCBQUEUED;
@@ -2234,7 +2239,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (ub)
 		ublk_put_device(ub);
  out:
-	io_uring_cmd_done(cmd, ret, 0);
+	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
 	return -EIOCBQUEUED;
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 723e7d5b778f..d24ea2e05156 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -464,7 +464,8 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
-static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd,
+				    unsigned issue_flags)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	struct request *req = pdu->req;
@@ -485,17 +486,18 @@ static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd)
 		blk_rq_unmap_user(req->bio);
 	blk_mq_free_request(req);
 
-	io_uring_cmd_done(ioucmd, status, result);
+	io_uring_cmd_done(ioucmd, status, result, issue_flags);
 }
 
-static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
+			       unsigned issue_flags)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
 
-	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result);
+	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result, issue_flags);
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
@@ -517,7 +519,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd);
+		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 
@@ -539,7 +541,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
 	 * Otherwise, move the completion to task work.
 	 */
 	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_meta_cb(ioucmd);
+		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 934e5dd4ccc0..35b9328ca335 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -27,7 +27,7 @@ struct io_uring_cmd {
 	const void	*cmd;
 	union {
 		/* callback to defer completions to task context */
-		void (*task_work_cb)(struct io_uring_cmd *cmd);
+		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
 		/* used for polled completion */
 		void *cookie;
 	};
@@ -39,9 +39,10 @@ struct io_uring_cmd {
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+			unsigned issue_flags);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *));
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
@@ -72,11 +73,11 @@ static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	return -EOPNOTSUPP;
 }
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
-		ssize_t ret2)
+		ssize_t ret2, unsigned issue_flags)
 {
 }
 static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *))
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 }
 static inline struct sock *io_uring_get_socket(struct file *file)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 446a189b78b0..e535e8db01e3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -15,12 +15,13 @@
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
 
-	ioucmd->task_work_cb(ioucmd);
+	ioucmd->task_work_cb(ioucmd, issue_flags);
 }
 
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *))
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -42,7 +43,8 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
+		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -56,7 +58,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
 	else
-		io_req_complete_post(req, 0);
+		io_req_complete_post(req, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-- 
Jens Axboe

