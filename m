Return-Path: <io-uring+bounces-3677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 312B599D8F3
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 23:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65B0F1F2276B
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 21:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592431CC173;
	Mon, 14 Oct 2024 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="TjezW3Vf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iZZSWBk/"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B24314B965
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728941231; cv=none; b=oJn2TMLQOF+8pqtq4B+EXo+sPnyfPhRsg0OSOQdvMctg+68nRrq6Hir8lpRqpqXWNEVjkSCoW3Z8g5okNmkMniWzUYmdQmv2RhN2kBMFj80dGA0dQ3Brnln/W6Ga02YAVbMWopKuRaTGFta1LEgOvCKS6AQqbQ3IzE+QnCELJ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728941231; c=relaxed/simple;
	bh=GXIMDGw2pWCqusOa8npz/ITO1C2Hb7qbtMJZrY8GxJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MiLmwF18+oiwhPmUcgsFzrLFc2rxwTquZshQygWm99DBr/BnFIvkFkVM93kBtQiPYJkiNawdz0IuNbDSEC5w5m+gzpexpufHmRC7r+7hH5kqKLBhycxSM07Tt4zm/dg0WVJoBJAZH7CTs58upC8fAXxNbQnUV6t0jZMmtf7QX7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=TjezW3Vf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iZZSWBk/; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 67B051140091;
	Mon, 14 Oct 2024 17:27:07 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 14 Oct 2024 17:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1728941227;
	 x=1729027627; bh=JbgLUvScf/bmbRElzdZghx6U7izygd7Q/cS2vBEAJ10=; b=
	TjezW3VfA4I2CEEUg2SZZHH8650b1poWFydj4d2JA5kWcLUkG3xT5akTKkf+t8xX
	zdjc0gA7gIUCZ41dBFzo0CPXY0/m5IjQBCTU8igLcQNUC1DhnTujvlv/mrr8ouWV
	GJPfnkNR0Ud4f771i3N/bZui+8ZD8ktDVn37xDqlIcVZXrj5QXXGuSSvWjDg8/1S
	uQhqrmc3YM3a3J9hz0cCkc3VMoAeVCxLonPWrqdhTwTg1YjPCHHGCkH3vdmzsmLm
	X/oNFvY2WeLkCEcXgo+oQDZ/bokfBthcRiqTmSzuVVLkf9A9Su162KV/cMGVHgY4
	/aKo98C907kxYmx/YCY3oQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1728941227; x=
	1729027627; bh=JbgLUvScf/bmbRElzdZghx6U7izygd7Q/cS2vBEAJ10=; b=i
	ZZSWBk/VmeVHaeqFCHILF1vifBu2KnFJjWVFOGrIfKRYDSh9wcyUzexLIUhf3Hef
	3kVArYeMPnEDG/E5RAPNger2+ARB7yGxSik31elEYs9T7+NbX0uYy/eFCiE3ZndW
	e3Z9V/6fQwp1cxwAXSJ9MQs8XuR3mldHRdMQUBqfDZTrHeUB8oxCqjTtPvOhxgQd
	saFF/qiZ1bhez2Mu+prkJL45sZaiHNsGKBnh6k2irtQ40VxWKr2ATLjJB38GIL2e
	NucBSOIi9hAowzTnE4cnrckHtOr4e8HV+8y7ttwJ9J9ghDdaiIgZsewuqJYH6kdR
	b3mAeJUccmbRM6o1CyLJg==
X-ME-Sender: <xms:qowNZ2S-AGMdau7KXBmqOKXXexth0GgedelHz7WDnXAmsrBlDM5bDw>
    <xme:qowNZ7wEhVYzKcGpKqNJo3gLW0tXn5KmsEifM04UJzR2gd8fO7LraesZPhw2leNg5
    7rp7NmqfmCFkSy1>
X-ME-Received: <xmr:qowNZz1ElLVmLH-hdw0BlF2xoQFmCNwv_1bLiVoorfEbbxnRX9KtQULUswI3sjWMavXyHudUC144IU0YjDl6N-eyeqxJBeY6YMmHh3Mbvt5D5r6qhcOc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeghedgudeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusg
    gvrhhtsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeduleefvdduvedu
    veelgeelffffkedukeegveelgfekleeuvdehkeehheehkefhfeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghr
    thesfhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopehtohhmrd
    hlvghimhhinhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhn
    vghlrdgukhdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgt
    phhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:q4wNZyBIj5jG3_L_NPk-VEqwUQ0CTTsG_FVWNxNO1R4jw21SgH-Mfw>
    <xmx:q4wNZ_g5kilPnS54BSRcTmywVfPQTNXqNODjU1wjYB3Sit8MZNR-jA>
    <xmx:q4wNZ-oa3hTqx-XRu7C7RtelLHVt10nLACzUP44lkqkYI6NT8y3COw>
    <xmx:q4wNZyhDFZ281RWEaR1RxdoDJ5y-WbbPFg97yucJW3CWc9xtwoECzA>
    <xmx:q4wNZ_g1aZlVUAYPOW9MVZz8JAl2YsQS58kpgg81FeA1jGL3FZhyMF2J>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Oct 2024 17:27:05 -0400 (EDT)
