Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396EC2DE7FF
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 18:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731531AbgLRRYX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 12:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbgLRRYX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 12:24:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BC2C0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:23:42 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i7so1728630pgc.8
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p6ITp9FwboEryXh6kB8xGxO/WjR1xPYuaMLDaq4LVQg=;
        b=YD+JZE4LxNG6kt87FZEdy+jLoAoKC2tWjPBEzqRUw9kg7yaINmD/76ZW7N7PfE2dH1
         2ZdWLeQaJ/+b3yWeh3F/pCUwmtBP6sjGhLWQ6lM+fmha/SSVVnIcczICYyTAqBVfQ8aY
         lQqlbJGGPFqYfXdslrfVGAnqEJaH0u8FHNKoe4zlVfgTChWwVd6H0YnTe5WRLEyQy3UD
         ZBeEFkS20uyqvPa7XI6ZLZR/GhBXfULgQemYTlPMJabaqrMpHLwOLgeCdZ5sz4UBIs6Q
         JHreajD6R12Jkbx+FRN0mwMziUkPLvRMVqsjwO/5oTajb36Ts6OqPEzCyA5bAl9mG2Xm
         mA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p6ITp9FwboEryXh6kB8xGxO/WjR1xPYuaMLDaq4LVQg=;
        b=lAMqHt0Gr4WFh7oRvLOt3LnS4TchOH0kQb8DtQpwPxWkVixCX1ik/NIW9Bavbyl/8q
         Ac1bsT8JJ1qxzg20vw6RsUGunfmNiQl0VaUb7BqPt2JGY0H9VqBvSA7k70Limz7zlnNC
         6Jyv3Ypem0rO7dxtISUAChNHrDQHqP5GG85ZHIhikJfA1Y5sF6ySRv/UZDPc9PY/E8Vg
         aj1I5RiErSzn6bazNvuUnkTSTUxdw64Nn4OC/oIn58ig4vavH8BiDwAleUnmlz1n3ail
         +RtUUs6ceuwxQt82U82CZSOMH9m748aUwwLmLvOOTR02hrtsyFX5i0/t8KHnUXdG/JZN
         NZNQ==
X-Gm-Message-State: AOAM531iSDxyvYxILpIGYoqqMI4lhu1/iEaYt5E7X/dIdgPUWDXU21q2
        YXuNhmpZLDK7RPY3xiI4CCxB5A==
X-Google-Smtp-Source: ABdhPJz9o0tl6XpIJfVh05OO8iIbTCJSjoxer76EwHp+UdYk9l4Rv14nWrpaP/sarH2QJwi3e8EMxw==
X-Received: by 2002:a63:6442:: with SMTP id y63mr5101122pgb.35.1608312222279;
        Fri, 18 Dec 2020 09:23:42 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e24sm8147977pjt.16.2020.12.18.09.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 09:23:41 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Josef <josef.grieb@gmail.com>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Norman Maurer <norman.maurer@googlemail.com>
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk>
 <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <caca825c-e88c-50a6-09a8-c4ba9d174251@kernel.dk>
Date:   Fri, 18 Dec 2020 10:23:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/20 10:21 AM, Josef wrote:
>> I've read through this thread, but haven't had time to really debug it
>> yet. I did try a few test cases, and wasn't able to trigger anything.
>> The signal part is interesting, as it would cause parallel teardowns
>> potentially. And I did post a patch for that yesterday, where I did spot
>> a race in the user mm accounting. I don't think this is related to this
>> one, but would still be useful if you could test with this applied:
>>
>> https://lore.kernel.org/io-uring/20201217152105.693264-3-axboe@kernel.dk/T/#u
> 
> as you expected it didn't work, unfortunately I couldn't reproduce
> that in C..I'll try to debug in netty/kernel

I'm happy to run _any_ reproducer, so please do let us know if you
manage to find something that I can run with netty. As long as it
includes instructions for exactly how to run it :-)

-- 
Jens Axboe

