Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5253A6AFCC0
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 03:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCHCMX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 21:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCHCMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 21:12:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72B1A2C01
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 18:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678241469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LjIhpLNu1/FM8k7JR4dHiHXMiEFei7baHUdSFdODfCY=;
        b=IRlxBbc+YXAq6wkTY/5haLbjDEcoQDRK7/T+qfQORtvhq2tx7k6/DZ34OTV17Kv+w36jgL
        l4NtUu/Xa+KKUCDz4p/PsyF9VAA9KqeKLA5buVeEzfXmkHSq6sPh9b3/b5hdzdqOEQH/Ne
        ZyjuAk7Dz1ZO9pieFyyABIBiFIIE1QA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-X-y8KCpiMPyakzG6Xo6J1w-1; Tue, 07 Mar 2023 21:11:05 -0500
X-MC-Unique: X-y8KCpiMPyakzG6Xo6J1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 405A529AA2C1;
        Wed,  8 Mar 2023 02:11:05 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C7F914035711;
        Wed,  8 Mar 2023 02:10:59 +0000 (UTC)
Date:   Wed, 8 Mar 2023 10:10:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZAfurtfY4lXa8sxX@ovpn-8-16.pek2.redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
 <ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 07, 2023 at 05:17:04PM +0000, Pavel Begunkov wrote:
