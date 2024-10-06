Return-Path: <io-uring+bounces-3433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A614F991D27
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 10:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E155F281953
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 08:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3102206E;
	Sun,  6 Oct 2024 08:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDBjH+De"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACA4155C97
	for <io-uring@vger.kernel.org>; Sun,  6 Oct 2024 08:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728202861; cv=none; b=W9Vi0PNrPYzyWDRjnNL9bIZrtf9rGbnLu4J34KwZL7/mpZ87KZ9naNL4tDqG5/BUyr5sq0UKqQvqqk0KdhZ9kKSYn1RHabciC1wQcmlzmEW+F1gkLSEhaNfY4JpIVWuvH5bxGrhz72GQeda6qwfaU7oxSNjLIWcmbaFvAuG88Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728202861; c=relaxed/simple;
	bh=4tweaVp3qvHc+44Q6lA/3rDHNQk7ijhQCTtjAEl2T+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ll/f2e6AN7x3/LMrdXr9zjdykJJruQQYRse4s35z54Eq3LSPdARjpGjuDwDN4VD2RBDMgYs1JTfcvGG/ENHdZVFlyXorIysS/K8D3VF0g4y99fm7tRgWwElYIVZjjfCJDvKrGRmelQeg/HadM6ghf+WloH4oJWmcXqPVUoi68Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FDBjH+De; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728202857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7avyxxLkxXXXzHO3kb4xso01qGFdLPLuNRVpRzG371s=;
	b=FDBjH+DeYxP8dp8JcBqWgfGSlBnwlGM6r6YxXZ/xRFAWboW43A4O61P6RoiRC8WFG1xoKG
	8FplhKwhH+C8tVsmCkX2uqr+w+cvXRMXDBuw3uOD7hj44K23XT+XxbFXrZbcqp+4HNWOlR
	Gv/hb+VKJr1ETTAhNSDVSn4AFcIhZH0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-408-NmEFzaZAPYGWvuse76rK9Q-1; Sun,
 06 Oct 2024 04:20:54 -0400
X-MC-Unique: NmEFzaZAPYGWvuse76rK9Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D09119540EF;
	Sun,  6 Oct 2024 08:20:53 +0000 (UTC)
Received: from fedora (unknown [10.72.116.29])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C55ED19560A2;
	Sun,  6 Oct 2024 08:20:48 +0000 (UTC)
Date: Sun, 6 Oct 2024 16:20:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
Message-ID: <ZwJIWqPT_Ae9K2bp@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
> On 9/12/24 11:49, Ming Lei wrote:
> ...
> > It can help to implement generic zero copy between device and related
> > operations, such as ublk, fuse, vdpa,
> > even network receive or whatever.
> 
> That's exactly the thing it can't sanely work with because
> of this design.

The provide buffer design is absolutely generic, and basically

- group leader provides buffer for member OPs, and member OPs can borrow
the buffer if leader allows by calling io_provide_group_kbuf()

- after member OPs consumes the buffer, the buffer is returned back by
the callback implemented in group leader subsystem, so group leader can
release related sources;

- and it is guaranteed that the buffer can be released always

The ublk implementation is pretty simple, it can be reused in device driver
to share buffer with other kernel subsystems.

I don't see anything insane with the design.