Message-ID: <e30b5268-6958-410f-9647-f7760abdafc3@fastmail.fm>
Date: Mon, 14 Oct 2024 23:27:04 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
 <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm> <ZwyFke6PayyOznP_@fedora>
 <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
 <b284b6a2-8837-4779-b6a2-f31196aea7b9@fastmail.fm>
 <ab2d2f5c-0e76-44a2-8a7e-6f9edcfa5a92@gmail.com>
 <24ee0d07-47cc-4dcb-bdca-2123f38d7219@fastmail.fm>
 <74b0e140-f79d-4a89-a83a-77334f739c92@gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <74b0e140-f79d-4a89-a83a-77334f739c92@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/14/24 19:48, Pavel Begunkov wrote:
> On 10/14/24 16:21, Bernd Schubert wrote:
>> On 10/14/24 15:34, Pavel Begunkov wrote:
>>> On 10/14/24 13:47, Bernd Schubert wrote:
>>>> On 10/14/24 13:10, Miklos Szeredi wrote:
>>>>> On Mon, 14 Oct 2024 at 04:44, Ming Lei <tom.leiming@gmail.com> wrote:
>>>>>
>>>>>> It also depends on how fuse user code consumes the big CQE
>>>>>> payload, if
>>>>>> fuse header needs to keep in memory a bit long, you may have to
>>>>>> copy it
>>>>>> somewhere for post-processing since io_uring(kernel) needs CQE to be
>>>>>> returned back asap.
>>>>>
>>>>> Yes.
>>>>>
>>>>> I'm not quite sure how the libfuse interface will work to accommodate
>>>>> this.  Currently if the server needs to delay the processing of a
>>>>> request it would have to copy all arguments, since validity will not
>>>>> be guaranteed after the callback returns.  With the io_uring
>>>>> infrastructure the headers would need to be copied, but the data
>>>>> buffer would be per-request and would not need copying.  This is
>>>>> relaxing a requirement so existing servers would continue to work
>>>>> fine, but would not be able to take full advantage of the multi-buffer
>>>>> design.
>>>>>
>>>>> Bernd do you have an idea how this would work?
>>>>
>>>> I assume returning a CQE is io_uring_cq_advance()?
>>>
>>> Yes
>>>
>>>> In my current libfuse io_uring branch that only happens when
>>>> all CQEs have been processed. We could also easily switch to
>>>> io_uring_cqe_seen() to do it per CQE.
>>>
>>> Either that one.
>>>
>>>> I don't understand why we need to return CQEs asap, assuming CQ
>>>> ring size is the same as SQ ring size - why does it matter?
>>>
>>> The SQE is consumed once the request is issued, but nothing
>>> prevents the user to keep the QD larger than the SQ size,
>>> e.g. do M syscalls each ending N requests and then wait for
> 
> typo, Sending or queueing N requests. In other words it's
> perfectly legal to:
> 
> It's perfectly legal to:
> 
> ring = create_ring(nr_cqes=N);
> for (i = 0 .. M) {
>     for (i = 0..N)
>         prep_sqe();
>     submit_all_sqes();
> }
> wait(nr=N * M);
> 
> 
> With a caveat that the wait can't complete more than the
> CQ size, but you can even add a loop atop of the wait.
> 
> while (nr_inflight_cqes) {
>     wait(nr = min(CQ_size, nr_inflight_cqes);
>     process_cqes();
> }
> 
> Or do something more elaborate, often frameworks allow
> to push any number of requests not caring too much about
> exactly matching queue sizes apart from sizing them for
> performance reasons.
> 
>>> N * M completions.
>>>
>>
>> I need a bit help to understand this. Do you mean that in typical
>> io-uring usage SQEs get submitted, already released in kernel
> 
> Typical or not, but the number of requests in flight is not
> limited by the size of the SQ, it only limits how many
> requests you can queue per syscall, i.e. per io_uring_submit().
> 
> 
>> and then users submit even more SQEs? And that creates a
>> kernel queue depth for completion?
>> I guess as long as libfuse does not expose the ring we don't have
>> that issue. But then yeah, exposing the ring to fuse-server/daemon
>> is planned...
> 
> Could be, for example you don't need to care about overflows
> at all if the CQ size is always larger than the number of
> requests in flight. Perhaps the simplest example:
> 
> prep_requests(nr=N);
> wait_cq(nr=N);
> process_cqes(nr=N);


With only libfuse as ring user it is more like 

prep_requests(nr=N);
wait_cq(1); ==> we must not wait for more than 1 as more might never arrive
io_uring_for_each_cqe {
}
	
I still think no issue with libfuse (or any other fuse lib) as single ring-user,
but if the same ring then gets used for more all of that might come up.

@Miklos maybe we avoid using large CQEs/SQEs and instead set up our own
separate buffer for FUSE headers?

Thanks,
Bernd



