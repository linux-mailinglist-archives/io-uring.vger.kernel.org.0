Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC4456D2EF
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 04:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiGKCUo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jul 2022 22:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGKCUo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jul 2022 22:20:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8862A12631
        for <io-uring@vger.kernel.org>; Sun, 10 Jul 2022 19:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657506039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dJ75ekBCMCxtk6fMn0YE6QszEL8gXPKMIMxOZ6p8i7c=;
        b=KX4iYUwu7Q1pI33qeAh0jdOAkdXj+kmkQv3oU98z5j03FJ3fIIw9w6Lqz1EQV6GWDoxUMw
        CT3ucYB8Ippy8kROnomzkpApLGwh6b/lNmhiwx38OMTLjuQZtodEoMTp4XdmXft7QZrVG5
        ymaM9+PBXB9kwrE6Uyqm7elCc8/RcBQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-p_9m_OanOO2SBAGUZnvlGA-1; Sun, 10 Jul 2022 22:20:38 -0400
X-MC-Unique: p_9m_OanOO2SBAGUZnvlGA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D84FE1C13940;
        Mon, 11 Jul 2022 02:20:37 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 296CE492C3B;
        Mon, 11 Jul 2022 02:20:35 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 1/2] ublk: add io_uring based userspace block driver
Date:   Mon, 11 Jul 2022 10:20:23 +0800
Message-Id: <20220711022024.217163-2-ming.lei@redhat.com>
In-Reply-To: <20220711022024.217163-1-ming.lei@redhat.com>
References: <20220711022024.217163-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is the driver part of userspace block driver(ublk driver), the other
part is userspace daemon part(ublksrv)[1].

The two parts communicate by io_uring's IORING_OP_URING_CMD with one
shared cmd buffer for storing io command, and the buffer is read only for
ublksrv, each io command is indexed by io request tag directly, and
is written by ublk driver.

For example, when one READ io request is submitted to ublk block driver, ublk
driver stores the io command into cmd buffer first, then completes one
IORING_OP_URING_CMD for notifying ublksrv, and the URING_CMD is issued to
ublk driver beforehand by ublksrv for getting notification of any new io request,
and each URING_CMD is associated with one io request by tag.

After ublksrv gets the io command, it translates and handles the ublk io
request, such as, for the ublk-loop target, ublksrv translates the request
into same request on another file or disk, like the kernel loop block
driver. In ublksrv's implementation, the io is still handled by io_uring,
and share same ring with IORING_OP_URING_CMD command. When the target io
request is done, the same IORING_OP_URING_CMD is issued to ublk driver for
both committing io request result and getting future notification of new
io request.

Another thing done by ublk driver is to copy data between kernel io
request and ublksrv's io buffer:

1) before ubsrv handles WRITE request, copy the request's data into
ublksrv's userspace io buffer, so that ublksrv can handle the write
request

2) after ubsrv handles READ request, copy ublksrv's userspace io buffer
into this READ request, then ublk driver can complete the READ request

Zero copy may be switched if mm is ready to support it.

ublk driver doesn't handle any logic of the specific user space driver,
so it is small/simple enough.

[1] ublksrv

https://github.com/ming1/ubdsrv

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/Kconfig         |    6 +
 drivers/block/Makefile        |    2 +
 drivers/block/ublk_drv.c      | 1632 +++++++++++++++++++++++++++++++++
 include/uapi/linux/ublk_cmd.h |  156 ++++
 4 files changed, 1796 insertions(+)
 create mode 100644 drivers/block/ublk_drv.c
 create mode 100644 include/uapi/linux/ublk_cmd.h

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index fdb81f2794cd..d218089cdbec 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -408,6 +408,12 @@ config BLK_DEV_RBD
 
 	  If unsure, say N.
 
+config BLK_DEV_UBLK
+	bool "Userspace block driver"
+	select IO_URING
+	help
+          io uring based userspace block driver.
+
 source "drivers/block/rnbd/Kconfig"
 
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 934a9c7c3a7c..be631352567e 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -39,4 +39,6 @@ obj-$(CONFIG_BLK_DEV_RNBD)	+= rnbd/
 
 obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
 
