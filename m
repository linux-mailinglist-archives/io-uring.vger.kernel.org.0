Return-Path: <io-uring+bounces-7053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CA1A5D467
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 03:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C0B53B4118
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 02:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B2815A868;
	Wed, 12 Mar 2025 02:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DqIGbvya"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF316D4E6
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 02:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741746849; cv=none; b=WfrBghrXPHWE8tvkcH/1Wlm9WPfGu5gBvTE95xgzpRjqcr7gRV4/x5eD1xXgkPVkg5K+bCFbwFjEhunr3AWnYSUZSFmkgqZR3h1HWsZE9xFdDDhjvtESilI2fY7t2Hq0VSSoyQZP5BvQZVln59at4/b7YeKC0DaNw/6DAlpOfr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741746849; c=relaxed/simple;
	bh=M48AM9kcumZWzN55D21lzW7LRTHUoW/zsTZg7ld9Cug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/AG5IbrWiDUO+ZdaNpuzJEH7+s4bZNFcEKGMhGAjUc6UQYtUJ9eGzJiKnYv5gwHuF5PL7nssoT/n+3+kZscGcPdaaYI8kx6vlN/FhP1N8YPtBeFrPtjs0pXU0bbYCz1oIglL/klitIfmbu0DguMmlXufgELXBexvvbR65uCJKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DqIGbvya; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22423adf751so91499725ad.2
        for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 19:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741746846; x=1742351646; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Stlf1qu6rV+8OapbnZzujdtm5F0KDIptQKaIEDCKwrU=;
        b=DqIGbvyaCckdB2/yNgqiErjrfLm25dqPw1SJvR2X25n3Vo/bRz7K4ExS5Jmq4+9+d5
         YvTdc4+EgsazdSUXXCLX3SfkzZAbGIfprVLirv5bi+gQpsT5R1UfGb1OfVFKaginOqtO
         emDVjZb8KVESah1IHByP+kH8fEl5ASLND2/fV/07MNFEJ7megtZ6/Qp+UmTBUMNc1P8M
         RSTd6R2et+J5sD4mMuDdlvZLJtt97xL4wxu5UqHmiAd8SeQsqMjRBurDeHRDcWoCnFxl
         7MxiFu9cKpaE2XLrLunpmsXOp5Z5eI+71zwel7PX8EU3m/1B4uUk2bscHgCXqWH8tLP8
         nNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741746846; x=1742351646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Stlf1qu6rV+8OapbnZzujdtm5F0KDIptQKaIEDCKwrU=;
        b=PnoP2KEnItcO+SiLen4pxj84ANu2SBG2+XENWxe483Lqbar43P8sjr7GIL118BI9uO
         jftkGsavQYkRBF2TjoEfNVqROFxnn2SuFsZg0pQnTQjHzpzbm/G750tPMyrF6Xi8Be0U
         She8jzEmlTyutkAbT/WI0aCpFsdW7osI+GGcG9CzHHEvXaC1zC7cTxjegbdFIWnv+nEA
         /c3OEN3joAmAJqFUjFGfgyMYP/t8HBoG7/smhnx00dcUUQFxnzFz/paOLTLRerVtvWrI
         so02CwWnRJpM2ZYlQDOYVBRtfR/x1f0V73ALyewBv9ieXAbU5BYxjR4xVjEAk8m0CwhO
         kGSA==
X-Forwarded-Encrypted: i=1; AJvYcCVfy3SVSiJfcz+8ogTvLb0R7xqXMFAWBx7ICOhh0isUyhk8MjkW3n2fwY6koGSVLvXT8I3bn/5Llw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTcT9uOz0y7BSbQIdowL85D6pRcrNAiFDyP1Btr4rYTLulZ/jc
	tfFxrwTHEBzS4cJmIglzr8tZKA8iC3FRWhtUxiTtJ+C1MDb+rPQygzjiGQ8eP+4=
