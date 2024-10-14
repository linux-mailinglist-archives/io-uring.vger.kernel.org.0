Return-Path: <io-uring+bounces-3662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4DD99D22C
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:23:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AEB71C235AB
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 15:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC741C6F70;
	Mon, 14 Oct 2024 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="MUR5WlGK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GE2BUbLL"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7CA1BC063
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919273; cv=none; b=c+FWbD5QORJPXmMrWBtOCb9UGmF/tD7zhnz4gs8YQpBKSMATkuJIw9favpRSPcptaFMShSj7YsgjbtpZSjgnP0QaVFqQgA3rgOzz3aQt/RepxApd+DF4bI6wGgjhh3rA1W/v8kuXmbiTXyLYXx1G95PLVAAQAnf00xnfCh6t0No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919273; c=relaxed/simple;
	bh=GuboxPJOV+Ne7Vl9D8D+c3bzn/5O63yQlpoJWWJDFV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=slzfKNnW9HYteZh1G30U+qBU4BPgDeh9KfCVxqDlBgYzxLZBLb2VZGSbXeCm7YJhGUZ2QFVNbnapFwxXP+shd0RGEl5Huqj2EOYImm1tIpdwnrWCqVIuEZNv26GbR1EYU+hQ0grJ0ITQzvdWQ3vPdeM+7HpbQwQAPVg3wcNBZyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=MUR5WlGK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GE2BUbLL; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6E85F1140173;
	Mon, 14 Oct 2024 11:21:10 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 14 Oct 2024 11:21:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1728919270;
	 x=1729005670; bh=qA5PhOYP1HKyXVhxg6KqGMCv51KsZlHfdaXFW8wEtw8=; b=
	MUR5WlGK5ckY0swI0M0CTQjMajXPOQVkORP7K/EJ0X7BVMCKe7H6oK1iTqi8ZNA8
	4E2SMA7jz1iXkSbdjjHr77stQkEa6c4WTA3NQgr4k6ulgp/6nf5fh/Yfso3ZxoFJ
	Sni7EkWj9oYNiaUApf+zGL559Kdj7ViY4w+pFdH+raXcoRv6LPPdwnM5/jbZspD1
	aF8HzqTLDMc1HZugkCDu521b8LShSdyF+zvfNHrIdUSHbqyF+HVnwGkKeBtemVRY
	WKurBpdEQFkrGKsV0jL1JrsBG6wMLZd43wi/qloo/Ca3iyx42rQWA44HvYynwPfs
	79Ctfk0IZY92XaoOyjk+bA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1728919270; x=
	1729005670; bh=qA5PhOYP1HKyXVhxg6KqGMCv51KsZlHfdaXFW8wEtw8=; b=G
	E2BUbLLsycWzYJ/R+FiAwM3StMFPS2YxBALNSVog27UL2MeIQREzMtGr1WVHjcWp
	WJyELTg4nWbeSMGbUeendeVGeF6Vdr9Bl3rhp4tJKf+D1HITZeYTffVacq1f/MTZ
	zpy7CNss34gMitDUK89iy4fdQHsjx+ntl/B+Yal6UKAY8aE3UGWPwoY8KXSG8nWS
	yPgnMTrrHldb/Nk7w3daK9uGedsYetyskFWGgJVCQ6aQ1jG7W7mwSaKlaWKM5y19
	+vbBIpALARjOiFNxy4WqSzbjUSxc0ed5itBYqlIWHqyGW/tkFpmNqkm/hcH0Xgiz
	5UPK5nNuhRVsmX0QUdLIQ==
X-ME-Sender: <xms:5TYNZ9Zcu_ShwOhUwQ2b6mtZS9umf7Tll5SEo-lLSUQ7vlQ419ZcVg>
    <xme:5TYNZ0bnbPqcOJO-fF_YwoFAl-Iv_8ajWqq74jRyrIgpzt9r__6PAGVrLU2ssvP9w
    fhIzOV9q36ol-fy>
