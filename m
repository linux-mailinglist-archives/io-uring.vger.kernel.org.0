Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9477E52992B
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 07:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbiEQFyb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 01:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbiEQFy0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 01:54:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3F9F3EBAA
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 22:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652766862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNpnp1q+1zpGCQWC3AVdzOAIBA4637Uta+WZijduYd4=;
        b=LwVL16vbWocGkN5bfgO/3Bg75liUHnc33Gt3FWXyTNUGQTKby0mXPpgzbiKsZaPfqKF48+
        8HMmPV8+aBnKSW4D/0JPYK5bAA84AlDwudysmWOOX2HPqxBjC5dSYgjSdomwCFPvkcgAFG
        nxlqKy8oVQ6/d+3LhGRevcgj1Zbu5yU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-gTps7anJPtaSm5swAcEV1A-1; Tue, 17 May 2022 01:54:18 -0400
X-MC-Unique: gTps7anJPtaSm5swAcEV1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B47985A5BE;
        Tue, 17 May 2022 05:54:17 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5496E5703A1;
        Tue, 17 May 2022 05:54:14 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/1] ubd: add io_uring based userspace block driver
Date:   Tue, 17 May 2022 13:53:58 +0800
Message-Id: <20220517055358.3164431-2-ming.lei@redhat.com>
In-Reply-To: <20220517055358.3164431-1-ming.lei@redhat.com>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is the driver part of userspace block driver(ubd driver), the other
part is userspace daemon part(ubdsrv)[1].

The two parts communicate by io_uring's IORING_OP_URING_CMD with one
shared cmd buffer for storing io command, and the buffer is read only for
ubdsrv, each io command is indexed by io request tag directly, and
is written by ubd driver.

For example, when one READ io request is submitted to ubd block driver, ubd
driver stores the io command into cmd buffer first, then completes one
IORING_OP_URING_CMD for notifying ubdsrv, and the URING_CMD is issued to
ubd driver beforehand by ubdsrv for getting notification of any new io request,
and each URING_CMD is associated with one io request by tag.

After ubdsrv gets the io command, it translates and handles the ubd io
request, such as, for the ubd-loop target, ubdsrv translates the request
into same request on another file or disk, like the kernel loop block
driver. In ubdsrv's implementation, the io is still handled by io_uring,
and share same ring with IORING_OP_URING_CMD command. When the target io
request is done, the same IORING_OP_URING_CMD is issued to ubd driver for
both committing io request result and getting future notification of new
io request.

Another thing done by ubd driver is to copy data between kernel io
request and ubdsrv's io buffer:

1) before ubsrv handles WRITE request, copy the request's data into
ubdsrv's userspace io buffer, so that ubdsrv can handle the write
request

2) after ubsrv handles READ request, copy ubdsrv's userspace io buffer
into this READ request, then ubd driver can complete the READ request

Zero copy may be switched if mm is ready to support it.

ubd driver doesn't handle any logic of the specific user space driver,
so it should be small/simple enough.

[1] ubdsrv
https://github.com/ming1/ubdsrv/commits/devel-v2

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/Kconfig        |    6 +
 drivers/block/Makefile       |    2 +
 drivers/block/ubd_drv.c      | 1444 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ubd_cmd.h |  158 ++++
 4 files changed, 1610 insertions(+)
 create mode 100644 drivers/block/ubd_drv.c
 create mode 100644 include/uapi/linux/ubd_cmd.h

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index fdb81f2794cd..6b8ba7a125ce 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -408,6 +408,12 @@ config BLK_DEV_RBD
 
 	  If unsure, say N.
 
+config BLK_DEV_USER_BLK_DRV
+	bool "Userspace block driver"
+	select IO_URING
+	help
+          io uring based userspace block driver.
+
 source "drivers/block/rnbd/Kconfig"
 
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 934a9c7c3a7c..effff34babd9 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -39,4 +39,6 @@ obj-$(CONFIG_BLK_DEV_RNBD)	+= rnbd/
 
 obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
 
