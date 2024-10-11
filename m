Return-Path: <io-uring+bounces-3581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56BCD9999E4
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 04:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6AA1282F7F
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 02:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36F9C2C6;
	Fri, 11 Oct 2024 02:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGCaA5hF"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9A34A06
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612024; cv=none; b=diWP/eIkDsj1eoYYb+e9bteQbbCz9bzdMNKl5r0L6qt6RpoyYAVxXplXT5vMaohbhecc3lKsFDS0xwWW7MCGXanKXSVyw3khsUrVnZToAACMo/E/TOYgGq5EK5+pX2XgRLAOLg7INi88GH+H5mnvbHd15G9kFRZaTqKF1+1n1CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612024; c=relaxed/simple;
	bh=9ZG6ZBEdFpc+64zfLWo//OKbo/+ZMIu4yPLcQkOsYlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ChKukad4gAnBi53Saoik881qpDboQ0dYiMyZ0IsbWCrby2cwBEsADDkdVZhmQF3DkUOEfM3Ibri6dzDIMyjdNVKxLYUnZDBXN+iN3XKwkYlGpuvov1coZSFKS81Clh7QBqSSHKZyUI9qV9AqJCB6hOc/KEAT9VzXtWsTg79Aoig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGCaA5hF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728612021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YeJjJJxkEPJeBG9Cz35USyyqVSTkO+JU0xphZusAySc=;
	b=OGCaA5hFuSdw0ohVrHKAVKqmJ5C5z/N2QlHVIj/B7WKMx0JCS6v3CiDynwG+Y2mv8xrR8d
	ZMMsmd2JDygPJBiwpoYYv6w7dTuGRluPT5ux+L5vgH1lnkDNIVEbJl07zm9xBibI9GXGo8
	aMVU63wo0Ms0+APtFOzVqhQcp1H3igY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-zzPhBMZqNpO9_VBVjDPQ6A-1; Thu,
 10 Oct 2024 22:00:18 -0400
X-MC-Unique: zzPhBMZqNpO9_VBVjDPQ6A-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 342121955F43;
	Fri, 11 Oct 2024 02:00:17 +0000 (UTC)
Received: from fedora (unknown [10.72.116.103])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C28E919560AA;
	Fri, 11 Oct 2024 02:00:12 +0000 (UTC)
Date: Fri, 11 Oct 2024 10:00:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
Message-ID: <ZwiGpp4ePoCihohg@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com>
 <ZwJIWqPT_Ae9K2bp@fedora>
 <8d93e1ba-0fdf-44d4-9189-199df57d0676@gmail.com>
 <ZwdDU1-lfywyb4jO@fedora>
 <b41dfbe1-2dee-47fc-a2f4-38bef49f60ab@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b41dfbe1-2dee-47fc-a2f4-38bef49f60ab@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Oct 10, 2024 at 07:51:19PM +0100, Pavel Begunkov wrote:
> On 10/10/24 04:00, Ming Lei wrote:
> > On Wed, Oct 09, 2024 at 03:25:25PM +0100, Pavel Begunkov wrote:
> > > On 10/6/24 09:20, Ming Lei wrote:
> > > > On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
> > > > > On 9/12/24 11:49, Ming Lei wrote:
> > > > > ...
> > > > > > It can help to implement generic zero copy between device and related
> > > > > > operations, such as ublk, fuse, vdpa,
> > > > > > even network receive or whatever.
> > > > > 
> > > > > That's exactly the thing it can't sanely work with because
> > > > > of this design.
> > > > 
> > > > The provide buffer design is absolutely generic, and basically
> > > > 
> > > > - group leader provides buffer for member OPs, and member OPs can borrow
> > > > the buffer if leader allows by calling io_provide_group_kbuf()
> > > > 
> > > > - after member OPs consumes the buffer, the buffer is returned back by
> > > > the callback implemented in group leader subsystem, so group leader can
> > > > release related sources;
> > > > 
> > > > - and it is guaranteed that the buffer can be released always
> > > > 
> > > > The ublk implementation is pretty simple, it can be reused in device driver
> > > > to share buffer with other kernel subsystems.
> > > > 
> > > > I don't see anything insane with the design.
> > > 
> > > There is nothing insane with the design, but the problem is cross
> > > request error handling, same thing that makes links a pain to use.
> > 
> > Wrt. link, the whole group is linked in the chain, and it respects
> > all existed link rule, care to share the trouble in link use case?
> 
> Error handling is a pain, it has been, even for pure link without
> any groups. Even with a simple req1 -> req2, you need to track if
> the first request fails you need to expect another failed CQE for
> the second request, probably refcount (let's say non-atomically)
> some structure and clean it up when you get both CQEs. It's not
> prettier when the 2nd fails, especially if you consider short IO
> and that you can't fully retry that partial IO, e.g. you consumed
> data from the socket. And so on.
> 
> > The only thing I thought of is that group internal link isn't supported
> > yet, but it may be added in future if use case is coming.
> > 
> > > It's good that with storage reads are reasonably idempotent and you
> > > can be retried if needed. With sockets and streams, however, you
> > > can't sanely borrow a buffer without consuming it, so if a member
> > > request processing the buffer fails for any reason, the user data
> > > will be dropped on the floor. I mentioned quite a while before,
> > > if for example you stash the buffer somewhere you can access
> > > across syscalls like the io_uring's registered buffer table, the
> > > user at least would be able to find an error and then memcpy the
> > > unprocessed data as a fallback.
> > 
> > I guess it is net rx case, which requires buffer to cross syscalls,
> > then the buffer has to be owned by userspace, otherwise the buffer
> > can be leaked easily.
> > 
> > That may not match with sqe group which is supposed to borrow kernel
> > buffer consumed by users.
> 
> It doesn't necessarily require to keep buffers across syscalls
> per se, it just can't drop the data it got on the floor. It's
> just storage can read data again.

In case of short read, data is really stored(not dropped) in the provided
buffer, and you can consume the short read data, or continue to read more to
the same buffer.

What is the your real issue here?

> 
> ...
> > > > > > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> > > > > > index 793d5a26d9b8..445e5507565a 100644
> > > > > > --- a/include/linux/io_uring_types.h
> > > > > > +++ b/include/linux/io_uring_types.h
> ...
> > > > > FWIW, would be nice if during init figure we can verify that the leader
> > > > > provides a buffer IFF there is someone consuming it, but I don't think
> > > > 
> > > > It isn't doable, same reason with IORING_OP_PROVIDE_BUFFERS, since buffer can
> > > > only be provided in ->issue().
> > > 
> > > In theory we could, in practise it'd be too much of a pain, I agree.
> > > 
> > > IORING_OP_PROVIDE_BUFFERS is different as you just stash the buffer
> > > in the io_uring instance, and it's used at an unspecified time later
> > > by some request. In this sense the API is explicit, requests that don't
> > > support it but marked with IOSQE_BUFFER_SELECT will be failed by the
> > > kernel.
> > 
> > That is also one reason why I add ->accept_group_kbuf.
> 
> I probably missed that, but I haven't seen that

Such as, any OPs with fixed buffer can't set ->accept_group_kbuf.

> 
> > > > > the semantics is flexible enough to do it sanely. i.e. there are many
> > > > > members in a group, some might want to use the buffer and some might not.
> > > > > 
> ...
> > > > > > +	if (!kbuf->bvec)
> > > > > > +		return -EINVAL;
> > > > > 
> > > > > How can this happen?
> > > > 
> > > > OK, we can run the check in uring_cmd API.
> > > 
> > > Not sure I follow, if a request providing a buffer can't set
> > > a bvec it should just fail, without exposing half made
> > > io_uring_kernel_buf to other requests.
> > > 
> > > Is it rather a WARN_ON_ONCE check?
> > 
> > I meant we can check it in API of io_provide_group_kbuf() since the group
> > buffer is filled by driver, since then the buffer is immutable, and we
> > needn't any other check.
> 
> That's be a buggy provider, so sounds like WARN_ON_ONCE

Not at all.

If the driver provides bad buffer, all group leader and members OP will be
failed, and userspace can get notified.

> 
> ...
> > > > > >     		if (unlikely(ret < 0))
> > > > > > @@ -593,6 +600,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
> > > > > >     	if (issue_flags & IO_URING_F_NONBLOCK)
> > > > > >     		flags |= MSG_DONTWAIT;
> > > > > > +	if (req->flags & REQ_F_GROUP_KBUF) {
> > > > > 
> > > > > Does anything prevent the request to be marked by both
> > > > > GROUP_KBUF and BUFFER_SELECT? In which case we'd set up
> > > > > a group kbuf and then go to the io_do_buffer_select()
> > > > > overriding all of that
> > > > 
> > > > It could be used in this way, and we can fail the member in
> > > > io_queue_group_members().
> > > 
> > > That's where the opdef flag could actually be useful,
> > > 
> > > if (opdef[member]->accept_group_kbuf &&
> > >      member->flags & SELECT_BUF)
> > > 	fail;
> > > 
> > > 
> > > > > > +		ret = io_import_group_kbuf(req,
> > > > > > +					user_ptr_to_u64(sr->buf),
> > > > > > +					sr->len, ITER_SOURCE,
> > > > > > +					&kmsg->msg.msg_iter);
> > > > > > +		if (unlikely(ret))
> > > > > > +			return ret;
> > > > > > +	}
> > > > > > +
> > > > > >     retry_bundle:
> > > > > >     	if (io_do_buffer_select(req)) {
> > > > > >     		struct buf_sel_arg arg = {
> > > > > > @@ -1154,6 +1170,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
> > > > > >     			goto out_free;
> > > > > >     		}
> > > > > >     		sr->buf = NULL;
> > > > > > +	} else if (req->flags & REQ_F_GROUP_KBUF) {
> > > > > 
> > > > > What happens if we get a short read/recv?
> > > > 
> > > > For short read/recv, any progress is stored in iterator, nothing to do
> > > > with the provide buffer, which is immutable.
> > > > 
> > > > One problem for read is reissue, but it can be handled by saving iter
> > > > state after the group buffer is imported, I will fix it in next version.
> > > > For net recv, offset/len of buffer is updated in case of short recv, so
> > > > it works as expected.
> > > 
> > > That was one of my worries.
> > > 
> > > > Or any other issue with short read/recv? Can you explain in detail?
> > > 
> > > To sum up design wise, when members that are using the buffer as a
> > > source, e.g. write/send, fail, the user is expected to usually reissue
> > > both the write and the ublk cmd.
> > > 
> > > Let's say you have a ublk leader command providing a 4K buffer, and
> > > you group it with a 4K send using the buffer. Let's assume the send
> > > is short and does't only 2K of data. Then the user would normally
> > > reissue:
> > > 
> > > ublk(4K, GROUP), send(off=2K)
> > > 
> > > That's fine assuming short IO is rare.
> > > 
> > > I worry more about the backward flow, ublk provides an "empty" buffer
> > > to receive/read into. ublk wants to do something with the buffer in
> > > the callback. What happens when read/recv is short (and cannot be
> > > retried by io_uring)?
> > > 
> > > 1. ublk(provide empty 4K buffer)
> > > 2. recv, ret=2K
> > > 3. ->grp_kbuf_ack: ublk should commit back only 2K
> > >     of data and not assume it's 4K
> > 
> > ->grp_kbuf_ack is supposed to only return back the buffer to the
> > owner, and it doesn't care result of buffer consumption.
> > 
> > When ->grp_kbuf_ack() is done, it means this time buffer borrow is
> > over.
> > 
> > When userspace figures out it is one short read, it will send one
> > ublk uring_cmd to notify that this io command is completed with
> > result(2k). ublk driver may decide to requeue this io command for
> > retrying the remained bytes, when only remained part of the buffer
> > is allowed to borrow in following provide uring command originated
> > from userspace.
> 
> My apologies, I failed to notice that moment, even though should've
> given it some thinking at the very beginning. I think that part would
> be a terrible interface. Might be good enough for ublk, but we can't
> be creating a ublk specific features that change the entire io_uring.
> Without knowing how much data it actually got, in generic case you

You do know how much data actually got in the member OP, don't you?

> 1) need to require the buffer to be fully initialised / zeroed
> before handing it.

The buffer is really initialized before being provided via
io_provide_group_kbuf(). And it is one bvec buffer, anytime the part
is consumed, the iterator is advanced, so always initialized buffer
is provided to consumer OP.

> 2) Can't ever commit the data from the callback,

What do you mean `commit`?

The callback is documented clearly from beginning that it is for
returning back the buffer to the owner.

Only member OPs consume buffer, and group leader provides valid buffer
for member OP, and the buffer lifetime is aligned with group leader
request.

> but it would need to wait until the userspace reacts. Yes, it
> works in the specific context of ublk, but I don't think it works
> as a generic interface.

It is just how ublk uses group buffer, but not necessary to be exactly
this way.

Anytime the buffer is provided via io_provide_group_kbuf() successfully,
the member OPs can consume it safely, and finally the buffer is returned
back if all member OPs are completed. That is all.

Please explain why it isn't generic interface.


Thanks, 
Ming