X-ME-Received: <xmr:5TYNZ_-0D1gJrdcJbhffEiphFh4UVl0wTJlYUlS9qyZ9sf4UUtG6UQ-l_vOX_HYqhLZPkarI6hbNKpq0liFT0vP1KSMkk0atE4nbRYDpYejbQWkMNiwR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeghedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudev
    leegleffffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgt
    phhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohepthhomhdrlh
    gvihhmihhnghesghhmrghilhdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgv
    lhdrughkpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:5TYNZ7qWRN2x1NPL3VlZUhy0ZtW93JsZZ-M2b3zNJ4Tbuibp62fHmA>
    <xmx:5TYNZ4oNW1FEHce2rboL1NrgmLyFb-kuPEr9uVWsIs2NRVHiFf9Tcg>
    <xmx:5TYNZxRcDRqHdJBRqB7ZJCVPfiGiVDy4CK5DZCBM_8RNnmA_EsQe3Q>
    <xmx:5TYNZwq-d8XVv2d5d_Bao5lLlSWP_g4szpMkSeGJUpopCiqdnNUFKQ>
    <xmx:5jYNZwLPlm1DHDlH6p-lflYcX1rbGH6zqgqz48IMz6u23wwHnkQeZfha>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Oct 2024 11:21:08 -0400 (EDT)
Message-ID: <24ee0d07-47cc-4dcb-bdca-2123f38d7219@fastmail.fm>
Date: Mon, 14 Oct 2024 17:21:07 +0200
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
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <ab2d2f5c-0e76-44a2-8a7e-6f9edcfa5a92@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/14/24 15:34, Pavel Begunkov wrote:
> On 10/14/24 13:47, Bernd Schubert wrote:
>> On 10/14/24 13:10, Miklos Szeredi wrote:
>>> On Mon, 14 Oct 2024 at 04:44, Ming Lei <tom.leiming@gmail.com> wrote:
>>>
>>>> It also depends on how fuse user code consumes the big CQE payload, if
>>>> fuse header needs to keep in memory a bit long, you may have to copy it
>>>> somewhere for post-processing since io_uring(kernel) needs CQE to be
>>>> returned back asap.
>>>
>>> Yes.
>>>
>>> I'm not quite sure how the libfuse interface will work to accommodate
>>> this.  Currently if the server needs to delay the processing of a
>>> request it would have to copy all arguments, since validity will not
>>> be guaranteed after the callback returns.  With the io_uring
>>> infrastructure the headers would need to be copied, but the data
>>> buffer would be per-request and would not need copying.  This is
>>> relaxing a requirement so existing servers would continue to work
>>> fine, but would not be able to take full advantage of the multi-buffer
>>> design.
>>>
>>> Bernd do you have an idea how this would work?
>>
>> I assume returning a CQE is io_uring_cq_advance()?
> 
> Yes
> 
>> In my current libfuse io_uring branch that only happens when
>> all CQEs have been processed. We could also easily switch to
>> io_uring_cqe_seen() to do it per CQE.
> 
> Either that one.
> 
>> I don't understand why we need to return CQEs asap, assuming CQ
>> ring size is the same as SQ ring size - why does it matter?
> 
> The SQE is consumed once the request is issued, but nothing
> prevents the user to keep the QD larger than the SQ size,
> e.g. do M syscalls each ending N requests and then wait for
> N * M completions.
> 

I need a bit help to understand this. Do you mean that in typical
io-uring usage SQEs get submitted, already released in kernel
and then users submit even more SQEs? And that creates a
kernel queue depth for completion?
I guess as long as libfuse does not expose the ring we don't have
that issue. But then yeah, exposing the ring to fuse-server/daemon
is planned...



>> If we indeed need to return the CQE before processing the request,
>> it indeed would be better to have a 2nd memory buffer associated with
>> the fuse request.
> 
> With that said, the usual problem is to size the CQ so that it
> (almost) never overflows, otherwise it hurts performance. With
> DEFER_TASKRUN you can delay returning CQEs to the kernel until
> the next time you wait for completions, i.e. do io_uring waiting
> syscall. Without the flag, CQEs may come asynchronously to the
> user, so need a bit more consideration.
> 

Current libfuse code has it disabled IORING_SETUP_SINGLE_ISSUER,
IORING_SETUP_DEFER_TASKRUN, IORING_SETUP_TASKRUN_FLAG and
IORING_SETUP_COOP_TASKRUN as these are somehow slowing down
things.
Not sure if this thread is optimal to discuss this. I would
also first like to sort out all the other design topics before
going into fine-tuning...


Thanks,
Bernd