X-Gm-Gg: ASbGncvQ6202bH/yi+IEWszae5P65YRZRFufXryE/WvFYEoHNykDFKEp556AO/T5x4C
	u9dl5R00cVg/1hRGajYn/AvaOm4pSw1nmmmYxFtVwDb7oLysOrhufs9DAXu94ZlBT2dl4f7NWx5
	S/yH6UqmhrrP/wwbB+dbi2KGi2tTYfFoCi/OI5ROiB41BnLAzNGnDjv8hM1IUxFyff0HsLdKyWg
	uRjodNbluLjfF4vqSkM3wwcRic1/8YcQe08v+sgEBW/Tdd+XwN1n/P67PvKJ9DzO5N3H6/v+Mqp
	NblUTbtRr94bHGg6espEVB8kbMYQO4vtmCCnYSOp19i3OtFKTVLTHLbO0+zBSUAIKFYUEJz0N1Q
	dj5IjH6Fp/jVjq8S/NrWg
X-Google-Smtp-Source: AGHT+IGcm3lvVDuzTxuY7XdP4D+eZSLjgBNBtRf9A2oXbOqunQw+ST+TfFUK9jaq8Qp+O7C4BkIDOA==
X-Received: by 2002:a17:902:d48f:b0:224:76f:9e4a with SMTP id d9443c01a7336-22592e2d5b2mr85216595ad.14.1741746845581;
        Tue, 11 Mar 2025 19:34:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddc7esm105413475ad.48.2025.03.11.19.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 19:34:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tsBv0-0000000ByYH-0qEH;
	Wed, 12 Mar 2025 13:34:02 +1100
Date: Wed, 12 Mar 2025 13:34:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9DymjGRW3mTPJTt@dread.disaster.area>
References: <Z8XlvU0o3C5hAAaM@infradead.org>
 <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
 <Z8Zh5T9ZtPOQlDzX@dread.disaster.area>
 <1fde6ab6-bfba-3dc4-d7fb-67074036deb0@redhat.com>
 <Z8eURG4AMbhornMf@dread.disaster.area>
 <81b037c8-8fea-2d4c-0baf-d9aa18835063@redhat.com>
 <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9ATyhq6PzOh7onx@fedora>

On Tue, Mar 11, 2025 at 06:43:22PM +0800, Ming Lei wrote:
> On Tue, Mar 11, 2025 at 12:27:23PM +1100, Dave Chinner wrote:
> > On Mon, Mar 10, 2025 at 12:18:51PM +0100, Mikulas Patocka wrote:
> > > On Sun, 9 Mar 2025, Ming Lei wrote:
> > > > Please try the following patchset:
> > > > 
> > > > https://lore.kernel.org/linux-block/20250308162312.1640828-1-ming.lei@redhat.com/
> > > > 
> > > > which tries to handle IO in current context directly via NOWAIT, and
> > > > supports MQ for loop since 12 io jobs are applied in your test. With this
> > > > change, I can observe similar perf data on raw block device and loop/xfs
> > > > over mq-virtio-scsi & nvme in my test VM.
> > 
> > I'm not sure RWF_NOWAIT is a workable solution.
> > 
> > Why?
> 
> It is just the sane implementation of Mikulas's static mapping
> approach: no need to move to workqueue if the mapping is immutable
> or sort of.
> 
> Also it matches with io_uring's FS read/write implementation:
>
> - try to submit IO with NOWAIT first
> - then fallback to io-wq in case of -EAGAIN

No, it doesn't match what io_uring does. yes, the NOWAIT bit does,
but the work queue implementation is in the loop device is
completely different to the way io_uring dispatches work.

That is, io_uring dispatches one IO per wroker thread context so
they can all run in parallel down through the filesystem. The loop
device has a single worker thread so it -serialises- IO submission
to the filesystem.

i.e. blocking a single IO submission in the loop worker blocks all
IO submission, whereas io_uring submits all IO indepedently so they
only block if serialisation occurs further down the stack.

> It isn't perfect, sometime it may be slower than running on io-wq
> directly.
> 
> But is there any better way for covering everything?

Yes - fix the loop queue workers.

> I guess no, because FS can't tell us when the IO can be submitted
> successfully via NOWAIT, and we can't know if it may succeed without
> trying. And basically that is what the interface is designed.

Wrong.

