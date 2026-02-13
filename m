Return-Path: <io-uring+bounces-12199-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2B+EOOF7j2mWRAEAu9opvQ
	(envelope-from <io-uring+bounces-12199-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:30:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E059813938A
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8ADBD30075F1
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 19:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954C52DB781;
	Fri, 13 Feb 2026 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="L3SOLo/E";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wVIKIqXy"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70255283C82;
	Fri, 13 Feb 2026 19:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771011038; cv=none; b=IzQIRx3DUqBWu/9ySpIUMwStjJe8IuO4T+ueJQqe3rmdvaPMKEXXdJl2Gzum4yKfVz7yivvOMRrUgYCMSAqXzZc2JawMCjk2OaqGjWHP6DismJS8MIy+6KWu4kXkunoIA/exGd2kkPGWUVyJ7JeTfm6eJ0iX1CpQuqU0AsB7PmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771011038; c=relaxed/simple;
	bh=/soP4JtfINeExdCYV4Go8jQcaz+E1DF0rz0KmGCkFEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZzSFJdMDF81BHYweb7bVt4VP9wbRXST0IaDJnN2f8oYc04aJN3ZYkU+UpcOCMgv/jpuH6WXFbVmgzLxxWpymN0nFltwH1wZNmq8Y7BLapWBann63doCXajdCU0/3gOQpqHY3OakGkcPikmtDJq5AnU8wKEdr7cV1PmICJ0w8mtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=L3SOLo/E; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wVIKIqXy; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8144414001BB;
	Fri, 13 Feb 2026 14:30:35 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 13 Feb 2026 14:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1771011035;
	 x=1771097435; bh=RMzHn/roFimnsPnYkWixH28HZlVlA9LXCmGdMns0/FA=; b=
	L3SOLo/EI83WrAFOrz8CH7Ow+qRsxrfCkc7G4VTT6EfztE+U9rfOqmMakkDePgZ8
	26GEdbS0fkt3uNoMfmtpIasDQGE/I1CoQaCKe3R3qyBLOjfFkS4n5M733kcfFWIo
	GLnv3038g3wDXe6AoGwAosypzfb4iXip/84xK29wpre7H87JNYyg5pJ0yEiYNhhT
	DBDgJ5yX9Q1U6v1CrK+GJ4qepDJaZ5OsbtHf4zDODetA/SnFzqiA7LFym/2U+yqx
	92cGN1BkIg4rfsD83JtUDjS9uUcxBJgYbjmlKGsJV11dnteBxZVMo3nopKpAC87y
	sMXC8Hv2dKBaL6KDMtO8CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771011035; x=
	1771097435; bh=RMzHn/roFimnsPnYkWixH28HZlVlA9LXCmGdMns0/FA=; b=w
	VIKIqXy82Ce/+FLc1YcxjaVq53oH74ATdCgDtB0PZccD4FcGOkaMgNNdFC3j+og/
	DLeLSafbc50cUIi2QdXU6nPYGWSgz+p3T1nJzSxLXUaGGRQ/jqb6L5RAVkBOoiur
	4VFX59U95ScOqeUh0FKMCVkSgJY0G7O+kl3dcXcYPCwGV+8q17eq0JbGzc7YDZdJ
	0QK2ccqzMcl6gT2ZwH+KGcK4hhgqDAn0fFBBUDAx+zxwfz92vVOOoc/ZOoxH3r7b
	U7Kt5lRoRQ/UGW7qixjNuy2AOF7ArqLhr4sHAxUTunyBtDZUcUt6uhk3hsZMLILC
	yhtcUq8ll3bwD6Fhp7l3Q==
X-ME-Sender: <xms:2nuPaajPe5oEtoV0mgSFbVx6AoEh_-75q4l-j5_Os-dLITdc8TcjrA>
    <xme:2nuPaVB4EZeymLjHPQA-gFSk17aCALs8Cha6EGyXfRTf9qwK2RHdzhR4q-s7AiAiY
    wD6kKpyzMxuHwz2-y_BV7DiMtBW_oNeoN2OFzpPr0E23qz0KoGf>
X-ME-Received: <xmr:2nuPaYuohnZzbhtr9BrObWbKdu9cAEnhTbRchSY-zz3yMNpM7Ry_WGfKSC0Qdo-6f1a6nV3fczhY5aEVuGhi1GhQnewYr4PlTc-teueyMHCT6MBkLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdeltdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffehudejvdfgteevvddtfeeiheef
    lefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeekpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtg
    homhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgt
    phhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheprgigsghovg
    eskhgvrhhnvghlrdgukhdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghr
    nhgvlhdrohhrghdprhgtphhtthhopegtshgrnhguvghrsehpuhhrvghsthhorhgrghgvrd
    gtohhmpdhrtghpthhtohepkhhrihhsmhgrnhesshhushgvrdguvgdprhgtphhtthhopehl
    ihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:2nuPaRejnj2DgyG2_1nUMB_yRlklfQ-AKUoj9RvBh2BQk-B6ht7A2A>
    <xmx:2nuPaV9rCZG2RZ1acwQWz4Lm0g4YvkB-Lgf633asxhpjMi85GEJlMA>
    <xmx:2nuPacTxwceexUzqXjqRvjsxcOXwGivJ3ogx4nmy5CAuf3S4d0Pz1g>
    <xmx:2nuPaWrdl6yvVAAT6Dco-agwqpT9oJCQFSz8pUEzQUwc76WMOKw1OA>
    <xmx:23uPaVAQPra6iRTKP3C_inS4G8cAAodIiRdA-5Dv1NyoGtnZp6541NX9>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 14:30:33 -0500 (EST)
Message-ID: <d9e25d62-d63c-4e09-9607-360c4a847087@bsbernd.com>
Date: Fri, 13 Feb 2026 20:30:32 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
 io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
 linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org>
 <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
 <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com>
 <aY7ScyJOp4zqKJO7@infradead.org>
 <7c241b57-95d4-4d58-8cd3-369751f17df1@gmail.com>
 <CAJnrk1b2BHwBzz+AS7x0WuJSpf98x1xGhf1ys2rm4Ffb0_5TOA@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1b2BHwBzz+AS7x0WuJSpf98x1xGhf1ys2rm4Ffb0_5TOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12199-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bsbernd.com:mid,bsbernd.com:dkim]
