Return-Path: <io-uring+bounces-9613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E63AB46760
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 02:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DFD65C08E2
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 00:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA273315D38;
	Sat,  6 Sep 2025 00:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Hsy/kPXc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEBE17E4
	for <io-uring@vger.kernel.org>; Sat,  6 Sep 2025 00:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757116866; cv=none; b=pGPKQ+u0qcW1q0mVKM6SJAoQVJ6KsvLdfmf/blEkvNBEq1dpuYa090Sb2dCTnVcnM02ftMyA4T8jc7XmIyDcOFD+0mteJ/NpF4CmXdufdDKMe+vEsCwnAXs/l0l/7UiybbG3ECHEDYjoUIpZrUiWjSzFwNCuhTChPjjczvEqDxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757116866; c=relaxed/simple;
	bh=I745OuqVCT8PA+unjsPW/MIzIeXr2r5FQRf1y5CrGQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rS1qnJS3YLZq2ZDo3N4vy1UXbhKoArwa/jfnNLIf66kJoE9jpTrBg6VJ5FCM6jfHi4vBwm5hX6AFUBx1zvObNlnrSFICI9vZgc5xG6HPJpWo7qqFNiaHiaR0XtUsI2OTEU9bM6WRwC3OA+NXJzGySItj5xMIIFoERqJrMPJ33lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Hsy/kPXc; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d603cebd9so32115777b3.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 17:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757116862; x=1757721662; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O7hhVmn7ApxXnBvxlYHbulBxdrRJDIkG54twuFLOHOY=;
        b=Hsy/kPXcNfDk7rZkDa+1qz1HojYoC5IxIr3+/kpA/DXyzI92A6SHJXu//NQsd7kTTn
         Pxkhem+wcQIJOv6o5I4Lan80B5uZke4S+mZGdNw5k5M6X+Rz9PkRHuu5rGmNXJ30vcAY
         rAErdkpwLHQligSGDG5RIdMZC7zT1GlcetQQomWU3YkI2to8LsviEIBexI5orNx3TQ2c
         zjJB28xHvAXHmkSZe0uygTgH/YnopBixQe6exK2IPFlNSvucNjdSQQ0iGCfb+0KNq9KR
         DQQKlv4QrG81WGT3s/bS0kNIKCQ9rHt6g2/kr2u5p4iUilTY7yqkXfq6dAQJpj++hi38
         HP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757116862; x=1757721662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O7hhVmn7ApxXnBvxlYHbulBxdrRJDIkG54twuFLOHOY=;
        b=LMy01bn5lkJmIIH/eIcxnch49ATBmBE/xFHlQcNlRtVCkguaD9HzM5bIw19EyKsNb6
         Wjk/Nwp6jxRXcuJqHhlG1+J7VIYOT0T2NakadZMZZouWEHr8mAWqvaZImmS1Q5AX3clN
         7ihMiMzBj0yhDyUDiPR5C4L5F76YyisPJ2wyeQUSWd0BInuExKlcQt/JmSZngCCc/zc5
         z5VRdMWj9RSbUF9cSIfheDh3ScoHRRsUFzt9PeLrs9DdviO9uH3+Z7KaelILR+zChZ/l
         UT7KpLuVc+W0xC84DpGGIjjndHHvYgGBuHTVWBcByQnXkr0Fi7iaga1ClfP3p+ZLxRx8
         VJqw==
X-Forwarded-Encrypted: i=1; AJvYcCVWFXL4h4isKk8kpyGLTI3JQnIyJ/3tAxEXiTLgRrYQRKPetY1G/1/IqZDjijaLW5CuljizBBl6sw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt+7E/xuLYpvBHUQzBeVXT8ZIJoZhTEKZ6FE5o6f/W/hRk3nBD
	3UuziHZVXEemR9JYMbEoyPG6Xh0166bHfCB9ZB8TM1X/1gVx1jec5HaNUkFLZqrGcgo=
X-Gm-Gg: ASbGncureOHPGf7NgWGAMvRbrZqaDv2aBrcmdJwRRpS1wQZwsfMyZo8S9kIv0Daz8N6
	H2T8bcJtoEhN0H+/YEsoTqHDY4nrROxVkffe9TyYYkF6ileFQnctMeTpAgEEbkS7nH6xT8Cs/3O
	zQv/uwpz6HNm/mznv2V5mySdK76pk8Fbw1b+PXblDLaG/NoAx4QpSVnny/97IZlCZ+83dpw1guA
	2crONjj0xHj3Bgi6A0AwMMn1wzTGJzH3MCdi+bKhoJNnjAYEkLMZ784jJUXeRzxZkUpYk2d3Z5O
	NGXjP5A8F5Be4zcLDsenRkvco+nkDpZGdiT6Fnnpd5tiwFChC/TxRP32R23nrc/Cp7GiVbLbx0X
	WGwxsouFnmSRam+WAYiM9sg+XMEOLCA==
