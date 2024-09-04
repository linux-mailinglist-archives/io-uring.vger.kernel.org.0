Return-Path: <io-uring+bounces-3035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E69196C76D
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 21:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13E7E287F72
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 19:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECF91E5015;
	Wed,  4 Sep 2024 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="EsGHSvPw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jcJ3d3BF"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D171714037F;
	Wed,  4 Sep 2024 19:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725477948; cv=none; b=Dqga+Y4E8Q8n9ZO4BPPZjgbTYxmJQ8vsIwoz4Wjr8bgThxnl+6cAOdr6UdR3hxNqF96OQEKs2eBEUFCmisDedFGoxflPA+mR+DMpIM3NyRh3Fra8jgOVpeY2NZZZJ7k97faXplz3o0Pu2lgcFX/2pZ8diU+BD+Obn10Jv3YZLBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725477948; c=relaxed/simple;
	bh=WABTkj5W0Tj09qjjpqm6Mz3K1iaWAwypzaKJMxQbkLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikbLnx3OEfVX7W/K9EUaKL54g7MnDtScflMeRwJ9jnCmJmcVk0FNv51lqaI/dCHzBVymDgqOQPxP75AQvYGHX53cltODYrQ7OkC4pBWk7Ynf6HWeYyuDZY23DtUrOzCdgi5BmezZv0EV7k5NN5zSEJi5aUBjcXfEifl8tcjjXm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=EsGHSvPw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jcJ3d3BF; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 076CB11402F5;
	Wed,  4 Sep 2024 15:25:45 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 04 Sep 2024 15:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725477945;
	 x=1725564345; bh=WbsggqAzRTToY1+tn0us2b1rSMx52vG/nDgynLfUhGk=; b=
	EsGHSvPw8/gxVj2//6A2Div9uhxp3yGd0AtHOUZ+S/j2cnjC7M2xPv0eyIgqyxCa
	kNYmxRXYGEPhifqI/r/MKZtqFQ4rI5RKCz0IDcMyTXLWFB6hAXLtycC10VWxP+EV
	B0/FeWkFKhZ0N3bPCONB4YzBGM5tWrYbJ0C9bWrlZ3RmWQ1cHL3i/GsOwOcbdPpq
	/D3iw5AQz3H6TfKeA11UcNZDv9Lwn4YAc7wbISRLdcpobCqIl4O/VH8sPUAafnf3
	7mYP6hekcaBAKWDLS0bx17CZZ4It1pAZRfyRx/83mR9q3hbGRkL6vVG3CM+6MaEK
	CrsLDK/U6F1kZ7sO2rKo5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725477945; x=
	1725564345; bh=WbsggqAzRTToY1+tn0us2b1rSMx52vG/nDgynLfUhGk=; b=j
	cJ3d3BFQRSR76m6Zp2eCsRnU0FT8TiIrlqs38jvygZOne9ZJM348kJW5o/vjAGMk
	20qPYOpUxs5G5TXZvUrPeTwei5rLpK8NcnU0lIvNrE+bybKlpvhtwDkRjr10+e+d
	Ag/IWQ/l5HkZI9Kc2k+7eiSs4meUt8OeFTUhPdpQtpFDiGQZw9h5YkI+oB2dfIkE
	ot6IiiwYNC3muTa4Y8v10u2cXxt4266tbImUwCgFiqNpgQ0L0wH5gkYel/JBTKP/
	76PIUrXlOX2bPS4FfdWkfMaqqTx8Th015N/8IHawjqGLjMldUg/c+waAFwE2Dmga
	YjRpJ2zo4lhQP8e5Vc7lA==
X-ME-Sender: <xms:OLTYZvK51uEUTt4J6iwE6qkDRNIoiLq3Z_BZccWCQidW3FjiYjCRqA>
    <xme:OLTYZjK0iqII0K2Bf7e06Z3UdiZH1VdWlYiXF8sRG0c6rf2VSvfgTzlvoI4I0F532
    p-dmoq1YlnsyQDw>
