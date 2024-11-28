Return-Path: <io-uring+bounces-5126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65FFD9DBC1E
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 19:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10C82163D20
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 18:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FA413BC35;
	Thu, 28 Nov 2024 18:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="gdNJcCDg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qatii8+7"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B7F537F8;
	Thu, 28 Nov 2024 18:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732818031; cv=none; b=Oe0QiBEjlK8O08IQKiTQizVZlg/i7EYH0+GFmDMEFoEhLMFCvLws06YjGqFosCwKq6RkywrPSCANrHPZ7N2zsm4seew2EJuVIvQUqdWCiDK89jeUi0tlMwWOGopJGKkhH7ZPU257EpbCS1PY2wUSMGbV5hqWqZ7q3PfXg2vpC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732818031; c=relaxed/simple;
	bh=QY64kWnKJWLm2Me3k4cg8PmmXeo90IJz5ny/XzAylB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WwLS6jlr0u2A7TJUEyffLRySxZF8lg1qExKM5ju4obeJ+A1Mt+sG4NZfO5fXtc+c38XgWFnhpWLeYcDtwWMGXvfbDzPQ3QnQo7Pi5Wj16h+f56uJtlkHfP7cN8IwlLZRRphyLD6rnZYzFD10fKrgbqyZpBVCNBEQiUcpUDzZ2GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=gdNJcCDg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=qatii8+7; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id E6CE3114019C;
	Thu, 28 Nov 2024 13:20:25 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 28 Nov 2024 13:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1732818025;
	 x=1732904425; bh=p64haSdDfLU13qYz1Cz1ZnwL7F4VO4sAMoDAgtJKr2c=; b=
	gdNJcCDg+3V/tMLwBeMOZq60GT6229qbCsKtZLdmXOWjYdP1m3mCJrFYwk5PkZUJ
	M7ZMt7sPnV2h6mlYm0Li/B+qLctdV35m/YHLwGOWXgpj3l/9MKz8rMjDyf9n9WR9
	Fl9i7qIRptO/c8I4FAwhkwx905noAchVm/8VPmTG/iGi1DXcfhdCS15haSj6hksJ
	9w8xTAPNj1glsFVENoBGC/cYPT42uQwuteSVebK9z9MtE807ajFUJLouIacg4DE7
	45bUpQsYZhbijXCA6y46IOq23UvcBAElHrp+1XFFtj/UcFNto7CH6CjfzKzKrHgb
	zK31aVl04azWA+aQfCd8xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1732818025; x=
	1732904425; bh=p64haSdDfLU13qYz1Cz1ZnwL7F4VO4sAMoDAgtJKr2c=; b=q
	atii8+7qsGyDqma3HCgsYdOK0GNScmnDhbycqmd5m1T/86xMW3rQ3e1D5ji/Bg0U
	KARRuJakh79xF8EUbKIFzjsDtuUwVV4GzKdaCLgULLj/yTb6aP202pJSIDYl0kVQ
	Ay4VN0ZXdg/weN7JiKyqPhGfPkZtuEfFn1yUnrakahHV0en7gmR+LnVsJwCkVqzZ
	rX9ts+ZYtSHgB8MYGfXrVhTXxV355ly2dGaNvMu7Jx5BqSTe/aGoPkwBXPOrjHds
	mmI64730ihSyz9FSk8plPujv3+Z4CbD0onWafCZJy0P+lS2JYIZ0U6kwSZRPp88T
	+5Wvz0exCmf/JZuMfjrYA==
X-ME-Sender: <xms:aLRIZ13K90TPSadVE2DwlYhDYEKqNoxkdvxj5ngLogVH9IgLOpTgpA>
    <xme:aLRIZ8HTAnks-uo_SsB-pAnOggzGpY1qio01_SJHL30qnpqf_INPrEIyzzGuwma_I
    -MuMCnyu0f_zztb>
