Return-Path: <io-uring+bounces-5004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB849D6907
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 13:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D0811614F2
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 12:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0A9175D39;
	Sat, 23 Nov 2024 12:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="Fn4r7bny";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BV9r1e/y"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DD5185B4C;
	Sat, 23 Nov 2024 12:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732365748; cv=none; b=raNg4A+HIKy3/cbSws6otRy/BTelb9jnbE/FRfgGnjYLIRptWw6i3ddF8gEsvoXkYkrr1uWECe+0quSr7uBX1W79iF1OjDEUbUOBJRIrshDP9nvnX6qFJyP10yKfLkuaTWpRk1TFGDSNtTiR6ZKJSa4gqRY0b8kajLyrGeCq23o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732365748; c=relaxed/simple;
	bh=yo0oujE9S0jFtyVwVv3kc9Y5eHkE1Ndp2GYvctaUUBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=Z6JfmqTUw+yecWwRfOoyDU/BDHSHIvtUQ5XXrXyDR0vuBNAMB9VrCyV8D1tNpIx1pKtndKUlW8mM7D8twVLODkqqkwRQ9G1EaiiclG5uNy8wTTIT4SCNEOx/DUqJEl9Rhqn1dh5h4mCUnhQX6gxj9stm1gzpRJHC7qpY7Q7MeQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=Fn4r7bny; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BV9r1e/y; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 68B0C11400D7;
	Sat, 23 Nov 2024 07:42:24 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sat, 23 Nov 2024 07:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1732365744;
	 x=1732452144; bh=bx7xxgw+6FQa0a0V49WhgBM2DH346mRjqx9zN2POSjo=; b=
	Fn4r7bnyZJBsUi3ra4ldo/dGduiZpYlG2Kva7l9X571Bwspc01Yr9z1VC6xbkCvl
	ESwK80J3gHBwVcOQIACltFjtdoWgxuXZ2DBBUP3GxxLsB042rjXeXxY0hsBTtsUA
	Nxdxx4Q9ZFvRilF1RIH1lAt0DMljsMHeLivNusog940+cXnujXRWdOBo3hI0vtZ0
	m8vWVeWjocW/MMNLeomLi96qKcSs1M1g//55mtzhvWQrweP4vC7j6pkR3DFgXpBB
	T8qJVDviIReyp6SySAE98W9wN0hOknMs9o1zVohDcUYhQuW8buUf8G4ii4lDqzPW
	N8PvVKIwud0uWGx4lcR0KQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1732365744; x=
	1732452144; bh=bx7xxgw+6FQa0a0V49WhgBM2DH346mRjqx9zN2POSjo=; b=B
	V9r1e/yJ0ehqF5KHe20Qm+F+jisfMmnZDUi/3deke9QFyrexG50uVrIvbetznP7F
	IXKfcN2p89oXUuzeVOBQSxAyO03sqoSQ//c6t0mF33zAOHBp23hbVtFIU7q+MAQa
	TMTz5/IXfmNi5E8q18bnvaLg0ENwAmZHzERDS34CJv3jpcDDBS9fjhvW6Vqb1RRS
	6iJW8qpxALlPJMn4MXV+68AL9mui8qCshQze++HPw75VVrunVho58U+dGE55q6Vj
	qG8O2LBXFiz8biUDpYzyCq9gZ7CSERWkYDBF6uVfJZy4iGVrb3HkKlG4oLgnLxLG
	rHd+ODo4M+T2CHW51ESjQ==
X-ME-Sender: <xms:r81BZzwgddqbTjhq0IUyPwQV8GIIeQj9QRuaKXtdKyhmM5eDLzEapg>
    <xme:r81BZ7S9GkZGq8NwJ9TWu1an8SligCSrN6Sbnavz_WJHGTO3RNJoRebhW71DoiKWA
    8bsH7MOOWCK2OS7>
X-ME-Received: <xmr:r81BZ9XVItEQUmjTF4lWUQn0LFtGCzqCppaKvv3bUzOZ98G07bcRl7F7Aih9sNpJxG5kqUQuqnyZtYKlszH8S41V2_Xw4LP1SUuLkU2gvWf-Hxqi7Kt->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrgedugdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfevjggtgfesthejredttddvjeen
    ucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrh
    htsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpedvvdefleehieefvdfg
    feefledvgffgjeetffefhfegudehtdfhhefhieefffeikeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthes
    fhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohep
    rgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvg
    esghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhl
    rdgtohhmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhmpdhrtg
    hpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhmpdhrtghpthhtohepthhomhdr
    lhgvihhmihhnghesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:r81BZ9jVMXNWwwCfHZSfh_DRHRa3-RbuGpRvCGAhvA4DwWl7h9RRRw>
    <xmx:r81BZ1Dhu4E-5hfnrXb8gEWIqUa4lXrpOAArVkmsyR9Y5EhIDxwCpg>
    <xmx:r81BZ2JrE6CSbH3_3gZI2EW93du8kTBhUaqWRZhX2P7b1m8A4DI-0g>
    <xmx:r81BZ0BWtAc3uIkIIddDc42MnGKDdhlQlU0XDbta4VoXrA3EfVvi3w>
    <xmx:sM1BZ6Iaw3Lbtillotb6Um3c9oK21M_4p1OnTIaGil5mzGqetglnLv0L>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 23 Nov 2024 07:42:21 -0500 (EST)
