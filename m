Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60301156B58
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 17:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgBIQki (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 11:40:38 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44234 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBIQki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 11:40:38 -0500
Received: by mail-pf1-f196.google.com with SMTP id y5so2429393pfb.11
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 08:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8LMjvnOnAPyqLmMXIt+ioZBsT16q2yvo/xCr2tE35IQ=;
        b=Va2+n9j4LzRk/jUgQGeW0aqj+wuUu3koQTiOdiyjM12Fv73bjOYYjKxgr/GUOKcPpX
         BnH50+wZ3fHDJ/kETddVjoYw2Rnz+rgloFgT7B0mrStVdQ97RWZhlu/64V+lwittOivY
         TSU71PKvgbJ2v06BSdHwyXmsSQfKlYVGMraB032w8/5LfMb9KbU4N8zPp/GAsbZmGXgL
         iQsZZk2Ev2jYmgYCuIW6wvEuAP3bqoEtyQ/5QlrsR6UZ6EZOQb1q79jVw49BvEwA58E1
         DmUDqkRcdU8ZMl24gvMN5lY4MeYO2vpoLRVqn3fJbs+yv3sykHMj2aRqATJS5wEsLsfc
         wfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8LMjvnOnAPyqLmMXIt+ioZBsT16q2yvo/xCr2tE35IQ=;
        b=okOzd/NpPaamCmgFBFi1UyE/7zIaCUkF39Q2vmJV+h76P2yB/nYOCqIzn28HDE2LNG
         /+m+B/dqlUrZdVwlG/LrO7AsrvW9uQydxhuWwModfMrVoSVWkQLfMocu5yb5EaZzOP8F
         M0QPjjdT8zDc4jzFrIl4O29VW8yQbhyJXxtmV3PRR5A0i5/MhgTFG24d4DiZVC90xr0h
         p7yNBew6EG6q8Z+qm85Pixd9Jaa4eZf+i43i3F6J3fsZH5ylOOMciNzgSwAzErqXzCRY
         UPfWgUOCQN9nPsktwZ5npEOgdJToDIYiny6BI9s7LMMoTkUqy8iKgmt5XSmNIgkBlv0e
         EHlw==
X-Gm-Message-State: APjAAAXBGIG2kAEtlANP1FfYJfz11G/+ApEyWRHSbcYEECRgK+YNwYoO
        E1Ao8P3PkJQa2I6gPpad+rABBEx+szo=
X-Google-Smtp-Source: APXvYqzTFGMnUiRifkoluIATTFhJmjohk6w+xLEal8LBhwRiodjxBch9YxkSoxvwut5dFhtOWyjSsA==
X-Received: by 2002:a63:4b49:: with SMTP id k9mr9929940pgl.269.1581266435811;
        Sun, 09 Feb 2020 08:40:35 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g21sm10301358pfb.126.2020.02.09.08.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 08:40:35 -0800 (PST)
Subject: Re: sendmsg fails when it 'blocks'
To:     Jonas Bonn <jonas@norrbonn.se>, io-uring@vger.kernel.org
References: <6b909e30-c31c-b7f0-fa3a-d30d287ce427@norrbonn.se>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6b95410a-f5d3-1d32-d191-dea46e86f45c@kernel.dk>
Date:   Sun, 9 Feb 2020 09:40:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6b909e30-c31c-b7f0-fa3a-d30d287ce427@norrbonn.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/20 2:25 AM, Jonas Bonn wrote:
> Hi Jens,
> 
> I've been trying to use io_uring to flood a network link with UDP 
> packets.  Essentially, the program just pushes a series of sendmsg() 
> calls through the SQE ring and keeps topping it up with new calls as 
> soon as the completions come in.
> 
> When the sendmsg() calls complete immediately then everything works 
> fine; however, when the calls 'block' and get queued up in the kernel 
> then the calls return either errno 97 or 22 when they're retried through 
> the workqueue (effectively, bad address or invalid iovec length).
> 
> My gut-feeling is that there's some issue copying the msghdr struct so 
> that the call that's retried isn't exactly the same one that was 
> requested.  I looked into the kernel code a bit, but couldn't really 
> make heads or tails of it so I though I'd ask for some input while I 
> keep investigating.
> 
> I noticed that liburing has a simple test for sendmsg that sends a 
> single message; the 'punted' case doesn't seem to be tested.  Is this 
> something you've tried?
> 
> Tested on kernels 5.3 to 5.6-pre and the behaviour's pretty much the 
> same with regards to the above.

You could try and pull:

git://git.kernel.dk/linux-block io_uring-5.6

into the current 5.6-pre tree and see if it works for you.

In any case, do you have a test case for this?


-- 
Jens Axboe

