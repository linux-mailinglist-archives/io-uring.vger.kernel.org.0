Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A673E69F54C
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 14:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjBVN0R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 08:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBVN0P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 08:26:15 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FE13B0E4;
        Wed, 22 Feb 2023 05:25:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VcH06.._1677072337;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VcH06.._1677072337)
          by smtp.aliyun-inc.com;
          Wed, 22 Feb 2023 21:25:38 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
Subject: [RFC v2 4/4] ublk_drv: add ebpf support
Date:   Wed, 22 Feb 2023 21:25:34 +0800
Message-Id: <20230222132534.114574-5-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
References: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currenly only one bpf_ublk_queue_sqe() ebpf is added, ublksrv target
can use this helper to write ebpf prog to support ublk kernel & usersapce
zero copy, please see ublksrv test codes for more info.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 drivers/block/ublk_drv.c       | 263 +++++++++++++++++++++++++++++++--
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/ublk_cmd.h  |  18 +++
 kernel/bpf/verifier.c          |   3 +-
 scripts/bpf_doc.py             |   4 +
 tools/include/uapi/linux/bpf.h |   9 ++
 6 files changed, 286 insertions(+), 12 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index b628e9eaefa6..d17ddb6fc27f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -105,6 +105,12 @@ struct ublk_uring_cmd_pdu {
  */
 #define UBLK_IO_FLAG_NEED_GET_DATA 0x08
 
+/*
+ * UBLK_IO_FLAG_BPF is set if IO command has be handled by ebpf prog instead
+ * of user space daemon.
+ */
+#define UBLK_IO_FLAG_BPF	0x10
+
 struct ublk_io {
 	/* userspace buffer address from io cmd */
 	__u64	addr;
@@ -114,6 +120,11 @@ struct ublk_io {
 	struct io_uring_cmd *cmd;
 };
 
+struct ublk_req_iter {
+	struct io_fixed_iter fixed_iter;
+	struct bio_vec *bvec;
+};
+
 struct ublk_queue {
 	int q_id;
 	int q_depth;
@@ -163,6 +174,9 @@ struct ublk_device {
 	unsigned int		nr_queues_ready;
 	atomic_t		nr_aborted_queues;
 
+	struct bpf_prog		*io_bpf_prog;
+	struct ublk_req_iter	*iter_table;
+
 	/*
 	 * Our ubq->daemon may be killed without any notification, so
 	 * monitor each queue's daemon periodically
@@ -189,10 +203,48 @@ static DEFINE_MUTEX(ublk_ctl_mutex);
 
 static struct miscdevice ublk_misc;
 
+struct ublk_io_bpf_ctx {
+	struct ublk_bpf_ctx ctx;
+	struct ublk_device *ub;
+};
+
+static inline struct ublk_req_iter *ublk_get_req_iter(struct ublk_device *ub,
+					int qid, int tag)
+{
+	return &(ub->iter_table[qid * ub->dev_info.queue_depth + tag]);
+}
+
+BPF_CALL_4(bpf_ublk_queue_sqe, struct ublk_io_bpf_ctx *, bpf_ctx,
+	   struct io_uring_sqe *, sqe, u32, sqe_len, u32, fd)
+{
+	struct ublk_req_iter *req_iter;
+	u16 q_id = bpf_ctx->ctx.q_id;
+	u16 tag = bpf_ctx->ctx.tag;
+
+	req_iter = ublk_get_req_iter(bpf_ctx->ub, q_id, tag);
+	io_uring_submit_sqe(fd, sqe, sqe_len, &(req_iter->fixed_iter));
+	return 0;
+}
+
+const struct bpf_func_proto ublk_bpf_queue_sqe_proto = {
+	.func = bpf_ublk_queue_sqe,
+	.gpl_only = false,
+	.ret_type = RET_INTEGER,
+	.arg1_type = ARG_ANYTHING,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+	.arg4_type = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 ublk_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
-	return bpf_base_func_proto(func_id);
+	switch (func_id) {
+	case BPF_FUNC_ublk_queue_sqe:
+		return &ublk_bpf_queue_sqe_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
 }
 
 static bool ublk_bpf_is_valid_access(int off, int size,
@@ -200,6 +252,23 @@ static bool ublk_bpf_is_valid_access(int off, int size,
 			const struct bpf_prog *prog,
 			struct bpf_insn_access_aux *info)
 {
+	if (off < 0 || off >= sizeof(struct ublk_bpf_ctx))
+		return false;
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	case offsetof(struct ublk_bpf_ctx, q_id):
+		return size == sizeof_field(struct ublk_bpf_ctx, q_id);
+	case offsetof(struct ublk_bpf_ctx, tag):
+		return size == sizeof_field(struct ublk_bpf_ctx, tag);
+	case offsetof(struct ublk_bpf_ctx, op):
+		return size == sizeof_field(struct ublk_bpf_ctx, op);
+	case offsetof(struct ublk_bpf_ctx, nr_sectors):
+		return size == sizeof_field(struct ublk_bpf_ctx, nr_sectors);
+	case offsetof(struct ublk_bpf_ctx, start_sector):
+		return size == sizeof_field(struct ublk_bpf_ctx, start_sector);
+	}
 	return false;
 }
 
@@ -324,7 +393,7 @@ static void ublk_put_device(struct ublk_device *ub)
 static inline struct ublk_queue *ublk_get_queue(struct ublk_device *dev,
 		int qid)
 {
-       return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
+	return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
 }
 
 static inline bool ublk_rq_has_data(const struct request *rq)
@@ -618,7 +687,6 @@ static void ublk_complete_rq(struct request *req)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	struct ublk_io *io = &ubq->ios[req->tag];
-	unsigned int unmapped_bytes;
 
 	/* failed read IO if nothing is read */
 	if (!io->res && req_op(req) == REQ_OP_READ)
@@ -641,15 +709,19 @@ static void ublk_complete_rq(struct request *req)
 	}
 
 	/* for READ request, writing data in iod->addr to rq buffers */
-	unmapped_bytes = ublk_unmap_io(ubq, req, io);
+	if (likely(!(io->flags & UBLK_IO_FLAG_BPF))) {
+		unsigned int unmapped_bytes;
 
-	/*
-	 * Extremely impossible since we got data filled in just before
-	 *
-	 * Re-read simply for this unlikely case.
-	 */
-	if (unlikely(unmapped_bytes < io->res))
-		io->res = unmapped_bytes;
+		unmapped_bytes = ublk_unmap_io(ubq, req, io);
+
+		/*
+		 * Extremely impossible since we got data filled in just before
+		 *
+		 * Re-read simply for this unlikely case.
+		 */
+		if (unlikely(unmapped_bytes < io->res))
+			io->res = unmapped_bytes;
+	}
 
 	if (blk_update_request(req, BLK_STS_OK, io->res))
 		blk_mq_requeue_request(req, true);
@@ -708,12 +780,92 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }
 
+static int ublk_init_uring_fixed_iter(struct ublk_queue *ubq, struct request *rq)
+{
+	struct ublk_device *ub = ubq->dev;
+	struct bio *bio = rq->bio;
+	struct bio_vec *bvec;
+	struct req_iterator rq_iter;
+	struct bio_vec tmp;
+	int nr_bvec = 0;
+	struct ublk_req_iter *req_iter;
+	unsigned int rw, offset;
+
+	req_iter = ublk_get_req_iter(ub, ubq->q_id, rq->tag);
+	if (req_op(rq) == REQ_OP_READ)
+		rw = ITER_DEST;
+	else
+		rw = ITER_SOURCE;
+
+	rq_for_each_bvec(tmp, rq, rq_iter)
+		nr_bvec++;
+	if (rq->bio != rq->biotail) {
+		bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec), GFP_NOIO);
+		if (!bvec)
+			return -EIO;
+		req_iter->bvec = bvec;
+
+		/*
+		 * The bios of the request may be started from the middle of
+		 * the 'bvec' because of bio splitting, so we can't directly
+		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_bvec
+		 * API will take care of all details for us.
+		 */
+		rq_for_each_bvec(tmp, rq, rq_iter) {
+			*bvec = tmp;
+			bvec++;
+		}
+		bvec = req_iter->bvec;
+		offset = 0;
+	} else {
+		/*
+		 * Same here, this bio may be started from the middle of the
+		 * 'bvec' because of bio splitting, so offset from the bvec
+		 * must be passed to iov iterator
+		 */
+		offset = bio->bi_iter.bi_bvec_done;
+		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+		req_iter->bvec = NULL;
+	}
+
+	iov_iter_bvec(&(req_iter->fixed_iter.iter), rw, bvec, nr_bvec, blk_rq_bytes(rq));
+	req_iter->fixed_iter.iter.iov_offset = offset;
+	return 0;
+}
+
+static int ublk_run_bpf_prog(struct ublk_queue *ubq, struct request *rq)
+{
+	int ret;
+	struct ublk_device *ub = ubq->dev;
+	struct ublk_io_bpf_ctx bpf_ctx;
+	u32 bpf_act;
+
+	if (!ub->io_bpf_prog)
+		return 0;
+
+	ret = ublk_init_uring_fixed_iter(ubq, rq);
+	if (ret < 0)
+		return UBLK_BPF_IO_ABORTED;
+
+	bpf_ctx.ub = ub;
+	bpf_ctx.ctx.q_id = ubq->q_id;
+	bpf_ctx.ctx.tag = rq->tag;
+	bpf_ctx.ctx.op = req_op(rq);
+	bpf_ctx.ctx.nr_sectors = blk_rq_sectors(rq);
+	bpf_ctx.ctx.start_sector = blk_rq_pos(rq);
+	bpf_act = bpf_prog_run_pin_on_cpu(ub->io_bpf_prog, &bpf_ctx);
+	return bpf_act;
+}
+
 static inline void __ublk_rq_task_work(struct request *req)
 {
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	struct ublk_device *ub = ubq->dev;
 	int tag = req->tag;
 	struct ublk_io *io = &ubq->ios[tag];
 	unsigned int mapped_bytes;
+	u32 bpf_act;
+	bool io_done = false;
 
 	pr_devel("%s: complete: op %d, qid %d tag %d io_flags %x addr %llx\n",
 			__func__, io->cmd->cmd_op, ubq->q_id, req->tag, io->flags,
@@ -762,6 +914,10 @@ static inline void __ublk_rq_task_work(struct request *req)
 				ublk_get_iod(ubq, req->tag)->addr);
 	}
 
