Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1E5200CC
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiEIPOE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiEIPOE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:14:04 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A789A24C74C;
        Mon,  9 May 2022 08:10:08 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 396511F432C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1652109007;
        bh=1cAl2PbTJSGJ3CC82Yn33U7hep7vr0g4V+6CViF8Pow=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DlK/qBc9C/4WVirEBhTu+mJMxegbIbG3kFfQdsiW2BjVtrfkj6ThCoGVSjwivqrPp
         VH3gjbmUGAo5dwXSL2DYhW0wFm3dCkULx10IJCf4kJiK3xDzQhtNwlQYKHeLLPPeEt
         xB1V9QImyRIPxXdOmCHu+sOG6EUhgYw870Qb9xzRgHA8TetpgIWk+d2ltN0TDh2JlS
         zeIEVtH0PHk0DcCLJBI5WzeqLrb/TnVy5g0GT3L04DZJteaRACV8kFtypFdIN5+RBh
         prSaFuzDdq8VFXxsay47Kw0o7ZD+VIjXEoiRaG+QiSh/0mlrS8U092v7xXgZHu3uUG
         cJvR8tcnJ46bw==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Organization: Collabora
References: <20220509092312.254354-1-ming.lei@redhat.com>
Date:   Mon, 09 May 2022 11:10:03 -0400
In-Reply-To: <20220509092312.254354-1-ming.lei@redhat.com> (Ming Lei's message
        of "Mon, 9 May 2022 17:23:12 +0800")
Message-ID: <87h75ylp2s.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> This is the driver part of userspace block driver(ubd driver), the other
> part is userspace daemon part(ubdsrv)[1].
>
> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
> shared cmd buffer for storing io command, and the buffer is read only for
> ubdsrv, each io command is indexed by io request tag directly, and
> is written by ubd driver.
>
> For example, when one READ io request is submitted to ubd block driver, ubd
> driver stores the io command into cmd buffer first, then completes one
> IORING_OP_URING_CMD for notifying ubdsrv, and the URING_CMD is issued to
> ubd driver beforehand by ubdsrv for getting notification of any new io request,
> and each URING_CMD is associated with one io request by tag.
>
> After ubdsrv gets the io command, it translates and handles the ubd io
> request, such as, for the ubd-loop target, ubdsrv translates the request
> into same request on another file or disk, like the kernel loop block
> driver. In ubdsrv's implementation, the io is still handled by io_uring,
> and share same ring with IORING_OP_URING_CMD command. When the target io
> request is done, the same IORING_OP_URING_CMD is issued to ubd driver for
> both committing io request result and getting future notification of new
> io request.
>
> Another thing done by ubd driver is to copy data between kernel io
> request and ubdsrv's io buffer:
>
> 1) before ubsrv handles WRITE request, copy the request's data into
> ubdsrv's userspace io buffer, so that ubdsrv can handle the write
> request
>
> 2) after ubsrv handles READ request, copy ubdsrv's userspace io buffer
> into this READ request, then ubd driver can complete the READ request
>
> Zero copy may be switched if mm is ready to support it.
>
> ubd driver doesn't handle any logic of the specific user space driver,
> so it should be small/simple enough.
>
> [1] ubdsrv
> https://github.com/ming1/ubdsrv/commits/devel
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/block/Kconfig        |    7 +
>  drivers/block/Makefile       |    2 +
>  drivers/block/ubd_drv.c      | 1193 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/ubd_cmd.h |  167 +++++
>  4 files changed, 1369 insertions(+)
>  create mode 100644 drivers/block/ubd_drv.c
>  create mode 100644 include/uapi/linux/ubd_cmd.h
>
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index fdb81f2794cd..3893ccd82e8a 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -408,6 +408,13 @@ config BLK_DEV_RBD
>  
>  	  If unsure, say N.
>  
> +config BLK_DEV_USER_BLK_DRV
> +	bool "Userspace block driver"
> +	select IO_URING
> +	default y
> +	help
> +          io uring based userspace block driver.
> +
>  source "drivers/block/rnbd/Kconfig"
>  
>  endif # BLK_DEV
> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
> index 934a9c7c3a7c..effff34babd9 100644
> --- a/drivers/block/Makefile
> +++ b/drivers/block/Makefile
> @@ -39,4 +39,6 @@ obj-$(CONFIG_BLK_DEV_RNBD)	+= rnbd/
>  
>  obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
>  
> +obj-$(CONFIG_BLK_DEV_USER_BLK_DRV)			+= ubd_drv.o
> +
>  swim_mod-y	:= swim.o swim_asm.o
> diff --git a/drivers/block/ubd_drv.c b/drivers/block/ubd_drv.c
> new file mode 100644
> index 000000000000..9eba7ee17aff
> --- /dev/null
> +++ b/drivers/block/ubd_drv.c

