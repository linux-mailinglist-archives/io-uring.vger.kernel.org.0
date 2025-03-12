Return-Path: <io-uring+bounces-7057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C743FA5D81A
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 09:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F50B3A7793
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 08:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D01823497B;
	Wed, 12 Mar 2025 08:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBaL9Qjs"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8C233D88
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 08:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741768039; cv=none; b=cvrB1jXlFCTYU4rCJwaSlpTHAiVg4BJjLFvIG8LF1RwHoSfqcsXGf2I7bcJ5DEvRTf5uObD2ZaBWdMzBB4yIeY661fsNeNUKGfVm4FONrY9o+I4qPZi4w6Xi2/stEsE1jeqNeCHKWpGggJFP/UIvmm+mK64J9NX4PHhYvIk3Ffc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741768039; c=relaxed/simple;
	bh=zw2wGQmz03Md5Lv7OzYJ/P/jzCLj4lxZQxrvBj8F0M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=flYUuk8vPO7HqwsWdaGRabd5044ni3zXDlIhlnUO/S5CursjnetkS0Z6SKAKqB3FrdnhxaPeDvn7IymBRzDc/Q9YbH7w83ouYcf3DY0UCNX0ubYfkIl90raoyLkzrzXknMj+feie7gVWdn5NbqXno8N6YYlpl/kXSWTAOuwE8jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBaL9Qjs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741768035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KqTvaX8T6vB9ESEAfjJr4ewnIk75G+0nTeiYMNPgZEc=;
	b=eBaL9Qjsjv3McR45eugqEw2byM3r2q6x1VfUEcPn7cfFjtRewFGc1fgVCHohhcmLswTt+E
	XzsM3b4YZrwQGwGsw9ZBtSMAjsnDGrbKXpFaz1GyToV8MAA2cN0wIfCmHN+nyVMf2+8jUV
	UquJYAhOVfAObuXreg/sZP7UCywPugw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-574-4laHxiP0NU20FwKAgUJMMw-1; Wed,
 12 Mar 2025 04:27:11 -0400
X-MC-Unique: 4laHxiP0NU20FwKAgUJMMw-1
X-Mimecast-MFC-AGG-ID: 4laHxiP0NU20FwKAgUJMMw_1741768029
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49FD01956048;
	Wed, 12 Mar 2025 08:27:09 +0000 (UTC)
Received: from fedora (unknown [10.72.120.37])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 899621800945;
	Wed, 12 Mar 2025 08:27:00 +0000 (UTC)
Date: Wed, 12 Mar 2025 16:26:54 +0800
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
Message-ID: <Z9FFTiuMC8WD6qMH@fedora>
References: <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
 <Z8Zh5T9ZtPOQlDzX@dread.disaster.area>
 <1fde6ab6-bfba-3dc4-d7fb-67074036deb0@redhat.com>
 <Z8eURG4AMbhornMf@dread.disaster.area>
 <81b037c8-8fea-2d4c-0baf-d9aa18835063@redhat.com>
 <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Vm1n1dgSJ9DBvycV"
Content-Disposition: inline
In-Reply-To: <Z9DymjGRW3mTPJTt@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


