Return-Path: <io-uring+bounces-143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF2F37F5D96
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 12:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74C281F20F0F
	for <lists+io-uring@lfdr.de>; Thu, 23 Nov 2023 11:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BB422F06;
	Thu, 23 Nov 2023 11:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+4PiOro"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB9B9;
	Thu, 23 Nov 2023 03:17:56 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2c87903d314so9598111fa.1;
        Thu, 23 Nov 2023 03:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700738275; x=1701343075; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xDWCb13i2Xqk5Lu2xg2VMmlaPURyczdB2TczHpewQdY=;
        b=E+4PiOroJAO467yYLlS2h3rkyVh4JPlrBRzQHkBbDZC1Xla0edBtUA8NnKJTLAQNbB
         p8yGxM505voyuZEjJCJTnQCcLr0sBNTtqSlpIYVPi3x2bdb8fDVoWLcpmz9hpPhM+wN9
         hKPm5xDZ/eXuNGSzxAlv/9qX2RXvea6nn9KSon9n8BDOZ5v0d9ClgcB5NacDlBYz6mbX
         w6iHwg3ZoSi/q7loAUteX2IxTx0LdM60xi+K8gJp0+a7GyWy8wbUb6AdcTERSBMKiI7r
         rLrFTJg/5b+jGKHSGtk6m2mifb5Qi6XPzX6nJ1qv/3pcj2xSja02oh+oCkV//IGU2uYd
         zbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700738275; x=1701343075;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDWCb13i2Xqk5Lu2xg2VMmlaPURyczdB2TczHpewQdY=;
        b=SPOscyJPC4lrUxGyLJ2INL2ma9QtZJZIEfP9Xe5+nKaX0mw+xJ6KaMPJsL1D0faIZo
         wyPhh1xRJ5lOpe7b2mu+b/A78VdzpiQRZfm5TndmR3+TD8yFvxz5ePJwqOtSQh87QioY
         NWtSh2cnvT8s6R9vxCijhHfjuEe94pkOEo4ibgvcx2T79XB5L5+FlN18nI/86KWxuVvl
         kz1p2ofK8E2RMtrIlLkHNrmjg1QB2Skrx6BV6vRhinh8aatIKT4jssgfEVOax0XFazYN
         k0A0hwUF4Nz1r3Kh4QwA4nJ0MYYvSlILwpOsfD88FPdElVWzA4F93dtkXl21OcvP0zOp
         cbNQ==
X-Gm-Message-State: AOJu0Yxy9hBZxYfg0/tPcveO/a8koDo9gRFuyI+RYUq/NFDYvCBwk0as
	pSjkyV5EyKAdR/dy046MPK9kEw8ucvI=
X-Google-Smtp-Source: AGHT+IFdINifXb6PzesvFjPCVh4KHe4pAkoD5GpW/04BFz0JaYKZBH3fGF2zY9twj4TRqf0u7lrM3w==
X-Received: by 2002:a2e:8e68:0:b0:2c6:f3fd:7f0 with SMTP id t8-20020a2e8e68000000b002c6f3fd07f0mr2985542ljk.19.1700738274443;
        Thu, 23 Nov 2023 03:17:54 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.145])
        by smtp.gmail.com with ESMTPSA id hg15-20020a05600c538f00b0040849ce7116sm2307863wmb.43.2023.11.23.03.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Nov 2023 03:17:54 -0800 (PST)
Message-ID: <c204c03a-785d-4872-a8c8-58d0cdc708d6@gmail.com>
Date: Thu, 23 Nov 2023 11:16:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: split out cmd api into a separate header
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, joshi.k@samsung.com
References: <cover.1700668641.git.asml.silence@gmail.com>
 <547e56560b97cd66f00bfc5b53db24f2fa1a8852.1700668641.git.asml.silence@gmail.com>
 <ZV67ozp4yizgWYYg@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZV67ozp4yizgWYYg@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/23 02:40, Ming Lei wrote:
> On Wed, Nov 22, 2023 at 04:01:09PM +0000, Pavel Begunkov wrote:
>> linux/io_uring.h is slowly becoming a rubbish bin where we put
>> anything exposed to other subsystems. For instance, the task exit
>> hooks and io_uring cmd infra are completely orthogonal and don't need
>> each other's definitions. Start cleaning it up by splitting out all
>> command bits into a new header file.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   drivers/block/ublk_drv.c       |  2 +-
>>   drivers/nvme/host/ioctl.c      |  2 +-
>>   include/linux/io_uring.h       | 89 +---------------------------------
>>   include/linux/io_uring/cmd.h   | 81 +++++++++++++++++++++++++++++++
>>   include/linux/io_uring_types.h | 20 ++++++++
>>   io_uring/io_uring.c            |  1 +
>>   io_uring/rw.c                  |  2 +-
>>   io_uring/uring_cmd.c           |  2 +-
>>   8 files changed, 107 insertions(+), 92 deletions(-)
>>   create mode 100644 include/linux/io_uring/cmd.h
>>
>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>> index 83600b45e12a..909377068a87 100644
>> --- a/drivers/block/ublk_drv.c
>> +++ b/drivers/block/ublk_drv.c
>> @@ -36,7 +36,7 @@
>>   #include <linux/sched/mm.h>
>>   #include <linux/uaccess.h>
>>   #include <linux/cdev.h>
>> -#include <linux/io_uring.h>
>> +#include <linux/io_uring/cmd.h>
>>   #include <linux/blk-mq.h>
>>   #include <linux/delay.h>
>>   #include <linux/mm.h>
>> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
>> index 529b9954d2b8..6864a6eeee93 100644
>> --- a/drivers/nvme/host/ioctl.c
>> +++ b/drivers/nvme/host/ioctl.c
>> @@ -5,7 +5,7 @@
>>    */
>>   #include <linux/ptrace.h>	/* for force_successful_syscall_return */
>>   #include <linux/nvme_ioctl.h>
>> -#include <linux/io_uring.h>
>> +#include <linux/io_uring/cmd.h>
>>   #include "nvme.h"
>>   
>>   enum {
>> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>> index aefb73eeeebf..d8fc93492dc5 100644
>> --- a/include/linux/io_uring.h
>> +++ b/include/linux/io_uring.h
>> @@ -6,71 +6,13 @@
>>   #include <linux/xarray.h>
>>   #include <uapi/linux/io_uring.h>
>>   
>> -enum io_uring_cmd_flags {
>> -	IO_URING_F_COMPLETE_DEFER	= 1,
>> -	IO_URING_F_UNLOCKED		= 2,
>> -	/* the request is executed from poll, it should not be freed */
>> -	IO_URING_F_MULTISHOT		= 4,
>> -	/* executed by io-wq */
>> -	IO_URING_F_IOWQ			= 8,
>> -	/* int's last bit, sign checks are usually faster than a bit test */
>> -	IO_URING_F_NONBLOCK		= INT_MIN,
>> -
>> -	/* ctx state flags, for URING_CMD */
>> -	IO_URING_F_SQE128		= (1 << 8),
>> -	IO_URING_F_CQE32		= (1 << 9),
>> -	IO_URING_F_IOPOLL		= (1 << 10),
>> -
>> -	/* set when uring wants to cancel a previously issued command */
>> -	IO_URING_F_CANCEL		= (1 << 11),
>> -	IO_URING_F_COMPAT		= (1 << 12),
>> -};
>> -
>> -/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>> -#define IORING_URING_CMD_CANCELABLE	(1U << 30)
>> -#define IORING_URING_CMD_POLLED		(1U << 31)
>> -
>> -struct io_uring_cmd {
>> -	struct file	*file;
>> -	const struct io_uring_sqe *sqe;
>> -	union {
>> -		/* callback to defer completions to task context */
>> -		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
>> -		/* used for polled completion */
>> -		void *cookie;
>> -	};
>> -	u32		cmd_op;
>> -	u32		flags;
>> -	u8		pdu[32]; /* available inline for free use */
>> -};
>> -
>> -static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
>> -{
>> -	return sqe->cmd;
>> -}
>> -
>>   #if defined(CONFIG_IO_URING)
>> -int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>> -			      struct iov_iter *iter, void *ioucmd);
>> -void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
>> -			unsigned issue_flags);
>>   struct sock *io_uring_get_socket(struct file *file);
>>   void __io_uring_cancel(bool cancel_all);
>>   void __io_uring_free(struct task_struct *tsk);
>>   void io_uring_unreg_ringfd(void);
>>   const char *io_uring_get_opcode(u8 opcode);
>> -void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>> -			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>> -			    unsigned flags);
>> -/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
>> -void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>> -			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
>> -
>> -static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> -			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> -{
>> -	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
>> -}
>> +int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>   
>>   static inline void io_uring_files_cancel(void)
>>   {
>> @@ -89,28 +31,7 @@ static inline void io_uring_free(struct task_struct *tsk)
>>   	if (tsk->io_uring)
>>   		__io_uring_free(tsk);
>>   }
>> -int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
>> -void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>> -		unsigned int issue_flags);
>> -struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
>>   #else
>> -static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>> -			      struct iov_iter *iter, void *ioucmd)
>> -{
>> -	return -EOPNOTSUPP;
>> -}
>> -static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
>> -		ssize_t ret2, unsigned issue_flags)
>> -{
>> -}
>> -static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> -			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> -{
>> -}
>> -static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>> -			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> -{
>> -}
>>   static inline struct sock *io_uring_get_socket(struct file *file)
>>   {
>>   	return NULL;
>> @@ -133,14 +54,6 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
>>   {
>>   	return -EOPNOTSUPP;
>>   }
>> -static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>> -		unsigned int issue_flags)
>> -{
>> -}
>> -static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
>> -{
>> -	return NULL;
>> -}
>>   #endif
>>   
>>   #endif
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> new file mode 100644
>> index 000000000000..62fcfaf6fcc9
>> --- /dev/null
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -0,0 +1,81 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +#ifndef _LINUX_IO_URING_CMD_H
>> +#define _LINUX_IO_URING_CMD_H
>> +
>> +#include <uapi/linux/io_uring.h>
>> +#include <linux/io_uring_types.h>
>> +
>> +/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>> +#define IORING_URING_CMD_CANCELABLE	(1U << 30)
>> +#define IORING_URING_CMD_POLLED		(1U << 31)
>> +
>> +struct io_uring_cmd {
>> +	struct file	*file;
>> +	const struct io_uring_sqe *sqe;
>> +	union {
>> +		/* callback to defer completions to task context */
>> +		void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
>> +		/* used for polled completion */
>> +		void *cookie;
>> +	};
>> +	u32		cmd_op;
>> +	u32		flags;
>> +	u8		pdu[32]; /* available inline for free use */
>> +};
>> +
>> +static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
>> +{
>> +	return sqe->cmd;
>> +}
>> +
>> +#if defined(CONFIG_IO_URING)
>> +int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>> +			      struct iov_iter *iter, void *ioucmd);
>> +void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
>> +			unsigned issue_flags);
>> +void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>> +			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>> +			    unsigned flags);
>> +/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
>> +void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>> +			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
>> +
>> +static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> +			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +{
>> +	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
>> +}
>> +
>> +void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>> +		unsigned int issue_flags);
>> +struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
>> +
>> +#else
>> +static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>> +			      struct iov_iter *iter, void *ioucmd)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
>> +		ssize_t ret2, unsigned issue_flags)
>> +{
>> +}
>> +static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>> +			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +{
>> +}
>> +static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>> +			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>> +{
>> +}
>> +static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>> +		unsigned int issue_flags)
>> +{
>> +}
>> +static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
>> +{
>> +	return NULL;
>> +}
>> +#endif
>> +
>> +#endif /* _LINUX_IO_URING_CMD_H */
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index d3009d56af0b..0bcecb734af3 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -7,6 +7,26 @@
>>   #include <linux/llist.h>
>>   #include <uapi/linux/io_uring.h>
>>   
>> +enum io_uring_cmd_flags {
>> +	IO_URING_F_COMPLETE_DEFER	= 1,
>> +	IO_URING_F_UNLOCKED		= 2,
>> +	/* the request is executed from poll, it should not be freed */
>> +	IO_URING_F_MULTISHOT		= 4,
>> +	/* executed by io-wq */
>> +	IO_URING_F_IOWQ			= 8,
>> +	/* int's last bit, sign checks are usually faster than a bit test */
>> +	IO_URING_F_NONBLOCK		= INT_MIN,
>> +
>> +	/* ctx state flags, for URING_CMD */
>> +	IO_URING_F_SQE128		= (1 << 8),
>> +	IO_URING_F_CQE32		= (1 << 9),
>> +	IO_URING_F_IOPOLL		= (1 << 10),
>> +
>> +	/* set when uring wants to cancel a previously issued command */
>> +	IO_URING_F_CANCEL		= (1 << 11),
>> +	IO_URING_F_COMPAT		= (1 << 12),
>> +};
> 
> I am wondering why you don't move io_uring_cmd_flags into
> io_uring/cmd.h? And many above flags are used by driver now.
> 
> But most definitions in io_uring_types.h are actually io_uring
> internal stuff.

That's because these are io_uring internal execution state flags,
on top of which someone started to pile up cmd flags, not the
other way around. No clue why it was named io_uring_cmd_flags.
iow, the first 5 flags are widely used internally, moving them
would force us to add cmd.h includes into all io_uring internals.

We could split the enum in half, but that would be more ugly
as there are still packed into a single unsigned. And we can
also get rid of IO_URING_F_SQE128 and others by checking
ctx flags directly (with a helper), it'd be way better than
having a cmd copy of specific flags.

-- 
Pavel Begunkov