+	if (unlikely(ub->io_bpf_prog))
+		goto call_ebpf;
+
+normal_path:
 	mapped_bytes = ublk_map_io(ubq, req, io);
 
 	/* partially mapped, update io descriptor */
@@ -784,7 +940,21 @@ static inline void __ublk_rq_task_work(struct request *req)
 			mapped_bytes >> 9;
 	}
 
+	if (!io_done)
+		ubq_complete_io_cmd(io, UBLK_IO_RES_OK);
+	return;
+
+call_ebpf:
 	ubq_complete_io_cmd(io, UBLK_IO_RES_OK);
+	bpf_act = ublk_run_bpf_prog(ubq, req);
+	switch (bpf_act) {
+	case UBLK_BPF_IO_ABORTED:
+	case UBLK_BPF_IO_DROP:
+	case UBLK_BPF_IO_PASS:
+		io_done = true;
+		goto normal_path;
+	}
+	io->flags |= UBLK_IO_FLAG_BPF;
 }
 
 static inline void ublk_forward_io_cmds(struct ublk_queue *ubq)
@@ -1231,6 +1401,10 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
 			ub_cmd->result);
 
+	/* To workaround task_work_add is not exported. */
+	if (unlikely(ub->io_bpf_prog && !(cmd->flags & IORING_URING_CMD_UNLOCK)))
+		goto out;
+
 	if (!(issue_flags & IO_URING_F_SQE128))
 		goto out;
 
