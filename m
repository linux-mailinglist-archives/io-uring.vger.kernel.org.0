Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A83C578128
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 13:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiGRLo5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 07:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiGRLo4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 07:44:56 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440AEB72;
        Mon, 18 Jul 2022 04:44:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VJk0F0G_1658144691;
Received: from 30.97.56.227(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VJk0F0G_1658144691)
          by smtp.aliyun-inc.com;
          Mon, 18 Jul 2022 19:44:52 +0800
Message-ID: <9993fb25-ecd1-4682-99b9-e83472583897@linux.alibaba.com>
Date:   Mon, 18 Jul 2022 19:44:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        joseph.qi@linux.alibaba.com,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH] ublk_drv: add one new ublk command: UBLK_IO_NEED_GET_DATA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add one new ublk command: UBLK_IO_NEED_GET_DATA.

It is designed for a user application who wants to allocate IO buffer
and set IO buffer address only after it receives an IO request.

1. Background:
For now, ublk requires the user to set IO buffer address in advance(with
last UBLK_IO_COMMIT_AND_FETCH_REQ command)so the user has to
pre-allocate IO buffer.

For READ requests, this work flow looks good because the data copy
happens after user application gets a cqe and the kernel copies data.
So user application can allocate IO buffer, copy data to be read into
it, and issues a sqe with the newly allocated IO buffer.

However, for WRITE requests, this work flow looks weird because
the data copy happens in a task_work before the user application gets one
cqe. So it is inconvenient for users who allocates(or fetch from a
memory pool)buffer after it gets one request(and know the actual data
size).

2. Design:
Consider add a new feature flag: UBLK_F_NEED_GET_DATA.

If user sets this new flag(through libublksrv) and pass it to kernel
driver, ublk kernel driver should returns a cqe with
UBLK_IO_RES_NEED_GET_DATA after a new blk-mq WRITE request comes.

A user application now can allocate data buffer for writing and pass its
address in UBLK_IO_NEED_GET_DATA command after ublk kernel driver returns
cqe with UBLK_IO_RES_NEED_GET_DATA.

After the kernel side gets the sqe (UBLK_IO_NEED_GET_DATA command), it
now copies(address pinned, indeed) data to be written from bio vectors
to newly returned IO data buffer.

Finally, the kernel side returns UBLK_IO_RES_OK and ublksrv handles the
IO request as usual.The new feature: UBLK_F_NEED_GET_DATA is enabled on
demand ublksrv still can pre-allocate data buffers with task_work.

3. Evaluation:
We modify ublksrv to support UBLK_F_NEED_GET_DATA and the modification
will be PR-ed to Ming Lei's github repository soon if this patch is
okay.

We have tested write latency with:
  (1)  No UBLK_F_NEED_GET_DATA(the old commit) as baseline
  (2)  UBLK_F_NEED_GET_DATA enabled/disabled
on demo_null and demo_event of newest ublksrv project.

Config of fio:bs=4k, iodepth=1, numjobs=1, rw=write/randwrite, direct=1,
ioengine=libaio.

Here is the comparison of lat(usec) in fio:

demo_null:
write:        28.74(baseline) -- 28.77(disable) -- 57.20(enable)
randwrite:    27.81(baseline) -- 28.51(disable) -- 54.81(enable)

demo_event:
write:        46.45(baseline) -- 43.31(disable) -- 75.50(enable)
randwrite:    45.39(baseline) -- 43.66(disable) -- 76.02(enable)

Looks like:
  (1) UBLK_F_NEED_GET_DATA does not introduce additional overhead when
      comparing baseline and disable.
  (2) enabling UBLK_F_NEED_GET_DATA adds about two times more latency
      than disabling it. And it is reasonable since the IO goes through
      the total ublk IO stack(ubd_drv <--> ublksrv) once again.
  (3) demo_null and demo_event are both null targets. And I think this
      overhead is not too heavy if real data handling backend is used.

Signed-off-by: ZiyangZhang <ZiyangZhang@linux.alibaba.com>
---
 drivers/block/ublk_drv.c      | 77 +++++++++++++++++++++++++++++++----
 include/uapi/linux/ublk_cmd.h | 19 +++++++++
 2 files changed, 88 insertions(+), 8 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 2c1b01d7f27d..0d56ae680cfe 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -83,6 +83,8 @@ struct ublk_uring_cmd_pdu {
  */
 #define UBLK_IO_FLAG_ABORTED 0x04
 
+#define UBLK_IO_FLAG_NEED_GET_DATA 0x08
+
 struct ublk_io {
 	/* userspace buffer address from io cmd */
 	__u64	addr;
@@ -160,11 +162,19 @@ static struct lock_class_key ublk_bio_compl_lkclass;
 static inline bool ublk_can_use_task_work(const struct ublk_queue *ubq)
 {
 	if (IS_BUILTIN(CONFIG_BLK_DEV_UBLK) &&
+			!(ubq->flags & UBLK_F_NEED_GET_DATA) &&
 			!(ubq->flags & UBLK_F_URING_CMD_COMP_IN_TASK))
 		return true;
 	return false;
 }
 
+static inline bool ublk_need_get_data(const struct ublk_queue *ubq)
+{
+	if (ubq->flags & UBLK_F_NEED_GET_DATA)
+		return true;
+	return false;
+}
+
 static struct ublk_device *ublk_get_device(struct ublk_device *ub)
 {
 	if (kobject_get_unless_zero(&ub->cdev_dev.kobj))
@@ -514,6 +524,21 @@ static void __ublk_fail_req(struct ublk_io *io, struct request *req)
 	}
 }
 
+static void ubq_complete_io_cmd(struct ublk_io *io, int res)
+{
+	/* mark this cmd owned by ublksrv */
+	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
+
+	/*
+	 * clear ACTIVE since we are done with this sqe/cmd slot
+	 * We can only accept io cmd in case of being not active.
+	 */
+	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
+
+	/* tell ublksrv one io request is coming */
+	io_uring_cmd_done(io->cmd, res, 0);
+}
+
 #define UBLK_REQUEUE_DELAY_MS	3
 
 static inline void __ublk_rq_task_work(struct request *req)
@@ -536,6 +561,20 @@ static inline void __ublk_rq_task_work(struct request *req)
 		return;
 	}
 