Speculative non-blocking IO like NOWAIT is the wrong optimisation to
make for workloads that are very likely to block in the IO path. It
just adds overhead without adding any improvement in performance.

Getting rid of the serialised IO submission problems that the loop
device current has will benefit *all* workloads that use the loop
device, not just those that are fully allocated. Yes, it won't quite
show the same performance as NOWAIT in that case, but it still
should give 90-95% of native performance for the static file case.
And it should also improve all the other cases, too, because now
they will only serialise when the backing file needs IO operations to
serialise (i.e. during allocation).

> > IO submission is queued to a different thread context because to
> > avoid a potential deadlock. That is, we are operating here in the
> > writeback context of another filesystem, and so we cannot do things
> > like depend on memory allocation making forwards progress for IO
> > submission.  RWF_NOWAIT is not a guarantee that memory allocation
> > will not occur in the IO submission path - it is implemented as best
> > effort non-blocking behaviour.
> 
> Yes, that is why BLK_MQ_F_BLOCKING is added.
> 
> > 
> > Further, if we have stacked loop devices (e.g.
> > xfs-loop-ext4-loop-btrfs-loop-xfs) we can will be stacking
> > RWF_NOWAIT IO submission contexts through multiple filesystems. This
> > is not a filesystem IO path I want to support - being in the middle
> > of such a stack creates all sorts of subtle constraints on behaviour
> > that otherwise wouldn't exist. We actually do this sort of multi-fs
> > stacking in fstests, so it's not a made up scenario.
> > 
> > I'm also concerned that RWF_NOWAIT submission is not an optimisation
> > at all for the common sparse/COW image file case, because in this
> > case RWF_NOWAIT failing with EAGAIN is just as common (if not
> > moreso) than it succeeding.
> > 
> > i.e. in this case, RWF_NOWAIT writes will fail with -EAGAIN very
> > frequently, so all that time spent doing IO submission is wasted
> > time.
> 
> Right.
> 
> I saw that when I wrote ublk/zoned in which every write needs to
> allocate space. It is workaround by preallocating space for one fixed
> range or the whole zone.

*cough*

You do realise that fallocate() serialises all IO on the file? i.e.
not only does it block all IO submission, mmap IO and other metadata
operations, it also waits for all IO in flight to complete and it
doesn't allow any IO to restart until the preallocation is complete.

i.e. preallocation creates a huge IO submission latency bubble in
the IO path. Hence preallocation is something that should be avoided
at runtime if at all possible.

If you have problems with allocation overhead during IO, then we
have things like extent size hints that allow the per-IO allocation
to be made much larger than the IO itself. This effectively does
preallocation during IO without the IO pipeline bubbles that
preallocation requires to function correctly....

> > Further, because allocation on write requires an exclusive lock and
> > it is held for some time, this will affect read performance from the
> > backing device as well. i.e. block mapping during a read while a
> > write is doing allocation will also return EAGAIN for RWF_NOWAIT.
> 
> But that can't be avoided without using NOWAIT, and read is blocked
> when write(WAIT) is in-progress.

If the loop worker dispatches each IO in it's own task context, then
we don't care if a read IO blocks on some other write in progress.
It doesn't get in the way of any other IO submission...

> > This will push the read off to the background worker thread to be
> > serviced and so that will go much slower than a RWF_NOWAIT read that
> > hits the backing file between writes doing allocation. i.e. read
> > latency is going to become much, much more variable.
> > 
> > Hence I suspect RWF_NOWAIT is simply hiding the underlying issue
> > by providing this benchmark with a "pure overwrite" fast path that
> > avoids the overhead of queueing work through loop_queue_work()....
> > 
> > Can you run these same loop dev tests using a sparse image file and
> > a sparse fio test file so that the fio benchmark measures the impact
> > of loop device block allocation on the test? I suspect the results
> > with the RWF_NOWAIT patch will be somewhat different to the fully
> > allocated case...
> 
> Yes, it will be slower, and io_uring FS IO application is in
> the same situation, and usually application doesn't have such
> knowledge if RWF_NOWAIT can succeed.

And that's my point: nothing above the filesystem will have - or
can have - any knowledge of whether NOWAIT IO will succeed or
not.