X-ME-Received: <xmr:aLRIZ17nv5sSD0Gvh0TxlEzbWBFl3z_cajgfqD2CUpka1zZCasrwx2yDgCmcHMu_NAhHf-HWKv4vnkn4mu1OrQc-5LYDY_UrMsZBvsF-CIJx1WK4TZiH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrhedugddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudev
    leegleffffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhopehmihhklh
    hoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgu
    khdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtph
    htthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhmpdhrtghpthhtoheprghmihhr
    jeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:aLRIZy1jH85CSwh_6RNjAB0ejvE3NUntbkBwccLpCZ4NwxviyvblsA>
    <xmx:aLRIZ4FsN6YrvD2XuD8ReLQcbn8f-8wXHOthA_HZtMnRv0Bfc4RB-A>
    <xmx:aLRIZz-15_ZSAWHAVtljfMXs2VQPQDXljA8QRK4N9K7WiVM-5HQhtg>
    <xmx:aLRIZ1lXMHjWmW78p9skAf5JS1xzAYXsmLqSpbuw3Qg3TrrQTlyO8Q>
    <xmx:abRIZ_ff9H9cePcwBzyMYLDBqljOmNLDCN6k3DdJFYcx6dKaGQHm6Uq9>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Nov 2024 13:20:23 -0500 (EST)
Message-ID: <d2249041-e90c-446b-be09-f60b3f03b193@fastmail.fm>
Date: Thu, 28 Nov 2024 19:20:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 06/16] fuse: {uring} Handle SQEs - register
 commands
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
 <CAJnrk1YnWFQYG9VTr_1iUwcJmQEg3LemGOGkiqwbaqa4EaMUWw@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1YnWFQYG9VTr_1iUwcJmQEg3LemGOGkiqwbaqa4EaMUWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Joanne,

thanks for your careful review!

On 11/28/24 03:23, Joanne Koong wrote:
> On Wed, Nov 27, 2024 at 5:41 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
>> For now only FUSE_URING_REQ_FETCH is handled to register queue entries.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>  fs/fuse/Kconfig           |  12 ++
>>  fs/fuse/Makefile          |   1 +
>>  fs/fuse/dev.c             |   4 +
>>  fs/fuse/dev_uring.c       | 318 ++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/fuse/dev_uring_i.h     | 115 +++++++++++++++++
>>  fs/fuse/fuse_i.h          |   5 +
>>  fs/fuse/inode.c           |  10 ++
>>  include/uapi/linux/fuse.h |  67 ++++++++++
>>  8 files changed, 532 insertions(+)
>>
>> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
>> index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..11f37cefc94b2af5a675c238801560c822b95f1a 100644
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
>> +
>> +         If you want to allow fuse server/client communication through io-uring,
>> +         answer Y
>> diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
>> index ce0ff7a9007b94b4ab246b5271f227d126c768e8..fcf16b1c391a9bf11ca9f3a25b137acdb203ac47 100644
>> --- a/fs/fuse/Makefile
>> +++ b/fs/fuse/Makefile
>> @@ -14,5 +14,6 @@ fuse-y := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o
>>  fuse-y += iomode.o
>>  fuse-$(CONFIG_FUSE_DAX) += dax.o
>>  fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
>> +fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
>>
>>  virtiofs-y := virtio_fs.o
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index 63c3865aebb7811fdf4a5729b2181ee8321421dc..0770373492ae9ee83c4154fede9dcfd7be9fb33d 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -6,6 +6,7 @@
>>    See the file COPYING.
>>  */
>>
>> +#include "dev_uring_i.h"
>>  #include "fuse_i.h"
>>  #include "fuse_dev_i.h"
>>
>> @@ -2452,6 +2453,9 @@ const struct file_operations fuse_dev_operations = {
>>         .fasync         = fuse_dev_fasync,
>>         .unlocked_ioctl = fuse_dev_ioctl,
>>         .compat_ioctl   = compat_ptr_ioctl,
>> +#ifdef CONFIG_FUSE_IO_URING
>> +       .uring_cmd      = fuse_uring_cmd,
>> +#endif
>>  };
>>  EXPORT_SYMBOL_GPL(fuse_dev_operations);
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..af9c5f116ba1dcf6c01d0359d1a06491c92c32f9
>> --- /dev/null
>> +++ b/fs/fuse/dev_uring.c
>> @@ -0,0 +1,318 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * FUSE: Filesystem in Userspace
>> + * Copyright (c) 2023-2024 DataDirect Networks.
>> + */
>> +
>> +#include <linux/fs.h>
> 
> nit: for consistency, should this line be placed directly above the
> other "#include <linux..." line?
> 
>> +
>> +#include "fuse_i.h"
>> +#include "dev_uring_i.h"
>> +#include "fuse_dev_i.h"
>> +
>> +#include <linux/io_uring/cmd.h>
>> +
>> +#ifdef CONFIG_FUSE_IO_URING
>> +static bool __read_mostly enable_uring;
>> +module_param(enable_uring, bool, 0644);
>> +MODULE_PARM_DESC(enable_uring,
>> +                "Enable uring userspace communication through uring.");
> 
> nit: The double uring seems a bit repetitive to me. Maybe just "enable
> uring userspace communication" or "enable userspace communication
> through uring"? Also, super nit but I noticed the other
> MODULE_PARM_DESCs don't have trailing periods.

