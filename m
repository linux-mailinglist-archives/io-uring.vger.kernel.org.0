Return-Path: <io-uring+bounces-4395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 630F89BABD0
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 05:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6669A1C2087F
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 04:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2515116EB76;
	Mon,  4 Nov 2024 04:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnandrewmarshall.com header.i=@johnandrewmarshall.com header.b="brbyYgra";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VvdNy5IR"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43A420ED;
	Mon,  4 Nov 2024 04:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694378; cv=none; b=Ux9fIqu8Af1LmcoTAjORP4qUZB0TO6j565dxPZi3hHgVHevFCBH6bWcHiZDb1zmaqizmrjxlyMfTzG7CFU9qMSaYIOAFvuO8TFF4OHEnEDu6+xloQ/U202YRd91Amkond1I+iRNgOElc6BVSA3HPcUYuDqLFaSNjAbTg47VYxTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694378; c=relaxed/simple;
	bh=mEnfDO2HJBpnOg4XxLOZrDqK5ORlbSKjA+TGiG2pjxw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=PxtpgOmstGZA1b8QHHOxMkgUCxbpxude5foZirpqfFBYCTldVTVcDdSRJgsEh1aydJ3DAfc0ydXbEYajiAaQXJei1zSDX8n36iNsprrkkLumc9R9t++q3Li/EKdUAj09cMbFqI1HI2+D69IRN5VrhbRWJunXfKh954svJkSti2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=johnandrewmarshall.com; spf=pass smtp.mailfrom=johnandrewmarshall.com; dkim=pass (2048-bit key) header.d=johnandrewmarshall.com header.i=@johnandrewmarshall.com header.b=brbyYgra; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VvdNy5IR; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=johnandrewmarshall.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnandrewmarshall.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BC1DF1140065;
	Sun,  3 Nov 2024 23:26:14 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Sun, 03 Nov 2024 23:26:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	johnandrewmarshall.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1730694374; x=1730780774; bh=/FIBjVgGqk
	VIrB9n+QQfMcN+1fXozGhyC1gKvO3XoI8=; b=brbyYgraOsa8xeHKobq8WKyPov
	hwZ4XzYo5tCNBmNHnUwd4KPv3KcKPGHIAAbvwtWf4bKNgnE8LDXXGCmpS1/8h+lR
	1DQ+Cbbq8hFz2MmYB3lswcXv8EsOXz64E948mCHYFsPMABQ+bOyjseHMErwOKvTA
	A6l9UTRyVekHFjjFQIhw+yt/4w6ErnjtH/RcqCr6QjFm3vfxW+dUqUoc7nhBtEFQ
	Ba9y75G9xN9AIVZ3T6IYYtDvANqntpLDrxRPqSp7kkei+2ugDjy3TVEgnXvpbP4B
	WypeUGlBaUvI/Mk+9AvO5Vj0T+6KbPjHSvnCGZdKt0FaGq7flxpsUmuyL41g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1730694374; x=
	1730780774; bh=/FIBjVgGqkVIrB9n+QQfMcN+1fXozGhyC1gKvO3XoI8=; b=V
	vdNy5IRpHPbBINyDgW/unEQffZAnzvV1+8ZZGSXrH2WG29I+iMljnKKRUlM++1D2
	K50S7rvv+iGAis3f7SXJpugawJ0JQWdyVzDowdjGhst2BVuYWwA6h2Ib5BK8A4Qq
	Dl7uyNpICRrpRK4Ce1TOOaCnbyYTWT4QI8eClJ8CMqTuOQxkePR+HjZ2sKNqj5EJ
	PXC9bEYzsBnzZ/I60PzpQd3jFiOHRnENr+8eA9jqLC+DDHlX8m9SfCueGYVqAvMj
	spOjI7rdQpeKa5jKoYTRoZEnnTW2MAu0HcIwYP0BCRHbwQbRWyBPkD4vZ+ofRlVY
	rJH5gb1iQCEoaakLXpjkQ==