+obj-$(CONFIG_BLK_DEV_UBLK)			+= ublk_drv.o
+
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
new file mode 100644
index 000000000000..0076418e6fad
--- /dev/null
+++ b/drivers/block/ublk_drv.c
@@ -0,0 +1,1632 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Userspace block device - block device which IO is handled from userspace
+ *
+ * Take full use of io_uring passthrough command for communicating with
+ * ublk userspace daemon(ublksrvd) for handling basic IO request.
+ *
+ * Copyright 2022 Ming Lei <ming.lei@redhat.com>
+ *
+ * (part of code stolen from loop.c)
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/stat.h>
+#include <linux/errno.h>
+#include <linux/major.h>
+#include <linux/wait.h>
+#include <linux/blkdev.h>
+#include <linux/init.h>
+#include <linux/swap.h>
+#include <linux/slab.h>
+#include <linux/compat.h>
+#include <linux/mutex.h>
+#include <linux/writeback.h>
+#include <linux/completion.h>
+#include <linux/highmem.h>
+#include <linux/sysfs.h>
+#include <linux/miscdevice.h>
+#include <linux/falloc.h>
+#include <linux/uio.h>
+#include <linux/ioprio.h>
+#include <linux/sched/mm.h>
+#include <linux/uaccess.h>
+#include <linux/cdev.h>
+#include <linux/io_uring.h>
+#include <linux/blk-mq.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <linux/task_work.h>
+#include <uapi/linux/ublk_cmd.h>
+
+#define UBLK_MINORS		(1U << MINORBITS)
+
+struct ublk_rq_data {
+	struct callback_head work;
+};
+
+/*
+ * io command is active: sqe cmd is received, and its cqe isn't done
+ *
+ * If the flag is set, the io command is owned by ublk driver, and waited
+ * for incoming blk-mq request from the ublk block device.
+ *
+ * If the flag is cleared, the io command will be completed, and owned by
+ * ublk server.
+ */
+#define UBLK_IO_FLAG_ACTIVE	0x01
+
+/*
+ * IO command is completed via cqe, and it is being handled by ublksrv, and
+ * not committed yet
+ *
+ * Basically exclusively with UBLK_IO_FLAG_ACTIVE, so can be served for
+ * cross verification
+ */
+#define UBLK_IO_FLAG_OWNED_BY_SRV 0x02
+
+/*
+ * IO command is aborted, so this flag is set in case of
+ * !UBLK_IO_FLAG_ACTIVE.
+ *
+ * After this flag is observed, any pending or new incoming request
+ * associated with this io command will be failed immediately
+ */
+#define UBLK_IO_FLAG_ABORTED 0x04
+
+struct ublk_io {
+	/* userspace buffer address from io cmd */
+	__u64	addr;
+	unsigned int flags;
+	int res;
+
+	struct io_uring_cmd *cmd;
+};
+
+struct ublk_queue {
+	int q_id;
+	int q_depth;
+
+	struct task_struct	*ubq_daemon;
+	char *io_cmd_buf;
+
+	unsigned long io_addr;	/* mapped vm address */
+	unsigned int max_io_sz;
+	bool abort_work_pending;
+	unsigned short nr_io_ready;	/* how many ios setup */
+	struct ublk_device *dev;
+	spinlock_t	abort_lock;
+	struct callback_head abort_work;
+	struct ublk_io ios[0];
+};
+
+#define UBLK_DAEMON_MONITOR_PERIOD	(5 * HZ)
+
+struct ublk_device {
+	struct gendisk		*ub_disk;
+	struct request_queue	*ub_queue;
+
+	char	*__queues;
+
+	unsigned short  queue_size;
+	unsigned short  bs_shift;
+	struct ublksrv_ctrl_dev_info	dev_info;
+
+	struct blk_mq_tag_set	tag_set;
+
+	struct cdev		cdev;
+	struct device		cdev_dev;
+
+	atomic_t		ch_open_cnt;
+	int			ub_number;
+
+	struct mutex		mutex;
+
+	struct mm_struct	*mm;
+
+	struct completion	completion;
+	unsigned int		nr_queues_ready;
+	atomic_t		nr_aborted_queues;
+
+	/*
+	 * Our ubq->daemon may be killed without any notification, so
+	 * monitor each queue's daemon periodically
+	 */
+	struct delayed_work	monitor_work;
+	struct work_struct	stop_work;
+};
+
+static dev_t ublk_chr_devt;
+static struct class *ublk_chr_class;
+
+static DEFINE_IDR(ublk_index_idr);
+static DEFINE_SPINLOCK(ublk_idr_lock);
+static wait_queue_head_t ublk_idr_wq;	/* wait until one idr is freed */
+
+static DEFINE_MUTEX(ublk_ctl_mutex);
+
+static struct miscdevice ublk_misc;
+
+static struct ublk_device *ublk_get_device(struct ublk_device *ub)
+{
+	if (kobject_get_unless_zero(&ub->cdev_dev.kobj))
+		return ub;
+	return NULL;
+}
+
+static void ublk_put_device(struct ublk_device *ub)
+{
+	put_device(&ub->cdev_dev);
+}
+
+static inline struct ublk_queue *ublk_get_queue(struct ublk_device *dev,
+		int qid)
+{
+       return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
+}
+
+static inline bool ublk_rq_has_data(const struct request *rq)
+{
+	return rq->bio && bio_has_data(rq->bio);
+}
+
+static inline struct ublksrv_io_desc *ublk_get_iod(struct ublk_queue *ubq,
+		int tag)
+{
+	return (struct ublksrv_io_desc *)
+		&(ubq->io_cmd_buf[tag * sizeof(struct ublksrv_io_desc)]);
+}
+
+static inline char *ublk_queue_cmd_buf(struct ublk_device *ub, int q_id)
+{
+	return ublk_get_queue(ub, q_id)->io_cmd_buf;
+}
+
+static inline int ublk_queue_cmd_buf_size(struct ublk_device *ub, int q_id)
+{
+	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
+
+	return round_up(ubq->q_depth * sizeof(struct ublksrv_io_desc),
+			PAGE_SIZE);
+}
+
+static int ublk_open(struct block_device *bdev, fmode_t mode)
+{
+	return 0;
+}
+
+static void ublk_release(struct gendisk *disk, fmode_t mode)
+{
+}
+
+static const struct block_device_operations ub_fops = {
+	.owner =	THIS_MODULE,
+	.open =		ublk_open,
+	.release =	ublk_release,
+};
+
+#define UBLK_MAX_PIN_PAGES	32
+
+struct ublk_map_data {
+	const struct ublk_queue *ubq;
+	const struct request *rq;
+	const struct ublk_io *io;
+	unsigned max_bytes;
+};
+
+struct ublk_io_iter {
+	struct page *pages[UBLK_MAX_PIN_PAGES];
+	unsigned pg_off;	/* offset in the 1st page in pages */
+	int nr_pages;		/* how many page pointers in pages */
+	struct bio *bio;
+	struct bvec_iter iter;
+};
+
+static inline unsigned ublk_copy_io_pages(struct ublk_io_iter *data,
+		unsigned max_bytes, bool to_vm)
+{
+	const unsigned total = min_t(unsigned, max_bytes,
+			PAGE_SIZE - data->pg_off +
+			((data->nr_pages - 1) << PAGE_SHIFT));
+	unsigned done = 0;
+	unsigned pg_idx = 0;
+
+	while (done < total) {
+		struct bio_vec bv = bio_iter_iovec(data->bio, data->iter);
+		const unsigned int bytes = min3(bv.bv_len, total - done,
+				(unsigned)(PAGE_SIZE - data->pg_off));
+		void *bv_buf = bvec_kmap_local(&bv);
+		void *pg_buf = kmap_local_page(data->pages[pg_idx]);
+
+		if (to_vm)
+			memcpy(pg_buf + data->pg_off, bv_buf, bytes);
+		else
+			memcpy(bv_buf, pg_buf + data->pg_off, bytes);
+
+		kunmap_local(pg_buf);
+		kunmap_local(bv_buf);
+
+		/* advance page array */
+		data->pg_off += bytes;
+		if (data->pg_off == PAGE_SIZE) {
+			pg_idx += 1;
+			data->pg_off = 0;
+		}
+
+		done += bytes;
+
+		/* advance bio */
+		bio_advance_iter_single(data->bio, &data->iter, bytes);
+		if (!data->iter.bi_size) {
+			data->bio = data->bio->bi_next;
+			if (data->bio == NULL)
+				break;
+			data->iter = data->bio->bi_iter;
+		}
+	}
+
+	return done;
+}
+
+static inline int ublk_copy_user_pages(struct ublk_map_data *data,
+		bool to_vm)
+{
+	const unsigned int gup_flags = to_vm ? FOLL_WRITE : 0;
+	const unsigned long start_vm = data->io->addr;
+	unsigned int done = 0;
+	struct ublk_io_iter iter = {
+		.pg_off	= start_vm & (PAGE_SIZE - 1),
+		.bio	= data->rq->bio,
+		.iter	= data->rq->bio->bi_iter,
+	};
+	const unsigned int nr_pages = round_up(data->max_bytes +
+			(start_vm & (PAGE_SIZE - 1)), PAGE_SIZE) >> PAGE_SHIFT;
+
+	while (done < nr_pages) {
+		const unsigned to_pin = min_t(unsigned, UBLK_MAX_PIN_PAGES,
+				nr_pages - done);
+		unsigned i, len;
+
+		iter.nr_pages = get_user_pages_fast(start_vm +
+				(done << PAGE_SHIFT), to_pin, gup_flags,
+				iter.pages);
+		if (iter.nr_pages <= 0)
+			return done == 0 ? iter.nr_pages : done;
+		len = ublk_copy_io_pages(&iter, data->max_bytes, to_vm);
+		for (i = 0; i < iter.nr_pages; i++) {
+			if (to_vm)
+				set_page_dirty(iter.pages[i]);
+			put_page(iter.pages[i]);
+		}
+		data->max_bytes -= len;
+		done += iter.nr_pages;
+	}
+
+	return done;
+}
+
+static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
+		struct ublk_io *io)
+{
+	const unsigned int rq_bytes = blk_rq_bytes(req);
+	/*
+	 * no zero copy, we delay copy WRITE request data into ublksrv
+	 * context via task_work_add and the big benefit is that pinning
+	 * pages in current context is pretty fast, see ublk_pin_user_pages
+	 */
+	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
+		return rq_bytes;
+
+	if (ublk_rq_has_data(req)) {
+		struct ublk_map_data data = {
+			.ubq	=	ubq,
+			.rq	=	req,
+			.io	=	io,
+			.max_bytes =	rq_bytes,
+		};
+
+		ublk_copy_user_pages(&data, true);
+
+		return rq_bytes - data.max_bytes;
+	}
+	return rq_bytes;
+}
+
+static int ublk_unmap_io(const struct ublk_queue *ubq,
+		const struct request *req,
+		struct ublk_io *io)
+{
+	const unsigned int rq_bytes = blk_rq_bytes(req);
+
+	if (req_op(req) == REQ_OP_READ && ublk_rq_has_data(req)) {
+		struct ublk_map_data data = {
+			.ubq	=	ubq,
+			.rq	=	req,
+			.io	=	io,
+			.max_bytes =	io->res,
+		};
+
+		WARN_ON_ONCE(io->res > rq_bytes);
+
+		ublk_copy_user_pages(&data, false);
+
+		return io->res - data.max_bytes;
+	}
+	return rq_bytes;
+}
+
+static inline unsigned int ublk_req_build_flags(struct request *req)
+{
+	unsigned flags = 0;
+
+	if (req->cmd_flags & REQ_FAILFAST_DEV)
+		flags |= UBLK_IO_F_FAILFAST_DEV;
+
+	if (req->cmd_flags & REQ_FAILFAST_TRANSPORT)
+		flags |= UBLK_IO_F_FAILFAST_TRANSPORT;
+
+	if (req->cmd_flags & REQ_FAILFAST_DRIVER)
+		flags |= UBLK_IO_F_FAILFAST_DRIVER;
+
+	if (req->cmd_flags & REQ_META)
+		flags |= UBLK_IO_F_META;
+
+	if (req->cmd_flags & REQ_INTEGRITY)
+		flags |= UBLK_IO_F_INTEGRITY;
+
+	if (req->cmd_flags & REQ_FUA)
+		flags |= UBLK_IO_F_FUA;
+
+	if (req->cmd_flags & REQ_PREFLUSH)
+		flags |= UBLK_IO_F_PREFLUSH;
+
+	if (req->cmd_flags & REQ_NOUNMAP)
+		flags |= UBLK_IO_F_NOUNMAP;
+
+	if (req->cmd_flags & REQ_SWAP)
+		flags |= UBLK_IO_F_SWAP;
+
+	return flags;
+}
+
+static int ublk_setup_iod(struct ublk_queue *ubq, struct request *req)
+{
+	struct ublksrv_io_desc *iod = ublk_get_iod(ubq, req->tag);
+	struct ublk_io *io = &ubq->ios[req->tag];
+	u32 ublk_op;
+
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+		ublk_op = UBLK_IO_OP_READ;
+		break;
+	case REQ_OP_WRITE:
+		ublk_op = UBLK_IO_OP_WRITE;
+		break;
+	case REQ_OP_FLUSH:
+		ublk_op = UBLK_IO_OP_FLUSH;
+		break;
+	case REQ_OP_DISCARD:
+		ublk_op = UBLK_IO_OP_DISCARD;
+		break;
+	case REQ_OP_WRITE_ZEROES:
+		ublk_op = UBLK_IO_OP_WRITE_ZEROES;
+		break;
+	default:
+		return BLK_STS_IOERR;
+	}
+
+	/* need to translate since kernel may change */
+	iod->op_flags = ublk_op | ublk_req_build_flags(req);
+	iod->nr_sectors = blk_rq_sectors(req);
+	iod->start_sector = blk_rq_pos(req);
+	iod->addr = io->addr;
+
+	return BLK_STS_OK;
+}
+
+static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct ublk_queue *ubq = hctx->driver_data;
+	struct request *rq = bd->rq;
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+	enum task_work_notify_mode notify_mode = bd->last ?
+		TWA_SIGNAL_NO_IPI : TWA_NONE;
+	blk_status_t res;
+
+	/* fill iod to slot in io cmd buffer */
+	res = ublk_setup_iod(ubq, rq);
+	if (res != BLK_STS_OK)
+		return BLK_STS_IOERR;
+
+	blk_mq_start_request(bd->rq);
+
+	/*
+	 * run data copy in task work context for WRITE, and complete io_uring
+	 * cmd there too.
+	 *
+	 * This way should improve batching, meantime pinning pages in current
+	 * context is pretty fast.
+	 *
+	 * If we can't add the task work, something must be wrong, schedule
+	 * monitor work immediately.
+	 */
+	if (task_work_add(ubq->ubq_daemon, &data->work, notify_mode)) {
+		struct ublk_device *ub = rq->q->queuedata;
+
+		mod_delayed_work(system_wq, &ub->monitor_work, 0);
+		return BLK_STS_IOERR;
+	}
+
+	return BLK_STS_OK;
+}
+
+static bool ubq_daemon_is_dying(struct ublk_queue *ubq)
+{
+	return ubq->ubq_daemon->flags & PF_EXITING;
+}
+
+static void ublk_commit_rqs(struct blk_mq_hw_ctx *hctx)
+{
+	struct ublk_queue *ubq = hctx->driver_data;
+
+	__set_notify_signal(ubq->ubq_daemon);
+	if (ubq_daemon_is_dying(ubq)) {
+		struct ublk_device *ub = hctx->queue->queuedata;
+
+		mod_delayed_work(system_wq, &ub->monitor_work, 0);
+	}
+}
+
+/* todo: handle partial completion */
+static void ublk_complete_rq(struct request *req)
+{
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	struct ublk_io *io = &ubq->ios[req->tag];
+	unsigned int unmapped_bytes;
+
+	/* failed read IO if nothing is read */
+	if (!io->res && req_op(req) == REQ_OP_READ)
+		io->res = -EIO;
+
+	if (io->res < 0) {
+		blk_mq_end_request(req, errno_to_blk_status(io->res));
+		return;
+	}
+
+	/*
+	 * FLUSH or DISCARD usually won't return bytes returned, so end them
+	 * directly.
+	 *
+	 * Both the two needn't unmap.
+	 */
+	if (req_op(req) != REQ_OP_READ && req_op(req) != REQ_OP_WRITE) {
+		blk_mq_end_request(req, BLK_STS_OK);
+		return;
+	}
+
+	/* for READ request, writing data in iod->addr to rq buffers */
+	unmapped_bytes = ublk_unmap_io(ubq, req, io);
+
+	/*
+	 * Extremely impossible since we got data filled in just before
+	 *
+	 * Re-read simply for this unlikely case.
+	 */
+	if (unlikely(unmapped_bytes < io->res))
+		io->res = unmapped_bytes;
+
+	if (blk_update_request(req, BLK_STS_OK, io->res))
+		blk_mq_requeue_request(req, true);
+	else
+		__blk_mq_end_request(req, BLK_STS_OK);
+}
+
+/*
+ * __ublk_fail_req() may be called from abort context or ->ubq_daemon
+ * context during exiting, so lock is required.
+ *
+ * Also aborting may not be started yet, keep in mind that one failed
+ * request may be issued by block layer again.
+ */
+static void __ublk_fail_req(struct ublk_io *io, struct request *req)
+{
+	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_ACTIVE);
+
+	if (!(io->flags & UBLK_IO_FLAG_ABORTED)) {
+		io->flags |= UBLK_IO_FLAG_ABORTED;
+		blk_mq_end_request(req, BLK_STS_IOERR);
+	}
+}
+
+#define UBLK_REQUEUE_DELAY_MS	3
+
+static void ublk_rq_task_work_fn(struct callback_head *work)
+{
+	bool task_exiting = !!(current->flags & PF_EXITING);
+	struct ublk_rq_data *data = container_of(work,
+			struct ublk_rq_data, work);
+	struct request *req = blk_mq_rq_from_pdu(data);
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	struct ublk_io *io = &ubq->ios[req->tag];
+	struct ublk_device *ub = req->q->queuedata;
+	int ret;
+
+	pr_devel("%s: complete: op %d, qid %d tag %d io_flags %x addr %llx\n",
+			__func__, io->cmd->cmd_op, ubq->q_id, req->tag, io->flags,
+			ublk_get_iod(ubq, req->tag)->addr);
+
+	/*
+	 * If task is exiting, we may be run from exit_task_work() in
+	 * do_exit(), and may race with ublk_abort_queue(), so lock is
+	 * needed.
+	 */
+	if (unlikely(task_exiting)) {
+		ret = -ESRCH;
+		spin_lock(&ubq->abort_lock);
+	} else {
+		unsigned int mapped_bytes = ublk_map_io(ubq, req, io);
+
+		/*
+		 * Nothing mapped, retry until we succeed.
+		 *
+		 * We may never succeed in mapping any bytes here because of
+		 * OOM. TODO: reserve one buffer with single page pinned for
+		 * providing forward progress guarantee.
+		 */
+		if (unlikely(!mapped_bytes)) {
+			blk_mq_requeue_request(req, false);
+			blk_mq_delay_kick_requeue_list(req->q,
+					UBLK_REQUEUE_DELAY_MS);
+			return;
+		}
+
+		/* partially mapped, update io descriptor */
+		if (unlikely(mapped_bytes != blk_rq_bytes(req)))
+			ublk_get_iod(ubq, req->tag)->nr_sectors =
+				mapped_bytes >> 9;
+		ret = 0;
+	}
+
+	/*
+	 * Request is re-issued after this io command is aborted, we still
+	 * need to fail it immediately
+         */
+	if (unlikely(io->flags & UBLK_IO_FLAG_ABORTED)) {
+		blk_mq_end_request(req, BLK_STS_IOERR);
+		if (task_exiting)
+			spin_unlock(&ubq->abort_lock);
+		return;
+	}
+
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
+	io_uring_cmd_done(io->cmd, ret, 0);
+
+	/*
+	 * in case task is exiting, our partner has gone, so schedule monitor
+	 * work immediately for aborting queue
+	 */
+	if (task_exiting) {
+		spin_unlock(&ubq->abort_lock);
+		mod_delayed_work(system_wq, &ub->monitor_work, 0);
+	}
+}
+
+static int ublk_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
+		unsigned int hctx_idx)
+{
+	struct ublk_device *ub = hctx->queue->queuedata;
+	struct ublk_queue *ubq = ublk_get_queue(ub, hctx->queue_num);
+
+	hctx->driver_data = ubq;
+	return 0;
+}
+
+static int ublk_init_rq(struct blk_mq_tag_set *set, struct request *req,
+		unsigned int hctx_idx, unsigned int numa_node)
+{
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+
+	init_task_work(&data->work, ublk_rq_task_work_fn);
+
+	return 0;
+}
+
+static const struct blk_mq_ops ublk_mq_ops = {
+	.queue_rq       = ublk_queue_rq,
+	.commit_rqs     = ublk_commit_rqs,
+	.init_hctx	= ublk_init_hctx,
+	.init_request	= ublk_init_rq,
+};
+
+static int ublk_ch_open(struct inode *inode, struct file *filp)
+{
+	struct ublk_device *ub = container_of(inode->i_cdev,
+			struct ublk_device, cdev);
+
+	if (atomic_cmpxchg(&ub->ch_open_cnt, 0, 1) == 0) {
+		filp->private_data = ub;
+		return 0;
+	}
+	return -EBUSY;
+}
+
+static int ublk_ch_release(struct inode *inode, struct file *filp)
+{
+	struct ublk_device *ub = filp->private_data;
+
+	while (atomic_cmpxchg(&ub->ch_open_cnt, 1, 0) != 1)
+		cpu_relax();
+
+	filp->private_data = NULL;
+	return 0;
+}
+
+/* map pre-allocated per-queue cmd buffer to ublksrv daemon */
+static int ublk_ch_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct ublk_device *ub = filp->private_data;
+	size_t sz = vma->vm_end - vma->vm_start;
+	unsigned max_sz = UBLK_MAX_QUEUE_DEPTH * sizeof(struct ublksrv_io_desc);
+	unsigned long pfn, end, phys_off = vma->vm_pgoff << PAGE_SHIFT;
+	int q_id, ret = 0;
+
+	mutex_lock(&ub->mutex);
+	if (!ub->mm)
+		ub->mm = current->mm;
+	if (current->mm != ub->mm)
+		ret = -EINVAL;
+	mutex_unlock(&ub->mutex);
+
+	if (ret)
+		return ret;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	end = UBLKSRV_CMD_BUF_OFFSET + ub->dev_info.nr_hw_queues * max_sz;
+	if (phys_off < UBLKSRV_CMD_BUF_OFFSET || phys_off >= end)
+		return -EINVAL;
+
+	q_id = (phys_off - UBLKSRV_CMD_BUF_OFFSET) / max_sz;
+	pr_devel("%s: qid %d, pid %d, addr %lx pg_off %lx sz %lu\n",
+			__func__, q_id, current->pid, vma->vm_start,
+			phys_off, (unsigned long)sz);
+
+	if (sz != ublk_queue_cmd_buf_size(ub, q_id))
+		return -EINVAL;
+
+	pfn = virt_to_phys(ublk_queue_cmd_buf(ub, q_id)) >> PAGE_SHIFT;
+	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
+}
+
+static void ublk_commit_completion(struct ublk_device *ub,
+		struct ublksrv_io_cmd *ub_cmd)
+{
+	u32 qid = ub_cmd->q_id, tag = ub_cmd->tag;
+	struct ublk_queue *ubq = ublk_get_queue(ub, qid);
+	struct ublk_io *io = &ubq->ios[tag];
+	struct request *req;
+
+	/* now this cmd slot is owned by nbd driver */
+	io->flags &= ~UBLK_IO_FLAG_OWNED_BY_SRV;
+	io->res = ub_cmd->result;
+
+	/* find the io request and complete */
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[qid], tag);
+
+	if (req && likely(!blk_should_fake_timeout(req->q)))
+		ublk_complete_rq(req);
+}
+
+/*
+ * Focus on aborting any in-flight request scheduled to run via task work
+ */
+static void __ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
+{
+	bool task_exiting = !!(ubq->ubq_daemon->flags & PF_EXITING);
+	int i;
+
+	if (!task_exiting)
+		goto out;
+
+	for (i = 0; i < ubq->q_depth; i++) {
+		struct ublk_io *io = &ubq->ios[i];
+
+		if (!(io->flags & UBLK_IO_FLAG_ACTIVE)) {
+			struct request *rq;
+
+			/*
+			 * Either we fail the request or ublk_rq_task_work_fn
+			 * will do it
+			 */
+			rq = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], i);
+			if (rq)
+				__ublk_fail_req(io, rq);
+		}
+	}
+ out:
+	ubq->abort_work_pending = false;
+	ublk_put_device(ub);
+}
+
+static void ublk_queue_task_work_fn(struct callback_head *work)
+{
+	struct ublk_queue *ubq = container_of(work, struct ublk_queue,
+			abort_work);
+
+	/*
+	 * Lock is only required in case of exiting ubq_daemon, but harmless
+	 * to grab it for running from task work too
+	 *
+	 * We are serialized with ublk_rq_task_work_fn() strictly.
+	 */
+	spin_lock(&ubq->abort_lock);
+	__ublk_abort_queue(ubq->dev, ubq);
+	spin_unlock(&ubq->abort_lock);
+}
+
+
+static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
+{
+	bool put_dev;
+
+	if (!ublk_get_device(ub))
+		return;
+
+	spin_lock(&ubq->abort_lock);
+	if (!ubq->abort_work_pending) {
+		ubq->abort_work_pending = true;
+		put_dev = false;
+		if (task_work_add(ubq->ubq_daemon, &ubq->abort_work,
+					TWA_SIGNAL)) {
+			__ublk_abort_queue(ub, ubq);
+		}
+	} else {
+		put_dev = true;
+	}
+	spin_unlock(&ubq->abort_lock);
+
+	/*
+	 * can't put device with ->abort_lock held, otherwise UAF
+	 * is triggered
+	 */
+	if (put_dev)
+		ublk_put_device(ub);
+}
+
+static void ublk_cancel_queue(struct ublk_queue *ubq)
+{
+	int i;
+
+	for (i = 0; i < ubq->q_depth; i++) {
+		struct ublk_io *io = &ubq->ios[i];
+
+		if (io->flags & UBLK_IO_FLAG_ACTIVE)
+			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0);
+	}
+}
+
+/* Cancel all pending commands, must be called after del_gendisk() returns */
+static void ublk_cancel_dev(struct ublk_device *ub)
+{
+	int i;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
+		ublk_cancel_queue(ublk_get_queue(ub, i));
+}
+
+static void ublk_stop_dev(struct ublk_device *ub)
+{
+	mutex_lock(&ub->mutex);
+	if (!disk_live(ub->ub_disk))
+		goto unlock;
+
+	del_gendisk(ub->ub_disk);
+	ub->dev_info.state = UBLK_S_DEV_DEAD;
+	ub->dev_info.ublksrv_pid = -1;
+	ublk_cancel_dev(ub);
+ unlock:
+	mutex_unlock(&ub->mutex);
+	cancel_delayed_work_sync(&ub->monitor_work);
+}
+
+static int ublk_ctrl_stop_dev(struct ublk_device *ub)
+{
+	ublk_stop_dev(ub);
+	cancel_work_sync(&ub->stop_work);
+	return 0;
+}
+
+static inline bool ublk_queue_ready(struct ublk_queue *ubq)
+{
+	return ubq->nr_io_ready == ubq->q_depth;
+}
+
+/* device can only be started after all IOs are ready */
+static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
+{
+	mutex_lock(&ub->mutex);
+	ubq->nr_io_ready++;
+	if (ublk_queue_ready(ubq)) {
+		ubq->ubq_daemon = current;
+		get_task_struct(ubq->ubq_daemon);
+		ub->nr_queues_ready++;
+	}
+	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
+		complete_all(&ub->completion);
+	mutex_unlock(&ub->mutex);
+}
+
+static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
+	struct ublk_device *ub = cmd->file->private_data;
+	struct ublk_queue *ubq;
+	struct ublk_io *io;
+	u32 cmd_op = cmd->cmd_op;
+	unsigned tag = ub_cmd->tag;
+	int ret = -EINVAL;
+
+	pr_devel("%s: received: cmd op %d queue %d tag %d result %d\n",
+			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
+			ub_cmd->result);
+
+	if (!(issue_flags & IO_URING_F_SQE128))
+		goto out;
+
+	if (ub_cmd->q_id >= ub->dev_info.nr_hw_queues)
+		goto out;
+
+	ubq = ublk_get_queue(ub, ub_cmd->q_id);
+	if (!ubq || ub_cmd->q_id != ubq->q_id)
+		goto out;
+
+	if (ubq->ubq_daemon && ubq->ubq_daemon != current)
+		goto out;
+
+	if (tag >= ubq->q_depth)
+		goto out;
+
+	io = &ubq->ios[tag];
+
+	/* there is pending io cmd, something must be wrong */
+	if (io->flags & UBLK_IO_FLAG_ACTIVE) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	switch (cmd_op) {
+	case UBLK_IO_FETCH_REQ:
+		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
+		if (ublk_queue_ready(ubq)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		/*
+		 * The io is being handled by server, so COMMIT_RQ is expected
+		 * instead of FETCH_REQ
+		 */
+		if (io->flags & UBLK_IO_FLAG_OWNED_BY_SRV)
+			goto out;
+		/* FETCH_RQ has to provide IO buffer */
+		if (!ub_cmd->addr)
+			goto out;
+		io->cmd = cmd;
+		io->flags |= UBLK_IO_FLAG_ACTIVE;
+		io->addr = ub_cmd->addr;
+
+		ublk_mark_io_ready(ub, ubq);
+		break;
+	case UBLK_IO_COMMIT_AND_FETCH_REQ:
+		/* FETCH_RQ has to provide IO buffer */
+		if (!ub_cmd->addr)
+			goto out;
+		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
+			goto out;
+		io->addr = ub_cmd->addr;
+		io->flags |= UBLK_IO_FLAG_ACTIVE;
+		io->cmd = cmd;
+		ublk_commit_completion(ub, ub_cmd);
+		break;
+	default:
+		goto out;
+	}
+	return -EIOCBQUEUED;
+
+ out:
+	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
+	io_uring_cmd_done(cmd, ret, 0);
+	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
+			__func__, cmd_op, tag, ret, io->flags);
+	return -EIOCBQUEUED;
+}
+
+static const struct file_operations ublk_ch_fops = {
+	.owner = THIS_MODULE,
+	.open = ublk_ch_open,
+	.release = ublk_ch_release,
+	.llseek = no_llseek,
+	.uring_cmd = ublk_ch_uring_cmd,
+	.mmap = ublk_ch_mmap,
+};
+
+static void ublk_deinit_queue(struct ublk_device *ub, int q_id)
+{
+	int size = ublk_queue_cmd_buf_size(ub, q_id);
+	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
+
+	if (ubq->ubq_daemon)
+		put_task_struct(ubq->ubq_daemon);
+	if (ubq->io_cmd_buf)
+		free_pages((unsigned long)ubq->io_cmd_buf, get_order(size));
+}
+
+static int ublk_init_queue(struct ublk_device *ub, int q_id)
+{
+	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO;
+	void *ptr;
+	int size;
+
+	ubq->q_id = q_id;
+	ubq->q_depth = ub->dev_info.queue_depth;
+	size = ublk_queue_cmd_buf_size(ub, q_id);
+
+	ptr = (void *) __get_free_pages(gfp_flags, get_order(size));
+	if (!ptr)
+		return -ENOMEM;
+
+	init_task_work(&ubq->abort_work, ublk_queue_task_work_fn);
+	ubq->io_cmd_buf = ptr;
+	ubq->dev = ub;
+	spin_lock_init(&ubq->abort_lock);
+	return 0;
+}
+
+static void ublk_deinit_queues(struct ublk_device *ub)
+{
+	int nr_queues = ub->dev_info.nr_hw_queues;
+	int i;
+
+	if (!ub->__queues)
+		return;
+
+	for (i = 0; i < nr_queues; i++)
+		ublk_deinit_queue(ub, i);
+	kfree(ub->__queues);
+}
+
+static int ublk_init_queues(struct ublk_device *ub)
+{
+	int nr_queues = ub->dev_info.nr_hw_queues;
+	int depth = ub->dev_info.queue_depth;
+	int ubq_size = sizeof(struct ublk_queue) + depth * sizeof(struct ublk_io);
+	int i, ret = -ENOMEM;
+
+	ub->queue_size = ubq_size;
+	ub->__queues = kcalloc(nr_queues, ubq_size, GFP_KERNEL);
+	if (!ub->__queues)
+		return ret;
+
+	for (i = 0; i < nr_queues; i++) {
+		if (ublk_init_queue(ub, i))
+			goto fail;
+	}
+
+	init_completion(&ub->completion);
+	return 0;
+
+ fail:
+	ublk_deinit_queues(ub);
+	return ret;
+}
+
+static int __ublk_alloc_dev_number(struct ublk_device *ub, int idx)
+{
+	int i = idx;
+	int err;
+
+	spin_lock(&ublk_idr_lock);
+	/* allocate id, if @id >= 0, we're requesting that specific id */
+	if (i >= 0) {
+		err = idr_alloc(&ublk_index_idr, ub, i, i + 1, GFP_NOWAIT);
+		if (err == -ENOSPC)
+			err = -EEXIST;
+	} else {
+		err = idr_alloc(&ublk_index_idr, ub, 0, 0, GFP_NOWAIT);
+	}
+	spin_unlock(&ublk_idr_lock);
+
+	if (err >= 0)
+		ub->ub_number = err;
+
+	return err;
+}
+
+static struct ublk_device *__ublk_create_dev(int idx)
+{
+	struct ublk_device *ub = NULL;
+	int ret;
+
+	ub = kzalloc(sizeof(*ub), GFP_KERNEL);
+	if (!ub)
+		return ERR_PTR(-ENOMEM);
+
+	ret = __ublk_alloc_dev_number(ub, idx);
+	if (ret < 0) {
+		kfree(ub);
+		return ERR_PTR(ret);
+	}
+	return ub;
+}
+
+static void __ublk_destroy_dev(struct ublk_device *ub)
+{
+	spin_lock(&ublk_idr_lock);
+	idr_remove(&ublk_index_idr, ub->ub_number);
+	wake_up_all(&ublk_idr_wq);
+	spin_unlock(&ublk_idr_lock);
+
+	mutex_destroy(&ub->mutex);
+
+	kfree(ub);
+}
+
+static void ublk_cdev_rel(struct device *dev)
+{
+	struct ublk_device *ub = container_of(dev, struct ublk_device, cdev_dev);
+
+	put_disk(ub->ub_disk);
+
+	blk_mq_free_tag_set(&ub->tag_set);
+
+	ublk_deinit_queues(ub);
+
+	__ublk_destroy_dev(ub);
+}
+
+static int ublk_add_chdev(struct ublk_device *ub)
+{
+	struct device *dev = &ub->cdev_dev;
+	int minor = ub->ub_number;
+	int ret;
+
+	dev->parent = ublk_misc.this_device;
+	dev->devt = MKDEV(MAJOR(ublk_chr_devt), minor);
+	dev->class = ublk_chr_class;
+	dev->release = ublk_cdev_rel;
+	device_initialize(dev);
+
+	ret = dev_set_name(dev, "ublkc%d", minor);
+	if (ret)
+		goto fail;
+
+	cdev_init(&ub->cdev, &ublk_ch_fops);
+	ret = cdev_device_add(&ub->cdev, dev);
+	if (ret)
+		goto fail;
+	return 0;
+ fail:
+	put_device(dev);
+	return ret;
+}
+
+static void ublk_stop_work_fn(struct work_struct *work)
+{
+	struct ublk_device *ub =
+		container_of(work, struct ublk_device, stop_work);
+
+	ublk_stop_dev(ub);
+}
+
+static void ublk_daemon_monitor_work(struct work_struct *work)
+{
+	struct ublk_device *ub =
+		container_of(work, struct ublk_device, monitor_work.work);
+	int i;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		struct ublk_queue *ubq = ublk_get_queue(ub, i);
+
+		if (ubq_daemon_is_dying(ubq)) {
+			schedule_work(&ub->stop_work);
+
+			/* abort queue is for making forward progress */
+			ublk_abort_queue(ub, ubq);
+		}
+	}
+
+	/*
+	 * We can't schedule monitor work after ublk_remove() is started.
+	 *
+	 * No need ub->mutex, monitor work are canceled after state is marked
+	 * as DEAD, so DEAD state is observed reliably.
+	 */
+	if (ub->dev_info.state != UBLK_S_DEV_DEAD)
+		schedule_delayed_work(&ub->monitor_work,
+				UBLK_DAEMON_MONITOR_PERIOD);
+}
+
+static void ublk_update_capacity(struct ublk_device *ub)
+{
+	unsigned int max_rq_bytes;
+
+	/* make max request buffer size aligned with PAGE_SIZE */
+	max_rq_bytes = round_down(ub->dev_info.rq_max_blocks <<
+			ub->bs_shift, PAGE_SIZE);
+	ub->dev_info.rq_max_blocks = max_rq_bytes >> ub->bs_shift;
+
+	set_capacity(ub->ub_disk, ub->dev_info.dev_blocks << (ub->bs_shift - 9));
+}
+
+/* add disk & cdev, cleanup everything in case of failure */
+static int ublk_add_dev(struct ublk_device *ub)
+{
+	struct gendisk *disk;
+	int err = -ENOMEM;
+	int bsize;
+
+	/* We are not ready to support zero copy */
+	ub->dev_info.flags[0] &= ~UBLK_F_SUPPORT_ZERO_COPY;
+
+	bsize = ub->dev_info.block_size;
+	ub->bs_shift = ilog2(bsize);
+
+	ub->dev_info.nr_hw_queues = min_t(unsigned int,
+			ub->dev_info.nr_hw_queues, nr_cpu_ids);
+
+	INIT_WORK(&ub->stop_work, ublk_stop_work_fn);
+	INIT_DELAYED_WORK(&ub->monitor_work, ublk_daemon_monitor_work);
+
+	if (ublk_init_queues(ub))
+		goto out_destroy_dev;
+
+	ub->tag_set.ops = &ublk_mq_ops;
+	ub->tag_set.nr_hw_queues = ub->dev_info.nr_hw_queues;
+	ub->tag_set.queue_depth = ub->dev_info.queue_depth;
+	ub->tag_set.numa_node = NUMA_NO_NODE;
+	ub->tag_set.cmd_size = sizeof(struct ublk_rq_data);
+	ub->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	ub->tag_set.driver_data = ub;
+
+	err = blk_mq_alloc_tag_set(&ub->tag_set);
+	if (err)
+		goto out_deinit_queues;
+
+	disk = ub->ub_disk = blk_mq_alloc_disk(&ub->tag_set, ub);
+	if (IS_ERR(disk)) {
+		err = PTR_ERR(disk);
+		goto out_cleanup_tags;
+	}
+	ub->ub_queue = ub->ub_disk->queue;
+
+	ub->ub_queue->queuedata = ub;
+
+	blk_queue_logical_block_size(ub->ub_queue, bsize);
+	blk_queue_physical_block_size(ub->ub_queue, bsize);
+	blk_queue_io_min(ub->ub_queue, bsize);
+
+	blk_queue_max_hw_sectors(ub->ub_queue, ub->dev_info.rq_max_blocks <<
+			(ub->bs_shift - 9));
+
+	ub->ub_queue->limits.discard_granularity = PAGE_SIZE;
+
+	blk_queue_max_discard_sectors(ub->ub_queue, UINT_MAX >> 9);
+	blk_queue_max_write_zeroes_sectors(ub->ub_queue, UINT_MAX >> 9);
+
+	ublk_update_capacity(ub);
+
+	disk->fops		= &ub_fops;
+	disk->private_data	= ub;
+	disk->queue		= ub->ub_queue;
+	sprintf(disk->disk_name, "ublkb%d", ub->ub_number);
+
+	mutex_init(&ub->mutex);
+
+	/* add char dev so that ublksrv daemon can be setup */
+	err = ublk_add_chdev(ub);
+	if (err)
+		return err;
+
+	/* don't expose disk now until we got start command from cdev */
+
+	return 0;
+
+out_cleanup_tags:
+	blk_mq_free_tag_set(&ub->tag_set);
+out_deinit_queues:
+	ublk_deinit_queues(ub);
+out_destroy_dev:
+	__ublk_destroy_dev(ub);
+	return err;
+}
+
+static void ublk_remove(struct ublk_device *ub)
+{
+	ublk_ctrl_stop_dev(ub);
+
+	cdev_device_del(&ub->cdev, &ub->cdev_dev);
+	put_device(&ub->cdev_dev);
+}
+
+static struct ublk_device *ublk_get_device_from_id(int idx)
+{
+	struct ublk_device *ub = NULL;
+
+	if (idx < 0)
+		return NULL;
+
+	spin_lock(&ublk_idr_lock);
+	ub = idr_find(&ublk_index_idr, idx);
+	if (ub)
+		ub = ublk_get_device(ub);
+	spin_unlock(&ublk_idr_lock);
+
+	return ub;
+}
+
+static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	int ret = -EINVAL;
+	int ublksrv_pid = (int)header->data[0];
+	unsigned long dev_blocks = header->data[1];
+
+	if (ublksrv_pid <= 0)
+		return ret;
+
+	wait_for_completion_interruptible(&ub->completion);
+
+	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
+
+	mutex_lock(&ub->mutex);
+	if (!disk_live(ub->ub_disk)) {
+		/* We may get disk size updated */
+		if (dev_blocks) {
+			ub->dev_info.dev_blocks = dev_blocks;
+			ublk_update_capacity(ub);
+		}
+		ub->dev_info.ublksrv_pid = ublksrv_pid;
+		ret = add_disk(ub->ub_disk);
+		if (!ret)
+			ub->dev_info.state = UBLK_S_DEV_LIVE;
+	} else {
+		ret = -EEXIST;
+	}
+	mutex_unlock(&ub->mutex);
+
+	return ret;
+}
+
+static struct blk_mq_hw_ctx *ublk_get_hw_queue(struct ublk_device *ub,
+		unsigned int index)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long i;
+
+	queue_for_each_hw_ctx(ub->ub_queue, hctx, i)
+		if (hctx->queue_num == index)
+			return hctx;
+	return NULL;
+}
+
+static int ublk_ctrl_get_queue_affinity(struct io_uring_cmd *cmd)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	void __user *argp = (void __user *)(unsigned long)header->addr;
+	struct blk_mq_hw_ctx *hctx;
+	struct ublk_device *ub;
+	unsigned long queue;
+	unsigned int retlen;
+	int ret;
+
+	ub = ublk_get_device_from_id(header->dev_id);
+	if (!ub)
+		goto out;
+
+	ret = -EINVAL;
+	queue = header->data[0];
+	if (queue >= ub->dev_info.nr_hw_queues)
+		goto out;
+	hctx = ublk_get_hw_queue(ub, queue);
+	if (!hctx)
+		goto out;
+
+	retlen = min_t(unsigned short, header->len, cpumask_size());
+	if (copy_to_user(argp, hctx->cpumask, retlen)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (retlen != header->len) {
+		if (clear_user(argp + retlen, header->len - retlen)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+	ret = 0;
+ out:
+	if (ub)
+		ublk_put_device(ub);
+	return ret;
+}
+
+static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_dev_info *info,
+		void __user *argp, int idx)
+{
+	struct ublk_device *ub;
+	int ret;
+
+	ret = mutex_lock_killable(&ublk_ctl_mutex);
+	if (ret)
+		return ret;
+
+	ub = __ublk_create_dev(idx);
+	if (!IS_ERR_OR_NULL(ub)) {
+		memcpy(&ub->dev_info, info, sizeof(*info));
+
+		/* update device id */
+		ub->dev_info.dev_id = ub->ub_number;
+
+		ret = ublk_add_dev(ub);
+		if (!ret) {
+			if (copy_to_user(argp, &ub->dev_info, sizeof(*info))) {
+				ublk_remove(ub);
+				ret = -EFAULT;
+			}
+		}
+	} else {
+		if (IS_ERR(ub))
+			ret = PTR_ERR(ub);
+		else
+			ret = -ENOMEM;
+	}
+	mutex_unlock(&ublk_ctl_mutex);
+
+	return ret;
+}
+
+static inline bool ublk_idr_freed(int id)
+{
+	void *ptr;
+
+	spin_lock(&ublk_idr_lock);
+	ptr = idr_find(&ublk_index_idr, id);
+	spin_unlock(&ublk_idr_lock);
+
+	return ptr == NULL;
+}
+
+static int ublk_ctrl_del_dev(int idx)
+{
+	struct ublk_device *ub;
+	int ret;
+
+	ret = mutex_lock_killable(&ublk_ctl_mutex);
+	if (ret)
+		return ret;
+
+	ub = ublk_get_device_from_id(idx);
+	if (ub) {
+		ublk_remove(ub);
+		ublk_put_device(ub);
+		ret = 0;
+	} else {
+		ret = -ENODEV;
+	}
+
+	/*
+	 * Wait until the idr is removed, then it can be reused after
+	 * DEL_DEV command is returned.
+	 */
+	if (!ret)
+		wait_event(ublk_idr_wq, ublk_idr_freed(idx));
+	mutex_unlock(&ublk_ctl_mutex);
+
+	return ret;
+}
+
+
+static inline void ublk_dump_dev_info(struct ublksrv_ctrl_dev_info *info)
+{
+	pr_devel("%s: dev id %d flags %llx\n", __func__,
+			info->dev_id, info->flags[0]);
+	pr_devel("\t nr_hw_queues %d queue_depth %d block size %d dev_capacity %lld\n",
+			info->nr_hw_queues, info->queue_depth,
+			info->block_size, info->dev_blocks);
+}
+
+static inline void ublk_ctrl_cmd_dump(struct io_uring_cmd *cmd)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+
+	pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len %u\n",
+			__func__, cmd->cmd_op, header->dev_id, header->queue_id,
+			header->data[0], header->addr, header->len);
+}
+
+static int ublk_ctrl_cmd_validate(struct io_uring_cmd *cmd,
+		struct ublksrv_ctrl_dev_info *info)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	u32 cmd_op = cmd->cmd_op;
+	void __user *argp = (void __user *)(unsigned long)header->addr;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (cmd_op) {
+	case UBLK_CMD_GET_DEV_INFO:
+		if (header->len < sizeof(*info) || !header->addr)
+			return -EINVAL;
+		break;
+	case UBLK_CMD_ADD_DEV:
+		if (header->len < sizeof(*info) || !header->addr)
+			return -EINVAL;
+		if (copy_from_user(info, argp, sizeof(*info)) != 0)
+			return -EFAULT;
+		ublk_dump_dev_info(info);
+		if (header->dev_id != info->dev_id) {
+			printk(KERN_WARNING "%s: cmd %x, dev id not match %u %u\n",
+					__func__, cmd_op, header->dev_id,
+					info->dev_id);
+			return -EINVAL;
+		}
+		if (header->queue_id != (u16)-1) {
+			printk(KERN_WARNING "%s: cmd %x queue_id is wrong %x\n",
+					__func__, cmd_op, header->queue_id);
+			return -EINVAL;
+		}
+		break;
+	case UBLK_CMD_GET_QUEUE_AFFINITY:
+		if ((header->len * BITS_PER_BYTE) < nr_cpu_ids)
+			return -EINVAL;
+		if (header->len & (sizeof(unsigned long)-1))
+			return -EINVAL;
+		if (!header->addr)
+			return -EINVAL;
+	};
+
+	return 0;
+}
+
+static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	void __user *argp = (void __user *)(unsigned long)header->addr;
+	struct ublksrv_ctrl_dev_info info;
+	u32 cmd_op = cmd->cmd_op;
+	struct ublk_device *ub;
+	int ret = -EINVAL;
+
+	ublk_ctrl_cmd_dump(cmd);
+
+	if (!(issue_flags & IO_URING_F_SQE128))
+		goto out;
+
+	ret = ublk_ctrl_cmd_validate(cmd, &info);
+	if (ret)
+		goto out;
+
+	ret = -ENODEV;
+	switch (cmd_op) {
+	case UBLK_CMD_START_DEV:
+		ub = ublk_get_device_from_id(header->dev_id);
+		if (ub) {
+			ret = ublk_ctrl_start_dev(ub, cmd);
+			ublk_put_device(ub);
+		}
+		break;
+	case UBLK_CMD_STOP_DEV:
+		ub = ublk_get_device_from_id(header->dev_id);
+		if (ub) {
+			ret = ublk_ctrl_stop_dev(ub);
+			ublk_put_device(ub);
+		}
+		break;
+	case UBLK_CMD_GET_DEV_INFO:
+		ub = ublk_get_device_from_id(header->dev_id);
+		if (ub) {
+			if (copy_to_user(argp, &ub->dev_info, sizeof(info)))
+				ret = -EFAULT;
+			else
+				ret = 0;
+			ublk_put_device(ub);
+		}
+		break;
+	case UBLK_CMD_ADD_DEV:
+		ret = ublk_ctrl_add_dev(&info, argp, header->dev_id);
+		break;
+	case UBLK_CMD_DEL_DEV:
+		ret = ublk_ctrl_del_dev(header->dev_id);
+		break;
+	case UBLK_CMD_GET_QUEUE_AFFINITY:
+		ret = ublk_ctrl_get_queue_affinity(cmd);
+		break;
+	default:
+		break;
+	};
+ out:
+	io_uring_cmd_done(cmd, ret, 0);
+	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
+			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
+	return -EIOCBQUEUED;
+}
+
+static const struct file_operations ublk_ctl_fops = {
+	.open		= nonseekable_open,
+	.uring_cmd      = ublk_ctrl_uring_cmd,
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice ublk_misc = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "ublk-control",
+	.fops		= &ublk_ctl_fops,
+};
+
+static int __init ublk_init(void)
+{
+	int ret;
+
+	init_waitqueue_head(&ublk_idr_wq);
+
+	ret = misc_register(&ublk_misc);
+	if (ret)
+		return ret;
+
+	ret = alloc_chrdev_region(&ublk_chr_devt, 0, UBLK_MINORS, "ublk-char");
+	if (ret)
+		goto unregister_mis;
+
+	ublk_chr_class = class_create(THIS_MODULE, "ublk-char");
+	if (IS_ERR(ublk_chr_class)) {
+		ret = PTR_ERR(ublk_chr_class);
+		goto free_chrdev_region;
+	}
+	return 0;
+
+free_chrdev_region:
+	unregister_chrdev_region(ublk_chr_devt, UBLK_MINORS);
+unregister_mis:
+	misc_deregister(&ublk_misc);
+	return ret;
+}
+
+static void __exit ublk_exit(void)
+{
+	struct ublk_device *ub;
+	int id;
+
+	class_destroy(ublk_chr_class);
+
+	misc_deregister(&ublk_misc);
+
+	idr_for_each_entry(&ublk_index_idr, ub, id)
+		ublk_remove(ub);
+
+	idr_destroy(&ublk_index_idr);
+	unregister_chrdev_region(ublk_chr_devt, UBLK_MINORS);
+}
+
+module_init(ublk_init);
+module_exit(ublk_exit);
+
+MODULE_AUTHOR("Ming Lei <ming.lei@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
new file mode 100644
index 000000000000..4f0c16ec875e
--- /dev/null
+++ b/include/uapi/linux/ublk_cmd.h
@@ -0,0 +1,156 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef USER_BLK_DRV_CMD_INC_H
+#define USER_BLK_DRV_CMD_INC_H
+
+#include <linux/types.h>
+
+/* ublk server command definition */
+
+/*
+ * Admin commands, issued by ublk server, and handled by ublk driver.
+ */
+#define	UBLK_CMD_GET_QUEUE_AFFINITY	0x01
+#define	UBLK_CMD_GET_DEV_INFO	0x02
+#define	UBLK_CMD_ADD_DEV		0x04
+#define	UBLK_CMD_DEL_DEV		0x05
+#define	UBLK_CMD_START_DEV	0x06
+#define	UBLK_CMD_STOP_DEV	0x07
+
+/*
+ * IO commands, issued by ublk server, and handled by ublk driver.
+ *
+ * FETCH_REQ: issued via sqe(URING_CMD) beforehand for fetching IO request
+ *      from ublk driver, should be issued only when starting device. After
+ *      the associated cqe is returned, request's tag can be retrieved via
+ *      cqe->userdata.
+ *
+ * COMMIT_AND_FETCH_REQ: issued via sqe(URING_CMD) after ublkserver handled
+ *      this IO request, request's handling result is committed to ublk
+ *      driver, meantime FETCH_REQ is piggyback, and FETCH_REQ has to be
+ *      handled before completing io request.
+ */
+#define	UBLK_IO_FETCH_REQ		0x20
+#define	UBLK_IO_COMMIT_AND_FETCH_REQ	0x21
+
+/* only ABORT means that no re-fetch */
+#define UBLK_IO_RES_OK			0
+#define UBLK_IO_RES_ABORT		(-ENODEV)
+
+#define UBLKSRV_CMD_BUF_OFFSET	0
+#define UBLKSRV_IO_BUF_OFFSET	0x80000000
+
+/* tag bit is 12bit, so at most 4096 IOs for each queue */
+#define UBLK_MAX_QUEUE_DEPTH	4096
+
+/*
+ * zero copy requires 4k block size, and can remap ublk driver's io
+ * request into ublksrv's vm space
+ */
+#define UBLK_F_SUPPORT_ZERO_COPY	(1UL << 0)
+
+/* device state */
+#define UBLK_S_DEV_DEAD	0
+#define UBLK_S_DEV_LIVE	1
+
+/* shipped via sqe->cmd of io_uring command */
+struct ublksrv_ctrl_cmd {
+	/* sent to which device, must be valid */
+	__u32	dev_id;
+
+	/* sent to which queue, must be -1 if the cmd isn't for queue */
+	__u16	queue_id;
+	/*
+	 * cmd specific buffer, can be IN or OUT.
+	 */
+	__u16	len;
+	__u64	addr;
+
+	/* inline data */
+	__u64	data[2];
+};
+
+struct ublksrv_ctrl_dev_info {
+	__u16	nr_hw_queues;
+	__u16	queue_depth;
+	__u16	block_size;
+	__u16	state;
+
+	__u32	rq_max_blocks;
+	__u32	dev_id;
+
+	__u64   dev_blocks;
+
+	__s32	ublksrv_pid;
+	__s32	reserved0;
+	__u64	flags[2];
+
+	/* For ublksrv internal use, invisible to ublk driver */
+	__u64	ublksrv_flags;
+	__u64	reserved1[9];
+};
+
+#define		UBLK_IO_OP_READ		0
+#define		UBLK_IO_OP_WRITE		1
+#define		UBLK_IO_OP_FLUSH		2
+#define		UBLK_IO_OP_DISCARD	3
+#define		UBLK_IO_OP_WRITE_SAME	4
+#define		UBLK_IO_OP_WRITE_ZEROES	5
+
+#define		UBLK_IO_F_FAILFAST_DEV		(1U << 8)
+#define		UBLK_IO_F_FAILFAST_TRANSPORT	(1U << 9)
+#define		UBLK_IO_F_FAILFAST_DRIVER	(1U << 10)
+#define		UBLK_IO_F_META			(1U << 11)
+#define		UBLK_IO_F_INTEGRITY		(1U << 12)
+#define		UBLK_IO_F_FUA			(1U << 13)
+#define		UBLK_IO_F_PREFLUSH		(1U << 14)
+#define		UBLK_IO_F_NOUNMAP		(1U << 15)
+#define		UBLK_IO_F_SWAP			(1U << 16)
+
+/*
+ * io cmd is described by this structure, and stored in share memory, indexed
+ * by request tag.
+ *
+ * The data is stored by ublk driver, and read by ublksrv after one fetch command
+ * returns.
+ */
+struct ublksrv_io_desc {
+	/* op: bit 0-7, flags: bit 8-31 */
+	__u32		op_flags;
+
+	__u32		nr_sectors;
+
+	/* start sector for this io */
+	__u64		start_sector;
+
+	/* buffer address in ublksrv daemon vm space, from ublk driver */
+	__u64		addr;
+};
+
+static inline __u8 ublksrv_get_op(const struct ublksrv_io_desc *iod)
+{
+	return iod->op_flags & 0xff;
+}
+
+static inline __u32 ublksrv_get_flags(const struct ublksrv_io_desc *iod)
+{
+	return iod->op_flags >> 8;
+}
+
+/* issued to ublk driver via /dev/ublkcN */
+struct ublksrv_io_cmd {
+	__u16	q_id;
+
+	/* for fetch/commit which result */
+	__u16	tag;
+
+	/* io result, it is valid for COMMIT* command only */
+	__s32	result;
+
+	/*
+	 * userspace buffer address in ublksrv daemon process, valid for
+	 * FETCH* command only
+	 */
+	__u64	addr;
+};
+
+#endif
-- 
2.31.1

