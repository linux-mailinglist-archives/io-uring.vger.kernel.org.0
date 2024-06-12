Return-Path: <io-uring+bounces-2182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F446905467
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DAD1B22E9E
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 13:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D612817D896;
	Wed, 12 Jun 2024 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="cF0wr9Vl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Q19rxdog"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh6-smtp.messagingengine.com (fhigh6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3717D8A3;
	Wed, 12 Jun 2024 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718200428; cv=none; b=uhlgkhvk2f+kSp/2THYENq9FRpgT1xVJvuQhGHosmzCNVicFKWtiL6ubbp4CayWA2GokK1mKt6UVJK8kYOf9dJzEYU8JrLVzh6XOEV6F8R4DxCYsqmF6yXBbVUOKCWoOlIB6duEb0dHIx/yrKrs90bH0GTfOoxgl2fIdkcBOYCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718200428; c=relaxed/simple;
	bh=ZpVYUlFXqmjNveupy/CsImDfgCtQUrYeZ+0EALhWhY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tsN+cBNKV1RjhQZHMa/9RQPANB/c8LvgkZtS6G0VPYiYJIZBwiRxmCdQQkpbIA0CYPS1hIM3aITBZxynSgqBDJWNd7uZ9FTDUz3nS76p3S7ZIiRrd4eYb8Gj3QitWfoyp8INgk3RB9pMXbJeWplEHQprbDGNjxqYpSPcuZT+m00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=cF0wr9Vl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Q19rxdog; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 1F3611140201;
	Wed, 12 Jun 2024 09:53:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 Jun 2024 09:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1718200426;
	 x=1718286826; bh=04DJWBew/hHwmU0Ytn7mCPWz2PLbAvV1Cam6ofFkdHQ=; b=
	cF0wr9Vl8GqaJwBu+Q+PM1mDuxRuMDC4jaOA8pLHbOI+NLnALW607n3lwhioU30F
	fQe6bEkzvI7wtQ6HQbiMjxF37VVEZqSWWUShs8IjxPHIw4zS3POyxWKJGaRJ1fIO
	3AcHQl1w1e5Vpy5budr5o0NSW0+oJTkJiMjsmNKEsvk1LaUvZH56m6Rbs8HH75C5
	ROwFC6b2PmH3eRFLBDhhLNoSd3kF65kPdpBWLCOmTlSdl+TIQ4A6CDiiVpRYxwx6
	uRb4VHeYTX9q/4uYyS1jliaATE5YxKSytcp2DTo8TJrTQRrYskcRLd1zv5A7IJHI
	lCx3pKzgXR5h1TYg3LwBPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1718200426; x=
	1718286826; bh=04DJWBew/hHwmU0Ytn7mCPWz2PLbAvV1Cam6ofFkdHQ=; b=Q
	19rxdogsji9GS6RBtKhgkC4CGcaBxZtQTEcPxW9G+bhc1L/LKWEMTDKIRy3Ypqiu
	ssw0TGgiKAMfAoKtQLgMNxpm72G/9V/ZZkAMY3+D785ROpP7cnhlNcTg3WvEXrfk
	QqoQmy7XJFPWmPA61GOWwp0dY2p1rv4TJeFlM1FUgct2XaJ0WPFzWCvQnavmPBrE
	9TcJU2hmekRVjKLE0XAp0yYAAH3q/+kJiTtx9xrRrDnM5tuQ8frnnP+HtHNAMVaC
	557UcrbFPdP+8CxLu0C+CPWVzXnAN4M6DwHf7oKwsdIv14qEGX7DHvHi3Mf+7Jp3
	XLrsmc5AWg7sYYjZMcwkg==
X-ME-Sender: <xms:aahpZj6aTE8sIZUPP-jAyitmG1QJ-338k-SZ1AbUF1OS4URHok0n3w>
    <xme:aahpZo58T9MoMKpZxxxWxKBILrfA-R6fenJM1GUNIlaYGcZaYNoV6aR8g8467V3qQ
    TAw_Z272n-xEE9Y>
X-ME-Received: <xmr:aahpZqf0B1HxOTe-AVez_oFdzDxvYN79vSe06sfdQCwwksXBp5YxgmmJ3VlFEL97Aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfedugedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepvedvfffhhefgjeetuddvhfffgeehhfelffek
    ffehvdfhfedvhfffjeekgfekkeefnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpgh
    hnuhifvggvsgdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrihhlrdhfmh
X-ME-Proxy: <xmx:aahpZkKhCEeBx9yQrhYzjfBluwa0dll_kIFt3QrTz_Kpb3ddTIjfuA>
    <xmx:aahpZnK5qSDhd7vwD2VvhlwsbieCsUcnMdV0Dfw6QShtZMmqfym8Kg>
    <xmx:aahpZtz93rbJPEGpU1IlB28HEiSoNuTlsxoNTpR8AYwkVyzJGxc3GQ>
    <xmx:aahpZjJQc3YP6YBJr95Fo-w_ntq-k5liXVMXDfUEXzpa0GsSHkNfrg>
    <xmx:aqhpZpw_4PJp82sYMtWJMun91qjAiggaNldlfVvWA6UnvSLA86V4aoeH>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Jun 2024 09:53:43 -0400 (EDT)
Message-ID: <a5ab3ea8-f730-4087-a9ea-b3ac4c8e7919@fastmail.fm>
Date: Wed, 12 Jun 2024 15:53:42 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>,
 Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US
In-Reply-To: <im6hqczm7qpr3oxndwupyydnclzne6nmpidln6wee4cer7i6up@hmpv4juppgii>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/12/24 01:35, Kent Overstreet wrote:
> On Tue, Jun 11, 2024 at 07:37:30PM GMT, Bernd Schubert wrote:
>>
>>
>> On 6/11/24 17:35, Miklos Szeredi wrote:
>>> On Tue, 11 Jun 2024 at 12:26, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
>>>
>>>> Secondly, with IORING_OP_URING_CMD we already have only a single command
>>>> to submit requests and fetch the next one - half of the system calls.
>>>>
>>>> Wouldn't IORING_OP_READV/IORING_OP_WRITEV be just this approach?
>>>> https://github.com/uroni/fuseuring?
>>>> I.e. it hook into the existing fuse and just changes from read()/write()
>>>> of /dev/fuse to io-uring of /dev/fuse. With the disadvantage of zero
>>>> control which ring/queue and which ring-entry handles the request.
>>>
>>> Unlike system calls, io_uring ops should have very little overhead.
>>> That's one of the main selling points of io_uring (as described in the
>>> io_uring(7) man page).
>>>
>>> So I don't think it matters to performance whether there's a combined
>>> WRITEV + READV (or COMMIT + FETCH) op or separate ops.
>>
>> This has to be performance proven and is no means what I'm seeing. How
>> should io-uring improve performance if you have the same number of
>> system calls?
>>
>> As I see it (@Jens or @Pavel or anyone else please correct me if I'm
>> wrong), advantage of io-uring comes when there is no syscall overhead at
>> all - either you have a ring with multiple entries and then one side
>> operates on multiple entries or you have polling and no syscall overhead
>> either. We cannot afford cpu intensive polling - out of question,
>> besides that I had even tried SQPOLL and it made things worse (that is
>> actually where my idea about application polling comes from).
>> As I see it, for sync blocking calls (like meta operations) with one
>> entry in the queue, you would get no advantage with
>> IORING_OP_READV/IORING_OP_WRITEV -  io-uring has  do two system calls -
>> one to submit from kernel to userspace and another from userspace to
>> kernel. Why should io-uring be faster there?
>>
>> And from my testing this is exactly what I had seen - io-uring for meta
>> requests (i.e. without a large request queue and *without* core
>> affinity) makes meta operations even slower that /dev/fuse.
>>
>> For anything that imposes a large ring queue and where either side
>> (kernel or userspace) needs to process multiple ring entries - system
>> call overhead gets reduced by the queue size. Just for DIO or meta
>> operations that is hard to reach.
>>
>> Also, if you are using IORING_OP_READV/IORING_OP_WRITEV, nothing would
>> change in fuse kernel? I.e. IOs would go via fuse_dev_read()?
>> I.e. we would not have encoded in the request which queue it belongs to?
> 
> Want to try out my new ringbuffer syscall?
> 
> I haven't yet dug far into the fuse protocol or /dev/fuse code yet, only
> skimmed. But using it to replace the read/write syscall overhead should
> be straightforward; you'll want to spin up a kthread for responding to
> requests.

I will definitely look at it this week. Although I don't like the idea
to have a new kthread. We already have an application thread and have
the fuse server thread, why do we need another one?

> 
> The next thing I was going to look at is how you guys are using splice,
> we want to get away from that too.

Well, Ming Lei is working on that for ublk_drv and I guess that new approach
could be adapted as well onto the current way of io-uring.
It _probably_ wouldn't work with IORING_OP_READV/IORING_OP_WRITEV.

https://lore.gnuweeb.org/io-uring/20240511001214.173711-6-ming.lei@redhat.com/T/

> 
> Brian was also saying the fuse virtio_fs code may be worth
> investigating, maybe that could be adapted?

I need to check, but really, the majority of the new additions
is just to set up things, shutdown and to have sanity checks.
Request sending/completing to/from the ring is not that much new lines.


Thanks,
Bernd