@@ -1295,6 +1469,14 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		io->flags |= UBLK_IO_FLAG_ACTIVE;
 		io->cmd = cmd;
 		ublk_commit_completion(ub, ub_cmd);
+		if (io->flags & UBLK_IO_FLAG_BPF) {
+			struct ublk_req_iter *req_iter;
+
+			req_iter = ublk_get_req_iter(ub, ubq->q_id, tag);
+			io->flags &= ~UBLK_IO_FLAG_BPF;
+			kfree(req_iter->bvec);
+			req_iter->bvec = NULL;
+		}
 		break;
 	case UBLK_IO_NEED_GET_DATA:
 		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
@@ -2009,6 +2191,59 @@ static int ublk_ctrl_end_recovery(struct io_uring_cmd *cmd)
 	return ret;
 }
 
+static int ublk_ctrl_reg_bpf_prog(struct io_uring_cmd *cmd)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublk_device *ub;
+	struct bpf_prog *prog;
+	int ret = 0, nr_queues, depth;
+
+	ub = ublk_get_device_from_id(header->dev_id);
+	if (!ub)
+		return -EINVAL;
+
+	mutex_lock(&ub->mutex);
+	nr_queues = ub->dev_info.nr_hw_queues;
+	depth = ub->dev_info.queue_depth;
+	ub->iter_table = kzalloc(sizeof(struct ublk_req_iter) * depth * nr_queues,
+				 GFP_KERNEL);
+	if (!ub->iter_table) {
+		ret =  -ENOMEM;
+		goto out_unlock;
+	}
+
+	prog = bpf_prog_get_type(header->data[0], BPF_PROG_TYPE_UBLK);
+	if (IS_ERR(prog)) {
+		kfree(ub->iter_table);
+		ret = PTR_ERR(prog);
+		goto out_unlock;
+	}
+	ub->io_bpf_prog = prog;
+
+out_unlock:
+	mutex_unlock(&ub->mutex);
+	ublk_put_device(ub);
+	return ret;
+}
+
+static int ublk_ctrl_unreg_bpf_prog(struct io_uring_cmd *cmd)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublk_device *ub;
+
+	ub = ublk_get_device_from_id(header->dev_id);
+	if (!ub)
+		return -EINVAL;
+
+	mutex_lock(&ub->mutex);
+	bpf_prog_put(ub->io_bpf_prog);
+	ub->io_bpf_prog = NULL;
+	kfree(ub->iter_table);
+	ub->iter_table = NULL;
+	mutex_unlock(&ub->mutex);
+	ublk_put_device(ub);
+	return 0;
+}
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
@@ -2059,6 +2294,12 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	case UBLK_CMD_END_USER_RECOVERY:
 		ret = ublk_ctrl_end_recovery(cmd);
 		break;