Fixed to "Enable userspace communication through io-uring"

> 
>> +#endif
>> +
>> +bool fuse_uring_enabled(void)
>> +{
>> +       return enable_uring;
>> +}
>> +
>> +static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
>> +{
>> +       struct fuse_ring_queue *queue = ent->queue;
>> +
>> +       lockdep_assert_held(&queue->lock);
>> +
>> +       if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
>> +               return -EIO;
>> +
>> +       ent->state = FRRS_COMMIT;
>> +       list_move(&ent->list, &queue->ent_commit_queue);
>> +
>> +       return 0;
>> +}
>> +
>> +void fuse_uring_destruct(struct fuse_conn *fc)
>> +{
>> +       struct fuse_ring *ring = fc->ring;
>> +       int qid;
>> +
>> +       if (!ring)
>> +               return;
>> +
>> +       for (qid = 0; qid < ring->nr_queues; qid++) {
>> +               struct fuse_ring_queue *queue = ring->queues[qid];
>> +
>> +               if (!queue)
>> +                       continue;
>> +
>> +               WARN_ON(!list_empty(&queue->ent_avail_queue));
>> +               WARN_ON(!list_empty(&queue->ent_commit_queue));
>> +
>> +               kfree(queue);
>> +               ring->queues[qid] = NULL;
>> +       }
>> +
>> +       kfree(ring->queues);
>> +       kfree(ring);
>> +       fc->ring = NULL;
>> +}
>> +
>> +#define FUSE_URING_IOV_SEGS 2 /* header and payload */
> 
> nit: to make the code flow easier, might be better to move #defines to
> the top of the file after the includes.

Fixed.

> 
>> +
>> +/*
>> + * Basic ring setup for this connection based on the provided configuration
>> + */
>> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
>> +{
>> +       struct fuse_ring *ring = NULL;
>> +       size_t nr_queues = num_possible_cpus();
>> +       struct fuse_ring *res = NULL;
>> +
>> +       ring = kzalloc(sizeof(*fc->ring) +
>> +                              nr_queues * sizeof(struct fuse_ring_queue),
> 
> I think you just need kzalloc(sizeof(*fc->ring)); here since you're
> allocating ring->queues later below

Ah, now I see what Miklos probably meant "with left over from previous
patches". Sorry Miklos, I had misunderstood what you meant and thanks 
Joanne for spotting it.

> 
>> +                      GFP_KERNEL_ACCOUNT);
>> +       if (!ring)
>> +               return NULL;
>> +
>> +       ring->queues = kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
>> +                              GFP_KERNEL_ACCOUNT);
>> +       if (!ring->queues)
>> +               goto out_err;
>> +
>> +       spin_lock(&fc->lock);
>> +       if (fc->ring) {
>> +               /* race, another thread created the ring in the mean time */
> 
> nit: s/mean time/meantime

Fixed.

> 
>> +               spin_unlock(&fc->lock);
>> +               res = fc->ring;
>> +               goto out_err;
>> +       }
>> +
>> +       fc->ring = ring;
>> +       ring->nr_queues = nr_queues;
>> +       ring->fc = fc;
>> +
>> +       spin_unlock(&fc->lock);
>> +       return ring;
>> +
>> +out_err:
>> +       if (ring)
> 
> I think you meant if (ring->queues)

I really meant ring, initially ring allocation error was via this goto. I just
removed the condition now.

