Return-Path: <io-uring+bounces-7045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B32C9A5BE1E
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 11:43:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 527393A95B1
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 10:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60BB23F382;
	Tue, 11 Mar 2025 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxX99SXU"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A44923F37D
	for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 10:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741689825; cv=none; b=eZJ85QOS+4NGSVVTpGr7UmU61sbpFSTNBTk/c4c6cb+gU4BJKvHyVLYfmKclMqvuhqsLkdE6ofXucT9ywa37GXBP1IOWQ+HMmi6Ctiy+Hm61s08mdHlo6HdLSTPnHMZ4nsNWci1B3rTlzkGqSOSs7AFczIwtA38AcywxZ1bRsFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741689825; c=relaxed/simple;
	bh=NDwrEIZNfNjx9TGRyM9gQPDMqS+Y0o92VGzdpyG3Afs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEaYzVXodupyUy5+GcDCntdXm/rsHppOyQKyowfd8u9wui19K2ysFxlhDwUaF4uNYIVBPtSYyQh/lzgQtFxKQlhPg/1riXDOENYH6y5OEtJSFKXG9LaCrfEsoaefY5fGT7/FHNoDTnBGxWp70BHMeLu9VmkuuBS8nV0nDZejO+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxX99SXU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741689822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gNTaRcQRZpz5AR59VTWcpjr921hgmtZv7ZHul/eXdxI=;
	b=bxX99SXUK9Cmdpb++0NEqX0AYYdTEBd0zh4aYNQ9pCah9CRXBlaa6Kkclz/LUxHJHOPVGY
	Xv7vG4O8ou32PGhpoIRvfybBdrrXCjPn6UbNKhKe6NkRjuvV/c1BNhbjQyZAYNiVnVkAc0
	DqlWMZnv2fsjtZhqkNf0pFw7YX+X5Eo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-D5yxNuwVOomwOm4HF4M5XA-1; Tue,
 11 Mar 2025 06:43:39 -0400
X-MC-Unique: D5yxNuwVOomwOm4HF4M5XA-1
X-Mimecast-MFC-AGG-ID: D5yxNuwVOomwOm4HF4M5XA_1741689818
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E597195608A;
	Tue, 11 Mar 2025 10:43:37 +0000 (UTC)
Received: from fedora (unknown [10.72.120.28])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCD9A1828A93;
	Tue, 11 Mar 2025 10:43:28 +0000 (UTC)
Date: Tue, 11 Mar 2025 18:43:22 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9ATyhq6PzOh7onx@fedora>
References: <b3caee06-c798-420e-f39f-f500b3ea68ca@redhat.com>
 <Z8XlvU0o3C5hAAaM@infradead.org>
 <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
 <Z8Zh5T9ZtPOQlDzX@dread.disaster.area>
 <1fde6ab6-bfba-3dc4-d7fb-67074036deb0@redhat.com>
 <Z8eURG4AMbhornMf@dread.disaster.area>
 <81b037c8-8fea-2d4c-0baf-d9aa18835063@redhat.com>
 <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8-ReyFRoTN4G7UU@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Mar 11, 2025 at 12:27:23PM +1100, Dave Chinner wrote:
