Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860BA1B803D
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2020 22:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgDXUL7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Apr 2020 16:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDXUL7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Apr 2020 16:11:59 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47C0C09B048
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 13:11:57 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id j7so5121573pgj.13
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 13:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qs6+14MYm0RtJWJZAe/BTNaI2oDLYoEFf/uXYdJz3a0=;
        b=XU2xAeGdDX45+4hPCNU7IxLVo0JZZ6Bx6tMCnyn5VNjeTQcV0hREf6tVJNhEyb1MHx
         XtaWGYr8Id7oq5vvNYSjXNUdufUpL8bTzHx/ymbMxwEZ/6jup09FCj98l/jdyhvm6kWa
         c488yO0xUAyRbw2sO5yNirqXuHh1j1/+2+qUxOke8A2Eqtuy/tVWezlyagZlvXjkJe6l
         F86mkR2cjnS2tZoFyMfUBRVyYEf+mMuSw18w2WTKB4VcCBjAdWiwHncYG/vofBsLkIoR
         OSiUbG/V+TnRK+HvYrBpHGkBlVPREOCOwoApU6YTmxbHWPCV0zBFGO5k1vJOiR0sgWPX
         7cHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qs6+14MYm0RtJWJZAe/BTNaI2oDLYoEFf/uXYdJz3a0=;
        b=hMKljugu9rsg8e6pO0RVh/Lt78HJkcqQoY5rxxnHPaDmP8TV6Kw+yDlNLWP6j9k0p2
         a027+B6GTJB7SnuHmAYO/0x4Og8FZJJ1e3vJtLfdKz+EO4XCDBMEyZhYY2EUCOPBvsdx
         8ZrSoMXsFeR1Vw/gzQvadEUWiBaoS5vksMyZ8um0jDlnGPZfpHVHLooIaMvq7zC5PHzL
         qTRPU5LQhGJD4Nc1EHP01vm0PrcMN2nUz2yrl5wBgIfJAQW1FLJAe4V+jkVd8KAOYrdZ
         rlIZyG47IuQr8YJvAvT9aolSCE+KfcRSS0rKM2X1kMrFDQ+8QB5KVifx4NBDAXaNlRAw
         8xkA==
X-Gm-Message-State: AGi0Pubsq7Yl60SNi3OnzeQsrvRUkR/1+mzbmsXUAXRDCrL2lcs62hGf
        tpuaHu2+sioYwBTwQI6UQcMGiw==
X-Google-Smtp-Source: APiQypLsgNm7rYon6RX6CqXnAiAXgIQ1GDutJAoov7v4Yd5o9nw33xgmZ4tXHbUXS340sLyqa9/YXQ==
X-Received: by 2002:a62:3044:: with SMTP id w65mr11522316pfw.270.1587759116875;
        Fri, 24 Apr 2020 13:11:56 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u9sm6007215pfn.197.2020.04.24.13.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 13:11:56 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring fix for 5.7-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <156f8353-5841-39ad-3bc2-af9cadac3c71@kernel.dk>
 <CAHk-=wibcCGvPy=PjevdSzEtzrYPWJnLo+t=S3zy3AQ5+NNeEg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f903c9de-cec8-0a3e-efae-a3d37b6db4ad@kernel.dk>
Date:   Fri, 24 Apr 2020 14:11:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wibcCGvPy=PjevdSzEtzrYPWJnLo+t=S3zy3AQ5+NNeEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/20 2:03 PM, Linus Torvalds wrote:
> On Fri, Apr 24, 2020 at 11:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Single fixup for a change that went into -rc2, please pull.
> 
> I'd like to point out that this was exactly the code that I pointed to
> as being badly written and hard to understand:
> 
>  "That whole apoll thing is disgusting.
> 
>   I cannot convince myself it is right. How do you convince yourself?"
> 
> And you at that time claimed it was all fairly simple and clear.

I know, and I was pretty much expecting you to bring that up...

> I repeat: that whole apoll thing is disgusting. It wasn't simple and
> clear and only a few obvious cases that had issues.
> 
> In fact, now it's even less clear, with an even more complicated check
> for when to restore things,
> 
> I think that whole approach needs re-thinking. Is the union really worth it?
> 
> Can you guarantee and explain why _this_ time it is right?

To be fair, this place is really the only place that is a bit tricky, since
it's where we restore things. The rest is clear, since we know exactly
which poll (&req->poll, or req->apoll) that is being used. The fix from
last week ended up somewhat conflicting with the cancellation part, which
is part of the reason it slipped.

But I do hear your point. If we run into anything like this again, I'll
bite the bullet and un-unionize this thing. I just care pretty deeply
about keeping the footprint of a single io_uring request down to as
little as we can, as we can be doing millions of these (per core). We've
still got some room in terms of not spilling into the next cacheline.

-- 
Jens Axboe

