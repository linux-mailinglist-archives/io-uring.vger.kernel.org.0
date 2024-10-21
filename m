Return-Path: <io-uring+bounces-3844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F419A66ED
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 13:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B7161C21BEA
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 11:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D123E1E3DE4;
	Mon, 21 Oct 2024 11:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="gzK14w1Q";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HrTqniu+"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589BE78C76;
	Mon, 21 Oct 2024 11:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729511227; cv=none; b=NmE7uQVcw+yQOFkDSyFDVzjqAbWOOSZd3TSrCAsp4DUHxPqbT4T3WvWif5IG8/eL8SO6h/7r5hg9mmQbBh38HkokTvnV3w90v7KgZHIy/GMfO2ISDQiAzzzPM5Lr37x3OHqnDeeRQ3T1JKwp7Dx1Ug4jszpVTounCJRYA/c5GuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729511227; c=relaxed/simple;
	bh=icDWyVYuGoilzsVGsRx+OQFBkWifsF/RQ0kUHHKaSJg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ax719o0fP/07Memr7mEeKuJNNZ7kgsXUt1TSCRZI5X0KIvOm1q45N9QR8gzOjVvKG5+Za5p6y9XsTHenLLrIbq835egJhBmIEdQB7RYiP3NO6iMl4YNLTd2Fk/EsbiXhOJHF1+jjJwIjpFWiO8jC2N4RpcqSu2vAd2iuLO7ps0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=gzK14w1Q; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HrTqniu+; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 250E225400BD;
	Mon, 21 Oct 2024 07:47:04 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 21 Oct 2024 07:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1729511223;
	 x=1729597623; bh=xYAIc9hKx/tsXstVKFR1tYRGW3CTN4RrIyyMbzt1Ldc=; b=
	gzK14w1Q5xEOl2PE2aO1vwoatEZbK9kcXwqXAGrU/VzOnsVu1QSid2LuKTityoMR
	OYGx1dGrpfCGtzssbiF9/ko7d1OTfiHydxoaRHATQaixBRqIx8ObFh+2WtKFzB0k
	s5Iv7f0BsGarjuwEdZO4jpdckhqrtCsRFVjrpJeWp2FJ7N1OPgM/z1Fq9vUvZcu9
	0RCakSfWrZq4f7mDsakpXfVAQo0EOYwcOP0Tx1HJ6eLa6MCGvu3glt4AwQejdM3X
	kKl/PYjHHdCKkx+mDx1Ly267atBjSPzJUq0i/j4/lcWSAfWB2K1TNaw/54m17mKZ
	NDNEbW8uHwh3VQgCyrMeIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1729511223; x=
	1729597623; bh=xYAIc9hKx/tsXstVKFR1tYRGW3CTN4RrIyyMbzt1Ldc=; b=H
	rTqniu+y6SgNFYWSCexJwmpOZnadEy9ctR5oalaWmx3katMjRjXnogc6novsTL2L
	Hbrc/iRIfLqwqkR7t47lFcfPA8u9Q42hquFsm8GYlvAHjoSEeTI8Jn1SrA4IhucQ
	N6DB8W7lbDWObditlq8R7JCcW5BZ83wfeHFsMP3YtnSKsSBK8CN7ZA0IjZtoZd38
	5MFVandXKvh0wg+Mu/Tv27k+5/hOhqFl9++Zh6lUISjaN56LqSFZ1uVy3+FmYLYm
	Y1ZWL0JzCiqhJKHD///CzApKbPT+KBeZVQWTSrxBoMA2TMJCp62RhQ9tfOdxSCmH
	CFFP+G1vod7PhQX+CL0aQ==
X-ME-Sender: <xms:Nz8WZ4Ei-2NqbzTqVMl2Wtul4Ew-YfgzsCFEVIQX2aDoD4Fm0oc1XQ>
    <xme:Nz8WZxWzzye_IKK67wpSoSZ-YIQx0FLASso1NQXO2qfJydfPo5GWuaKr3t0KS4Rq5
    HTSEyzDpA57b6tg>
X-ME-Received: <xmr:Nz8WZyJ2ENM_OPkvFSRbZYkZqHesHgWKeSpdv9s13KiCCWQpF4DXBkGzSGOiqlaZ0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehledggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfhffuvfevfhgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepffduhfegvdetfedt
    teeihfdvfeehlefhgfehkefgveeugedvfedtheekledthedtnecuffhomhgrihhnpegrkh
    grrdhmshdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilh
    drfhhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepugifsegurghvihgufigvihdruhhkpdhrtghpthhtohepmhhikhhlohhssehsiigvrh
    gvughirdhhuhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthht
    oheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinh
    hugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehi
    ohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnh
    hnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopegrmhhirhejfehilhes
    ghhmrghilhdrtghomhdprhgtphhtthhopehtohhmrdhlvghimhhinhhgsehgmhgrihhlrd
    gtohhm
