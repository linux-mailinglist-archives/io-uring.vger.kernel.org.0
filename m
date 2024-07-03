Return-Path: <io-uring+bounces-2435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E16492687E
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 20:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D938B28330F
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 18:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B6C186E3B;
	Wed,  3 Jul 2024 18:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="uQ4YFtuj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="henDsDRR"
X-Original-To: io-uring@vger.kernel.org
Received: from fout3-smtp.messagingengine.com (fout3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911711891CA;
	Wed,  3 Jul 2024 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032314; cv=none; b=DY2BNmIC7IDCF/j+IRTWNlYTM7o/ntdn8qg4A4Fmng/cu44qmYtAR2ORoKBJjdCgnfMPrjd0Etn5pnfYI+1kAfaduPeNVGK+xj+yzdybRgNZrvlMT78NWw48onvsjxUVbsOt1d8IL51eIVIXI3AcV8KwkysXZabP8PgoJMBpM3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032314; c=relaxed/simple;
	bh=1HAUPmxyK03Kz683iTuisW6s29R1cGrirF7oFDboFUA=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=jm4xodiS8tXrqnGT3U3yq9AFRE5Y3uSaw0gaB4ASiuom+F2Jab48UalaplWHAWV7SbqIjBSrsdopvoqQIOa04erw8s/gxGZ/OKeOKHUOdrE3mvmXvJ0V9/Oh0TJLFlePxiZzTPadcsL4tSWAnrPc77JE8b+2vaE5PAjtey6mX9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=uQ4YFtuj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=henDsDRR; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id C074213800AE;
	Wed,  3 Jul 2024 14:45:11 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 03 Jul 2024 14:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1720032311; x=1720118711; bh=EFR6lVRiOK
	NkSmgerDmIGmryUFpvxrTuGj4sDMv6LuM=; b=uQ4YFtujx0iAMZbEkSSPfBw//w
	Aur1tTE1Qbso8Qh56qTd1bnaFbQo+kmB/NGJqeOI2XV8HsRJMG7843ABjamNxMnj
	M4ovl7iWTLqMKDf2Q+1qH4ds7PtTS1k4dWr7lrJAGnaAp0nzlTRdMwTZJ3bSuQwv
	XWrABZJ5x5z4SfnBbh9+UXQ9KBDGVU6Wkx0r2n4+7EjwdxE7NNrlH3uFbdX8xl3Q
	UdD0H4f5JegElE8jF7PD8GeN0dBo9laTfrXToPEAEHuw8+0lWgZU1n+bC8lSzNDx
	U7ZoLL4eBDJIlXyEXratlmB4J0ydxZwMErKZKG/kyRXNsl2E0/j8dx8madKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1720032311; x=1720118711; bh=EFR6lVRiOKNkSmgerDmIGmryUFpv
	xrTuGj4sDMv6LuM=; b=henDsDRR8/F745TtI0Y1tC5+Nc6H9jEggKnNn3OHRM2r
	3OHlEMBEmZwhK6LSWkqi/LCQQ4dvYVESR5RBf+wOQwG8WBmlISDBJHj9lf3SRNDk
	9gs+9SvVRgEvuhkmt/SnNwvVLztalAClHlseHc2xI0lBg1pps36ss01EQogXAmmF
	CX7dTP3DChLjFm1OIVXZPxe/bSuSeB1CoAQiu8PdhCujII+9uVULHQxu2z4FGDaQ
	hh8pCxPRm/e2WoKoEJGoyiOz6z90bOKiR90BdsH9jlFQJx9dNrY2uyM/jcCtAQi1
	L6MfDNZmczYPctWOZkIEkQbAHTJhwySVDK2zduwLPA==
X-ME-Sender: <xms:NpyFZg30A3MeOPyKrPuwUoDeB_OwRpWC0ZPGHwnSiy0tomE1Obxvxw>
    <xme:NpyFZrGz5A-UGfdmxRnxGjaKhoRAhYhMw_NYH6Ptfv_AX1Sj6_SElDYfRwip5yYoe
    JJ6j3aIscbLsUHB9pw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:N5yFZo7gXVqAPjDWi2QezGkWDZ2JL7YakJk7qiYZAatQt3Mf8YykSw>
    <xmx:N5yFZp2cgz1mDDb_W-9hY_89kt1J6cHgOLxKUz_iuwSS59Ky8wmm8g>
    <xmx:N5yFZjGBvjIJ4JC0EC-Qz0j5pahLu5UN_rIwi9cuwG1W-dh58T8CpA>
    <xmx:N5yFZi-kQdsbAyW1IUXnOJVEnbrhBfq45fG0m2QElEAoAFPPUsiWNg>
    <xmx:N5yFZjEeYshha2BPTAgTbkxpsLLtlhc8Dpb-_paLn8_GKVyj3ZuaN4n6>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id E5373B6008D; Wed,  3 Jul 2024 14:45:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-566-g3812ddbbc-fm-20240627.001-g3812ddbb
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a30ac1fe-07ac-4b09-9ede-c9360a34a103@app.fastmail.com>
In-Reply-To: 
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
 <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
 <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
Date: Wed, 03 Jul 2024 20:44:50 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Xi Ruoyao" <xry111@xry111.site>
Cc: "Christian Brauner" <brauner@kernel.org>,
 "Xi Ruoyao" <libc-alpha@sourceware.org>,
 "Andreas K Huettel" <dilfridge@gentoo.org>,
 "Huacai Chen" <chenhuacai@kernel.org>, "Mateusz Guzik" <mjguzik@gmail.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>,
 loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Content-Type: text/plain

On Wed, Jul 3, 2024, at 19:40, Linus Torvalds wrote:
> On Wed, 3 Jul 2024 at 10:30, Xi Ruoyao <xry111@xry111.site> wrote:
>>
>> struct stat64 {
>>
>> // ...
>>
>>     int     st_atime;   /* Time of last access.  */
>
> Oh wow. Shows just *how* long ago that was - and how long ago I looked
> at 32-bit code. Because clearly, I was wrong.
>
> I guess it shows how nobody actually cares about 32-bit any more, at
> least in the 2037 sense.
>
> The point stands, though - statx isn't a replacement for existing binaries.

We had long discussions about adding another stat()/fstat()
variant with 64-bit timestamps from 2012 to 2017, the result
was that we mandated that a libc implementation with 64-bit
time_t must only use statx() and not fall back to the time32
syscalls on kernels that are new enough to have statx().
This is both for architectures that were introduced after
time64 support was added (riscv32 and the glibc port for
arc), and for userspace builds that are explicitly using
time64 syscalls only.

That may have been a mistake in hindsight, or it may have
been the right choice, but the thing is that if we now decide
that 32-bit userspace can not rely on statx() to be available,
then we need to introduce one or two new system calls.

    Arnd