--Vm1n1dgSJ9DBvycV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2025 at 01:34:02PM +1100, Dave Chinner wrote:
> On Tue, Mar 11, 2025 at 06:43:22PM +0800, Ming Lei wrote:
> > On Tue, Mar 11, 2025 at 12:27:23PM +1100, Dave Chinner wrote:
> > > On Mon, Mar 10, 2025 at 12:18:51PM +0100, Mikulas Patocka wrote:
> > > > On Sun, 9 Mar 2025, Ming Lei wrote:
> > > > > Please try the following patchset:
> > > > > 
> > > > > https://lore.kernel.org/linux-block/20250308162312.1640828-1-ming.lei@redhat.com/
> > > > > 
> > > > > which tries to handle IO in current context directly via NOWAIT, and
> > > > > supports MQ for loop since 12 io jobs are applied in your test. With this
> > > > > change, I can observe similar perf data on raw block device and loop/xfs
> > > > > over mq-virtio-scsi & nvme in my test VM.
> > > 
> > > I'm not sure RWF_NOWAIT is a workable solution.
> > > 
> > > Why?
> > 
> > It is just the sane implementation of Mikulas's static mapping
> > approach: no need to move to workqueue if the mapping is immutable
> > or sort of.
> > 
> > Also it matches with io_uring's FS read/write implementation:
> >
> > - try to submit IO with NOWAIT first
> > - then fallback to io-wq in case of -EAGAIN
> 
> No, it doesn't match what io_uring does. yes, the NOWAIT bit does,
> but the work queue implementation is in the loop device is
> completely different to the way io_uring dispatches work.
> 
> That is, io_uring dispatches one IO per wroker thread context so
> they can all run in parallel down through the filesystem. The loop
> device has a single worker thread so it -serialises- IO submission
> to the filesystem.
> 
> i.e. blocking a single IO submission in the loop worker blocks all
> IO submission, whereas io_uring submits all IO indepedently so they
> only block if serialisation occurs further down the stack.

block layer/storage has many optimization for batching handling, if IOs
are submitted from many contexts:

- this batch handling optimization is gone

- IO is re-ordered from underlying hardware viewpoint

- more contention from FS write lock, because loop has single back file.

That is why the single task context is taken from the beginning of loop aio,
and it performs pretty well for sequential IO workloads, as I shown
in the zloop example.

> 
> > It isn't perfect, sometime it may be slower than running on io-wq
> > directly.
> > 
> > But is there any better way for covering everything?
> 
> Yes - fix the loop queue workers.

What you suggested is threaded aio by submitting IO concurrently from
different task context, this way is not the most efficient one, otherwise
modern language won't invent async/.await.

In my test VM, by running Mikulas's fio script on loop/nvme by the attached
threaded_aio patch:

NOWAIT with MQ 4		:   70K iops(read), 70K iops(write), cpu util: 40%
threaded_aio with MQ 4	:	64k iops(read), 64K iops(write), cpu util: 52% 
in tree loop(SQ)		:   58K	iops(read), 58K iops(write)	

Mikulas, please feel free to run your tests with threaded_aio:

	modprobe loop nr_hw_queues=4 threaded_aio=1

by applying the attached the patch over the loop patchset.

The performance gap could be more obvious in fast hardware.

> 
> > I guess no, because FS can't tell us when the IO can be submitted
> > successfully via NOWAIT, and we can't know if it may succeed without
> > trying. And basically that is what the interface is designed.
> 
> Wrong.
> 
> Speculative non-blocking IO like NOWAIT is the wrong optimisation to
> make for workloads that are very likely to block in the IO path. It
> just adds overhead without adding any improvement in performance.

Mikulas's ->bmap() implies that there isn't block in IO path too.

And many io_uring application shouldn't have idea if the IO will block too,
but they still use NOWAIT...

> 
> Getting rid of the serialised IO submission problems that the loop
> device current has will benefit *all* workloads that use the loop
> device, not just those that are fully allocated. Yes, it won't quite
> show the same performance as NOWAIT in that case, but it still
> should give 90-95% of native performance for the static file case.
> And it should also improve all the other cases, too, because now
> they will only serialise when the backing file needs IO operations to
> serialise (i.e. during allocation).

The above test shows that concurrent submission isn't better than NOWAIT,
and my ublk/zoned examples showed the point too.