> 
>> +               kfree(ring->queues);
>> +       kfree(ring);
>> +       return res;
>> +}
>> +
>> +static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>> +                                                      int qid)
>> +{
>> +       struct fuse_conn *fc = ring->fc;
>> +       struct fuse_ring_queue *queue;
>> +
>> +       queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>> +       if (!queue)
>> +               return ERR_PTR(-ENOMEM);
>> +       spin_lock(&fc->lock);
> 
> This probably doesn't make much of a difference but might be better to
> minimize logic inside the lock, eg do the queue initialization stuff
> outside the lock

Absolutely, fixed.

> 
>> +       if (ring->queues[qid]) {
>> +               spin_unlock(&fc->lock);
>> +               kfree(queue);
>> +               return ring->queues[qid];
>> +       }
>> +
>> +       queue->qid = qid;
>> +       queue->ring = ring;
>> +       spin_lock_init(&queue->lock);
>> +
>> +       INIT_LIST_HEAD(&queue->ent_avail_queue);
>> +       INIT_LIST_HEAD(&queue->ent_commit_queue);
>> +
>> +       WRITE_ONCE(ring->queues[qid], queue);
> 
> Just curious, why do we need WRITE_ONCE here if it's already protected
> by the fc->lock?

fuse_uring_fetch() (going to rename it _register) obtains the the ring
without holding a lock. Only when that fails it calls into 
fuse_uring_create(), which then obtains the lock. 
I.e. this is optimized to not need the lock at all.

Btw, interesting part here is that I always thought that with a single 
libfuse ring thread we should never run into races, until I noticed 
with large queue sizes (>128) that there were races in fuse_uring_fetch, 
because fuse_uring_create_queue had assigned "ring->queues[qid] = queue" 
too early, before initialization of the spin lock (some lockdep
annotations about the queue spin lock not being initialized came up). 


> 
>> +       spin_unlock(&fc->lock);
>> +
>> +       return queue;
>> +}
>> +
>> +/*
>> + * Make a ring entry available for fuse_req assignment
>> + */
>> +static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
>> +                                struct fuse_ring_queue *queue)
>> +{
>> +       list_move(&ring_ent->list, &queue->ent_avail_queue);
>> +       ring_ent->state = FRRS_WAIT;
>> +}
>> +
>> +/*
>> + * fuse_uring_req_fetch command handling
>> + */
>> +static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
>> +                             struct io_uring_cmd *cmd,
>> +                             unsigned int issue_flags)
>> +{
>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>> +
>> +       spin_lock(&queue->lock);
>> +       fuse_uring_ent_avail(ring_ent, queue);
>> +       ring_ent->cmd = cmd;
>> +       spin_unlock(&queue->lock);
>> +}
>> +
>> +/*
>> + * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
>> + * the payload
>> + */
>> +static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
>> +                                        struct iovec iov[FUSE_URING_IOV_SEGS])
>> +{
>> +       struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +       struct iov_iter iter;
>> +       ssize_t ret;
>> +
>> +       if (sqe->len != FUSE_URING_IOV_SEGS)
>> +               return -EINVAL;
>> +
>> +       /*
>> +        * Direction for buffer access will actually be READ and WRITE,
>> +        * using write for the import should include READ access as well.
>> +        */
>> +       ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
>> +                          FUSE_URING_IOV_SEGS, &iov, &iter);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       return 0;
>> +}
>> +
>> +static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
>> +                           struct fuse_conn *fc)
>> +{
>> +       const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
>> +       struct fuse_ring *ring = fc->ring;
>> +       struct fuse_ring_queue *queue;
>> +       struct fuse_ring_ent *ring_ent;
>> +       int err;
>> +       struct iovec iov[FUSE_URING_IOV_SEGS];
>> +
>> +       err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
>> +       if (err) {
>> +               pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
>> +                                   err);
>> +               return err;
>> +       }
>> +
>> +       err = -ENOMEM;
>> +       if (!ring) {
>> +               ring = fuse_uring_create(fc);
>> +               if (!ring)
>> +                       return err;
>> +       }
>> +
>> +       queue = ring->queues[cmd_req->qid];
>> +       if (!queue) {
>> +               queue = fuse_uring_create_queue(ring, cmd_req->qid);
>> +               if (!queue)
>> +                       return err;
>> +       }
>> +
>> +       /*
>> +        * The created queue above does not need to be destructed in
>> +        * case of entry errors below, will be done at ring destruction time.
>> +        */
>> +
>> +       ring_ent = kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
>> +       if (ring_ent == NULL)
> 
> nit: !ring_ent

Fixed.

