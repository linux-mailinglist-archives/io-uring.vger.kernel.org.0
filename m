Return-Path: <io-uring+bounces-3616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2539E99B079
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 05:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BBDE1F22EAF
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 03:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85EE83CA0;
	Sat, 12 Oct 2024 03:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sym95yiA"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222941C6E
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 03:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728704126; cv=none; b=jkEtoaoY0XkW0lf64C/gl2bGZma0j88OVVLuN140pAl+Y2+/Ymh3C822VPH66jqWnNgIMSy0nNfj21BcScKsDujxB0jv5/VCx4jhG+LrMPy5ZFNr+MArJ+vNkx+QoN6C7jUnrAZREfH86FMNw2gUU7+uPiukio7YGJpoShWXvqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728704126; c=relaxed/simple;
	bh=wU2B/RbQAGrxUMadqbL1Cs3cm4GBAcTsMCO/SLFzByw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJ3CVUiid9UQ6M+2I/X7cASnEtvFb77Ubkpxr7Fiw605E2hHcHQP8RU4EKMg6FMbcR847BOGBb+llNSrr/55M1icqMHOf2n9psYMCjsO5wCVpMnFXQ5DRRvsUl0sqQTuTagiOTRLUfqHGwtxRP1jKeVNUzFEYx2jtBIpyVjPvf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sym95yiA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728704123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xp2mu47bjoY1NfZM2AmKgNgRBcl7BFLCQHoYuZXdEvk=;
	b=Sym95yiA1wM2CpyJ5BzCRX0zs8yeCxFWHX3IcxpkFnS/3HYnUApT7K8Mc6cWCt5QAixX++
	MHzobcZ7BvPls/S/FUDa7XTukxQ0dojmWNTSOsjVMCabkslInab0CK+F7vKAY1pZ5M27l1
	r5Nca3zbPwIa1YG0CszzHP4zhmqxl5o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-cy9mjAiDPw-ZWmp3ROmruQ-1; Fri,
 11 Oct 2024 23:35:19 -0400
X-MC-Unique: cy9mjAiDPw-ZWmp3ROmruQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 788471956080;
	Sat, 12 Oct 2024 03:35:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.52])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9286D1955F43;
	Sat, 12 Oct 2024 03:35:13 +0000 (UTC)
Date: Sat, 12 Oct 2024 11:35:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
Message-ID: <ZwnubPOWFFQNGXM6@fedora>
References: <4b40eff1-a848-4742-9cb3-541bf8ed606e@gmail.com>
 <655b3348-27a1-4bc7-ade7-4d958a692d0b@kernel.dk>
 <ZwiN0Ioy2Y7cfnTI@fedora>
 <44028492-3681-4cd4-8ae2-ef7139ad50ad@kernel.dk>
 <ZwiWdO6SS_jlkYrM@fedora>
 <051e74c9-c5b4-40d7-9024-b4bd3f5d0a0f@kernel.dk>
 <Zwk0SQBiTUBLNvj0@fedora>
 <a7eefe36-55fd-48f7-b05b-afed16a32d0c@kernel.dk>
 <ZwlIEiWpTMMh-NTL@fedora>
 <2e541c8a-c88d-4765-bbb9-cd61f9c4757a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e541c8a-c88d-4765-bbb9-cd61f9c4757a@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Oct 11, 2024 at 10:49:10AM -0600, Jens Axboe wrote:
> On 10/11/24 9:45 AM, Ming Lei wrote:
> > On Fri, Oct 11, 2024 at 08:41:03AM -0600, Jens Axboe wrote:
> >> On 10/11/24 8:20 AM, Ming Lei wrote:
> >>> On Fri, Oct 11, 2024 at 07:24:27AM -0600, Jens Axboe wrote:
> >>>> On 10/10/24 9:07 PM, Ming Lei wrote:
> >>>>> On Thu, Oct 10, 2024 at 08:39:12PM -0600, Jens Axboe wrote:
> >>>>>> On 10/10/24 8:30 PM, Ming Lei wrote:
> >>>>>>> Hi Jens,
> >>>>>>>
> >>>>>>> On Thu, Oct 10, 2024 at 01:31:21PM -0600, Jens Axboe wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> Discussed this with Pavel, and on his suggestion, I tried prototyping a
> >>>>>>>> "buffer update" opcode. Basically it works like
> >>>>>>>> IORING_REGISTER_BUFFERS_UPDATE in that it can update an existing buffer
> >>>>>>>> registration. But it works as an sqe rather than being a sync opcode.
> >>>>>>>>
> >>>>>>>> The idea here is that you could do that upfront, or as part of a chain,
> >>>>>>>> and have it be generically available, just like any other buffer that
> >>>>>>>> was registered upfront. You do need an empty table registered first,
> >>>>>>>> which can just be sparse. And since you can pick the slot it goes into,
> >>>>>>>> you can rely on that slot afterwards (either as a link, or just the
> >>>>>>>> following sqe).
> >>>>>>>>
> >>>>>>>> Quick'n dirty obviously, but I did write a quick test case too to verify
> >>>>>>>> that:
> >>>>>>>>
> >>>>>>>> 1) It actually works (it seems to)
> >>>>>>>
> >>>>>>> It doesn't work for ublk zc since ublk needs to provide one kernel buffer
> >>>>>>> for fs rw & net send/recv to consume, and the kernel buffer is invisible
> >>>>>>> to userspace. But  __io_register_rsrc_update() only can register userspace
> >>>>>>> buffer.
> >>>>>>
> >>>>>> I'd be surprised if this simple one was enough! In terms of user vs
> >>>>>> kernel buffer, you could certainly use the same mechanism, and just
> >>>>>> ensure that buffers are tagged appropriately. I need to think about that
> >>>>>> a little bit.
> >>>>>
> >>>>> It is actually same with IORING_OP_PROVIDE_BUFFERS, so the following
> >>>>> consumer OPs have to wait until this OP_BUF_UPDATE is completed.
> >>>>
> >>>> See below for the registered vs provided buffer confusion that seems to
> >>>> be a confusion issue here.
> >>>>
> >>>>> Suppose we have N consumers OPs which depends on OP_BUF_UPDATE.
> >>>>>
> >>>>> 1) all N OPs are linked with OP_BUF_UPDATE
> >>>>>
> >>>>> Or
> >>>>>
> >>>>> 2) submit OP_BUF_UPDATE first, and wait its completion, then submit N
> >>>>> OPs concurrently.
> >>>>
> >>>> Correct
> >>>>
> >>>>> But 1) and 2) may slow the IO handing.  In 1) all N OPs are serialized,
> >>>>> and 1 extra syscall is introduced in 2).
> >>>>
> >>>> Yes you don't want do do #1. But the OP_BUF_UPDATE is cheap enough that
> >>>> you can just do it upfront. It's not ideal in terms of usage, and I get
> >>>> where the grouping comes from. But is it possible to do the grouping in
> >>>> a less intrusive fashion with OP_BUF_UPDATE? Because it won't change any
> >>>
> >>> The most of 'intrusive' change is just on patch 4, and Pavel has commented
> >>> that it is good enough:
> >>>
> >>> https://lore.kernel.org/linux-block/ZwZzsPcXyazyeZnu@fedora/T/#m551e94f080b80ccbd2561e01da5ea8e17f7ee15d
> >>
> >> At least for me, patch 4 looks fine. The problem occurs when you start
> >> needing to support this different buffer type, which is in patch 6. I'm
> >> not saying we can necessarily solve this with OP_BUF_UPDATE, I just want
> >> to explore that path because if we can, then patch 6 turns into "oh
> >> let's just added registered/fixed buffer support to these ops that don't
> >> currently support it". And that would be much nicer indeed.
> > 
> > OK, in my local V7, the buffer type is actually aligned with
> > BUFFER_SELECT from both interface & use viewpoint, since member SQE
> > have three empty flags available.
> > 
> > I will post V7 for review.
> 
> OK, I'll take a look once posted.
> 
> >>>> of the other ops in terms of buffer consumption, they'd just need fixed
> >>>> buffer support and you'd flag the buffer index in sqe->buf_index. And
> >>>> the nice thing about that is that while fixed/registered buffers aren't
> >>>> really used on the networking side yet (as they don't bring any benefit
> >>>> yet), adding support for them could potentially be useful down the line
> >>>> anyway.
> >>>
> >>> With 2), two extra syscalls are added for each ublk IO, one is provide
> >>> buffer, another is remove buffer. The two syscalls have to be sync with
> >>> consumer OPs.
> >>>
> >>> I can understand the concern, but if the change can't improve perf or
> >>> even slow things done, it loses its value.
> >>
> >> It'd be one extra syscall, as the remove can get bundled with the next
> >> add. But your point still stands, yes it will add extra overhead,
> > 
> > It can't be bundled.
> 
> Don't see why not, but let's review v7 and see what comes up.
> 
> > And the kernel buffer is blk-mq's request pages, which is per tag.
> > 
> > Such as, for ublk-target, IO comes to tag 0, after this IO(tag 0) is
> > handled, how can we know if there is new IO comes to tag 0 immediately? :-)
> 
> Gotcha, yeah sounds like that needs to remain a kernel buffer.
> 
> >> although be it pretty darn minimal. I'm actually more concerned with the
> >> complexity for handling it. While the OP_BUF_UPDATE will always
> >> complete immediately, there's no guarantee it's the next cqe you pull
> >> out when peeking post submission.
> >>
> >>>>> The same thing exists in the next OP_BUF_UPDATE which has to wait until
> >>>>> all the previous buffer consumers are done. So the same slow thing are
> >>>>> doubled. Not mention the application will become more complicated.
> >>>>
> >>>> It does not, you can do an update on a buffer that's already inflight.
> >>>
> >>> UPDATE may not match the case, actually two OPs are needed, one is
> >>> provide buffer OP and the other is remove buffer OP, both have to deal
> >>> with the other subsystem(ublk). Remove buffer needs to be done after all
> >>> consumer OPs are done immediately.
> >>
> >> You don't necessarily need the remove. If you always just use the same
> >> slot for these, then the OP_BUF_UPDATE will just update the current
> >> location.
> > 
> > The buffer is per tag, and can't guarantee to be reused immediately,
> > otherwise it isn't zero copy any more.
> 
> Don't follow this one either. As long as reuse keeps existing IO fine,
> then it should be fine? I'm not talking about reusing the buffer, just
> the slot it belongs to.

