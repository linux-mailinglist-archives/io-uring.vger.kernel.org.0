Return-Path: <io-uring+bounces-3606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E02A099AC5C
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 21:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FFE428BBDC
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 19:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889851D0B9E;
	Fri, 11 Oct 2024 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="gAqvRk9D";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Rj7HDllw"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000371D0BB9
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 19:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728673420; cv=none; b=kabm1IVsIUryicBaXaXxe3z2XPeDkWmumWMOvQH+Gs6mT3vn/kMhcGpCfqzMeLYCUhjtusQYG5/ukfazTVGcqACt79i7akHvS9X9YDd3UwGziqDlR6Dwnw7E1T8/SCloG8i8TYKCGhkLak1U1uAvJb8XwaEuGVrPW71bPZROcZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728673420; c=relaxed/simple;
	bh=Y97XW7/qS+6jhMSzEgAAsFAwweNo5a6DwpnHMJT114E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwavThkaH/e2N12sFeiO/Ih4txq3ywet1EY2UAPPFX3i9oy+klWMjlmnfPWVT+OE5yfRuYOp++SjcFnT9OBGB075KtT8QOjBsDly5FlkeChjL6BK+DnobcFfAL447Zt1Xa+XgLNGG2gvMDtd7i1XxqokzEidK4x7hCRu7S+iQC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=gAqvRk9D; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Rj7HDllw; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 143C311401C3;
	Fri, 11 Oct 2024 15:03:37 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 11 Oct 2024 15:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1728673417;
	 x=1728759817; bh=e2ytkKs+PWBvMCc9fcft/6PzEHM59Ryg/XRZb5dGoS4=; b=
	gAqvRk9DeVmUBck8nu6dpOaciQpZl2CKQtFI3Jpt4FriMSE7EeoZ1thpn7MZQxXG
	Z3grsONLW4YMWrZYqwWiOT9gD1Fb4/aAtMOq6Zjtv/BS6ad2l1wU2HkPARqc+ycC
	Mu0uoXTY+1tFVAD1yWOPbBweCO7vKZ/BXmZGuzXYdBogaOmMBfcd2x9tKh4Hpt4I
	6YZz3QA1tGDq4EPpJgsx+R0UkK4kkow/AdYVQsaoPy3YWubtr5aVOVO34assAaOn
	IhZJZDjGxdKlYEegd9qNwZLXRLlkbled4kf23zxBVsqLEwfQ3HFVlMroqrKxYUcq
	xYbg2XpQ9W2ua9qCw6ythQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1728673417; x=
	1728759817; bh=e2ytkKs+PWBvMCc9fcft/6PzEHM59Ryg/XRZb5dGoS4=; b=R
	j7HDllwOBDsPC6rLomFkN/hLIw5glO2f3X16/4MWQCpjvVUasgQyAtdgyYWEtpR5
	Zg3ZU0xkW03Ft8OoM+n4LAzBUNfQu8pc4Cti4htZn8uCApYpZyBm6HfoeBncYbOF
	xE/DpcBDZGB+boLwUQHTFPH9iKPTVG40NyLdOY/AvhHgrMIGwfpxYyhkY7dQfpEK
	e/337d4uIg5PLycZLB9vGzgbGRnrfz9DQu0wWhhOo0b+9b6CxWBNTZ8gdPbQDjr4
	mD6IUsZVkTyaIBBn4poLyaF//Dhuh4q35uUQ5rwoFCCKztki8IuJJqq7ySAQFgws
	OXjwXfMKyqB3IyH4+MPCw==
X-ME-Sender: <xms:iHYJZ-7SU2b07VG8avVdNiUWFDFV6mEYqJ-H5jMEIcadkcChxSD1cg>
    <xme:iHYJZ36_kAABoETbA9XBgZ4eD2NJoWbYAgOwPXg8cVW9r-Bv4tnh2vAdrVu_kjcHQ
    2TJ_iPuPG94VJyJ>