> 
>> +               return err;
>> +
>> +       INIT_LIST_HEAD(&ring_ent->list);
>> +
>> +       ring_ent->queue = queue;
>> +       ring_ent->cmd = cmd;
>> +
>> +       err = -EINVAL;
>> +       if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
>> +               pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
>> +               goto err;
>> +       }
>> +
>> +       ring_ent->headers = iov[0].iov_base;
>> +       ring_ent->payload = iov[1].iov_base;
>> +       ring_ent->max_arg_len = iov[1].iov_len;
>> +
>> +       if (ring_ent->max_arg_len <
>> +           max_t(size_t, FUSE_MIN_READ_BUFFER, fc->max_write)) {
> 
> If I'm understanding this correctly, iov[0] is the header and iov[1]
> is the payload. Is this right that the payload len must always be
> equal to fc->max_write?

I'm going to drop ring_ent->max_arg_len for the next version, but it will
eventually come back once I had support for multiple payload sizes.
Typically we will need many small requests, less mid size requests and few
large size requests. Just think of a queue size of 128 and a recent system
with 192 cores.


> 
> Also, do we need to take into account fc->max_pages too?

Oh yes, thanks for spotting!

> 
>> +               pr_info_ratelimited("Invalid req payload len %zu\n",
>> +                                   ring_ent->max_arg_len);
>> +               goto err;
>> +       }
>> +
>> +       spin_lock(&queue->lock);
>> +
>> +       /*
>> +        * FUSE_URING_REQ_FETCH is an initialization exception, needs
>> +        * state override
>> +        */
>> +       ring_ent->state = FRRS_USERSPACE;
>> +       err = fuse_ring_ent_unset_userspace(ring_ent);
>> +       spin_unlock(&queue->lock);
>> +       if (WARN_ON_ONCE(err != 0))
> 
> nit: WARN_ON_ONCE(err)

Fixed.

