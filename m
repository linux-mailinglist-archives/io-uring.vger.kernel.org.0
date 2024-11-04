Return-Path: <io-uring+bounces-4404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB5589BB5A0
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 14:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BF0CB212E0
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 13:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E666FB9;
	Mon,  4 Nov 2024 13:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnandrewmarshall.com header.i=@johnandrewmarshall.com header.b="bz6NmrpI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NhXk80lE"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26221F942;
	Mon,  4 Nov 2024 13:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726283; cv=none; b=HjANsXmjF9Q1SGjuMB3nZffetQGp5exdNyUSydnvxJuh8pLmK41EW0o2/2PSn7Qnk2CClKuhvzf6SVfykIIncYpa3XJYldwSUnOKMn0nBygZaMga/706UYB3Ry6mLoSWtLkUVfZ0+Sitn9h6kK03ijc5YuoYtGXoDyIlTmrRP/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726283; c=relaxed/simple;
	bh=qBJ8/c8eXDIbe5Ol2OUiUgZPgnkEkxCcRJARCDXt1jE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=TRsZ9JEKXkvhIqufxFYwOqObF8mln3y1jpu3T1sF5I+ZsEhnw0M+yLNybdTSzv4cv1iljHe6SSuxsOhW0LKIcUNFPatdtoHqjFgi5rShFhoRbJvnu3CL3W7VF3iQWTyPjSBGvBex7ubCHZ1nhzXS8L/5GoFSRYv/DYqw6Nts5A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=johnandrewmarshall.com; spf=pass smtp.mailfrom=johnandrewmarshall.com; dkim=pass (2048-bit key) header.d=johnandrewmarshall.com header.i=@johnandrewmarshall.com header.b=bz6NmrpI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NhXk80lE; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=johnandrewmarshall.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnandrewmarshall.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id E2C6F11400BA;
	Mon,  4 Nov 2024 08:17:59 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Mon, 04 Nov 2024 08:18:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	johnandrewmarshall.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1730726279; x=1730812679; bh=3aowMq8Y+j
	s5EeqEBm7W0lhYsUxHP9J7b2gWhO7xpjk=; b=bz6NmrpILCxy63K3X8YlThOCn6
	/iFy38QitcsnWKIlBZ9mva1GwXpnk5UL6sz76vJStKzzOwLfWextvC7sxcaPj9zR
	nZnX2AGZyNBxFgPpuGSPCUHO9ObdfAK5hyU0HT2Iihmgf9kVM9F4bDz3R/KHkKVi
	jmIPSiiBS/h8OucYVe+1ZrQAIG0bEkOmEjV6Kw34i1gCDC49uwP1oISLfPDWokVy
	HZmFkcPcLt0pENLYiqdeWp+nlzXHVB3F6fN8iifeAUGhW/7WzhVUdKbS3Gmn0P+I
	EJMk5HNL3xNPIzpMULKK+Gl8VsCxbGIt76x2bT7ZyDmM5xVoN33slNRSnM1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1730726279; x=
	1730812679; bh=3aowMq8Y+js5EeqEBm7W0lhYsUxHP9J7b2gWhO7xpjk=; b=N
	hXk80lENe09YpqlREb0W1w61ximUsqQdJDwbIgsLPyjX4aM3cVJx5620a27osWiF
	YGFKQTAihcs0ztcUR0FCSptptkMNoiK9wKXNTsPlfJWAvifw25yPT4fkEL/vYGcw
	Z++2EbsAOBxTDEZVmUw4wMjfBJlVKy0R19zM9vCO/Sm4P+8O/K7kpi5MPHyTgwJS
	1+ltmaoFw99JYu+DAbZ+sfkzNITNwgexruIp78ptL2/VpNOESgkeINbHk3X4/NCw
	g8plmMEL55GIbJsnZ0JrCU0GBcy847LCq7fBMccj2U/fTDNOOyK/Fwvq2XRQFBvl
	WXVQMqG1vvvM/oPmgUdjw==