> 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/linux/io_uring_types.h | 33 +++++++++++++++++++
> >   io_uring/io_uring.c            | 10 +++++-
> >   io_uring/io_uring.h            | 10 ++++++
> >   io_uring/kbuf.c                | 60 ++++++++++++++++++++++++++++++++++
> >   io_uring/kbuf.h                | 13 ++++++++
> >   io_uring/net.c                 | 23 ++++++++++++-
> >   io_uring/opdef.c               |  4 +++
> >   io_uring/opdef.h               |  2 ++
> >   io_uring/rw.c                  | 20 +++++++++++-
> >   9 files changed, 172 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > index 793d5a26d9b8..445e5507565a 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -6,6 +6,7 @@
> >   #include <linux/task_work.h>
> >   #include <linux/bitmap.h>
> >   #include <linux/llist.h>
> > +#include <linux/bvec.h>
> >   #include <uapi/linux/io_uring.h>
> >   enum {
> > @@ -39,6 +40,26 @@ enum io_uring_cmd_flags {
> >   	IO_URING_F_COMPAT		= (1 << 12),
> >   };
> > +struct io_uring_kernel_buf;
> > +typedef void (io_uring_buf_giveback_t) (const struct io_uring_kernel_buf *);
> > +
> > +/* buffer provided from kernel */
> > +struct io_uring_kernel_buf {
> > +	unsigned long		len;
> > +	unsigned short		nr_bvecs;
> > +	unsigned char		dir;	/* ITER_SOURCE or ITER_DEST */
> > +
> > +	/* offset in the 1st bvec */
> > +	unsigned int		offset;
> > +	const struct bio_vec	*bvec;
> > +
> > +	/* called when we are done with this buffer */
> > +	io_uring_buf_giveback_t	*grp_kbuf_ack;
> > +
> > +	/* private field, user don't touch it */
> > +	struct bio_vec		__bvec[];
> > +};
> > +
> >   struct io_wq_work_node {
> >   	struct io_wq_work_node *next;
> >   };
> > @@ -473,6 +494,7 @@ enum {
> >   	REQ_F_BUFFERS_COMMIT_BIT,
> >   	REQ_F_SQE_GROUP_LEADER_BIT,
> >   	REQ_F_SQE_GROUP_DEP_BIT,
> > +	REQ_F_GROUP_KBUF_BIT,
> >   	/* not a real bit, just to check we're not overflowing the space */
> >   	__REQ_F_LAST_BIT,
> > @@ -557,6 +579,8 @@ enum {
> >   	REQ_F_SQE_GROUP_LEADER	= IO_REQ_FLAG(REQ_F_SQE_GROUP_LEADER_BIT),
> >   	/* sqe group with members depending on leader */
> >   	REQ_F_SQE_GROUP_DEP	= IO_REQ_FLAG(REQ_F_SQE_GROUP_DEP_BIT),
> > +	/* group lead provides kbuf for members, set for both lead and member */
> > +	REQ_F_GROUP_KBUF	= IO_REQ_FLAG(REQ_F_GROUP_KBUF_BIT),
> 
> We have a huge flag problem here. It's a 4th group flag, that gives
> me an idea that it's overabused. We're adding state machines based on
> them "set group, clear group, but if last set it again.

I have explained it is just for reusing SQE_GROUP flag to mark the last
member.

And now REQ_F_SQE_GROUP_DEP_BIT can be killed.

> And clear
> group lead if refs are of particular value".

It is actually one dead code for supporting concurrent leader & members,
so it will be removed too.

> And it's not really
> clear what these two flags are here for or what they do.
> 
> From what I see you need here just one flag to mark requests
> that provide a buffer, ala REQ_F_PROVIDING_KBUF. On the import
> side:
> 
> if ((req->flags & GROUP) && (req->lead->flags & REQ_F_PROVIDING_KBUF))
> 	...
> 
> And when you kill the request:
> 
> if (req->flags & REQ_F_PROVIDING_KBUF)
> 	io_group_kbuf_drop();

Yeah, this way works, here using REQ_F_GROUP_KBUF can remove the extra
indirect ->lead->flags check. I am fine to switch to this way by adding
one helper of io_use_group_provided_buf() to cover the check.

> 
> And I don't think you need opdef::accept_group_kbuf since the
> request handler should already know that and, importantly, you don't
> imbue any semantics based on it.

Yeah, and it just follows logic of buffer_select. I guess def->buffer_select
may be removed too?

> 
> FWIW, would be nice if during init figure we can verify that the leader
> provides a buffer IFF there is someone consuming it, but I don't think

It isn't doable, same reason with IORING_OP_PROVIDE_BUFFERS, since buffer can
only be provided in ->issue().

> the semantics is flexible enough to do it sanely. i.e. there are many
> members in a group, some might want to use the buffer and some might not.
> 
> 
> >   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
> > @@ -640,6 +664,15 @@ struct io_kiocb {
> >   		 * REQ_F_BUFFER_RING is set.
> >   		 */
> >   		struct io_buffer_list	*buf_list;
> > +
> > +		/*
> > +		 * store kernel buffer provided by sqe group lead, valid
> > +		 * IFF REQ_F_GROUP_KBUF
> > +		 *
> > +		 * The buffer meta is immutable since it is shared by
> > +		 * all member requests
> > +		 */
> > +		const struct io_uring_kernel_buf *grp_kbuf;
> >   	};
> >   	union {
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 99b44b6babd6..80c4d9192657 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -116,7 +116,7 @@
> >   #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
> >   				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
> > -				REQ_F_ASYNC_DATA)
> > +				REQ_F_ASYNC_DATA | REQ_F_GROUP_KBUF)
> >   #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
> >   				 REQ_F_SQE_GROUP | REQ_F_SQE_GROUP_LEADER | \
> > @@ -387,6 +387,11 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
> >   static void io_clean_op(struct io_kiocb *req)
> >   {
> > +	/* GROUP_KBUF is only available for REQ_F_SQE_GROUP_DEP */
> > +	if ((req->flags & (REQ_F_GROUP_KBUF | REQ_F_SQE_GROUP_DEP)) ==
> > +			(REQ_F_GROUP_KBUF | REQ_F_SQE_GROUP_DEP))
> > +		io_group_kbuf_drop(req);
> > +
> >   	if (req->flags & REQ_F_BUFFER_SELECTED) {
> >   		spin_lock(&req->ctx->completion_lock);
> >   		io_kbuf_drop(req);
> > @@ -914,9 +919,12 @@ static void io_queue_group_members(struct io_kiocb *req)
> >   	req->grp_link = NULL;
> >   	while (member) {
> > +		const struct io_issue_def *def = &io_issue_defs[member->opcode];
> >   		struct io_kiocb *next = member->grp_link;
> >   		member->grp_leader = req;
> > +		if ((req->flags & REQ_F_GROUP_KBUF) && def->accept_group_kbuf)
> > +			member->flags |= REQ_F_GROUP_KBUF;
> 
> As per above I suspect that is not needed.
> 
> >   		if (unlikely(member->flags & REQ_F_FAIL)) {
> >   			io_req_task_queue_fail(member, member->cqe.res);
> >   		} else if (unlikely(req->flags & REQ_F_FAIL)) {
> > diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> > index df2be7353414..8e111d24c02d 100644
> > --- a/io_uring/io_uring.h
> > +++ b/io_uring/io_uring.h
> > @@ -349,6 +349,16 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
> >   	return req->flags & REQ_F_SQE_GROUP_LEADER;
> >   }
> ...
> > +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
> > +		unsigned int len, int dir, struct iov_iter *iter)
> > +{
> > +	struct io_kiocb *lead = req->grp_link;
> > +	const struct io_uring_kernel_buf *kbuf;
> > +	unsigned long offset;
> > +
> > +	WARN_ON_ONCE(!(req->flags & REQ_F_GROUP_KBUF));
> > +
> > +	if (!req_is_group_member(req))
> > +		return -EINVAL;
> > +
> > +	if (!lead || !req_support_group_dep(lead) || !lead->grp_kbuf)
> > +		return -EINVAL;
> > +
> > +	/* req->fused_cmd_kbuf is immutable */
> > +	kbuf = lead->grp_kbuf;
> > +	offset = kbuf->offset;
> > +
> > +	if (!kbuf->bvec)
> > +		return -EINVAL;
> 
> How can this happen?

OK, we can run the check in uring_cmd API.

> 
> > +	if (dir != kbuf->dir)
> > +		return -EINVAL;
> > +
> > +	if (unlikely(buf_off > kbuf->len))
> > +		return -EFAULT;
> > +
> > +	if (unlikely(len > kbuf->len - buf_off))
> > +		return -EFAULT;
> 
> check_add_overflow() would be more readable

OK.

> 
> > +
> > +	/* don't use io_import_fixed which doesn't support multipage bvec */
> > +	offset += buf_off;
> > +	iov_iter_bvec(iter, dir, kbuf->bvec, kbuf->nr_bvecs, offset + len);
> > +
> > +	if (offset)
> > +		iov_iter_advance(iter, offset);
> > +
> > +	return 0;
> > +}
> > diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> > index 36aadfe5ac00..37d18324e840 100644
> > --- a/io_uring/kbuf.h
> > +++ b/io_uring/kbuf.h
> > @@ -89,6 +89,11 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
> >   				      unsigned long bgid);
> >   int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
> > +int io_provide_group_kbuf(struct io_kiocb *req,
> > +		const struct io_uring_kernel_buf *grp_kbuf);
> > +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
> > +		unsigned int len, int dir, struct iov_iter *iter);
> > +
> >   static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
> >   {
> >   	/*
> > @@ -220,4 +225,12 @@ static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
> >   {
> >   	return __io_put_kbufs(req, len, nbufs, issue_flags);
> >   }
> > +
> > +static inline void io_group_kbuf_drop(struct io_kiocb *req)
> > +{
> > +	const struct io_uring_kernel_buf *gbuf = req->grp_kbuf;
> > +
> > +	if (gbuf && gbuf->grp_kbuf_ack)
> 
> How can ->grp_kbuf_ack be missing?

OK, the check can be removed here.

> 
> > +		gbuf->grp_kbuf_ack(gbuf);
> > +}
> >   #endif
> > diff --git a/io_uring/net.c b/io_uring/net.c
> > index f10f5a22d66a..ad24dd5924d2 100644
> > --- a/io_uring/net.c
> > +++ b/io_uring/net.c
> > @@ -89,6 +89,13 @@ struct io_sr_msg {
> >    */
> >   #define MULTISHOT_MAX_RETRY	32
> > +#define user_ptr_to_u64(x) (		\
> > +{					\
> > +	typecheck(void __user *, (x));	\
> > +	(u64)(unsigned long)(x);	\
> > +}					\
> > +)
> > +
> >   int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >   {
> >   	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
> > @@ -375,7 +382,7 @@ static int io_send_setup(struct io_kiocb *req)
> >   		kmsg->msg.msg_name = &kmsg->addr;
> >   		kmsg->msg.msg_namelen = sr->addr_len;
> >   	}
> > -	if (!io_do_buffer_select(req)) {
> > +	if (!io_do_buffer_select(req) && !(req->flags & REQ_F_GROUP_KBUF)) {
> >   		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
> >   				  &kmsg->msg.msg_iter);
> >   		if (unlikely(ret < 0))
> > @@ -593,6 +600,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
> >   	if (issue_flags & IO_URING_F_NONBLOCK)
> >   		flags |= MSG_DONTWAIT;
> > +	if (req->flags & REQ_F_GROUP_KBUF) {
> 
> Does anything prevent the request to be marked by both
> GROUP_KBUF and BUFFER_SELECT? In which case we'd set up
> a group kbuf and then go to the io_do_buffer_select()
> overriding all of that

It could be used in this way, and we can fail the member in
io_queue_group_members().

> 
> > +		ret = io_import_group_kbuf(req,
> > +					user_ptr_to_u64(sr->buf),
> > +					sr->len, ITER_SOURCE,
> > +					&kmsg->msg.msg_iter);
> > +		if (unlikely(ret))
> > +			return ret;
> > +	}
> > +
> >   retry_bundle:
> >   	if (io_do_buffer_select(req)) {
> >   		struct buf_sel_arg arg = {
> > @@ -1154,6 +1170,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
> >   			goto out_free;
> >   		}
> >   		sr->buf = NULL;
> > +	} else if (req->flags & REQ_F_GROUP_KBUF) {
> 
> What happens if we get a short read/recv?

For short read/recv, any progress is stored in iterator, nothing to do
with the provide buffer, which is immutable.

One problem for read is reissue, but it can be handled by saving iter
state after the group buffer is imported, I will fix it in next version.
For net recv, offset/len of buffer is updated in case of short recv, so
it works as expected.

Or any other issue with short read/recv? Can you explain in detail?

Thanks,
Ming


