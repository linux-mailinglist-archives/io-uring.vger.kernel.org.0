Return-Path: <io-uring+bounces-1689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5188B7AE4
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 17:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51337286746
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 15:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF5817BB33;
	Tue, 30 Apr 2024 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LEXkKs3r"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7038B17BB21
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714489238; cv=none; b=WiAY/O8HHs+UaitXMITqzfF16qMXKQD+HQ6EfHTKbKMdc3rpG0i4F0nclo3jbIyJVIpXzm8m023TzART+v+d0CddZg2SDV5Q9waIV3hHTyzGn7rQrvqV8teEjck20C9JshqOYW+5YZUns0AugmxbzayBIC3DO1kHDKKH1n1ZiDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714489238; c=relaxed/simple;
	bh=dVa3+A4hPQOp2cwfrkwPzPPHetg5nbNTW7DotXjC6kY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDr2e4cBnd7XWNBciNSe+hFcKkSRClYm8g1Bf7QIFz7RC9Y6DBOToGz3znUvl7Pb26yNKEmmNG08yHn9sbyc3fkPG1eoJz4tj9noXYQq+xPk+LRux7wCcBJBFfsm7L1m7RX4NnO0N2FXODq6I1MHtsjDw7RF0vyyfujYdRx6xLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LEXkKs3r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714489235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uREv44CEvp2n490pQEElChrCwEHmm5/ZmjXtMG+PLZo=;
	b=LEXkKs3rI2kDXmjGGZm8v/8zQsQ5vrRjCbjDIWk+z1ZY5btvzLCzM7wWUnALLYcwQdlAvZ
	RrgUVbrmC7/ZfzlMfsdKKPs2R7SqCW68g3l47hNSdhwRuhyODiOwZMWB2pheYZYOjiuyxa
	Y2a8iUTqFPFZ0V9fs89ZnzAe0lJbZkM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-RQyk2-tLNoWe2uQQ7gOqPQ-1; Tue, 30 Apr 2024 11:00:31 -0400
X-MC-Unique: RQyk2-tLNoWe2uQQ7gOqPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C79081F44B;
	Tue, 30 Apr 2024 15:00:31 +0000 (UTC)
Received: from fedora (unknown [10.72.116.42])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DAD9201F35C;
	Tue, 30 Apr 2024 15:00:26 +0000 (UTC)
Date: Tue, 30 Apr 2024 23:00:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	ming.lei@redhat.com
Subject: Re: [PATCH 5/9] io_uring: support SQE group
Message-ID: <ZjEHhRoGP8z4syuP@fedora>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
 <6077165e-a127-489e-9e47-6ec10b9d85d4@gmail.com>
 <ZjBffAzunso3lhsJ@fedora>
 <0f142448-3702-4be9-aad4-7ae6e1e5e785@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f142448-3702-4be9-aad4-7ae6e1e5e785@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Apr 30, 2024 at 01:27:10PM +0100, Pavel Begunkov wrote:
> On 4/30/24 04:03, Ming Lei wrote:
> > On Mon, Apr 29, 2024 at 04:32:35PM +0100, Pavel Begunkov wrote:
> > > On 4/23/24 14:08, Kevin Wolf wrote:
> > > > Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
> > > > > On 4/7/24 7:03 PM, Ming Lei wrote:
> > > > > > SQE group is defined as one chain of SQEs starting with the first sqe that
> > > > > > has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
> > > > > > doesn't have it set, and it is similar with chain of linked sqes.
> > > > > > 
> > > > > > The 1st SQE is group leader, and the other SQEs are group member. The group
> > > > > > leader is always freed after all members are completed. Group members
> > > > > > aren't submitted until the group leader is completed, and there isn't any
> > > > > > dependency among group members, and IOSQE_IO_LINK can't be set for group
> > > > > > members, same with IOSQE_IO_DRAIN.
> > > > > > 
> > > > > > Typically the group leader provides or makes resource, and the other members
> > > > > > consume the resource, such as scenario of multiple backup, the 1st SQE is to
> > > > > > read data from source file into fixed buffer, the other SQEs write data from
> > > > > > the same buffer into other destination files. SQE group provides very
> > > > > > efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
> > > > > > submitted in single syscall, no need to submit fs read SQE first, and wait
> > > > > > until read SQE is completed, 2) no need to link all write SQEs together, then
> > > > > > write SQEs can be submitted to files concurrently. Meantime application is
> > > > > > simplified a lot in this way.
> > > > > > 
> > > > > > Another use case is to for supporting generic device zero copy:
> > > > > > 
> > > > > > - the lead SQE is for providing device buffer, which is owned by device or
> > > > > >     kernel, can't be cross userspace, otherwise easy to cause leak for devil
> > > > > >     application or panic
> > > > > > 
> > > > > > - member SQEs reads or writes concurrently against the buffer provided by lead
> > > > > >     SQE
> > > > > 
> > > > > In concept, this looks very similar to "sqe bundles" that I played with
> > > > > in the past:
> > > > > 
> > > > > https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
> > > > > 
> > > > > Didn't look too closely yet at the implementation, but in spirit it's
> > > > > about the same in that the first entry is processed first, and there's
> > > > > no ordering implied between the test of the members of the bundle /
> > > > > group.
> > > > 
> > > > When I first read this patch, I wondered if it wouldn't make sense to
> > > > allow linking a group with subsequent requests, e.g. first having a few
> > > > requests that run in parallel and once all of them have completed
> > > > continue with the next linked one sequentially.
> > > > 
> > > > For SQE bundles, you reused the LINK flag, which doesn't easily allow
> > > > this. Ming's patch uses a new flag for groups, so the interface would be
> > > > more obvious, you simply set the LINK flag on the last member of the
> > > > group (or on the leader, doesn't really matter). Of course, this doesn't
> > > > mean it has to be implemented now, but there is a clear way forward if
> > > > it's wanted.
> > > 
> > > Putting zc aside, links, graphs, groups, it all sounds interesting in
> > > concept but let's not fool anyone, all the different ordering
> > > relationships between requests proved to be a bad idea.
> > 
> > As Jens mentioned, sqe group is very similar with bundle:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=io_uring-bundle
> > 
> > which is really something io_uring is missing.
> 
> One could've said same about links, retrospectively I argue that it
> was a mistake, so I pretty much doubt arguments like "io_uring is
> missing it". Another thing is that zero copy, which is not possible
> to implement by returning to the userspace.
> 
> > > I can complaint for long, error handling is miserable, user handling
> > > resubmitting a part of a link is horrible, the concept of errors is
> > > hard coded (time to appreciate "beautifulness" of IOSQE_IO_HARDLINK
> > > and the MSG_WAITALL workaround). The handling and workarounds are
> > > leaking into generic paths, e.g. we can't init files when it's the most
> > > convenient. For cancellation we're walking links, which need more care
> > > than just looking at a request (is cancellation by user_data of a
> > > "linked" to a group request even supported?). The list goes on
> > 
> > Only the group leader is linked, if the group leader is canceled, all
> > requests in the whole group will be canceled.
> > 
> > But yes, cancelling by user_data for group members can't be supported,
> > and it can be documented clearly, since user still can cancel the whole
> > group with group leader's user_data.
> 
> Which means it'd break the case REQ_F_INFLIGHT covers, and you need
> to disallow linking REQ_F_INFLIGHT marked requests.

Both io_match_linked() and io_match_task() only iterates over req's
link chain, and only the group leader can appear in this link chain,
which is exactly the usual handling.

So care to explain it a bit what the real link issue is about sqe group?

> 
> > > And what does it achieve? The infra has matured since early days,
> > > it saves user-kernel transitions at best but not context switching
> > > overhead, and not even that if you do wait(1) and happen to catch
> > > middle CQEs. And it disables LAZY_WAKE, so CQ side batching with
> > > timers and what not is effectively useless with links.
> > 
> > Not only the context switch, it supports 1:N or N:M dependency which
> 
> I completely missed, how N:M is supported? That starting to sound
> terrifying.

N:M is actually from Kevin's idea.

sqe group can be made to be more flexible by:

    Inside the group, all SQEs are submitted in parallel, so there isn't any
    dependency among SQEs in one group.
    
    The 1st SQE is group leader, and the other SQEs are group member. The whole
    group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
    the two flags can't be set for group members.
    
    When the group is in one link chain, this group isn't submitted until
    the previous SQE or group is completed. And the following SQE or group
    can't be started if this group isn't completed.
    
    When IOSQE_IO_DRAIN is set for group leader, all requests in this group
    and previous requests submitted are drained. Given IOSQE_IO_DRAIN can
    be set for group leader only, we respect IO_DRAIN for SQE group by
    always completing group leader as the last on in the group.
    
    SQE group provides flexible way to support N:M dependency, such as:
    
    - group A is chained with group B together by IOSQE_IO_LINK
    - group A has N SQEs
    - group B has M SQEs
    
    then M SQEs in group B depend on N SQEs in group A.


> 
> > is missing in io_uring, but also makes async application easier to write by
> > saving extra context switches, which just adds extra intermediate states for
> > application.
> 
> You're still executing requests (i.e. ->issue) primarily from the
> submitter task context, they would still fly back to the task and
> wake it up. You may save something by completing all of them
> together via that refcounting, but you might just as well try to
> batch CQ, which is a more generic issue. It's not clear what
> context switches you save then.

Wrt. the above N:M example, one io_uring_enter() is enough, and
it can't be done in single context switch without sqe group, please
see the liburing test code:

https://lore.kernel.org/io-uring/ZiHA+pN28hRdprhX@fedora/T/#ma755c500eab0b7dc8c1473448dd98f093097e066

> 
> As for simplicity, using the link example and considering error
> handling, it only complicates it. In case of an error you need to
> figure out a middle req failed, collect all failed CQEs linked to
> it and automatically cancelled (unless SKIP_COMPLETE is used), and
> then resubmit the failed. That's great your reads are idempotent
> and presumably you don't have to resubmit half a link, but in the
> grand picture of things it's rather one of use cases where a generic
> feature can be used.

SQE group doesn't change the current link implementation, and N:M
dependency is built over IOSQE_IO_LINK actually.

> 
> > > So, please, please! instead of trying to invent a new uber scheme
> > > of request linking, which surely wouldn't step on same problems
> > > over and over again, and would definitely be destined to overshadow
> > > all previous attempts and finally conquer the world, let's rather
> > > focus on minimasing the damage from this patchset's zero copy if
> > > it's going to be taken.
> > 
> > One key problem for zero copy is lifetime of the kernel buffer, which
> > can't cross OPs, that is why sqe group is introduced, for aligning
> > kernel buffer lifetime with the group.
> 
> Right, which is why I'm saying if we're leaving groups with zero
> copy, let's rather try to make them simple and not intrusive as
> much as possible, instead of creating an unsupportable overarching
> beast out of it, which would fail as a generic feature.

Then it degraded to the original fused command, :-)

Thanks,
Ming


