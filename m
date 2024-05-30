Return-Path: <io-uring+bounces-2014-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE50B8D4FDF
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 18:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 544241F227A3
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 16:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF7F6AA1;
	Thu, 30 May 2024 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="kkbvhgEb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZCXszEPo"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7982E417;
	Thu, 30 May 2024 16:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717086756; cv=none; b=r2Qk7I8TI05ssDiPCqzd8fgnwvkMfJrD9ltUzuI0OV6emT2brg4sfyRu+pJF75CUXPMtFsWqhfMU45Oqky+O/pYyxfQKXyKTkHZs64zVjIogC6bfYDr7nVqcCmr7OTWiq7+Y/g8hQ34/mb5ySdM/iNs+2SgCMuvmZAWfp4W02jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717086756; c=relaxed/simple;
	bh=RfMtDG8CnOGXEk70NubsN9/P4gwT8kDTXYKcm/sIU2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGloQYLe/92OnnlhTtea+CXoaVnIJpXlVdhPj7A15fMde48Dv0LIfzf7J3uwlV5kUNSY9QNNi1HcvcM7DHHx951i6MbW6aTLHgrkdbxZMcgf7obaA0r/cqBkarPKrhwOTXiEDHpCey/W2XRg9Yv/9385jhvMrV33iokXNBTLFUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=kkbvhgEb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZCXszEPo; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 4AC3211400FC;
	Thu, 30 May 2024 12:32:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 30 May 2024 12:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1717086753;
	 x=1717173153; bh=Z4Mm1fkBTA3G1C9T3Tcls34tn8SvlTzmOdzcBAwMLg0=; b=
	kkbvhgEbnEgoRF6t9YBedwE5kcWWLw9KtvCXj8gaNVX07uevoUFm/NVZrxu5ddoz
	9+5xSvyxUUYLVZgnck1hH3R3AI7Wc5+NsRrrwdOZGVjNKGiOeTkGlnEUwosMd6km
	q7fKNSr67HYq3zwdkhdoF1q8nmGgms+J6RYLyX49MJZ3gjj8WCWImHc7Z2BXHtoW
	mW2Z2Cav9qr4jHbSRTk3ypoX/1X6AJaNg44FfUbcKCk7Jlf/TYOcLtri0j7soOYf
	fV4A1CSJXGBddUnwrJoK9Wm3tUCFfEbkp5D2COk062pm5YhlS/pbmn174SGxVdBM
	c55xiJp4/Ap/qYnyEPJf4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1717086753; x=
	1717173153; bh=Z4Mm1fkBTA3G1C9T3Tcls34tn8SvlTzmOdzcBAwMLg0=; b=Z
	CXszEPopBF+gpaNXu6tmgcIOGJYOorFOTUFnD1VLE4590Q1QpqWoUCiiucOIoCpZ
	Fe6RzjnjUHFoStMSOCM4vnoPyNO+WNvvuUQmHibbcaNDG9XzQDPOnBnDj3KvjWm/
	1QvH4qA4SBXMI50f3vIKhSn3kxscDTX+VxxY9S14o+RaVC7ciRnHRzbhWEIzu9EM
	I6h6359NMopGMagccAhHG3HmXlvo51H5xwUeLPe7RKb+ozp6qT6fmfD+JcPVuAIR
	wmyluALrLeisGkCknLqco/TjenmU1lPwBj1tdzmsAEouFl++fUzSj713F3fApFCJ
	ZAuSmWZkAnLXnjuBGzK5A==
X-ME-Sender: <xms:IKpYZhlpAbsy2U0zGFzkXZJyfw6ZICeFCMIXwNuqdy89klBcvmC3MQ>
    <xme:IKpYZs1RCL2Z7WcFFcZd1bLT-x8aF3K6AaJhy0n1p6VA3cIEGpdZJjHBPs1Xcp04A
    GwwIr5-YuXMwrxj>