X-ME-Sender: <xms:5kwoZ3bJZJLPiG8nZvlW0lql8V1oKIJh0IAhafSIrTQbxgI6jlKrxw>
    <xme:5kwoZ2bnpzaJysJLsqaoxWpSilqIGN2C1plevwop9_bNUi-yZa0ZdAk9LWESUcdtf
    W2HBpio6ZmM5HWWPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdelhedgjeduucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:5kwoZ5-Cy9w-Md-rN4U5qsoUyJPC2VYp8dJ3gAHo5-Iz4ScHXyITmw>
    <xmx:5kwoZ9rjeGsHgOHs7a_uQwDQ4BVxhbUHFkzUnh6xFSxkNwRKQ0UasQ>
    <xmx:5kwoZyqkarRx76JmCcNx12o312EL-1mYLTTsEIOQGZgeW4DXqh4-zw>
    <xmx:5kwoZzQ-hOQ5XzjCAHX-El7UerOyAglYn3RkynYA2dGdkuNeIO6-3w>
    <xmx:5kwoZ7mf38-AUGX1ECL5wlJSYkOIQ45WTKBmV9YoF2-m4EE98FXGY8G3>
Feedback-ID: i5df14252:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 76B8CB00068; Sun,  3 Nov 2024 23:26:14 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 03 Nov 2024 23:25:53 -0500
From: "Andrew Marshall" <andrew@johnandrewmarshall.com>
To: "Jens Axboe" <axboe@kernel.dk>, "Keith Busch" <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 stable <stable@vger.kernel.org>
Message-Id: <98907a37-81dd-463e-b5ef-9190bf0f33be@app.fastmail.com>
In-Reply-To: <c34e6c38-ca47-439a-baf1-3489c05a65a8@kernel.dk>
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
 <ZygO7O1Pm5lYbNkP@kbusch-mbp>
 <25c4c665-1a33-456c-93c7-8b7b56c0e6db@kernel.dk>
 <c34e6c38-ca47-439a-baf1-3489c05a65a8@kernel.dk>
Subject: Re: Stable backport (was "Re: PROBLEM: io_uring hang causing uninterruptible
 sleep state on 6.6.59")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 3, 2024, at 21:38, Jens Axboe wrote:
> On 11/3/24 5:06 PM, Jens Axboe wrote:
>> On 11/3/24 5:01 PM, Keith Busch wrote:
>>> On Sun, Nov 03, 2024 at 04:53:27PM -0700, Jens Axboe wrote:
>>>> On 11/3/24 4:47 PM, Andrew Marshall wrote:
>>>>> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
>>>>> problematic commit simply by browsing git log. As indicated above;
>>>>> reverting that atop 6.6.59 results in success. Since it is passing=
 on
>>>>> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
>>>>> other semantic merge conflict. Unfortunately I do not have a compa=
ct,
>>>>> minimal reproducer, but can provide my large one (it is testing a
>>>>> larger build process in a VM) if needed?there are some additional
>>>>> details in the above-linked downstream bug report, though. I hope =
that
>>>>> having identified the problematic commit is enough for someone with
>>>>> more context to go off of. Happy to provide more information if
>>>>> needed.
>>>>
>>>> Don't worry about not having a reproducer, having the backport comm=
it
>>>> pin pointed will do just fine. I'll take a look at this.
>>>
>>> I think stable is missing:
>>>
>>>   6b231248e97fc3 ("io_uring: consolidate overflow flushing")
>>=20
>> I think you need to go back further than that, this one already
>> unconditionally holds ->uring_lock around overflow flushing...
>
> Took a look, it's this one:
>
> commit 8d09a88ef9d3cb7d21d45c39b7b7c31298d23998
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Wed Apr 10 02:26:54 2024 +0100
>
>     io_uring: always lock __io_cqring_overflow_flush
>
> Greg/stable, can you pick this one for 6.6-stable? It picks
> cleanly.
>
> For 6.1, which is the other stable of that age that has the backport,
> the attached patch will do the trick.
>
> With that, I believe it should be sorted. Hopefully that can make
> 6.6.60 and 6.1.116.
>
> --=20
> Jens Axboe
> Attachments:
> * 0001-io_uring-always-lock-__io_cqring_overflow_flush.patch

Cherry-picking 6b231248e97fc3 onto 6.6.59, I can confirm it passes my re=
producer (run a few times). Your first quick patch also passed, for what=
 it=E2=80=99s worth. Thanks for the quick responses!

