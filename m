Return-Path: <io-uring+bounces-3544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95839997AF4
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 05:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 043BFB2449F
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 03:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BE3189902;
	Thu, 10 Oct 2024 03:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2c4mZLl"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D05187560
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 03:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728529251; cv=none; b=beT7Ap0jtEki1a2FZGVO0/KlJCMIBSm4N+yAhhddNo+dKM/KN9A6LmLc95yj3Tra6EiPD/CYU/crl66oxQJIJ9spGp/sLkICSLQHjnDGaslkpAyXWXT1MXZ3TD8VS+Wl3U2ZGzTW2uluYa9dwER1jvIU3Iu/rsSSalJ+4jFUwO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728529251; c=relaxed/simple;
	bh=SEs38TBpDbrpen/OlhU4LHjI11AsoR9Af6/zl1f+9lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSryfsflh7cwBZdfAioPxoQDzz/Nn3Lm7vqtuszvv/LQlCGKdeC6+tOnLAKDJaVxNfgh7+RgxoNf67I7isA9qNfTk/TpJLbou7IOmZprK0aUh4SVRo7k5JJeJHhMZa3hGrY39yg1bdkuXY3dkyohcIbJWkxYCreAhV2+UjIBCto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z2c4mZLl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728529247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kS7RJWn3RvRzonK3SC/P4ZSwiYaZ7PdMcq6mq+T8FeE=;
	b=Z2c4mZLlKmwqjXtw2KuStqWiyR4StE0j4IiFgb2lJ/QhywyZ+KcSGQPUH8mL/5hNW0N9+U
	OteZj7Ehu+tPKDAMC8tRPX+KKLCI8rifi2AkzRlFVRNAuJ6gIfin3/htOKtiA1H6MI3BuC
	BFpfWM4AeV6UPdmvHhuD+egnd53FXB0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-irtjcrsKOh2Q8WpjFGZepg-1; Wed,
 09 Oct 2024 23:00:45 -0400
X-MC-Unique: irtjcrsKOh2Q8WpjFGZepg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68CAA195608B;
	Thu, 10 Oct 2024 03:00:44 +0000 (UTC)
Received: from fedora (unknown [10.72.116.47])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 724671956086;
	Thu, 10 Oct 2024 03:00:40 +0000 (UTC)
Date: Thu, 10 Oct 2024 11:00:35 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
Message-ID: <ZwdDU1-lfywyb4jO@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
 <ZwJIWqPT_Ae9K2bp@fedora>
 <8d93e1ba-0fdf-44d4-9189-199df57d0676@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d93e1ba-0fdf-44d4-9189-199df57d0676@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Oct 09, 2024 at 03:25:25PM +0100, Pavel Begunkov wrote:
> On 10/6/24 09:20, Ming Lei wrote:
> > On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
> > > On 9/12/24 11:49, Ming Lei wrote:
> > > ...
> > > > It can help to implement generic zero copy between device and related
> > > > operations, such as ublk, fuse, vdpa,
> > > > even network receive or whatever.
> > > 
> > > That's exactly the thing it can't sanely work with because
> > > of this design.
> > 
> > The provide buffer design is absolutely generic, and basically
> > 
> > - group leader provides buffer for member OPs, and member OPs can borrow
> > the buffer if leader allows by calling io_provide_group_kbuf()
> > 
> > - after member OPs consumes the buffer, the buffer is returned back by
> > the callback implemented in group leader subsystem, so group leader can
> > release related sources;
> > 
> > - and it is guaranteed that the buffer can be released always
> > 
> > The ublk implementation is pretty simple, it can be reused in device driver
> > to share buffer with other kernel subsystems.
> > 
> > I don't see anything insane with the design.
> 
> There is nothing insane with the design, but the problem is cross
> request error handling, same thing that makes links a pain to use.

Wrt. link, the whole group is linked in the chain, and it respects
all existed link rule, care to share the trouble in link use case?

The only thing I thought of is that group internal link isn't supported
yet, but it may be added in future if use case is coming.

> It's good that with storage reads are reasonably idempotent and you
> can be retried if needed. With sockets and streams, however, you
> can't sanely borrow a buffer without consuming it, so if a member
> request processing the buffer fails for any reason, the user data
> will be dropped on the floor. I mentioned quite a while before,
> if for example you stash the buffer somewhere you can access
> across syscalls like the io_uring's registered buffer table, the
> user at least would be able to find an error and then memcpy the
> unprocessed data as a fallback.

I guess it is net rx case, which requires buffer to cross syscalls,
then the buffer has to be owned by userspace, otherwise the buffer
can be leaked easily.

That may not match with sqe group which is supposed to borrow kernel
buffer consumed by users.

