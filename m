Return-Path: <io-uring+bounces-6291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D09A2B9EF
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 04:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E0E5162711
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 03:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4BC12E1CD;
	Fri,  7 Feb 2025 03:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NviQFyn+"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2F71632F2
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 03:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738900331; cv=none; b=l3pGoXl6jmsGSL7uaOCrhTEtfz+v+I5dD3sdBn0kclfGui5n9WKfzIimByS6JuIuqbRf1nsSpHFqwdNPmGHZ+mENcxBYTRVFHnUKiSoPh3TFQpWBdiYLDIGqcynF9qxnloSuvkV1P+MdKmBr3LEGB4/a8xFQ7RxbAHJ0CbtvrcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738900331; c=relaxed/simple;
	bh=gLyOIxyU/lTzYHzQgUlsX6k87vGwfj77cTC+EmtQumI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2UlCVpNoAfNc3Cv4jMzvsAJMh55C0/wyv0ubllCcmY+k5vqCthqf00EfH5hnWF+t31wqzZiuow9wfPNed7ptNVlQfTzvL5C0WM0MNYeGxggVA2cSfca8/9QKskrmZeWTc8U112leagtwIlLcld9cRrIOL7kpzcTVdcrao3kE2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NviQFyn+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738900327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BxBEek3HoBBjZmmM7Ja8P6ff70Ie4PDh6pjJATyCWGo=;
	b=NviQFyn+adUs3pMiX7sIX5a9vKpZedO0lkem4eI3I68U8dp1vjWO7rOMirIY6OYxkRPuLp
	bGQ6GgjLfsbYk8TzZNuFDrWDvMeujV8KR6zipGr/StADW1u5R1YOtJ3wu8kXQQV8DZBjx7
	9kDdasTr45QVwPYBTVRvKxLoifWNnEc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-356-p2XVQIzONkG0SxHi1RasrA-1; Thu,
 06 Feb 2025 22:52:03 -0500
X-MC-Unique: p2XVQIzONkG0SxHi1RasrA-1
X-Mimecast-MFC-AGG-ID: p2XVQIzONkG0SxHi1RasrA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9059C18004A7;
	Fri,  7 Feb 2025 03:51:59 +0000 (UTC)
Received: from fedora (unknown [10.72.116.126])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D92E319560AE;
	Fri,  7 Feb 2025 03:51:54 +0000 (UTC)
Date: Fri, 7 Feb 2025 11:51:49 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk,
	asml.silence@gmail.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 0/6] ublk zero-copy support
Message-ID: <Z6WDVdYxxQT4Trj8@fedora>
References: <20250203154517.937623-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203154517.937623-1-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Feb 03, 2025 at 07:45:11AM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This is a new look at supporting zero copy with ublk.
> 
> The previous version from Ming can be viewed here:
> 
>   https://lore.kernel.org/linux-block/20241107110149.890530-1-ming.lei@redhat.com/
> 
> Based on the feedback from that thread, the desired io_uring interfaces
> needed to be simpler, and the kernel registered resources need to behave
> more similiar to user registered buffers.
> 
> This series introduces a new resource node type, KBUF, which, like the
> BUFFER resource, needs to be installed into an io_uring buf_node table
> in order for the user to access it in a fixed buffer command. The
> new io_uring kernel API provides a way for a user to register a struct
> request's bvec to a specific index, and a way to unregister it.
> 
> When the ublk server receives notification of a new command, it must
> first select an index and register the zero copy buffer. It may use that
> index for any number of fixed buffer commands, then it must unregister
> the index when it's done. This can all be done in a single io_uring_enter
> if desired, or it can be split into multiple enters if needed.

I suspect it may not be done in single io_uring_enter() because there
is strict dependency among the three OPs(register buffer, read/write,
unregister buffer).

