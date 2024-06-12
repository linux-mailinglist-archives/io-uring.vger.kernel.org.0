Return-Path: <io-uring+bounces-2193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 326FF905870
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 18:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BAAB1C226AD
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 16:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3EE186E28;
	Wed, 12 Jun 2024 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="P5+DFqUu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SeKc1UOE"
X-Original-To: io-uring@vger.kernel.org
Received: from fout1-smtp.messagingengine.com (fout1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957B818413C;
	Wed, 12 Jun 2024 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718208966; cv=none; b=l2QT4c8yBQBB18xkIiqELzq/otYn5Er++kW6Em9om2EEj8+RRcjJBirzN5XDQppwA3sYRqMyzzotuUdxm88ZmSfHLGYdVhDTzp6e38Ek4CcUIzISBDTz9DaELUi3xEyMKE1kmehAwktZKTvW8CZOPeLMZfGsA6BCQaKYoapDX4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718208966; c=relaxed/simple;
	bh=w7YqKEPo/kGZffJcLuvhJMRGD8qtbQi51bwOtBzbl+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QEPZ1BMhOutkXKjZMIjYWPB+oS/zdRj2o6eIpA7m2SkYe0ueO5O7ykcx0tMqB3kGanuYWHl74d8i/Ob5gc/6cw6Ke6gjM1DrYDMl9GHogQtP2URQvnW6q9kt3zLcgffguQecnEpFhcKX/NxeJUWsmkYXK4nSH6ferRG0mUK4mS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=P5+DFqUu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SeKc1UOE; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfout.nyi.internal (Postfix) with ESMTP id AE33413801A0;
	Wed, 12 Jun 2024 12:16:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 Jun 2024 12:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1718208960;
	 x=1718295360; bh=yUVDTGhYlj4eqvhNv3LbdHV4m8qId3DIMMR0yTJOkJM=; b=
	P5+DFqUujekIlZNSWpOY/ofX2U2H2K5uwcBGQZElhpsyjWaIFvOw13BPAYYAqU4s
	Gpmp1PF4ohcyG+wIkt7upnntP2WgW9IbD83oeiq1KpaisGkT+LXz2mQ1hHHTYL9W
	01ZPpo68i2fzgwh2gol7k6ulAgl2OzJXquKbARD1mKFJsQZpK6HhrR1fmTEj4zam
	kq9vlnXo6N7jMCXZ8c+5p1+jjURkdlpENfQA2fQwQjC/FveN5bNmwUq6Y+69x89m
	hqHhsQqjZseNjVQDzgBMbTItjpg6pb04SrXxDxj6jeeh7Rxmw/oh0awhiRNc10ab
	BQ1ie57V6dG4Q9neYJV5Gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1718208960; x=
	1718295360; bh=yUVDTGhYlj4eqvhNv3LbdHV4m8qId3DIMMR0yTJOkJM=; b=S
	eKc1UOEsuxbKs5p1pNZyWogTfSzgOJZJ71Q5mtbCU2TMzyo/dWvqV3Rl9xS6u8GC
	C5425Jun8AeSst+EzALpOs1tzruTIDjaRtdkuy9t39s6xsXhDnXajg8tdFgmYVGv
	uX/VZa8UzEn2kWq5lT72wwL7Od8hJExyVNnght/afOa0pmwUAO2XrywwCzdU3y79
	UnTBsX6pEk4IKYjKdk28x9L6W2HR1enb+jw+78oIt/GwSDyAnNIRSyK3SPul08T/
	NcGTcV7/8yxIQfDEOwbQMHdIfwZZba8uBAMQwDpsM6VhMFpJIk/S8jAqdCTM93oa
	fPGGTvnXwYjrdv9EAO7Sg==
X-ME-Sender: <xms:wMlpZsLmHbwWnqJItrS8_mzecoO2HBvq2RZh63jULV-5WRNy3fUD6Q>
    <xme:wMlpZsKo2zRcKOjj0kInY6pZw54fKFzLH6MRGVluyUbXozibnRNrEZ7ESlZUMjcMd
    2CCG1kpEoyLRqSz>
X-ME-Received: <xmr:wMlpZst-XaEx6T3_9vldXIxO1sKOM6-wo9GCUadknJnJtaOUPATRv3njzDI9j-nSFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfedugedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepteetjeduvedufeffudetgfelvddvgfdtleeu
    ieefgeduheekleekfeefvdeiheeknecuffhomhgrihhnpehgnhhufigvvggsrdhorhhgne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhn
    ugdrshgthhhusggvrhhtsehfrghsthhmrghilhdrfhhm
X-ME-Proxy: <xmx:wMlpZpbKwOZ08BqskffwmwnxcM1nT3UpBYG6y_tdlNGsluXEyBSbHg>
    <xmx:wMlpZjbKpIhBT3ZbYLk-I-iQbFnJ7TrABVSAeBrTHou9o6w1_BETUg>
    <xmx:wMlpZlA5hfo2pA7Zoql9AkCLNBQu4HqA9_ZN9k9xSX8GiFnObNcCXw>
    <xmx:wMlpZpbYlAQ7y6teoj0YhnaKtSUpZfEDLFTfjETy3taWpPawKMlPbQ>
    <xmx:wMlpZhBAHN2tYYlhy2wb1bV1LbccT8IgESlEbNSGwfJrEigMsJWxZQJs>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Jun 2024 12:15:58 -0400 (EDT)
Message-ID: <d5f61930-beb5-495b-9227-4531de98dae8@fastmail.fm>
Date: Wed, 12 Jun 2024 18:15:57 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
 <a5ab3ea8-f730-4087-a9ea-b3ac4c8e7919@fastmail.fm>
 <olaitdmh662osparvdobr267qgjitygkl7lt7zdiyyi6ee6jlc@xaashssdxwxm>
 <4e5a84ab-4aa5-4d8b-aa12-625082d92073@ddn.com>
 <hhkehi7qlcjulhyvtd5j25cl3xw764cjk7tbsakf3ueerdhp3j@6d2nka5oalzn>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US
In-Reply-To: <hhkehi7qlcjulhyvtd5j25cl3xw764cjk7tbsakf3ueerdhp3j@6d2nka5oalzn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/12/24 17:55, Kent Overstreet wrote:
> On Wed, Jun 12, 2024 at 03:40:14PM GMT, Bernd Schubert wrote:
>> On 6/12/24 16:19, Kent Overstreet wrote:
>>> On Wed, Jun 12, 2024 at 03:53:42PM GMT, Bernd Schubert wrote:
>>>> I will definitely look at it this week. Although I don't like the idea
>>>> to have a new kthread. We already have an application thread and have
>>>> the fuse server thread, why do we need another one?
>>>
>>> Ok, I hadn't found the fuse server thread - that should be fine.
>>>
>>>>>
>>>>> The next thing I was going to look at is how you guys are using splice,
>>>>> we want to get away from that too.
>>>>
>>>> Well, Ming Lei is working on that for ublk_drv and I guess that new approach
>>>> could be adapted as well onto the current way of io-uring.
>>>> It _probably_ wouldn't work with IORING_OP_READV/IORING_OP_WRITEV.
>>>>
>>>> https://lore.gnuweeb.org/io-uring/20240511001214.173711-6-ming.lei@redhat.com/T/
>>>>
>>>>>
>>>>> Brian was also saying the fuse virtio_fs code may be worth
>>>>> investigating, maybe that could be adapted?
>>>>
>>>> I need to check, but really, the majority of the new additions
>>>> is just to set up things, shutdown and to have sanity checks.
>>>> Request sending/completing to/from the ring is not that much new lines.
>>>
>>> What I'm wondering is how read/write requests are handled. Are the data
>>> payloads going in the same ringbuffer as the commands? That could work,
>>> if the ringbuffer is appropriately sized, but alignment is a an issue.
>>
>> That is exactly the big discussion Miklos and I have. Basically in my
>> series another buffer is vmalloced, mmaped and then assigned to ring entries.
>> Fuse meta headers and application payload goes into that buffer.
>> In both kernel/userspace directions. io-uring only allows 80B, so only a
>> really small request would fit into it.
> 
> Well, the generic ringbuffer would lift that restriction.

Yeah, kind of. Instead allocating the buffer in fuse, it would be now allocated
in that code. At least all that setup code would be moved out of fuse. I will
eventually come to your patches today.
Now we only need to convince Miklos that your ring is better ;)