X-ME-Proxy: <xmx:Nz8WZ6FEYFDDckzqhZOvVpiyHHFnQnGa8RTbAYki9kqT79PU9J03tw>
    <xmx:Nz8WZ-WiVdXxekYyIE3RYCz7kc8Wyyja6TDiMs53WrZpSliweumb_w>
    <xmx:Nz8WZ9O10gcHQJoNY-TkPSjpOnne7CQliRxYEt9WOu0_W_zUnVir1w>
    <xmx:Nz8WZ12ONK-5FY41UPYeMTSGRx5n2SDDLoR0tgo7qntmKNmv81w3ng>
    <xmx:Nz8WZ3O4LhZkknl5B0LW9zkZPFFZ6_1usyFjK8qmsX7xxNIMgGc2lT0_>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Oct 2024 07:47:02 -0400 (EDT)
Message-ID: <ed03c267-92c1-4431-85b2-d58fd45807be@fastmail.fm>
Date: Mon, 21 Oct 2024 13:47:00 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
To: David Wei <dw@davidwei.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <38c76d27-1657-4f8c-9875-43839c8bbe80@davidwei.uk>
Content-Language: en-US
In-Reply-To: <38c76d27-1657-4f8c-9875-43839c8bbe80@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi David,

On 10/21/24 06:06, David Wei wrote:
> [You don't often get email from dw@davidwei.uk. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 2024-10-15 17:05, Bernd Schubert wrote:
> [...]
>>

...

> Hi Bernd, I applied this patchset to io_uring-6.12 branch with some
> minor conflicts. I'm running the following command:
> 
> $ sudo ./build/example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
> --uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 \
> /home/vmuser/scratch/source /home/vmuser/scratch/dest
> FUSE library version: 3.17.0
> Creating ring per-core-queue=1 sync-depth=1 async-depth=1 arglen=1052672
> dev unique: 2, opcode: INIT (26), nodeid: 0, insize: 104, pid: 0
> INIT: 7.40
> flags=0x73fffffb
> max_readahead=0x00020000
>     INIT: 7.40
>     flags=0x4041f429
>     max_readahead=0x00020000
>     max_write=0x00100000
>     max_background=0
>     congestion_threshold=0
>     time_gran=1
>     unique: 2, success, outsize: 80
> 
> I created the source and dest folders which are both empty.
> 
> I see the following in dmesg:
> 
> [ 2453.197510] uring is disabled
> [ 2453.198525] uring is disabled
> [ 2453.198749] uring is disabled
> ...
> 
> If I then try to list the directory /home/vmuser/scratch:
> 
> $ ls -l /home/vmuser/scratch
> ls: cannot access 'dest': Software caused connection abort
> 
> And passthrough_hp terminates.
> 
> My kconfig:
> 
> CONFIG_FUSE_FS=m
> CONFIG_FUSE_PASSTHROUGH=y
> CONFIG_FUSE_IO_URING=y
> 
> I'll look into it next week but, do you see anything obviously wrong?


thanks for testing it! I just pushed a fix to my libfuse branches to
avoid the abort for -EOPNOTSUPP. It will gracefully fall back to
/dev/fuse IO now.

Could you please use the rfcv4 branch, as the plain uring
branch will soon get incompatible updates for rfc5?

https://github.com/bsbernd/libfuse/tree/uring-for-rfcv4


The short answer to let you enable fuse-io-uring:

echo 1 >/sys/module/fuse/parameters/enable_uring


(With that the "uring is disabled" should be fixed.)


The long answer for Miklos and others


IOCTL removal introduced a design issue, as now fuse-client
(kernel) does not know if fuse-server/libfuse wants to set
up io-uring communication.
It is not even possible to forbid FUSE_URING_REQ_FETCH after
FUSE_INIT reply, as io-uring is async. What happens is that
fuse-client (kernel) receives all FUSE_URING_REQ_FETCH commands
only after FUSE_INIT reply. And that although FUSE_URING_REQ_FETCH
is send out from libuse *before* replying to FUSE_INIT.
I had also added a comment for that into the code.

And the other issue is that libfuse now does not know if kernel supports
fuse-io-uring. That has some implications
- libfuse cannot write at start up time a clear error message like
"Kernel does not support fuse-over-io-uring, falling back to /dev/fuse IO"
- In the fallback code path one might want to adjust number of libfuse
/dev/fuse threads if io-uring is not supported - with io-uring typically
one thread might be sufficient - to handle FUSE_INTERRUPT.


My suggestion is that we introduce the new FUSE_URING_REQ_REGISTER (or
replace FUSE_URING_REQ_FETCH with that) and then wait in fuse-server
for completion of that command before sending out FUSE_URING_REQ_FETCH.


Thanks,
Bernd