X-ME-Sender: <xms:h8koZ31gBb6zNgB_3QmgbM9itv1yNS9xffnyn6Xz4XEgOCK5MFxPTQ>
    <xme:h8koZ2F_LF53kgBPS5omXchTUCDa5-MXKoAJ_41bEu4WeEByw-Tz3TxCU2kApdqai
    tox4i-eDAOaooJO_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeliedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedftehnughrvgifucforghrshhhrghllhdfuceorghnughrvgifsehjoh
    hhnhgrnhgurhgvfihmrghrshhhrghllhdrtghomheqnecuggftrfgrthhtvghrnhephfek
    uddtieevvdeuudduheevjeevueeigfefieevhfelteegteetgfdvkeefleefnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvgifsehj
    ohhhnhgrnhgurhgvfihmrghrshhhrghllhdrtghomhdpnhgspghrtghpthhtohephedpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdp
    rhgtphhtthhopehksghushgthheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepghhrvg
    hgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepihhoqdhu
    rhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhtrggslhgvse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:h8koZ366L5a0hegn880YtRtOhEI4ixu7x6FpiKV_atTDSfyX9RcBpw>
    <xmx:h8koZ80H60g6OY2780eHLl1AJYx6b3WFkAIEpBs89o1eAsWY7VF8Zg>
    <xmx:h8koZ6FEVGh1w3ZriFh7oywtNfwSVbwErpdHb9vQQgefjjFaS0Xl0w>
    <xmx:h8koZ9963IQubaOTg1GSkEreN22Bf1-R9JDn2GlAt6Yx-x34_7i7cQ>
    <xmx:h8koZ2iBO7pXh6LvjRqNHOP-sja7eAlJZrX-c37WrYVcLjdPc4Dmn-Nt>
Feedback-ID: i5df14252:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 63F2FB00068; Mon,  4 Nov 2024 08:17:59 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 04 Nov 2024 08:17:39 -0500
From: "Andrew Marshall" <andrew@johnandrewmarshall.com>
To: "Jens Axboe" <axboe@kernel.dk>, "Keith Busch" <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 stable <stable@vger.kernel.org>
Message-Id: <23b02882-6f23-4b19-b39d-fd4ef09429ad@app.fastmail.com>
In-Reply-To: <98907a37-81dd-463e-b5ef-9190bf0f33be@app.fastmail.com>
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
 <ZygO7O1Pm5lYbNkP@kbusch-mbp>
 <25c4c665-1a33-456c-93c7-8b7b56c0e6db@kernel.dk>
 <c34e6c38-ca47-439a-baf1-3489c05a65a8@kernel.dk>
 <98907a37-81dd-463e-b5ef-9190bf0f33be@app.fastmail.com>
Subject: Re: Stable backport (was "Re: PROBLEM: io_uring hang causing uninterruptible
 sleep state on 6.6.59")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 3, 2024, at 23:25, Andrew Marshall wrote:
> On Sun, Nov 3, 2024, at 21:38, Jens Axboe wrote:
>> On 11/3/24 5:06 PM, Jens Axboe wrote:
>>> On 11/3/24 5:01 PM, Keith Busch wrote:
>>>> On Sun, Nov 03, 2024 at 04:53:27PM -0700, Jens Axboe wrote:
>>>>> On 11/3/24 4:47 PM, Andrew Marshall wrote:
>>>>>> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the like=
ly
>>>>>> problematic commit simply by browsing git log. As indicated above;
>>>>>> reverting that atop 6.6.59 results in success. Since it is passin=
g on
>>>>>> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
>>>>>> other semantic merge conflict. Unfortunately I do not have a comp=
act,
>>>>>> minimal reproducer, but can provide my large one (it is testing a
>>>>>> larger build process in a VM) if needed?there are some additional
>>>>>> details in the above-linked downstream bug report, though. I hope=
 that
>>>>>> having identified the problematic commit is enough for someone wi=
th
>>>>>> more context to go off of. Happy to provide more information if
>>>>>> needed.
>>>>>
>>>>> Don't worry about not having a reproducer, having the backport com=
mit
>>>>> pin pointed will do just fine. I'll take a look at this.
>>>>
>>>> I think stable is missing:
>>>>
>>>>   6b231248e97fc3 ("io_uring: consolidate overflow flushing")
>>>=20
>>> I think you need to go back further than that, this one already
>>> unconditionally holds ->uring_lock around overflow flushing...
>>
>> Took a look, it's this one:
>>
>> commit 8d09a88ef9d3cb7d21d45c39b7b7c31298d23998
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Wed Apr 10 02:26:54 2024 +0100
>>
>>     io_uring: always lock __io_cqring_overflow_flush
>>
>> Greg/stable, can you pick this one for 6.6-stable? It picks
>> cleanly.
>>
>> For 6.1, which is the other stable of that age that has the backport,
>> the attached patch will do the trick.
>>
>> With that, I believe it should be sorted. Hopefully that can make
>> 6.6.60 and 6.1.116.
>>
>> --=20
>> Jens Axboe
>> Attachments:
>> * 0001-io_uring-always-lock-__io_cqring_overflow_flush.patch
>
> Cherry-picking 6b231248e97fc3 onto 6.6.59, I can confirm it passes my=20
> reproducer (run a few times). Your first quick patch also passed, for=20
> what it=E2=80=99s worth. Thanks for the quick responses!

Correction: I cherry-picked and tested 8d09a88ef9d3cb7d21d45c39b7b7c3129=
8d23998 (which was the change you identified), not 6b231248e97fc3. Apolo=
gies for any confusion.

