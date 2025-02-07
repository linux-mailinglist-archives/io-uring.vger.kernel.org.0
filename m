Return-Path: <io-uring+bounces-6300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 012A3A2C6AD
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 16:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDAC17A1A86
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 15:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C19238D5A;
	Fri,  7 Feb 2025 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0lDI0fK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8963238D59;
	Fri,  7 Feb 2025 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738941465; cv=none; b=NsJQgkAryAAYPwXemF5H2xMTH/3/UyJTduHmUOi8TIn+i05xwSwy5chHrFekJwmDADjDumfEmMEEuJ7Hcw3JmdksWhoTNrxw5cjngVj3LrIQ9bva8jPSxEAPveqnFYdqQDPjTdQNDmsUvzHaj0S90ymaY7eR2KwXpHms4ll56Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738941465; c=relaxed/simple;
	bh=dfZpokZWz7HpV4GWMGvWCSsakh2UsHzo49tDGK+MDGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkI2T4Ox8h14S0zgta7dUt5m7g/6gbRABya2CzxzZyd+U1j+Woyi8fOTCTz47rT9kGDvaSEmxiAZ8wdueauYwTs0lZAHx8zrITqCZ3RQlqyXCHKwFx4wSIQKXL47PQWNjqrjfCK6JLtlsGvx/5S2219TSAVIcjKMmmfvJccH/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0lDI0fK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F6DC4CED1;
	Fri,  7 Feb 2025 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738941465;
	bh=dfZpokZWz7HpV4GWMGvWCSsakh2UsHzo49tDGK+MDGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A0lDI0fK2/h3RkL+L8389U7m8/qgtUSFehnwuOGmMvuIIgAWY1tjW7/bvlDkOGO6+
	 lPqp5zMenkmz4pBieoPz9aToKSb7EOt8uReylh5/MtFtZYj8957kyfgRvsTLwlVVPh
	 UK43e/a1HyBR/C/pN41QURb9tIp34OcgXIt8AnM4w5vhwO7K0aViP5ofJjsK6FonbA
	 du3SqKgWa4xC1JiUl1ZMbC2JUGP3ji1TJISQsfBlks+udYqbIbQq8U4WSEa8HlQAa5
	 iUMeg/km/OY8yUleUmxmNhCi6VpG5bHeZfHCuXRCjKlgjOUJV4RptBYPIFvlgPns8P
	 HdttlULQCKpKg==
Date: Fri, 7 Feb 2025 08:17:42 -0700
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH 3/6] io_uring: add support for kernel registered bvecs
Message-ID: <Z6YkFsathkU6ltTS@kbusch-mbp>
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-4-kbusch@meta.com>
 <b36f0c87-71ad-444f-b234-f71953ca58ba@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b36f0c87-71ad-444f-b234-f71953ca58ba@gmail.com>

On Fri, Feb 07, 2025 at 02:08:23PM +0000, Pavel Begunkov wrote:
> On 2/3/25 15:45, Keith Busch wrote:
> >   		struct io_rsrc_node *node;
> >   		u64 tag = 0;
> > +		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
> > +		node = io_rsrc_node_lookup(&ctx->buf_table, i);
> > +		if (node && node->type != IORING_RSRC_BUFFER) {
> 
> We might need to rethink how it's unregistered. The next patch
> does it as a ublk commands, but what happens if it gets ejected
> by someone else?  get_page might protect from kernel corruption
> and here you try to forbid ejections, but there is io_rsrc_data_free()
> and the io_uring ctx can die as well and it will have to drop it.

We prevent clearing an index through the typical user register update
call. The expected way to clear for a well functioning program is
through the kernel interfaces.

Other than that, there's nothing special about kernel buffers here. You
can kill the ring or tear down registered buffer table, but that same
scenario exists for user registered buffers. The only thing io_uring
needs to ensure is that nothing gets corrupted. User registered buffers
hold a pin on the user pages while the node is referenced. Kernel
registered buffers hold a page reference while the node is referenced.
Nothing special.

> And then you don't really have clear ownership rules. Does ublk
> releases the block request and "returns ownership" over pages to
> its user while io_uring is still dying and potenially have some
> IO inflight against it?
> 
> That's why I liked more the option to allow removing buffers from
> the table as per usual io_uring api / rules instead of a separate
> unregister ublk cmd. 

ublk is the only entity that knows about the struct request that
provides the bvec we want to use for zero-copy, so it has to be ublk
that handles the registration. Moving the unregister outside of that
breaks the symmetry and requires an indirect call.

> And inside, when all node refs are dropped,
> it'd call back to ublk. This way you have a single mechanism of
> how buffers are dropped from io_uring perspective. Thoughts?
>
> > +			err = -EBUSY;
> > +			break;
> > +		}
> > +
> >   		uvec = u64_to_user_ptr(user_data);
> >   		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
> >   		if (IS_ERR(iov)) {
> > @@ -258,6 +268,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
> >   			err = PTR_ERR(node);
> >   			break;
> >   		}
> ...
> > +int io_buffer_register_bvec(struct io_ring_ctx *ctx, const struct request *rq,
> > +			    unsigned int index)
> > +{
> > +	struct io_rsrc_data *data = &ctx->buf_table;
> > +	u16 nr_bvecs = blk_rq_nr_phys_segments(rq);
> > +	struct req_iterator rq_iter;
> > +	struct io_rsrc_node *node;
> > +	struct bio_vec bv;
> > +	int i = 0;
> > +
> > +	lockdep_assert_held(&ctx->uring_lock);
> > +
> > +	if (WARN_ON_ONCE(!data->nr))
> > +		return -EINVAL;
> 
> IIUC you can trigger all these from the user space, so they
> can't be warnings. Likely same goes for unregister*()

It helped with debugging, but sure, the warns don't need to be there.

> > +	if (WARN_ON_ONCE(index >= data->nr))
> > +		return -EINVAL;
> > +
> > +	node = data->nodes[index];
> > +	if (WARN_ON_ONCE(node))
> > +		return -EBUSY;
> > +
> > +	node = io_buffer_alloc_node(ctx, nr_bvecs, blk_rq_bytes(rq));
> > +	if (!node)
> > +		return -ENOMEM;
> > +
> > +	rq_for_each_bvec(bv, rq, rq_iter) {
> > +		get_page(bv.bv_page);
> > +		node->buf->bvec[i].bv_page = bv.bv_page;
> > +		node->buf->bvec[i].bv_len = bv.bv_len;
> > +		node->buf->bvec[i].bv_offset = bv.bv_offset;
> 
> bvec_set_page() should be more convenient

Indeed.

> > +		i++;
> > +	}
> > +	data->nodes[index] = node;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> > +
> 
> ...
> >   			unsigned long seg_skip;
> > diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> > index abd0d5d42c3e1..d1d90d9cd2b43 100644
> > --- a/io_uring/rsrc.h
> > +++ b/io_uring/rsrc.h
> > @@ -13,6 +13,7 @@
> >   enum {
> >   	IORING_RSRC_FILE		= 0,
> >   	IORING_RSRC_BUFFER		= 1,
> > +	IORING_RSRC_KBUF		= 2,
> 
> The name "kbuf" is already used, to avoid confusion let's rename it.
> Ming called it leased buffers before, I think it's a good name.

These are just fixed buffers, just like user space onces. The only
difference is where the buffer comes from: kernel or userspace? I don't
see what the term "lease" has to do with this.

