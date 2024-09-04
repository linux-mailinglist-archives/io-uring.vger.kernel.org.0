Return-Path: <io-uring+bounces-3040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C608C96CA65
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 00:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D51128C072
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 22:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E02B189901;
	Wed,  4 Sep 2024 22:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="UaRFcODn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EsyiMuz+"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh6-smtp.messagingengine.com (fhigh6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2461865FA;
	Wed,  4 Sep 2024 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725488700; cv=none; b=hKPksX4IMorbTTOms3vOC2uNvejADDc+Mx3pGXF5BY2FQ0eSrHmuvaDIt9+KrKyJ2ehG1YbP9cArVP8RlgUrdax8amG5Nc2g9L8/rijqxtqrsIjIRv4HRc41Oyd3WS7TW+kAKvHsrg951pU51qU3CYvTKj3ZA2iG8YjMx7pEIbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725488700; c=relaxed/simple;
	bh=CQezxYZ1koJ0gnNOovo6xIbTDPLyXS+N3jnKJ68zyYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFvIMsOzU71bXrp2Sb51/bSmpp4+yXjzf+k37o5LKwp5pq6YEb3afoGQe4wfj+PmHvf2J7OUbNQ6dCKYwF+0rtVWdw6jUGID9rr70fkxOyWCsJNd8dfesmjTs0VW+0SpgRkiGqKDadgUZldtraLgzph7bx2JPLlL+mXLNx/qm68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=UaRFcODn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EsyiMuz+; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6004911401D2;
	Wed,  4 Sep 2024 18:24:56 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 04 Sep 2024 18:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725488696;
	 x=1725575096; bh=98aKl3jVVzRlEJIYX3Pmf73SHG1lhetxrgMCwPoOEjc=; b=
	UaRFcODnGsW0bpxZ0FJvNpPBXlld/7u+u95A8UvvwL/HApIuKk9UzlOUtCLVBZjv
	cNOWNP6frnM7Uc1EUAlXzBPb5oojpYRZ34LQBp6cRv/34klojF5Yfi611UYqvh2H
	yKGwwOMKvs1uPmssaEBr5DTNshGXM3wHHYfU9KECtPTcXQg9yAYnlHgjgM81nPED
	qlKWtoScKJjgm9h0q2Ecv/5mtlz9nOKQZ+Kj4BPeg2hGJ+Rs+b62OmhjhJmFvct9
	8BAFIxKDtAm9RjhGBxPJBk1cKkdrapfiQkxFbLa3T6gzLREAV1JwVcTivYAX7aVj
	2rDMIA48U9LZkqB1EcPAvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725488696; x=
	1725575096; bh=98aKl3jVVzRlEJIYX3Pmf73SHG1lhetxrgMCwPoOEjc=; b=E
	syiMuz+Y6HCo73TKz/gw8bsNTbQlJLwPbInh+lq9mMKk8OyFWdztB2cHMfaP9rGc
	etg7fnAfI/ku8YUztCP0tKi81aAfn/UTiuNTzgRFRHNdhTjBuuTBvAkBwB/O5Ulv
	mEJMxGiPObh9klO5lKgpsj2+rWKiDP1AlwgvF4mynbnFv9JFQxzqsLLRHgJtAug9
	bYIcMIkuMeCJx6/5173vf9cGnEv6bQo4H5tNAeocwL9KJUphXT2El7sPxujJEDof
	AH8AtO8LaRF3WQUGAAbvXJs3o+JQ9fnmpP0ecqf1Psj9q6cfY+Gdti5iqNgxDghA
	fL1ONkxpUx5LxTo7iF49Q==
X-ME-Sender: <xms:N97YZvY_HO10sr8REQzT_pMAtvOg9z9lb0iUSSNXyKMlw-kosICf7Q>
    <xme:N97YZuZbPOly62KiPRr-Egn-QyXtOq_h3OXPIUyFujDeCwmUEowU25aCJhBG6zkS_
    svwYI8b8vPKPDTA>
X-ME-Received: <xmr:N97YZh8drKzOHKZCaa5iQllx43-Cc2Al-lnBLp0rVlXK9C9r6S1NLjRW-vM4V0TG3ylBam3eW8DvbsIzA4pwHKpXNUkPWZki6NSggDCVIvbjcB1pEkH8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepuedtkeeileeghedu
    kefghfdtuddvudfgheeljeejgeelueffueekheefheffveelnecuffhomhgrihhnpehgih
    hthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrihhlrdhfmhdpnhgspg
    hrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehjohgrnhhn
    vghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopegsshgthhhusggvrhhtse
    guughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgt
    phhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsih
    hlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsggvrhhnugesfhgrshhtmhgr
    ihhlrdhfmhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:N97YZlqs6SboTyGhu4T46tmGR_nJ9pz2BF9LyGfxxLYA_MXfWMh37g>
    <xmx:N97YZqoCk63nc6peuErGZ1jS5zuvaL6brIr6rR6ZTbFS7F-59raHLw>
    <xmx:N97YZrR6m11bwWse_SXS6fmhWKMHQMeAKq_8MKAQhOTpYa-qqCWR9g>
    <xmx:N97YZiqI_jP3kUF4Z5f6Thx81JCvIUnr7u_pUHsXDz_-TsOAqvZTrw>
    <xmx:ON7YZniTx73RSIupXQ7sJ2hgBKHEn0AgfGMPtTF21rGl1AQRWdEvRUal>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Sep 2024 18:24:54 -0400 (EDT)
Message-ID: <4a0ac578-48fd-4c46-88c1-713f1720e771@fastmail.fm>
Date: Thu, 5 Sep 2024 00:24:53 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 05/17] fuse: Add a uring config ioctl
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-5-9207f7391444@ddn.com>
 <CAJnrk1am+s=z2iDcdQ9vXrTvo3wAXH9UE57BpXAovOqdNdYKHg@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1am+s=z2iDcdQ9vXrTvo3wAXH9UE57BpXAovOqdNdYKHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/4/24 02:43, Joanne Koong wrote:
> On Sun, Sep 1, 2024 at 6:37 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> This only adds the initial ioctl for basic fuse-uring initialization.
>> More ioctl types will be added later to initialize queues.
>>
>> This also adds data structures needed or initialized by the ioctl
>> command and that will be used later.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> 
> Exciting to read through the work in this patchset!
> 
> I left some comments, lots of which are more granular / implementation
> details than high-level design, in case that would be helpful to you
> in reducing the turnaround time for this patchset. Let me know if
> you'd prefer a hold-off on that though, if your intention with the RFC
> is more to get high-level feedback.

Thanks Joanne! I'm going to address your comments later this week.
> 
> 
> Thanks,
> Joanne
> 
>> ---
>>  fs/fuse/Kconfig           |  12 ++++
>>  fs/fuse/Makefile          |   1 +
>>  fs/fuse/dev.c             |  33 ++++++++---
>>  fs/fuse/dev_uring.c       | 141 ++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/fuse/dev_uring_i.h     | 113 +++++++++++++++++++++++++++++++++++++
>>  fs/fuse/fuse_dev_i.h      |   1 +
>>  fs/fuse/fuse_i.h          |   5 ++
>>  fs/fuse/inode.c           |   3 +
>>  include/uapi/linux/fuse.h |  47 ++++++++++++++++
>>  9 files changed, 349 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
>> index 8674dbfbe59d..11f37cefc94b 100644
>> --- a/fs/fuse/Kconfig
>> +++ b/fs/fuse/Kconfig
>> @@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
>>           to be performed directly on a backing file.
>>
>>           If you want to allow passthrough operations, answer Y.
>> +
>> +config FUSE_IO_URING
>> +       bool "FUSE communication over io-uring"
>> +       default y
>> +       depends on FUSE_FS
>> +       depends on IO_URING
>> +       help
>> +         This allows sending FUSE requests over the IO uring interface and
>> +          also adds request core affinity.
> 
> nit: this wording is a little bit awkward imo. Maybe something like
> "... over the IO uring interface and enables core affinity for each
> request" or "... over the IO uring interface and pins each request to
> a specific core"?
> I think there's an extra whitespace here in front of "also".
> 
>> +
>> +         If you want to allow fuse server/client communication through io-uring,
>> +         answer Y
> 
> super nit: missing a period at the end of Y.
> 
>> diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
>> index 6e0228c6d0cb..7193a14374fd 100644
>> --- a/fs/fuse/Makefile
>> +++ b/fs/fuse/Makefile
>> @@ -11,5 +11,6 @@ fuse-y := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o
>>  fuse-y += iomode.o
>>  fuse-$(CONFIG_FUSE_DAX) += dax.o
>>  fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
>> +fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
>>
>>  virtiofs-y := virtio_fs.o
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index dbc222f9b0f0..6489179e7260 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -8,6 +8,7 @@
>>
>>  #include "fuse_i.h"
>>  #include "fuse_dev_i.h"
>> +#include "dev_uring_i.h"
>>
>>  #include <linux/init.h>
>>  #include <linux/module.h>
>> @@ -26,6 +27,13 @@
>>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>>  MODULE_ALIAS("devname:fuse");
>>
>> +#ifdef CONFIG_FUSE_IO_URING
>> +static bool __read_mostly enable_uring;
> 
> I don't see where enable_uring gets used in this patchset, are you
> planning to use this in a separate future patchset?

