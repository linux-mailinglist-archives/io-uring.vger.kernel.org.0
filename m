Return-Path: <io-uring+bounces-9671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D2CBB50012
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 16:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03F645E523E
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 14:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9F32505AA;
	Tue,  9 Sep 2025 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LHEA4QTi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D06F226D1D
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757429438; cv=none; b=WxDU/9bbk4d1yYXWAvw0V0O6SxAYhAgkAuIUTyKGjqjCTtxibNq/vzguHyc55U2LPLTGu7bkL148NWvAwHFRxaOZ8YiVSU/ZEifeLG4rlnzMptYGc1Fqyw3/nl3+clTKV+yt+XRRZThtf8uce1Aj9uchhKNflyFtJf+Tilc2x/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757429438; c=relaxed/simple;
	bh=/HQ7eG2EU/1xoy+iu4MjOdCrQNrXHQmUwHmc2hEXyYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJDdRNcNNPPuvidFzeLyiKbuEpyUYIVXrvlS0yNPrXQ/jXwt5P2+3Y1IK6q50BDYGOjvZ83x8XmUo3Js5mRbEmqkWJtvcrtphjBpwzdf0N6oOxFzQcmN5PhpyRJIQewOIYW9NdPwXPyLzsnHiypG66jRi2gd1uUJCPDU2lHrAyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LHEA4QTi; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3f66ad3fcf4so58400455ab.3
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 07:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757429435; x=1758034235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DXLblETDvxgJMHTAUnUTKUamNq1cz28z86qXHFq5Z8w=;
        b=LHEA4QTiE+vwLKZNjoeSTBkGJHfDYSTSKX+jyMPNZUV3fwxalTzdLAHanXIHLDhgMN
         yeFNq47bT/H0Pxit0/+K+3D6f7PQ2H0zsgiIuKOkuSz0gkot5FNmHB9FpDl1ndPC1tqb
         9GXAthLMoNxxKqAhRTU76FjrhRjYtfVR9cWE2Bz5H5GIV2iFp+h0ZH9ImxEFbtXdfURu
         35V0Bab76Uu1atpaNAtX99QHokC9kDhnZG82kn3AmXFcWAW6ZXuqOILW959qB/jE/uEB
         cYZIak2VKIoulVzRYpSR8RR+6wf2oAzJQmXiO3GfoEjM6BQ1cI6+ZmN73TYy/k/MBqns
         WwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757429435; x=1758034235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXLblETDvxgJMHTAUnUTKUamNq1cz28z86qXHFq5Z8w=;
        b=L1ANLQMaa2WXQdXpiT5bb408kUmpG3+7bCr18J0YbygdT3gkt40YKcukr+NS3BJ4wt
         pWQkgFxbdDijpvhjPmKR5cZy68/DYhTXOOs+Zrz4H09IBsF1U+A+eohBh/oz39smuDw/
         ysV7efLe1yK7XtI2hkg9eoet+iC311a0EHC9IB/26BKhS9vLck8bvBoKCt7YdLGSpO1K
         w5gvsazzSz3h/FH7U13GEGftQhrxByKh8/xUBLw3nrT3TiwjtQEVZ4poW9JqLf6kDJgj
         /8wioRqj4LFuIcnrzRjzR34r/3Ihpp63CkSaKqfiWqPe0MyuUArkFi838iLB1BZfICp7
         yjCw==
X-Forwarded-Encrypted: i=1; AJvYcCVED/KyNddnzPmEFzSUKxHNzcX82oG4ZsLoImw1Sm/vW4OT/0SSfiO6ikaGTdkgdq4kTjQqveccvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxU7NWnwhh7e27Nb9WpPPGh+W+NKDUu9T43z9RlLbvHdCZU6wEW
	YDFP7f5EhuSmxakS4yRTX+uv9IT3alkllUomfwR5KBsw8KZNooKQgsxOBJjyBqnDEHU=
X-Gm-Gg: ASbGncvRgZ4AF2C69el+E+fzfWJY3h0boEkRYOUmkEwKvwwmTPFaAvd6xCiB3rJ0Pf/
	dmKBQHfeQ6lkY0uPUnEifJx3XpwhfVCa4Ab7l1/OiKtfBIB+nmZ0NWszteoNnVuGiiT6vMwJEb5
	ftL940USuH2bMOEa/LEWYOeg2H8jK49FGdptN7hNtR4trAo7PLMevTQkgC+V8GkmXab9JP8N/+2
	lZN0ZAkSU3FJVGA24xh7UC85rvA6mFplWpztYrkuTP7nRnVKP/0JSYz4uqCSpuZTsr9SSitlYEF
	XzVR9XsFwdXQI2Nq+kzfNFzt5BezvejAxOqa7r08Esby2WBaR6PN3s9qbY72EWyW8x3udQzp2cj
	VIT5uWytTx3KIZtF8YIDoRwyFGsKqYw==
X-Google-Smtp-Source: AGHT+IG8on+GnBlP4B7ZwsdBR6evH84/qt5pimUFsPIyK0o6XVGa9c2E1LFU0VJp+XvtVThhxs07Ow==
X-Received: by 2002:a05:6e02:1c2e:b0:3f3:b6c4:7cce with SMTP id e9e14a558f8ab-3fd89bf009amr192865295ab.27.1757429435400;
        Tue, 09 Sep 2025 07:50:35 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f3e136cc71sm121472625ab.46.2025.09.09.07.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 07:50:34 -0700 (PDT)
Message-ID: <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
Date: Tue, 9 Sep 2025 08:50:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
To: Vlastimil Babka <vbabka@suse.cz>,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com,
 Caleb Sander Mateos <csander@purestorage.com>,
 io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/25 8:48 AM, Vlastimil Babka wrote:
> On 9/9/25 16:42, Konstantin Ryabitsev wrote:
>> On Tue, Sep 09, 2025 at 08:35:18AM -0600, Jens Axboe wrote:
>>>>> On a global scale, that's quite a number of saved mailing list archive searches.
>>>>
>>>> +1 FWIW. I also started slapping the links on all patches in a series,
>>>> even if we apply with a merge commit. I don't know of a good way with
>>>> git to "get to the first parent merge" so scanning the history to find
>>>> the link in the cover letter was annoying me :(
>>>
>>> Like I've tried to argue, I find them useful too. But after this whole
>>> mess of a thread, I killed -l from my scripts. I do think it's a mistake
>>> and it seems like the only reason to remove them is that Linus expects
>>> to find something at the end of the link rainbow and is often
>>> disappointed, and that annoys him enough to rant about it.
>>>
>>> I know some folks downstream of me on the io_uring side find them useful
>>> too, because they've asked me several times to please remember to ensure
>>> my own self-applied patches have the link as well. For those, I tend to
>>> pick or add them locally rather than use b4 for it, which is why they've
>>> never had links.
>>>
>>> As far as I can tell, only two things have been established here:
>>>
>>> 1) Linus hates the Link tags, except if they have extra information
>>> 2) Lots of other folks find them useful
>>>
>>> and hence we're at a solid deadlock here.
>>
>> I did suggest that provenance links use the patch.msgid.link subdomain. This
> 
> Yes, and the PR that started this thread had a normal lore link. Would it
> have been different with a patch.msgid.link as perhaps Linus would not try
> opening it and become disappointed?
> You did kinda ask that early in the thread but then the conversation went in
> different directions.

I think we all know the answer to that one - it would've been EXACTLY
the same outcome. Not to put words in Linus' mouth, but it's not the
name of the tag that he finds repulsive, it's the very fact that a link
is there and it isn't useful _to him_.

-- 
Jens Axboe