> On Mon, Mar 10, 2025 at 12:18:51PM +0100, Mikulas Patocka wrote:
> > 
> > 
> > On Sun, 9 Mar 2025, Ming Lei wrote:
> > 
> > > On Fri, Mar 07, 2025 at 04:21:58PM +0100, Mikulas Patocka wrote:
> > > > > I didn't say you were. I said the concept that dm-loop is based on
> > > > > is fundamentally flawed and that your benchmark setup does not
> > > > > reflect real world usage of loop devices.
> > > > 
> > > > > Where are the bug reports about the loop device being slow and the
> > > > > analysis that indicates that it is unfixable?
> > > > 
> > > > So, I did benchmarks on an enterprise nvme drive (SAMSUNG 
> > > > MZPLJ1T6HBJR-00007). I stacked ext4/loop/ext4, xfs/loop/xfs (using losetup 
> > > > --direct-io=on), ext4/dm-loop/ext4 and xfs/dm-loop/xfs. And loop is slow.
> > > > 
> > > > synchronous I/O:
> > > > fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=psync --iodepth=1 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
> > > > raw block device:
> > > >    READ: bw=399MiB/s (418MB/s), 399MiB/s-399MiB/s (418MB/s-418MB/s), io=3985MiB (4179MB), run=10001-10001msec
> > > >   WRITE: bw=399MiB/s (418MB/s), 399MiB/s-399MiB/s (418MB/s-418MB/s), io=3990MiB (4184MB), run=10001-10001msec
> > > > ext4/loop/ext4:
> > > >    READ: bw=223MiB/s (234MB/s), 223MiB/s-223MiB/s (234MB/s-234MB/s), io=2232MiB (2341MB), run=10002-10002msec
> > > >   WRITE: bw=223MiB/s (234MB/s), 223MiB/s-223MiB/s (234MB/s-234MB/s), io=2231MiB (2339MB), run=10002-10002msec
> > > > xfs/loop/xfs:
> > > >    READ: bw=220MiB/s (230MB/s), 220MiB/s-220MiB/s (230MB/s-230MB/s), io=2196MiB (2303MB), run=10001-10001msec
> > > >   WRITE: bw=219MiB/s (230MB/s), 219MiB/s-219MiB/s (230MB/s-230MB/s), io=2193MiB (2300MB), run=10001-10001msec
> > > > ext4/dm-loop/ext4:
> > > >    READ: bw=338MiB/s (355MB/s), 338MiB/s-338MiB/s (355MB/s-355MB/s), io=3383MiB (3547MB), run=10002-10002msec
> > > >   WRITE: bw=338MiB/s (355MB/s), 338MiB/s-338MiB/s (355MB/s-355MB/s), io=3385MiB (3549MB), run=10002-10002msec
> > > > xfs/dm-loop/xfs:
> > > >    READ: bw=375MiB/s (393MB/s), 375MiB/s-375MiB/s (393MB/s-393MB/s), io=3752MiB (3934MB), run=10002-10002msec
> > > >   WRITE: bw=376MiB/s (394MB/s), 376MiB/s-376MiB/s (394MB/s-394MB/s), io=3756MiB (3938MB), run=10002-10002msec
> > > > 
> > > > asynchronous I/O:
> > > > fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=libaio --iodepth=16 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
> > > > raw block device:
> > > >    READ: bw=1246MiB/s (1306MB/s), 1246MiB/s-1246MiB/s (1306MB/s-1306MB/s), io=12.2GiB (13.1GB), run=10001-10001msec
> > > >   WRITE: bw=1247MiB/s (1308MB/s), 1247MiB/s-1247MiB/s (1308MB/s-1308MB/s), io=12.2GiB (13.1GB), run=10001-10001msec
> > > > ext4/loop/ext4:
> > > >    READ: bw=274MiB/s (288MB/s), 274MiB/s-274MiB/s (288MB/s-288MB/s), io=2743MiB (2877MB), run=10001-10001msec
> > > >   WRITE: bw=275MiB/s (288MB/s), 275MiB/s-275MiB/s (288MB/s-288MB/s), io=2747MiB (2880MB), run=10001-10001msec
> > > > xfs/loop/xfs:
> > > >    READ: bw=276MiB/s (289MB/s), 276MiB/s-276MiB/s (289MB/s-289MB/s), io=2761MiB (2896MB), run=10002-10002msec
> > > >   WRITE: bw=276MiB/s (290MB/s), 276MiB/s-276MiB/s (290MB/s-290MB/s), io=2765MiB (2899MB), run=10002-10002msec
> > > > ext4/dm-loop/ext4:
> > > >    READ: bw=1189MiB/s (1247MB/s), 1189MiB/s-1189MiB/s (1247MB/s-1247MB/s), io=11.6GiB (12.5GB), run=10002-10002msec
> > > >   WRITE: bw=1190MiB/s (1248MB/s), 1190MiB/s-1190MiB/s (1248MB/s-1248MB/s), io=11.6GiB (12.5GB), run=10002-10002msec
> > > > xfs/dm-loop/xfs:
> > > >    READ: bw=1209MiB/s (1268MB/s), 1209MiB/s-1209MiB/s (1268MB/s-1268MB/s), io=11.8GiB (12.7GB), run=10001-10001msec
> > > >   WRITE: bw=1210MiB/s (1269MB/s), 1210MiB/s-1210MiB/s (1269MB/s-1269MB/s), io=11.8GiB (12.7GB), run=10001-10001msec
> > > 
> > > Hi Mikulas,
> > > 
> > > Please try the following patchset:
> > > 
> > > https://lore.kernel.org/linux-block/20250308162312.1640828-1-ming.lei@redhat.com/
> > > 
> > > which tries to handle IO in current context directly via NOWAIT, and
> > > supports MQ for loop since 12 io jobs are applied in your test. With this
> > > change, I can observe similar perf data on raw block device and loop/xfs
> > > over mq-virtio-scsi & nvme in my test VM.
> 
> I'm not sure RWF_NOWAIT is a workable solution.
> 
> Why?

