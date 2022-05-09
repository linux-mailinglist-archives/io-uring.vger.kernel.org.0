Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878FE51F922
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 12:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiEIJvj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 05:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiEIJ2f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 05:28:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7975420956E
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 02:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652088279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rwb+Bg8ZKs6ACDRUAKYvoHu1JlTPTvjTz2xoLnLTmiE=;
        b=G28+LvdG2Jre4YmvdGJV2ymnLytJAqQRDfaFakWvjtQ2fE5zHeYRWJOq70V1+Ocam63qK0
        N+p5WVoYc6EJyDq+iObhUIbiUCye4l1GRjHdxCA/YDbsRMq1yk1dxFaGEWMvLII3F2Zpj0
        QSThUlPtFCs8aw87NhE9qIpj8OcdU1c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-hDyTg6gbPwqj8uejzsimZg-1; Mon, 09 May 2022 05:24:36 -0400
X-MC-Unique: hDyTg6gbPwqj8uejzsimZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06DC029AA2FC;
        Mon,  9 May 2022 09:24:36 +0000 (UTC)
Received: from localhost (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 175E640D1B9A;
        Mon,  9 May 2022 09:24:33 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH] ubd: add io_uring based userspace block driver
Date:   Mon,  9 May 2022 17:23:12 +0800
Message-Id: <20220509092312.254354-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
https://github.com/ming1/ubdsrv/commits/devel

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/Kconfig        |    7 +
 drivers/block/Makefile       |    2 +
 drivers/block/ubd_drv.c      | 1193 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ubd_cmd.h |  167 +++++
 4 files changed, 1369 insertions(+)
 create mode 100644 drivers/block/ubd_drv.c
 create mode 100644 include/uapi/linux/ubd_cmd.h

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index fdb81f2794cd..3893ccd82e8a 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -408,6 +408,13 @@ config BLK_DEV_RBD
 
 	  If unsure, say N.
 
