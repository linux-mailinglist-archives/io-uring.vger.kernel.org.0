Return-Path: <io-uring+bounces-5026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B979D7850
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A94E281555
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7675212B17C;
	Sun, 24 Nov 2024 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="WELxrSG+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oQjQXiFR"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAC1558BA;
	Sun, 24 Nov 2024 21:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732483556; cv=none; b=AGY5hO2S3iRcpzYf3vHMb0aaZx5Ipe4aDiV+UjzmD0gSvb3QsLlNUX6ekNUj5mi84lcbZ9tWln7F5tMZBzOPak9uzZc56GPvBU+TVSB/6q/i26gjlKwW7tfZ9XO4rOkb1b2KpkzNK0+LNi1AqKpyssMdi2N+wpQJX8K/GihZq40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732483556; c=relaxed/simple;
	bh=r34tkhY9rOokdTejypmWIIHi34QnPu2VrBZb3fqi7ng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O208i8rKP2Mpa35RK1cHtQrnmjMBUbIxQEtpPx+XM0yv/AT29p6EFRVtQ/IQwcVAluga10wUbo36cb1EBLIvXDYR+GEvUhkhLTFAkdVp39Fc4XOt4CiGYYGJoO1Iu6rvyYFyAKahNEU8xnHMNsSkciYbA8Fwv3XT3OUS+tpRKc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=WELxrSG+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oQjQXiFR; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 89D522540177;
	Sun, 24 Nov 2024 16:25:52 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 24 Nov 2024 16:25:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1732483552;
	 x=1732569952; bh=1Y6PTr/j1+XMevFD9gDvZOX4YuxF2dHvdlIBuDCTZcc=; b=
	WELxrSG+/LFjztKecuuRK+KxdOFJACgEH9rMVEWw7DOFwanOEGttkNV6mG9tPaaj
	HNZcFKjFF+pT2XXRDp5ovQeh+9JdiY81F3QhCuO/EwwDIeN8MX8/5rQNiVkNwJC8
	mxZsOWspER5IIiW6yBErN3um9EpZJRs1ItYmKqCyDfZkAVmNpnklaFcqs+ukgqwr
	XYoiQFC5wlCWkgKr0V5kbl/rNEn270lOgbxMLEOFfsYTcm39aPaANJ5HAvsCpFko
	sIoIf23VtvxF9kwi2Ue+bZ6oW8yNiO3PpCPrXb1BkTsSLqIxCC0ThJyBI4SMNcWw
	lF57/15vCieIINM3zj3grw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1732483552; x=
	1732569952; bh=1Y6PTr/j1+XMevFD9gDvZOX4YuxF2dHvdlIBuDCTZcc=; b=o
	QjQXiFRIHoY2os4kFVNbzRWHuikGNr124LryRHYuKk7z55N6bVpZP2FqN4QgvY96
	mozSMuAthyUWx6XkPw9YECrMb5mue91EBfuc577fXXrNksLqRt9YR0Or3TtINJ22
	ODHKMyjyI5BWiyNEdFVvT4VRDPBzi2iTlDLq7TYFMFDTEGHtudYqUj7JdeWk7eeH
	Nn8ZYra9UqfBOefLQwd2Ml1BIwN/FWqI7hgwUDyj3TSDPV+GFspGeVcBTIZlZEFC
	SsbSrf8LR/EnEyOnNwPkBFc2VB2ZzZ0w5doZ3fXMfH1yho5GHftMptRRP85K9zas
	ieU6j2VXIxGnEyYeic9vw==
X-ME-Sender: <xms:35lDZ0pg8nfjnSVvON47qjAO3aNlS8JDF-ZYoalC-gXoiXaAVPFtLw>
    <xme:35lDZ6qX4wyQMz9hsYrICNiuKw98e4gbCwdF8xQ-tVEeVO7qEXrPtu3JQkeUNmaPZ
    cPCxmlRkKcuigKO>