X-Rspamd-Queue-Id: E059813938A
X-Rspamd-Action: no action



On 2/13/26 20:09, Joanne Koong wrote:
> On Fri, Feb 13, 2026 at 7:31 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/13/26 07:27, Christoph Hellwig wrote:
>>> On Thu, Feb 12, 2026 at 09:29:31AM -0800, Joanne Koong wrote:
>>>>>> I'm arguing exactly against this.  For my use case I need a setup
>>>>>> where the kernel controls the allocation fully and guarantees user
>>>>>> processes can only read the memory but never write to it.  I'd love
>>>>
>>>> By "control the allocation fully" do you mean for your use case, the
>>>> allocation/setup isn't triggered by userspace but is initiated by the
>>>> kernel (eg user never explicitly registers any kbuf ring, the kernel
>>>> just uses the kbuf ring data structure internally and users can read
>>>> the buffer contents)? If userspace initiates the setup of the kbuf
>>>> ring, going through IORING_REGISTER_MEM_REGION would be semantically
>>>> the same, except the buffer allocation by the kernel now happens
>>>> before the ring is created and then later populated into the ring.
>>>> userspace would still need to make an mmap call to the region and the
>>>> kernel could enforce that as read-only. But if userspace doesn't
>>>> initiate the setup, then going through IORING_REGISTER_MEM_REGION gets
>>>> uglier.
>>>
>>> The idea is that the application tells the kernel that it wants to use
>>> a fixed buffer pool for reads.  Right now the application does this
>>> using io_uring_register_buffers().  The problem with that is that
>>> io_uring_register_buffers ends up just doing a pin of the memory,
>>> but the application or, in case of shared memory, someone else could
>>> still modify the memory.  If the underlying file system or storage
>>> device needs verify checksums, or worse rebuild data from parity
>>> (or uncompress), it needs to ensure that the memory it is operating
>>> on can't be modified by someone else.
>>>
>>> So I've been thinking of a version of io_uring_register_buffers where
>>> the buffers are not provided by the application, but instead by the
>>> kernel and mapped into the application address space read-only for
>>> a while, and I thought I could implement this on top of your series,
>>> but I have to admit I haven't really looked into the details all
>>> that much.
>>
>> There is nothing about registered buffers in this series. And even
>> if you try to reuse buffer allocation out of it, it'll come with
>> a circular buffer you'll have no need for. And I'm pretty much
> 
> I think the circular buffer will be useful for Christoph's use case in
> the same way it'll be useful for fuse's. The read payload could be
> differently sized across requests, so it's a lot of wasted space to
> have to allocate a buffer large enough to support the max-size request
> per entry in the io_ring. With using a circular buffer, buffers have a
> way to be shared across entries, which means we can significantly
> reduce how much memory needs to be allocated.

Dunno, what we actually want is requests of multiple sizes. Sharing
buffers across entries sounds like just reducing the ring size - I
personally don't see the point here.


Thanks,
Bernd