Ouch, thanks, I broke it from the previous patch, when I refactored ioctls. As I wrote in the introduction, this patch set is not completely tested - had missed it. Thanks again for spotting.

> 
>> +module_param(enable_uring, bool, 0644);
>> +MODULE_PARM_DESC(enable_uring,
>> +                "Enable uring userspace communication through uring.");
>                                      ^^^ extra "uring" here?
> 
>> +#endif
>> +
>>  static struct kmem_cache *fuse_req_cachep;
>>
>>  static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
>> @@ -2298,16 +2306,12 @@ static int fuse_device_clone(struct fuse_conn *fc, struct file *new)
>>         return 0;
>>  }
>>
>> -static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
>> +static long _fuse_dev_ioctl_clone(struct file *file, int oldfd)
> 
> I think it'd be a bit clearer if this change was moved to patch 06/17
> "Add the queue configuration ioctl" where it gets used

Oh, yeah, accidentally in here.

> 
>>  {
>>         int res;
>> -       int oldfd;
>>         struct fuse_dev *fud = NULL;
>>         struct fd f;
>>
>> -       if (get_user(oldfd, argp))
>> -               return -EFAULT;
>> -
>>         f = fdget(oldfd);
>>         if (!f.file)
>>                 return -EINVAL;
>> @@ -2330,6 +2334,16 @@ static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
>>         return res;
>>  }
>>
>> +static long fuse_dev_ioctl_clone(struct file *file, __u32 __user *argp)
>> +{
>> +       int oldfd;
>> +
>> +       if (get_user(oldfd, argp))
>> +               return -EFAULT;
>> +
>> +       return _fuse_dev_ioctl_clone(file, oldfd);
>> +}
>> +
>>  static long fuse_dev_ioctl_backing_open(struct file *file,
>>                                         struct fuse_backing_map __user *argp)
>>  {
>> @@ -2365,8 +2379,9 @@ static long fuse_dev_ioctl_backing_close(struct file *file, __u32 __user *argp)
>>         return fuse_backing_close(fud->fc, backing_id);
>>  }
>>
>> -static long fuse_dev_ioctl(struct file *file, unsigned int cmd,
>> -                          unsigned long arg)
>> +static long
>> +fuse_dev_ioctl(struct file *file, unsigned int cmd,
>> +              unsigned long arg)
> 
> I think you accidentally added this line break here?