It is just the sane implementation of Mikulas's static mapping
approach: no need to move to workqueue if the mapping is immutable
or sort of.

Also it matches with io_uring's FS read/write implementation:

- try to submit IO with NOWAIT first

- then fallback to io-wq in case of -EAGAIN

It isn't perfect, sometime it may be slower than running on io-wq
directly.

But is there any better way for covering everything?

I guess no, because FS can't tell us when the IO can be submitted
successfully via NOWAIT, and we can't know if it may succeed without
trying. And basically that is what the interface is designed.

> 
> IO submission is queued to a different thread context because to
> avoid a potential deadlock. That is, we are operating here in the
> writeback context of another filesystem, and so we cannot do things
> like depend on memory allocation making forwards progress for IO
> submission.  RWF_NOWAIT is not a guarantee that memory allocation
> will not occur in the IO submission path - it is implemented as best
> effort non-blocking behaviour.

Yes, that is why BLK_MQ_F_BLOCKING is added.

> 
> Further, if we have stacked loop devices (e.g.
> xfs-loop-ext4-loop-btrfs-loop-xfs) we can will be stacking
> RWF_NOWAIT IO submission contexts through multiple filesystems. This
> is not a filesystem IO path I want to support - being in the middle
> of such a stack creates all sorts of subtle constraints on behaviour
> that otherwise wouldn't exist. We actually do this sort of multi-fs
> stacking in fstests, so it's not a made up scenario.
> 
> I'm also concerned that RWF_NOWAIT submission is not an optimisation
> at all for the common sparse/COW image file case, because in this
> case RWF_NOWAIT failing with EAGAIN is just as common (if not
> moreso) than it succeeding.
> 
> i.e. in this case, RWF_NOWAIT writes will fail with -EAGAIN very
> frequently, so all that time spent doing IO submission is wasted
> time.

Right.

I saw that when I wrote ublk/zoned in which every write needs to
allocate space. It is workaround by preallocating space for one fixed
range or the whole zone.

> 
> Further, because allocation on write requires an exclusive lock and
> it is held for some time, this will affect read performance from the
> backing device as well. i.e. block mapping during a read while a
> write is doing allocation will also return EAGAIN for RWF_NOWAIT.

But that can't be avoided without using NOWAIT, and read is blocked
when write(WAIT) is in-progress.

> This will push the read off to the background worker thread to be
> serviced and so that will go much slower than a RWF_NOWAIT read that
> hits the backing file between writes doing allocation. i.e. read
> latency is going to become much, much more variable.
> 
> Hence I suspect RWF_NOWAIT is simply hiding the underlying issue
> by providing this benchmark with a "pure overwrite" fast path that
> avoids the overhead of queueing work through loop_queue_work()....
> 
> Can you run these same loop dev tests using a sparse image file and
> a sparse fio test file so that the fio benchmark measures the impact
> of loop device block allocation on the test? I suspect the results
> with the RWF_NOWAIT patch will be somewhat different to the fully
> allocated case...

Yes, it will be slower, and io_uring FS IO application is in
the same situation, and usually application doesn't have such
knowledge if RWF_NOWAIT can succeed.

