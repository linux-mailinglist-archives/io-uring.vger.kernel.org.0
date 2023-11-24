Return-Path: <io-uring+bounces-150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BAA7F6A87
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 03:06:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B3C91C20A10
	for <lists+io-uring@lfdr.de>; Fri, 24 Nov 2023 02:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99708646;
	Fri, 24 Nov 2023 02:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HYzp84Iz"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB80E1A5
	for <io-uring@vger.kernel.org>; Thu, 23 Nov 2023 18:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700791565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rQnzBTj/z5aPPqyxUu82KqapSq/NYxk1EmzIkkjx9o8=;
	b=HYzp84IzRbtaHbA6Jpx65vThgkiJTol0I/3JZcubExERwxAwutvgGS/h220IeHvDJb2MFh
	aY6u40CmBhISBSDpcorBoY67gOxLOdhFcMRX79adFQ5+1hhnSgtOIBOPFdAOaX5y6Nar2Y
	8GQKIXlgu8wYBH0fUNbdUQpveD7RxYo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-JXD-KZH4P42NL2KHtynaEw-1; Thu,
 23 Nov 2023 21:06:02 -0500
X-MC-Unique: JXD-KZH4P42NL2KHtynaEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E71731C060C6;
	Fri, 24 Nov 2023 02:06:01 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D229B1C060B0;
	Fri, 24 Nov 2023 02:05:57 +0000 (UTC)
Date: Fri, 24 Nov 2023 10:05:53 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, joshi.k@samsung.com
Subject: Re: [PATCH 1/3] io_uring: split out cmd api into a separate header
Message-ID: <ZWAFAex/QRx8ODZe@fedora>
References: <cover.1700668641.git.asml.silence@gmail.com>
 <547e56560b97cd66f00bfc5b53db24f2fa1a8852.1700668641.git.asml.silence@gmail.com>
 <ZV67ozp4yizgWYYg@fedora>
 <c204c03a-785d-4872-a8c8-58d0cdc708d6@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c204c03a-785d-4872-a8c8-58d0cdc708d6@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Thu, Nov 23, 2023 at 11:16:33AM +0000, Pavel Begunkov wrote:
> On 11/23/23 02:40, Ming Lei wrote:
> > On Wed, Nov 22, 2023 at 04:01:09PM +0000, Pavel Begunkov wrote:
> > > linux/io_uring.h is slowly becoming a rubbish bin where we put
> > > anything exposed to other subsystems. For instance, the task exit
> > > hooks and io_uring cmd infra are completely orthogonal and don't need
> > > each other's definitions. Start cleaning it up by splitting out all
> > > command bits into a new header file.
> > > 
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > ---
> > >   drivers/block/ublk_drv.c       |  2 +-
> > >   drivers/nvme/host/ioctl.c      |  2 +-
> > >   include/linux/io_uring.h       | 89 +---------------------------------
> > >   include/linux/io_uring/cmd.h   | 81 +++++++++++++++++++++++++++++++
> > >   include/linux/io_uring_types.h | 20 ++++++++
> > >   io_uring/io_uring.c            |  1 +
> > >   io_uring/rw.c                  |  2 +-
> > >   io_uring/uring_cmd.c           |  2 +-
> > >   8 files changed, 107 insertions(+), 92 deletions(-)
> > >   create mode 100644 include/linux/io_uring/cmd.h
> > > 
> > > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > > index 83600b45e12a..909377068a87 100644
> > > --- a/drivers/block/ublk_drv.c
> > > +++ b/drivers/block/ublk_drv.c
> > > @@ -36,7 +36,7 @@
> > >   #include <linux/sched/mm.h>
> > >   #include <linux/uaccess.h>
> > >   #include <linux/cdev.h>
> > > -#include <linux/io_uring.h>
> > > +#include <linux/io_uring/cmd.h>
> > >   #include <linux/blk-mq.h>
> > >   #include <linux/delay.h>
> > >   #include <linux/mm.h>
> > > diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> > > index 529b9954d2b8..6864a6eeee93 100644
> > > --- a/drivers/nvme/host/ioctl.c
> > > +++ b/drivers/nvme/host/ioctl.c
> > > @@ -5,7 +5,7 @@
> > >    */
> > >   #include <linux/ptrace.h>	/* for force_successful_syscall_return */
> > >   #include <linux/nvme_ioctl.h>
> > > -#include <linux/io_uring.h>
> > > +#include <linux/io_uring/cmd.h>
> > >   #include "nvme.h"
> > >   enum {
> > > diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> > > index aefb73eeeebf..d8fc93492dc5 100644
> > > --- a/include/linux/io_uring.h
> > > +++ b/include/linux/io_uring.h
> > > @@ -6,71 +6,13 @@
> > >   #include <linux/xarray.h>
> > >   #include <uapi/linux/io_uring.h>
> > > -enum io_uring_cmd_flags {
> > > -	IO_URING_F_COMPLETE_DEFER	= 1,
> > > -	IO_URING_F_UNLOCKED		= 2,
> > > -	/* the request is executed from poll, it should not be freed */
> > > -	IO_URING_F_MULTISHOT		= 4,
> > > -	/* executed by io-wq */
> > > -	IO_URING_F_IOWQ			= 8,
> > > -	/* int's last bit, sign checks are usually faster than a bit test */
> > > -	IO_URING_F_NONBLOCK		= INT_MIN,
> > > -
> > > -	/* ctx state flags, for URING_CMD */
> > > -	IO_URING_F_SQE128		= (1 << 8),
> > > -	IO_URING_F_CQE32		= (1 << 9),
> > > -	IO_URING_F_IOPOLL		= (1 << 10),
> > > -
> > > -	/* set when uring wants to cancel a previously issued command */
> > > -	IO_URING_F_CANCEL		= (1 << 11),
> > > -	IO_URING_F_COMPAT		= (1 << 12),
> > > -};
> > > -
> > > -/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
> > > -#define IORING_URING_CMD_CANCELABLE	(1U << 30)
> > > -#define IORING_URING_CMD_POLLED		(1U << 31)
> > > -
> > > -struct io_uring_cmd {
> > > -	struct file	*file;
> > > -	const struct io_uring_sqe *sqe;
> > > -	union {
> > > -		/* callback to defer completions to task context */
> > > -		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
> > > -		/* used for polled completion */
> > > -		void *cookie;
> > > -	};
> > > -	u32		cmd_op;
> > > -	u32		flags;
> > > -	u8		pdu[32]; /* available inline for free use */
> > > -};
> > > -
> > > -static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
> > > -{
> > > -	return sqe->cmd;
> > > -}
> > > -
> > >   #if defined(CONFIG_IO_URING)
> > > -int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > > -			      struct iov_iter *iter, void *ioucmd);
> > > -void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
> > > -			unsigned issue_flags);
> > >   struct sock *io_uring_get_socket(struct file *file);
> > >   void __io_uring_cancel(bool cancel_all);
> > >   void __io_uring_free(struct task_struct *tsk);
> > >   void io_uring_unreg_ringfd(void);
> > >   const char *io_uring_get_opcode(u8 opcode);
> > > -void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> > > -			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
> > > -			    unsigned flags);
> > > -/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
> > > -void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
> > > -			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
> > > -
> > > -static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> > > -			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
> > > -{
> > > -	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
> > > -}
> > > +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
> > >   static inline void io_uring_files_cancel(void)
> > >   {
> > > @@ -89,28 +31,7 @@ static inline void io_uring_free(struct task_struct *tsk)
> > >   	if (tsk->io_uring)
> > >   		__io_uring_free(tsk);
> > >   }
> > > -int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
> > > -void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > > -		unsigned int issue_flags);
> > > -struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
> > >   #else
> > > -static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > > -			      struct iov_iter *iter, void *ioucmd)
> > > -{
> > > -	return -EOPNOTSUPP;
> > > -}
> > > -static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
> > > -		ssize_t ret2, unsigned issue_flags)
> > > -{
> > > -}
> > > -static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> > > -			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
> > > -{
> > > -}
> > > -static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
> > > -			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
> > > -{
> > > -}
> > >   static inline struct sock *io_uring_get_socket(struct file *file)
> > >   {
> > >   	return NULL;
> > > @@ -133,14 +54,6 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
> > >   {
> > >   	return -EOPNOTSUPP;
> > >   }
> > > -static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > > -		unsigned int issue_flags)
> > > -{
> > > -}
> > > -static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
> > > -{
> > > -	return NULL;
> > > -}
> > >   #endif
> > >   #endif
> > > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> > > new file mode 100644
> > > index 000000000000..62fcfaf6fcc9
> > > --- /dev/null
> > > +++ b/include/linux/io_uring/cmd.h
> > > @@ -0,0 +1,81 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > +#ifndef _LINUX_IO_URING_CMD_H
> > > +#define _LINUX_IO_URING_CMD_H
> > > +
> > > +#include <uapi/linux/io_uring.h>
> > > +#include <linux/io_uring_types.h>
> > > +
> > > +/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
> > > +#define IORING_URING_CMD_CANCELABLE	(1U << 30)
> > > +#define IORING_URING_CMD_POLLED		(1U << 31)
> > > +
> > > +struct io_uring_cmd {
> > > +	struct file	*file;
> > > +	const struct io_uring_sqe *sqe;
> > > +	union {
> > > +		/* callback to defer completions to task context */
> > > +		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
> > > +		/* used for polled completion */
> > > +		void *cookie;
> > > +	};
> > > +	u32		cmd_op;
> > > +	u32		flags;
> > > +	u8		pdu[32]; /* available inline for free use */
> > > +};
> > > +
> > > +static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
> > > +{
> > > +	return sqe->cmd;
> > > +}
> > > +
> > > +#if defined(CONFIG_IO_URING)
> > > +int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > > +			      struct iov_iter *iter, void *ioucmd);
> > > +void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
> > > +			unsigned issue_flags);
> > > +void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> > > +			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
> > > +			    unsigned flags);
> > > +/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
> > > +void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
> > > +			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
> > > +
> > > +static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> > > +			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
> > > +{
> > > +	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
> > > +}
> > > +
> > > +void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > > +		unsigned int issue_flags);
> > > +struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
> > > +
> > > +#else
> > > +static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > > +			      struct iov_iter *iter, void *ioucmd)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
> > > +		ssize_t ret2, unsigned issue_flags)
> > > +{
> > > +}
> > > +static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> > > +			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
> > > +{
> > > +}
> > > +static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
> > > +			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
> > > +{
> > > +}
> > > +static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > > +		unsigned int issue_flags)
> > > +{
> > > +}
> > > +static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
> > > +{
> > > +	return NULL;
> > > +}
> > > +#endif
> > > +
> > > +#endif /* _LINUX_IO_URING_CMD_H */
> > > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > > index d3009d56af0b..0bcecb734af3 100644
> > > --- a/include/linux/io_uring_types.h
> > > +++ b/include/linux/io_uring_types.h
> > > @@ -7,6 +7,26 @@
> > >   #include <linux/llist.h>
> > >   #include <uapi/linux/io_uring.h>
> > > +enum io_uring_cmd_flags {
> > > +	IO_URING_F_COMPLETE_DEFER	= 1,
> > > +	IO_URING_F_UNLOCKED		= 2,
> > > +	/* the request is executed from poll, it should not be freed */
> > > +	IO_URING_F_MULTISHOT		= 4,
> > > +	/* executed by io-wq */
> > > +	IO_URING_F_IOWQ			= 8,
> > > +	/* int's last bit, sign checks are usually faster than a bit test */
> > > +	IO_URING_F_NONBLOCK		= INT_MIN,
> > > +
> > > +	/* ctx state flags, for URING_CMD */
> > > +	IO_URING_F_SQE128		= (1 << 8),
> > > +	IO_URING_F_CQE32		= (1 << 9),
> > > +	IO_URING_F_IOPOLL		= (1 << 10),
> > > +
> > > +	/* set when uring wants to cancel a previously issued command */
> > > +	IO_URING_F_CANCEL		= (1 << 11),
> > > +	IO_URING_F_COMPAT		= (1 << 12),
> > > +};
> > 
> > I am wondering why you don't move io_uring_cmd_flags into
> > io_uring/cmd.h? And many above flags are used by driver now.
> > 
> > But most definitions in io_uring_types.h are actually io_uring
> > internal stuff.
> 
> That's because these are io_uring internal execution state flags,
> on top of which someone started to pile up cmd flags, not the
> other way around. No clue why it was named io_uring_cmd_flags.
> iow, the first 5 flags are widely used internally, moving them
> would force us to add cmd.h includes into all io_uring internals.
> 
> We could split the enum in half, but that would be more ugly
> as there are still packed into a single unsigned. And we can
> also get rid of IO_URING_F_SQE128 and others by checking
> ctx flags directly (with a helper), it'd be way better than
> having a cmd copy of specific flags.

OK, thanks for the explanation.

My only concern is about io_uring_types.h, which is used by io_uring
internal except for trace. If you think it is OK to expose it to driver
via io_uring/cmd.h now, this patch looks fine for me.


thanks,
Ming