> 
> The io_uring instance that gets the zero copy registration doesn't
> necessarily need to be the same ring that is receiving notifcations from
> the ublk_drv module. This allows you to split frontend and backend rings
> if desired.
> 
> At the end of this cover letter, I've provided a patch to the ublksrv to
> demonstrate how to use this.
> 
> Jens Axboe (1):
>   io_uring: use node for import
> 
> Keith Busch (5):
>   block: const blk_rq_nr_phys_segments request
>   io_uring: add support for kernel registered bvecs
>   ublk: zc register/unregister bvec
>   io_uring: add abstraction for buf_table rsrc data
>   io_uring: cache nodes and mapped buffers
> 
>  drivers/block/ublk_drv.c       | 139 +++++++++++++-----
>  include/linux/blk-mq.h         |   2 +-
>  include/linux/io_uring.h       |   1 +
>  include/linux/io_uring_types.h |  25 +++-
>  include/uapi/linux/ublk_cmd.h  |   4 +
>  io_uring/fdinfo.c              |   8 +-
>  io_uring/filetable.c           |   2 +-
>  io_uring/net.c                 |   5 +-
>  io_uring/nop.c                 |   2 +-
>  io_uring/register.c            |   2 +-
>  io_uring/rsrc.c                | 259 ++++++++++++++++++++++++++-------
>  io_uring/rsrc.h                |   8 +-
>  io_uring/rw.c                  |   4 +-
>  io_uring/uring_cmd.c           |   4 +-
>  14 files changed, 351 insertions(+), 114 deletions(-)
> 
> -- 
> 2.43.5
> 
> ublksrv:
> 
> https://github.com/ublk-org/ublksrv
> 
> ---
>  include/ublk_cmd.h    |  4 +++
>  include/ublksrv_tgt.h | 13 ++++++++
>  lib/ublksrv.c         |  9 ++++++
>  tgt_loop.cpp          | 74 +++++++++++++++++++++++++++++++++++++++++--
>  ublksrv_tgt.cpp       |  2 +-
>  5 files changed, 99 insertions(+), 3 deletions(-)
> 
> diff --git a/include/ublk_cmd.h b/include/ublk_cmd.h
> index 0150003..07439be 100644
> --- a/include/ublk_cmd.h
> +++ b/include/ublk_cmd.h
> @@ -94,6 +94,10 @@
>  	_IOWR('u', UBLK_IO_COMMIT_AND_FETCH_REQ, struct ublksrv_io_cmd)
>  #define	UBLK_U_IO_NEED_GET_DATA		\
>  	_IOWR('u', UBLK_IO_NEED_GET_DATA, struct ublksrv_io_cmd)
> +#define UBLK_U_IO_REGISTER_IO_BUF	\
> +	_IOWR('u', 0x23, struct ublksrv_io_cmd)
> +#define UBLK_U_IO_UNREGISTER_IO_BUF	\
> +	_IOWR('u', 0x24, struct ublksrv_io_cmd)
>  
>  /* only ABORT means that no re-fetch */
>  #define UBLK_IO_RES_OK			0
> diff --git a/include/ublksrv_tgt.h b/include/ublksrv_tgt.h
> index 1deee2b..6291531 100644
> --- a/include/ublksrv_tgt.h
> +++ b/include/ublksrv_tgt.h
> @@ -189,4 +189,17 @@ static inline void ublk_get_sqe_pair(struct io_uring *r,
>  		*sqe2 = io_uring_get_sqe(r);
>  }
>  
> +static inline void ublk_get_sqe_three(struct io_uring *r,
> +		struct io_uring_sqe **sqe1, struct io_uring_sqe **sqe2,
> +		struct io_uring_sqe **sqe3)
> +{
> +	unsigned left = io_uring_sq_space_left(r);
> +
> +	if (left < 3)
> +		io_uring_submit(r);
> +
> +	*sqe1 = io_uring_get_sqe(r);
> +	*sqe2 = io_uring_get_sqe(r);
> +	*sqe3 = io_uring_get_sqe(r);
> +}
>  #endif
> diff --git a/lib/ublksrv.c b/lib/ublksrv.c
> index 16a9e13..7205247 100644
> --- a/lib/ublksrv.c
> +++ b/lib/ublksrv.c
> @@ -619,6 +619,15 @@ skip_alloc_buf:
>  		goto fail;
>  	}
>  
> +	if (ctrl_dev->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY) {
> +		ret = io_uring_register_buffers_sparse(&q->ring, q->q_depth);
> +		if (ret) {
> +			ublk_err("ublk dev %d queue %d register spare buffers failed %d",
> +					q->dev->ctrl_dev->dev_info.dev_id, q->q_id, ret);
> +			goto fail;
> +		}
> +	}
> +
>  	io_uring_register_ring_fd(&q->ring);
>  
>  	/*
> diff --git a/tgt_loop.cpp b/tgt_loop.cpp
> index 0f16676..ce44c7d 100644
> --- a/tgt_loop.cpp
> +++ b/tgt_loop.cpp
> @@ -246,12 +246,62 @@ static inline int loop_fallocate_mode(const struct ublksrv_io_desc *iod)
>         return mode;
>  }
>  
> +static inline void io_uring_prep_buf_register(struct io_uring_sqe *sqe,
> +		int dev_fd, int tag, int q_id, __u64 index)
> +{
> +	struct ublksrv_io_cmd *cmd = (struct ublksrv_io_cmd *)sqe->cmd;
> +
> +	io_uring_prep_read(sqe, dev_fd, 0, 0, 0);
> +	sqe->opcode		= IORING_OP_URING_CMD;
> +	sqe->flags		|= IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_FILE;

IOSQE_IO_LINK is missed, because the following buffer consumer OP
has to be issued after this buffer register OP is completed.

> +	sqe->cmd_op		= UBLK_U_IO_REGISTER_IO_BUF;
> +
> +	cmd->tag		= tag;
> +	cmd->addr		= index;
> +	cmd->q_id		= q_id;
> +}
> +
> +static inline void io_uring_prep_buf_unregister(struct io_uring_sqe *sqe,
> +		int dev_fd, int tag, int q_id, __u64 index)
> +{
> +	struct ublksrv_io_cmd *cmd = (struct ublksrv_io_cmd *)sqe->cmd;
> +
> +	io_uring_prep_read(sqe, dev_fd, 0, 0, 0);
> +	sqe->opcode		= IORING_OP_URING_CMD;
> +	sqe->flags		|= IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_FILE;
> +	sqe->cmd_op		= UBLK_U_IO_UNREGISTER_IO_BUF;

IOSQE_IO_LINK is missed, because buffer un-register OP has to be issued
after the previous buffer consumer OP is completed.

> +
> +	cmd->tag		= tag;
> +	cmd->addr		= index;
> +	cmd->q_id		= q_id;
> +}
> +
>  static void loop_queue_tgt_read(const struct ublksrv_queue *q,
>  		const struct ublksrv_io_desc *iod, int tag)
>  {
> +	const struct ublksrv_ctrl_dev_info *info =
> +		ublksrv_ctrl_get_dev_info(ublksrv_get_ctrl_dev(q->dev));
>  	unsigned ublk_op = ublksrv_get_op(iod);
>  
> -	if (user_copy) {
> +	if (info->flags & UBLK_F_SUPPORT_ZERO_COPY) {
> +		struct io_uring_sqe *reg;
> +		struct io_uring_sqe *read;
> +		struct io_uring_sqe *ureg;
> +
> +		ublk_get_sqe_three(q->ring_ptr, &reg, &read, &ureg);
> +
> +		io_uring_prep_buf_register(reg, 0, tag, q->q_id, tag);
> +
> +		io_uring_prep_read_fixed(read, 1 /*fds[1]*/,
> +			0,
> +			iod->nr_sectors << 9,
> +			iod->start_sector << 9,
> +			tag);
> +		io_uring_sqe_set_flags(read, IOSQE_FIXED_FILE);
> +		read->user_data = build_user_data(tag, ublk_op, 0, 1);

Does this interface support to read to partial buffer? Which is useful
for stacking device cases.

Also does this interface support to consume the buffer from multiple
OPs concurrently? 


Thanks, 
Ming


