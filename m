Return-Path: <io-uring+bounces-1745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3CD8BB91D
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 03:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C3371F2289E
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 01:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04555CA1;
	Sat,  4 May 2024 01:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I6ezqv9G"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE9C1865
	for <io-uring@vger.kernel.org>; Sat,  4 May 2024 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714787821; cv=none; b=ftySMfWhV9m7cVK395vmmz2Ep1+GnrQgENwd3vLJ9oqvyHXFFF3aT73jC/gMwRMA7xDh0YIYT0cSOS2aShv6bKmCzpSv6J410Aj3da3HcAVe0xo+dwUCQvYwnxt5v5GZY9gyCNtUrseW65jj+0sja8eLYvlgg8H/3O3L8yDb+U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714787821; c=relaxed/simple;
	bh=Otj5m9PELif+eknMroD8AlUjhGarUNwe1B1KREke5zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAZcWL5xQuTrVCuMszw3GQjYgM4EH1tU01cGHrfGM7VkAhGke1XWz+BV0C5JiJ2o+nS0CpfiA3WpCXWlRKHXwTaS97ig+ft+BjqqQIupF9J0z+vh+phncb/jqc6hcyiW8DtzrrphG1ZCm48LoWund9tO3cr+2FcrcRBRFkhhmE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I6ezqv9G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714787818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g0TuD2A3tYS9B09zg7n93UlzeI+QL2fGwuxvtZ42VxI=;
	b=I6ezqv9G81J69PMWBqYLHeoIKcxEiPC2APWJqwVKB7Sb9m6P01e7Ch+/5JujB4oWBCKwQ5
	5HnZpRQxt9tUKu1+bvcJXR+v1N796ucL+MRK7DaFaUl7qfdITpn43uQ06JXQjy3GzNBVBP
	TSGJakPHzfYD8x2IQIJCGQkvV7X6lmI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-TSpxQC0rPei-F_xVqqZfLg-1; Fri, 03 May 2024 21:56:56 -0400
X-MC-Unique: TSpxQC0rPei-F_xVqqZfLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0400B1005055;
	Sat,  4 May 2024 01:56:56 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AEDFEC682;
	Sat,  4 May 2024 01:56:51 +0000 (UTC)
Date: Sat, 4 May 2024 09:56:47 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	ming.lei@redhat.com
Subject: Re: [PATCH 5/9] io_uring: support SQE group
Message-ID: <ZjWV32Atf2D8Z+pu@fedora>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
 <6077165e-a127-489e-9e47-6ec10b9d85d4@gmail.com>
 <ZjBffAzunso3lhsJ@fedora>
 <0f142448-3702-4be9-aad4-7ae6e1e5e785@gmail.com>
 <ZjEHhRoGP8z4syuP@fedora>
 <bc3f89dd-fa94-4f0f-b7e9-d6ac37a7c185@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc3f89dd-fa94-4f0f-b7e9-d6ac37a7c185@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Thu, May 02, 2024 at 03:09:13PM +0100, Pavel Begunkov wrote:
> On 4/30/24 16:00, Ming Lei wrote:
> > On Tue, Apr 30, 2024 at 01:27:10PM +0100, Pavel Begunkov wrote:
> > > On 4/30/24 04:03, Ming Lei wrote:
> > > > On Mon, Apr 29, 2024 at 04:32:35PM +0100, Pavel Begunkov wrote:
> > > > > On 4/23/24 14:08, Kevin Wolf wrote:
> > > > > > Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
> > > > > > > On 4/7/24 7:03 PM, Ming Lei wrote:
> > > > > > > > SQE group is defined as one chain of SQEs starting with the first sqe that
> > > > > > > > has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
> > > > > > > > doesn't have it set, and it is similar with chain of linked sqes.
> > > > > > > > 
> > > > > > > > The 1st SQE is group leader, and the other SQEs are group member. The group
> > > > > > > > leader is always freed after all members are completed. Group members
> > > > > > > > aren't submitted until the group leader is completed, and there isn't any
> > > > > > > > dependency among group members, and IOSQE_IO_LINK can't be set for group
> > > > > > > > members, same with IOSQE_IO_DRAIN.
> > > > > > > > 
> > > > > > > > Typically the group leader provides or makes resource, and the other members
> > > > > > > > consume the resource, such as scenario of multiple backup, the 1st SQE is to
> > > > > > > > read data from source file into fixed buffer, the other SQEs write data from
> > > > > > > > the same buffer into other destination files. SQE group provides very
> > > > > > > > efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
> > > > > > > > submitted in single syscall, no need to submit fs read SQE first, and wait
> > > > > > > > until read SQE is completed, 2) no need to link all write SQEs together, then
> > > > > > > > write SQEs can be submitted to files concurrently. Meantime application is
> > > > > > > > simplified a lot in this way.
> > > > > > > > 
> > > > > > > > Another use case is to for supporting generic device zero copy:
> > > > > > > > 
> > > > > > > > - the lead SQE is for providing device buffer, which is owned by device or
> > > > > > > >      kernel, can't be cross userspace, otherwise easy to cause leak for devil
> > > > > > > >      application or panic
> > > > > > > > 
> > > > > > > > - member SQEs reads or writes concurrently against the buffer provided by lead
> > > > > > > >      SQE
> > > > > > > 
> > > > > > > In concept, this looks very similar to "sqe bundles" that I played with
> > > > > > > in the past:
> > > > > > > 
> > > > > > > https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
> > > > > > > 
> > > > > > > Didn't look too closely yet at the implementation, but in spirit it's
> > > > > > > about the same in that the first entry is processed first, and there's
> > > > > > > no ordering implied between the test of the members of the bundle /
> > > > > > > group.
> > > > > > 
> > > > > > When I first read this patch, I wondered if it wouldn't make sense to
> > > > > > allow linking a group with subsequent requests, e.g. first having a few
> > > > > > requests that run in parallel and once all of them have completed
> > > > > > continue with the next linked one sequentially.
> > > > > > 
> > > > > > For SQE bundles, you reused the LINK flag, which doesn't easily allow
> > > > > > this. Ming's patch uses a new flag for groups, so the interface would be
> > > > > > more obvious, you simply set the LINK flag on the last member of the
> > > > > > group (or on the leader, doesn't really matter). Of course, this doesn't
> > > > > > mean it has to be implemented now, but there is a clear way forward if
> > > > > > it's wanted.
> > > > > 
> > > > > Putting zc aside, links, graphs, groups, it all sounds interesting in
> > > > > concept but let's not fool anyone, all the different ordering
> > > > > relationships between requests proved to be a bad idea.
> > > > 
> > > > As Jens mentioned, sqe group is very similar with bundle:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=io_uring-bundle
> > > > 
> > > > which is really something io_uring is missing.
> > > 
> > > One could've said same about links, retrospectively I argue that it
> > > was a mistake, so I pretty much doubt arguments like "io_uring is
> > > missing it". Another thing is that zero copy, which is not possible
> > > to implement by returning to the userspace.
> > > 
> > > > > I can complaint for long, error handling is miserable, user handling
> > > > > resubmitting a part of a link is horrible, the concept of errors is
> > > > > hard coded (time to appreciate "beautifulness" of IOSQE_IO_HARDLINK
> > > > > and the MSG_WAITALL workaround). The handling and workarounds are
> > > > > leaking into generic paths, e.g. we can't init files when it's the most
> > > > > convenient. For cancellation we're walking links, which need more care
> > > > > than just looking at a request (is cancellation by user_data of a
> > > > > "linked" to a group request even supported?). The list goes on
> > > > 
> > > > Only the group leader is linked, if the group leader is canceled, all
> > > > requests in the whole group will be canceled.
> > > > 
> > > > But yes, cancelling by user_data for group members can't be supported,
> > > > and it can be documented clearly, since user still can cancel the whole
> > > > group with group leader's user_data.
> > > 
> > > Which means it'd break the case REQ_F_INFLIGHT covers, and you need
> > > to disallow linking REQ_F_INFLIGHT marked requests.
> > 
> > Both io_match_linked() and io_match_task() only iterates over req's
> > link chain, and only the group leader can appear in this link chain,
> > which is exactly the usual handling.
> > 
> > So care to explain it a bit what the real link issue is about sqe group?
> 
> Because of ref deps when a task exits it has to cancel REQ_F_INFLIGHT
> requests, and therefore they should be discoverable. The flag is only
> for POLL_ADD requests polling io_uring fds, should be good enough if
> you disallow such requests from grouping.

The group leader is always marked as REQ_F_INFLIGHT and discoverable,
and the cancel code path cancels group leader request which will
guarantees that all group members are canceled, so I think this change
isn't needed.

But io_get_sequence() needs to take it into account, such as:

@@ -1680,8 +1846,12 @@ static u32 io_get_sequence(struct io_kiocb *req)
        struct io_kiocb *cur;

        /* need original cached_sq_head, but it was increased for each req */
-       io_for_each_link(cur, req)
-               seq--;
+       io_for_each_link(cur, req) {
+               if (req_is_group_lead(cur))
+                       seq -= atomic_read(&cur->grp_refs);
+               else
+                       seq--;
+       }

> 
> > > > > And what does it achieve? The infra has matured since early days,
> > > > > it saves user-kernel transitions at best but not context switching
> > > > > overhead, and not even that if you do wait(1) and happen to catch
> > > > > middle CQEs. And it disables LAZY_WAKE, so CQ side batching with
> > > > > timers and what not is effectively useless with links.
> > > > 
> > > > Not only the context switch, it supports 1:N or N:M dependency which
> > > 
> > > I completely missed, how N:M is supported? That starting to sound
> > > terrifying.
> > 
> > N:M is actually from Kevin's idea.
> > 
> > sqe group can be made to be more flexible by:
> > 
> >      Inside the group, all SQEs are submitted in parallel, so there isn't any
> >      dependency among SQEs in one group.
> >      The 1st SQE is group leader, and the other SQEs are group member. The whole
> >      group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
> >      the two flags can't be set for group members.
> >      When the group is in one link chain, this group isn't submitted until
> >      the previous SQE or group is completed. And the following SQE or group
> >      can't be started if this group isn't completed.
> >      When IOSQE_IO_DRAIN is set for group leader, all requests in this group
> >      and previous requests submitted are drained. Given IOSQE_IO_DRAIN can
> >      be set for group leader only, we respect IO_DRAIN for SQE group by
> >      always completing group leader as the last on in the group.
> >      SQE group provides flexible way to support N:M dependency, such as:
> >      - group A is chained with group B together by IOSQE_IO_LINK
> >      - group A has N SQEs
> >      - group B has M SQEs
> >      then M SQEs in group B depend on N SQEs in group A.
> 
> In other words, linking groups together with basically no extra rules.
> Fwiw, sounds generic, but if there are complications with IOSQE_IO_DRAIN
> that I don't immediately see, it'd be more reasonable to just disable it.

The only change on IO_DRAIN is on io_get_sequence() for taking leader->grp_refs
into account, and leader->grp_refs covers all requests in this group.

And my local patchset passes all related sqe->flags combination(DRAIN, LINKING,
ASYNC) on both single group or linked groups, meantime with extra change
of sharing same FORCE_ASYNC for both leader and members.

> 
> > > > is missing in io_uring, but also makes async application easier to write by
> > > > saving extra context switches, which just adds extra intermediate states for
> > > > application.
> > > 
> > > You're still executing requests (i.e. ->issue) primarily from the
> > > submitter task context, they would still fly back to the task and
> > > wake it up. You may save something by completing all of them
> > > together via that refcounting, but you might just as well try to
> > > batch CQ, which is a more generic issue. It's not clear what
> > > context switches you save then.
> > 
> > Wrt. the above N:M example, one io_uring_enter() is enough, and
> > it can't be done in single context switch without sqe group, please
> > see the liburing test code:
> > 
> > https://lore.kernel.org/io-uring/ZiHA+pN28hRdprhX@fedora/T/#ma755c500eab0b7dc8c1473448dd98f093097e066
> > 
> > > 
> > > As for simplicity, using the link example and considering error
> > > handling, it only complicates it. In case of an error you need to
> > > figure out a middle req failed, collect all failed CQEs linked to
> > > it and automatically cancelled (unless SKIP_COMPLETE is used), and
> > > then resubmit the failed. That's great your reads are idempotent
> > > and presumably you don't have to resubmit half a link, but in the
> > > grand picture of things it's rather one of use cases where a generic
> > > feature can be used.
> > 
> > SQE group doesn't change the current link implementation, and N:M
> > dependency is built over IOSQE_IO_LINK actually.
> > 
> > > 
> > > > > So, please, please! instead of trying to invent a new uber scheme
> > > > > of request linking, which surely wouldn't step on same problems
> > > > > over and over again, and would definitely be destined to overshadow
> > > > > all previous attempts and finally conquer the world, let's rather
> > > > > focus on minimasing the damage from this patchset's zero copy if
> > > > > it's going to be taken.
> > > > 
> > > > One key problem for zero copy is lifetime of the kernel buffer, which
> > > > can't cross OPs, that is why sqe group is introduced, for aligning
> > > > kernel buffer lifetime with the group.
> > > 
> > > Right, which is why I'm saying if we're leaving groups with zero
> > > copy, let's rather try to make them simple and not intrusive as
> > > much as possible, instead of creating an unsupportable overarching
> > > beast out of it, which would fail as a generic feature.
> > 
> > Then it degraded to the original fused command, :-)
> 
> I'm not arguing about restricting it to 1 request in a group apart
> from the master/leader/etc., if that's what you mean. The argument
> is rather to limit the overhead and abstraction leakage into hot
> paths.
> 
> For example that N:M, all that sounds great on paper until it sees
> the harsh reality. And instead of linking groups together, you
> can perfectly fine be sending one group at a time and queuing the
> next group from the userspace when the previous completes. And
> that would save space in io_kiocb, maybe(?) a flag, maybe something
> else.

Yes, it can be done with userspace, with cost of one extra io_uring_enter()
for handling two depended groups in userspace.

io_uring excellent performance is attributed to great batch processing,
if group linking is done in per-IO level, this way could degrade
performance a lot. And we know io_uring may perform worse in QD=1.

And the introduced 12 bytes doesn't add extra l1 cacheline, and won't
be touched in code path without using group.

> 
> Regardless of interoperability with links, I'd also prefer it to
> be folded into the link code structure and state machine, so
> it's not all over in the submission/completion paths adding
> overhead for one narrow feature, including un-inlining the
> entire submission path.

I can work toward this direction if the idea of sqe group may be accepted
but the biggest blocker could be where to allocate the extra SQE_GROUP
flag.

> 
> E.g. there should be no separate hand coded duplicated SQE
> / request assembling like in io_init_req_group(). Instead
> it should be able to consume SQEs and requests it's given
> from submit_sqes(), and e.g. process grouping in
> io_submit_sqe() around the place requests are linked.

Yeah, IOSQE_IO_LINK sort of handling could be needed for processing
requests in group.


Thanks,
Ming