X-ME-Received: <xmr:iHYJZ9cUNQ2Pp_rhXw4SMIBySrdkSxqvIcOSHdQtcqfzJaeJF0IqQ646BUzfO-1jKC8eacC6rrHI1f8_MSukZLPQMjgCBi9cYUCKdqflD4T0MGq4t4FG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdefkedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusg
    gvrhhtsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeffjeevfeefjefg
    hfefhfeiueffffetledtgffhhfdttdefueevledvleetfeevtdenucffohhmrghinhepkh
    gvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdrfhhmpdhnsg
    gprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrgigsohgv
    sehkvghrnhgvlhdrughkpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgt
    ohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhope
    hjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghf
    sehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:iHYJZ7J1aj05l7hkjrgpkpyneGQZ_dyXMpEuf4fmLDCJ8vH0cWx_2w>
    <xmx:iHYJZyLNbeQyhuHFlTSNpMtWNA1yYAy_lnj9QCpj3aJxXSy6NjyE2Q>
    <xmx:iHYJZ8x_SwEqGnmT_0s_DKNAkAOv3VlYYYZzFiUAfhR4ma2XccTVvA>
    <xmx:iHYJZ2JDpIyBvck8yEriZ2GBbs3YdUkD99ftGZQtIT7vYpt1PbGAVA>
    <xmx:iXYJZ6_PMyIu68lfdKDsSCSar2TRJCCrxEr7rZ3OeCVz2nVWE3l1blgG>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Oct 2024 15:03:35 -0400 (EDT)
Message-ID: <69b6d3e2-28a1-4055-9b4f-b34d11f77dfc@fastmail.fm>
Date: Fri, 11 Oct 2024 21:03:34 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <f83d5370-f026-4654-810a-199fb3e01038@kernel.dk>
 <aa99c09f-fa6f-4662-9da4-62a7d848d8b9@fastmail.fm>
 <3766a6e2-c9da-4643-8333-4f152d955609@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <3766a6e2-c9da-4643-8333-4f152d955609@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/11/24 20:39, Jens Axboe wrote:
> On 10/11/24 12:35 PM, Bernd Schubert wrote:
>> On 10/11/24 19:57, Jens Axboe wrote:
>>> On 10/10/24 2:56 PM, Bernd Schubert wrote:
>>>> Hello,
>>>>
>>>> as discussed during LPC, we would like to have large CQE sizes, at least
>>>> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
>>>>
>>>> Pavel said that this should be ok, but it would be better to have the CQE
>>>> size as function argument. 
>>>> Could you give me some hints how this should look like and especially how
>>>> we are going to communicate the CQE size to the kernel? I guess just adding
>>>> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.
>>>
>>> Not Pavel and unfortunately I could not be at that LPC discussion, but
>>> yeah I don't see why not just adding the necessary SETUP arg for this
>>> would not be the way to go. As long as they are power-of-2, then all
>>> it'll impact on both the kernel and liburing side is what size shift to
>>> use when iterating CQEs.
>>
>> Thanks, Pavel also wanted power-of-2, although 512 is a bit much for fuse. 
>> Well, maybe 256 will be sufficient. Going to look into adding that parameter
>> during the next days.
> 
> We really have to keep it pow-of-2 just to avoid convoluting the logic
> (and overhead) of iterating the CQ ring and CQEs. You can search for
> IORING_SETUP_CQE32 in the kernel to see how it's just a shift, and ditto
> on the liburing side.

Thanks, going to look into it.

> 
> Curious, what's all the space needed for?

The basic fuse header: struct fuse_in_header -> current 40B
and per request header headers, I think current max is 64.

And then some extra compat space for both, so that they can be safely
extended in the future (which is currently an issue).


> 
>>> Since this obviously means larger CQ rings, one nice side effect is that
>>> since 6.10 we don't need contig pages to map any of the rings. So should
>>> work just fine regardless of memory fragmentation, where previously that
>>> would've been a concern.
>>>
>>
>> Out of interest, what is the change? Up to fuse-io-uring rfc2 I was
>> vmalloced buffers for fuse that got mmaped - was working fine. Miklos just
>> wants to avoid that kernel allocates large chunks of memory on behalf of
>> users.
> 
> It was the change that got rid of remap_pfn_range() for mapping, and
> switched to vm_insert_page(s) instead. Memory overhead should generally
> not be too bad, it's all about sizing the rings appropriately. The much
> bigger concern is needing contig memory, as that can become scarce after
> longer uptimes, even with plenty of memory free. This is particularly
> important if you need 512b CQEs, obviously.
> 

For sure, I was just curious what you had changed. I think I had looked into
that io-uring code around 2 years ago.  Going to look into the update
io-uring code, thanks for the hint.
For fuse I was just using remap_vmalloc_range().

https://lore.kernel.org/all/20240529-fuse-uring-for-6-9-rfc2-out-v1-7-d149476b1d65@ddn.com/


Thanks,
Bernd