+obj-$(CONFIG_BLK_DEV_USER_BLK_DRV)			+= ubd_drv.o
+
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/ubd_drv.c b/drivers/block/ubd_drv.c
new file mode 100644
index 000000000000..eb2e6a5650f2
--- /dev/null
+++ b/drivers/block/ubd_drv.c
@@ -0,0 +1,1444 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Userspace block device - block device which IO is handled from userspace
+ *
+ * Take full use of io_uring passthrough command for communicating with
+ * ubd userspace daemon(ubdsrvd) for handling basic IO request.
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
+#include <uapi/linux/ubd_cmd.h>
+
+#define UBD_MINORS		(1U << MINORBITS)
+
+struct ubd_rq_data {
+	struct callback_head work;
+};
+
+/* io cmd is active: sqe cmd is received, and its cqe isn't done */
+#define UBD_IO_FLAG_ACTIVE	0x01
+
+/*
+ * FETCH io cmd is completed via cqe, and the io cmd is being handled by
+ * ubdsrv, and not committed yet
+ */
+#define UBD_IO_FLAG_OWNED_BY_SRV 0x02
+
+/*
+ * request has been failed, only used in handling aborting, and after
+ * this flag is observed, this request will be failed immediately
+ */
+#define UBD_IO_FLAG_REQ_FAILED 0x04
+
+struct ubd_io {
+	/* userspace buffer address from io cmd */
+	__u64	addr;
+	unsigned int flags;
+	int res;
+
+	struct io_uring_cmd *cmd;
+};
+
+struct ubd_queue {
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
+	struct ubd_device *dev;
+	spinlock_t	abort_lock;
+	struct callback_head abort_work;
+	struct ubd_io ios[0];
+};
+
+#define UBD_DAEMON_MONITOR_PERIOD	(5 * HZ)
+
+struct ubd_device {
+	struct gendisk		*ub_disk;
+	struct request_queue	*ub_queue;
+
+	char	*__queues;
+
+	unsigned short  queue_size;
+	unsigned short  bs_shift;
+	struct ubdsrv_ctrl_dev_info	dev_info;
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
+static dev_t ubd_chr_devt;
+static struct class *ubd_chr_class;
+
+static DEFINE_IDR(ubd_index_idr);
+static DEFINE_MUTEX(ubd_ctl_mutex);
+
+static struct miscdevice ubd_misc;
+
+static inline struct ubd_queue *ubd_get_queue(struct ubd_device *dev, int qid)
+{
+       return (struct ubd_queue *)&(dev->__queues[qid * dev->queue_size]);
+}
+
+static inline bool ubd_rq_need_copy(struct request *rq)
+{
+	return rq->bio && bio_has_data(rq->bio);
+}
+
+static inline struct ubdsrv_io_desc *ubd_get_iod(struct ubd_queue *ubq, int tag)
+{
+	return (struct ubdsrv_io_desc *)
+		&(ubq->io_cmd_buf[tag * sizeof(struct ubdsrv_io_desc)]);
+}
+
+static inline char *ubd_queue_cmd_buf(struct ubd_device *ub, int q_id)
+{
+	return ubd_get_queue(ub, q_id)->io_cmd_buf;
+}
+
+static inline int ubd_queue_cmd_buf_size(struct ubd_device *ub, int q_id)
+{
+	struct ubd_queue *ubq = ubd_get_queue(ub, q_id);
+
+	return round_up(ubq->q_depth * sizeof(struct ubdsrv_io_desc), PAGE_SIZE);
+}
+
+static int ubd_open(struct block_device *bdev, fmode_t mode)
+{
+	return 0;
+}
+
+static void ubd_release(struct gendisk *disk, fmode_t mode)
+{
+}
+
+static const struct block_device_operations ub_fops = {
+	.owner =	THIS_MODULE,
+	.open =		ubd_open,
+	.release =	ubd_release,
+};
+
+#define UBD_MAX_PIN_PAGES	32
+
+static void ubd_release_pages(struct ubd_device *ub, struct page **pages,
+		int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		put_page(pages[i]);
+}
+
+static int ubd_pin_user_pages(struct ubd_device *ub, u64 start_vm,
+		struct page **pages, unsigned int nr_pages, bool to_rq)
+{
+	unsigned int gup_flags = to_rq ? 0 : FOLL_WRITE;
+
+	return get_user_pages_fast(start_vm, nr_pages, gup_flags, pages);
+}
+
+static inline unsigned ubd_copy_bv(struct bio_vec *bv, void **bv_addr,
+		void *pg_addr, unsigned int *pg_off,
+		unsigned int *pg_len, bool to_bv)
+{
+	unsigned len = min_t(unsigned, bv->bv_len, *pg_len);
+
+	if (*bv_addr == NULL)
+		*bv_addr = kmap_local_page(bv->bv_page);
+
+	if (to_bv)
+		memcpy(*bv_addr + bv->bv_offset, pg_addr + *pg_off, len);
+	else
+		memcpy(pg_addr + *pg_off, *bv_addr + bv->bv_offset, len);
+
+	bv->bv_offset += len;
+	bv->bv_len -= len;
+	*pg_off += len;
+	*pg_len -= len;
+
+	if (!bv->bv_len) {
+		kunmap_local(*bv_addr);
+		*bv_addr = NULL;
+	}
+
+	return len;
+}
+
+/* copy rq pages to ubdsrv vm address pointed by io->addr */
+static int ubd_copy_pages(struct ubd_device *ub, struct request *rq)
+{
+	struct ubd_queue *ubq = rq->mq_hctx->driver_data;
+	struct ubd_io *io = &ubq->ios[rq->tag];
+	struct page *pgs[UBD_MAX_PIN_PAGES];
+	const bool to_rq = !op_is_write(rq->cmd_flags);
+	struct req_iterator req_iter;
+	struct bio_vec bv;
+	unsigned long start = io->addr, left = rq->__data_len;
+	unsigned int idx = 0, pg_len = 0, pg_off = 0;
+	int nr_pin = 0;
+	void *pg_addr = NULL;
+	struct page *curr = NULL;
+
+	rq_for_each_segment(bv, rq, req_iter) {
+		unsigned len, bv_off = bv.bv_offset, bv_len = bv.bv_len;
+		void *bv_addr = NULL;
+
+refill:
+		if (pg_len == 0) {
+			unsigned int off = 0;
+
+			if (pg_addr) {
+				kunmap_local(pg_addr);
+				if (!to_rq)
+					set_page_dirty_lock(curr);
+				pg_addr = NULL;
+			}
+
+			/* refill pages */
+			if (idx >= nr_pin) {
+				unsigned int max_pages;
+
+				ubd_release_pages(ub, pgs, nr_pin);
+
+				off = start & (PAGE_SIZE - 1);
+				max_pages = round_up(off + left, PAGE_SIZE);
+				nr_pin = min_t(unsigned, UBD_MAX_PIN_PAGES, max_pages);
+				nr_pin = ubd_pin_user_pages(ub, start, pgs,
+						nr_pin, to_rq);
+				if (nr_pin < 0)
+					return nr_pin;
+				idx = 0;
+			}
+			pg_off = off;
+			pg_len = min(PAGE_SIZE - off, left);
+			off = 0;
+			curr = pgs[idx++];
+			pg_addr = kmap_local_page(curr);
+		}
+
+		len = ubd_copy_bv(&bv, &bv_addr, pg_addr, &pg_off, &pg_len,
+				to_rq);
+		/* either one of the two has been consumed */
+		WARN_ON_ONCE(bv.bv_len && pg_len);
+		start += len;
+		left -= len;
+
+		/* overflow */
+		WARN_ON_ONCE(left > rq->__data_len);
+		WARN_ON_ONCE(bv.bv_len > bv_len);
+		if (bv.bv_len)
+			goto refill;
+
+		bv.bv_len = bv_len;
+		bv.bv_offset = bv_off;
+	}
+	if (pg_addr) {
+		kunmap_local(pg_addr);
+		if (!to_rq)
+			set_page_dirty_lock(curr);
+	}
+	ubd_release_pages(ub, pgs, nr_pin);
+
+	WARN_ON_ONCE(left != 0);
+
+	return 0;
+}
+
+#define UBD_REMAP_BATCH	32
+
+static int ubd_map_io(struct ubd_device *ub, struct request *req)
+{
+	/*
+	 * no zero copy, we delay copy WRITE request data into ubdsrv
+	 * context via task_work_add and the big benefit is that pinning
+	 * pages in current context is pretty fast, see ubd_pin_user_pages
+	 */
+	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
+		return 0;
+
+	if (!ubd_rq_need_copy(req))
+		return 0;
+
+	/* convert to data copy in current context */
+	return ubd_copy_pages(ub, req);
+}
+
+static int ubd_unmap_io(struct request *req, struct ubd_io *io)
+{
+	struct ubd_device *ub = req->q->queuedata;
+
+	if (req_op(req) == REQ_OP_READ && ubd_rq_need_copy(req)) {
+		WARN_ON_ONCE(io->res > req->__data_len);
+
+		if (io->res > 0 && io->res < req->__data_len)
+			pr_err_once("%s: short read, expected %u, got %d\n",
+					__func__, req->__data_len, io->res);
+
+		return ubd_copy_pages(ub, req);
+	}
+	return 0;
+}
+
+static inline unsigned int ubd_req_build_flags(struct request *req)
+{
+	unsigned flags = 0;
+
+	if (req->cmd_flags & REQ_FAILFAST_DEV)
+		flags |= UBD_IO_F_FAILFAST_DEV;
+
+	if (req->cmd_flags & REQ_FAILFAST_TRANSPORT)
+		flags |= UBD_IO_F_FAILFAST_TRANSPORT;
+
+	if (req->cmd_flags & REQ_FAILFAST_DRIVER)
+		flags |= UBD_IO_F_FAILFAST_DRIVER;
+
+	if (req->cmd_flags & REQ_META)
+		flags |= UBD_IO_F_META;
+
+	if (req->cmd_flags & REQ_INTEGRITY)
+		flags |= UBD_IO_F_INTEGRITY;
+
+	if (req->cmd_flags & REQ_FUA)
+		flags |= UBD_IO_F_FUA;
+
+	if (req->cmd_flags & REQ_PREFLUSH)
+		flags |= UBD_IO_F_PREFLUSH;
+
+	if (req->cmd_flags & REQ_NOUNMAP)
+		flags |= UBD_IO_F_NOUNMAP;
+
+	if (req->cmd_flags & REQ_SWAP)
+		flags |= UBD_IO_F_SWAP;
+
+	return flags;
+}
+
+static int ubd_setup_iod(struct ubd_queue *ubq, struct request *req)
+{
+	struct ubdsrv_io_desc *iod = ubd_get_iod(ubq, req->tag);
+	struct ubd_io *io = &ubq->ios[req->tag];
+	u32 ubd_op;
+
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+		ubd_op = UBD_IO_OP_READ;
+		break;
+	case REQ_OP_WRITE:
+		ubd_op = UBD_IO_OP_WRITE;
+		break;
+	case REQ_OP_FLUSH:
+		ubd_op = UBD_IO_OP_FLUSH;
+		break;
+	case REQ_OP_DISCARD:
+		ubd_op = UBD_IO_OP_DISCARD;
+		break;
+	case REQ_OP_WRITE_ZEROES:
+		ubd_op = UBD_IO_OP_WRITE_ZEROES;
+		break;
+	default:
+		return BLK_STS_IOERR;
+	}
+
+	/* need to translate since kernel may change */
+	iod->op_flags = ubd_op | ubd_req_build_flags(req);
+	iod->nr_sectors = blk_rq_sectors(req);
+	iod->start_sector = blk_rq_pos(req);
+	iod->addr = io->addr;
+
+	return BLK_STS_OK;
+}
+
+static blk_status_t ubd_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct ubd_queue *ubq = hctx->driver_data;
+	struct request *rq = bd->rq;
+	struct ubd_rq_data *data = blk_mq_rq_to_pdu(rq);
+	enum task_work_notify_mode notify_mode = bd->last ?
+		TWA_SIGNAL_NO_IPI : TWA_NONE;
+	blk_status_t res;
+
+	/* fill iod to slot in io cmd buffer */
+	res = ubd_setup_iod(ubq, rq);
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
+		struct ubd_device *ub = rq->q->queuedata;
+
+		mod_delayed_work(system_wq, &ub->monitor_work, 0);
+		return BLK_STS_IOERR;
+	}
+
+	return BLK_STS_OK;
+}
+
+static bool ubq_daemon_is_dying(struct ubd_queue *ubq)
+{
+	return ubq->ubq_daemon->flags & PF_EXITING;
+}
+
+static void ubd_commit_rqs(struct blk_mq_hw_ctx *hctx)
+{
+	struct ubd_queue *ubq = hctx->driver_data;
+
+	__set_notify_signal(ubq->ubq_daemon);
+	if (ubq_daemon_is_dying(ubq)) {
+		struct ubd_device *ub = hctx->queue->queuedata;
+
+		mod_delayed_work(system_wq, &ub->monitor_work, 0);
+	}
+}
+
+/* todo: handle partial completion */
+static void ubd_complete_rq(struct request *req)
+{
+	struct ubd_queue *ubq = req->mq_hctx->driver_data;
+	struct ubd_io *io = &ubq->ios[req->tag];
+
+	/* for READ request, writing data in iod->addr to rq buffers */
+	ubd_unmap_io(req, io);
+
+	blk_mq_end_request(req, io->res >= 0 ? BLK_STS_OK :
+			errno_to_blk_status(io->res));
+}
+
+/*
+ * __ubd_fail_req() may be called from abort context or ->ubq_daemon
+ * context during exiting, so lock is required.
+ *
+ * Also aborting may not be started yet, keep in mind that one failed
+ * request may be issued by block layer again.
+ */
+static void __ubd_fail_req(struct ubd_io *io, struct request *req)
+{
+	WARN_ON_ONCE(io->flags & UBD_IO_FLAG_ACTIVE);
+
+	if (!(io->flags & UBD_IO_FLAG_REQ_FAILED)) {
+		io->flags |= UBD_IO_FLAG_REQ_FAILED;
+		blk_mq_end_request(req, BLK_STS_IOERR);
+	}
+}
+
+static void ubd_rq_task_work_fn(struct callback_head *work)
+{
+	bool task_exiting = !!(current->flags & PF_EXITING);
+	struct ubd_rq_data *data = container_of(work,
+			struct ubd_rq_data, work);
+	struct request *req = blk_mq_rq_from_pdu(data);
+	struct ubd_queue *ubq = req->mq_hctx->driver_data;
+	struct ubd_io *io = &ubq->ios[req->tag];
+	struct ubd_device *ub = req->q->queuedata;
+	int ret;
+
+	pr_devel("%s: complete: op %d, qid %d tag %d ret %d io_flags %x addr %llx\n",
+			__func__, io->cmd->cmd_op, ubq->q_id,  req->tag, ret, io->flags,
+			ubd_get_iod(ubq, req->tag)->addr);
+
+	/*
+	 * If task is exiting, we may be run from exit_task_work() in
+	 * do_exit(), and may race with ubd_abort_queue(), so lock is
+	 * needed.
+	 */
+	if (unlikely(task_exiting)) {
+		ret = -ESRCH;
+		spin_lock(&ubq->abort_lock);
+	} else {
+		ret = ubd_map_io(ub, req);
+	}
+
+	/*
+	 * Or abort isn't started, but the request is re-issued after being
+	 * failed, we still need to fail it one more time.
+         */
+	if (unlikely(io->flags & UBD_IO_FLAG_REQ_FAILED)) {
+		blk_mq_end_request(req, BLK_STS_IOERR);
+		if (task_exiting)
+			spin_unlock(&ubq->abort_lock);
+		return;
+	}
+
+	/* mark this cmd owned by ubdsrv */
+	io->flags |= UBD_IO_FLAG_OWNED_BY_SRV;
+
+	/*
+	 * clear ACTIVE since we are done with this sqe/cmd slot
+	 * We can only accept io cmd in case of being not active.
+	 */
+	io->flags &= ~UBD_IO_FLAG_ACTIVE;
+
+	/* tell ubdsrv one io request is coming */
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
+static int ubd_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
+		unsigned int hctx_idx)
+{
+	struct ubd_device *ub = hctx->queue->queuedata;
+	struct ubd_queue *ubq = ubd_get_queue(ub, hctx->queue_num);
+
+	hctx->driver_data = ubq;
+	return 0;
+}
+
+static int ubd_init_rq(struct blk_mq_tag_set *set, struct request *req,
+		unsigned int hctx_idx, unsigned int numa_node)
+{
+	struct ubd_rq_data *data = blk_mq_rq_to_pdu(req);
+
+	init_task_work(&data->work, ubd_rq_task_work_fn);
+
+	return 0;
+}
+
+static const struct blk_mq_ops ubd_mq_ops = {
+	.queue_rq       = ubd_queue_rq,
+	.commit_rqs     = ubd_commit_rqs,
+	.init_hctx	= ubd_init_hctx,
+	.init_request	= ubd_init_rq,
+};
+
+static int ubd_ch_open(struct inode *inode, struct file *filp)
+{
+	struct ubd_device *ub = container_of(inode->i_cdev,
+			struct ubd_device, cdev);
+
+	if (atomic_cmpxchg(&ub->ch_open_cnt, 0, 1) == 0) {
+		filp->private_data = ub;
+		return 0;
+	}
+	return -EBUSY;
+}
+
+static int ubd_ch_release(struct inode *inode, struct file *filp)
+{
+	struct ubd_device *ub = filp->private_data;
+
+	while (atomic_cmpxchg(&ub->ch_open_cnt, 1, 0) != 1)
+		cpu_relax();
+
+	filp->private_data = NULL;
+	return 0;
+}
+
+/* map pre-allocated per-queue cmd buffer to ubdsrv daemon */
+static int ubd_ch_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct ubd_device *ub = filp->private_data;
+	size_t sz = vma->vm_end - vma->vm_start;
+	unsigned max_sz = UBD_MAX_QUEUE_DEPTH * sizeof(struct ubdsrv_io_desc);
+	unsigned long pfn, end, phys_off = vma->vm_pgoff << PAGE_SHIFT;
+	int q_id;
+
+	end = UBDSRV_CMD_BUF_OFFSET + ub->dev_info.nr_hw_queues * max_sz;
+	if (phys_off < UBDSRV_CMD_BUF_OFFSET || phys_off >= end)
+		return -EINVAL;
+
+	q_id = (phys_off - UBDSRV_CMD_BUF_OFFSET) / max_sz;
+	pr_devel("%s: qid %d, pid %d, addr %lx pg_off %lx sz %lu\n",
+			__func__, q_id, current->pid, vma->vm_start,
+			phys_off, (unsigned long)sz);
+
+	if (sz != ubd_queue_cmd_buf_size(ub, q_id))
+		return -EINVAL;
+
+	pfn = virt_to_phys(ubd_queue_cmd_buf(ub, q_id)) >> PAGE_SHIFT;
+	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
+}
+
+static void ubd_commit_completion(struct ubd_device *ub,
+		struct ubdsrv_io_cmd *ub_cmd)
+{
+	u32 qid = ub_cmd->q_id, tag = ub_cmd->tag;
+	struct ubd_queue *ubq = ubd_get_queue(ub, qid);
+	struct ubd_io *io = &ubq->ios[tag];
+	struct request *req;
+
+	/* now this cmd slot is owned by nbd driver */
+	io->flags &= ~UBD_IO_FLAG_OWNED_BY_SRV;
+	io->res = ub_cmd->result;
+
+	/* find the io request and complete */
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[qid], tag);
+
+	if (req && likely(!blk_should_fake_timeout(req->q)))
+		ubd_complete_rq(req);
+}
+
+/*
+ * Focus on aborting any in-flight request scheduled to run via task work
+ */
+static void __ubd_abort_queue(struct ubd_device *ub, struct ubd_queue *ubq)
+{
+	bool task_exiting = !!(ubq->ubq_daemon->flags & PF_EXITING);
+	int i;
+
+	for (i = 0; i < ubq->q_depth; i++) {
+		struct ubd_io *io = &ubq->ios[i];
+
+		if (!(io->flags & UBD_IO_FLAG_ACTIVE) && task_exiting) {
+			struct request *rq;
+
+			/*
+			 * Either we fail the request or ubd_rq_task_work_fn
+			 * will do it
+			 */
+			rq = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], i);
+			if (rq)
+				__ubd_fail_req(io, rq);
+		}
+	}
+	ubq->abort_work_pending = false;
+	blk_put_queue(ub->ub_queue);
+}
+
+static void ubd_queue_task_work_fn(struct callback_head *work)
+{
+	struct ubd_queue *ubq = container_of(work, struct ubd_queue,
+			abort_work);
+
+	/*
+	 * Lock is only required in case of exiting ubq_daemon, but harmless
+	 * to grab it for running from task work too
+	 *
+	 * We are serialized with ubd_rq_task_work_fn() strictly.
+	 */
+	spin_lock(&ubq->abort_lock);
+	__ubd_abort_queue(ubq->dev, ubq);
+	spin_unlock(&ubq->abort_lock);
+}
+
+
+static void ubd_abort_queue(struct ubd_device *ub, struct ubd_queue *ubq)
+{
+	if (!blk_get_queue(ub->ub_queue))
+		return;
+
+	spin_lock(&ubq->abort_lock);
+	if (!ubq->abort_work_pending) {
+		if (task_work_add(ubq->ubq_daemon, &ubq->abort_work,
+					TWA_SIGNAL))
+			__ubd_abort_queue(ub, ubq);
+		else
+			ubq->abort_work_pending = true;
+	}
+	spin_unlock(&ubq->abort_lock);
+}
+
+static void ubd_release_queues(struct ubd_device *ub)
+{
+	int i;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		struct ubd_queue *ubq = ubd_get_queue(ub, i);
+
+		put_task_struct(ubq->ubq_daemon);
+		ubq->ubq_daemon = NULL;
+	}
+}
+
+static void ubd_cancel_queue(struct ubd_queue *ubq)
+{
+	int i;
+
+	for (i = 0; i < ubq->q_depth; i++) {
+		struct ubd_io *io = &ubq->ios[i];
+
+		if (io->flags & UBD_IO_FLAG_ACTIVE) {
+			io->flags &= ~UBD_IO_FLAG_ACTIVE;
+			io_uring_cmd_done(io->cmd, UBD_IO_RES_ABORT, 0);
+		}
+	}
+}
+
+/* Cancel all pending commands, must be called after del_gendisk() returns */
+static void ubd_cancel_dev(struct ubd_device *ub)
+{
+	int i;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
+		ubd_cancel_queue(ubd_get_queue(ub, i));
+}
+
+static void ubd_stop_dev(struct ubd_device *ub)
+{
+	mutex_lock(&ub->mutex);
+	if (!disk_live(ub->ub_disk))
+		goto unlock;
+
+	del_gendisk(ub->ub_disk);
+	ub->dev_info.state = UBD_S_DEV_DEAD;
+	ub->dev_info.ubdsrv_pid = -1;
+	ubd_cancel_dev(ub);
+ unlock:
+	mutex_unlock(&ub->mutex);
+	cancel_delayed_work_sync(&ub->monitor_work);
+}
+
+static int ubd_ctrl_stop_dev(struct ubd_device *ub)
+{
+	ubd_stop_dev(ub);
+	return 0;
+}
+
+static inline bool ubd_queue_ready(struct ubd_queue *ubq)
+{
+	return ubq->nr_io_ready == ubq->q_depth;
+}
+
+/* device can only be started after all IOs are ready */
+static void ubd_mark_io_ready(struct ubd_device *ub, struct ubd_queue *ubq)
+{
+	mutex_lock(&ub->mutex);
+	ubq->nr_io_ready++;
+	if (ubd_queue_ready(ubq)) {
+		ubq->ubq_daemon = current;
+		get_task_struct(ubq->ubq_daemon);
+		ub->nr_queues_ready++;
+	}
+	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
+		complete_all(&ub->completion);
+	mutex_unlock(&ub->mutex);
+}
+
+static int ubd_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct ubdsrv_io_cmd *ub_cmd = (struct ubdsrv_io_cmd *)cmd->cmd;
+	struct ubd_device *ub = cmd->file->private_data;
+	struct ubd_queue *ubq;
+	struct ubd_io *io;
+	u32 cmd_op = cmd->cmd_op;
+	unsigned tag = ub_cmd->tag;
+	int ret = -EINVAL;
+
+	pr_devel("%s: receieved: cmd op %d queue %d tag %d result %d\n",
+			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
+			ub_cmd->result);
+
+	if (!(issue_flags & IO_URING_F_SQE128))
+		goto out;
+
+	ubq = ubd_get_queue(ub, ub_cmd->q_id);
+	if (!ubq || ub_cmd->q_id != ubq->q_id)
+		goto out;
+
+	if (WARN_ON_ONCE(tag >= ubq->q_depth))
+		goto out;
+
+	io = &ubq->ios[tag];
+
+	/* there is pending io cmd, something must be wrong */
+	if (io->flags & UBD_IO_FLAG_ACTIVE) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	switch (cmd_op) {
+	case UBD_IO_FETCH_REQ:
+		/* UBD_IO_FETCH_REQ is only allowed before queue is setup */
+		if (WARN_ON_ONCE(ubd_queue_ready(ubq))) {
+			ret = -EBUSY;
+			goto out;
+		}
+		/*
+		 * The io is being handled by server, so COMMIT_RQ is expected
+		 * instead of FETCH_REQ
+		 */
+		if (io->flags & UBD_IO_FLAG_OWNED_BY_SRV)
+			goto out;
+		/* FETCH_RQ has to provide IO buffer */
+		if (!ub_cmd->addr)
+			goto out;
+		io->cmd = cmd;
+		io->flags |= UBD_IO_FLAG_ACTIVE;
+		io->addr = ub_cmd->addr;
+
+		ubd_mark_io_ready(ub, ubq);
+		break;
+	case UBD_IO_COMMIT_AND_FETCH_REQ:
+		/* FETCH_RQ has to provide IO buffer */
+		if (!ub_cmd->addr)
+			goto out;
+		io->addr = ub_cmd->addr;
+		io->flags |= UBD_IO_FLAG_ACTIVE;
+		fallthrough;
+	case UBD_IO_COMMIT_REQ:
+		io->cmd = cmd;
+		if (!(io->flags & UBD_IO_FLAG_OWNED_BY_SRV))
+			goto out;
+		ubd_commit_completion(ub, ub_cmd);
+
+		/* COMMIT_REQ is supposed to not fetch req */
+		if (cmd_op == UBD_IO_COMMIT_REQ) {
+			ret = UBD_IO_RES_OK;
+			goto out;
+		}
+		break;
+	default:
+		goto out;
+	}
+	return -EIOCBQUEUED;
+
+ out:
+	io->flags &= ~UBD_IO_FLAG_ACTIVE;
+	io_uring_cmd_done(cmd, ret, 0);
+	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
+			__func__, cmd_op, tag, ret, io->flags);
+	return -EIOCBQUEUED;
+}
+
+static const struct file_operations ubd_ch_fops = {
+	.owner = THIS_MODULE,
+	.open = ubd_ch_open,
+	.release = ubd_ch_release,
+	.llseek = no_llseek,
+	.uring_cmd = ubd_ch_uring_cmd,
+	.mmap = ubd_ch_mmap,
+};
+
+static void ubd_deinit_queue(struct ubd_device *ub, int q_id)
+{
+	int size = ubd_queue_cmd_buf_size(ub, q_id);
+	struct ubd_queue *ubq = ubd_get_queue(ub, q_id);
+
+	if (ubq->io_cmd_buf)
+		free_pages((unsigned long)ubq->io_cmd_buf, get_order(size));
+}
+
+static int ubd_init_queue(struct ubd_device *ub, int q_id)
+{
+	struct ubd_queue *ubq = ubd_get_queue(ub, q_id);
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO;
+	void *ptr;
+	int size;
+
+	ubq->q_id = q_id;
+	ubq->q_depth = ub->dev_info.queue_depth;
+	size = ubd_queue_cmd_buf_size(ub, q_id);
+
+	ptr = (void *) __get_free_pages(gfp_flags, get_order(size));
+	if (!ptr)
+		return -ENOMEM;
+
+	init_task_work(&ubq->abort_work, ubd_queue_task_work_fn);
+	ubq->io_cmd_buf = ptr;
+	ubq->dev = ub;
+	spin_lock_init(&ubq->abort_lock);
+	return 0;
+}
+
+static void ubd_deinit_queues(struct ubd_device *ub)
+{
+	int nr_queues = ub->dev_info.nr_hw_queues;
+	int i;
+
+	if (!ub->__queues)
+		return;
+
+	for (i = 0; i < nr_queues; i++)
+		ubd_deinit_queue(ub, i);
+	kfree(ub->__queues);
+}
+
+static int ubd_init_queues(struct ubd_device *ub)
+{
+	int nr_queues = ub->dev_info.nr_hw_queues;
+	int depth = ub->dev_info.queue_depth;
+	int ubq_size = sizeof(struct ubd_queue) + depth * sizeof(struct ubd_io);
+	int i, ret = -ENOMEM;
+
+	ub->queue_size = ubq_size;
+	ub->__queues = kcalloc(nr_queues, ubq_size, GFP_KERNEL);
+	if (!ub->__queues)
+		return ret;
+
+	for (i = 0; i < nr_queues; i++) {
+		if (ubd_init_queue(ub, i))
+			goto fail;
+	}
+
+	init_completion(&ub->completion);
+	return 0;
+
+ fail:
+	ubd_deinit_queues(ub);
+	return ret;
+}
+
+static void ubd_cdev_rel(struct device *dev)
+{
+	struct ubd_device *ub = container_of(dev, struct ubd_device, cdev_dev);
+
+	blk_mq_free_tag_set(&ub->tag_set);
+	mutex_lock(&ubd_ctl_mutex);
+	idr_remove(&ubd_index_idr, ub->ub_number);
+	mutex_unlock(&ubd_ctl_mutex);
+
+	ubd_deinit_queues(ub);
+
+	kfree(ub);
+}
+
+static int ubd_add_chdev(struct ubd_device *ub)
+{
+	struct device *dev = &ub->cdev_dev;
+	int minor = ub->ub_number;
+	int ret;
+
+	dev->parent = ubd_misc.this_device;
+	ret = dev_set_name(dev, "ubdc%d", minor);
+	if (ret)
+		return ret;
+
+	dev->devt = MKDEV(MAJOR(ubd_chr_devt), minor);
+	dev->class = ubd_chr_class;
+	dev->release = ubd_cdev_rel;
+	device_initialize(dev);
+
+	cdev_init(&ub->cdev, &ubd_ch_fops);
+	ret = cdev_device_add(&ub->cdev, dev);
+	if (ret) {
+		put_device(dev);
+		return -1;
+	}
+	return 0;
+}
+
+/* add disk & cdev */
+static int ubd_add_dev(struct ubd_device *ub)
+{
+	unsigned int max_rq_bytes;
+	struct gendisk *disk;
+	int err = -ENOMEM;
+	int bsize;
+
+	/* We are not ready to support zero copy */
+	ub->dev_info.flags[0] &= ~(1ULL << UBD_F_SUPPORT_ZERO_COPY);
+
+	bsize = ub->dev_info.block_size;
+	ub->bs_shift = ilog2(bsize);
+
+	ub->dev_info.nr_hw_queues = min_t(unsigned int,
+			ub->dev_info.nr_hw_queues, nr_cpu_ids);
+
+	/* make max request buffer size aligned with PAGE_SIZE */
+	max_rq_bytes = round_down(ub->dev_info.rq_max_blocks <<
+			ub->bs_shift, PAGE_SIZE);
+	ub->dev_info.rq_max_blocks = max_rq_bytes >> ub->bs_shift;
+
+	if (ubd_init_queues(ub))
+		return err;
+
+	ub->tag_set.ops = &ubd_mq_ops;
+	ub->tag_set.nr_hw_queues = ub->dev_info.nr_hw_queues;
+	ub->tag_set.queue_depth = ub->dev_info.queue_depth;
+	ub->tag_set.numa_node = NUMA_NO_NODE;
+	ub->tag_set.cmd_size = sizeof(struct ubd_rq_data);
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
+	set_capacity(ub->ub_disk, ub->dev_info.dev_blocks << (ub->bs_shift - 9));
+
+	ub->ub_queue->limits.discard_granularity = PAGE_SIZE;
+
+	blk_queue_max_discard_sectors(ub->ub_queue, UINT_MAX >> 9);
+	blk_queue_max_write_zeroes_sectors(ub->ub_queue, UINT_MAX >> 9);
+	blk_queue_flag_set(QUEUE_FLAG_DISCARD, ub->ub_queue);
+
+	disk->fops		= &ub_fops;
+	disk->private_data	= ub;
+	disk->queue		= ub->ub_queue;
+	sprintf(disk->disk_name, "ubdb%d", ub->ub_number);
+
+	mutex_init(&ub->mutex);
+
+	/* add char dev so that ubdsrv daemon can be setup */
+	err = ubd_add_chdev(ub);
+	if (err)
+		goto out_cleanup_disk;
+
+	/* don't expose disk now until we got start command from cdev */
+
+	return 0;
+
+out_cleanup_disk:
+	blk_cleanup_disk(ub->ub_disk);
+out_cleanup_tags:
+	blk_mq_free_tag_set(&ub->tag_set);
+out_deinit_queues:
+	ubd_deinit_queues(ub);
+	return err;
+}
+
+static void ubd_remove(struct ubd_device *ub)
+{
+	ubd_ctrl_stop_dev(ub);
+
+	blk_cleanup_queue(ub->ub_queue);
+	ubd_release_queues(ub);
+	put_disk(ub->ub_disk);
+
+	cdev_device_del(&ub->cdev, &ub->cdev_dev);
+	put_device(&ub->cdev_dev);
+}
+
+static struct ubd_device *ubd_find_device(int idx)
+{
+	struct ubd_device *ub = NULL;
+
+	if (idx < 0) {
+		pr_warn_once("deleting an unspecified ubd device is not supported.\n");
+		return NULL;
+	}
+
+	if (mutex_lock_killable(&ubd_ctl_mutex))
+		return NULL;
+	ub = idr_find(&ubd_index_idr, idx);
+	mutex_unlock(&ubd_ctl_mutex);
+
+	return ub;
+}
+
+static int __ubd_alloc_dev_number(struct ubd_device *ub, int idx)
+{
+	int i = idx;
+	int err;
+
+	/* allocate id, if @id >= 0, we're requesting that specific id */
+	if (i >= 0) {
+		err = idr_alloc(&ubd_index_idr, ub, i, i + 1, GFP_KERNEL);
+		if (err == -ENOSPC)
+			err = -EEXIST;
+	} else {
+		err = idr_alloc(&ubd_index_idr, ub, 0, 0, GFP_KERNEL);
+	}
+
+	if (err >= 0)
+		ub->ub_number = err;
+
+	return err;
+}
+
+static struct ubd_device *ubd_create_dev(int idx)
+{
+	struct ubd_device *ub = NULL;
+	int ret;
+
+	ub = kzalloc(sizeof(*ub), GFP_KERNEL);
+	if (!ub)
+		return ERR_PTR(-ENOMEM);
+
+	ret = mutex_lock_killable(&ubd_ctl_mutex);
+	if (ret)
+		goto free_mem;
+
+	if (idx >= 0 && idr_find(&ubd_index_idr, idx)) {
+		ret = -EEXIST;
+		goto unlock;
+	}
+
+	ret = __ubd_alloc_dev_number(ub, idx);
+unlock:
+	mutex_unlock(&ubd_ctl_mutex);
+free_mem:
+	if (ret < 0) {
+		kfree(ub);
+		return ERR_PTR(ret);
+	}
+	return ub;
+}
+
+static void ubd_stop_work_fn(struct work_struct *work)
+{
+	struct ubd_device *ub =
+		container_of(work, struct ubd_device, stop_work);
+
+	ubd_stop_dev(ub);
+}
+
+static void ubd_daemon_monitor_work(struct work_struct *work)
+{
+	struct ubd_device *ub =
+		container_of(work, struct ubd_device, monitor_work.work);
+	int i;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		struct ubd_queue *ubq = ubd_get_queue(ub, i);
+
+		if (ubq_daemon_is_dying(ubq)) {
+			schedule_work(&ub->stop_work);
+
+			/* abort queue is for making forward progress */
+			ubd_abort_queue(ub, ubq);
+		}
+	}
+
+	schedule_delayed_work(&ub->monitor_work, UBD_DAEMON_MONITOR_PERIOD);
+}
+
+static int ubd_ctrl_start_dev(struct ubd_device *ub, struct io_uring_cmd *cmd)
+{
+	struct ubdsrv_ctrl_cmd *header = (struct ubdsrv_ctrl_cmd *)cmd->cmd;
+	int ret = -EINVAL;
+	int ubdsrv_pid = (int)header->data[0];
+
+	if (ubdsrv_pid <= 0)
+		return ret;
+
+	wait_for_completion_interruptible(&ub->completion);
+
+	INIT_WORK(&ub->stop_work, ubd_stop_work_fn);
+	INIT_DELAYED_WORK(&ub->monitor_work, ubd_daemon_monitor_work);
+	schedule_delayed_work(&ub->monitor_work, UBD_DAEMON_MONITOR_PERIOD);
+
+	mutex_lock(&ub->mutex);
+	if (!disk_live(ub->ub_disk)) {
+		ub->dev_info.ubdsrv_pid = ubdsrv_pid;
+		ret = add_disk(ub->ub_disk);
+		if (!ret)
+			ub->dev_info.state = UBD_S_DEV_LIVE;
+	} else {
+		ret = -EEXIST;
+	}
+	mutex_unlock(&ub->mutex);
+
+	return ret;
+}
+
+static struct blk_mq_hw_ctx *ubd_get_hw_queue(struct ubd_device *ub,
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
+static inline void ubd_dump_dev_info(struct ubdsrv_ctrl_dev_info *info)
+{
+	pr_devel("%s: dev id %d flags %llx\n", __func__,
+			info->dev_id, info->flags[0]);
+	pr_devel("\t nr_hw_queues %d queue_depth %d block size %d dev_capacity %lld\n",
+			info->nr_hw_queues, info->queue_depth,
+			info->block_size, info->dev_blocks);
+}
+
+static inline void ubd_ctrl_cmd_dump(struct io_uring_cmd *cmd)
+{
+	struct ubdsrv_ctrl_cmd *header = (struct ubdsrv_ctrl_cmd *)cmd->cmd;
+
+	pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len %u\n",
+			__func__, cmd->cmd_op, header->dev_id, header->queue_id,
+			header->data[0], header->addr, header->len);
+}
+
+static int ubd_ctrl_cmd_validate(struct io_uring_cmd *cmd,
+		struct ubdsrv_ctrl_dev_info *info)
+{
+	struct ubdsrv_ctrl_cmd *header = (struct ubdsrv_ctrl_cmd *)cmd->cmd;
+	u32 cmd_op = cmd->cmd_op;
+	void __user *argp = (void __user *)(unsigned long)header->addr;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (cmd_op) {
+	case UBD_CMD_GET_DEV_INFO:
+		if (header->len < sizeof(*info) || !header->addr)
+			return -EINVAL;
+		break;
+	case UBD_CMD_ADD_DEV:
+		if (header->len < sizeof(*info) || !header->addr)
+			return -EINVAL;
+		if (copy_from_user(info, argp, sizeof(*info)) != 0)
+			return -EFAULT;
+		ubd_dump_dev_info(info);
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
+	case UBD_CMD_GET_QUEUE_AFFINITY:
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
+static int ubd_ctrl_uring_cmd(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	struct ubdsrv_ctrl_cmd *header = (struct ubdsrv_ctrl_cmd *)cmd->cmd;
+	void __user *argp = (void __user *)(unsigned long)header->addr;
+	struct ubdsrv_ctrl_dev_info info;
+	struct blk_mq_hw_ctx *hctx;
+	u32 cmd_op = cmd->cmd_op;
+	struct ubd_device *ub;
+	unsigned long queue;
+	unsigned int retlen;
+	int ret = -EINVAL;
+
+	ubd_ctrl_cmd_dump(cmd);
+
+	if (!(issue_flags & IO_URING_F_SQE128))
+		goto out;
+
+	ret = ubd_ctrl_cmd_validate(cmd, &info);
+	if (ret)
+		goto out;
+
+	ret = -ENODEV;
+	switch (cmd_op) {
+	case UBD_CMD_START_DEV:
+		ub = ubd_find_device(header->dev_id);
+		if (!ub)
+			goto out;
+		if (!ubd_ctrl_start_dev(ub, cmd))
+			ret = 0;
+		break;
+	case UBD_CMD_STOP_DEV:
+		ub = ubd_find_device(header->dev_id);
+		if (!ub)
+			goto out;
+		if (!ubd_ctrl_stop_dev(ub))
+			ret = 0;
+		break;
+	case UBD_CMD_GET_DEV_INFO:
+		ub = ubd_find_device(header->dev_id);
+		if (ub) {
+			if (copy_to_user(argp, &ub->dev_info, sizeof(info)))
+				ret = -EFAULT;
+			else
+				ret = 0;
+		}
+		break;
+	case UBD_CMD_ADD_DEV:
+		ub = ubd_create_dev(header->dev_id);
+		if (!IS_ERR_OR_NULL(ub)) {
+			memcpy(&ub->dev_info, &info, sizeof(info));
+
+			/* update device id */
+			ub->dev_info.dev_id = ub->ub_number;
+
+			if (ubd_add_dev(ub) || copy_to_user(argp,
+						&ub->dev_info, sizeof(info)))
+				ubd_remove(ub);
+			else {
+				ret = 0;
+			}
+		}
+		break;
+	case UBD_CMD_DEL_DEV:
+		ub = ubd_find_device(header->dev_id);
+		if (ub) {
+			ubd_remove(ub);
+			ret = 0;
+		}
+		break;
+	case UBD_CMD_GET_QUEUE_AFFINITY:
+		ub = ubd_find_device(header->dev_id);
+		if (!ub)
+			goto out;
+
+		ret = -EINVAL;
+		queue = header->data[0];
+		if (queue >= ub->dev_info.nr_hw_queues)
+			goto out;
+		hctx = ubd_get_hw_queue(ub, queue);
+		if (!hctx)
+			goto out;
+
+		retlen = min_t(unsigned short, header->len, cpumask_size());
+		if (copy_to_user(argp, hctx->cpumask, retlen)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (retlen != header->len) {
+			if (clear_user(argp + retlen, header->len - retlen)) {
+				ret = -EFAULT;
+				goto out;
+			}
+		}
+		ret = 0;
+		break;
+	default:
+		break;
+	};
+ out:
+	io_uring_cmd_done(cmd, ret, 0);
+	return -EIOCBQUEUED;
+}
+
+static const struct file_operations ubd_ctl_fops = {
+	.open		= nonseekable_open,
+	.uring_cmd      = ubd_ctrl_uring_cmd,
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice ubd_misc = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "ubd-control",
+	.fops		= &ubd_ctl_fops,
+};
+
+static int __init ubd_init(void)
+{
+	int ret;
+
+	ret = misc_register(&ubd_misc);
+	if (ret)
+		return ret;
+
+	ret = alloc_chrdev_region(&ubd_chr_devt, 0, UBD_MINORS, "ubd-char");
+	if (ret)
+		goto unregister_mis;
+
+	ubd_chr_class = class_create(THIS_MODULE, "ubd-char");
+	if (IS_ERR(ubd_chr_class)) {
+		ret = PTR_ERR(ubd_chr_class);
+		goto free_chrdev_region;
+	}
+	return 0;
+
+free_chrdev_region:
+	unregister_chrdev_region(ubd_chr_devt, UBD_MINORS);
+unregister_mis:
+	misc_deregister(&ubd_misc);
+	return ret;
+}
+
+static void __exit ubd_exit(void)
+{
+	struct ubd_device *ub;
+	int id;
+
+	class_destroy(ubd_chr_class);
+
+	misc_deregister(&ubd_misc);
+
+	idr_for_each_entry(&ubd_index_idr, ub, id)
+		ubd_remove(ub);
+
+	idr_destroy(&ubd_index_idr);
+	unregister_chrdev_region(ubd_chr_devt, UBD_MINORS);
+}
+
+module_init(ubd_init);
+module_exit(ubd_exit);
+
+MODULE_AUTHOR("Ming Lei <ming.lei@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/ubd_cmd.h b/include/uapi/linux/ubd_cmd.h
new file mode 100644
index 000000000000..45f94b6667ac
--- /dev/null
+++ b/include/uapi/linux/ubd_cmd.h
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef USER_BLK_DRV_CMD_INC_H
+#define USER_BLK_DRV_CMD_INC_H
+
+#include <linux/types.h>
+
+/* ubd server command definition */
+
+/*
+ * Admin commands, issued by ubd server, and handled by ubd driver.
+ */
+#define	UBD_CMD_GET_QUEUE_AFFINITY	0x01
+#define	UBD_CMD_GET_DEV_INFO	0x02
+#define	UBD_CMD_ADD_DEV		0x04
+#define	UBD_CMD_DEL_DEV		0x05
+#define	UBD_CMD_START_DEV	0x06
+#define	UBD_CMD_STOP_DEV	0x07
+
+/*
+ * IO commands, issued by ubd server, and handled by ubd driver.
+ *
+ * FETCH_REQ: issued via sqe(URING_CMD) beforehand for fetching IO request
+ *      from ubd driver, should be issued only when starting device. After
+ *      the associated cqe is returned, request's tag can be retrieved via
+ *      cqe->userdata.
+ *
+ * COMMIT_AND_FETCH_REQ: issued via sqe(URING_CMD) after ubdserver handled
+ *      this IO request, request's handling result is committed to ubd
+ *      driver, meantime FETCH_REQ is piggyback, and FETCH_REQ has to be
+ *      handled before completing io request.
+ *
+ * COMMIT_REQ: issued via sqe(URING_CMD) after ubdserver handled this IO
+ *      request, request's handling result is committed to ubd driver.
+ */
+#define	UBD_IO_FETCH_REQ		0x20
+#define	UBD_IO_COMMIT_AND_FETCH_REQ	0x21
+#define	UBD_IO_COMMIT_REQ		0x22
+
+/* only ABORT means that no re-fetch */
+#define UBD_IO_RES_OK			0
+#define UBD_IO_RES_ABORT		(-ENODEV)
+
+#define UBDSRV_CMD_BUF_OFFSET	0
+#define UBDSRV_IO_BUF_OFFSET	0x80000000
+
+/* tag bit is 12bit, so at most 4096 IOs for each queue */
+#define UBD_MAX_QUEUE_DEPTH	4096
+
+/*
+ * zero copy requires 4k block size, and can remap ubd driver's io
+ * request into ubdsrv's vm space
+ */
+#define UBD_F_SUPPORT_ZERO_COPY	0
+
+/* device state */
+#define UBD_S_DEV_DEAD	0
+#define UBD_S_DEV_LIVE	1
+
+/* shipped via sqe->cmd of io_uring command */
+struct ubdsrv_ctrl_cmd {
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
+struct ubdsrv_ctrl_dev_info {
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
+	__s32	ubdsrv_pid;
+	__s32	reserved0;
+	__u64	flags[2];
+
+	__u64	reserved1[10];
+};
+
+#define		UBD_IO_OP_READ		0
+#define		UBD_IO_OP_WRITE		1
+#define		UBD_IO_OP_FLUSH		2
+#define		UBD_IO_OP_DISCARD	3
+#define		UBD_IO_OP_WRITE_SAME	4
+#define		UBD_IO_OP_WRITE_ZEROES	5
+
+#define		UBD_IO_F_FAILFAST_DEV		(1U << 8)
+#define		UBD_IO_F_FAILFAST_TRANSPORT	(1U << 9)
+#define		UBD_IO_F_FAILFAST_DRIVER	(1U << 10)
+#define		UBD_IO_F_META			(1U << 11)
+#define		UBD_IO_F_INTEGRITY		(1U << 12)
+#define		UBD_IO_F_FUA			(1U << 13)
+#define		UBD_IO_F_PREFLUSH		(1U << 14)
+#define		UBD_IO_F_NOUNMAP		(1U << 15)
+#define		UBD_IO_F_SWAP			(1U << 16)
+
+/*
+ * io cmd is described by this structure, and stored in share memory, indexed
+ * by request tag.
+ *
+ * The data is stored by ubd driver, and read by ubdsrv after one fetch command
+ * returns.
+ */
+struct ubdsrv_io_desc {
+	/* op: bit 0-7, flags: bit 8-31 */
+	__u32		op_flags;
+
+	__u32		nr_sectors;
+
+	/* start sector for this io */
+	__u64		start_sector;
+
+	/* buffer address in ubdsrv daemon vm space, from ubd driver */
+	__u64		addr;
+};
+
+static inline __u8 ubdsrv_get_op(const struct ubdsrv_io_desc *iod)
+{
+	return iod->op_flags & 0xff;
+}
+
+static inline __u32 ubdsrv_get_flags(const struct ubdsrv_io_desc *iod)
+{
+	return iod->op_flags >> 8;
+}
+
+/* issued to ubd driver via /dev/ubdcN */
+struct ubdsrv_io_cmd {
+	__u16	q_id;
+
+	/* for fetch/commit which result */
+	__u16	tag;
+
+	/* io result, it is valid for COMMIT* command only */
+	__s32	result;
+
+	/*
+	 * userspace buffer address in ubdsrv daemon process, valid for
+	 * FETCH* command only
+	 */
+	__u64	addr;
+};
+
+#endif
-- 
2.31.1