Yeah :(

> 
>>  {
>>         void __user *argp = (void __user *)arg;
>>
>> @@ -2380,6 +2395,10 @@ static long fuse_dev_ioctl(struct file *file, unsigned int cmd,
>>         case FUSE_DEV_IOC_BACKING_CLOSE:
>>                 return fuse_dev_ioctl_backing_close(file, argp);
>>
>> +#ifdef CONFIG_FUSE_IO_URING
>> +       case FUSE_DEV_IOC_URING_CFG:
>> +               return fuse_uring_conn_cfg(file, argp);
>> +#endif
>>         default:
>>                 return -ENOTTY;
>>         }
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> new file mode 100644
>> index 000000000000..4e7518ef6527
>> --- /dev/null
>> +++ b/fs/fuse/dev_uring.c
>> @@ -0,0 +1,141 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * FUSE: Filesystem in Userspace
>> + * Copyright (c) 2023-2024 DataDirect Networks.
>> + */
>> +
>> +#include "fuse_dev_i.h"
>> +#include "fuse_i.h"
>> +#include "dev_uring_i.h"
>> +
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/poll.h>
>> +#include <linux/sched/signal.h>
>> +#include <linux/uio.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/pagemap.h>
>> +#include <linux/file.h>
>> +#include <linux/slab.h>
>> +#include <linux/pipe_fs_i.h>
>> +#include <linux/swap.h>
>> +#include <linux/splice.h>
>> +#include <linux/sched.h>
>> +#include <linux/io_uring.h>
>> +#include <linux/mm.h>
>> +#include <linux/io.h>
>> +#include <linux/io_uring.h>
>> +#include <linux/io_uring/cmd.h>
>> +#include <linux/topology.h>
>> +#include <linux/io_uring/cmd.h>
> 
> Are all of these headers (eg miscdevice.h, pipe_fs_i.h, topology.h) needed?

Actually already removed in my local v4 branch. I noticed myself on Monday.

> 
>> +
>> +static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
>> +                                struct fuse_ring *ring)
>> +{
>> +       int tag;
>> +
>> +       queue->qid = qid;
>> +       queue->ring = ring;
>> +
>> +       for (tag = 0; tag < ring->queue_depth; tag++) {
>> +               struct fuse_ring_ent *ent = &queue->ring_ent[tag];
>> +
>> +               ent->queue = queue;
>> +               ent->tag = tag;
>> +       }
>> +}
>> +
>> +static int _fuse_uring_conn_cfg(struct fuse_ring_config *rcfg,
>> +                               struct fuse_conn *fc, struct fuse_ring *ring,
>> +                               size_t queue_sz)
> 
> Should this function just be marked "void" as the return type?

Yeah, I had missed it.

> 
>> +{
>> +       ring->numa_aware = rcfg->numa_aware;
>> +       ring->nr_queues = rcfg->nr_queues;
>> +       ring->per_core_queue = rcfg->nr_queues > 1;
>> +
>> +       ring->max_nr_sync = rcfg->sync_queue_depth;
>> +       ring->max_nr_async = rcfg->async_queue_depth;
>> +       ring->queue_depth = ring->max_nr_sync + ring->max_nr_async;
>> +
>> +       ring->req_buf_sz = rcfg->user_req_buf_sz;
>> +
>> +       ring->queue_size = queue_sz;
>> +
>> +       fc->ring = ring;
>> +       ring->fc = fc;
>> +
>> +       return 0;
>> +}
>> +
>> +static int fuse_uring_cfg_sanity(struct fuse_ring_config *rcfg)
>> +{
>> +       if (rcfg->nr_queues == 0) {
>> +               pr_info("zero number of queues is invalid.\n");
> 
> I think this might get misinterpreted as "zero queues are invalid" -
> maybe something like: "fuse_ring_config nr_queues=0 is invalid arg"
> might be clearer?
> 
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (rcfg->nr_queues > 1 && rcfg->nr_queues != num_present_cpus()) {
> 
> Will it always be that nr_queues must be the number of CPUs on the
> system or will that constraint be relaxed in the future?

In all my testing performance rather suffered when any kind of cpu switching was involved. I guess we should first find a good reason to relax it and then need to think about which queue to use, when a request comes on a different core. Do you have a use case?

> 
>> +               pr_info("nr-queues (%d) does not match nr-cores (%d).\n",
> 
> nit: %u for nr_queues,  s/nr-queues/nr_queues
> It might be useful here to specify "uring nr_queues" as well to make
> it more obvious
> 
>> +                       rcfg->nr_queues, num_present_cpus());
>> +               return -EINVAL;
>> +       }
>> +
> 
> Should this function also sanity check that the queue depth is <=
> FUSE_URING_MAX_QUEUE_DEPTH?

Right.

> 
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Basic ring setup for this connection based on the provided configuration
>> + */
>> +int fuse_uring_conn_cfg(struct file *file, void __user *argp)
> 
> Is there a reason we pass in "void __user *argp" instead of "struct
> fuse_ring_config __user *argp"?

Will fix it.

> 
>> +{
>> +       struct fuse_ring_config rcfg;
>> +       int res;
>> +       struct fuse_dev *fud;
>> +       struct fuse_conn *fc;
>> +       struct fuse_ring *ring = NULL;
>> +       struct fuse_ring_queue *queue;
>> +       int qid;
>> +
>> +       res = copy_from_user(&rcfg, (void *)argp, sizeof(rcfg));
> 
> I don't think we need this "(void *)" cast here
> 
>> +       if (res != 0)
>> +               return -EFAULT;
>> +       res = fuse_uring_cfg_sanity(&rcfg);
>> +       if (res != 0)
>> +               return res;
>> +
>> +       fud = fuse_get_dev(file);
>> +       if (fud == NULL)
> 
> nit: if (!fud)
> 
>> +               return -ENODEV;
> 
> Should this be -ENODEV or -EPERM? -ENODEV makes sense to me but I'm
> seeing other callers of fuse_get_dev() in fuse/dev.c return -EPERM
> when fud is NULL.
> 
>> +       fc = fud->fc;
>> +
> 
> Should we add a check
> if (fc->ring)
>    return -EINVAL (or -EALREADY);
> 
> if not, then i think we need to move the "for (qid = 0; ...)" logic
> below to be within the "if (fc->ring == NULL)" check
> 
>> +       if (fc->ring == NULL) {
> 
> nit: if (!fc->ring)
> 
>> +               size_t queue_depth = rcfg.async_queue_depth +
>> +                                    rcfg.sync_queue_depth;
>> +               size_t queue_sz = sizeof(struct fuse_ring_queue) +
>> +                                 sizeof(struct fuse_ring_ent) * queue_depth;
>> +
>> +               ring = kvzalloc(sizeof(*fc->ring) + queue_sz * rcfg.nr_queues,
>> +                               GFP_KERNEL_ACCOUNT);
>> +               if (ring == NULL)
> 
> nit: if (!ring)
> 
>> +                       return -ENOMEM;
>> +
>> +               spin_lock(&fc->lock);
>> +               if (fc->ring == NULL)
> 
> if (!fc->ring)
> 
>> +                       res = _fuse_uring_conn_cfg(&rcfg, fc, ring, queue_sz);
>> +               else
>> +                       res = -EALREADY;
>> +               spin_unlock(&fc->lock);
>> +               if (res != 0)
> 
> nit: if (res)
> 
>> +                       goto err;
>> +       }
>> +
>> +       for (qid = 0; qid < ring->nr_queues; qid++) {
>> +               queue = fuse_uring_get_queue(ring, qid);
>> +               fuse_uring_queue_cfg(queue, qid, ring);
>> +       }
>> +
>> +       return 0;
>> +err:
>> +       kvfree(ring);
>> +       return res;
>> +}
>> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
>> new file mode 100644
>> index 000000000000..d4eff87bcd1f
>> --- /dev/null
>> +++ b/fs/fuse/dev_uring_i.h
>> @@ -0,0 +1,113 @@
>> +/* SPDX-License-Identifier: GPL-2.0
>> + *
>> + * FUSE: Filesystem in Userspace
>> + * Copyright (c) 2023-2024 DataDirect Networks.
>> + */
>> +
>> +#ifndef _FS_FUSE_DEV_URING_I_H
>> +#define _FS_FUSE_DEV_URING_I_H
>> +
>> +#include "fuse_i.h"
>> +
>> +#ifdef CONFIG_FUSE_IO_URING
>> +
>> +/* IORING_MAX_ENTRIES */
> 
> nit: I'm not sure this comment is that helpful. The
> "FUSE_URING_MAX_QUEUE_DEPTH" name is clear enough, I think.
> 
>> +#define FUSE_URING_MAX_QUEUE_DEPTH 32768
>> +
>> +/* A fuse ring entry, part of the ring queue */
>> +struct fuse_ring_ent {
>> +       /* back pointer */
>> +       struct fuse_ring_queue *queue;
> 
> Do you think it's worth using the tag to find the queue (i think we
> can just use some containerof magic to get the queue backpointer here
> since ring_ent is embedded within struct fuse_ring_queue?) instead of
> having this be an explicit 8 byte pointer? I'm thinking about the case
> where the user sets a queue depth of 32k (eg
> FUSE_URING_MAX_QUEUE_DEPTH) and is on an 8-core system where they set
> nr_queues to 8. This would end up in 8 * 32k * 8 = 2 MiB extra memory
> allocated which seems non-trivial (but I guess this is also an extreme
> case). Curious what your thoughts on this are.
> 
>> +
>> +       /* array index in the ring-queue */
>> +       unsigned int tag;
> 
> Just wondering, is this called "tag" instead of "index" to be
> consistent with an io-ring naming convention?
> 
>> +};
>> +
>> +struct fuse_ring_queue {
>> +       /*
>> +        * back pointer to the main fuse uring structure that holds this
>> +        * queue
>> +        */
>> +       struct fuse_ring *ring;
>> +
>> +       /* queue id, typically also corresponds to the cpu core */
>> +       unsigned int qid;
>> +
>> +       /* size depends on queue depth */
>> +       struct fuse_ring_ent ring_ent[] ____cacheline_aligned_in_smp;
>> +};
>> +
>> +/**
>> + * Describes if uring is for communication and holds alls the data needed
> 
> nit: maybe this should just be "Holds all the data needed for uring
> communication"?
> 
> nit: s/alls/all
> 
>> + * for uring communication
>> + */
>> +struct fuse_ring {
>> +       /* back pointer */
>> +       struct fuse_conn *fc;
>> +
>> +       /* number of ring queues */
> 
> I think it's worth calling out here too that this must be the number
> of CPUs on the system and that each CPU operates its own ring queue.
> 
>> +       size_t nr_queues;
>> +
>> +       /* number of entries per queue */
>> +       size_t queue_depth;
>> +
>> +       /* req_arg_len + sizeof(struct fuse_req) */
> 
> What is req_arg_len? In _fuse_uring_conn_cfg(), it looks like this
> gets set to rcfg->user_req_buf_sz which is passed in from userspace,
> but from what I understand, "struct fuse_req" is a kernel-defined
> struct? I'm a bit confused overall what the comment refers to, but I
> also haven't yet looked through the libfuse change yet for this
> patchset.

Sorry, it is a typo, it is supposed to be 'sizeof(struct fuse_ring_req)'.

> 
>> +       size_t req_buf_sz;
>> +
>> +       /* max number of background requests per queue */
>> +       size_t max_nr_async;
>> +
>> +       /* max number of foreground requests */
> 
> nit: for consistency with the comment for max_nr_async,
> s/requests/"requests per queue"
> 
>> +       size_t max_nr_sync;
> 
> It's interesting to me that this can get configured by userspace for
> background requests vs foreground requests. My perspective was that
> from the userspace POV, there's no differentiation between background
> vs foreground requests. Personally, I'm still not really even sure yet
> which of the read requests are async vs sync when I do a 8 MiB read
> call for example (iirc, I was seeing both, when it first tried the
> readahead path). It seems a bit like overkill to me but maybe there
> are some servers that actually do care a lot about this.

I think I need to rework this a bit. What I actually want is credits. With /dev/fuse bg requests get moved into the main request list and can then block everything. To keep the series small, maybe better if I entirely remove that in v4.

> 
>> +
>> +       /* size of struct fuse_ring_queue + queue-depth * entry-size */
>> +       size_t queue_size;
>> +
>> +       /* one queue per core or a single queue only ? */
>> +       unsigned int per_core_queue : 1;
>> +
>> +       /* numa aware memory allocation */
>> +       unsigned int numa_aware : 1;
>> +
>> +       struct fuse_ring_queue queues[] ____cacheline_aligned_in_smp;
>> +};
>> +
>> +void fuse_uring_abort_end_requests(struct fuse_ring *ring);
> 
> nit: I think it'd be a bit cleaner if this got moved to patch 12/17
> (fuse: {uring} Handle teardown of ring entries) when it gets used
> 
>> +int fuse_uring_conn_cfg(struct file *file, void __user *argp);
>> +
>> +static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
>> +{
>> +       if (fc->ring == NULL)
> 
> nit: if (!fc->ring)

Maybe I find a cocinelle script or write one for such things, 
checkpatch.pl doesn't annotate it.

> 
>> +               return;
>> +
>> +       kvfree(fc->ring);
>> +       fc->ring = NULL;
>> +}
>> +
>> +static inline struct fuse_ring_queue *
>> +fuse_uring_get_queue(struct fuse_ring *ring, int qid)
>> +{
>> +       char *ptr = (char *)ring->queues;
> 
> Do we need to cast this to char * or can we just do the math below as
> return ring->queues + qid;

It is qid * ring->queue_size, as we have the variable length 
array 'struct fuse_ring_ent ring_ent[]'. I'm still looking for a better
name for 'ring->queue_size'. Meaning is 
sizeof(struct fuse_ring_queue) + queue_depth * sizeof(struct fuse_ring_ent)


> 
>> +
>> +       if (WARN_ON(qid > ring->nr_queues))
> 
> Should this be >= since qid is 0-indexed?

Ouch, yeah.

> 
> we should never reach here, but it feels like if we do, we should just
> automatically return NULL.
> 
>> +               qid = 0;
>> +
>> +       return (struct fuse_ring_queue *)(ptr + qid * ring->queue_size);
>> +}
>> +
>> +#else /* CONFIG_FUSE_IO_URING */
>> +
>> +struct fuse_ring;
>> +
>> +static inline void fuse_uring_conn_init(struct fuse_ring *ring,
>> +                                       struct fuse_conn *fc)
>> +{
>> +}
>> +
>> +static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
>> +{
>> +}
>> +
>> +#endif /* CONFIG_FUSE_IO_URING */
>> +
>> +#endif /* _FS_FUSE_DEV_URING_I_H */
>> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
>> index 6c506f040d5f..e6289bafb788 100644
>> --- a/fs/fuse/fuse_dev_i.h
>> +++ b/fs/fuse/fuse_dev_i.h
>> @@ -7,6 +7,7 @@
>>  #define _FS_FUSE_DEV_I_H
>>
>>  #include <linux/types.h>
>> +#include <linux/fs.h>
> 
> I think you accidentally included this.
> 

When I remove it:

bschubert2@imesrv6 linux.git>make M=fs/fuse/
  CC [M]  fs/fuse/dev_uring.o
In file included from fs/fuse/dev_uring.c:7:
fs/fuse/fuse_dev_i.h:15:52: warning: declaration of 'struct file' will not be visible outside of this function [-Wvisibility]
static inline struct fuse_dev *fuse_get_dev(struct file *file)
                                                   ^
fs/fuse/fuse_dev_i.h:21:9: error: call to undeclared function 'READ_ONCE'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
        return READ_ONCE(file->private_data);
               ^
fs/fuse/fuse_dev_i.h:21:23: error: incomplete definition of type 'struct file'
        return READ_ONCE(file->private_data);
                         ~~~~^


I could also include <linux/fs.h> in dev_uring.c, but isn't it cleaner 
to have the include in fuse_dev_i.h as it is that file that
adds dependencies?

>>
>>  /* Ordinary requests have even IDs, while interrupts IDs are odd */
>>  #define FUSE_INT_REQ_BIT (1ULL << 0)
>> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
>> index f23919610313..33e81b895fee 100644
>> --- a/fs/fuse/fuse_i.h
>> +++ b/fs/fuse/fuse_i.h
>> @@ -917,6 +917,11 @@ struct fuse_conn {
>>         /** IDR for backing files ids */
>>         struct idr backing_files_map;
>>  #endif
>> +
>> +#ifdef CONFIG_FUSE_IO_URING
>> +       /**  uring connection information*/
> nit: need extra space between information and */
>> +       struct fuse_ring *ring;
>> +#endif
>>  };
>>
>>  /*
>> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> index 99e44ea7d875..33a080b24d65 100644
>> --- a/fs/fuse/inode.c
>> +++ b/fs/fuse/inode.c
>> @@ -7,6 +7,7 @@
>>  */
>>
>>  #include "fuse_i.h"
>> +#include "dev_uring_i.h"
>>
>>  #include <linux/pagemap.h>
>>  #include <linux/slab.h>
>> @@ -947,6 +948,8 @@ static void delayed_release(struct rcu_head *p)
>>  {
>>         struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
>>
>> +       fuse_uring_conn_destruct(fc);
> 
> I think it's cleaner if this is moved to fuse_free_conn than here.
> 
>> +
>>         put_user_ns(fc->user_ns);
>>         fc->release(fc);
>>  }
>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
>> index d08b99d60f6f..a1c35e0338f0 100644
>> --- a/include/uapi/linux/fuse.h
>> +++ b/include/uapi/linux/fuse.h
>> @@ -1079,12 +1079,53 @@ struct fuse_backing_map {
>>         uint64_t        padding;
>>  };
>>
>> +enum fuse_uring_ioctl_cmd {
> 
> Do you have a link to the libfuse side? I'm not seeing these get used
> in the patchset - I'm curious how libfuse will be using these then?

I had written it in the introduction

https://github.com/bsbernd/libfuse/tree/uring

Don't look at the individual patches please, I will clean that up,
once we agree on the basic approach.

> 
>> +       /* not correctly initialized when set */
>> +       FUSE_URING_IOCTL_CMD_INVALID    = 0,
>> +
>> +       /* Ioctl to prepare communucation with io-uring */
> 
> nit: communication spelling
> 
>> +       FUSE_URING_IOCTL_CMD_RING_CFG   = 1,
>> +
>> +       /* Ring queue configuration ioctl */
>> +       FUSE_URING_IOCTL_CMD_QUEUE_CFG  = 2,
>> +};
>> +
>> +enum fuse_uring_cfg_flags {
>> +       /* server/daemon side requests numa awareness */
>> +       FUSE_URING_WANT_NUMA = 1ul << 0,
> 
> nit: 1UL for consistency
> 
>> +};
>> +
>> +struct fuse_ring_config {
>> +       /* number of queues */
>> +       uint32_t nr_queues;
>> +
>> +       /* number of foreground entries per queue */
>> +       uint32_t sync_queue_depth;
>> +
>> +       /* number of background entries per queue */
>> +       uint32_t async_queue_depth;
>> +
>> +       /*
>> +        * buffer size userspace allocated per request buffer
>> +        * from the mmaped queue buffer
>> +        */
>> +       uint32_t user_req_buf_sz;
>> +
>> +       /* ring config flags */
>> +       uint64_t numa_aware:1;
>> +
>> +       /* for future extensions */
>> +       uint8_t padding[64];
>> +};
>> +
>>  /* Device ioctls: */
>>  #define FUSE_DEV_IOC_MAGIC             229
>>  #define FUSE_DEV_IOC_CLONE             _IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
>>  #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1, \
>>                                              struct fuse_backing_map)
>>  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_t)
>> +#define FUSE_DEV_IOC_URING_CFG         _IOR(FUSE_DEV_IOC_MAGIC, 3, \
>> +                                            struct fuse_ring_config)
>>
>>  struct fuse_lseek_in {
>>         uint64_t        fh;
>> @@ -1186,4 +1227,10 @@ struct fuse_supp_groups {
>>         uint32_t        groups[];
>>  };
>>
>> +/**
>> + * Size of the ring buffer header
>> + */
>> +#define FUSE_RING_HEADER_BUF_SIZE 4096
>> +#define FUSE_RING_MIN_IN_OUT_ARG_SIZE 4096
> 
> I think this'd be cleaner to review if this got moved to the patch
> where this gets used
> 
>> +
>>  #endif /* _LINUX_FUSE_H */
>>
>> --
>> 2.43.0
>>

I will get it all fixed later this week! I will also review my own
patches before v4, I just wanted to get v3 out asap as it was already
taking so much time after v2.


Thanks,
Bernd