X-ME-Received: <xmr:35lDZ5OnQiuEJ0xowQkAE7gL422AKnkrO_RJncL7oSdd5ukproPHenGO5fr68nyTJUvhOMCE6jp_vdS7bZykAlKyquW9aqdTq6v2puUFmMOre1Hr_J44>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrgeefgddugeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudev
    leegleffffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopeduuddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthho
    pegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghntg
    gvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrd
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghi
    lhdrtghomhdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomhdprh
    gtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomhdprhgtphhtthhopehtohhm
    rdhlvghimhhinhhgsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:35lDZ77XVoi5Qa274SOGZ8ZeSEU9ZFyVC6RLeEd_--T_X-NcoUXVGA>
    <xmx:35lDZz5UOvYO7Q5-7Fe6MUV-3Ii11LRpiemUhcXZa4cBHDPH7SVPJA>
    <xmx:35lDZ7gulCzWxLTxR_oX6GFov2cat7sp0DKeswKkMowhr8Nu8tHiHQ>
    <xmx:35lDZ97FTjEzC_oLpTsciLoDNt0affvLhEGp0t9RgIz0HkUVkmV9VQ>
    <xmx:4JlDZ3hf8-MppPDAi4XTpQhc8hrHc0cCHqZInLisNWuTZ5TRUHvj5voO>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Nov 2024 16:25:49 -0500 (EST)
Message-ID: <e509c3d7-84f1-4e9b-a1d7-1bb58ddcb5f2@fastmail.fm>
Date: Sun, 24 Nov 2024 22:25:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v6 06/16] fuse: {uring} Handle SQEs - register
 commands
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
 <20241122-fuse-uring-for-6-10-rfc4-v6-6-28e6cdd0e914@ddn.com>
 <CAJfpegtih77CpuSQAOkUaKRMPj44ua65+_MUMa3LqgYjLFofqg@mail.gmail.com>
 <e1f3cbf0-eedf-41a9-9689-5eda56e06216@fastmail.fm>
 <CAJfpegt=CxhYSyxWVBAWnf2S926Vj+1yEF_GPkOJYRMN_XbkSQ@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJfpegt=CxhYSyxWVBAWnf2S926Vj+1yEF_GPkOJYRMN_XbkSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/23/24 14:09, Miklos Szeredi wrote:
> On Sat, 23 Nov 2024 at 13:42, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
>>
>>
>>
>> On 11/23/24 10:52, Miklos Szeredi wrote:
>>> On Fri, 22 Nov 2024 at 00:44, Bernd Schubert <bschubert@ddn.com> wrote:
>>>
>>>> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
>>>> +{
>>>> +       struct fuse_ring *ring = NULL;
>>>> +       size_t nr_queues = num_possible_cpus();
>>>> +       struct fuse_ring *res = NULL;
>>>> +
>>>> +       ring = kzalloc(sizeof(*fc->ring) +
>>>> +                              nr_queues * sizeof(struct fuse_ring_queue),
>>>
>>> Left over from a previous version?
>>
>> Why? This struct holds all the queues? We could also put into fc, but
>> it would take additional memory, even if uring is not used.
> 
> But fuse_ring_queue is allocated on demand in
> fuse_uring_create_queue().  Where is this space actually gets used?


In fuse_uring_fetch()

	err = -ENOMEM;
	if (!ring) {
		ring = fuse_uring_create(fc);
		if (!ring)
			return err;
	}

	queue = ring->queues[cmd_req->qid];
	if (!queue) {
		queue = fuse_uring_create_queue(ring, cmd_req->qid);
		if (!queue)
			return err;
	}

I.е. the ring object is created dynamically. Btw, I still a bit struggling
with struct names - maybe 'struct fuse_ring_pool' is a better name?


> 
>> there you really need a ring state, because access is outside of lists.
>> Unless you want to iterate over the lists, if the the entry is still
>> in there. Please see the discussion with Joanne in RFC v5.
>> I have also added in v6 15/16 comments about non-list access.
> 
> Okay, let that be then.
> 
>> Even though libfuse sends the SQEs before
>> setting up /dev/fuse threads, handling the SQEs takes longer.
>> So what happens is that while IORING_OP_URING_CMD/FUSE_URING_REQ_FETCH
>> are coming in, FUSE_INIT reply gets through. In userspace we do not
>> know at all, when these SQEs are registered, because we don't get
>> a reply. Even worse, we don't even know if io-uring works at all and
>> cannot adjust number of /dev/fuse handling threads. Here setup with
>> ioctls had a clear advantage - there was a clear reply.
> 
> Server could negotiate fuse uring availability in INIT, which is how
> all other feature negotiations work.
> 
>> The other issue is, that we will probably first need handle FUSE_INIT
>> in userspace before sending SQEs at all, in order to know the payload
>> buffer size.
> 
> Yeah.

Fine with me will move it in libfuse


Thanks,
Bernd

