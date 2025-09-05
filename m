Return-Path: <io-uring+bounces-9607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D073DB463A5
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 21:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A1E816E889
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 19:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB6F220F2F;
	Fri,  5 Sep 2025 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B0grQHhQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABED821FF33
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100626; cv=none; b=NxR/H5M9OQvUGKMmsRJi3gcLW9r4O60J6VwyDrGT5RpWb6xJgyrrztE7G4iCDQq1zpeklG+KdeyJckbH5UZ5ckrOsg9qjV+I5cTaC1KA9lx3qkPj+pM74Yfw57EUpTqqpotk4AKocso0TmW7tTi85YJGs7+mq4QZz83jkMap2/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100626; c=relaxed/simple;
	bh=LIvLLzeWxngEMM03p/AmrSIdqWB80bRVcTwF4Db8KI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2imH7gjahbbNpuQQUY5WRLggMzsF2dTaZXp4W/OKupTYL8/4kZt6k01VrUoL6g5t1jR7BjskJh1jKZ6GxLvbcOz6c+wJ+COEDrwit90QjtrToUyyWrNwzNZ840/AX7Ip/jP+Qm8LDYSQBxGvCH/WIVNl3dzYwgJQohAgVX3Qi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B0grQHhQ; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-723ae0bb4e4so28729767b3.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 12:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757100621; x=1757705421; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UeCLZVR9qp4o8K0h7QYu1xDU39mEJgRdW0I1Y4sZcfI=;
        b=B0grQHhQKGW3jkTqY95aERSFWQW/ULIGUpbggRFfKWTiKsPt7JvBLSBCK3sOYEOeiC
         tGfY3yoILKGDIKUoGZeGRKqxidSQ4aiJLz6JyxKRVrUMichzvSsvANwH44uNad/XzRzb
         w1/s5tZDWdy/6LXjGV+YFtp2F6DM/eHiX2O/pDzD4Xtsx75BxazKrYQ3qqWAmJjBGJVg
         9Gwl0tbVlEnCCKGTt+g/1p+LgEspiR3+e9ZAuq/M3t0O6opar+MmFjuWOqzz/02DGWX1
         V3jz6GVg71+Y5d4iquJ3Nq0FJSOT5MxMKBNiggB146/Wct8x3xd4bZlZuvKoYIptqq+8
         pMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757100621; x=1757705421;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UeCLZVR9qp4o8K0h7QYu1xDU39mEJgRdW0I1Y4sZcfI=;
        b=qJZpZ4xoEdC3XzHUo55P52yqvYhW0EB9NTsaDVp6joqe+HQqHQ1+qLwedcEnZuoGcL
         z11PRU8tP4Zve+kN6Md8PyfZpIxGhP3+7Avng2B9SK4bdhNYTjrmTG6gALRseaxsewMc
         XjdZ01ZUi9W0DVHai1VvIOET/iCxX6qJqoSF0FM99/MwMVjIF6BDtT8z24B56Zi0IIpW
         fvldotomG+QD6ldQkFCBL5k7rlwErt9mvVYCYMOnHOlEHhu2fDQYEvaDrJJ7/3fhQISB
         +HcUmKVH6cmxr+71EhIEY3mtPLm4B021ee3zqEc9Flo3LvueSUHzHiPIhkShd5OCA1no
         FOgg==
X-Forwarded-Encrypted: i=1; AJvYcCVemrUeDejyU42rVOhfnEo1MwRa0d+gFLKQkuvwOcpI5oeS8jywv55HQgcyCwlUGBxeQFMo9quAoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPuMRGLZ4f+15Z0fzzSiLOSKAvz7YQ1sZX/DV2ysgYYlLrtuK9
	ECcR78Kl7qMJC1vLjulnR8lp2ow56DbJZDFymlcUqpXxDupdxBN1rPVZPc1R/VVGAOQ=
X-Gm-Gg: ASbGnctkajUPSFmnl7XmHAXzOASMcCqTTbgZuB//wHeRbIt4Sd4X8YQ4e5eCZKk5O15
	ME7DD5Kvo+gKyMxtpnyH4QIgg2PGnPA0qGz963FQFmlath8KLXI6mRe60os+EL5hx+FXd5zbkb/
	N3O/WNrmOHxGTdQFBArhFztpr0ebwW0A6X0kaOnnHlY9I7tBLi1eGrof9ogpPKiLujYqOusC7NK
	qEIUv08eEjPJWjQeo5e6HQRVDnSIinhZaIB1Wnk0AqF0Jg1GtclugH6gFyFPL4///daAhIYIp4N
	HaGsTgLPiC3fa0o/G9MYioE0fOivWrs/BmNfOQT/IsAlpnF1gbEm8YtRlzJOZ8nNAZWO5guBauL
	A/eBocs+IbIgOeuKTZi7c/mg323xSCw==
X-Google-Smtp-Source: AGHT+IG0gQO8H6mqRXwALtCbtcE7r45Vp1bxBcTphTjbS1pb5ua70uZIuVvidY9u/Sq0ntrl7dJ06A==
X-Received: by 2002:a05:690c:9688:b0:723:b94d:97cf with SMTP id 00721157ae682-727f4383b3amr461947b3.10.1757100621371;
        Fri, 05 Sep 2025 12:30:21 -0700 (PDT)
Received: from [172.17.0.109] ([50.168.186.2])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-608110cabd6sm2004567d50.8.2025.09.05.12.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 12:30:21 -0700 (PDT)
Message-ID: <72fb5776-0c50-42b8-943d-940960714811@kernel.dk>
Date: Fri, 5 Sep 2025 13:30:20 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wgkgSoqMh3CQgj=tvKdEwJhFvr1gtDbK7Givr1bNRZ==w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/25 1:21 PM, Linus Torvalds wrote:
> On Fri, 5 Sept 2025 at 12:04, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> What is the hurt here, really, other than you being disappointed there's
>> nothing extra in the link?
> 
> And just to clarify: the hurt is real. It's not just the
> disappointment. It's the wasted effort of following a link and having
> to then realize that there's nothing useful there.
> 
> Those links *literally* double the effort for me when I try to be
> careful about patches.
> 
> So the "what's the hurt here" question is WRONG. The cost is real. The
> cost is something I've complained about before.
> 
> I'm tired of having to complain about this, and I'm really really
> tired of wasting my time on links that people have added with
> absolutely zero effort and no thinking to back them up.

Like I said, I think there more fruitful ways to get the point across
and this picked up and well known, because I don't believe it is right
now.

> Yes, it's literally free to you to add this cost. No, *YOU* don't see
> the cost, and you think it is helpful. It's not. It's the opposite of
> helpful.

As a maintainer, yes it's free to add, and it removes the cost of
needing to think about this. Which is why lots of people just have -l as
the default. Exactly because then you don't have to think about it. I do
agree that this adds a lot of frivolous links, I think the mindset has
just been "well better to always have it there, rather than to never
even if you rarely need it".

> So I want commit messages to be relevant and explain what is going on,
> and I want them to NOT WASTE MY TIME.
> 
> And I also don't want to ignore links that are actually *useful* and
> give background information.
> 
> Is that really too much to ask for?

No I think that's fine, I'm mostly just complaining about the approach
in getting there. I think we all prefer the commit messages to be as
useful and relevant as possible.

-- 
Jens Axboe

