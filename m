Return-Path: <io-uring+bounces-4361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 563FE9BA5D8
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 14:58:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5D731C20EDD
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 13:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CEA170A3A;
	Sun,  3 Nov 2024 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="kl++LKv5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ajs5ogkw"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B693AE552;
	Sun,  3 Nov 2024 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730642259; cv=none; b=VdJYkvOBbX/9HSHYbaKrDjNIUD1WrQnj5iOOjxhi1agc/Bd7WFv0Q1IQRfzgBUtZ4TFFt/o7xXyboDme4wPBAIc+WUOUsEyAHl8Z09AF+uUnpEMeog/VlUfzQqFOryV5PgUNOpCdZ9LkkyltYYGiiGsAlb2LfwVt8O6QWQ2KolE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730642259; c=relaxed/simple;
	bh=zpyduir8KASLB7Yy6vBo7DqLdhBpiamlPJhbHc7oh0o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=eGS0tAdTmX1x8PCa8/HWmnGc8tPq6sHqMAdbHrZ3jvFnr9DojZd+2NM0Wmq2413xctbTWoPioDcNnw8Q+LyBayRgtZiv/ERiaUf1AJt3eFlMsKfLcq1/jYwNE5ssh8IPerfq7wMzJ+BH0manMtpRcR2HMMWfS4u4UJDf7IADdPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=kl++LKv5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ajs5ogkw; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 89A10138013E;
	Sun,  3 Nov 2024 08:57:35 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Sun, 03 Nov 2024 08:57:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1730642255;
	 x=1730728655; bh=ydQGTnO+D+8IgXolqjrApABtyzUTC1FsDHb85LN5EBs=; b=
	kl++LKv5ur8JF8VDRjLQVLqY+1hqs6JwpI7YEJzRcnCTO3Z8fnvPYbSJn8zaDFjR
	TzaKNapPTrgDhUimyG7GK+nt+ohFuSWerG5SRxaIHyqy726ehxCHlH89BoPPjzHc
	a4ozIgZMJasFMzYLfpIFiQi2qzRnxn/57I5JDSgMpadwakvlkpFrC4HRI2bHRZ+z
	xAFC8RqaVLXPEYXNEQcKhcUo87JZzaaHrDMXeobir65l8iCxg4EV/zjBX+GBdmQB
	8KETsVcbEBtkGTt76ALzsu8nS1cmlG+MbruPuECjIv3SRM+l9NbnkGMWDySlsbFS
	X8lUkgAkUlt2m1qjKv2xbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1730642255; x=
	1730728655; bh=ydQGTnO+D+8IgXolqjrApABtyzUTC1FsDHb85LN5EBs=; b=A
	js5ogkwSnRaA8Gn6DwR9Z0i/ZrMmRHFoM7x1cMS+wR0yB4dG5stM8RxKKpQmHhyO
	vNBIrNvAU9pZ0Qd/fzTO7vt6kkL6n8yPVgWdsA88TEe4q3dFj0DVDsPkMqqnQNhg
	LjYotuQvCDgB3IMfzj9cOu+5Z58Q2qtfisqJBabQquPVhaRDVklgLVd114yzUl0L
	rOYdhhq2JTdizKndUohqgGUuRBbM83Y1axbL665AkKO7zkINw2iEfxbDLfI1ulYi
	UvVG4XRzzo2oi5JRDo8049BRCXSgXs9S0x/Swtp/OAJb1+tOZuzi35jPRWZKlYti
	3dJ5LYcUi3Z8lUgaRhLqw==
X-ME-Sender: <xms:ToEnZ3DJ3gEM7imtb0kDgDLY63odQqLQg2Vy2wqIgVJm7YwjgcksOw>
    <xme:ToEnZ9iADBCE14U-BLMgoWe7eRJvqGc0UonoqxSCtOtU8zmlq5FcrtChY7C5M0qav
    iZ6gulHnp9JuhrSa7M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdelgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddt
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefg
    gfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepiedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptghgiihonhgvshesghhoohhglhgvmh
    grihhlrdgtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphht
    thhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrih
    hnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshgu
    vghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhhirhhoseiivg
    hnihhvrdhlihhnuhigrdhorhhgrdhukh
X-ME-Proxy: <xmx:ToEnZylElR-_KhxNM7nl09AQwin57FTlhrWuz2U3aIq-WDZllewGYw>
    <xmx:ToEnZ5xHejaKCc3wuAKkKo3Q-c08ZZgttYp9LZko6G5hJPFMu1wacg>
    <xmx:ToEnZ8RpepYdyY2YeMVLDSFxT_iy8vtiTVXMkaoPEln49KYyK-rtTg>
    <xmx:ToEnZ8a8uwYaGnKI03rs8MY0LQWZaFJLeM4Tezp-_lGCgSDxOjLxXg>
    <xmx:T4EnZxLmTYt7hpf-Iom7IZFUuBMViJ4Tj4zz01DgHoIE8fcyZUsijRV7>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B93332220071; Sun,  3 Nov 2024 08:57:34 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 03 Nov 2024 14:57:14 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jens Axboe" <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, "Christian Brauner" <brauner@kernel.org>,
 io-uring@vger.kernel.org,
 =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Message-Id: <a8081b55-c770-4709-aa9e-f55c85d78cdb@app.fastmail.com>
In-Reply-To: <20241103065156.GS1350452@ZenIV>
References: <20241002011011.GB4017910@ZenIV> <20241102072834.GQ1350452@ZenIV>
 <2a01f70e-111c-4981-9165-5f5170242a8c@kernel.dk>
 <20241103065156.GS1350452@ZenIV>
Subject: Re: [RFC][PATCHES v2] xattr stuff and interactions with io_uring
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, Nov 3, 2024, at 07:51, Al Viro wrote:
> On Sat, Nov 02, 2024 at 08:43:31AM -0600, Jens Axboe wrote:
>> Tested on arm64, fwiw I get these:
>> 
>> <stdin>:1603:2: warning: #warning syscall setxattrat not implemented [-Wcpp]
>> <stdin>:1606:2: warning: #warning syscall getxattrat not implemented [-Wcpp]
>> <stdin>:1609:2: warning: #warning syscall listxattrat not implemented [-Wcpp]
>> <stdin>:1612:2: warning: #warning syscall removexattrat not implemented [-Wcpp]
>
> arch/arm64/tools/syscall*.tbl bits are missing (as well as
> arch/sparc/kernel/syscall_32.tbl ones, but that's less of an
> issue).
>
> AFAICS, the following should be the right incremental.  Objections, anyone?

Looks fine to me.

I have a patch to convert s390 to use the exact same format
as the others, and I should push that patch, but it slightly
conflict with this one.

We can also remove the old include/uapi/asm-generic/unistd.h
that is no longer used.

I was planning to have a patch by now to only need to chance a
single .tbl file for new entries, which is a bit behind some
other work I have planned for these files.

      Arnd