> 
>> +               goto err;
>> +
>> +       _fuse_uring_fetch(ring_ent, cmd, issue_flags);
>> +
>> +       return 0;
>> +err:
>> +       list_del_init(&ring_ent->list);
>> +       kfree(ring_ent);
>> +       return err;
>> +}
>> +
>> +/*
>> + * Entry function from io_uring to handle the given passthrough command
>> + * (op cocde IORING_OP_URING_CMD)
>> + */
>> +int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> +{
>> +       struct fuse_dev *fud;
>> +       struct fuse_conn *fc;
>> +       u32 cmd_op = cmd->cmd_op;
>> +       int err;
>> +
>> +       /* Disabled for now, especially as teardown is not implemented yet */
>> +       pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
>> +       return -EOPNOTSUPP;
>> +
>> +       if (!enable_uring) {
>> +               pr_info_ratelimited("fuse-io-uring is disabled\n");
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       fud = fuse_get_dev(cmd->file);
>> +       if (!fud) {
>> +               pr_info_ratelimited("No fuse device found\n");
>> +               return -ENOTCONN;
>> +       }
>> +       fc = fud->fc;
>> +
>> +       if (!fc->connected || fc->aborted)
>> +               return fc->aborted ? -ECONNABORTED : -ENOTCONN;
> 
> I find
> if (fc->aborted)
>   return -ECONNABORTED;
> if (!fc->connected)
>    return -ENOTCONN;
> 
> easier to read

Fine with me.

>> +
>> +       switch (cmd_op) {
>> +       case FUSE_URING_REQ_FETCH:
> 
> FUSE_URING_REQ_FETCH is only used for initialization, would it be
> clearer if this was named FUSE_URING_INIT or something like that?

 FUSE_URING_CMD_REGISTER?

> 
>> +               err = fuse_uring_fetch(cmd, issue_flags, fc);
>> +               if (err) {
>> +                       pr_info_once("fuse_uring_fetch failed err=%d\n", err);
>> +                       return err;
>> +               }
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       return -EIOCBQUEUED;
>> +}
>> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..75c644cc0b2bb3721b08f8695964815d53f46e92
>> --- /dev/null
>> +++ b/fs/fuse/dev_uring_i.h
>> @@ -0,0 +1,115 @@
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
>> +enum fuse_ring_req_state {
>> +       FRRS_INVALID = 0,
>> +
>> +       /* The ring entry received from userspace and it being processed */
> 
> nit: "it is being processed"
> 
>> +       FRRS_COMMIT,
>> +
>> +       /* The ring entry is waiting for new fuse requests */
>> +       FRRS_WAIT,
>> +
>> +       /* The ring entry is in or on the way to user space */
>> +       FRRS_USERSPACE,
>> +};
>> +
>> +/** A fuse ring entry, part of the ring queue */
>> +struct fuse_ring_ent {
>> +       /* userspace buffer */
>> +       struct fuse_uring_req_header __user *headers;
>> +       void *__user *payload;
>> +
>> +       /* the ring queue that owns the request */
>> +       struct fuse_ring_queue *queue;
>> +
>> +       struct io_uring_cmd *cmd;
>> +
>> +       struct list_head list;
>> +
>> +       /* size of payload buffer */
>> +       size_t max_arg_len;
>> +
>> +       /*
>> +        * state the request is currently in
>> +        * (enum fuse_ring_req_state)
>> +        */
>> +       unsigned int state;
>> +
>> +       struct fuse_req *fuse_req;
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
>> +       /*
>> +        * queue lock, taken when any value in the queue changes _and_ also
>> +        * a ring entry state changes.
>> +        */
>> +       spinlock_t lock;
>> +
>> +       /* available ring entries (struct fuse_ring_ent) */
>> +       struct list_head ent_avail_queue;
>> +
>> +       /*
>> +        * entries in the process of being committed or in the process
>> +        * to be send to userspace
>> +        */
>> +       struct list_head ent_commit_queue;
>> +};
>> +
>> +/**
>> + * Describes if uring is for communication and holds alls the data needed
>> + * for uring communication
>> + */
>> +struct fuse_ring {
>> +       /* back pointer */
>> +       struct fuse_conn *fc;
>> +
>> +       /* number of ring queues */
>> +       size_t nr_queues;
>> +
>> +       struct fuse_ring_queue **queues;
>> +};
>> +
>> +bool fuse_uring_enabled(void);
>> +void fuse_uring_destruct(struct fuse_conn *fc);
>> +int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>> +
>> +#else /* CONFIG_FUSE_IO_URING */
>> +
>> +struct fuse_ring;
>> +
>> +static inline void fuse_uring_create(struct fuse_conn *fc)
>> +{
>> +}
>> +
>> +static inline void fuse_uring_destruct(struct fuse_conn *fc)
>> +{
>> +}
>> +
>> +static inline bool fuse_uring_enabled(void)
>> +{
>> +       return false;
>> +}
>> +
>> +#endif /* CONFIG_FUSE_IO_URING */
>> +
>> +#endif /* _FS_FUSE_DEV_URING_I_H */
>> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
>> index e3748751e231d0991c050b31bdd84db0b8016f9f..a21256ec4c3b4bd7c67eae2d03b68d87dcc8234b 100644
>> --- a/fs/fuse/fuse_i.h
>> +++ b/fs/fuse/fuse_i.h
>> @@ -914,6 +914,11 @@ struct fuse_conn {
>>         /** IDR for backing files ids */
>>         struct idr backing_files_map;
>>  #endif
>> +
>> +#ifdef CONFIG_FUSE_IO_URING
>> +       /**  uring connection information*/
>> +       struct fuse_ring *ring;
>> +#endif
>>  };
>>
>>  /*
>> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> index fd3321e29a3e569bf06be22a5383cf34fd42c051..76267c79e920204175e5713853de8214c5555d46 100644
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
>> @@ -959,6 +960,8 @@ static void delayed_release(struct rcu_head *p)
>>  {
>>         struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
>>
>> +       fuse_uring_destruct(fc);
>> +
>>         put_user_ns(fc->user_ns);
>>         fc->release(fc);
>>  }
>> @@ -1413,6 +1416,13 @@ void fuse_send_init(struct fuse_mount *fm)
>>         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
>>                 flags |= FUSE_PASSTHROUGH;
>>
>> +       /*
>> +        * This is just an information flag for fuse server. No need to check
>> +        * the reply - server is either sending IORING_OP_URING_CMD or not.
>> +        */
>> +       if (fuse_uring_enabled())
>> +               flags |= FUSE_OVER_IO_URING;
>> +
>>         ia->in.flags = flags;
>>         ia->in.flags2 = flags >> 32;
>>
>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
>> index f1e99458e29e4fdce5273bc3def242342f207ebd..6d39077edf8cde4fa77130efcec16323839a676c 100644
>> --- a/include/uapi/linux/fuse.h
>> +++ b/include/uapi/linux/fuse.h
>> @@ -220,6 +220,14 @@
>>   *
>>   *  7.41
>>   *  - add FUSE_ALLOW_IDMAP
>> + *  7.42
>> + *  - Add FUSE_OVER_IO_URING and all other io-uring related flags and data
>> + *    structures:
>> + *    - fuse_uring_ent_in_out
>> + *    - fuse_uring_req_header
>> + *    - fuse_uring_cmd_req
>> + *    - FUSE_URING_IN_OUT_HEADER_SZ
>> + *    - FUSE_URING_OP_IN_OUT_SZ
>>   */
>>
>>  #ifndef _LINUX_FUSE_H
>> @@ -425,6 +433,7 @@ struct fuse_file_lock {
>>   * FUSE_HAS_RESEND: kernel supports resending pending requests, and the high bit
>>   *                 of the request ID indicates resend requests
>>   * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
>> + * FUSE_OVER_IO_URING: Indicate that Client supports io-uring
>>   */
>>  #define FUSE_ASYNC_READ                (1 << 0)
>>  #define FUSE_POSIX_LOCKS       (1 << 1)
>> @@ -471,6 +480,7 @@ struct fuse_file_lock {
>>  /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
>>  #define FUSE_DIRECT_IO_RELAX   FUSE_DIRECT_IO_ALLOW_MMAP
>>  #define FUSE_ALLOW_IDMAP       (1ULL << 40)
>> +#define FUSE_OVER_IO_URING     (1ULL << 41)
>>
>>  /**
>>   * CUSE INIT request/reply flags
>> @@ -1206,4 +1216,61 @@ struct fuse_supp_groups {
>>         uint32_t        groups[];
>>  };
>>
>> +/**
>> + * Size of the ring buffer header
>> + */
>> +#define FUSE_URING_IN_OUT_HEADER_SZ 128
>> +#define FUSE_URING_OP_IN_OUT_SZ 128
>> +
>> +struct fuse_uring_ent_in_out {
>> +       uint64_t flags;
>> +
>> +       /* size of use payload buffer */
>> +       uint32_t payload_sz;
>> +       uint32_t padding;
>> +
>> +       uint8_t reserved[30];
> 
> out of curiosity, how was 30 chosen here? I think this makes the
> struct 46 bytes?

Clearly a bug, that was supposed to be 16. I changed it to
	uint64_t reserved[2];


> 
>> +};
>> +
>> +/**
>> + * This structure mapped onto the
>> + */
>> +struct fuse_uring_req_header {
>> +       /* struct fuse_in / struct fuse_out */
>> +       char in_out[FUSE_URING_IN_OUT_HEADER_SZ];
>> +
>> +       /* per op code structs */
>> +       char op_in[FUSE_URING_OP_IN_OUT_SZ];
>> +
>> +       /* struct fuse_ring_in_out */
>> +       char ring_ent_in_out[sizeof(struct fuse_uring_ent_in_out)];
>> +};
>> +
>> +/**
>> + * sqe commands to the kernel
>> + */
>> +enum fuse_uring_cmd {
>> +       FUSE_URING_REQ_INVALID = 0,
>> +
>> +       /* submit sqe to kernel to get a request */
>> +       FUSE_URING_REQ_FETCH = 1,
>> +
>> +       /* commit result and fetch next request */
>> +       FUSE_URING_REQ_COMMIT_AND_FETCH = 2,
>> +};
>> +
>> +/**
>> + * In the 80B command area of the SQE.
>> + */
>> +struct fuse_uring_cmd_req {
>> +       uint64_t flags;
>> +
>> +       /* entry identifier */
>> +       uint64_t commit_id;
>> +
>> +       /* queue the command is for (queue index) */
>> +       uint16_t qid;
>> +       uint8_t padding[6];
>> +};
>> +
>>  #endif /* _LINUX_FUSE_H */
>>
> 
> I'll be out the rest of this week for an American holiday
> (Thanksgiving) and next week for a work trip but will review the rest
> of this patchset after that when i get back.

Thanks so much for your review! Happy Thanksgiving and safe travels!


Thanks,
Bernd