Message-ID: <e1f3cbf0-eedf-41a9-9689-5eda56e06216@fastmail.fm>
Date: Sat, 23 Nov 2024 13:42:20 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v6 06/16] fuse: {uring} Handle SQEs - register
 commands
To: Miklos Szeredi <miklos@szeredi.hu>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
 <20241122-fuse-uring-for-6-10-rfc4-v6-6-28e6cdd0e914@ddn.com>
 <CAJfpegtih77CpuSQAOkUaKRMPj44ua65+_MUMa3LqgYjLFofqg@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
In-Reply-To: <CAJfpegtih77CpuSQAOkUaKRMPj44ua65+_MUMa3LqgYjLFofqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/23/24 10:52, Miklos Szeredi wrote:
> On Fri, 22 Nov 2024 at 00:44, Bernd Schubert <bschubert@ddn.com> wrote:
> 
>> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
>> +{
>> +       struct fuse_ring *ring = NULL;
>> +       size_t nr_queues = num_possible_cpus();
>> +       struct fuse_ring *res = NULL;
>> +
>> +       ring = kzalloc(sizeof(*fc->ring) +
>> +                              nr_queues * sizeof(struct fuse_ring_queue),
> 
> Left over from a previous version?

Why? This struct holds all the queues? We could also put into fc, but
it would take additional memory, even if uring is not used.

> 
>> +static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
>> +                                struct fuse_ring_queue *queue)
>> +       __must_hold(&queue->lock)
>> +{
>> +       struct fuse_ring *ring = queue->ring;
>> +
>> +       lockdep_assert_held(&queue->lock);
>> +
>> +       /* unsets all previous flags - basically resets */
>> +       pr_devel("%s ring=%p qid=%d state=%d\n", __func__, ring,
>> +                ring_ent->queue->qid, ring_ent->state);
>> +
>> +       if (WARN_ON(ring_ent->state != FRRS_COMMIT)) {
>> +               pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
>> +                       ring_ent->state);
>> +               return;
>> +       }
>> +
>> +       list_move(&ring_ent->list, &queue->ent_avail_queue);
>> +
>> +       ring_ent->state = FRRS_WAIT;
>> +}
> 
> AFAICS this function is essentially just one line, the rest is
> debugging.   While it's good for initial development it's bad for
> review because the of the bad signal to noise ratio (the debugging
> part is irrelevant for code review).
> 
> Would it make sense to post the non-RFC version without most of the
> pr_debug()/pr_warn() stuff and just keep the simple WARN_ON() lines
> that signal if something has gone wrong.

I can remove the pr_debug/pr_warn lines for the non-RFC version, that
will come early next week.

> 
> Long term we could get rid of some of that too.   E.g ring_ent->state
> seems to be there just for debugging, but if the code is clean enough
> we don't need to have a separate state.

Almost, please see 

[PATCH RFC v6 15/16] fuse: {io-uring} Prevent mount point hang on fuse-server termination

there you really need a ring state, because access is outside of lists.
Unless you want to iterate over the lists, if the the entry is still
in there. Please see the discussion with Joanne in RFC v5.
I have also added in v6 15/16 comments about non-list access.

> 
>> +#if 0
>> +       /* Does not work as sending over io-uring is async */
>> +       err = -ETXTBSY;
>> +       if (fc->initialized) {
>> +               pr_info_ratelimited(
>> +                       "Received FUSE_URING_REQ_FETCH after connection is initialized\n");
>> +               return err;
>> +       }
>> +#endif
> 
> I fail to remember what's up with this.  Why is it important that
> FETCH is sent before INIT reply?

That is basically what I try to explain with the comment,
it does not work. I had left it in the code, so that you would
run over it, looks like that worked  :)

Even though libfuse sends the SQEs before
setting up /dev/fuse threads, handling the SQEs takes longer.
So what happens is that while IORING_OP_URING_CMD/FUSE_URING_REQ_FETCH
are coming in, FUSE_INIT reply gets through. In userspace we do not
know at all, when these SQEs are registered, because we don't get
a reply. Even worse, we don't even know if io-uring works at all and
cannot adjust number of /dev/fuse handling threads. Here setup with
ioctls had a clear advantage - there was a clear reply.

The other issue is, that we will probably first need handle FUSE_INIT
in userspace before sending SQEs at all, in order to know the payload
buffer size.

> 
>> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
>> index 6c506f040d5fb57dae746880c657a95637ac50ce..e82cbf9c569af4f271ba0456cb49e0a5116bf36b 100644
>> --- a/fs/fuse/fuse_dev_i.h
>> +++ b/fs/fuse/fuse_dev_i.h
>> @@ -8,6 +8,7 @@
>>
>>  #include <linux/types.h>
>>
>> +
> 
> Unneeded extra line.

Yeah, I didn't review these patches on my own yet, there are probably
more tiny things like that all over the place - will be done by next
with in the non-RFC version.


Thanks,
Bernd

