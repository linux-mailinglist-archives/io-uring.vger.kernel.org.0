Return-Path: <io-uring+bounces-3720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2AB39A08C2
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 13:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78E2E1F24C0E
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 11:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F11C1B6D07;
	Wed, 16 Oct 2024 11:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="IZjUaZ9G";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RoHa94h5"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC00618C33F
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729079586; cv=none; b=lfJJlH0XRSG1trOidDXQq2ZBdlK7MEvY4ShjEjwSuiOZkJIKlKiwOq6LagDcYi6V4xuxJpPMTAE8cGAjjRpqUTDn+9kKTpaTHxCTogi8rL+nOr3uPDJw0dpBRbFhDKBQ208I11UD5W0x7ifTEjUFQSdWUTZVUTnCgJphmOoORmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729079586; c=relaxed/simple;
	bh=2gbM6qH+foGVD3rEOjC7Df3CPh2XPPNUTFylTfhVwT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KjFsPOWJLDTXhdXOdAYL5IGWGVPGXB6aGdpu//CYbAdVK8rLfHfivAmVVO5HN6ybR5M8eUExj7LMu+uDaNLo95vqhN5Q5iR5fBKdp3k6rJDVxuTm+hVRzuJUkfZv7Cumz90BdcK1fGKj3RXb6MHT05YyTsSvvxwdlbrpwT2VqS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=IZjUaZ9G; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RoHa94h5; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id A95BD138006B;
	Wed, 16 Oct 2024 07:53:02 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Wed, 16 Oct 2024 07:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1729079582;
	 x=1729165982; bh=O5ToGYu94OqOaSEBPCUKQkk8e2INOTdGA9OsXFJO6NQ=; b=
	IZjUaZ9GF2MxPTS/L1AUJOXR1oXZLdim9aynpUbsmpFgjmQ2OcJWHuO0iUybiPYg
	oUPVEEYK1LOvIBZQ4vYqcSCWLDWQfEJ94+Jl9X8EONNSM/gpXQ5qEr0Caegr2HCQ
	pO5U10B+V8S/0INCo6+LPrvYVvAuKjRd/tSOnD6kcM0FX56W9DzIkkbTF9WJRZdB
	QjzWNOifgzGtTwzKfg5nxzIcic3aZH4PlhzccVei7RY2zlhgU3kGjFLnLJ2jhzZI
	DdatrNWlaGSdddSGxawfNmCgrYaorVfrm0AOowqJqos23JqIgoC1MyPJDWya3+rU
	JX++PC6mMNZd142NO2rgYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1729079582; x=
	1729165982; bh=O5ToGYu94OqOaSEBPCUKQkk8e2INOTdGA9OsXFJO6NQ=; b=R
	oHa94h5B2V47l7o7bU4G3v44maQaf5MnSomDvIsX7lQBu9FfS7B/pMe4b++5rZEk
	fXDLJGyApkKiL/25XZFFDeAWPNPtU4aTTgG/bxjtnzf9vDAdzI/909itL9vUQMx3
	Tz5od8E8U0qsdVzyyZI3+S1NnKmhzojB46g/k+AWAh0DpXMUhfMjXrD3dOAUSrF8
	Zs85mvebva/BpKxjIEUeE4mjRl8OXAWP7sC5Lldg7mc1mK9jw7gEctPxFssN89Xy
	Bs/T+5sTYurrbXYGTmkhTus2xa0Z0XhI9TMP5gs7mkXprgwQ5rctkLP7mB8NJP8R
	lHBYxn6c9c3Adcbccm8ug==
X-ME-Sender: <xms:HakPZ4hxsXz8qEzGk55ItlzQWbStV2BWC6yNpx310EAG8h4HCFEMuA>
    <xme:HakPZxCj42Slf2xuenXbTx1Eb1jdf6AKhhEptk2ldLpiOhljfut5cxybiEjbqqeVz
    T0VM2u5Ysw1r-1S>
X-ME-Received: <xmr:HakPZwEmjaPHlu74fGax1QbaxdpPNH4I_thYZosOKnoU3-gwmRVCu6_pnBJRQvTQIvHw_HqIoMulBZxtDu8rjgAfZTzhAXueh2CYmfPfR7ZV1sK6h1QI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdegledggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfg
    tdfggeelfedvheefieevjeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohep
    rghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepthhomhdrlh
    gvihhmihhnghesghhmrghilhdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgv
    lhdrughkpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:HqkPZ5SADZ8e8EqFiMYxNuTqHdlCD57Kb7B9ZIOspDkbP7CqKRvCrA>
    <xmx:HqkPZ1x7-PalbgXuTh63RowbAdujgeClHeTxjOWsk_OtSwv4j0XO-w>
    <xmx:HqkPZ37KV2gXdxAhvdwrGfIHmJ7AmEDzDbdOJ6fXm_8h_c86nYu0xA>
    <xmx:HqkPZyz9E7B03w3LjrcssxJQlQVaCpCThZxlV1QEFGlBJH0nGIvI8Q>
    <xmx:HqkPZ0wRvDp2zgIGakSPdaWh3yHaIvgHeU5X90KNCIQA8pgHn8fCb0G0>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Oct 2024 07:53:01 -0400 (EDT)
Message-ID: <c2efdcc9-02c0-4937-b545-d0e6f88ee679@fastmail.fm>
Date: Wed, 16 Oct 2024 13:53:00 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei
 <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
 <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm> <ZwyFke6PayyOznP_@fedora>
 <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
 <b284b6a2-8837-4779-b6a2-f31196aea7b9@fastmail.fm>
 <ab2d2f5c-0e76-44a2-8a7e-6f9edcfa5a92@gmail.com>
 <24ee0d07-47cc-4dcb-bdca-2123f38d7219@fastmail.fm>
 <74b0e140-f79d-4a89-a83a-77334f739c92@gmail.com>
 <e30b5268-6958-410f-9647-f7760abdafc3@fastmail.fm>
 <CAJfpegs1fBX6zDeUbzK-NntwhuPkVdCoE386coODjgHuxsBuJA@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegs1fBX6zDeUbzK-NntwhuPkVdCoE386coODjgHuxsBuJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/24 12:54, Miklos Szeredi wrote:
> On Mon, 14 Oct 2024 at 23:27, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
> 
>> With only libfuse as ring user it is more like
>>
>> prep_requests(nr=N);
>> wait_cq(1); ==> we must not wait for more than 1 as more might never arrive
>> io_uring_for_each_cqe {
>> }
> 
> Right.
> 
> I think the point Pavel is trying to make is that  io_uring queue
> sizes don't have to match fuse queue size.  So we could have
> sq_entries=4, cq_entries=4 and have the server queue 64
> FUSE_URING_REQ_FETCH commands, it just has to do that in batches of 4
> max.

Hmm ok, I guess that might matter when payload is small compared to 
SQ/CQ size and the system is low in memory.

> 
>> @Miklos maybe we avoid using large CQEs/SQEs and instead set up our own
>> separate buffer for FUSE headers?
> 
> The only gain from this would be in the case where the uring is used
> for non-fuse requests as well, in which case the extra space in the
> queue entries would be unused (i.e. 48 unused bytes in the cacheline).
> I don't know if this is a realistic use case or not.  It's definitely
> a challenge to create a library API that allows this.
> 
> The disadvantage would be a more complex interface.

I don't think that complicated. In the end it is just another pointer
that needs to be mapped. We don't even need to use mmap.
At least for zero-copy we will need to the ring non-fuse requests. 
For the DDN use case, we are using another io-uring for tcp requests,
I would actually like to switch that to the same ring.


Thanks,
Bernd