> 
> > > IO submission is queued to a different thread context because to
> > > avoid a potential deadlock. That is, we are operating here in the
> > > writeback context of another filesystem, and so we cannot do things
> > > like depend on memory allocation making forwards progress for IO
> > > submission.  RWF_NOWAIT is not a guarantee that memory allocation
> > > will not occur in the IO submission path - it is implemented as best
> > > effort non-blocking behaviour.
> > 
> > Yes, that is why BLK_MQ_F_BLOCKING is added.
> > 
> > > 
> > > Further, if we have stacked loop devices (e.g.
> > > xfs-loop-ext4-loop-btrfs-loop-xfs) we can will be stacking
> > > RWF_NOWAIT IO submission contexts through multiple filesystems. This
> > > is not a filesystem IO path I want to support - being in the middle
> > > of such a stack creates all sorts of subtle constraints on behaviour
> > > that otherwise wouldn't exist. We actually do this sort of multi-fs
> > > stacking in fstests, so it's not a made up scenario.
> > > 
> > > I'm also concerned that RWF_NOWAIT submission is not an optimisation
> > > at all for the common sparse/COW image file case, because in this
> > > case RWF_NOWAIT failing with EAGAIN is just as common (if not
> > > moreso) than it succeeding.
> > > 
> > > i.e. in this case, RWF_NOWAIT writes will fail with -EAGAIN very
> > > frequently, so all that time spent doing IO submission is wasted
> > > time.
> > 
> > Right.
> > 
> > I saw that when I wrote ublk/zoned in which every write needs to
> > allocate space. It is workaround by preallocating space for one fixed
> > range or the whole zone.
> 
> *cough*
> 
> You do realise that fallocate() serialises all IO on the file? i.e.
> not only does it block all IO submission, mmap IO and other metadata
> operations, it also waits for all IO in flight to complete and it
> doesn't allow any IO to restart until the preallocation is complete.
> 

It isn't one issue for zloop & ublk/zoned, each zone is emulated by one
single file, and the zone is usual the parallelism unit.

> i.e. preallocation creates a huge IO submission latency bubble in
> the IO path. Hence preallocation is something that should be avoided
> at runtime if at all possible.
> 
> If you have problems with allocation overhead during IO, then we
> have things like extent size hints that allow the per-IO allocation
> to be made much larger than the IO itself. This effectively does
> preallocation during IO without the IO pipeline bubbles that
> preallocation requires to function correctly....

OK, I will try it later in ublk/zoned and see if the pre-allocation can
be replaced by extent size hints, is it available for all popular FS?

> 
> > > Further, because allocation on write requires an exclusive lock and
> > > it is held for some time, this will affect read performance from the
> > > backing device as well. i.e. block mapping during a read while a
> > > write is doing allocation will also return EAGAIN for RWF_NOWAIT.
> > 
> > But that can't be avoided without using NOWAIT, and read is blocked
> > when write(WAIT) is in-progress.
> 
> If the loop worker dispatches each IO in it's own task context, then
> we don't care if a read IO blocks on some other write in progress.
> It doesn't get in the way of any other IO submission...
> 
> > > This will push the read off to the background worker thread to be
> > > serviced and so that will go much slower than a RWF_NOWAIT read that
> > > hits the backing file between writes doing allocation. i.e. read
> > > latency is going to become much, much more variable.
> > > 
> > > Hence I suspect RWF_NOWAIT is simply hiding the underlying issue
> > > by providing this benchmark with a "pure overwrite" fast path that
> > > avoids the overhead of queueing work through loop_queue_work()....
> > > 
> > > Can you run these same loop dev tests using a sparse image file and
> > > a sparse fio test file so that the fio benchmark measures the impact
> > > of loop device block allocation on the test? I suspect the results
> > > with the RWF_NOWAIT patch will be somewhat different to the fully
> > > allocated case...
> > 
> > Yes, it will be slower, and io_uring FS IO application is in
> > the same situation, and usually application doesn't have such
> > knowledge if RWF_NOWAIT can succeed.
> 
> And that's my point: nothing above the filesystem will have - or
> can have - any knowledge of whether NOWAIT IO will succeed or
> not.
> 
> Therefore we have to use our brains to analyse what the typical
> behaviour of the filesystem will be for a given situation to
> determine how best to optimise IO submission.

Indeed, I think FS typical behaviour for loop case is valuable for
optimizing loop driver, but care to provide more details if you have?

> 
> > However, usually meta IO is much less compared with normal IO, so most
> > times it will be a win to try NOWAIT first.
> 
> Data vs metadata from the upper filesystem doesn't even enter into
> the equation here.
> 
> Filesystems like XFS, bcachefs and btrfs all dynamically create,
> move and remove metadata, so metadata writes are as much of an
> allocation problem for sparse loop backing files as write-once user
> data IO is.