+	case UBLK_CMD_REG_BPF_PROG:
+		ret = ublk_ctrl_reg_bpf_prog(cmd);
+		break;
+	case UBLK_CMD_UNREG_BPF_PROG:
+		ret = ublk_ctrl_unreg_bpf_prog(cmd);
+		break;
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 515b7b995b3a..578d65e9f30e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5699,6 +5699,7 @@ union bpf_attr {
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(cgrp_storage_get, 210, ##ctx)		\
 	FN(cgrp_storage_delete, 211, ##ctx)		\
+	FN(ublk_queue_sqe, 212, ##ctx)			\
 	/* */
 
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index 8f88e3a29998..fbfe5145221e 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -17,6 +17,8 @@
 #define	UBLK_CMD_STOP_DEV	0x07
 #define	UBLK_CMD_SET_PARAMS	0x08
 #define	UBLK_CMD_GET_PARAMS	0x09
+#define UBLK_CMD_REG_BPF_PROG		0x0a
+#define UBLK_CMD_UNREG_BPF_PROG		0x0b
 #define	UBLK_CMD_START_USER_RECOVERY	0x10
 #define	UBLK_CMD_END_USER_RECOVERY	0x11
 /*
@@ -230,4 +232,20 @@ struct ublk_params {
 	struct ublk_param_discard	discard;
 };
 
+struct ublk_bpf_ctx {
+	__u32   t_val;
+	__u16   q_id;
+	__u16   tag;
+	__u8    op;
+	__u32   nr_sectors;
+	__u64   start_sector;
+};
+
+enum {
+	UBLK_BPF_IO_ABORTED = 0,
+	UBLK_BPF_IO_DROP,
+	UBLK_BPF_IO_PASS,
+	UBLK_BPF_IO_REDIRECT,
+};
+
 #endif
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1e5bc89aea36..b1645a3d93a2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24,6 +24,7 @@
 #include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
 #include <linux/poison.h>
+#include <linux/ublk_cmd.h>
 
 #include "disasm.h"
 
@@ -12236,7 +12237,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 		break;
 
 	case BPF_PROG_TYPE_UBLK:
-		range = tnum_const(0);
+		range = tnum_range(UBLK_BPF_IO_ABORTED, UBLK_BPF_IO_REDIRECT);
 		break;
 
 	case BPF_PROG_TYPE_EXT:
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index e8d90829f23e..f8672294e145 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -700,6 +700,8 @@ class PrinterHelpers(Printer):
             'struct bpf_dynptr',
             'struct iphdr',
             'struct ipv6hdr',
+            'struct ublk_io_bpf_ctx',
+            'struct io_uring_sqe',
     ]
     known_types = {
             '...',
@@ -755,6 +757,8 @@ class PrinterHelpers(Printer):
             'const struct bpf_dynptr',
             'struct iphdr',
             'struct ipv6hdr',
+            'struct ublk_io_bpf_ctx',
+            'struct io_uring_sqe',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 515b7b995b3a..e3a81e576ec1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5485,6 +5485,14 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf_local_storage cannot be found.
+ *
+ *
+ * u64 bpf_ublk_queue_sqe(struct ublk_io_bpf_ctx *ctx, struct io_uring_sqe *sqe, u32 offset, u32 len)
+ *	Description
+ *		Submit ublk io requests.
+ *	Return
+ *		0 on success.
+ *
  */
 #define ___BPF_FUNC_MAPPER(FN, ctx...)			\
 	FN(unspec, 0, ##ctx)				\
@@ -5699,6 +5707,7 @@ union bpf_attr {
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(cgrp_storage_get, 210, ##ctx)		\
 	FN(cgrp_storage_delete, 211, ##ctx)		\
+	FN(ublk_queue_sqe, 212, ##ctx)			\
 	/* */
 
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
-- 
2.31.1