> 
>> Legacy /dev/fuse has an alignment issue as payload follows directly as the fuse
>> header - intrinsically fixed in the ring patches.
> 
> *nod*
> 
> That's the big question, put the data inline (with potential alignment
> hassles) or manage (and map) a separate data structure.
> 
> Maybe padding could be inserted to solve alignment?

Right now I have this struct:

struct fuse_ring_req {
	union {
		/* The first 4K are command data */
		char ring_header[FUSE_RING_HEADER_BUF_SIZE];

		struct {
			uint64_t flags;

			/* enum fuse_ring_buf_cmd */
			uint32_t in_out_arg_len;
			uint32_t padding;

			/* kernel fills in, reads out */
			union {
				struct fuse_in_header in;
				struct fuse_out_header out;
			};
		};
	};

	char in_out_arg[];
};


Data go into in_out_arg, i.e. headers are padded by the union.
I actually wonder if FUSE_RING_HEADER_BUF_SIZE should be page size
and not a fixed 4K.

(I just see the stale comment 'enum fuse_ring_buf_cmd',
will remove it in the next series)


> 
> A separate data structure would only really be useful if it enabled zero
> copy, but that should probably be a secondary enhancement.
> 
>> I will now try without mmap and just provide a user buffer as pointer in the 80B
>> section.
>>
>>
>>>
>>> We just looked up the device DMA requirements and with modern NVME only
>>> 4 byte alignment is required, but the block layer likely isn't set up to
>>> handle that.
>>
>> I think existing fuse headers have and their data have a 4 byte alignment.
>> Maybe even 8 byte, I don't remember without looking through all request types.
>> If you try a simple O_DIRECT read/write to libfuse/example_passthrough_hp
>> without the ring patches it will fail because of alignment. Needs to be fixed
>> in legacy fuse and would also avoid compat issues we had in libfuse when the
>> kernel header was updated.
>>
>>>
>>> So - prearranged buffer? Or are you using splice to get pages that
>>> userspace has read into into the kernel pagecache?
>>
>> I didn't even try to use splice yet, because for the DDN (my employer) use case
>> we cannot use  zero copy, at least not without violating the rule that one
>> cannot access the application buffer in userspace.
> 
> DDN - lustre related?

I have bit of ancient Lustre background, also with DDN, then went to Fraunhofer
for FhGFS/BeeGFS (kind of competing with Lustre).
Back at DDN initially on IME (burst buffer) and now Infinia. Lustre is mostly HPC
only, Infina is kind of everything.