And both provide/remove buffer OP is dealing with IO buffer with same
unique tag, and the buffer is indexed by one key provided by user, which
is similar with ->buf_index. It is definitely not possible to remove one
old buffer and add new buffer in single command with same key. Another
reason is that we don't know if any new IO(with buffer) comes at that time.

Also anytime there is only 1 inflight IO with same tag in storage world,
there can't be new IO coming on current slot, since the old IO can't
completed until the kernel buffer is removed.

> 
> >>>> would be totally fine in terms of performance. OP_BUF_UPDATE will
> >>>> _always_ completely immediately and inline, which means that it'll
> >>>> _always_ be immediately available post submission. The only think you'd
> >>>> ever have to worry about in terms of failure is a badly formed request,
> >>>> which is a programming issue, or running out of memory on the host.
> >>>>
> >>>>> Also it makes error handling more complicated, io_uring has to remove
> >>>>> the kernel buffer when the current task is exit, dependency or order with
> >>>>> buffer provider is introduced.
> >>>>
> >>>> Why would that be? They belong to the ring, so should be torn down as
> >>>> part of the ring anyway? Why would they be task-private, but not
> >>>> ring-private?
> >>>
> >>> It is kernel buffer, which belongs to provider(such as ublk) instead
> >>> of uring, application may panic any time, then io_uring has to remove
> >>> the buffer for notifying the buffer owner.
> >>
> >> But it could be an application buffer, no? You'd just need the
> >> application to provide it to ublk and have it mapped, rather than have
> >> ublk allocate it in-kernel and then use that.
> > 
> > The buffer is actually kernel 'request/bio' pages of /dev/ublkbN, and now we
> > forward and borrow it to io_uring OPs(fs rw, net send/recv), so it can't be
> > application buffer, not same with net rx.
> 
> So you borrow the kernel pages, but presumably these are all from
> O_DIRECT and have a user mapping?