X-ME-Received: <xmr:IKpYZnpaZRxk9HEbTTJg0v3AU7Yxw2t6W2BUmehR2rH1yr9lcZSJaiy6VepqILtkaJNPDklZdj5X_bvQePxQWV3Xwiy0weLzKLssA56ne-OlC2UvwzJd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdekgedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfgtdfggeelfedvheefieev
    jeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdr
    fhhm
X-ME-Proxy: <xmx:IKpYZhmOzJ-QN_SbLAovxDKscMJLhN1PlE0oycH3kvdzuD5sL8ZJ6g>
    <xmx:IKpYZv26ErvJWNKdZxx_ti9EOYUspV6Vq2WPhX2c7Rp4RjOIb5u6ng>
    <xmx:IKpYZguIG8M7QQ3YlljsH28fTjXVqVC8ugkpBdOf-bte9ItykUvXmg>
    <xmx:IKpYZjVgtDV17rWE3s38y9AApnmYLmAmH8soRJBcp5DBnFR-D6MvSw>
    <xmx:IapYZm11Gg8lRZPCTlM6bAUiJXlww7heo-mWKeMq8kdD38viGQSNsdY0>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 May 2024 12:32:30 -0400 (EDT)
Message-ID: <43205d1f-de49-4115-857f-c2c7db28b418@fastmail.fm>
Date: Thu, 30 May 2024 18:32:29 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Jens Axboe <axboe@kernel.dk>, Kent Overstreet
 <kent.overstreet@linux.dev>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/24 18:21, Jens Axboe wrote:
> On 5/30/24 10:02 AM, Bernd Schubert wrote:
>>
>>
>> On 5/30/24 17:36, Kent Overstreet wrote:
>>> On Wed, May 29, 2024 at 08:00:35PM +0200, Bernd Schubert wrote:
>>>> From: Bernd Schubert <bschubert@ddn.com>
>>>>
>>>> This adds support for uring communication between kernel and
>>>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>>>> appraoch was taken from ublk.  The patches are in RFC state,
>>>> some major changes are still to be expected.
>>>>
>>>> Motivation for these patches is all to increase fuse performance.
>>>> In fuse-over-io-uring requests avoid core switching (application
>>>> on core X, processing of fuse server on random core Y) and use
>>>> shared memory between kernel and userspace to transfer data.
>>>> Similar approaches have been taken by ZUFS and FUSE2, though
>>>> not over io-uring, but through ioctl IOs
>>>
>>> What specifically is it about io-uring that's helpful here? Besides the
>>> ringbuffer?
>>>
>>> So the original mess was that because we didn't have a generic
>>> ringbuffer, we had aio, tracing, and god knows what else all
>>> implementing their own special purpose ringbuffers (all with weird
>>> quirks of debatable or no usefulness).
>>>
>>> It seems to me that what fuse (and a lot of other things want) is just a
>>> clean simple easy to use generic ringbuffer for sending what-have-you
>>> back and forth between the kernel and userspace - in this case RPCs from
>>> the kernel to userspace.
>>>
>>> But instead, the solution seems to be just toss everything into a new
>>> giant subsystem?
>>
>>
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
> 
> If you have an interest in the zero copy, do chime in, it would
> certainly help get some closure on that feature. I don't think anyone
> disagrees it's a useful and needed feature, but there are different view
> points on how it's best solved.

We had a bit of discussion with Ming about that last year, besides that
I got busy with other parts, it got a bit less of personal interest for
me as our project really needs to access the buffer (additional
checksums, sending it out over network library (libfabric), possibly
even preprocessing of some data) - I think it makes sense if I work on
the other fuse parts first and only come back zero copy a bit later.

> 
>> From our side, a customer has pointed out security concerns for io-uring. 
> 
> That's just bs and fud these days.

I wasn't in contact with that customer personally, I had just seen their
email.It would probably help if RHEL would eventually gain io-uring
support - almost all of HPC systems are using it or a clone. I was
always hoping that RHEL would get it before I'm done with
fuse-over-io-uring, now I'm not so sure anymore.


Thanks,
Bernd