Hi Ming,

Thank you very much for sending it.

Given the interest in working on it from a bunch of people, I'd
appreciate if we consider putting the code into drivers/staging as soon
as possible, and let us work on the same code base to consolidate the
protocol there, instead of taking too long to push to drivers/block.

One initial concern is that UBD is already the name for storage device
exposed by User Mode Linux.  A rename would avoid future confusion.

> @@ -0,0 +1,1193 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Userspace block device - block device which IO is handled from userspace
> + *
> + * Take full use of io_uring passthrough command for communicating with
> + * ubd userspace daemon(ubdsrvd) for handling basic IO request.
> + *
> + * Copyright 2022 Ming Lei <ming.lei@redhat.com>
> + *
> + * (part of code stolen from loop.c)
> + */
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/sched.h>
> +#include <linux/fs.h>
> +#include <linux/pagemap.h>
> +#include <linux/file.h>
> +#include <linux/stat.h>
> +#include <linux/errno.h>
> +#include <linux/major.h>
> +#include <linux/wait.h>
> +#include <linux/blkdev.h>
> +#include <linux/init.h>
> +#include <linux/swap.h>
> +#include <linux/slab.h>
> +#include <linux/compat.h>
> +#include <linux/mutex.h>
> +#include <linux/writeback.h>
> +#include <linux/completion.h>
> +#include <linux/highmem.h>
> +#include <linux/sysfs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/falloc.h>
> +#include <linux/uio.h>
> +#include <linux/ioprio.h>
> +#include <linux/sched/mm.h>
> +#include <linux/uaccess.h>
> +#include <linux/cdev.h>
> +#include <linux/io_uring.h>
> +#include <linux/blk-mq.h>
> +#include <linux/delay.h>
> +#include <linux/mm.h>
> +#include <asm/page.h>
> +#include <linux/task_work.h>
> +#include <uapi/linux/ubd_cmd.h>
> +
> +#define UBD_MINORS		(1U << MINORBITS)
> +
> +struct ubd_abort_work {
> +	struct ubd_device *ub;
> +	unsigned int q_id;
> +	struct work_struct work;
> +};
> +
> +struct ubd_rq_data {
> +	struct callback_head work;
> +};
> +
> +/* io cmd is active: sqe cmd is received, and its cqe isn't done */
> +#define UBD_IO_FLAG_ACTIVE	0x01
> +
> +/*
> + * FETCH io cmd is completed via cqe, and the io cmd is being handled by
> + * ubdsrv, and not committed yet
> + */
> +#define UBD_IO_FLAG_OWNED_BY_SRV 0x02
> +
> +struct ubd_io {
> +	/* userspace buffer address from io cmd */
> +	__u64	addr;
> +	unsigned int flags;
> +	unsigned int res;
> +
> +	struct io_uring_cmd *cmd;
> +};
> +
> +struct ubd_queue {
> +	int q_id;
> +	int q_depth;
> +
> +	struct task_struct	*ubq_daemon;
> +	char *io_cmd_buf;
> +
> +	unsigned long io_addr;	/* mapped vm address */
> +	unsigned int max_io_sz;
> +	bool aborted;
> +	struct ubd_io ios[0];
> +};
> +
> +struct ubd_device {
> +	struct gendisk		*ub_disk;
> +	struct request_queue	*ub_queue;
> +
> +	char	*__queues;
> +
> +	unsigned short  queue_size;
> +	unsigned short  bs_shift;
> +	unsigned int nr_aborted_queues;
> +	struct ubdsrv_ctrl_dev_info	dev_info;
> +
> +	struct blk_mq_tag_set	tag_set;
> +
> +	struct cdev		cdev;
> +	struct device		cdev_dev;
> +
> +	atomic_t		ch_open_cnt;
> +	int			ub_number;
> +
> +	struct mutex		mutex;
> +};
> +
> +static dev_t ubd_chr_devt;
> +static struct class *ubd_chr_class;
> +
> +static DEFINE_IDR(ubd_index_idr);
> +static DEFINE_MUTEX(ubd_ctl_mutex);
> +
> +static struct miscdevice ubd_misc;
> +
> +static inline struct ubd_queue *ubd_get_queue(struct ubd_device *dev, int qid)
> +{
> +       return (struct ubd_queue *)&(dev->__queues[qid * dev->queue_size]);
> +}
> +
> +static inline bool ubd_rq_need_copy(struct request *rq)
> +{
> +	return rq->bio && bio_has_data(rq->bio);
> +}
> +
> +static inline struct ubdsrv_io_desc *ubd_get_iod(struct ubd_queue *ubq, int tag)
> +{
> +	return (struct ubdsrv_io_desc *)
> +		&(ubq->io_cmd_buf[tag * sizeof(struct ubdsrv_io_desc)]);
> +}
> +
> +static inline char *ubd_queue_cmd_buf(struct ubd_device *ub, int q_id)
> +{
> +	return ubd_get_queue(ub, q_id)->io_cmd_buf;
> +}
> +
> +static inline int ubd_queue_cmd_buf_size(struct ubd_device *ub, int q_id)
> +{
> +	struct ubd_queue *ubq = ubd_get_queue(ub, q_id);
> +
> +	return round_up(ubq->q_depth * sizeof(struct ubdsrv_io_desc), PAGE_SIZE);
> +}
> +
> +static int ubd_open(struct block_device *bdev, fmode_t mode)
> +{
> +	return 0;
> +}
> +
> +static void ubd_release(struct gendisk *disk, fmode_t mode)
> +{
> +}
> +
> +static const struct block_device_operations ub_fops = {
> +	.owner =	THIS_MODULE,
> +	.open =		ubd_open,
> +	.release =	ubd_release,
> +};
> +
> +#define UBD_MAX_PIN_PAGES	32
> +
> +static void ubd_release_pages(struct ubd_device *ub, struct page **pages,
> +		int nr_pages)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		put_page(pages[i]);
> +}
> +
> +static int ubd_pin_user_pages(struct ubd_device *ub, u64 start_vm,
> +		struct page **pages, unsigned int nr_pages, bool to_rq)
> +{
> +	unsigned int gup_flags = to_rq ? 0 : FOLL_WRITE;
> +
> +	return get_user_pages_fast(start_vm, nr_pages, gup_flags, pages);
> +}
> +
> +static inline unsigned ubd_copy_bv(struct bio_vec *bv, void **bv_addr,
> +		void *pg_addr, unsigned int *pg_off,
> +		unsigned int *pg_len, bool to_bv)
> +{
> +	unsigned len = min_t(unsigned, bv->bv_len, *pg_len);
> +
> +	if (*bv_addr == NULL)
> +		*bv_addr = kmap_local_page(bv->bv_page);
> +
> +	if (to_bv)
> +		memcpy(*bv_addr + bv->bv_offset, pg_addr + *pg_off, len);
> +	else
> +		memcpy(pg_addr + *pg_off, *bv_addr + bv->bv_offset, len);
> +
> +	bv->bv_offset += len;
> +	bv->bv_len -= len;
> +	*pg_off += len;
> +	*pg_len -= len;
> +
> +	if (!bv->bv_len) {
> +		kunmap_local(*bv_addr);
> +		*bv_addr = NULL;
> +	}
> +
> +	return len;
> +}
> +
> +/* copy rq pages to ubdsrv vm address pointed by io->addr */
> +static int ubd_copy_pages(struct ubd_device *ub, struct request *rq)
> +{
> +	struct ubd_queue *ubq = rq->mq_hctx->driver_data;
> +	struct ubd_io *io = &ubq->ios[rq->tag];
> +	struct page *pgs[UBD_MAX_PIN_PAGES];
> +	const bool to_rq = !op_is_write(rq->cmd_flags);
> +	struct req_iterator req_iter;
> +	struct bio_vec bv;
> +	unsigned long start = io->addr, left = rq->__data_len;
> +	unsigned int idx = 0, pg_len = 0, pg_off = 0;
> +	int nr_pin = 0;
> +	void *pg_addr = NULL;
> +	struct page *curr = NULL;
> +
> +	rq_for_each_segment(bv, rq, req_iter) {
> +		unsigned len, bv_off = bv.bv_offset, bv_len = bv.bv_len;
> +		void *bv_addr = NULL;
> +
> +refill:
> +		if (pg_len == 0) {
> +			unsigned int off = 0;
> +
> +			if (pg_addr) {
> +				kunmap_local(pg_addr);
> +				if (!to_rq)
> +					set_page_dirty_lock(curr);
> +				pg_addr = NULL;
> +			}
> +
> +			/* refill pages */
> +			if (idx >= nr_pin) {
> +				unsigned int max_pages;
> +
> +				ubd_release_pages(ub, pgs, nr_pin);
> +
> +				off = start & (PAGE_SIZE - 1);
> +				max_pages = round_up(off + left, PAGE_SIZE);
> +				nr_pin = min_t(unsigned, UBD_MAX_PIN_PAGES, max_pages);
> +				nr_pin = ubd_pin_user_pages(ub, start, pgs,
> +						nr_pin, to_rq);
> +				if (nr_pin <= 0)
> +					return -EINVAL;
> +				idx = 0;
> +			}
> +			pg_off = off;
> +			pg_len = min(PAGE_SIZE - off, left);
> +			off = 0;
> +			curr = pgs[idx++];
> +			pg_addr = kmap_local_page(curr);
> +		}
> +
> +		len = ubd_copy_bv(&bv, &bv_addr, pg_addr, &pg_off, &pg_len,
> +				to_rq);
> +		/* either one of the two has been consumed */
> +		WARN_ON_ONCE(bv.bv_len && pg_len);
> +		start += len;
> +		left -= len;
> +
> +		/* overflow */
> +		WARN_ON_ONCE(left > rq->__data_len);
> +		WARN_ON_ONCE(bv.bv_len > bv_len);
> +		if (bv.bv_len)
> +			goto refill;
> +
> +		bv.bv_len = bv_len;
> +		bv.bv_offset = bv_off;
> +	}
> +	if (pg_addr) {
> +		kunmap_local(pg_addr);
> +		if (!to_rq)
> +			set_page_dirty_lock(curr);
> +	}
> +	ubd_release_pages(ub, pgs, nr_pin);
> +
> +	WARN_ON_ONCE(left != 0);
> +
> +	return 0;
> +}
> +
> +#define UBD_REMAP_BATCH	32
> +
> +static int ubd_map_io(struct ubd_device *ub, struct request *req)
> +{
> +	/*
> +	 * no zero copy, we delay copy WRITE request data into ubdsrv
> +	 * context via task_work_add and the big benefit is that pinning
> +	 * pages in current context is pretty fast, see ubd_pin_user_pages
> +	 */
> +	if (!op_is_write(req->cmd_flags) || !ubd_rq_need_copy(req))
> +		return 0;
> +
> +	/* convert to data copy in current context */
> +	return ubd_copy_pages(ub, req);
> +}
> +
> +static int ubd_unmap_io(struct request *req)
> +{
> +	struct ubd_device *ub = req->q->queuedata;
> +
> +	if (!op_is_write(req->cmd_flags) && ubd_rq_need_copy(req))
> +		return ubd_copy_pages(ub, req);
> +	return 0;
> +}
> +
> +static inline unsigned int ubd_req_build_flags(struct request *req)
> +{
> +	unsigned flags = 0;
> +
> +	if (req->cmd_flags & REQ_FAILFAST_DEV)
> +		flags |= UBD_IO_F_FAILFAST_DEV;
> +
> +	if (req->cmd_flags & REQ_FAILFAST_TRANSPORT)
> +		flags |= UBD_IO_F_FAILFAST_TRANSPORT;
> +
> +	if (req->cmd_flags & REQ_FAILFAST_DRIVER)
> +		flags |= UBD_IO_F_FAILFAST_DRIVER;
> +
> +	if (req->cmd_flags & REQ_META)
> +		flags |= UBD_IO_F_META;
> +
> +	if (req->cmd_flags & REQ_INTEGRITY)
> +		flags |= UBD_IO_F_INTEGRITY;
> +
> +	if (req->cmd_flags & REQ_FUA)
> +		flags |= UBD_IO_F_FUA;
> +
> +	if (req->cmd_flags & REQ_PREFLUSH)
> +		flags |= UBD_IO_F_PREFLUSH;
> +
> +	if (req->cmd_flags & REQ_NOUNMAP)
> +		flags |= UBD_IO_F_NOUNMAP;
> +
> +	if (req->cmd_flags & REQ_SWAP)
> +		flags |= UBD_IO_F_SWAP;
> +
> +	return flags;
> +}
> +
> +static int ubd_setup_iod(struct ubd_queue *ubq, struct request *req)
> +{
> +	struct ubdsrv_io_desc *iod = ubd_get_iod(ubq, req->tag);
> +	struct ubd_io *io = &ubq->ios[req->tag];
> +	u32 ubd_op;
> +
> +	switch (req_op(req)) {
> +	case REQ_OP_READ:
> +		ubd_op = UBD_IO_OP_READ;
> +		break;
> +	case REQ_OP_WRITE:
> +		ubd_op = UBD_IO_OP_WRITE;
> +		break;
> +	case REQ_OP_FLUSH:
> +		ubd_op = UBD_IO_OP_FLUSH;
> +		break;
> +	case REQ_OP_DISCARD:
> +		ubd_op = UBD_IO_OP_DISCARD;
> +		break;
> +	case REQ_OP_WRITE_ZEROES:
> +		ubd_op = UBD_IO_OP_WRITE_ZEROES;
> +		break;
> +	default:
> +		return BLK_STS_IOERR;
> +	}
> +
> +	/* need to translate since kernel may change */
> +	iod->op_flags = ubd_op | ubd_req_build_flags(req);
> +	iod->tag_blocks = req->tag | (blk_rq_sectors(req) << 12);
> +	iod->start_block = blk_rq_pos(req);
> +	iod->addr = io->addr;
> +
> +	return BLK_STS_OK;
> +}
> +
> +static blk_status_t ubd_queue_rq(struct blk_mq_hw_ctx *hctx,
> +		const struct blk_mq_queue_data *bd)
> +{
> +	struct ubd_queue *ubq = hctx->driver_data;
> +	struct request *rq = bd->rq;
> +	struct ubd_io *io = &ubq->ios[rq->tag];
> +	struct ubd_rq_data *data = blk_mq_rq_to_pdu(rq);
> +	blk_status_t res;
> +
> +	if (ubq->aborted)
> +		return BLK_STS_IOERR;
> +
> +	/* this io cmd slot isn't active, so have to fail this io */
> +	if (WARN_ON_ONCE(!(io->flags & UBD_IO_FLAG_ACTIVE)))
> +		return BLK_STS_IOERR;
> +
> +	/* fill iod to slot in io cmd buffer */
> +	res = ubd_setup_iod(ubq, rq);
> +	if (res != BLK_STS_OK)
> +		return BLK_STS_IOERR;
> +
> +	blk_mq_start_request(bd->rq);
> +
> +	/* mark this cmd owned by ubdsrv */
> +	io->flags |= UBD_IO_FLAG_OWNED_BY_SRV;
> +
> +	/*
> +	 * clear ACTIVE since we are done with this sqe/cmd slot
> +	 *
> +	 * We can only accept io cmd in case of being not active.
> +	 */
> +	io->flags &= ~UBD_IO_FLAG_ACTIVE;
> +
> +	/*
> +	 * run data copy in task work context for WRITE, and complete io_uring
> +	 * cmd there too.
> +	 *
> +	 * This way should improve batching, meantime pinning pages in current
> +	 * context is pretty fast.
> +	 */
> +	task_work_add(ubq->ubq_daemon, &data->work, TWA_SIGNAL);
> +
> +	return BLK_STS_OK;
> +}
> +
> +static void ubd_complete_rq(struct request *req)
> +{
> +	struct ubd_queue *ubq = req->mq_hctx->driver_data;
> +	struct ubd_io *io = &ubq->ios[req->tag];
> +
> +	/* for READ request, writing data in iod->addr to rq buffers */
> +	ubd_unmap_io(req);
> +
> +	blk_mq_end_request(req, io->res);
> +}
> +
> +static void ubd_rq_task_work_fn(struct callback_head *work)
> +{
> +	struct ubd_rq_data *data = container_of(work,
> +			struct ubd_rq_data, work);
> +	struct request *req = blk_mq_rq_from_pdu(data);
> +	struct ubd_queue *ubq = req->mq_hctx->driver_data;
> +	struct ubd_io *io = &ubq->ios[req->tag];
> +	struct ubd_device *ub = req->q->queuedata;
> +	int ret = UBD_IO_RES_OK;
> +
> +	if (ubd_map_io(ub, req))
> +		ret = UBD_IO_RES_DATA_BAD;
> +
> +	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x, addr %llx\n",
> +			__func__, io->cmd->cmd_op, req->tag, ret, io->flags,
> +			ubd_get_iod(ubq, req->tag)->addr);
> +	/* tell ubdsrv one io request is coming */
> +	io_uring_cmd_done(io->cmd, ret, 0);
> +}
> +
> +static int ubd_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
> +		unsigned int hctx_idx)
> +{
> +	struct ubd_device *ub = hctx->queue->queuedata;
> +	struct ubd_queue *ubq = ubd_get_queue(ub, hctx->queue_num);
> +
> +	hctx->driver_data = ubq;
> +	return 0;
> +}
> +
> +static int ubd_init_rq(struct blk_mq_tag_set *set, struct request *req,
> +		unsigned int hctx_idx, unsigned int numa_node)
> +{
> +	struct ubd_rq_data *data = blk_mq_rq_to_pdu(req);
> +
> +	init_task_work(&data->work, ubd_rq_task_work_fn);
> +
> +	return 0;
> +}
> +
> +static const struct blk_mq_ops ubd_mq_ops = {
> +	.queue_rq       = ubd_queue_rq,
> +	.init_hctx	= ubd_init_hctx,
> +	.init_request	= ubd_init_rq,
> +};
> +
> +static int ubd_ch_open(struct inode *inode, struct file *filp)
> +{
> +	struct ubd_device *ub = container_of(inode->i_cdev,
> +			struct ubd_device, cdev);
> +
> +	if (atomic_cmpxchg(&ub->ch_open_cnt, 0, 1) == 0) {
> +		filp->private_data = ub;
> +		return 0;
> +	}
> +	return -EBUSY;
> +}
> +
> +static int ubd_ch_release(struct inode *inode, struct file *filp)
> +{
> +	struct ubd_device *ub = filp->private_data;
> +
> +	while (atomic_cmpxchg(&ub->ch_open_cnt, 1, 0) != 1)
> +		cpu_relax();
> +
> +	filp->private_data = NULL;
> +	return 0;
> +}
> +
> +/* map pre-allocated per-queue cmd buffer to ubdsrv daemon */
> +static int ubd_ch_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct ubd_device *ub = filp->private_data;
> +	size_t sz = vma->vm_end - vma->vm_start;
> +	unsigned max_sz = UBD_MAX_QUEUE_DEPTH * sizeof(struct ubdsrv_io_desc);
> +	unsigned long pfn, end;
> +	int q_id;
> +
> +	end = UBDSRV_CMD_BUF_OFFSET + ub->dev_info.nr_hw_queues * max_sz;
> +	if (vma->vm_pgoff < UBDSRV_CMD_BUF_OFFSET || vma->vm_pgoff >= end)
> +		return -EINVAL;
> +
> +	q_id = (vma->vm_pgoff - UBDSRV_CMD_BUF_OFFSET) / max_sz;
> +
> +	if (sz != ubd_queue_cmd_buf_size(ub, q_id))
> +		return -EINVAL;
> +
> +	pfn = virt_to_phys(ubd_queue_cmd_buf(ub, q_id)) >> PAGE_SHIFT;
> +	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
> +}
> +
> +static void ubd_commit_completion(struct ubd_device *ub,
> +		struct ubdsrv_io_cmd *ub_cmd)
> +{
> +	u32 qid = ub_cmd->q_id, tag = ub_cmd->tag;
> +	struct ubd_queue *ubq = ubd_get_queue(ub, qid);
> +	struct ubd_io *io = &ubq->ios[tag];
> +	struct request *req;
> +
> +	/* now this cmd slot is owned by nbd driver */
> +	io->flags &= ~UBD_IO_FLAG_OWNED_BY_SRV;
> +	io->res = ub_cmd->result;
> +
> +	/* find the io request and complete */
> +	req = blk_mq_tag_to_rq(ub->tag_set.tags[qid], ub_cmd->tag);
> +
> +	if (req && likely(!blk_should_fake_timeout(req->q)))
> +		ubd_complete_rq(req);
> +}
> +
> +/* has to be called disk is dead or frozen */
> +static int ubd_abort_queue(struct ubd_device *ub, int qid)
> +{
> +	int ret = UBD_IO_RES_ABORT;
> +	struct ubd_queue *q = ubd_get_queue(ub, qid);
> +	int i;
> +
> +	for (i = 0; i < q->q_depth; i++) {
> +		struct ubd_io *io = &q->ios[i];
> +
> +		if (io->flags & UBD_IO_FLAG_ACTIVE) {
> +			io->flags &= ~UBD_IO_FLAG_ACTIVE;
> +			io_uring_cmd_done(io->cmd, ret, 0);
> +		}
> +	}
> +	q->ubq_daemon = NULL;
> +	return 0;
> +}
> +
> +static void ubd_abort_work_fn(struct work_struct *work)
> +{
> +	struct ubd_abort_work *abort_work =
> +		container_of(work, struct ubd_abort_work, work);
> +	struct ubd_device *ub = abort_work->ub;
> +	struct ubd_queue *ubq = ubd_get_queue(ub, abort_work->q_id);
> +
> +	blk_mq_freeze_queue(ub->ub_queue);
> +	mutex_lock(&ub->mutex);
> +	if (!ubq->aborted) {
> +		ubq->aborted = true;
> +		ubd_abort_queue(ub, abort_work->q_id);
> +		ub->nr_aborted_queues++;
> +	}
> +	mutex_unlock(&ub->mutex);
> +	blk_mq_unfreeze_queue(ub->ub_queue);
> +
> +	mutex_lock(&ub->mutex);
> +	if (ub->nr_aborted_queues == ub->dev_info.nr_hw_queues) {
> +		if (disk_live(ub->ub_disk))
> +			del_gendisk(ub->ub_disk);
> +	}
> +	mutex_unlock(&ub->mutex);
> +
> +	kfree(abort_work);
> +}
> +
> +static int ubd_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	struct ubdsrv_io_cmd *ub_cmd = (struct ubdsrv_io_cmd *)cmd->cmd;
> +	struct ubd_device *ub = cmd->file->private_data;
> +	struct ubd_queue *ubq;
> +	struct ubd_io *io;
> +	u32 cmd_op = cmd->cmd_op;
> +	unsigned tag = ub_cmd->tag;
> +	int ret = UBD_IO_RES_INVALID_SQE;
> +
> +	pr_devel("%s: receieved: cmd op %d, tag %d, queue %d\n",
> +			__func__, cmd->cmd_op, tag, ub_cmd->q_id);
> +
> +	if (!(issue_flags & IO_URING_F_SQE128))
> +		goto out;
> +
> +	if (cmd_op == UBD_IO_ABORT_QUEUE) {
> +		struct ubd_abort_work *work = kzalloc(sizeof(*work),
> +				GFP_KERNEL);
> +		if (!work)
> +			goto out;
> +
> +		INIT_WORK(&work->work, ubd_abort_work_fn);
> +		work->ub = ub;
> +		work->q_id = ub_cmd->q_id;
> +
> +		schedule_work(&work->work);
> +		ret = UBD_IO_RES_OK;
> +		goto out_done;
> +	}
> +
> +	ubq = ubd_get_queue(ub, ub_cmd->q_id);
> +	if (WARN_ON_ONCE(tag >= ubq->q_depth))
> +		goto out;
> +
> +	io = &ubq->ios[tag];
> +
> +	/* there is pending io cmd, something must be wrong */
> +	if (io->flags & UBD_IO_FLAG_ACTIVE) {
> +		ret = UBD_IO_RES_BUSY;
> +		goto out;
> +	}
> +
> +	switch (cmd_op) {
> +	case UBD_IO_FETCH_REQ:
> +		/* FETCH_REQ is only issued when starting device */
> +		mutex_lock(&ub->mutex);
> +		if (!ubq->ubq_daemon)
> +			ubq->ubq_daemon = current;

I find it slightly weird to set ubq_daemon per-request.  It would cause
weird corruptions if a buggy thread sends a FETCH_REQ to the wrong q_id
after another request in-flight has already set ubq_daemon.  I was also
working on MQ and I was thinking of dropping the q_id field from the
io_uring command, implying it from the fd that was opened.  Then, I let
each thread reopen the char device to configure a new queue:

 fd = open("/dev/ubdc0", O_RDWR);   // Connects to a new queue

fd is closed with fork/exec.

> +static int ubd_ctrl_start_dev(struct ubd_device *ub, struct io_uring_cmd *cmd)
> +{
> +	struct ubdsrv_ctrl_dev_info *info = (struct ubdsrv_ctrl_dev_info *)cmd->cmd;
> +	int ret = -EINVAL;
> +	unsigned long end = jiffies + 3 * HZ;
> +
> +	if (info->ubdsrv_pid <= 0)
> +		return -1;
> +
> +	mutex_lock(&ub->mutex);
> +
> +	ub->dev_info.ubdsrv_pid = info->ubdsrv_pid;
> +	if (disk_live(ub->ub_disk))
> +		goto unlock;
> +	while (time_before(jiffies, end)) {
> +		if (ubd_io_ready(ub)) {
> +			ret = 0;
> +			break;
> +		}
> +		msleep(100);
> +	}

This timer is quite weird, in my opinion.  Shouldn't we fail start_dev
and let userspace retry the command at a later time?

> + unlock:
> +	mutex_unlock(&ub->mutex);
> +	pr_devel("%s: device io ready %d\n", __func__, !ret);
> +
> +	if (ret == 0)
> +		ret = add_disk(ub->ub_disk);
> +
> +	return ret;
> +}
> +
> +static inline void ubd_dump(struct io_uring_cmd *cmd)
> +{
> +#ifdef DEBUG
> +	struct ubdsrv_ctrl_dev_info *info =
> +		(struct ubdsrv_ctrl_dev_info *)cmd->cmd;
> +
> +	printk("%s: cmd_op %x, dev id %d flags %llx\n", __func__,
> +			cmd->cmd_op, info->dev_id, info->flags);
> +
> +	printk("\t nr_hw_queues %d queue_depth %d block size %d dev_capacity %lld\n",
> +			info->nr_hw_queues, info->queue_depth,
> +			info->block_size, info->dev_blocks);
> +#endif
> +}

Maybe pr_debug or tracepoint?

> +MODULE_AUTHOR("Ming Lei <ming.lei@redhat.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/uapi/linux/ubd_cmd.h b/include/uapi/linux/ubd_cmd.h
> new file mode 100644
> index 000000000000..8ecea6aa9cfe
> --- /dev/null
> +++ b/include/uapi/linux/ubd_cmd.h
> @@ -0,0 +1,167 @@
> +#ifndef USER_BLK_DRV_CMD_INC_H
> +#define USER_BLK_DRV_CMD_INC_H
> +
> +/* ubd server command definition */
> +
> +/* CMD result code */
> +#define UBD_CTRL_CMD_RES_OK		0
> +#define UBD_CTRL_CMD_RES_FAILED		-1
> +
> +/*
> + * Admin commands, issued by ubd server, and handled by ubd driver.
> + */
> +#define	UBD_CMD_SET_DEV_INFO	0x01
> +#define	UBD_CMD_GET_DEV_INFO	0x02
> +#define	UBD_CMD_ADD_DEV		0x04
> +#define	UBD_CMD_DEL_DEV		0x05
> +#define	UBD_CMD_START_DEV	0x06
> +#define	UBD_CMD_STOP_DEV	0x07
> +
> +/*
> + * IO commands, issued by ubd server, and handled by ubd driver.
> + *
> + * FETCH_REQ: issued via sqe(URING_CMD) beforehand for fetching IO request
> + *      from ubd driver, should be issued only when starting device. After
> + *      the associated cqe is returned, request's tag can be retrieved via
> + *      cqe->userdata.
> + *
> + * COMMIT_AND_FETCH_REQ: issued via sqe(URING_CMD) after ubdserver handled
> + *      this IO request, request's handling result is committed to ubd
> + *      driver, meantime FETCH_REQ is piggyback, and FETCH_REQ has to be
> + *      handled before completing io request.
> + *
> + * COMMIT_REQ: issued via sqe(URING_CMD) after ubdserver handled this IO
> + *      request, request's handling result is committed to ubd driver.
> + *
> + * ABORT_QUEUE: issued via sqe(URING_CMD) and abort all active commands,
> + * 	meantime ubdserver can't issue any FETCH_REQ commands
> + */
> +#define	UBD_IO_FETCH_REQ		0x20
> +#define	UBD_IO_COMMIT_AND_FETCH_REQ	0x21
> +#define	UBD_IO_COMMIT_REQ		0x22
> +#define	UBD_IO_ABORT_QUEUE		0x23
> +
> +#define UBD_IO_RES_OK			0x01
> +#define UBD_IO_RES_INVALID_SQE		0x5f
> +#define UBD_IO_RES_INVALID_TAG		0x5e
> +#define UBD_IO_RES_INVALID_QUEUE	0x5d
> +#define UBD_IO_RES_BUSY			0x5c
> +#define UBD_IO_RES_DUP_FETCH		0x5b
> +#define UBD_IO_RES_UNEXPECTED_CMD	0x5a
> +#define UBD_IO_RES_DATA_BAD		0x59
> +
> +/* only ABORT means that no re-fetch */
> +#define UBD_IO_RES_ABORT		0x59
> +
> +#define UBDSRV_CMD_BUF_OFFSET	0
> +#define UBDSRV_IO_BUF_OFFSET	0x80000000
> +
> +/* tag bit is 12bit, so at most 4096 IOs for each queue */
> +#define UBD_MAX_QUEUE_DEPTH	4096
> +
> +/*
> + * zero copy requires 4k block size, and can remap ubd driver's io
> + * request into ubdsrv's vm space
> + */
> +#define UBD_F_SUPPORT_ZERO_COPY	0
> +
> +struct ubdsrv_ctrl_dev_info {
> +	__u16	nr_hw_queues;
> +	__u16	queue_depth;
> +	__u16	block_size;
> +	__u16	state;
> +
> +	__u32	rq_max_blocks;
> +	__u32	dev_id;
> +
> +	__u64   dev_blocks;
> +	__u64	flags;
> +
> +	/*
> +	 * Only valid for READ kind of ctrl command, and driver can
> +	 * get the userspace buffer address here, then write data
> +	 * into this buffer.
> +	 *
> +	 * And the buffer has to be inside one single page.
> +	 */
> +	__u64	addr;
> +	__u32	len;
> +	__s32	ubdsrv_pid;
> +	__u64	reserved0[2];
> +};

I was about to send you a patch to simplify the interface for
different commands.  My plan was to avoid passing parts of the structure for
commands that don't use it, considering the limit of io_uring cmd length.

 struct ubdsrv_ctrl_dev_info {
       __u32   dev_id;
       union {

               char raw[28]; /* Maximum size for iouring_command */

               struct {
                       __u32   rq_max_blocks;
                       __s32   ubdsrv_pid;

                       __u16   nr_hw_queues;
                       __u16   queue_depth;
                       __u16   block_size;
                       __u16   state;

                       __u64   dev_blocks;
                       __u64   flags;
               }, /* UBD_CMD_ADD_DEV */

               struct {
                       __u64   addr;
                       __u32   len;
               } /* CMD_GET_DEV_INFO */
       }
 };

What do you think?

in addition, I think UBD_CMD_ADD_DEV should embed an extra protocol
version field, for future extension.

-- 
Gabriel Krisman Bertazi
