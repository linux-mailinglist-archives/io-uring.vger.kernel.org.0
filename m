Return-Path: <io-uring+bounces-2010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ADD18D4F8A
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 18:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E8241C23519
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 16:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980BE1CABA;
	Thu, 30 May 2024 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="stEMyZw1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="W5OZc0OI"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2182B208A7;
	Thu, 30 May 2024 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717084949; cv=none; b=Jpd9JfKeLSTH40u2VbRt7D7TQjgeIYAZdVZ8m5Km7RWt9ftigCZXxAw/zeO941hJy+5g6pjqaJhaNJlg/no2UStdmx9j8HtiicSbBZyOOj5tgdI0icQsGitSRzC7QyusZhugI5JvdKKz437KmDByzOsrnAmczlCvEI2/mEwdSC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717084949; c=relaxed/simple;
	bh=AHev1TtoduSJSd4z2OfkHLXmcG2aBHc5FTs1KykKJ6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FTc+MeC8oqE0kY3TxuFsq7XKnjBxcpXrPvra/Y4YyvTqyN8mREi2o6uW+7yX+cXJj7bMkuEXLSSmE6FA7xtzQ+xajHZZKZleKJa0U2byf/seyq0tH8ADSmeyXxTjRxI5YadbuGIPuDRlw/tUnDYWUzUY+Yy1vldDXo/peluCEOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=stEMyZw1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=W5OZc0OI; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 3BA231140133;
	Thu, 30 May 2024 12:02:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 30 May 2024 12:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1717084946;
	 x=1717171346; bh=rI9Mnu6bKEwhWUljKF/ma2c1LKvj8PeUrbA5/YS6tYU=; b=
	stEMyZw14kKUbp4V+Fpik4JFcCM1mHPhjcOur3FnLMSttvKcQFf6myQwpQ17v4II
	9Bzt9qSs/YAVPF7gv26VKgkJwAZfjpipU6IkppCMJeQuTnQ8ZGQQa4jClFFb51FG
	kEGD7N8H2ZqZvqXMmrLqxvOp8tTZk/V8b68d72OjAZCpEVRXQWDFMIQ+vCw7tS7Y
	2aT6guNq04+0Rlgcz9uW08hpC/D3qbBS6Xb1xueekRyit52mNABq6DRzC+IqFoXJ
	E9z9yy+0Pb013wKyAK5I057tLBtJIm5R1kqf1qyccTBML0pMeiePXSGAnKpSrQC3
	CXDRNpbvYkIIOunAlZW6QQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1717084946; x=
	1717171346; bh=rI9Mnu6bKEwhWUljKF/ma2c1LKvj8PeUrbA5/YS6tYU=; b=W
	5OZc0OIDJhgoGwN8QQkFxtf5YRuZ8RcUQ4VvkPZ7Iyw1Ts85lVHFKnhOiPpcvGcw
	n7Mq1/OsGeZAsFyuAeeblD7HEFlPOa6CtE2dQfeEwtKwAIFhAGG33sRvFujssQ7g
	NWM3Ysou355VTZC66ZMmPVlFUDfnorni4HLf5ktdTwvavEOjM+ZGDK4UB56XzY22
	5Zdm00Jiyop2qBFmHUEPb4kopcRKu3XOX/g/x7y0Af0+ficPN4n54h/EInoMEXBJ
	ImUXRJtVG3SiLp3+Kn4FVBO/N5sC1IAZggBtg3ZjQhS/wvP5BU8ikXYutbZYOVct
	gMVe7DtuM7uhwtBcXFL2A==
X-ME-Sender: <xms:EKNYZoksAl1KXd1hoGy1c-9EHtIfDcWLlJqvjnSGD1o9QtZjFrJNLg>
    <xme:EKNYZn0oMrLNq88HnndI3-4G0fYXYPNU84bFyVQEez9pMndvzpkGyyEMFAMw2zGlf
    bGzafKQhKsJvLZ5>
X-ME-Received: <xmr:EKNYZmrjV6BOEeXp-syKhHTT-keYZ402V7V2Ms9STmDmFZnvVgDSknPi32rsy1-Su4w_nfc9_19bEj0Bx0R2vaSUMRZ2qt3xjDrbf5BP_g1UzDT6pjzi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdekgedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfgtdfggeelfedvheefieev
    jeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdr
    fhhm
X-ME-Proxy: <xmx:EKNYZkl8WBLlGTVEHKfpEx2hMVTRn8TaZorWLJY0nAangfyZ4z8Ljg>
    <xmx:EKNYZm1F5mwh8NEuG_wkSjK9FuKcEL7R-DPPAD99afK7C3vLCWNgGg>
    <xmx:EKNYZrsZzkd6XNWIAyWw8G2y3KkKLCqQUA-R_hraBhYWCxkIcKzZDw>
    <xmx:EKNYZiWI4BL9T1w487Uqvr1vRC2yYuEFosk0Zji4tvpORK8EPZ4T1Q>
    <xmx:EqNYZh3-_l_mDh-AN5Ea7FgGXAqijGIm2YdSTeUJRDj7olHAuzv0Msjj>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 May 2024 12:02:22 -0400 (EDT)
Message-ID: <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
Date: Thu, 30 May 2024 18:02:21 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Ming Lei <ming.lei@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/24 17:36, Kent Overstreet wrote:
> On Wed, May 29, 2024 at 08:00:35PM +0200, Bernd Schubert wrote:
>> From: Bernd Schubert <bschubert@ddn.com>
>>
>> This adds support for uring communication between kernel and
>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>> appraoch was taken from ublk.  The patches are in RFC state,
>> some major changes are still to be expected.
>>
>> Motivation for these patches is all to increase fuse performance.
>> In fuse-over-io-uring requests avoid core switching (application
>> on core X, processing of fuse server on random core Y) and use
>> shared memory between kernel and userspace to transfer data.
>> Similar approaches have been taken by ZUFS and FUSE2, though
>> not over io-uring, but through ioctl IOs
> 
> What specifically is it about io-uring that's helpful here? Besides the
> ringbuffer?
> 
> So the original mess was that because we didn't have a generic
> ringbuffer, we had aio, tracing, and god knows what else all
> implementing their own special purpose ringbuffers (all with weird
> quirks of debatable or no usefulness).
> 
> It seems to me that what fuse (and a lot of other things want) is just a
> clean simple easy to use generic ringbuffer for sending what-have-you
> back and forth between the kernel and userspace - in this case RPCs from
> the kernel to userspace.
> 
> But instead, the solution seems to be just toss everything into a new
> giant subsystem?


Hmm, initially I had thought about writing my own ring buffer, but then 
io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
need? From interface point of view, io-uring seems easy to use here, 
has everything we need and kind of the same thing is used for ublk - 
what speaks against io-uring? And what other suggestion do you have?

I guess the same concern would also apply to ublk_drv. 

Well, decoupling from io-uring might help to get for zero-copy, as there
doesn't seem to be an agreement with Mings approaches (sorry I'm only
silently following for now).

From our side, a customer has pointed out security concerns for io-uring. 
My thinking so far was to implemented the required io-uring pieces into 
an module and access it with ioctls... Which would also allow to
backport it to RHEL8/RHEL9.


Thanks,
Bernd

