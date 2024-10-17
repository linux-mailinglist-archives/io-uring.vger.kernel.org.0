Return-Path: <io-uring+bounces-3757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E0619A195C
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 05:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6AE028758C
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 03:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B0841C6C;
	Thu, 17 Oct 2024 03:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTbpkvOz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D626BFC0;
	Thu, 17 Oct 2024 03:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729136387; cv=none; b=a1YyqyAd1BWlMQC1O7jIlM62M5CsJ3cTzMk98VaM3S/MHy0LM51j4b/E/z5dtrhzhPG4cOTvAyREIfQ+99nhOwsIyDSk8WOvPBgmvgSlrA8DGCvyRIjkUmg7Uaaa/mnvIxl2NfGLA/RGR3IhDLaDBXZL4sFYrfr12ApjTR04Drc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729136387; c=relaxed/simple;
	bh=ll9KNLkVW5eVQ/kDk1KI8rxOkRgzBSrnu0RG0fEV+3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gVpEKO0dBYPRO3Yew4Q24sVSK8dl4yOv0t5B3yzHl/lFkyvWaFwe6OTorxXimfiCzt+a3uwjxAGGclkwPMvQa9idh0b7Iyr8GWR6AyAfGezVD1DgSxBJFB0YlKWHTcGACY7x1S/Rek048Gl5NAEpYUE0ORdR0J7+dI3z2Omw9XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTbpkvOz; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a039511a7so8511366b.0;
        Wed, 16 Oct 2024 20:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729136384; x=1729741184; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s0tI51HOKytW0kcq7yTi5a60pKE5OoOTWRqkx7pSWOg=;
        b=fTbpkvOzLBSy04lj874IymwEgOyA5GlqtVRgZivUKdguXkqkFaCLPHMmfcAm0h+DBz
         ae8WuTCiL3b1b2XUGRgHzwo03P5wdqVgyUYXGBteTxl7IOxv8l5vxWZhVPXNT6ebAMjz
         n7fo6Sv11hIZ9Ajl42FIw/XaD6zozxxJuke/nnbUhrr/I96YXyCpQHGjmgH2hXY6nTo1
         PZuvNObGNL8zkLcrDapIOtgAZin9rirqCKFcXHHfxPeMqaGkShiSyyyBQhO7/tYSNC45
         HV/FUouyQAClUK5Z/pLIpsoGz9Kd+ev7q/+uOsJym5x1ot2tWo47+V5fySeXMOzk7G/6
         dbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729136384; x=1729741184;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s0tI51HOKytW0kcq7yTi5a60pKE5OoOTWRqkx7pSWOg=;
        b=RIIps9K0+exjAqwc8Gml/TvYhQU72+tokL8tw5iWBMQo2z8zjV3NL0ctKAhJ93FkZG
         4mJlQMpnXJpyksLtPGyuvnRwiCGUJTvNMlKeX2ot+Viec68O8QnTpoQcqoPEVWG2WQ7x
         USLiQuVFbW12iWzsbokLk/56ItLFM99RayI6xCGoOW2BRGGDFIQld/EmE4Pu3oAYXTtV
         balqyzOM8Rpc4TEGTS51tMQjnxs/NE/KzNj2Z+Bl53qUn2orO2WD8V/+pbUdkP1r3/Af
         ioLDL14z3hDL41dQWw6z/AcfwYJuowvsu6CuQ/QcyP5YBvjNAbMXXfNGbXeFIhIydtLC
         pX1g==
X-Forwarded-Encrypted: i=1; AJvYcCUbHL964fabDckmuB5iowThZfj/nq7j9GoW/sGmQxKpIEU3IUXmm2YFT/O5eNA+WynaQAJXTf+ym91Ksb1/@vger.kernel.org, AJvYcCV7bqd7CjSZYm8LiJy4pg6sqC2F12oQJz1/dzfrIYLpT+EY0smRJqfz28i+owGYIz39KbnOAIM6pw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8UOybnq3J5/qxWDpmGAPGh5R6r6EP1rEb1gv8dxKQZr/aA13s
	6CcOzwMavVw1fMUZr5dtQUnfcXLJbWAEkWCItQzWVyQGluDs97MJ6oJli7hIDW+hxio9yM+Fex/
	UkpXyZWJNZVc61XfzJjNJZOcwMlk=
X-Google-Smtp-Source: AGHT+IHH6ahqEN9cRcWFEfqUSV84Ayz569JIzcrs+n+rLrJme226TWECzbw+PiLJSqEUz1VBBWJLV0pzol9WtZq58GA=
X-Received: by 2002:a05:6402:40d1:b0:5c9:3f3:ae0 with SMTP id
 4fb4d7f45d1cf-5c9a5e76c7bmr451534a12.5.1729136383905; Wed, 16 Oct 2024
 20:39:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJg=8jwijTP5fre8woS4JVJQ8iUA6v+iNcsOgtj9Zfpc3obDOQ@mail.gmail.com>
 <CAJg=8jxg=hCxTeNMmtUTKeBhP=4ryoAb0ekoP05FOLjmDN5G0g@mail.gmail.com>
 <f02a96a2-9f3a-4bed-90a5-b3309eb91d94@intel.com> <fc3a0edc-f2fb-488a-81d9-016f78b5671d@kernel.dk>
 <CAJg=8jzfbrG+-wBz29wKKPXuPFSR_1Ltb6mmO9czh-834aN0UQ@mail.gmail.com> <15c0859f-445f-4159-9b38-3af6d9a2a572@intel.com>
In-Reply-To: <15c0859f-445f-4159-9b38-3af6d9a2a572@intel.com>
From: Marius Fleischer <fleischermarius@gmail.com>
Date: Wed, 16 Oct 2024 20:39:31 -0700
Message-ID: <CAJg=8jw-ZfYjuxUVK5WZU9n+-igfonpeN=mBfy9qqmvnUUe1YQ@mail.gmail.com>
Subject: Re: WARNING in get_pat_info
To: Dave Hansen <dave.hansen@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com, harrisonmichaelgreen@gmail.com, 
	Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Dave,

> > TL;DR compile syzkaller, copy syz-execprog, syz-executor, repro.syz into
> > the VM and run the command below inside the VM
> > ./syz-execprog -executor=./syz-executor -procs=8 -repeat=0 repro.syz
> >
> > Please let me know if you need more details from us!
>
> It didn't reproduce for me, either, at least ~10k executed programs in.
> How long should it take?
>

This is surprising to me - it triggers the crash within 4 seconds for
me. syz-execprog
should not even get to the state of printing the number of executed programs.
Could you try compiling an older version of syzkaller, specifically the
commit bf285f0cf1f7863e0b0d17980de703fab89476bb? I noticed that the
instructions I linked to above mention that a difference in syzkaller version
can lead to issues.
Not sure if this is relevant, but I am using the bullseye image created with
the script provided by syzkaller as described here
https://github.com/google/syzkaller/blob/master/docs/linux/setup_ubuntu-host_qemu-vm_x86-64-kernel.md#image.

> The next step would be to figure out specifically why get_pat_info()
> failed.  To double check that io_uring is the thing that's involved and
> (presumably) why follow_phys() failed.  Basically, I think we need to
> know what state the page tables and the VMA were in.

Sorry, I am very inexperienced in debugging such crashes. Could you
expand a little bit on what state of page tables and VMA exactly means?
Are there some specific kernel structs I should dump?

Best,
Marius

