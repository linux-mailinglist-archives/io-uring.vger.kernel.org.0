Return-Path: <io-uring+bounces-7143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41936A6A358
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 11:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB033A6D9E
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 10:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2F51C5D7E;
	Thu, 20 Mar 2025 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uapzh6yv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F262C1A238C
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 10:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742465507; cv=none; b=qUPk/H94DQrFVZvxNm2guU8pRRokQdG7xcsolcLKaYEWgntPEgY+48rAedM+tdGnDMUlDvxMP+4flE5OCb3POH3zSbUQBHxaPz/N3bhfKwN1ZnjsLXpVY3jB+4PVV7F8GzdwOl5loMFLPyB05OvVhziy0JSMB4LO4yk5LbcEZXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742465507; c=relaxed/simple;
	bh=XtyF44D9/8nc8FTiB798wUyrBiOPCZfwGrJ4q5LIUgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q+OYZfdlWYCUumV/nz2ioiT4kg8hnP0JezMLbYvwnuVwFcv3kl1OTnHKSvuPq0PTTNqwQ4pgDk7P5+JQJdGQAuIp2AugAGA7wMAwsZGAMQ5yl5/s1qxnRvv+YxII2dNAJMjfaSMo79zhX4FiF0E5DNrBmR1Sy5vBXZKP8FfaDSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uapzh6yv; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5dccaaca646so1203575a12.0
        for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 03:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742465503; x=1743070303; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gXJZZLcSFqpFnmMN1tYTZHOipu6UAxEGZXg7UA9HbPY=;
        b=Uapzh6yvcNjKA6J5vyHMDC79+oXA6Ft1vUdJf7PsZEFATYvErBRKNtStCm1RCoRSlk
         WPopvHX2vtnlEq8oyMCHNikkhJ7HNgVZHITiewQ82oPurs7K5SFFyFr53N0uc07ms/N/
         JErr1nCmW3bNzfd8XODTjoqjgntr5q9hrJbHjr2KtuhyeIEFnf0bXgbvzJk2Wjh+yoE6
         bGZ1C7gMLGFh8lv/gnM98hKJSFoNcDs4BbSOPNQqfwEEATLvaqGswRvjbhrxdnvfoxxE
         l52U208lJpU5rhypySpSF51vOBRx46u6NnzrDN15zo8W6eOokXfpE+mre5gBGxFfRhF3
         Zywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742465503; x=1743070303;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gXJZZLcSFqpFnmMN1tYTZHOipu6UAxEGZXg7UA9HbPY=;
        b=kVWKQSNnZoo9/a9DmLIlsEOjEX2NAe8psg7GuYxCibbbLKOh34eSzmuyMYm+281mzg
         4eFbqP87jdmChb6hOpuXRUlTV0VJQy5o520+5yyDAgEblAATFiuhhQJTgSTkhOVpLye3
         hRovZH+A05L9JQ0hVX5yu597bME6LhyZ0hDDnbds5+6q9EeGnedbgW/LA4pK1X7vFCHb
         P+lD1RfTRMiMvxNozI83ua09jS4K9gyLc4mZ0ShsJSlzBqPJ0qqPSPGayM6OQ6pRuEnl
         Pd4FaZ/oTgUlddhRmiWf4YWeGHkBtWNF2U6vbIwVM9KJ5LgvG73TO6VORSU8IrsVPISj
         sV/w==
X-Forwarded-Encrypted: i=1; AJvYcCU0gxU1nrfmE+cug3TLooZZcfSfUeudJi4h/Fa32KSqDaxoLZg/hI5IS3PpYuO+V4MD9/WQj9Xz4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YytRYG7jlPrFKx7Oj3FcuA+iE/M8Z3gd90cD9m1twP/iCmU/M7L
	dEVjR50OSiv2MoIZ9ESa5yepRWSAQV/BHlTtEKukEyTGx9i+MeNSi1BFtQ==
