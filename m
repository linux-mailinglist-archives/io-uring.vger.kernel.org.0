Return-Path: <io-uring+bounces-3053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB5696E499
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 23:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B1E31C23F9D
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 21:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1688A9443;
	Thu,  5 Sep 2024 21:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="n5rn2X4w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GsKRD1wo"
X-Original-To: io-uring@vger.kernel.org
Received: from fout8-smtp.messagingengine.com (fout8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9537A188A16;
	Thu,  5 Sep 2024 21:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725570287; cv=none; b=KNcYVigvF4WofGOncnYPR+FBTrbx2YwWxQC+D2gaRTSTU0PMQ7mXR/k/cQoOkPQRrQut3A2tONrFxvkTKp0FpM+hjLhuEbsgc/b84vpyR/QTf1KNdMFUHfc3UxEIyf56vYS8llvSifQAXvzA9zp15FdPZzOMJDUHNk8oGjfTxAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725570287; c=relaxed/simple;
	bh=pnJo8BCK/P3cWwmcQ6XRvES4TVu/0JjX0mA0+astEaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ItI63lqvVRz32BjPzNn+8XspazAxzsQxABbciS+1uqxpZP68aucEtLRysrNLCe9iW7oPwfKSSKHCYmxLE360L1lsj7myDoMuJ82BesX/op6AkqaPkLidBcCgCaT1Hzeq2lV2dx5IW6Lk7xwp8xOmETFhftsnAhouAqdnKaUW1DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=n5rn2X4w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GsKRD1wo; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id C1EA9138039E;
	Thu,  5 Sep 2024 17:04:43 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 05 Sep 2024 17:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725570283;
	 x=1725656683; bh=3p4qQr07PkgRUdo6X+f/Vcy9Vgd92TzGan6BdMlGZSA=; b=
	n5rn2X4wYl1TyLsAnA917oyGgO6kS+okmdrN4rEwKPpA37wFNWU/prCR/oKDn+Xp
	ZUNfjg0tDxYnlk/rKBUJh7tnSIU+q63re90RU7kuXjwUQqX9zAxPbBtRDXi3YbPS
	+iymIAYpoEmYS4m9ZrgJj8K4g9m9ib4RvEmB0noFDgFlwr5bLjfTFabbnuCGr4YV
	D6oCpvOBF6BT6cJnSRsHiyCb7iKPUGhQ7JUcTGNtboq5AtNSwGDz9hyHBcDVtwyk
	2SYYWekm4eyv2qDZV0x7IBLJXcZ03f2pD8qitx+0V9Q9KVPxqZKwI8YbwC+X+6vM
	0oebiP8SGuoxt1FUkvvXoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725570283; x=
	1725656683; bh=3p4qQr07PkgRUdo6X+f/Vcy9Vgd92TzGan6BdMlGZSA=; b=G
	sKRD1woO2VGLChwZ6LwaA+IDjdiEEymqxVeEHfCnR0Q0CgaCZDUvrFM9KhjWBDjG
	9SwOQk9N1dSmxj9/qwaZjU4uW+bpbC08s9UNaQYV6GMLvuOJpCBWEdQrUIfOKb6/
	lTFquKr2h91RQCV69vDGNRZmKhTHLFh7JMFVZpEEt5V9Yw8rXRNVU2dU8RwYNwtS
	yMmoDq6U0VBnrkYQAVCeTWLVms2+m9UFEX01twTtP3AkDy7Zhj931QQT/psAGVJn
	uGNTUavOAHNo6/gQezrhHqce2n0udOvW0jE+MalwIRcbdvEZLouUtIir2E2Z/vdB
	jbnXnbpf9PPtqXWulgGaQ==
X-ME-Sender: <xms:6xzaZmpaB2MnswIVgAhCpHPYGOFiEK953Ru0O77uV5bu_KkpPR9f9Q>
    <xme:6xzaZkrXClOXZYXJAGXOK8MgxbvlDz3Jxzao8alAdexJoZQEph8m2P7YiW5MXyLiX
    MjNebmzZI6HRoS7>
X-ME-Received: <xmr:6xzaZrN-orTj8_9wkHLZqHYycZxk4w4AolPsTPz4fNWuUm-Ki_hK9V45jdlazJFg3XEU_YW1qISNxhJJuOvXYO661uVJQb_pwRYWx37-3IiNYPrz5xiC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehledgudehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusg
    gvrhhtsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddu
    gfdtgfegleefvdehfeeiveejieefveeiteeggffggfeulefgjeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghr
    thesfhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepuddtpdhmohguvgepshhmth
    hpohhuthdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohep
    sghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivg
    hrvgguihdrhhhupdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgt
    ohhmpdhrtghpthhtohepsggvrhhnugesfhgrshhtmhgrihhlrdhfmhdprhgtphhtthhope
    hlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjh
    horghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepjhhoshgvfhes
    thhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:6xzaZl4w7DIrGyEBUu0d5LG7yDa7rW6FrAOUrHTYgFV5kTwZMmZSrw>
    <xmx:6xzaZl7Q8Di8Yo8P0PH1R09znJ22CsBOui7z99P8PbTLeMFkn9bgdw>
    <xmx:6xzaZljIS7V4pMS7MW8sYnZXjoiunE82wMXDtkkARRwQuM6Dtudnpg>
    <xmx:6xzaZv7uALud-pV_2gzyE26bk4WscUVk-mQqzWBwMBfPuL9_ledDQg>
    <xmx:6xzaZiw2xJHxMV74mxdS3EjNnLjuzOMJGx9tjKZGPSeWm4vFRKWf93fy>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Sep 2024 17:04:41 -0400 (EDT)
Message-ID: <3ec40e7a-8600-4aec-af57-7f65126c78eb@fastmail.fm>
Date: Thu, 5 Sep 2024 23:04:40 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 17/17] fuse: {uring} Pin the user buffer
To: Jens Axboe <axboe@kernel.dk>, Bernd Schubert <bschubert@ddn.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Pavel Begunkov <asml.silence@gmail.com>,
 bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-17-9207f7391444@ddn.com>
 <9a0e31ff-06ad-4065-8218-84b9206fc8a5@kernel.dk>
 <6c336a8f-4a91-4236-9431-9d0123b38796@fastmail.fm>
 <cd1e8d26-a0f0-49f2-ac27-428d26713cc1@kernel.dk>
 <26c96371-a113-4384-b97b-cf4913cdf8b5@fastmail.fm>
 <20342352-773c-4fb1-ac66-bcc6cf45d577@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20342352-773c-4fb1-ac66-bcc6cf45d577@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/4/24 21:40, Jens Axboe wrote:
> On 9/4/24 1:25 PM, Bernd Schubert wrote:
>>
>>
>> On 9/4/24 18:16, Jens Axboe wrote:
>>> On 9/4/24 10:08 AM, Bernd Schubert wrote:
>>>> Hi Jens,
>>>>
>>>> thanks for your help.
>>>>
>>>> On 9/4/24 17:47, Jens Axboe wrote:
>>>>> On 9/1/24 7:37 AM, Bernd Schubert wrote:
>>>>>> This is to allow copying into the buffer from the application
>>>>>> without the need to copy in ring context (and with that,
>>>>>> the need that the ring task is active in kernel space).
>>>>>>
>>>>>> Also absolutely needed for now to avoid this teardown issue
>>>>>
>>>>> I'm fine using these helpers, but they are absolutely not needed to
>>>>> avoid that teardown issue - well they may help because it's already
>>>>> mapped, but it's really the fault of your handler from attempting to map
>>>>> in user pages from when it's teardown/fallback task_work. If invoked and
>>>>> the ring is dying or not in the right task (as per the patch from
>>>>> Pavel), then just cleanup and return -ECANCELED.
>>>>
>>>> As I had posted on Friday/Saturday, it didn't work. I had added a 
>>>> debug pr_info into Pavels patch, somehow it didn't trigger on PF_EXITING 
>>>> and I didn't further debug it yet as I was working on the pin anyway.
>>>> And since Monday occupied with other work...
>>>
>>> Then there's something wrong with that patch, as it definitely should
>>> work. How did you reproduce the teardown crash? I'll take a look here.
>>
>> Thank you! In this specific case
>>
>> 1) Run passthrough_hp with --debug-fuse
>>
>> 2) dd if=/dev/zero of=/scratch/test/testfile bs=1M count=1
>>
>> Then on the console that has passthrough_hp output and runs slow with my
>> ASAN/etc kernel: ctrl-z and kill -9 %
>> I guess a pkill -9 passthrough_hp should also work
> 
> Eerily similar to what I tried, but I managed to get it to trigger.
> Should work what's in there, but I think checking for task != current is
> better and not race prone like PF_EXITING is. So maybe? Try with the
> below incremental.
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 55bdcb4b63b3..fa5a0f724a84 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -121,7 +121,8 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>  	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>  	unsigned flags = IO_URING_F_COMPLETE_DEFER;
>  
> -	if (req->task->flags & PF_EXITING)
> +	/* Different task should only happen if the original is going away */
> +	if (req->task != current)
>  		flags |= IO_URING_F_TASK_DEAD;
>  
>  	/* task_work executor checks the deffered list completion */
> 

Thanks, just tested this version works fine!
My user of that (patch 16/17) left the fuse ring entry in bad state -
fixed in my v4 branch.

Thanks,
Bernd