X-ME-Received: <xmr:OLTYZnv9a0Q5Wt2W2HJZiXoMLFltlXEJLFQ9PedkbenrEcG5AQbSvzrhxkkHFxv0Mzv47dJHjSrDptOQPb179fXflXTvQ8j-0K_zuBamp03CMNFLDODm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehjedgudefiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:OLTYZobb_sM23i8Fwhqtjsp8HpETDEraEhQLUJzqZGISt-7eOBsZKQ>
    <xmx:OLTYZmagiTx9KVhuxvpZyKFlSgKv_0JZP9oi2ZD5ZZRDNuYdMDOstg>
    <xmx:OLTYZsCLoz9MKhLBqkO23-L5s0so0DBLzckBhb9Rh044ujlVt2tqdg>
    <xmx:OLTYZkaSzs8z-gzt-XGwf8czrSekcxRftEfe-PDKanxOdbU5y_l72A>
    <xmx:ObTYZjQY0fAl4vfHgr5cyebyaG6DWdsCoWpfwbgZ26B8ImvrKMWhduu->
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Sep 2024 15:25:43 -0400 (EDT)
Message-ID: <26c96371-a113-4384-b97b-cf4913cdf8b5@fastmail.fm>
Date: Wed, 4 Sep 2024 21:25:42 +0200
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
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <cd1e8d26-a0f0-49f2-ac27-428d26713cc1@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/4/24 18:16, Jens Axboe wrote:
> On 9/4/24 10:08 AM, Bernd Schubert wrote:
>> Hi Jens,
>>
>> thanks for your help.
>>
>> On 9/4/24 17:47, Jens Axboe wrote:
>>> On 9/1/24 7:37 AM, Bernd Schubert wrote:
>>>> This is to allow copying into the buffer from the application
>>>> without the need to copy in ring context (and with that,
>>>> the need that the ring task is active in kernel space).
>>>>
>>>> Also absolutely needed for now to avoid this teardown issue
>>>
>>> I'm fine using these helpers, but they are absolutely not needed to
>>> avoid that teardown issue - well they may help because it's already
>>> mapped, but it's really the fault of your handler from attempting to map
>>> in user pages from when it's teardown/fallback task_work. If invoked and
>>> the ring is dying or not in the right task (as per the patch from
>>> Pavel), then just cleanup and return -ECANCELED.
>>
>> As I had posted on Friday/Saturday, it didn't work. I had added a 
>> debug pr_info into Pavels patch, somehow it didn't trigger on PF_EXITING 
>> and I didn't further debug it yet as I was working on the pin anyway.
>> And since Monday occupied with other work...
> 
> Then there's something wrong with that patch, as it definitely should
> work. How did you reproduce the teardown crash? I'll take a look here.

Thank you! In this specific case

1) Run passthrough_hp with --debug-fuse

2) dd if=/dev/zero of=/scratch/test/testfile bs=1M count=1

Then on the console that has passthrough_hp output and runs slow with my
ASAN/etc kernel: ctrl-z and kill -9 %
I guess a pkill -9 passthrough_hp should also work


But I can investigate later on myself what is the issue with PF_EXITING,
just not today and maybe not tomorrow either.

> 
> That said, it may indeed be the better approach to pin upfront. I just
> want to make sure it's not done as a bug fix for something that should
> not be happening.
> 
>> For this series it is needed to avoid kernel crashes. If we can can fix 
>> patch 15 and 16, the better. Although we will still later on need it as
>> optimization.
> 
> Yeah exactly, didn't see this before typing the above :-)
> 
>>>> +/*
>>>> + * Copy from memmap.c, should be exported
>>>> + */
>>>> +static void io_pages_free(struct page ***pages, int npages)
>>>> +{
>>>> +	struct page **page_array = *pages;
>>>> +
>>>> +	if (!page_array)
>>>> +		return;
>>>> +
>>>> +	unpin_user_pages(page_array, npages);
>>>> +	kvfree(page_array);
>>>> +	*pages = NULL;
>>>> +}
>>>
>>> I noticed this and the mapping helper being copied before seeing the
>>> comments - just export them from memmap.c and use those rather than
>>> copying in the code. Add that as a prep patch.
>>
>> No issue to do that either. The hard part is then to get it through
>> different branches. I had removed the big optimization of 
>> __wake_up_on_current_cpu in this series, because it needs another
>> export.
> 
> It's not that hard, just split it out in the next patch and I'll be
> happy to ack/review it so it can go in with the other patches rather
> than needing to go in separately.

Great thank you very much, will do!


Thanks,
Bernd