+	if (ublk_need_get_data(ubq) &&
+			(req_op(req) == REQ_OP_WRITE ||
+			req_op(req) == REQ_OP_FLUSH) &&
+			!(io->flags & UBLK_IO_FLAG_NEED_GET_DATA)) {
+
+		pr_devel("%s: ublk_need_get_data. op %d, qid %d tag %d io_flags %x\n",
+				__func__, io->cmd->cmd_op, ubq->q_id, req->tag, io->flags);
+
+		io->flags |= UBLK_IO_FLAG_NEED_GET_DATA;
+
+		ubq_complete_io_cmd(io, UBLK_IO_RES_NEED_GET_DATA);
+		return;
+	}
+
 	mapped_bytes = ublk_map_io(ubq, req, io);
 
 	/* partially mapped, update io descriptor */
@@ -558,17 +597,13 @@ static inline void __ublk_rq_task_work(struct request *req)
 			mapped_bytes >> 9;
 	}
 
-	/* mark this cmd owned by ublksrv */
-	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
-
 	/*
-	 * clear ACTIVE since we are done with this sqe/cmd slot
-	 * We can only accept io cmd in case of being not active.
+	 * Anyway, we have handled UBLK_IO_NEED_GET_DATA for WRITE/FLUSH requests,
+	 * or we did nothing for other types requests.
 	 */
-	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
+	io->flags &= ~UBLK_IO_FLAG_NEED_GET_DATA;
 
-	/* tell ublksrv one io request is coming */
-	io_uring_cmd_done(io->cmd, UBLK_IO_RES_OK, 0);
+	ubq_complete_io_cmd(io, UBLK_IO_RES_OK);
 }
 
 static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd)
@@ -860,6 +895,16 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
 	mutex_unlock(&ub->mutex);
 }
 
+static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
+		int tag, struct io_uring_cmd *cmd)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
+
+	pdu->req = req;
+	io_uring_cmd_complete_in_task(cmd, ublk_rq_task_work_cb);
+}
+
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
@@ -898,6 +943,14 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		goto out;
 	}
 
+	/*
+	 * ensure that the user issues UBLK_IO_NEED_GET_DATA
+	 * if the driver have set the UBLK_IO_FLAG_NEED_GET_DATA.
+	 */
+	if ((io->flags & UBLK_IO_FLAG_NEED_GET_DATA)
+			&& (cmd_op != UBLK_IO_NEED_GET_DATA))
+		goto out;
+
 	switch (cmd_op) {
 	case UBLK_IO_FETCH_REQ:
 		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
@@ -931,6 +984,14 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		io->cmd = cmd;
 		ublk_commit_completion(ub, ub_cmd);
 		break;
+	case UBLK_IO_NEED_GET_DATA:
+		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
+			goto out;
+		io->addr = ub_cmd->addr;
+		io->cmd = cmd;
+		io->flags |= UBLK_IO_FLAG_ACTIVE;
+		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag, cmd);
+		break;
 	default:
 		goto out;
 	}
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index a3f5e7c21807..711170f961ac 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -28,12 +28,22 @@
  *      this IO request, request's handling result is committed to ublk
  *      driver, meantime FETCH_REQ is piggyback, and FETCH_REQ has to be
  *      handled before completing io request.
+ *
+ * NEED_GET_DATA: only used for write requests to set io addr and copy data
+ *      When NEED_GET_DATA is set, ublksrv has to issue UBLK_IO_NEED_GET_DATA
+ *      command after ublk driver returns UBLK_IO_RES_NEED_GET_DATA.
+ *
+ *      It is only used if ublksrv set UBLK_F_NEED_GET_DATA flag
+ *      while starting a ublk device.
  */
 #define	UBLK_IO_FETCH_REQ		0x20
 #define	UBLK_IO_COMMIT_AND_FETCH_REQ	0x21
 
+#define UBLK_IO_NEED_GET_DATA	0x22
+
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
+#define UBLK_IO_RES_NEED_GET_DATA	1
 #define UBLK_IO_RES_ABORT		(-ENODEV)
 
 #define UBLKSRV_CMD_BUF_OFFSET	0
@@ -54,6 +64,15 @@
  */
 #define UBLK_F_URING_CMD_COMP_IN_TASK	(1UL << 1)
 
+/*
+ * User should issue io cmd again for write requests to
+ * set io buffer address and copy data from bio vectors
+ * to the userspace io buffer.
+ *
+ * In this mode, task_work is not used.
+ */
+#define UBLK_F_NEED_GET_DATA (1UL << 3)
+
 /* device state */
 #define UBLK_S_DEV_DEAD	0
 #define UBLK_S_DEV_LIVE	1
-- 
2.34.1