Therefore we have to use our brains to analyse what the typical
behaviour of the filesystem will be for a given situation to
determine how best to optimise IO submission.

> However, usually meta IO is much less compared with normal IO, so most
> times it will be a win to try NOWAIT first.

Data vs metadata from the upper filesystem doesn't even enter into
the equation here.

Filesystems like XFS, bcachefs and btrfs all dynamically create,
move and remove metadata, so metadata writes are as much of an
allocation problem for sparse loop backing files as write-once user
data IO is.

> > Yup, this sort of difference in performance simply from bypassing
> > loop_queue_work() implies the problem is the single threaded loop
> > device queue implementation needs to be fixed.
> > 
> > loop_queue_work()
> > {
> > 	....
> > 	spin_lock_irq(&lo->lo_work_lock);
> > 	....
> > 
> >         } else {
> >                 work = &lo->rootcg_work;
> >                 cmd_list = &lo->rootcg_cmd_list;
> >         }
> > 	list_add_tail(&cmd->list_entry, cmd_list);
> > 	queue_work(lo->workqueue, work);
> > 	spin_unlock_irq(&lo->lo_work_lock);
> > }
> > 
> > Not only does every IO that is queued takes this queue lock, there
> > is only one work instance for the loop device. Therefore there is
> > only one kworker process per control group that does IO submission
> > for the loop device. And that kworker thread also takes the work
> > lock to do dequeue as well.
> > 
> > That serialised queue with a single IO dispatcher thread looks to be
> > the performance bottleneck to me. We could get rid of the lock by
> > using a llist for this multi-producer/single consumer cmd list
> > pattern, though I suspect we can get rid of the list entirely...
> > 
> > i.e. we have a work queue that can run a
> > thousand concurrent works for this loop device, but the request
> > queue is depth limited to 128 requests. hence we can have a full
> > set of requests in flight and not run out of submission worker
> > concurrency. There's no need to isolate IO from different cgroups in
> > this situation - they will not get blocked behind IO submission
> > from a different cgroup that is throttled...
> > 
> > i.e. the cmd->list_entry list_head could be replaced with a struct
> > work_struct and that whole cmd list management and cgroup scheduling
> > thing could be replaced with a single call to
> > queue_work(cmd->io_work). i.e. the single point that all IO
> 
> Then there will be many FS write contention, :-)

Did you think about how much parallelism your NOWAIT patches are
directing at the loop device backing file before making that
comment?

The fio test that was run had 12 jobs running, there is at least
12-way IO concurrency hitting the backing file directly via the
NOWAIT path.

Yup, the NOWAIT path exposes the filesystem directly to userspace
write IO concurrency.  Yet the filesystem IO scaled to near raw
device speed....

It should be obvious that adding more IO concurrency to loop
device IO submission isn't a problem for the XFS IO path. And if it
proves to be an issue, then that's an XFS problem to solve, not a
generic device scalability issue.

> > submission is directed through goes away completely.
> 
> It has been shown many times that AIO submitted from single or much less
> contexts is much more efficient than running IO concurrently from multiple
> contexts, especially for sequential IO.

Yes, I know that, and I'm not disputing that this is the most
optimal way to submit IO *when it doesn't require blocking to
dispatch*.

However, the fact is this benefit only exists when all IO can be
submitted in a non-blocking manner.

As soon as blocking occurs in IO submission, then AIO submission
either becomes synchronous or is aborted with EAGAIN (i.e. NOWAIT
io).

If we use blocking submission behaviour, then performance tanks.
This is what the loop device does right now.

If we use non-blocking submission and get -EAGAIN, then we still
need to use the slightly less efficient method of per-IO task
contexts to scale out blocking IO submission.

With that in mind, we must accept that loop device IO *frequently
needs to block* and so non-blocking IO is the wrong behaviour to
optimise *exclusively* for.

Hence we need to first make the loop device scale with per-IO task
contexts as this will improve both IO that can be dispatched without
blocking as well as IO that will block during dispatch.  If this
does not bring performance up to acceptible levels, then other
optimisations can then be considered.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

