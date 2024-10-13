Return-Path: <io-uring+bounces-3640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1EA99BBFB
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 23:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EF6C1F21389
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 21:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC818F64;
	Sun, 13 Oct 2024 21:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="ELEkTJbC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FJEZgoi3"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C87231C88
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 21:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728854460; cv=none; b=lghbcELyk6FDESe1JUUatrV0RnTClNGHSAm8luxmmXVCuEjF5avmQusJEWnwxgukWUoubWOaaLk3Uoo65KA0iT+Ftfm4eRTJuIxl7DskN2lH+n4NC26GtelLjfYWMDUMGoufXZ3k2X2jP/hAhealrvsEDVq28MdD0iVYsTpKH0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728854460; c=relaxed/simple;
	bh=zg9M86MV/FLWGlZsKLe5CNq/iAdv1NaIvA7nxXcSIXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=icsZisnLRJzJEwFCO6LI8roies5n5+dpIZfsfW/F0b+ENaeN73dvbgTe5Bueku6X1U+q+YYDoR5Nu+KCTXGXwDxZ7zBBJDUCsrMmcBl1Yk5Uy0M3XibAK4SMBlX2BUtZDSo2UdMnWqIvX1jJD6UrOr2rqvDF0jRGCTbPkAjRnUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=ELEkTJbC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FJEZgoi3; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 95A261380778;
	Sun, 13 Oct 2024 17:20:56 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Sun, 13 Oct 2024 17:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1728854456;
	 x=1728940856; bh=qA/iaIcLDfyGbMP3JKpXpk4wzRWV4AQdpqtESVgmNYo=; b=
	ELEkTJbCum3DfHbgGPrNs9eFSnJCoNkuegzGR+LpIYGQnvFefcp0HDJgcSfadN63
	0UyRhV0DLWnjgy4/bJuEF8l9YbkI52gkvn9fmq1qH1+dTmC/LH4KwI2jGu6RbsVQ
	6xOzzPyuVcKIdPDylPnR5OD2sBS1RHYXIaA3oiXcR3oF8JBh1f6+3mMNilEEAong
	7jb9ocsDPT2yB0Yfb9Efxxk6S5UtHsmAhjzRwrju7z4rdJ/FD+Y3Bc/qxQuxpQrr
	HckdUVmZKHNHrKaw9tVtyZaLGXrHur3ynIFrrwSY7cm2V9JNnA5ZUsw0nBZ7qhNO
	zGiccVFOQD/IFdfMxH3IqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1728854456; x=
	1728940856; bh=qA/iaIcLDfyGbMP3JKpXpk4wzRWV4AQdpqtESVgmNYo=; b=F
	JEZgoi3Dworcd2exhGtwmnT4gOr5ihk/j1YbkCFwY+xp2TeJ9A7YNKiVNBR9OPfl
	PMkN+S32LmEhWOKq/zrIHzTZy73kpCY0tmECDdwaCoeaCg1heVLzp524WGHrvTYm
	buNBwUKaAODvQb/eEia4sh+aIvUJJnMUPbd09mTGhwQXk05cHP8qQ7D2ks2Wz3w7
	z6Vs5L8eBExoQZyWewm9GNolrWC8a14SlXDYQHfMIRLlUORyGGLPBh/l5He1UOrt
	ITcgo9vAOx7df7eEW8a3Wp/6LsUgsBM3RJdC0P9Ap4LFEMIkJK1F8MmK9HjN9rUV
	+4Q2NNk+wwoQM1r2ql3KA==
X-ME-Sender: <xms:uDkMZw87jtFUxeZ9mf1vfugj0BBWcDg1joyJsiUVbSnQO_KgVPBHBw>
    <xme:uDkMZ4u7aL5salu8OEQA_S4O3NiodGqTb_qaNk87GC6LWyd3LCg-Jj4tIO_JixeEU
    IWJ1MAlM2aVa_2I>