> 
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >    include/linux/io_uring_types.h | 33 +++++++++++++++++++
> > > >    io_uring/io_uring.c            | 10 +++++-
> > > >    io_uring/io_uring.h            | 10 ++++++
> > > >    io_uring/kbuf.c                | 60 ++++++++++++++++++++++++++++++++++
> > > >    io_uring/kbuf.h                | 13 ++++++++
> > > >    io_uring/net.c                 | 23 ++++++++++++-
> > > >    io_uring/opdef.c               |  4 +++
> > > >    io_uring/opdef.h               |  2 ++
> > > >    io_uring/rw.c                  | 20 +++++++++++-
> > > >    9 files changed, 172 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > > > index 793d5a26d9b8..445e5507565a 100644
> > > > --- a/include/linux/io_uring_types.h
> > > > +++ b/include/linux/io_uring_types.h
> ...
> > > 
> > > And I don't think you need opdef::accept_group_kbuf since the
> > > request handler should already know that and, importantly, you don't
> > > imbue any semantics based on it.
> > 
> > Yeah, and it just follows logic of buffer_select. I guess def->buffer_select
> > may be removed too?
> 
> ->buffer_select helps to fail IOSQE_BUFFER_SELECT for requests
> that don't support it, so we don't need to add the check every
> time we add a new request opcode.
> 
> In your case requests just ignore ->accept_group_kbuf /
> REQ_F_GROUP_KBUF if they don't expect to use the buffer, so
> it's different in several aspects.
> 
> fwiw, I don't mind ->accept_group_kbuf, I just don't see
> what purpose it serves. Would be nice to have a sturdier uAPI,
> where the user sets a flag to each member that want to use
> these provided buffers and then the kernel checks leader vs
> that flag and fails misconfigurations, but likely we don't
> have flags / sqe space for it.

As I replied in previous email, members have three flags available,
we can map one of them to REQ_F_GROUP_KBUF.

> 
> 
> > > FWIW, would be nice if during init figure we can verify that the leader
> > > provides a buffer IFF there is someone consuming it, but I don't think
> > 
> > It isn't doable, same reason with IORING_OP_PROVIDE_BUFFERS, since buffer can
> > only be provided in ->issue().
> 
> In theory we could, in practise it'd be too much of a pain, I agree.
> 
> IORING_OP_PROVIDE_BUFFERS is different as you just stash the buffer
> in the io_uring instance, and it's used at an unspecified time later
> by some request. In this sense the API is explicit, requests that don't
> support it but marked with IOSQE_BUFFER_SELECT will be failed by the
> kernel.

That is also one reason why I add ->accept_group_kbuf.