Yes.

> 
> >>> In concept grouping is simpler because:
> >>>
> >>> - buffer lifetime is aligned with group leader lifetime, so we needn't
> >>> worry buffer leak because of application accidental exit
> >>
> >> But if it was an application buffer, that would not be a concern.
> > 
> > Yeah, but storage isn't same with network, here application buffer can't
> > support zc.
> 
> Maybe I'm dense, but can you expand on why that's the case?

network data can come anytime, so I guess rx buffer has to be provided beforehand,
so it is just one buffer, which can be built from application or kernel.

Storage is client/server model, and data can only come after request
is sent to device, so buffer is prepared with request together before
sending the request, which is built in kernel in current linux, so it
has to be one kernel buffer(bio->bi_bvec).

> 
> >> I do like the concept of the ephemeral buffer, the downside is that we
> >> need per-op support for it too. And while I'm not totally against doing
> > 
> > Can you explain per-op support a bit?
> > 
> > Now the buffer has been provided by one single uring command.
> 
> I mean the need to do:
> 
> +	if (req->flags & REQ_F_GROUP_KBUF) {
> +		ret = io_import_group_kbuf(req, rw->addr, rw->len, ITER_SOURCE,
> +				&io->iter);
> +		if (unlikely(ret))
> +			return ret;
> +	}
> 
> for picking such a buffer.

The above is for starting to consume the buffer, which usage is same
with buffer_select case, in which the buffer still need to be imported.

And this patchset provides this buffer(REQ_F_GROUP_KBUF) in single
uring_cmd.

The use model is basically that we use driver specific commands for
providing & removing the kernel buffer, and the buffer is consumed
by generic io_uring OP with generic interface in group style.

Looks you and Pavel hope that generic buffer provide/remove kernel
buffer OPs can be added from beginning.

> 
> >> that, it would be lovely if we could utilize and existing mechanism for
> >> that rather than add another one.
> > 
> > If existing mechanism can cover everything, our linux may not progress any
> > more.
> 
> That's not what I mean at all. We already have essentially three ways to
> get a buffer destination for IO:
> 
> 1) Just pass in an uaddr+len or an iovec
> 2) Set ->buf_index, the op needs to support this separately to grab a
>    registered buffer for IO.
> 3) For pollable stuff, provided buffers, either via the ring or the
>    legacy/classic approach.
> 
> This adds a 4th method, which shares the characteristics of 2+3 that the
> op needs to support it. This is the whole motivation to poke at having a
> way to use the normal registered buffer table for this, because then
> this falls into method 2 above.

Here the kernel buffer has very short lifetime, and the lifetime is aligned
with block IO request in ublk use case, which is another big difference
with 2#, and could have shorter time than provided buffer too.

As we discussed, there are several disadvantages with existed mechanism
for this use case:

1) it is actually the above 3# provided buffer instead of registered buffer,
because:
- registered buffer is long-live, without dependency problem
- registered buffer can be imported in ->prep()

here the kernel buffer has short lifetime, can't be imported in ->prep()
because of buffer dependency.

2) dependency between consumer OPs and provide buffer & remove buffer,
which adds two extra syscalls for handling each ublk IO; and makes
application to become more complicated.

3) application may exit with exception or panic, uring has to
remove this kernel buffer from table when that happens, but removing
the kernel buffer need to return this buffer to the buffer provider.