X-ME-Received: <xmr:uDkMZ2AUm5BTNXZaZmChfgcJesj5mTv4rqzr0pDQxKuV2L8TN90pFrx3xyyJ1bUYVCvwxIDbV6YBjP4F76JBEylnzcve2ZArm-UhmVnp-XKNcpnmTCYZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdegfedgudeifecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusg
    gvrhhtsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddu
    gfdtgfegleefvdehfeeiveejieefveeiteeggffggfeulefgjeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghr
    thesfhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopeht
    ohhmrdhlvghimhhinhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepihhoqdhurhhinh
    hgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghsmhhlrdhsihhlvghn
    tggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughird
    hhuhdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgt
    phhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:uDkMZwdZuTOswu_iHBg5UwJQGhKTGs6GnSDjbF72Xvego3RwTAsS_Q>
    <xmx:uDkMZ1P2nuy0m6T7f-YsyAwVw7mlFZ_QTExNQHxc_JgIf_R1w4AnAw>
    <xmx:uDkMZ6kPaCDptuL3OCehV1TETJhug02oRy3HrIdgUXZixTQQlpk0iw>
    <xmx:uDkMZ3sSyrojktfQmI5hx0W5tXV36ob_ZgKuYMvaORWr_utWJJFuKQ>
    <xmx:uDkMZ4c-dDdNLWdi-5yCHophkiHDEtlhxg_oPURw9CN6RbOw8NTYE4Mp>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Oct 2024 17:20:55 -0400 (EDT)
Message-ID: <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>
Date: Sun, 13 Oct 2024 23:20:53 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/12/24 16:38, Jens Axboe wrote:
> On 10/11/24 7:55 PM, Ming Lei wrote:
>> On Fri, Oct 11, 2024 at 4:56?AM Bernd Schubert
>> <bernd.schubert@fastmail.fm> wrote:
>>>
>>> Hello,
>>>
>>> as discussed during LPC, we would like to have large CQE sizes, at least
>>> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
>>>
>>> Pavel said that this should be ok, but it would be better to have the CQE
>>> size as function argument.
>>> Could you give me some hints how this should look like and especially how
>>> we are going to communicate the CQE size to the kernel? I guess just adding
>>> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.
>>>
>>> I'm basically through with other changes Miklos had been asking for and
>>> moving fuse headers into the CQE is next.
>>
>> Big CQE may not be efficient,  there are copy from kernel to CQE and
>> from CQE to userspace. And not flexible, it is one ring-wide property,
>> if it is big,
>> any CQE from this ring has to be big.
> 
> There isn't really a copy - the kernel fills it in, generally the
> application itself, just in the kernel, and then the application can
> read it on that side. It's the same memory, and it'll also generally be
> cache hot when the applicatio reaps it. Unless a lot of time has passed,
> obviously.
> 
> That said, yeah bigger sqe/cqe is less ideal than smaller ones,
> obviously. Currently you can fit 4 normal cqes in a cache line, or a
> single sqe. Making either of them bigger will obviously bloat that.
> 
>> If you are saying uring_cmd,  another way is to mapped one area for
>> this purpose, the fuse driver can write fuse headers to this indexed
>> mmap buffer, and userspace read it, which is just efficient, without
>> io_uring core changes. ublk uses this way to fill IO request header.
>> But it requires each command to have a unique tag.
> 
> That may indeed be a decent idea for this too. You don't even need fancy
> tagging, you can just use the cqe index for your tag too, as it should
> not be bigger than the the cq ring space. Then you can get away with
> just using normal cqe sizes, and just have a shared region between the
> two where data gets written by the uring_cmd completion, and the app can
> access it directly from userspace.

Would be good if Miklos could chime in here, adding back mmap for headers
wouldn't be difficult, but would add back more fuse-uring startup and
tear-down code.

From performance point of view, I don't know anything about CPU cache
prefetching, but shouldn't the cpu cache logic be able to easily prefetch 
larger linear io-uring rings into 2nd/3rd level caches? And if if the
fuse header is in a separated buffer, it can't auto prefetch that
without additional instructions? I.e. how would the cpu cache logic
auto know about these additional memory areas?


Thanks,
Bernd


