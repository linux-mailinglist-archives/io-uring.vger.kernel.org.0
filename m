Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39FB6972C4
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 01:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjBOAlc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 19:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbjBOAlb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 19:41:31 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D854E2D14D;
        Tue, 14 Feb 2023 16:41:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VbhRiW3_1676421685;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VbhRiW3_1676421685)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 08:41:25 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
Subject: [RFC 3/3] ublk_drv: add ebpf support
Date:   Wed, 15 Feb 2023 08:41:22 +0800
Message-Id: <20230215004122.28917-4-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/block/ublk_drv.c       | 207 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/ublk_cmd.h  |  11 ++
 scripts/bpf_doc.py             |   4 +
 tools/include/uapi/linux/bpf.h |   8 ++
 5 files changed, 229 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index b628e9eaefa6..44c289b72864 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -61,6 +61,7 @@
 struct ublk_rq_data {
 	struct llist_node node;
 	struct callback_head work;
+	struct io_mapped_kbuf *kbuf;
 };
 
 struct ublk_uring_cmd_pdu {
@@ -163,6 +164,9 @@ struct ublk_device {
 	unsigned int		nr_queues_ready;
 	atomic_t		nr_aborted_queues;
 
+	struct bpf_prog		*io_prep_prog;
+	struct bpf_prog		*io_submit_prog;
+
 	/*
 	 * Our ubq->daemon may be killed without any notification, so
 	 * monitor each queue's daemon periodically
@@ -189,10 +193,46 @@ static DEFINE_MUTEX(ublk_ctl_mutex);
 
 static struct miscdevice ublk_misc;
 
+struct ublk_io_bpf_ctx {
+	struct ublk_bpf_ctx ctx;
+	struct ublk_device *ub;
+	struct callback_head work;
+};
+
+BPF_CALL_4(bpf_ublk_queue_sqe, struct ublk_io_bpf_ctx *, bpf_ctx,
+	   struct io_uring_sqe *, sqe, u32, sqe_len, u32, fd)
+{
+	struct request *rq;
+	struct ublk_rq_data *data;
+	struct io_mapped_kbuf *kbuf;
+	u16 q_id = bpf_ctx->ctx.q_id;
+	u16 tag = bpf_ctx->ctx.tag;
+
+	rq = blk_mq_tag_to_rq(bpf_ctx->ub->tag_set.tags[q_id], tag);
+	data = blk_mq_rq_to_pdu(rq);
+	kbuf = data->kbuf;
+	io_uring_submit_sqe(fd, sqe, sqe_len, kbuf);
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
@@ -200,6 +240,23 @@ static bool ublk_bpf_is_valid_access(int off, int size,
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
 
@@ -324,7 +381,7 @@ static void ublk_put_device(struct ublk_device *ub)
 static inline struct ublk_queue *ublk_get_queue(struct ublk_device *dev,
 		int qid)
 {
-       return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
+	return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
 }
 
 static inline bool ublk_rq_has_data(const struct request *rq)
@@ -492,12 +549,16 @@ static inline int ublk_copy_user_pages(struct ublk_map_data *data,
 static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		struct ublk_io *io)
 {
+	struct ublk_device *ub = ubq->dev;
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 	/*
 	 * no zero copy, we delay copy WRITE request data into ublksrv
 	 * context and the big benefit is that pinning pages in current
 	 * context is pretty fast, see ublk_pin_user_pages
 	 */
+	if ((req_op(req) == REQ_OP_WRITE) && ub->io_prep_prog)
+		return rq_bytes;
+
 	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
 		return rq_bytes;
 
@@ -860,6 +921,89 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 	}
 }
 