For typical loop workloads, I still see much less metadata io, and that
is why improvement from NOWAIT is big in Mikulas's test.


Thanks,
Ming

--Vm1n1dgSJ9DBvycV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-loop-debug-add-threaded-aio.patch"

From b3c78b04ac6b80e171271a833c0221b8ab3b2b00 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 12 Mar 2025 07:33:55 +0000
Subject: [PATCH] loop: debug: add threaded aio

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 47 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 393f38573169..113e29b3ac80 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -86,6 +86,8 @@ struct loop_cmd {
 	struct bio_vec *bvec;
 	struct cgroup_subsys_state *blkcg_css;
 	struct cgroup_subsys_state *memcg_css;
+
+	struct work_struct work;
 };
 
 #define LOOP_IDLE_WORKER_TIMEOUT (60 * HZ)
@@ -98,6 +100,8 @@ static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_ctl_mutex);
 static DEFINE_MUTEX(loop_validate_mutex);
 
+static unsigned int threaded_aio = 0;
+
 /**
  * loop_global_lock_killable() - take locks for safe loop_validate_file() test
  *
@@ -508,10 +512,17 @@ static int lo_rw_aio_prep(struct loop_device *lo, struct loop_cmd *cmd,
 static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd, loff_t pos)
 {
 	unsigned int nr_bvec = lo_cmd_nr_bvec(cmd);
-	int ret;
+	int ret = 0;
+
+	if (threaded_aio) {
+		ret = lo_rw_aio_prep(lo, cmd, nr_bvec);
+		if (ret < 0)
+			goto exit;
+	}
 
 	cmd->iocb.ki_flags &= ~IOCB_NOWAIT;
 	ret = lo_submit_rw_aio(lo, cmd, pos, nr_bvec);
+exit:
 	if (ret != -EIOCBQUEUED)
 		lo_rw_aio_complete(&cmd->iocb, ret);
 	return 0;
@@ -1941,10 +1952,39 @@ static const struct kernel_param_ops loop_nr_hw_q_param_ops = {
 device_param_cb(nr_hw_queues, &loop_nr_hw_q_param_ops, &nr_hw_queues, 0444);
 MODULE_PARM_DESC(nr_hw_queues, "number of hardware queues. Default: " __stringify(LOOP_DEFAULT_NR_HW_Q));
 
+module_param(threaded_aio, uint, 0644);
+MODULE_PARM_DESC(threaded_aio, "threaded aio");
+
 MODULE_DESCRIPTION("Loopback device support");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
+static void loop_aio_workfn(struct work_struct *work)
+{
+	struct loop_cmd *cmd = container_of(work, struct loop_cmd, work);
+	struct request *rq = blk_mq_rq_from_pdu(cmd);
+	struct loop_device *lo = rq->q->queuedata;
+	int ret = do_req_filebacked(lo, rq);
+
+	if (!cmd->use_aio || ret) {
+		if (ret == -EOPNOTSUPP)
+			cmd->ret = ret;
+		else
+			cmd->ret = ret ? -EIO : 0;
+		if (likely(!blk_should_fake_timeout(rq->q)))
+			blk_mq_complete_request(rq);
+	}
+}
+
+static void loop_queue_rq_threaded_aio(struct loop_cmd *cmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(cmd);
+	struct loop_device *lo = rq->q->queuedata;
+
+	INIT_WORK(&cmd->work, loop_aio_workfn);
+	queue_work(lo->workqueue, &cmd->work);
+}
+
 static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
@@ -1968,6 +2008,11 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	}
 
+	if (threaded_aio) {
+		loop_queue_rq_threaded_aio(cmd);
+		return BLK_STS_OK;
+	}
+
 	if (cmd->use_aio) {
 		loff_t pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 		int ret = lo_rw_aio_nowait(lo, cmd, pos);
-- 
2.47.1


--Vm1n1dgSJ9DBvycV--