X-Gm-Gg: ASbGncs/b6kDA+00MeGL6tGtJR9s6yKe35CJw75rTv008JdJ8T2JAHQiEZGn5RlLBB9
	+IpBjXvLJhZxNHENcIxNFCq184Tq0ONv7RgWDTkTLZiXr7g3snhMGC5SExo3AWqIRTDtqcwgzuB
	jSc/+7ilObrojNUCbUAxH71Nrj9VgRMg/MDeJBWGAwVosZkFwQL2OVynKtxESCS99KSNvfJaQlD
	AWEQGEVAzYlchf9Gyv1Uh5noL2gOXWLAN94pfYweENPWW87Q8XOCc+RTtcUtPPc9/3Qi+MVbGxo
	dAo4ukd7R6oyG0aPGqrBXe8v0eE363e+jZ0laSvjjQJGPYYjA1yRs8/WEFdyZ5Gw369qCxQ1u1t
	azQ==
X-Google-Smtp-Source: AGHT+IEx0MezBSOCVPR16/khgnsV2d5UA7oJLx9tBUCaGEdKonOuTFHWI4LbrGpnoNO9L6e7IIAxiA==
X-Received: by 2002:a05:6402:2356:b0:5e4:95fc:d748 with SMTP id 4fb4d7f45d1cf-5eb9972699cmr2835989a12.5.1742465502911;
        Thu, 20 Mar 2025 03:11:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5148])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e81692e583sm10152033a12.16.2025.03.20.03.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 03:11:42 -0700 (PDT)
Message-ID: <ef9cca7a-90a5-4e18-8721-8b83a39177ce@gmail.com>
Date: Thu, 20 Mar 2025 10:12:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: enable toggle of iowait usage when waiting
 on CQEs
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
 <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
 <37fcb9fb-a396-477e-9fe5-ab530c5c26b5@kernel.dk>
 <42d8e234-21b0-49d9-b048-421f4d4a30b6@gmail.com>
 <5be69fe9-4de4-49d6-a457-9720e50c92d9@kernel.dk>
 <807d665f-2b3c-418b-b13f-2c757fc0c762@gmail.com>
 <2fc90b4a-a84b-4823-9eb3-5e330fb17b4b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2fc90b4a-a84b-4823-9eb3-5e330fb17b4b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/25 01:54, Jens Axboe wrote:
...
>> Do we really want it though? What are you trying to achieve, fixing
>> the iowait stat problem or providing an optimisation option? Because
>> as I see it, what's good for one is bad for the other, unfortunately.
>> A sysctl is not a great option as an optimisation, because with that
>> all apps in the system has either to be storage or net to be optimal
>> in relation to iowait / power consumption. That one you won't even
>> be able to use in a good number of server setups while getting
>> optimal power consumption, even if you own the entire stack.
>>
>> It sounds to me like the best option is to choose which one we want
>> to solve at the moment. Global / sysctl option for the stat, but I'm
>> not sure it's that important atm, people complain less nowadays
>> as well. Enter flag goes fine for the iowait optimisation, but
>> messes with the stat. IMHO, that should be fine if we're clear
>> about it and that the stat part of it can change. That's what
>> I'd suggest doing.
>>
>> The third option is to try to solve them both, but seems your
>> patches got buried in a discussion, and working it around at
>> io_uring side doesn't sound pretty, like two flags you
>> mentioned.
> 
> I'm not digging into that again. Once those guys figure out what they
> want, we can address it on our side.
> 
>> Another option is to just have v2 and tell that the optimisation
>> and the accounting is the same, having some mess on the stat
>> side, and deal with the consequences when the in-kernel semantics
>> changes.
> 
> After thinking about it a bit more, I do think v2 is the best approach.
> And the name is probably fine, IORING_ENTER_NO_IOWAIT. If we at some
> point end up having the ability to control boost and stats separately,
> we could add IORING_ENTER_IOWAIT_BOOST or something. That'll allow you
> to control both separately.

After a private discussion, apparently you do care about the
iowait stat, and there are just too many users that complain
about it and tools that misinterpret it. All that "hint" and
"side effect" discussion of mine doesn't solve that.

I think we do agree that it's a poor interface, but there is
no good alternative, not on the io_uring side, and it's pretty
sad that we're forced into a bad design because the patches
actually solving the problem are blocked for a year now by
sched/cpufreq.

  > What do you think? I do want to get this sorted for 6.15, I feel like
> we've been ignoring or stalling on this issue for way too long.
> 

-- 
Pavel Begunkov