+config BLK_DEV_USER_BLK_DRV
+	bool "Userspace block driver"
+	select IO_URING
+	default y
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
index 000000000000..9eba7ee17aff
--- /dev/null
+++ b/drivers/block/ubd_drv.c
@@ -0,0 +1,1193 @@
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
+struct ubd_abort_work {
+	struct ubd_device *ub;
+	unsigned int q_id;
+	struct work_struct work;
+};
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
+struct ubd_io {
+	/* userspace buffer address from io cmd */
+	__u64	addr;
+	unsigned int flags;
+	unsigned int res;
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
+	bool aborted;
+	struct ubd_io ios[0];
+};
+
+struct ubd_device {
+	struct gendisk		*ub_disk;
+	struct request_queue	*ub_queue;
+
+	char	*__queues;
+
+	unsigned short  queue_size;
+	unsigned short  bs_shift;
+	unsigned int nr_aborted_queues;
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
+				if (nr_pin <= 0)
+					return -EINVAL;
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
+	if (!op_is_write(req->cmd_flags) || !ubd_rq_need_copy(req))
+		return 0;
+
+	/* convert to data copy in current context */
+	return ubd_copy_pages(ub, req);
+}
+
+static int ubd_unmap_io(struct request *req)
+{
+	struct ubd_device *ub = req->q->queuedata;
+
+	if (!op_is_write(req->cmd_flags) && ubd_rq_need_copy(req))
+		return ubd_copy_pages(ub, req);
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
+	iod->tag_blocks = req->tag | (blk_rq_sectors(req) << 12);
+	iod->start_block = blk_rq_pos(req);
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
+	struct ubd_io *io = &ubq->ios[rq->tag];
+	struct ubd_rq_data *data = blk_mq_rq_to_pdu(rq);
+	blk_status_t res;
+
+	if (ubq->aborted)
+		return BLK_STS_IOERR;
+
+	/* this io cmd slot isn't active, so have to fail this io */
+	if (WARN_ON_ONCE(!(io->flags & UBD_IO_FLAG_ACTIVE)))
+		return BLK_STS_IOERR;
+
+	/* fill iod to slot in io cmd buffer */
+	res = ubd_setup_iod(ubq, rq);
+	if (res != BLK_STS_OK)
+		return BLK_STS_IOERR;
+
+	blk_mq_start_request(bd->rq);
+
+	/* mark this cmd owned by ubdsrv */
+	io->flags |= UBD_IO_FLAG_OWNED_BY_SRV;
+
+	/*
+	 * clear ACTIVE since we are done with this sqe/cmd slot
+	 *
+	 * We can only accept io cmd in case of being not active.
+	 */
+	io->flags &= ~UBD_IO_FLAG_ACTIVE;
+
+	/*
+	 * run data copy in task work context for WRITE, and complete io_uring
+	 * cmd there too.
+	 *
+	 * This way should improve batching, meantime pinning pages in current
+	 * context is pretty fast.
+	 */
+	task_work_add(ubq->ubq_daemon, &data->work, TWA_SIGNAL);
+
+	return BLK_STS_OK;
+}
+
+static void ubd_complete_rq(struct request *req)
+{
+	struct ubd_queue *ubq = req->mq_hctx->driver_data;
+	struct ubd_io *io = &ubq->ios[req->tag];
+
+	/* for READ request, writing data in iod->addr to rq buffers */
+	ubd_unmap_io(req);
+
+	blk_mq_end_request(req, io->res);
+}
+
+static void ubd_rq_task_work_fn(struct callback_head *work)
+{
+	struct ubd_rq_data *data = container_of(work,
+			struct ubd_rq_data, work);
+	struct request *req = blk_mq_rq_from_pdu(data);
+	struct ubd_queue *ubq = req->mq_hctx->driver_data;
+	struct ubd_io *io = &ubq->ios[req->tag];
+	struct ubd_device *ub = req->q->queuedata;
+	int ret = UBD_IO_RES_OK;
+
+	if (ubd_map_io(ub, req))
+		ret = UBD_IO_RES_DATA_BAD;
+
+	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x, addr %llx\n",
+			__func__, io->cmd->cmd_op, req->tag, ret, io->flags,
+			ubd_get_iod(ubq, req->tag)->addr);
+	/* tell ubdsrv one io request is coming */
+	io_uring_cmd_done(io->cmd, ret, 0);
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
+	unsigned long pfn, end;
+	int q_id;
+
+	end = UBDSRV_CMD_BUF_OFFSET + ub->dev_info.nr_hw_queues * max_sz;
+	if (vma->vm_pgoff < UBDSRV_CMD_BUF_OFFSET || vma->vm_pgoff >= end)
+		return -EINVAL;
+
+	q_id = (vma->vm_pgoff - UBDSRV_CMD_BUF_OFFSET) / max_sz;
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
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[qid], ub_cmd->tag);
+
+	if (req && likely(!blk_should_fake_timeout(req->q)))
+		ubd_complete_rq(req);
+}
+
+/* has to be called disk is dead or frozen */
+static int ubd_abort_queue(struct ubd_device *ub, int qid)
+{
+	int ret = UBD_IO_RES_ABORT;
+	struct ubd_queue *q = ubd_get_queue(ub, qid);
+	int i;
+
+	for (i = 0; i < q->q_depth; i++) {
+		struct ubd_io *io = &q->ios[i];
+
+		if (io->flags & UBD_IO_FLAG_ACTIVE) {
+			io->flags &= ~UBD_IO_FLAG_ACTIVE;
+			io_uring_cmd_done(io->cmd, ret, 0);
+		}
+	}
+	q->ubq_daemon = NULL;
+	return 0;
+}
+
+static void ubd_abort_work_fn(struct work_struct *work)
+{
+	struct ubd_abort_work *abort_work =
+		container_of(work, struct ubd_abort_work, work);
+	struct ubd_device *ub = abort_work->ub;
+	struct ubd_queue *ubq = ubd_get_queue(ub, abort_work->q_id);
+
+	blk_mq_freeze_queue(ub->ub_queue);
+	mutex_lock(&ub->mutex);
+	if (!ubq->aborted) {
+		ubq->aborted = true;
+		ubd_abort_queue(ub, abort_work->q_id);
+		ub->nr_aborted_queues++;
+	}
+	mutex_unlock(&ub->mutex);
+	blk_mq_unfreeze_queue(ub->ub_queue);
+
+	mutex_lock(&ub->mutex);
+	if (ub->nr_aborted_queues == ub->dev_info.nr_hw_queues) {
+		if (disk_live(ub->ub_disk))
+			del_gendisk(ub->ub_disk);
+	}
+	mutex_unlock(&ub->mutex);
+
+	kfree(abort_work);
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
+	int ret = UBD_IO_RES_INVALID_SQE;
+
+	pr_devel("%s: receieved: cmd op %d, tag %d, queue %d\n",
+			__func__, cmd->cmd_op, tag, ub_cmd->q_id);
+
+	if (!(issue_flags & IO_URING_F_SQE128))
+		goto out;
+
+	if (cmd_op == UBD_IO_ABORT_QUEUE) {
+		struct ubd_abort_work *work = kzalloc(sizeof(*work),
+				GFP_KERNEL);
+		if (!work)
+			goto out;
+
+		INIT_WORK(&work->work, ubd_abort_work_fn);
+		work->ub = ub;
+		work->q_id = ub_cmd->q_id;
+
+		schedule_work(&work->work);
+		ret = UBD_IO_RES_OK;
+		goto out_done;
+	}
+
+	ubq = ubd_get_queue(ub, ub_cmd->q_id);
+	if (WARN_ON_ONCE(tag >= ubq->q_depth))
+		goto out;
+
+	io = &ubq->ios[tag];
+
+	/* there is pending io cmd, something must be wrong */
+	if (io->flags & UBD_IO_FLAG_ACTIVE) {
+		ret = UBD_IO_RES_BUSY;
+		goto out;
+	}
+
+	switch (cmd_op) {
+	case UBD_IO_FETCH_REQ:
+		/* FETCH_REQ is only issued when starting device */
+		mutex_lock(&ub->mutex);
+		if (!ubq->ubq_daemon)
+			ubq->ubq_daemon = current;
+		mutex_unlock(&ub->mutex);
+		/*
+		 * The io is being handled by server, so COMMIT_RQ is expected
+		 * instead of FETCH_REQ
+		 */
+		if (io->flags & UBD_IO_FLAG_OWNED_BY_SRV) {
+			ret = UBD_IO_RES_DUP_FETCH;
+			goto out;
+		}
+		io->cmd = cmd;
+		io->flags |= UBD_IO_FLAG_ACTIVE;
+		io->addr = ub_cmd->addr;
+		break;
+	case UBD_IO_COMMIT_AND_FETCH_REQ:
+		io->addr = ub_cmd->addr;
+		io->flags |= UBD_IO_FLAG_ACTIVE;
+		fallthrough;
+	case UBD_IO_COMMIT_REQ:
+		io->cmd = cmd;
+		if (!(io->flags & UBD_IO_FLAG_OWNED_BY_SRV)) {
+			ret = UBD_IO_RES_UNEXPECTED_CMD;
+			goto out;
+		}
+		ubd_commit_completion(ub, ub_cmd);
+		if (cmd_op == UBD_IO_COMMIT_REQ) {
+			ret = UBD_IO_RES_OK;
+			goto out;
+		}
+		break;
+	default:
+		ret = UBD_IO_RES_UNEXPECTED_CMD;
+		goto out;
+	}
+	return -EIOCBQUEUED;
+
+ out:
+	io->flags &= ~UBD_IO_FLAG_ACTIVE;
+ out_done:
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
+	ubq->io_cmd_buf = ptr;
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
+	struct gendisk *disk;
+	int err = -ENOMEM;
+	int bsize;
+
+	/* We are not ready to support zero copy */
+	ub->dev_info.flags &= ~(1ULL << UBD_F_SUPPORT_ZERO_COPY);
+
+	bsize = ub->dev_info.block_size;
+	ub->bs_shift = ilog2(bsize);
+
+	ub->dev_info.nr_hw_queues = min_t(unsigned int,
+			ub->dev_info.nr_hw_queues, nr_cpu_ids);
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
+	ub->ub_queue->limits.discard_granularity = 0;
+
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
+	/* we may not start disk yet*/
+	if (disk_live(ub->ub_disk))
+		del_gendisk(ub->ub_disk);
+	blk_cleanup_disk(ub->ub_disk);
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
+/* has to be called disk is dead or frozen */
+static int ubd_active_io_cmd_cnt(struct ubd_device *ub, int qid)
+{
+	struct ubd_queue *q = ubd_get_queue(ub, qid);
+	int i, cnt = 0;
+
+	for (i = 0; i < q->q_depth; i++) {
+		struct ubd_io *io = &q->ios[i];
+
+		if (io->flags & UBD_IO_FLAG_ACTIVE)
+			cnt++;
+	}
+
+	return cnt;
+}
+
+static bool ubd_queue_ready(struct ubd_device *ub, int qid)
+{
+	return ubd_active_io_cmd_cnt(ub, qid) == ub->dev_info.queue_depth;
+}
+
+static bool ubd_io_ready(struct ubd_device *ub)
+{
+	struct ubdsrv_ctrl_dev_info *info = &ub->dev_info;
+	int cnt = 0;
+	int i;
+
+	for (i = 0; i < info->nr_hw_queues; i++)
+		cnt += ubd_queue_ready(ub, i);
+
+	return cnt == info->nr_hw_queues;
+}
+
+static int ubd_ctrl_stop_dev(struct ubd_device *ub, struct io_uring_cmd *cmd)
+{
+	int ret = 0;
+	int i;
+
+	mutex_lock(&ub->mutex);
+	if (!disk_live(ub->ub_disk))
+		goto unlock;
+
+	del_gendisk(ub->ub_disk);
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
+		ret += ubd_abort_queue(ub, i);
+ unlock:
+	mutex_unlock(&ub->mutex);
+	if (ret == 0)
+		ub->dev_info.ubdsrv_pid = -1;
+	return ret;
+}
+
+static int ubd_ctrl_start_dev(struct ubd_device *ub, struct io_uring_cmd *cmd)
+{
+	struct ubdsrv_ctrl_dev_info *info = (struct ubdsrv_ctrl_dev_info *)cmd->cmd;
+	int ret = -EINVAL;
+	unsigned long end = jiffies + 3 * HZ;
+
+	if (info->ubdsrv_pid <= 0)
+		return -1;
+
+	mutex_lock(&ub->mutex);
+
+	ub->dev_info.ubdsrv_pid = info->ubdsrv_pid;
+	if (disk_live(ub->ub_disk))
+		goto unlock;
+	while (time_before(jiffies, end)) {
+		if (ubd_io_ready(ub)) {
+			ret = 0;
+			break;
+		}
+		msleep(100);
+	}
+ unlock:
+	mutex_unlock(&ub->mutex);
+	pr_devel("%s: device io ready %d\n", __func__, !ret);
+
+	if (ret == 0)
+		ret = add_disk(ub->ub_disk);
+
+	return ret;
+}
+
+static inline void ubd_dump(struct io_uring_cmd *cmd)
+{
+#ifdef DEBUG
+	struct ubdsrv_ctrl_dev_info *info =
+		(struct ubdsrv_ctrl_dev_info *)cmd->cmd;
+
+	printk("%s: cmd_op %x, dev id %d flags %llx\n", __func__,
+			cmd->cmd_op, info->dev_id, info->flags);
+
+	printk("\t nr_hw_queues %d queue_depth %d block size %d dev_capacity %lld\n",
+			info->nr_hw_queues, info->queue_depth,
+			info->block_size, info->dev_blocks);
+#endif
+}
+
+static bool ubd_ctrl_cmd_validate(struct io_uring_cmd *cmd)
+{
+	/* Fix me: validate all ctrl commands */
+	return  true;
+}
+
+static int ubd_ctrl_uring_cmd(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	struct ubdsrv_ctrl_dev_info *info = (struct ubdsrv_ctrl_dev_info *)cmd->cmd;
+	unsigned int ret = UBD_CTRL_CMD_RES_FAILED;
+	u32 cmd_op = cmd->cmd_op;
+	struct ubd_device *ub;
+
+	ubd_dump(cmd);
+
+	if (!(issue_flags & IO_URING_F_SQE128))
+		goto out;
+
+	if (!ubd_ctrl_cmd_validate(cmd))
+		goto out;
+
+	switch (cmd_op) {
+	case UBD_CMD_START_DEV:
+		ub = ubd_find_device(info->dev_id);
+		if (!ub)
+			goto out;
+		if (!ubd_ctrl_start_dev(ub, cmd))
+			ret = UBD_CTRL_CMD_RES_OK;
+		break;
+	case UBD_CMD_STOP_DEV:
+		ub = ubd_find_device(info->dev_id);
+		if (!ub)
+			goto out;
+		if (!ubd_ctrl_stop_dev(ub, cmd))
+			ret = UBD_CTRL_CMD_RES_OK;
+		break;
+	case UBD_CMD_GET_DEV_INFO:
+		ub = ubd_find_device(info->dev_id);
+		if (ub) {
+			if (info->len < sizeof(*info))
+				goto out;
+
+			if (!copy_to_user((void __user *)info->addr,
+						(void *)&ub->dev_info,
+						sizeof(*info)))
+				ret = UBD_CTRL_CMD_RES_OK;
+		}
+		break;
+	case UBD_CMD_ADD_DEV:
+		if (info->len < sizeof(*info) || !info->addr)
+			goto out;
+		ub = ubd_create_dev(info->dev_id);
+		if (!IS_ERR_OR_NULL(ub)) {
+			memcpy(&ub->dev_info, info, sizeof(*info));
+
+			/* update device id */
+			ub->dev_info.dev_id = ub->ub_number;
+
+			if (ubd_add_dev(ub))
+				ubd_remove(ub);
+			else {
+				ret = UBD_CTRL_CMD_RES_OK;
+				WARN_ON_ONCE(copy_to_user((void __user *)info->addr,
+						(void *)&ub->dev_info,
+						sizeof(*info)));
+			}
+		}
+		break;
+	case UBD_CMD_DEL_DEV:
+		ub = ubd_find_device(info->dev_id);
+		if (ub) {
+			ubd_remove(ub);
+			ret = UBD_CTRL_CMD_RES_OK;
+		}
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
index 000000000000..8ecea6aa9cfe
--- /dev/null
+++ b/include/uapi/linux/ubd_cmd.h
@@ -0,0 +1,167 @@
+#ifndef USER_BLK_DRV_CMD_INC_H
+#define USER_BLK_DRV_CMD_INC_H
+
+/* ubd server command definition */
+
+/* CMD result code */
+#define UBD_CTRL_CMD_RES_OK		0
+#define UBD_CTRL_CMD_RES_FAILED		-1
+
+/*
+ * Admin commands, issued by ubd server, and handled by ubd driver.
+ */
+#define	UBD_CMD_SET_DEV_INFO	0x01
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
+ *
+ * ABORT_QUEUE: issued via sqe(URING_CMD) and abort all active commands,
+ * 	meantime ubdserver can't issue any FETCH_REQ commands
+ */
+#define	UBD_IO_FETCH_REQ		0x20
+#define	UBD_IO_COMMIT_AND_FETCH_REQ	0x21
+#define	UBD_IO_COMMIT_REQ		0x22
+#define	UBD_IO_ABORT_QUEUE		0x23
+
+#define UBD_IO_RES_OK			0x01
+#define UBD_IO_RES_INVALID_SQE		0x5f
+#define UBD_IO_RES_INVALID_TAG		0x5e
+#define UBD_IO_RES_INVALID_QUEUE	0x5d
+#define UBD_IO_RES_BUSY			0x5c
+#define UBD_IO_RES_DUP_FETCH		0x5b
+#define UBD_IO_RES_UNEXPECTED_CMD	0x5a
+#define UBD_IO_RES_DATA_BAD		0x59
+
+/* only ABORT means that no re-fetch */
+#define UBD_IO_RES_ABORT		0x59
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
+	__u64	flags;
+
+	/*
+	 * Only valid for READ kind of ctrl command, and driver can
+	 * get the userspace buffer address here, then write data
+	 * into this buffer.
+	 *
+	 * And the buffer has to be inside one single page.
+	 */
+	__u64	addr;
+	__u32	len;
+	__s32	ubdsrv_pid;
+	__u64	reserved0[2];
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
+	/*
+	 * tag: bit 0 - 11, max: 4096
+	 *
+	 * blocks: bit 12 ~ 31, max: 1M blocks
+	 */
+	__u32		tag_blocks;
+
+	/* start block for this io */
+	__u64		start_block;
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
+static inline __u32 ubdsrv_get_blocks(const struct ubdsrv_io_desc *iod)
+{
+	return iod->tag_blocks >> 12;
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
+	__u32	result;
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