4) The existed provide & register buffer needs big change for support to
provide/remove kernel buffer, and the model is more complicated than
group buffer method. The existed buffer use code(import buffer) has to
change too because it isn't real registered buffer. But if we treat it
as provided buffer, that is basically what this patch is doing.

Looks you and Pavel are fine with patch 4, which adds sqe or IO group concept,
just wondering if you may take one step further and consider the group buffer
concept, which is valid only in group wide(local buffer), won't need register
and needn't to be global, and implementation & use is simple.

The cons could be that one new buffer type is added, even BUFFER_SELECT
can be reused, but not flexible.

> 
> I'm not at all saying "oh we can't add this new feature", the only thing
> I'm addressing is HOW we do that. I don't think anybody disagrees that
> we need zero copy for ublk, and honestly I would love to see that sooner
> rather than later!

If fuse will switch to uring_cmd, it may benefit from it too.

The current fuse can only support WRITE zero copy, and READ zc never
gets supported, because of splice/pipe's limit. I discussed with
Miklos, turns out it is one impossible task to support fuse READ zc with
splice.

> 
> >>>>>> There are certainly many different ways that can get propagated which
> >>>>>> would not entail a complicated mechanism. I really like the aspect of
> >>>>>> having the identifier being the same thing that we already use, and
> >>>>>> hence not needing to be something new on the side.
> >>>>>>
> >>>>>>> Also multiple OPs may consume the buffer concurrently, which can't be
> >>>>>>> supported by buffer select.
> >>>>>>
> >>>>>> Why not? You can certainly have multiple ops using the same registered
> >>>>>> buffer concurrently right now.
> >>>>>
> >>>>> Please see the above problem.
> >>>>>
> >>>>> Also I remember that the selected buffer is removed from buffer list,
> >>>>> see io_provided_buffer_select(), but maybe I am wrong.
> >>>>
> >>>> You're mixing up provided and registered buffers. Provided buffers are
> >>>> ones that the applications gives to the kernel, and the kernel grabs and
> >>>> consumes them. Then the application replenishes, repeat.
> >>>>
> >>>> Registered buffers are entirely different, those are registered with the
> >>>> kernel and we can do things like pre-gup the pages so we don't have to
> >>>> do them for every IO. They are entirely persistent, any multiple ops can
> >>>> keep using them, concurrently. They don't get consumed by an IO like
> >>>> provided buffers, they remain in place until they get unregistered (or
> >>>> updated, like my patch) at some point.
> >>>
> >>> I know the difference.
> >>
> >> But io_provided_buffer_select() has nothing to do with registered/fixed
> >> buffers or this use case, the above "remove from buffer list" is an
> >> entirely different buffer concept. So there's some confusion here, just
> >> wanted to make that clear.
> >>
> >>> The thing is that here we can't register the kernel buffer in ->prep(),
> >>> and it has to be provided in ->issue() of uring command. That is similar
> >>> with provided buffer.
> >>
> >> What's preventing it from registering it in ->prep()? It would be a bit
> >> odd, but there would be nothing preventing it codewise, outside of the
> >> oddity of ->prep() not being idempotent at that point. Don't follow why
> >> that would be necessary, though, can you expand?
> > 
> > ->prep() doesn't export to uring cmd, and we may not want to bother
> > drivers.
> 
> Sure, we don't want it off ->uring_cmd() or anything like that.
> 
> > Also remove buffer still can't be done in ->prep().
> 
> I mean, technically it could... Same restrictions as add, however.
> 
> > Not dig into further, one big thing could be that dependency isn't
> > respected in ->prep().
> 
> This is the main thing I was considering, because there's nothing
> preventing it from happening outside of the fact that it makes ->prep()
> not idempotent. Which is a big enough reason already, but...

It depends on if the OP need to support IO_LINK, if yes, it can't be
done in ->prep(), otherwise the link rule is broken.

But here IO_LINK is important, because buffer dependency really exists,
IMO, we shouldn't put the limit on this OP from user viewpoint.


Thanks
Ming


