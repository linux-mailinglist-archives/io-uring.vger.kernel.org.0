Return-Path: <io-uring+bounces-3421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 576509907D0
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 17:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AFEB28AC96
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0E51E282B;
	Fri,  4 Oct 2024 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtBP5V9P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEF01E32B4;
	Fri,  4 Oct 2024 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728055898; cv=none; b=k0pssoh1xr0hP/p7pZTwCoeZWos6AOtjF+0hRSZWslYy6NL98sUXETRonq951L4g6dztVe1q2XLEHcGNFbb1MZbmFf+MiFv3b64T7TP2Usizj/+L0++vbaOFJg3WpJxWamfjzj3i2bHjB+2YuPtzJB6KnXpOf6Lr6/igExjZzYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728055898; c=relaxed/simple;
	bh=f5/ni8h3DdZKoKWyc5z80VKCL1LayDLkjL6Ene1yzmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+rvzFq5nRmi5246+WZbLbqOp/cRHO1J6BtTc6WBInWz4VZBaAkKplbDlptJnN/Eu+c3UG8gplPlXyRohQFjC75xGv6mi/lYrYuwBAdhIVJMeE7T0/y76OqVNqkRdBh9r36ay4z7uH6HluYIePgtM5ff0X6Uvg3shzA1cVALTKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtBP5V9P; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c896b9b4e0so3098868a12.3;
        Fri, 04 Oct 2024 08:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728055895; x=1728660695; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KpgCnbUnyGHcgAECDbGFdsBjlW4u9W2300inp7VuFq0=;
        b=NtBP5V9PnLuBPrSPCDuwI4KC8CWI4V0bMnrz+JY5WNdWg6Tsd5f4G7j66cYLhOsNTa
         gEe6R8JM6s9Bdbki0vOD3whnO8C1EVi/zIuCvhIwqnA8gQGJ5Ue9R6KrOpVVu1sHgp6V
         FANKQWvusYW+Fs3bVQuX/uN83+y7z+hiSt0nxASnPiB0LYBQc/gnoq65yVHN5ODru7Qs
         V30Gwksjg5JLFMjapQl/AXsbCjrP69RWS0N6HmSGvADyhMXFYYMo/xl2uZuodVUaFJUR
         olgfl0P9bVwfOckfGFUo5acQS8SJDZgBQ2cloBYwpBw1kQ6JlXqiye7ITHlYu2z2L8kp
         wxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728055895; x=1728660695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KpgCnbUnyGHcgAECDbGFdsBjlW4u9W2300inp7VuFq0=;
        b=KMHdQKYQjtAcbyOzdKijl6BkfqxOdiBNnZ+ixytI+DmWhm92685hfdNou1OY5Q76Nd
         MBDfDWCh3+c56zYWAp9Yz+iu3johNg0djLVj1sw/4ge5BtOHrBL7DMkQfzS2wE/nOZfu
         wHFl6JGwG8+6ZzNe19m8PgIsdhMVAZjnBZQapgP2YxhFGUAq1k3P62Yedeloj3jcqQQS
         IYZ4m5sWhDWAHOzUaBeEcXDChBJSpH2ufrpdYlTnAcppyJu1uA1KKPyV3ETjki6GUG9h
         uaxVS96xZTNeLIXgjQHWg36aE/yru7m2hIlzQf2yx+e/cjoOmovNypw+uekvh9km5hLo
         77oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhc5wwfTNwpvwYkdhrh/sMoXPaWYLfW6OlzW5PYNVZfcQn0fRdLBkPuXB5GV8OL3Rr0C5OdKQFEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPHKVS5znTXb2+oqVIH0mEVPR+hGRMHIVOZ994L/EkGeSNbIyW
	8FRcxCelWh3eUwfzwWWkbXz+EmBwfYBlD/JV3t5c7VZ/EPintwq+