However, usually meta IO is much less compared with normal IO, so most
times it will be a win to try NOWAIT first.

> 
> > 
> > Yes - with these patches, it is much better.
> > 
> > > 1) try single queue first by `modprobe loop`
> > 
> > fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=psync --iodepth=1 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
> > xfs/loop/xfs
> >    READ: bw=302MiB/s (317MB/s), 302MiB/s-302MiB/s (317MB/s-317MB/s), io=3024MiB (3170MB), run=10001-10001msec
> >   WRITE: bw=303MiB/s (317MB/s), 303MiB/s-303MiB/s (317MB/s-317MB/s), io=3026MiB (3173MB), run=10001-10001msec
> > 
> > fio --direct=1 --bs=4k --runtime=10 --time_based --numjobs=12 --ioengine=libaio --iodepth=16 --group_reporting=1 --filename=/mnt/test2/l -name=job --rw=rw
> > xfs/loop/xfs
> >    READ: bw=1055MiB/s (1106MB/s), 1055MiB/s-1055MiB/s (1106MB/s-1106MB/s), io=10.3GiB (11.1GB), run=10001-10001msec
> >   WRITE: bw=1056MiB/s (1107MB/s), 1056MiB/s-1056MiB/s (1107MB/s-1107MB/s), io=10.3GiB (11.1GB), run=10001-10001msec
> 
> Yup, this sort of difference in performance simply from bypassing
> loop_queue_work() implies the problem is the single threaded loop
> device queue implementation needs to be fixed.
> 
> loop_queue_work()
> {
> 	....
> 	spin_lock_irq(&lo->lo_work_lock);
> 	....
> 
>         } else {
>                 work = &lo->rootcg_work;
>                 cmd_list = &lo->rootcg_cmd_list;
>         }
> 	list_add_tail(&cmd->list_entry, cmd_list);
> 	queue_work(lo->workqueue, work);
> 	spin_unlock_irq(&lo->lo_work_lock);
> }
> 
> Not only does every IO that is queued takes this queue lock, there
> is only one work instance for the loop device. Therefore there is
> only one kworker process per control group that does IO submission
> for the loop device. And that kworker thread also takes the work
> lock to do dequeue as well.
> 
> That serialised queue with a single IO dispatcher thread looks to be
> the performance bottleneck to me. We could get rid of the lock by
> using a llist for this multi-producer/single consumer cmd list
> pattern, though I suspect we can get rid of the list entirely...
> 
> i.e. we have a work queue that can run a
> thousand concurrent works for this loop device, but the request
> queue is depth limited to 128 requests. hence we can have a full
> set of requests in flight and not run out of submission worker
> concurrency. There's no need to isolate IO from different cgroups in
> this situation - they will not get blocked behind IO submission
> from a different cgroup that is throttled...
> 
> i.e. the cmd->list_entry list_head could be replaced with a struct
> work_struct and that whole cmd list management and cgroup scheduling
> thing could be replaced with a single call to
> queue_work(cmd->io_work). i.e. the single point that all IO

Then there will be many FS write contention, :-)

> submission is directed through goes away completely.

It has been shown many times that AIO submitted from single or much less
contexts is much more efficient than running IO concurrently from multiple
contexts, especially for sequential IO.

Please see the recent example of zloop vs. ublk/zoned:

https://lore.kernel.org/linux-block/d5e59531-c19b-4332-8f47-b380ab9678be@kernel.org/

When zloop takes single dispatcher just like the in-tree loop, sequential
WRITE performs much better than initial version of ublk/zoned, which just
handles every IO in its own io-wq(one time NOWAIT & -EAGAIN and one time fallback
to io-wq). I tried to submit FS WRITE via io-wq directly and it becomes what
your suggested, the improvement is small, and still much worse than zloop's
single dispatcher.

Later, when I switch to pre-allocate space for each zone or one fixed range,
each write is submitted with NOWAIT successfully, then the sequential write perf
is improved much:

https://lore.kernel.org/linux-block/Z6QrceGGAJl_X_BM@fedora/



Thanks,
Ming


