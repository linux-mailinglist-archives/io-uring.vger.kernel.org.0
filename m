Return-Path: <io-uring+bounces-9666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA3BB4FF95
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 16:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA2861C25639
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 14:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0BE350D42;
	Tue,  9 Sep 2025 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0GDAS6Os"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1B0350842
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757428522; cv=none; b=dm19OGBEI5nS7130gQ5qa2FEIHfGlEGaMAlAyVBAatSlfJtuQPdmUTr+jYwF2RUz+kNPJ1+h2ujUhppTYv0ov0/U96q3UUuyObVN55E+yqhUBraccVjpkWvObSL9B/C1b5CLmUwEo58rLzPI0l9n3H/4VeiVH/CdN6/sc7W/rqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757428522; c=relaxed/simple;
	bh=rQWH/NmcpNFnxB0wgun6+QVk7GxdIWJElTzM6KFhoAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EOAHxmeuibkBOF9qWXFUZJii/HpW7zmjmfBo263V/zsYArQLONjg5Kx21enmk2nJx7lywywhFt68n1qh0V3MhWC8DKK6ABfwEOCCRqn/aMTdTfz2qiqmoNh6rRsZ5vfBSQSTo8z3Q5P6MQecf6xUyJoOepnLAM5oLzBHRzVewmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0GDAS6Os; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-88432a1ed9aso70038639f.1
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 07:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757428519; x=1758033319; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EMgUYo9u9E3FopZ0TDjXKfzm0MSZWxygWvWesTcsWZs=;
        b=0GDAS6OslgMQwR5jwQ3TbH4YKD3FhNHwec9oXQTsDYXUen/wT8zbsVD2LK6oY1c9Tn
         nZzSxSJW5rtZzTjm3tbASNwOhWb1mnC6TDzgRzOBp+9uCwSdo8WcWMrIYB9lzq3h3e+5
         0aVcU4OgW4U9dKSG3EXeigxREg47QnFuR3RxPs35Q58g8CKMHjpApV4SX6CasxQv8hwE
         bNp406qDFrsvlwqD+VL/0z97KEqjayR3fyLww4BYsAbbs28qBcJ+gH1onHs/0S3F7/QL
         dzEaX4n1MSa1ZD7UQMvH1Tspv/fCxDQPOyWHCoch+gX/GXD0BeCeQpvq82ilvV4V+NA6
         rWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757428519; x=1758033319;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMgUYo9u9E3FopZ0TDjXKfzm0MSZWxygWvWesTcsWZs=;
        b=FDkxsrltvMVAERtICMnov+c1KAUpgLeiPNpKP2aQONWNIrm9dzVgEtgMO2xOxX/Z/R
         1Kc1AHB9uZzXGcyr8dxFnM1uh6S4X7Ui22sSjYWREbU7sNWW47+6BOgZmn3o16l6zSl7
         Wjz0HfvR02tt3ozUE6/wQwyy8sXxWCNFqi+Ql6Us6mweMP1K0SS2OQc2C2iY5jBr5kwp
         XHz/lTIDxWpsamI/I4MWYWqp0ROSolbplV0NXLGBWDDcWC1dIQF1grP4ScJ0o2/zvR+e
         T4OCRA0EGrNq6A6pkU9v1bSqAnDCzgYorqc2MudTfYg+b8At9UJn/rLSQq9MNpHu8BO1
         sw/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUPzWFlBhtI03VB+2rjOxyF/j5sJ+HJOxjrJbGmQp6lJnoxiESxRYklPzyerfFlhZPNOFF2l16Hwg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7l/yZ5oAlLdBgLWFzxssezwrn3wh7kHCnF5tg8S4qvs7ZTp4E
	GTR35ZFfRBaV39d2OnnnxArdCkanPxXax5y0JrtUrQydDet8ejIdqGITmWDItbqLNfI=
X-Gm-Gg: ASbGnct92RCMqBNZ4NGUhvBC6Wt7LjC0XME73QN5u0lwPKhXiKl5XjqSyvQ9BOuVwyz
	eo9wdpK1Go+DsSOqUJWsH3dHnSu8FjXIiSr/vFWRJEgssQuMOIJaDSMm2TwFVOqXa2EfEdINZjs
	D48hpU4AnnSruBXxOeY6HS2vAPS3XHe7UaLK/k6MA8Hbg96M1kD7JSNSnBKT1YvpyqMM7yhYsXD
	dZY41LhWe7XHyoVMCgrduJbH0wxwT4QXaIUBZP1jDQUzIG+D6tpkbP17XVE14+Adehgj9mXvB42
	pR+/6X+c61R5SmWuk28FEtboGAQETlsHVR03z2OJpbxGHktTd/B0MppQEyg0JI8rw0eSw9E4Zgp
	zqVzhQASaEGQNXGLKUSY=
X-Google-Smtp-Source: AGHT+IHaannFzQXhK7EjrWWeA0pcTCulS9Fd5iidHKoVs+Dzgs/KTqYZPXCTQxNYHuxa2UK2dtfBrg==
X-Received: by 2002:a05:6602:3fd4:b0:883:fc4a:ea55 with SMTP id ca18e2360f4ac-88777999fdcmr1890133939f.3.1757428519370;
        Tue, 09 Sep 2025 07:35:19 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-887711c4ee5sm408829939f.17.2025.09.09.07.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 07:35:18 -0700 (PDT)
Message-ID: <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
Date: Tue, 9 Sep 2025 08:35:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
To: Jakub Kicinski <kuba@kernel.org>,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com,
 Caleb Sander Mateos <csander@purestorage.com>,
 io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250909071818.15507ee6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/25 8:18 AM, Jakub Kicinski wrote:
> On Tue, 09 Sep 2025 15:17:15 +0200 Rafael J. Wysocki wrote:
>>>> We do support this usage using `b4 shazam -M` -- it's the functional
>>>> equivalent of applying a pull request and will use the cover letter contents
>>>> as the initial source of the merge commit message. I do encourage people to
>>>> use this more than just a linear `git am` for series, for a number of reasons:  
>>>
>>> For me, as a subsystem downstream person the 'mindless' patch.msgid.link
>>> saves me time when I need to report a regression, or validate which
>>> version of a patch was pulled from a list when curating a long-running
>>> topic in a staging tree. I do make sure to put actual discussion
>>> references outside the patch.msgid.link namespace and hope that others
>>> continue to use this helpful breadcrumb.  
>>
>> Same here.
>>
>> Every time one needs to connect a git commit with a patch that it has come from,
>> the presence of patch.msgid.link saves a search of a mailing list archive (if
>> all goes well, or more searches otherwise).
>>
>> On a global scale, that's quite a number of saved mailing list archive searches.
> 
> +1 FWIW. I also started slapping the links on all patches in a series,
> even if we apply with a merge commit. I don't know of a good way with
> git to "get to the first parent merge" so scanning the history to find
> the link in the cover letter was annoying me :(

Like I've tried to argue, I find them useful too. But after this whole
mess of a thread, I killed -l from my scripts. I do think it's a mistake
and it seems like the only reason to remove them is that Linus expects
to find something at the end of the link rainbow and is often
disappointed, and that annoys him enough to rant about it.

I know some folks downstream of me on the io_uring side find them useful
too, because they've asked me several times to please remember to ensure
my own self-applied patches have the link as well. For those, I tend to
pick or add them locally rather than use b4 for it, which is why they've
never had links.

As far as I can tell, only two things have been established here:

1) Linus hates the Link tags, except if they have extra information
2) Lots of other folks find them useful

and hence we're at a solid deadlock here.

-- 
Jens Axboe

