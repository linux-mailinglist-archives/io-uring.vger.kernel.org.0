Return-Path: <io-uring+bounces-3603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B84699AB06
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 20:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DA771C219DA
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 18:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82F319B581;
	Fri, 11 Oct 2024 18:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="cmGIDwid";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cuIDQ9Ka"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1EA125D6
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671726; cv=none; b=mOFBBqVyfhBMDlCOvTG4yho7uxKWO1RStXv5U6IMODrPDMBgkSy5COhtSXFxJQeFrqv5fpgdnMsWTp0tyM/iq7r03LTa/VcTd5b3X6Zn6ZZLUhNLHBhmvdgXVo5YlFpLp7rj7IRBqnQsW6tQprsesPMlFyStWpIAgpezjszct9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671726; c=relaxed/simple;
	bh=WXtuviDW7xaVntCiiXcAorslnKzrD02qqqEXdqyt4uk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aKFKK+kWGebdI6YHuztQ9vvEHjiUBCVBeOpFbYAPelBl1SmjialZe50XamM9Nzk8490KsLEKZSWjP2+B0kSFiFJpNIDEAwQJx5pk1vPwPhH5UuKVcz0qvrbBpmyDj+pmI6HnMruyPizzcbOEAf5vgaRpcHrQSRhNGGVjBDKATxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=cmGIDwid; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cuIDQ9Ka; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 9469113802C8;
	Fri, 11 Oct 2024 14:35:23 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 11 Oct 2024 14:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1728671723;
	 x=1728758123; bh=2hfd3yNxk85kvJRhYVPpez9obmGWP+/0ENupikfQRw0=; b=
	cmGIDwid677iUXfo/+cGwuP/MBi8RkwY3Pnmv95jKiA2FpVgIml4qRuv1rDhDue2
	o/qjmwddNcHkhQ3aRcVYBX2C3vUIaSw2B/BjuqXLF9W+ZodgipacbcKQ9+nVWyFx
	22cFrnUPHwYpVL0sfd2YDCtaIBXELyLbck/ofQ+6E/1JguDgMF/91S9ku0g4kEYT
	72vdnQraQKUsn//N0Ev+4jHO+4tWJadFQdOiMha3lo8aZW7DrwjVeu65GtMigqQV
	yPYZqNiTX6FW2gvIloEtglbhZ65SokP9G2HWCoKq7P1gr4JblxeqE9lZvtR1VpHC
	tXPwgrOX1NGE5FVo3zryZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1728671723; x=
	1728758123; bh=2hfd3yNxk85kvJRhYVPpez9obmGWP+/0ENupikfQRw0=; b=c
	uIDQ9Ka8qM8SpagjNOvBz7AlAzFDeemvf/eEXPwz+X4+5MaTyjBlMLwj/Z19bEi3
	4FegGKfZMMpCK/Jmsc6WHkIBI1nApvJu8gqDkd2vNullgFK8koLmdvFxhN/Mylr3
	wQUOWu9lN+nJIAIJH+HKggDFV2NYThQn0GUwvzGOtmTKeeVsaNLSP4emr0bZ4jpQ
	kWFGAKL0fcZE6TAzsM5tLonfCN6e9mMV06oZVLtVYK9K8DnfDDxBVmOwkmJAkaa4
	D+jl/wqh2KZXgCEdSABZTHXpMxKVJeoLoUQsa9Jh6mDVP0IGro5Qujy2agNrvr8z
	puLZ4dqH9LujEISF8eIqA==
X-ME-Sender: <xms:628JZ-Y1AqG4GzOA4K7jinz8MDEzOmRG-eW9jRTjtVx7BKatHTHjMg>
    <xme:628JZxazW_bhY0hUjYkywcsSZ-6vdMcnjszGbuhlvp-tinA_jkIoqKCIkwXmbToPW
    u3c2EySH1fsJWwc>
X-ME-Received: <xmr:628JZ49cmWumfx3gBo9nSN_B56yu7EnYs0K5lo8Mm4uoXNKXA3sk-cg9lcghdBK6ASRqV4Tf_LkfLRsRWHyCVYVgcWYJUkDvJWZs1xBq9jBxi_sx1jgS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdefkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusg
    gvrhhtsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddu
    gfdtgfegleefvdehfeeiveejieefveeiteeggffggfeulefgjeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghr
    thesfhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehi
    ohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrshhmlh
    drshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehmihhklhhoshesshii
    vghrvgguihdrhhhupdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:628JZwpPLDTZ_8swpsLOCETUzsX5cX_xy6QRg1N3GscY3oj56YYJrQ>
    <xmx:628JZ5pnXMuZIFPMo_SaryVLfB_g3jMOXeoRcReiEYI9v3Q8P9sdUw>
    <xmx:628JZ-QUSypEDppzkyAKpIu01ljZDdkB1rkBz5Nz9pbp6bTtOQqjKg>
    <xmx:628JZ5pOiuNxAl1QyygRuEcD0e9AHVvixN2Y87mv7QiEes9pq40YQA>
    <xmx:628JZ6fgoD2EG7bSc1Qtv-ESK3lUsE94L82v1hcAnfZvvzzsbaHVmuPT>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Oct 2024 14:35:22 -0400 (EDT)
Message-ID: <aa99c09f-fa6f-4662-9da4-62a7d848d8b9@fastmail.fm>
Date: Fri, 11 Oct 2024 20:35:21 +0200
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
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <f83d5370-f026-4654-810a-199fb3e01038@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/11/24 19:57, Jens Axboe wrote:
> On 10/10/24 2:56 PM, Bernd Schubert wrote:
>> Hello,
>>
>> as discussed during LPC, we would like to have large CQE sizes, at least
>> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
>>
>> Pavel said that this should be ok, but it would be better to have the CQE
>> size as function argument. 
>> Could you give me some hints how this should look like and especially how
>> we are going to communicate the CQE size to the kernel? I guess just adding
>> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.
> 
> Not Pavel and unfortunately I could not be at that LPC discussion, but
> yeah I don't see why not just adding the necessary SETUP arg for this
> would not be the way to go. As long as they are power-of-2, then all
> it'll impact on both the kernel and liburing side is what size shift to
> use when iterating CQEs.

Thanks, Pavel also wanted power-of-2, although 512 is a bit much for fuse. 
Well, maybe 256 will be sufficient. Going to look into adding that parameter
during the next days.

> 
> Since this obviously means larger CQ rings, one nice side effect is that
> since 6.10 we don't need contig pages to map any of the rings. So should
> work just fine regardless of memory fragmentation, where previously that
> would've been a concern.
> 

Out of interest, what is the change? Up to fuse-io-uring rfc2 I was
vmalloced buffers for fuse that got mmaped - was working fine. Miklos just
wants to avoid that kernel allocates large chunks of memory on behalf of
users.


Thanks,
Bernd