X-Google-Smtp-Source: AGHT+IEML6zwtdg4bf7900lxMLOZ08qSJJp7cNp4wH/EhIsHroMsTS0v5tkPBsasYQ53vrl1p90EIg==
X-Received: by 2002:a17:907:e6c5:b0:a8d:4845:de57 with SMTP id a640c23a62f3a-a991bd0d398mr300657066b.26.1728055894499;
        Fri, 04 Oct 2024 08:31:34 -0700 (PDT)
Received: from [192.168.42.59] (82-132-213-31.dab.02.net. [82.132.213.31])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a992e7d4d9csm4843066b.182.2024.10.04.08.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 08:31:34 -0700 (PDT)
Message-ID: <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
Date: Fri, 4 Oct 2024 16:32:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240912104933.1875409-7-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 11:49, Ming Lei wrote:
...
> It can help to implement generic zero copy between device and related
> operations, such as ublk, fuse, vdpa,
> even network receive or whatever.

That's exactly the thing it can't sanely work with because
of this design.

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/io_uring_types.h | 33 +++++++++++++++++++
>   io_uring/io_uring.c            | 10 +++++-
>   io_uring/io_uring.h            | 10 ++++++
>   io_uring/kbuf.c                | 60 ++++++++++++++++++++++++++++++++++
>   io_uring/kbuf.h                | 13 ++++++++
>   io_uring/net.c                 | 23 ++++++++++++-
>   io_uring/opdef.c               |  4 +++
>   io_uring/opdef.h               |  2 ++
>   io_uring/rw.c                  | 20 +++++++++++-
>   9 files changed, 172 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 793d5a26d9b8..445e5507565a 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -6,6 +6,7 @@
>   #include <linux/task_work.h>
>   #include <linux/bitmap.h>
>   #include <linux/llist.h>
> +#include <linux/bvec.h>
>   #include <uapi/linux/io_uring.h>
>   
>   enum {
> @@ -39,6 +40,26 @@ enum io_uring_cmd_flags {
>   	IO_URING_F_COMPAT		= (1 << 12),
>   };
>   
> +struct io_uring_kernel_buf;
> +typedef void (io_uring_buf_giveback_t) (const struct io_uring_kernel_buf *);
> +
> +/* buffer provided from kernel */
> +struct io_uring_kernel_buf {
> +	unsigned long		len;
> +	unsigned short		nr_bvecs;
> +	unsigned char		dir;	/* ITER_SOURCE or ITER_DEST */
> +
> +	/* offset in the 1st bvec */
> +	unsigned int		offset;
> +	const struct bio_vec	*bvec;
> +
> +	/* called when we are done with this buffer */
> +	io_uring_buf_giveback_t	*grp_kbuf_ack;
> +
> +	/* private field, user don't touch it */
> +	struct bio_vec		__bvec[];
> +};
> +
>   struct io_wq_work_node {
>   	struct io_wq_work_node *next;
>   };
> @@ -473,6 +494,7 @@ enum {
>   	REQ_F_BUFFERS_COMMIT_BIT,
>   	REQ_F_SQE_GROUP_LEADER_BIT,
>   	REQ_F_SQE_GROUP_DEP_BIT,
> +	REQ_F_GROUP_KBUF_BIT,
>   
>   	/* not a real bit, just to check we're not overflowing the space */
>   	__REQ_F_LAST_BIT,
> @@ -557,6 +579,8 @@ enum {
>   	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
>   	/* sqe group with members depending on leader */
>   	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
> +	/* group lead provides kbuf for members, set for both lead and member */
> +	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),

We have a huge flag problem here. It's a 4th group flag, that gives
me an idea that it's overabused. We're adding state machines based on
them "set group, clear group, but if last set it again. And clear
group lead if refs are of particular value". And it's not really
clear what these two flags are here for or what they do.

 From what I see you need here just one flag to mark requests
that provide a buffer, ala REQ_F_PROVIDING_KBUF. On the import
side:

if ((req->flags & GROUP) && (req->lead->flags & REQ_F_PROVIDING_KBUF))
	...

And when you kill the request:

if (req->flags & REQ_F_PROVIDING_KBUF)
	io_group_kbuf_drop();

And I don't think you need opdef::accept_group_kbuf since the
request handler should already know that and, importantly, you don't
imbue any semantics based on it.

FWIW, would be nice if during init figure we can verify that the leader
provides a buffer IFF there is someone consuming it, but I don't think
the semantics is flexible enough to do it sanely. i.e. there are many
members in a group, some might want to use the buffer and some might not.


>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
> @@ -640,6 +664,15 @@ struct io_kiocb {
>   		 * REQ_F_BUFFER_RING is set.
>   		 */
>   		struct io_buffer_list	*buf_list;
> +
> +		/*
> +		 * store kernel buffer provided by sqe group lead, valid
> +		 * IFF REQ_F_GROUP_KBUF
> +		 *
> +		 * The buffer meta is immutable since it is shared by
> +		 * all member requests
> +		 */
> +		const struct io_uring_kernel_buf *grp_kbuf;
>   	};
>   
>   	union {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 99b44b6babd6..80c4d9192657 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -116,7 +116,7 @@
>   
>   #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
>   				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
> -				REQ_F_ASYNC_DATA)
> +				REQ_F_ASYNC_DATA | REQ_F_GROUP_KBUF)
>   
>   #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
>   				 REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER | \
> @@ -387,6 +387,11 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>   
>   static void io_clean_op(struct io_kiocb *req)
>   {
> +	/* GROUP_KBUF is only available for REQ_F_SQE_GROUP_DEP */
> +	if ((req->flags & (REQ_F_GROUP_KBUF | REQ_F_SQE_GROUP_DEP)) ==
> +			(REQ_F_GROUP_KBUF | REQ_F_SQE_GROUP_DEP))
> +		io_group_kbuf_drop(req);
> +
>   	if (req->flags & REQ_F_BUFFER_SELECTED) {
>   		spin_lock(&req->ctx->completion_lock);
>   		io_kbuf_drop(req);
> @@ -914,9 +919,12 @@ static void io_queue_group_members(struct io_kiocb *req)
>   
>   	req->grp_link = NULL;
>   	while (member) {
> +		const struct io_issue_def *def = &io_issue_defs[member->opcode];
>   		struct io_kiocb *next = member->grp_link;
>   
>   		member->grp_leader = req;
> +		if ((req->flags & REQ_F_GROUP_KBUF) && def->accept_group_kbuf)
> +			member->flags |= REQ_F_GROUP_KBUF;

As per above I suspect that is not needed.

>   		if (unlikely(member->flags & REQ_F_FAIL)) {
>   			io_req_task_queue_fail(member, member->cqe.res);
>   		} else if (unlikely(req->flags & REQ_F_FAIL)) {
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index df2be7353414..8e111d24c02d 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -349,6 +349,16 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
>   	return req->flags & REQ_F_SQE_GROUP_LEADER;
>   }
>   
...
> +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
> +		unsigned int len, int dir, struct iov_iter *iter)
> +{
> +	struct io_kiocb *lead = req->grp_link;
> +	const struct io_uring_kernel_buf *kbuf;
> +	unsigned long offset;
> +
> +	WARN_ON_ONCE(!(req->flags & REQ_F_GROUP_KBUF));
> +
> +	if (!req_is_group_member(req))
> +		return -EINVAL;
> +
> +	if (!lead || !req_support_group_dep(lead) || !lead->grp_kbuf)
> +		return -EINVAL;
> +
> +	/* req->fused_cmd_kbuf is immutable */
> +	kbuf = lead->grp_kbuf;
> +	offset = kbuf->offset;
> +
> +	if (!kbuf->bvec)
> +		return -EINVAL;

How can this happen?

> +	if (dir != kbuf->dir)
> +		return -EINVAL;
> +
> +	if (unlikely(buf_off > kbuf->len))
> +		return -EFAULT;
> +
> +	if (unlikely(len > kbuf->len - buf_off))
> +		return -EFAULT;

check_add_overflow() would be more readable

> +
> +	/* don't use io_import_fixed which doesn't support multipage bvec */
> +	offset += buf_off;
> +	iov_iter_bvec(iter, dir, kbuf->bvec, kbuf->nr_bvecs, offset + len);
> +
> +	if (offset)
> +		iov_iter_advance(iter, offset);
> +
> +	return 0;
> +}
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index 36aadfe5ac00..37d18324e840 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -89,6 +89,11 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
>   				      unsigned long bgid);
>   int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
>   
> +int io_provide_group_kbuf(struct io_kiocb *req,
> +		const struct io_uring_kernel_buf *grp_kbuf);
> +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
> +		unsigned int len, int dir, struct iov_iter *iter);
> +
>   static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
>   {
>   	/*
> @@ -220,4 +225,12 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
>   {
>   	return __io_put_kbufs(req, len, nbufs, issue_flags);
>   }
> +
> +static inline void io_group_kbuf_drop(struct io_kiocb *req)
> +{
> +	const struct io_uring_kernel_buf *gbuf = req->grp_kbuf;
> +
> +	if (gbuf && gbuf->grp_kbuf_ack)

How can ->grp_kbuf_ack be missing?

> +		gbuf->grp_kbuf_ack(gbuf);
> +}
>   #endif
> diff --git a/io_uring/net.c b/io_uring/net.c
> index f10f5a22d66a..ad24dd5924d2 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -89,6 +89,13 @@ struct io_sr_msg {
>    */
>   #define MULTISHOT_MAX_RETRY	32
>   
> +#define user_ptr_to_u64(x) (		\
> +{					\
> +	typecheck(void __user *, (x));	\
> +	(u64)(unsigned long)(x);	\
> +}					\
> +)
> +
>   int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   {
>   	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
> @@ -375,7 +382,7 @@ static int io_send_setup(struct io_kiocb *req)
>   		kmsg->msg.msg_name = &kmsg->addr;
>   		kmsg->msg.msg_namelen = sr->addr_len;
>   	}
> -	if (!io_do_buffer_select(req)) {
> +	if (!io_do_buffer_select(req) && !(req->flags & REQ_F_GROUP_KBUF)) {
>   		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
>   				  &kmsg->msg.msg_iter);
>   		if (unlikely(ret < 0))
> @@ -593,6 +600,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
>   	if (issue_flags & IO_URING_F_NONBLOCK)
>   		flags |= MSG_DONTWAIT;
>   
> +	if (req->flags & REQ_F_GROUP_KBUF) {

Does anything prevent the request to be marked by both
GROUP_KBUF and BUFFER_SELECT? In which case we'd set up
a group kbuf and then go to the io_do_buffer_select()
overriding all of that

> +		ret = io_import_group_kbuf(req,
> +					user_ptr_to_u64(sr->buf),
> +					sr->len, ITER_SOURCE,
> +					&kmsg->msg.msg_iter);
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +
>   retry_bundle:
>   	if (io_do_buffer_select(req)) {
>   		struct buf_sel_arg arg = {
> @@ -1154,6 +1170,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>   			goto out_free;
>   		}
>   		sr->buf = NULL;
> +	} else if (req->flags & REQ_F_GROUP_KBUF) {

What happens if we get a short read/recv?

> +		ret = io_import_group_kbuf(req, user_ptr_to_u64(sr->buf),
> +				sr->len, ITER_DEST, &kmsg->msg.msg_iter);
> +		if (unlikely(ret))
> +			goto out_free;
>   	}
>   
>   	kmsg->msg.msg_flags = 0;
...

-- 
Pavel Begunkov