> 
> > > the semantics is flexible enough to do it sanely. i.e. there are many
> > > members in a group, some might want to use the buffer and some might not.
> > > 
> ...
> > > > diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> > > > index df2be7353414..8e111d24c02d 100644
> > > > --- a/io_uring/io_uring.h
> > > > +++ b/io_uring/io_uring.h
> > > > @@ -349,6 +349,16 @@ static inline bool req_is_group_leader(struct io_kiocb *req)
> > > >    	return req->flags & REQ_F_SQE_GROUP_LEADER;
> > > >    }
> > > ...
> > > > +int io_import_group_kbuf(struct io_kiocb *req, unsigned long buf_off,
> > > > +		unsigned int len, int dir, struct iov_iter *iter)
> > > > +{
> > > > +	struct io_kiocb *lead = req->grp_link;
> > > > +	const struct io_uring_kernel_buf *kbuf;
> > > > +	unsigned long offset;
> > > > +
> > > > +	WARN_ON_ONCE(!(req->flags & REQ_F_GROUP_KBUF));
> > > > +
> > > > +	if (!req_is_group_member(req))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (!lead || !req_support_group_dep(lead) || !lead->grp_kbuf)
> > > > +		return -EINVAL;
> > > > +
> > > > +	/* req->fused_cmd_kbuf is immutable */
> > > > +	kbuf = lead->grp_kbuf;
> > > > +	offset = kbuf->offset;
> > > > +
> > > > +	if (!kbuf->bvec)
> > > > +		return -EINVAL;
> > > 
> > > How can this happen?
> > 
> > OK, we can run the check in uring_cmd API.
> 
> Not sure I follow, if a request providing a buffer can't set
> a bvec it should just fail, without exposing half made
> io_uring_kernel_buf to other requests.
> 
> Is it rather a WARN_ON_ONCE check?

I meant we can check it in API of io_provide_group_kbuf() since the group
buffer is filled by driver, since then the buffer is immutable, and we
needn't any other check.

> 
> 
> > > > diff --git a/io_uring/net.c b/io_uring/net.c
> > > > index f10f5a22d66a..ad24dd5924d2 100644
> > > > --- a/io_uring/net.c
> > > > +++ b/io_uring/net.c
> > > > @@ -89,6 +89,13 @@ struct io_sr_msg {
> > > >     */
> > > >    #define MULTISHOT_MAX_RETRY	32
> > > > +#define user_ptr_to_u64(x) (		\
> > > > +{					\
> > > > +	typecheck(void __user *, (x));	\
> > > > +	(u64)(unsigned long)(x);	\
> > > > +}					\
> > > > +)
> > > > +
> > > >    int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > > >    {
> > > >    	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
> > > > @@ -375,7 +382,7 @@ static int io_send_setup(struct io_kiocb *req)
> > > >    		kmsg->msg.msg_name = &kmsg->addr;
> > > >    		kmsg->msg.msg_namelen = sr->addr_len;
> > > >    	}
> > > > -	if (!io_do_buffer_select(req)) {
> > > > +	if (!io_do_buffer_select(req) && !(req->flags & REQ_F_GROUP_KBUF)) {
> > > >    		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
> > > >    				  &kmsg->msg.msg_iter);
> > > >    		if (unlikely(ret < 0))
> > > > @@ -593,6 +600,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
> > > >    	if (issue_flags & IO_URING_F_NONBLOCK)
> > > >    		flags |= MSG_DONTWAIT;
> > > > +	if (req->flags & REQ_F_GROUP_KBUF) {
> > > 
> > > Does anything prevent the request to be marked by both
> > > GROUP_KBUF and BUFFER_SELECT? In which case we'd set up
> > > a group kbuf and then go to the io_do_buffer_select()
> > > overriding all of that
> > 
> > It could be used in this way, and we can fail the member in
> > io_queue_group_members().
> 
> That's where the opdef flag could actually be useful,
> 
> if (opdef[member]->accept_group_kbuf &&
>     member->flags & SELECT_BUF)
> 	fail;
> 
> 
> > > > +		ret = io_import_group_kbuf(req,
> > > > +					user_ptr_to_u64(sr->buf),
> > > > +					sr->len, ITER_SOURCE,
> > > > +					&kmsg->msg.msg_iter);
> > > > +		if (unlikely(ret))
> > > > +			return ret;
> > > > +	}
> > > > +
> > > >    retry_bundle:
> > > >    	if (io_do_buffer_select(req)) {
> > > >    		struct buf_sel_arg arg = {
> > > > @@ -1154,6 +1170,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
> > > >    			goto out_free;
> > > >    		}
> > > >    		sr->buf = NULL;
> > > > +	} else if (req->flags & REQ_F_GROUP_KBUF) {
> > > 
> > > What happens if we get a short read/recv?
> > 
> > For short read/recv, any progress is stored in iterator, nothing to do
> > with the provide buffer, which is immutable.
> > 
> > One problem for read is reissue, but it can be handled by saving iter
> > state after the group buffer is imported, I will fix it in next version.
> > For net recv, offset/len of buffer is updated in case of short recv, so
> > it works as expected.
> 
> That was one of my worries.
> 
> > Or any other issue with short read/recv? Can you explain in detail?
> 
> To sum up design wise, when members that are using the buffer as a
> source, e.g. write/send, fail, the user is expected to usually reissue
> both the write and the ublk cmd.
> 
> Let's say you have a ublk leader command providing a 4K buffer, and
> you group it with a 4K send using the buffer. Let's assume the send
> is short and does't only 2K of data. Then the user would normally
> reissue:
> 
> ublk(4K, GROUP), send(off=2K)
> 
> That's fine assuming short IO is rare.
> 
> I worry more about the backward flow, ublk provides an "empty" buffer
> to receive/read into. ublk wants to do something with the buffer in
> the callback. What happens when read/recv is short (and cannot be
> retried by io_uring)?
> 
> 1. ublk(provide empty 4K buffer)
> 2. recv, ret=2K
> 3. ->grp_kbuf_ack: ublk should commit back only 2K
>    of data and not assume it's 4K

->grp_kbuf_ack is supposed to only return back the buffer to the
owner, and it doesn't care result of buffer consumption.

When ->grp_kbuf_ack() is done, it means this time buffer borrow is
over.

When userspace figures out it is one short read, it will send one
ublk uring_cmd to notify that this io command is completed with
result(2k). ublk driver may decide to requeue this io command for
retrying the remained bytes, when only remained part of the buffer
is allowed to borrow in following provide uring command originated
from userspace.

For ublk use case, so far so good.

> 
> Another option is to fail ->grp_kbuf_ack if any member fails, but
> the API might be a bit too awkward and inconvenient .

We needn't ->grp_kbuf_ack() to cover buffer consumption.


Thanks,
Ming