+static void ublk_bpf_io_submit_fn(struct callback_head *work)
+{
+	struct ublk_io_bpf_ctx *bpf_ctx = container_of(work,
+			struct ublk_io_bpf_ctx, work);
+
+	if (bpf_ctx->ub->io_submit_prog)
+		bpf_prog_run_pin_on_cpu(bpf_ctx->ub->io_submit_prog, bpf_ctx);
+	kfree(bpf_ctx);
+}
+
+static int ublk_init_uring_kbuf(struct request *rq)
+{
+	struct bio_vec *bvec;
+	struct req_iterator rq_iter;
+	struct bio_vec tmp;
+	int nr_bvec = 0;
+	struct io_mapped_kbuf *kbuf;
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+
+	/* Drop previous allocation */
+	if (data->kbuf) {
+		kfree(data->kbuf->bvec);
+		kfree(data->kbuf);
+		data->kbuf = NULL;
+	}
+
+	kbuf = kmalloc(sizeof(struct io_mapped_kbuf), GFP_NOIO);
+	if (!kbuf)
+		return -EIO;
+
+	rq_for_each_bvec(tmp, rq, rq_iter)
+		nr_bvec++;
+
+	bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec), GFP_NOIO);
+	if (!bvec) {
+		kfree(kbuf);
+		return -EIO;
+	}
+	kbuf->bvec = bvec;
+	rq_for_each_bvec(tmp, rq, rq_iter) {
+		*bvec = tmp;
+		bvec++;
+	}
+
+	kbuf->count = blk_rq_bytes(rq);
+	kbuf->nr_bvecs = nr_bvec;
+	data->kbuf = kbuf;
+	return 0;
+}
+
+static int ublk_run_bpf_prog(struct ublk_queue *ubq, struct request *rq)
+{
+	int err;
+	struct ublk_device *ub = ubq->dev;
+	struct bpf_prog *prog = ub->io_prep_prog;
+	struct ublk_io_bpf_ctx *bpf_ctx;
+
+	if (!prog)
+		return 0;
+
+	bpf_ctx = kmalloc(sizeof(struct ublk_io_bpf_ctx), GFP_NOIO);
+	if (!bpf_ctx)
+		return -EIO;
+
+	err = ublk_init_uring_kbuf(rq);
+	if (err < 0) {
+		kfree(bpf_ctx);
+		return -EIO;
+	}
+	bpf_ctx->ub = ub;
+	bpf_ctx->ctx.q_id = ubq->q_id;
+	bpf_ctx->ctx.tag = rq->tag;
+	bpf_ctx->ctx.op = req_op(rq);
+	bpf_ctx->ctx.nr_sectors = blk_rq_sectors(rq);
+	bpf_ctx->ctx.start_sector = blk_rq_pos(rq);
+	bpf_prog_run_pin_on_cpu(prog, bpf_ctx);
+
+	init_task_work(&bpf_ctx->work, ublk_bpf_io_submit_fn);
+	if (task_work_add(ubq->ubq_daemon, &bpf_ctx->work, TWA_SIGNAL_NO_IPI))
+		kfree(bpf_ctx);
+	return 0;
+}
+
 static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
@@ -872,6 +1016,9 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (unlikely(res != BLK_STS_OK))
 		return BLK_STS_IOERR;
 
+	/* Currently just for test. */
+	ublk_run_bpf_prog(ubq, rq);
+
 	/* With recovery feature enabled, force_abort is set in
 	 * ublk_stop_dev() before calling del_gendisk(). We have to
 	 * abort all requeued and new rqs here to let del_gendisk()
@@ -2009,6 +2156,56 @@ static int ublk_ctrl_end_recovery(struct io_uring_cmd *cmd)
 	return ret;
 }
 
+static int ublk_ctrl_reg_bpf_prog(struct io_uring_cmd *cmd)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublk_device *ub;
+	struct bpf_prog *prog;
+	int ret = 0;
+
+	ub = ublk_get_device_from_id(header->dev_id);
+	if (!ub)
+		return -EINVAL;
+
+	mutex_lock(&ub->mutex);
+	prog = bpf_prog_get_type(header->data[0], BPF_PROG_TYPE_UBLK);
+	if (IS_ERR(prog)) {
+		ret = PTR_ERR(prog);
+		goto out_unlock;
+	}
+	ub->io_prep_prog = prog;
+
+	prog = bpf_prog_get_type(header->data[1], BPF_PROG_TYPE_UBLK);
+	if (IS_ERR(prog)) {
+		ret = PTR_ERR(prog);
+		goto out_unlock;
+	}
+	ub->io_submit_prog = prog;
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
+	bpf_prog_put(ub->io_prep_prog);
+	bpf_prog_put(ub->io_submit_prog);
+	ub->io_prep_prog = NULL;
+	ub->io_submit_prog = NULL;
+	mutex_unlock(&ub->mutex);
+	ublk_put_device(ub);
+	return 0;
+}
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
@@ -2059,6 +2256,12 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
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
index 8f88e3a29998..a43b1864de51 100644
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
@@ -230,4 +232,13 @@ struct ublk_params {
 	struct ublk_param_discard	discard;
 };
 
+struct ublk_bpf_ctx {
+	__u32	t_val;
+	__u16	q_id;
+	__u16	tag;
+	__u8	op;
+	__u32	nr_sectors;
+	__u64	start_sector;
+};
+
 #endif
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
index 515b7b995b3a..530094246e2a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5485,6 +5485,13 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf_local_storage cannot be found.
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
@@ -5699,6 +5706,7 @@ union bpf_attr {
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(cgrp_storage_get, 210, ##ctx)		\
 	FN(cgrp_storage_delete, 211, ##ctx)		\
+	FN(ublk_queue_sqe, 212, ##ctx)			\
 	/* */
 
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
-- 
2.31.1

