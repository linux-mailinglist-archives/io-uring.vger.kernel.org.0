Return-Path: <io-uring+bounces-3657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A0F99CB79
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 15:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAEDD1C22E84
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 13:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A801A76BC;
	Mon, 14 Oct 2024 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="pbU0ILu5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dOwybfaD"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7391A1AA7A1
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 13:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728912019; cv=none; b=rjlc9qRmzaFM6oxkOh0Fm0I8GYBJiC7XotqhIWz1ekxZ+zv8bKUoJjRlWSNZMDJTmcmoi2B3EjfFTL+6/YjNIkbj6EnLomApfgnbG7AojbxRecmJjPyq9em6eOJ/ViNxZu8ciM84VHesW+3o5qS18wfc4FeJhxXvtNAcjFeQWrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728912019; c=relaxed/simple;
	bh=MsacvKqRTdcnda5eezI+hTBPES8rw1mi1RhEVV5payQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCzbmvpMiLHQ9p5h3eaE0tOWRAievSh50mEXT0IfGirDpSXLYvtuWYbqsbHdC/Cgd9wjJd6AhGf7bh52OTeGxpCjLrGiEHh4/PZcmXVJjIJu0Ke97QuNN91gOt4vP8lIZ5OubMdsBfZJIbSct6Za0SWxv9mLPePzhf7Kf/27x7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=pbU0ILu5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dOwybfaD; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 901EC138045C;
	Mon, 14 Oct 2024 09:20:16 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 14 Oct 2024 09:20:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1728912016;
	 x=1728998416; bh=c0AMcCpXh1gyTuS4Ev8DkhQAb8SWcqr2zt0rV5DKTIE=; b=
	pbU0ILu58SUY1V6WT5JvIoL7jRvxLGl+5ha8peeNBX7CnVdCp+FETMP2pG6B6mYB
	Cvdqug/2VtBbY4BUAx7icFoChCT33S7GYEuVlRDNZOazQMvexW1Apk9WJt0sv2n1
	fiNFZnKkrP6tFxCmBDYnuvwrl7OVhFSWg39dOWAITb7XT8fd3m8z2UqFc5tv4RJJ
	RGfpafYv5mmtydF+KedEO4TT4cXEzgBvhIKJT6jd3U+yIdQd+SkTTanES3gsgC8B
	gMQo2G0ZgCyI3mo4zZeVZkJ0N8pj90G/Tu5BEUX7vuQLOTsZa9ObFasHjCr2tkpm
	GfflolzkCRZ8egc9xHdDpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1728912016; x=
	1728998416; bh=c0AMcCpXh1gyTuS4Ev8DkhQAb8SWcqr2zt0rV5DKTIE=; b=d
	OwybfaDfu4WhUi4mBYLV84kw5uAOOfMMyLLcnKBjo3jXjJcxr/M3cjscLUVLHUga
	Jb/6odJx3DVsa4FDF1SfBgE/toZLgEcoTiK8A8f7DoblrIXGdO032ZFx0MTRHtcu
	nol1eRVBKFK4uPjLoaDgXUxdutmORnEe7GjphoWYiuumrvziwKx+3d9BOUE5Gskd
	kuO6VFhjFpIyI6WeGKXTLFjFPkSOdfepT7p5cFzJ+vvJqg4cqnVwGYmHnS2sS+kA
	0txHheqK6IIOutLBLu+A8o7tFaWS6FSdHF92rVoSdZB2Tx5fYvhqaCCQd9o/smH6
	7YsDjrTKRZDK+5XxZ6ALw==
X-ME-Sender: <xms:kBoNZ17l2RlMffblMqsT_DsZbLqxQJWLBmXwUn54e46XJPeVcFc8tA>
    <xme:kBoNZy45dwR5-7Q3mLgBgng6KZ75ueEU_KglGVcdvpUyNldF70IVIytL0BoVtNiFE
    PBKPFv1qHp53BFK>
X-ME-Received: <xmr:kBoNZ8cE65VQDvsEXVmFcR3lpjc6Veo175CCCxmyYeSd9zb2dDgErdjjtTIj6pRlGgxPS0KmyxWuIVB6DysbuswE3hnp1koRyeMJXOSzVeT77XTso1O4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeghedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfg
    tdfggeelfedvheefieevjeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohep
    thhomhdrlhgvihhmihhnghesghhmrghilhdrtghomhdprhgtphhtthhopegrgigsohgvse
    hkvghrnhgvlhdrughkpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhmpdhrtghpthhtohepthhrrg
    hpvgigihhtsehsphgrfihnrdhlihhnkh
X-ME-Proxy: <xmx:kBoNZ-I-szkgAWUNMZOVpafjyylca2Cgvdxef03LgsKt6x_OQzddGw>
    <xmx:kBoNZ5KWbMz1AbXpYIfnxcQjogWEk8qvX4I7GyMuoQ1pH1VM2qMF3Q>
    <xmx:kBoNZ3zkAYVQwZrL_HV_dusYM545t2uHwk2OgNjjMl4AeXdPjN2vAA>
    <xmx:kBoNZ1JCA_JS2feW-4qbFxMrqIseRqgqcDcpKOJ4GbrTPbaera0W7w>
    <xmx:kBoNZw-tkOgbqapPoo18aNWNp3BFbz1Sl-Y_X2cfVgGibWpSF61IhsqG>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Oct 2024 09:20:14 -0400 (EDT)
Message-ID: <8c951c4e-b08d-416a-ad25-216839352337@fastmail.fm>
Date: Mon, 14 Oct 2024 15:20:13 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Miklos Szeredi <miklos@szeredi.hu>, Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Antonio SJ Musumeci <trapexit@spawn.link>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
 <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm> <ZwyFke6PayyOznP_@fedora>
 <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/24 13:10, Miklos Szeredi wrote:
> On Mon, 14 Oct 2024 at 04:44, Ming Lei <tom.leiming@gmail.com> wrote:
> 
>> It also depends on how fuse user code consumes the big CQE payload, if
>> fuse header needs to keep in memory a bit long, you may have to copy it
>> somewhere for post-processing since io_uring(kernel) needs CQE to be
>> returned back asap.
> 
> Yes.
> 
> I'm not quite sure how the libfuse interface will work to accommodate
> this.  Currently if the server needs to delay the processing of a
> request it would have to copy all arguments, since validity will not
> be guaranteed after the callback returns.  With the io_uring

Well, it depends on the libfuse implementation. In plain libfuse the
buffer is associated with the the thread. This could be improved
by creating a request pool and buffers per request. AFAIK, Antonio
has done that for mergerfs.

> infrastructure the headers would need to be copied, but the data
> buffer would be per-request and would not need copying.  This is
> relaxing a requirement so existing servers would continue to work

Yep, that is actually how we use it at ddn for requests over io-uring.

> fine, but would not be able to take full advantage of the multi-buffer
> design.

What do you actually mean with "multi-buffer design"?



Thanks,
Bernd

