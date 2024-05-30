Return-Path: <io-uring+bounces-2012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3437A8D4FB5
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 18:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9E8C1F26001
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 16:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790FB210FB;
	Thu, 30 May 2024 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="Fz67EPV5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SjzopVqe"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC00718755C;
	Thu, 30 May 2024 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717085855; cv=none; b=HxwOtD3s0WHfWzWDLuQKGyOWWGghDKhpQT18hP3RRAdYm2wha43dVh/AW+C1PjO36rhH00mcL7bgRnrqBK1pWPLO3tPIttETCOHo+X1cMsToIUCJp7ZutydmUkpkcEuiZIlcXnfg8zonzkRzms/uX1T5xC7APuTeVLi98Z9rPwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717085855; c=relaxed/simple;
	bh=EjM9n8tLoWd79y3uiDmR4Rpory8WFpIavdV0sVGVgCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XkdTnKoxVI23ZM/ij4jqDZLjw8PIhu9ucYBjkAsx1wcm/3QFL2fmYiXBkF+N/BxRMtpj9+Jg+2d3LO9rgwZjkf/jIFnHbyv76NF+xQJdoKCLLgleQm6R2+XxpG2cWXxe9AYBv6DuOybZ33l3rdKpArTEe4BtMhzz8PH42UTzaeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=Fz67EPV5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SjzopVqe; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id E375C11400A9;
	Thu, 30 May 2024 12:17:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 30 May 2024 12:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1717085852;
	 x=1717172252; bh=MGMMw8JtoR+hpgCNUIg6+WGJ9z2greIjzCdBdJk5HfM=; b=
	Fz67EPV5YNzXYLpLtexiHS8LzlYTC9YevgaovADisFwgxzDIDxN8ZaWTG8T6Ij+z
	V0L2X0tf9XG2S7hxgYmX744BjMJxE6ihiSY9R/dc97d5mZHAO8ixDQxzgi1lnHdC
	heugFF2CrdaJbd+/OgAJkFp5R7id+A1YEulW61qV1/j6v85O3+G/oV9hwtcRnbjR
	8WoKOP9iEdsnRhGtKVJq2A8A6PMLJTxbyx7/R5AxLQcMRp3WfPGgxIPUttPF3g9T
	Dw45Ig7DZ/lPBOG6Ncwq5efXDNuCqs1mpypnAHmQ0JKrlmE8J3LKvMyh71QZHii/
	Ahq6dLv3YbFdnG23cnyJyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1717085852; x=
	1717172252; bh=MGMMw8JtoR+hpgCNUIg6+WGJ9z2greIjzCdBdJk5HfM=; b=S
	jzopVqey7HbgRWXHw0q/Cm2iHnRd5sK15iRjuBsUhpMKLZeJ69Z6l9vPXrHid4BC
	x1GffOCu+AGKNY8R0qGjF3bxg97SZZfglVZkdRvWOod4gxFUJHXSH+cv1X/tcigE
	Gi1v1wVomMMDoFo85tDa4aTETvABuE3J+8zb6hlu2t/Dl2IYm0mTih8bli5+B6Jo
	lysy7FiPO5V7+IiaiodLzVLX/rx8qFhunlxdJYMHzNeppzXFo2agjboCS7yVQf55
	AONmB9K42p3kPvi1qf6QC6SbHO+jWHxmt949+OrBgH7/QdL841Hr/kR1wdWm1J3Z
	HFXd5TGWugnqPo4XcsILQ==
X-ME-Sender: <xms:nKZYZixVa_PCzcAaqJjaVF_qYVny0k24ej-J948I7w9tAgRQmCOOsA>
    <xme:nKZYZuTnvgez9CMogqVmem5Fg0yhTxGwkrYrPy3nHgulR2zANgCgFpfQjrAtt6AE1
    Bo0hZ3BQ-SG3cca>
X-ME-Received: <xmr:nKZYZkXsL0bJKb-3hKKgtSGufFxMAL0k3VEgGwqjs4GfGAo-riWWKGmsAAJRf5mFBUNo0TvNP-HqYNMxAZpn9SbNyrkJ42flWwmFXIVKCQCL4UBzLfRU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdekgedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfgtdfggeelfedvheefieev
    jeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdr
    fhhm
X-ME-Proxy: <xmx:nKZYZogDLdt0UhyUjUytZjPVLZMY0CSE3TIDTJgpNvF-ppzwf8nuqw>
    <xmx:nKZYZkB1-jBVtlcklwTPIaeJUkiTglCuD6eJznJT3XAHwHTCU-JOzQ>
    <xmx:nKZYZpII4vcdOlMvwupc22hjWYeYlM9wBwOJ-UxVOZ3xj0YCT-jLjA>
    <xmx:nKZYZrBjJpSmEHcr-8vDP0H6rLaOGzbRwcSbOv_be6UMd_mn8SICRg>
    <xmx:nKZYZiSDhwQneGhlEdPwrv7CU0UGIJAVs3IxroSQI7sBchzL4mdcci5H>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 May 2024 12:17:30 -0400 (EDT)
Message-ID: <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>
Date: Thu, 30 May 2024 18:17:29 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <owccqrazlyfo2zcsprxr7bhpgjrh4km3xlc4ku2aqhqhlqhtyj@djlwwccmlwhw>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <owccqrazlyfo2zcsprxr7bhpgjrh4km3xlc4ku2aqhqhlqhtyj@djlwwccmlwhw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/24 18:10, Kent Overstreet wrote:
> On Thu, May 30, 2024 at 06:02:21PM +0200, Bernd Schubert wrote:
>> Hmm, initially I had thought about writing my own ring buffer, but then 
>> io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
>> need? From interface point of view, io-uring seems easy to use here, 
>> has everything we need and kind of the same thing is used for ublk - 
>> what speaks against io-uring? And what other suggestion do you have?
>>
>> I guess the same concern would also apply to ublk_drv. 
>>
>> Well, decoupling from io-uring might help to get for zero-copy, as there
>> doesn't seem to be an agreement with Mings approaches (sorry I'm only
>> silently following for now).
>>
>> From our side, a customer has pointed out security concerns for io-uring. 
>> My thinking so far was to implemented the required io-uring pieces into 
>> an module and access it with ioctls... Which would also allow to
>> backport it to RHEL8/RHEL9.
> 
> Well, I've been starting to sketch out a ringbuffer() syscall, which
> would work on any (supported) file descriptor and give you a ringbuffer
> for reading or writing (or call it twice for both).
> 
> That seems to be what fuse really wants, no? You're already using a file
> descriptor and your own RPC format, you just want a faster
> communications channel.

Fine with me, if you have something better/simpler with less security
concerns - why not. We just need a community agreement on that.

Do you have something I could look at?

Thanks,
Bernd