X-Google-Smtp-Source: AGHT+IHgNVCwtMI0/9guEHCsfNnNR1Dy8aWTaz1hyNxfBEFoTst4l6lSZRKX9+Wq18nZ+vqcEy2n/Q==
X-Received: by 2002:a05:690c:9a05:b0:722:8ee9:ad57 with SMTP id 00721157ae682-727f30ae187mr7545227b3.14.1757116862435;
        Fri, 05 Sep 2025 17:01:02 -0700 (PDT)
Received: from [172.17.0.109] ([50.168.186.2])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a85ae106sm32907267b3.70.2025.09.05.17.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 17:01:01 -0700 (PDT)
Message-ID: <a65abd25-69bd-4f10-a8b8-90c348d89242@kernel.dk>
Date: Fri, 5 Sep 2025 18:01:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring fix for 6.17-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 io-uring <io-uring@vger.kernel.org>,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <f0f31943-cfed-463d-8e03-9855ba027830@kernel.dk>
 <CAHk-=wgkgSoqMh3CQgj=tvKdEwJhFvr1gtDbK7Givr1bNRZ==w@mail.gmail.com>
 <72fb5776-0c50-42b8-943d-940960714811@kernel.dk>
 <CAHk-=wgdOGyaZ3p=r8Zn8Su0DnSqhEAMXzME91ZD9=8DDurnUg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wgdOGyaZ3p=r8Zn8Su0DnSqhEAMXzME91ZD9=8DDurnUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/25 2:54 PM, Linus Torvalds wrote:
> On Fri, 5 Sept 2025 at 12:30, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Like I said, I think there more fruitful ways to get the point across
>> and this picked up and well known, because I don't believe it is right
>> now.
> 
> So I've actually been complaining about the link tags for years: [1]
> [2] [3] [4].
> 
> In fact, that [4] from 2022 is about how people are then trying to
> distinguish the *useful* links (to bug reports) from the useless ones,
> by giving them a different name ("Buglink:"). Where I was telling
> people to instead fix this problem by just not adding the useless
> links in the first place!
> 
> Anyway, I'm a bit frustrated, exactly because this _has_ been going on
> for years. It's not a new peeve.

What's that saying on doing the same thing over and over again and
expecting different results...? :-)

> And I don't think we have a good central place for that kind of "don't do this".
> 
> Yes, there's the maintainer summit, but that's a pretty limited set of people.

That'd be a great place to discuss it, however. One thing I've always
wanted to bring up but have forgotten to, is how I'd _love_ for your PR
merges to contain the link to the PR that you got for them. Yes I know
that's now adding a link, but that's a useful one. Maybe not for you,
but for me and I bet tons of other people. At least if there's
discussion on it. But hey I'd be happy if it was just always there, but
it seems we disagree on that part.

What is clear, however, is that the rules on this aren't clear at all.

> I guess I could mention it in my release notes, but I don't know who
> actually reads those either..

I actually think a LOT of people read those. I do every week, and it
always goes on LWN too, for example.

But it does not have to be in the release notes. Just a separate email
with LWN/Jon CC'ed, and boom you have your story and people will see it.
And it doesn't need yelling. Alternatively, we discuss at the
maintainers summit, and come up with a set of rules that can get
documented. And then hopefully end up on LWN too. Honestly I had to
search in Documentation/ to see if we even have any kind of maintainer
documentation. Looks like we do, but who looks in there...

> So I end up just complaining when I see it.
> 
> And yeah, I will take some of the blame for people doing the useless
> Link. Because going even further back, people were arguing for random
> "bug ID" numbers. Go search lkml, and you'll find discussions about
> having UUID's in the commits, and I said that no, we're not doing
> that, and that a "Link:" tag to something valid is a good alternative,
> and I even mentioned a link to the submission. So that could be seen
> as some kind of encouragement - but it was more of a "no, we're *NOT*
> doing random meaningless UUIDs".

Maybe the problem is indeed in the name, it's very generic to call it a
Link. If you see "Closes: " you know exactly what it is, it's for some
bug tracker and you can click it and expect to see more info. Maybe
"Bug: " would be useful, or "Report: " or whatever - naming is hard. But
Link literally tells my brain, it's a link to the patch. Maybe there's
discussion there, maybe there's not. Because like or not, I do think the
generic nature of the name Link is part of the issue here.

-- 
Jens Axboe