> On 3/7/23 15:37, Pavel Begunkov wrote:
> > On 3/7/23 14:15, Ming Lei wrote:
> > > Hello,
> > > 
> > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > > and its ->issue() can retrieve/import buffer from master request's
> > > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > > submits slave OP just like normal OP issued from userspace, that said,
> > > SQE order is kept, and batching handling is done too.
> > 
> >  From a quick look through patches it all looks a bit complicated
> > and intrusive, all over generic hot paths. I think instead we
> > should be able to use registered buffer table as intermediary and
> > reuse splicing. Let me try it out
> 
> Here we go, isolated in a new opcode, and in the end should work
> with any file supporting splice. It's a quick prototype, it's lacking
> and there are many obvious fatal bugs. It also needs some optimisations,
> improvements on how executed by io_uring and extra stuff like
> memcpy ops and fixed buf recv/send. I'll clean it up.
> 
> I used a test below, it essentially does zc recv.
> 
> https://github.com/isilence/liburing/commit/81fe705739af7d9b77266f9aa901c1ada870739d
> 
> 
> From 87ad9e8e3aed683aa040fb4b9ae499f8726ba393 Mon Sep 17 00:00:00 2001
> Message-Id: <87ad9e8e3aed683aa040fb4b9ae499f8726ba393.1678208911.git.asml.silence@gmail.com>
> From: Pavel Begunkov <asml.silence@gmail.com>
> Date: Tue, 7 Mar 2023 17:01:44 +0000
> Subject: [POC 1/1] io_uring: splicing into reg buf table
> 
> EXTREMELY BUGGY! Not for inclusion.
> 
> Add a new operation called IORING_OP_SPLICE_FROM,
> which splices from a file into the registered buffer table. This is
> done in a zerocopy fashion with a caveat that the user won't have
> direct access to the data, however it can use it with any io_uring
> request supporting registered buffers.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/uapi/linux/io_uring.h |  1 +
>  io_uring/io_uring.c           |  4 +-
>  io_uring/opdef.c              | 10 ++++
>  io_uring/splice.c             | 98 +++++++++++++++++++++++++++++++++++
>  io_uring/splice.h             |  3 ++
>  5 files changed, 114 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 709de6d4feb2..a91ce1d2ebd7 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -223,6 +223,7 @@ enum io_uring_op {
>  	IORING_OP_URING_CMD,
>  	IORING_OP_SEND_ZC,
>  	IORING_OP_SENDMSG_ZC,
> +	IORING_OP_SPLICE_FROM,
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 7625597b5227..b7389a6ea190 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2781,8 +2781,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>  	io_wait_rsrc_data(ctx->file_data);
>  	mutex_lock(&ctx->uring_lock);
> -	if (ctx->buf_data)
> -		__io_sqe_buffers_unregister(ctx);
> +	// if (ctx->buf_data)
> +	// 	__io_sqe_buffers_unregister(ctx);
>  	if (ctx->file_data)
>  		__io_sqe_files_unregister(ctx);
>  	io_cqring_overflow_kill(ctx);
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index cca7c5b55208..28d4fa42676b 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -428,6 +428,13 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_eopnotsupp_prep,
>  #endif
>  	},
> +	[IORING_OP_SPLICE_FROM] = {
> +		.needs_file		= 1,
> +		.unbound_nonreg_file	= 1,
> +		// .pollin			= 1,
> +		.prep			= io_splice_from_prep,
> +		.issue			= io_splice_from,
> +	}
>  };
> @@ -648,6 +655,9 @@ const struct io_cold_def io_cold_defs[] = {
>  		.fail			= io_sendrecv_fail,
>  #endif
>  	},
> +	[IORING_OP_SPLICE_FROM] = {
> +		.name			= "SPLICE_FROM",
> +	}
>  };
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/splice.c b/io_uring/splice.c
> index 2a4bbb719531..0467e9f46e99 100644
> --- a/io_uring/splice.c
> +++ b/io_uring/splice.c
> @@ -8,11 +8,13 @@
>  #include <linux/namei.h>
>  #include <linux/io_uring.h>
>  #include <linux/splice.h>
> +#include <linux/nospec.h>
>  #include <uapi/linux/io_uring.h>
>  #include "io_uring.h"
>  #include "splice.h"
> +#include "rsrc.h"
>  struct io_splice {
>  	struct file			*file_out;
> @@ -119,3 +121,99 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
>  	io_req_set_res(req, ret, 0);
>  	return IOU_OK;
>  }
> +
> +struct io_splice_from {
> +	struct file			*file;
> +	loff_t				off;
> +	u64				len;
> +};
> +
> +
> +int io_splice_from_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_splice_from *sp = io_kiocb_to_cmd(req, struct io_splice_from);
> +
> +	if (unlikely(sqe->splice_flags || sqe->splice_fd_in || sqe->ioprio ||
> +		     sqe->addr || sqe->addr3))
> +		return -EINVAL;
> +
> +	req->buf_index = READ_ONCE(sqe->buf_index);
> +
> +	sp->len = READ_ONCE(sqe->len);
> +	if (unlikely(!sp->len))
> +		return -EINVAL;
> +
> +	sp->off = READ_ONCE(sqe->off);
> +	return 0;
> +}
> +
> +int io_splice_from(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_splice_from *sp = io_kiocb_to_cmd(req, struct io_splice_from);
> +	loff_t *ppos = (sp->off == -1) ? NULL : &sp->off;
> +	struct io_mapped_ubuf *imu;
> +	struct pipe_inode_info *pi;
> +	struct io_ring_ctx *ctx;
> +	unsigned int pipe_tail;
> +	int ret, i, nr_pages;
> +	u16 index;
> +
> +	if (!sp->file->f_op->splice_read)
> +		return -ENOTSUPP;
> +
> +	pi = alloc_pipe_info();

The above should be replaced with direct pipe, otherwise every time
allocating one pipe inode really hurts performance.

> +	if (!pi)
> +		return -ENOMEM;
> +	pi->readers = 1;
> +
> +	ret = sp->file->f_op->splice_read(sp->file, ppos, pi, sp->len, 0);
> +	if (ret < 0)
> +		goto done;
> +
> +	nr_pages = pipe_occupancy(pi->head, pi->tail);
> +	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
> +	if (!imu)
> +		goto done;
> +
> +	ret = 0;
> +	pipe_tail = pi->tail;
> +	for (i = 0; !pipe_empty(pi->head, pipe_tail); i++) {
> +		unsigned int mask = pi->ring_size - 1; // kill mask
> +		struct pipe_buffer *buf = &pi->bufs[pipe_tail & mask];
> +
> +		bvec_set_page(&imu->bvec[i], buf->page, buf->len, buf->offset);
> +		ret += buf->len;
> +		pipe_tail++;
> +	}
> +	if (WARN_ON_ONCE(i != nr_pages))
> +		return -EFAULT;
> +
> +	ctx = req->ctx;
> +	io_ring_submit_lock(ctx, issue_flags);
> +	if (unlikely(req->buf_index >= ctx->nr_user_bufs)) {
> +		/* TODO: cleanup pages */
> +		ret = -EFAULT;
> +		kvfree(imu);
> +		goto done_unlock;
> +	}
> +	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
> +	if (ctx->user_bufs[index] != ctx->dummy_ubuf) {
> +		/* TODO: cleanup pages */
> +		kvfree(imu);
> +		ret = -EFAULT;
> +		goto done_unlock;
> +	}
> +
> +	imu->ubuf = 0;
> +	imu->ubuf_end = ret;
> +	imu->nr_bvecs = nr_pages;
> +	ctx->user_bufs[index] = imu;

Your patch looks like transferring pages ownership to io_uring fixed
buffer, but unfortunately it can't be done in this way. splice is
supposed for moving data, not transfer buffer ownership.

https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/

1) pages are actually owned by device side(ublk, here: sp->file), but we want to
loan them to io_uring normal OPs.

2) after these pages are used by io_uring normal OPs, these pages have
been returned back to sp->file, and the notification has to be done
explicitly, because page is owned by sp->file of splice_read().

3) pages RW direction has to limited strictly, and in case of ublk/fuse,
device pages can only be read or write which depends on user io request
direction.

Also IMO it isn't good to add one buffer to ctx->user_bufs[] oneshot and
retrieve it oneshot, and it can be set via req->imu simply in one fused
command.

Thanks,
Ming

